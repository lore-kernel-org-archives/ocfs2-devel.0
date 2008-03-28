From: Tao Ma <tao.ma@oracle.com>
Date: Fri Mar 28 01:46:59 2008
Subject: [Ocfs2-devel] [PATCH 3/3] Extent tree operation refactoring.take 1
Message-ID: <20080328084559.GA6352@dhcp-beijing-cdc-10-182-120-173.cn.oracle
	.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In the old extent tree operation, we take the hypothesis that we
are using the ocfs2_extent_list in ocfs2_dinode as the tree root.
As xattr will also use ocfs2_extent_list to store large values
xattr enty, we refactor the tree operation so that xattr can use
it directly.

The refactoring includes 3 steps:
1. Abstract the set/get of last_eb_blk since it may be stored
   in different location for dinode and xattr.
2. Add a new structure named ocfs2_extent_tree to indicate the
   extent tree the operation will work on.
3. Remove all the use of fe_bh and di, use root_bh and root_el in
   extent tree instead. So now all the fe_bh is replaced with
   et->root_bh, el with root_el accordingly.

Note: This patch hasn't touch the code of ocfs2_commit_truncate since
it isn't has been modified with the new tree operation.
So all the truncating code deem that the tree root is ocfs2_dinode.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c |  457 ++++++++++++++++++++++++++++++++++--------------------
 fs/ocfs2/alloc.h |   23 ++-
 fs/ocfs2/aops.c  |    3 +-
 fs/ocfs2/dir.c   |    7 +-
 fs/ocfs2/file.c  |   10 +-
 5 files changed, 317 insertions(+), 183 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 540ab70..1dcc839 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -49,6 +49,95 @@
 
 #include "buffer_head_io.h"
 
+struct ocfs2_extent_tree_operations {
+	void (*set_last_eb_blk) (void *et, u64 blkno);
+	u64 (*get_last_eb_blk) (void *et);
+};
+
+struct ocfs2_extent_tree {
+	enum ocfs2_extent_tree_type type;
+	struct ocfs2_extent_tree_operations *eops;
+	struct buffer_head *root_bh;
+	struct ocfs2_extent_list *root_el;
+};
+
+static void ocfs2_dinode_set_last_eb_blk(void *p, u64 blkno)
+{
+	struct ocfs2_extent_tree *et = (struct ocfs2_extent_tree *)p;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)et->root_bh->b_data;
+
+	BUG_ON(et->type != OCFS2_DINODE_EXTENT);
+	di->i_last_eb_blk = cpu_to_le64(blkno);
+}
+
+static u64 ocfs2_dinode_get_last_eb_blk(void *p)
+{
+	struct ocfs2_extent_tree *et = (struct ocfs2_extent_tree *)p;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)et->root_bh->b_data;
+
+	BUG_ON(et->type != OCFS2_DINODE_EXTENT);
+	return le64_to_cpu(di->i_last_eb_blk);
+}
+
+static struct ocfs2_extent_tree_operations ocfs2_dinode_et_ops = {
+	.set_last_eb_blk	= ocfs2_dinode_set_last_eb_blk,
+	.get_last_eb_blk	= ocfs2_dinode_get_last_eb_blk,
+};
+
+static struct ocfs2_extent_tree*
+	 ocfs2_new_extent_tree(struct buffer_head *bh,
+			       enum ocfs2_extent_tree_type et_type)
+{
+	struct ocfs2_extent_tree *et;
+
+	et = kzalloc(sizeof(*et), GFP_NOFS);
+	if (!et)
+		return NULL;
+
+	et->type = et_type;
+	get_bh(bh);
+	et->root_bh = bh;
+
+	/* current we only support dinode extent. */
+	BUG_ON(et->type != OCFS2_DINODE_EXTENT);
+	if (et_type == OCFS2_DINODE_EXTENT) {
+		et->root_el = &((struct ocfs2_dinode *)bh->b_data)->id2.i_list;
+		et->eops = &ocfs2_dinode_et_ops;
+	}
+
+	return et;
+}
+
+static void ocfs2_free_extent_tree(struct ocfs2_extent_tree *et)
+{
+	if (et) {
+		brelse(et->root_bh);
+		kfree(et);
+	}
+}
+
+static int ocfs2_extent_tree_sanity_check(struct inode *inode,
+					  struct ocfs2_extent_tree *et)
+{
+	int ret = 0;
+
+	/* current we only support dinode extent. */
+	BUG_ON(et->type != OCFS2_DINODE_EXTENT);
+	if (et->type == OCFS2_DINODE_EXTENT) {
+		struct ocfs2_dinode *di;
+
+		di = (struct ocfs2_dinode *)et->root_bh->b_data;
+		if (!OCFS2_IS_VALID_DINODE(di)) {
+			ret = -EIO;
+			ocfs2_error(inode->i_sb,
+				"Inode %llu has invalid path root",
+				(unsigned long long)OCFS2_I(inode)->ip_blkno);
+		}
+	}
+
+	return ret;
+}
+
 static void ocfs2_free_truncate_context(struct ocfs2_truncate_context *tc);
 static int ocfs2_cache_extent_block_free(struct ocfs2_cached_dealloc_ctxt *ctxt,
 					 struct ocfs2_extent_block *eb);
@@ -205,17 +294,6 @@ static struct ocfs2_path *ocfs2_new_path(struct buffer_head *root_bh,
 }
 
 /*
- * Allocate and initialize a new path based on a disk inode tree.
- */
-static struct ocfs2_path *ocfs2_new_inode_path(struct buffer_head *di_bh)
-{
-	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
-	struct ocfs2_extent_list *el = &di->id2.i_list;
-
-	return ocfs2_new_path(di_bh, el);
-}
-
-/*
  * Convenience function to journal all components in a path.
  */
 static int ocfs2_journal_access_path(struct inode *inode, handle_t *handle,
@@ -368,24 +446,35 @@ struct ocfs2_merge_ctxt {
  */
 int ocfs2_num_free_extents(struct ocfs2_super *osb,
 			   struct inode *inode,
-			   struct buffer_head *bh)
+			   struct buffer_head *root_bh,
+			   enum ocfs2_extent_tree_type type)
 {
 	int retval;
-	struct ocfs2_extent_list *el;
+	struct ocfs2_extent_list *el = NULL;
 	struct ocfs2_extent_block *eb;
 	struct buffer_head *eb_bh = NULL;
-	struct ocfs2_dinode *fe = (struct ocfs2_dinode *)bh->b_data;
+	u64 last_eb_blk = 0;
 
 	mlog_entry_void();
 
-	if (!OCFS2_IS_VALID_DINODE(fe)) {
-		OCFS2_RO_ON_INVALID_DINODE(inode->i_sb, fe);
-		retval = -EIO;
-		goto bail;
+	/* current we only support dinode extent. */
+	BUG_ON(type != OCFS2_DINODE_EXTENT);
+	if (type == OCFS2_DINODE_EXTENT) {
+		struct ocfs2_dinode *fe =
+				(struct ocfs2_dinode *)root_bh->b_data;
+		if (!OCFS2_IS_VALID_DINODE(fe)) {
+			OCFS2_RO_ON_INVALID_DINODE(inode->i_sb, fe);
+			retval = -EIO;
+			goto bail;
+		}
+
+		if (fe->i_last_eb_blk)
+			last_eb_blk = le64_to_cpu(fe->i_last_eb_blk);
+		el = &fe->id2.i_list;
 	}
 
-	if (fe->i_last_eb_blk) {
-		retval = ocfs2_read_block(osb, le64_to_cpu(fe->i_last_eb_blk),
+	if (last_eb_blk) {
+		retval = ocfs2_read_block(osb, last_eb_blk,
 					  &eb_bh, OCFS2_BH_CACHED, inode);
 		if (retval < 0) {
 			mlog_errno(retval);
@@ -393,8 +482,7 @@ int ocfs2_num_free_extents(struct ocfs2_super *osb,
 		}
 		eb = (struct ocfs2_extent_block *) eb_bh->b_data;
 		el = &eb->h_list;
-	} else
-		el = &fe->id2.i_list;
+	}
 
 	BUG_ON(el->l_tree_depth != 0);
 
@@ -532,7 +620,7 @@ static inline u32 ocfs2_sum_rightmost_rec(struct ocfs2_extent_list  *el)
 static int ocfs2_add_branch(struct ocfs2_super *osb,
 			    handle_t *handle,
 			    struct inode *inode,
-			    struct buffer_head *fe_bh,
+			    struct ocfs2_extent_tree *et,
 			    struct buffer_head *eb_bh,
 			    struct buffer_head **last_eb_bh,
 			    struct ocfs2_alloc_context *meta_ac)
@@ -541,7 +629,6 @@ static int ocfs2_add_branch(struct ocfs2_super *osb,
 	u64 next_blkno, new_last_eb_blk;
 	struct buffer_head *bh;
 	struct buffer_head **new_eb_bhs = NULL;
-	struct ocfs2_dinode *fe;
 	struct ocfs2_extent_block *eb;
 	struct ocfs2_extent_list  *eb_el;
 	struct ocfs2_extent_list  *el;
@@ -551,13 +638,11 @@ static int ocfs2_add_branch(struct ocfs2_super *osb,
 
 	BUG_ON(!last_eb_bh || !*last_eb_bh);
 
-	fe = (struct ocfs2_dinode *) fe_bh->b_data;
-
 	if (eb_bh) {
 		eb = (struct ocfs2_extent_block *) eb_bh->b_data;
 		el = &eb->h_list;
 	} else
-		el = &fe->id2.i_list;
+		el = et->root_el;
 
 	/* we never add a branch to a leaf. */
 	BUG_ON(!el->l_tree_depth);
@@ -647,7 +732,7 @@ static int ocfs2_add_branch(struct ocfs2_super *osb,
 		mlog_errno(status);
 		goto bail;
 	}
-	status = ocfs2_journal_access(handle, inode, fe_bh,
+	status = ocfs2_journal_access(handle, inode, et->root_bh,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
@@ -663,7 +748,7 @@ static int ocfs2_add_branch(struct ocfs2_super *osb,
 	}
 
 	/* Link the new branch into the rest of the tree (el will
-	 * either be on the fe, or the extent block passed in. */
+	 * either be on the root_bh, or the extent block passed in. */
 	i = le16_to_cpu(el->l_next_free_rec);
 	el->l_recs[i].e_blkno = cpu_to_le64(next_blkno);
 	el->l_recs[i].e_cpos = cpu_to_le32(new_cpos);
@@ -672,7 +757,7 @@ static int ocfs2_add_branch(struct ocfs2_super *osb,
 
 	/* fe needs a new last extent block pointer, as does the
 	 * next_leaf on the previously last-extent-block. */
-	fe->i_last_eb_blk = cpu_to_le64(new_last_eb_blk);
+	et->eops->set_last_eb_blk(et, new_last_eb_blk);
 
 	eb = (struct ocfs2_extent_block *) (*last_eb_bh)->b_data;
 	eb->h_next_leaf_blk = cpu_to_le64(new_last_eb_blk);
@@ -680,7 +765,7 @@ static int ocfs2_add_branch(struct ocfs2_super *osb,
 	status = ocfs2_journal_dirty(handle, *last_eb_bh);
 	if (status < 0)
 		mlog_errno(status);
-	status = ocfs2_journal_dirty(handle, fe_bh);
+	status = ocfs2_journal_dirty(handle, et->root_bh);
 	if (status < 0)
 		mlog_errno(status);
 	if (eb_bh) {
@@ -718,16 +803,15 @@ bail:
 static int ocfs2_shift_tree_depth(struct ocfs2_super *osb,
 				  handle_t *handle,
 				  struct inode *inode,
-				  struct buffer_head *fe_bh,
+				  struct ocfs2_extent_tree *et,
 				  struct ocfs2_alloc_context *meta_ac,
 				  struct buffer_head **ret_new_eb_bh)
 {
 	int status, i;
 	u32 new_clusters;
 	struct buffer_head *new_eb_bh = NULL;
-	struct ocfs2_dinode *fe;
 	struct ocfs2_extent_block *eb;
-	struct ocfs2_extent_list  *fe_el;
+	struct ocfs2_extent_list  *root_el;
 	struct ocfs2_extent_list  *eb_el;
 
 	mlog_entry_void();
@@ -747,8 +831,7 @@ static int ocfs2_shift_tree_depth(struct ocfs2_super *osb,
 	}
 
 	eb_el = &eb->h_list;
-	fe = (struct ocfs2_dinode *) fe_bh->b_data;
-	fe_el = &fe->id2.i_list;
+	root_el = et->root_el;
 
 	status = ocfs2_journal_access(handle, inode, new_eb_bh,
 				      OCFS2_JOURNAL_ACCESS_CREATE);
@@ -757,11 +840,11 @@ static int ocfs2_shift_tree_depth(struct ocfs2_super *osb,
 		goto bail;
 	}
 
-	/* copy the fe data into the new extent block */
-	eb_el->l_tree_depth = fe_el->l_tree_depth;
-	eb_el->l_next_free_rec = fe_el->l_next_free_rec;
-	for(i = 0; i < le16_to_cpu(fe_el->l_next_free_rec); i++)
-		eb_el->l_recs[i] = fe_el->l_recs[i];
+	/* copy the root extent list data into the new extent block */
+	eb_el->l_tree_depth = root_el->l_tree_depth;
+	eb_el->l_next_free_rec = root_el->l_next_free_rec;
+	for (i = 0; i < le16_to_cpu(root_el->l_next_free_rec); i++)
+		eb_el->l_recs[i] = root_el->l_recs[i];
 
 	status = ocfs2_journal_dirty(handle, new_eb_bh);
 	if (status < 0) {
@@ -769,7 +852,7 @@ static int ocfs2_shift_tree_depth(struct ocfs2_super *osb,
 		goto bail;
 	}
 
-	status = ocfs2_journal_access(handle, inode, fe_bh,
+	status = ocfs2_journal_access(handle, inode, et->root_bh,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
@@ -778,21 +861,21 @@ static int ocfs2_shift_tree_depth(struct ocfs2_super *osb,
 
 	new_clusters = ocfs2_sum_rightmost_rec(eb_el);
 
-	/* update fe now */
-	le16_add_cpu(&fe_el->l_tree_depth, 1);
-	fe_el->l_recs[0].e_cpos = 0;
-	fe_el->l_recs[0].e_blkno = eb->h_blkno;
-	fe_el->l_recs[0].e_int_clusters = cpu_to_le32(new_clusters);
-	for(i = 1; i < le16_to_cpu(fe_el->l_next_free_rec); i++)
-		memset(&fe_el->l_recs[i], 0, sizeof(struct ocfs2_extent_rec));
-	fe_el->l_next_free_rec = cpu_to_le16(1);
+	/* update root_bh now */
+	le16_add_cpu(&root_el->l_tree_depth, 1);
+	root_el->l_recs[0].e_cpos = 0;
+	root_el->l_recs[0].e_blkno = eb->h_blkno;
+	root_el->l_recs[0].e_int_clusters = cpu_to_le32(new_clusters);
+	for (i = 1; i < le16_to_cpu(root_el->l_next_free_rec); i++)
+		memset(&root_el->l_recs[i], 0, sizeof(struct ocfs2_extent_rec));
+	root_el->l_next_free_rec = cpu_to_le16(1);
 
 	/* If this is our 1st tree depth shift, then last_eb_blk
 	 * becomes the allocated extent block */
-	if (fe_el->l_tree_depth == cpu_to_le16(1))
-		fe->i_last_eb_blk = eb->h_blkno;
+	if (root_el->l_tree_depth == cpu_to_le16(1))
+		et->eops->set_last_eb_blk(et, le64_to_cpu(eb->h_blkno));
 
-	status = ocfs2_journal_dirty(handle, fe_bh);
+	status = ocfs2_journal_dirty(handle, et->root_bh);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -818,22 +901,21 @@ bail:
  * 1) a lowest extent block is found, then we pass it back in
  *    *lowest_eb_bh and return '0'
  *
- * 2) the search fails to find anything, but the dinode has room. We
+ * 2) the search fails to find anything, but the root_el has room. We
  *    pass NULL back in *lowest_eb_bh, but still return '0'
  *
- * 3) the search fails to find anything AND the dinode is full, in
+ * 3) the search fails to find anything AND the root_el is full, in
  *    which case we return > 0
  *
  * return status < 0 indicates an error.
  */
 static int ocfs2_find_branch_target(struct ocfs2_super *osb,
 				    struct inode *inode,
-				    struct buffer_head *fe_bh,
+				    struct ocfs2_extent_tree *et,
 				    struct buffer_head **target_bh)
 {
 	int status = 0, i;
 	u64 blkno;
-	struct ocfs2_dinode *fe;
 	struct ocfs2_extent_block *eb;
 	struct ocfs2_extent_list  *el;
 	struct buffer_head *bh = NULL;
@@ -843,8 +925,7 @@ static int ocfs2_find_branch_target(struct ocfs2_super *osb,
 
 	*target_bh = NULL;
 
-	fe = (struct ocfs2_dinode *) fe_bh->b_data;
-	el = &fe->id2.i_list;
+	el = et->root_el;
 
 	while(le16_to_cpu(el->l_tree_depth) > 1) {
 		if (le16_to_cpu(el->l_next_free_rec) == 0) {
@@ -896,8 +977,8 @@ static int ocfs2_find_branch_target(struct ocfs2_super *osb,
 
 	/* If we didn't find one and the fe doesn't have any room,
 	 * then return '1' */
-	if (!lowest_bh
-	    && (fe->id2.i_list.l_next_free_rec == fe->id2.i_list.l_count))
+	el = et->root_el;
+	if (!lowest_bh && (el->l_next_free_rec == el->l_count))
 		status = 1;
 
 	*target_bh = lowest_bh;
@@ -920,19 +1001,19 @@ bail:
  * *last_eb_bh will be updated by ocfs2_add_branch().
  */
 static int ocfs2_grow_tree(struct inode *inode, handle_t *handle,
-			   struct buffer_head *di_bh, int *final_depth,
+			   struct ocfs2_extent_tree *et, int *final_depth,
 			   struct buffer_head **last_eb_bh,
 			   struct ocfs2_alloc_context *meta_ac)
 {
 	int ret, shift;
-	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
-	int depth = le16_to_cpu(di->id2.i_list.l_tree_depth);
+	struct ocfs2_extent_list *el = et->root_el;
+	int depth = le16_to_cpu(el->l_tree_depth);
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct buffer_head *bh = NULL;
 
 	BUG_ON(meta_ac == NULL);
 
-	shift = ocfs2_find_branch_target(osb, inode, di_bh, &bh);
+	shift = ocfs2_find_branch_target(osb, inode, et, &bh);
 	if (shift < 0) {
 		ret = shift;
 		mlog_errno(ret);
@@ -949,7 +1030,7 @@ static int ocfs2_grow_tree(struct inode *inode, handle_t *handle,
 		/* ocfs2_shift_tree_depth will return us a buffer with
 		 * the new extent block (so we can pass that to
 		 * ocfs2_add_branch). */
-		ret = ocfs2_shift_tree_depth(osb, handle, inode, di_bh,
+		ret = ocfs2_shift_tree_depth(osb, handle, inode, et,
 					     meta_ac, &bh);
 		if (ret < 0) {
 			mlog_errno(ret);
@@ -976,7 +1057,7 @@ static int ocfs2_grow_tree(struct inode *inode, handle_t *handle,
 	/* call ocfs2_add_branch to add the final part of the tree with
 	 * the new data. */
 	mlog(0, "add branch. bh = %p\n", bh);
-	ret = ocfs2_add_branch(osb, handle, inode, di_bh, bh, last_eb_bh,
+	ret = ocfs2_add_branch(osb, handle, inode, et, bh, last_eb_bh,
 			       meta_ac);
 	if (ret < 0) {
 		mlog_errno(ret);
@@ -2067,11 +2148,11 @@ static int ocfs2_rotate_subtree_left(struct inode *inode, handle_t *handle,
 				     struct ocfs2_path *right_path,
 				     int subtree_index,
 				     struct ocfs2_cached_dealloc_ctxt *dealloc,
-				     int *deleted)
+				     int *deleted,
+				     struct ocfs2_extent_tree *et)
 {
 	int ret, i, del_right_subtree = 0, right_has_empty = 0;
-	struct buffer_head *root_bh, *di_bh = path_root_bh(right_path);
-	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+	struct buffer_head *root_bh, *et_root_bh = path_root_bh(right_path);
 	struct ocfs2_extent_list *right_leaf_el, *left_leaf_el;
 	struct ocfs2_extent_block *eb;
 
@@ -2123,7 +2204,7 @@ static int ocfs2_rotate_subtree_left(struct inode *inode, handle_t *handle,
 		 * We have to update i_last_eb_blk during the meta
 		 * data delete.
 		 */
-		ret = ocfs2_journal_access(handle, inode, di_bh,
+		ret = ocfs2_journal_access(handle, inode, et_root_bh,
 					   OCFS2_JOURNAL_ACCESS_WRITE);
 		if (ret) {
 			mlog_errno(ret);
@@ -2198,7 +2279,7 @@ static int ocfs2_rotate_subtree_left(struct inode *inode, handle_t *handle,
 		ocfs2_update_edge_lengths(inode, handle, left_path);
 
 		eb = (struct ocfs2_extent_block *)path_leaf_bh(left_path)->b_data;
-		di->i_last_eb_blk = eb->h_blkno;
+		et->eops->set_last_eb_blk(et, le64_to_cpu(eb->h_blkno));
 
 		/*
 		 * Removal of the extent in the left leaf was skipped
@@ -2208,7 +2289,7 @@ static int ocfs2_rotate_subtree_left(struct inode *inode, handle_t *handle,
 		if (right_has_empty)
 			ocfs2_remove_empty_extent(left_leaf_el);
 
-		ret = ocfs2_journal_dirty(handle, di_bh);
+		ret = ocfs2_journal_dirty(handle, et_root_bh);
 		if (ret)
 			mlog_errno(ret);
 
@@ -2331,7 +2412,8 @@ static int __ocfs2_rotate_tree_left(struct inode *inode,
 				    handle_t *handle, int orig_credits,
 				    struct ocfs2_path *path,
 				    struct ocfs2_cached_dealloc_ctxt *dealloc,
-				    struct ocfs2_path **empty_extent_path)
+				    struct ocfs2_path **empty_extent_path,
+				    struct ocfs2_extent_tree *et)
 {
 	int ret, subtree_root, deleted;
 	u32 right_cpos;
@@ -2404,7 +2486,7 @@ static int __ocfs2_rotate_tree_left(struct inode *inode,
 
 		ret = ocfs2_rotate_subtree_left(inode, handle, left_path,
 						right_path, subtree_root,
-						dealloc, &deleted);
+						dealloc, &deleted, et);
 		if (ret == -EAGAIN) {
 			/*
 			 * The rotation has to temporarily stop due to
@@ -2447,29 +2529,20 @@ out:
 }
 
 static int ocfs2_remove_rightmost_path(struct inode *inode, handle_t *handle,
-				       struct ocfs2_path *path,
-				       struct ocfs2_cached_dealloc_ctxt *dealloc)
+				struct ocfs2_path *path,
+				struct ocfs2_cached_dealloc_ctxt *dealloc,
+				struct ocfs2_extent_tree *et)
 {
 	int ret, subtree_index;
 	u32 cpos;
 	struct ocfs2_path *left_path = NULL;
-	struct ocfs2_dinode *di;
 	struct ocfs2_extent_block *eb;
 	struct ocfs2_extent_list *el;
 
-	/*
-	 * XXX: This code assumes that the root is an inode, which is
-	 * true for now but may change as tree code gets generic.
-	 */
-	di = (struct ocfs2_dinode *)path_root_bh(path)->b_data;
-	if (!OCFS2_IS_VALID_DINODE(di)) {
-		ret = -EIO;
-		ocfs2_error(inode->i_sb,
-			    "Inode %llu has invalid path root",
-			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
-		goto out;
-	}
 
+	ret = ocfs2_extent_tree_sanity_check(inode, et);
+	if (ret)
+		goto out;
 	/*
 	 * There's two ways we handle this depending on
 	 * whether path is the only existing one.
@@ -2526,7 +2599,7 @@ static int ocfs2_remove_rightmost_path(struct inode *inode, handle_t *handle,
 		ocfs2_update_edge_lengths(inode, handle, left_path);
 
 		eb = (struct ocfs2_extent_block *)path_leaf_bh(left_path)->b_data;
-		di->i_last_eb_blk = eb->h_blkno;
+		et->eops->set_last_eb_blk(et, le64_to_cpu(eb->h_blkno));
 	} else {
 		/*
 		 * 'path' is also the leftmost path which
@@ -2537,12 +2610,12 @@ static int ocfs2_remove_rightmost_path(struct inode *inode, handle_t *handle,
 		 */
 		ocfs2_unlink_path(inode, handle, dealloc, path, 1);
 
-		el = &di->id2.i_list;
+		el = et->root_el;
 		el->l_tree_depth = 0;
 		el->l_next_free_rec = 0;
 		memset(&el->l_recs[0], 0, sizeof(struct ocfs2_extent_rec));
 
-		di->i_last_eb_blk = 0;
+		et->eops->set_last_eb_blk(et, 0);
 	}
 
 	ocfs2_journal_dirty(handle, path_root_bh(path));
@@ -2570,7 +2643,8 @@ out:
  */
 static int ocfs2_rotate_tree_left(struct inode *inode, handle_t *handle,
 				  struct ocfs2_path *path,
-				  struct ocfs2_cached_dealloc_ctxt *dealloc)
+				  struct ocfs2_cached_dealloc_ctxt *dealloc,
+				  struct ocfs2_extent_tree *et)
 {
 	int ret, orig_credits = handle->h_buffer_credits;
 	struct ocfs2_path *tmp_path = NULL, *restart_path = NULL;
@@ -2584,7 +2658,7 @@ static int ocfs2_rotate_tree_left(struct inode *inode, handle_t *handle,
 	if (path->p_tree_depth == 0) {
 rightmost_no_delete:
 		/*
-		 * In-inode extents. This is trivially handled, so do
+		 * Inline extents. This is trivially handled, so do
 		 * it up front.
 		 */
 		ret = ocfs2_rotate_rightmost_leaf_left(inode, handle,
@@ -2638,7 +2712,7 @@ rightmost_no_delete:
 		 */
 
 		ret = ocfs2_remove_rightmost_path(inode, handle, path,
-						  dealloc);
+						  dealloc, et);
 		if (ret)
 			mlog_errno(ret);
 		goto out;
@@ -2650,7 +2724,7 @@ rightmost_no_delete:
 	 */
 try_rotate:
 	ret = __ocfs2_rotate_tree_left(inode, handle, orig_credits, path,
-				       dealloc, &restart_path);
+				       dealloc, &restart_path, et);
 	if (ret && ret != -EAGAIN) {
 		mlog_errno(ret);
 		goto out;
@@ -2662,7 +2736,7 @@ try_rotate:
 
 		ret = __ocfs2_rotate_tree_left(inode, handle, orig_credits,
 					       tmp_path, dealloc,
-					       &restart_path);
+					       &restart_path, et);
 		if (ret && ret != -EAGAIN) {
 			mlog_errno(ret);
 			goto out;
@@ -2816,7 +2890,8 @@ static int ocfs2_try_to_merge_extent(struct inode *inode,
 				     int split_index,
 				     struct ocfs2_extent_rec *split_rec,
 				     struct ocfs2_cached_dealloc_ctxt *dealloc,
-				     struct ocfs2_merge_ctxt *ctxt)
+				     struct ocfs2_merge_ctxt *ctxt,
+				     struct ocfs2_extent_tree *et)
 
 {
 	int ret = 0;
@@ -2834,7 +2909,7 @@ static int ocfs2_try_to_merge_extent(struct inode *inode,
 		 * illegal.
 		 */
 		ret = ocfs2_rotate_tree_left(inode, handle, left_path,
-					     dealloc);
+					     dealloc, et);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -2876,7 +2951,8 @@ static int ocfs2_try_to_merge_extent(struct inode *inode,
 		 * The left merge left us with an empty extent, remove
 		 * it.
 		 */
-		ret = ocfs2_rotate_tree_left(inode, handle, left_path, dealloc);
+		ret = ocfs2_rotate_tree_left(inode, handle, left_path,
+					     dealloc, et);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -2898,7 +2974,7 @@ static int ocfs2_try_to_merge_extent(struct inode *inode,
 		BUG_ON(!ocfs2_is_empty_extent(&el->l_recs[0]));
 
 		ret = ocfs2_rotate_tree_left(inode, handle, left_path,
-					     dealloc);
+					     dealloc, et);
 		/*
 		 * Error from this last rotate is not critical, so
 		 * print but don't bubble it up.
@@ -2940,7 +3016,7 @@ static int ocfs2_try_to_merge_extent(struct inode *inode,
 			 * our leaf. Try to rotate it away.
 			 */
 			ret = ocfs2_rotate_tree_left(inode, handle, left_path,
-						     dealloc);
+						     dealloc, et);
 			if (ret)
 				mlog_errno(ret);
 			ret = 0;
@@ -3084,6 +3160,17 @@ static inline void ocfs2_update_dinode_clusters(struct inode *inode,
 	spin_unlock(&OCFS2_I(inode)->ip_lock);
 }
 
+static void ocfs2_update_clusters(struct inode *inode,
+				  struct ocfs2_extent_tree *et,
+				  u32 clusters)
+{
+	if (et->type == OCFS2_DINODE_EXTENT) {
+		struct ocfs2_dinode *di =
+			(struct ocfs2_dinode *)et->root_bh->b_data;
+		ocfs2_update_dinode_clusters(inode, di, clusters);
+	}
+}
+
 static void ocfs2_adjust_rightmost_records(struct inode *inode,
 					   handle_t *handle,
 					   struct ocfs2_path *path,
@@ -3285,8 +3372,8 @@ static void ocfs2_split_record(struct inode *inode,
 }
 
 /*
- * This function only does inserts on an allocation b-tree. For dinode
- * lists, ocfs2_insert_at_leaf() is called directly.
+ * This function only does inserts on an allocation b-tree. For tree
+ * depth = 0, ocfs2_insert_at_leaf() is called directly.
  *
  * right_path is the path we want to do the actual insert
  * in. left_path should only be passed in if we need to update that
@@ -3383,7 +3470,7 @@ out:
 
 static int ocfs2_do_insert_extent(struct inode *inode,
 				  handle_t *handle,
-				  struct buffer_head *di_bh,
+				  struct ocfs2_extent_tree *et,
 				  struct ocfs2_extent_rec *insert_rec,
 				  struct ocfs2_insert_type *type)
 {
@@ -3391,13 +3478,11 @@ static int ocfs2_do_insert_extent(struct inode *inode,
 	u32 cpos;
 	struct ocfs2_path *right_path = NULL;
 	struct ocfs2_path *left_path = NULL;
-	struct ocfs2_dinode *di;
 	struct ocfs2_extent_list *el;
 
-	di = (struct ocfs2_dinode *) di_bh->b_data;
-	el = &di->id2.i_list;
+	el = et->root_el;
 
-	ret = ocfs2_journal_access(handle, inode, di_bh,
+	ret = ocfs2_journal_access(handle, inode, et->root_bh,
 				   OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
@@ -3409,7 +3494,7 @@ static int ocfs2_do_insert_extent(struct inode *inode,
 		goto out_update_clusters;
 	}
 
-	right_path = ocfs2_new_inode_path(di_bh);
+	right_path = ocfs2_new_path(et->root_bh, et->root_el);
 	if (!right_path) {
 		ret = -ENOMEM;
 		mlog_errno(ret);
@@ -3459,7 +3544,7 @@ static int ocfs2_do_insert_extent(struct inode *inode,
 		 * ocfs2_rotate_tree_right() might have extended the
 		 * transaction without re-journaling our tree root.
 		 */
-		ret = ocfs2_journal_access(handle, inode, di_bh,
+		ret = ocfs2_journal_access(handle, inode, et->root_bh,
 					   OCFS2_JOURNAL_ACCESS_WRITE);
 		if (ret) {
 			mlog_errno(ret);
@@ -3484,10 +3569,10 @@ static int ocfs2_do_insert_extent(struct inode *inode,
 
 out_update_clusters:
 	if (type->ins_split == SPLIT_NONE)
-		ocfs2_update_dinode_clusters(inode, di,
-					     le16_to_cpu(insert_rec->e_leaf_clusters));
+		ocfs2_update_clusters(inode, et,
+				      le16_to_cpu(insert_rec->e_leaf_clusters));
 
-	ret = ocfs2_journal_dirty(handle, di_bh);
+	ret = ocfs2_journal_dirty(handle, et->root_bh);
 	if (ret)
 		mlog_errno(ret);
 
@@ -3563,8 +3648,8 @@ static void ocfs2_figure_contig_type(struct inode *inode,
  * ocfs2_figure_appending_type() will figure out whether we'll have to
  * insert at the tail of the rightmost leaf.
  *
- * This should also work against the dinode list for tree's with 0
- * depth. If we consider the dinode list to be the rightmost leaf node
+ * This should also work against the root extent list for tree's with 0
+ * depth. If we consider the root extent list to be the rightmost leaf node
  * then the logic here makes sense.
  */
 static void ocfs2_figure_appending_type(struct ocfs2_insert_type *insert,
@@ -3615,14 +3700,13 @@ set_tail_append:
  * structure.
  */
 static int ocfs2_figure_insert_type(struct inode *inode,
-				    struct buffer_head *di_bh,
+				    struct ocfs2_extent_tree *et,
 				    struct buffer_head **last_eb_bh,
 				    struct ocfs2_extent_rec *insert_rec,
 				    int *free_records,
 				    struct ocfs2_insert_type *insert)
 {
 	int ret;
-	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 	struct ocfs2_extent_block *eb;
 	struct ocfs2_extent_list *el;
 	struct ocfs2_path *path = NULL;
@@ -3630,7 +3714,7 @@ static int ocfs2_figure_insert_type(struct inode *inode,
 
 	insert->ins_split = SPLIT_NONE;
 
-	el = &di->id2.i_list;
+	el = et->root_el;
 	insert->ins_tree_depth = le16_to_cpu(el->l_tree_depth);
 
 	if (el->l_tree_depth) {
@@ -3641,7 +3725,7 @@ static int ocfs2_figure_insert_type(struct inode *inode,
 		 * may want it later.
 		 */
 		ret = ocfs2_read_block(OCFS2_SB(inode->i_sb),
-				       le64_to_cpu(di->i_last_eb_blk), &bh,
+				       et->eops->get_last_eb_blk(et), &bh,
 				       OCFS2_BH_CACHED, inode);
 		if (ret) {
 			mlog_exit(ret);
@@ -3668,7 +3752,7 @@ static int ocfs2_figure_insert_type(struct inode *inode,
 		return 0;
 	}
 
-	path = ocfs2_new_inode_path(di_bh);
+	path = ocfs2_new_path(et->root_bh, et->root_el);
 	if (!path) {
 		ret = -ENOMEM;
 		mlog_errno(ret);
@@ -3718,7 +3802,8 @@ static int ocfs2_figure_insert_type(struct inode *inode,
 	 * the case that we're doing a tail append, so maybe we can
 	 * take advantage of that information somehow.
 	 */
-	if (le64_to_cpu(di->i_last_eb_blk) == path_leaf_bh(path)->b_blocknr) {
+	if (et->eops->get_last_eb_blk(et) ==
+	    path_leaf_bh(path)->b_blocknr) {
 		/*
 		 * Ok, ocfs2_find_path() returned us the rightmost
 		 * tree path. This might be an appending insert. There are
@@ -3748,21 +3833,30 @@ out:
 int ocfs2_insert_extent(struct ocfs2_super *osb,
 			handle_t *handle,
 			struct inode *inode,
-			struct buffer_head *fe_bh,
+			struct buffer_head *root_bh,
 			u32 cpos,
 			u64 start_blk,
 			u32 new_clusters,
 			u8 flags,
-			struct ocfs2_alloc_context *meta_ac)
+			struct ocfs2_alloc_context *meta_ac,
+			enum ocfs2_extent_tree_type et_type)
 {
 	int status;
 	int uninitialized_var(free_records);
 	struct buffer_head *last_eb_bh = NULL;
 	struct ocfs2_insert_type insert = {0, };
 	struct ocfs2_extent_rec rec;
+	struct ocfs2_extent_tree *et = NULL;
 
 	BUG_ON(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL);
 
+	et = ocfs2_new_extent_tree(root_bh, et_type);
+	if (!et) {
+		status = -ENOMEM;
+		mlog_errno(status);
+		goto bail;
+	}
+
 	mlog(0, "add %u clusters at position %u to inode %llu\n",
 	     new_clusters, cpos, (unsigned long long)OCFS2_I(inode)->ip_blkno);
 
@@ -3780,7 +3874,7 @@ int ocfs2_insert_extent(struct ocfs2_super *osb,
 	rec.e_leaf_clusters = cpu_to_le16(new_clusters);
 	rec.e_flags = flags;
 
-	status = ocfs2_figure_insert_type(inode, fe_bh, &last_eb_bh, &rec,
+	status = ocfs2_figure_insert_type(inode, et, &last_eb_bh, &rec,
 					  &free_records, &insert);
 	if (status < 0) {
 		mlog_errno(status);
@@ -3794,7 +3888,7 @@ int ocfs2_insert_extent(struct ocfs2_super *osb,
 	     free_records, insert.ins_tree_depth);
 
 	if (insert.ins_contig == CONTIG_NONE && free_records == 0) {
-		status = ocfs2_grow_tree(inode, handle, fe_bh,
+		status = ocfs2_grow_tree(inode, handle, et,
 					 &insert.ins_tree_depth, &last_eb_bh,
 					 meta_ac);
 		if (status) {
@@ -3804,16 +3898,18 @@ int ocfs2_insert_extent(struct ocfs2_super *osb,
 	}
 
 	/* Finally, we can add clusters. This might rotate the tree for us. */
-	status = ocfs2_do_insert_extent(inode, handle, fe_bh, &rec, &insert);
+	status = ocfs2_do_insert_extent(inode, handle, et, &rec, &insert);
 	if (status < 0)
 		mlog_errno(status);
-	else
+	else if (et->type == OCFS2_DINODE_EXTENT)
 		ocfs2_extent_map_insert_rec(inode, &rec);
 
 bail:
 	if (last_eb_bh)
 		brelse(last_eb_bh);
 
+	if (et)
+		ocfs2_free_extent_tree(et);
 	mlog_exit(status);
 	return status;
 }
@@ -3841,7 +3937,7 @@ static void ocfs2_make_right_split_rec(struct super_block *sb,
 static int ocfs2_split_and_insert(struct inode *inode,
 				  handle_t *handle,
 				  struct ocfs2_path *path,
-				  struct buffer_head *di_bh,
+				  struct ocfs2_extent_tree *et,
 				  struct buffer_head **last_eb_bh,
 				  int split_index,
 				  struct ocfs2_extent_rec *orig_split_rec,
@@ -3855,7 +3951,6 @@ static int ocfs2_split_and_insert(struct inode *inode,
 	struct ocfs2_extent_rec split_rec = *orig_split_rec;
 	struct ocfs2_insert_type insert;
 	struct ocfs2_extent_block *eb;
-	struct ocfs2_dinode *di;
 
 leftright:
 	/*
@@ -3864,8 +3959,7 @@ leftright:
 	 */
 	rec = path_leaf_el(path)->l_recs[split_index];
 
-	di = (struct ocfs2_dinode *)di_bh->b_data;
-	rightmost_el = &di->id2.i_list;
+	rightmost_el = et->root_el;
 
 	depth = le16_to_cpu(rightmost_el->l_tree_depth);
 	if (depth) {
@@ -3876,8 +3970,8 @@ leftright:
 
 	if (le16_to_cpu(rightmost_el->l_next_free_rec) ==
 	    le16_to_cpu(rightmost_el->l_count)) {
-		ret = ocfs2_grow_tree(inode, handle, di_bh, &depth, last_eb_bh,
-				      meta_ac);
+		ret = ocfs2_grow_tree(inode, handle, et,
+				      &depth, last_eb_bh, meta_ac);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -3914,8 +4008,7 @@ leftright:
 		do_leftright = 1;
 	}
 
-	ret = ocfs2_do_insert_extent(inode, handle, di_bh, &split_rec,
-				     &insert);
+	ret = ocfs2_do_insert_extent(inode, handle, et, &split_rec, &insert);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -3957,8 +4050,9 @@ out:
  * of the tree is required. All other cases will degrade into a less
  * optimal tree layout.
  *
- * last_eb_bh should be the rightmost leaf block for any inode with a
- * btree. Since a split may grow the tree or a merge might shrink it, the caller cannot trust the contents of that buffer after this call.
+ * last_eb_bh should be the rightmost leaf block for any extent
+ * btree. Since a split may grow the tree or a merge might shrink it,
+ * the caller cannot trust the contents of that buffer after this call.
  *
  * This code is optimized for readability - several passes might be
  * made over certain portions of the tree. All of those blocks will
@@ -3966,7 +4060,7 @@ out:
  * extra overhead is not expressed in terms of disk reads.
  */
 static int __ocfs2_mark_extent_written(struct inode *inode,
-				       struct buffer_head *di_bh,
+				       struct ocfs2_extent_tree *et,
 				       handle_t *handle,
 				       struct ocfs2_path *path,
 				       int split_index,
@@ -4006,10 +4100,9 @@ static int __ocfs2_mark_extent_written(struct inode *inode,
 	 */
 	if (path->p_tree_depth) {
 		struct ocfs2_extent_block *eb;
-		struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 
 		ret = ocfs2_read_block(OCFS2_SB(inode->i_sb),
-				       le64_to_cpu(di->i_last_eb_blk),
+				       et->eops->get_last_eb_blk(et),
 				       &last_eb_bh, OCFS2_BH_CACHED, inode);
 		if (ret) {
 			mlog_exit(ret);
@@ -4043,7 +4136,7 @@ static int __ocfs2_mark_extent_written(struct inode *inode,
 		if (ctxt.c_split_covers_rec)
 			el->l_recs[split_index] = *split_rec;
 		else
-			ret = ocfs2_split_and_insert(inode, handle, path, di_bh,
+			ret = ocfs2_split_and_insert(inode, handle, path, et,
 						     &last_eb_bh, split_index,
 						     split_rec, meta_ac);
 		if (ret)
@@ -4051,7 +4144,7 @@ static int __ocfs2_mark_extent_written(struct inode *inode,
 	} else {
 		ret = ocfs2_try_to_merge_extent(inode, handle, path,
 						split_index, split_rec,
-						dealloc, &ctxt);
+						dealloc, &ctxt, et);
 		if (ret)
 			mlog_errno(ret);
 	}
@@ -4069,16 +4162,18 @@ out:
  *
  * The caller is responsible for passing down meta_ac if we'll need it.
  */
-int ocfs2_mark_extent_written(struct inode *inode, struct buffer_head *di_bh,
+int ocfs2_mark_extent_written(struct inode *inode, struct buffer_head *root_bh,
 			      handle_t *handle, u32 cpos, u32 len, u32 phys,
 			      struct ocfs2_alloc_context *meta_ac,
-			      struct ocfs2_cached_dealloc_ctxt *dealloc)
+			      struct ocfs2_cached_dealloc_ctxt *dealloc,
+			      enum ocfs2_extent_tree_type et_type)
 {
 	int ret, index;
 	u64 start_blkno = ocfs2_clusters_to_blocks(inode->i_sb, phys);
 	struct ocfs2_extent_rec split_rec;
 	struct ocfs2_path *left_path = NULL;
 	struct ocfs2_extent_list *el;
+	struct ocfs2_extent_tree *et = NULL;
 
 	mlog(0, "Inode %lu cpos %u, len %u, phys %u (%llu)\n",
 	     inode->i_ino, cpos, len, phys, (unsigned long long)start_blkno);
@@ -4092,13 +4187,21 @@ int ocfs2_mark_extent_written(struct inode *inode, struct buffer_head *di_bh,
 		goto out;
 	}
 
+	et = ocfs2_new_extent_tree(root_bh, et_type);
+	if (!et) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto out;
+	}
+
 	/*
 	 * XXX: This should be fixed up so that we just re-insert the
 	 * next extent records.
 	 */
-	ocfs2_extent_map_trunc(inode, 0);
+	if (et_type == OCFS2_DINODE_EXTENT)
+		ocfs2_extent_map_trunc(inode, 0);
 
-	left_path = ocfs2_new_inode_path(di_bh);
+	left_path = ocfs2_new_path(et->root_bh, et->root_el);
 	if (!left_path) {
 		ret = -ENOMEM;
 		mlog_errno(ret);
@@ -4129,23 +4232,25 @@ int ocfs2_mark_extent_written(struct inode *inode, struct buffer_head *di_bh,
 	split_rec.e_flags = path_leaf_el(left_path)->l_recs[index].e_flags;
 	split_rec.e_flags &= ~OCFS2_EXT_UNWRITTEN;
 
-	ret = __ocfs2_mark_extent_written(inode, di_bh, handle, left_path,
-					  index, &split_rec, meta_ac, dealloc);
+	ret = __ocfs2_mark_extent_written(inode, et, handle, left_path,
+					  index, &split_rec, meta_ac,
+					  dealloc);
 	if (ret)
 		mlog_errno(ret);
 
 out:
 	ocfs2_free_path(left_path);
+	if (et)
+		ocfs2_free_extent_tree(et);
 	return ret;
 }
 
-static int ocfs2_split_tree(struct inode *inode, struct buffer_head *di_bh,
+static int ocfs2_split_tree(struct inode *inode, struct ocfs2_extent_tree *et,
 			    handle_t *handle, struct ocfs2_path *path,
 			    int index, u32 new_range,
 			    struct ocfs2_alloc_context *meta_ac)
 {
 	int ret, depth, credits = handle->h_buffer_credits;
-	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 	struct buffer_head *last_eb_bh = NULL;
 	struct ocfs2_extent_block *eb;
 	struct ocfs2_extent_list *rightmost_el, *el;
@@ -4163,7 +4268,7 @@ static int ocfs2_split_tree(struct inode *inode, struct buffer_head *di_bh,
 	depth = path->p_tree_depth;
 	if (depth > 0) {
 		ret = ocfs2_read_block(OCFS2_SB(inode->i_sb),
-				       le64_to_cpu(di->i_last_eb_blk),
+				       et->eops->get_last_eb_blk(et),
 				       &last_eb_bh, OCFS2_BH_CACHED, inode);
 		if (ret < 0) {
 			mlog_errno(ret);
@@ -4176,7 +4281,7 @@ static int ocfs2_split_tree(struct inode *inode, struct buffer_head *di_bh,
 		rightmost_el = path_leaf_el(path);
 
 	credits += path->p_tree_depth +
-		   ocfs2_extend_meta_needed(&di->id2.i_list);
+		   ocfs2_extend_meta_needed(et->root_el);
 	ret = ocfs2_extend_trans(handle, credits);
 	if (ret) {
 		mlog_errno(ret);
@@ -4185,7 +4290,7 @@ static int ocfs2_split_tree(struct inode *inode, struct buffer_head *di_bh,
 
 	if (le16_to_cpu(rightmost_el->l_next_free_rec) ==
 	    le16_to_cpu(rightmost_el->l_count)) {
-		ret = ocfs2_grow_tree(inode, handle, di_bh, &depth, &last_eb_bh,
+		ret = ocfs2_grow_tree(inode, handle, et, &depth, &last_eb_bh,
 				      meta_ac);
 		if (ret) {
 			mlog_errno(ret);
@@ -4199,7 +4304,7 @@ static int ocfs2_split_tree(struct inode *inode, struct buffer_head *di_bh,
 	insert.ins_split = SPLIT_RIGHT;
 	insert.ins_tree_depth = depth;
 
-	ret = ocfs2_do_insert_extent(inode, handle, di_bh, &split_rec, &insert);
+	ret = ocfs2_do_insert_extent(inode, handle, et, &split_rec, &insert);
 	if (ret)
 		mlog_errno(ret);
 
@@ -4211,7 +4316,8 @@ out:
 static int ocfs2_truncate_rec(struct inode *inode, handle_t *handle,
 			      struct ocfs2_path *path, int index,
 			      struct ocfs2_cached_dealloc_ctxt *dealloc,
-			      u32 cpos, u32 len)
+			      u32 cpos, u32 len,
+			      struct ocfs2_extent_tree *et)
 {
 	int ret;
 	u32 left_cpos, rec_range, trunc_range;
@@ -4223,7 +4329,7 @@ static int ocfs2_truncate_rec(struct inode *inode, handle_t *handle,
 	struct ocfs2_extent_block *eb;
 
 	if (ocfs2_is_empty_extent(&el->l_recs[0]) && index > 0) {
-		ret = ocfs2_rotate_tree_left(inode, handle, path, dealloc);
+		ret = ocfs2_rotate_tree_left(inode, handle, path, dealloc, et);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -4354,7 +4460,7 @@ static int ocfs2_truncate_rec(struct inode *inode, handle_t *handle,
 
 	ocfs2_journal_dirty(handle, path_leaf_bh(path));
 
-	ret = ocfs2_rotate_tree_left(inode, handle, path, dealloc);
+	ret = ocfs2_rotate_tree_left(inode, handle, path, dealloc, et);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -4365,20 +4471,29 @@ out:
 	return ret;
 }
 
-int ocfs2_remove_extent(struct inode *inode, struct buffer_head *di_bh,
+int ocfs2_remove_extent(struct inode *inode, struct buffer_head *root_bh,
 			u32 cpos, u32 len, handle_t *handle,
 			struct ocfs2_alloc_context *meta_ac,
-			struct ocfs2_cached_dealloc_ctxt *dealloc)
+			struct ocfs2_cached_dealloc_ctxt *dealloc,
+			enum ocfs2_extent_tree_type et_type)
 {
 	int ret, index;
 	u32 rec_range, trunc_range;
 	struct ocfs2_extent_rec *rec;
 	struct ocfs2_extent_list *el;
-	struct ocfs2_path *path;
+	struct ocfs2_path *path = NULL;
+	struct ocfs2_extent_tree *et = NULL;
+
+	et = ocfs2_new_extent_tree(root_bh, et_type);
+	if (!et) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto out;
+	}
 
 	ocfs2_extent_map_trunc(inode, 0);
 
-	path = ocfs2_new_inode_path(di_bh);
+	path = ocfs2_new_path(et->root_bh, et->root_el);
 	if (!path) {
 		ret = -ENOMEM;
 		mlog_errno(ret);
@@ -4431,13 +4546,13 @@ int ocfs2_remove_extent(struct inode *inode, struct buffer_head *di_bh,
 
 	if (le32_to_cpu(rec->e_cpos) == cpos || rec_range == trunc_range) {
 		ret = ocfs2_truncate_rec(inode, handle, path, index, dealloc,
-					 cpos, len);
+					 cpos, len, et);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
 		}
 	} else {
-		ret = ocfs2_split_tree(inode, di_bh, handle, path, index,
+		ret = ocfs2_split_tree(inode, et, handle, path, index,
 				       trunc_range, meta_ac);
 		if (ret) {
 			mlog_errno(ret);
@@ -4486,7 +4601,7 @@ int ocfs2_remove_extent(struct inode *inode, struct buffer_head *di_bh,
 		}
 
 		ret = ocfs2_truncate_rec(inode, handle, path, index, dealloc,
-					 cpos, len);
+					 cpos, len, et);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -4495,6 +4610,8 @@ int ocfs2_remove_extent(struct inode *inode, struct buffer_head *di_bh,
 
 out:
 	ocfs2_free_path(path);
+	if (et)
+		ocfs2_free_extent_tree(et);
 	return ret;
 }
 
@@ -6001,7 +6118,8 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 		 * the in-inode data from our pages.
 		 */
 		ret = ocfs2_insert_extent(osb, handle, inode, di_bh,
-					  0, block, 1, 0, NULL);
+					  0, block, 1, 0,
+					  NULL, OCFS2_DINODE_EXTENT);
 		if (ret) {
 			mlog_errno(ret);
 			goto out_commit;
@@ -6043,13 +6161,14 @@ int ocfs2_commit_truncate(struct ocfs2_super *osb,
 	handle_t *handle = NULL;
 	struct inode *tl_inode = osb->osb_tl_inode;
 	struct ocfs2_path *path = NULL;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)fe_bh->b_data;
 
 	mlog_entry_void();
 
 	new_highest_cpos = ocfs2_clusters_for_bytes(osb->sb,
 						     i_size_read(inode));
 
-	path = ocfs2_new_inode_path(fe_bh);
+	path = ocfs2_new_path(fe_bh, &di->id2.i_list);
 	if (!path) {
 		status = -ENOMEM;
 		mlog_errno(status);
@@ -6339,3 +6458,5 @@ static void ocfs2_free_truncate_context(struct ocfs2_truncate_context *tc)
 
 	kfree(tc);
 }
+
+
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index 249e79e..5a460a9 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -26,28 +26,37 @@
 #ifndef OCFS2_ALLOC_H
 #define OCFS2_ALLOC_H
 
+enum ocfs2_extent_tree_type {
+	OCFS2_DINODE_EXTENT = 0,
+};
+
 struct ocfs2_alloc_context;
 int ocfs2_insert_extent(struct ocfs2_super *osb,
 			handle_t *handle,
 			struct inode *inode,
-			struct buffer_head *fe_bh,
+			struct buffer_head *root_bh,
 			u32 cpos,
 			u64 start_blk,
 			u32 new_clusters,
 			u8 flags,
-			struct ocfs2_alloc_context *meta_ac);
+			struct ocfs2_alloc_context *meta_ac,
+			enum ocfs2_extent_tree_type et_type);
 struct ocfs2_cached_dealloc_ctxt;
-int ocfs2_mark_extent_written(struct inode *inode, struct buffer_head *di_bh,
+int ocfs2_mark_extent_written(struct inode *inode, struct buffer_head *root_bh,
 			      handle_t *handle, u32 cpos, u32 len, u32 phys,
 			      struct ocfs2_alloc_context *meta_ac,
-			      struct ocfs2_cached_dealloc_ctxt *dealloc);
-int ocfs2_remove_extent(struct inode *inode, struct buffer_head *di_bh,
+			      struct ocfs2_cached_dealloc_ctxt *dealloc,
+			      enum ocfs2_extent_tree_type et_type);
+int ocfs2_remove_extent(struct inode *inode, struct buffer_head *root_bh,
 			u32 cpos, u32 len, handle_t *handle,
 			struct ocfs2_alloc_context *meta_ac,
-			struct ocfs2_cached_dealloc_ctxt *dealloc);
+			struct ocfs2_cached_dealloc_ctxt *dealloc,
+			enum ocfs2_extent_tree_type et_type);
 int ocfs2_num_free_extents(struct ocfs2_super *osb,
 			   struct inode *inode,
-			   struct buffer_head *bh);
+			   struct buffer_head *root_bh,
+			   enum ocfs2_extent_tree_type et_type);
+
 /*
  * how many new metadata chunks would an allocation need at maximum?
  *
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index ceeb60d..e992bd7 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1268,7 +1268,8 @@ static int ocfs2_write_cluster(struct address_space *mapping,
 	} else if (unwritten) {
 		ret = ocfs2_mark_extent_written(inode, wc->w_di_bh,
 						wc->w_handle, cpos, 1, phys,
-						meta_ac, &wc->w_dealloc);
+						meta_ac, &wc->w_dealloc,
+						OCFS2_DINODE_EXTENT);
 		if (ret < 0) {
 			mlog_errno(ret);
 			goto out;
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 5e8cd6d..8c10158 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -1307,7 +1307,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 	 * related blocks have been journaled already.
 	 */
 	ret = ocfs2_insert_extent(osb, handle, dir, di_bh, 0, blkno, len, 0,
-				  NULL);
+				  NULL, OCFS2_DINODE_EXTENT);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -1333,7 +1333,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 		blkno = ocfs2_clusters_to_blocks(dir->i_sb, bit_off);
 
 		ret = ocfs2_insert_extent(osb, handle, dir, di_bh, 1, blkno,
-					  len, 0, NULL);
+					  len, 0, NULL, OCFS2_DINODE_EXTENT);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -1476,7 +1476,8 @@ static int ocfs2_extend_dir(struct ocfs2_super *osb,
 	if (dir_i_size == ocfs2_clusters_to_bytes(sb, OCFS2_I(dir)->ip_clusters)) {
 		spin_unlock(&OCFS2_I(dir)->ip_lock);
 		num_free_extents = ocfs2_num_free_extents(osb, dir,
-							  parent_fe_bh);
+							  parent_fe_bh,
+							  OCFS2_DINODE_EXTENT);
 		if (num_free_extents < 0) {
 			status = num_free_extents;
 			mlog_errno(status);
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index a75a1a5..35ff947 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -521,7 +521,8 @@ int ocfs2_do_extend_allocation(struct ocfs2_super *osb,
 	if (mark_unwritten)
 		flags = OCFS2_EXT_UNWRITTEN;
 
-	free_extents = ocfs2_num_free_extents(osb, inode, fe_bh);
+	free_extents = ocfs2_num_free_extents(osb, inode, fe_bh,
+					      OCFS2_DINODE_EXTENT);
 	if (free_extents < 0) {
 		status = free_extents;
 		mlog_errno(status);
@@ -570,7 +571,7 @@ int ocfs2_do_extend_allocation(struct ocfs2_super *osb,
 	     num_bits, bit_off, (unsigned long long)OCFS2_I(inode)->ip_blkno);
 	status = ocfs2_insert_extent(osb, handle, inode, fe_bh,
 				     *logical_offset, block, num_bits,
-				     flags, meta_ac);
+				     flags, meta_ac, OCFS2_DINODE_EXTENT);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
@@ -630,7 +631,8 @@ int ocfs2_lock_allocators(struct inode *inode, struct buffer_head *di_bh,
 	     (unsigned long long)OCFS2_I(inode)->ip_blkno, (long long)i_size_read(inode),
 	     le32_to_cpu(di->i_clusters), clusters_to_add, extents_to_split);
 
-	num_free_extents = ocfs2_num_free_extents(osb, inode, di_bh);
+	num_free_extents = ocfs2_num_free_extents(osb, inode, di_bh,
+						  OCFS2_DINODE_EXTENT);
 	if (num_free_extents < 0) {
 		ret = num_free_extents;
 		mlog_errno(ret);
@@ -1424,7 +1426,7 @@ static int __ocfs2_remove_inode_range(struct inode *inode,
 	}
 
 	ret = ocfs2_remove_extent(inode, di_bh, cpos, len, handle, meta_ac,
-				  dealloc);
+				  dealloc, OCFS2_DINODE_EXTENT);
 	if (ret) {
 		mlog_errno(ret);
 		goto out_commit;
-- 
1.5.3.GIT
