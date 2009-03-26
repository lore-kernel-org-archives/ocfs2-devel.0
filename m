From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 27 Mar 2009 07:02:46 +0800
Subject: [Ocfs2-devel] [PATCH 40/42] ocfs2: Modify removing xattr process
	for refcount.
In-Reply-To: <49CC86FC.2070906@oracle.com>
References: <49CC86FC.2070906@oracle.com>
Message-ID: <1238108568-23740-40-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The old xattr value remove is quite simple, it just erase the
tree and free the clusters. But as we have added refcount support,
The process is a little complicated.

We have to lock the refcount tree at the beginning, what's more,
we may split the refcount tree in some cases, so meta/credits are
needed.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |  170 ++++++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 134 insertions(+), 36 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 37c3bef..cfc71c2 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -198,6 +198,11 @@ static int ocfs2_prepare_refcount_xattr(struct inode *inode,
 					struct ocfs2_refcount_tree **ref_tree,
 					int *meta_need,
 					int *credits);
+static int ocfs2_get_xattr_tree_value_root(struct super_block *sb,
+					   struct ocfs2_xattr_bucket *bucket,
+					   int offset,
+					   struct ocfs2_xattr_value_root **xv,
+					   struct buffer_head **bh);
 
 static inline u16 ocfs2_xattr_buckets_per_cluster(struct ocfs2_super *osb)
 {
@@ -1746,51 +1751,106 @@ out:
 	return ret;
 }
 
+/*
+ * In xattr remove, if it is stored outside and refcounted, we may have
+ * the chance to split the refcount tree. So need the allocators.
+ */
+static int ocfs2_lock_xattr_remove_allocators(struct inode *inode,
+					struct ocfs2_xattr_value_root *xv,
+					struct ocfs2_extent_tree *ref_et,
+					struct ocfs2_alloc_context **meta_ac,
+					int *ref_credits)
+{
+	int ret;
+	u32 p_cluster, num_clusters;
+	unsigned int ext_flags;
+
+	*ref_credits = 0;
+	ret = ocfs2_xattr_get_clusters(inode, 0, &p_cluster,
+				       &num_clusters,
+				       &xv->xr_list,
+				       &ext_flags);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	if (!(ext_flags & OCFS2_EXT_REFCOUNTED))
+		goto out;
+
+	ret = ocfs2_lock_allocators(inode, ref_et, 0,
+				le32_to_cpu(xv->xr_clusters),
+				NULL, meta_ac);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	*ref_credits = ocfs2_calc_extend_credits(inode->i_sb,
+						 ref_et->et_root_el,
+						 le32_to_cpu(xv->xr_clusters));
+out:
+	return ret;
+}
+
 static int ocfs2_remove_value_outside(struct inode*inode,
 				      struct ocfs2_xattr_value_buf *vb,
-				      struct ocfs2_xattr_header *header)
+				      struct ocfs2_xattr_header *header,
+				      struct ocfs2_extent_tree *ref_et)
 {
-	int ret = 0, i;
+	int ret = 0, i, ref_credits;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_xattr_set_ctxt ctxt = { NULL, NULL, };
+	void *val;
 
 	ocfs2_init_dealloc_ctxt(&ctxt.dealloc);
 
-	ctxt.handle = ocfs2_start_trans(osb,
-					ocfs2_remove_extent_credits(osb->sb));
-	if (IS_ERR(ctxt.handle)) {
-		ret = PTR_ERR(ctxt.handle);
-		mlog_errno(ret);
-		goto out;
-	}
-
 	for (i = 0; i < le16_to_cpu(header->xh_count); i++) {
 		struct ocfs2_xattr_entry *entry = &header->xh_entries[i];
 
-		if (!ocfs2_xattr_is_local(entry)) {
-			void *val;
+		if (ocfs2_xattr_is_local(entry))
+			continue;
 
-			val = (void *)header +
-				le16_to_cpu(entry->xe_name_offset);
-			vb->vb_xv = (struct ocfs2_xattr_value_root *)
-				(val + OCFS2_XATTR_SIZE(entry->xe_name_len));
-			ret = ocfs2_xattr_value_truncate(inode, vb, 0, &ctxt);
-			if (ret < 0) {
-				mlog_errno(ret);
-				break;
-			}
+		val = (void *)header +
+			le16_to_cpu(entry->xe_name_offset);
+		vb->vb_xv = (struct ocfs2_xattr_value_root *)
+			(val + OCFS2_XATTR_SIZE(entry->xe_name_len));
+
+		ret = ocfs2_lock_xattr_remove_allocators(inode, vb->vb_xv,
+							 ref_et, &ctxt.meta_ac,
+							 &ref_credits);
+
+		ctxt.handle = ocfs2_start_trans(osb, ref_credits +
+					ocfs2_remove_extent_credits(osb->sb));
+		if (IS_ERR(ctxt.handle)) {
+			ret = PTR_ERR(ctxt.handle);
+			mlog_errno(ret);
+			break;
+		}
+
+		ret = ocfs2_xattr_value_truncate(inode, vb, 0, &ctxt);
+		if (ret < 0) {
+			mlog_errno(ret);
+			break;
+		}
+
+		ocfs2_commit_trans(osb, ctxt.handle);
+		if (ctxt.meta_ac) {
+			ocfs2_free_alloc_context(ctxt.meta_ac);
+			ctxt.meta_ac = NULL;
 		}
 	}
 
-	ocfs2_commit_trans(osb, ctxt.handle);
+	if (ctxt.meta_ac)
+		ocfs2_free_alloc_context(ctxt.meta_ac);
 	ocfs2_schedule_truncate_log_flush(osb, 1);
 	ocfs2_run_deallocs(osb, &ctxt.dealloc);
-out:
 	return ret;
 }
 
 static int ocfs2_xattr_ibody_remove(struct inode *inode,
-				    struct buffer_head *di_bh)
+				    struct buffer_head *di_bh,
+				    struct ocfs2_extent_tree *ref_et)
 {
 
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
@@ -1805,13 +1865,14 @@ static int ocfs2_xattr_ibody_remove(struct inode *inode,
 		 ((void *)di + inode->i_sb->s_blocksize -
 		 le16_to_cpu(di->i_xattr_inline_size));
 
-	ret = ocfs2_remove_value_outside(inode, &vb, header);
+	ret = ocfs2_remove_value_outside(inode, &vb, header, ref_et);
 
 	return ret;
 }
 
 static int ocfs2_xattr_block_remove(struct inode *inode,
-				    struct buffer_head *blk_bh)
+				    struct buffer_head *blk_bh,
+				    struct ocfs2_extent_tree *ref_et)
 {
 	struct ocfs2_xattr_block *xb;
 	int ret = 0;
@@ -1823,18 +1884,19 @@ static int ocfs2_xattr_block_remove(struct inode *inode,
 	xb = (struct ocfs2_xattr_block *)blk_bh->b_data;
 	if (!(le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED)) {
 		struct ocfs2_xattr_header *header = &(xb->xb_attrs.xb_header);
-		ret = ocfs2_remove_value_outside(inode, &vb, header);
+		ret = ocfs2_remove_value_outside(inode, &vb, header, ref_et);
 	} else
 		ret = ocfs2_iterate_xattr_index_block(inode,
 						blk_bh,
 						ocfs2_rm_xattr_cluster,
-						NULL);
+						ref_et);
 
 	return ret;
 }
 
 static int ocfs2_xattr_free_block(struct inode *inode,
-				  u64 block)
+				  u64 block,
+				  struct ocfs2_extent_tree *ref_et)
 {
 	struct inode *xb_alloc_inode;
 	struct buffer_head *xb_alloc_bh = NULL;
@@ -1852,7 +1914,7 @@ static int ocfs2_xattr_free_block(struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_xattr_block_remove(inode, blk_bh);
+	ret = ocfs2_xattr_block_remove(inode, blk_bh, ref_et);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out;
@@ -1912,6 +1974,9 @@ int ocfs2_xattr_remove(struct inode *inode, struct buffer_head *di_bh)
 {
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+	struct ocfs2_refcount_tree *ref_tree = NULL;
+	struct buffer_head *ref_bh = NULL;
+	struct ocfs2_extent_tree ref_et;
 	handle_t *handle;
 	int ret;
 
@@ -1921,8 +1986,22 @@ int ocfs2_xattr_remove(struct inode *inode, struct buffer_head *di_bh)
 	if (!(oi->ip_dyn_features & OCFS2_HAS_XATTR_FL))
 		return 0;
 
+	memset(&ref_et, 0, sizeof(ref_et));
+	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL) {
+		ret = ocfs2_lock_refcount_tree(OCFS2_SB(inode->i_sb),
+					       le64_to_cpu(di->i_refcount_loc),
+					       1, &ref_tree, &ref_bh);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		ocfs2_init_refcount_extent_tree(&ref_et,
+						&ref_tree->rf_ci, ref_bh);
+	}
+
 	if (oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL) {
-		ret = ocfs2_xattr_ibody_remove(inode, di_bh);
+		ret = ocfs2_xattr_ibody_remove(inode, di_bh, &ref_et);
 		if (ret < 0) {
 			mlog_errno(ret);
 			goto out;
@@ -1931,7 +2010,8 @@ int ocfs2_xattr_remove(struct inode *inode, struct buffer_head *di_bh)
 
 	if (di->i_xattr_loc) {
 		ret = ocfs2_xattr_free_block(inode,
-					     le64_to_cpu(di->i_xattr_loc));
+					     le64_to_cpu(di->i_xattr_loc),
+					     &ref_et);
 		if (ret < 0) {
 			mlog_errno(ret);
 			goto out;
@@ -1965,6 +2045,9 @@ int ocfs2_xattr_remove(struct inode *inode, struct buffer_head *di_bh)
 out_commit:
 	ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
 out:
+	if (ref_tree)
+		ocfs2_unlock_refcount_tree(OCFS2_SB(inode->i_sb), ref_tree, 1);
+	brelse(ref_bh);
 	return ret;
 }
 
@@ -4987,7 +5070,7 @@ static int ocfs2_rm_xattr_cluster(struct inode *inode,
 	struct ocfs2_extent_tree et;
 
 	ret = ocfs2_iterate_xattr_buckets(inode, blkno, len,
-					  ocfs2_delete_xattr_in_bucket, NULL);
+					  ocfs2_delete_xattr_in_bucket, para);
 	if (ret) {
 		mlog_errno(ret);
 		return ret;
@@ -5375,7 +5458,7 @@ static int ocfs2_delete_xattr_in_bucket(struct inode *inode,
 					struct ocfs2_xattr_bucket *bucket,
 					void *para)
 {
-	int ret = 0;
+	int ret = 0, ref_credits;
 	struct ocfs2_xattr_header *xh = bucket_xh(bucket);
 	u16 i;
 	struct ocfs2_xattr_entry *xe;
@@ -5383,7 +5466,9 @@ static int ocfs2_delete_xattr_in_bucket(struct inode *inode,
 	struct ocfs2_xattr_set_ctxt ctxt = {NULL, NULL,};
 	int credits = ocfs2_remove_extent_credits(osb->sb) +
 		ocfs2_blocks_per_xattr_bucket(inode->i_sb);
-
+	struct ocfs2_xattr_value_root *xv;
+	struct ocfs2_extent_tree *ref_et =
+			(struct ocfs2_extent_tree *)para;
 
 	ocfs2_init_dealloc_ctxt(&ctxt.dealloc);
 
@@ -5392,7 +5477,14 @@ static int ocfs2_delete_xattr_in_bucket(struct inode *inode,
 		if (ocfs2_xattr_is_local(xe))
 			continue;
 
-		ctxt.handle = ocfs2_start_trans(osb, credits);
+		ret = ocfs2_get_xattr_tree_value_root(inode->i_sb, bucket,
+						      i, &xv, NULL);
+
+		ret = ocfs2_lock_xattr_remove_allocators(inode, xv,
+							 ref_et, &ctxt.meta_ac,
+							 &ref_credits);
+
+		ctxt.handle = ocfs2_start_trans(osb, credits + ref_credits);
 		if (IS_ERR(ctxt.handle)) {
 			ret = PTR_ERR(ctxt.handle);
 			mlog_errno(ret);
@@ -5403,12 +5495,18 @@ static int ocfs2_delete_xattr_in_bucket(struct inode *inode,
 							i, 0, &ctxt);
 
 		ocfs2_commit_trans(osb, ctxt.handle);
+		if (ctxt.meta_ac) {
+			ocfs2_free_alloc_context(ctxt.meta_ac);
+			ctxt.meta_ac = NULL;
+		}
 		if (ret) {
 			mlog_errno(ret);
 			break;
 		}
 	}
 
+	if (ctxt.meta_ac)
+		ocfs2_free_alloc_context(ctxt.meta_ac);
 	ocfs2_schedule_truncate_log_flush(osb, 1);
 	ocfs2_run_deallocs(osb, &ctxt.dealloc);
 	return ret;
-- 
1.6.2.rc2.16.gf474c
