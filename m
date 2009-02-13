From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:16:18 -0800
Subject: [Ocfs2-devel] [PATCH 31/40] ocfs2: Swap inode for extent_tree in
	ocfs2_figure_merge_contig_type().
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-32-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We don't want struct inode in generic btree operations.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 79055bc..093fc51 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -4150,7 +4150,8 @@ out:
 }
 
 static enum ocfs2_contig_type
-ocfs2_figure_merge_contig_type(struct inode *inode, struct ocfs2_path *path,
+ocfs2_figure_merge_contig_type(struct ocfs2_extent_tree *et,
+			       struct ocfs2_path *path,
 			       struct ocfs2_extent_list *el, int index,
 			       struct ocfs2_extent_rec *split_rec)
 {
@@ -4162,12 +4163,12 @@ ocfs2_figure_merge_contig_type(struct inode *inode, struct ocfs2_path *path,
 	struct ocfs2_path *left_path = NULL, *right_path = NULL;
 	struct buffer_head *bh;
 	struct ocfs2_extent_block *eb;
+	struct super_block *sb = ocfs2_metadata_cache_get_super(et->et_ci);
 
 	if (index > 0) {
 		rec = &el->l_recs[index - 1];
 	} else if (path->p_tree_depth > 0) {
-		status = ocfs2_find_cpos_for_left_leaf(inode->i_sb,
-						       path, &left_cpos);
+		status = ocfs2_find_cpos_for_left_leaf(sb, path, &left_cpos);
 		if (status)
 			goto out;
 
@@ -4176,8 +4177,8 @@ ocfs2_figure_merge_contig_type(struct inode *inode, struct ocfs2_path *path,
 			if (!left_path)
 				goto out;
 
-			status = ocfs2_find_path(INODE_CACHE(inode),
-						 left_path, left_cpos);
+			status = ocfs2_find_path(et->et_ci, left_path,
+						 left_cpos);
 			if (status)
 				goto out;
 
@@ -4187,7 +4188,7 @@ ocfs2_figure_merge_contig_type(struct inode *inode, struct ocfs2_path *path,
 			    le16_to_cpu(new_el->l_count)) {
 				bh = path_leaf_bh(left_path);
 				eb = (struct ocfs2_extent_block *)bh->b_data;
-				ocfs2_error(inode->i_sb,
+				ocfs2_error(sb,
 					    "Extent block #%llu has an "
 					    "invalid l_next_free_rec of "
 					    "%d.  It should have "
@@ -4212,7 +4213,7 @@ ocfs2_figure_merge_contig_type(struct inode *inode, struct ocfs2_path *path,
 			if (split_rec->e_cpos == el->l_recs[index].e_cpos)
 				ret = CONTIG_RIGHT;
 		} else {
-			ret = ocfs2_extent_contig(inode->i_sb, rec, split_rec);
+			ret = ocfs2_extent_contig(sb, rec, split_rec);
 		}
 	}
 
@@ -4221,8 +4222,7 @@ ocfs2_figure_merge_contig_type(struct inode *inode, struct ocfs2_path *path,
 		rec = &el->l_recs[index + 1];
 	else if (le16_to_cpu(el->l_next_free_rec) == le16_to_cpu(el->l_count) &&
 		 path->p_tree_depth > 0) {
-		status = ocfs2_find_cpos_for_right_leaf(inode->i_sb,
-							path, &right_cpos);
+		status = ocfs2_find_cpos_for_right_leaf(sb, path, &right_cpos);
 		if (status)
 			goto out;
 
@@ -4233,7 +4233,7 @@ ocfs2_figure_merge_contig_type(struct inode *inode, struct ocfs2_path *path,
 		if (!right_path)
 			goto out;
 
-		status = ocfs2_find_path(INODE_CACHE(inode), right_path, right_cpos);
+		status = ocfs2_find_path(et->et_ci, right_path, right_cpos);
 		if (status)
 			goto out;
 
@@ -4243,7 +4243,7 @@ ocfs2_figure_merge_contig_type(struct inode *inode, struct ocfs2_path *path,
 			if (le16_to_cpu(new_el->l_next_free_rec) <= 1) {
 				bh = path_leaf_bh(right_path);
 				eb = (struct ocfs2_extent_block *)bh->b_data;
-				ocfs2_error(inode->i_sb,
+				ocfs2_error(sb,
 					    "Extent block #%llu has an "
 					    "invalid l_next_free_rec of %d",
 					    (unsigned long long)le64_to_cpu(eb->h_blkno),
@@ -4258,7 +4258,7 @@ ocfs2_figure_merge_contig_type(struct inode *inode, struct ocfs2_path *path,
 	if (rec) {
 		enum ocfs2_contig_type contig_type;
 
-		contig_type = ocfs2_extent_contig(inode->i_sb, rec, split_rec);
+		contig_type = ocfs2_extent_contig(sb, rec, split_rec);
 
 		if (contig_type == CONTIG_LEFT && ret == CONTIG_RIGHT)
 			ret = CONTIG_LEFTRIGHT;
@@ -4850,7 +4850,7 @@ static int __ocfs2_mark_extent_written(struct inode *inode,
 		goto out;
 	}
 
-	ctxt.c_contig_type = ocfs2_figure_merge_contig_type(inode, path, el,
+	ctxt.c_contig_type = ocfs2_figure_merge_contig_type(et, path, el,
 							    split_index,
 							    split_rec);
 
-- 
1.5.6.5
