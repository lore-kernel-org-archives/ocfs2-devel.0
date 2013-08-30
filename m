From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Fri, 30 Aug 2013 08:40:46 -0500
Subject: [Ocfs2-devel] [PATCH] Remove unnecessary variable bits_wanted from
 ocfs2_calc_extend_credits
Message-ID: <20130830134041.GA4427@shrek.cartoons>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Code cleanup to remove unnecessary variable passed but never used
to ocfs2_calc_extend_credits.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/ocfs2/aops.c         |  3 +--
 fs/ocfs2/dir.c          |  4 ++--
 fs/ocfs2/file.c         |  6 ++----
 fs/ocfs2/journal.h      |  3 +--
 fs/ocfs2/move_extents.c |  3 +--
 fs/ocfs2/refcounttree.c |  9 +++------
 fs/ocfs2/xattr.c        | 20 +++++++-------------
 7 files changed, 17 insertions(+), 31 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 2abf97b..a230138 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1808,8 +1808,7 @@ try_again:
 			data_ac->ac_resv = &OCFS2_I(inode)->ip_la_data_resv;
 
 		credits = ocfs2_calc_extend_credits(inode->i_sb,
-						    &di->id2.i_list,
-						    clusters_to_alloc);
+						    &di->id2.i_list);
 
 	}
 
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 30544ce..93b0791 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -3284,7 +3284,7 @@ static int ocfs2_extend_dir(struct ocfs2_super *osb,
 		if (ocfs2_dir_resv_allowed(osb))
 			data_ac->ac_resv = &OCFS2_I(dir)->ip_la_data_resv;
 
-		credits = ocfs2_calc_extend_credits(sb, el, 1);
+		credits = ocfs2_calc_extend_credits(sb, el);
 	} else {
 		spin_unlock(&OCFS2_I(dir)->ip_lock);
 		credits = OCFS2_SIMPLE_DIR_EXTEND_CREDITS;
@@ -3716,7 +3716,7 @@ static int ocfs2_dx_dir_rebalance_credits(struct ocfs2_super *osb,
 {
 	int credits = ocfs2_clusters_to_blocks(osb->sb, 2);
 
-	credits += ocfs2_calc_extend_credits(osb->sb, &dx_root->dr_list, 1);
+	credits += ocfs2_calc_extend_credits(osb->sb, &dx_root->dr_list);
 	credits += ocfs2_quota_trans_credits(osb->sb);
 	return credits;
 }
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 3261d71..7870449 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -603,8 +603,7 @@ restart_all:
 		goto leave;
 	}
 
-	credits = ocfs2_calc_extend_credits(osb->sb, &fe->id2.i_list,
-					    clusters_to_add);
+	credits = ocfs2_calc_extend_credits(osb->sb, &fe->id2.i_list);
 	handle = ocfs2_start_trans(osb, credits);
 	if (IS_ERR(handle)) {
 		status = PTR_ERR(handle);
@@ -673,8 +672,7 @@ restarted_transaction:
 
 			/* TODO: This can be more intelligent. */
 			credits = ocfs2_calc_extend_credits(osb->sb,
-							    &fe->id2.i_list,
-							    clusters_to_add);
+							    &fe->id2.i_list);
 			status = ocfs2_extend_trans(handle, credits);
 			if (status < 0) {
 				/* handle still has to be committed at
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 0a99273..8a75f6b 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -513,8 +513,7 @@ static inline int ocfs2_calc_dxi_expand_credits(struct super_block *sb)
  * the result may be wrong.
  */
 static inline int ocfs2_calc_extend_credits(struct super_block *sb,
-					    struct ocfs2_extent_list *root_el,
-					    u32 bits_wanted)
+					    struct ocfs2_extent_list *root_el)
 {
 	int bitmap_blocks, sysfile_bitmap_blocks, extent_blocks;
 
diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 452068b..5d224e88 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -200,8 +200,7 @@ static int ocfs2_lock_allocators_move_extents(struct inode *inode,
 		}
 	}
 
-	*credits += ocfs2_calc_extend_credits(osb->sb, et->et_root_el,
-					      clusters_to_move + 2);
+	*credits += ocfs2_calc_extend_credits(osb->sb, et->et_root_el);
 
 	mlog(0, "reserve metadata_blocks: %d, data_clusters: %u, credits: %d\n",
 	     extra_blocks, clusters_to_move, *credits);
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index a70d604..2b21625 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -2502,8 +2502,7 @@ static int ocfs2_calc_refcount_meta_credits(struct super_block *sb,
 		ocfs2_init_refcount_extent_tree(&et, ci, ref_root_bh);
 		*meta_add += ocfs2_extend_meta_needed(et.et_root_el);
 		*credits += ocfs2_calc_extend_credits(sb,
-						      et.et_root_el,
-						      ref_blocks);
+						      et.et_root_el);
 	} else {
 		*credits += OCFS2_EXPAND_REFCOUNT_TREE_CREDITS;
 		*meta_add += 1;
@@ -2874,8 +2873,7 @@ static int ocfs2_lock_refcount_allocators(struct super_block *sb,
 		meta_add =
 			ocfs2_extend_meta_needed(et->et_root_el);
 
-	*credits += ocfs2_calc_extend_credits(sb, et->et_root_el,
-					      num_clusters + 2);
+	*credits += ocfs2_calc_extend_credits(sb, et->et_root_el);
 
 	ret = ocfs2_calc_refcount_meta_credits(sb, ref_ci, ref_root_bh,
 					       p_cluster, num_clusters,
@@ -3625,8 +3623,7 @@ int ocfs2_refcounted_xattr_delete_need(struct inode *inode,
 
 		ocfs2_init_refcount_extent_tree(&et, ref_ci, ref_root_bh);
 		*credits += ocfs2_calc_extend_credits(inode->i_sb,
-						      et.et_root_el,
-						      ref_blocks);
+						      et.et_root_el);
 	}
 
 out:
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 317ef0a..81813e6 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -754,8 +754,7 @@ static int ocfs2_xattr_extend_allocation(struct inode *inode,
 			BUG_ON(why == RESTART_META);
 
 			credits = ocfs2_calc_extend_credits(inode->i_sb,
-							    &vb->vb_xv->xr_list,
-							    clusters_to_add);
+							    &vb->vb_xv->xr_list);
 			status = ocfs2_extend_trans(handle, credits);
 			if (status < 0) {
 				status = -ENOMEM;
@@ -3040,8 +3039,7 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
 		if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE) {
 			clusters_add += new_clusters;
 			credits += ocfs2_calc_extend_credits(inode->i_sb,
-							&def_xv.xv.xr_list,
-							new_clusters);
+							&def_xv.xv.xr_list);
 		}
 
 		goto meta_guess;
@@ -3106,8 +3104,7 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
 			if (!ocfs2_xattr_is_local(xe))
 				credits += ocfs2_calc_extend_credits(
 							inode->i_sb,
-							&def_xv.xv.xr_list,
-							new_clusters);
+							&def_xv.xv.xr_list);
 			goto out;
 		}
 	}
@@ -3132,9 +3129,7 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
 			meta_add += ocfs2_extend_meta_needed(&xv->xr_list);
 			clusters_add += new_clusters - old_clusters;
 			credits += ocfs2_calc_extend_credits(inode->i_sb,
-							     &xv->xr_list,
-							     new_clusters -
-							     old_clusters);
+							     &xv->xr_list);
 			if (value_size >= OCFS2_XATTR_ROOT_SIZE)
 				goto out;
 		}
@@ -3180,7 +3175,7 @@ meta_guess:
 				 &xb->xb_attrs.xb_root.xt_list;
 			meta_add += ocfs2_extend_meta_needed(el);
 			credits += ocfs2_calc_extend_credits(inode->i_sb,
-							     el, 1);
+							     el);
 		} else
 			credits += OCFS2_SUBALLOC_ALLOC + 1;
 
@@ -6211,8 +6206,7 @@ static int ocfs2_value_metas_in_xattr_header(struct super_block *sb,
 			  le16_to_cpu(xv->xr_list.l_next_free_rec);
 
 		*credits += ocfs2_calc_extend_credits(sb,
-						&def_xv.xv.xr_list,
-						le32_to_cpu(xv->xr_clusters));
+						&def_xv.xv.xr_list);
 
 		/*
 		 * If the value is a tree with depth > 1, We don't go deep
@@ -6777,7 +6771,7 @@ static int ocfs2_lock_reflink_xattr_rec_allocators(
 		metas.num_metas += ocfs2_extend_meta_needed(xt_et->et_root_el);
 
 	*credits += ocfs2_calc_extend_credits(osb->sb,
-					      xt_et->et_root_el, len);
+					      xt_et->et_root_el);
 
 	if (metas.num_metas) {
 		ret = ocfs2_reserve_new_metadata_blocks(osb, metas.num_metas,
-- 
1.8.1.4


-- 
Goldwyn
