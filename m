From: Joel Becker <joel.becker@oracle.com>
Date: Tue,  9 Dec 2008 17:09:47 -0800
Subject: [Ocfs2-devel] [PATCH 10/18] ocfs2: Create ocfs2_xattr_value_buf.
In-Reply-To: <1228871395-10273-1-git-send-email-joel.becker@oracle.com>
References: <1228871395-10273-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1228871395-10273-11-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When an ocfs2 extended attribute is large enough to require its own
allocation tree, we root it with an ocfs2_xattr_value_root.  However,
these roots can be a part of inodes, xattr blocks, or xattr buckets.
Thus, they need a different journal access function for each container.

We wrap the bh, its journal access function, and the value root (xv) in
a structure called ocfs2_xattr_valu_buf.  This is a package that can
be passed around.  In this first pass, we simply pass it to the
extent tree code.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c |   25 +++++++++++--------------
 fs/ocfs2/alloc.h |    4 ++--
 fs/ocfs2/xattr.c |   34 ++++++++++++++++++++++------------
 fs/ocfs2/xattr.h |   14 ++++++++++++++
 4 files changed, 49 insertions(+), 28 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 3c8d866..f5087c7 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -48,6 +48,7 @@
 #include "file.h"
 #include "super.h"
 #include "uptodate.h"
+#include "xattr.h"
 
 #include "buffer_head_io.h"
 
@@ -207,36 +208,33 @@ static void ocfs2_dinode_fill_root_el(struct ocfs2_extent_tree *et)
 
 static void ocfs2_xattr_value_fill_root_el(struct ocfs2_extent_tree *et)
 {
-	struct ocfs2_xattr_value_root *xv = et->et_object;
+	struct ocfs2_xattr_value_buf *vb = et->et_object;
 
-	et->et_root_el = &xv->xr_list;
+	et->et_root_el = &vb->vb_xv->xr_list;
 }
 
 static void ocfs2_xattr_value_set_last_eb_blk(struct ocfs2_extent_tree *et,
 					      u64 blkno)
 {
-	struct ocfs2_xattr_value_root *xv =
-		(struct ocfs2_xattr_value_root *)et->et_object;
+	struct ocfs2_xattr_value_buf *vb = et->et_object;
 
-	xv->xr_last_eb_blk = cpu_to_le64(blkno);
+	vb->vb_xv->xr_last_eb_blk = cpu_to_le64(blkno);
 }
 
 static u64 ocfs2_xattr_value_get_last_eb_blk(struct ocfs2_extent_tree *et)
 {
-	struct ocfs2_xattr_value_root *xv =
-		(struct ocfs2_xattr_value_root *) et->et_object;
+	struct ocfs2_xattr_value_buf *vb = et->et_object;
 
-	return le64_to_cpu(xv->xr_last_eb_blk);
+	return le64_to_cpu(vb->vb_xv->xr_last_eb_blk);
 }
 
 static void ocfs2_xattr_value_update_clusters(struct inode *inode,
 					      struct ocfs2_extent_tree *et,
 					      u32 clusters)
 {
-	struct ocfs2_xattr_value_root *xv =
-		(struct ocfs2_xattr_value_root *)et->et_object;
+	struct ocfs2_xattr_value_buf *vb = et->et_object;
 
-	le32_add_cpu(&xv->xr_clusters, clusters);
+	le32_add_cpu(&vb->vb_xv->xr_clusters, clusters);
 }
 
 static struct ocfs2_extent_tree_operations ocfs2_xattr_value_et_ops = {
@@ -334,10 +332,9 @@ void ocfs2_init_xattr_tree_extent_tree(struct ocfs2_extent_tree *et,
 
 void ocfs2_init_xattr_value_extent_tree(struct ocfs2_extent_tree *et,
 					struct inode *inode,
-					struct buffer_head *bh,
-					struct ocfs2_xattr_value_root *xv)
+					struct ocfs2_xattr_value_buf *vb)
 {
-	__ocfs2_init_extent_tree(et, inode, bh, ocfs2_journal_access, xv,
+	__ocfs2_init_extent_tree(et, inode, vb->vb_bh, vb->vb_access, vb,
 				 &ocfs2_xattr_value_et_ops);
 }
 
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index 4b6fea2..cceff5c 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -71,10 +71,10 @@ void ocfs2_init_dinode_extent_tree(struct ocfs2_extent_tree *et,
 void ocfs2_init_xattr_tree_extent_tree(struct ocfs2_extent_tree *et,
 				       struct inode *inode,
 				       struct buffer_head *bh);
+struct ocfs2_xattr_value_buf;
 void ocfs2_init_xattr_value_extent_tree(struct ocfs2_extent_tree *et,
 					struct inode *inode,
-					struct buffer_head *bh,
-					struct ocfs2_xattr_value_root *xv);
+					struct ocfs2_xattr_value_buf *vb);
 
 /*
  * Read an extent block into *bh.  If *bh is NULL, a bh will be
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 1540e4d..df35b7d 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -581,21 +581,26 @@ static int ocfs2_xattr_extend_allocation(struct inode *inode,
 	handle_t *handle = ctxt->handle;
 	enum ocfs2_alloc_restarted why;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	u32 prev_clusters, logical_start = le32_to_cpu(xv->xr_clusters);
+	struct ocfs2_xattr_value_buf vb = {
+		.vb_bh	= xattr_bh,
+		.vb_xv = xv,
+		.vb_access = ocfs2_journal_access,
+	};
+	u32 prev_clusters, logical_start = le32_to_cpu(vb.vb_xv->xr_clusters);
 	struct ocfs2_extent_tree et;
 
 	mlog(0, "(clusters_to_add for xattr= %u)\n", clusters_to_add);
 
-	ocfs2_init_xattr_value_extent_tree(&et, inode, xattr_bh, xv);
+	ocfs2_init_xattr_value_extent_tree(&et, inode, &vb);
 
-	status = ocfs2_journal_access(handle, inode, xattr_bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
+	status = vb.vb_access(handle, inode, vb.vb_bh,
+			      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
 	}
 
-	prev_clusters = le32_to_cpu(xv->xr_clusters);
+	prev_clusters = le32_to_cpu(vb.vb_xv->xr_clusters);
 	status = ocfs2_add_clusters_in_btree(osb,
 					     inode,
 					     &logical_start,
@@ -611,13 +616,13 @@ static int ocfs2_xattr_extend_allocation(struct inode *inode,
 		goto leave;
 	}
 
-	status = ocfs2_journal_dirty(handle, xattr_bh);
+	status = ocfs2_journal_dirty(handle, vb.vb_bh);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
 	}
 
-	clusters_to_add -= le32_to_cpu(xv->xr_clusters) - prev_clusters;
+	clusters_to_add -= le32_to_cpu(vb.vb_xv->xr_clusters) - prev_clusters;
 
 	/*
 	 * We should have already allocated enough space before the transaction,
@@ -640,11 +645,16 @@ static int __ocfs2_remove_xattr_range(struct inode *inode,
 	u64 phys_blkno = ocfs2_clusters_to_blocks(inode->i_sb, phys_cpos);
 	handle_t *handle = ctxt->handle;
 	struct ocfs2_extent_tree et;
+	struct ocfs2_xattr_value_buf vb = {
+		.vb_bh = root_bh,
+		.vb_xv = xv,
+		.vb_access = ocfs2_journal_access,
+	};
 
-	ocfs2_init_xattr_value_extent_tree(&et, inode, root_bh, xv);
+	ocfs2_init_xattr_value_extent_tree(&et, inode, &vb);
 
-	ret = ocfs2_journal_access(handle, inode, root_bh,
-				   OCFS2_JOURNAL_ACCESS_WRITE);
+	ret = vb.vb_access(handle, inode, vb.vb_bh,
+			   OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -657,9 +667,9 @@ static int __ocfs2_remove_xattr_range(struct inode *inode,
 		goto out;
 	}
 
-	le32_add_cpu(&xv->xr_clusters, -len);
+	le32_add_cpu(&vb.vb_xv->xr_clusters, -len);
 
-	ret = ocfs2_journal_dirty(handle, root_bh);
+	ret = ocfs2_journal_dirty(handle, vb.vb_bh);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
index 9a67e7d..5a1ebc7 100644
--- a/fs/ocfs2/xattr.h
+++ b/fs/ocfs2/xattr.h
@@ -70,4 +70,18 @@ int ocfs2_calc_xattr_init(struct inode *, struct buffer_head *,
 			  int, struct ocfs2_security_xattr_info *,
 			  int *, int *, struct ocfs2_alloc_context **);
 
+/*
+ * xattrs can live inside an inode, as part of an external xattr block,
+ * or inside an xattr bucket, which is the leaf of a tree rooted in an
+ * xattr block.  Some of the xattr calls, especially the value setting
+ * functions, want to treat each of these locations as equal.  Let's wrap
+ * them in a structure that we can pass around instead of raw buffer_heads.
+ */
+struct ocfs2_xattr_value_buf {
+	struct buffer_head		*vb_bh;
+	ocfs2_journal_access_func	vb_access;
+	struct ocfs2_xattr_value_root	*vb_xv;
+};
+
+
 #endif /* OCFS2_XATTR_H */
-- 
1.5.6.5
