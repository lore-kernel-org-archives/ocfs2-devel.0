From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 18 Aug 2009 14:19:21 +0800
Subject: [Ocfs2-devel] [PATCH 20/41] ocfs2: CoW a reflinked cluster when it
	is truncated.
In-Reply-To: <4A8A47DF.8020707@oracle.com>
References: <4A8A47DF.8020707@oracle.com>
Message-ID: <1250576382-27080-20-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When we truncate a file to a specific size which resides in a reflinked
cluster, we need to CoW it since ocfs2_zero_range_for_truncate will
zero the space after the size(just another type of write).

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/aops.c         |    2 +-
 fs/ocfs2/file.c         |   45 +++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/refcounttree.c |   12 ++++++++++--
 fs/ocfs2/refcounttree.h |    2 +-
 4 files changed, 57 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 02244bb..c94febc 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1731,7 +1731,7 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 		cow_len = wc->w_clen - (refcounted_cpos - wc->w_cpos);
 
 		ret = ocfs2_refcount_cow(inode, di_bh,
-					 refcounted_cpos, cow_len);
+					 refcounted_cpos, cow_len, UINT_MAX);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 4921b4e..1254d72 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -59,6 +59,7 @@
 #include "xattr.h"
 #include "acl.h"
 #include "quota.h"
+#include "refcounttree.h"
 
 #include "buffer_head_io.h"
 
@@ -334,6 +335,39 @@ out:
 	return ret;
 }
 
+static int ocfs2_cow_file_pos(struct inode *inode,
+			      struct buffer_head *fe_bh,
+			      u64 offset)
+{
+	int status;
+	u32 phys, cpos = offset >> OCFS2_SB(inode->i_sb)->s_clustersize_bits;
+	unsigned int num_clusters = 0;
+	unsigned int ext_flags = 0;
+
+	/*
+	 * If the new offset is aligned to the range of the cluster, there is
+	 * no space for ocfs2_zero_range_for_truncate to fill, so no need to
+	 * CoW either.
+	 */
+	if ((offset & (OCFS2_SB(inode->i_sb)->s_clustersize - 1)) == 0)
+		return 0;
+
+	status = ocfs2_get_clusters(inode, cpos, &phys,
+				    &num_clusters, &ext_flags);
+	if (status) {
+		mlog_errno(status);
+		goto out;
+	}
+
+	if (!(ext_flags & OCFS2_EXT_REFCOUNTED))
+		goto out;
+
+	return ocfs2_refcount_cow(inode, fe_bh, cpos, 1, cpos+1);
+
+out:
+	return status;
+}
+
 static int ocfs2_orphan_for_truncate(struct ocfs2_super *osb,
 				     struct inode *inode,
 				     struct buffer_head *fe_bh,
@@ -346,6 +380,17 @@ static int ocfs2_orphan_for_truncate(struct ocfs2_super *osb,
 
 	mlog_entry_void();
 
+	/*
+	 * We need to CoW the cluster contains the offset if it is reflinked
+	 * since we will call ocfs2_zero_range_for_truncate later which will
+	 * write "0" from offset to the end of the cluster.
+	 */
+	status = ocfs2_cow_file_pos(inode, fe_bh, new_i_size);
+	if (status) {
+		mlog_errno(status);
+		return status;
+	}
+
 	/* TODO: This needs to actually orphan the inode in this
 	 * transaction. */
 
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index a3aeaea..0231f17 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -2435,6 +2435,7 @@ out:
  *
  * cpos is vitual start cluster position we want to do CoW in a
  * file and write_len is the cluster length.
+ * max_cpos is the place where we want to stop CoW intentionally.
  *
  * Normal we will start CoW from the beginning of extent record cotaining cpos.
  * And We will try to Cow as much clusters as we can until we reach
@@ -2445,6 +2446,7 @@ static int ocfs2_refcount_cal_cow_clusters(struct inode *inode,
 					   struct buffer_head *di_bh,
 					   u32 cpos,
 					   u32 write_len,
+					   u32 max_cpos,
 					   u32 *cow_start,
 					   u32 *cow_len)
 {
@@ -2512,6 +2514,10 @@ static int ocfs2_refcount_cal_cow_clusters(struct inode *inode,
 
 		leaf_clusters = le16_to_cpu(rec->e_leaf_clusters);
 		rec_end = le32_to_cpu(rec->e_cpos) + leaf_clusters;
+		if (rec_end > max_cpos) {
+			rec_end = max_cpos;
+			leaf_clusters = rec_end - le32_to_cpu(rec->e_cpos);
+		}
 
 		if (*cow_len + leaf_clusters >= max_clusters) {
 			if (*cow_len == 0) {
@@ -3090,7 +3096,7 @@ static int ocfs2_replace_cow(struct inode *inode,
 
 int ocfs2_refcount_cow(struct inode *inode,
 		       struct buffer_head *di_bh,
-		       u32 cpos, u32 write_len)
+		       u32 cpos, u32 write_len, u32 max_cpos)
 {
 	int ret;
 	u32 cow_start = 0, cow_len = 0;
@@ -3102,12 +3108,14 @@ int ocfs2_refcount_cow(struct inode *inode,
 
 	BUG_ON(!(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL));
 
-	ret = ocfs2_refcount_cal_cow_clusters(inode, di_bh, cpos, write_len,
+	ret = ocfs2_refcount_cal_cow_clusters(inode, di_bh,
+					      cpos, write_len, max_cpos,
 					      &cow_start, &cow_len);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
 	}
+
 	mlog(0, "CoW inode %lu, cpos %u, write_len %u, cow_start %u, "
 	     "cow_len %u\n", inode->i_ino,
 	     cpos, write_len, cow_start, cow_len);
diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
index bc40af1..5539211 100644
--- a/fs/ocfs2/refcounttree.h
+++ b/fs/ocfs2/refcounttree.h
@@ -53,5 +53,5 @@ int ocfs2_prepare_refcount_change_for_del(struct inode *inode,
 					  int *credits,
 					  struct ocfs2_alloc_context **meta_ac);
 int ocfs2_refcount_cow(struct inode *inode, struct buffer_head *di_bh,
-		       u32 cpos, u32 write_len);
+		       u32 cpos, u32 write_len, u32 max_cpos);
 #endif /* OCFS2_REFCOUNTTREE_H */
-- 
1.6.2.rc2.16.gf474c
