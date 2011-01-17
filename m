From: Tristan Ye <tristan.ye@oracle.com>
Date: Mon, 17 Jan 2011 15:08:57 +0800
Subject: [Ocfs2-devel] [PATCH 9/9] Ocfs2: Handle refcounted extents when
	doing moving/defraging.
Message-ID: <1295248137-24363-1-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

semantically we may don't wanna drop/decrease any refcounts when moving/defraging
the refcounted extents upon one victim inode, and moving extents for all inodes
which shared the extent to be moved, since data blocks never be gonna change there.

while in reality, we probably not are not able to do this, due to lack of way
traversing the inodes which shared the same refcount tree. instead, we CoW and moving
extents for affected inode only, and leave other inodes as-is, just like we writting
those refcounted extents.

The bad thing is, other inodes sharing the refcounted extents can not benefit from
defraging/extents_moving not at all;-)

Simple sanity check and data integrity test has passed against this patch.

Tao, any thoughts?

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/move_extents.c |  112 +++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 99 insertions(+), 13 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index dd5b995..c0f0ae8 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -38,6 +38,7 @@
 #include "buffer_head_io.h"
 #include "sysfile.h"
 #include "suballoc.h"
+#include "refcounttree.h"
 #include "move_extents.h"
 
 struct ocfs2_move_extents_context {
@@ -47,6 +48,7 @@ struct ocfs2_move_extents_context {
 	int credits;
 	u32 new_phys_cpos;
 	u32 clusters_moved;
+	u64 refcount_loc;
 	struct ocfs2_move_extents *range;
 	struct ocfs2_extent_tree et;
 	struct ocfs2_alloc_context *meta_ac;
@@ -216,7 +218,14 @@ static int __ocfs2_move_extent(handle_t *handle,
 	rec = &el->l_recs[index];
 
 	BUG_ON(ext_flags != rec->e_flags);
-	replace_rec.e_flags = rec->e_flags;
+	/*
+	 * after moving/defraging to new location, the extent is not going
+	 * to be refcounted anymore.
+	 */
+	if (ext_flags & OCFS2_EXT_REFCOUNTED)
+		replace_rec.e_flags = ext_flags & ~OCFS2_EXT_REFCOUNTED;
+	else
+		replace_rec.e_flags = ext_flags;
 
 	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode),
 				      context->et.et_root_bh,
@@ -241,8 +250,18 @@ static int __ocfs2_move_extent(handle_t *handle,
 	/*
 	 * need I to append truncate log for old clusters?
 	 */
-	if (old_blkno)
-		ret = ocfs2_truncate_log_append(osb, handle, old_blkno, len);
+	if (old_blkno) {
+		if (ext_flags & OCFS2_EXT_REFCOUNTED)
+			ret = ocfs2_decrease_refcount(inode, handle,
+					ocfs2_blocks_to_clusters(osb->sb,
+								 old_blkno),
+					len, context->meta_ac,
+					&context->dealloc, 1);
+			
+		else
+			ret = ocfs2_truncate_log_append(osb, handle,
+							old_blkno, len);
+	}
 
 out:
 	return ret;
@@ -319,20 +338,48 @@ out:
 static int ocfs2_defrag_extent(struct ocfs2_move_extents_context *context,
 			       u32 cpos, u32 phys_cpos, u32 len, int ext_flags)
 {
-	int ret, credits = 0;
+	int ret, credits = 0, extra_blocks = 0;
 	handle_t *handle;
 	struct inode *inode = context->inode;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct inode *tl_inode = osb->osb_tl_inode;
+	struct ocfs2_refcount_tree *ref_tree = NULL;
 	u32 new_phys_cpos, new_len;
+	u64 phys_blkno = ocfs2_clusters_to_blocks(inode->i_sb, phys_cpos);
+
+	if ((ext_flags & OCFS2_EXT_REFCOUNTED) && len) {
+
+		BUG_ON(!(OCFS2_I(inode)->ip_dyn_features &
+			 OCFS2_HAS_REFCOUNT_FL));
+
+		BUG_ON(!context->refcount_loc);
+
+		ret = ocfs2_lock_refcount_tree(osb, context->refcount_loc, 1,
+					       &ref_tree, NULL);
+		if (ret) {
+			mlog_errno(ret);
+			return ret;
+		}
+		
+		ret = ocfs2_prepare_refcount_change_for_del(inode,
+							context->refcount_loc,
+							phys_blkno,
+							len,
+							&credits,
+							&extra_blocks);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+	}
 
 	ret = ocfs2_lock_allocators_move_extents(inode, &context->et, len, 1,
 						 &context->meta_ac,
 						 &context->data_ac,
-						 0, &credits);
+						 extra_blocks, &credits);
 	if (ret) {
 		mlog_errno(ret);
-		return ret;
+		goto out;
 	}
 
 	/*
@@ -348,7 +395,7 @@ static int ocfs2_defrag_extent(struct ocfs2_move_extents_context *context,
 		ret = __ocfs2_flush_truncate_log(osb);
 		if (ret < 0) {
 			mlog_errno(ret);
-			goto out;
+			goto out_unlock_mutex;
 		}
 	}
 
@@ -356,7 +403,7 @@ static int ocfs2_defrag_extent(struct ocfs2_move_extents_context *context,
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		mlog_errno(ret);
-		goto out;
+		goto out_unlock_mutex;
 	}
 
 	ret = __ocfs2_claim_clusters(handle, context->data_ac, 1, len,
@@ -392,7 +439,7 @@ static int ocfs2_defrag_extent(struct ocfs2_move_extents_context *context,
 out_commit:
 	ocfs2_commit_trans(osb, handle);
 
-out:
+out_unlock_mutex:
 	mutex_unlock(&tl_inode->i_mutex);
 
 	if (context->data_ac) {
@@ -405,6 +452,10 @@ out:
 		context->meta_ac = NULL;
 	}
 
+out:
+	if (ref_tree)
+		ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
+
 	return ret;
 }
 
@@ -696,7 +747,7 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
 			     u32 cpos, u32 phys_cpos, u32 *new_phys_cpos,
 			     u32 len, int ext_flags)
 {
-	int ret, credits = 0, goal_bit = 0;
+	int ret, credits = 0, extra_blocks = 0, goal_bit = 0;
 	handle_t *handle;
 	struct inode *inode = context->inode;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
@@ -705,16 +756,45 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
 	struct buffer_head *gb_bh = NULL;
 	struct buffer_head *gd_bh = NULL;
 	struct ocfs2_group_desc *gd;
+	struct ocfs2_refcount_tree *ref_tree = NULL;
 	u32 move_max_hop = ocfs2_blocks_to_clusters(inode->i_sb,
 						    context->range->me_thresh);
-	u64 new_phys_blkno;
+	u64 phys_blkno, new_phys_blkno;
+
+	phys_blkno = ocfs2_clusters_to_blocks(inode->i_sb, phys_cpos);
+
+	if ((ext_flags & OCFS2_EXT_REFCOUNTED) && len) {
+
+		BUG_ON(!(OCFS2_I(inode)->ip_dyn_features &
+			 OCFS2_HAS_REFCOUNT_FL));
+
+		BUG_ON(!context->refcount_loc);
+
+		ret = ocfs2_lock_refcount_tree(osb, context->refcount_loc, 1,
+					       &ref_tree, NULL);
+		if (ret) {
+			mlog_errno(ret);
+			return ret;
+		}
+		
+		ret = ocfs2_prepare_refcount_change_for_del(inode,
+							context->refcount_loc,
+							phys_blkno,
+							len,
+							&credits,
+							&extra_blocks);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+	}
 
 	ret = ocfs2_lock_allocators_move_extents(inode, &context->et, len, 1,
 						 &context->meta_ac,
-						 NULL, 0, &credits);
+						 NULL, extra_blocks, &credits);
 	if (ret) {
 		mlog_errno(ret);
-		return ret;
+		goto out;
 	}
 
 	/*
@@ -814,6 +894,9 @@ out:
 		context->meta_ac = NULL;
 	}
 
+	if (ref_tree)
+		ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
+
 	return ret;
 }
 
@@ -855,6 +938,7 @@ static int __ocfs2_move_extents_range(struct buffer_head *di_bh,
 	u32 len_defraged = 0, defrag_thresh, new_phys_cpos = 0;
 
 	struct inode *inode = context->inode;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 	struct ocfs2_move_extents *range = context->range;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
@@ -864,6 +948,8 @@ static int __ocfs2_move_extents_range(struct buffer_head *di_bh,
 	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
 		return 0;
 
+	context->refcount_loc = le64_to_cpu(di->i_refcount_loc);
+
 	ocfs2_init_dinode_extent_tree(&context->et, INODE_CACHE(inode), di_bh);
 	ocfs2_init_dealloc_ctxt(&context->dealloc);
 
-- 
1.5.5
