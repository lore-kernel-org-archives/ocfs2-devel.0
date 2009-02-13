From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:16:01 -0800
Subject: [Ocfs2-devel] [PATCH 14/40] ocfs2: Pass ocfs2_extent_tree to
	ocfs2_get_subtree_root()
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-15-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Get rid of the inode argument.  Use extent_tree instead.  This means a
few more functions have to pass an extent_tree around.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c |   52 +++++++++++++++++++++++++++-------------------------
 1 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 94a7980..d2cc623 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -1561,7 +1561,7 @@ set_and_inc:
  *
  * The array index of the subtree root is passed back.
  */
-static int ocfs2_find_subtree_root(struct inode *inode,
+static int ocfs2_find_subtree_root(struct ocfs2_extent_tree *et,
 				   struct ocfs2_path *left,
 				   struct ocfs2_path *right)
 {
@@ -1579,10 +1579,10 @@ static int ocfs2_find_subtree_root(struct inode *inode,
 		 * The caller didn't pass two adjacent paths.
 		 */
 		mlog_bug_on_msg(i > left->p_tree_depth,
-				"Inode %lu, left depth %u, right depth %u\n"
+				"Owner %llu, left depth %u, right depth %u\n"
 				"left leaf blk %llu, right leaf blk %llu\n",
-				inode->i_ino, left->p_tree_depth,
-				right->p_tree_depth,
+				(unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
+				left->p_tree_depth, right->p_tree_depth,
 				(unsigned long long)path_leaf_bh(left)->b_blocknr,
 				(unsigned long long)path_leaf_bh(right)->b_blocknr);
 	} while (left->p_node[i].bh->b_blocknr ==
@@ -2291,7 +2291,7 @@ static int ocfs2_rotate_tree_right(struct inode *inode, handle_t *handle,
 			goto out_ret_path;
 		}
 
-		start = ocfs2_find_subtree_root(inode, left_path, right_path);
+		start = ocfs2_find_subtree_root(et, left_path, right_path);
 
 		mlog(0, "Subtree root at index %d (blk %llu, depth %d)\n",
 		     start,
@@ -2773,7 +2773,7 @@ static int __ocfs2_rotate_tree_left(struct inode *inode,
 			goto out;
 		}
 
-		subtree_root = ocfs2_find_subtree_root(inode, left_path,
+		subtree_root = ocfs2_find_subtree_root(et, left_path,
 						       right_path);
 
 		mlog(0, "Subtree root at index %d (blk %llu, depth %d)\n",
@@ -2908,7 +2908,7 @@ static int ocfs2_remove_rightmost_path(struct inode *inode, handle_t *handle,
 			goto out;
 		}
 
-		subtree_index = ocfs2_find_subtree_root(inode, left_path, path);
+		subtree_index = ocfs2_find_subtree_root(et, left_path, path);
 
 		ocfs2_unlink_subtree(handle, et, left_path, path,
 				     subtree_index, dealloc);
@@ -3159,6 +3159,7 @@ out:
 static int ocfs2_merge_rec_right(struct inode *inode,
 				 struct ocfs2_path *left_path,
 				 handle_t *handle,
+				 struct ocfs2_extent_tree *et,
 				 struct ocfs2_extent_rec *split_rec,
 				 int index)
 {
@@ -3198,8 +3199,8 @@ static int ocfs2_merge_rec_right(struct inode *inode,
 		       le16_to_cpu(left_rec->e_leaf_clusters) !=
 		       le32_to_cpu(right_rec->e_cpos));
 
-		subtree_index = ocfs2_find_subtree_root(inode,
-							left_path, right_path);
+		subtree_index = ocfs2_find_subtree_root(et, left_path,
+							right_path);
 
 		ret = ocfs2_extend_rotate_transaction(handle, subtree_index,
 						      handle->h_buffer_credits,
@@ -3212,7 +3213,7 @@ static int ocfs2_merge_rec_right(struct inode *inode,
 		root_bh = left_path->p_node[subtree_index].bh;
 		BUG_ON(root_bh != right_path->p_node[subtree_index].bh);
 
-		ret = ocfs2_path_bh_journal_access(handle, INODE_CACHE(inode), right_path,
+		ret = ocfs2_path_bh_journal_access(handle, et->et_ci, right_path,
 						   subtree_index);
 		if (ret) {
 			mlog_errno(ret);
@@ -3221,14 +3222,14 @@ static int ocfs2_merge_rec_right(struct inode *inode,
 
 		for (i = subtree_index + 1;
 		     i < path_num_items(right_path); i++) {
-			ret = ocfs2_path_bh_journal_access(handle, INODE_CACHE(inode),
+			ret = ocfs2_path_bh_journal_access(handle, et->et_ci,
 							   right_path, i);
 			if (ret) {
 				mlog_errno(ret);
 				goto out;
 			}
 
-			ret = ocfs2_path_bh_journal_access(handle, INODE_CACHE(inode),
+			ret = ocfs2_path_bh_journal_access(handle, et->et_ci,
 							   left_path, i);
 			if (ret) {
 				mlog_errno(ret);
@@ -3241,7 +3242,7 @@ static int ocfs2_merge_rec_right(struct inode *inode,
 		right_rec = &el->l_recs[index + 1];
 	}
 
-	ret = ocfs2_path_bh_journal_access(handle, INODE_CACHE(inode), left_path,
+	ret = ocfs2_path_bh_journal_access(handle, et->et_ci, left_path,
 					   path_num_items(left_path) - 1);
 	if (ret) {
 		mlog_errno(ret);
@@ -3252,7 +3253,8 @@ static int ocfs2_merge_rec_right(struct inode *inode,
 
 	le32_add_cpu(&right_rec->e_cpos, -split_clusters);
 	le64_add_cpu(&right_rec->e_blkno,
-		     -ocfs2_clusters_to_blocks(inode->i_sb, split_clusters));
+		     -ocfs2_clusters_to_blocks(ocfs2_metadata_cache_get_super(et->et_ci),
+					       split_clusters));
 	le16_add_cpu(&right_rec->e_leaf_clusters, split_clusters);
 
 	ocfs2_cleanup_merge(el, index);
@@ -3367,8 +3369,8 @@ static int ocfs2_merge_rec_left(struct inode *inode,
 		       le16_to_cpu(left_rec->e_leaf_clusters) !=
 		       le32_to_cpu(split_rec->e_cpos));
 
-		subtree_index = ocfs2_find_subtree_root(inode,
-							left_path, right_path);
+		subtree_index = ocfs2_find_subtree_root(et, left_path,
+							right_path);
 
 		ret = ocfs2_extend_rotate_transaction(handle, subtree_index,
 						      handle->h_buffer_credits,
@@ -3529,7 +3531,7 @@ static int ocfs2_try_to_merge_extent(struct inode *inode,
 		 * if we do merge_right first and merge_left later.
 		 */
 		ret = ocfs2_merge_rec_right(inode, path,
-					    handle, split_rec,
+					    handle, et, split_rec,
 					    split_index);
 		if (ret) {
 			mlog_errno(ret);
@@ -3593,9 +3595,8 @@ static int ocfs2_try_to_merge_extent(struct inode *inode,
 				goto out;
 			}
 		} else {
-			ret = ocfs2_merge_rec_right(inode,
-						    path,
-						    handle, split_rec,
+			ret = ocfs2_merge_rec_right(inode, path, handle,
+						    et, split_rec,
 						    split_index);
 			if (ret) {
 				mlog_errno(ret);
@@ -3953,6 +3954,7 @@ static void ocfs2_split_record(struct inode *inode,
  */
 static int ocfs2_insert_path(struct inode *inode,
 			     handle_t *handle,
+			     struct ocfs2_extent_tree *et,
 			     struct ocfs2_path *left_path,
 			     struct ocfs2_path *right_path,
 			     struct ocfs2_extent_rec *insert_rec,
@@ -3978,7 +3980,7 @@ static int ocfs2_insert_path(struct inode *inode,
 			goto out;
 		}
 
-		ret = ocfs2_journal_access_path(INODE_CACHE(inode), handle, left_path);
+		ret = ocfs2_journal_access_path(et->et_ci, handle, left_path);
 		if (ret < 0) {
 			mlog_errno(ret);
 			goto out;
@@ -3989,7 +3991,7 @@ static int ocfs2_insert_path(struct inode *inode,
 	 * Pass both paths to the journal. The majority of inserts
 	 * will be touching all components anyway.
 	 */
-	ret = ocfs2_journal_access_path(INODE_CACHE(inode), handle, right_path);
+	ret = ocfs2_journal_access_path(et->et_ci, handle, right_path);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out;
@@ -4029,7 +4031,7 @@ static int ocfs2_insert_path(struct inode *inode,
 		 *
 		 * XXX: Should we extend the transaction here?
 		 */
-		subtree_index = ocfs2_find_subtree_root(inode, left_path,
+		subtree_index = ocfs2_find_subtree_root(et, left_path,
 							right_path);
 		ocfs2_complete_edge_insert(handle, left_path, right_path,
 					   subtree_index);
@@ -4132,7 +4134,7 @@ static int ocfs2_do_insert_extent(struct inode *inode,
 		}
 	}
 
-	ret = ocfs2_insert_path(inode, handle, left_path, right_path,
+	ret = ocfs2_insert_path(inode, handle, et, left_path, right_path,
 				insert_rec, type);
 	if (ret) {
 		mlog_errno(ret);
@@ -5207,7 +5209,7 @@ static int ocfs2_truncate_rec(struct inode *inode, handle_t *handle,
 	if (left_path) {
 		int subtree_index;
 
-		subtree_index = ocfs2_find_subtree_root(inode, left_path, path);
+		subtree_index = ocfs2_find_subtree_root(et, left_path, path);
 		ocfs2_complete_edge_insert(handle, left_path, path,
 					   subtree_index);
 	}
-- 
1.5.6.5
