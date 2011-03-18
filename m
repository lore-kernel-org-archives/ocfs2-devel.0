From: Tristan Ye <tristan.ye@oracle.com>
Date: Fri, 18 Mar 2011 14:35:39 +0800
Subject: [Ocfs2-devel] [PATCH 12/16] Ocfs2/move_extents: move entire/partial
	extent.
In-Reply-To: <1300430143-23909-1-git-send-email-tristan.ye@oracle.com>
References: <1300430143-23909-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1300430143-23909-13-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_move_extent() logic will validate the goal_offset_in_block,
where extents to be moved, what's more, it also compromises a bit
to probe the appropriate region around given goal_offset when the
original goal is not able to fit the movement.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/move_extents.c |  165 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 165 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index be60ed0..5b00b8c 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -636,3 +636,168 @@ bail:
 	mlog_exit(status);
 	return status;
 }
+
+static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
+			     u32 cpos, u32 phys_cpos, u32 *new_phys_cpos,
+			     u32 len, int ext_flags)
+{
+	int ret, credits = 0, extra_blocks = 0, goal_bit = 0;
+	handle_t *handle;
+	struct inode *inode = context->inode;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct inode *tl_inode = osb->osb_tl_inode;
+	struct inode *gb_inode = NULL;
+	struct buffer_head *gb_bh = NULL;
+	struct buffer_head *gd_bh = NULL;
+	struct ocfs2_group_desc *gd;
+	struct ocfs2_refcount_tree *ref_tree = NULL;
+	u32 move_max_hop = ocfs2_blocks_to_clusters(inode->i_sb,
+						    context->range->me_thresh);
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
+
+	ret = ocfs2_lock_allocators_move_extents(inode, &context->et, len, 1,
+						 &context->meta_ac,
+						 NULL, extra_blocks, &credits);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	/*
+	 * need to count 2 extra credits for global_bitmap inode and
+	 * group descriptor.
+	 */
+	credits += OCFS2_INODE_UPDATE_CREDITS + 1;
+
+	/*
+	 * ocfs2_move_extent() didn't reserve any clusters in lock_allocators()
+	 * logic, while we still need to lock the global_bitmap.
+	 */
+	gb_inode = ocfs2_get_system_file_inode(osb, GLOBAL_BITMAP_SYSTEM_INODE,
+					       OCFS2_INVALID_SLOT);
+	if (!gb_inode) {
+		mlog(ML_ERROR, "unable to get global_bitmap inode\n");
+		ret = -EIO;
+		goto out;
+	}
+
+	mutex_lock(&gb_inode->i_mutex);
+
+	ret = ocfs2_inode_lock(gb_inode, &gb_bh, 1);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_unlock_gb_mutex;
+	}
+
+	mutex_lock(&tl_inode->i_mutex);
+
+	handle = ocfs2_start_trans(osb, credits);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		mlog_errno(ret);
+		goto out_unlock_tl_inode;
+	}
+
+	new_phys_blkno = ocfs2_clusters_to_blocks(inode->i_sb, *new_phys_cpos);
+	ret = ocfs2_find_victim_alloc_group(inode, new_phys_blkno,
+					    GLOBAL_BITMAP_SYSTEM_INODE,
+					    OCFS2_INVALID_SLOT,
+					    &goal_bit, &gd_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	/*
+	 * probe the victim cluster group to find a proper
+	 * region to fit wanted movement, it even will perfrom
+	 * a best-effort attempt by compromising to a threshold
+	 * around the goal.
+	 */
+	ocfs2_probe_alloc_group(inode, gd_bh, &goal_bit, len, move_max_hop,
+				new_phys_cpos);
+	if (!new_phys_cpos) {
+		ret = -ENOSPC;
+		goto out_commit;
+	}
+
+	ret = __ocfs2_move_extent(handle, context, cpos, len, phys_cpos,
+				  *new_phys_cpos, ext_flags);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	gd = (struct ocfs2_group_desc *)gd_bh->b_data;
+	ret = ocfs2_alloc_dinode_update_counts(gb_inode, handle, gb_bh, len,
+					       le16_to_cpu(gd->bg_chain));
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	ret = ocfs2_block_group_set_bits(handle, gb_inode, gd, gd_bh,
+					 goal_bit, len);
+	if (ret)
+		mlog_errno(ret);
+
+	/*
+	 * Here we should write the new page out first if we are
+	 * in write-back mode.
+	 */
+	ret = ocfs2_cow_sync_writeback(inode->i_sb, context->inode, cpos, len);
+	if (ret)
+		mlog_errno(ret);
+
+out_commit:
+	ocfs2_commit_trans(osb, handle);
+	brelse(gd_bh);
+
+out_unlock_tl_inode:
+	mutex_unlock(&tl_inode->i_mutex);
+
+	ocfs2_inode_unlock(gb_inode, 1);
+out_unlock_gb_mutex:
+	mutex_unlock(&gb_inode->i_mutex);
+	brelse(gb_bh);
+	iput(gb_inode);
+
+out:
+	if (context->meta_ac) {
+		ocfs2_free_alloc_context(context->meta_ac);
+		context->meta_ac = NULL;
+	}
+
+	if (ref_tree)
+		ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
+
+	return ret;
+}
-- 
1.5.5
