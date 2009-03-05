From: Tiger Yang <tiger.yang@oracle.com>
Date: Thu,  5 Mar 2009 11:06:15 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: tweak to get the maximum inline
	data size with xattr
In-Reply-To: <49AF40A9.8050601@oracle.com>
References: <49AF40A9.8050601@oracle.com>
Message-ID: <1236222375-10467-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Replace max_inline_data with max_inline_data_with_xattr
to ensure it correct when xattr inlined.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/aops.c     |    7 +++++--
 fs/ocfs2/namei.c    |    3 ++-
 fs/ocfs2/ocfs2_fs.h |    6 ------
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index a067a6c..8e1709a 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -227,7 +227,7 @@ int ocfs2_read_inline_data(struct inode *inode, struct page *page,
 	size = i_size_read(inode);
 
 	if (size > PAGE_CACHE_SIZE ||
-	    size > ocfs2_max_inline_data(inode->i_sb)) {
+	    size > ocfs2_max_inline_data_with_xattr(inode->i_sb, di)) {
 		ocfs2_error(inode->i_sb,
 			    "Inode %llu has with inline data has bad size: %Lu",
 			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
@@ -1555,6 +1555,7 @@ static int ocfs2_try_to_write_inline_data(struct address_space *mapping,
 	int ret, written = 0;
 	loff_t end = pos + len;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct ocfs2_dinode *di = NULL;
 
 	mlog(0, "Inode %llu, write of %u bytes at off %llu. features: 0x%x\n",
 	     (unsigned long long)oi->ip_blkno, len, (unsigned long long)pos,
@@ -1587,7 +1588,9 @@ static int ocfs2_try_to_write_inline_data(struct address_space *mapping,
 	/*
 	 * Check whether the write can fit.
 	 */
-	if (mmap_page || end > ocfs2_max_inline_data(inode->i_sb))
+	di = (struct ocfs2_dinode *)wc->w_di_bh->b_data;
+	if (mmap_page ||
+	    end > ocfs2_max_inline_data_with_xattr(inode->i_sb, di))
 		return 0;
 
 do_inline_write:
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 084aba8..4b11762 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -532,7 +532,8 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 
 		fe->i_dyn_features = cpu_to_le16(feat | OCFS2_INLINE_DATA_FL);
 
-		fe->id2.i_data.id_count = cpu_to_le16(ocfs2_max_inline_data(osb->sb));
+		fe->id2.i_data.id_count = cpu_to_le16(
+				ocfs2_max_inline_data_with_xattr(osb->sb, fe));
 	} else {
 		fel = &fe->id2.i_list;
 		fel->l_tree_depth = 0;
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index c7ae45a..2332ef7 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -1070,12 +1070,6 @@ static inline int ocfs2_fast_symlink_chars(struct super_block *sb)
 		 offsetof(struct ocfs2_dinode, id2.i_symlink);
 }
 
-static inline int ocfs2_max_inline_data(struct super_block *sb)
-{
-	return sb->s_blocksize -
-		offsetof(struct ocfs2_dinode, id2.i_data.id_data);
-}
-
 static inline int ocfs2_max_inline_data_with_xattr(struct super_block *sb,
 						   struct ocfs2_dinode *di)
 {
-- 
1.5.4.1
