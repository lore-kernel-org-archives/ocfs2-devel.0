From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 18 Jun 2010 11:02:50 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: make xattr extension work with new
	local alloc reservation.
In-Reply-To: <4C1AE141.60707@oracle.com>
References: <4C1AE141.60707@oracle.com>
Message-ID: <1276830171-5908-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

New local alloc reservation can give us less clusters than
what we want and ask us to restart the transaction, so let
ocfs2_xattr_extend_allocation restart the transaction in
this case.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |   33 +++++++++++++++++++++++++--------
 1 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index e97b348..894734b 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -709,7 +709,7 @@ static int ocfs2_xattr_extend_allocation(struct inode *inode,
 					 struct ocfs2_xattr_value_buf *vb,
 					 struct ocfs2_xattr_set_ctxt *ctxt)
 {
-	int status = 0;
+	int status = 0, credits;
 	handle_t *handle = ctxt->handle;
 	enum ocfs2_alloc_restarted why;
 	u32 prev_clusters, logical_start = le32_to_cpu(vb->vb_xv->xr_clusters);
@@ -719,6 +719,7 @@ static int ocfs2_xattr_extend_allocation(struct inode *inode,
 
 	ocfs2_init_xattr_value_extent_tree(&et, INODE_CACHE(inode), vb);
 
+restarted_transaction:
 	status = vb->vb_access(handle, INODE_CACHE(inode), vb->vb_bh,
 			      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
@@ -735,8 +736,9 @@ static int ocfs2_xattr_extend_allocation(struct inode *inode,
 					     ctxt->data_ac,
 					     ctxt->meta_ac,
 					     &why);
-	if (status < 0) {
-		mlog_errno(status);
+	if ((status < 0) && (status != -EAGAIN)) {
+		if (status != -ENOSPC)
+			mlog_errno(status);
 		goto leave;
 	}
 
@@ -744,11 +746,26 @@ static int ocfs2_xattr_extend_allocation(struct inode *inode,
 
 	clusters_to_add -= le32_to_cpu(vb->vb_xv->xr_clusters) - prev_clusters;
 
-	/*
-	 * We should have already allocated enough space before the transaction,
-	 * so no need to restart.
-	 */
-	BUG_ON(why != RESTART_NONE || clusters_to_add);
+	if (why != RESTART_NONE && clusters_to_add) {
+		/*
+		 * We can only fail in case the alloc file doesn't give up
+		 * enough clusters.
+		 */
+		BUG_ON(why == RESTART_META);
+
+		mlog(0, "restarting xattr value extension for %u clusters,.\n",
+		     clusters_to_add);
+		credits = ocfs2_calc_extend_credits(inode->i_sb,
+						    &vb->vb_xv->xr_list,
+						    clusters_to_add);
+		status = ocfs2_extend_trans(handle, credits);
+		if (status < 0) {
+			status = -ENOMEM;
+			mlog_errno(status);
+			goto leave;
+		}
+		goto restarted_transaction;
+	}
 
 leave:
 
-- 
1.5.5
