From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 14 Aug 2008 01:33:12 +0800
Subject: [Ocfs2-devel] [PATCH] Refactor ocfs2_insert_extent for not-merging.
In-Reply-To: <20080812205225.GH21187@wotan.suse.de>
References: <20080812205225.GH21187@wotan.suse.de>
Message-ID: <1218648792-5033-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: taoma <taoma@tma-home.cn.oracle.com>

Hi Mark,
	Here is the patch we discussed this morning.

In xattr bucket, we want to limit the maximum size of a btree leaf,
otherwise we'll lose the benefits of hashing because we'll have to search
large leaves.

So add a new flag in ocfs2_extent_tree which will prevent ocfs2_insert_extent
from merging the leaf record even if they are contiguous.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c |   23 ++++++++++++++++++++---
 1 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 417419c..a30dfaf 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -73,12 +73,18 @@ struct ocfs2_extent_tree_operations {
 	int (*sanity_check) (struct inode *inode, struct ocfs2_extent_tree *et);
 };
 
+/*
+ * flags is used to adjust ocfs2_insert_extent behaviour
+ * for some specific reason.
+ */
+#define OCFS2_EXTENT_TREE_NOT_MERGE_LEAF 0x1
 struct ocfs2_extent_tree {
 	enum ocfs2_extent_tree_type type;
 	struct ocfs2_extent_tree_operations *eops;
 	struct buffer_head *root_bh;
 	struct ocfs2_extent_list *root_el;
 	void *private;
+	u16 flags;
 };
 
 static void ocfs2_dinode_set_last_eb_blk(struct ocfs2_extent_tree *et,
@@ -248,6 +254,7 @@ static struct ocfs2_extent_tree*
 			(struct ocfs2_xattr_block *)bh->b_data;
 		et->root_el = &xb->xb_attrs.xb_root.xt_list;
 		et->eops = &ocfs2_xattr_tree_et_ops;
+		et->flags = OCFS2_EXTENT_TREE_NOT_MERGE_LEAF;
 	}
 
 	return et;
@@ -4118,13 +4125,23 @@ out:
 static void ocfs2_figure_contig_type(struct inode *inode,
 				     struct ocfs2_insert_type *insert,
 				     struct ocfs2_extent_list *el,
-				     struct ocfs2_extent_rec *insert_rec)
+				     struct ocfs2_extent_rec *insert_rec,
+				     struct ocfs2_extent_tree *et)
 {
 	int i;
 	enum ocfs2_contig_type contig_type = CONTIG_NONE;
 
 	BUG_ON(le16_to_cpu(el->l_tree_depth) != 0);
 
+	/*
+	 * We don't calculate whether they are contiguous if the caller don't
+	 * want us to do it.
+	 */
+	if (et->flags & OCFS2_EXTENT_TREE_NOT_MERGE_LEAF) {
+		insert->ins_contig = CONTIG_NONE;
+		return;
+	}
+
 	for(i = 0; i < le16_to_cpu(el->l_next_free_rec); i++) {
 		contig_type = ocfs2_extent_contig(inode, &el->l_recs[i],
 						  insert_rec);
@@ -4241,7 +4258,7 @@ static int ocfs2_figure_insert_type(struct inode *inode,
 		le16_to_cpu(el->l_next_free_rec);
 
 	if (!insert->ins_tree_depth) {
-		ocfs2_figure_contig_type(inode, insert, el, insert_rec);
+		ocfs2_figure_contig_type(inode, insert, el, insert_rec, et);
 		ocfs2_figure_appending_type(insert, el, insert_rec);
 		return 0;
 	}
@@ -4275,7 +4292,7 @@ static int ocfs2_figure_insert_type(struct inode *inode,
          *     into two types of appends: simple record append, or a
          *     rotate inside the tail leaf.
 	 */
-	ocfs2_figure_contig_type(inode, insert, el, insert_rec);
+	ocfs2_figure_contig_type(inode, insert, el, insert_rec, et);
 
 	/*
 	 * The insert code isn't quite ready to deal with all cases of
-- 
1.5.4.1
