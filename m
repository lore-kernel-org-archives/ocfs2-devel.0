From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 30 Oct 2008 13:42:14 +0800
Subject: [Ocfs2-devel] [PATCH 04/15] ocfs2/xattr: Reserve meta/data at the
	beginning of ocfs2_xattr_set.
In-Reply-To: <49099B13.9030802@oracle.com>
References: <49099B13.9030802@oracle.com>
Message-ID: <1225345335-11527-4-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2 xattr set, we reserve metadata and clusters in any place
they are needed. It is time-consuming and ineffective, so this
patch try to reserve metadata and clusters at the beginning of
ocfs2_xattr_set.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |  486 ++++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 360 insertions(+), 126 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 7605677..f6881b4 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -71,6 +71,12 @@ struct ocfs2_xattr_bucket {
 	int bu_blocks;
 };
 
+struct ocfs2_xattr_set_ctxt {
+	struct ocfs2_alloc_context *meta_ac;
+	struct ocfs2_alloc_context *data_ac;
+	struct ocfs2_cached_dealloc_ctxt dealloc;
+};
+
 #define OCFS2_XATTR_ROOT_SIZE	(sizeof(struct ocfs2_xattr_def_value_root))
 #define OCFS2_XATTR_INLINE_SIZE	80
 
@@ -133,11 +139,13 @@ static int ocfs2_xattr_tree_list_index_block(struct inode *inode,
 					size_t buffer_size);
 
 static int ocfs2_xattr_create_index_block(struct inode *inode,
-					  struct ocfs2_xattr_search *xs);
+					  struct ocfs2_xattr_search *xs,
+					  struct ocfs2_xattr_set_ctxt *ctxt);
 
 static int ocfs2_xattr_set_entry_index_block(struct inode *inode,
 					     struct ocfs2_xattr_info *xi,
-					     struct ocfs2_xattr_search *xs);
+					     struct ocfs2_xattr_search *xs,
+					     struct ocfs2_xattr_set_ctxt *ctxt);
 
 static int ocfs2_delete_xattr_index_block(struct inode *inode,
 					  struct buffer_head *xb_bh);
@@ -332,14 +340,13 @@ static void ocfs2_xattr_hash_entry(struct inode *inode,
 static int ocfs2_xattr_extend_allocation(struct inode *inode,
 					 u32 clusters_to_add,
 					 struct buffer_head *xattr_bh,
-					 struct ocfs2_xattr_value_root *xv)
+					 struct ocfs2_xattr_value_root *xv,
+					 struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	int status = 0;
 	int restart_func = 0;
 	int credits = 0;
 	handle_t *handle = NULL;
-	struct ocfs2_alloc_context *data_ac = NULL;
-	struct ocfs2_alloc_context *meta_ac = NULL;
 	enum ocfs2_alloc_restarted why;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	u32 prev_clusters, logical_start = le32_to_cpu(xv->xr_clusters);
@@ -351,13 +358,6 @@ static int ocfs2_xattr_extend_allocation(struct inode *inode,
 
 restart_all:
 
-	status = ocfs2_lock_allocators(inode, &et, clusters_to_add, 0,
-				       &data_ac, &meta_ac);
-	if (status) {
-		mlog_errno(status);
-		goto leave;
-	}
-
 	credits = ocfs2_calc_extend_credits(osb->sb, et.et_root_el,
 					    clusters_to_add);
 	handle = ocfs2_start_trans(osb, credits);
@@ -384,8 +384,8 @@ restarted_transaction:
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
@@ -430,14 +430,6 @@ leave:
 		ocfs2_commit_trans(osb, handle);
 		handle = NULL;
 	}
-	if (data_ac) {
-		ocfs2_free_alloc_context(data_ac);
-		data_ac = NULL;
-	}
-	if (meta_ac) {
-		ocfs2_free_alloc_context(meta_ac);
-		meta_ac = NULL;
-	}
 	if ((!status) && restart_func) {
 		restart_func = 0;
 		goto restart_all;
@@ -450,23 +442,16 @@ static int __ocfs2_remove_xattr_range(struct inode *inode,
 				      struct buffer_head *root_bh,
 				      struct ocfs2_xattr_value_root *xv,
 				      u32 cpos, u32 phys_cpos, u32 len,
-				      struct ocfs2_cached_dealloc_ctxt *dealloc)
+				      struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	int ret;
 	u64 phys_blkno = ocfs2_clusters_to_blocks(inode->i_sb, phys_cpos);
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	handle_t *handle;
-	struct ocfs2_alloc_context *meta_ac = NULL;
 	struct ocfs2_extent_tree et;
 
 	ocfs2_init_xattr_value_extent_tree(&et, inode, root_bh, xv);
 
-	ret = ocfs2_lock_allocators(inode, &et, 0, 1, NULL, &meta_ac);
-	if (ret) {
-		mlog_errno(ret);
-		return ret;
-	}
-
 	handle = ocfs2_start_trans(osb, OCFS2_REMOVE_EXTENT_CREDITS);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
@@ -481,8 +466,8 @@ static int __ocfs2_remove_xattr_range(struct inode *inode,
 		goto out_commit;
 	}
 
-	ret = ocfs2_remove_extent(inode, &et, cpos, len, handle, meta_ac,
-				  dealloc);
+	ret = ocfs2_remove_extent(inode, &et, cpos, len, handle, ctxt->meta_ac,
+				  &ctxt->dealloc);
 	if (ret) {
 		mlog_errno(ret);
 		goto out_commit;
@@ -496,17 +481,13 @@ static int __ocfs2_remove_xattr_range(struct inode *inode,
 		goto out_commit;
 	}
 
-	ret = ocfs2_cache_clusters_dealloc(dealloc, phys_blkno, len);
+	ret = ocfs2_cache_clusters_dealloc(&ctxt->dealloc, phys_blkno, len);
 	if (ret)
 		mlog_errno(ret);
 
 out_commit:
 	ocfs2_commit_trans(osb, handle);
 out:
-
-	if (meta_ac)
-		ocfs2_free_alloc_context(meta_ac);
-
 	return ret;
 }
 
@@ -514,15 +495,12 @@ static int ocfs2_xattr_shrink_size(struct inode *inode,
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
@@ -542,7 +520,7 @@ static int ocfs2_xattr_shrink_size(struct inode *inode,
 
 		ret = __ocfs2_remove_xattr_range(inode, root_bh, xv, cpos,
 						 phys_cpos, alloc_size,
-						 &dealloc);
+						 ctxt);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -556,16 +534,14 @@ static int ocfs2_xattr_shrink_size(struct inode *inode,
 	}
 
 out:
-	ocfs2_schedule_truncate_log_flush(osb, 1);
-	ocfs2_run_deallocs(osb, &dealloc);
-
 	return ret;
 }
 
 static int ocfs2_xattr_value_truncate(struct inode *inode,
 				      struct buffer_head *root_bh,
 				      struct ocfs2_xattr_value_root *xv,
-				      int len)
+				      int len,
+				      struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	int ret;
 	u32 new_clusters = ocfs2_clusters_for_bytes(inode->i_sb, len);
@@ -577,11 +553,11 @@ static int ocfs2_xattr_value_truncate(struct inode *inode,
 	if (new_clusters > old_clusters)
 		ret = ocfs2_xattr_extend_allocation(inode,
 						    new_clusters - old_clusters,
-						    root_bh, xv);
+						    root_bh, xv, ctxt);
 	else
 		ret = ocfs2_xattr_shrink_size(inode,
 					      old_clusters, new_clusters,
-					      root_bh, xv);
+					      root_bh, xv, ctxt);
 
 	return ret;
 }
@@ -1160,6 +1136,7 @@ out:
 static int ocfs2_xattr_set_value_outside(struct inode *inode,
 					 struct ocfs2_xattr_info *xi,
 					 struct ocfs2_xattr_search *xs,
+					 struct ocfs2_xattr_set_ctxt *ctxt,
 					 size_t offs)
 {
 	size_t name_len = strlen(xi->name);
@@ -1179,7 +1156,7 @@ static int ocfs2_xattr_set_value_outside(struct inode *inode,
 	xv->xr_list.l_next_free_rec = 0;
 
 	ret = ocfs2_xattr_value_truncate(inode, xs->xattr_bh, xv,
-					 xi->value_len);
+					 xi->value_len, ctxt);
 	if (ret < 0) {
 		mlog_errno(ret);
 		return ret;
@@ -1310,6 +1287,7 @@ static void ocfs2_xattr_set_entry_local(struct inode *inode,
 static int ocfs2_xattr_set_entry(struct inode *inode,
 				 struct ocfs2_xattr_info *xi,
 				 struct ocfs2_xattr_search *xs,
+				 struct ocfs2_xattr_set_ctxt *ctxt,
 				 int flag)
 {
 	struct ocfs2_xattr_entry *last;
@@ -1380,7 +1358,7 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 		if (ocfs2_xattr_is_local(xs->here) && size == size_l) {
 			/* Replace existing local xattr with tree root */
 			ret = ocfs2_xattr_set_value_outside(inode, xi, xs,
-							    offs);
+							    ctxt, offs);
 			if (ret < 0)
 				mlog_errno(ret);
 			goto out;
@@ -1399,7 +1377,8 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 				ret = ocfs2_xattr_value_truncate(inode,
 								 xs->xattr_bh,
 								 xv,
-								 xi->value_len);
+								 xi->value_len,
+								 ctxt);
 				if (ret < 0) {
 					mlog_errno(ret);
 					goto out;
@@ -1429,7 +1408,8 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 				 ret = ocfs2_xattr_value_truncate(inode,
 								 xs->xattr_bh,
 								 xv,
-								 0);
+								 0,
+								 ctxt);
 				if (ret < 0)
 					mlog_errno(ret);
 			}
@@ -1524,7 +1504,7 @@ out_commit:
 		 * This is the second step for value size > INLINE_SIZE.
 		 */
 		size_t offs = le16_to_cpu(xs->here->xe_name_offset);
-		ret = ocfs2_xattr_set_value_outside(inode, xi, xs, offs);
+		ret = ocfs2_xattr_set_value_outside(inode, xi, xs, ctxt, offs);
 		if (ret < 0) {
 			int ret2;
 
@@ -1548,6 +1528,11 @@ static int ocfs2_remove_value_outside(struct inode*inode,
 				      struct ocfs2_xattr_header *header)
 {
 	int ret = 0, i;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_xattr_set_ctxt ctxt;
+
+	memset(&ctxt, 0, sizeof(ctxt));
+	ocfs2_init_dealloc_ctxt(&ctxt.dealloc);
 
 	for (i = 0; i < le16_to_cpu(header->xh_count); i++) {
 		struct ocfs2_xattr_entry *entry = &header->xh_entries[i];
@@ -1560,14 +1545,17 @@ static int ocfs2_remove_value_outside(struct inode*inode,
 				le16_to_cpu(entry->xe_name_offset);
 			xv = (struct ocfs2_xattr_value_root *)
 				(val + OCFS2_XATTR_SIZE(entry->xe_name_len));
-			ret = ocfs2_xattr_value_truncate(inode, bh, xv, 0);
+			ret = ocfs2_xattr_value_truncate(inode, bh, xv,
+							 0, &ctxt);
 			if (ret < 0) {
 				mlog_errno(ret);
-				return ret;
+				break;
 			}
 		}
 	}
 
+	ocfs2_schedule_truncate_log_flush(osb, 1);
+	ocfs2_run_deallocs(osb, &ctxt.dealloc);
 	return ret;
 }
 
@@ -1829,7 +1817,8 @@ static int ocfs2_xattr_ibody_find(struct inode *inode,
  */
 static int ocfs2_xattr_ibody_set(struct inode *inode,
 				 struct ocfs2_xattr_info *xi,
-				 struct ocfs2_xattr_search *xs)
+				 struct ocfs2_xattr_search *xs,
+				 struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)xs->inode_bh->b_data;
@@ -1846,7 +1835,7 @@ static int ocfs2_xattr_ibody_set(struct inode *inode,
 		}
 	}
 
-	ret = ocfs2_xattr_set_entry(inode, xi, xs,
+	ret = ocfs2_xattr_set_entry(inode, xi, xs, ctxt,
 				(OCFS2_INLINE_XATTR_FL | OCFS2_HAS_XATTR_FL));
 out:
 	up_write(&oi->ip_alloc_sem);
@@ -1919,12 +1908,12 @@ cleanup:
  */
 static int ocfs2_xattr_block_set(struct inode *inode,
 				 struct ocfs2_xattr_info *xi,
-				 struct ocfs2_xattr_search *xs)
+				 struct ocfs2_xattr_search *xs,
+				 struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	struct buffer_head *new_bh = NULL;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_dinode *di =  (struct ocfs2_dinode *)xs->inode_bh->b_data;
-	struct ocfs2_alloc_context *meta_ac = NULL;
 	handle_t *handle = NULL;
 	struct ocfs2_xattr_block *xblk = NULL;
 	u16 suballoc_bit_start;
@@ -1933,15 +1922,6 @@ static int ocfs2_xattr_block_set(struct inode *inode,
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
 		handle = ocfs2_start_trans(osb,
 					   OCFS2_XATTR_BLOCK_CREATE_CREDITS);
 		if (IS_ERR(handle)) {
@@ -1956,7 +1936,7 @@ static int ocfs2_xattr_block_set(struct inode *inode,
 			goto out_commit;
 		}
 
-		ret = ocfs2_claim_metadata(osb, handle, meta_ac, 1,
+		ret = ocfs2_claim_metadata(osb, handle, ctxt->meta_ac, 1,
 					   &suballoc_bit_start, &num_got,
 					   &first_blkno);
 		if (ret < 0) {
@@ -1989,7 +1969,6 @@ static int ocfs2_xattr_block_set(struct inode *inode,
 		xs->end = (void *)xblk + inode->i_sb->s_blocksize;
 		xs->here = xs->header->xh_entries;
 
-
 		ret = ocfs2_journal_dirty(handle, new_bh);
 		if (ret < 0) {
 			mlog_errno(ret);
@@ -2002,8 +1981,6 @@ static int ocfs2_xattr_block_set(struct inode *inode,
 out_commit:
 		ocfs2_commit_trans(osb, handle);
 out:
-		if (meta_ac)
-			ocfs2_free_alloc_context(meta_ac);
 		if (ret < 0)
 			return ret;
 	} else
@@ -2011,22 +1988,266 @@ out:
 
 	if (!(le16_to_cpu(xblk->xb_flags) & OCFS2_XATTR_INDEXED)) {
 		/* Set extended attribute into external block */
-		ret = ocfs2_xattr_set_entry(inode, xi, xs, OCFS2_HAS_XATTR_FL);
+		ret = ocfs2_xattr_set_entry(inode, xi, xs, ctxt,
+					    OCFS2_HAS_XATTR_FL);
 		if (!ret || ret != -ENOSPC)
 			goto end;
 
-		ret = ocfs2_xattr_create_index_block(inode, xs);
+		ret = ocfs2_xattr_create_index_block(inode, xs, ctxt);
 		if (ret)
 			goto end;
 	}
 
-	ret = ocfs2_xattr_set_entry_index_block(inode, xi, xs);
+	ret = ocfs2_xattr_set_entry_index_block(inode, xi, xs, ctxt);
 
 end:
 
 	return ret;
 }
 
+/* Check whether the new xattr can be inserted into the inode. */
+static int ocfs2_xattr_can_be_in_inode(struct inode *inode,
+				       struct ocfs2_xattr_info *xi,
+				       struct ocfs2_xattr_search *xs)
+{
+	u64 value_size;
+	struct ocfs2_xattr_entry *last;
+	int free, i;
+	size_t min_offs = xs->end - xs->base;
+
+	if (!xs->header)
+		return 0;
+
+	last = xs->header->xh_entries;
+
+	for (i = 0; i < le16_to_cpu(xs->header->xh_count); i++) {
+		size_t offs = le16_to_cpu(last->xe_name_offset);
+		if (offs < min_offs)
+			min_offs = offs;
+		last += 1;
+	}
+
+	free = min_offs - ((void *)last - xs->base) - sizeof(__u32);
+	if (free < 0)
+		return 0;
+
+	BUG_ON(!xs->not_found);
+
+	if (xi->value_len > OCFS2_XATTR_INLINE_SIZE)
+		value_size = OCFS2_XATTR_ROOT_SIZE;
+	else
+		value_size = OCFS2_XATTR_SIZE(xi->value_len);
+
+	if (free >= sizeof(struct ocfs2_xattr_entry) +
+		   OCFS2_XATTR_SIZE(strlen(xi->name)) + value_size)
+		return 1;
+
+	return 0;
+}
+
+static int ocfs2_calc_xattr_set_need(struct inode *inode,
+				     struct ocfs2_dinode *di,
+				     struct ocfs2_xattr_info *xi,
+				     struct ocfs2_xattr_search *xis,
+				     struct ocfs2_xattr_search *xbs,
+				     int *clusters_need,
+				     int *meta_need)
+{
+	int ret = 0, old_in_xb = 0;
+	int clusters_add = 0, meta_add = 0;
+	struct buffer_head *bh = NULL;
+	struct ocfs2_xattr_block *xb = NULL;
+	struct ocfs2_xattr_entry *xe = NULL;
+	struct ocfs2_xattr_value_root *xv = NULL;
+	char *base = NULL;
+	int name_offset, name_len = 0;
+	u32 new_clusters = ocfs2_clusters_for_bytes(inode->i_sb,
+						    xi->value_len);
+	u64 value_size;
+
+	/*
+	 * delete a xattr doesn't need metadata and cluster allocation.
+	 * so return.
+	 */
+	if (!xi->value)
+		goto out;
+
+	if (xis->not_found && xbs->not_found) {
+		if (xi->value_len > OCFS2_XATTR_INLINE_SIZE)
+			clusters_add += new_clusters;
+
+		goto meta_guess;
+	}
+
+	if (!xis->not_found) {
+		xe = xis->here;
+		name_offset = le16_to_cpu(xe->xe_name_offset);
+		name_len = OCFS2_XATTR_SIZE(xe->xe_name_len);
+		base = xis->base;
+	} else {
+		int i, block_off;
+		xb = (struct ocfs2_xattr_block *)xbs->xattr_bh->b_data;
+		xe = xbs->here;
+		name_offset = le16_to_cpu(xe->xe_name_offset);
+		name_len = OCFS2_XATTR_SIZE(xe->xe_name_len);
+		i = xbs->here - xbs->header->xh_entries;
+		old_in_xb = 1;
+
+		if (le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED) {
+			ret = ocfs2_xattr_bucket_get_name_value(inode,
+							bucket_xh(xbs->bucket),
+							i, &block_off,
+							&name_offset);
+			base = bucket_block(xbs->bucket, block_off);
+		} else
+			base = xbs->base;
+	}
+
+	/* do cluster allocation guess first. */
+	value_size = le64_to_cpu(xe->xe_value_size);
+
+	if (old_in_xb) {
+		/*
+		 * In xattr set, we always try to set the xe in inode first,
+		 * so if it can be inserted into inode successfully, the old
+		 * one will be removed from the xattr block, and this xattr
+		 * will be inserted into inode as a new xattr in inode.
+		 */
+		if (ocfs2_xattr_can_be_in_inode(inode, xi, xis)) {
+			clusters_add += new_clusters;
+			goto out;
+		}
+	}
+
+	if (xi->value_len > OCFS2_XATTR_INLINE_SIZE) {
+		/* the new values will be stored outside. */
+		u32 old_clusters = 0;
+
+		if (!ocfs2_xattr_is_local(xe)) {
+			old_clusters =	ocfs2_clusters_for_bytes(inode->i_sb,
+								 value_size);
+			xv = (struct ocfs2_xattr_value_root *)
+			     (base + name_offset + name_len);
+		} else
+			xv = &def_xv.xv;
+
+		if (old_clusters >= new_clusters)
+			goto out;
+		else {
+			meta_add += ocfs2_extend_meta_needed(&xv->xr_list);
+			clusters_add += new_clusters - old_clusters;
+			goto out;
+		}
+	} else {
+		/*
+		 * Now the new value will be stored inside. So if the new
+		 * value is smaller than the size of value root or the old
+		 * value, we don't need any allocation, otherwise we have
+		 * to guess metadata allocation.
+		 */
+		if ((ocfs2_xattr_is_local(xe) && value_size >= xi->value_len) ||
+		    (!ocfs2_xattr_is_local(xe) &&
+		     OCFS2_XATTR_ROOT_SIZE >= xi->value_len))
+			goto out;
+	}
+
+meta_guess:
+	/* calculate metadata allocation. */
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
+
+		/*
+		 * This cluster will be used either for new bucket or for
+		 * new xattr block.
+		 * If the cluster size is the same as the bucket size, one
+		 * more is needed since we may need to extend the bucket
+		 * also.
+		 */
+		clusters_add += 1;
+		if (OCFS2_XATTR_BUCKET_SIZE ==
+			OCFS2_SB(inode->i_sb)->s_clustersize)
+			clusters_add += 1;
+	} else
+		meta_add += 1;
+out:
+	if (clusters_need)
+		*clusters_need = clusters_add;
+	if (meta_need)
+		*meta_need = meta_add;
+	brelse(bh);
+	return ret;
+}
+
+static int ocfs2_init_xattr_set_ctxt(struct inode *inode,
+				     struct ocfs2_dinode *di,
+				     struct ocfs2_xattr_info *xi,
+				     struct ocfs2_xattr_search *xis,
+				     struct ocfs2_xattr_search *xbs,
+				     struct ocfs2_xattr_set_ctxt *ctxt)
+{
+	int clusters_add, meta_add, ret;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+
+	memset(ctxt, 0, sizeof(struct ocfs2_xattr_set_ctxt));
+
+	ocfs2_init_dealloc_ctxt(&ctxt->dealloc);
+
+	ret = ocfs2_calc_xattr_set_need(inode, di, xi, xis, xbs,
+					&clusters_add, &meta_add);
+	if (ret) {
+		mlog_errno(ret);
+		return ret;
+	}
+
+	mlog(0, "Set xattr %s, reserve meta blocks = %d, clusters = %d\n",
+	     xi->name, meta_add, clusters_add);
+
+	if (meta_add) {
+		ret = ocfs2_reserve_new_metadata_blocks(osb, meta_add,
+							&ctxt->meta_ac);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+	}
+
+	if (clusters_add) {
+		ret = ocfs2_reserve_clusters(osb, clusters_add, &ctxt->data_ac);
+		if (ret)
+			mlog_errno(ret);
+	}
+out:
+	if (ret) {
+		if (ctxt->meta_ac) {
+			ocfs2_free_alloc_context(ctxt->meta_ac);
+			ctxt->meta_ac = NULL;
+		}
+
+		/*
+		 * We cannot have an error and a non null ctxt->data_ac.
+		 */
+	}
+
+	return ret;
+}
+
 /*
  * ocfs2_xattr_set()
  *
@@ -2044,6 +2265,8 @@ int ocfs2_xattr_set(struct inode *inode,
 	struct buffer_head *di_bh = NULL;
 	struct ocfs2_dinode *di;
 	int ret;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_xattr_set_ctxt ctxt;
 
 	struct ocfs2_xattr_info xi = {
 		.name_index = name_index,
@@ -2060,6 +2283,8 @@ int ocfs2_xattr_set(struct inode *inode,
 		.not_found = -ENODATA,
 	};
 
+	memset(&ctxt, 0, sizeof(ctxt));
+
 	if (!ocfs2_supports_xattr(OCFS2_SB(inode->i_sb)))
 		return -EOPNOTSUPP;
 
@@ -2108,15 +2333,21 @@ int ocfs2_xattr_set(struct inode *inode,
 			goto cleanup;
 	}
 
+	ret = ocfs2_init_xattr_set_ctxt(inode, di, &xi, &xis, &xbs, &ctxt);
+	if (ret) {
+		mlog_errno(ret);
+		goto cleanup;
+	}
+
 	if (!value) {
 		/* Remove existing extended attribute */
 		if (!xis.not_found)
-			ret = ocfs2_xattr_ibody_set(inode, &xi, &xis);
+			ret = ocfs2_xattr_ibody_set(inode, &xi, &xis, &ctxt);
 		else if (!xbs.not_found)
-			ret = ocfs2_xattr_block_set(inode, &xi, &xbs);
+			ret = ocfs2_xattr_block_set(inode, &xi, &xbs, &ctxt);
 	} else {
 		/* We always try to set extended attribute into inode first*/
-		ret = ocfs2_xattr_ibody_set(inode, &xi, &xis);
+		ret = ocfs2_xattr_ibody_set(inode, &xi, &xis, &ctxt);
 		if (!ret && !xbs.not_found) {
 			/*
 			 * If succeed and that extended attribute existing in
@@ -2124,7 +2355,7 @@ int ocfs2_xattr_set(struct inode *inode,
 			 */
 			xi.value = NULL;
 			xi.value_len = 0;
-			ret = ocfs2_xattr_block_set(inode, &xi, &xbs);
+			ret = ocfs2_xattr_block_set(inode, &xi, &xbs, &ctxt);
 		} else if (ret == -ENOSPC) {
 			if (di->i_xattr_loc && !xbs.xattr_bh) {
 				ret = ocfs2_xattr_block_find(inode, name_index,
@@ -2136,9 +2367,9 @@ int ocfs2_xattr_set(struct inode *inode,
 			 * If no space in inode, we will set extended attribute
 			 * into external block.
 			 */
-			ret = ocfs2_xattr_block_set(inode, &xi, &xbs);
+			ret = ocfs2_xattr_block_set(inode, &xi, &xbs, &ctxt);
 			if (ret)
-				goto cleanup;
+				goto free;
 			if (!xis.not_found) {
 				/*
 				 * If succeed and that extended attribute
@@ -2146,10 +2377,18 @@ int ocfs2_xattr_set(struct inode *inode,
 				 */
 				xi.value = NULL;
 				xi.value_len = 0;
-				ret = ocfs2_xattr_ibody_set(inode, &xi, &xis);
+				ret = ocfs2_xattr_ibody_set(inode, &xi,
+							    &xis, &ctxt);
 			}
 		}
 	}
+free:
+	if (ctxt.data_ac)
+		ocfs2_free_alloc_context(ctxt.data_ac);
+	if (ctxt.meta_ac)
+		ocfs2_free_alloc_context(ctxt.meta_ac);
+	ocfs2_schedule_truncate_log_flush(osb, 1);
+	ocfs2_run_deallocs(osb, &ctxt.dealloc);
 cleanup:
 	up_write(&OCFS2_I(inode)->ip_xattr_sem);
 	ocfs2_inode_unlock(inode, 1);
@@ -2731,7 +2970,8 @@ static void ocfs2_xattr_update_xattr_search(struct inode *inode,
 }
 
 static int ocfs2_xattr_create_index_block(struct inode *inode,
-					  struct ocfs2_xattr_search *xs)
+					  struct ocfs2_xattr_search *xs,
+					  struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	int ret, credits = OCFS2_SUBALLOC_ALLOC;
 	u32 bit_off, len;
@@ -2739,7 +2979,6 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
 	handle_t *handle;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
-	struct ocfs2_alloc_context *data_ac;
 	struct buffer_head *xb_bh = xs->xattr_bh;
 	struct ocfs2_xattr_block *xb =
 			(struct ocfs2_xattr_block *)xb_bh->b_data;
@@ -2752,12 +2991,6 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
 	BUG_ON(xb_flags & OCFS2_XATTR_INDEXED);
 	BUG_ON(!xs->bucket);
 
-	ret = ocfs2_reserve_clusters(osb, 1, &data_ac);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
-
 	/*
 	 * XXX:
 	 * We can use this lock for now, and maybe move to a dedicated mutex
@@ -2784,7 +3017,8 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
 		goto out_commit;
 	}
 
-	ret = ocfs2_claim_clusters(osb, handle, data_ac, 1, &bit_off, &len);
+	ret = __ocfs2_claim_clusters(osb, handle, ctxt->data_ac,
+				     1, 1, &bit_off, &len);
 	if (ret) {
 		mlog_errno(ret);
 		goto out_commit;
@@ -2846,10 +3080,6 @@ out_commit:
 out_sem:
 	up_write(&oi->ip_alloc_sem);
 
-out:
-	if (data_ac)
-		ocfs2_free_alloc_context(data_ac);
-
 	return ret;
 }
 
@@ -3619,7 +3849,8 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 				       u32 *num_clusters,
 				       u32 prev_cpos,
 				       u64 prev_blkno,
-				       int *extend)
+				       int *extend,
+				       struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	int ret, credits;
 	u16 bpc = ocfs2_clusters_to_blocks(inode->i_sb, 1);
@@ -3627,8 +3858,6 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 	u32 clusters_to_add = 1, bit_off, num_bits, v_start = 0;
 	u64 block;
 	handle_t *handle = NULL;
-	struct ocfs2_alloc_context *data_ac = NULL;
-	struct ocfs2_alloc_context *meta_ac = NULL;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_extent_tree et;
 
@@ -3639,13 +3868,6 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 
 	ocfs2_init_xattr_tree_extent_tree(&et, inode, root_bh);
 
-	ret = ocfs2_lock_allocators(inode, &et, clusters_to_add, 0,
-				    &data_ac, &meta_ac);
-	if (ret) {
-		mlog_errno(ret);
-		goto leave;
-	}
-
 	credits = ocfs2_calc_extend_credits(osb->sb, et.et_root_el,
 					    clusters_to_add);
 	handle = ocfs2_start_trans(osb, credits);
@@ -3663,7 +3885,7 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 		goto leave;
 	}
 
-	ret = __ocfs2_claim_clusters(osb, handle, data_ac, 1,
+	ret = __ocfs2_claim_clusters(osb, handle, ctxt->data_ac, 1,
 				     clusters_to_add, &bit_off, &num_bits);
 	if (ret < 0) {
 		if (ret != -ENOSPC)
@@ -3724,7 +3946,7 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 	mlog(0, "Insert %u clusters at block %llu for xattr@%u\n",
 	     num_bits, block, v_start);
 	ret = ocfs2_insert_extent(osb, handle, inode, &et, v_start, block,
-				  num_bits, 0, meta_ac);
+				  num_bits, 0, ctxt->meta_ac);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto leave;
@@ -3739,10 +3961,6 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 leave:
 	if (handle)
 		ocfs2_commit_trans(osb, handle);
-	if (data_ac)
-		ocfs2_free_alloc_context(data_ac);
-	if (meta_ac)
-		ocfs2_free_alloc_context(meta_ac);
 
 	return ret;
 }
@@ -3826,7 +4044,8 @@ out:
  */
 static int ocfs2_add_new_xattr_bucket(struct inode *inode,
 				      struct buffer_head *xb_bh,
-				      struct buffer_head *header_bh)
+				      struct buffer_head *header_bh,
+				      struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	struct ocfs2_xattr_header *first_xh = NULL;
 	struct buffer_head *first_bh = NULL;
@@ -3877,7 +4096,8 @@ static int ocfs2_add_new_xattr_bucket(struct inode *inode,
 						  &num_clusters,
 						  e_cpos,
 						  p_blkno,
-						  &extend);
+						  &extend,
+						  ctxt);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -4152,7 +4372,8 @@ out:
 static int ocfs2_xattr_bucket_value_truncate(struct inode *inode,
 					     struct buffer_head *header_bh,
 					     int xe_off,
-					     int len)
+					     int len,
+					     struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	int ret, offset;
 	u64 value_blk;
@@ -4187,7 +4408,7 @@ static int ocfs2_xattr_bucket_value_truncate(struct inode *inode,
 
 	mlog(0, "truncate %u in xattr bucket %llu to %d bytes.\n",
 	     xe_off, (unsigned long long)header_bh->b_blocknr, len);
-	ret = ocfs2_xattr_value_truncate(inode, value_bh, xv, len);
+	ret = ocfs2_xattr_value_truncate(inode, value_bh, xv, len, ctxt);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -4205,8 +4426,9 @@ out:
 }
 
 static int ocfs2_xattr_bucket_value_truncate_xs(struct inode *inode,
-						struct ocfs2_xattr_search *xs,
-						int len)
+					struct ocfs2_xattr_search *xs,
+					int len,
+					struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	int ret, offset;
 	struct ocfs2_xattr_entry *xe = xs->here;
@@ -4216,7 +4438,7 @@ static int ocfs2_xattr_bucket_value_truncate_xs(struct inode *inode,
 
 	offset = xe - xh->xh_entries;
 	ret = ocfs2_xattr_bucket_value_truncate(inode, xs->bucket->bu_bhs[0],
-						offset, len);
+						offset, len, ctxt);
 	if (ret)
 		mlog_errno(ret);
 
@@ -4380,7 +4602,8 @@ out_commit:
  */
 static int ocfs2_xattr_set_in_bucket(struct inode *inode,
 				     struct ocfs2_xattr_info *xi,
-				     struct ocfs2_xattr_search *xs)
+				     struct ocfs2_xattr_search *xs,
+				     struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	int ret, local = 1;
 	size_t value_len;
@@ -4408,7 +4631,8 @@ static int ocfs2_xattr_set_in_bucket(struct inode *inode,
 			value_len = 0;
 
 		ret = ocfs2_xattr_bucket_value_truncate_xs(inode, xs,
-							   value_len);
+							   value_len,
+							   ctxt);
 		if (ret)
 			goto out;
 
@@ -4439,7 +4663,7 @@ static int ocfs2_xattr_set_in_bucket(struct inode *inode,
 
 	/* allocate the space now for the outside block storage. */
 	ret = ocfs2_xattr_bucket_value_truncate_xs(inode, xs,
-						   value_len);
+						   value_len, ctxt);
 	if (ret) {
 		mlog_errno(ret);
 
@@ -4490,7 +4714,8 @@ static int ocfs2_check_xattr_bucket_collision(struct inode *inode,
 
 static int ocfs2_xattr_set_entry_index_block(struct inode *inode,
 					     struct ocfs2_xattr_info *xi,
-					     struct ocfs2_xattr_search *xs)
+					     struct ocfs2_xattr_search *xs,
+					     struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	struct ocfs2_xattr_header *xh;
 	struct ocfs2_xattr_entry *xe;
@@ -4608,7 +4833,8 @@ try_again:
 
 		ret = ocfs2_add_new_xattr_bucket(inode,
 						 xs->xattr_bh,
-						 xs->bucket->bu_bhs[0]);
+						 xs->bucket->bu_bhs[0],
+						 ctxt);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -4627,7 +4853,7 @@ try_again:
 	}
 
 xattr_set:
-	ret = ocfs2_xattr_set_in_bucket(inode, xi, xs);
+	ret = ocfs2_xattr_set_in_bucket(inode, xi, xs, ctxt);
 out:
 	mlog_exit(ret);
 	return ret;
@@ -4641,6 +4867,11 @@ static int ocfs2_delete_xattr_in_bucket(struct inode *inode,
 	struct ocfs2_xattr_header *xh = bucket_xh(bucket);
 	u16 i;
 	struct ocfs2_xattr_entry *xe;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_xattr_set_ctxt ctxt;
+
+	memset(&ctxt, 0, sizeof(ctxt));
+	ocfs2_init_dealloc_ctxt(&ctxt.dealloc);
 
 	for (i = 0; i < le16_to_cpu(xh->xh_count); i++) {
 		xe = &xh->xh_entries[i];
@@ -4649,13 +4880,16 @@ static int ocfs2_delete_xattr_in_bucket(struct inode *inode,
 
 		ret = ocfs2_xattr_bucket_value_truncate(inode,
 							bucket->bu_bhs[0],
-							i, 0);
+							i, 0, &ctxt);
 		if (ret) {
 			mlog_errno(ret);
 			break;
 		}
 	}
 
+	ocfs2_schedule_truncate_log_flush(osb, 1);
+	ocfs2_run_deallocs(osb, &ctxt.dealloc);
+
 	return ret;
 }
 
-- 
1.5.4.GIT
