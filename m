From: Tao Ma <tao.ma@oracle.com>
Date: Thu,  7 Aug 2008 06:31:30 +0800
Subject: [Ocfs2-devel] [PATCH 10/15] Add xattr tree operations in
	ocfs2_extent_tree.v3
In-Reply-To: <489A94F4.90903@oracle.com>
References: <489A94F4.90903@oracle.com>
Message-ID: <1218061894-7693-8-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Modification from V2 to V3:
Add one new function ocfs2_xattr_tree_insert_extent so that manipulation
of the extent tree will be handled by this one.

ocfs2_xattr_block will use ocfs2_extent_list to store large numbers of
EAs. So add a new type in ocfs2_extent_tree_type and add one new
ocfs_extent_tree implementation so that it can use b-tree code to handle
the storage of many EAs.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c    |   83 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/alloc.h    |   10 ++++++
 fs/ocfs2/suballoc.c |    6 ++++
 3 files changed, 99 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 294bede..417419c 100644
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
@@ -4406,6 +4459,36 @@ bail:
 	return status;
 }
 
+int ocfs2_xattr_tree_insert_extent(struct ocfs2_super *osb,
+				   handle_t *handle,
+				   struct inode *inode,
+				   struct buffer_head *root_bh,
+				   u32 cpos,
+				   u64 start_blk,
+				   u32 new_clusters,
+				   u8 flags,
+				   struct ocfs2_alloc_context *meta_ac)
+{
+	int status;
+	struct ocfs2_extent_tree *et = NULL;
+
+	et = ocfs2_new_extent_tree(root_bh, OCFS2_XATTR_TREE_EXTENT, NULL);
+	if (!et) {
+		status = -ENOMEM;
+		mlog_errno(status);
+		goto bail;
+	}
+
+	status = ocfs2_insert_extent(osb, handle, inode, root_bh,
+				     cpos, start_blk, new_clusters,
+				     flags, meta_ac, et);
+
+	if (et)
+		ocfs2_free_extent_tree(et);
+bail:
+	return status;
+}
+
 static void ocfs2_make_right_split_rec(struct super_block *sb,
 				       struct ocfs2_extent_rec *split_rec,
 				       u32 cpos,
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index de69df1..211ae9a 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -29,6 +29,7 @@
 enum ocfs2_extent_tree_type {
 	OCFS2_DINODE_EXTENT = 0,
 	OCFS2_XATTR_VALUE_EXTENT,
+	OCFS2_XATTR_TREE_EXTENT,
 };
 
 struct ocfs2_alloc_context;
@@ -51,6 +52,15 @@ int ocfs2_xattr_value_insert_extent(struct ocfs2_super *osb,
 				    u8 flags,
 				    struct ocfs2_alloc_context *meta_ac,
 				    void *private);
+int ocfs2_xattr_tree_insert_extent(struct ocfs2_super *osb,
+				   handle_t *handle,
+				   struct inode *inode,
+				   struct buffer_head *root_bh,
+				   u32 cpos,
+				   u64 start_blk,
+				   u32 new_clusters,
+				   u8 flags,
+				   struct ocfs2_alloc_context *meta_ac);
 struct ocfs2_cached_dealloc_ctxt;
 int ocfs2_mark_extent_written(struct inode *inode, struct buffer_head *root_bh,
 			      handle_t *handle, u32 cpos, u32 len, u32 phys,
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 439e6bc..5f6cb6e 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -2069,6 +2069,12 @@ int ocfs2_add_clusters_in_btree(struct ocfs2_super *osb,
 		status = ocfs2_dinode_insert_extent(osb, handle, inode, root_bh,
 						    *logical_offset, block,
 						    num_bits, flags, meta_ac);
+	else if (type == OCFS2_XATTR_TREE_EXTENT)
+		status = ocfs2_xattr_tree_insert_extent(osb, handle,
+							inode, root_bh,
+							*logical_offset,
+							block, num_bits, flags,
+							meta_ac);
 	else
 		status = ocfs2_xattr_value_insert_extent(osb, handle,
 							 inode, root_bh,
-- 
1.5.4.GIT
