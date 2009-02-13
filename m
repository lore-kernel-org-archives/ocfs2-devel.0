From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:15:54 -0800
Subject: [Ocfs2-devel] [PATCH 07/40] ocfs2: Store the ocfs2_caching_info on
	ocfs2_extent_tree.
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-8-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

What do we cache?  Metadata blocks.  What are most of our non-inode metadata
blocks?  Extent blocks for our btrees.  struct ocfs2_extent_tree is the
main structure for managing those.  So let's store the associated
ocfs2_caching_info there.

This means that ocfs2_et_root_journal_access() doesn't need struct inode
anymore, and any place that has an et can refer to et->et_ci instead of
INODE_CACHE(inode).

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c |   26 +++++++++++++-------------
 fs/ocfs2/alloc.h |    4 +++-
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 84ecf90..2c87173 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -302,6 +302,7 @@ static void __ocfs2_init_extent_tree(struct ocfs2_extent_tree *et,
 {
 	et->et_ops = ops;
 	et->et_root_bh = bh;
+	et->et_ci = INODE_CACHE(inode);
 	et->et_root_journal_access = access;
 	if (!obj)
 		obj = (void *)bh->b_data;
@@ -357,11 +358,10 @@ static inline void ocfs2_et_update_clusters(struct inode *inode,
 }
 
 static inline int ocfs2_et_root_journal_access(handle_t *handle,
-					       struct ocfs2_caching_info *ci,
 					       struct ocfs2_extent_tree *et,
 					       int type)
 {
-	return et->et_root_journal_access(handle, ci, et->et_root_bh,
+	return et->et_root_journal_access(handle, et->et_ci, et->et_root_bh,
 					  type);
 }
 
@@ -1079,7 +1079,7 @@ static int ocfs2_add_branch(struct ocfs2_super *osb,
 		mlog_errno(status);
 		goto bail;
 	}
-	status = ocfs2_et_root_journal_access(handle, INODE_CACHE(inode), et,
+	status = ocfs2_et_root_journal_access(handle, et,
 					      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
@@ -1195,7 +1195,7 @@ static int ocfs2_shift_tree_depth(struct ocfs2_super *osb,
 		goto bail;
 	}
 
-	status = ocfs2_et_root_journal_access(handle, INODE_CACHE(inode), et,
+	status = ocfs2_et_root_journal_access(handle, et,
 					      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
@@ -2519,7 +2519,7 @@ static int ocfs2_rotate_subtree_left(struct inode *inode, handle_t *handle,
 		 * We have to update i_last_eb_blk during the meta
 		 * data delete.
 		 */
-		ret = ocfs2_et_root_journal_access(handle, INODE_CACHE(inode), et,
+		ret = ocfs2_et_root_journal_access(handle, et,
 						   OCFS2_JOURNAL_ACCESS_WRITE);
 		if (ret) {
 			mlog_errno(ret);
@@ -2866,7 +2866,7 @@ static int ocfs2_remove_rightmost_path(struct inode *inode, handle_t *handle,
 		goto out;
 	}
 
-	ret = ocfs2_journal_access_path(INODE_CACHE(inode), handle, path);
+	ret = ocfs2_journal_access_path(et->et_ci, handle, path);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -2896,7 +2896,7 @@ static int ocfs2_remove_rightmost_path(struct inode *inode, handle_t *handle,
 			goto out;
 		}
 
-		ret = ocfs2_journal_access_path(INODE_CACHE(inode), handle, left_path);
+		ret = ocfs2_journal_access_path(et->et_ci, handle, left_path);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -4047,7 +4047,7 @@ static int ocfs2_do_insert_extent(struct inode *inode,
 
 	el = et->et_root_el;
 
-	ret = ocfs2_et_root_journal_access(handle, INODE_CACHE(inode), et,
+	ret = ocfs2_et_root_journal_access(handle, et,
 					   OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
@@ -4109,7 +4109,7 @@ static int ocfs2_do_insert_extent(struct inode *inode,
 		 * ocfs2_rotate_tree_right() might have extended the
 		 * transaction without re-journaling our tree root.
 		 */
-		ret = ocfs2_et_root_journal_access(handle, INODE_CACHE(inode), et,
+		ret = ocfs2_et_root_journal_access(handle, et,
 						   OCFS2_JOURNAL_ACCESS_WRITE);
 		if (ret) {
 			mlog_errno(ret);
@@ -4632,7 +4632,7 @@ int ocfs2_add_clusters_in_btree(struct ocfs2_super *osb,
 	BUG_ON(num_bits > clusters_to_add);
 
 	/* reserve our write early -- insert_extent may update the tree root */
-	status = ocfs2_et_root_journal_access(handle, INODE_CACHE(inode), et,
+	status = ocfs2_et_root_journal_access(handle, et,
 					      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
@@ -5144,13 +5144,13 @@ static int ocfs2_truncate_rec(struct inode *inode, handle_t *handle,
 		goto out;
 	}
 
-	ret = ocfs2_journal_access_path(INODE_CACHE(inode), handle, path);
+	ret = ocfs2_journal_access_path(et->et_ci, handle, path);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
 	}
 
-	ret = ocfs2_journal_access_path(INODE_CACHE(inode), handle, left_path);
+	ret = ocfs2_journal_access_path(et->et_ci, handle, left_path);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -5385,7 +5385,7 @@ int ocfs2_remove_btree_range(struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_et_root_journal_access(handle, INODE_CACHE(inode), et,
+	ret = ocfs2_et_root_journal_access(handle, et,
 					   OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index cceff5c..b16e32c 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -45,7 +45,8 @@
  *
  * ocfs2_extent_tree contains info for the root of the b-tree, it must have a
  * root ocfs2_extent_list and a root_bh so that they can be used in the b-tree
- * functions.  With metadata ecc, we now call different journal_access
+ * functions.  It needs the ocfs2_caching_info structure associated with
+ * I/O on the tree.  With metadata ecc, we now call different journal_access
  * functions for each type of metadata, so it must have the
  * root_journal_access function.
  * ocfs2_extent_tree_operations abstract the normal operations we do for
@@ -56,6 +57,7 @@ struct ocfs2_extent_tree {
 	struct ocfs2_extent_tree_operations	*et_ops;
 	struct buffer_head			*et_root_bh;
 	struct ocfs2_extent_list		*et_root_el;
+	struct ocfs2_caching_info		*et_ci;
 	ocfs2_journal_access_func		et_root_journal_access;
 	void					*et_object;
 	unsigned int				et_max_leaf_clusters;
-- 
1.5.6.5
