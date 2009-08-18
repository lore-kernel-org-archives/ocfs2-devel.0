From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 18 Aug 2009 14:19:09 +0800
Subject: [Ocfs2-devel] [PATCH 08/41] ocfs2: Basic tree root operation.
In-Reply-To: <4A8A47DF.8020707@oracle.com>
References: <4A8A47DF.8020707@oracle.com>
Message-ID: <1250576382-27080-8-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Add basic refcount tree root operation.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/journal.h      |   14 ++
 fs/ocfs2/refcounttree.c |  343 ++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 351 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index b2dc125..bd88c8b 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -490,6 +490,20 @@ static inline int ocfs2_calc_dxi_expand_credits(struct super_block *sb)
 	return credits;
 }
 
+/* inode update, new refcount block and its allocation credits. */
+#define OCFS2_REFCOUNT_TREE_CREATE_CREDITS (OCFS2_INODE_UPDATE_CREDITS + 1 \
+					    + OCFS2_SUBALLOC_ALLOC)
+
+/* inode and the refcount block update. */
+#define OCFS2_REFCOUNT_TREE_SET_CREDITS (OCFS2_INODE_UPDATE_CREDITS + 1)
+
+/*
+ * inode and the refcount block update.
+ * It doesn't include the credits for sub alloc change.
+ * So if we need to free the bit, OCFS2_SUBALLOC_FREE needs to be added.
+ */
+#define OCFS2_REFCOUNT_TREE_REMOVE_CREDITS (OCFS2_INODE_UPDATE_CREDITS + 1)
+
 /*
  * Please note that the caller must make sure that root_el is the root
  * of extent tree. So for an inode, it should be &fe->id2.i_list. Otherwise
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index b6d356b..650347b 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -27,6 +27,7 @@
 #include "buffer_head_io.h"
 #include "blockcheck.h"
 #include "refcounttree.h"
+#include "sysfile.h"
 #include "dlmglue.h"
 
 static inline struct ocfs2_refcount_tree *
@@ -272,6 +273,22 @@ static inline void ocfs2_init_refcount_tree_lock(struct ocfs2_super *osb,
 				     rf_blkno, generation);
 }
 
+static struct ocfs2_refcount_tree*
+ocfs2_allocate_refcount_tree(struct ocfs2_super *osb, u64 rf_blkno)
+{
+	struct ocfs2_refcount_tree *new;
+
+	new = kzalloc(sizeof(struct ocfs2_refcount_tree), GFP_NOFS);
+	if (!new)
+		return NULL;
+
+	new->rf_blkno = rf_blkno;
+	kref_init(&new->rf_getcnt);
+	ocfs2_init_refcount_tree_ci(new, osb->sb);
+
+	return new;
+}
+
 static int ocfs2_get_refcount_tree(struct ocfs2_super *osb, u64 rf_blkno,
 				   struct ocfs2_refcount_tree **ret_tree)
 {
@@ -291,16 +308,12 @@ static int ocfs2_get_refcount_tree(struct ocfs2_super *osb, u64 rf_blkno,
 
 	spin_unlock(&osb->osb_lock);
 
-	new = kzalloc(sizeof(struct ocfs2_refcount_tree), GFP_NOFS);
+	new = ocfs2_allocate_refcount_tree(osb, rf_blkno);
 	if (!new) {
 		ret = -ENOMEM;
+		mlog_errno(ret);
 		return ret;
 	}
-
-	new->rf_blkno = rf_blkno;
-	kref_init(&new->rf_getcnt);
-	ocfs2_init_refcount_tree_ci(new, osb->sb);
-
 	/*
 	 * We need the generation to create the refcount tree lock and since
 	 * it isn't changed during the tree modification, we are safe here to
@@ -515,3 +528,321 @@ void ocfs2_purge_refcount_tree(struct ocfs2_super *osb)
 		ocfs2_free_refcount_tree(tree);
 	}
 }
+
+/*
+ * Create a refcount tree for an inode.
+ * We take for granted that the inode is already locked.
+ */
+static int ocfs2_create_refcount_tree(struct inode *inode,
+				      struct buffer_head *di_bh)
+{
+	int ret;
+	handle_t *handle = NULL;
+	struct ocfs2_alloc_context *meta_ac = NULL;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct buffer_head *new_bh = NULL;
+	struct ocfs2_refcount_block *rb;
+	struct ocfs2_refcount_tree *new_tree = NULL, *tree = NULL;
+	u16 suballoc_bit_start;
+	u32 num_got;
+	u64 first_blkno;
+
+	BUG_ON(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL);
+
+	mlog(0, "create tree for inode %lu\n", inode->i_ino);
+
+	ret = ocfs2_reserve_new_metadata_blocks(osb, 1, &meta_ac);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	handle = ocfs2_start_trans(osb, OCFS2_REFCOUNT_TREE_CREATE_CREDITS);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	ret = ocfs2_claim_metadata(osb, handle, meta_ac, 1,
+				   &suballoc_bit_start, &num_got,
+				   &first_blkno);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	new_tree = ocfs2_allocate_refcount_tree(osb, first_blkno);
+	if (!new_tree) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	new_bh = sb_getblk(inode->i_sb, first_blkno);
+	ocfs2_set_new_buffer_uptodate(&new_tree->rf_ci, new_bh);
+
+	ret = ocfs2_journal_access_rb(handle, &new_tree->rf_ci, new_bh,
+				      OCFS2_JOURNAL_ACCESS_CREATE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	/* Initialize ocfs2_refcount_block. */
+	rb = (struct ocfs2_refcount_block *)new_bh->b_data;
+	memset(rb, 0, inode->i_sb->s_blocksize);
+	strcpy((void *)rb, OCFS2_REFCOUNT_BLOCK_SIGNATURE);
+	rb->rf_suballoc_slot = cpu_to_le16(osb->slot_num);
+	rb->rf_suballoc_bit = cpu_to_le16(suballoc_bit_start);
+	rb->rf_fs_generation = cpu_to_le32(osb->fs_generation);
+	rb->rf_blkno = cpu_to_le64(first_blkno);
+	rb->rf_count = cpu_to_le32(1);
+	rb->rf_records.rl_count =
+			cpu_to_le16(ocfs2_refcount_recs_per_rb(osb->sb));
+	spin_lock(&osb->osb_lock);
+	rb->rf_generation = osb->s_next_generation++;
+	spin_unlock(&osb->osb_lock);
+
+	ocfs2_journal_dirty(handle, new_bh);
+
+	spin_lock(&oi->ip_lock);
+	oi->ip_dyn_features |= OCFS2_HAS_REFCOUNT_FL;
+	di->i_dyn_features = cpu_to_le16(oi->ip_dyn_features);
+	di->i_refcount_loc = cpu_to_le64(first_blkno);
+	spin_unlock(&oi->ip_lock);
+
+	mlog(0, "created tree for inode %lu, refblock %llu\n",
+	     inode->i_ino, (unsigned long long)first_blkno);
+
+	ocfs2_journal_dirty(handle, di_bh);
+
+	/*
+	 * We have to init the tree lock here since it will use
+	 * the generation number to create it.
+	 */
+	new_tree->rf_generation = le32_to_cpu(rb->rf_generation);
+	ocfs2_init_refcount_tree_lock(osb, new_tree, first_blkno,
+				      new_tree->rf_generation);
+
+	spin_lock(&osb->osb_lock);
+	tree = ocfs2_find_refcount_tree(osb, first_blkno);
+
+	/*
+	 * The tree has been deleted and recreated. So remove the old
+	 * tree in this node.
+	 */
+	BUG_ON(tree && tree->rf_generation == new_tree->rf_generation);
+	if (tree)
+		ocfs2_erase_refcount_tree_from_list_no_lock(osb, tree);
+	ocfs2_insert_refcount_tree(osb, new_tree);
+	spin_unlock(&osb->osb_lock);
+	new_tree = NULL;
+	if (tree)
+		ocfs2_refcount_tree_put(tree);
+
+out_commit:
+	ocfs2_commit_trans(osb, handle);
+
+out:
+	if (new_tree) {
+		ocfs2_metadata_cache_exit(&new_tree->rf_ci);
+		kfree(new_tree);
+	}
+
+	brelse(new_bh);
+	if (meta_ac)
+		ocfs2_free_alloc_context(meta_ac);
+
+	return ret;
+}
+
+static int ocfs2_set_refcount_tree(struct inode *inode,
+				   struct buffer_head *di_bh,
+				   u64 refcount_loc)
+{
+	int ret;
+	handle_t *handle = NULL;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct buffer_head *ref_root_bh = NULL;
+	struct ocfs2_refcount_block *rb;
+	struct ocfs2_refcount_tree *ref_tree;
+
+	BUG_ON(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL);
+
+	ret = ocfs2_lock_refcount_tree(osb, refcount_loc, 1,
+				       &ref_tree, &ref_root_bh);
+	if (ret) {
+		mlog_errno(ret);
+		return ret;
+	}
+
+	handle = ocfs2_start_trans(osb, OCFS2_REFCOUNT_TREE_SET_CREDITS);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	ret = ocfs2_journal_access_rb(handle, &ref_tree->rf_ci, ref_root_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	rb = (struct ocfs2_refcount_block *)ref_root_bh->b_data;
+	le32_add_cpu(&rb->rf_count, 1);
+
+	ocfs2_journal_dirty(handle, ref_root_bh);
+
+	spin_lock(&oi->ip_lock);
+	oi->ip_dyn_features |= OCFS2_HAS_REFCOUNT_FL;
+	di->i_dyn_features = cpu_to_le16(oi->ip_dyn_features);
+	di->i_refcount_loc = cpu_to_le64(refcount_loc);
+	spin_unlock(&oi->ip_lock);
+	ocfs2_journal_dirty(handle, di_bh);
+
+out_commit:
+	ocfs2_commit_trans(osb, handle);
+out:
+	ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
+	brelse(ref_root_bh);
+
+	return ret;
+}
+
+int ocfs2_remove_refcount_tree(struct inode *inode, struct buffer_head *di_bh)
+{
+	int ret, delete_tree = 0;
+	handle_t *handle = NULL;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_refcount_block *rb;
+	struct inode *alloc_inode = NULL;
+	struct buffer_head *alloc_bh = NULL;
+	struct buffer_head *blk_bh = NULL;
+	struct ocfs2_refcount_tree *ref_tree;
+	int credits = OCFS2_REFCOUNT_TREE_REMOVE_CREDITS;
+	u64 blk = 0, bg_blkno = 0, ref_blkno = le64_to_cpu(di->i_refcount_loc);
+	u16 bit = 0;
+
+	if (!(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL))
+		return 0;
+
+	BUG_ON(!ref_blkno);
+	ret = ocfs2_lock_refcount_tree(osb, ref_blkno, 1, &ref_tree, &blk_bh);
+	if (ret) {
+		mlog_errno(ret);
+		return ret;
+	}
+
+	rb = (struct ocfs2_refcount_block *)blk_bh->b_data;
+
+	/*
+	 * If we are the last user, we need to free the block.
+	 * So lock the allocator ahead.
+	 */
+	if (le32_to_cpu(rb->rf_count) == 1) {
+		blk = le64_to_cpu(rb->rf_blkno);
+		bit = le16_to_cpu(rb->rf_suballoc_bit);
+		bg_blkno = ocfs2_which_suballoc_group(blk, bit);
+
+		alloc_inode = ocfs2_get_system_file_inode(osb,
+					EXTENT_ALLOC_SYSTEM_INODE,
+					le16_to_cpu(rb->rf_suballoc_slot));
+		if (!alloc_inode) {
+			ret = -ENOMEM;
+			mlog_errno(ret);
+			goto out;
+		}
+		mutex_lock(&alloc_inode->i_mutex);
+
+		ret = ocfs2_inode_lock(alloc_inode, &alloc_bh, 1);
+		if (ret) {
+			mlog_errno(ret);
+			goto out_mutex;
+		}
+
+		credits += OCFS2_SUBALLOC_FREE;
+	}
+
+	handle = ocfs2_start_trans(osb, credits);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		mlog_errno(ret);
+		goto out_unlock;
+	}
+
+	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	ret = ocfs2_journal_access_rb(handle, &ref_tree->rf_ci, blk_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	spin_lock(&oi->ip_lock);
+	oi->ip_dyn_features &= ~OCFS2_HAS_REFCOUNT_FL;
+	di->i_dyn_features = cpu_to_le16(oi->ip_dyn_features);
+	di->i_refcount_loc = 0;
+	spin_unlock(&oi->ip_lock);
+	ocfs2_journal_dirty(handle, di_bh);
+
+	le32_add_cpu(&rb->rf_count , -1);
+	ocfs2_journal_dirty(handle, blk_bh);
+
+	if (!rb->rf_count) {
+		delete_tree = 1;
+		ocfs2_erase_refcount_tree_from_list(osb, ref_tree);
+		ret = ocfs2_free_suballoc_bits(handle, alloc_inode,
+					       alloc_bh, bit, bg_blkno, 1);
+		if (ret)
+			mlog_errno(ret);
+	}
+
+out_commit:
+	ocfs2_commit_trans(osb, handle);
+out_unlock:
+	if (alloc_inode) {
+		ocfs2_inode_unlock(alloc_inode, 1);
+		brelse(alloc_bh);
+	}
+out_mutex:
+	if (alloc_inode) {
+		mutex_unlock(&alloc_inode->i_mutex);
+		iput(alloc_inode);
+	}
+out:
+	ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
+	if (delete_tree)
+		ocfs2_refcount_tree_put(ref_tree);
+	brelse(blk_bh);
+
+	return ret;
+}
-- 
1.6.2.rc2.16.gf474c
