From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:16:05 -0800
Subject: [Ocfs2-devel] [PATCH 18/40] ocfs2: ocfs2_rotate_subtree_left()
	doesn't need struct inode.
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-19-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

It already has struct ocfs2_extent_tree, which has the caching info.  So
we don't need to pass it struct inode.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index ada1049..2dc0334 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -2449,13 +2449,13 @@ static void ocfs2_unlink_subtree(handle_t *handle,
 			  subtree_index + 1);
 }
 
-static int ocfs2_rotate_subtree_left(struct inode *inode, handle_t *handle,
+static int ocfs2_rotate_subtree_left(handle_t *handle,
+				     struct ocfs2_extent_tree *et,
 				     struct ocfs2_path *left_path,
 				     struct ocfs2_path *right_path,
 				     int subtree_index,
 				     struct ocfs2_cached_dealloc_ctxt *dealloc,
-				     int *deleted,
-				     struct ocfs2_extent_tree *et)
+				     int *deleted)
 {
 	int ret, i, del_right_subtree = 0, right_has_empty = 0;
 	struct buffer_head *root_bh, *et_root_bh = path_root_bh(right_path);
@@ -2491,7 +2491,7 @@ static int ocfs2_rotate_subtree_left(struct inode *inode, handle_t *handle,
 			return -EAGAIN;
 
 		if (le16_to_cpu(right_leaf_el->l_next_free_rec) > 1) {
-			ret = ocfs2_journal_access_eb(handle, INODE_CACHE(inode),
+			ret = ocfs2_journal_access_eb(handle, et->et_ci,
 						      path_leaf_bh(right_path),
 						      OCFS2_JOURNAL_ACCESS_WRITE);
 			if (ret) {
@@ -2526,7 +2526,7 @@ static int ocfs2_rotate_subtree_left(struct inode *inode, handle_t *handle,
 	 */
 	BUG_ON(right_has_empty && !del_right_subtree);
 
-	ret = ocfs2_path_bh_journal_access(handle, INODE_CACHE(inode), right_path,
+	ret = ocfs2_path_bh_journal_access(handle, et->et_ci, right_path,
 					   subtree_index);
 	if (ret) {
 		mlog_errno(ret);
@@ -2534,14 +2534,14 @@ static int ocfs2_rotate_subtree_left(struct inode *inode, handle_t *handle,
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
@@ -2786,9 +2786,9 @@ static int __ocfs2_rotate_tree_left(struct inode *inode,
 			goto out;
 		}
 
-		ret = ocfs2_rotate_subtree_left(inode, handle, left_path,
+		ret = ocfs2_rotate_subtree_left(handle, et, left_path,
 						right_path, subtree_root,
-						dealloc, &deleted, et);
+						dealloc, &deleted);
 		if (ret == -EAGAIN) {
 			/*
 			 * The rotation has to temporarily stop due to
-- 
1.5.6.5
