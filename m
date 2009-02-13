From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:16:07 -0800
Subject: [Ocfs2-devel] [PATCH 20/40] ocfs2: ocfs2_rotate_tree_left() no
	longer needs struct inode.
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-21-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

It already gets ocfs2_extent_tree, so we can just use that.  This chains
to the same modification for ocfs2_remove_rightmost_path() and
ocfs2_rotate_rightmost_leaf_left().

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c |   56 +++++++++++++++++++++++++----------------------------
 1 files changed, 26 insertions(+), 30 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 0816bb7..6cfd1ca 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -2685,8 +2685,8 @@ out:
 	return ret;
 }
 
-static int ocfs2_rotate_rightmost_leaf_left(struct inode *inode,
-					    handle_t *handle,
+static int ocfs2_rotate_rightmost_leaf_left(handle_t *handle,
+					    struct ocfs2_extent_tree *et,
 					    struct ocfs2_path *path)
 {
 	int ret;
@@ -2696,7 +2696,7 @@ static int ocfs2_rotate_rightmost_leaf_left(struct inode *inode,
 	if (!ocfs2_is_empty_extent(&el->l_recs[0]))
 		return 0;
 
-	ret = ocfs2_path_bh_journal_access(handle, INODE_CACHE(inode), path,
+	ret = ocfs2_path_bh_journal_access(handle, et->et_ci, path,
 					   path_num_items(path) - 1);
 	if (ret) {
 		mlog_errno(ret);
@@ -2830,10 +2830,10 @@ out:
 	return ret;
 }
 
-static int ocfs2_remove_rightmost_path(struct inode *inode, handle_t *handle,
+static int ocfs2_remove_rightmost_path(handle_t *handle,
+				struct ocfs2_extent_tree *et,
 				struct ocfs2_path *path,
-				struct ocfs2_cached_dealloc_ctxt *dealloc,
-				struct ocfs2_extent_tree *et)
+				struct ocfs2_cached_dealloc_ctxt *dealloc)
 {
 	int ret, subtree_index;
 	u32 cpos;
@@ -2907,7 +2907,7 @@ static int ocfs2_remove_rightmost_path(struct inode *inode, handle_t *handle,
 		 * 'path' is also the leftmost path which
 		 * means it must be the only one. This gets
 		 * handled differently because we want to
-		 * revert the inode back to having extents
+		 * revert the root back to having extents
 		 * in-line.
 		 */
 		ocfs2_unlink_path(handle, et, dealloc, path, 1);
@@ -2943,10 +2943,10 @@ out:
  * the rightmost tree leaf record is removed so the caller is
  * responsible for detecting and correcting that.
  */
-static int ocfs2_rotate_tree_left(struct inode *inode, handle_t *handle,
+static int ocfs2_rotate_tree_left(handle_t *handle,
+				  struct ocfs2_extent_tree *et,
 				  struct ocfs2_path *path,
-				  struct ocfs2_cached_dealloc_ctxt *dealloc,
-				  struct ocfs2_extent_tree *et)
+				  struct ocfs2_cached_dealloc_ctxt *dealloc)
 {
 	int ret, orig_credits = handle->h_buffer_credits;
 	struct ocfs2_path *tmp_path = NULL, *restart_path = NULL;
@@ -2963,8 +2963,7 @@ rightmost_no_delete:
 		 * Inline extents. This is trivially handled, so do
 		 * it up front.
 		 */
-		ret = ocfs2_rotate_rightmost_leaf_left(inode, handle,
-						       path);
+		ret = ocfs2_rotate_rightmost_leaf_left(handle, et, path);
 		if (ret)
 			mlog_errno(ret);
 		goto out;
@@ -2980,7 +2979,7 @@ rightmost_no_delete:
 	 *
 	 *  1) is handled via ocfs2_rotate_rightmost_leaf_left()
 	 *  2a) we need the left branch so that we can update it with the unlink
-	 *  2b) we need to bring the inode back to inline extents.
+	 *  2b) we need to bring the root back to inline extents.
 	 */
 
 	eb = (struct ocfs2_extent_block *)path_leaf_bh(path)->b_data;
@@ -2996,9 +2995,9 @@ rightmost_no_delete:
 
 		if (le16_to_cpu(el->l_next_free_rec) == 0) {
 			ret = -EIO;
-			ocfs2_error(inode->i_sb,
-				    "Inode %llu has empty extent block at %llu",
-				    (unsigned long long)OCFS2_I(inode)->ip_blkno,
+			ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
+				    "Owner %llu has empty extent block at %llu",
+				    (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
 				    (unsigned long long)le64_to_cpu(eb->h_blkno));
 			goto out;
 		}
@@ -3012,8 +3011,8 @@ rightmost_no_delete:
 		 * nonempty list.
 		 */
 
-		ret = ocfs2_remove_rightmost_path(inode, handle, path,
-						  dealloc, et);
+		ret = ocfs2_remove_rightmost_path(handle, et, path,
+						  dealloc);
 		if (ret)
 			mlog_errno(ret);
 		goto out;
@@ -3439,9 +3438,9 @@ static int ocfs2_merge_rec_left(struct inode *inode,
 		if (le16_to_cpu(right_rec->e_leaf_clusters) == 0 &&
 		    le16_to_cpu(el->l_next_free_rec) == 1) {
 
-			ret = ocfs2_remove_rightmost_path(inode, handle,
+			ret = ocfs2_remove_rightmost_path(handle, et,
 							  right_path,
-							  dealloc, et);
+							  dealloc);
 			if (ret) {
 				mlog_errno(ret);
 				goto out;
@@ -3486,8 +3485,7 @@ static int ocfs2_try_to_merge_extent(struct inode *inode,
 		 * extents - having more than one in a leaf is
 		 * illegal.
 		 */
-		ret = ocfs2_rotate_tree_left(inode, handle, path,
-					     dealloc, et);
+		ret = ocfs2_rotate_tree_left(handle, et, path, dealloc);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -3530,8 +3528,7 @@ static int ocfs2_try_to_merge_extent(struct inode *inode,
 		BUG_ON(!ocfs2_is_empty_extent(&el->l_recs[0]));
 
 		/* The merge left us with an empty extent, remove it. */
-		ret = ocfs2_rotate_tree_left(inode, handle, path,
-					     dealloc, et);
+		ret = ocfs2_rotate_tree_left(handle, et, path, dealloc);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -3553,8 +3550,7 @@ static int ocfs2_try_to_merge_extent(struct inode *inode,
 			goto out;
 		}
 
-		ret = ocfs2_rotate_tree_left(inode, handle, path,
-					     dealloc, et);
+		ret = ocfs2_rotate_tree_left(handle, et, path, dealloc);
 		/*
 		 * Error from this last rotate is not critical, so
 		 * print but don't bubble it up.
@@ -3595,8 +3591,8 @@ static int ocfs2_try_to_merge_extent(struct inode *inode,
 			 * The merge may have left an empty extent in
 			 * our leaf. Try to rotate it away.
 			 */
-			ret = ocfs2_rotate_tree_left(inode, handle, path,
-						     dealloc, et);
+			ret = ocfs2_rotate_tree_left(handle, et, path,
+						     dealloc);
 			if (ret)
 				mlog_errno(ret);
 			ret = 0;
@@ -5071,7 +5067,7 @@ static int ocfs2_truncate_rec(struct inode *inode, handle_t *handle,
 	struct ocfs2_extent_block *eb;
 
 	if (ocfs2_is_empty_extent(&el->l_recs[0]) && index > 0) {
-		ret = ocfs2_rotate_tree_left(inode, handle, path, dealloc, et);
+		ret = ocfs2_rotate_tree_left(handle, et, path, dealloc);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -5202,7 +5198,7 @@ static int ocfs2_truncate_rec(struct inode *inode, handle_t *handle,
 
 	ocfs2_journal_dirty(handle, path_leaf_bh(path));
 
-	ret = ocfs2_rotate_tree_left(inode, handle, path, dealloc, et);
+	ret = ocfs2_rotate_tree_left(handle, et, path, dealloc);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
-- 
1.5.6.5
