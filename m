From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 27 Jun 2008 15:02:04 +0800
Subject: [Ocfs2-devel] [PATCH 10/15] Add xattr tree operations in
	ocfs2_extent_tree.v2
In-Reply-To: <48648B3E.6050808@oracle.com>
Message-ID: <20080627070204.GA20364@tma-pc2.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_xattr_block will use ocfs2_extent_list to store large numbers of
EAs. So add a new type in ocfs2_extent_tree_type and add one new
ocfs_extent_tree implementation so that it can use b-tree code to handle
the storage of many EAs.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c |   53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/alloc.h |    1 +
 2 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 2df5a7f..d93b7da 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -177,6 +177,48 @@ static struct ocfs2_extent_tree_operations ocfs2_xattr_et_ops = {
 	.sanity_check		= ocfs2_xattr_value_sanity_check,
 };
 
+static void ocfs2_xattr_tree_set_last_eb_blk(struct ocfs2_extent_tree *et,
+					     u64 blkno)
+{
+	struct ocfs2_xattr_block *xb =
+		(struct ocfs2_xattr_block *) et->root_bh->b_data;
+	struct ocfs2_xattr_tree_root *xt = &xb->xb_attrs.xb_root;
+
+	xt->xt_last_eb_blk = cpu_to_le64(blkno);
+}
+
+static u64 ocfs2_xattr_tree_get_last_eb_blk(struct ocfs2_extent_tree *et)
+{
+	struct ocfs2_xattr_block *xb =
+		(struct ocfs2_xattr_block *) et->root_bh->b_data;
+	struct ocfs2_xattr_tree_root *xt = &xb->xb_attrs.xb_root;
+
+	return le64_to_cpu(xt->xt_last_eb_blk);
+}
+
+static void ocfs2_xattr_tree_update_clusters(struct inode *inode,
+					     struct ocfs2_extent_tree *et,
+					     u32 clusters)
+{
+	struct ocfs2_xattr_block *xb =
+			(struct ocfs2_xattr_block *)et->root_bh->b_data;
+
+	le32_add_cpu(&xb->xb_attrs.xb_root.xt_clusters, clusters);
+}
+
+static int ocfs2_xattr_tree_sanity_check(struct inode *inode,
+					 struct ocfs2_extent_tree *et)
+{
+	return 0;
+}
+
+static struct ocfs2_extent_tree_operations ocfs2_xattr_tree_et_ops = {
+	.set_last_eb_blk	= ocfs2_xattr_tree_set_last_eb_blk,
+	.get_last_eb_blk	= ocfs2_xattr_tree_get_last_eb_blk,
+	.update_clusters	= ocfs2_xattr_tree_update_clusters,
+	.sanity_check		= ocfs2_xattr_tree_sanity_check,
+};
+
 static struct ocfs2_extent_tree*
 	 ocfs2_new_extent_tree(struct buffer_head *bh,
 			       enum ocfs2_extent_tree_type et_type,
@@ -201,6 +243,11 @@ static struct ocfs2_extent_tree*
 			(struct ocfs2_xattr_value_root *) private;
 		et->root_el = &xv->xr_list;
 		et->eops = &ocfs2_xattr_et_ops;
+	} else if (et_type == OCFS2_XATTR_TREE_EXTENT) {
+		struct ocfs2_xattr_block *xb =
+			(struct ocfs2_xattr_block *)bh->b_data;
+		et->root_el = &xb->xb_attrs.xb_root.xt_list;
+		et->eops = &ocfs2_xattr_tree_et_ops;
 	}
 
 	return et;
@@ -570,6 +617,12 @@ int ocfs2_num_free_extents(struct ocfs2_super *osb,
 
 		last_eb_blk = le64_to_cpu(xv->xr_last_eb_blk);
 		el = &xv->xr_list;
+	} else if (type == OCFS2_XATTR_TREE_EXTENT) {
+		struct ocfs2_xattr_block *xb =
+			(struct ocfs2_xattr_block *)root_bh->b_data;
+
+		last_eb_blk = le64_to_cpu(xb->xb_attrs.xb_root.xt_last_eb_blk);
+		el = &xb->xb_attrs.xb_root.xt_list;
 	}
 
 	if (last_eb_blk) {
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index b50ace5..7587f0e 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -29,6 +29,7 @@
 enum ocfs2_extent_tree_type {
 	OCFS2_DINODE_EXTENT = 0,
 	OCFS2_XATTR_VALUE_EXTENT,
+	OCFS2_XATTR_TREE_EXTENT,
 };
 
 struct ocfs2_alloc_context;
-- 
1.5.4.GIT
