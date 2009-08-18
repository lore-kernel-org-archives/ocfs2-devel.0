From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 18 Aug 2009 14:19:34 +0800
Subject: [Ocfs2-devel] [PATCH 33/41] ocfs2: Modify removing xattr process
	for refcount.
In-Reply-To: <4A8A47DF.8020707@oracle.com>
References: <4A8A47DF.8020707@oracle.com>
Message-ID: <1250576382-27080-33-git-send-email-tao.ma@oracle.com>
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
 fs/ocfs2/xattr.c |  190 +++++++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 154 insertions(+), 36 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index c32ef2c..4eef69b 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -199,6 +199,11 @@ static int ocfs2_prepare_refcount_xattr(struct inode *inode,
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
@@ -1752,51 +1757,112 @@ out:
 	return ret;
 }
 
+/*
+ * In xattr remove, if it is stored outside and refcounted, we may have
+ * the chance to split the refcount tree. So need the allocators.
+ */
+static int ocfs2_lock_xattr_remove_allocators(struct inode *inode,
+					struct ocfs2_xattr_value_root *xv,
+					struct ocfs2_caching_info *ref_ci,
+					struct buffer_head *ref_root_bh,
+					struct ocfs2_alloc_context **meta_ac,
+					int *ref_credits)
+{
+	int ret, meta_add = 0;
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
+	ret = ocfs2_refcounted_xattr_delete_need(inode, ref_ci,
+						 ref_root_bh, xv,
+						 &meta_add, ref_credits);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_reserve_new_metadata_blocks(OCFS2_SB(inode->i_sb),
+						meta_add, meta_ac);
+	if (ret)
+		mlog_errno(ret);
+
+out:
+	return ret;
+}
+
 static int ocfs2_remove_value_outside(struct inode*inode,
 				      struct ocfs2_xattr_value_buf *vb,
-				      struct ocfs2_xattr_header *header)
+				      struct ocfs2_xattr_header *header,
+				      struct ocfs2_caching_info *ref_ci,
+				      struct buffer_head *ref_root_bh)
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
+							 ref_ci, ref_root_bh,
+							 &ctxt.meta_ac,
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
+				    struct ocfs2_caching_info *ref_ci,
+				    struct buffer_head *ref_root_bh)
 {
 
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
@@ -1811,13 +1877,21 @@ static int ocfs2_xattr_ibody_remove(struct inode *inode,
 		 ((void *)di + inode->i_sb->s_blocksize -
 		 le16_to_cpu(di->i_xattr_inline_size));
 
-	ret = ocfs2_remove_value_outside(inode, &vb, header);
+	ret = ocfs2_remove_value_outside(inode, &vb, header,
+					 ref_ci, ref_root_bh);
 
 	return ret;
 }
 
+struct ocfs2_rm_xattr_bucket_para {
+	struct ocfs2_caching_info *ref_ci;
+	struct buffer_head *ref_root_bh;
+};
+
 static int ocfs2_xattr_block_remove(struct inode *inode,
-				    struct buffer_head *blk_bh)
+				    struct buffer_head *blk_bh,
+				    struct ocfs2_caching_info *ref_ci,
+				    struct buffer_head *ref_root_bh)
 {
 	struct ocfs2_xattr_block *xb;
 	int ret = 0;
@@ -1825,22 +1899,29 @@ static int ocfs2_xattr_block_remove(struct inode *inode,
 		.vb_bh = blk_bh,
 		.vb_access = ocfs2_journal_access_xb,
 	};
+	struct ocfs2_rm_xattr_bucket_para args = {
+		.ref_ci = ref_ci,
+		.ref_root_bh = ref_root_bh,
+	};
 
 	xb = (struct ocfs2_xattr_block *)blk_bh->b_data;
 	if (!(le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED)) {
 		struct ocfs2_xattr_header *header = &(xb->xb_attrs.xb_header);
-		ret = ocfs2_remove_value_outside(inode, &vb, header);
+		ret = ocfs2_remove_value_outside(inode, &vb, header,
+						 ref_ci, ref_root_bh);
 	} else
 		ret = ocfs2_iterate_xattr_index_block(inode,
 						blk_bh,
 						ocfs2_rm_xattr_cluster,
-						NULL);
+						&args);
 
 	return ret;
 }
 
 static int ocfs2_xattr_free_block(struct inode *inode,
-				  u64 block)
+				  u64 block,
+				  struct ocfs2_caching_info *ref_ci,
+				  struct buffer_head *ref_root_bh)
 {
 	struct inode *xb_alloc_inode;
 	struct buffer_head *xb_alloc_bh = NULL;
@@ -1858,7 +1939,7 @@ static int ocfs2_xattr_free_block(struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_xattr_block_remove(inode, blk_bh);
+	ret = ocfs2_xattr_block_remove(inode, blk_bh, ref_ci, ref_root_bh);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out;
@@ -1918,6 +1999,9 @@ int ocfs2_xattr_remove(struct inode *inode, struct buffer_head *di_bh)
 {
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+	struct ocfs2_refcount_tree *ref_tree = NULL;
+	struct buffer_head *ref_root_bh = NULL;
+	struct ocfs2_caching_info *ref_ci = NULL;
 	handle_t *handle;
 	int ret;
 
@@ -1927,8 +2011,21 @@ int ocfs2_xattr_remove(struct inode *inode, struct buffer_head *di_bh)
 	if (!(oi->ip_dyn_features & OCFS2_HAS_XATTR_FL))
 		return 0;
 
+	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL) {
+		ret = ocfs2_lock_refcount_tree(OCFS2_SB(inode->i_sb),
+					       le64_to_cpu(di->i_refcount_loc),
+					       1, &ref_tree, &ref_root_bh);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+		ref_ci = &ref_tree->rf_ci;
+
+	}
+
 	if (oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL) {
-		ret = ocfs2_xattr_ibody_remove(inode, di_bh);
+		ret = ocfs2_xattr_ibody_remove(inode, di_bh,
+					       ref_ci, ref_root_bh);
 		if (ret < 0) {
 			mlog_errno(ret);
 			goto out;
@@ -1937,7 +2034,8 @@ int ocfs2_xattr_remove(struct inode *inode, struct buffer_head *di_bh)
 
 	if (di->i_xattr_loc) {
 		ret = ocfs2_xattr_free_block(inode,
-					     le64_to_cpu(di->i_xattr_loc));
+					     le64_to_cpu(di->i_xattr_loc),
+					     ref_ci, ref_root_bh);
 		if (ret < 0) {
 			mlog_errno(ret);
 			goto out;
@@ -1971,6 +2069,9 @@ int ocfs2_xattr_remove(struct inode *inode, struct buffer_head *di_bh)
 out_commit:
 	ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
 out:
+	if (ref_tree)
+		ocfs2_unlock_refcount_tree(OCFS2_SB(inode->i_sb), ref_tree, 1);
+	brelse(ref_root_bh);
 	return ret;
 }
 
@@ -4989,7 +5090,7 @@ static int ocfs2_rm_xattr_cluster(struct inode *inode,
 	struct ocfs2_extent_tree et;
 
 	ret = ocfs2_iterate_xattr_buckets(inode, blkno, len,
-					  ocfs2_delete_xattr_in_bucket, NULL);
+					  ocfs2_delete_xattr_in_bucket, para);
 	if (ret) {
 		mlog_errno(ret);
 		return ret;
@@ -5378,7 +5479,7 @@ static int ocfs2_delete_xattr_in_bucket(struct inode *inode,
 					struct ocfs2_xattr_bucket *bucket,
 					void *para)
 {
-	int ret = 0;
+	int ret = 0, ref_credits;
 	struct ocfs2_xattr_header *xh = bucket_xh(bucket);
 	u16 i;
 	struct ocfs2_xattr_entry *xe;
@@ -5386,7 +5487,9 @@ static int ocfs2_delete_xattr_in_bucket(struct inode *inode,
 	struct ocfs2_xattr_set_ctxt ctxt = {NULL, NULL,};
 	int credits = ocfs2_remove_extent_credits(osb->sb) +
 		ocfs2_blocks_per_xattr_bucket(inode->i_sb);
-
+	struct ocfs2_xattr_value_root *xv;
+	struct ocfs2_rm_xattr_bucket_para *args =
+			(struct ocfs2_rm_xattr_bucket_para *)para;
 
 	ocfs2_init_dealloc_ctxt(&ctxt.dealloc);
 
@@ -5395,7 +5498,16 @@ static int ocfs2_delete_xattr_in_bucket(struct inode *inode,
 		if (ocfs2_xattr_is_local(xe))
 			continue;
 
-		ctxt.handle = ocfs2_start_trans(osb, credits);
+		ret = ocfs2_get_xattr_tree_value_root(inode->i_sb, bucket,
+						      i, &xv, NULL);
+
+		ret = ocfs2_lock_xattr_remove_allocators(inode, xv,
+							 args->ref_ci,
+							 args->ref_root_bh,
+							 &ctxt.meta_ac,
+							 &ref_credits);
+
+		ctxt.handle = ocfs2_start_trans(osb, credits + ref_credits);
 		if (IS_ERR(ctxt.handle)) {
 			ret = PTR_ERR(ctxt.handle);
 			mlog_errno(ret);
@@ -5406,12 +5518,18 @@ static int ocfs2_delete_xattr_in_bucket(struct inode *inode,
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
