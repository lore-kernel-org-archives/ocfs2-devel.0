From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 30 Apr 2009 06:58:20 +0800
Subject: [Ocfs2-devel] [PATCH 08/39] ocfs2: Add refcount b-tree as a new
	extent tree.
In-Reply-To: <49F95A79.6040806@oracle.com>
References: <49F95A79.6040806@oracle.com>
Message-ID: <1241045931-24607-8-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Add refcount b-tree as a new extent tree so that it can
use the b-tree to store and maniuplate ocfs2_refcount_rec.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/alloc.h |    3 +++
 2 files changed, 57 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index b06db13..115c054 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -386,6 +386,52 @@ static struct ocfs2_extent_tree_operations ocfs2_dx_root_et_ops = {
 	.eo_fill_root_el	= ocfs2_dx_root_fill_root_el,
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
+static enum ocfs2_contig_type
+ocfs2_refcount_tree_extent_contig(struct super_block *sb,
+				  struct ocfs2_extent_rec *ext,
+				  struct ocfs2_extent_rec *insert_rec)
+{
+	return CONTIG_NONE;
+}
+
+static struct ocfs2_extent_tree_operations ocfs2_refcount_tree_et_ops = {
+	.eo_set_last_eb_blk	= ocfs2_refcount_tree_set_last_eb_blk,
+	.eo_get_last_eb_blk	= ocfs2_refcount_tree_get_last_eb_blk,
+	.eo_update_clusters	= ocfs2_refcount_tree_update_clusters,
+	.eo_fill_root_el	= ocfs2_refcount_tree_fill_root_el,
+	.eo_ocfs2_extent_contig = ocfs2_refcount_tree_extent_contig,
+};
+
 static void __ocfs2_init_extent_tree(struct ocfs2_extent_tree *et,
 				     struct ocfs2_caching_info *ci,
 				     struct buffer_head *bh,
@@ -443,6 +489,14 @@ void ocfs2_init_dx_root_extent_tree(struct ocfs2_extent_tree *et,
 				 NULL, &ocfs2_dx_root_et_ops);
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
index bcf6aa4..df0e778 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -80,6 +80,9 @@ void ocfs2_init_xattr_value_extent_tree(struct ocfs2_extent_tree *et,
 void ocfs2_init_dx_root_extent_tree(struct ocfs2_extent_tree *et,
 				    struct ocfs2_caching_info *ci,
 				    struct buffer_head *bh);
+void ocfs2_init_refcount_extent_tree(struct ocfs2_extent_tree *et,
+				     struct ocfs2_caching_info *ci,
+				     struct buffer_head *bh);
 
 /*
  * Read an extent block into *bh.  If *bh is NULL, a bh will be
-- 
1.6.2.rc2.16.gf474c
