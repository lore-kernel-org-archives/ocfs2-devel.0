From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 30 Apr 2009 06:58:39 +0800
Subject: [Ocfs2-devel] [PATCH 27/39] ocfs2: Abstract duplicate clusters
	process in CoW.
In-Reply-To: <49F95A79.6040806@oracle.com>
References: <49F95A79.6040806@oracle.com>
Message-ID: <1241045931-24607-27-git-send-email-tao.ma@oracle.com>
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
 fs/ocfs2/refcounttree.c |  141 ++++++++++++++++++++++++++---------------------
 1 files changed, 79 insertions(+), 62 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index a12d739..0f94619 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -41,7 +41,7 @@
 
 struct ocfs2_cow_context {
 	struct inode *inode;
-	struct ocfs2_extent_tree di_et;
+	struct ocfs2_extent_tree data_et;
 	struct ocfs2_caching_info *ref_ci;
 	struct buffer_head *ref_root_bh;
 	struct ocfs2_alloc_context *meta_ac;
@@ -52,6 +52,14 @@ struct ocfs2_cow_context {
 	int num_pages;
 	u32 cow_start;
 	u32 cow_len;
+	int (*get_clusters)(struct ocfs2_cow_context *context,
+			    u32 v_cluster, u32 *p_cluster,
+			    u32 *num_clusters,
+			    unsigned int *extent_flags);
+	int (*cow_duplicate_clusters)(handle_t *handle,
+				      struct ocfs2_cow_context *context,
+				      u32 cpos, u32 old_cluster,
+				      u32 new_cluster, u32 new_len);
 };
 
 static const struct ocfs2_caching_operations ocfs2_refcount_caching_ops;
@@ -1830,7 +1838,7 @@ out:
  * use that value as the maximum clusters.
  */
 static int ocfs2_refcount_cal_cow_clusters(struct inode *inode,
-					   struct buffer_head *di_bh,
+					   struct ocfs2_extent_list *el,
 					   u32 cpos,
 					   u32 write_len,
 					   u32 *cow_start,
@@ -1838,8 +1846,6 @@ static int ocfs2_refcount_cal_cow_clusters(struct inode *inode,
 					   int *has_data)
 {
 	int ret = 0;
-	struct ocfs2_dinode *di = (struct ocfs2_dinode *) di_bh->b_data;
-	struct ocfs2_extent_list *el = &di->id2.i_list;
 	int tree_height = le16_to_cpu(el->l_tree_depth), i;
 	struct buffer_head *eb_bh = NULL;
 	struct ocfs2_extent_block *eb = NULL;
@@ -2091,13 +2097,13 @@ out:
 	return ret;
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
 	int ret = 0, bh_num;
-	struct ocfs2_caching_info *ci = context->di_et.et_ci;
+	struct ocfs2_caching_info *ci = context->data_et.et_ci;
 	struct super_block *sb = ocfs2_metadata_cache_get_super(ci);
 	int i, j, bpc = ocfs2_clusters_to_blocks(sb, 1);
 	u64 old_block = ocfs2_clusters_to_blocks(sb, old_cluster);
@@ -2235,7 +2241,7 @@ static int ocfs2_replace_clusters(handle_t *handle,
 				  unsigned int ext_flags)
 {
 	int ret;
-	struct ocfs2_caching_info *ci = context->di_et.et_ci;
+	struct ocfs2_caching_info *ci = context->data_et.et_ci;
 	u64 ino = ocfs2_metadata_cache_owner(ci);
 
 	mlog(0, "inode %llu, cpos %u, old %u, new %u, len %u, ext_flags %u\n",
@@ -2243,15 +2249,15 @@ static int ocfs2_replace_clusters(handle_t *handle,
 
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
@@ -2277,7 +2283,7 @@ static int ocfs2_make_clusters_writable(struct super_block *sb,
 	     cpos, p_cluster, num_clusters, e_flags);
 
 	ret = ocfs2_lock_refcount_allocators(sb, p_cluster, num_clusters,
-					     &context->di_et,
+					     &context->data_et,
 					     context->ref_ci,
 					     context->ref_root_bh,
 					     &context->meta_ac,
@@ -2318,7 +2324,8 @@ static int ocfs2_make_clusters_writable(struct super_block *sb,
 		 */
 		if (le32_to_cpu(rec.r_refcount) == 1) {
 			delete = 0;
-			ret = ocfs2_clear_ext_refcount(handle, &context->di_et,
+			ret = ocfs2_clear_ext_refcount(handle,
+						       &context->data_et,
 						       cpos, p_cluster,
 						       set_len, e_flags,
 						       context->meta_ac,
@@ -2382,19 +2389,25 @@ out:
 	return ret;
 }
 
-static int ocfs2_replace_cow(struct inode *inode,
-			     struct buffer_head *di_bh,
-			     struct buffer_head *ref_root_bh,
-			     struct ocfs2_caching_info *ref_ci,
-			     u32 cow_start, u32 cow_len,
-			     struct page **pages,
-			     int num_pages)
+static int ocfs2_di_get_clusters(struct ocfs2_cow_context *context,
+				 u32 v_cluster, u32 *p_cluster,
+				 u32 *num_clusters,
+				 unsigned int *extent_flags)
+{
+	struct inode *inode = context->inode;
+
+	return ocfs2_get_clusters(inode, v_cluster, p_cluster,
+				  num_clusters, extent_flags);
+}
+
+static int ocfs2_replace_cow(struct ocfs2_cow_context *context)
 {
 	int ret;
-	u32 p_cluster, num_clusters, start = cow_start;
+	struct inode *inode = context->inode;
+	u32 cow_start = context->cow_start, cow_len = context->cow_len;
+	u32 p_cluster, num_clusters;
 	unsigned int ext_flags;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	struct ocfs2_cow_context context;
 
 	if (!ocfs2_refcount_tree(OCFS2_SB(inode->i_sb))) {
 		ocfs2_error(inode->i_sb, "Inode %lu want to use refcount "
@@ -2403,38 +2416,18 @@ static int ocfs2_replace_cow(struct inode *inode,
 		return -EROFS;
 	}
 
-	memset(&context, 0, sizeof(context));
-
-	context.inode = inode;
-	context.cow_pages = pages;
-	context.num_pages = num_pages;
-	context.cow_start = cow_start;
-	context.cow_len = cow_len;
-	context.ref_ci = ref_ci;
-	context.ref_root_bh = ref_root_bh;
-
-	context.bhs = kcalloc(ocfs2_clusters_to_blocks(inode->i_sb, 1),
-			      sizeof(struct buffer_head *), GFP_NOFS);
-	if (!context.bhs) {
-		ret = -ENOMEM;
-		mlog_errno(ret);
-		return ret;
-	}
-
-	ocfs2_init_dealloc_ctxt(&context.dealloc);
-	ocfs2_init_dinode_extent_tree(&context.di_et,
-				      INODE_CACHE(inode), di_bh);
+	ocfs2_init_dealloc_ctxt(&context->dealloc);
 
 	while (cow_len) {
-		ret = ocfs2_get_clusters(inode, cow_start, &p_cluster,
-					 &num_clusters, &ext_flags);
+		ret = context->get_clusters(context, cow_start, &p_cluster,
+					    &num_clusters, &ext_flags);
 
 		BUG_ON(!(ext_flags & OCFS2_EXT_REFCOUNTED));
 
 		if (cow_len < num_clusters)
 			num_clusters = cow_len;
 
-		ret = ocfs2_make_clusters_writable(inode->i_sb, &context,
+		ret = ocfs2_make_clusters_writable(inode->i_sb, context,
 						   cow_start, p_cluster,
 						   num_clusters, ext_flags);
 		if (ret) {
@@ -2446,20 +2439,11 @@ static int ocfs2_replace_cow(struct inode *inode,
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
-	if (ocfs2_dealloc_has_cluster(&context.dealloc)) {
+	if (ocfs2_dealloc_has_cluster(&context->dealloc)) {
 		ocfs2_schedule_truncate_log_flush(osb, 1);
-		ocfs2_run_deallocs(osb, &context.dealloc);
+		ocfs2_run_deallocs(osb, &context->dealloc);
 	}
 
-	kfree(context.bhs);
 	return ret;
 }
 
@@ -2476,11 +2460,15 @@ int ocfs2_refcount_cow(struct inode *inode,
 	struct page **pages = NULL;
 	struct ocfs2_refcount_tree *ref_tree;
 	loff_t start, end;
+	struct ocfs2_cow_context context;
+
+	memset(&context, 0, sizeof(context));
 
 	BUG_ON(!(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL));
 	BUG_ON(!di->i_refcount_loc);
 
-	ret = ocfs2_refcount_cal_cow_clusters(inode, di_bh, cpos, write_len,
+	ret = ocfs2_refcount_cal_cow_clusters(inode, &di->id2.i_list,
+					      cpos, write_len,
 					      &cow_start, &cow_len, &has_data);
 	if (ret) {
 		mlog_errno(ret);
@@ -2518,11 +2506,40 @@ int ocfs2_refcount_cow(struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_replace_cow(inode, di_bh, ref_root_bh, &ref_tree->rf_ci,
-				cow_start, cow_len, pages, num_pages);
+	context.inode = inode;
+	context.cow_start = cow_start;
+	context.cow_len = cow_len;
+	context.ref_ci = &ref_tree->rf_ci;
+	context.ref_root_bh = ref_root_bh;
+	context.cow_pages = pages;
+	context.num_pages = num_pages;
+	context.bhs = kcalloc(ocfs2_clusters_to_blocks(inode->i_sb, 1),
+			      sizeof(struct buffer_head *), GFP_NOFS);
+	if (!context.bhs) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto out_unlock;
+	}
+
+	context.cow_duplicate_clusters = ocfs2_duplicate_clusters_by_page;
+	context.get_clusters = ocfs2_di_get_clusters;
+
+	ocfs2_init_dinode_extent_tree(&context.data_et,
+				      INODE_CACHE(inode), di_bh);
+
+	ret = ocfs2_replace_cow(&context);
 	if (ret)
 		mlog_errno(ret);
 
+	/*
+	 * truncate the extent map here since no matter whether we meet with
+	 * any error during the action, we shouldn't trust cached extent map
+	 * any more.
+	 */
+	ocfs2_extent_map_trunc(inode, cow_start);
+
+	kfree(context.bhs);
+out_unlock:
 	ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
 	brelse(ref_root_bh);
 out:
-- 
1.6.2.rc2.16.gf474c
