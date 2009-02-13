From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:16:00 -0800
Subject: [Ocfs2-devel] [PATCH 13/40] ocfs2: Get inode out of
	ocfs2_rotate_subtree_root_right().
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-14-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Pass the ocfs2_extent_list down through ocfs2_rotate_tree_right() and
get rid of struct inode in ocfs2_rotate_subtree_root_right().

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c |   37 +++++++++++++++++++------------------
 1 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 7209463..94a7980 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -1931,8 +1931,8 @@ static void ocfs2_complete_edge_insert(handle_t *handle,
 		mlog_errno(ret);
 }
 
-static int ocfs2_rotate_subtree_right(struct inode *inode,
-				      handle_t *handle,
+static int ocfs2_rotate_subtree_right(handle_t *handle,
+				      struct ocfs2_extent_tree *et,
 				      struct ocfs2_path *left_path,
 				      struct ocfs2_path *right_path,
 				      int subtree_index)
@@ -1948,10 +1948,10 @@ static int ocfs2_rotate_subtree_right(struct inode *inode,
 	left_el = path_leaf_el(left_path);
 
 	if (left_el->l_next_free_rec != left_el->l_count) {
-		ocfs2_error(inode->i_sb,
+		ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
 			    "Inode %llu has non-full interior leaf node %llu"
 			    "(next free = %u)",
-			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
+			    (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
 			    (unsigned long long)left_leaf_bh->b_blocknr,
 			    le16_to_cpu(left_el->l_next_free_rec));
 		return -EROFS;
@@ -1967,7 +1967,7 @@ static int ocfs2_rotate_subtree_right(struct inode *inode,
 	root_bh = left_path->p_node[subtree_index].bh;
 	BUG_ON(root_bh != right_path->p_node[subtree_index].bh);
 
-	ret = ocfs2_path_bh_journal_access(handle, INODE_CACHE(inode), right_path,
+	ret = ocfs2_path_bh_journal_access(handle, et->et_ci, right_path,
 					   subtree_index);
 	if (ret) {
 		mlog_errno(ret);
@@ -1975,14 +1975,14 @@ static int ocfs2_rotate_subtree_right(struct inode *inode,
 	}
 
 	for(i = subtree_index + 1; i < path_num_items(right_path); i++) {
-		ret = ocfs2_path_bh_journal_access(handle, INODE_CACHE(inode),
+		ret = ocfs2_path_bh_journal_access(handle, et->et_ci,
 						   right_path, i);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
 		}
 
-		ret = ocfs2_path_bh_journal_access(handle, INODE_CACHE(inode),
+		ret = ocfs2_path_bh_journal_access(handle, et->et_ci,
 						   left_path, i);
 		if (ret) {
 			mlog_errno(ret);
@@ -1996,7 +1996,7 @@ static int ocfs2_rotate_subtree_right(struct inode *inode,
 	/* This is a code error, not a disk corruption. */
 	mlog_bug_on_msg(!right_el->l_next_free_rec, "Inode %llu: Rotate fails "
 			"because rightmost leaf block %llu is empty\n",
-			(unsigned long long)OCFS2_I(inode)->ip_blkno,
+			(unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
 			(unsigned long long)right_leaf_bh->b_blocknr);
 
 	ocfs2_create_empty_extent(right_el);
@@ -2194,8 +2194,8 @@ static int ocfs2_leftmost_rec_contains(struct ocfs2_extent_list *el, u32 cpos)
  *   *ret_left_path will contain a valid path which can be passed to
  *   ocfs2_insert_path().
  */
-static int ocfs2_rotate_tree_right(struct inode *inode,
-				   handle_t *handle,
+static int ocfs2_rotate_tree_right(struct inode *inode, handle_t *handle,
+				   struct ocfs2_extent_tree *et,
 				   enum ocfs2_split_type split,
 				   u32 insert_cpos,
 				   struct ocfs2_path *right_path,
@@ -2204,6 +2204,7 @@ static int ocfs2_rotate_tree_right(struct inode *inode,
 	int ret, start, orig_credits = handle->h_buffer_credits;
 	u32 cpos;
 	struct ocfs2_path *left_path = NULL;
+	struct super_block *sb = ocfs2_metadata_cache_get_super(et->et_ci);
 
 	*ret_left_path = NULL;
 
@@ -2214,7 +2215,7 @@ static int ocfs2_rotate_tree_right(struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_find_cpos_for_left_leaf(inode->i_sb, right_path, &cpos);
+	ret = ocfs2_find_cpos_for_left_leaf(sb, right_path, &cpos);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -2252,7 +2253,7 @@ static int ocfs2_rotate_tree_right(struct inode *inode,
 		mlog(0, "Rotating a tree: ins. cpos: %u, left path cpos: %u\n",
 		     insert_cpos, cpos);
 
-		ret = ocfs2_find_path(INODE_CACHE(inode), left_path, cpos);
+		ret = ocfs2_find_path(et->et_ci, left_path, cpos);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -2260,10 +2261,11 @@ static int ocfs2_rotate_tree_right(struct inode *inode,
 
 		mlog_bug_on_msg(path_leaf_bh(left_path) ==
 				path_leaf_bh(right_path),
-				"Inode %lu: error during insert of %u "
+				"Owner %llu: error during insert of %u "
 				"(left path cpos %u) results in two identical "
 				"paths ending at %llu\n",
-				inode->i_ino, insert_cpos, cpos,
+				(unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
+				insert_cpos, cpos,
 				(unsigned long long)
 				path_leaf_bh(left_path)->b_blocknr);
 
@@ -2303,7 +2305,7 @@ static int ocfs2_rotate_tree_right(struct inode *inode,
 			goto out;
 		}
 
-		ret = ocfs2_rotate_subtree_right(inode, handle, left_path,
+		ret = ocfs2_rotate_subtree_right(handle, et, left_path,
 						 right_path, start);
 		if (ret) {
 			mlog_errno(ret);
@@ -2335,8 +2337,7 @@ static int ocfs2_rotate_tree_right(struct inode *inode,
 		 */
 		ocfs2_mv_path(right_path, left_path);
 
-		ret = ocfs2_find_cpos_for_left_leaf(inode->i_sb, right_path,
-						    &cpos);
+		ret = ocfs2_find_cpos_for_left_leaf(sb, right_path, &cpos);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -4103,7 +4104,7 @@ static int ocfs2_do_insert_extent(struct inode *inode,
 	 * can wind up skipping both of these two special cases...
 	 */
 	if (rotate) {
-		ret = ocfs2_rotate_tree_right(inode, handle, type->ins_split,
+		ret = ocfs2_rotate_tree_right(inode, handle, et, type->ins_split,
 					      le32_to_cpu(insert_rec->e_cpos),
 					      right_path, &left_path);
 		if (ret) {
-- 
1.5.6.5
