From: Tristan Ye <tristan.ye@oracle.com>
Date: Tue, 28 Dec 2010 19:40:46 +0800
Subject: [Ocfs2-devel] [PATCH 6/8] Ocfs2: defrag a range of extent.
In-Reply-To: <1293536448-20516-1-git-send-email-tristan.ye@oracle.com>
References: <1293536448-20516-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1293536448-20516-7-git-send-email-tristan.ye@oracle.com>
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
 fs/ocfs2/move_extents.c |   97 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 97 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index e32dd40..6d2d130 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -299,6 +299,103 @@ out:
 	return ret;
 }
 
+/*
+ * Using one journal handle to guarantee the data consistency in case
+ * crash happens anywhere.
+ */
+static int ocfs2_defrag_extent(struct ocfs2_move_extents_context *context,
+			       u32 cpos, u32 phys_cpos, u32 len, int flags)
+{
+	int ret, credits = 0;
+	handle_t *handle;
+	struct inode *inode = context->inode;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct inode *tl_inode = osb->osb_tl_inode;
+	u32 new_phys_cpos, new_len;
+
+	ret = ocfs2_lock_allocators_move_extents(inode, &context->et, len, 1,
+						 &context->meta_ac,
+						 &context->data_ac,
+						 0, &credits);
+	if (ret) {
+		mlog_errno(ret);
+		return ret;
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
+			goto out;
+		}
+	}
+
+	handle = ocfs2_start_trans(osb, credits);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		mlog_errno(ret);
+		goto out;
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
+	 * or extent movements get gone, users anyway is able to have another
+	 * try as they wish anytime, since they're going to be returned a
+	 * '-ENOSPC' and completed length of this movement.
+	 *
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
+				  new_phys_cpos);
+	if (ret)
+		mlog_errno(ret);
+
+out_commit:
+	ocfs2_commit_trans(osb, handle);
+
+out:
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
+	return ret;
+}
+
 static int ocfs2_move_extents(struct ocfs2_move_extents_context *context)
 {
 	int status;
-- 
1.5.5
