From: Tao Ma <tao.ma@oracle.com>
Date: Fri,  3 Apr 2009 07:46:11 +0800
Subject: [Ocfs2-devel] [PATCH 32/42] ocfs2: Add CoW support for xattr.
In-Reply-To: <49D5CAC2.4010201@oracle.com>
References: <49D5CAC2.4010201@oracle.com>
Message-ID: <1238715981-21488-32-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In order to make 2 transcation(xattr and cow) independent with each other,
we CoW the whole xattr out in case we are setting them.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c        |    2 +-
 fs/ocfs2/refcounttree.c |  160 +++++++++++++++++++++++++++--
 fs/ocfs2/refcounttree.h |   26 +++++-
 fs/ocfs2/xattr.c        |  264 ++++++++++++++++++++++++++++++++++++++++++++--
 4 files changed, 429 insertions(+), 23 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index a09bfb5..d2a058a 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -7052,7 +7052,7 @@ static int ocfs2_do_truncate(struct ocfs2_super *osb,
 
 	if (delete_blk) {
 		if (rec_flags & OCFS2_EXT_REFCOUNTED)
-			status = ocfs2_decrease_refcount(inode, fe_bh, handle,
+			status = ocfs2_decrease_refcount(inode, handle,
 					ocfs2_blocks_to_clusters(osb->sb,
 								 delete_blk),
 					clusters_to_del, meta_ac,
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index bf03d21..7eaab1d 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -32,6 +32,7 @@
 #include "extent_map.h"
 #include "aops.h"
 #include "namei.h"
+#include "xattr.h"
 
 #include <linux/security.h>
 #include <linux/quotaops.h>
@@ -48,6 +49,7 @@ struct ocfs2_cow_context {
 	struct buffer_head **bhs;
 	struct page **cow_pages;
 	int num_pages;
+	struct ocfs2_xattr_value_root *cow_xv;
 	u32 cow_start;
 	u32 cow_len;
 	int (*get_clusters)(struct ocfs2_cow_context *context,
@@ -65,6 +67,8 @@ static void ocfs2_delete_refcount_tree(struct ocfs2_super *osb,
 				       struct ocfs2_refcount_tree *tree);
 static int ocfs2_get_refcount_tree(struct ocfs2_super *osb, u64 rf_blkno,
 				   struct ocfs2_refcount_tree **ret_tree);
+static int ocfs2_get_refcount_tree_by_inode(struct inode *inode,
+					struct ocfs2_refcount_tree **ret_tree);
 
 static int ocfs2_validate_refcount_block(struct super_block *sb,
 					 struct buffer_head *bh)
@@ -709,7 +713,7 @@ out:
 	return ret;
 }
 
-int ocfs2_decrease_refcount(struct inode *inode, struct buffer_head *di_bh,
+int ocfs2_decrease_refcount(struct inode *inode,
 			    handle_t *handle, u32 cpos, u32 len,
 			    struct ocfs2_alloc_context *meta_ac,
 			    struct ocfs2_cached_dealloc_ctxt *dealloc,
@@ -718,22 +722,18 @@ int ocfs2_decrease_refcount(struct inode *inode, struct buffer_head *di_bh,
 	int ret;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct buffer_head *ref_bh = NULL;
-	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 	struct ocfs2_extent_tree et;
 	struct ocfs2_refcount_tree *tree;
 
 	BUG_ON(!(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL));
-	BUG_ON(!di->i_refcount_loc);
 
-	ret = ocfs2_get_refcount_tree(OCFS2_SB(inode->i_sb),
-				      le64_to_cpu(di->i_refcount_loc), &tree);
+	ret = ocfs2_get_refcount_tree_by_inode(inode, &tree);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
 	}
 
-	ret = ocfs2_read_refcount_block(&tree->rf_ci,
-					le64_to_cpu(di->i_refcount_loc),
+	ret = ocfs2_read_refcount_block(&tree->rf_ci, tree->rf_blkno,
 					&ref_bh);
 	if (ret) {
 		mlog_errno(ret);
@@ -1190,6 +1190,65 @@ out:
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
@@ -1382,7 +1441,7 @@ static int ocfs2_di_get_clusters(struct ocfs2_cow_context *context,
 }
 
 static int ocfs2_replace_cow(struct ocfs2_cow_context *context,
-			     int num_recs)
+			     int num_recs, struct ocfs2_post_refcount *post)
 {
 	int ret, credits;
 	struct inode *inode = context->inode;
@@ -1414,6 +1473,8 @@ static int ocfs2_replace_cow(struct ocfs2_cow_context *context,
 	 */
 	credits += ocfs2_remove_extent_credits(inode->i_sb) * num_recs * 2;
 
+	if (post)
+		credits += post->credits;
 	handle = ocfs2_start_trans(osb, credits);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
@@ -1442,6 +1503,13 @@ static int ocfs2_replace_cow(struct ocfs2_cow_context *context,
 		cow_start += num_clusters;
 	}
 
+	/* handle some pos_cow case. */
+	if (post && post->func) {
+		ret = post->func(inode, handle, post->para);
+		if (ret)
+			mlog_errno(ret);
+	}
+
 	ocfs2_commit_trans(osb, handle);
 
 out:
@@ -1539,7 +1607,7 @@ int ocfs2_refcount_cow(struct inode *inode,
 	ocfs2_init_refcount_extent_tree(&context.ref_et,
 					&ref_tree->rf_ci, ref_bh);
 
-	ret = ocfs2_replace_cow(&context, num_recs);
+	ret = ocfs2_replace_cow(&context, num_recs, NULL);
 	if (ret)
 		mlog_errno(ret);
 
@@ -1562,6 +1630,80 @@ out:
 	return ret;
 }
 
+static int ocfs2_xattr_value_get_clusters(struct ocfs2_cow_context *context,
+					  u32 v_cluster, u32 *p_cluster,
+					  u32 *num_clusters,
+					  unsigned int *extent_flags)
+{
+	struct inode *inode = context->inode;
+	struct ocfs2_xattr_value_root *xv = context->cow_xv;
+
+	return ocfs2_xattr_get_clusters(inode, v_cluster, p_cluster,
+					num_clusters, &xv->xr_list,
+					extent_flags);
+}
+
+/*
+ * Do CoW for xattr.
+ */
+int ocfs2_refcount_cow_xattr(struct inode *inode,
+			     struct ocfs2_dinode *di,
+			     struct ocfs2_xattr_value_buf *vb,
+			     struct ocfs2_refcount_tree *ref_tree,
+			     struct buffer_head *ref_bh,
+			     u32 cpos, u32 write_len,
+			     struct ocfs2_post_refcount *post)
+{
+	int ret, num_recs, has_data;
+	struct ocfs2_xattr_value_root *xv = vb->vb_xv;
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct ocfs2_cow_context context;
+	u32 cow_start, cow_len;
+
+	memset(&context, 0, sizeof(context));
+
+	BUG_ON(!(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL));
+
+	ret = ocfs2_refcount_cal_cow_clusters(inode, &xv->xr_list,
+					      cpos, write_len,
+					      &cow_start, &cow_len,
+					      &num_recs, &has_data);
+	if (ret) {
+		mlog_errno(ret);
+		return ret;
+	}
+
+	BUG_ON(cow_len == 0 || num_recs == 0 || has_data == 0);
+
+	context.inode = inode;
+	context.cow_start = cow_start;
+	context.cow_len = cow_len;
+	context.cow_xv = xv;
+	context.bhs = kcalloc(ocfs2_clusters_to_blocks(inode->i_sb, 1),
+			      sizeof(struct buffer_head *), GFP_NOFS);
+	if (!context.bhs) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto out;
+	}
+
+	context.cow_duplicate_clusters = ocfs2_duplicate_clusters_by_jbd;
+	context.get_clusters = ocfs2_xattr_value_get_clusters;
+
+	ocfs2_init_xattr_value_extent_tree(&context.data_et,
+					   INODE_CACHE(inode), vb);
+	ocfs2_init_refcount_extent_tree(&context.ref_et,
+					&ref_tree->rf_ci, ref_bh);
+
+	ret = ocfs2_replace_cow(&context, num_recs, post);
+	if (ret)
+		mlog_errno(ret);
+
+out:
+	kfree(context.bhs);
+	return ret;
+}
+
 /*
  * Insert a new extent into refcount tree and mark a extent rec
  * as refcounted in the dinode tree.
diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
index 5c3faaf..32ae584 100644
--- a/fs/ocfs2/refcounttree.h
+++ b/fs/ocfs2/refcounttree.h
@@ -48,7 +48,7 @@ int ocfs2_set_refcount_tree(struct inode *inode,
 			    u64 blkno);
 int ocfs2_remove_refcount_tree(struct inode *inode, struct buffer_head *di_bh);
 
-int ocfs2_decrease_refcount(struct inode *inode, struct buffer_head *di_bh,
+int ocfs2_decrease_refcount(struct inode *inode,
 			    handle_t *handle, u32 cpos, u32 len,
 			    struct ocfs2_alloc_context *meta_ac,
 			    struct ocfs2_cached_dealloc_ctxt *dealloc,
@@ -69,4 +69,28 @@ int ocfs2_lock_refcount_tree(struct ocfs2_super *osb, u64 ref_blkno, int rw,
 void ocfs2_unlock_refcount_tree(struct ocfs2_super *osb,
 				struct ocfs2_refcount_tree *tree,
 				int rw);
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
+int ocfs2_refcount_cow_xattr(struct inode *inode,
+			     struct ocfs2_dinode *di,
+			     struct ocfs2_xattr_value_buf *vb,
+			     struct ocfs2_refcount_tree *ref_tree,
+			     struct buffer_head *ref_bh,
+			     u32 cpos, u32 write_len,
+			     struct ocfs2_post_refcount *post);
 #endif /* OCFS2_REFCOUNTTREE_H */
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 0d81862..15d89a7 100644
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
@@ -175,6 +175,14 @@ static int ocfs2_mv_xattr_buckets(struct inode *inode, handle_t *handle,
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
@@ -642,6 +650,7 @@ leave:
 static int __ocfs2_remove_xattr_range(struct inode *inode,
 				      struct ocfs2_xattr_value_buf *vb,
 				      u32 cpos, u32 phys_cpos, u32 len,
+				      unsigned int ext_flags,
 				      struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	int ret;
@@ -673,7 +682,14 @@ static int __ocfs2_remove_xattr_range(struct inode *inode,
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
 
@@ -688,6 +704,7 @@ static int ocfs2_xattr_shrink_size(struct inode *inode,
 				   struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	int ret = 0;
+	unsigned int ext_flags;
 	u32 trunc_len, cpos, phys_cpos, alloc_size;
 	u64 block;
 
@@ -699,7 +716,7 @@ static int ocfs2_xattr_shrink_size(struct inode *inode,
 	while (trunc_len) {
 		ret = ocfs2_xattr_get_clusters(inode, cpos, &phys_cpos,
 					       &alloc_size,
-					       &vb->vb_xv->xr_list, NULL);
+					       &vb->vb_xv->xr_list, &ext_flags);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -710,7 +727,7 @@ static int ocfs2_xattr_shrink_size(struct inode *inode,
 
 		ret = __ocfs2_remove_xattr_range(inode, vb, cpos,
 						 phys_cpos, alloc_size,
-						 ctxt);
+						 ext_flags, ctxt);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -1176,7 +1193,7 @@ static int ocfs2_xattr_get(struct inode *inode,
 
 static int __ocfs2_xattr_set_value_outside(struct inode *inode,
 					   handle_t *handle,
-					   struct ocfs2_xattr_value_root *xv,
+					   struct ocfs2_xattr_value_buf *vb,
 					   const void *value,
 					   int value_len)
 {
@@ -1187,18 +1204,22 @@ static int __ocfs2_xattr_set_value_outside(struct inode *inode,
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
@@ -1350,7 +1371,7 @@ static int ocfs2_xattr_set_value_outside(struct inode *inode,
 		mlog_errno(ret);
 		return ret;
 	}
-	ret = __ocfs2_xattr_set_value_outside(inode, ctxt->handle, vb->vb_xv,
+	ret = __ocfs2_xattr_set_value_outside(inode, ctxt->handle, vb,
 					      xi->value, xi->value_len);
 	if (ret < 0)
 		mlog_errno(ret);
@@ -1589,7 +1610,7 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 
 				ret = __ocfs2_xattr_set_value_outside(inode,
 								handle,
-								vb.vb_xv,
+								&vb,
 								xi->value,
 								xi->value_len);
 				if (ret < 0)
@@ -2425,6 +2446,7 @@ static int ocfs2_init_xattr_set_ctxt(struct inode *inode,
 				     struct ocfs2_xattr_search *xis,
 				     struct ocfs2_xattr_search *xbs,
 				     struct ocfs2_xattr_set_ctxt *ctxt,
+				     int extra_meta,
 				     int *credits)
 {
 	int clusters_add, meta_add, ret;
@@ -2441,6 +2463,7 @@ static int ocfs2_init_xattr_set_ctxt(struct inode *inode,
 		return ret;
 	}
 
+	meta_add += extra_meta;
 	mlog(0, "Set xattr %s, reserve meta blocks = %d, clusters = %d, "
 	     "credits = %d\n", xi->name, meta_add, clusters_add, *credits);
 
@@ -2708,10 +2731,11 @@ int ocfs2_xattr_set(struct inode *inode,
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
@@ -2776,6 +2800,17 @@ int ocfs2_xattr_set(struct inode *inode,
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
 
@@ -2790,7 +2825,7 @@ int ocfs2_xattr_set(struct inode *inode,
 	mutex_unlock(&tl_inode->i_mutex);
 
 	ret = ocfs2_init_xattr_set_ctxt(inode, di, &xi, &xis,
-					&xbs, &ctxt, &credits);
+					&xbs, &ctxt, ref_meta, &credits);
 	if (ret) {
 		mlog_errno(ret);
 		goto cleanup;
@@ -2798,7 +2833,7 @@ int ocfs2_xattr_set(struct inode *inode,
 
 	/* we need to update inode's ctime field, so add credit for it. */
 	credits += OCFS2_INODE_UPDATE_CREDITS;
-	ctxt.handle = ocfs2_start_trans(osb, credits);
+	ctxt.handle = ocfs2_start_trans(osb, credits + ref_credits);
 	if (IS_ERR(ctxt.handle)) {
 		ret = PTR_ERR(ctxt.handle);
 		mlog_errno(ret);
@@ -2817,6 +2852,8 @@ int ocfs2_xattr_set(struct inode *inode,
 		ocfs2_schedule_truncate_log_flush(osb, 1);
 	ocfs2_run_deallocs(osb, &ctxt.dealloc);
 cleanup:
+	if (ref_tree)
+		ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
 	up_write(&OCFS2_I(inode)->ip_xattr_sem);
 	ocfs2_inode_unlock(inode, 1);
 cleanup_nolock:
@@ -4800,6 +4837,9 @@ static int ocfs2_xattr_bucket_set_value_outside(struct inode *inode,
 	struct ocfs2_xattr_entry *xe = xs->here;
 	struct ocfs2_xattr_header *xh = bucket_xh(xs->bucket);
 	void *base;
+	struct ocfs2_xattr_value_buf vb = {
+		.vb_access = ocfs2_journal_access,
+	};
 
 	BUG_ON(!xs->base || !xe || ocfs2_xattr_is_local(xe));
 
@@ -4816,8 +4856,10 @@ static int ocfs2_xattr_bucket_set_value_outside(struct inode *inode,
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
@@ -5308,6 +5350,204 @@ out:
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
+ * Given a xattr value, calculate the most meta/credits we need
+ * if we truncat it to 0.
+ */
+static int ocfs2_refcounted_xattr_delete_need(struct ocfs2_super *osb,
+					      struct ocfs2_extent_tree *ref_et,
+					      struct ocfs2_xattr_value_root *xv,
+					      int *meta_add,
+					      int *credits)
+{
+	int ret = 0, num_free_extents = ocfs2_num_free_extents(osb, ref_et);
+
+	if (num_free_extents < 0) {
+		ret = num_free_extents;
+		mlog_errno(ret);
+		goto out;
+	}
+
+	if (num_free_extents < le32_to_cpu(xv->xr_clusters) * 2) {
+		*meta_add = ocfs2_extend_meta_needed(ref_et->et_root_el);
+		*credits = ocfs2_calc_extend_credits(osb->sb,
+						ref_et->et_root_el,
+						le32_to_cpu(xv->xr_clusters));
+	}
+
+out:
+	return ret;
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
+	struct buffer_head *ref_bh = NULL;
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
+				       1, ref_tree, &ref_bh);
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
+		struct ocfs2_extent_tree et;
+
+		ocfs2_init_refcount_extent_tree(&et,
+						&(*ref_tree)->rf_ci, ref_bh);
+
+		ret = ocfs2_refcounted_xattr_delete_need(osb, &et, vb.vb_xv,
+							 meta_add, credits);
+		if (ret)
+			mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_refcount_cow_xattr(inode, di, &vb, *ref_tree, ref_bh, 0,
+				       le32_to_cpu(vb.vb_xv->xr_clusters), p);
+	if (ret)
+		mlog_errno(ret);
+
+out:
+	brelse(ref_bh);
+	return ret;
+}
+
+/*
  * 'security' attributes support
  */
 static size_t ocfs2_xattr_security_list(struct inode *inode, char *list,
-- 
1.6.2.rc2.16.gf474c
