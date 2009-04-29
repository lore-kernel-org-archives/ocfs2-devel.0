From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 30 Apr 2009 06:58:43 +0800
Subject: [Ocfs2-devel] [PATCH 31/39] ocfs2: Abstract ocfs2 xattr tree extend
	rec iteration process.
In-Reply-To: <49F95A79.6040806@oracle.com>
References: <49F95A79.6040806@oracle.com>
Message-ID: <1241045931-24607-31-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Currently we have ocfs2_iterate_xattr_buckets which can receive
a para and a callback to iterate a series of bucket. It is good.
But actually the 2 callers ocfs2_xattr_tree_list_index_block and
ocfs2_delete_xattr_index_block are almost the same. The only
difference is that the latter need to handle the extent record
also. So add a new function named ocfs2_iterate_xattr_index_block.
It can be given func callback which are used for exten record.
So now we only have one iteration function for the xattr index
block. Ane what's more, it is useful for our future reflink
operations.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |  147 ++++++++++++++++++++++++++++--------------------------
 1 files changed, 76 insertions(+), 71 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index e3910a1..527cfe8 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -157,7 +157,7 @@ static int ocfs2_xattr_index_block_find(struct inode *inode,
 					struct ocfs2_xattr_search *xs);
 
 static int ocfs2_xattr_tree_list_index_block(struct inode *inode,
-					struct ocfs2_xattr_tree_root *xt,
+					struct buffer_head *blk_bh,
 					char *buffer,
 					size_t buffer_size);
 
@@ -170,8 +170,23 @@ static int ocfs2_xattr_set_entry_index_block(struct inode *inode,
 					     struct ocfs2_xattr_search *xs,
 					     struct ocfs2_xattr_set_ctxt *ctxt);
 
-static int ocfs2_delete_xattr_index_block(struct inode *inode,
-					  struct buffer_head *xb_bh);
+typedef int (xattr_tree_rec_func)(struct inode *inode,
+				  struct buffer_head *root_bh,
+				  u64 blkno, u32 cpos, u32 len, void *para);
+static int ocfs2_iterate_xattr_index_block(struct inode *inode,
+					   struct buffer_head *root_bh,
+					   xattr_tree_rec_func *rec_func,
+					   void *para);
+static int ocfs2_delete_xattr_in_bucket(struct inode *inode,
+					struct ocfs2_xattr_bucket *bucket,
+					void *para);
+static int ocfs2_rm_xattr_cluster(struct inode *inode,
+				  struct buffer_head *root_bh,
+				  u64 blkno,
+				  u32 cpos,
+				  u32 len,
+				  void *para);
+
 static int ocfs2_mv_xattr_buckets(struct inode *inode, handle_t *handle,
 				  u64 src_blk, u64 last_blk, u64 to_blk,
 				  unsigned int start_bucket,
@@ -870,11 +885,9 @@ static int ocfs2_xattr_block_list(struct inode *inode,
 		struct ocfs2_xattr_header *header = &xb->xb_attrs.xb_header;
 		ret = ocfs2_xattr_list_entries(inode, header,
 					       buffer, buffer_size);
-	} else {
-		struct ocfs2_xattr_tree_root *xt = &xb->xb_attrs.xb_root;
-		ret = ocfs2_xattr_tree_list_index_block(inode, xt,
+	} else
+		ret = ocfs2_xattr_tree_list_index_block(inode, blk_bh,
 						   buffer, buffer_size);
-	}
 
 	brelse(blk_bh);
 
@@ -1800,7 +1813,10 @@ static int ocfs2_xattr_block_remove(struct inode *inode,
 		struct ocfs2_xattr_header *header = &(xb->xb_attrs.xb_header);
 		ret = ocfs2_remove_value_outside(inode, &vb, header);
 	} else
-		ret = ocfs2_delete_xattr_index_block(inode, blk_bh);
+		ret = ocfs2_iterate_xattr_index_block(inode,
+						blk_bh,
+						ocfs2_rm_xattr_cluster,
+						NULL);
 
 	return ret;
 }
@@ -3297,22 +3313,19 @@ static int ocfs2_list_xattr_bucket(struct inode *inode,
 	return ret;
 }
 
-static int ocfs2_xattr_tree_list_index_block(struct inode *inode,
-					     struct ocfs2_xattr_tree_root *xt,
-					     char *buffer,
-					     size_t buffer_size)
+static int ocfs2_iterate_xattr_index_block(struct inode *inode,
+					   struct buffer_head *blk_bh,
+					   xattr_tree_rec_func *rec_func,
+					   void *para)
 {
-	struct ocfs2_extent_list *el = &xt->xt_list;
+	struct ocfs2_xattr_block *xb =
+			(struct ocfs2_xattr_block *)blk_bh->b_data;
+	struct ocfs2_extent_list *el = &xb->xb_attrs.xb_root.xt_list;
 	int ret = 0;
 	u32 name_hash = UINT_MAX, e_cpos = 0, num_clusters = 0;
 	u64 p_blkno = 0;
-	struct ocfs2_xattr_tree_list xl = {
-		.buffer = buffer,
-		.buffer_size = buffer_size,
-		.result = 0,
-	};
 
-	if (le16_to_cpu(el->l_next_free_rec) == 0)
+	if (!el->l_next_free_rec || !rec_func)
 		return 0;
 
 	while (name_hash > 0) {
@@ -3320,15 +3333,14 @@ static int ocfs2_xattr_tree_list_index_block(struct inode *inode,
 					  &e_cpos, &num_clusters, el);
 		if (ret) {
 			mlog_errno(ret);
-			goto out;
+			break;
 		}
 
-		ret = ocfs2_iterate_xattr_buckets(inode, p_blkno, num_clusters,
-						  ocfs2_list_xattr_bucket,
-						  &xl);
+		ret = rec_func(inode, blk_bh, p_blkno, e_cpos,
+			       num_clusters, para);
 		if (ret) {
 			mlog_errno(ret);
-			goto out;
+			break;
 		}
 
 		if (e_cpos == 0)
@@ -3337,6 +3349,37 @@ static int ocfs2_xattr_tree_list_index_block(struct inode *inode,
 		name_hash = e_cpos - 1;
 	}
 
+	return ret;
+
+}
+
+static int ocfs2_list_xattr_tree_rec(struct inode *inode,
+				     struct buffer_head *root_bh,
+				     u64 blkno, u32 cpos, u32 len, void *para)
+{
+	return ocfs2_iterate_xattr_buckets(inode, blkno, len,
+					   ocfs2_list_xattr_bucket, para);
+}
+
+static int ocfs2_xattr_tree_list_index_block(struct inode *inode,
+					     struct buffer_head *blk_bh,
+					     char *buffer,
+					     size_t buffer_size)
+{
+	int ret;
+	struct ocfs2_xattr_tree_list xl = {
+		.buffer = buffer,
+		.buffer_size = buffer_size,
+		.result = 0,
+	};
+
+	ret = ocfs2_iterate_xattr_index_block(inode, blk_bh,
+					      ocfs2_list_xattr_tree_rec, &xl);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
 	ret = xl.result;
 out:
 	return ret;
@@ -4895,7 +4938,8 @@ static int ocfs2_rm_xattr_cluster(struct inode *inode,
 				  struct buffer_head *root_bh,
 				  u64 blkno,
 				  u32 cpos,
-				  u32 len)
+				  u32 len,
+				  void *para)
 {
 	int ret;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
@@ -4907,6 +4951,13 @@ static int ocfs2_rm_xattr_cluster(struct inode *inode,
 	struct ocfs2_cached_dealloc_ctxt dealloc;
 	struct ocfs2_extent_tree et;
 
+	ret = ocfs2_iterate_xattr_buckets(inode, blkno, len,
+					  ocfs2_delete_xattr_in_bucket, NULL);
+	if (ret) {
+		mlog_errno(ret);
+		return ret;
+	}
+
 	ocfs2_init_xattr_tree_extent_tree(&et, INODE_CACHE(inode), root_bh);
 
 	ocfs2_init_dealloc_ctxt(&dealloc);
@@ -5329,52 +5380,6 @@ static int ocfs2_delete_xattr_in_bucket(struct inode *inode,
 	return ret;
 }
 
-static int ocfs2_delete_xattr_index_block(struct inode *inode,
-					  struct buffer_head *xb_bh)
-{
-	struct ocfs2_xattr_block *xb =
-			(struct ocfs2_xattr_block *)xb_bh->b_data;
-	struct ocfs2_extent_list *el = &xb->xb_attrs.xb_root.xt_list;
-	int ret = 0;
-	u32 name_hash = UINT_MAX, e_cpos, num_clusters;
-	u64 p_blkno;
-
-	if (le16_to_cpu(el->l_next_free_rec) == 0)
-		return 0;
-
-	while (name_hash > 0) {
-		ret = ocfs2_xattr_get_rec(inode, name_hash, &p_blkno,
-					  &e_cpos, &num_clusters, el);
-		if (ret) {
-			mlog_errno(ret);
-			goto out;
-		}
-
-		ret = ocfs2_iterate_xattr_buckets(inode, p_blkno, num_clusters,
-						  ocfs2_delete_xattr_in_bucket,
-						  NULL);
-		if (ret) {
-			mlog_errno(ret);
-			goto out;
-		}
-
-		ret = ocfs2_rm_xattr_cluster(inode, xb_bh,
-					     p_blkno, e_cpos, num_clusters);
-		if (ret) {
-			mlog_errno(ret);
-			break;
-		}
-
-		if (e_cpos == 0)
-			break;
-
-		name_hash = e_cpos - 1;
-	}
-
-out:
-	return ret;
-}
-
 /*
  * Whenever we modify a xattr value root in the bucket(e.g, CoW
  * or change the extent record flag), we need to recalculate
-- 
1.6.2.rc2.16.gf474c
