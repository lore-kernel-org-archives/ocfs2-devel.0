From: Tristan Ye <tristan.ye@oracle.com>
Date: Tue, 28 Dec 2010 19:40:47 +0800
Subject: [Ocfs2-devel] [PATCH 7/8] Ocfs2: move entire/partial extent.
In-Reply-To: <1293536448-20516-1-git-send-email-tristan.ye@oracle.com>
References: <1293536448-20516-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1293536448-20516-8-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The only difference between ocfs2_move_extent() and ocfs2_defrag_extent() is
that former one didn't claim new clusters itself;)

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/move_extents.c |   50 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 6d2d130..02d4d01 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -396,6 +396,56 @@ out:
 	return ret;
 }
 
+static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
+			     u32 cpos, u32 phys_cpos, u32 new_phys_cpos,
+			     u32 len, int flags)
+{
+	int ret, credits = 0;
+	handle_t *handle;
+	struct inode *inode = context->inode;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct inode *tl_inode = osb->osb_tl_inode;
+
+	ret = ocfs2_lock_allocators_move_extents(inode, &context->et, len, 1,
+						 &context->meta_ac,
+						 NULL, 0, &credits);
+	if (ret) {
+		mlog_errno(ret);
+		return ret;
+	}
+
+	mutex_lock(&tl_inode->i_mutex);
+
+	handle = ocfs2_start_trans(osb, credits);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = __ocfs2_move_extent(handle, context, cpos, len, phys_cpos,
+				  new_phys_cpos);
+	if (ret)
+		mlog_errno(ret);
+
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
