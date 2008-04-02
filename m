From: Mark Fasheh <mfasheh@suse.com>
Date: Wed,  2 Apr 2008 13:15:03 -0700
Subject: [Ocfs2-devel] [PATCH 53/62] ocfs2: Enable cross extent block merge.
In-Reply-To: <1207167427753-git-send-email-mfasheh@suse.com>
References: <12071673121124-git-send-email-mfasheh@suse.com>
	<1207167318479-git-send-email-mfasheh@suse.com>
	<12071673203909-git-send-email-mfasheh@suse.com>
	<12071673232465-git-send-email-mfasheh@suse.com>
	<12071673263948-git-send-email-mfasheh@suse.com>
	<12071673282579-git-send-email-mfasheh@suse.com>
	<1207167330482-git-send-email-mfasheh@suse.com>
	<12071673321172-git-send-email-mfasheh@suse.com>
	<12071673341888-git-send-email-mfasheh@suse.com>
	<12071673362069-git-send-email-mfasheh@suse.com>
	<12071673391031-git-send-email-mfasheh@suse.com>
	<12071673413492-git-send-email-mfasheh@suse.com>
	<1207167343926-git-send-email-mfasheh@suse.com>
	<12071673461268-git-send-email-mfasheh@suse.com>
	<12071673481928-git-send-email-mfasheh@suse.com>
	<12071673492775-git-send-email-mfasheh@suse.com>
	<12071673511262-git-send-email-mfasheh@suse.com>
	<12071673543752-git-send-email-mfasheh@suse.com>
	<1207167355295-git-send-email-mfasheh@suse.com>
	<12071673571757-git-send-email-mfasheh@suse.com>
	<12071673591158-git-send-email-mfasheh@suse.com>
	<12071673613757-git-send-email-mfasheh@suse.com>
	<1207167363119-git-send-email-mfasheh@suse.com>
	<12071673661674-git-send-email-mfasheh@suse.com>
	<12071673681650-git-send-email-mfasheh@suse.com>
	<12071673701937-git-send-email-mfasheh@suse.com>
	<12071673722691-git-send-email-mfasheh@suse.com>
	<12071673731276-git-send-email-mfasheh@suse.com>
	<12071673753788-git-send-email-mfasheh@suse.com>
	<12071673772233-git-send-email-mfasheh@suse.com>
	<1207167379283-git-send-email-mfasheh@suse.com>
	<12071673821008-git-send-email-mfasheh@suse.com>
	<12071673843208-git-send-email-mfasheh@suse.com>
	<12071673872568-git-send-email-mfasheh@suse.com>
	<12071673882492-git-send-email-mfasheh@suse.com>
	<1207167390414-git-send-email-mfasheh@suse.com>
	<1207167392537-git-send-email-mfasheh@suse.com>
	<12071673941659-git-send-email-mfasheh@suse.com>
	<12071673964014-git-send-email-mfasheh@suse.com>
	<1207167398684-git-send-email-mfasheh@suse.com>
	<12071674013954-git-send-email-mfasheh@suse.com>
	<12071674033903-git-send-email-mfasheh@suse.com>
	<12071674061934-git-send-email-mfasheh@suse.com>
	<12071674083120-git-send-email-mfasheh@suse.com>
	<12071674103432-git-send-email-mfasheh@suse.com>
	<1207167413855-git-send-email-mfasheh@suse.com>
	<12071674151752-git-send-email-mfasheh@suse.com>
	<12071674171596-git-send-email-mfasheh@suse.com>
	<12071674193441-git-send-email-mfasheh@suse.com>
	<12071674213882-git-send-email-mfasheh@suse.com>
	<12071674242631-git-send-email-mfasheh@suse.com>
	<1207167425415-git-send-email-mfasheh@suse.com>
	<1207167427753-git-send-email-mfasheh@suse.com>
Message-ID: <12071674291040-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Tao Ma <tao.ma@oracle.com>

From: Tao Ma <tao.ma@oracle.com>

In ocfs2_figure_merge_contig_type, we judge whether there exists
a cross extent block merge and enable it by setting CONTIG_LEFT
and CONTIG_RIGHT accordingly.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/alloc.c |   94 +++++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 86 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index f63cb32..7d81aa6 100644
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
1.5.4.1
