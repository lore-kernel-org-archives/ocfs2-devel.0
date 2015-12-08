From: Julia Lawall <Julia.Lawall@lip6.fr>
Date: Tue,  8 Dec 2015 22:14:31 +0100
Subject: [Ocfs2-devel] [PATCH] ocfs2: constify ocfs2_extent_tree_operations
	structures
Message-ID: <1449609271-4955-1-git-send-email-Julia.Lawall@lip6.fr>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>
Cc: kernel-janitors@vger.kernel.org, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

The ocfs2_extent_tree_operations structures are never modified, so declare
them as const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 fs/ocfs2/alloc.c |   12 ++++++------
 fs/ocfs2/alloc.h |    2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index c2cb51d..ceb56b7 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -164,7 +164,7 @@ static int ocfs2_dinode_insert_check(struct ocfs2_extent_tree *et,
 				     struct ocfs2_extent_rec *rec);
 static int ocfs2_dinode_sanity_check(struct ocfs2_extent_tree *et);
 static void ocfs2_dinode_fill_root_el(struct ocfs2_extent_tree *et);
-static struct ocfs2_extent_tree_operations ocfs2_dinode_et_ops = {
+static const struct ocfs2_extent_tree_operations ocfs2_dinode_et_ops = {
 	.eo_set_last_eb_blk	= ocfs2_dinode_set_last_eb_blk,
 	.eo_get_last_eb_blk	= ocfs2_dinode_get_last_eb_blk,
 	.eo_update_clusters	= ocfs2_dinode_update_clusters,
@@ -286,7 +286,7 @@ static void ocfs2_xattr_value_update_clusters(struct ocfs2_extent_tree *et,
 	le32_add_cpu(&vb->vb_xv->xr_clusters, clusters);
 }
 
-static struct ocfs2_extent_tree_operations ocfs2_xattr_value_et_ops = {
+static const struct ocfs2_extent_tree_operations ocfs2_xattr_value_et_ops = {
 	.eo_set_last_eb_blk	= ocfs2_xattr_value_set_last_eb_blk,
 	.eo_get_last_eb_blk	= ocfs2_xattr_value_get_last_eb_blk,
 	.eo_update_clusters	= ocfs2_xattr_value_update_clusters,
@@ -332,7 +332,7 @@ static void ocfs2_xattr_tree_update_clusters(struct ocfs2_extent_tree *et,
 	le32_add_cpu(&xb->xb_attrs.xb_root.xt_clusters, clusters);
 }
 
-static struct ocfs2_extent_tree_operations ocfs2_xattr_tree_et_ops = {
+static const struct ocfs2_extent_tree_operations ocfs2_xattr_tree_et_ops = {
 	.eo_set_last_eb_blk	= ocfs2_xattr_tree_set_last_eb_blk,
 	.eo_get_last_eb_blk	= ocfs2_xattr_tree_get_last_eb_blk,
 	.eo_update_clusters	= ocfs2_xattr_tree_update_clusters,
@@ -379,7 +379,7 @@ static void ocfs2_dx_root_fill_root_el(struct ocfs2_extent_tree *et)
 	et->et_root_el = &dx_root->dr_list;
 }
 
-static struct ocfs2_extent_tree_operations ocfs2_dx_root_et_ops = {
+static const struct ocfs2_extent_tree_operations ocfs2_dx_root_et_ops = {
 	.eo_set_last_eb_blk	= ocfs2_dx_root_set_last_eb_blk,
 	.eo_get_last_eb_blk	= ocfs2_dx_root_get_last_eb_blk,
 	.eo_update_clusters	= ocfs2_dx_root_update_clusters,
@@ -425,7 +425,7 @@ ocfs2_refcount_tree_extent_contig(struct ocfs2_extent_tree *et,
 	return CONTIG_NONE;
 }
 
-static struct ocfs2_extent_tree_operations ocfs2_refcount_tree_et_ops = {
+static const struct ocfs2_extent_tree_operations ocfs2_refcount_tree_et_ops = {
 	.eo_set_last_eb_blk	= ocfs2_refcount_tree_set_last_eb_blk,
 	.eo_get_last_eb_blk	= ocfs2_refcount_tree_get_last_eb_blk,
 	.eo_update_clusters	= ocfs2_refcount_tree_update_clusters,
@@ -438,7 +438,7 @@ static void __ocfs2_init_extent_tree(struct ocfs2_extent_tree *et,
 				     struct buffer_head *bh,
 				     ocfs2_journal_access_func access,
 				     void *obj,
-				     struct ocfs2_extent_tree_operations *ops)
+				     const struct ocfs2_extent_tree_operations *ops)
 {
 	et->et_ops = ops;
 	et->et_root_bh = bh;
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index fb09b97..f3dc1b0 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -54,7 +54,7 @@
  */
 struct ocfs2_extent_tree_operations;
 struct ocfs2_extent_tree {
-	struct ocfs2_extent_tree_operations	*et_ops;
+	const struct ocfs2_extent_tree_operations *et_ops;
 	struct buffer_head			*et_root_bh;
 	struct ocfs2_extent_list		*et_root_el;
 	struct ocfs2_caching_info		*et_ci;
