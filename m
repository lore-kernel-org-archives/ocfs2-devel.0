From: Tristan Ye <tristan.ye@oracle.com>
Date: Fri, 18 Mar 2011 14:35:34 +0800
Subject: [Ocfs2-devel] [PATCH 07/16] Ocfs2/move_extents: defrag a range of
	extent.
In-Reply-To: <1300430143-23909-1-git-send-email-tristan.ye@oracle.com>
References: <1300430143-23909-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1300430143-23909-8-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

It's a relatively complete function to accomplish defragmentation for entire
or partial extent, one journal handle was kept during the operation, it was
logically doing one more thing than ocfs2_move_extent() acutally, yes, it's
claiming the new clusters itself;-)

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/move_extents.c |  136 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 136 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index f05ca13..30ed5cb 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -216,3 +216,139 @@ out:
 
 	return ret;
 }
+
+/*
+ * Using one journal handle to guarantee the data consistency in case
+ * crash happens anywhere.
+ */
+static int ocfs2_defrag_extent(struct ocfs2_move_extents_context *context,
+			       u32 cpos, u32 phys_cpos, u32 len, int ext_flags)
+{
+	int ret, credits = 0, extra_blocks = 0;
+	handle_t *handle;
+	struct inode *inode = context->inode;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct inode *tl_inode = osb->osb_tl_inode;
+	struct ocfs2_refcount_tree *ref_tree = NULL;
+	u32 new_phys_cpos, new_len;
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
+
+	ret = ocfs2_lock_allocators_move_extents(inode, &context->et, len, 1,
+						 &context->meta_ac,
+						 &context->data_ac,
+						 extra_blocks, &credits);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	/*
+	 * should be using allocation reservation strategy there?
+	 *
+	 * if (context->data_ac)
+	 *	context->data_ac->ac_resv = &OCFS2_I(inode)->ip_la_data_resv;
+	 */
+
+	mutex_lock(&tl_inode->i_mutex);
+
+	if (ocfs2_truncate_log_needs_flush(osb)) {
+		ret = __ocfs2_flush_truncate_log(osb);
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto out_unlock_mutex;
+		}
+	}
+
+	handle = ocfs2_start_trans(osb, credits);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		mlog_errno(ret);
+		goto out_unlock_mutex;
+	}
+
+	ret = __ocfs2_claim_clusters(handle, context->data_ac, 1, len,
+				     &new_phys_cpos, &new_len);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	/*
+	 * we're not quite patient here to make multiple attempts for claiming
+	 * enough clusters, failure to claim clusters per-requested is not a
+	 * disaster though, it can only mean partial range of defragmentation
+	 * or extent movements gets gone, users anyway is able to have another
+	 * try as they wish anytime, since they're going to be returned a
+	 * '-ENOSPC' and completed length of this movement.
+	 */
+	if (new_len != len) {
+		mlog(0, "len_claimed: %u, len: %u\n", new_len, len);
+		context->range->me_flags &= ~OCFS2_MOVE_EXT_FL_COMPLETE;
+		ret = -ENOSPC;
+		goto out_commit;
+	}
+
+	mlog(0, "cpos: %u, phys_cpos: %u, new_phys_cpos: %u\n", cpos,
+	     phys_cpos, new_phys_cpos);
+
+	ret = __ocfs2_move_extent(handle, context, cpos, len, phys_cpos,
+				  new_phys_cpos, ext_flags);
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
+
+out_unlock_mutex:
+	mutex_unlock(&tl_inode->i_mutex);
+
+	if (context->data_ac) {
+		ocfs2_free_alloc_context(context->data_ac);
+		context->data_ac = NULL;
+	}
+
+	if (context->meta_ac) {
+		ocfs2_free_alloc_context(context->meta_ac);
+		context->meta_ac = NULL;
+	}
+
+out:
+	if (ref_tree)
+		ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
+
+	return ret;
+}
-- 
1.5.5
