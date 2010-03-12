From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 11 Mar 2010 18:31:09 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Clear undo bits when local alloc is
	freed
Message-ID: <20100312023109.GS11402@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When the local alloc file changes windows, unused bits are freed back to the
global bitmap. By defnition, those bits can not be in use by any file. Also,
the local alloc will never have been able to allocate those bits if they
were part of a previous truncate. Therefore it makes sense that we should
clear unused local alloc bits in the undo buffer so that they can be used
immediatly.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/alloc.c        |    4 ++--
 fs/ocfs2/dir.c          |    2 +-
 fs/ocfs2/localalloc.c   |    2 +-
 fs/ocfs2/refcounttree.c |    2 +-
 fs/ocfs2/suballoc.c     |   44 ++++++++++++++++++++++++++++----------------
 fs/ocfs2/suballoc.h     |    5 +++--
 fs/ocfs2/xattr.c        |    2 +-
 7 files changed, 37 insertions(+), 24 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index d17bdc7..c9608a5 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -5921,7 +5921,7 @@ static int ocfs2_replay_truncate_records(struct ocfs2_super *osb,
 
 			status = ocfs2_free_clusters(handle, data_alloc_inode,
 						     data_alloc_bh, start_blk,
-						     num_clusters);
+						     num_clusters, 0);
 			if (status < 0) {
 				mlog_errno(status);
 				goto bail;
@@ -6349,7 +6349,7 @@ static int ocfs2_free_cached_blocks(struct ocfs2_super *osb,
 		     head->free_bit, (unsigned long long)head->free_blk);
 
 		ret = ocfs2_free_suballoc_bits(handle, inode, di_bh,
-					       head->free_bit, bg_blkno, 1);
+					       head->free_bit, bg_blkno, 1, 0);
 		if (ret) {
 			mlog_errno(ret);
 			goto out_journal;
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 28c3ec2..54f711a 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -4497,7 +4497,7 @@ static int ocfs2_dx_dir_remove_index(struct inode *dir,
 	bit = le16_to_cpu(dx_root->dr_suballoc_bit);
 	bg_blkno = ocfs2_which_suballoc_group(blk, bit);
 	ret = ocfs2_free_suballoc_bits(handle, dx_alloc_inode, dx_alloc_bh,
-				       bit, bg_blkno, 1);
+				       bit, bg_blkno, 1, 0);
 	if (ret)
 		mlog_errno(ret);
 
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 955a60b..0347544 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -874,7 +874,7 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
 			     ocfs2_blocks_to_clusters(osb->sb, blkno), count);
 
 			status = ocfs2_free_clusters(handle, main_bm_inode,
-						     main_bm_bh, blkno, count);
+						     main_bm_bh, blkno, count, 1);
 			if (status < 0) {
 				mlog_errno(status);
 				goto bail;
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 8ae65c9..4507207 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -847,7 +847,7 @@ int ocfs2_remove_refcount_tree(struct inode *inode, struct buffer_head *di_bh)
 		delete_tree = 1;
 		ocfs2_erase_refcount_tree_from_list(osb, ref_tree);
 		ret = ocfs2_free_suballoc_bits(handle, alloc_inode,
-					       alloc_bh, bit, bg_blkno, 1);
+					       alloc_bh, bit, bg_blkno, 1, 0);
 		if (ret)
 			mlog_errno(ret);
 	}
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index b772da7..24c5a18 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -100,7 +100,8 @@ static inline int ocfs2_block_group_clear_bits(handle_t *handle,
 					       struct ocfs2_group_desc *bg,
 					       struct buffer_head *group_bh,
 					       unsigned int bit_off,
-					       unsigned int num_bits);
+					       unsigned int num_bits,
+					       int clear_undo);
 
 static int ocfs2_relink_block_group(handle_t *handle,
 				    struct inode *alloc_inode,
@@ -1902,12 +1903,22 @@ int ocfs2_claim_clusters(struct ocfs2_super *osb,
 				      bits_wanted, cluster_start, num_clusters);
 }
 
+static void ocfs2_cluster_bit_undo(unsigned int bit, unsigned long *bmap,
+				   int set)
+{
+	if (set)
+		ocfs2_set_bit(bit, bmap);
+	else
+		ocfs2_clear_bit(bit, bmap);
+}
+
 static inline int ocfs2_block_group_clear_bits(handle_t *handle,
 					       struct inode *alloc_inode,
 					       struct ocfs2_group_desc *bg,
 					       struct buffer_head *group_bh,
 					       unsigned int bit_off,
-					       unsigned int num_bits)
+					       unsigned int num_bits,
+					       int clear_undo)
 {
 	int status;
 	unsigned int tmp;
@@ -1923,8 +1934,10 @@ static inline int ocfs2_block_group_clear_bits(handle_t *handle,
 
 	mlog(0, "off = %u, num = %u\n", bit_off, num_bits);
 
-	if (ocfs2_is_cluster_bitmap(alloc_inode))
+	if (ocfs2_is_cluster_bitmap(alloc_inode)) {
 		journal_type = OCFS2_JOURNAL_ACCESS_UNDO;
+		cluster_bitmap = 1;
+	}
 
 	status = ocfs2_journal_access_gd(handle, INODE_CACHE(alloc_inode),
 					 group_bh, journal_type);
@@ -1933,9 +1946,6 @@ static inline int ocfs2_block_group_clear_bits(handle_t *handle,
 		goto bail;
 	}
 
-	if (ocfs2_is_cluster_bitmap(alloc_inode))
-		cluster_bitmap = 1;
-
 	if (cluster_bitmap) {
 		jbd_lock_bh_state(group_bh);
 		undo_bg = (struct ocfs2_group_desc *)
@@ -1948,8 +1958,9 @@ static inline int ocfs2_block_group_clear_bits(handle_t *handle,
 		ocfs2_clear_bit((bit_off + tmp),
 				(unsigned long *) bg->bg_bitmap);
 		if (cluster_bitmap)
-			ocfs2_set_bit(bit_off + tmp,
-				      (unsigned long *) undo_bg->bg_bitmap);
+			ocfs2_cluster_bit_undo(bit_off + tmp,
+					(unsigned long *) undo_bg->bg_bitmap,
+					!clear_undo);
 	}
 	le16_add_cpu(&bg->bg_free_bits_count, num_bits);
 
@@ -1971,7 +1982,7 @@ int ocfs2_free_suballoc_bits(handle_t *handle,
 			     struct buffer_head *alloc_bh,
 			     unsigned int start_bit,
 			     u64 bg_blkno,
-			     unsigned int count)
+			     unsigned int count, int la_data)
 {
 	int status = 0;
 	u32 tmp_used;
@@ -2006,7 +2017,7 @@ int ocfs2_free_suballoc_bits(handle_t *handle,
 
 	status = ocfs2_block_group_clear_bits(handle, alloc_inode,
 					      group, group_bh,
-					      start_bit, count);
+					      start_bit, count, la_data);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -2047,14 +2058,15 @@ int ocfs2_free_dinode(handle_t *handle,
 	u64 bg_blkno = ocfs2_which_suballoc_group(blk, bit);
 
 	return ocfs2_free_suballoc_bits(handle, inode_alloc_inode,
-					inode_alloc_bh, bit, bg_blkno, 1);
+					inode_alloc_bh, bit, bg_blkno, 1, 0);
 }
 
 int ocfs2_free_clusters(handle_t *handle,
-		       struct inode *bitmap_inode,
-		       struct buffer_head *bitmap_bh,
-		       u64 start_blk,
-		       unsigned int num_clusters)
+			struct inode *bitmap_inode,
+			struct buffer_head *bitmap_bh,
+			u64 start_blk,
+			unsigned int num_clusters,
+			int la_data)
 {
 	int status;
 	u16 bg_start_bit;
@@ -2083,7 +2095,7 @@ int ocfs2_free_clusters(handle_t *handle,
 
 	status = ocfs2_free_suballoc_bits(handle, bitmap_inode, bitmap_bh,
 					  bg_start_bit, bg_blkno,
-					  num_clusters);
+					  num_clusters, la_data);
 	if (status < 0) {
 		mlog_errno(status);
 		goto out;
diff --git a/fs/ocfs2/suballoc.h b/fs/ocfs2/suballoc.h
index a614a44..b910642 100644
--- a/fs/ocfs2/suballoc.h
+++ b/fs/ocfs2/suballoc.h
@@ -118,7 +118,7 @@ int ocfs2_free_suballoc_bits(handle_t *handle,
 			     struct buffer_head *alloc_bh,
 			     unsigned int start_bit,
 			     u64 bg_blkno,
-			     unsigned int count);
+			     unsigned int count, int la_data);
 int ocfs2_free_dinode(handle_t *handle,
 		      struct inode *inode_alloc_inode,
 		      struct buffer_head *inode_alloc_bh,
@@ -127,7 +127,8 @@ int ocfs2_free_clusters(handle_t *handle,
 			struct inode *bitmap_inode,
 			struct buffer_head *bitmap_bh,
 			u64 start_blk,
-			unsigned int num_clusters);
+			unsigned int num_clusters,
+			int la_data);
 
 static inline u64 ocfs2_which_suballoc_group(u64 block, unsigned int bit)
 {
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 8fc6fb0..0d00ce3 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1971,7 +1971,7 @@ static int ocfs2_xattr_free_block(struct inode *inode,
 	}
 
 	ret = ocfs2_free_suballoc_bits(handle, xb_alloc_inode, xb_alloc_bh,
-				       bit, bg_blkno, 1);
+				       bit, bg_blkno, 1, 0);
 	if (ret < 0)
 		mlog_errno(ret);
 
-- 
1.6.4.2
