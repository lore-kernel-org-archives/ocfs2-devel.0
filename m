From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 27 Mar 2009 07:02:17 +0800
Subject: [Ocfs2-devel] [PATCH 11/42] ocfs2: Add refcount b-tree as a new
	extent tree.
In-Reply-To: <49CC86FC.2070906@oracle.com>
References: <49CC86FC.2070906@oracle.com>
Message-ID: <1238108568-23740-11-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Add refcount b-tree as a new extent tree so that it can
use the b-tree to store and maniuplate ocfs2_refcount_rec.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c |   78 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/alloc.h |    3 ++
 2 files changed, 81 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 912f29c..6a7dada 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -163,6 +163,9 @@ struct ocfs2_extent_tree_operations {
 };
 
 
+static int ocfs2_extents_adjacent(struct ocfs2_extent_rec *left,
+				  struct ocfs2_extent_rec *right);
+
 /*
  * Pre-declare ocfs2_dinode_et_ops so we can use it as a sanity check
  * in the methods.
@@ -356,6 +359,73 @@ static struct ocfs2_extent_tree_operations ocfs2_xattr_tree_et_ops = {
 	.eo_fill_max_leaf_clusters = ocfs2_xattr_tree_fill_max_leaf_clusters,
 };
 
+static void ocfs2_refcount_tree_fill_root_el(struct ocfs2_extent_tree *et)
+{
+	struct ocfs2_refcount_block *rb = et->et_object;
+
+	et->et_root_el = &rb->rf_list;
+}
+
+static void ocfs2_refcount_tree_set_last_eb_blk(struct ocfs2_extent_tree *et,
+						u64 blkno)
+{
+	struct ocfs2_refcount_block *rb = et->et_object;
+
+	rb->rf_last_eb_blk = cpu_to_le64(blkno);
+}
+
+static u64 ocfs2_refcount_tree_get_last_eb_blk(struct ocfs2_extent_tree *et)
+{
+	struct ocfs2_refcount_block *rb = et->et_object;
+
+	return le64_to_cpu(rb->rf_last_eb_blk);
+}
+
+static void ocfs2_refcount_tree_update_clusters(struct ocfs2_extent_tree *et,
+						u32 clusters)
+{
+	struct ocfs2_refcount_block *rb = et->et_object;
+
+	le32_add_cpu(&rb->rf_clusters, clusters);
+}
+
+static	enum ocfs2_contig_type
+	ocfs2_refcount_tree_extent_contig(struct super_block *sb,
+					  struct ocfs2_extent_rec *ext,
+					  struct ocfs2_extent_rec *insert_rec)
+{
+	if (ext->e_refcount != insert_rec->e_refcount)
+		return CONTIG_NONE;
+
+	if (ocfs2_extents_adjacent(ext, insert_rec))
+		return CONTIG_RIGHT;
+
+	if (ocfs2_extents_adjacent(insert_rec, ext))
+		return CONTIG_LEFT;
+
+	return CONTIG_NONE;
+}
+
+static void ocfs2_refcount_leaf_rec_change(struct super_block *sb,
+					   struct ocfs2_extent_rec *rec,
+					   enum ocfs2_leaf_rec_change_type type,
+					   int clusters)
+{
+	if (type == LEAF_CHANGE_LEFT)
+		le32_add_cpu(&rec->e_cpos, -clusters);
+
+	le16_add_cpu(&rec->e_leaf_clusters, clusters);
+}
+
+static struct ocfs2_extent_tree_operations ocfs2_refcount_tree_et_ops = {
+	.eo_set_last_eb_blk	= ocfs2_refcount_tree_set_last_eb_blk,
+	.eo_get_last_eb_blk	= ocfs2_refcount_tree_get_last_eb_blk,
+	.eo_update_clusters	= ocfs2_refcount_tree_update_clusters,
+	.eo_fill_root_el	= ocfs2_refcount_tree_fill_root_el,
+	.eo_ocfs2_extent_contig = ocfs2_refcount_tree_extent_contig,
+	.eo_leaf_rec_change	= ocfs2_refcount_leaf_rec_change,
+};
+
 static void ocfs2_leaf_extent_rec_change(struct super_block *sb,
 					 struct ocfs2_extent_rec *rec,
 					 enum ocfs2_leaf_rec_change_type type,
@@ -426,6 +496,14 @@ void ocfs2_init_xattr_value_extent_tree(struct ocfs2_extent_tree *et,
 				 &ocfs2_xattr_value_et_ops);
 }
 
+void ocfs2_init_refcount_extent_tree(struct ocfs2_extent_tree *et,
+				     struct ocfs2_caching_info *ci,
+				     struct buffer_head *bh)
+{
+	__ocfs2_init_extent_tree(et, ci, bh, ocfs2_journal_access_rb,
+				 NULL, &ocfs2_refcount_tree_et_ops);
+}
+
 static inline void ocfs2_et_set_last_eb_blk(struct ocfs2_extent_tree *et,
 					    u64 new_last_eb_blk)
 {
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index 4eeb59f..49eff75 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -77,6 +77,9 @@ struct ocfs2_xattr_value_buf;
 void ocfs2_init_xattr_value_extent_tree(struct ocfs2_extent_tree *et,
 					struct ocfs2_caching_info *ci,
 					struct ocfs2_xattr_value_buf *vb);
+void ocfs2_init_refcount_extent_tree(struct ocfs2_extent_tree *et,
+				     struct ocfs2_caching_info *ci,
+				     struct buffer_head *bh);
 
 /*
  * Read an extent block into *bh.  If *bh is NULL, a bh will be
-- 
1.6.2.rc2.16.gf474c
