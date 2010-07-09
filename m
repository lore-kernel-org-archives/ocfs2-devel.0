From: Tao Ma <tao.ma@oracle.com>
Date: Fri,  9 Jul 2010 14:53:11 +0800
Subject: [Ocfs2-devel] [PATCH 1/2 v2] ocfs2: make xattr extension work with
	new local alloc reservation.
Message-ID: <1278658392-22009-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The old ocfs2_xattr_extent_allocation is too optimistic about
the clusters we can get. So actually if the file system is
too fragmented, ocfs2_add_clusters_in_btree will return us
with EGAIN and we need to allocate clusters once again.

So this patch change it to a while loop so that we can allocate
clusters until we reach clusters_to_add.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |   78 ++++++++++++++++++++++++++++++++---------------------
 1 files changed, 47 insertions(+), 31 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index e97b348..2be1908 100644
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
@@ -719,38 +719,54 @@ static int ocfs2_xattr_extend_allocation(struct inode *inode,
 
 	ocfs2_init_xattr_value_extent_tree(&et, INODE_CACHE(inode), vb);
 
-	status = vb->vb_access(handle, INODE_CACHE(inode), vb->vb_bh,
-			      OCFS2_JOURNAL_ACCESS_WRITE);
-	if (status < 0) {
-		mlog_errno(status);
-		goto leave;
-	}
+	while (clusters_to_add) {
+		status = vb->vb_access(handle, INODE_CACHE(inode), vb->vb_bh,
+				       OCFS2_JOURNAL_ACCESS_WRITE);
+		if (status < 0) {
+			mlog_errno(status);
+			break;
+		}
 
-	prev_clusters = le32_to_cpu(vb->vb_xv->xr_clusters);
-	status = ocfs2_add_clusters_in_btree(handle,
-					     &et,
-					     &logical_start,
-					     clusters_to_add,
-					     0,
-					     ctxt->data_ac,
-					     ctxt->meta_ac,
-					     &why);
-	if (status < 0) {
-		mlog_errno(status);
-		goto leave;
-	}
+		prev_clusters = le32_to_cpu(vb->vb_xv->xr_clusters);
+		status = ocfs2_add_clusters_in_btree(handle,
+						     &et,
+						     &logical_start,
+						     clusters_to_add,
+						     0,
+						     ctxt->data_ac,
+						     ctxt->meta_ac,
+						     &why);
+		if ((status < 0) && (status != -EAGAIN)) {
+			if (status != -ENOSPC)
+				mlog_errno(status);
+			break;
+		}
 
-	ocfs2_journal_dirty(handle, vb->vb_bh);
+		ocfs2_journal_dirty(handle, vb->vb_bh);
 
-	clusters_to_add -= le32_to_cpu(vb->vb_xv->xr_clusters) - prev_clusters;
+		clusters_to_add -= le32_to_cpu(vb->vb_xv->xr_clusters) -
+					 prev_clusters;
 
-	/*
-	 * We should have already allocated enough space before the transaction,
-	 * so no need to restart.
-	 */
-	BUG_ON(why != RESTART_NONE || clusters_to_add);
-
-leave:
+		if (why != RESTART_NONE && clusters_to_add) {
+			/*
+			 * We can only fail in case the alloc file doesn't give
+			 * up enough clusters.
+			 */
+			BUG_ON(why == RESTART_META);
+
+			mlog(0, "restarting xattr value extension for %u"
+			     " clusters,.\n", clusters_to_add);
+			credits = ocfs2_calc_extend_credits(inode->i_sb,
+							    &vb->vb_xv->xr_list,
+							    clusters_to_add);
+			status = ocfs2_extend_trans(handle, credits);
+			if (status < 0) {
+				status = -ENOMEM;
+				mlog_errno(status);
+				break;
+			}
+		}
+	}
 
 	return status;
 }
-- 
1.7.1.GIT
