From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 30 Oct 2008 13:42:15 +0800
Subject: [Ocfs2-devel] [PATCH 05/15] ocfs2/xattr: Merge xattr set
	transaction.
In-Reply-To: <49099B13.9030802@oracle.com>
References: <49099B13.9030802@oracle.com>
Message-ID: <1225345335-11527-5-git-send-email-tao.ma@oracle.com>
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

Note:
In xattr set, I try to avoid ocfs2_extend_trans since if
the credits aren't enough for the extension, it will commit
all the dirty blocks and create a new transaction which may
lead to inconsistency in metadata. All ocfs2_extend_trans
remained are safe now.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |  673 ++++++++++++++++++++++++++----------------------------
 1 files changed, 325 insertions(+), 348 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index f6881b4..0e380c4 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -72,6 +72,7 @@ struct ocfs2_xattr_bucket {
 };
 
 struct ocfs2_xattr_set_ctxt {
+	handle_t *handle;
 	struct ocfs2_alloc_context *meta_ac;
 	struct ocfs2_alloc_context *data_ac;
 	struct ocfs2_cached_dealloc_ctxt dealloc;
@@ -344,9 +345,7 @@ static int ocfs2_xattr_extend_allocation(struct inode *inode,
 					 struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	int status = 0;
-	int restart_func = 0;
-	int credits = 0;
-	handle_t *handle = NULL;
+	handle_t *handle = ctxt->handle;
 	enum ocfs2_alloc_restarted why;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	u32 prev_clusters, logical_start = le32_to_cpu(xv->xr_clusters);
@@ -356,19 +355,6 @@ static int ocfs2_xattr_extend_allocation(struct inode *inode,
 
 	ocfs2_init_xattr_value_extent_tree(&et, inode, xattr_bh, xv);
 
-restart_all:
-
-	credits = ocfs2_calc_extend_credits(osb->sb, et.et_root_el,
-					    clusters_to_add);
-	handle = ocfs2_start_trans(osb, credits);
-	if (IS_ERR(handle)) {
-		status = PTR_ERR(handle);
-		handle = NULL;
-		mlog_errno(status);
-		goto leave;
-	}
-
-restarted_transaction:
 	status = ocfs2_journal_access(handle, inode, xattr_bh,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
@@ -387,9 +373,8 @@ restarted_transaction:
 					     ctxt->data_ac,
 					     ctxt->meta_ac,
 					     &why);
-	if ((status < 0) && (status != -EAGAIN)) {
-		if (status != -ENOSPC)
-			mlog_errno(status);
+	if (status < 0) {
+		mlog_errno(status);
 		goto leave;
 	}
 
@@ -401,39 +386,13 @@ restarted_transaction:
 
 	clusters_to_add -= le32_to_cpu(xv->xr_clusters) - prev_clusters;
 
-	if (why != RESTART_NONE && clusters_to_add) {
-		if (why == RESTART_META) {
-			mlog(0, "restarting function.\n");
-			restart_func = 1;
-		} else {
-			BUG_ON(why != RESTART_TRANS);
-
-			mlog(0, "restarting transaction.\n");
-			/* TODO: This can be more intelligent. */
-			credits = ocfs2_calc_extend_credits(osb->sb,
-							    et.et_root_el,
-							    clusters_to_add);
-			status = ocfs2_extend_trans(handle, credits);
-			if (status < 0) {
-				/* handle still has to be committed at
-				 * this point. */
-				status = -ENOMEM;
-				mlog_errno(status);
-				goto leave;
-			}
-			goto restarted_transaction;
-		}
-	}
+	/*
+	 * We should have already allocated enough space before the transaction,
+	 * so no need to restart.
+	 */
+	BUG_ON(why != RESTART_NONE || clusters_to_add);
 
 leave:
-	if (handle) {
-		ocfs2_commit_trans(osb, handle);
-		handle = NULL;
-	}
-	if ((!status) && restart_func) {
-		restart_func = 0;
-		goto restart_all;
-	}
 
 	return status;
 }
@@ -446,31 +405,23 @@ static int __ocfs2_remove_xattr_range(struct inode *inode,
 {
 	int ret;
 	u64 phys_blkno = ocfs2_clusters_to_blocks(inode->i_sb, phys_cpos);
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	handle_t *handle;
+	handle_t *handle = ctxt->handle;
 	struct ocfs2_extent_tree et;
 
 	ocfs2_init_xattr_value_extent_tree(&et, inode, root_bh, xv);
 
-	handle = ocfs2_start_trans(osb, OCFS2_REMOVE_EXTENT_CREDITS);
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		mlog_errno(ret);
-		goto out;
-	}
-
 	ret = ocfs2_journal_access(handle, inode, root_bh,
 				   OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
-		goto out_commit;
+		goto out;
 	}
 
 	ret = ocfs2_remove_extent(inode, &et, cpos, len, handle, ctxt->meta_ac,
 				  &ctxt->dealloc);
 	if (ret) {
 		mlog_errno(ret);
-		goto out_commit;
+		goto out;
 	}
 
 	le32_add_cpu(&xv->xr_clusters, -len);
@@ -478,15 +429,13 @@ static int __ocfs2_remove_xattr_range(struct inode *inode,
 	ret = ocfs2_journal_dirty(handle, root_bh);
 	if (ret) {
 		mlog_errno(ret);
-		goto out_commit;
+		goto out;
 	}
 
 	ret = ocfs2_cache_clusters_dealloc(&ctxt->dealloc, phys_blkno, len);
 	if (ret)
 		mlog_errno(ret);
 
-out_commit:
-	ocfs2_commit_trans(osb, handle);
 out:
 	return ret;
 }
@@ -968,6 +917,7 @@ static int ocfs2_xattr_get(struct inode *inode,
 }
 
 static int __ocfs2_xattr_set_value_outside(struct inode *inode,
+					   handle_t *handle,
 					   struct ocfs2_xattr_value_root *xv,
 					   const void *value,
 					   int value_len)
@@ -979,14 +929,17 @@ static int __ocfs2_xattr_set_value_outside(struct inode *inode,
 	u32 clusters = ocfs2_clusters_for_bytes(inode->i_sb, value_len);
 	u64 blkno;
 	struct buffer_head *bh = NULL;
-	handle_t *handle;
 
 	BUG_ON(clusters > le32_to_cpu(xv->xr_clusters));
 
+	/*
+	 * In __ocfs2_xattr_set_value_outside has already been dirtied,
+	 * so we don't need to worry about whether ocfs2_extend_trans
+	 * will create a new transactio for us or not.
+	 */
 	credits = clusters * bpc;
-	handle = ocfs2_start_trans(OCFS2_SB(inode->i_sb), credits);
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
+	ret = ocfs2_extend_trans(handle, credits);
+	if (ret) {
 		mlog_errno(ret);
 		goto out;
 	}
@@ -996,7 +949,7 @@ static int __ocfs2_xattr_set_value_outside(struct inode *inode,
 					       &num_clusters, &xv->xr_list);
 		if (ret) {
 			mlog_errno(ret);
-			goto out_commit;
+			goto out;
 		}
 
 		blkno = ocfs2_clusters_to_blocks(inode->i_sb, p_cluster);
@@ -1005,7 +958,7 @@ static int __ocfs2_xattr_set_value_outside(struct inode *inode,
 			ret = ocfs2_read_block(inode, blkno, &bh);
 			if (ret) {
 				mlog_errno(ret);
-				goto out_commit;
+				goto out;
 			}
 
 			ret = ocfs2_journal_access(handle,
@@ -1014,7 +967,7 @@ static int __ocfs2_xattr_set_value_outside(struct inode *inode,
 						   OCFS2_JOURNAL_ACCESS_WRITE);
 			if (ret < 0) {
 				mlog_errno(ret);
-				goto out_commit;
+				goto out;
 			}
 
 			cp_len = value_len > blocksize ? blocksize : value_len;
@@ -1028,7 +981,7 @@ static int __ocfs2_xattr_set_value_outside(struct inode *inode,
 			ret = ocfs2_journal_dirty(handle, bh);
 			if (ret < 0) {
 				mlog_errno(ret);
-				goto out_commit;
+				goto out;
 			}
 			brelse(bh);
 			bh = NULL;
@@ -1042,8 +995,6 @@ static int __ocfs2_xattr_set_value_outside(struct inode *inode,
 		}
 		cpos += num_clusters;
 	}
-out_commit:
-	ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
 out:
 	brelse(bh);
 
@@ -1051,28 +1002,21 @@ out:
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
@@ -1083,32 +1027,23 @@ static int ocfs2_xattr_cleanup(struct inode *inode,
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
 
 	xs->here->xe_name_offset = cpu_to_le16(offs);
@@ -1122,8 +1057,6 @@ static int ocfs2_xattr_update_entry(struct inode *inode,
 	ret = ocfs2_journal_dirty(handle, xs->xattr_bh);
 	if (ret < 0)
 		mlog_errno(ret);
-out_commit:
-	ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
 out:
 	return ret;
 }
@@ -1161,13 +1094,13 @@ static int ocfs2_xattr_set_value_outside(struct inode *inode,
 		mlog_errno(ret);
 		return ret;
 	}
-	ret = __ocfs2_xattr_set_value_outside(inode, xv, xi->value,
-					      xi->value_len);
+	ret = ocfs2_xattr_update_entry(inode, ctxt->handle, xi, xs, offs);
 	if (ret < 0) {
 		mlog_errno(ret);
 		return ret;
 	}
-	ret = ocfs2_xattr_update_entry(inode, xi, xs, offs);
+	ret = __ocfs2_xattr_set_value_outside(inode, ctxt->handle, xv,
+					      xi->value, xi->value_len);
 	if (ret < 0)
 		mlog_errno(ret);
 
@@ -1295,7 +1228,7 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)xs->inode_bh->b_data;
 	size_t min_offs = xs->end - xs->base, name_len = strlen(xi->name);
 	size_t size_l = 0;
-	handle_t *handle = NULL;
+	handle_t *handle = ctxt->handle;
 	int free, i, ret;
 	struct ocfs2_xattr_info xi_l = {
 		.name_index = xi->name_index,
@@ -1384,19 +1317,21 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 					goto out;
 				}
 
-				ret = __ocfs2_xattr_set_value_outside(inode,
-								xv,
-								xi->value,
-								xi->value_len);
+				ret = ocfs2_xattr_update_entry(inode,
+							       handle,
+							       xi,
+							       xs,
+							       offs);
 				if (ret < 0) {
 					mlog_errno(ret);
 					goto out;
 				}
 
-				ret = ocfs2_xattr_update_entry(inode,
-							       xi,
-							       xs,
-							       offs);
+				ret = __ocfs2_xattr_set_value_outside(inode,
+								handle,
+								xv,
+								xi->value,
+								xi->value_len);
 				if (ret < 0)
 					mlog_errno(ret);
 				goto out;
@@ -1406,45 +1341,29 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 				 * just trucate old value to zero.
 				 */
 				 ret = ocfs2_xattr_value_truncate(inode,
-								 xs->xattr_bh,
-								 xv,
-								 0,
-								 ctxt);
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
 
@@ -1458,7 +1377,7 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 		ret = ocfs2_journal_dirty(handle, xs->xattr_bh);
 		if (ret < 0) {
 			mlog_errno(ret);
-			goto out_commit;
+			goto out;
 		}
 	}
 
@@ -1495,9 +1414,6 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 	if (ret < 0)
 		mlog_errno(ret);
 
-out_commit:
-	ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
-
 	if (!ret && xi->value_len > OCFS2_XATTR_INLINE_SIZE) {
 		/*
 		 * Set value outside in B tree.
@@ -1513,14 +1429,14 @@ out_commit:
 			 * If set value outside failed, we have to clean
 			 * the junk tree root we have already set in local.
 			 */
-			ret2 = ocfs2_xattr_cleanup(inode, xi, xs, offs);
+			ret2 = ocfs2_xattr_cleanup(inode, ctxt->handle,
+						   xi, xs, offs);
 			if (ret2 < 0)
 				mlog_errno(ret2);
 		}
 	}
 out:
 	return ret;
-
 }
 
 static int ocfs2_remove_value_outside(struct inode*inode,
@@ -1534,6 +1450,13 @@ static int ocfs2_remove_value_outside(struct inode*inode,
 	memset(&ctxt, 0, sizeof(ctxt));
 	ocfs2_init_dealloc_ctxt(&ctxt.dealloc);
 
+	ctxt.handle = ocfs2_start_trans(osb, OCFS2_REMOVE_EXTENT_CREDITS);
+	if (IS_ERR(ctxt.handle)) {
+		ret = PTR_ERR(ctxt.handle);
+		mlog_errno(ret);
+		goto out;
+	}
+
 	for (i = 0; i < le16_to_cpu(header->xh_count); i++) {
 		struct ocfs2_xattr_entry *entry = &header->xh_entries[i];
 
@@ -1554,8 +1477,10 @@ static int ocfs2_remove_value_outside(struct inode*inode,
 		}
 	}
 
+	ocfs2_commit_trans(osb, ctxt.handle);
 	ocfs2_schedule_truncate_log_flush(osb, 1);
 	ocfs2_run_deallocs(osb, &ctxt.dealloc);
+out:
 	return ret;
 }
 
@@ -1914,7 +1839,7 @@ static int ocfs2_xattr_block_set(struct inode *inode,
 	struct buffer_head *new_bh = NULL;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_dinode *di =  (struct ocfs2_dinode *)xs->inode_bh->b_data;
-	handle_t *handle = NULL;
+	handle_t *handle = ctxt->handle;
 	struct ocfs2_xattr_block *xblk = NULL;
 	u16 suballoc_bit_start;
 	u32 num_got;
@@ -1922,18 +1847,11 @@ static int ocfs2_xattr_block_set(struct inode *inode,
 	int ret;
 
 	if (!xs->xattr_bh) {
-		handle = ocfs2_start_trans(osb,
-					   OCFS2_XATTR_BLOCK_CREATE_CREDITS);
-		if (IS_ERR(handle)) {
-			ret = PTR_ERR(handle);
-			mlog_errno(ret);
-			goto out;
-		}
 		ret = ocfs2_journal_access(handle, inode, xs->inode_bh,
 					   OCFS2_JOURNAL_ACCESS_CREATE);
 		if (ret < 0) {
 			mlog_errno(ret);
-			goto out_commit;
+			goto end;
 		}
 
 		ret = ocfs2_claim_metadata(osb, handle, ctxt->meta_ac, 1,
@@ -1941,7 +1859,7 @@ static int ocfs2_xattr_block_set(struct inode *inode,
 					   &first_blkno);
 		if (ret < 0) {
 			mlog_errno(ret);
-			goto out_commit;
+			goto end;
 		}
 
 		new_bh = sb_getblk(inode->i_sb, first_blkno);
@@ -1951,7 +1869,7 @@ static int ocfs2_xattr_block_set(struct inode *inode,
 					   OCFS2_JOURNAL_ACCESS_CREATE);
 		if (ret < 0) {
 			mlog_errno(ret);
-			goto out_commit;
+			goto end;
 		}
 
 		/* Initialize ocfs2_xattr_block */
@@ -1972,17 +1890,10 @@ static int ocfs2_xattr_block_set(struct inode *inode,
 		ret = ocfs2_journal_dirty(handle, new_bh);
 		if (ret < 0) {
 			mlog_errno(ret);
-			goto out_commit;
+			goto end;
 		}
 		di->i_xattr_loc = cpu_to_le64(first_blkno);
-		ret = ocfs2_journal_dirty(handle, xs->inode_bh);
-		if (ret < 0)
-			mlog_errno(ret);
-out_commit:
-		ocfs2_commit_trans(osb, handle);
-out:
-		if (ret < 0)
-			return ret;
+		ocfs2_journal_dirty(handle, xs->inode_bh);
 	} else
 		xblk = (struct ocfs2_xattr_block *)xs->xattr_bh->b_data;
 
@@ -2051,10 +1962,11 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
 				     struct ocfs2_xattr_search *xis,
 				     struct ocfs2_xattr_search *xbs,
 				     int *clusters_need,
-				     int *meta_need)
+				     int *meta_need,
+				     int *credits_need)
 {
 	int ret = 0, old_in_xb = 0;
-	int clusters_add = 0, meta_add = 0;
+	int clusters_add = 0, meta_add = 0, credits = 0;
 	struct buffer_head *bh = NULL;
 	struct ocfs2_xattr_block *xb = NULL;
 	struct ocfs2_xattr_entry *xe = NULL;
@@ -2065,16 +1977,15 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
 						    xi->value_len);
 	u64 value_size;
 
-	/*
-	 * delete a xattr doesn't need metadata and cluster allocation.
-	 * so return.
-	 */
-	if (!xi->value)
-		goto out;
-
 	if (xis->not_found && xbs->not_found) {
-		if (xi->value_len > OCFS2_XATTR_INLINE_SIZE)
+		credits += ocfs2_blocks_per_xattr_bucket(inode->i_sb);
+
+		if (xi->value_len > OCFS2_XATTR_INLINE_SIZE) {
 			clusters_add += new_clusters;
+			credits += ocfs2_calc_extend_credits(inode->i_sb,
+							&def_xv.xv.xr_list,
+							new_clusters);
+		}
 
 		goto meta_guess;
 	}
@@ -2084,6 +1995,7 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
 		name_offset = le16_to_cpu(xe->xe_name_offset);
 		name_len = OCFS2_XATTR_SIZE(xe->xe_name_len);
 		base = xis->base;
+		credits += OCFS2_INODE_UPDATE_CREDITS;
 	} else {
 		int i, block_off;
 		xb = (struct ocfs2_xattr_block *)xbs->xattr_bh->b_data;
@@ -2099,8 +2011,25 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
 							i, &block_off,
 							&name_offset);
 			base = bucket_block(xbs->bucket, block_off);
-		} else
+			credits += ocfs2_blocks_per_xattr_bucket(inode->i_sb);
+		} else {
 			base = xbs->base;
+			credits += OCFS2_XATTR_BLOCK_UPDATE_CREDITS;
+		}
+	}
+
+	/*
+	 * delete a xattr doesn't need metadata and cluster allocation.
+	 * so just calculate the credits and return.
+	 *
+	 * The credits for removing the value tree will be extended
+	 * by ocfs2_remove_extent itself.
+	 */
+	if (!xi->value) {
+		if (!ocfs2_xattr_is_local(xe))
+			credits += OCFS2_REMOVE_EXTENT_CREDITS;
+
+		goto out;
 	}
 
 	/* do cluster allocation guess first. */
@@ -2115,6 +2044,13 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
 		 */
 		if (ocfs2_xattr_can_be_in_inode(inode, xi, xis)) {
 			clusters_add += new_clusters;
+			credits += OCFS2_REMOVE_EXTENT_CREDITS +
+				    OCFS2_INODE_UPDATE_CREDITS;
+			if (!ocfs2_xattr_is_local(xe))
+				credits += ocfs2_calc_extend_credits(
+							inode->i_sb,
+							&def_xv.xv.xr_list,
+							new_clusters);
 			goto out;
 		}
 	}
@@ -2131,11 +2067,16 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
 		} else
 			xv = &def_xv.xv;
 
-		if (old_clusters >= new_clusters)
+		if (old_clusters >= new_clusters) {
+			credits += OCFS2_REMOVE_EXTENT_CREDITS;
 			goto out;
-		else {
+		} else {
 			meta_add += ocfs2_extend_meta_needed(&xv->xr_list);
 			clusters_add += new_clusters - old_clusters;
+			credits += ocfs2_calc_extend_credits(inode->i_sb,
+							     &xv->xr_list,
+							     new_clusters -
+							     old_clusters);
 			goto out;
 		}
 	} else {
@@ -2171,6 +2112,8 @@ meta_guess:
 			struct ocfs2_extent_list *el =
 				 &xb->xb_attrs.xb_root.xt_list;
 			meta_add += ocfs2_extend_meta_needed(el);
+			credits += ocfs2_calc_extend_credits(inode->i_sb,
+							     el, 1);
 		}
 
 		/*
@@ -2181,16 +2124,23 @@ meta_guess:
 		 * also.
 		 */
 		clusters_add += 1;
+		credits += ocfs2_blocks_per_xattr_bucket(inode->i_sb);
 		if (OCFS2_XATTR_BUCKET_SIZE ==
-			OCFS2_SB(inode->i_sb)->s_clustersize)
+			OCFS2_SB(inode->i_sb)->s_clustersize) {
+			credits += ocfs2_blocks_per_xattr_bucket(inode->i_sb);
 			clusters_add += 1;
-	} else
+		}
+	} else {
 		meta_add += 1;
+		credits += OCFS2_XATTR_BLOCK_CREATE_CREDITS;
+	}
 out:
 	if (clusters_need)
 		*clusters_need = clusters_add;
 	if (meta_need)
 		*meta_need = meta_add;
+	if (credits_need)
+		*credits_need = credits;
 	brelse(bh);
 	return ret;
 }
@@ -2200,7 +2150,8 @@ static int ocfs2_init_xattr_set_ctxt(struct inode *inode,
 				     struct ocfs2_xattr_info *xi,
 				     struct ocfs2_xattr_search *xis,
 				     struct ocfs2_xattr_search *xbs,
-				     struct ocfs2_xattr_set_ctxt *ctxt)
+				     struct ocfs2_xattr_set_ctxt *ctxt,
+				     int *credits)
 {
 	int clusters_add, meta_add, ret;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
@@ -2210,14 +2161,14 @@ static int ocfs2_init_xattr_set_ctxt(struct inode *inode,
 	ocfs2_init_dealloc_ctxt(&ctxt->dealloc);
 
 	ret = ocfs2_calc_xattr_set_need(inode, di, xi, xis, xbs,
-					&clusters_add, &meta_add);
+					&clusters_add, &meta_add, credits);
 	if (ret) {
 		mlog_errno(ret);
 		return ret;
 	}
 
-	mlog(0, "Set xattr %s, reserve meta blocks = %d, clusters = %d\n",
-	     xi->name, meta_add, clusters_add);
+	mlog(0, "Set xattr %s, reserve meta blocks = %d, clusters = %d, "
+	     "credits = %d\n", xi->name, meta_add, clusters_add, *credits);
 
 	if (meta_add) {
 		ret = ocfs2_reserve_new_metadata_blocks(osb, meta_add,
@@ -2248,6 +2199,126 @@ out:
 	return ret;
 }
 
+static int __ocfs2_xattr_set_handle(struct inode *inode,
+				    struct ocfs2_dinode *di,
+				    struct ocfs2_xattr_info *xi,
+				    struct ocfs2_xattr_search *xis,
+				    struct ocfs2_xattr_search *xbs,
+				    struct ocfs2_xattr_set_ctxt *ctxt)
+{
+	int ret = 0, credits;
+
+	if (!xi->value) {
+		/* Remove existing extended attribute */
+		if (!xis->not_found)
+			ret = ocfs2_xattr_ibody_set(inode, xi, xis, ctxt);
+		else if (!xbs->not_found)
+			ret = ocfs2_xattr_block_set(inode, xi, xbs, ctxt);
+	} else {
+		/* We always try to set extended attribute into inode first*/
+		ret = ocfs2_xattr_ibody_set(inode, xi, xis, ctxt);
+		if (!ret && !xbs->not_found) {
+			/*
+			 * If succeed and that extended attribute existing in
+			 * external block, then we will remove it.
+			 */
+			xi->value = NULL;
+			xi->value_len = 0;
+
+			xis->not_found = -ENODATA;
+			ret = ocfs2_calc_xattr_set_need(inode,
+							di,
+							xi,
+							xis,
+							xbs,
+							NULL,
+							NULL,
+							&credits);
+			if (ret) {
+				mlog_errno(ret);
+				goto out;
+			}
+
+			ret = ocfs2_extend_trans(ctxt->handle, credits +
+					ctxt->handle->h_buffer_credits);
+			if (ret) {
+				mlog_errno(ret);
+				goto out;
+			}
+			ret = ocfs2_xattr_block_set(inode, xi, xbs, ctxt);
+		} else if (ret == -ENOSPC) {
+			if (di->i_xattr_loc && !xbs->xattr_bh) {
+				ret = ocfs2_xattr_block_find(inode,
+							     xi->name_index,
+							     xi->name, xbs);
+				if (ret)
+					goto out;
+
+				xis->not_found = -ENODATA;
+				ret = ocfs2_calc_xattr_set_need(inode,
+								di,
+								xi,
+								xis,
+								xbs,
+								NULL,
+								NULL,
+								&credits);
+				if (ret) {
+					mlog_errno(ret);
+					goto out;
+				}
+
+				ret = ocfs2_extend_trans(ctxt->handle, credits +
+					ctxt->handle->h_buffer_credits);
+				if (ret) {
+					mlog_errno(ret);
+					goto out;
+				}
+			}
+			/*
+			 * If no space in inode, we will set extended attribute
+			 * into external block.
+			 */
+			ret = ocfs2_xattr_block_set(inode, xi, xbs, ctxt);
+			if (ret)
+				goto out;
+			if (!xis->not_found) {
+				/*
+				 * If succeed and that extended attribute
+				 * existing in inode, we will remove it.
+				 */
+				xi->value = NULL;
+				xi->value_len = 0;
+				xbs->not_found = -ENODATA;
+				ret = ocfs2_calc_xattr_set_need(inode,
+								di,
+								xi,
+								xis,
+								xbs,
+								NULL,
+								NULL,
+								&credits);
+				if (ret) {
+					mlog_errno(ret);
+					goto out;
+				}
+
+				ret = ocfs2_extend_trans(ctxt->handle, credits +
+						ctxt->handle->h_buffer_credits);
+				if (ret) {
+					mlog_errno(ret);
+					goto out;
+				}
+				ret = ocfs2_xattr_ibody_set(inode, xi,
+							    xis, ctxt);
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
@@ -2264,9 +2335,10 @@ int ocfs2_xattr_set(struct inode *inode,
 {
 	struct buffer_head *di_bh = NULL;
 	struct ocfs2_dinode *di;
-	int ret;
+	int ret, credits;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_xattr_set_ctxt ctxt;
+	struct inode *tl_inode = osb->osb_tl_inode;
 
 	struct ocfs2_xattr_info xi = {
 		.name_index = name_index,
@@ -2333,56 +2405,37 @@ int ocfs2_xattr_set(struct inode *inode,
 			goto cleanup;
 	}
 
-	ret = ocfs2_init_xattr_set_ctxt(inode, di, &xi, &xis, &xbs, &ctxt);
+
+	mutex_lock(&tl_inode->i_mutex);
+
+	if (ocfs2_truncate_log_needs_flush(osb)) {
+		ret = __ocfs2_flush_truncate_log(osb);
+		if (ret < 0) {
+			mutex_unlock(&tl_inode->i_mutex);
+			mlog_errno(ret);
+			goto cleanup;
+		}
+	}
+	mutex_unlock(&tl_inode->i_mutex);
+
+	ret = ocfs2_init_xattr_set_ctxt(inode, di, &xi, &xis,
+					&xbs, &ctxt, &credits);
 	if (ret) {
 		mlog_errno(ret);
 		goto cleanup;
 	}
 
-	if (!value) {
-		/* Remove existing extended attribute */
-		if (!xis.not_found)
-			ret = ocfs2_xattr_ibody_set(inode, &xi, &xis, &ctxt);
-		else if (!xbs.not_found)
-			ret = ocfs2_xattr_block_set(inode, &xi, &xbs, &ctxt);
-	} else {
-		/* We always try to set extended attribute into inode first*/
-		ret = ocfs2_xattr_ibody_set(inode, &xi, &xis, &ctxt);
-		if (!ret && !xbs.not_found) {
-			/*
-			 * If succeed and that extended attribute existing in
-			 * external block, then we will remove it.
-			 */
-			xi.value = NULL;
-			xi.value_len = 0;
-			ret = ocfs2_xattr_block_set(inode, &xi, &xbs, &ctxt);
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
-			ret = ocfs2_xattr_block_set(inode, &xi, &xbs, &ctxt);
-			if (ret)
-				goto free;
-			if (!xis.not_found) {
-				/*
-				 * If succeed and that extended attribute
-				 * existing in inode, we will remove it.
-				 */
-				xi.value = NULL;
-				xi.value_len = 0;
-				ret = ocfs2_xattr_ibody_set(inode, &xi,
-							    &xis, &ctxt);
-			}
-		}
+	ctxt.handle = ocfs2_start_trans(osb, credits);
+	if (IS_ERR(ctxt.handle)) {
+		ret = PTR_ERR(ctxt.handle);
+		mlog_errno(ret);
+		goto cleanup;
 	}
-free:
+
+	ret = __ocfs2_xattr_set_handle(inode, di, &xi, &xis, &xbs, &ctxt);
+
+	ocfs2_commit_trans(osb, ctxt.handle);
+
 	if (ctxt.data_ac)
 		ocfs2_free_alloc_context(ctxt.data_ac);
 	if (ctxt.meta_ac)
@@ -2973,10 +3026,10 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
 					  struct ocfs2_xattr_search *xs,
 					  struct ocfs2_xattr_set_ctxt *ctxt)
 {
-	int ret, credits = OCFS2_SUBALLOC_ALLOC;
+	int ret;
 	u32 bit_off, len;
 	u64 blkno;
-	handle_t *handle;
+	handle_t *handle = ctxt->handle;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct buffer_head *xb_bh = xs->xattr_bh;
@@ -2998,30 +3051,18 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
 	 */
 	down_write(&oi->ip_alloc_sem);
 
-	/*
-	 * We need more credits.  One for the xattr block update and one
-	 * for each block of the new xattr bucket.
-	 */
-	credits += 1 + ocfs2_blocks_per_xattr_bucket(inode->i_sb);
-	handle = ocfs2_start_trans(osb, credits);
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		mlog_errno(ret);
-		goto out_sem;
-	}
-
 	ret = ocfs2_journal_access(handle, inode, xb_bh,
 				   OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
-		goto out_commit;
+		goto out;
 	}
 
 	ret = __ocfs2_claim_clusters(osb, handle, ctxt->data_ac,
 				     1, 1, &bit_off, &len);
 	if (ret) {
 		mlog_errno(ret);
-		goto out_commit;
+		goto out;
 	}
 
 	/*
@@ -3036,14 +3077,14 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
 	ret = ocfs2_init_xattr_bucket(xs->bucket, blkno);
 	if (ret) {
 		mlog_errno(ret);
-		goto out_commit;
+		goto out;
 	}
 
 	ret = ocfs2_xattr_bucket_journal_access(handle, xs->bucket,
 						OCFS2_JOURNAL_ACCESS_CREATE);
 	if (ret) {
 		mlog_errno(ret);
-		goto out_commit;
+		goto out;
 	}
 
 	ocfs2_cp_xattr_block_to_bucket(inode, xb_bh, xs->bucket);
@@ -3068,16 +3109,9 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
 
 	xb->xb_flags = cpu_to_le16(xb_flags | OCFS2_XATTR_INDEXED);
 
-	ret = ocfs2_journal_dirty(handle, xb_bh);
-	if (ret) {
-		mlog_errno(ret);
-		goto out_commit;
-	}
+	ocfs2_journal_dirty(handle, xb_bh);
 
-out_commit:
-	ocfs2_commit_trans(osb, handle);
-
-out_sem:
+out:
 	up_write(&oi->ip_alloc_sem);
 
 	return ret;
@@ -3103,6 +3137,7 @@ static int cmp_xe_offset(const void *a, const void *b)
  * so that we can spare some space for insertion.
  */
 static int ocfs2_defrag_xattr_bucket(struct inode *inode,
+				     handle_t *handle,
 				     struct ocfs2_xattr_bucket *bucket)
 {
 	int ret, i;
@@ -3112,7 +3147,6 @@ static int ocfs2_defrag_xattr_bucket(struct inode *inode,
 	u64 blkno = bucket_blkno(bucket);
 	u16 xh_free_start;
 	size_t blocksize = inode->i_sb->s_blocksize;
-	handle_t *handle;
 	struct ocfs2_xattr_entry *xe;
 	struct ocfs2_xattr_bucket *wb = NULL;
 
@@ -3142,19 +3176,11 @@ static int ocfs2_defrag_xattr_bucket(struct inode *inode,
 	for (i = 0; i < wb->bu_blocks; i++, buf += blocksize)
 		memcpy(buf, bucket_block(wb, i), blocksize);
 
-	handle = ocfs2_start_trans((OCFS2_SB(inode->i_sb)), wb->bu_blocks);
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		handle = NULL;
-		mlog_errno(ret);
-		goto out;
-	}
-
 	ret = ocfs2_xattr_bucket_journal_access(handle, wb,
 						OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret < 0) {
 		mlog_errno(ret);
-		goto commit;
+		goto out;
 	}
 
 	xh = (struct ocfs2_xattr_header *)bucket_buf;
@@ -3212,7 +3238,7 @@ static int ocfs2_defrag_xattr_bucket(struct inode *inode,
 			"bucket %llu\n", (unsigned long long)blkno);
 
 	if (xh_free_start == end)
-		goto commit;
+		goto out;
 
 	memset(bucket_buf + xh_free_start, 0, end - xh_free_start);
 	xh->xh_free_start = cpu_to_le16(end);
@@ -3227,8 +3253,6 @@ static int ocfs2_defrag_xattr_bucket(struct inode *inode,
 		memcpy(bucket_block(wb, i), buf, blocksize);
 	ocfs2_xattr_bucket_journal_dirty(handle, wb);
 
-commit:
-	ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
 out:
 	ocfs2_xattr_bucket_free(wb);
 	kfree(bucket_buf);
@@ -3280,7 +3304,7 @@ static int ocfs2_mv_xattr_bucket_cross_cluster(struct inode *inode,
 	 * 1 more for the update of the 1st bucket of the previous
 	 * extent record.
 	 */
-	credits = bpc / 2 + 1;
+	credits = bpc / 2 + 1 + handle->h_buffer_credits;
 	ret = ocfs2_extend_trans(handle, credits);
 	if (ret) {
 		mlog_errno(ret);
@@ -3670,7 +3694,7 @@ static int ocfs2_cp_xattr_cluster(struct inode *inode,
 	 * We need to update the new cluster and 1 more for the update of
 	 * the 1st bucket of the previous extent rec.
 	 */
-	credits = bpc + 1;
+	credits = bpc + 1 + handle->h_buffer_credits;
 	ret = ocfs2_extend_trans(handle, credits);
 	if (ret) {
 		mlog_errno(ret);
@@ -3740,7 +3764,7 @@ static int ocfs2_divide_xattr_cluster(struct inode *inode,
 				      u32 *first_hash)
 {
 	u16 blk_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
-	int ret, credits = 2 * blk_per_bucket;
+	int ret, credits = 2 * blk_per_bucket + handle->h_buffer_credits;
 
 	BUG_ON(OCFS2_XATTR_BUCKET_SIZE < OCFS2_SB(inode->i_sb)->s_clustersize);
 
@@ -3852,12 +3876,12 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 				       int *extend,
 				       struct ocfs2_xattr_set_ctxt *ctxt)
 {
-	int ret, credits;
+	int ret;
 	u16 bpc = ocfs2_clusters_to_blocks(inode->i_sb, 1);
 	u32 prev_clusters = *num_clusters;
 	u32 clusters_to_add = 1, bit_off, num_bits, v_start = 0;
 	u64 block;
-	handle_t *handle = NULL;
+	handle_t *handle = ctxt->handle;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_extent_tree et;
 
@@ -3868,16 +3892,6 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 
 	ocfs2_init_xattr_tree_extent_tree(&et, inode, root_bh);
 
-	credits = ocfs2_calc_extend_credits(osb->sb, et.et_root_el,
-					    clusters_to_add);
-	handle = ocfs2_start_trans(osb, credits);
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		handle = NULL;
-		mlog_errno(ret);
-		goto leave;
-	}
-
 	ret = ocfs2_journal_access(handle, inode, root_bh,
 				   OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret < 0) {
@@ -3931,18 +3945,6 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 		}
 	}
 
-	if (handle->h_buffer_credits < credits) {
-		/*
-		 * The journal has been restarted before, and don't
-		 * have enough space for the insertion, so extend it
-		 * here.
-		 */
-		ret = ocfs2_extend_trans(handle, credits);
-		if (ret) {
-			mlog_errno(ret);
-			goto leave;
-		}
-	}
 	mlog(0, "Insert %u clusters at block %llu for xattr@%u\n",
 	     num_bits, block, v_start);
 	ret = ocfs2_insert_extent(osb, handle, inode, &et, v_start, block,
@@ -3953,15 +3955,10 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
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
-
 	return ret;
 }
 
@@ -3970,6 +3967,7 @@ leave:
  * We meet with start_bh. Only move half of the xattrs to the bucket after it.
  */
 static int ocfs2_extend_xattr_bucket(struct inode *inode,
+				     handle_t *handle,
 				     struct buffer_head *first_bh,
 				     struct buffer_head *start_bh,
 				     u32 num_clusters)
@@ -3979,7 +3977,6 @@ static int ocfs2_extend_xattr_bucket(struct inode *inode,
 	u16 blk_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
 	u64 start_blk = start_bh->b_blocknr, end_blk;
 	u32 num_buckets = num_clusters * ocfs2_xattr_buckets_per_cluster(osb);
-	handle_t *handle;
 	struct ocfs2_xattr_header *first_xh =
 				(struct ocfs2_xattr_header *)first_bh->b_data;
 	u16 bucket = le16_to_cpu(first_xh->xh_num_buckets);
@@ -3996,11 +3993,10 @@ static int ocfs2_extend_xattr_bucket(struct inode *inode,
 	 * We will touch all the buckets after the start_bh(include it).
 	 * Then we add one more bucket.
 	 */
-	credits = end_blk - start_blk + 3 * blk_per_bucket + 1;
-	handle = ocfs2_start_trans(osb, credits);
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		handle = NULL;
+	credits = end_blk - start_blk + 3 * blk_per_bucket + 1 +
+		  handle->h_buffer_credits;
+	ret = ocfs2_extend_trans(handle, credits);
+	if (ret) {
 		mlog_errno(ret);
 		goto out;
 	}
@@ -4009,14 +4005,14 @@ static int ocfs2_extend_xattr_bucket(struct inode *inode,
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
 
@@ -4027,8 +4023,6 @@ static int ocfs2_extend_xattr_bucket(struct inode *inode,
 	le16_add_cpu(&first_xh->xh_num_buckets, 1);
 	ocfs2_journal_dirty(handle, first_bh);
 
-commit:
-	ocfs2_commit_trans(osb, handle);
 out:
 	return ret;
 }
@@ -4106,6 +4100,7 @@ static int ocfs2_add_new_xattr_bucket(struct inode *inode,
 
 	if (extend)
 		ret = ocfs2_extend_xattr_bucket(inode,
+						ctxt->handle,
 						first_bh,
 						header_bh,
 						num_clusters);
@@ -4279,14 +4274,13 @@ set_new_name_value:
  * space for the xattr insertion.
  */
 static int ocfs2_xattr_set_entry_in_bucket(struct inode *inode,
+					   handle_t *handle,
 					   struct ocfs2_xattr_info *xi,
 					   struct ocfs2_xattr_search *xs,
 					   u32 name_hash,
 					   int local)
 {
 	int ret;
-	handle_t *handle = NULL;
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	u64 blkno;
 
 	mlog(0, "Set xattr entry len = %lu index = %d in bucket %llu\n",
@@ -4303,14 +4297,6 @@ static int ocfs2_xattr_set_entry_in_bucket(struct inode *inode,
 		}
 	}
 
-	handle = ocfs2_start_trans(osb, xs->bucket->bu_blocks);
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		handle = NULL;
-		mlog_errno(ret);
-		goto out;
-	}
-
 	ret = ocfs2_xattr_bucket_journal_access(handle, xs->bucket,
 						OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret < 0) {
@@ -4322,32 +4308,22 @@ static int ocfs2_xattr_set_entry_in_bucket(struct inode *inode,
 	ocfs2_xattr_bucket_journal_dirty(handle, xs->bucket);
 
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
-	if (IS_ERR(handle)) {
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
@@ -4356,8 +4332,6 @@ static int ocfs2_xattr_value_update_size(struct inode *inode,
 	if (ret < 0)
 		mlog_errno(ret);
 
-out_commit:
-	ocfs2_commit_trans(osb, handle);
 out:
 	return ret;
 }
@@ -4414,7 +4388,8 @@ static int ocfs2_xattr_bucket_value_truncate(struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_xattr_value_update_size(inode, header_bh, xe, len);
+	ret = ocfs2_xattr_value_update_size(inode, ctxt->handle,
+					    header_bh, xe, len);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -4446,6 +4421,7 @@ static int ocfs2_xattr_bucket_value_truncate_xs(struct inode *inode,
 }
 
 static int ocfs2_xattr_bucket_set_value_outside(struct inode *inode,
+						handle_t *handle,
 						struct ocfs2_xattr_search *xs,
 						char *val,
 						int value_len)
@@ -4461,7 +4437,8 @@ static int ocfs2_xattr_bucket_set_value_outside(struct inode *inode,
 
 	xv = (struct ocfs2_xattr_value_root *)(xs->base + offset);
 
-	return __ocfs2_xattr_set_value_outside(inode, xv, val, value_len);
+	return __ocfs2_xattr_set_value_outside(inode, handle,
+					       xv, val, value_len);
 }
 
 static int ocfs2_rm_xattr_cluster(struct inode *inode,
@@ -4554,27 +4531,19 @@ out:
 }
 
 static void ocfs2_xattr_bucket_remove_xs(struct inode *inode,
+					 handle_t *handle,
 					 struct ocfs2_xattr_search *xs)
 {
-	handle_t *handle = NULL;
 	struct ocfs2_xattr_header *xh = bucket_xh(xs->bucket);
 	struct ocfs2_xattr_entry *last = &xh->xh_entries[
 						le16_to_cpu(xh->xh_count) - 1];
 	int ret = 0;
 
-	handle = ocfs2_start_trans((OCFS2_SB(inode->i_sb)),
-				   ocfs2_blocks_per_xattr_bucket(inode->i_sb));
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		mlog_errno(ret);
-		return;
-	}
-
 	ret = ocfs2_xattr_bucket_journal_access(handle, xs->bucket,
 						OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
-		goto out_commit;
+		return;
 	}
 
 	/* Remove the old entry. */
@@ -4584,9 +4553,6 @@ static void ocfs2_xattr_bucket_remove_xs(struct inode *inode,
 	le16_add_cpu(&xh->xh_count, -1);
 
 	ocfs2_xattr_bucket_journal_dirty(handle, xs->bucket);
-
-out_commit:
-	ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
 }
 
 /*
@@ -4652,7 +4618,8 @@ static int ocfs2_xattr_set_in_bucket(struct inode *inode,
 		xi->value_len = OCFS2_XATTR_ROOT_SIZE;
 	}
 
-	ret = ocfs2_xattr_set_entry_in_bucket(inode, xi, xs, name_hash, local);
+	ret = ocfs2_xattr_set_entry_in_bucket(inode, ctxt->handle, xi, xs,
+					      name_hash, local);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -4673,13 +4640,14 @@ static int ocfs2_xattr_set_in_bucket(struct inode *inode,
 			 * storage and we have allocated xattr already,
 			 * so need to remove it.
 			 */
-			ocfs2_xattr_bucket_remove_xs(inode, xs);
+			ocfs2_xattr_bucket_remove_xs(inode, ctxt->handle, xs);
 		}
 		goto out;
 	}
 
 set_value_outside:
-	ret = ocfs2_xattr_bucket_set_value_outside(inode, xs, val, value_len);
+	ret = ocfs2_xattr_bucket_set_value_outside(inode, ctxt->handle,
+						   xs, val, value_len);
 out:
 	return ret;
 }
@@ -4792,7 +4760,8 @@ try_again:
 			 * name/value will be moved, the xe shouldn't be changed
 			 * in xs.
 			 */
-			ret = ocfs2_defrag_xattr_bucket(inode, xs->bucket);
+			ret = ocfs2_defrag_xattr_bucket(inode, ctxt->handle,
+							xs->bucket);
 			if (ret) {
 				mlog_errno(ret);
 				goto out;
@@ -4873,6 +4842,13 @@ static int ocfs2_delete_xattr_in_bucket(struct inode *inode,
 	memset(&ctxt, 0, sizeof(ctxt));
 	ocfs2_init_dealloc_ctxt(&ctxt.dealloc);
 
+	ctxt.handle = ocfs2_start_trans(osb, OCFS2_REMOVE_EXTENT_CREDITS);
+	if (IS_ERR(ctxt.handle)) {
+		ret = PTR_ERR(ctxt.handle);
+		mlog_errno(ret);
+		goto out;
+	}
+
 	for (i = 0; i < le16_to_cpu(xh->xh_count); i++) {
 		xe = &xh->xh_entries[i];
 		if (ocfs2_xattr_is_local(xe))
@@ -4887,9 +4863,10 @@ static int ocfs2_delete_xattr_in_bucket(struct inode *inode,
 		}
 	}
 
+	ret = ocfs2_commit_trans(osb, ctxt.handle);
 	ocfs2_schedule_truncate_log_flush(osb, 1);
 	ocfs2_run_deallocs(osb, &ctxt.dealloc);
-
+out:
 	return ret;
 }
 
-- 
1.5.4.GIT
