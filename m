From: Tao Ma <tao.ma@oracle.com>
Date: Tue Jan 29 22:21:12 2008
Subject: [Ocfs2-devel] [PATCH 1/2] Add support for cross extent block
	merge.V2
In-Reply-To: <20080130060924.GA9243@tma-pc1.cn.oracle.com>
Message-ID: <20080130062105.GA9282@tma-pc1.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_merge_rec_left, when we find the merge extent is "CONTIG_RIGHT"
with the first extent record of the next extent block, we will merge it to
the next extent block and change all the related extent blocks accordingly.

In ocfs2_merge_rec_right, when we find the merge extent is "CONTIG_LEFT"
with the last extent record of the previous extent block, we will merge
it to the prevoius extent block and change all the related extent blocks
accordingly.

As for CONTIG_LEFTRIGHT, we will handle CONTIG_RIGHT first so that when
the index is zero, the merge process will be more efficient and easier.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c |  366 ++++++++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 325 insertions(+), 41 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 23c8cda..0fea024 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -1450,6 +1450,8 @@ static void ocfs2_adjust_root_records(struct ocfs2_extent_list *root_el,
  *   - When our insert into the right path leaf is at the leftmost edge
  *     and requires an update of the path immediately to it's left. This
  *     can occur at the end of some types of rotation and appending inserts.
+ *   - When we've adjusted the last extent record in the left path leaf and the
+ *     1st extent record in the right path leaf during cross extent block merge.
  */
 static void ocfs2_complete_edge_insert(struct inode *inode, handle_t *handle,
 				       struct ocfs2_path *left_path,
@@ -2712,24 +2714,147 @@ static void ocfs2_cleanup_merge(struct ocfs2_extent_list *el,
 	}
 }
 
+static int ocfs2_get_right_path(struct inode *inode,
+				struct ocfs2_path *left_path,
+				struct ocfs2_path **ret_right_path)
+{
+	int ret;
+	u32 right_cpos;
+	struct ocfs2_path *right_path = NULL;
+	struct ocfs2_extent_list *left_el;
+
+	*ret_right_path = NULL;
+
+	/* This function shouldn't be called for non-trees. */
+	BUG_ON(left_path->p_tree_depth == 0);
+
+	left_el = path_leaf_el(left_path);
+	BUG_ON(left_el->l_next_free_rec != left_el->l_count);
+
+	ret = ocfs2_find_cpos_for_right_leaf(inode->i_sb, left_path,
+					     &right_cpos);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	/* This function shouldn't be called for the rightmost leaf. */
+	BUG_ON(right_cpos == 0);
+
+	right_path = ocfs2_new_path(path_root_bh(left_path),
+				    path_root_el(left_path));
+	if (!right_path) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_find_path(inode, right_path, right_cpos);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	*ret_right_path = right_path;
+out:
+	if (ret)
+		ocfs2_free_path(right_path);
+	return ret;
+}
+
 /*
  * Remove split_rec clusters from the record at index and merge them
- * onto the beginning of the record at index + 1.
+ * onto the beginning of the record "next" to it.
+ * For index < l_count - 1, the next means the extent rec@index + 1.
+ * For index == l_count - 1, the "next" means the 1st extent rec of the
+ * next extent block.
  */
-static int ocfs2_merge_rec_right(struct inode *inode, struct buffer_head *bh,
-				handle_t *handle,
-				struct ocfs2_extent_rec *split_rec,
-				struct ocfs2_extent_list *el, int index)
+static int ocfs2_merge_rec_right(struct inode *inode,
+				 struct ocfs2_path *left_path,
+				 handle_t *handle,
+				 struct ocfs2_extent_rec *split_rec,
+				 int index)
 {
-	int ret;
+	int ret, next_free, i;
 	unsigned int split_clusters = le16_to_cpu(split_rec->e_leaf_clusters);
 	struct ocfs2_extent_rec *left_rec;
 	struct ocfs2_extent_rec *right_rec;
+	struct ocfs2_extent_list *right_el;
+	struct ocfs2_path *right_path = NULL;
+	int subtree_index = 0;
+	struct ocfs2_extent_list *el = path_leaf_el(left_path);
+	struct buffer_head *bh = path_leaf_bh(left_path);
+	struct buffer_head *root_bh = NULL;
 
 	BUG_ON(index >= le16_to_cpu(el->l_next_free_rec));
-
 	left_rec = &el->l_recs[index];
-	right_rec = &el->l_recs[index + 1];
+
+	if (index == le16_to_cpu(el->l_next_free_rec - 1) &&
+	    le16_to_cpu(el->l_next_free_rec) == le16_to_cpu(el->l_count)) {
+		/* we meet with a cross extent block merge. */
+		ret = ocfs2_get_right_path(inode, left_path, &right_path);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		right_el = path_leaf_el(right_path);
+		next_free = le16_to_cpu(right_el->l_next_free_rec);
+		BUG_ON(next_free <= 0);
+		right_rec = &right_el->l_recs[0];
+		if (ocfs2_is_empty_extent(right_rec)) {
+			BUG_ON(le16_to_cpu(next_free) <= 1);
+			right_rec = &right_el->l_recs[1];
+		}
+
+		BUG_ON(le32_to_cpu(left_rec->e_cpos) +
+		       le16_to_cpu(left_rec->e_leaf_clusters) !=
+		       le32_to_cpu(right_rec->e_cpos));
+
+		subtree_index = ocfs2_find_subtree_root(inode,
+							left_path, right_path);
+
+		ret = ocfs2_extend_rotate_transaction(handle, subtree_index,
+						      handle->h_buffer_credits,
+						      right_path);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		root_bh = left_path->p_node[subtree_index].bh;
+		BUG_ON(root_bh != right_path->p_node[subtree_index].bh);
+
+		ret = ocfs2_journal_access(handle, inode, root_bh,
+					   OCFS2_JOURNAL_ACCESS_WRITE);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		for (i = subtree_index + 1;
+		     i < path_num_items(right_path); i++) {
+			ret = ocfs2_journal_access(handle, inode,
+						   right_path->p_node[i].bh,
+						   OCFS2_JOURNAL_ACCESS_WRITE);
+			if (ret) {
+				mlog_errno(ret);
+				goto out;
+			}
+
+			ret = ocfs2_journal_access(handle, inode,
+						   left_path->p_node[i].bh,
+						   OCFS2_JOURNAL_ACCESS_WRITE);
+			if (ret) {
+				mlog_errno(ret);
+				goto out;
+			}
+		}
+
+	} else {
+		BUG_ON(index == le16_to_cpu(el->l_next_free_rec) - 1);
+		right_rec = &el->l_recs[index + 1];
+	}
 
 	ret = ocfs2_journal_access(handle, inode, bh,
 				   OCFS2_JOURNAL_ACCESS_WRITE);
@@ -2751,30 +2876,156 @@ static int ocfs2_merge_rec_right(struct inode *inode, struct buffer_head *bh,
 	if (ret)
 		mlog_errno(ret);
 
+	if (right_path) {
+		ret = ocfs2_journal_dirty(handle, path_leaf_bh(right_path));
+		if (ret)
+			mlog_errno(ret);
+
+		ocfs2_complete_edge_insert(inode, handle, left_path,
+					   right_path, subtree_index);
+	}
+out:
+	if (right_path)
+		ocfs2_free_path(right_path);
+	return ret;
+}
+
+static int ocfs2_get_left_path(struct inode *inode,
+			       struct ocfs2_path *right_path,
+			       struct ocfs2_path **ret_left_path)
+{
+	int ret;
+	u32 left_cpos;
+	struct ocfs2_path *left_path = NULL;
+
+	*ret_left_path = NULL;
+
+	/* This function shouldn't be called for non-trees. */
+	BUG_ON(right_path->p_tree_depth == 0);
+
+	ret = ocfs2_find_cpos_for_left_leaf(inode->i_sb,
+					    right_path, &left_cpos);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	/* This function shouldn't be called for the leftmost leaf. */
+	BUG_ON(left_cpos == 0);
+
+	left_path = ocfs2_new_path(path_root_bh(right_path),
+				   path_root_el(right_path));
+	if (!left_path) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_find_path(inode, left_path, left_cpos);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	*ret_left_path = left_path;
 out:
+	if (ret)
+		ocfs2_free_path(left_path);
 	return ret;
 }
 
 /*
  * Remove split_rec clusters from the record at index and merge them
- * onto the tail of the record at index - 1.
+ * onto the tail of the record "before" it.
+ * For index > 0, the "before" means the extent rec at index - 1.
+ *
+ * For index == 0, the "before" means the last record of the previous
+ * extent block. And there is also a situation that we may need to
+ * remove the rightmost leaf extent block in the right_path and change
+ * the right path to indicate the new rightmost path.
  */
-static int ocfs2_merge_rec_left(struct inode *inode, struct buffer_head *bh,
+static int ocfs2_merge_rec_left(struct inode *inode,
+				struct ocfs2_path *right_path,
 				handle_t *handle,
 				struct ocfs2_extent_rec *split_rec,
-				struct ocfs2_extent_list *el, int index)
+				struct ocfs2_cached_dealloc_ctxt *dealloc,
+				int index)
 {
-	int ret, has_empty_extent = 0;
+	int ret, i, subtree_index = 0, has_empty_extent = 0;
 	unsigned int split_clusters = le16_to_cpu(split_rec->e_leaf_clusters);
 	struct ocfs2_extent_rec *left_rec;
 	struct ocfs2_extent_rec *right_rec;
+	struct ocfs2_extent_list *el = path_leaf_el(right_path);
+	struct buffer_head *bh = path_leaf_bh(right_path);
+	struct buffer_head *root_bh = NULL;
+	struct ocfs2_path *left_path = NULL;
+	struct ocfs2_extent_list *left_el;
 
-	BUG_ON(index <= 0);
+	BUG_ON(index < 0);
 
-	left_rec = &el->l_recs[index - 1];
 	right_rec = &el->l_recs[index];
-	if (ocfs2_is_empty_extent(&el->l_recs[0]))
-		has_empty_extent = 1;
+	if (index == 0) {
+		/* we meet with a cross extent block merge. */
+		ret = ocfs2_get_left_path(inode, right_path, &left_path);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		left_el = path_leaf_el(left_path);
+		BUG_ON(le16_to_cpu(left_el->l_next_free_rec) !=
+		       le16_to_cpu(left_el->l_count));
+
+		left_rec = &left_el->l_recs[
+				le16_to_cpu(left_el->l_next_free_rec) - 1];
+		BUG_ON(le32_to_cpu(left_rec->e_cpos) +
+		       le16_to_cpu(left_rec->e_leaf_clusters) !=
+		       le32_to_cpu(split_rec->e_cpos));
+
+		subtree_index = ocfs2_find_subtree_root(inode,
+							left_path, right_path);
+
+		ret = ocfs2_extend_rotate_transaction(handle, subtree_index,
+						      handle->h_buffer_credits,
+						      left_path);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		root_bh = left_path->p_node[subtree_index].bh;
+		BUG_ON(root_bh != right_path->p_node[subtree_index].bh);
+
+		ret = ocfs2_journal_access(handle, inode, root_bh,
+					   OCFS2_JOURNAL_ACCESS_WRITE);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		for (i = subtree_index + 1;
+		     i < path_num_items(right_path); i++) {
+			ret = ocfs2_journal_access(handle, inode,
+						   right_path->p_node[i].bh,
+						   OCFS2_JOURNAL_ACCESS_WRITE);
+			if (ret) {
+				mlog_errno(ret);
+				goto out;
+			}
+
+			ret = ocfs2_journal_access(handle, inode,
+						   left_path->p_node[i].bh,
+						   OCFS2_JOURNAL_ACCESS_WRITE);
+			if (ret) {
+				mlog_errno(ret);
+				goto out;
+			}
+		}
+	} else {
+		left_rec = &el->l_recs[index - 1];
+		if (ocfs2_is_empty_extent(&el->l_recs[0]))
+			has_empty_extent = 1;
+	}
 
 	ret = ocfs2_journal_access(handle, inode, bh,
 				   OCFS2_JOURNAL_ACCESS_WRITE);
@@ -2790,9 +3041,8 @@ static int ocfs2_merge_rec_left(struct inode *inode, struct buffer_head *bh,
 		*left_rec = *split_rec;
 
 		has_empty_extent = 0;
-	} else {
+	} else
 		le16_add_cpu(&left_rec->e_leaf_clusters, split_clusters);
-	}
 
 	le32_add_cpu(&right_rec->e_cpos, split_clusters);
 	le64_add_cpu(&right_rec->e_blkno,
@@ -2805,13 +3055,44 @@ static int ocfs2_merge_rec_left(struct inode *inode, struct buffer_head *bh,
 	if (ret)
 		mlog_errno(ret);
 
+	if (left_path) {
+		ret = ocfs2_journal_dirty(handle, path_leaf_bh(left_path));
+		if (ret)
+			mlog_errno(ret);
+
+		/*
+		 * In the situation that the right_rec is empty and the extent
+		 * block is empty also,  ocfs2_complete_edge_insert can't handle
+		 * it and we need to delete the right extent block.
+		 */
+		if (le16_to_cpu(right_rec->e_leaf_clusters) == 0 &&
+		    le16_to_cpu(el->l_next_free_rec) == 1) {
+
+			ret = ocfs2_remove_rightmost_path(inode, handle,
+							  right_path, dealloc);
+			if (ret) {
+				mlog_errno(ret);
+				goto out;
+			}
+
+			/* Now the rightmost extent block has been deleted.
+			 * So we use the new rightmost path.
+			 */
+			ocfs2_mv_path(right_path, left_path);
+			left_path = NULL;
+		} else
+			ocfs2_complete_edge_insert(inode, handle, left_path,
+						   right_path, subtree_index);
+	}
 out:
+	if (left_path)
+		ocfs2_free_path(left_path);
 	return ret;
 }
 
 static int ocfs2_try_to_merge_extent(struct inode *inode,
 				     handle_t *handle,
-				     struct ocfs2_path *left_path,
+				     struct ocfs2_path *path,
 				     int split_index,
 				     struct ocfs2_extent_rec *split_rec,
 				     struct ocfs2_cached_dealloc_ctxt *dealloc,
@@ -2819,7 +3100,7 @@ static int ocfs2_try_to_merge_extent(struct inode *inode,
 
 {
 	int ret = 0;
-	struct ocfs2_extent_list *el = path_leaf_el(left_path);
+	struct ocfs2_extent_list *el = path_leaf_el(path);
 	struct ocfs2_extent_rec *rec = &el->l_recs[split_index];
 
 	BUG_ON(ctxt->c_contig_type == CONTIG_NONE);
@@ -2832,7 +3113,7 @@ static int ocfs2_try_to_merge_extent(struct inode *inode,
 		 * extents - having more than one in a leaf is
 		 * illegal.
 		 */
-		ret = ocfs2_rotate_tree_left(inode, handle, left_path,
+		ret = ocfs2_rotate_tree_left(inode, handle, path,
 					     dealloc);
 		if (ret) {
 			mlog_errno(ret);
@@ -2847,7 +3128,6 @@ static int ocfs2_try_to_merge_extent(struct inode *inode,
 		 * Left-right contig implies this.
 		 */
 		BUG_ON(!ctxt->c_split_covers_rec);
-		BUG_ON(split_index == 0);
 
 		/*
 		 * Since the leftright insert always covers the entire
@@ -2858,9 +3138,14 @@ static int ocfs2_try_to_merge_extent(struct inode *inode,
 		 * Since the adding of an empty extent shifts
 		 * everything back to the right, there's no need to
 		 * update split_index here.
+		 *
+		 * When the split_index is zero, we need to merge it to the
+		 * prevoius extent block. It is more efficient and easier
+		 * if we do merge_right first and merge_left later.
 		 */
-		ret = ocfs2_merge_rec_left(inode, path_leaf_bh(left_path),
-					   handle, split_rec, el, split_index);
+		ret = ocfs2_merge_rec_right(inode, path,
+					    handle, split_rec,
+					    split_index);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -2871,32 +3156,30 @@ static int ocfs2_try_to_merge_extent(struct inode *inode,
 		 */
 		BUG_ON(!ocfs2_is_empty_extent(&el->l_recs[0]));
 
-		/*
-		 * The left merge left us with an empty extent, remove
-		 * it.
-		 */
-		ret = ocfs2_rotate_tree_left(inode, handle, left_path, dealloc);
+		/* The merge left us with an empty extent, remove it. */
+		ret = ocfs2_rotate_tree_left(inode, handle, path, dealloc);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
 		}
-		split_index--;
+
 		rec = &el->l_recs[split_index];
 
 		/*
 		 * Note that we don't pass split_rec here on purpose -
-		 * we've merged it into the left side.
+		 * we've merged it into the rec already.
 		 */
-		ret = ocfs2_merge_rec_right(inode, path_leaf_bh(left_path),
-					    handle, rec, el, split_index);
+		ret = ocfs2_merge_rec_left(inode, path,
+					   handle, rec,
+					   dealloc,
+					   split_index);
+
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
 		}
 
-		BUG_ON(!ocfs2_is_empty_extent(&el->l_recs[0]));
-
-		ret = ocfs2_rotate_tree_left(inode, handle, left_path,
+		ret = ocfs2_rotate_tree_left(inode, handle, path,
 					     dealloc);
 		/*
 		 * Error from this last rotate is not critical, so
@@ -2915,8 +3198,9 @@ static int ocfs2_try_to_merge_extent(struct inode *inode,
 		 */
 		if (ctxt->c_contig_type == CONTIG_RIGHT) {
 			ret = ocfs2_merge_rec_left(inode,
-						   path_leaf_bh(left_path),
-						   handle, split_rec, el,
+						   path,
+						   handle, split_rec,
+						   dealloc,
 						   split_index);
 			if (ret) {
 				mlog_errno(ret);
@@ -2924,8 +3208,8 @@ static int ocfs2_try_to_merge_extent(struct inode *inode,
 			}
 		} else {
 			ret = ocfs2_merge_rec_right(inode,
-						    path_leaf_bh(left_path),
-						    handle, split_rec, el,
+						    path,
+						    handle, split_rec,
 						    split_index);
 			if (ret) {
 				mlog_errno(ret);
@@ -2938,7 +3222,7 @@ static int ocfs2_try_to_merge_extent(struct inode *inode,
 			 * The merge may have left an empty extent in
 			 * our leaf. Try to rotate it away.
 			 */
-			ret = ocfs2_rotate_tree_left(inode, handle, left_path,
+			ret = ocfs2_rotate_tree_left(inode, handle, path,
 						     dealloc);
 			if (ret)
 				mlog_errno(ret);
-- 
1.5.3.GIT
