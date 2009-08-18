From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 18 Aug 2009 14:19:25 +0800
Subject: [Ocfs2-devel] [PATCH 24/41] ocfs2: Abstract duplicate clusters
	process in CoW.
In-Reply-To: <4A8A47DF.8020707@oracle.com>
References: <4A8A47DF.8020707@oracle.com>
Message-ID: <1250576382-27080-24-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We currently use pagecache to duplicate clusters in CoW,
but it isn't suitable for xattr case. So abstract it out
so that the caller can decide which method it use.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/refcounttree.c |  127 ++++++++++++++++++++++++++---------------------
 1 files changed, 71 insertions(+), 56 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index efcccb4..6029f52 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -45,12 +45,20 @@ struct ocfs2_cow_context {
 	struct inode *inode;
 	u32 cow_start;
 	u32 cow_len;
-	struct ocfs2_extent_tree di_et;
-	struct ocfs2_caching_info *ref_ci;
+	struct ocfs2_extent_tree data_et;
+	struct ocfs2_refcount_tree *ref_tree;
 	struct buffer_head *ref_root_bh;
 	struct ocfs2_alloc_context *meta_ac;
 	struct ocfs2_alloc_context *data_ac;
 	struct ocfs2_cached_dealloc_ctxt dealloc;
+	int (*get_clusters)(struct ocfs2_cow_context *context,
+			    u32 v_cluster, u32 *p_cluster,
+			    u32 *num_clusters,
+			    unsigned int *extent_flags);
+	int (*cow_duplicate_clusters)(handle_t *handle,
+				      struct ocfs2_cow_context *context,
+				      u32 cpos, u32 old_cluster,
+				      u32 new_cluster, u32 new_len);
 };
 
 static inline struct ocfs2_refcount_tree *
@@ -2443,7 +2451,7 @@ out:
  * use that value as the maximum clusters.
  */
 static int ocfs2_refcount_cal_cow_clusters(struct inode *inode,
-					   struct buffer_head *di_bh,
+					   struct ocfs2_extent_list *el,
 					   u32 cpos,
 					   u32 write_len,
 					   u32 max_cpos,
@@ -2451,8 +2459,6 @@ static int ocfs2_refcount_cal_cow_clusters(struct inode *inode,
 					   u32 *cow_len)
 {
 	int ret = 0;
-	struct ocfs2_dinode *di = (struct ocfs2_dinode *) di_bh->b_data;
-	struct ocfs2_extent_list *el = &di->id2.i_list;
 	int tree_height = le16_to_cpu(el->l_tree_depth), i;
 	struct buffer_head *eb_bh = NULL;
 	struct ocfs2_extent_block *eb = NULL;
@@ -2675,13 +2681,13 @@ static int ocfs2_clear_cow_buffer(handle_t *handle, struct buffer_head *bh)
 	return 0;
 }
 
-static int ocfs2_duplicate_clusters(handle_t *handle,
-				    struct ocfs2_cow_context *context,
-				    u32 cpos, u32 old_cluster,
-				    u32 new_cluster, u32 new_len)
+static int ocfs2_duplicate_clusters_by_page(handle_t *handle,
+					    struct ocfs2_cow_context *context,
+					    u32 cpos, u32 old_cluster,
+					    u32 new_cluster, u32 new_len)
 {
 	int ret = 0, partial;
-	struct ocfs2_caching_info *ci = context->di_et.et_ci;
+	struct ocfs2_caching_info *ci = context->data_et.et_ci;
 	struct super_block *sb = ocfs2_metadata_cache_get_super(ci);
 	u64 new_block = ocfs2_clusters_to_blocks(sb, new_cluster);
 	struct page *page;
@@ -2815,7 +2821,7 @@ static int ocfs2_replace_clusters(handle_t *handle,
 				  unsigned int ext_flags)
 {
 	int ret;
-	struct ocfs2_caching_info *ci = context->di_et.et_ci;
+	struct ocfs2_caching_info *ci = context->data_et.et_ci;
 	u64 ino = ocfs2_metadata_cache_owner(ci);
 
 	mlog(0, "inode %llu, cpos %u, old %u, new %u, len %u, ext_flags %u\n",
@@ -2823,15 +2829,15 @@ static int ocfs2_replace_clusters(handle_t *handle,
 
 	/*If the old clusters is unwritten, no need to duplicate. */
 	if (!(ext_flags & OCFS2_EXT_UNWRITTEN)) {
-		ret = ocfs2_duplicate_clusters(handle, context, cpos,
-					       old, new, len);
+		ret = context->cow_duplicate_clusters(handle, context, cpos,
+						      old, new, len);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
 		}
 	}
 
-	ret = ocfs2_clear_ext_refcount(handle, &context->di_et,
+	ret = ocfs2_clear_ext_refcount(handle, &context->data_et,
 				       cpos, new, len, ext_flags,
 				       context->meta_ac, &context->dealloc);
 	if (ret)
@@ -2889,6 +2895,15 @@ static int ocfs2_cow_sync_writeback(struct super_block *sb,
 	return ret;
 }
 
+static int ocfs2_di_get_clusters(struct ocfs2_cow_context *context,
+				 u32 v_cluster, u32 *p_cluster,
+				 u32 *num_clusters,
+				 unsigned int *extent_flags)
+{
+	return ocfs2_get_clusters(context->inode, v_cluster, p_cluster,
+				  num_clusters, extent_flags);
+}
+
 static int ocfs2_make_clusters_writable(struct super_block *sb,
 					struct ocfs2_cow_context *context,
 					u32 cpos, u32 p_cluster,
@@ -2900,14 +2915,15 @@ static int ocfs2_make_clusters_writable(struct super_block *sb,
 	struct ocfs2_super *osb = OCFS2_SB(sb);
 	handle_t *handle;
 	struct buffer_head *ref_leaf_bh = NULL;
+	struct ocfs2_caching_info *ref_ci = &context->ref_tree->rf_ci;
 	struct ocfs2_refcount_rec rec;
 
 	mlog(0, "cpos %u, p_cluster %u, num_clusters %u, e_flags %u\n",
 	     cpos, p_cluster, num_clusters, e_flags);
 
 	ret = ocfs2_lock_refcount_allocators(sb, p_cluster, num_clusters,
-					     &context->di_et,
-					     context->ref_ci,
+					     &context->data_et,
+					     ref_ci,
 					     context->ref_root_bh,
 					     &context->meta_ac,
 					     &context->data_ac, &credits);
@@ -2924,8 +2940,7 @@ static int ocfs2_make_clusters_writable(struct super_block *sb,
 	}
 
 	while (num_clusters) {
-		ret = ocfs2_get_refcount_rec(context->ref_ci,
-					     context->ref_root_bh,
+		ret = ocfs2_get_refcount_rec(ref_ci, context->ref_root_bh,
 					     p_cluster, num_clusters,
 					     &rec, &index, &ref_leaf_bh);
 		if (ret) {
@@ -2947,7 +2962,8 @@ static int ocfs2_make_clusters_writable(struct super_block *sb,
 		 */
 		if (le32_to_cpu(rec.r_refcount) == 1) {
 			delete = 0;
-			ret = ocfs2_clear_ext_refcount(handle, &context->di_et,
+			ret = ocfs2_clear_ext_refcount(handle,
+						       &context->data_et,
 						       cpos, p_cluster,
 						       set_len, e_flags,
 						       context->meta_ac,
@@ -2978,7 +2994,7 @@ static int ocfs2_make_clusters_writable(struct super_block *sb,
 			set_len = new_len;
 		}
 
-		ret = __ocfs2_decrease_refcount(handle, context->ref_ci,
+		ret = __ocfs2_decrease_refcount(handle, ref_ci,
 						context->ref_root_bh,
 						p_cluster, set_len,
 						context->meta_ac,
@@ -3020,17 +3036,14 @@ out:
 	return ret;
 }
 
-static int ocfs2_replace_cow(struct inode *inode,
-			     struct buffer_head *di_bh,
-			     struct buffer_head *ref_root_bh,
-			     struct ocfs2_caching_info *ref_ci,
-			     u32 cow_start, u32 cow_len)
+static int ocfs2_replace_cow(struct ocfs2_cow_context *context)
 {
 	int ret;
-	u32 p_cluster, num_clusters, start = cow_start;
+	struct inode *inode = context->inode;
+	u32 cow_start = context->cow_start, cow_len = context->cow_len;
+	u32 p_cluster, num_clusters;
 	unsigned int ext_flags;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	struct ocfs2_cow_context *context;
 
 	if (!ocfs2_refcount_tree(OCFS2_SB(inode->i_sb))) {
 		ocfs2_error(inode->i_sb, "Inode %lu want to use refcount "
@@ -3039,26 +3052,11 @@ static int ocfs2_replace_cow(struct inode *inode,
 		return -EROFS;
 	}
 
-	context = kzalloc(sizeof(struct ocfs2_cow_context), GFP_NOFS);
-	if (!context) {
-		ret = -ENOMEM;
-		mlog_errno(ret);
-		return ret;
-	}
-
-	context->inode = inode;
-	context->cow_start = cow_start;
-	context->cow_len = cow_len;
-	context->ref_ci = ref_ci;
-	context->ref_root_bh = ref_root_bh;
-
 	ocfs2_init_dealloc_ctxt(&context->dealloc);
-	ocfs2_init_dinode_extent_tree(&context->di_et,
-				      INODE_CACHE(inode), di_bh);
 
 	while (cow_len) {
-		ret = ocfs2_get_clusters(inode, cow_start, &p_cluster,
-					 &num_clusters, &ext_flags);
+		ret = context->get_clusters(context, cow_start, &p_cluster,
+					    &num_clusters, &ext_flags);
 
 		BUG_ON(!(ext_flags & OCFS2_EXT_REFCOUNTED));
 
@@ -3077,20 +3075,11 @@ static int ocfs2_replace_cow(struct inode *inode,
 		cow_start += num_clusters;
 	}
 
-
-	/*
-	 * truncate the extent map here since no matter whether we meet with
-	 * any error during the action, we shouldn't trust cached extent map
-	 * any more.
-	 */
-	ocfs2_extent_map_trunc(inode, start);
-
 	if (ocfs2_dealloc_has_cluster(&context->dealloc)) {
 		ocfs2_schedule_truncate_log_flush(osb, 1);
 		ocfs2_run_deallocs(osb, &context->dealloc);
 	}
 
-	kfree(context);
 	return ret;
 }
 
@@ -3105,10 +3094,11 @@ int ocfs2_refcount_cow(struct inode *inode,
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 	struct buffer_head *ref_root_bh = NULL;
 	struct ocfs2_refcount_tree *ref_tree;
+	struct ocfs2_cow_context *context = NULL;
 
 	BUG_ON(!(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL));
 
-	ret = ocfs2_refcount_cal_cow_clusters(inode, di_bh,
+	ret = ocfs2_refcount_cal_cow_clusters(inode, &di->id2.i_list,
 					      cpos, write_len, max_cpos,
 					      &cow_start, &cow_len);
 	if (ret) {
@@ -3122,6 +3112,13 @@ int ocfs2_refcount_cow(struct inode *inode,
 
 	BUG_ON(cow_len == 0);
 
+	context = kzalloc(sizeof(struct ocfs2_cow_context), GFP_NOFS);
+	if (!context) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto out;
+	}
+
 	ret = ocfs2_lock_refcount_tree(osb, le64_to_cpu(di->i_refcount_loc),
 				       1, &ref_tree, &ref_root_bh);
 	if (ret) {
@@ -3129,14 +3126,32 @@ int ocfs2_refcount_cow(struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_replace_cow(inode, di_bh, ref_root_bh, &ref_tree->rf_ci,
-				cow_start, cow_len);
+	context->inode = inode;
+	context->cow_start = cow_start;
+	context->cow_len = cow_len;
+	context->ref_tree = ref_tree;
+	context->ref_root_bh = ref_root_bh;
+	context->cow_duplicate_clusters = ocfs2_duplicate_clusters_by_page;
+	context->get_clusters = ocfs2_di_get_clusters;
+
+	ocfs2_init_dinode_extent_tree(&context->data_et,
+				      INODE_CACHE(inode), di_bh);
+
+	ret = ocfs2_replace_cow(context);
 	if (ret)
 		mlog_errno(ret);
 
+	/*
+	 * truncate the extent map here since no matter whether we meet with
+	 * any error during the action, we shouldn't trust cached extent map
+	 * any more.
+	 */
+	ocfs2_extent_map_trunc(inode, cow_start);
+
 	ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
 	brelse(ref_root_bh);
 out:
+	kfree(context);
 	return ret;
 }
 
-- 
1.6.2.rc2.16.gf474c
