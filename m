From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:16:17 -0800
Subject: [Ocfs2-devel] [PATCH 30/40] ocfs2: ocfs2_extent_contig() only
	requires the superblock.
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-31-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Don't pass the inode in.  We don't want it around for generic btree
operations.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 7f1a6bc..79055bc 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -686,7 +686,7 @@ static int ocfs2_extents_adjacent(struct ocfs2_extent_rec *left,
 }
 
 static enum ocfs2_contig_type
-	ocfs2_extent_contig(struct inode *inode,
+	ocfs2_extent_contig(struct super_block *sb,
 			    struct ocfs2_extent_rec *ext,
 			    struct ocfs2_extent_rec *insert_rec)
 {
@@ -701,12 +701,12 @@ static enum ocfs2_contig_type
 		return CONTIG_NONE;
 
 	if (ocfs2_extents_adjacent(ext, insert_rec) &&
-	    ocfs2_block_extent_contig(inode->i_sb, ext, blkno))
+	    ocfs2_block_extent_contig(sb, ext, blkno))
 			return CONTIG_RIGHT;
 
 	blkno = le64_to_cpu(ext->e_blkno);
 	if (ocfs2_extents_adjacent(insert_rec, ext) &&
-	    ocfs2_block_extent_contig(inode->i_sb, insert_rec, blkno))
+	    ocfs2_block_extent_contig(sb, insert_rec, blkno))
 		return CONTIG_LEFT;
 
 	return CONTIG_NONE;
@@ -4212,7 +4212,7 @@ ocfs2_figure_merge_contig_type(struct inode *inode, struct ocfs2_path *path,
 			if (split_rec->e_cpos == el->l_recs[index].e_cpos)
 				ret = CONTIG_RIGHT;
 		} else {
-			ret = ocfs2_extent_contig(inode, rec, split_rec);
+			ret = ocfs2_extent_contig(inode->i_sb, rec, split_rec);
 		}
 	}
 
@@ -4258,7 +4258,7 @@ ocfs2_figure_merge_contig_type(struct inode *inode, struct ocfs2_path *path,
 	if (rec) {
 		enum ocfs2_contig_type contig_type;
 
-		contig_type = ocfs2_extent_contig(inode, rec, split_rec);
+		contig_type = ocfs2_extent_contig(inode->i_sb, rec, split_rec);
 
 		if (contig_type == CONTIG_LEFT && ret == CONTIG_RIGHT)
 			ret = CONTIG_LEFTRIGHT;
@@ -4287,7 +4287,7 @@ static void ocfs2_figure_contig_type(struct inode *inode,
 	BUG_ON(le16_to_cpu(el->l_tree_depth) != 0);
 
 	for(i = 0; i < le16_to_cpu(el->l_next_free_rec); i++) {
-		contig_type = ocfs2_extent_contig(inode, &el->l_recs[i],
+		contig_type = ocfs2_extent_contig(inode->i_sb, &el->l_recs[i],
 						  insert_rec);
 		if (contig_type != CONTIG_NONE) {
 			insert->ins_contig_index = i;
-- 
1.5.6.5
