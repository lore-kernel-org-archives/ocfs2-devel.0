From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:16:19 -0800
Subject: [Ocfs2-devel] [PATCH 32/40] ocfs2: Remove inode from
	ocfs2_figure_extent_contig().
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-33-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

It already has an ocfs2_extent_tree and doesn't need the inode.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 093fc51..ed0c430 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -4275,11 +4275,10 @@ out:
 	return ret;
 }
 
-static void ocfs2_figure_contig_type(struct inode *inode,
+static void ocfs2_figure_contig_type(struct ocfs2_extent_tree *et,
 				     struct ocfs2_insert_type *insert,
 				     struct ocfs2_extent_list *el,
-				     struct ocfs2_extent_rec *insert_rec,
-				     struct ocfs2_extent_tree *et)
+				     struct ocfs2_extent_rec *insert_rec)
 {
 	int i;
 	enum ocfs2_contig_type contig_type = CONTIG_NONE;
@@ -4287,8 +4286,8 @@ static void ocfs2_figure_contig_type(struct inode *inode,
 	BUG_ON(le16_to_cpu(el->l_tree_depth) != 0);
 
 	for(i = 0; i < le16_to_cpu(el->l_next_free_rec); i++) {
-		contig_type = ocfs2_extent_contig(inode->i_sb, &el->l_recs[i],
-						  insert_rec);
+		contig_type = ocfs2_extent_contig(ocfs2_metadata_cache_get_super(et->et_ci),
+						  &el->l_recs[i], insert_rec);
 		if (contig_type != CONTIG_NONE) {
 			insert->ins_contig_index = i;
 			break;
@@ -4417,7 +4416,7 @@ static int ocfs2_figure_insert_type(struct inode *inode,
 		le16_to_cpu(el->l_next_free_rec);
 
 	if (!insert->ins_tree_depth) {
-		ocfs2_figure_contig_type(inode, insert, el, insert_rec, et);
+		ocfs2_figure_contig_type(et, insert, el, insert_rec);
 		ocfs2_figure_appending_type(insert, el, insert_rec);
 		return 0;
 	}
@@ -4451,7 +4450,7 @@ static int ocfs2_figure_insert_type(struct inode *inode,
          *     into two types of appends: simple record append, or a
          *     rotate inside the tail leaf.
 	 */
-	ocfs2_figure_contig_type(inode, insert, el, insert_rec, et);
+	ocfs2_figure_contig_type(et, insert, el, insert_rec);
 
 	/*
 	 * The insert code isn't quite ready to deal with all cases of
-- 
1.5.6.5
