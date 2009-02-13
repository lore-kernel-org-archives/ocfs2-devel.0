From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:16:08 -0800
Subject: [Ocfs2-devel] [PATCH 21/40] ocfs2: ocfs2_merge_rec_left/right() no
	longer need struct inode.
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-22-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Drop it from the parameters - they already have ocfs2_extent_list.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c |   54 ++++++++++++++++++++++++------------------------------
 1 files changed, 24 insertions(+), 30 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 6cfd1ca..c43243b 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -3087,7 +3087,7 @@ static void ocfs2_cleanup_merge(struct ocfs2_extent_list *el,
 	}
 }
 
-static int ocfs2_get_right_path(struct inode *inode,
+static int ocfs2_get_right_path(struct ocfs2_extent_tree *et,
 				struct ocfs2_path *left_path,
 				struct ocfs2_path **ret_right_path)
 {
@@ -3104,8 +3104,8 @@ static int ocfs2_get_right_path(struct inode *inode,
 	left_el = path_leaf_el(left_path);
 	BUG_ON(left_el->l_next_free_rec != left_el->l_count);
 
-	ret = ocfs2_find_cpos_for_right_leaf(inode->i_sb, left_path,
-					     &right_cpos);
+	ret = ocfs2_find_cpos_for_right_leaf(ocfs2_metadata_cache_get_super(et->et_ci),
+					     left_path, &right_cpos);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -3121,7 +3121,7 @@ static int ocfs2_get_right_path(struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_find_path(INODE_CACHE(inode), right_path, right_cpos);
+	ret = ocfs2_find_path(et->et_ci, right_path, right_cpos);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -3141,8 +3141,7 @@ out:
  * For index == l_count - 1, the "next" means the 1st extent rec of the
  * next extent block.
  */
-static int ocfs2_merge_rec_right(struct inode *inode,
-				 struct ocfs2_path *left_path,
+static int ocfs2_merge_rec_right(struct ocfs2_path *left_path,
 				 handle_t *handle,
 				 struct ocfs2_extent_tree *et,
 				 struct ocfs2_extent_rec *split_rec,
@@ -3165,7 +3164,7 @@ static int ocfs2_merge_rec_right(struct inode *inode,
 	if (index == le16_to_cpu(el->l_next_free_rec) - 1 &&
 	    le16_to_cpu(el->l_next_free_rec) == le16_to_cpu(el->l_count)) {
 		/* we meet with a cross extent block merge. */
-		ret = ocfs2_get_right_path(inode, left_path, &right_path);
+		ret = ocfs2_get_right_path(et, left_path, &right_path);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -3262,7 +3261,7 @@ out:
 	return ret;
 }
 
-static int ocfs2_get_left_path(struct inode *inode,
+static int ocfs2_get_left_path(struct ocfs2_extent_tree *et,
 			       struct ocfs2_path *right_path,
 			       struct ocfs2_path **ret_left_path)
 {
@@ -3275,7 +3274,7 @@ static int ocfs2_get_left_path(struct inode *inode,
 	/* This function shouldn't be called for non-trees. */
 	BUG_ON(right_path->p_tree_depth == 0);
 
-	ret = ocfs2_find_cpos_for_left_leaf(inode->i_sb,
+	ret = ocfs2_find_cpos_for_left_leaf(ocfs2_metadata_cache_get_super(et->et_ci),
 					    right_path, &left_cpos);
 	if (ret) {
 		mlog_errno(ret);
@@ -3292,7 +3291,7 @@ static int ocfs2_get_left_path(struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_find_path(INODE_CACHE(inode), left_path, left_cpos);
+	ret = ocfs2_find_path(et->et_ci, left_path, left_cpos);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -3315,12 +3314,11 @@ out:
  * remove the rightmost leaf extent block in the right_path and change
  * the right path to indicate the new rightmost path.
  */
-static int ocfs2_merge_rec_left(struct inode *inode,
-				struct ocfs2_path *right_path,
+static int ocfs2_merge_rec_left(struct ocfs2_path *right_path,
 				handle_t *handle,
+				struct ocfs2_extent_tree *et,
 				struct ocfs2_extent_rec *split_rec,
 				struct ocfs2_cached_dealloc_ctxt *dealloc,
-				struct ocfs2_extent_tree *et,
 				int index)
 {
 	int ret, i, subtree_index = 0, has_empty_extent = 0;
@@ -3338,7 +3336,7 @@ static int ocfs2_merge_rec_left(struct inode *inode,
 	right_rec = &el->l_recs[index];
 	if (index == 0) {
 		/* we meet with a cross extent block merge. */
-		ret = ocfs2_get_left_path(inode, right_path, &left_path);
+		ret = ocfs2_get_left_path(et, right_path, &left_path);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -3368,7 +3366,7 @@ static int ocfs2_merge_rec_left(struct inode *inode,
 		root_bh = left_path->p_node[subtree_index].bh;
 		BUG_ON(root_bh != right_path->p_node[subtree_index].bh);
 
-		ret = ocfs2_path_bh_journal_access(handle, INODE_CACHE(inode), right_path,
+		ret = ocfs2_path_bh_journal_access(handle, et->et_ci, right_path,
 						   subtree_index);
 		if (ret) {
 			mlog_errno(ret);
@@ -3377,14 +3375,14 @@ static int ocfs2_merge_rec_left(struct inode *inode,
 
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
@@ -3397,7 +3395,7 @@ static int ocfs2_merge_rec_left(struct inode *inode,
 			has_empty_extent = 1;
 	}
 
-	ret = ocfs2_path_bh_journal_access(handle, INODE_CACHE(inode), right_path,
+	ret = ocfs2_path_bh_journal_access(handle, et->et_ci, right_path,
 					   path_num_items(right_path) - 1);
 	if (ret) {
 		mlog_errno(ret);
@@ -3416,7 +3414,8 @@ static int ocfs2_merge_rec_left(struct inode *inode,
 
 	le32_add_cpu(&right_rec->e_cpos, split_clusters);
 	le64_add_cpu(&right_rec->e_blkno,
-		     ocfs2_clusters_to_blocks(inode->i_sb, split_clusters));
+		     ocfs2_clusters_to_blocks(ocfs2_metadata_cache_get_super(et->et_ci),
+					      split_clusters));
 	le16_add_cpu(&right_rec->e_leaf_clusters, -split_clusters);
 
 	ocfs2_cleanup_merge(el, index);
@@ -3514,8 +3513,7 @@ static int ocfs2_try_to_merge_extent(struct inode *inode,
 		 * prevoius extent block. It is more efficient and easier
 		 * if we do merge_right first and merge_left later.
 		 */
-		ret = ocfs2_merge_rec_right(inode, path,
-					    handle, et, split_rec,
+		ret = ocfs2_merge_rec_right(path, handle, et, split_rec,
 					    split_index);
 		if (ret) {
 			mlog_errno(ret);
@@ -3540,10 +3538,8 @@ static int ocfs2_try_to_merge_extent(struct inode *inode,
 		 * Note that we don't pass split_rec here on purpose -
 		 * we've merged it into the rec already.
 		 */
-		ret = ocfs2_merge_rec_left(inode, path,
-					   handle, rec,
-					   dealloc, et,
-					   split_index);
+		ret = ocfs2_merge_rec_left(path, handle, et, rec,
+					   dealloc, split_index);
 
 		if (ret) {
 			mlog_errno(ret);
@@ -3567,17 +3563,15 @@ static int ocfs2_try_to_merge_extent(struct inode *inode,
 		 * the record on the left (hence the left merge).
 		 */
 		if (ctxt->c_contig_type == CONTIG_RIGHT) {
-			ret = ocfs2_merge_rec_left(inode,
-						   path,
-						   handle, split_rec,
-						   dealloc, et,
+			ret = ocfs2_merge_rec_left(path, handle, et,
+						   split_rec, dealloc,
 						   split_index);
 			if (ret) {
 				mlog_errno(ret);
 				goto out;
 			}
 		} else {
-			ret = ocfs2_merge_rec_right(inode, path, handle,
+			ret = ocfs2_merge_rec_right(path, handle,
 						    et, split_rec,
 						    split_index);
 			if (ret) {
-- 
1.5.6.5
