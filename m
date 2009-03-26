From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 27 Mar 2009 07:02:14 +0800
Subject: [Ocfs2-devel] [PATCH 08/42] ocfs2: Wrap manipulation of leaf extent
	record in b-tree operation.
In-Reply-To: <49CC86FC.2070906@oracle.com>
References: <49CC86FC.2070906@oracle.com>
Message-ID: <1238108568-23740-8-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In b-tree operation, when we merge/split an already existing extent
record, we need to modify e_blkno, e_cpos and e_leaf_clusters. While
with the ocfs2_extent_rec in a refcount tree, some fields now have
different meanings. So wrap the modification of leaf extent record
so that we can make it usable for the refcount tree.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c |  140 ++++++++++++++++++++++++++++++++++--------------------
 1 files changed, 89 insertions(+), 51 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index e1ddf9b..e88c949 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -60,6 +60,11 @@ enum ocfs2_contig_type {
 	CONTIG_LEFTRIGHT,
 };
 
+enum ocfs2_leaf_rec_change_type {
+	LEAF_CHANGE_LEFT = 0,
+	LEAF_CHANGE_RIGHT,
+};
+
 static enum ocfs2_contig_type
 	ocfs2_extent_rec_contig(struct super_block *sb,
 				struct ocfs2_extent_rec *ext,
@@ -143,6 +148,18 @@ struct ocfs2_extent_tree_operations {
 		(*eo_ocfs2_extent_contig)(struct super_block *sb,
 					  struct ocfs2_extent_rec *ext,
 					  struct ocfs2_extent_rec *insert_rec);
+
+	/*
+	 * Change the specified leaf extent record.
+	 * type indicates the action we need to do with the rec.
+	 * If clusters < 0, it means shrinking instead of extension.
+	 * Optional. Don't need to set it if use ocfs2_extent_rec as the
+	 * tree leaf.
+	 */
+	void (*eo_leaf_rec_change)(struct super_block *sb,
+				   struct ocfs2_extent_rec *rec,
+				   enum ocfs2_leaf_rec_change_type type,
+				   int clusters);
 };
 
 
@@ -339,6 +356,24 @@ static struct ocfs2_extent_tree_operations ocfs2_xattr_tree_et_ops = {
 	.eo_fill_max_leaf_clusters = ocfs2_xattr_tree_fill_max_leaf_clusters,
 };
 
+static void ocfs2_leaf_extent_rec_change(struct super_block *sb,
+					 struct ocfs2_extent_rec *rec,
+					 enum ocfs2_leaf_rec_change_type type,
+					 int clusters)
+{
+	if (type == LEAF_CHANGE_LEFT) {
+		le32_add_cpu(&rec->e_cpos, -clusters);
+		if (clusters > 0)
+			le64_add_cpu(&rec->e_blkno,
+			     -ocfs2_clusters_to_blocks(sb, clusters));
+		else
+			le64_add_cpu(&rec->e_blkno,
+			     ocfs2_clusters_to_blocks(sb, -clusters));
+	}
+
+	le16_add_cpu(&rec->e_leaf_clusters, clusters);
+}
+
 static void __ocfs2_init_extent_tree(struct ocfs2_extent_tree *et,
 				     struct ocfs2_caching_info *ci,
 				     struct buffer_head *bh,
@@ -362,6 +397,9 @@ static void __ocfs2_init_extent_tree(struct ocfs2_extent_tree *et,
 
 	if (!et->et_ops->eo_ocfs2_extent_contig)
 		et->et_ops->eo_ocfs2_extent_contig = ocfs2_extent_rec_contig;
+
+	if (!et->et_ops->eo_leaf_rec_change)
+		et->et_ops->eo_leaf_rec_change = ocfs2_leaf_extent_rec_change;
 }
 
 void ocfs2_init_dinode_extent_tree(struct ocfs2_extent_tree *et,
@@ -437,6 +475,16 @@ static inline enum ocfs2_contig_type
 			ext, insert_rec);
 }
 
+static inline void ocfs2_et_leaf_rec_change(struct ocfs2_extent_tree *et,
+					struct ocfs2_extent_rec *rec,
+					enum ocfs2_leaf_rec_change_type type,
+					int clusters)
+{
+	return et->et_ops->eo_leaf_rec_change(
+				ocfs2_metadata_cache_get_super(et->et_ci),
+				rec, type, clusters);
+}
+
 static inline int ocfs2_et_insert_check(struct ocfs2_extent_tree *et,
 					struct ocfs2_extent_rec *rec)
 {
@@ -3302,13 +3350,11 @@ static int ocfs2_merge_rec_right(struct ocfs2_path *left_path,
 		goto out;
 	}
 
-	le16_add_cpu(&left_rec->e_leaf_clusters, -split_clusters);
+	ocfs2_et_leaf_rec_change(et, left_rec,
+				 LEAF_CHANGE_RIGHT, -split_clusters);
 
-	le32_add_cpu(&right_rec->e_cpos, -split_clusters);
-	le64_add_cpu(&right_rec->e_blkno,
-		     -ocfs2_clusters_to_blocks(ocfs2_metadata_cache_get_super(et->et_ci),
-					       split_clusters));
-	le16_add_cpu(&right_rec->e_leaf_clusters, split_clusters);
+	ocfs2_et_leaf_rec_change(et, right_rec,
+				 LEAF_CHANGE_LEFT, split_clusters);
 
 	ocfs2_cleanup_merge(el, index);
 
@@ -3479,13 +3525,11 @@ static int ocfs2_merge_rec_left(struct ocfs2_path *right_path,
 
 		has_empty_extent = 0;
 	} else
-		le16_add_cpu(&left_rec->e_leaf_clusters, split_clusters);
+		ocfs2_et_leaf_rec_change(et, left_rec,
+					 LEAF_CHANGE_RIGHT, split_clusters);
 
-	le32_add_cpu(&right_rec->e_cpos, split_clusters);
-	le64_add_cpu(&right_rec->e_blkno,
-		     ocfs2_clusters_to_blocks(ocfs2_metadata_cache_get_super(et->et_ci),
-					      split_clusters));
-	le16_add_cpu(&right_rec->e_leaf_clusters, -split_clusters);
+	ocfs2_et_leaf_rec_change(et, right_rec,
+				 LEAF_CHANGE_LEFT, -split_clusters);
 
 	ocfs2_cleanup_merge(el, index);
 
@@ -3664,33 +3708,27 @@ out:
 	return ret;
 }
 
-static void ocfs2_subtract_from_rec(struct super_block *sb,
+static void ocfs2_subtract_from_rec(struct ocfs2_extent_tree *et,
 				    enum ocfs2_split_type split,
 				    struct ocfs2_extent_rec *rec,
 				    struct ocfs2_extent_rec *split_rec)
 {
-	u64 len_blocks;
-
-	len_blocks = ocfs2_clusters_to_blocks(sb,
-				le16_to_cpu(split_rec->e_leaf_clusters));
+	int clusters = le16_to_cpu(split_rec->e_leaf_clusters);
 
 	if (split == SPLIT_LEFT) {
 		/*
 		 * Region is on the left edge of the existing
 		 * record.
 		 */
-		le32_add_cpu(&rec->e_cpos,
-			     le16_to_cpu(split_rec->e_leaf_clusters));
-		le64_add_cpu(&rec->e_blkno, len_blocks);
-		le16_add_cpu(&rec->e_leaf_clusters,
-			     -le16_to_cpu(split_rec->e_leaf_clusters));
+		ocfs2_et_leaf_rec_change(et, rec,
+					 LEAF_CHANGE_LEFT, -clusters);
 	} else {
 		/*
 		 * Region is on the right edge of the existing
 		 * record.
 		 */
-		le16_add_cpu(&rec->e_leaf_clusters,
-			     -le16_to_cpu(split_rec->e_leaf_clusters));
+		ocfs2_et_leaf_rec_change(et, rec,
+					 LEAF_CHANGE_RIGHT, -clusters);
 	}
 }
 
@@ -3707,6 +3745,7 @@ static void ocfs2_insert_at_leaf(struct ocfs2_extent_tree *et,
 	int i = insert->ins_contig_index;
 	unsigned int range;
 	struct ocfs2_extent_rec *rec;
+	unsigned int insert_clusters = le16_to_cpu(insert_rec->e_leaf_clusters);
 
 	BUG_ON(le16_to_cpu(el->l_tree_depth) != 0);
 
@@ -3714,7 +3753,7 @@ static void ocfs2_insert_at_leaf(struct ocfs2_extent_tree *et,
 		i = ocfs2_search_extent_list(el, le32_to_cpu(insert_rec->e_cpos));
 		BUG_ON(i == -1);
 		rec = &el->l_recs[i];
-		ocfs2_subtract_from_rec(ocfs2_metadata_cache_get_super(et->et_ci),
+		ocfs2_subtract_from_rec(et,
 					insert->ins_split, rec,
 					insert_rec);
 		goto rotate;
@@ -3726,11 +3765,14 @@ static void ocfs2_insert_at_leaf(struct ocfs2_extent_tree *et,
 	if (insert->ins_contig != CONTIG_NONE) {
 		rec = &el->l_recs[i];
 		if (insert->ins_contig == CONTIG_LEFT) {
-			rec->e_blkno = insert_rec->e_blkno;
-			rec->e_cpos = insert_rec->e_cpos;
-		}
-		le16_add_cpu(&rec->e_leaf_clusters,
-			     le16_to_cpu(insert_rec->e_leaf_clusters));
+			ocfs2_et_leaf_rec_change(et, rec,
+						 LEAF_CHANGE_LEFT,
+						 insert_clusters);
+		} else
+			ocfs2_et_leaf_rec_change(et, rec,
+						 LEAF_CHANGE_RIGHT,
+						 insert_clusters);
+
 		return;
 	}
 
@@ -3985,8 +4027,7 @@ static void ocfs2_split_record(struct ocfs2_extent_tree *et,
 	}
 
 	rec = &el->l_recs[index];
-	ocfs2_subtract_from_rec(ocfs2_metadata_cache_get_super(et->et_ci),
-				split, rec, split_rec);
+	ocfs2_subtract_from_rec(et, split, rec, split_rec);
 	ocfs2_rotate_leaf(insert_el, split_rec);
 }
 
@@ -4724,24 +4765,23 @@ leave:
 	return status;
 }
 
-static void ocfs2_make_right_split_rec(struct super_block *sb,
+static void ocfs2_make_right_split_rec(struct ocfs2_extent_tree *et,
 				       struct ocfs2_extent_rec *split_rec,
 				       u32 cpos,
 				       struct ocfs2_extent_rec *rec)
 {
 	u32 rec_cpos = le32_to_cpu(rec->e_cpos);
-	u32 rec_range = rec_cpos + le16_to_cpu(rec->e_leaf_clusters);
-
-	memset(split_rec, 0, sizeof(struct ocfs2_extent_rec));
 
-	split_rec->e_cpos = cpu_to_le32(cpos);
-	split_rec->e_leaf_clusters = cpu_to_le16(rec_range - cpos);
-
-	split_rec->e_blkno = rec->e_blkno;
-	le64_add_cpu(&split_rec->e_blkno,
-		     ocfs2_clusters_to_blocks(sb, cpos - rec_cpos));
+	/*
+	 * We want to create a right split rec which start from cpos
+	 * while end at the original rec's end. So we first make
+	 * the split_rec the same as rec and then shrink it to the
+	 * specified size.
+	 */
+	*split_rec = *rec;
 
-	split_rec->e_flags = rec->e_flags;
+	ocfs2_et_leaf_rec_change(et, split_rec, LEAF_CHANGE_LEFT,
+				 rec_cpos - cpos);
 }
 
 static int ocfs2_split_and_insert(handle_t *handle,
@@ -4808,8 +4848,7 @@ leftright:
 		 */
 		insert.ins_split = SPLIT_RIGHT;
 
-		ocfs2_make_right_split_rec(ocfs2_metadata_cache_get_super(et->et_ci),
-					   &tmprec, insert_range, &rec);
+		ocfs2_make_right_split_rec(et, &tmprec, insert_range, &rec);
 
 		split_rec = tmprec;
 
@@ -5090,8 +5129,7 @@ static int ocfs2_split_tree(handle_t *handle, struct ocfs2_extent_tree *et,
 	 */
 	el = path_leaf_el(path);
 	rec = &el->l_recs[index];
-	ocfs2_make_right_split_rec(ocfs2_metadata_cache_get_super(et->et_ci),
-				   &split_rec, new_range, rec);
+	ocfs2_make_right_split_rec(et, &split_rec, new_range, rec);
 
 	depth = path->p_tree_depth;
 	if (depth > 0) {
@@ -5260,12 +5298,12 @@ static int ocfs2_truncate_rec(handle_t *handle,
 		}
 	} else if (le32_to_cpu(rec->e_cpos) == cpos) {
 		/* Remove leftmost portion of the record. */
-		le32_add_cpu(&rec->e_cpos, len);
-		le64_add_cpu(&rec->e_blkno, ocfs2_clusters_to_blocks(sb, len));
-		le16_add_cpu(&rec->e_leaf_clusters, -len);
+		ocfs2_et_leaf_rec_change(et, rec,
+					 LEAF_CHANGE_LEFT, -len);
 	} else if (rec_range == trunc_range) {
 		/* Remove rightmost portion of the record */
-		le16_add_cpu(&rec->e_leaf_clusters, -len);
+		ocfs2_et_leaf_rec_change(et, rec,
+					 LEAF_CHANGE_RIGHT, -len);
 		if (is_rightmost_tree_rec)
 			ocfs2_adjust_rightmost_records(handle, et, path, rec);
 	} else {
-- 
1.6.2.rc2.16.gf474c
