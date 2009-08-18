From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 18 Aug 2009 14:19:10 +0800
Subject: [Ocfs2-devel] [PATCH 09/41] ocfs2: Wrap ocfs2_extent_contig in
	ocfs2_extent_tree.
In-Reply-To: <4A8A47DF.8020707@oracle.com>
References: <4A8A47DF.8020707@oracle.com>
Message-ID: <1250576382-27080-9-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Add a new operation eo_ocfs2_extent_contig int the extent tree's
operations vector. So that with the new refcount tree, We want
this so that refcount trees can always return CONTIG_NONE and
prevent extent merging.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c |   57 ++++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 41 insertions(+), 16 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index ab4d2b5..75e65df 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -52,7 +52,17 @@
 
 #include "buffer_head_io.h"
 
+enum ocfs2_contig_type {
+	CONTIG_NONE = 0,
+	CONTIG_LEFT,
+	CONTIG_RIGHT,
+	CONTIG_LEFTRIGHT,
+};
 
+static enum ocfs2_contig_type
+	ocfs2_extent_rec_contig(struct super_block *sb,
+				struct ocfs2_extent_rec *ext,
+				struct ocfs2_extent_rec *insert_rec);
 /*
  * Operations for a specific extent tree type.
  *
@@ -122,6 +132,16 @@ struct ocfs2_extent_tree_operations {
 	 * to 0 (unlimited).  Optional.
 	 */
 	void (*eo_fill_max_leaf_clusters)(struct ocfs2_extent_tree *et);
+
+	/*
+	 * ->eo_extent_contig test whether the 2 ocfs2_extent_rec
+	 * are contiguous or not. Optional. Don't need to set it if use
+	 * ocfs2_extent_rec as the tree leaf.
+	 */
+	enum ocfs2_contig_type
+		(*eo_extent_contig)(struct ocfs2_extent_tree *et,
+				    struct ocfs2_extent_rec *ext,
+				    struct ocfs2_extent_rec *insert_rec);
 };
 
 
@@ -458,6 +478,19 @@ static inline int ocfs2_et_root_journal_access(handle_t *handle,
 					  type);
 }
 
+static inline enum ocfs2_contig_type
+	ocfs2_et_extent_contig(struct ocfs2_extent_tree *et,
+			       struct ocfs2_extent_rec *rec,
+			       struct ocfs2_extent_rec *insert_rec)
+{
+	if (et->et_ops->eo_extent_contig)
+		return et->et_ops->eo_extent_contig(et, rec, insert_rec);
+
+	return ocfs2_extent_rec_contig(
+				ocfs2_metadata_cache_get_super(et->et_ci),
+				rec, insert_rec);
+}
+
 static inline int ocfs2_et_insert_check(struct ocfs2_extent_tree *et,
 					struct ocfs2_extent_rec *rec)
 {
@@ -736,17 +769,9 @@ int ocfs2_search_extent_list(struct ocfs2_extent_list *el, u32 v_cluster)
 	return ret;
 }
 
-enum ocfs2_contig_type {
-	CONTIG_NONE = 0,
-	CONTIG_LEFT,
-	CONTIG_RIGHT,
-	CONTIG_LEFTRIGHT,
-};
-
-
 /*
  * NOTE: ocfs2_block_extent_contig(), ocfs2_extents_adjacent() and
- * ocfs2_extent_contig only work properly against leaf nodes!
+ * ocfs2_extent_rec_contig only work properly against leaf nodes!
  */
 static int ocfs2_block_extent_contig(struct super_block *sb,
 				     struct ocfs2_extent_rec *ext,
@@ -772,9 +797,9 @@ static int ocfs2_extents_adjacent(struct ocfs2_extent_rec *left,
 }
 
 static enum ocfs2_contig_type
-	ocfs2_extent_contig(struct super_block *sb,
-			    struct ocfs2_extent_rec *ext,
-			    struct ocfs2_extent_rec *insert_rec)
+	ocfs2_extent_rec_contig(struct super_block *sb,
+				struct ocfs2_extent_rec *ext,
+				struct ocfs2_extent_rec *insert_rec)
 {
 	u64 blkno = le64_to_cpu(insert_rec->e_blkno);
 
@@ -4400,7 +4425,7 @@ ocfs2_figure_merge_contig_type(struct ocfs2_extent_tree *et,
 			if (split_rec->e_cpos == el->l_recs[index].e_cpos)
 				ret = CONTIG_RIGHT;
 		} else {
-			ret = ocfs2_extent_contig(sb, rec, split_rec);
+			ret = ocfs2_et_extent_contig(et, rec, split_rec);
 		}
 	}
 
@@ -4445,7 +4470,7 @@ ocfs2_figure_merge_contig_type(struct ocfs2_extent_tree *et,
 	if (rec) {
 		enum ocfs2_contig_type contig_type;
 
-		contig_type = ocfs2_extent_contig(sb, rec, split_rec);
+		contig_type = ocfs2_et_extent_contig(et, rec, split_rec);
 
 		if (contig_type == CONTIG_LEFT && ret == CONTIG_RIGHT)
 			ret = CONTIG_LEFTRIGHT;
@@ -4473,8 +4498,8 @@ static void ocfs2_figure_contig_type(struct ocfs2_extent_tree *et,
 	BUG_ON(le16_to_cpu(el->l_tree_depth) != 0);
 
 	for(i = 0; i < le16_to_cpu(el->l_next_free_rec); i++) {
-		contig_type = ocfs2_extent_contig(ocfs2_metadata_cache_get_super(et->et_ci),
-						  &el->l_recs[i], insert_rec);
+		contig_type = ocfs2_et_extent_contig(et, &el->l_recs[i],
+						     insert_rec);
 		if (contig_type != CONTIG_NONE) {
 			insert->ins_contig_index = i;
 			break;
-- 
1.6.2.rc2.16.gf474c
