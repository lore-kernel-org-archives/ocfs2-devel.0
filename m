From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:16:06 -0800
Subject: [Ocfs2-devel] [PATCH 19/40] ocfs2: __ocfs2_rotate_tree_left()
	doesn't need struct inode.
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-20-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

It already has struct ocfs2_extent_tree, which has the caching info.  So
we don't need to pass it struct inode.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 2dc0334..0816bb7 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -2713,24 +2713,24 @@ out:
 	return ret;
 }
 
-static int __ocfs2_rotate_tree_left(struct inode *inode,
-				    handle_t *handle, int orig_credits,
+static int __ocfs2_rotate_tree_left(handle_t *handle,
+				    struct ocfs2_extent_tree *et,
+				    int orig_credits,
 				    struct ocfs2_path *path,
 				    struct ocfs2_cached_dealloc_ctxt *dealloc,
-				    struct ocfs2_path **empty_extent_path,
-				    struct ocfs2_extent_tree *et)
+				    struct ocfs2_path **empty_extent_path)
 {
 	int ret, subtree_root, deleted;
 	u32 right_cpos;
 	struct ocfs2_path *left_path = NULL;
 	struct ocfs2_path *right_path = NULL;
+	struct super_block *sb = ocfs2_metadata_cache_get_super(et->et_ci);
 
 	BUG_ON(!ocfs2_is_empty_extent(&(path_leaf_el(path)->l_recs[0])));
 
 	*empty_extent_path = NULL;
 
-	ret = ocfs2_find_cpos_for_right_leaf(inode->i_sb, path,
-					     &right_cpos);
+	ret = ocfs2_find_cpos_for_right_leaf(sb, path, &right_cpos);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -2779,7 +2779,7 @@ static int __ocfs2_rotate_tree_left(struct inode *inode,
 		 * Caller might still want to make changes to the
 		 * tree root, so re-add it to the journal here.
 		 */
-		ret = ocfs2_path_bh_journal_access(handle, INODE_CACHE(inode),
+		ret = ocfs2_path_bh_journal_access(handle, et->et_ci,
 						   left_path, 0);
 		if (ret) {
 			mlog_errno(ret);
@@ -2815,7 +2815,7 @@ static int __ocfs2_rotate_tree_left(struct inode *inode,
 
 		ocfs2_mv_path(left_path, right_path);
 
-		ret = ocfs2_find_cpos_for_right_leaf(inode->i_sb, left_path,
+		ret = ocfs2_find_cpos_for_right_leaf(sb, left_path,
 						     &right_cpos);
 		if (ret) {
 			mlog_errno(ret);
@@ -3024,8 +3024,8 @@ rightmost_no_delete:
 	 * and restarting from there.
 	 */
 try_rotate:
-	ret = __ocfs2_rotate_tree_left(inode, handle, orig_credits, path,
-				       dealloc, &restart_path, et);
+	ret = __ocfs2_rotate_tree_left(handle, et, orig_credits, path,
+				       dealloc, &restart_path);
 	if (ret && ret != -EAGAIN) {
 		mlog_errno(ret);
 		goto out;
@@ -3035,9 +3035,9 @@ try_rotate:
 		tmp_path = restart_path;
 		restart_path = NULL;
 
-		ret = __ocfs2_rotate_tree_left(inode, handle, orig_credits,
+		ret = __ocfs2_rotate_tree_left(handle, et, orig_credits,
 					       tmp_path, dealloc,
-					       &restart_path, et);
+					       &restart_path);
 		if (ret && ret != -EAGAIN) {
 			mlog_errno(ret);
 			goto out;
-- 
1.5.6.5
