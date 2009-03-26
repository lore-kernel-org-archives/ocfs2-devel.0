From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 27 Mar 2009 07:02:36 +0800
Subject: [Ocfs2-devel] [PATCH 30/42] ocfs2: Abstract duplicate clusters
	process in CoW.
In-Reply-To: <49CC86FC.2070906@oracle.com>
References: <49CC86FC.2070906@oracle.com>
Message-ID: <1238108568-23740-30-git-send-email-tao.ma@oracle.com>
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
 fs/ocfs2/refcounttree.c |  156 ++++++++++++++++++++++++++---------------------
 1 files changed, 87 insertions(+), 69 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index ec6ec0b..4970620 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -40,7 +40,7 @@
 
 struct ocfs2_cow_context {
 	struct inode *inode;
-	struct ocfs2_extent_tree di_et;
+	struct ocfs2_extent_tree data_et;
 	struct ocfs2_extent_tree ref_et;
 	struct ocfs2_alloc_context *meta_ac;
 	struct ocfs2_alloc_context *data_ac;
@@ -50,6 +50,14 @@ struct ocfs2_cow_context {
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
@@ -920,7 +928,7 @@ out:
  * use that value as the maximum clusters.
  */
 static int ocfs2_refcount_cal_cow_clusters(struct inode *inode,
-					   struct buffer_head *di_bh,
+					   struct ocfs2_extent_list *el,
 					   u32 cpos,
 					   u32 write_len,
 					   u32 *cow_start,
@@ -929,8 +937,6 @@ static int ocfs2_refcount_cal_cow_clusters(struct inode *inode,
 					   int *has_data)
 {
 	int ret = 0;
-	struct ocfs2_dinode *di = (struct ocfs2_dinode *) di_bh->b_data;
-	struct ocfs2_extent_list *el = &di->id2.i_list;
 	int tree_height = le16_to_cpu(el->l_tree_depth), i;
 	struct buffer_head *eb_bh = NULL;
 	struct ocfs2_extent_block *eb = NULL;
@@ -1061,7 +1067,7 @@ static int ocfs2_lock_refcount_cow_allocator(struct super_block *sb,
 
 	*credits = 0;
 
-	ret = ocfs2_calc_refcount_credits(sb, &context->di_et, cow_len,
+	ret = ocfs2_calc_refcount_credits(sb, &context->data_et, cow_len,
 					  &meta_add, credits);
 	if (ret) {
 		mlog_errno(ret);
@@ -1167,13 +1173,13 @@ out:
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
@@ -1309,7 +1315,7 @@ static int ocfs2_replace_clusters(handle_t *handle,
 				  unsigned int ext_flags)
 {
 	int ret;
-	struct ocfs2_caching_info *ci = context->di_et.et_ci;
+	struct ocfs2_caching_info *ci = context->data_et.et_ci;
 	u64 ino = ocfs2_metadata_cache_owner(ci);
 
 	mlog(0, "inode %llu, cpos %u, old %u, new %u, len %u, ext_flags %u\n",
@@ -1317,15 +1323,15 @@ static int ocfs2_replace_clusters(handle_t *handle,
 
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
 out:
@@ -1340,7 +1346,7 @@ static int ocfs2_make_clusters_writable(handle_t *handle,
 	int ret, delete, index;
 	u32 new_bit, new_len, r_end;
 	unsigned int set_len;
-	struct ocfs2_caching_info *inode_ci = context->di_et.et_ci;
+	struct ocfs2_caching_info *inode_ci = context->data_et.et_ci;
 	struct ocfs2_super *osb =
 			OCFS2_SB(ocfs2_metadata_cache_get_super(inode_ci));
 	struct ocfs2_path *path;
@@ -1379,7 +1385,8 @@ static int ocfs2_make_clusters_writable(handle_t *handle,
 		 */
 		if (le32_to_cpu(rec.e_refcount) == 1) {
 			delete = 0;
-			ret = ocfs2_clear_ext_refcount(handle, &context->di_et,
+			ret = ocfs2_clear_ext_refcount(handle,
+						       &context->data_et,
 						       cpos, p_cluster,
 						       set_len, e_flags,
 						       context->meta_ac,
@@ -1429,21 +1436,27 @@ static int ocfs2_make_clusters_writable(handle_t *handle,
 	return ret;
 }
 
-static int ocfs2_replace_cow(struct inode *inode,
-			     struct buffer_head *di_bh,
-			     struct buffer_head *ref_bh,
-			     struct ocfs2_caching_info *ref_ci,
-			     u32 cow_start, u32 cow_len,
-			     int num_recs,
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
+static int ocfs2_replace_cow(struct ocfs2_cow_context *context,
+			     int num_recs)
 {
 	int ret, credits;
-	u32 p_cluster, num_clusters, start = cow_start;
+	struct inode *inode = context->inode;
+	u32 cow_start = context->cow_start, cow_len = context->cow_len;
+	u32 p_cluster, num_clusters;
 	unsigned int ext_flags;
 	handle_t *handle = NULL;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	struct ocfs2_cow_context context;
 
 	if (!ocfs2_refcount_tree(OCFS2_SB(inode->i_sb))) {
 		ocfs2_error(inode->i_sb, "Inode %lu want to use refcount "
@@ -1452,36 +1465,17 @@ static int ocfs2_replace_cow(struct inode *inode,
 		return -EROFS;
 	}
 
-	memset(&context, 0, sizeof(context));
-
-	context.inode = inode;
-	context.cow_pages = pages;
-	context.num_pages = num_pages;
-	context.cow_start = cow_start;
-	context.cow_len = cow_len;
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
-	ocfs2_init_refcount_extent_tree(&context.ref_et, ref_ci, ref_bh);
+	ocfs2_init_dealloc_ctxt(&context->dealloc);
 
 	ret = ocfs2_lock_refcount_cow_allocator(inode->i_sb, cow_len,
-						&context, &credits);
+						context, &credits);
 	if (ret) {
 		mlog_errno(ret);
 		return ret;
 	}
 
 	/*
-	 * We also need the credits for removing extents for both di-tree and
+	 * We also need the credits for removing extents for both data-tree and
 	 * refcount tree and the copy of data.
 	 */
 	credits += ocfs2_remove_extent_credits(inode->i_sb) * num_recs * 2;
@@ -1494,15 +1488,15 @@ static int ocfs2_replace_cow(struct inode *inode,
 	}
 
 	while (cow_len) {
-		ret = ocfs2_get_clusters(inode, cow_start, &p_cluster,
-					 &num_clusters, &ext_flags);
+		ret = context->get_clusters(context, cow_start, &p_cluster,
+					    &num_clusters, &ext_flags);
 
 		BUG_ON(!(ext_flags & OCFS2_EXT_REFCOUNTED));
 
 		if (cow_len < num_clusters)
 			num_clusters = cow_len;
 
-		ret = ocfs2_make_clusters_writable(handle, &context, cow_start,
+		ret = ocfs2_make_clusters_writable(handle, context, cow_start,
 						   p_cluster, num_clusters,
 						   ext_flags);
 		if (ret) {
@@ -1514,27 +1508,19 @@ static int ocfs2_replace_cow(struct inode *inode,
 		cow_start += num_clusters;
 	}
 
-
-	/*
-	 * truncate the extent map here since no matter whether we meet with
-	 * any error during the action, we shouldn't trust cached extent map
-	 * any more.
-	 */
-	ocfs2_extent_map_trunc(inode, start);
 	ocfs2_commit_trans(osb, handle);
 
 out:
-	if (context.data_ac)
-		ocfs2_free_alloc_context(context.data_ac);
-	if (context.meta_ac)
-		ocfs2_free_alloc_context(context.meta_ac);
+	if (context->data_ac)
+		ocfs2_free_alloc_context(context->data_ac);
+	if (context->meta_ac)
+		ocfs2_free_alloc_context(context->meta_ac);
 
-	if (ocfs2_dealloc_has_cluster(&context.dealloc)) {
+	if (ocfs2_dealloc_has_cluster(&context->dealloc)) {
 		ocfs2_schedule_truncate_log_flush(osb, 1);
-		ocfs2_run_deallocs(osb, &context.dealloc);
+		ocfs2_run_deallocs(osb, &context->dealloc);
 	}
 
-	kfree(context.bhs);
 	return ret;
 }
 
@@ -1551,11 +1537,15 @@ int ocfs2_refcount_cow(struct inode *inode,
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
 					      &cow_start, &cow_len,
 					       &num_recs, &has_data);
 	if (ret) {
@@ -1594,12 +1584,40 @@ int ocfs2_refcount_cow(struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_replace_cow(inode, di_bh, ref_bh, &ref_tree->rf_ci,
-				cow_start, cow_len, num_recs,
-				pages, num_pages);
+	context.inode = inode;
+	context.cow_start = cow_start;
+	context.cow_len = cow_len;
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
+	ocfs2_init_refcount_extent_tree(&context.ref_et,
+					&ref_tree->rf_ci, ref_bh);
+
+	ret = ocfs2_replace_cow(&context, num_recs);
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
 	brelse(ref_bh);
 out:
-- 
1.6.2.rc2.16.gf474c
