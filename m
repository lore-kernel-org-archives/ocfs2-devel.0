From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 15 Aug 2008 00:22:24 +0800
Subject: [Ocfs2-devel] [PATCH] Refactor ocfs2_insert_extent for not-merging.
	Revised
In-Reply-To: <20080814020422.GE21187@wotan.suse.de>
References: <20080814020422.GE21187@wotan.suse.de>
Message-ID: <1218730944-23484-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,
	Your explanation is clear enough. So here is the revised one. Thanks.

In xattr bucket, we want to limit the maximum size of a btree leaf,
otherwise we'll lose the benefits of hashing because we'll have to search
large leaves.

So add a new field in ocfs2_extent_tree which indicates the max leaf cluster
size we want so that we can prevent ocfs2_insert_extent from merging the leaf
record even if they are contiguous.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c |   38 +++++++++++++++++++++++++++++---------
 fs/ocfs2/alloc.h |    5 +++++
 2 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 417419c..10c3e40 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -79,6 +79,7 @@ struct ocfs2_extent_tree {
 	struct buffer_head *root_bh;
 	struct ocfs2_extent_list *root_el;
 	void *private;
+	unsigned int max_leaf_clusters;
 };
 
 static void ocfs2_dinode_set_last_eb_blk(struct ocfs2_extent_tree *et,
@@ -220,7 +221,8 @@ static struct ocfs2_extent_tree_operations ocfs2_xattr_tree_et_ops = {
 };
 
 static struct ocfs2_extent_tree*
-	 ocfs2_new_extent_tree(struct buffer_head *bh,
+	 ocfs2_new_extent_tree(struct inode *inode,
+			       struct buffer_head *bh,
 			       enum ocfs2_extent_tree_type et_type,
 			       void *private)
 {
@@ -248,6 +250,8 @@ static struct ocfs2_extent_tree*
 			(struct ocfs2_xattr_block *)bh->b_data;
 		et->root_el = &xb->xb_attrs.xb_root.xt_list;
 		et->eops = &ocfs2_xattr_tree_et_ops;
+		et->max_leaf_clusters = ocfs2_clusters_for_bytes(inode->i_sb,
+						OCFS2_MAX_XATTR_TREE_LEAF_SIZE);
 	}
 
 	return et;
@@ -4118,7 +4122,8 @@ out:
 static void ocfs2_figure_contig_type(struct inode *inode,
 				     struct ocfs2_insert_type *insert,
 				     struct ocfs2_extent_list *el,
-				     struct ocfs2_extent_rec *insert_rec)
+				     struct ocfs2_extent_rec *insert_rec,
+				     struct ocfs2_extent_tree *et)
 {
 	int i;
 	enum ocfs2_contig_type contig_type = CONTIG_NONE;
@@ -4134,6 +4139,20 @@ static void ocfs2_figure_contig_type(struct inode *inode,
 		}
 	}
 	insert->ins_contig = contig_type;
+
+	if (insert->ins_contig != CONTIG_NONE) {
+		struct ocfs2_extent_rec *rec =
+				&el->l_recs[insert->ins_contig_index];
+		unsigned int len = le16_to_cpu(rec->e_leaf_clusters) +
+				   le16_to_cpu(insert_rec->e_leaf_clusters);
+
+		/*
+		 * Caller might want us to limit the size of extents, don't
+		 * calculate contiguousness if we might exceed that limit.
+ 		 */
+		if (et->max_leaf_clusters && len > et->max_leaf_clusters)
+		        insert->ins_contig = CONTIG_NONE;
+	}
 }
 
 /*
@@ -4241,7 +4260,7 @@ static int ocfs2_figure_insert_type(struct inode *inode,
 		le16_to_cpu(el->l_next_free_rec);
 
 	if (!insert->ins_tree_depth) {
-		ocfs2_figure_contig_type(inode, insert, el, insert_rec);
+		ocfs2_figure_contig_type(inode, insert, el, insert_rec, et);
 		ocfs2_figure_appending_type(insert, el, insert_rec);
 		return 0;
 	}
@@ -4275,7 +4294,7 @@ static int ocfs2_figure_insert_type(struct inode *inode,
          *     into two types of appends: simple record append, or a
          *     rotate inside the tail leaf.
 	 */
-	ocfs2_figure_contig_type(inode, insert, el, insert_rec);
+	ocfs2_figure_contig_type(inode, insert, el, insert_rec, et);
 
 	/*
 	 * The insert code isn't quite ready to deal with all cases of
@@ -4411,7 +4430,7 @@ int ocfs2_dinode_insert_extent(struct ocfs2_super *osb,
 	int status;
 	struct ocfs2_extent_tree *et = NULL;
 
-	et = ocfs2_new_extent_tree(root_bh, OCFS2_DINODE_EXTENT, NULL);
+	et = ocfs2_new_extent_tree(inode, root_bh, OCFS2_DINODE_EXTENT, NULL);
 	if (!et) {
 		status = -ENOMEM;
 		mlog_errno(status);
@@ -4442,7 +4461,7 @@ int ocfs2_xattr_value_insert_extent(struct ocfs2_super *osb,
 	int status;
 	struct ocfs2_extent_tree *et = NULL;
 
-	et = ocfs2_new_extent_tree(root_bh, OCFS2_XATTR_VALUE_EXTENT, private);
+	et = ocfs2_new_extent_tree(inode, root_bh, OCFS2_XATTR_VALUE_EXTENT, private);
 	if (!et) {
 		status = -ENOMEM;
 		mlog_errno(status);
@@ -4472,7 +4491,8 @@ int ocfs2_xattr_tree_insert_extent(struct ocfs2_super *osb,
 	int status;
 	struct ocfs2_extent_tree *et = NULL;
 
-	et = ocfs2_new_extent_tree(root_bh, OCFS2_XATTR_TREE_EXTENT, NULL);
+	et = ocfs2_new_extent_tree(inode, root_bh, OCFS2_XATTR_TREE_EXTENT,
+				   NULL);
 	if (!et) {
 		status = -ENOMEM;
 		mlog_errno(status);
@@ -4763,7 +4783,7 @@ int ocfs2_mark_extent_written(struct inode *inode, struct buffer_head *root_bh,
 		goto out;
 	}
 
-	et = ocfs2_new_extent_tree(root_bh, et_type, private);
+	et = ocfs2_new_extent_tree(inode, root_bh, et_type, private);
 	if (!et) {
 		ret = -ENOMEM;
 		mlog_errno(ret);
@@ -5061,7 +5081,7 @@ int ocfs2_remove_extent(struct inode *inode, struct buffer_head *root_bh,
 	struct ocfs2_path *path = NULL;
 	struct ocfs2_extent_tree *et = NULL;
 
-	et = ocfs2_new_extent_tree(root_bh, et_type, private);
+	et = ocfs2_new_extent_tree(inode, root_bh, et_type, private);
 	if (!et) {
 		ret = -ENOMEM;
 		mlog_errno(ret);
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index 211ae9a..d513914 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -32,6 +32,11 @@ enum ocfs2_extent_tree_type {
 	OCFS2_XATTR_TREE_EXTENT,
 };
 
+/*
+ * For xattr tree leaf, we limit the leaf byte size to be 64K.
+ */
+#define OCFS2_MAX_XATTR_TREE_LEAF_SIZE 65536
+
 struct ocfs2_alloc_context;
 int ocfs2_dinode_insert_extent(struct ocfs2_super *osb,
 			       handle_t *handle,
-- 
1.5.4.1
