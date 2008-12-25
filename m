From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 25 Dec 2008 10:04:27 -0800
Subject: [Ocfs2-devel] [PATCH 12/35] ocfs2: Pull ocfs2_xattr_value_buf up
	into ocfs2_xattr_value_truncate().
In-Reply-To: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
References: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
Message-ID: <1230228290-22803-13-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Joel Becker <joel.becker@oracle.com>

Place an ocfs2_xattr_value_buf in ocfs2_xattr_value_truncate() and pass
it down to ocfs2_xattr_shrink_size().  We can also pass it into
ocfs2_xattr_extend_allocation(), replacing its ocfs2_xattr_value_buf.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/xattr.c |   41 +++++++++++++++++------------------------
 1 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 3b059cf..4ce8019 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -573,34 +573,28 @@ int ocfs2_calc_xattr_init(struct inode *dir,
 
 static int ocfs2_xattr_extend_allocation(struct inode *inode,
 					 u32 clusters_to_add,
-					 struct buffer_head *xattr_bh,
-					 struct ocfs2_xattr_value_root *xv,
+					 struct ocfs2_xattr_value_buf *vb,
 					 struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	int status = 0;
 	handle_t *handle = ctxt->handle;
 	enum ocfs2_alloc_restarted why;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	struct ocfs2_xattr_value_buf vb = {
-		.vb_bh	= xattr_bh,
-		.vb_xv = xv,
-		.vb_access = ocfs2_journal_access,
-	};
-	u32 prev_clusters, logical_start = le32_to_cpu(vb.vb_xv->xr_clusters);
+	u32 prev_clusters, logical_start = le32_to_cpu(vb->vb_xv->xr_clusters);
 	struct ocfs2_extent_tree et;
 
 	mlog(0, "(clusters_to_add for xattr= %u)\n", clusters_to_add);
 
-	ocfs2_init_xattr_value_extent_tree(&et, inode, &vb);
+	ocfs2_init_xattr_value_extent_tree(&et, inode, vb);
 
-	status = vb.vb_access(handle, inode, vb.vb_bh,
+	status = vb->vb_access(handle, inode, vb->vb_bh,
 			      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
 	}
 
-	prev_clusters = le32_to_cpu(vb.vb_xv->xr_clusters);
+	prev_clusters = le32_to_cpu(vb->vb_xv->xr_clusters);
 	status = ocfs2_add_clusters_in_btree(osb,
 					     inode,
 					     &logical_start,
@@ -616,13 +610,13 @@ static int ocfs2_xattr_extend_allocation(struct inode *inode,
 		goto leave;
 	}
 
-	status = ocfs2_journal_dirty(handle, vb.vb_bh);
+	status = ocfs2_journal_dirty(handle, vb->vb_bh);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
 	}
 
-	clusters_to_add -= le32_to_cpu(vb.vb_xv->xr_clusters) - prev_clusters;
+	clusters_to_add -= le32_to_cpu(vb->vb_xv->xr_clusters) - prev_clusters;
 
 	/*
 	 * We should have already allocated enough space before the transaction,
@@ -680,18 +674,12 @@ out:
 static int ocfs2_xattr_shrink_size(struct inode *inode,
 				   u32 old_clusters,
 				   u32 new_clusters,
-				   struct buffer_head *root_bh,
-				   struct ocfs2_xattr_value_root *xv,
+				   struct ocfs2_xattr_value_buf *vb,
 				   struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	int ret = 0;
 	u32 trunc_len, cpos, phys_cpos, alloc_size;
 	u64 block;
-	struct ocfs2_xattr_value_buf vb = {
-		.vb_bh = root_bh,
-		.vb_xv = xv,
-		.vb_access = ocfs2_journal_access,
-	};
 
 	if (old_clusters <= new_clusters)
 		return 0;
@@ -701,7 +689,7 @@ static int ocfs2_xattr_shrink_size(struct inode *inode,
 	while (trunc_len) {
 		ret = ocfs2_xattr_get_clusters(inode, cpos, &phys_cpos,
 					       &alloc_size,
-					       &vb.vb_xv->xr_list);
+					       &vb->vb_xv->xr_list);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -710,7 +698,7 @@ static int ocfs2_xattr_shrink_size(struct inode *inode,
 		if (alloc_size > trunc_len)
 			alloc_size = trunc_len;
 
-		ret = __ocfs2_remove_xattr_range(inode, &vb, cpos,
+		ret = __ocfs2_remove_xattr_range(inode, vb, cpos,
 						 phys_cpos, alloc_size,
 						 ctxt);
 		if (ret) {
@@ -738,6 +726,11 @@ static int ocfs2_xattr_value_truncate(struct inode *inode,
 	int ret;
 	u32 new_clusters = ocfs2_clusters_for_bytes(inode->i_sb, len);
 	u32 old_clusters = le32_to_cpu(xv->xr_clusters);
+	struct ocfs2_xattr_value_buf vb = {
+		.vb_bh = root_bh,
+		.vb_xv = xv,
+		.vb_access = ocfs2_journal_access,
+	};
 
 	if (new_clusters == old_clusters)
 		return 0;
@@ -745,11 +738,11 @@ static int ocfs2_xattr_value_truncate(struct inode *inode,
 	if (new_clusters > old_clusters)
 		ret = ocfs2_xattr_extend_allocation(inode,
 						    new_clusters - old_clusters,
-						    root_bh, xv, ctxt);
+						    &vb, ctxt);
 	else
 		ret = ocfs2_xattr_shrink_size(inode,
 					      old_clusters, new_clusters,
-					      root_bh, xv, ctxt);
+					      &vb, ctxt);
 
 	return ret;
 }
-- 
1.5.6
