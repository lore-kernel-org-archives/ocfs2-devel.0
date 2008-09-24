From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 24 Sep 2008 15:00:55 -0700
Subject: [Ocfs2-devel] [PATCH 14/39] ocfs2: Add xattr index tree operations
In-Reply-To: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
Message-ID: <1222293680-15451-15-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: joel.becker@oracle.com, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, Tao Ma <tao.ma@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Tao Ma <tao.ma@oracle.com>

When necessary, an ocfs2_xattr_block will embed an ocfs2_extent_list to
store large numbers of EAs. This patch adds a new type in
ocfs2_extent_tree_type and adds the implementation so that we can re-use the
b-tree code to handle the storage of many EAs.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/alloc.c |   89 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/alloc.h |   10 ++++++
 2 files changed, 99 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index d175db1..47cdea6 100644
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
 /*
  * Allcate and add clusters into the extent b-tree.
  * The new clusters(clusters_to_add) will be inserted at logical_offset.
@@ -4491,6 +4574,12 @@ int ocfs2_add_clusters_in_btree(struct ocfs2_super *osb,
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
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index 168e86e..b8cfc53 100644
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
 enum ocfs2_alloc_restarted {
 	RESTART_NONE = 0,
 	RESTART_TRANS,
-- 
1.5.4.5
