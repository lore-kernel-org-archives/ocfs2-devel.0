From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 16 Oct 2008 13:10:40 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2/xattr: Merge xattr set transaction.
In-Reply-To: <1224133840-13608-1-git-send-email-tao.ma@oracle.com>
References: <1224133840-13608-1-git-send-email-tao.ma@oracle.com>
Message-ID: <1224133840-13608-2-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In current ocfs2/xattr, the whole xattr set is divided into
many steps are many transaction are used, this make the
xattr set process isn't like a real transaction, so this
patch try to merge all the transaction into one. Another
benefit is that acl can use it easily now.

I don't merge the transaction of deleting xattr when we
remove an inode. The reason is that if we have a large number
of xattrs and every xattrs has large values(large enough
for outside storage), the whole transaction will be very
huge and it looks like jbd can't handle it(I meet with a
jbd complain once). And the old inode removal is also divided
into many steps, so I'd like to leave as it is.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |  888 +++++++++++++++++++++++++++++++-----------------------
 1 files changed, 513 insertions(+), 375 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index f158280..de3b057 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -70,6 +70,12 @@ struct ocfs2_xattr_bucket {
 	struct ocfs2_xattr_header *xh;
 };
 
+struct ocfs2_xattr_set_ctxt {
+	struct ocfs2_alloc_context *meta_ac;
+	struct ocfs2_alloc_context *data_ac;
+	struct ocfs2_cached_dealloc_ctxt dealloc;
+};
+
 #define OCFS2_XATTR_ROOT_SIZE	(sizeof(struct ocfs2_xattr_def_value_root))
 #define OCFS2_XATTR_INLINE_SIZE	80
 
@@ -128,11 +134,15 @@ static int ocfs2_xattr_tree_list_index_block(struct inode *inode,
 					size_t buffer_size);
 
 static int ocfs2_xattr_create_index_block(struct inode *inode,
-					  struct ocfs2_xattr_search *xs);
+					  handle_t *handle,
+					  struct ocfs2_xattr_search *xs,
+					  struct ocfs2_xattr_set_ctxt *ctxt);
 
 static int ocfs2_xattr_set_entry_index_block(struct inode *inode,
+					     handle_t *handle,
 					     struct ocfs2_xattr_info *xi,
-					     struct ocfs2_xattr_search *xs);
+					     struct ocfs2_xattr_search *xs,
+					     struct ocfs2_xattr_set_ctxt *ctxt);
 
 static int ocfs2_delete_xattr_index_block(struct inode *inode,
 					  struct buffer_head *xb_bh);
@@ -184,16 +194,14 @@ static void ocfs2_xattr_hash_entry(struct inode *inode,
 }
 
 static int ocfs2_xattr_extend_allocation(struct inode *inode,
+					 handle_t *handle,
 					 u32 clusters_to_add,
 					 struct buffer_head *xattr_bh,
-					 struct ocfs2_xattr_value_root *xv)
+					 struct ocfs2_xattr_value_root *xv,
+					 struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	int status = 0;
-	int restart_func = 0;
 	int credits = 0;
-	handle_t *handle = NULL;
-	struct ocfs2_alloc_context *data_ac = NULL;
-	struct ocfs2_alloc_context *meta_ac = NULL;
 	enum ocfs2_alloc_restarted why;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	u32 prev_clusters, logical_start = le32_to_cpu(xv->xr_clusters);
@@ -203,21 +211,10 @@ static int ocfs2_xattr_extend_allocation(struct inode *inode,
 
 	ocfs2_init_xattr_value_extent_tree(&et, inode, xattr_bh, xv);
 
-restart_all:
-
-	status = ocfs2_lock_allocators(inode, &et, clusters_to_add, 0,
-				       &data_ac, &meta_ac);
-	if (status) {
-		mlog_errno(status);
-		goto leave;
-	}
-
 	credits = ocfs2_calc_extend_credits(osb->sb, et.et_root_el,
-					    clusters_to_add);
-	handle = ocfs2_start_trans(osb, credits);
-	if (IS_ERR(handle)) {
-		status = PTR_ERR(handle);
-		handle = NULL;
+			clusters_to_add) + handle->h_buffer_credits;
+	status = ocfs2_extend_trans(handle, credits);
+	if (status) {
 		mlog_errno(status);
 		goto leave;
 	}
@@ -238,8 +235,8 @@ restarted_transaction:
 					     0,
 					     &et,
 					     handle,
-					     data_ac,
-					     meta_ac,
+					     ctxt->data_ac,
+					     ctxt->meta_ac,
 					     &why);
 	if ((status < 0) && (status != -EAGAIN)) {
 		if (status != -ENOSPC)
@@ -257,8 +254,9 @@ restarted_transaction:
 
 	if (why != RESTART_NONE && clusters_to_add) {
 		if (why == RESTART_META) {
-			mlog(0, "restarting function.\n");
-			restart_func = 1;
+			mlog(0, "haven't reserved meta for xattr set.\n");
+			status = -ENOSPC;
+			goto leave;
 		} else {
 			BUG_ON(why != RESTART_TRANS);
 
@@ -280,62 +278,30 @@ restarted_transaction:
 	}
 
 leave:
-	if (handle) {
-		ocfs2_commit_trans(osb, handle);
-		handle = NULL;
-	}
-	if (data_ac) {
-		ocfs2_free_alloc_context(data_ac);
-		data_ac = NULL;
-	}
-	if (meta_ac) {
-		ocfs2_free_alloc_context(meta_ac);
-		meta_ac = NULL;
-	}
-	if ((!status) && restart_func) {
-		restart_func = 0;
-		goto restart_all;
-	}
 
 	return status;
 }
 
 static int __ocfs2_remove_xattr_range(struct inode *inode,
+				      handle_t *handle,
 				      struct buffer_head *root_bh,
 				      struct ocfs2_xattr_value_root *xv,
 				      u32 cpos, u32 phys_cpos, u32 len,
-				      struct ocfs2_cached_dealloc_ctxt *dealloc)
+				      struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	int ret;
 	u64 phys_blkno = ocfs2_clusters_to_blocks(inode->i_sb, phys_cpos);
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct inode *tl_inode = osb->osb_tl_inode;
-	handle_t *handle;
-	struct ocfs2_alloc_context *meta_ac = NULL;
 	struct ocfs2_extent_tree et;
 
 	ocfs2_init_xattr_value_extent_tree(&et, inode, root_bh, xv);
 
-	ret = ocfs2_lock_allocators(inode, &et, 0, 1, NULL, &meta_ac);
+	ret = ocfs2_extend_trans(handle,
+				 OCFS2_REMOVE_EXTENT_CREDITS +
+				 handle->h_buffer_credits);
 	if (ret) {
 		mlog_errno(ret);
-		return ret;
-	}
-
-	mutex_lock(&tl_inode->i_mutex);
-
-	if (ocfs2_truncate_log_needs_flush(osb)) {
-		ret = __ocfs2_flush_truncate_log(osb);
-		if (ret < 0) {
-			mlog_errno(ret);
-			goto out;
-		}
-	}
-
-	handle = ocfs2_start_trans(osb, OCFS2_REMOVE_EXTENT_CREDITS);
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		mlog_errno(ret);
 		goto out;
 	}
 
@@ -343,14 +309,14 @@ static int __ocfs2_remove_xattr_range(struct inode *inode,
 				   OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
-		goto out_commit;
+		goto out;
 	}
 
-	ret = ocfs2_remove_extent(inode, &et, cpos, len, handle, meta_ac,
-				  dealloc);
+	ret = ocfs2_remove_extent(inode, &et, cpos, len, handle, ctxt->meta_ac,
+				  &ctxt->dealloc);
 	if (ret) {
 		mlog_errno(ret);
-		goto out_commit;
+		goto out;
 	}
 
 	le32_add_cpu(&xv->xr_clusters, -len);
@@ -358,37 +324,30 @@ static int __ocfs2_remove_xattr_range(struct inode *inode,
 	ret = ocfs2_journal_dirty(handle, root_bh);
 	if (ret) {
 		mlog_errno(ret);
-		goto out_commit;
+		goto out;
 	}
 
+	mutex_lock(&tl_inode->i_mutex);
 	ret = ocfs2_truncate_log_append(osb, handle, phys_blkno, len);
 	if (ret)
 		mlog_errno(ret);
+	 mutex_unlock(&tl_inode->i_mutex);
 
-out_commit:
-	ocfs2_commit_trans(osb, handle);
 out:
-	mutex_unlock(&tl_inode->i_mutex);
-
-	if (meta_ac)
-		ocfs2_free_alloc_context(meta_ac);
-
 	return ret;
 }
 
 static int ocfs2_xattr_shrink_size(struct inode *inode,
+				   handle_t *handle,
 				   u32 old_clusters,
 				   u32 new_clusters,
 				   struct buffer_head *root_bh,
-				   struct ocfs2_xattr_value_root *xv)
+				   struct ocfs2_xattr_value_root *xv,
+				   struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	int ret = 0;
 	u32 trunc_len, cpos, phys_cpos, alloc_size;
 	u64 block;
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	struct ocfs2_cached_dealloc_ctxt dealloc;
-
-	ocfs2_init_dealloc_ctxt(&dealloc);
 
 	if (old_clusters <= new_clusters)
 		return 0;
@@ -406,9 +365,10 @@ static int ocfs2_xattr_shrink_size(struct inode *inode,
 		if (alloc_size > trunc_len)
 			alloc_size = trunc_len;
 
-		ret = __ocfs2_remove_xattr_range(inode, root_bh, xv, cpos,
+		ret = __ocfs2_remove_xattr_range(inode, handle, root_bh,
+						 xv, cpos,
 						 phys_cpos, alloc_size,
-						 &dealloc);
+						 ctxt);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -422,16 +382,15 @@ static int ocfs2_xattr_shrink_size(struct inode *inode,
 	}
 
 out:
-	ocfs2_schedule_truncate_log_flush(osb, 1);
-	ocfs2_run_deallocs(osb, &dealloc);
-
 	return ret;
 }
 
 static int ocfs2_xattr_value_truncate(struct inode *inode,
+				      handle_t *handle,
 				      struct buffer_head *root_bh,
 				      struct ocfs2_xattr_value_root *xv,
-				      int len)
+				      int len,
+				      struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	int ret;
 	u32 new_clusters = ocfs2_clusters_for_bytes(inode->i_sb, len);
@@ -442,12 +401,14 @@ static int ocfs2_xattr_value_truncate(struct inode *inode,
 
 	if (new_clusters > old_clusters)
 		ret = ocfs2_xattr_extend_allocation(inode,
+						    handle,
 						    new_clusters - old_clusters,
-						    root_bh, xv);
+						    root_bh, xv, ctxt);
 	else
 		ret = ocfs2_xattr_shrink_size(inode,
+					      handle,
 					      old_clusters, new_clusters,
-					      root_bh, xv);
+					      root_bh, xv, ctxt);
 
 	return ret;
 }
@@ -885,6 +846,7 @@ int ocfs2_xattr_get(struct inode *inode,
 }
 
 static int __ocfs2_xattr_set_value_outside(struct inode *inode,
+					   handle_t *handle,
 					   struct ocfs2_xattr_value_root *xv,
 					   const void *value,
 					   int value_len)
@@ -896,14 +858,12 @@ static int __ocfs2_xattr_set_value_outside(struct inode *inode,
 	u32 clusters = ocfs2_clusters_for_bytes(inode->i_sb, value_len);
 	u64 blkno;
 	struct buffer_head *bh = NULL;
-	handle_t *handle;
 
 	BUG_ON(clusters > le32_to_cpu(xv->xr_clusters));
 
 	credits = clusters * bpc;
-	handle = ocfs2_start_trans(OCFS2_SB(inode->i_sb), credits);
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
+	ret = ocfs2_extend_trans(handle, credits);
+	if (ret) {
 		mlog_errno(ret);
 		goto out;
 	}
@@ -913,7 +873,7 @@ static int __ocfs2_xattr_set_value_outside(struct inode *inode,
 					       &num_clusters, &xv->xr_list);
 		if (ret) {
 			mlog_errno(ret);
-			goto out_commit;
+			goto out;
 		}
 
 		blkno = ocfs2_clusters_to_blocks(inode->i_sb, p_cluster);
@@ -922,7 +882,7 @@ static int __ocfs2_xattr_set_value_outside(struct inode *inode,
 			ret = ocfs2_read_block(inode, blkno, &bh);
 			if (ret) {
 				mlog_errno(ret);
-				goto out_commit;
+				goto out;
 			}
 
 			ret = ocfs2_journal_access(handle,
@@ -931,7 +891,7 @@ static int __ocfs2_xattr_set_value_outside(struct inode *inode,
 						   OCFS2_JOURNAL_ACCESS_WRITE);
 			if (ret < 0) {
 				mlog_errno(ret);
-				goto out_commit;
+				goto out;
 			}
 
 			cp_len = value_len > blocksize ? blocksize : value_len;
@@ -945,7 +905,7 @@ static int __ocfs2_xattr_set_value_outside(struct inode *inode,
 			ret = ocfs2_journal_dirty(handle, bh);
 			if (ret < 0) {
 				mlog_errno(ret);
-				goto out_commit;
+				goto out;
 			}
 			brelse(bh);
 			bh = NULL;
@@ -959,8 +919,6 @@ static int __ocfs2_xattr_set_value_outside(struct inode *inode,
 		}
 		cpos += num_clusters;
 	}
-out_commit:
-	ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
 out:
 	brelse(bh);
 
@@ -968,28 +926,21 @@ out:
 }
 
 static int ocfs2_xattr_cleanup(struct inode *inode,
+			       handle_t *handle,
 			       struct ocfs2_xattr_info *xi,
 			       struct ocfs2_xattr_search *xs,
 			       size_t offs)
 {
-	handle_t *handle = NULL;
 	int ret = 0;
 	size_t name_len = strlen(xi->name);
 	void *val = xs->base + offs;
 	size_t size = OCFS2_XATTR_SIZE(name_len) + OCFS2_XATTR_ROOT_SIZE;
 
-	handle = ocfs2_start_trans((OCFS2_SB(inode->i_sb)),
-				   OCFS2_XATTR_BLOCK_UPDATE_CREDITS);
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		mlog_errno(ret);
-		goto out;
-	}
 	ret = ocfs2_journal_access(handle, inode, xs->xattr_bh,
 				   OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
-		goto out_commit;
+		goto out;
 	}
 	/* Decrease xattr count */
 	le16_add_cpu(&xs->header->xh_count, -1);
@@ -1000,32 +951,29 @@ static int ocfs2_xattr_cleanup(struct inode *inode,
 	ret = ocfs2_journal_dirty(handle, xs->xattr_bh);
 	if (ret < 0)
 		mlog_errno(ret);
-out_commit:
-	ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
 out:
 	return ret;
 }
 
 static int ocfs2_xattr_update_entry(struct inode *inode,
+				    handle_t *handle,
 				    struct ocfs2_xattr_info *xi,
 				    struct ocfs2_xattr_search *xs,
 				    size_t offs)
 {
-	handle_t *handle = NULL;
-	int ret = 0;
+	int ret;
 
-	handle = ocfs2_start_trans((OCFS2_SB(inode->i_sb)),
-				   OCFS2_XATTR_BLOCK_UPDATE_CREDITS);
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
+	ret = ocfs2_extend_trans(handle, OCFS2_XATTR_BLOCK_UPDATE_CREDITS);
+	if (ret) {
 		mlog_errno(ret);
 		goto out;
 	}
+
 	ret = ocfs2_journal_access(handle, inode, xs->xattr_bh,
 				   OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
-		goto out_commit;
+		goto out;
 	}
 
 	xs->here->xe_name_offset = cpu_to_le16(offs);
@@ -1039,8 +987,6 @@ static int ocfs2_xattr_update_entry(struct inode *inode,
 	ret = ocfs2_journal_dirty(handle, xs->xattr_bh);
 	if (ret < 0)
 		mlog_errno(ret);
-out_commit:
-	ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
 out:
 	return ret;
 }
@@ -1051,8 +997,10 @@ out:
  * Set large size value in B tree.
  */
 static int ocfs2_xattr_set_value_outside(struct inode *inode,
+					 handle_t *handle,
 					 struct ocfs2_xattr_info *xi,
 					 struct ocfs2_xattr_search *xs,
+					 struct ocfs2_xattr_set_ctxt *ctxt,
 					 size_t offs)
 {
 	size_t name_len = strlen(xi->name);
@@ -1071,19 +1019,20 @@ static int ocfs2_xattr_set_value_outside(struct inode *inode,
 	xv->xr_list.l_count = cpu_to_le16(1);
 	xv->xr_list.l_next_free_rec = 0;
 
-	ret = ocfs2_xattr_value_truncate(inode, xs->xattr_bh, xv,
-					 xi->value_len);
+	ret = ocfs2_xattr_value_truncate(inode, handle, xs->xattr_bh, xv,
+					 xi->value_len, ctxt);
+
 	if (ret < 0) {
 		mlog_errno(ret);
 		return ret;
 	}
-	ret = __ocfs2_xattr_set_value_outside(inode, xv, xi->value,
-					      xi->value_len);
+	ret = __ocfs2_xattr_set_value_outside(inode, handle, xv,
+					      xi->value, xi->value_len);
 	if (ret < 0) {
 		mlog_errno(ret);
 		return ret;
 	}
-	ret = ocfs2_xattr_update_entry(inode, xi, xs, offs);
+	ret = ocfs2_xattr_update_entry(inode, handle, xi, xs, offs);
 	if (ret < 0)
 		mlog_errno(ret);
 
@@ -1201,8 +1150,10 @@ static void ocfs2_xattr_set_entry_local(struct inode *inode,
  * then set value in B tree with set_value_outside().
  */
 static int ocfs2_xattr_set_entry(struct inode *inode,
+				 handle_t *handle,
 				 struct ocfs2_xattr_info *xi,
 				 struct ocfs2_xattr_search *xs,
+				 struct ocfs2_xattr_set_ctxt *ctxt,
 				 int flag)
 {
 	struct ocfs2_xattr_entry *last;
@@ -1210,7 +1161,6 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)xs->inode_bh->b_data;
 	size_t min_offs = xs->end - xs->base, name_len = strlen(xi->name);
 	size_t size_l = 0;
-	handle_t *handle = NULL;
 	int free, i, ret;
 	struct ocfs2_xattr_info xi_l = {
 		.name_index = xi->name_index,
@@ -1272,8 +1222,9 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 
 		if (ocfs2_xattr_is_local(xs->here) && size == size_l) {
 			/* Replace existing local xattr with tree root */
-			ret = ocfs2_xattr_set_value_outside(inode, xi, xs,
-							    offs);
+			ret = ocfs2_xattr_set_value_outside(inode, handle,
+							    xi, xs,
+							    ctxt, offs);
 			if (ret < 0)
 				mlog_errno(ret);
 			goto out;
@@ -1290,15 +1241,18 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 				 * then set new value with set_value_outside().
 				 */
 				ret = ocfs2_xattr_value_truncate(inode,
+								 handle,
 								 xs->xattr_bh,
 								 xv,
-								 xi->value_len);
+								 xi->value_len,
+								 ctxt);
 				if (ret < 0) {
 					mlog_errno(ret);
 					goto out;
 				}
 
 				ret = __ocfs2_xattr_set_value_outside(inode,
+								handle,
 								xv,
 								xi->value,
 								xi->value_len);
@@ -1308,6 +1262,7 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 				}
 
 				ret = ocfs2_xattr_update_entry(inode,
+							       handle,
 							       xi,
 							       xs,
 							       offs);
@@ -1320,44 +1275,30 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 				 * just trucate old value to zero.
 				 */
 				 ret = ocfs2_xattr_value_truncate(inode,
-								 xs->xattr_bh,
-								 xv,
-								 0);
+								  handle,
+								  xs->xattr_bh,
+								  xv,
+								  0,
+								  ctxt);
 				if (ret < 0)
 					mlog_errno(ret);
 			}
 		}
 	}
 
-	handle = ocfs2_start_trans((OCFS2_SB(inode->i_sb)),
-				   OCFS2_INODE_UPDATE_CREDITS);
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		mlog_errno(ret);
-		goto out;
-	}
-
 	ret = ocfs2_journal_access(handle, inode, xs->inode_bh,
 				   OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
-		goto out_commit;
+		goto out;
 	}
 
 	if (!(flag & OCFS2_INLINE_XATTR_FL)) {
-		/* set extended attribute in external block. */
-		ret = ocfs2_extend_trans(handle,
-					 OCFS2_INODE_UPDATE_CREDITS +
-					 OCFS2_XATTR_BLOCK_UPDATE_CREDITS);
-		if (ret) {
-			mlog_errno(ret);
-			goto out_commit;
-		}
 		ret = ocfs2_journal_access(handle, inode, xs->xattr_bh,
 					   OCFS2_JOURNAL_ACCESS_WRITE);
 		if (ret) {
 			mlog_errno(ret);
-			goto out_commit;
+			goto out;
 		}
 	}
 
@@ -1371,7 +1312,7 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 		ret = ocfs2_journal_dirty(handle, xs->xattr_bh);
 		if (ret < 0) {
 			mlog_errno(ret);
-			goto out_commit;
+			goto out;
 		}
 	}
 
@@ -1408,16 +1349,14 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 	if (ret < 0)
 		mlog_errno(ret);
 
-out_commit:
-	ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
-
 	if (!ret && xi->value_len > OCFS2_XATTR_INLINE_SIZE) {
 		/*
 		 * Set value outside in B tree.
 		 * This is the second step for value size > INLINE_SIZE.
 		 */
 		size_t offs = le16_to_cpu(xs->here->xe_name_offset);
-		ret = ocfs2_xattr_set_value_outside(inode, xi, xs, offs);
+		ret = ocfs2_xattr_set_value_outside(inode, handle, xi, xs,
+						    ctxt, offs);
 		if (ret < 0) {
 			int ret2;
 
@@ -1426,14 +1365,13 @@ out_commit:
 			 * If set value outside failed, we have to clean
 			 * the junk tree root we have already set in local.
 			 */
-			ret2 = ocfs2_xattr_cleanup(inode, xi, xs, offs);
+			ret2 = ocfs2_xattr_cleanup(inode, handle, xi, xs, offs);
 			if (ret2 < 0)
 				mlog_errno(ret2);
 		}
 	}
 out:
 	return ret;
-
 }
 
 static int ocfs2_remove_value_outside(struct inode*inode,
@@ -1441,6 +1379,23 @@ static int ocfs2_remove_value_outside(struct inode*inode,
 				      struct ocfs2_xattr_header *header)
 {
 	int ret = 0, i;
+	handle_t *handle = NULL;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_xattr_set_ctxt ctxt;
+
+	memset(&ctxt, 0, sizeof(ctxt));
+	ocfs2_init_dealloc_ctxt(&ctxt.dealloc);
+
+	/*
+	 * actually ofs2_xattr_value_truncate will extend trans
+	 * if needed, so just 1 is enough.
+	 */
+	handle = ocfs2_start_trans(osb, 1);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		mlog_errno(ret);
+		goto out;
+	}
 
 	for (i = 0; i < le16_to_cpu(header->xh_count); i++) {
 		struct ocfs2_xattr_entry *entry = &header->xh_entries[i];
@@ -1453,14 +1408,19 @@ static int ocfs2_remove_value_outside(struct inode*inode,
 				le16_to_cpu(entry->xe_name_offset);
 			xv = (struct ocfs2_xattr_value_root *)
 				(val + OCFS2_XATTR_SIZE(entry->xe_name_len));
-			ret = ocfs2_xattr_value_truncate(inode, bh, xv, 0);
+			ret = ocfs2_xattr_value_truncate(inode, handle,
+							 bh, xv, 0, &ctxt);
 			if (ret < 0) {
 				mlog_errno(ret);
-				return ret;
+				break;
 			}
 		}
 	}
 
+	ret = ocfs2_commit_trans(osb, handle);
+	ocfs2_schedule_truncate_log_flush(osb, 1);
+	ocfs2_run_deallocs(osb, &ctxt.dealloc);
+out:
 	return ret;
 }
 
@@ -1723,8 +1683,10 @@ static int ocfs2_xattr_ibody_find(struct inode *inode,
  *
  */
 static int ocfs2_xattr_ibody_set(struct inode *inode,
+				 handle_t *handle,
 				 struct ocfs2_xattr_info *xi,
-				 struct ocfs2_xattr_search *xs)
+				 struct ocfs2_xattr_search *xs,
+				 struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)xs->inode_bh->b_data;
@@ -1741,7 +1703,7 @@ static int ocfs2_xattr_ibody_set(struct inode *inode,
 		}
 	}
 
-	ret = ocfs2_xattr_set_entry(inode, xi, xs,
+	ret = ocfs2_xattr_set_entry(inode, handle, xi, xs, ctxt,
 				(OCFS2_INLINE_XATTR_FL | OCFS2_HAS_XATTR_FL));
 out:
 	up_write(&oi->ip_alloc_sem);
@@ -1815,14 +1777,14 @@ cleanup:
  *
  */
 static int ocfs2_xattr_block_set(struct inode *inode,
+				 handle_t *handle,
 				 struct ocfs2_xattr_info *xi,
-				 struct ocfs2_xattr_search *xs)
+				 struct ocfs2_xattr_search *xs,
+				 struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	struct buffer_head *new_bh = NULL;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_dinode *di =  (struct ocfs2_dinode *)xs->inode_bh->b_data;
-	struct ocfs2_alloc_context *meta_ac = NULL;
-	handle_t *handle = NULL;
 	struct ocfs2_xattr_block *xblk = NULL;
 	u16 suballoc_bit_start;
 	u32 num_got;
@@ -1830,35 +1792,26 @@ static int ocfs2_xattr_block_set(struct inode *inode,
 	int ret;
 
 	if (!xs->xattr_bh) {
-		/*
-		 * Alloc one external block for extended attribute
-		 * outside of inode.
-		 */
-		ret = ocfs2_reserve_new_metadata_blocks(osb, 1, &meta_ac);
-		if (ret < 0) {
-			mlog_errno(ret);
-			goto out;
-		}
-		handle = ocfs2_start_trans(osb,
-					   OCFS2_XATTR_BLOCK_CREATE_CREDITS);
-		if (IS_ERR(handle)) {
-			ret = PTR_ERR(handle);
+		ret = ocfs2_extend_trans(handle,
+					 OCFS2_XATTR_BLOCK_CREATE_CREDITS);
+		if (ret) {
 			mlog_errno(ret);
 			goto out;
 		}
+
 		ret = ocfs2_journal_access(handle, inode, xs->inode_bh,
 					   OCFS2_JOURNAL_ACCESS_CREATE);
 		if (ret < 0) {
 			mlog_errno(ret);
-			goto out_commit;
+			goto out;
 		}
 
-		ret = ocfs2_claim_metadata(osb, handle, meta_ac, 1,
+		ret = ocfs2_claim_metadata(osb, handle, ctxt->meta_ac, 1,
 					   &suballoc_bit_start, &num_got,
 					   &first_blkno);
 		if (ret < 0) {
 			mlog_errno(ret);
-			goto out_commit;
+			goto out;
 		}
 
 		new_bh = sb_getblk(inode->i_sb, first_blkno);
@@ -1868,7 +1821,7 @@ static int ocfs2_xattr_block_set(struct inode *inode,
 					   OCFS2_JOURNAL_ACCESS_CREATE);
 		if (ret < 0) {
 			mlog_errno(ret);
-			goto out_commit;
+			goto out;
 		}
 
 		/* Initialize ocfs2_xattr_block */
@@ -1886,44 +1839,249 @@ static int ocfs2_xattr_block_set(struct inode *inode,
 		xs->end = (void *)xblk + inode->i_sb->s_blocksize;
 		xs->here = xs->header->xh_entries;
 
-
 		ret = ocfs2_journal_dirty(handle, new_bh);
 		if (ret < 0) {
 			mlog_errno(ret);
-			goto out_commit;
+			goto out;
 		}
 		di->i_xattr_loc = cpu_to_le64(first_blkno);
-		ret = ocfs2_journal_dirty(handle, xs->inode_bh);
-		if (ret < 0)
-			mlog_errno(ret);
-out_commit:
-		ocfs2_commit_trans(osb, handle);
-out:
-		if (meta_ac)
-			ocfs2_free_alloc_context(meta_ac);
-		if (ret < 0)
-			return ret;
+		ocfs2_journal_dirty(handle, xs->inode_bh);
 	} else
 		xblk = (struct ocfs2_xattr_block *)xs->xattr_bh->b_data;
 
 	if (!(le16_to_cpu(xblk->xb_flags) & OCFS2_XATTR_INDEXED)) {
 		/* Set extended attribute into external block */
-		ret = ocfs2_xattr_set_entry(inode, xi, xs, OCFS2_HAS_XATTR_FL);
+		ret = ocfs2_xattr_set_entry(inode, handle, xi, xs, ctxt,
+					    OCFS2_HAS_XATTR_FL);
 		if (!ret || ret != -ENOSPC)
-			goto end;
+			goto out;
 
-		ret = ocfs2_xattr_create_index_block(inode, xs);
+		ret = ocfs2_xattr_create_index_block(inode, handle, xs, ctxt);
 		if (ret)
-			goto end;
+			goto out;
 	}
 
-	ret = ocfs2_xattr_set_entry_index_block(inode, xi, xs);
+	ret = ocfs2_xattr_set_entry_index_block(inode, handle, xi, xs, ctxt);
 
-end:
+out:
 
 	return ret;
 }
 
+static int ocfs2_calc_xattr_set_credits(struct inode *inode,
+					struct ocfs2_xattr_info *xi,
+					struct ocfs2_xattr_search *xis,
+					struct ocfs2_xattr_search *xbs)
+{
+	int credits = OCFS2_INODE_UPDATE_CREDITS;
+
+	/* calculate xattr metadata update credits. */
+	if (xbs->xattr_bh) {
+		struct ocfs2_xattr_block *xb =
+			(struct ocfs2_xattr_block *)xbs->xattr_bh->b_data;
+
+		if (!(le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED))
+			credits += OCFS2_XATTR_BLOCK_UPDATE_CREDITS;
+		else
+			credits += ocfs2_blocks_per_xattr_bucket(inode->i_sb);
+	}
+
+	return credits;
+}
+
+static int ocfs2_init_xattr_set_ctxt(struct inode *inode,
+				     struct ocfs2_dinode *di,
+				     struct ocfs2_xattr_info *xi,
+				     struct ocfs2_xattr_search *xis,
+				     struct ocfs2_xattr_search *xbs,
+				     struct ocfs2_xattr_set_ctxt *ctxt)
+{
+	int ret = 0, clusters_add = 0, meta_add = 0;
+	struct buffer_head *bh = NULL;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_xattr_block *xb = NULL;
+	struct ocfs2_xattr_entry *xe;
+
+	memset(ctxt, 0, sizeof(struct ocfs2_xattr_set_ctxt));
+
+	ocfs2_init_dealloc_ctxt(&ctxt->dealloc);
+
+	if (di->i_xattr_loc) {
+		if (!xbs->xattr_bh) {
+			ret = ocfs2_read_block(inode,
+					       le64_to_cpu(di->i_xattr_loc),
+					       &bh);
+			if (ret) {
+				mlog_errno(ret);
+				goto out;
+			}
+
+			xb = (struct ocfs2_xattr_block *)bh->b_data;
+		} else
+			xb = (struct ocfs2_xattr_block *)xbs->xattr_bh->b_data;
+
+		if (le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED) {
+			struct ocfs2_extent_list *el =
+				 &xb->xb_attrs.xb_root.xt_list;
+			meta_add += ocfs2_extend_meta_needed(el);
+		}
+		/*
+		 * This cluster will be used either for new bucket or for
+		 * new xattr block.
+		 * If the cluster size is the same as the bucket size, one
+		 * more is needed since we may need to extend the bucket
+		 * also.
+		 */
+		clusters_add += 1;
+		if (OCFS2_XATTR_BUCKET_SIZE == osb->s_clustersize)
+			clusters_add += 1;
+	} else
+		meta_add += 1;
+
+	/* calculate xattr value update. */
+	if (xi->value && xi->value_len > OCFS2_XATTR_INLINE_SIZE) {
+		char *base;
+		int name_offset, name_len, block_off, i;
+		u32 new_clusters = ocfs2_clusters_for_bytes(inode->i_sb,
+							    xi->value_len);
+
+		xe = NULL;
+		if (!xis->not_found) {
+			xe = xis->here;
+			name_offset = le16_to_cpu(xe->xe_name_offset);
+			name_len = OCFS2_XATTR_SIZE(xe->xe_name_len);
+			base = xis->base;
+		} else if (!xbs->not_found) {
+			xe = xbs->here;
+			name_offset = le16_to_cpu(xe->xe_name_offset);
+			name_len = OCFS2_XATTR_SIZE(xe->xe_name_len);
+			i = xbs->here - xbs->header->xh_entries;
+
+			if (le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED) {
+				ret = ocfs2_xattr_bucket_get_name_value(inode,
+								xbs->bucket.xh,
+								i,
+								&block_off,
+								&name_offset);
+				base = xbs->bucket.bhs[block_off]->b_data;
+			} else
+				base = xbs->base;
+		}
+
+		/* calc value clusters and value tree metadata change. */
+		if (!xe ||
+		    (le64_to_cpu(xe->xe_value_size) <= OCFS2_XATTR_INLINE_SIZE))
+			clusters_add += new_clusters;
+		else {
+			u32 old_clusters = ocfs2_clusters_for_bytes(inode->i_sb,
+						le64_to_cpu(xe->xe_value_size));
+
+			if (old_clusters < new_clusters) {
+				struct ocfs2_xattr_value_root *xv =
+					(struct ocfs2_xattr_value_root *)
+					(base + name_offset + name_len);
+				meta_add +=
+					ocfs2_extend_meta_needed(&xv->xr_list);
+				clusters_add += new_clusters - old_clusters;
+
+			}
+		}
+	}
+
+	mlog(0, "Set xattr %s, reserve meta blocks = %d, clusters = %d\n",
+	     xi->name, meta_add, clusters_add);
+	if (meta_add) {
+		ret = ocfs2_reserve_new_metadata_blocks(osb, meta_add,
+							&ctxt->meta_ac);
+		if (ret)
+			mlog_errno(ret);
+	}
+
+	if (clusters_add) {
+		ret = ocfs2_reserve_clusters(osb, clusters_add, &ctxt->data_ac);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+	}
+
+out:
+	return ret;
+}
+
+static int ocfs2_xattr_set_handle(struct inode *inode,
+				  handle_t *handle,
+				  struct ocfs2_dinode *di,
+				  struct ocfs2_xattr_info *xi,
+				  struct ocfs2_xattr_search *xis,
+				  struct ocfs2_xattr_search *xbs,
+				  struct ocfs2_xattr_set_ctxt *ctxt)
+{
+	int ret = 0, credits;
+
+	if (!xi->value) {
+		/* Remove existing extended attribute */
+		if (!xis->not_found)
+			ret = ocfs2_xattr_ibody_set(inode, handle,
+						    xi, xis, ctxt);
+		else if (!xbs->not_found)
+			ret = ocfs2_xattr_block_set(inode, handle,
+						    xi, xbs, ctxt);
+	} else {
+		/* We always try to set extended attribute into inode first*/
+		ret = ocfs2_xattr_ibody_set(inode, handle, xi, xis, ctxt);
+		if (!ret && !xbs->not_found) {
+			/*
+			 * If succeed and that extended attribute existing in
+			 * external block, then we will remove it.
+			 */
+			xi->value = NULL;
+			xi->value_len = 0;
+			ret = ocfs2_xattr_block_set(inode, handle,
+						    xi, xbs, ctxt);
+		} else if (ret == -ENOSPC) {
+			if (di->i_xattr_loc && !xbs->xattr_bh) {
+				ret = ocfs2_xattr_block_find(inode,
+							     xi->name_index,
+							     xi->name, xbs);
+				if (ret)
+					goto out;
+
+				credits = ocfs2_calc_xattr_set_credits(inode,
+								       xi,
+								       xis,
+								       xbs);
+				ret = ocfs2_extend_trans(handle, credits);
+				if (ret) {
+					mlog_errno(ret);
+					goto out;
+				}
+			}
+			/*
+			 * If no space in inode, we will set extended attribute
+			 * into external block.
+			 */
+			ret = ocfs2_xattr_block_set(inode, handle,
+						    xi, xbs, ctxt);
+			if (ret)
+				goto out;
+			if (!xis->not_found) {
+				/*
+				 * If succeed and that extended attribute
+				 * existing in inode, we will remove it.
+				 */
+				xi->value = NULL;
+				xi->value_len = 0;
+				ret = ocfs2_xattr_ibody_set(inode, handle,
+							    xi, xis, ctxt);
+			}
+		}
+	}
+
+out:
+	return ret;
+}
+
 /*
  * ocfs2_xattr_set()
  *
@@ -1940,8 +2098,12 @@ int ocfs2_xattr_set(struct inode *inode,
 {
 	struct buffer_head *di_bh = NULL;
 	struct ocfs2_dinode *di;
-	int ret;
+	int ret, credits;
 	u16 i, blk_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
+	struct ocfs2_xattr_set_ctxt ctxt;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct inode *tl_inode = osb->osb_tl_inode;
+	handle_t *handle = NULL;
 
 	struct ocfs2_xattr_info xi = {
 		.name_index = name_index,
@@ -1996,48 +2158,44 @@ int ocfs2_xattr_set(struct inode *inode,
 			goto cleanup;
 	}
 
-	if (!value) {
-		/* Remove existing extended attribute */
-		if (!xis.not_found)
-			ret = ocfs2_xattr_ibody_set(inode, &xi, &xis);
-		else if (!xbs.not_found)
-			ret = ocfs2_xattr_block_set(inode, &xi, &xbs);
-	} else {
-		/* We always try to set extended attribute into inode first*/
-		ret = ocfs2_xattr_ibody_set(inode, &xi, &xis);
-		if (!ret && !xbs.not_found) {
-			/*
-			 * If succeed and that extended attribute existing in
-			 * external block, then we will remove it.
-			 */
-			xi.value = NULL;
-			xi.value_len = 0;
-			ret = ocfs2_xattr_block_set(inode, &xi, &xbs);
-		} else if (ret == -ENOSPC) {
-			if (di->i_xattr_loc && !xbs.xattr_bh) {
-				ret = ocfs2_xattr_block_find(inode, name_index,
-							     name, &xbs);
-				if (ret)
-					goto cleanup;
-			}
-			/*
-			 * If no space in inode, we will set extended attribute
-			 * into external block.
-			 */
-			ret = ocfs2_xattr_block_set(inode, &xi, &xbs);
-			if (ret)
-				goto cleanup;
-			if (!xis.not_found) {
-				/*
-				 * If succeed and that extended attribute
-				 * existing in inode, we will remove it.
-				 */
-				xi.value = NULL;
-				xi.value_len = 0;
-				ret = ocfs2_xattr_ibody_set(inode, &xi, &xis);
-			}
+
+	mutex_lock(&tl_inode->i_mutex);
+
+	if (ocfs2_truncate_log_needs_flush(osb)) {
+		ret = __ocfs2_flush_truncate_log(osb);
+		if (ret < 0) {
+			mutex_unlock(&tl_inode->i_mutex);
+			mlog_errno(ret);
+			goto cleanup;
 		}
 	}
+	mutex_unlock(&tl_inode->i_mutex);
+
+	ret = ocfs2_init_xattr_set_ctxt(inode, di, &xi, &xis, &xbs, &ctxt);
+	if (ret) {
+		mlog_errno(ret);
+		goto cleanup;
+	}
+
+	credits = ocfs2_calc_xattr_set_credits(inode, &xi, &xis, &xbs);
+	handle = ocfs2_start_trans(osb, credits);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		mlog_errno(ret);
+		goto cleanup;
+	}
+
+	ret = ocfs2_xattr_set_handle(inode, handle, di, &xi, &xis, &xbs, &ctxt);
+
+	ocfs2_commit_trans(osb, handle);
+
+	if (ctxt.data_ac)
+		ocfs2_free_alloc_context(ctxt.data_ac);
+	if (ctxt.meta_ac)
+		ocfs2_free_alloc_context(ctxt.meta_ac);
+	ocfs2_schedule_truncate_log_flush(osb, 1);
+	ocfs2_run_deallocs(osb, &ctxt.dealloc);
+
 cleanup:
 	up_write(&OCFS2_I(inode)->ip_xattr_sem);
 	ocfs2_inode_unlock(inode, 1);
@@ -2667,15 +2825,15 @@ static int ocfs2_xattr_update_xattr_search(struct inode *inode,
 }
 
 static int ocfs2_xattr_create_index_block(struct inode *inode,
-					  struct ocfs2_xattr_search *xs)
+					  handle_t *handle,
+					  struct ocfs2_xattr_search *xs,
+					  struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	int ret, credits = OCFS2_SUBALLOC_ALLOC;
 	u32 bit_off, len;
 	u64 blkno;
-	handle_t *handle;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
-	struct ocfs2_alloc_context *data_ac;
 	struct buffer_head *xh_bh = NULL, *data_bh = NULL;
 	struct buffer_head *xb_bh = xs->xattr_bh;
 	struct ocfs2_xattr_block *xb =
@@ -2689,12 +2847,6 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
 
 	BUG_ON(xb_flags & OCFS2_XATTR_INDEXED);
 
-	ret = ocfs2_reserve_clusters(osb, 1, &data_ac);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
-
 	/*
 	 * XXX:
 	 * We can use this lock for now, and maybe move to a dedicated mutex
@@ -2707,24 +2859,24 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
 	 * of the new xattr bucket and one for the value/data.
 	 */
 	credits += 3;
-	handle = ocfs2_start_trans(osb, credits);
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
+	ret = ocfs2_extend_trans(handle, credits + handle->h_buffer_credits);
+	if (ret) {
 		mlog_errno(ret);
-		goto out_sem;
+		goto out;
 	}
 
 	ret = ocfs2_journal_access(handle, inode, xb_bh,
 				   OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
-		goto out_commit;
+		goto out;
 	}
 
-	ret = ocfs2_claim_clusters(osb, handle, data_ac, 1, &bit_off, &len);
+	ret = __ocfs2_claim_clusters(osb, handle, ctxt->data_ac,
+				     1, 1, &bit_off, &len);
 	if (ret) {
 		mlog_errno(ret);
-		goto out_commit;
+		goto out;
 	}
 
 	/*
@@ -2740,7 +2892,7 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
 	if (!xh_bh) {
 		ret = -EIO;
 		mlog_errno(ret);
-		goto out_commit;
+		goto out;
 	}
 
 	ocfs2_set_new_buffer_uptodate(inode, xh_bh);
@@ -2749,7 +2901,7 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
 				   OCFS2_JOURNAL_ACCESS_CREATE);
 	if (ret) {
 		mlog_errno(ret);
-		goto out_commit;
+		goto out;
 	}
 
 	if (bpb > 1) {
@@ -2757,7 +2909,7 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
 		if (!data_bh) {
 			ret = -EIO;
 			mlog_errno(ret);
-			goto out_commit;
+			goto out;
 		}
 
 		ocfs2_set_new_buffer_uptodate(inode, data_bh);
@@ -2766,7 +2918,7 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
 					   OCFS2_JOURNAL_ACCESS_CREATE);
 		if (ret) {
 			mlog_errno(ret);
-			goto out_commit;
+			goto out;
 		}
 	}
 
@@ -2795,21 +2947,10 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
 
 	xb->xb_flags = cpu_to_le16(xb_flags | OCFS2_XATTR_INDEXED);
 
-	ret = ocfs2_journal_dirty(handle, xb_bh);
-	if (ret) {
-		mlog_errno(ret);
-		goto out_commit;
-	}
-
-out_commit:
-	ocfs2_commit_trans(osb, handle);
-
-out_sem:
-	up_write(&oi->ip_alloc_sem);
+	ocfs2_journal_dirty(handle, xb_bh);
 
 out:
-	if (data_ac)
-		ocfs2_free_alloc_context(data_ac);
+	up_write(&oi->ip_alloc_sem);
 
 	brelse(xh_bh);
 	brelse(data_bh);
@@ -2837,6 +2978,7 @@ static int cmp_xe_offset(const void *a, const void *b)
  * so that we can spare some space for insertion.
  */
 static int ocfs2_defrag_xattr_bucket(struct inode *inode,
+				     handle_t *handle,
 				     struct ocfs2_xattr_bucket *bucket)
 {
 	int ret, i;
@@ -2847,9 +2989,9 @@ static int ocfs2_defrag_xattr_bucket(struct inode *inode,
 	u16 blk_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
 	u16 xh_free_start;
 	size_t blocksize = inode->i_sb->s_blocksize;
-	handle_t *handle;
 	struct buffer_head **bhs;
 	struct ocfs2_xattr_entry *xe;
+	int credits;
 
 	bhs = kzalloc(sizeof(struct buffer_head *) * blk_per_bucket,
 			GFP_NOFS);
@@ -2876,10 +3018,10 @@ static int ocfs2_defrag_xattr_bucket(struct inode *inode,
 	for (i = 0; i < blk_per_bucket; i++, buf += blocksize)
 		memcpy(buf, bhs[i]->b_data, blocksize);
 
-	handle = ocfs2_start_trans((OCFS2_SB(inode->i_sb)), blk_per_bucket);
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		handle = NULL;
+
+	credits = blk_per_bucket + handle->h_buffer_credits;
+	ret = ocfs2_extend_trans(handle, credits);
+	if (ret) {
 		mlog_errno(ret);
 		goto out;
 	}
@@ -2889,7 +3031,7 @@ static int ocfs2_defrag_xattr_bucket(struct inode *inode,
 					   OCFS2_JOURNAL_ACCESS_WRITE);
 		if (ret < 0) {
 			mlog_errno(ret);
-			goto commit;
+			goto out;
 		}
 	}
 
@@ -2948,7 +3090,7 @@ static int ocfs2_defrag_xattr_bucket(struct inode *inode,
 			"bucket %llu\n", (unsigned long long)blkno);
 
 	if (xh_free_start == end)
-		goto commit;
+		goto out;
 
 	memset(bucket_buf + xh_free_start, 0, end - xh_free_start);
 	xh->xh_free_start = cpu_to_le16(end);
@@ -2964,8 +3106,6 @@ static int ocfs2_defrag_xattr_bucket(struct inode *inode,
 		ocfs2_journal_dirty(handle, bhs[i]);
 	}
 
-commit:
-	ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
 out:
 
 	if (bhs) {
@@ -3565,22 +3705,21 @@ static int ocfs2_adjust_xattr_cross_cluster(struct inode *inode,
  * when the header_bh is moved into the new cluster.
  */
 static int ocfs2_add_new_xattr_cluster(struct inode *inode,
+				       handle_t *handle,
 				       struct buffer_head *root_bh,
 				       struct buffer_head **first_bh,
 				       struct buffer_head **header_bh,
 				       u32 *num_clusters,
 				       u32 prev_cpos,
 				       u64 prev_blkno,
-				       int *extend)
+				       int *extend,
+				       struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	int ret, credits;
 	u16 bpc = ocfs2_clusters_to_blocks(inode->i_sb, 1);
 	u32 prev_clusters = *num_clusters;
 	u32 clusters_to_add = 1, bit_off, num_bits, v_start = 0;
 	u64 block;
-	handle_t *handle = NULL;
-	struct ocfs2_alloc_context *data_ac = NULL;
-	struct ocfs2_alloc_context *meta_ac = NULL;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_extent_tree et;
 
@@ -3591,19 +3730,11 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 
 	ocfs2_init_xattr_tree_extent_tree(&et, inode, root_bh);
 
-	ret = ocfs2_lock_allocators(inode, &et, clusters_to_add, 0,
-				    &data_ac, &meta_ac);
-	if (ret) {
-		mlog_errno(ret);
-		goto leave;
-	}
-
 	credits = ocfs2_calc_extend_credits(osb->sb, et.et_root_el,
-					    clusters_to_add);
-	handle = ocfs2_start_trans(osb, credits);
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		handle = NULL;
+				clusters_to_add) + handle->h_buffer_credits;
+
+	ret = ocfs2_extend_trans(handle, credits);
+	if (ret) {
 		mlog_errno(ret);
 		goto leave;
 	}
@@ -3615,7 +3746,7 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 		goto leave;
 	}
 
-	ret = __ocfs2_claim_clusters(osb, handle, data_ac, 1,
+	ret = __ocfs2_claim_clusters(osb, handle, ctxt->data_ac, 1,
 				     clusters_to_add, &bit_off, &num_bits);
 	if (ret < 0) {
 		if (ret != -ENOSPC)
@@ -3676,26 +3807,17 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 	mlog(0, "Insert %u clusters at block %llu for xattr@%u\n",
 	     num_bits, block, v_start);
 	ret = ocfs2_insert_extent(osb, handle, inode, &et, v_start, block,
-				  num_bits, 0, meta_ac);
+				  num_bits, 0, ctxt->meta_ac);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto leave;
 	}
 
 	ret = ocfs2_journal_dirty(handle, root_bh);
-	if (ret < 0) {
+	if (ret < 0)
 		mlog_errno(ret);
-		goto leave;
-	}
 
 leave:
-	if (handle)
-		ocfs2_commit_trans(osb, handle);
-	if (data_ac)
-		ocfs2_free_alloc_context(data_ac);
-	if (meta_ac)
-		ocfs2_free_alloc_context(meta_ac);
-
 	return ret;
 }
 
@@ -3704,6 +3826,7 @@ leave:
  * We meet with start_bh. Only move half of the xattrs to the bucket after it.
  */
 static int ocfs2_extend_xattr_bucket(struct inode *inode,
+				     handle_t *handle,
 				     struct buffer_head *first_bh,
 				     struct buffer_head *start_bh,
 				     u32 num_clusters)
@@ -3713,7 +3836,6 @@ static int ocfs2_extend_xattr_bucket(struct inode *inode,
 	u16 blk_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
 	u64 start_blk = start_bh->b_blocknr, end_blk;
 	u32 num_buckets = num_clusters * ocfs2_xattr_buckets_per_cluster(osb);
-	handle_t *handle;
 	struct ocfs2_xattr_header *first_xh =
 				(struct ocfs2_xattr_header *)first_bh->b_data;
 	u16 bucket = le16_to_cpu(first_xh->xh_num_buckets);
@@ -3730,11 +3852,10 @@ static int ocfs2_extend_xattr_bucket(struct inode *inode,
 	 * We will touch all the buckets after the start_bh(include it).
 	 * Add one more bucket and modify the first_bh.
 	 */
-	credits = end_blk - start_blk + 2 * blk_per_bucket + 1;
-	handle = ocfs2_start_trans(osb, credits);
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		handle = NULL;
+	credits = end_blk - start_blk + 2 * blk_per_bucket + 1 +
+		  handle->h_buffer_credits;
+	ret = ocfs2_extend_trans(handle, credits);
+	if (ret) {
 		mlog_errno(ret);
 		goto out;
 	}
@@ -3743,14 +3864,14 @@ static int ocfs2_extend_xattr_bucket(struct inode *inode,
 				   OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
-		goto commit;
+		goto out;
 	}
 
 	while (end_blk != start_blk) {
 		ret = ocfs2_cp_xattr_bucket(inode, handle, end_blk,
 					    end_blk + blk_per_bucket, 0);
 		if (ret)
-			goto commit;
+			goto out;
 		end_blk -= blk_per_bucket;
 	}
 
@@ -3761,8 +3882,6 @@ static int ocfs2_extend_xattr_bucket(struct inode *inode,
 	le16_add_cpu(&first_xh->xh_num_buckets, 1);
 	ocfs2_journal_dirty(handle, first_bh);
 
-commit:
-	ocfs2_commit_trans(osb, handle);
 out:
 	return ret;
 }
@@ -3777,8 +3896,10 @@ out:
  * header_bh and first_bh if the insert place is moved to the new cluster.
  */
 static int ocfs2_add_new_xattr_bucket(struct inode *inode,
+				      handle_t *handle,
 				      struct buffer_head *xb_bh,
-				      struct buffer_head *header_bh)
+				      struct buffer_head *header_bh,
+				      struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	struct ocfs2_xattr_header *first_xh = NULL;
 	struct buffer_head *first_bh = NULL;
@@ -3823,13 +3944,15 @@ static int ocfs2_add_new_xattr_bucket(struct inode *inode,
 
 	if (num_buckets == le16_to_cpu(first_xh->xh_num_buckets)) {
 		ret = ocfs2_add_new_xattr_cluster(inode,
+						  handle,
 						  xb_bh,
 						  &first_bh,
 						  &header_bh,
 						  &num_clusters,
 						  e_cpos,
 						  p_blkno,
-						  &extend);
+						  &extend,
+						  ctxt);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -3838,6 +3961,7 @@ static int ocfs2_add_new_xattr_bucket(struct inode *inode,
 
 	if (extend)
 		ret = ocfs2_extend_xattr_bucket(inode,
+						handle,
 						first_bh,
 						header_bh,
 						num_clusters);
@@ -4039,15 +4163,14 @@ static int ocfs2_xattr_bucket_handle_journal(struct inode *inode,
  * space for the xattr insertion.
  */
 static int ocfs2_xattr_set_entry_in_bucket(struct inode *inode,
+					   handle_t *handle,
 					   struct ocfs2_xattr_info *xi,
 					   struct ocfs2_xattr_search *xs,
 					   u32 name_hash,
 					   int local)
 {
 	int i, ret;
-	handle_t *handle = NULL;
 	u16 blk_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
 	mlog(0, "Set xattr entry len = %lu index = %d in bucket %llu\n",
 	     (unsigned long)xi->value_len, xi->name_index,
@@ -4064,14 +4187,6 @@ static int ocfs2_xattr_set_entry_in_bucket(struct inode *inode,
 		}
 	}
 
-	handle = ocfs2_start_trans(osb, blk_per_bucket);
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		handle = NULL;
-		mlog_errno(ret);
-		goto out;
-	}
-
 	for (i = 0; i < blk_per_bucket; i++) {
 		ret = ocfs2_journal_access(handle, inode, xs->bucket.bhs[i],
 					   OCFS2_JOURNAL_ACCESS_WRITE);
@@ -4089,32 +4204,22 @@ static int ocfs2_xattr_set_entry_in_bucket(struct inode *inode,
 	if (ret)
 		mlog_errno(ret);
 out:
-	ocfs2_commit_trans(osb, handle);
-
 	return ret;
 }
 
 static int ocfs2_xattr_value_update_size(struct inode *inode,
+					 handle_t *handle,
 					 struct buffer_head *xe_bh,
 					 struct ocfs2_xattr_entry *xe,
 					 u64 new_size)
 {
 	int ret;
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	handle_t *handle = NULL;
-
-	handle = ocfs2_start_trans(osb, 1);
-	if (handle == NULL) {
-		ret = -ENOMEM;
-		mlog_errno(ret);
-		goto out;
-	}
 
 	ret = ocfs2_journal_access(handle, inode, xe_bh,
 				   OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret < 0) {
 		mlog_errno(ret);
-		goto out_commit;
+		goto out;
 	}
 
 	xe->xe_value_size = cpu_to_le64(new_size);
@@ -4123,8 +4228,6 @@ static int ocfs2_xattr_value_update_size(struct inode *inode,
 	if (ret < 0)
 		mlog_errno(ret);
 
-out_commit:
-	ocfs2_commit_trans(osb, handle);
 out:
 	return ret;
 }
@@ -4137,9 +4240,11 @@ out:
  * Copy the new updated xe and xe_value_root to new_xe and new_xv if needed.
  */
 static int ocfs2_xattr_bucket_value_truncate(struct inode *inode,
+					     handle_t *handle,
 					     struct buffer_head *header_bh,
 					     int xe_off,
-					     int len)
+					     int len,
+					     struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	int ret, offset;
 	u64 value_blk;
@@ -4174,13 +4279,14 @@ static int ocfs2_xattr_bucket_value_truncate(struct inode *inode,
 
 	mlog(0, "truncate %u in xattr bucket %llu to %d bytes.\n",
 	     xe_off, (unsigned long long)header_bh->b_blocknr, len);
-	ret = ocfs2_xattr_value_truncate(inode, value_bh, xv, len);
+	ret = ocfs2_xattr_value_truncate(inode, handle, value_bh,
+					 xv, len, ctxt);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
 	}
 
-	ret = ocfs2_xattr_value_update_size(inode, header_bh, xe, len);
+	ret = ocfs2_xattr_value_update_size(inode, handle, header_bh, xe, len);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -4192,8 +4298,10 @@ out:
 }
 
 static int ocfs2_xattr_bucket_value_truncate_xs(struct inode *inode,
-						struct ocfs2_xattr_search *xs,
-						int len)
+					handle_t *handle,
+					struct ocfs2_xattr_search *xs,
+					int len,
+					struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	int ret, offset;
 	struct ocfs2_xattr_entry *xe = xs->here;
@@ -4202,8 +4310,9 @@ static int ocfs2_xattr_bucket_value_truncate_xs(struct inode *inode,
 	BUG_ON(!xs->bucket.bhs[0] || !xe || ocfs2_xattr_is_local(xe));
 
 	offset = xe - xh->xh_entries;
-	ret = ocfs2_xattr_bucket_value_truncate(inode, xs->bucket.bhs[0],
-						offset, len);
+	ret = ocfs2_xattr_bucket_value_truncate(inode, handle,
+						xs->bucket.bhs[0],
+						offset, len, ctxt);
 	if (ret)
 		mlog_errno(ret);
 
@@ -4211,6 +4320,7 @@ static int ocfs2_xattr_bucket_value_truncate_xs(struct inode *inode,
 }
 
 static int ocfs2_xattr_bucket_set_value_outside(struct inode *inode,
+						handle_t *handle,
 						struct ocfs2_xattr_search *xs,
 						char *val,
 						int value_len)
@@ -4226,7 +4336,8 @@ static int ocfs2_xattr_bucket_set_value_outside(struct inode *inode,
 
 	xv = (struct ocfs2_xattr_value_root *)(xs->base + offset);
 
-	return __ocfs2_xattr_set_value_outside(inode, xv, val, value_len);
+	return __ocfs2_xattr_set_value_outside(inode, handle,
+					       xv, val, value_len);
 }
 
 static int ocfs2_rm_xattr_cluster(struct inode *inode,
@@ -4319,26 +4430,19 @@ out:
 }
 
 static void ocfs2_xattr_bucket_remove_xs(struct inode *inode,
+					 handle_t *handle,
 					 struct ocfs2_xattr_search *xs)
 {
-	handle_t *handle = NULL;
 	struct ocfs2_xattr_header *xh = xs->bucket.xh;
 	struct ocfs2_xattr_entry *last = &xh->xh_entries[
 						le16_to_cpu(xh->xh_count) - 1];
 	int ret = 0;
 
-	handle = ocfs2_start_trans((OCFS2_SB(inode->i_sb)), 1);
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		mlog_errno(ret);
-		return;
-	}
-
 	ret = ocfs2_journal_access(handle, inode, xs->bucket.bhs[0],
 				   OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
-		goto out_commit;
+		return;
 	}
 
 	/* Remove the old entry. */
@@ -4350,8 +4454,6 @@ static void ocfs2_xattr_bucket_remove_xs(struct inode *inode,
 	ret = ocfs2_journal_dirty(handle, xs->bucket.bhs[0]);
 	if (ret < 0)
 		mlog_errno(ret);
-out_commit:
-	ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
 }
 
 /*
@@ -4366,8 +4468,10 @@ out_commit:
  *    to free the xattr we allocated in set.
  */
 static int ocfs2_xattr_set_in_bucket(struct inode *inode,
+				     handle_t *handle,
 				     struct ocfs2_xattr_info *xi,
-				     struct ocfs2_xattr_search *xs)
+				     struct ocfs2_xattr_search *xs,
+				     struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	int ret, local = 1;
 	size_t value_len;
@@ -4394,8 +4498,8 @@ static int ocfs2_xattr_set_in_bucket(struct inode *inode,
 		else
 			value_len = 0;
 
-		ret = ocfs2_xattr_bucket_value_truncate_xs(inode, xs,
-							   value_len);
+		ret = ocfs2_xattr_bucket_value_truncate_xs(inode, handle,
+							   xs, value_len, ctxt);
 		if (ret)
 			goto out;
 
@@ -4415,7 +4519,8 @@ static int ocfs2_xattr_set_in_bucket(struct inode *inode,
 		xi->value_len = OCFS2_XATTR_ROOT_SIZE;
 	}
 
-	ret = ocfs2_xattr_set_entry_in_bucket(inode, xi, xs, name_hash, local);
+	ret = ocfs2_xattr_set_entry_in_bucket(inode, handle, xi, xs,
+					      name_hash, local);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -4425,8 +4530,8 @@ static int ocfs2_xattr_set_in_bucket(struct inode *inode,
 		goto out;
 
 	/* allocate the space now for the outside block storage. */
-	ret = ocfs2_xattr_bucket_value_truncate_xs(inode, xs,
-						   value_len);
+	ret = ocfs2_xattr_bucket_value_truncate_xs(inode, handle,
+						   xs, value_len, ctxt);
 	if (ret) {
 		mlog_errno(ret);
 
@@ -4436,13 +4541,14 @@ static int ocfs2_xattr_set_in_bucket(struct inode *inode,
 			 * storage and we have allocated xattr already,
 			 * so need to remove it.
 			 */
-			ocfs2_xattr_bucket_remove_xs(inode, xs);
+			ocfs2_xattr_bucket_remove_xs(inode, handle, xs);
 		}
 		goto out;
 	}
 
 set_value_outside:
-	ret = ocfs2_xattr_bucket_set_value_outside(inode, xs, val, value_len);
+	ret = ocfs2_xattr_bucket_set_value_outside(inode, handle,
+						   xs, val, value_len);
 out:
 	return ret;
 }
@@ -4466,8 +4572,10 @@ static int ocfs2_check_xattr_bucket_collision(struct inode *inode,
 }
 
 static int ocfs2_xattr_set_entry_index_block(struct inode *inode,
+					     handle_t *handle,
 					     struct ocfs2_xattr_info *xi,
-					     struct ocfs2_xattr_search *xs)
+					     struct ocfs2_xattr_search *xs,
+					     struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	struct ocfs2_xattr_header *xh;
 	struct ocfs2_xattr_entry *xe;
@@ -4543,7 +4651,8 @@ try_again:
 			 * name/value will be moved, the xe shouldn't be changed
 			 * in xs.
 			 */
-			ret = ocfs2_defrag_xattr_bucket(inode, &xs->bucket);
+			ret = ocfs2_defrag_xattr_bucket(inode, handle,
+							&xs->bucket);
 			if (ret) {
 				mlog_errno(ret);
 				goto out;
@@ -4581,8 +4690,10 @@ try_again:
 		}
 
 		ret = ocfs2_add_new_xattr_bucket(inode,
+						 handle,
 						 xs->xattr_bh,
-						 xs->bucket.bhs[0]);
+						 xs->bucket.bhs[0],
+						 ctxt);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -4604,12 +4715,17 @@ try_again:
 	}
 
 xattr_set:
-	ret = ocfs2_xattr_set_in_bucket(inode, xi, xs);
+	ret = ocfs2_xattr_set_in_bucket(inode, handle, xi, xs, ctxt);
 out:
 	mlog_exit(ret);
 	return ret;
 }
 
+struct ocfs2_delete_xattr_ctxt {
+	struct ocfs2_xattr_set_ctxt *set_ctxt;
+	handle_t *handle;
+};
+
 static int ocfs2_delete_xattr_in_bucket(struct inode *inode,
 					struct ocfs2_xattr_bucket *bucket,
 					void *para)
@@ -4618,6 +4734,23 @@ static int ocfs2_delete_xattr_in_bucket(struct inode *inode,
 	struct ocfs2_xattr_header *xh = bucket->xh;
 	u16 i;
 	struct ocfs2_xattr_entry *xe;
+	handle_t *handle = NULL;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_xattr_set_ctxt ctxt;
+
+	memset(&ctxt, 0, sizeof(ctxt));
+	ocfs2_init_dealloc_ctxt(&ctxt.dealloc);
+
+	/*
+	 * actually ofs2_xattr_value_truncate will extend trans
+	 * if needed, so just 1 is enough.
+	 */
+	handle = ocfs2_start_trans(osb, 1);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		mlog_errno(ret);
+		goto out;
+	}
 
 	for (i = 0; i < le16_to_cpu(xh->xh_count); i++) {
 		xe = &xh->xh_entries[i];
@@ -4625,14 +4758,19 @@ static int ocfs2_delete_xattr_in_bucket(struct inode *inode,
 			continue;
 
 		ret = ocfs2_xattr_bucket_value_truncate(inode,
+							handle,
 							bucket->bhs[0],
-							i, 0);
+							i, 0, &ctxt);
 		if (ret) {
 			mlog_errno(ret);
 			break;
 		}
 	}
 
+	ret = ocfs2_commit_trans(osb, handle);
+	ocfs2_schedule_truncate_log_flush(osb, 1);
+	ocfs2_run_deallocs(osb, &ctxt.dealloc);
+out:
 	return ret;
 }
 
-- 
1.5.4.GIT
