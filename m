From: Joel Becker <joel.becker@oracle.com>
Date: Wed, 20 Aug 2008 19:48:20 -0700
Subject: [Ocfs2-devel] [PATCH 05/10] ocfs2: Provide the get_root_el() method
	to ocfs2_extent_tree_operations.
In-Reply-To: <1219286905-28104-1-git-send-email-joel.becker@oracle.com>
References: <1219286905-28104-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1219286905-28104-6-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The root_el of an ocfs2_extent_tree needs to be calculated from
et->et_object.  Make it an operation on et->et_ops.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c |   38 ++++++++++++++++++++++++++++++--------
 1 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 93f44f4..fb6ae67 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -72,6 +72,10 @@ struct ocfs2_extent_tree_operations {
 				   struct ocfs2_extent_tree *et,
 				   u32 new_clusters);
 	int (*eo_sanity_check)(struct inode *inode, struct ocfs2_extent_tree *et);
+
+	/* These are internal to ocfs2_extent_tree and don't have
+	 * accessor functions */
+	void (*eo_fill_root_el)(struct ocfs2_extent_tree *et);
 };
 
 struct ocfs2_extent_tree {
@@ -83,6 +87,13 @@ struct ocfs2_extent_tree {
 	unsigned int				et_max_leaf_clusters;
 };
 
+static void ocfs2_dinode_fill_root_el(struct ocfs2_extent_tree *et)
+{
+	struct ocfs2_dinode *di = et->et_object;
+
+	et->et_root_el = &di->id2.i_list;
+}
+
 static void ocfs2_dinode_set_last_eb_blk(struct ocfs2_extent_tree *et,
 					 u64 blkno)
 {
@@ -136,8 +147,16 @@ static struct ocfs2_extent_tree_operations ocfs2_dinode_et_ops = {
 	.eo_get_last_eb_blk	= ocfs2_dinode_get_last_eb_blk,
 	.eo_update_clusters	= ocfs2_dinode_update_clusters,
 	.eo_sanity_check	= ocfs2_dinode_sanity_check,
+	.eo_fill_root_el	= ocfs2_dinode_fill_root_el,
 };
 
+static void ocfs2_xattr_value_fill_root_el(struct ocfs2_extent_tree *et)
+{
+	struct ocfs2_xattr_value_root *xv = et->et_object;
+
+	et->et_root_el = &xv->xr_list;
+}
+
 static void ocfs2_xattr_value_set_last_eb_blk(struct ocfs2_extent_tree *et,
 					      u64 blkno)
 {
@@ -176,8 +195,16 @@ static struct ocfs2_extent_tree_operations ocfs2_xattr_et_ops = {
 	.eo_get_last_eb_blk	= ocfs2_xattr_value_get_last_eb_blk,
 	.eo_update_clusters	= ocfs2_xattr_value_update_clusters,
 	.eo_sanity_check	= ocfs2_xattr_value_sanity_check,
+	.eo_fill_root_el	= ocfs2_xattr_value_fill_root_el,
 };
 
+static void ocfs2_xattr_tree_fill_root_el(struct ocfs2_extent_tree *et)
+{
+	struct ocfs2_xattr_block *xb = et->et_object;
+
+	et->et_root_el = &xb->xb_attrs.xb_root.xt_list;
+}
+
 static void ocfs2_xattr_tree_set_last_eb_blk(struct ocfs2_extent_tree *et,
 					     u64 blkno)
 {
@@ -215,6 +242,7 @@ static struct ocfs2_extent_tree_operations ocfs2_xattr_tree_et_ops = {
 	.eo_get_last_eb_blk	= ocfs2_xattr_tree_get_last_eb_blk,
 	.eo_update_clusters	= ocfs2_xattr_tree_update_clusters,
 	.eo_sanity_check	= ocfs2_xattr_tree_sanity_check,
+	.eo_fill_root_el	= ocfs2_xattr_tree_fill_root_el,
 };
 
 static void ocfs2_get_extent_tree(struct ocfs2_extent_tree *et,
@@ -232,22 +260,16 @@ static void ocfs2_get_extent_tree(struct ocfs2_extent_tree *et,
 	et->et_object = obj;
 
 	if (et_type == OCFS2_DINODE_EXTENT) {
-		et->et_root_el =
-			&((struct ocfs2_dinode *)obj)->id2.i_list;
 		et->et_ops = &ocfs2_dinode_et_ops;
 	} else if (et_type == OCFS2_XATTR_VALUE_EXTENT) {
-		struct ocfs2_xattr_value_root *xv =
-			(struct ocfs2_xattr_value_root *)obj;
-		et->et_root_el = &xv->xr_list;
 		et->et_ops = &ocfs2_xattr_et_ops;
 	} else if (et_type == OCFS2_XATTR_TREE_EXTENT) {
-		struct ocfs2_xattr_block *xb =
-			(struct ocfs2_xattr_block *)obj;
-		et->et_root_el = &xb->xb_attrs.xb_root.xt_list;
 		et->et_ops = &ocfs2_xattr_tree_et_ops;
 		et->et_max_leaf_clusters = ocfs2_clusters_for_bytes(inode->i_sb,
 						OCFS2_MAX_XATTR_TREE_LEAF_SIZE);
 	}
+
+	et->et_ops->eo_fill_root_el(et);
 }
 
 static void ocfs2_put_extent_tree(struct ocfs2_extent_tree *et)
-- 
1.5.6.3
