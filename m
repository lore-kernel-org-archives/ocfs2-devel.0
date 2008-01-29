From: Tao Ma <tao.ma@oracle.com>
Date: Tue Jan 29 22:23:11 2008
Subject: [Ocfs2-devel] [PATCH 2/2] Enable cross extent block merge. V2
In-Reply-To: <20080130060924.GA9243@tma-pc1.cn.oracle.com>
Message-ID: <20080130062132.GA9290@tma-pc1.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_figure_merge_contig_type, we judge whether there exists
a cross extent block merge and enable it by setting CONTIG_LEFT
and CONTIG_RIGHT accordingly.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c |   94 +++++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 86 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 0fea024..ad0157c 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -3782,20 +3782,57 @@ out:
 }
 
 static enum ocfs2_contig_type
-ocfs2_figure_merge_contig_type(struct inode *inode,
+ocfs2_figure_merge_contig_type(struct inode *inode, struct ocfs2_path *path,
 			       struct ocfs2_extent_list *el, int index,
 			       struct ocfs2_extent_rec *split_rec)
 {
-	struct ocfs2_extent_rec *rec;
+	int status;
 	enum ocfs2_contig_type ret = CONTIG_NONE;
+	u32 left_cpos, right_cpos;
+	struct ocfs2_extent_rec *rec = NULL;
+	struct ocfs2_extent_list *new_el;
+	struct ocfs2_path *left_path = NULL, *right_path = NULL;
+	struct buffer_head *bh;
+	struct ocfs2_extent_block *eb;
+
+	if (index > 0) {
+		rec = &el->l_recs[index - 1];
+	} else if (path->p_tree_depth > 0) {
+		status = ocfs2_find_cpos_for_left_leaf(inode->i_sb,
+						       path, &left_cpos);
+		if (status)
+			goto out;
+
+		if (left_cpos != 0) {
+			left_path = ocfs2_new_path(path_root_bh(path),
+						   path_root_el(path));
+			if (!left_path)
+				goto out;
+
+			status = ocfs2_find_path(inode, left_path, left_cpos);
+			if (status)
+				goto out;
+
+			new_el = path_leaf_el(left_path);
+
+			if (le16_to_cpu(new_el->l_next_free_rec) !=
+			    le16_to_cpu(new_el->l_count)) {
+				bh = path_leaf_bh(left_path);
+				eb = (struct ocfs2_extent_block *)bh->b_data;
+				OCFS2_RO_ON_INVALID_EXTENT_BLOCK(inode->i_sb,
+								 eb);
+				goto out;
+			}
+			rec = &new_el->l_recs[
+				le16_to_cpu(new_el->l_next_free_rec) - 1];
+		}
+	}
 
 	/*
 	 * We're careful to check for an empty extent record here -
 	 * the merge code will know what to do if it sees one.
 	 */
-
-	if (index > 0) {
-		rec = &el->l_recs[index - 1];
+	if (rec) {
 		if (index == 1 && ocfs2_is_empty_extent(rec)) {
 			if (split_rec->e_cpos == el->l_recs[index].e_cpos)
 				ret = CONTIG_RIGHT;
@@ -3804,10 +3841,45 @@ ocfs2_figure_merge_contig_type(struct inode *inode,
 		}
 	}
 
-	if (index < (le16_to_cpu(el->l_next_free_rec) - 1)) {
+	rec = NULL;
+	if (index < (le16_to_cpu(el->l_next_free_rec) - 1))
+		rec = &el->l_recs[index + 1];
+	else if (le16_to_cpu(el->l_next_free_rec) == le16_to_cpu(el->l_count) &&
+		 path->p_tree_depth > 0) {
+		status = ocfs2_find_cpos_for_right_leaf(inode->i_sb,
+							path, &right_cpos);
+		if (status)
+			goto out;
+
+		if (right_cpos == 0)
+			goto out;
+
+		right_path = ocfs2_new_path(path_root_bh(path),
+					    path_root_el(path));
+		if (!right_path)
+			goto out;
+
+		status = ocfs2_find_path(inode, right_path, right_cpos);
+		if (status)
+			goto out;
+
+		new_el = path_leaf_el(right_path);
+		rec = &new_el->l_recs[0];
+		if (ocfs2_is_empty_extent(rec)) {
+			if (le16_to_cpu(new_el->l_next_free_rec) <= 1) {
+				bh = path_leaf_bh(right_path);
+				eb = (struct ocfs2_extent_block *)bh->b_data;
+				OCFS2_RO_ON_INVALID_EXTENT_BLOCK(inode->i_sb,
+								 eb);
+				goto out;
+			}
+			rec = &new_el->l_recs[1];
+		}
+	}
+
+	if (rec) {
 		enum ocfs2_contig_type contig_type;
 
-		rec = &el->l_recs[index + 1];
 		contig_type = ocfs2_extent_contig(inode, rec, split_rec);
 
 		if (contig_type == CONTIG_LEFT && ret == CONTIG_RIGHT)
@@ -3816,6 +3888,12 @@ ocfs2_figure_merge_contig_type(struct inode *inode,
 			ret = contig_type;
 	}
 
+out:
+	if (left_path)
+		ocfs2_free_path(left_path);
+	if (right_path)
+		ocfs2_free_path(right_path);
+
 	return ret;
 }
 
@@ -4278,7 +4356,7 @@ static int __ocfs2_mark_extent_written(struct inode *inode,
 		goto out;
 	}
 
-	ctxt.c_contig_type = ocfs2_figure_merge_contig_type(inode, el,
+	ctxt.c_contig_type = ocfs2_figure_merge_contig_type(inode, path, el,
 							    split_index,
 							    split_rec);
 
-- 
1.5.3.GIT
