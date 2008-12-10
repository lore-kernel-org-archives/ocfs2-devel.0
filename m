From: Joel Becker <joel.becker@oracle.com>
Date: Tue,  9 Dec 2008 17:09:44 -0800
Subject: [Ocfs2-devel] [PATCH 07/18] ocfs2: Wrap up the common use cases of
	ocfs2_new_path().
In-Reply-To: <1228871395-10273-1-git-send-email-joel.becker@oracle.com>
References: <1228871395-10273-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1228871395-10273-8-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The majority of ocfs2_new_path() calls are:

	ocfs2_new_path(path_root_bh(otherpath),
		       path_root_el(otherpath));

Let's call that ocfs2_new_path_from_path().  The rest do similar things
from struct ocfs2_extent_tree.  Let's call those
ocfs2_new_path_from_et().  This will make the next change easier.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c |   48 ++++++++++++++++++++++++------------------------
 1 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 6b27f74..c22ff49 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -532,6 +532,16 @@ static struct ocfs2_path *ocfs2_new_path(struct buffer_head *root_bh,
 	return path;
 }
 
+static struct ocfs2_path *ocfs2_new_path_from_path(struct ocfs2_path *path)
+{
+	return ocfs2_new_path(path_root_bh(path), path_root_el(path));
+}
+
+static struct ocfs2_path *ocfs2_new_path_from_et(struct ocfs2_extent_tree *et)
+{
+	return ocfs2_new_path(et->et_root_bh, et->et_root_el);
+}
+
 /*
  * Convenience function to journal all components in a path.
  */
@@ -2150,8 +2160,7 @@ static int ocfs2_rotate_tree_right(struct inode *inode,
 
 	*ret_left_path = NULL;
 
-	left_path = ocfs2_new_path(path_root_bh(right_path),
-				   path_root_el(right_path));
+	left_path = ocfs2_new_path_from_path(right_path);
 	if (!left_path) {
 		ret = -ENOMEM;
 		mlog_errno(ret);
@@ -2692,8 +2701,7 @@ static int __ocfs2_rotate_tree_left(struct inode *inode,
 		goto out;
 	}
 
-	left_path = ocfs2_new_path(path_root_bh(path),
-				   path_root_el(path));
+	left_path = ocfs2_new_path_from_path(path);
 	if (!left_path) {
 		ret = -ENOMEM;
 		mlog_errno(ret);
@@ -2702,8 +2710,7 @@ static int __ocfs2_rotate_tree_left(struct inode *inode,
 
 	ocfs2_cp_path(left_path, path);
 
-	right_path = ocfs2_new_path(path_root_bh(path),
-				    path_root_el(path));
+	right_path = ocfs2_new_path_from_path(path);
 	if (!right_path) {
 		ret = -ENOMEM;
 		mlog_errno(ret);
@@ -2833,8 +2840,7 @@ static int ocfs2_remove_rightmost_path(struct inode *inode, handle_t *handle,
 		 * We have a path to the left of this one - it needs
 		 * an update too.
 		 */
-		left_path = ocfs2_new_path(path_root_bh(path),
-					   path_root_el(path));
+		left_path = ocfs2_new_path_from_path(path);
 		if (!left_path) {
 			ret = -ENOMEM;
 			mlog_errno(ret);
@@ -3075,8 +3081,7 @@ static int ocfs2_get_right_path(struct inode *inode,
 	/* This function shouldn't be called for the rightmost leaf. */
 	BUG_ON(right_cpos == 0);
 
-	right_path = ocfs2_new_path(path_root_bh(left_path),
-				    path_root_el(left_path));
+	right_path = ocfs2_new_path_from_path(left_path);
 	if (!right_path) {
 		ret = -ENOMEM;
 		mlog_errno(ret);
@@ -3247,8 +3252,7 @@ static int ocfs2_get_left_path(struct inode *inode,
 	/* This function shouldn't be called for the leftmost leaf. */
 	BUG_ON(left_cpos == 0);
 
-	left_path = ocfs2_new_path(path_root_bh(right_path),
-				   path_root_el(right_path));
+	left_path = ocfs2_new_path_from_path(right_path);
 	if (!left_path) {
 		ret = -ENOMEM;
 		mlog_errno(ret);
@@ -3780,8 +3784,7 @@ static int ocfs2_append_rec_to_path(struct inode *inode, handle_t *handle,
 		 * leftmost leaf.
 		 */
 		if (left_cpos) {
-			left_path = ocfs2_new_path(path_root_bh(right_path),
-						   path_root_el(right_path));
+			left_path = ocfs2_new_path_from_path(right_path);
 			if (!left_path) {
 				ret = -ENOMEM;
 				mlog_errno(ret);
@@ -4018,7 +4021,7 @@ static int ocfs2_do_insert_extent(struct inode *inode,
 		goto out_update_clusters;
 	}
 
-	right_path = ocfs2_new_path(et->et_root_bh, et->et_root_el);
+	right_path = ocfs2_new_path_from_et(et);
 	if (!right_path) {
 		ret = -ENOMEM;
 		mlog_errno(ret);
@@ -4130,8 +4133,7 @@ ocfs2_figure_merge_contig_type(struct inode *inode, struct ocfs2_path *path,
 			goto out;
 
 		if (left_cpos != 0) {
-			left_path = ocfs2_new_path(path_root_bh(path),
-						   path_root_el(path));
+			left_path = ocfs2_new_path_from_path(path);
 			if (!left_path)
 				goto out;
 
@@ -4187,8 +4189,7 @@ ocfs2_figure_merge_contig_type(struct inode *inode, struct ocfs2_path *path,
 		if (right_cpos == 0)
 			goto out;
 
-		right_path = ocfs2_new_path(path_root_bh(path),
-					    path_root_el(path));
+		right_path = ocfs2_new_path_from_path(path);
 		if (!right_path)
 			goto out;
 
@@ -4381,7 +4382,7 @@ static int ocfs2_figure_insert_type(struct inode *inode,
 		return 0;
 	}
 
-	path = ocfs2_new_path(et->et_root_bh, et->et_root_el);
+	path = ocfs2_new_path_from_et(et);
 	if (!path) {
 		ret = -ENOMEM;
 		mlog_errno(ret);
@@ -4910,7 +4911,7 @@ int ocfs2_mark_extent_written(struct inode *inode,
 	if (et->et_ops == &ocfs2_dinode_et_ops)
 		ocfs2_extent_map_trunc(inode, 0);
 
-	left_path = ocfs2_new_path(et->et_root_bh, et->et_root_el);
+	left_path = ocfs2_new_path_from_et(et);
 	if (!left_path) {
 		ret = -ENOMEM;
 		mlog_errno(ret);
@@ -5082,8 +5083,7 @@ static int ocfs2_truncate_rec(struct inode *inode, handle_t *handle,
 		}
 
 		if (left_cpos && le16_to_cpu(el->l_next_free_rec) > 1) {
-			left_path = ocfs2_new_path(path_root_bh(path),
-						   path_root_el(path));
+			left_path = ocfs2_new_path_from_path(path);
 			if (!left_path) {
 				ret = -ENOMEM;
 				mlog_errno(ret);
@@ -5192,7 +5192,7 @@ int ocfs2_remove_extent(struct inode *inode,
 
 	ocfs2_extent_map_trunc(inode, 0);
 
-	path = ocfs2_new_path(et->et_root_bh, et->et_root_el);
+	path = ocfs2_new_path_from_et(et);
 	if (!path) {
 		ret = -ENOMEM;
 		mlog_errno(ret);
-- 
1.5.6.5
