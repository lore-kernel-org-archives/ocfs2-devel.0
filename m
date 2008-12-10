From: Joel Becker <joel.becker@oracle.com>
Date: Tue,  9 Dec 2008 17:09:45 -0800
Subject: [Ocfs2-devel] [PATCH 08/18] ocfs2: Use metadata-specific
	ocfs2_journal_access_*() functions.
In-Reply-To: <1228871395-10273-1-git-send-email-joel.becker@oracle.com>
References: <1228871395-10273-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1228871395-10273-9-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The per-metadata-type ocfs2_journal_access_*() functions hook up jbd2
commit triggers and allow us to compute metadata ecc right before the
buffers are written out.  This commit provides ecc for inodes, extent
blocks, group descriptors, and quota blocks.  It is not safe to use
extened attributes and metaecc at the same time yet.

The ocfs2_extent_tree and ocfs2_path abstractions in alloc.c both hide
the type of block at their root.  Before, it didn't matter, but now the
root block must use the appropriate ocfs2_journal_access_*() function.
To keep this abstract, the structures now have a pointer to the matching
journal_access function and a wrapper call to call it.

Since we pass around the journal_access functions.  Let's typedef them
in ocfs2.h.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c      |  230 +++++++++++++++++++++++++++++--------------------
 fs/ocfs2/alloc.h      |    5 +-
 fs/ocfs2/aops.c       |    8 +-
 fs/ocfs2/dir.c        |   38 +++++----
 fs/ocfs2/file.c       |   16 ++--
 fs/ocfs2/inode.c      |   17 ++--
 fs/ocfs2/journal.c    |    2 +
 fs/ocfs2/journal.h    |    3 +-
 fs/ocfs2/localalloc.c |   16 ++--
 fs/ocfs2/namei.c      |   38 ++++----
 fs/ocfs2/ocfs2.h      |    4 +
 fs/ocfs2/resize.c     |   16 ++--
 fs/ocfs2/suballoc.c   |   58 +++++++------
 13 files changed, 257 insertions(+), 194 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index c22ff49..3c8d866 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -298,11 +298,13 @@ static struct ocfs2_extent_tree_operations ocfs2_xattr_tree_et_ops = {
 static void __ocfs2_init_extent_tree(struct ocfs2_extent_tree *et,
 				     struct inode *inode,
 				     struct buffer_head *bh,
+				     ocfs2_journal_access_func access,
 				     void *obj,
 				     struct ocfs2_extent_tree_operations *ops)
 {
 	et->et_ops = ops;
 	et->et_root_bh = bh;
+	et->et_root_journal_access = access;
 	if (!obj)
 		obj = (void *)bh->b_data;
 	et->et_object = obj;
@@ -318,15 +320,16 @@ void ocfs2_init_dinode_extent_tree(struct ocfs2_extent_tree *et,
 				   struct inode *inode,
 				   struct buffer_head *bh)
 {
-	__ocfs2_init_extent_tree(et, inode, bh, NULL, &ocfs2_dinode_et_ops);
+	__ocfs2_init_extent_tree(et, inode, bh, ocfs2_journal_access_di,
+				 NULL, &ocfs2_dinode_et_ops);
 }
 
 void ocfs2_init_xattr_tree_extent_tree(struct ocfs2_extent_tree *et,
 				       struct inode *inode,
 				       struct buffer_head *bh)
 {
-	__ocfs2_init_extent_tree(et, inode, bh, NULL,
-				 &ocfs2_xattr_tree_et_ops);
+	__ocfs2_init_extent_tree(et, inode, bh, ocfs2_journal_access_xb,
+				 NULL, &ocfs2_xattr_tree_et_ops);
 }
 
 void ocfs2_init_xattr_value_extent_tree(struct ocfs2_extent_tree *et,
@@ -334,7 +337,7 @@ void ocfs2_init_xattr_value_extent_tree(struct ocfs2_extent_tree *et,
 					struct buffer_head *bh,
 					struct ocfs2_xattr_value_root *xv)
 {
-	__ocfs2_init_extent_tree(et, inode, bh, xv,
+	__ocfs2_init_extent_tree(et, inode, bh, ocfs2_journal_access, xv,
 				 &ocfs2_xattr_value_et_ops);
 }
 
@@ -356,6 +359,15 @@ static inline void ocfs2_et_update_clusters(struct inode *inode,
 	et->et_ops->eo_update_clusters(inode, et, clusters);
 }
 
+static inline int ocfs2_et_root_journal_access(handle_t *handle,
+					       struct inode *inode,
+					       struct ocfs2_extent_tree *et,
+					       int type)
+{
+	return et->et_root_journal_access(handle, inode, et->et_root_bh,
+					  type);
+}
+
 static inline int ocfs2_et_insert_check(struct inode *inode,
 					struct ocfs2_extent_tree *et,
 					struct ocfs2_extent_rec *rec)
@@ -396,12 +408,14 @@ struct ocfs2_path_item {
 #define OCFS2_MAX_PATH_DEPTH	5
 
 struct ocfs2_path {
-	int			p_tree_depth;
-	struct ocfs2_path_item	p_node[OCFS2_MAX_PATH_DEPTH];
+	int				p_tree_depth;
+	ocfs2_journal_access_func	p_root_access;
+	struct ocfs2_path_item		p_node[OCFS2_MAX_PATH_DEPTH];
 };
 
 #define path_root_bh(_path) ((_path)->p_node[0].bh)
 #define path_root_el(_path) ((_path)->p_node[0].el)
+#define path_root_access(_path)((_path)->p_root_access)
 #define path_leaf_bh(_path) ((_path)->p_node[(_path)->p_tree_depth].bh)
 #define path_leaf_el(_path) ((_path)->p_node[(_path)->p_tree_depth].el)
 #define path_num_items(_path) ((_path)->p_tree_depth + 1)
@@ -434,6 +448,8 @@ static void ocfs2_reinit_path(struct ocfs2_path *path, int keep_root)
 	 */
 	if (keep_root)
 		depth = le16_to_cpu(path_root_el(path)->l_tree_depth);
+	else
+		path_root_access(path) = NULL;
 
 	path->p_tree_depth = depth;
 }
@@ -459,6 +475,7 @@ static void ocfs2_cp_path(struct ocfs2_path *dest, struct ocfs2_path *src)
 
 	BUG_ON(path_root_bh(dest) != path_root_bh(src));
 	BUG_ON(path_root_el(dest) != path_root_el(src));
+	BUG_ON(path_root_access(dest) != path_root_access(src));
 
 	ocfs2_reinit_path(dest, 1);
 
@@ -480,6 +497,7 @@ static void ocfs2_mv_path(struct ocfs2_path *dest, struct ocfs2_path *src)
 	int i;
 
 	BUG_ON(path_root_bh(dest) != path_root_bh(src));
+	BUG_ON(path_root_access(dest) != path_root_access(src));
 
 	for(i = 1; i < OCFS2_MAX_PATH_DEPTH; i++) {
 		brelse(dest->p_node[i].bh);
@@ -515,7 +533,8 @@ static inline void ocfs2_path_insert_eb(struct ocfs2_path *path, int index,
 }
 
 static struct ocfs2_path *ocfs2_new_path(struct buffer_head *root_bh,
-					 struct ocfs2_extent_list *root_el)
+					 struct ocfs2_extent_list *root_el,
+					 ocfs2_journal_access_func access)
 {
 	struct ocfs2_path *path;
 
@@ -527,6 +546,7 @@ static struct ocfs2_path *ocfs2_new_path(struct buffer_head *root_bh,
 		get_bh(root_bh);
 		path_root_bh(path) = root_bh;
 		path_root_el(path) = root_el;
+		path_root_access(path) = access;
 	}
 
 	return path;
@@ -534,12 +554,38 @@ static struct ocfs2_path *ocfs2_new_path(struct buffer_head *root_bh,
 
 static struct ocfs2_path *ocfs2_new_path_from_path(struct ocfs2_path *path)
 {
-	return ocfs2_new_path(path_root_bh(path), path_root_el(path));
+	return ocfs2_new_path(path_root_bh(path), path_root_el(path),
+			      path_root_access(path));
 }
 
 static struct ocfs2_path *ocfs2_new_path_from_et(struct ocfs2_extent_tree *et)
 {
-	return ocfs2_new_path(et->et_root_bh, et->et_root_el);
+	return ocfs2_new_path(et->et_root_bh, et->et_root_el,
+			      et->et_root_journal_access);
+}
+
+/*
+ * Journal the buffer at depth idx.  All idx>0 are extent_blocks,
+ * otherwise it's the root_access function.
+ *
+ * I don't like the way this function's name looks next to
+ * ocfs2_journal_access_path(), but I don't have a better one.
+ */
+static int ocfs2_path_bh_journal_access(handle_t *handle,
+					struct inode *inode,
+					struct ocfs2_path *path,
+					int idx)
+{
+	ocfs2_journal_access_func access = path_root_access(path);
+
+	if (!access)
+		access = ocfs2_journal_access;
+
+	if (idx)
+		access = ocfs2_journal_access_eb;
+
+	return access(handle, inode, path->p_node[idx].bh,
+		      OCFS2_JOURNAL_ACCESS_WRITE);
 }
 
 /*
@@ -554,8 +600,7 @@ static int ocfs2_journal_access_path(struct inode *inode, handle_t *handle,
 		goto out;
 
 	for(i = 0; i < path_num_items(path); i++) {
-		ret = ocfs2_journal_access(handle, inode, path->p_node[i].bh,
-					   OCFS2_JOURNAL_ACCESS_WRITE);
+		ret = ocfs2_path_bh_journal_access(handle, inode, path, i);
 		if (ret < 0) {
 			mlog_errno(ret);
 			goto out;
@@ -708,8 +753,11 @@ static int ocfs2_validate_extent_block(struct super_block *sb,
 	 * local to this block.
 	 */
 	rc = ocfs2_validate_meta_ecc(sb, bh->b_data, &eb->h_check);
-	if (rc)
+	if (rc) {
+		mlog(ML_ERROR, "Checksum failed for extent block %llu\n",
+		     (unsigned long long)bh->b_blocknr);
 		return rc;
+	}
 
 	/*
 	 * Errors after here are fatal.
@@ -842,8 +890,8 @@ static int ocfs2_create_new_meta_bhs(struct ocfs2_super *osb,
 			}
 			ocfs2_set_new_buffer_uptodate(inode, bhs[i]);
 
-			status = ocfs2_journal_access(handle, inode, bhs[i],
-						      OCFS2_JOURNAL_ACCESS_CREATE);
+			status = ocfs2_journal_access_eb(handle, inode, bhs[i],
+							 OCFS2_JOURNAL_ACCESS_CREATE);
 			if (status < 0) {
 				mlog_errno(status);
 				goto bail;
@@ -986,8 +1034,8 @@ static int ocfs2_add_branch(struct ocfs2_super *osb,
 		BUG_ON(!OCFS2_IS_VALID_EXTENT_BLOCK(eb));
 		eb_el = &eb->h_list;
 
-		status = ocfs2_journal_access(handle, inode, bh,
-					      OCFS2_JOURNAL_ACCESS_CREATE);
+		status = ocfs2_journal_access_eb(handle, inode, bh,
+						 OCFS2_JOURNAL_ACCESS_CREATE);
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail;
@@ -1026,21 +1074,21 @@ static int ocfs2_add_branch(struct ocfs2_super *osb,
 	 * journal_dirty erroring as it won't unless we've aborted the
 	 * handle (in which case we would never be here) so reserving
 	 * the write with journal_access is all we need to do. */
-	status = ocfs2_journal_access(handle, inode, *last_eb_bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
+	status = ocfs2_journal_access_eb(handle, inode, *last_eb_bh,
+					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
 	}
-	status = ocfs2_journal_access(handle, inode, et->et_root_bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
+	status = ocfs2_et_root_journal_access(handle, inode, et,
+					      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
 	}
 	if (eb_bh) {
-		status = ocfs2_journal_access(handle, inode, eb_bh,
-					      OCFS2_JOURNAL_ACCESS_WRITE);
+		status = ocfs2_journal_access_eb(handle, inode, eb_bh,
+						 OCFS2_JOURNAL_ACCESS_WRITE);
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail;
@@ -1129,8 +1177,8 @@ static int ocfs2_shift_tree_depth(struct ocfs2_super *osb,
 	eb_el = &eb->h_list;
 	root_el = et->et_root_el;
 
-	status = ocfs2_journal_access(handle, inode, new_eb_bh,
-				      OCFS2_JOURNAL_ACCESS_CREATE);
+	status = ocfs2_journal_access_eb(handle, inode, new_eb_bh,
+					 OCFS2_JOURNAL_ACCESS_CREATE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -1148,8 +1196,8 @@ static int ocfs2_shift_tree_depth(struct ocfs2_super *osb,
 		goto bail;
 	}
 
-	status = ocfs2_journal_access(handle, inode, et->et_root_bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
+	status = ocfs2_et_root_journal_access(handle, inode, et,
+					      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -1918,25 +1966,23 @@ static int ocfs2_rotate_subtree_right(struct inode *inode,
 	root_bh = left_path->p_node[subtree_index].bh;
 	BUG_ON(root_bh != right_path->p_node[subtree_index].bh);
 
-	ret = ocfs2_journal_access(handle, inode, root_bh,
-				   OCFS2_JOURNAL_ACCESS_WRITE);
+	ret = ocfs2_path_bh_journal_access(handle, inode, right_path,
+					   subtree_index);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
 	}
 
 	for(i = subtree_index + 1; i < path_num_items(right_path); i++) {
-		ret = ocfs2_journal_access(handle, inode,
-					   right_path->p_node[i].bh,
-					   OCFS2_JOURNAL_ACCESS_WRITE);
+		ret = ocfs2_path_bh_journal_access(handle, inode,
+						   right_path, i);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
 		}
 
-		ret = ocfs2_journal_access(handle, inode,
-					   left_path->p_node[i].bh,
-					   OCFS2_JOURNAL_ACCESS_WRITE);
+		ret = ocfs2_path_bh_journal_access(handle, inode,
+						   left_path, i);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -2455,9 +2501,9 @@ static int ocfs2_rotate_subtree_left(struct inode *inode, handle_t *handle,
 			return -EAGAIN;
 
 		if (le16_to_cpu(right_leaf_el->l_next_free_rec) > 1) {
-			ret = ocfs2_journal_access(handle, inode,
-						   path_leaf_bh(right_path),
-						   OCFS2_JOURNAL_ACCESS_WRITE);
+			ret = ocfs2_journal_access_eb(handle, inode,
+						      path_leaf_bh(right_path),
+						      OCFS2_JOURNAL_ACCESS_WRITE);
 			if (ret) {
 				mlog_errno(ret);
 				goto out;
@@ -2474,8 +2520,8 @@ static int ocfs2_rotate_subtree_left(struct inode *inode, handle_t *handle,
 		 * We have to update i_last_eb_blk during the meta
 		 * data delete.
 		 */
-		ret = ocfs2_journal_access(handle, inode, et_root_bh,
-					   OCFS2_JOURNAL_ACCESS_WRITE);
+		ret = ocfs2_et_root_journal_access(handle, inode, et,
+						   OCFS2_JOURNAL_ACCESS_WRITE);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -2490,25 +2536,23 @@ static int ocfs2_rotate_subtree_left(struct inode *inode, handle_t *handle,
 	 */
 	BUG_ON(right_has_empty && !del_right_subtree);
 
-	ret = ocfs2_journal_access(handle, inode, root_bh,
-				   OCFS2_JOURNAL_ACCESS_WRITE);
+	ret = ocfs2_path_bh_journal_access(handle, inode, right_path,
+					   subtree_index);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
 	}
 
 	for(i = subtree_index + 1; i < path_num_items(right_path); i++) {
-		ret = ocfs2_journal_access(handle, inode,
-					   right_path->p_node[i].bh,
-					   OCFS2_JOURNAL_ACCESS_WRITE);
+		ret = ocfs2_path_bh_journal_access(handle, inode,
+						   right_path, i);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
 		}
 
-		ret = ocfs2_journal_access(handle, inode,
-					   left_path->p_node[i].bh,
-					   OCFS2_JOURNAL_ACCESS_WRITE);
+		ret = ocfs2_path_bh_journal_access(handle, inode,
+						   left_path, i);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -2653,16 +2697,17 @@ out:
 
 static int ocfs2_rotate_rightmost_leaf_left(struct inode *inode,
 					    handle_t *handle,
-					    struct buffer_head *bh,
-					    struct ocfs2_extent_list *el)
+					    struct ocfs2_path *path)
 {
 	int ret;
+	struct buffer_head *bh = path_leaf_bh(path);
+	struct ocfs2_extent_list *el = path_leaf_el(path);
 
 	if (!ocfs2_is_empty_extent(&el->l_recs[0]))
 		return 0;
 
-	ret = ocfs2_journal_access(handle, inode, bh,
-				   OCFS2_JOURNAL_ACCESS_WRITE);
+	ret = ocfs2_path_bh_journal_access(handle, inode, path,
+					   path_num_items(path) - 1);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -2744,9 +2789,8 @@ static int __ocfs2_rotate_tree_left(struct inode *inode,
 		 * Caller might still want to make changes to the
 		 * tree root, so re-add it to the journal here.
 		 */
-		ret = ocfs2_journal_access(handle, inode,
-					   path_root_bh(left_path),
-					   OCFS2_JOURNAL_ACCESS_WRITE);
+		ret = ocfs2_path_bh_journal_access(handle, inode,
+						   left_path, 0);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -2929,8 +2973,7 @@ rightmost_no_delete:
 		 * it up front.
 		 */
 		ret = ocfs2_rotate_rightmost_leaf_left(inode, handle,
-						       path_leaf_bh(path),
-						       path_leaf_el(path));
+						       path);
 		if (ret)
 			mlog_errno(ret);
 		goto out;
@@ -3164,8 +3207,8 @@ static int ocfs2_merge_rec_right(struct inode *inode,
 		root_bh = left_path->p_node[subtree_index].bh;
 		BUG_ON(root_bh != right_path->p_node[subtree_index].bh);
 
-		ret = ocfs2_journal_access(handle, inode, root_bh,
-					   OCFS2_JOURNAL_ACCESS_WRITE);
+		ret = ocfs2_path_bh_journal_access(handle, inode, right_path,
+						   subtree_index);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -3173,17 +3216,15 @@ static int ocfs2_merge_rec_right(struct inode *inode,
 
 		for (i = subtree_index + 1;
 		     i < path_num_items(right_path); i++) {
-			ret = ocfs2_journal_access(handle, inode,
-						   right_path->p_node[i].bh,
-						   OCFS2_JOURNAL_ACCESS_WRITE);
+			ret = ocfs2_path_bh_journal_access(handle, inode,
+							   right_path, i);
 			if (ret) {
 				mlog_errno(ret);
 				goto out;
 			}
 
-			ret = ocfs2_journal_access(handle, inode,
-						   left_path->p_node[i].bh,
-						   OCFS2_JOURNAL_ACCESS_WRITE);
+			ret = ocfs2_path_bh_journal_access(handle, inode,
+							   left_path, i);
 			if (ret) {
 				mlog_errno(ret);
 				goto out;
@@ -3195,8 +3236,8 @@ static int ocfs2_merge_rec_right(struct inode *inode,
 		right_rec = &el->l_recs[index + 1];
 	}
 
-	ret = ocfs2_journal_access(handle, inode, bh,
-				   OCFS2_JOURNAL_ACCESS_WRITE);
+	ret = ocfs2_path_bh_journal_access(handle, inode, left_path,
+					   path_num_items(left_path) - 1);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -3335,8 +3376,8 @@ static int ocfs2_merge_rec_left(struct inode *inode,
 		root_bh = left_path->p_node[subtree_index].bh;
 		BUG_ON(root_bh != right_path->p_node[subtree_index].bh);
 
-		ret = ocfs2_journal_access(handle, inode, root_bh,
-					   OCFS2_JOURNAL_ACCESS_WRITE);
+		ret = ocfs2_path_bh_journal_access(handle, inode, right_path,
+						   subtree_index);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -3344,17 +3385,15 @@ static int ocfs2_merge_rec_left(struct inode *inode,
 
 		for (i = subtree_index + 1;
 		     i < path_num_items(right_path); i++) {
-			ret = ocfs2_journal_access(handle, inode,
-						   right_path->p_node[i].bh,
-						   OCFS2_JOURNAL_ACCESS_WRITE);
+			ret = ocfs2_path_bh_journal_access(handle, inode,
+							   right_path, i);
 			if (ret) {
 				mlog_errno(ret);
 				goto out;
 			}
 
-			ret = ocfs2_journal_access(handle, inode,
-						   left_path->p_node[i].bh,
-						   OCFS2_JOURNAL_ACCESS_WRITE);
+			ret = ocfs2_path_bh_journal_access(handle, inode,
+							   left_path, i);
 			if (ret) {
 				mlog_errno(ret);
 				goto out;
@@ -3366,8 +3405,8 @@ static int ocfs2_merge_rec_left(struct inode *inode,
 			has_empty_extent = 1;
 	}
 
-	ret = ocfs2_journal_access(handle, inode, bh,
-				   OCFS2_JOURNAL_ACCESS_WRITE);
+	ret = ocfs2_path_bh_journal_access(handle, inode, left_path,
+					   path_num_items(left_path) - 1);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -4009,8 +4048,8 @@ static int ocfs2_do_insert_extent(struct inode *inode,
 
 	el = et->et_root_el;
 
-	ret = ocfs2_journal_access(handle, inode, et->et_root_bh,
-				   OCFS2_JOURNAL_ACCESS_WRITE);
+	ret = ocfs2_et_root_journal_access(handle, inode, et,
+					   OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -4071,8 +4110,8 @@ static int ocfs2_do_insert_extent(struct inode *inode,
 		 * ocfs2_rotate_tree_right() might have extended the
 		 * transaction without re-journaling our tree root.
 		 */
-		ret = ocfs2_journal_access(handle, inode, et->et_root_bh,
-					   OCFS2_JOURNAL_ACCESS_WRITE);
+		ret = ocfs2_et_root_journal_access(handle, inode, et,
+						   OCFS2_JOURNAL_ACCESS_WRITE);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -4594,8 +4633,8 @@ int ocfs2_add_clusters_in_btree(struct ocfs2_super *osb,
 	BUG_ON(num_bits > clusters_to_add);
 
 	/* reserve our write early -- insert_extent may update the inode */
-	status = ocfs2_journal_access(handle, inode, et->et_root_bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
+	status = ocfs2_et_root_journal_access(handle, inode, et,
+					      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
@@ -5347,8 +5386,8 @@ int ocfs2_remove_btree_range(struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_journal_access(handle, inode, et->et_root_bh,
-				   OCFS2_JOURNAL_ACCESS_WRITE);
+	ret = ocfs2_et_root_journal_access(handle, inode, et,
+					   OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -5461,8 +5500,8 @@ int ocfs2_truncate_log_append(struct ocfs2_super *osb,
 		goto bail;
 	}
 
-	status = ocfs2_journal_access(handle, tl_inode, tl_bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
+	status = ocfs2_journal_access_di(handle, tl_inode, tl_bh,
+					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -5523,8 +5562,8 @@ static int ocfs2_replay_truncate_records(struct ocfs2_super *osb,
 	while (i >= 0) {
 		/* Caller has given us at least enough credits to
 		 * update the truncate log dinode */
-		status = ocfs2_journal_access(handle, tl_inode, tl_bh,
-					      OCFS2_JOURNAL_ACCESS_WRITE);
+		status = ocfs2_journal_access_di(handle, tl_inode, tl_bh,
+						 OCFS2_JOURNAL_ACCESS_WRITE);
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail;
@@ -6546,8 +6585,8 @@ static int ocfs2_do_truncate(struct ocfs2_super *osb,
 	}
 
 	if (last_eb_bh) {
-		status = ocfs2_journal_access(handle, inode, last_eb_bh,
-					      OCFS2_JOURNAL_ACCESS_WRITE);
+		status = ocfs2_journal_access_eb(handle, inode, last_eb_bh,
+						 OCFS2_JOURNAL_ACCESS_WRITE);
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail;
@@ -6908,8 +6947,8 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 		goto out_unlock;
 	}
 
-	ret = ocfs2_journal_access(handle, inode, di_bh,
-				   OCFS2_JOURNAL_ACCESS_WRITE);
+	ret = ocfs2_journal_access_di(handle, inode, di_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
 		goto out_commit;
@@ -7043,7 +7082,8 @@ int ocfs2_commit_truncate(struct ocfs2_super *osb,
 	new_highest_cpos = ocfs2_clusters_for_bytes(osb->sb,
 						     i_size_read(inode));
 
-	path = ocfs2_new_path(fe_bh, &di->id2.i_list);
+	path = ocfs2_new_path(fe_bh, &di->id2.i_list,
+			      ocfs2_journal_access_di);
 	if (!path) {
 		status = -ENOMEM;
 		mlog_errno(status);
@@ -7276,8 +7316,8 @@ int ocfs2_truncate_inline(struct inode *inode, struct buffer_head *di_bh,
 		goto out;
 	}
 
-	ret = ocfs2_journal_access(handle, inode, di_bh,
-				   OCFS2_JOURNAL_ACCESS_WRITE);
+	ret = ocfs2_journal_access_di(handle, inode, di_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
 		goto out_commit;
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index 59d37d1..4b6fea2 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -45,7 +45,9 @@
  *
  * ocfs2_extent_tree contains info for the root of the b-tree, it must have a
  * root ocfs2_extent_list and a root_bh so that they can be used in the b-tree
- * functions.
+ * functions.  With metadata ecc, we now call different journal_access
+ * functions for each type of metadata, so it must have the
+ * root_journal_access function.
  * ocfs2_extent_tree_operations abstract the normal operations we do for
  * the root of extent b-tree.
  */
@@ -54,6 +56,7 @@ struct ocfs2_extent_tree {
 	struct ocfs2_extent_tree_operations	*et_ops;
 	struct buffer_head			*et_root_bh;
 	struct ocfs2_extent_list		*et_root_el;
+	ocfs2_journal_access_func		et_root_journal_access;
 	void					*et_object;
 	unsigned int				et_max_leaf_clusters;
 };
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 6b647ec..a067a6c 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1512,8 +1512,8 @@ static int ocfs2_write_begin_inline(struct address_space *mapping,
 		goto out;
 	}
 
-	ret = ocfs2_journal_access(handle, inode, wc->w_di_bh,
-				   OCFS2_JOURNAL_ACCESS_WRITE);
+	ret = ocfs2_journal_access_di(handle, inode, wc->w_di_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		ocfs2_commit_trans(osb, handle);
 
@@ -1740,8 +1740,8 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 	 * We don't want this to fail in ocfs2_write_end(), so do it
 	 * here.
 	 */
-	ret = ocfs2_journal_access(handle, inode, wc->w_di_bh,
-				   OCFS2_JOURNAL_ACCESS_WRITE);
+	ret = ocfs2_journal_access_di(handle, inode, wc->w_di_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
 		goto out_quota;
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 3708fe4..1ab2a3c 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -384,8 +384,8 @@ int ocfs2_update_entry(struct inode *dir, handle_t *handle,
 	 * based directories, so no need to split this up.
 	 */
 
-	ret = ocfs2_journal_access(handle, dir, de_bh,
-				   OCFS2_JOURNAL_ACCESS_WRITE);
+	ret = ocfs2_journal_access_db(handle, dir, de_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -420,8 +420,8 @@ static int __ocfs2_delete_entry(handle_t *handle, struct inode *dir,
 			goto bail;
 		}
 		if (de == de_del)  {
-			status = ocfs2_journal_access(handle, dir, bh,
-						      OCFS2_JOURNAL_ACCESS_WRITE);
+			status = ocfs2_journal_access_db(handle, dir, bh,
+							 OCFS2_JOURNAL_ACCESS_WRITE);
 			if (status < 0) {
 				status = -EIO;
 				mlog_errno(status);
@@ -581,8 +581,14 @@ int __ocfs2_add_entry(handle_t *handle,
 				goto bail;
 			}
 
-			status = ocfs2_journal_access(handle, dir, insert_bh,
-						      OCFS2_JOURNAL_ACCESS_WRITE);
+			if (insert_bh == parent_fe_bh)
+				status = ocfs2_journal_access_di(handle, dir,
+								 insert_bh,
+								 OCFS2_JOURNAL_ACCESS_WRITE);
+			else
+				status = ocfs2_journal_access_db(handle, dir,
+								 insert_bh,
+								 OCFS2_JOURNAL_ACCESS_WRITE);
 			/* By now the buffer is marked for journaling */
 			offset += le16_to_cpu(de->rec_len);
 			if (le64_to_cpu(de->inode)) {
@@ -1081,8 +1087,8 @@ static int ocfs2_fill_new_dir_id(struct ocfs2_super *osb,
 	struct ocfs2_inline_data *data = &di->id2.i_data;
 	unsigned int size = le16_to_cpu(data->id_count);
 
-	ret = ocfs2_journal_access(handle, inode, di_bh,
-				   OCFS2_JOURNAL_ACCESS_WRITE);
+	ret = ocfs2_journal_access_di(handle, inode, di_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -1129,8 +1135,8 @@ static int ocfs2_fill_new_dir_el(struct ocfs2_super *osb,
 
 	ocfs2_set_new_buffer_uptodate(inode, new_bh);
 
-	status = ocfs2_journal_access(handle, inode, new_bh,
-				      OCFS2_JOURNAL_ACCESS_CREATE);
+	status = ocfs2_journal_access_db(handle, inode, new_bh,
+					 OCFS2_JOURNAL_ACCESS_CREATE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -1292,8 +1298,8 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 
 	ocfs2_set_new_buffer_uptodate(dir, dirdata_bh);
 
-	ret = ocfs2_journal_access(handle, dir, dirdata_bh,
-				   OCFS2_JOURNAL_ACCESS_CREATE);
+	ret = ocfs2_journal_access_db(handle, dir, dirdata_bh,
+				      OCFS2_JOURNAL_ACCESS_CREATE);
 	if (ret) {
 		mlog_errno(ret);
 		goto out_commit;
@@ -1319,8 +1325,8 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 	 * We let the later dirent insert modify c/mtime - to the user
 	 * the data hasn't changed.
 	 */
-	ret = ocfs2_journal_access(handle, dir, di_bh,
-				   OCFS2_JOURNAL_ACCESS_CREATE);
+	ret = ocfs2_journal_access_di(handle, dir, di_bh,
+				      OCFS2_JOURNAL_ACCESS_CREATE);
 	if (ret) {
 		mlog_errno(ret);
 		goto out_commit;
@@ -1583,8 +1589,8 @@ do_extend:
 
 	ocfs2_set_new_buffer_uptodate(dir, new_bh);
 
-	status = ocfs2_journal_access(handle, dir, new_bh,
-				      OCFS2_JOURNAL_ACCESS_CREATE);
+	status = ocfs2_journal_access_db(handle, dir, new_bh,
+					 OCFS2_JOURNAL_ACCESS_CREATE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 9374d37..e8f795f 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -256,8 +256,8 @@ int ocfs2_update_inode_atime(struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_journal_access(handle, inode, bh,
-				   OCFS2_JOURNAL_ACCESS_WRITE);
+	ret = ocfs2_journal_access_di(handle, inode, bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
 		goto out_commit;
@@ -353,8 +353,8 @@ static int ocfs2_orphan_for_truncate(struct ocfs2_super *osb,
 		goto out;
 	}
 
-	status = ocfs2_journal_access(handle, inode, fe_bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
+	status = ocfs2_journal_access_di(handle, inode, fe_bh,
+					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto out_commit;
@@ -590,8 +590,8 @@ restarted_transaction:
 	/* reserve a write to the file entry early on - that we if we
 	 * run out of credits in the allocation path, we can still
 	 * update i_size. */
-	status = ocfs2_journal_access(handle, inode, bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
+	status = ocfs2_journal_access_di(handle, inode, bh,
+					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
@@ -1121,8 +1121,8 @@ static int __ocfs2_write_remove_suid(struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_journal_access(handle, inode, bh,
-				   OCFS2_JOURNAL_ACCESS_WRITE);
+	ret = ocfs2_journal_access_di(handle, inode, bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out_trans;
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 9370b65..229e707 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -537,8 +537,8 @@ static int ocfs2_truncate_for_delete(struct ocfs2_super *osb,
 			goto out;
 		}
 
-		status = ocfs2_journal_access(handle, inode, fe_bh,
-					      OCFS2_JOURNAL_ACCESS_WRITE);
+		status = ocfs2_journal_access_di(handle, inode, fe_bh,
+						 OCFS2_JOURNAL_ACCESS_WRITE);
 		if (status < 0) {
 			mlog_errno(status);
 			goto out;
@@ -621,8 +621,8 @@ static int ocfs2_remove_inode(struct inode *inode,
 	}
 
 	/* set the inodes dtime */
-	status = ocfs2_journal_access(handle, inode, di_bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
+	status = ocfs2_journal_access_di(handle, inode, di_bh,
+					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail_commit;
@@ -1190,8 +1190,8 @@ int ocfs2_mark_inode_dirty(handle_t *handle,
 	mlog_entry("(inode %llu)\n",
 		   (unsigned long long)OCFS2_I(inode)->ip_blkno);
 
-	status = ocfs2_journal_access(handle, inode, bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
+	status = ocfs2_journal_access_di(handle, inode, bh,
+					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
@@ -1277,8 +1277,11 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 	 * local to this block.
 	 */
 	rc = ocfs2_validate_meta_ecc(sb, bh->b_data, &di->i_check);
-	if (rc)
+	if (rc) {
+		mlog(ML_ERROR, "Checksum failed for dinode %llu\n",
+		     (unsigned long long)bh->b_blocknr);
 		goto bail;
+	}
 
 	/*
 	 * Errors after here are fatal.
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 2daa584..3b54dba 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -752,6 +752,7 @@ static int ocfs2_journal_toggle_dirty(struct ocfs2_super *osb,
 	if (replayed)
 		ocfs2_bump_recovery_generation(fe);
 
+	ocfs2_compute_meta_ecc(osb->sb, bh->b_data, &fe->i_check);
 	status = ocfs2_write_block(osb, bh, journal->j_inode);
 	if (status < 0)
 		mlog_errno(status);
@@ -1486,6 +1487,7 @@ static int ocfs2_replay_journal(struct ocfs2_super *osb,
 	osb->slot_recovery_generations[slot_num] =
 					ocfs2_get_recovery_generation(fe);
 
+	ocfs2_compute_meta_ecc(osb->sb, bh->b_data, &fe->i_check);
 	status = ocfs2_write_block(osb, bh, inode);
 	if (status < 0)
 		mlog_errno(status);
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index bca370d..3c3532e 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -247,9 +247,10 @@ int			     ocfs2_extend_trans(handle_t *handle, int nblocks);
 #define OCFS2_JOURNAL_ACCESS_WRITE  1
 #define OCFS2_JOURNAL_ACCESS_UNDO   2
 
+
 /* ocfs2_inode */
 int ocfs2_journal_access_di(handle_t *handle, struct inode *inode,
-			       struct buffer_head *bh, int type);
+			    struct buffer_head *bh, int type);
 /* ocfs2_extent_block */
 int ocfs2_journal_access_eb(handle_t *handle, struct inode *inode,
 			    struct buffer_head *bh, int type);
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 19cfb1b..1368e75 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -382,8 +382,8 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *osb)
 	}
 	memcpy(alloc_copy, alloc, bh->b_size);
 
-	status = ocfs2_journal_access(handle, local_alloc_inode, bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
+	status = ocfs2_journal_access_di(handle, local_alloc_inode, bh,
+					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto out_commit;
@@ -762,9 +762,9 @@ int ocfs2_claim_local_alloc_bits(struct ocfs2_super *osb,
 	 * delete bits from it! */
 	*num_bits = bits_wanted;
 
-	status = ocfs2_journal_access(handle, local_alloc_inode,
-				      osb->local_alloc_bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
+	status = ocfs2_journal_access_di(handle, local_alloc_inode,
+					 osb->local_alloc_bh,
+					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -1240,9 +1240,9 @@ static int ocfs2_local_alloc_slide_window(struct ocfs2_super *osb,
 	}
 	memcpy(alloc_copy, alloc, osb->local_alloc_bh->b_size);
 
-	status = ocfs2_journal_access(handle, local_alloc_inode,
-				      osb->local_alloc_bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
+	status = ocfs2_journal_access_di(handle, local_alloc_inode,
+					 osb->local_alloc_bh,
+					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 02c8026..7587d24 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -361,8 +361,8 @@ static int ocfs2_mknod(struct inode *dir,
 			goto leave;
 		}
 
-		status = ocfs2_journal_access(handle, dir, parent_fe_bh,
-					      OCFS2_JOURNAL_ACCESS_WRITE);
+		status = ocfs2_journal_access_di(handle, dir, parent_fe_bh,
+						 OCFS2_JOURNAL_ACCESS_WRITE);
 		if (status < 0) {
 			mlog_errno(status);
 			goto leave;
@@ -493,8 +493,8 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 	}
 	ocfs2_set_new_buffer_uptodate(inode, *new_fe_bh);
 
-	status = ocfs2_journal_access(handle, inode, *new_fe_bh,
-				      OCFS2_JOURNAL_ACCESS_CREATE);
+	status = ocfs2_journal_access_di(handle, inode, *new_fe_bh,
+					 OCFS2_JOURNAL_ACCESS_CREATE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
@@ -664,8 +664,8 @@ static int ocfs2_link(struct dentry *old_dentry,
 		goto out_unlock_inode;
 	}
 
-	err = ocfs2_journal_access(handle, inode, fe_bh,
-				   OCFS2_JOURNAL_ACCESS_WRITE);
+	err = ocfs2_journal_access_di(handle, inode, fe_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (err < 0) {
 		mlog_errno(err);
 		goto out_commit;
@@ -851,8 +851,8 @@ static int ocfs2_unlink(struct inode *dir,
 		goto leave;
 	}
 
-	status = ocfs2_journal_access(handle, inode, fe_bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
+	status = ocfs2_journal_access_di(handle, inode, fe_bh,
+					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
@@ -1265,8 +1265,8 @@ static int ocfs2_rename(struct inode *old_dir,
 				goto bail;
 			}
 		}
-		status = ocfs2_journal_access(handle, new_inode, newfe_bh,
-					      OCFS2_JOURNAL_ACCESS_WRITE);
+		status = ocfs2_journal_access_di(handle, new_inode, newfe_bh,
+						 OCFS2_JOURNAL_ACCESS_WRITE);
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail;
@@ -1312,8 +1312,8 @@ static int ocfs2_rename(struct inode *old_dir,
 	old_inode->i_ctime = CURRENT_TIME;
 	mark_inode_dirty(old_inode);
 
-	status = ocfs2_journal_access(handle, old_inode, old_inode_bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
+	status = ocfs2_journal_access_di(handle, old_inode, old_inode_bh,
+					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status >= 0) {
 		old_di = (struct ocfs2_dinode *) old_inode_bh->b_data;
 
@@ -1389,9 +1389,9 @@ static int ocfs2_rename(struct inode *old_dir,
 			     (int)old_dir_nlink, old_dir->i_nlink);
 		} else {
 			struct ocfs2_dinode *fe;
-			status = ocfs2_journal_access(handle, old_dir,
-						      old_dir_bh,
-						      OCFS2_JOURNAL_ACCESS_WRITE);
+			status = ocfs2_journal_access_di(handle, old_dir,
+							 old_dir_bh,
+							 OCFS2_JOURNAL_ACCESS_WRITE);
 			fe = (struct ocfs2_dinode *) old_dir_bh->b_data;
 			fe->i_links_count = cpu_to_le16(old_dir->i_nlink);
 			status = ocfs2_journal_dirty(handle, old_dir_bh);
@@ -1898,8 +1898,8 @@ static int ocfs2_orphan_add(struct ocfs2_super *osb,
 		goto leave;
 	}
 
-	status = ocfs2_journal_access(handle, orphan_dir_inode, orphan_dir_bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
+	status = ocfs2_journal_access_di(handle, orphan_dir_inode, orphan_dir_bh,
+					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
@@ -1986,8 +1986,8 @@ int ocfs2_orphan_del(struct ocfs2_super *osb,
 		goto leave;
 	}
 
-	status = ocfs2_journal_access(handle,orphan_dir_inode,  orphan_dir_bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
+	status = ocfs2_journal_access_di(handle,orphan_dir_inode,  orphan_dir_bh,
+					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 2bb389f..bad87d0 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -339,6 +339,10 @@ struct ocfs2_super
 
 #define OCFS2_SB(sb)	    ((struct ocfs2_super *)(sb)->s_fs_info)
 
+/* Useful typedef for passing around journal access functions */
+typedef int (*ocfs2_journal_access_func)(handle_t *handle, struct inode *inode,
+					 struct buffer_head *bh, int type);
+
 static inline int ocfs2_should_order_data(struct inode *inode)
 {
 	if (!S_ISREG(inode->i_mode))
diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index 867de3e..424adaa 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -106,8 +106,8 @@ static int ocfs2_update_last_group_and_inode(handle_t *handle,
 	mlog_entry("(new_clusters=%d, first_new_cluster = %u)\n",
 		   new_clusters, first_new_cluster);
 
-	ret = ocfs2_journal_access(handle, bm_inode, group_bh,
-				   OCFS2_JOURNAL_ACCESS_WRITE);
+	ret = ocfs2_journal_access_gd(handle, bm_inode, group_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out;
@@ -141,8 +141,8 @@ static int ocfs2_update_last_group_and_inode(handle_t *handle,
 	}
 
 	/* update the inode accordingly. */
-	ret = ocfs2_journal_access(handle, bm_inode, bm_bh,
-				   OCFS2_JOURNAL_ACCESS_WRITE);
+	ret = ocfs2_journal_access_di(handle, bm_inode, bm_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out_rollback;
@@ -536,8 +536,8 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
 	cl = &fe->id2.i_chain;
 	cr = &cl->cl_recs[input->chain];
 
-	ret = ocfs2_journal_access(handle, main_bm_inode, group_bh,
-				   OCFS2_JOURNAL_ACCESS_WRITE);
+	ret = ocfs2_journal_access_gd(handle, main_bm_inode, group_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out_commit;
@@ -552,8 +552,8 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
 		goto out_commit;
 	}
 
-	ret = ocfs2_journal_access(handle, main_bm_inode, main_bm_bh,
-				   OCFS2_JOURNAL_ACCESS_WRITE);
+	ret = ocfs2_journal_access_di(handle, main_bm_inode, main_bm_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out_commit;
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 7875576..a696286 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -261,7 +261,11 @@ int ocfs2_check_group_descriptor(struct super_block *sb,
 	 * local to this block.
 	 */
 	rc = ocfs2_validate_meta_ecc(sb, bh->b_data, &gd->bg_check);
-	if (!rc)
+	if (rc) {
+		mlog(ML_ERROR,
+		     "Checksum failed for group descriptor %llu\n",
+		     (unsigned long long)bh->b_blocknr);
+	} else
 		rc = ocfs2_validate_gd_self(sb, bh, 1);
 	if (!rc)
 		rc = ocfs2_validate_gd_parent(sb, di, bh, 1);
@@ -343,10 +347,10 @@ static int ocfs2_block_group_fill(handle_t *handle,
 		goto bail;
 	}
 
-	status = ocfs2_journal_access(handle,
-				      alloc_inode,
-				      bg_bh,
-				      OCFS2_JOURNAL_ACCESS_CREATE);
+	status = ocfs2_journal_access_gd(handle,
+					 alloc_inode,
+					 bg_bh,
+					 OCFS2_JOURNAL_ACCESS_CREATE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -476,8 +480,8 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 
 	bg = (struct ocfs2_group_desc *) bg_bh->b_data;
 
-	status = ocfs2_journal_access(handle, alloc_inode,
-				      bh, OCFS2_JOURNAL_ACCESS_WRITE);
+	status = ocfs2_journal_access_di(handle, alloc_inode,
+					 bh, OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -986,10 +990,10 @@ static inline int ocfs2_block_group_set_bits(handle_t *handle,
 	if (ocfs2_is_cluster_bitmap(alloc_inode))
 		journal_type = OCFS2_JOURNAL_ACCESS_UNDO;
 
-	status = ocfs2_journal_access(handle,
-				      alloc_inode,
-				      group_bh,
-				      journal_type);
+	status = ocfs2_journal_access_gd(handle,
+					 alloc_inode,
+					 group_bh,
+					 journal_type);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -1060,8 +1064,8 @@ static int ocfs2_relink_block_group(handle_t *handle,
 	bg_ptr = le64_to_cpu(bg->bg_next_group);
 	prev_bg_ptr = le64_to_cpu(prev_bg->bg_next_group);
 
-	status = ocfs2_journal_access(handle, alloc_inode, prev_bg_bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
+	status = ocfs2_journal_access_gd(handle, alloc_inode, prev_bg_bh,
+					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto out_rollback;
@@ -1075,8 +1079,8 @@ static int ocfs2_relink_block_group(handle_t *handle,
 		goto out_rollback;
 	}
 
-	status = ocfs2_journal_access(handle, alloc_inode, bg_bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
+	status = ocfs2_journal_access_gd(handle, alloc_inode, bg_bh,
+					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto out_rollback;
@@ -1090,8 +1094,8 @@ static int ocfs2_relink_block_group(handle_t *handle,
 		goto out_rollback;
 	}
 
-	status = ocfs2_journal_access(handle, alloc_inode, fe_bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
+	status = ocfs2_journal_access_di(handle, alloc_inode, fe_bh,
+					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto out_rollback;
@@ -1242,8 +1246,8 @@ static int ocfs2_alloc_dinode_update_counts(struct inode *inode,
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *) di_bh->b_data;
 	struct ocfs2_chain_list *cl = (struct ocfs2_chain_list *) &di->id2.i_chain;
 
-	ret = ocfs2_journal_access(handle, inode, di_bh,
-				   OCFS2_JOURNAL_ACCESS_WRITE);
+	ret = ocfs2_journal_access_di(handle, inode, di_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out;
@@ -1414,10 +1418,10 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
 
 	/* Ok, claim our bits now: set the info on dinode, chainlist
 	 * and then the group */
-	status = ocfs2_journal_access(handle,
-				      alloc_inode,
-				      ac->ac_bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
+	status = ocfs2_journal_access_di(handle,
+					 alloc_inode,
+					 ac->ac_bh,
+					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -1824,8 +1828,8 @@ static inline int ocfs2_block_group_clear_bits(handle_t *handle,
 	if (ocfs2_is_cluster_bitmap(alloc_inode))
 		journal_type = OCFS2_JOURNAL_ACCESS_UNDO;
 
-	status = ocfs2_journal_access(handle, alloc_inode, group_bh,
-				      journal_type);
+	status = ocfs2_journal_access_gd(handle, alloc_inode, group_bh,
+					 journal_type);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -1900,8 +1904,8 @@ int ocfs2_free_suballoc_bits(handle_t *handle,
 		goto bail;
 	}
 
-	status = ocfs2_journal_access(handle, alloc_inode, alloc_bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
+	status = ocfs2_journal_access_di(handle, alloc_inode, alloc_bh,
+					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
-- 
1.5.6.5
