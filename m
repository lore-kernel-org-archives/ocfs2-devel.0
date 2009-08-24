From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 24 Aug 2009 23:06:39 +0800
Subject: [Ocfs2-devel] [PATCH 19/41] ocfs2: Integrate CoW in file write.
In-Reply-To: <20090821234210.GH4330@mail.oracle.com>
References: <20090821234210.GH4330@mail.oracle.com>
Message-ID: <1251126399-8296-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel,
	This patch resolve the problem of directIO by CoW in
ocfs2_prepare_inode_for_write. please review.

Regards,
Tao

When we use mmap, we CoW the refcountd clusters in
ocfs2_write_begin_nolock. While for normal file
io(including directio), we do CoW in
ocfs2_prepare_inode_for_write.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/aops.c |   15 ++++++++++
 fs/ocfs2/file.c |   80 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 94 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 65e17b3..9329f8c 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -44,6 +44,7 @@
 #include "suballoc.h"
 #include "super.h"
 #include "symlink.h"
+#include "refcounttree.h"
 
 #include "buffer_head_io.h"
 
@@ -590,6 +591,8 @@ static int ocfs2_direct_IO_get_blocks(struct inode *inode, sector_t iblock,
 		goto bail;
 	}
 
+	/* We should already CoW the refcounted extent. */
+	BUG_ON(ext_flags & OCFS2_EXT_REFCOUNTED);
 	/*
 	 * get_more_blocks() expects us to describe a hole by clearing
 	 * the mapped bit on bh_result().
@@ -1449,6 +1452,9 @@ static int ocfs2_populate_write_desc(struct inode *inode,
 				goto out;
 			}
 
+			/* We should already CoW the refcountd extent. */
+			BUG_ON(ext_flags & OCFS2_EXT_REFCOUNTED);
+
 			/*
 			 * Assume worst case - that we're writing in
 			 * the middle of the extent.
@@ -1700,6 +1706,15 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 		goto out;
 	}
 
+	if (ocfs2_refcount_tree(OCFS2_SB(inode->i_sb))) {
+		ret = ocfs2_refcount_cow(inode, di_bh,
+					 wc->w_cpos, wc->w_clen);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+	}
+
 	ret = ocfs2_populate_write_desc(inode, wc, &clusters_to_alloc,
 					&extents_to_split);
 	if (ret) {
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 4921b4e..46c256d 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -59,6 +59,7 @@
 #include "xattr.h"
 #include "acl.h"
 #include "quota.h"
+#include "refcounttree.h"
 
 #include "buffer_head_io.h"
 
@@ -1656,6 +1657,66 @@ static long ocfs2_fallocate(struct inode *inode, int mode, loff_t offset,
 					 OCFS2_IOC_RESVSP64, &sr, change_size);
 }
 
+static int ocfs2_check_range_for_refcount(struct inode *inode, loff_t pos,
+					  size_t count)
+{
+	int ret = 0;
+	unsigned int extent_flags;
+	u32 cpos, clusters, extent_len, phys_cpos;
+	struct super_block *sb = inode->i_sb;
+
+	cpos = pos >> OCFS2_SB(sb)->s_clustersize_bits;
+	clusters = ocfs2_clusters_for_bytes(sb, pos + count) - cpos;
+
+	while (clusters) {
+		ret = ocfs2_get_clusters(inode, cpos, &phys_cpos, &extent_len,
+					 &extent_flags);
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		if (phys_cpos && (extent_flags & OCFS2_EXT_REFCOUNTED)) {
+			ret = 1;
+			break;
+		}
+
+		if (extent_len > clusters)
+			extent_len = clusters;
+
+		clusters -= extent_len;
+		cpos += extent_len;
+	}
+out:
+	return ret;
+}
+
+static int ocfs2_prepare_inode_for_refcount(struct inode *inode,
+					    loff_t pos, size_t count,
+					    int *meta_level)
+{
+	int ret;
+	struct buffer_head *di_bh = NULL;
+	u32 cpos = pos >> OCFS2_SB(inode->i_sb)->s_clustersize_bits;
+	u32 clusters =
+		ocfs2_clusters_for_bytes(inode->i_sb, pos + count) - cpos;
+
+	ret = ocfs2_inode_lock(inode, &di_bh, 1);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	*meta_level = 1;
+
+	ret = ocfs2_refcount_cow(inode, di_bh, cpos, clusters);
+	if (ret)
+		mlog_errno(ret);
+out:
+	brelse(di_bh);
+	return ret;
+}
+
 static int ocfs2_prepare_inode_for_write(struct dentry *dentry,
 					 loff_t *ppos,
 					 size_t count,
@@ -1712,6 +1773,22 @@ static int ocfs2_prepare_inode_for_write(struct dentry *dentry,
 
 		end = saved_pos + count;
 
+		ret = ocfs2_check_range_for_refcount(inode, saved_pos, count);
+		if (ret == 1) {
+			ocfs2_inode_unlock(inode, meta_level);
+			meta_level = -1;
+
+			ret = ocfs2_prepare_inode_for_refcount(inode,
+							       saved_pos,
+							       count,
+							       &meta_level);
+		}
+
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto out_unlock;
+		}
+
 		/*
 		 * Skip the O_DIRECT checks if we don't need
 		 * them.
@@ -1758,7 +1835,8 @@ static int ocfs2_prepare_inode_for_write(struct dentry *dentry,
 		*ppos = saved_pos;
 
 out_unlock:
-	ocfs2_inode_unlock(inode, meta_level);
+	if (meta_level >= 0)
+		ocfs2_inode_unlock(inode, meta_level);
 
 out:
 	return ret;
-- 
1.6.2.rc2.16.gf474c
