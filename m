From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 27 Mar 2009 07:02:18 +0800
Subject: [Ocfs2-devel] [PATCH 12/42] ocfs2: export tree operation functions.
In-Reply-To: <49CC86FC.2070906@oracle.com>
References: <49CC86FC.2070906@oracle.com>
Message-ID: <1238108568-23740-12-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Now fs/ocfs2/alloc.c has more than 7000 lines. It contains our
basic b-tree operation. Although we have already make our b-tree
operation generic, the basic structrue ocfs2_path which is used
to iterate one b-tree branch is still static and limited to only
used in alloc.c. As refcount tree need them and I don't want to
add any more b-tree unrelated code to alloc.c, export them out.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c |   74 ++++++++++++++++-------------------------------------
 fs/ocfs2/alloc.h |   49 +++++++++++++++++++++++++++++++++++
 2 files changed, 72 insertions(+), 51 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 6a7dada..7221073 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -585,40 +585,12 @@ static inline int ocfs2_et_sanity_check(struct ocfs2_extent_tree *et)
 static void ocfs2_free_truncate_context(struct ocfs2_truncate_context *tc);
 static int ocfs2_cache_extent_block_free(struct ocfs2_cached_dealloc_ctxt *ctxt,
 					 struct ocfs2_extent_block *eb);
-
-/*
- * Structures which describe a path through a btree, and functions to
- * manipulate them.
- *
- * The idea here is to be as generic as possible with the tree
- * manipulation code.
- */
-struct ocfs2_path_item {
-	struct buffer_head		*bh;
-	struct ocfs2_extent_list	*el;
-};
-
-#define OCFS2_MAX_PATH_DEPTH	5
-
-struct ocfs2_path {
-	int				p_tree_depth;
-	ocfs2_journal_access_func	p_root_access;
-	struct ocfs2_path_item		p_node[OCFS2_MAX_PATH_DEPTH];
-};
-
-#define path_root_bh(_path) ((_path)->p_node[0].bh)
-#define path_root_el(_path) ((_path)->p_node[0].el)
-#define path_root_access(_path)((_path)->p_root_access)
-#define path_leaf_bh(_path) ((_path)->p_node[(_path)->p_tree_depth].bh)
-#define path_leaf_el(_path) ((_path)->p_node[(_path)->p_tree_depth].el)
-#define path_num_items(_path) ((_path)->p_tree_depth + 1)
-
 /*
  * Reset the actual path elements so that we can re-use the structure
  * to build another path. Generally, this involves freeing the buffer
  * heads.
  */
-static void ocfs2_reinit_path(struct ocfs2_path *path, int keep_root)
+void ocfs2_reinit_path(struct ocfs2_path *path, int keep_root)
 {
 	int i, start = 0, depth = 0;
 	struct ocfs2_path_item *node;
@@ -647,7 +619,7 @@ static void ocfs2_reinit_path(struct ocfs2_path *path, int keep_root)
 	path->p_tree_depth = depth;
 }
 
-static void ocfs2_free_path(struct ocfs2_path *path)
+void ocfs2_free_path(struct ocfs2_path *path)
 {
 	if (path) {
 		ocfs2_reinit_path(path, 0);
@@ -745,13 +717,13 @@ static struct ocfs2_path *ocfs2_new_path(struct buffer_head *root_bh,
 	return path;
 }
 
-static struct ocfs2_path *ocfs2_new_path_from_path(struct ocfs2_path *path)
+struct ocfs2_path *ocfs2_new_path_from_path(struct ocfs2_path *path)
 {
 	return ocfs2_new_path(path_root_bh(path), path_root_el(path),
 			      path_root_access(path));
 }
 
-static struct ocfs2_path *ocfs2_new_path_from_et(struct ocfs2_extent_tree *et)
+struct ocfs2_path *ocfs2_new_path_from_et(struct ocfs2_extent_tree *et)
 {
 	return ocfs2_new_path(et->et_root_bh, et->et_root_el,
 			      et->et_root_journal_access);
@@ -764,10 +736,10 @@ static struct ocfs2_path *ocfs2_new_path_from_et(struct ocfs2_extent_tree *et)
  * I don't like the way this function's name looks next to
  * ocfs2_journal_access_path(), but I don't have a better one.
  */
-static int ocfs2_path_bh_journal_access(handle_t *handle,
-					struct ocfs2_caching_info *ci,
-					struct ocfs2_path *path,
-					int idx)
+int ocfs2_path_bh_journal_access(handle_t *handle,
+				 struct ocfs2_caching_info *ci,
+				 struct ocfs2_path *path,
+				 int idx)
 {
 	ocfs2_journal_access_func access = path_root_access(path);
 
@@ -784,9 +756,9 @@ static int ocfs2_path_bh_journal_access(handle_t *handle,
 /*
  * Convenience function to journal all components in a path.
  */
-static int ocfs2_journal_access_path(struct ocfs2_caching_info *ci,
-				     handle_t *handle,
-				     struct ocfs2_path *path)
+int ocfs2_journal_access_path(struct ocfs2_caching_info *ci,
+			      handle_t *handle,
+			      struct ocfs2_path *path)
 {
 	int i, ret = 0;
 
@@ -1890,8 +1862,8 @@ static void find_path_ins(void *data, struct buffer_head *bh)
 	ocfs2_path_insert_eb(fp->path, fp->index, bh);
 	fp->index++;
 }
-static int ocfs2_find_path(struct ocfs2_caching_info *ci,
-			   struct ocfs2_path *path, u32 cpos)
+int ocfs2_find_path(struct ocfs2_caching_info *ci,
+		    struct ocfs2_path *path, u32 cpos)
 {
 	struct find_path_data data;
 
@@ -5000,13 +4972,13 @@ out:
  * have been brought into cache (and pinned via the journal), so the
  * extra overhead is not expressed in terms of disk reads.
  */
-static int __ocfs2_split_extent(handle_t *handle,
-				struct ocfs2_extent_tree *et,
-				struct ocfs2_path *path,
-				int split_index,
-				struct ocfs2_extent_rec *split_rec,
-				struct ocfs2_alloc_context *meta_ac,
-				struct ocfs2_cached_dealloc_ctxt *dealloc)
+int ocfs2_split_extent(handle_t *handle,
+		       struct ocfs2_extent_tree *et,
+		       struct ocfs2_path *path,
+		       int split_index,
+		       struct ocfs2_extent_rec *split_rec,
+		       struct ocfs2_alloc_context *meta_ac,
+		       struct ocfs2_cached_dealloc_ctxt *dealloc)
 {
 	int ret = 0;
 	struct ocfs2_extent_list *el = path_leaf_el(path);
@@ -5153,9 +5125,9 @@ static int ocfs2_change_extent_flag(handle_t *handle,
 	else
 		split_rec.e_flags &= ~clear_flags;
 
-	ret = __ocfs2_split_extent(handle, et, left_path,
-				  index, &split_rec, meta_ac,
-				  dealloc);
+	ret = ocfs2_split_extent(handle, et, left_path,
+				 index, &split_rec, meta_ac,
+				 dealloc);
 	if (ret)
 		mlog_errno(ret);
 
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index 49eff75..c89197a 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -109,6 +109,14 @@ int ocfs2_add_clusters_in_btree(handle_t *handle,
 				struct ocfs2_alloc_context *meta_ac,
 				enum ocfs2_alloc_restarted *reason_ret);
 struct ocfs2_cached_dealloc_ctxt;
+struct ocfs2_path;
+int ocfs2_split_extent(handle_t *handle,
+		       struct ocfs2_extent_tree *et,
+		       struct ocfs2_path *path,
+		       int split_index,
+		       struct ocfs2_extent_rec *split_rec,
+		       struct ocfs2_alloc_context *meta_ac,
+		       struct ocfs2_cached_dealloc_ctxt *dealloc);
 int ocfs2_mark_extent_written(struct inode *inode,
 			      struct ocfs2_extent_tree *et,
 			      handle_t *handle, u32 cpos, u32 len, u32 phys,
@@ -255,4 +263,45 @@ static inline int ocfs2_is_empty_extent(struct ocfs2_extent_rec *rec)
 	return !rec->e_leaf_clusters;
 }
 
+/*
+ * Structures which describe a path through a btree, and functions to
+ * manipulate them.
+ *
+ * The idea here is to be as generic as possible with the tree
+ * manipulation code.
+ */
+struct ocfs2_path_item {
+	struct buffer_head		*bh;
+	struct ocfs2_extent_list	*el;
+};
+
+#define OCFS2_MAX_PATH_DEPTH	5
+
+struct ocfs2_path {
+	int				p_tree_depth;
+	ocfs2_journal_access_func	p_root_access;
+	struct ocfs2_path_item		p_node[OCFS2_MAX_PATH_DEPTH];
+};
+
+#define path_root_bh(_path) ((_path)->p_node[0].bh)
+#define path_root_el(_path) ((_path)->p_node[0].el)
+#define path_root_access(_path)((_path)->p_root_access)
+#define path_leaf_bh(_path) ((_path)->p_node[(_path)->p_tree_depth].bh)
+#define path_leaf_el(_path) ((_path)->p_node[(_path)->p_tree_depth].el)
+#define path_num_items(_path) ((_path)->p_tree_depth + 1)
+
+void ocfs2_reinit_path(struct ocfs2_path *path, int keep_root);
+void ocfs2_free_path(struct ocfs2_path *path);
+int ocfs2_find_path(struct ocfs2_caching_info *ci,
+		    struct ocfs2_path *path,
+		    u32 cpos);
+struct ocfs2_path *ocfs2_new_path_from_path(struct ocfs2_path *path);
+struct ocfs2_path *ocfs2_new_path_from_et(struct ocfs2_extent_tree *et);
+int ocfs2_path_bh_journal_access(handle_t *handle,
+				 struct ocfs2_caching_info *ci,
+				 struct ocfs2_path *path,
+				 int idx);
+int ocfs2_journal_access_path(struct ocfs2_caching_info *ci,
+			      handle_t *handle,
+			      struct ocfs2_path *path);
 #endif /* OCFS2_ALLOC_H */
-- 
1.6.2.rc2.16.gf474c
