From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 18 Aug 2009 14:19:26 +0800
Subject: [Ocfs2-devel] [PATCH 25/41] ocfs2: Add CoW support for xattr.
In-Reply-To: <4A8A47DF.8020707@oracle.com>
References: <4A8A47DF.8020707@oracle.com>
Message-ID: <1250576382-27080-25-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In order to make 2 transcation(xattr and cow) independent with each other,
we CoW the whole xattr out in case we are setting them.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/refcounttree.c |  246 ++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ocfs2/refcounttree.h |   29 ++++++
 fs/ocfs2/xattr.c        |  234 ++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 494 insertions(+), 15 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 6029f52..d6db689 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -32,6 +32,7 @@
 #include "dlmglue.h"
 #include "extent_map.h"
 #include "aops.h"
+#include "xattr.h"
 
 #include <linux/bio.h>
 #include <linux/blkdev.h>
@@ -51,6 +52,9 @@ struct ocfs2_cow_context {
 	struct ocfs2_alloc_context *meta_ac;
 	struct ocfs2_alloc_context *data_ac;
 	struct ocfs2_cached_dealloc_ctxt dealloc;
+	void *cow_object;
+	struct ocfs2_post_refcount *post_refcount;
+	int extra_credits;
 	int (*get_clusters)(struct ocfs2_cow_context *context,
 			    u32 v_cluster, u32 *p_cluster,
 			    u32 *num_clusters,
@@ -2754,6 +2758,65 @@ unlock:
 	return ret;
 }
 
+static int ocfs2_duplicate_clusters_by_jbd(handle_t *handle,
+					   struct ocfs2_cow_context *context,
+					   u32 cpos, u32 old_cluster,
+					   u32 new_cluster, u32 new_len)
+{
+	int ret = 0;
+	struct super_block *sb = context->inode->i_sb;
+	struct ocfs2_caching_info *ci = context->data_et.et_ci;
+	int i, blocks = ocfs2_clusters_to_blocks(sb, new_len);
+	u64 old_block = ocfs2_clusters_to_blocks(sb, old_cluster);
+	u64 new_block = ocfs2_clusters_to_blocks(sb, new_cluster);
+	struct ocfs2_super *osb = OCFS2_SB(sb);
+	struct buffer_head *old_bh = NULL;
+	struct buffer_head *new_bh = NULL;
+
+	mlog(0, "old_cluster %u, new %u, len %u\n", old_cluster,
+	     new_cluster, new_len);
+
+	for (i = 0; i < blocks; i++, old_block++, new_block++) {
+		new_bh = sb_getblk(osb->sb, new_block);
+		if (new_bh == NULL) {
+			ret = -EIO;
+			mlog_errno(ret);
+			break;
+		}
+
+		ocfs2_set_new_buffer_uptodate(ci, new_bh);
+
+		ret = ocfs2_read_block(ci, old_block, &old_bh, NULL);
+		if (ret) {
+			mlog_errno(ret);
+			break;
+		}
+
+		ret = ocfs2_journal_access(handle, ci, new_bh,
+					   OCFS2_JOURNAL_ACCESS_CREATE);
+		if (ret) {
+			mlog_errno(ret);
+			break;
+		}
+
+		memcpy(new_bh->b_data, old_bh->b_data, sb->s_blocksize);
+		ret = ocfs2_journal_dirty(handle, new_bh);
+		if (ret) {
+			mlog_errno(ret);
+			break;
+		}
+
+		brelse(new_bh);
+		brelse(old_bh);
+		new_bh = NULL;
+		old_bh = NULL;
+	}
+
+	brelse(new_bh);
+	brelse(old_bh);
+	return ret;
+}
+
 static int ocfs2_clear_ext_refcount(handle_t *handle,
 				    struct ocfs2_extent_tree *et,
 				    u32 cpos, u32 p_cluster, u32 len,
@@ -2932,6 +2995,10 @@ static int ocfs2_make_clusters_writable(struct super_block *sb,
 		return ret;
 	}
 
+	if (context->post_refcount)
+		credits += context->post_refcount->credits;
+
+	credits += context->extra_credits;
 	handle = ocfs2_start_trans(osb, credits);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
@@ -3011,13 +3078,25 @@ static int ocfs2_make_clusters_writable(struct super_block *sb,
 		ref_leaf_bh = NULL;
 	}
 
+	/* handle any post_cow action. */
+	if (context->post_refcount && context->post_refcount->func) {
+		ret = context->post_refcount->func(context->inode, handle,
+						context->post_refcount->para);
+		if (ret) {
+			mlog_errno(ret);
+			goto out_commit;
+		}
+	}
+
 	/*
 	 * Here we should write the new page out first if we are
 	 * in write-back mode.
 	 */
-	ret = ocfs2_cow_sync_writeback(sb, context, cpos, num_clusters);
-	if (ret)
-		mlog_errno(ret);
+	if (context->get_clusters == ocfs2_di_get_clusters) {
+		ret = ocfs2_cow_sync_writeback(sb, context, cpos, num_clusters);
+		if (ret)
+			mlog_errno(ret);
+	}
 
 out_commit:
 	ocfs2_commit_trans(osb, handle);
@@ -3155,6 +3234,167 @@ out:
 	return ret;
 }
 
+static int ocfs2_xattr_value_get_clusters(struct ocfs2_cow_context *context,
+					  u32 v_cluster, u32 *p_cluster,
+					  u32 *num_clusters,
+					  unsigned int *extent_flags)
+{
+	struct inode *inode = context->inode;
+	struct ocfs2_xattr_value_root *xv = context->cow_object;
+
+	return ocfs2_xattr_get_clusters(inode, v_cluster, p_cluster,
+					num_clusters, &xv->xr_list,
+					extent_flags);
+}
+
+/*
+ * Given a xattr value root, calculate the most meta/credits we need for
+ * refcount tree change if we truncate it to 0.
+ */
+int ocfs2_refcounted_xattr_delete_need(struct inode *inode,
+				       struct ocfs2_caching_info *ref_ci,
+				       struct buffer_head *ref_root_bh,
+				       struct ocfs2_xattr_value_root *xv,
+				       int *meta_add, int *credits)
+{
+	int ret = 0, index, ref_blocks = 0;
+	u32 p_cluster, num_clusters;
+	u32 cpos = 0, clusters = le32_to_cpu(xv->xr_clusters);
+	struct ocfs2_refcount_block *rb;
+	struct ocfs2_refcount_rec rec;
+	struct buffer_head *ref_leaf_bh = NULL;
+
+	while (cpos < clusters) {
+		ret = ocfs2_xattr_get_clusters(inode, cpos, &p_cluster,
+					       &num_clusters, &xv->xr_list,
+					       NULL);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		cpos += num_clusters;
+
+		while (num_clusters) {
+			ret = ocfs2_get_refcount_rec(ref_ci, ref_root_bh,
+						     p_cluster, num_clusters,
+						     &rec, &index,
+						     &ref_leaf_bh);
+			if (ret) {
+				mlog_errno(ret);
+				goto out;
+			}
+
+			BUG_ON(!rec.r_refcount);
+
+			rb = (struct ocfs2_refcount_block *)ref_leaf_bh->b_data;
+
+			/*
+			 * We really don't know whether the other clusters is in
+			 * this refcount block or not, so just take the worst
+			 * case that all the clusters are in this block and each
+			 * one will split a refcount rec, so totally we need
+			 * clusters * 2 new refcount rec.
+			 */
+			if (le64_to_cpu(rb->rf_records.rl_used) + clusters * 2 >
+			    le16_to_cpu(rb->rf_records.rl_count))
+				ref_blocks++;
+
+			*credits += 1;
+			brelse(ref_leaf_bh);
+			ref_leaf_bh = NULL;
+
+			if (num_clusters <= le32_to_cpu(rec.r_clusters))
+				break;
+			else
+				num_clusters -= le32_to_cpu(rec.r_clusters);
+			p_cluster += num_clusters;
+		}
+	}
+
+	*meta_add += ref_blocks;
+	if (!ref_blocks)
+		goto out;
+
+	rb = (struct ocfs2_refcount_block *)ref_root_bh->b_data;
+	if (le32_to_cpu(rb->rf_flags) & OCFS2_REFCOUNT_TREE_FL)
+		*credits += OCFS2_EXPAND_REFCOUNT_TREE_CREDITS;
+	else {
+		struct ocfs2_extent_tree et;
+
+		ocfs2_init_refcount_extent_tree(&et, ref_ci, ref_root_bh);
+		*credits += ocfs2_calc_extend_credits(inode->i_sb,
+						      et.et_root_el,
+						      ref_blocks);
+	}
+
+out:
+	brelse(ref_leaf_bh);
+	return ret;
+}
+
+/*
+ * Do CoW for xattr.
+ */
+int ocfs2_refcount_cow_xattr(struct inode *inode,
+			     struct ocfs2_dinode *di,
+			     struct ocfs2_xattr_value_buf *vb,
+			     struct ocfs2_refcount_tree *ref_tree,
+			     struct buffer_head *ref_root_bh,
+			     u32 cpos, u32 write_len,
+			     struct ocfs2_post_refcount *post)
+{
+	int ret;
+	struct ocfs2_xattr_value_root *xv = vb->vb_xv;
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct ocfs2_cow_context *context = NULL;
+	u32 cow_start, cow_len;
+
+	BUG_ON(!(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL));
+
+	ret = ocfs2_refcount_cal_cow_clusters(inode, &xv->xr_list,
+					      cpos, write_len, UINT_MAX,
+					      &cow_start, &cow_len);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	BUG_ON(cow_len == 0);
+
+	context = kzalloc(sizeof(struct ocfs2_cow_context), GFP_NOFS);
+	if (!context) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto out;
+	}
+
+	context->inode = inode;
+	context->cow_start = cow_start;
+	context->cow_len = cow_len;
+	context->ref_tree = ref_tree;
+	context->ref_root_bh = ref_root_bh;;
+	context->cow_object = xv;
+
+	context->cow_duplicate_clusters = ocfs2_duplicate_clusters_by_jbd;
+	/* We need the extra credits for duplicate_clusters by jbd. */
+	context->extra_credits =
+		ocfs2_clusters_to_blocks(inode->i_sb, 1) * cow_len;
+	context->get_clusters = ocfs2_xattr_value_get_clusters;
+	context->post_refcount = post;
+
+	ocfs2_init_xattr_value_extent_tree(&context->data_et,
+					   INODE_CACHE(inode), vb);
+
+	ret = ocfs2_replace_cow(context);
+	if (ret)
+		mlog_errno(ret);
+
+out:
+	kfree(context);
+	return ret;
+}
+
 /*
  * Insert a new extent into refcount tree and mark a extent rec
  * as refcounted in the dinode tree.
diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
index 5539211..cd62eeb 100644
--- a/fs/ocfs2/refcounttree.h
+++ b/fs/ocfs2/refcounttree.h
@@ -54,4 +54,33 @@ int ocfs2_prepare_refcount_change_for_del(struct inode *inode,
 					  struct ocfs2_alloc_context **meta_ac);
 int ocfs2_refcount_cow(struct inode *inode, struct buffer_head *di_bh,
 		       u32 cpos, u32 write_len, u32 max_cpos);
+
+typedef int (ocfs2_post_refcount_func)(struct inode *inode,
+				       handle_t *handle,
+				       void *para);
+/*
+ * Some refcount caller need to do more work after we modify the data b-tree
+ * during refcount operation(including CoW and add refcount flag), and make the
+ * transaction complete. So it must give us this structure so that we can do it
+ * within our transaction.
+ *
+ */
+struct ocfs2_post_refcount {
+	int credits;			/* credits it need for journal. */
+	ocfs2_post_refcount_func *func;	/* real function. */
+	void *para;
+};
+
+int ocfs2_refcounted_xattr_delete_need(struct inode *inode,
+				       struct ocfs2_caching_info *ref_ci,
+				       struct buffer_head *ref_root_bh,
+				       struct ocfs2_xattr_value_root *xv,
+				       int *meta_add, int *credits);
+int ocfs2_refcount_cow_xattr(struct inode *inode,
+			     struct ocfs2_dinode *di,
+			     struct ocfs2_xattr_value_buf *vb,
+			     struct ocfs2_refcount_tree *ref_tree,
+			     struct buffer_head *ref_root_bh,
+			     u32 cpos, u32 write_len,
+			     struct ocfs2_post_refcount *post);
 #endif /* OCFS2_REFCOUNTTREE_H */
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index dda49c0..a538ceb 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -55,7 +55,7 @@
 #include "buffer_head_io.h"
 #include "super.h"
 #include "xattr.h"
-
+#include "refcounttree.h"
 
 struct ocfs2_xattr_def_value_root {
 	struct ocfs2_xattr_value_root	xv;
@@ -176,6 +176,14 @@ static int ocfs2_mv_xattr_buckets(struct inode *inode, handle_t *handle,
 				  u64 src_blk, u64 last_blk, u64 to_blk,
 				  unsigned int start_bucket,
 				  u32 *first_hash);
+static int ocfs2_prepare_refcount_xattr(struct inode *inode,
+					struct ocfs2_dinode *di,
+					struct ocfs2_xattr_info *xi,
+					struct ocfs2_xattr_search *xis,
+					struct ocfs2_xattr_search *xbs,
+					struct ocfs2_refcount_tree **ref_tree,
+					int *meta_need,
+					int *credits);
 
 static inline u16 ocfs2_xattr_buckets_per_cluster(struct ocfs2_super *osb)
 {
@@ -647,6 +655,7 @@ leave:
 static int __ocfs2_remove_xattr_range(struct inode *inode,
 				      struct ocfs2_xattr_value_buf *vb,
 				      u32 cpos, u32 phys_cpos, u32 len,
+				      unsigned int ext_flags,
 				      struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	int ret;
@@ -678,7 +687,14 @@ static int __ocfs2_remove_xattr_range(struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_cache_cluster_dealloc(&ctxt->dealloc, phys_blkno, len);
+	if (ext_flags & OCFS2_EXT_REFCOUNTED)
+		ret = ocfs2_decrease_refcount(inode, handle,
+					ocfs2_blocks_to_clusters(inode->i_sb,
+								 phys_blkno),
+					len, ctxt->meta_ac, &ctxt->dealloc, 1);
+	else
+		ret = ocfs2_cache_cluster_dealloc(&ctxt->dealloc,
+						  phys_blkno, len);
 	if (ret)
 		mlog_errno(ret);
 
@@ -693,6 +709,7 @@ static int ocfs2_xattr_shrink_size(struct inode *inode,
 				   struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	int ret = 0;
+	unsigned int ext_flags;
 	u32 trunc_len, cpos, phys_cpos, alloc_size;
 	u64 block;
 
@@ -704,7 +721,7 @@ static int ocfs2_xattr_shrink_size(struct inode *inode,
 	while (trunc_len) {
 		ret = ocfs2_xattr_get_clusters(inode, cpos, &phys_cpos,
 					       &alloc_size,
-					       &vb->vb_xv->xr_list, NULL);
+					       &vb->vb_xv->xr_list, &ext_flags);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -715,7 +732,7 @@ static int ocfs2_xattr_shrink_size(struct inode *inode,
 
 		ret = __ocfs2_remove_xattr_range(inode, vb, cpos,
 						 phys_cpos, alloc_size,
-						 ctxt);
+						 ext_flags, ctxt);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -1182,7 +1199,7 @@ static int ocfs2_xattr_get(struct inode *inode,
 
 static int __ocfs2_xattr_set_value_outside(struct inode *inode,
 					   handle_t *handle,
-					   struct ocfs2_xattr_value_root *xv,
+					   struct ocfs2_xattr_value_buf *vb,
 					   const void *value,
 					   int value_len)
 {
@@ -1193,18 +1210,22 @@ static int __ocfs2_xattr_set_value_outside(struct inode *inode,
 	u32 clusters = ocfs2_clusters_for_bytes(inode->i_sb, value_len);
 	u64 blkno;
 	struct buffer_head *bh = NULL;
+	unsigned int ext_flags;
+	struct ocfs2_xattr_value_root *xv = vb->vb_xv;
 
 	BUG_ON(clusters > le32_to_cpu(xv->xr_clusters));
 
 	while (cpos < clusters) {
 		ret = ocfs2_xattr_get_clusters(inode, cpos, &p_cluster,
 					       &num_clusters, &xv->xr_list,
-					       NULL);
+					       &ext_flags);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
 		}
 
+		BUG_ON(ext_flags & OCFS2_EXT_REFCOUNTED);
+
 		blkno = ocfs2_clusters_to_blocks(inode->i_sb, p_cluster);
 
 		for (i = 0; i < num_clusters * bpc; i++, blkno++) {
@@ -1356,7 +1377,7 @@ static int ocfs2_xattr_set_value_outside(struct inode *inode,
 		mlog_errno(ret);
 		return ret;
 	}
-	ret = __ocfs2_xattr_set_value_outside(inode, ctxt->handle, vb->vb_xv,
+	ret = __ocfs2_xattr_set_value_outside(inode, ctxt->handle, vb,
 					      xi->value, xi->value_len);
 	if (ret < 0)
 		mlog_errno(ret);
@@ -1595,7 +1616,7 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 
 				ret = __ocfs2_xattr_set_value_outside(inode,
 								handle,
-								vb.vb_xv,
+								&vb,
 								xi->value,
 								xi->value_len);
 				if (ret < 0)
@@ -2431,6 +2452,7 @@ static int ocfs2_init_xattr_set_ctxt(struct inode *inode,
 				     struct ocfs2_xattr_search *xis,
 				     struct ocfs2_xattr_search *xbs,
 				     struct ocfs2_xattr_set_ctxt *ctxt,
+				     int extra_meta,
 				     int *credits)
 {
 	int clusters_add, meta_add, ret;
@@ -2447,6 +2469,7 @@ static int ocfs2_init_xattr_set_ctxt(struct inode *inode,
 		return ret;
 	}
 
+	meta_add += extra_meta;
 	mlog(0, "Set xattr %s, reserve meta blocks = %d, clusters = %d, "
 	     "credits = %d\n", xi->name, meta_add, clusters_add, *credits);
 
@@ -2714,10 +2737,11 @@ int ocfs2_xattr_set(struct inode *inode,
 {
 	struct buffer_head *di_bh = NULL;
 	struct ocfs2_dinode *di;
-	int ret, credits;
+	int ret, credits, ref_meta = 0, ref_credits = 0;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct inode *tl_inode = osb->osb_tl_inode;
 	struct ocfs2_xattr_set_ctxt ctxt = { NULL, NULL, };
+	struct ocfs2_refcount_tree *ref_tree = NULL;
 
 	struct ocfs2_xattr_info xi = {
 		.name_index = name_index,
@@ -2782,6 +2806,17 @@ int ocfs2_xattr_set(struct inode *inode,
 			goto cleanup;
 	}
 
+	/* Check whether the value is refcounted and do some prepartion. */
+	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL &&
+	    (!xis.not_found || !xbs.not_found)) {
+		ret = ocfs2_prepare_refcount_xattr(inode, di, &xi,
+						   &xis, &xbs, &ref_tree,
+						   &ref_meta, &ref_credits);
+		if (ret) {
+			mlog_errno(ret);
+			goto cleanup;
+		}
+	}
 
 	mutex_lock(&tl_inode->i_mutex);
 
@@ -2796,7 +2831,7 @@ int ocfs2_xattr_set(struct inode *inode,
 	mutex_unlock(&tl_inode->i_mutex);
 
 	ret = ocfs2_init_xattr_set_ctxt(inode, di, &xi, &xis,
-					&xbs, &ctxt, &credits);
+					&xbs, &ctxt, ref_meta, &credits);
 	if (ret) {
 		mlog_errno(ret);
 		goto cleanup;
@@ -2804,7 +2839,7 @@ int ocfs2_xattr_set(struct inode *inode,
 
 	/* we need to update inode's ctime field, so add credit for it. */
 	credits += OCFS2_INODE_UPDATE_CREDITS;
-	ctxt.handle = ocfs2_start_trans(osb, credits);
+	ctxt.handle = ocfs2_start_trans(osb, credits + ref_credits);
 	if (IS_ERR(ctxt.handle)) {
 		ret = PTR_ERR(ctxt.handle);
 		mlog_errno(ret);
@@ -2823,6 +2858,8 @@ int ocfs2_xattr_set(struct inode *inode,
 		ocfs2_schedule_truncate_log_flush(osb, 1);
 	ocfs2_run_deallocs(osb, &ctxt.dealloc);
 cleanup:
+	if (ref_tree)
+		ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
 	up_write(&OCFS2_I(inode)->ip_xattr_sem);
 	ocfs2_inode_unlock(inode, 1);
 cleanup_nolock:
@@ -4802,6 +4839,9 @@ static int ocfs2_xattr_bucket_set_value_outside(struct inode *inode,
 	struct ocfs2_xattr_entry *xe = xs->here;
 	struct ocfs2_xattr_header *xh = bucket_xh(xs->bucket);
 	void *base;
+	struct ocfs2_xattr_value_buf vb = {
+		.vb_access = ocfs2_journal_access,
+	};
 
 	BUG_ON(!xs->base || !xe || ocfs2_xattr_is_local(xe));
 
@@ -4818,8 +4858,10 @@ static int ocfs2_xattr_bucket_set_value_outside(struct inode *inode,
 	xv = (struct ocfs2_xattr_value_root *)(base + offset +
 		 OCFS2_XATTR_SIZE(xe->xe_name_len));
 
+	vb.vb_xv = xv;
+	vb.vb_bh = xs->bucket->bu_bhs[block_off];
 	ret = __ocfs2_xattr_set_value_outside(inode, handle,
-					      xv, val, value_len);
+					      &vb, val, value_len);
 	if (ret)
 		mlog_errno(ret);
 out:
@@ -5311,6 +5353,174 @@ out:
 }
 
 /*
+ * Whenever we modify a xattr value root in the bucket(e.g, CoW
+ * or change the extent record flag), we need to recalculate
+ * the metaecc for the whole bucket. So it is done here.
+ *
+ * Note:
+ * We have to give the extra credits for the caller.
+ */
+static int ocfs2_xattr_bucket_post_refcount(struct inode *inode,
+					    handle_t *handle,
+					    void *para)
+{
+	int ret;
+	struct ocfs2_xattr_bucket *bucket =
+			(struct ocfs2_xattr_bucket *)para;
+
+	ret = ocfs2_xattr_bucket_journal_access(handle, bucket,
+						OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		return ret;
+	}
+
+	ocfs2_xattr_bucket_journal_dirty(handle, bucket);
+
+	return 0;
+}
+
+/*
+ * Special action we need if the xattr value is refcounted.
+ *
+ * 1. If the xattr is refcounted, lock the tree.
+ * 2. CoW the xattr if we are setting the new value and the value
+ *    will be stored outside.
+ * 3. In other case, decrease_refcount will work for us, so just
+ *    lock the refcount tree, calculate the meta and credits is OK.
+ *
+ * We have to do CoW before ocfs2_init_xattr_set_ctxt since
+ * currently CoW is a completed transaction, while this function
+ * will also lock the allocators and let us deadlock. So we will
+ * CoW the whole xattr value.
+ */
+static int ocfs2_prepare_refcount_xattr(struct inode *inode,
+					struct ocfs2_dinode *di,
+					struct ocfs2_xattr_info *xi,
+					struct ocfs2_xattr_search *xis,
+					struct ocfs2_xattr_search *xbs,
+					struct ocfs2_refcount_tree **ref_tree,
+					int *meta_add,
+					int *credits)
+{
+	int ret = 0;
+	struct ocfs2_xattr_block *xb;
+	struct ocfs2_xattr_entry *xe;
+	char *base;
+	u32 p_cluster, num_clusters;
+	unsigned int ext_flags;
+	int name_offset, name_len;
+	struct ocfs2_xattr_value_buf vb;
+	struct ocfs2_xattr_bucket *bucket = NULL;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_post_refcount refcount;
+	struct ocfs2_post_refcount *p = NULL;
+	struct buffer_head *ref_root_bh = NULL;
+
+	if (!xis->not_found) {
+		xe = xis->here;
+		name_offset = le16_to_cpu(xe->xe_name_offset);
+		name_len = OCFS2_XATTR_SIZE(xe->xe_name_len);
+		base = xis->base;
+		vb.vb_bh = xis->inode_bh;
+		vb.vb_access = ocfs2_journal_access_di;
+	} else {
+		int i, block_off = 0;
+		xb = (struct ocfs2_xattr_block *)xbs->xattr_bh->b_data;
+		xe = xbs->here;
+		name_offset = le16_to_cpu(xe->xe_name_offset);
+		name_len = OCFS2_XATTR_SIZE(xe->xe_name_len);
+		i = xbs->here - xbs->header->xh_entries;
+
+		if (le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED) {
+			ret = ocfs2_xattr_bucket_get_name_value(inode,
+							bucket_xh(xbs->bucket),
+							i, &block_off,
+							&name_offset);
+			if (ret) {
+				mlog_errno(ret);
+				goto out;
+			}
+			base = bucket_block(xbs->bucket, block_off);
+			vb.vb_bh = xbs->bucket->bu_bhs[block_off];
+			vb.vb_access = ocfs2_journal_access;
+
+			if (ocfs2_meta_ecc(osb)) {
+				/*create parameters for ocfs2_post_refcount. */
+				bucket = xbs->bucket;
+				refcount.credits = bucket->bu_blocks;
+				refcount.para = bucket;
+				refcount.func =
+					ocfs2_xattr_bucket_post_refcount;
+				p = &refcount;
+			}
+		} else {
+			base = xbs->base;
+			vb.vb_bh = xbs->xattr_bh;
+			vb.vb_access = ocfs2_journal_access_xb;
+		}
+	}
+
+	if (ocfs2_xattr_is_local(xe))
+		goto out;
+
+	vb.vb_xv = (struct ocfs2_xattr_value_root *)
+				(base + name_offset + name_len);
+
+	ret = ocfs2_xattr_get_clusters(inode, 0, &p_cluster,
+				       &num_clusters, &vb.vb_xv->xr_list,
+				       &ext_flags);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	/*
+	 * We just need to check the 1st extent record, since we always
+	 * CoW the whole xattr. So there shouldn't be a xattr with
+	 * some REFCOUNT extent recs after the 1st one.
+	 */
+	if (!(ext_flags & OCFS2_EXT_REFCOUNTED))
+		goto out;
+
+	ret = ocfs2_lock_refcount_tree(osb, le64_to_cpu(di->i_refcount_loc),
+				       1, ref_tree, &ref_root_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	/*
+	 * If we are deleting the xattr or the new size will be stored inside,
+	 * cool, leave it there, the xattr truncate process will remove them
+	 * for us(it still needs the refcount tree lock and the meta, credits).
+	 * And the worse case is that every cluster truncate will split the
+	 * refcount tree, and make the original extent become 3. So we will need
+	 * 2 * cluster more extent recs at most.
+	 */
+	if (!xi->value || xi->value_len <= OCFS2_XATTR_INLINE_SIZE) {
+
+		ret = ocfs2_refcounted_xattr_delete_need(inode,
+							 &(*ref_tree)->rf_ci,
+							 ref_root_bh, vb.vb_xv,
+							 meta_add, credits);
+		if (ret)
+			mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_refcount_cow_xattr(inode, di, &vb,
+				       *ref_tree, ref_root_bh, 0,
+				       le32_to_cpu(vb.vb_xv->xr_clusters), p);
+	if (ret)
+		mlog_errno(ret);
+
+out:
+	brelse(ref_root_bh);
+	return ret;
+}
+
+/*
  * 'security' attributes support
  */
 static size_t ocfs2_xattr_security_list(struct inode *inode, char *list,
-- 
1.6.2.rc2.16.gf474c
