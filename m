From: Joel Becker <joel.becker@oracle.com>
Date: Tue,  9 Dec 2008 17:09:48 -0800
Subject: [Ocfs2-devel] [PATCH 11/18] ocfs2: Pull ocfs2_xattr_value_buf up
	from __ocfs2_remove_xattr_range().
In-Reply-To: <1228871395-10273-1-git-send-email-joel.becker@oracle.com>
References: <1228871395-10273-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1228871395-10273-12-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Place an ocfs2_xattr_value_buf in __ocfs2_xattr_shrink_size() and pass
it down to __ocfs2_remove_xattr_range().

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index df35b7d..42e062c 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -636,8 +636,7 @@ leave:
 }
 
 static int __ocfs2_remove_xattr_range(struct inode *inode,
-				      struct buffer_head *root_bh,
-				      struct ocfs2_xattr_value_root *xv,
+				      struct ocfs2_xattr_value_buf *vb,
 				      u32 cpos, u32 phys_cpos, u32 len,
 				      struct ocfs2_xattr_set_ctxt *ctxt)
 {
@@ -645,16 +644,11 @@ static int __ocfs2_remove_xattr_range(struct inode *inode,
 	u64 phys_blkno = ocfs2_clusters_to_blocks(inode->i_sb, phys_cpos);
 	handle_t *handle = ctxt->handle;
 	struct ocfs2_extent_tree et;
-	struct ocfs2_xattr_value_buf vb = {
-		.vb_bh = root_bh,
-		.vb_xv = xv,
-		.vb_access = ocfs2_journal_access,
-	};
 
-	ocfs2_init_xattr_value_extent_tree(&et, inode, &vb);
+	ocfs2_init_xattr_value_extent_tree(&et, inode, vb);
 
-	ret = vb.vb_access(handle, inode, vb.vb_bh,
-			   OCFS2_JOURNAL_ACCESS_WRITE);
+	ret = vb->vb_access(handle, inode, vb->vb_bh,
+			    OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -667,9 +661,9 @@ static int __ocfs2_remove_xattr_range(struct inode *inode,
 		goto out;
 	}
 
-	le32_add_cpu(&vb.vb_xv->xr_clusters, -len);
+	le32_add_cpu(&vb->vb_xv->xr_clusters, -len);
 
-	ret = ocfs2_journal_dirty(handle, vb.vb_bh);
+	ret = ocfs2_journal_dirty(handle, vb->vb_bh);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -693,6 +687,11 @@ static int ocfs2_xattr_shrink_size(struct inode *inode,
 	int ret = 0;
 	u32 trunc_len, cpos, phys_cpos, alloc_size;
 	u64 block;
+	struct ocfs2_xattr_value_buf vb = {
+		.vb_bh = root_bh,
+		.vb_xv = xv,
+		.vb_access = ocfs2_journal_access,
+	};
 
 	if (old_clusters <= new_clusters)
 		return 0;
@@ -701,7 +700,8 @@ static int ocfs2_xattr_shrink_size(struct inode *inode,
 	trunc_len = old_clusters - new_clusters;
 	while (trunc_len) {
 		ret = ocfs2_xattr_get_clusters(inode, cpos, &phys_cpos,
-					       &alloc_size, &xv->xr_list);
+					       &alloc_size,
+					       &vb.vb_xv->xr_list);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -710,7 +710,7 @@ static int ocfs2_xattr_shrink_size(struct inode *inode,
 		if (alloc_size > trunc_len)
 			alloc_size = trunc_len;
 
-		ret = __ocfs2_remove_xattr_range(inode, root_bh, xv, cpos,
+		ret = __ocfs2_remove_xattr_range(inode, &vb, cpos,
 						 phys_cpos, alloc_size,
 						 ctxt);
 		if (ret) {
-- 
1.5.6.5
