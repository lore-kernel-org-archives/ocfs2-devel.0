From: Tristan Ye <tristan.ye@oracle.com>
Date: Fri, 18 Mar 2011 14:35:42 +0800
Subject: [Ocfs2-devel] [PATCH 15/16] Ocfs2/move_extents: Let defrag handle
	partial extent moving.
In-Reply-To: <1300430143-23909-1-git-send-email-tristan.ye@oracle.com>
References: <1300430143-23909-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1300430143-23909-16-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We're going to have multiple attempts/pieces to satisfy the allocations
for a whole extent moving, in case fs was already fragmented severely.

The strategy may need to be compromised however, since it can end up making
the fs even more fragmented somehow, another solution is just to fail the whole
defragmentation with partial part completed when contiguous area for a fixed length
is no longer satisfied.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/move_extents.c |   34 ++++++++++++----------------------
 1 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 71c97de..9b79ee7 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -222,7 +222,7 @@ out:
  * crash happens anywhere.
  */
 static int ocfs2_defrag_extent(struct ocfs2_move_extents_context *context,
-			       u32 cpos, u32 phys_cpos, u32 len, int ext_flags)
+			       u32 cpos, u32 phys_cpos, u32 *len, int ext_flags)
 {
 	int ret, credits = 0, extra_blocks = 0;
 	handle_t *handle;
@@ -233,7 +233,7 @@ static int ocfs2_defrag_extent(struct ocfs2_move_extents_context *context,
 	u32 new_phys_cpos, new_len;
 	u64 phys_blkno = ocfs2_clusters_to_blocks(inode->i_sb, phys_cpos);
 
-	if ((ext_flags & OCFS2_EXT_REFCOUNTED) && len) {
+	if ((ext_flags & OCFS2_EXT_REFCOUNTED) && *len) {
 
 		BUG_ON(!(OCFS2_I(inode)->ip_dyn_features &
 			 OCFS2_HAS_REFCOUNT_FL));
@@ -250,7 +250,7 @@ static int ocfs2_defrag_extent(struct ocfs2_move_extents_context *context,
 		ret = ocfs2_prepare_refcount_change_for_del(inode,
 							context->refcount_loc,
 							phys_blkno,
-							len,
+							*len,
 							&credits,
 							&extra_blocks);
 		if (ret) {
@@ -259,7 +259,7 @@ static int ocfs2_defrag_extent(struct ocfs2_move_extents_context *context,
 		}
 	}
 
-	ret = ocfs2_lock_allocators_move_extents(inode, &context->et, len, 1,
+	ret = ocfs2_lock_allocators_move_extents(inode, &context->et, *len, 1,
 						 &context->meta_ac,
 						 &context->data_ac,
 						 extra_blocks, &credits);
@@ -292,41 +292,31 @@ static int ocfs2_defrag_extent(struct ocfs2_move_extents_context *context,
 		goto out_unlock_mutex;
 	}
 
-	ret = __ocfs2_claim_clusters(handle, context->data_ac, 1, len,
+	ret = __ocfs2_claim_clusters(handle, context->data_ac, 1, *len,
 				     &new_phys_cpos, &new_len);
 	if (ret) {
 		mlog_errno(ret);
 		goto out_commit;
 	}
 
-	/*
-	 * we're not quite patient here to make multiple attempts for claiming
-	 * enough clusters, failure to claim clusters per-requested is not a
-	 * disaster though, it can only mean partial range of defragmentation
-	 * or extent movements gets gone, users anyway is able to have another
-	 * try as they wish anytime, since they're going to be returned a
-	 * '-ENOSPC' and completed length of this movement.
-	 */
-	if (new_len != len) {
-		mlog(0, "len_claimed: %u, len: %u\n", new_len, len);
-		context->range->me_flags &= ~OCFS2_MOVE_EXT_FL_COMPLETE;
-		ret = -ENOSPC;
-		goto out_commit;
-	}
+	if (new_len != *len)
+		mlog(0, "len_claimed: %u, len: %u\n", new_len, *len);
 
 	mlog(0, "cpos: %u, phys_cpos: %u, new_phys_cpos: %u\n", cpos,
 	     phys_cpos, new_phys_cpos);
 
-	ret = __ocfs2_move_extent(handle, context, cpos, len, phys_cpos,
+	ret = __ocfs2_move_extent(handle, context, cpos, new_len, phys_cpos,
 				  new_phys_cpos, ext_flags);
 	if (ret)
 		mlog_errno(ret);
 
+	*len = new_len;
+
 	/*
 	 * Here we should write the new page out first if we are
 	 * in write-back mode.
 	 */
-	ret = ocfs2_cow_sync_writeback(inode->i_sb, context->inode, cpos, len);
+	ret = ocfs2_cow_sync_writeback(inode->i_sb, context->inode, cpos, *len);
 	if (ret)
 		mlog_errno(ret);
 
@@ -930,7 +920,7 @@ static int __ocfs2_move_extents_range(struct buffer_head *di_bh,
 			     cpos, phys_cpos, alloc_size, len_defraged);
 
 			ret = ocfs2_defrag_extent(context, cpos, phys_cpos,
-						  alloc_size, flags);
+						  &alloc_size, flags);
 		} else {
 			ret = ocfs2_move_extent(context, cpos, phys_cpos,
 						&new_phys_cpos, alloc_size,
-- 
1.5.5
