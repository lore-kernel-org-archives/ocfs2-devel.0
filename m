From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 5 Jun 2008 15:35:14 +0800
Subject: [Ocfs2-devel] [PATCH 8/8] Add large numbers of extended attributes
	support for	ocfs2.v1
In-Reply-To: <484792D1.3080802@oracle.com>
Message-ID: <20080605073514.GA19806@tma-pc2.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Extended attributes is added into ocfs2, but it can be only stored in inode and
one extra block, so the number is very limited. This patch enable ocfs2 to store
large numbers of EAs.

The original design doc is written by Mark Fasheh, and it can be found in
http://oss.oracle.com/osswiki/OCFS2/DesignDocs/IndexedEATrees. Just some little
modifications to it.

First, because the bucket size is 4K, a new field named as xh_offset is added
in ocfs2_xattr_header to indicate the next valid name/value offset in abucket.
It is used when we store new EA name/value. With this field, we can find the
place more quickly and what's more, we dont' need to sort the name/value every
time to let the last entry indicate the next unused space. Considering when the
blocksize is 512, we may have to update 8 blocks for one insertion if we sort
name/value like the original in-inode xattr. It is definitely inefficient.

Because of the new xh_offset, another field named as xh_name_value_len is also
added in ocfs2_xattr_header. It records the total length of all the name/values
in the bucket. We need this so that we can check it and defragment the bucket
if the bucket is too much fragmented.

So now the insertion will be like this:
1. xattr_index_block_find: find the right bucket by the name_hash, say bucketA.
2. check whether there is enough space in bucketA. If yes, insert it directly
   and modify xh_offset and xh_name_value_len accordingly. If no, check
   xh_name_value_len to see whether we can store this by defragment the bucket.
   If yes, defragment it and go on insertion.
3. If defragement doesnt' work, check whether there is new empty bucket in
   the clusters within this extent record. If yes, init the new bucket and move
   all the buckets after bucketA one by one to the next bucket. Move half of the
   entries in bucketA to the next bucket and go on insertion.
4. If there is no new bucket, grow the extent tree.(This should be the same as
   Mark has described in the design doc).

As for xattr deletion, we will delete an xattr bucket when all the xattr in this
bucket are removed and move all the buckets after it to the previous one. When
all the xattr buckets in an extend record are freed, free this extend records
from ocfs2_xattr_tree.

Two more things. This patch is a bit longer, so please be patient when reviewing
it. ;) I will divide it inot several small ones next time. And some function
names may not be good enough, I may modify them when I collect all of your
advice. So hope you enjoy it.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c |   46 +
 fs/ocfs2/alloc.h |    1 +
 fs/ocfs2/xattr.c | 3017 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ocfs2/xattr.h |    5 +-
 4 files changed, 3028 insertions(+), 41 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 9aba2c1..e0ceda6 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -136,6 +136,37 @@ static struct ocfs2_extent_tree_operations ocfs2_xattr_et_ops = {
 	.sanity_check		= ocfs2_xattr_value_sanity_check,
 };
 
+static void ocfs2_xattr_tree_set_last_eb_blk(void *p, u64 blkno)
+{
+	struct ocfs2_extent_tree *et = (struct ocfs2_extent_tree *)p;
+	struct ocfs2_xattr_block *xb =
+		(struct ocfs2_xattr_block *) et->root_bh->b_data;
+	struct ocfs2_xattr_tree_root *xt = &xb->xb_attrs.xb_root;
+
+	xt->xt_last_eb_blk = cpu_to_le64(blkno);
+}
+
+static u64 ocfs2_xattr_tree_get_last_eb_blk(void *p)
+{
+	struct ocfs2_extent_tree *et = (struct ocfs2_extent_tree *)p;
+	struct ocfs2_xattr_block *xb =
+		(struct ocfs2_xattr_block *) et->root_bh->b_data;
+	struct ocfs2_xattr_tree_root *xt = &xb->xb_attrs.xb_root;
+
+	return le64_to_cpu(xt->xt_last_eb_blk);
+}
+
+static int ocfs2_xattr_tree_sanity_check(struct inode *inode, void *p)
+{
+	return 0;
+}
+
+static struct ocfs2_extent_tree_operations ocfs2_xattr_tree_et_ops = {
+	.set_last_eb_blk	= ocfs2_xattr_tree_set_last_eb_blk,
+	.get_last_eb_blk	= ocfs2_xattr_tree_get_last_eb_blk,
+	.sanity_check		= ocfs2_xattr_tree_sanity_check,
+};
+
 static struct ocfs2_extent_tree*
 	 ocfs2_new_extent_tree(struct buffer_head *bh,
 			       enum ocfs2_extent_tree_type et_type,
@@ -160,6 +191,11 @@ static struct ocfs2_extent_tree*
 			(struct ocfs2_xattr_value_root *) private;
 		et->root_el = &xv->xr_list;
 		et->eops = &ocfs2_xattr_et_ops;
+	} else if (et_type == OCFS2_XATTR_TREE_EXTENT) {
+		struct ocfs2_xattr_block *xb =
+			(struct ocfs2_xattr_block *)bh->b_data;
+		et->root_el = &xb->xb_attrs.xb_root.xt_list;
+		et->eops = &ocfs2_xattr_tree_et_ops;
 	}
 
 	return et;
@@ -511,6 +547,12 @@ int ocfs2_num_free_extents(struct ocfs2_super *osb,
 
 		last_eb_blk = le64_to_cpu(xv->xr_last_eb_blk);
 		el = &xv->xr_list;
+	} else if (type == OCFS2_XATTR_TREE_EXTENT) {
+		struct ocfs2_xattr_block *xb =
+			(struct ocfs2_xattr_block *)root_bh->b_data;
+
+		last_eb_blk = le64_to_cpu(xb->xb_attrs.xb_root.xt_last_eb_blk);
+		el = &xb->xb_attrs.xb_root.xt_list;
 	}
 
 	if (last_eb_blk) {
@@ -3497,6 +3539,10 @@ static void ocfs2_update_clusters(struct inode *inode,
 		struct ocfs2_xattr_value_root *xv =
 			(struct ocfs2_xattr_value_root *)et->private;
 		le32_add_cpu(&xv->xr_clusters, clusters);
+	} else if (et->type == OCFS2_XATTR_TREE_EXTENT) {
+		struct ocfs2_xattr_block *xb =
+			(struct ocfs2_xattr_block *)et->root_bh->b_data;
+		le32_add_cpu(&xb->xb_attrs.xb_root.xt_clusters, clusters);
 	}
 }
 
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index b50ace5..7587f0e 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -29,6 +29,7 @@
 enum ocfs2_extent_tree_type {
 	OCFS2_DINODE_EXTENT = 0,
 	OCFS2_XATTR_VALUE_EXTENT,
+	OCFS2_XATTR_TREE_EXTENT,
 };
 
 struct ocfs2_alloc_context;
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index ed07448..5775e03 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -33,6 +33,7 @@
 #include <linux/mount.h>
 #include <linux/writeback.h>
 #include <linux/falloc.h>
+#include <linux/sort.h>
 
 #define MLOG_MASK_PREFIX ML_INODE
 #include <cluster/masklog.h>
@@ -48,6 +49,7 @@
 #include "suballoc.h"
 #include "uptodate.h"
 #include "buffer_head_io.h"
+#include "super.h"
 #include "xattr.h"
 
 
@@ -108,13 +110,36 @@ struct ocfs2_xattr_info {
 struct ocfs2_xattr_search {
 	struct buffer_head *inode_bh;
 	struct buffer_head *xattr_bh;
+	struct buffer_head *header_bh;
 	struct ocfs2_xattr_header *header;
 	void *base;
 	void *end;
 	struct ocfs2_xattr_entry *here;
+	int alloc_base;
 	int not_found;
 };
 
+static int ocfs2_xattr_index_block_find(struct inode *inode,
+					struct buffer_head *root_bh,
+					int name_index,
+					const char *name,
+					struct ocfs2_xattr_search *xs);
+
+static int ocfs2_xattr_list_index_block(struct inode *inode,
+					struct ocfs2_xattr_tree_root *xt,
+					char *buffer,
+					size_t buffer_size);
+
+static int ocfs2_xattr_create_index_block(struct inode *inode,
+					  struct ocfs2_xattr_search *xs);
+
+static int ocfs2_xattr_set_entry_index_block(struct inode *inode,
+					     struct ocfs2_xattr_info *xi,
+					     struct ocfs2_xattr_search *xs);
+
+static int ocfs2_delete_xattr_index_block(struct inode *inode,
+					  struct buffer_head *xb_bh);
+
 static inline u32 ocfs2_blocks_per_cluster(struct super_block *sb)
 {
 	return 1 << (OCFS2_SB(sb)->s_clustersize_bits - sb->s_blocksize_bits);
@@ -493,22 +518,28 @@ static int ocfs2_xattr_block_list(struct inode *inode,
 				  size_t buffer_size)
 {
 	struct buffer_head *blk_bh = NULL;
-	struct ocfs2_xattr_header *header = NULL;
+	struct ocfs2_xattr_block *xb;
 	int ret = 0;
 
 	if (!di->i_xattr_loc)
 		return ret;
-	else {
-		ret = ocfs2_read_block(OCFS2_SB(inode->i_sb),
-				       le64_to_cpu(di->i_xattr_loc),
-				       &blk_bh, OCFS2_BH_CACHED, inode);
-		if (ret)
-			return ret;
-	}
 
-	header = &((struct ocfs2_xattr_block *)blk_bh->b_data)->
-		 xb_attrs.xb_header;
-	ret = ocfs2_xattr_list_entries(inode, header, buffer, buffer_size);
+	ret = ocfs2_read_block(OCFS2_SB(inode->i_sb),
+			       le64_to_cpu(di->i_xattr_loc),
+			       &blk_bh, OCFS2_BH_CACHED, inode);
+	if (ret)
+		return ret;
+	xb = (struct ocfs2_xattr_block *)blk_bh->b_data;
+
+	if (!(le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED)) {
+		struct ocfs2_xattr_header *header = &xb->xb_attrs.xb_header;
+		ret = ocfs2_xattr_list_entries(inode, header,
+					       buffer, buffer_size);
+	} else {
+		struct ocfs2_xattr_tree_root *xt = &xb->xb_attrs.xb_root;
+		ret = ocfs2_xattr_list_index_block(inode, xt,
+						   buffer, buffer_size);
+	}
 
 	if (blk_bh)
 		brelse(blk_bh);
@@ -689,28 +720,35 @@ static int ocfs2_xattr_block_get(struct inode *inode,
 {
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)xs->inode_bh->b_data;
 	struct buffer_head *blk_bh = NULL;
+	struct ocfs2_xattr_block *xb;
 	size_t size;
 	int ret = -ENODATA;
 
 	if (!di->i_xattr_loc)
 		return ret;
-	else {
-		struct ocfs2_xattr_block *xb;
 
-		ret = ocfs2_read_block(OCFS2_SB(inode->i_sb),
-				       le64_to_cpu(di->i_xattr_loc),
-				       &blk_bh, OCFS2_BH_CACHED, inode);
-		if (ret)
-			goto cleanup;
-		xs->xattr_bh = blk_bh;
-		xb = (struct ocfs2_xattr_block *)blk_bh->b_data;
+	ret = ocfs2_read_block(OCFS2_SB(inode->i_sb),
+			       le64_to_cpu(di->i_xattr_loc),
+			       &blk_bh, OCFS2_BH_CACHED, inode);
+	if (ret)
+		goto cleanup;
+	xb = (struct ocfs2_xattr_block *)blk_bh->b_data;
+	xs->xattr_bh = blk_bh;
+
+	if (!xb || !(le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED)) {
 		xs->header = &xb->xb_attrs.xb_header;
 		xs->base = (void *)xs->header;
 		xs->end = (void *)(blk_bh->b_data) + blk_bh->b_size;
 		xs->here = xs->header->xh_entries;
+		ret = ocfs2_xattr_find_entry(name_index, name, xs);
+	} else {
+		xs->header_bh = NULL;
+		xs->alloc_base = 0;
+		ret = ocfs2_xattr_index_block_find(inode, blk_bh,
+						   name_index,
+						   name, xs);
 	}
 
-	ret = ocfs2_xattr_find_entry(name_index, name, xs);
 	if (ret)
 		goto cleanup;
 	size = le64_to_cpu(xs->here->xe_value_size);
@@ -731,8 +769,12 @@ static int ocfs2_xattr_block_get(struct inode *inode,
 	}
 	ret = size;
 cleanup:
-	if (blk_bh)
-		brelse(blk_bh);
+	if (xs->header_bh)
+		brelse(xs->header_bh);
+	if (xs->alloc_base)
+		kfree(xs->base);
+	if (xs->xattr_bh)
+		brelse(xs->xattr_bh);
 	return ret;
 }
 
@@ -1255,13 +1297,14 @@ static int ocfs2_xattr_block_remove(struct inode *inode,
 				    struct buffer_head *blk_bh)
 {
 	struct ocfs2_xattr_block *xb;
-	struct ocfs2_xattr_header *header;
 	int ret = 0;
 
 	xb = (struct ocfs2_xattr_block *)blk_bh->b_data;
-	header = &(xb->xb_attrs.xb_header);
-
-	ret = ocfs2_remove_value_outside(inode, blk_bh, header);
+	if (!(le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED)) {
+		struct ocfs2_xattr_header *header = &(xb->xb_attrs.xb_header);
+		ret = ocfs2_remove_value_outside(inode, blk_bh, header);
+	} else
+		ret = ocfs2_delete_xattr_index_block(inode, blk_bh);
 
 	return ret;
 }
@@ -1419,15 +1462,23 @@ static int ocfs2_xattr_block_find(struct inode *inode,
 {
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)xs->inode_bh->b_data;
 	struct buffer_head *blk_bh = NULL;
+	struct ocfs2_xattr_block *xb;
 	int ret = 0;
 
-	if (di->i_xattr_loc) {
-		ret = ocfs2_read_block(OCFS2_SB(inode->i_sb),
-				       le64_to_cpu(di->i_xattr_loc),
-				       &blk_bh, OCFS2_BH_CACHED, inode);
-		if (ret)
-			return ret;
-		xs->xattr_bh = blk_bh;
+	if (di->i_xattr_loc == 0)
+		return 0;
+
+	ret = ocfs2_read_block(OCFS2_SB(inode->i_sb),
+			       le64_to_cpu(di->i_xattr_loc),
+			       &blk_bh, OCFS2_BH_CACHED, inode);
+	if (ret)
+		return ret;
+
+	xb = (struct ocfs2_xattr_block *)blk_bh->b_data;
+	xs->xattr_bh = blk_bh;
+
+	if (!(le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED)) {
+		xs->header = &xb->xb_attrs.xb_header;
 		xs->header = &((struct ocfs2_xattr_block *)blk_bh->b_data)->
 				xb_attrs.xb_header;
 		xs->base = (void *)xs->header;
@@ -1435,17 +1486,62 @@ static int ocfs2_xattr_block_find(struct inode *inode,
 		xs->here = xs->header->xh_entries;
 
 		ret = ocfs2_xattr_find_entry(name_index, name, xs);
-		if (ret && ret != -ENODATA)
-			goto cleanup;
-		xs->not_found = ret;
-		return 0;
-	}
+	} else
+		ret = ocfs2_xattr_index_block_find(inode, blk_bh,
+						   name_index,
+						   name, xs);
+
+	if (ret && ret != -ENODATA)
+		goto cleanup;
+	xs->not_found = ret;
+	return 0;
+
 cleanup:
 	if (blk_bh)
 		brelse(blk_bh);
 	return ret;
 }
 
+static int ocfs2_restore_xattr_block(struct inode *inode,
+				     struct ocfs2_xattr_search *xs)
+{
+	int ret;
+	handle_t *handle;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_xattr_block *xb =
+		(struct ocfs2_xattr_block *)xs->xattr_bh->b_data;
+	struct ocfs2_extent_list *el = &xb->xb_attrs.xb_root.xt_list;
+	u16 xb_flags = le16_to_cpu(xb->xb_flags);
+
+	BUG_ON(!(xb_flags & OCFS2_XATTR_INDEXED) ||
+		le16_to_cpu(el->l_next_free_rec) != 0);
+
+	handle = ocfs2_start_trans(osb, 1);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		handle = NULL;
+		goto out;
+	}
+
+	ret = ocfs2_journal_access(handle, inode, xs->xattr_bh,
+				   OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	memset(&xb->xb_attrs, 0, sizeof(struct ocfs2_xattr_header));
+
+	xb->xb_flags = cpu_to_le16(xb_flags & ~OCFS2_XATTR_INDEXED);
+
+	ocfs2_journal_dirty(handle, xs->xattr_bh);
+
+out_commit:
+	ocfs2_commit_trans(osb, handle);
+out:
+	return ret;
+}
+
 static int ocfs2_xattr_block_set(struct inode *inode,
 				 struct ocfs2_xattr_info *xi,
 				 struct ocfs2_xattr_search *xs)
@@ -1527,8 +1623,24 @@ out:
 			ocfs2_free_alloc_context(meta_ac);
 		if (ret < 0)
 			return ret;
+	} else
+		xblk = (struct ocfs2_xattr_block *)xs->xattr_bh->b_data;
+
+	if (!(le16_to_cpu(xblk->xb_flags) & OCFS2_XATTR_INDEXED)) {
+		ret = ocfs2_xattr_set_entry(inode, xi, xs);
+		if (!ret || ret != -ENOSPC)
+			goto end;
+
+		ret = ocfs2_xattr_create_index_block(inode, xs);
+		if (ret)
+			goto end;
 	}
-	ret = ocfs2_xattr_set_entry(inode, xi, xs);
+
+	ret = ocfs2_xattr_set_entry_index_block(inode, xi, xs);
+	if (!ret && xblk->xb_attrs.xb_root.xt_list.l_next_free_rec == 0)
+		ret = ocfs2_restore_xattr_block(inode, xs);
+
+end:
 	if (!ret && !(le16_to_cpu(di->i_dyn_features) & OCFS2_HAS_XATTR_FL))
 		ocfs2_xattr_update_flag(inode,
 					xs->inode_bh,
@@ -1626,6 +1738,2831 @@ cleanup:
 		brelse(di_bh);
 	if (xbs.xattr_bh)
 		brelse(xbs.xattr_bh);
+	if (xbs.alloc_base)
+		kfree(xbs.base);
+	if (xbs.header_bh)
+		brelse(xbs.header_bh);
+	return ret;
+}
+
+#define OCFS2_XATTR_BUCKET_SIZE			4096
+#define OCFS2_XATTR_MAX_BLOCKS_PER_BUCKET 	8
+
+static inline u16 ocfs2_xattr_buckets_per_cluster(struct ocfs2_super *osb)
+{
+	return (1 << osb->s_clustersize_bits) / OCFS2_XATTR_BUCKET_SIZE;
+}
+
+static inline u16 ocfs2_blocks_per_xattr_bucket(struct super_block *sb)
+{
+	return OCFS2_XATTR_BUCKET_SIZE / (1 << sb->s_blocksize_bits);
+}
+
+static inline u16 ocfs2_xattr_recs_per_xb(struct super_block *sb)
+{
+	int size;
+
+	size = sb->s_blocksize -
+		offsetof(struct ocfs2_xattr_block,
+			 xb_attrs.xb_root.xt_list.l_recs);
+
+	return size / sizeof(struct ocfs2_extent_rec);
+}
+
+static inline u32 ocfs2_xattr_hash_by_name(int name_index,
+					   const char *suffix_name)
+{
+	struct xattr_handler *handler = ocfs2_xattr_handler(name_index);
+	char *prefix = handler->prefix;
+	int prefix_len = strlen(handler->prefix);
+
+	return ocfs2_xattr_name_hash(prefix, prefix_len, (char *)suffix_name,
+				     strlen(suffix_name));
+}
+/*
+ * Find the xattr extent rec which may contains name_hash.
+ * e_cpos will be the first name hash of the xattr rec.
+ * el must be the ocfs2_xattr_header.xb_attrs.xb_root.xt_list.
+ */
+static int ocfs2_xattr_get_bucket(struct inode *inode,
+				  u32 name_hash,
+				  u64 *p_blkno,
+				  u32 *e_cpos,
+				  u32 *num_clusters,
+				  struct ocfs2_extent_list *el)
+{
+	int ret, i;
+	struct buffer_head *eb_bh = NULL;
+	struct ocfs2_extent_block *eb;
+	struct ocfs2_extent_rec *rec = NULL;
+	u64 e_blkno = 0;
+
+	if (el->l_tree_depth) {
+		ret = ocfs2_find_leaf(inode, el, name_hash, &eb_bh);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		eb = (struct ocfs2_extent_block *) eb_bh->b_data;
+		el = &eb->h_list;
+
+		if (el->l_tree_depth) {
+			ocfs2_error(inode->i_sb,
+				    "Inode %lu has non zero tree depth in "
+				    "xattr tree block %llu\n", inode->i_ino,
+				    (unsigned long long)eb_bh->b_blocknr);
+			ret = -EROFS;
+			goto out;
+		}
+	}
+
+	for (i = le16_to_cpu(el->l_next_free_rec) - 1; i >= 0; i--) {
+		rec = &el->l_recs[i];
+
+		if (le32_to_cpu(rec->e_cpos) <= name_hash) {
+			e_blkno = le64_to_cpu(rec->e_blkno);
+			break;
+		}
+	}
+
+	if (!e_blkno) {
+		ocfs2_error(inode->i_sb, "Inode %lu has bad extent "
+			    "record (%u, %u, 0) in xattr", inode->i_ino,
+			    le32_to_cpu(rec->e_cpos),
+			    ocfs2_rec_clusters(el, rec));
+		ret = -EROFS;
+		goto out;
+	}
+
+	*p_blkno = le64_to_cpu(rec->e_blkno);
+	*num_clusters = le16_to_cpu(rec->e_leaf_clusters);
+	if (e_cpos)
+		*e_cpos = le32_to_cpu(rec->e_cpos);
+out:
+	if (eb_bh)
+		brelse(eb_bh);
+	return ret;
+}
+
+/*
+ * Get the xattr entry at offset in a bucket(starting from start_blkno).
+ *
+ * The bh is the block which contains this entry. If the entry is in the same
+ * block as the header, it will set as NULL.
+ * Please note that the whole xattr entry will always be in the same block.
+ */
+static struct ocfs2_xattr_entry*
+	ocfs2_get_xe_in_bucket(struct inode *inode,
+			       struct buffer_head *header_bh,
+			       struct buffer_head **bh,
+			       u16 offset)
+{
+	int ret;
+	struct ocfs2_xattr_header *xh =
+			(struct ocfs2_xattr_header *)header_bh->b_data;
+	struct ocfs2_xattr_entry *xe = NULL;
+	u16 xe_count = le16_to_cpu(xh->xh_count);
+	u16 xe_off, block_off;
+	size_t blocksize = inode->i_sb->s_blocksize;
+	u64 start_blkno = header_bh->b_blocknr;
+
+	*bh = NULL;
+
+	if (offset >= xe_count)
+		return NULL;
+
+	xe_off = sizeof(struct ocfs2_xattr_header) +
+			offset * sizeof(struct ocfs2_xattr_entry);
+	block_off = xe_off / blocksize;
+
+	if (block_off == 0)
+		xe = &xh->xh_entries[offset];
+	else {
+		ret = ocfs2_read_block(OCFS2_SB(inode->i_sb),
+				       start_blkno + block_off,
+				       bh, OCFS2_BH_CACHED, inode);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		xe_off = xe_off % blocksize;
+		xe = (struct ocfs2_xattr_entry *)((*bh)->b_data + xe_off);
+	}
+
+out:
+	return xe;
+}
+
+/*
+ * Get a range of bytes in the bucket.
+ * If store is not NULL, copy the bytes to store.
+ */
+static int ocfs2_get_range_in_bucket(struct inode *inode,
+				     struct buffer_head *header_bh,
+				     u16 start_offset,
+				     u16 len,
+				     char *store)
+{
+	int ret;
+	struct buffer_head *bh = NULL;
+	u16 read_len = 0, read, offset = start_offset;
+	u16 block_off;
+	int blocksize = inode->i_sb->s_blocksize;
+	u64 start_blkno = header_bh->b_blocknr;
+
+	if (start_offset >= OCFS2_XATTR_BUCKET_SIZE ||
+	    start_offset + len > OCFS2_XATTR_BUCKET_SIZE)
+		return -EINVAL;
+
+	while (len > 0) {
+		block_off = start_offset / blocksize;
+		offset = start_offset % blocksize;
+
+		ret = ocfs2_read_block(OCFS2_SB(inode->i_sb),
+				       start_blkno + block_off,
+				       &bh, OCFS2_BH_CACHED, inode);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		read = (blocksize - offset) <= len ?
+				 (blocksize - offset) : len;
+		memcpy(store + read_len, bh->b_data + offset, read);
+		read_len += read;
+		start_offset += read;
+		len -= read;
+		brelse(bh);
+		bh = NULL;
+	}
+	ret = read_len;
+
+out:
+	return ret;
+}
+
+static inline int ocfs2_get_xe_name_in_bucket(struct inode *inode,
+					      struct buffer_head *header_bh,
+					      struct ocfs2_xattr_entry *xe,
+					      char *xe_name)
+{
+	u16 start = le16_to_cpu(xe->xe_name_offset);
+	u16 len = xe->xe_name_len;
+
+	return ocfs2_get_range_in_bucket(inode, header_bh,
+					 start, len, xe_name);
+}
+
+static int ocfs2_find_xe_in_bucket(struct inode *inode,
+				   struct buffer_head *header_bh,
+				   int name_index,
+				   const char *name,
+				   u32 name_hash,
+				   u16 *xe_index,
+				   int *found)
+{
+	int ret = 0, cmp = 1;
+	struct ocfs2_xattr_header *xh =
+			(struct ocfs2_xattr_header *)header_bh->b_data;
+	size_t name_len = strlen(name);
+	u16 i, xe_count = le16_to_cpu(xh->xh_count);
+	struct ocfs2_xattr_entry *xe = NULL;
+	struct buffer_head *xe_bh = NULL;
+	char *xe_name = NULL;
+
+	/*
+	 * We don't use binary search in the bucket because there
+	 * may be multiple entries with the same name hash.
+	 */
+	for (i = 0; i < xe_count; i++) {
+		xe = ocfs2_get_xe_in_bucket(inode, header_bh, &xe_bh, i);
+		if (!xe) {
+			ret = -EIO;
+			mlog_errno(ret);
+			goto out;
+		}
+
+		if (name_hash > le32_to_cpu(xe->xe_name_hash))
+			goto next;
+		else if (name_hash < le32_to_cpu(xe->xe_name_hash)) {
+			brelse(xe_bh);
+			break;
+		}
+
+		cmp = name_index - xe->xe_type;
+		if (!cmp)
+			cmp = name_len - xe->xe_name_len;
+		if (cmp)
+			goto next;
+
+		/* now we have to compare the xattr name. */
+		xe_name = kzalloc(name_len, GFP_NOFS);
+		ret = ocfs2_get_xe_name_in_bucket(inode, header_bh,
+						  xe, xe_name);
+		if (ret != name_len) {
+			kfree(xe_name);
+			goto out;
+		}
+
+		cmp = memcmp(name, xe_name, name_len);
+		kfree(xe_name);
+		if (cmp == 0) {
+			*xe_index = i;
+			*found = 1;
+			break;
+		}
+next:
+		brelse(xe_bh);
+		xe_bh = NULL;
+	}
+
+	ret = cmp ? -ENODATA : 0;
+out:
+	return ret;
+}
+
+static int ocfs2_read_xattr_bucket(struct inode *inode,
+				   u64 blkno,
+				   struct buffer_head **bhs,
+				   int new)
+{
+	int ret = 0;
+	u16 i, block_num = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
+
+	if (!new)
+		return ocfs2_read_blocks(OCFS2_SB(inode->i_sb), blkno,
+					 block_num, bhs,
+					 OCFS2_BH_CACHED, inode);
+
+	for (i = 0; i < block_num; i++) {
+		bhs[i] = sb_getblk(inode->i_sb, blkno + i);
+		if (bhs[i] == NULL) {
+			ret = -EIO;
+			mlog_errno(ret);
+			break;
+		}
+		ocfs2_set_new_buffer_uptodate(inode, bhs[i]);
+	}
+
+	return ret;
+}
+
+static int ocfs2_cp_xattr_bucket_to_buffer(struct inode *inode,
+					   u64 blkno,
+					   char *buffer)
+{
+	int i, ret, block_num = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
+	int blocksize = inode->i_sb->s_blocksize;
+	struct buffer_head **bhs = NULL;
+	char *target;
+
+	bhs = kzalloc(sizeof(struct buffer_head *) * block_num, GFP_NOFS);
+	ret = ocfs2_read_xattr_bucket(inode, blkno, bhs, 0);
+	if (ret)
+		goto out;
+
+	target = buffer;
+	for (i = 0; i < block_num; i++, target += blocksize)
+		memcpy(target, bhs[i]->b_data, blocksize);
+
+out:
+	if (bhs) {
+		for (i = 0; i < block_num; i++)
+			brelse(bhs[i]);
+		kfree(bhs);
+	}
+	return ret;
+}
+
+/*
+ * Find the specided xattr entry in a series of buckets.
+ * This series start from p_blkno and last for num_clusters.
+ * The ocfs2_xattr_header.xh_reserved1 of the first bucket contains
+ * the valid num of the buckets.
+ */
+static int ocfs2_xattr_bucket_find(struct inode *inode,
+				   int name_index,
+				   const char *name,
+				   u32 name_hash,
+				   u64 p_blkno,
+				   u32 first_hash,
+				   u32 num_clusters,
+				   struct ocfs2_xattr_search *xs)
+{
+	int ret, found = 0;
+	struct buffer_head *bh = NULL;
+	struct buffer_head *last_bh = NULL;
+	struct ocfs2_xattr_header *xh = NULL;
+	struct ocfs2_xattr_entry *xe = NULL;
+	u16 xh_count, xe_index;
+	u16 block_in_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
+	int low_bucket = 0, bucket, high_bucket;
+	int blocksize = inode->i_sb->s_blocksize;
+	u32 last_hash;
+	u64 blkno;
+
+	ret = ocfs2_read_block(OCFS2_SB(inode->i_sb), p_blkno,
+			       &bh, OCFS2_BH_CACHED, inode);
+	if (ret)
+		goto out;
+	xh = (struct ocfs2_xattr_header *)bh->b_data;
+	high_bucket = le16_to_cpu(xh->xh_reserved1) - 1;
+
+	while (low_bucket <= high_bucket) {
+		brelse(bh);
+		bh = last_bh = NULL;
+		bucket = (low_bucket + high_bucket) / 2;
+
+		blkno = p_blkno + bucket * block_in_bucket;
+
+		ret = ocfs2_read_block(OCFS2_SB(inode->i_sb), blkno,
+				       &bh, OCFS2_BH_CACHED, inode);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		xh = (struct ocfs2_xattr_header *)bh->b_data;
+		xe = &xh->xh_entries[0];
+		if (name_hash < le32_to_cpu(xe->xe_name_hash)) {
+			high_bucket = bucket - 1;
+			continue;
+		}
+
+		/*
+		 * Check whether the hash of the last entry in our
+		 * bucket is larger than the search one.
+		 */
+		xh_count = le16_to_cpu(xh->xh_count);
+		xe = ocfs2_get_xe_in_bucket(inode, bh, &last_bh,
+					    xh_count - 1);
+		if (!xe) {
+			ret = -EIO;
+			goto out;
+		}
+
+		last_hash = le32_to_cpu(xe->xe_name_hash);
+		brelse(last_bh);
+		if (name_hash > le32_to_cpu(xe->xe_name_hash)) {
+			low_bucket = bucket + 1;
+			continue;
+		}
+
+		/* the searched xattr should reside in this bucket if exists. */
+		ret = ocfs2_find_xe_in_bucket(inode, bh,
+					      name_index, name, name_hash,
+					      &xe_index, &found);
+		break;
+	}
+
+	/*
+	 * Record the bucket we have found.
+	 * Here the "header" is initialized first as the bh->b_data so that
+	 * the set function can use it to find the insert place.
+	 */
+	xs->header_bh = bh;
+	xs->header = (struct ocfs2_xattr_header *)xs->header_bh->b_data;
+	bh = NULL;
+	xs->base = NULL;
+
+	/* alloc bucket and get the xattr attribute here. */
+	if (found) {
+		if (blocksize < OCFS2_XATTR_BUCKET_SIZE) {
+			xs->base = kmalloc(OCFS2_XATTR_BUCKET_SIZE,  GFP_NOFS);
+			if (!xs->base) {
+				ret = -ENOMEM;
+				mlog_errno(ret);
+				goto out;
+			}
+			xs->alloc_base = 1;
+			ret = ocfs2_cp_xattr_bucket_to_buffer(inode,
+						xs->header_bh->b_blocknr,
+						xs->base);
+			if (ret)
+				goto out;
+		} else
+			xs->base = xs->header_bh->b_data;
+
+		xs->end = xs->base + OCFS2_XATTR_BUCKET_SIZE;
+		xs->here = &((struct ocfs2_xattr_header *)xs->base)->
+							xh_entries[xe_index];
+		mlog(0, "find xattr in bucket %llu, index = %u\n",
+		     (unsigned long long)xs->header_bh->b_blocknr, xe_index);
+	} else
+		ret = -ENODATA;
+
+out:
+	brelse(bh);
+	return ret;
+}
+
+static int ocfs2_xattr_index_block_find(struct inode *inode,
+					struct buffer_head *root_bh,
+					int name_index,
+					const char *name,
+					struct ocfs2_xattr_search *xs)
+{
+	int ret;
+	struct ocfs2_xattr_block *xb =
+			(struct ocfs2_xattr_block *)root_bh->b_data;
+	struct ocfs2_xattr_tree_root *xb_root = &xb->xb_attrs.xb_root;
+	struct ocfs2_extent_list *el = &xb_root->xt_list;
+	u64 p_blkno = 0;
+	u32 first_hash, num_clusters = 0;
+	u32 name_hash = ocfs2_xattr_hash_by_name(name_index, name);
+
+	if (le16_to_cpu(el->l_next_free_rec) == 0)
+		return -ENODATA;
+
+	mlog(0, "find xattr %s, hash = %u, index = %d in index block\n",
+	     name, name_hash, name_index);
+
+	ret = ocfs2_xattr_get_bucket(inode, name_hash, &p_blkno, &first_hash,
+				     &num_clusters, el);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	BUG_ON(p_blkno == 0 || num_clusters == 0 || first_hash > name_hash);
+
+	mlog(0, "find xattr extent rec %u clusters from %llu, the first hash "
+	     "in the rec is %u\n", num_clusters, p_blkno, first_hash);
+
+	ret = ocfs2_xattr_bucket_find(inode, name_index, name, name_hash,
+				      p_blkno, first_hash, num_clusters, xs);
+
+out:
+	return ret;
+}
+
+struct ocfs2_xattr_list {
+	char *buffer;
+	size_t buffer_size;
+};
+
+static int ocfs2_list_xattr_bucket(struct inode *inode,
+				   struct buffer_head *header_bh,
+				   struct ocfs2_xattr_header *xh,
+				   void *para)
+{
+	int ret;
+	struct ocfs2_xattr_list *xl = (struct ocfs2_xattr_list *)para;
+
+	ret = ocfs2_xattr_list_entries(inode, xh,
+				       xl->buffer, xl->buffer_size);
+
+	if (ret < 0)
+		mlog_errno(ret);
+	else {
+		if (xl->buffer)
+			xl->buffer += ret;
+
+		xl->buffer_size -= ret;
+		ret = 0;
+	}
+
+	return ret;
+}
+
+static int ocfs2_iterate_xattr_buckets(struct inode *inode,
+				       u64 blkno,
+				       u32 clusters,
+				       int (*func)(struct inode *inode,
+						struct buffer_head *header_bh,
+						struct ocfs2_xattr_header *xh,
+						void *para),
+				       void *para)
+{
+	int i, j, ret = 0, alloc_bucket = 0;
+	char *bucket = NULL, *buf;
+	struct ocfs2_xattr_header *xh;
+	int block_num = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
+	u32 bpc = ocfs2_xattr_buckets_per_cluster(OCFS2_SB(inode->i_sb));
+	u32 bucket_num = clusters * bpc;
+	struct buffer_head **bhs = NULL;
+	int blocksize = inode->i_sb->s_blocksize;
+
+	mlog(0, "iterating xattr buckets in %u clusters starting from %llu\n",
+	     clusters, blkno);
+
+	bhs = kcalloc(block_num, sizeof(struct buffer_head *), GFP_NOFS);
+	if (!bhs)
+		return -ENOMEM;
+
+	if (block_num > 1) {
+		bucket = kmalloc(OCFS2_XATTR_BUCKET_SIZE,  GFP_NOFS);
+		if (!bucket) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		alloc_bucket = 1;
+	}
+
+	for (i = 0; i < bucket_num; i++, blkno += block_num) {
+		ret = ocfs2_read_blocks(OCFS2_SB(inode->i_sb), blkno, block_num,
+					bhs, OCFS2_BH_CACHED, inode);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		if (block_num > 1) {
+			buf = bucket;
+			for (j = 0; j < block_num; j++, buf += blocksize)
+				memcpy(buf, bhs[j]->b_data, blocksize);
+		} else
+			bucket = bhs[0]->b_data;
+
+		xh = (struct ocfs2_xattr_header *)bucket;
+		/*
+		 * The real bucket num in this series of blocks is stored
+		 * in the 1st bucket.
+		 */
+		if (i == 0)
+			bucket_num = le16_to_cpu(xh->xh_reserved1);
+
+		mlog(0, "iterating xattr bucket %llu\n", blkno);
+		if (func) {
+			ret = func(inode, bhs[0], xh, para);
+			if (ret) {
+				mlog_errno(ret);
+				break;
+			}
+		}
+
+		for (j = 0; j < block_num; j++) {
+			brelse(bhs[j]);
+			bhs[j] = NULL;
+		}
+	}
+
+out:
+	for (j = 0; j < block_num; j++)
+		brelse(bhs[j]);
+	kfree(bhs);
+
+	if (alloc_bucket)
+		kfree(bucket);
+
+	return ret;
+}
+
+static int ocfs2_xattr_list_index_block(struct inode *inode,
+					struct ocfs2_xattr_tree_root *xt,
+					char *buffer,
+					size_t buffer_size)
+{
+	struct ocfs2_extent_list *el = &xt->xt_list;
+	int ret = 0;
+	u32 name_hash = UINT_MAX, e_cpos, num_clusters;
+	u64 p_blkno;
+	struct ocfs2_xattr_list xl = {
+		.buffer = buffer,
+		.buffer_size = buffer_size,
+	};
+
+	if (le16_to_cpu(el->l_next_free_rec) == 0)
+		return 0;
+
+	while (name_hash > 0) {
+		ret = ocfs2_xattr_get_bucket(inode, name_hash, &p_blkno,
+					     &e_cpos, &num_clusters, el);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		ret = ocfs2_iterate_xattr_buckets(inode, p_blkno, num_clusters,
+						  ocfs2_list_xattr_bucket,
+						  &xl);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		if (e_cpos == 0)
+			break;
+
+		name_hash = e_cpos - 1;
+	}
+
+	ret = buffer_size - xl.buffer_size;
+out:
+	return ret;
+}
+
+static int cmp_xe(const void *a, const void *b)
+{
+	const struct ocfs2_xattr_entry *l = a, *r = b;
+	u32 l_hash = le32_to_cpu(l->xe_name_hash);
+	u32 r_hash = le32_to_cpu(r->xe_name_hash);
+
+	if (l_hash > r_hash)
+		return 1;
+	if (l_hash < r_hash)
+		return -1;
+	return 0;
+}
+
+static void swap_xe(void *a, void *b, int size)
+{
+	struct ocfs2_xattr_entry *l = a, *r = b, tmp;
+
+	tmp = *l;
+	memcpy(l, r, sizeof(struct ocfs2_xattr_entry));
+	memcpy(r, &tmp, sizeof(struct ocfs2_xattr_entry));
+}
+
+static void ocfs2_cp_xattr_block_to_bucket(struct inode *inode,
+					   struct buffer_head *xb_bh,
+					   struct buffer_head *xh_bh,
+					   struct buffer_head *data_bh)
+{
+	int i, blocksize = inode->i_sb->s_blocksize;
+	u16 offset, size, off_change;
+	struct ocfs2_xattr_entry *xe;
+	struct ocfs2_xattr_block *xb =
+				(struct ocfs2_xattr_block *)xb_bh->b_data;
+	struct ocfs2_xattr_header *xb_xh = &xb->xb_attrs.xb_header;
+	struct ocfs2_xattr_header *xh =
+				(struct ocfs2_xattr_header *)xh_bh->b_data;
+	u16 count = le16_to_cpu(xb_xh->xh_count);
+	char *target = xh_bh->b_data, *src = xb_bh->b_data;
+
+	mlog(0, "cp xattr from block %llu to bucket %llu\n",
+	     (unsigned long long)xb_bh->b_blocknr,
+	     (unsigned long long)xh_bh->b_blocknr);
+
+	xh->xh_count = xb_xh->xh_count;
+	xh->xh_reserved1 = cpu_to_le16(1);
+
+	/*
+	 * Since the xe_name_offset is based on ocfs2_xattr_header,
+	 * there is a offset change corresponding to the change of
+	 * ocfs2_xattr_header's position.
+	 */
+	off_change = offsetof(struct ocfs2_xattr_block, xb_attrs.xb_header);
+	xe = &xb_xh->xh_entries[count-1];
+	offset = le16_to_cpu(xe->xe_name_offset) + off_change;
+	size = blocksize - offset;
+	xh->xh_name_value_len = cpu_to_le16(size);
+	xh->xh_offset = cpu_to_le16(OCFS2_XATTR_BUCKET_SIZE - size);
+
+	mlog(0, "copy name/value from %u to %u, size = %u\n", offset,
+	     le16_to_cpu(xh->xh_offset), size);
+	/* copy all the names and values. */
+	if (data_bh)
+		target = data_bh->b_data;
+	memcpy(target + offset, src + offset, size);
+
+	/* copy all the entries. */
+	target = xh_bh->b_data;
+	offset = offsetof(struct ocfs2_xattr_header, xh_entries);
+	size = count * sizeof(struct ocfs2_xattr_entry);
+	memcpy(target + offset, (char *)xb_xh + offset, size);
+
+	/* Change the xe offset for all the xe because of the move. */
+	off_change = OCFS2_XATTR_BUCKET_SIZE - blocksize +
+		 offsetof(struct ocfs2_xattr_block, xb_attrs.xb_header);
+	for (i = 0; i < count; i++)
+		le16_add_cpu(&xh->xh_entries[i].xe_name_offset, off_change);
+
+	mlog(0, "copy entry: start = %u, size = %u, offset_change = %u\n",
+	     offset, size, off_change);
+
+	sort(target + offset, count, sizeof(struct ocfs2_xattr_entry),
+	     cmp_xe, swap_xe);
+}
+
+/*
+ * After we move xattr from block to index btree, we have to
+ * update ocfs2_xattr_search to the new xe and base.
+ */
+static int ocfs2_xattr_update_xattr_search(struct inode *inode,
+					   struct ocfs2_xattr_search *xs,
+					   struct buffer_head *old_bh,
+					   struct buffer_head *new_bh)
+{
+	int ret;
+	char *buf = old_bh->b_data;
+	struct ocfs2_xattr_block *old_xb = (struct ocfs2_xattr_block *)buf;
+	struct ocfs2_xattr_header *old_xh = &old_xb->xb_attrs.xb_header;
+	int i, blocksize = inode->i_sb->s_blocksize;
+
+	xs->header_bh = new_bh;
+	get_bh(new_bh);
+	xs->header = (struct ocfs2_xattr_header *)xs->header_bh->b_data;
+
+	if (OCFS2_XATTR_BUCKET_SIZE != blocksize) {
+		xs->base = kmalloc(OCFS2_XATTR_BUCKET_SIZE,  GFP_NOFS);
+		if (!xs->base)
+			return -ENOMEM;
+		xs->alloc_base = 1;
+		ret = ocfs2_cp_xattr_bucket_to_buffer(inode,
+						      new_bh->b_blocknr,
+						      xs->base);
+		if (ret) {
+			mlog_errno(ret);
+			return ret;
+		}
+	} else
+		xs->base = new_bh->b_data;
+	xs->end = xs->base + OCFS2_XATTR_BUCKET_SIZE;
+
+	if (!xs->not_found) {
+		i = xs->here - old_xh->xh_entries;
+		xs->here = &((struct ocfs2_xattr_header *)xs->base)->
+								xh_entries[i];
+	}
+
 	return ret;
 }
 
+static int ocfs2_xattr_create_index_block(struct inode *inode,
+					  struct ocfs2_xattr_search *xs)
+{
+	int ret, credits = OCFS2_SUBALLOC_ALLOC;
+	u32 bit_off, len;
+	u64 blkno;
+	handle_t *handle;
+	struct super_block *sb = inode->i_sb;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct ocfs2_alloc_context *data_ac;
+	struct buffer_head *xh_bh = NULL, *data_bh = NULL;
+	struct buffer_head *xb_bh = xs->xattr_bh;
+	struct ocfs2_xattr_block *xb =
+			(struct ocfs2_xattr_block *)xb_bh->b_data;
+	struct ocfs2_xattr_tree_root *xr;
+	u16 xb_flags = le16_to_cpu(xb->xb_flags);
+	u16 bpb = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
+
+	mlog(0, "create xattr index block for %llu\n",
+	     (unsigned long long)xb_bh->b_blocknr);
+
+	BUG_ON(xb_flags & OCFS2_XATTR_INDEXED);
+
+	ret = ocfs2_reserve_clusters(osb, 1, &data_ac);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	/*
+	 * this one should be changed to the sem which is used
+	 * in xattr allocation.
+	 */
+	down_write(&oi->ip_alloc_sem);
+
+	/*
+	 * 3 more credits, one for xattr block update, one for the 1st block
+	 * of the new xattr bucket and one for the value/data.
+	 */
+	credits += 3;
+	handle = ocfs2_start_trans(osb, credits);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		mlog_errno(ret);
+		goto out_sem;
+	}
+
+	ret = ocfs2_journal_access(handle, inode, xb_bh,
+				   OCFS2_JOURNAL_ACCESS_CREATE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	ret = ocfs2_claim_clusters(osb, handle, data_ac, 1, &bit_off, &len);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	/*
+	 * The bucket may spread in many blocks, and
+	 * we will only touch the 1st block and the last block
+	 * in the whole bucket(one for entry and one for data.
+	 */
+	blkno = ocfs2_clusters_to_blocks(sb, bit_off);
+
+	mlog(0, "allocate 1 cluster from %llu to xattr block\n", blkno);
+
+	ret = ocfs2_read_block(osb, blkno, &xh_bh,
+			       OCFS2_BH_CACHED, inode);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	ret = ocfs2_journal_access(handle, inode, xh_bh,
+				   OCFS2_JOURNAL_ACCESS_CREATE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	if (bpb > 1) {
+		ret = ocfs2_read_block(osb, blkno + bpb - 1, &data_bh,
+				       OCFS2_BH_CACHED, inode);
+		if (ret) {
+			mlog_errno(ret);
+			goto out_commit;
+		}
+
+		ret = ocfs2_journal_access(handle, inode, data_bh,
+					   OCFS2_JOURNAL_ACCESS_CREATE);
+		if (ret) {
+			mlog_errno(ret);
+			goto out_commit;
+		}
+	}
+
+	ocfs2_cp_xattr_block_to_bucket(inode, xb_bh, xh_bh, data_bh);
+
+	ocfs2_journal_dirty(handle, xh_bh);
+	if (data_bh)
+		ocfs2_journal_dirty(handle, data_bh);
+
+	ocfs2_xattr_update_xattr_search(inode, xs, xb_bh, xh_bh);
+
+	/* Re-initalize the xattr block. */
+	xr = &xb->xb_attrs.xb_root;
+	memset(xr, 0, sizeof(struct ocfs2_xattr_tree_root));
+	xr->xt_clusters = cpu_to_le32(1);
+	xr->xt_last_eb_blk = 0;
+	xr->xt_list.l_tree_depth = 0;
+	xr->xt_list.l_count = cpu_to_le16(ocfs2_xattr_recs_per_xb(inode->i_sb));
+	xr->xt_list.l_next_free_rec = cpu_to_le16(1);
+
+	memset(xr->xt_list.l_recs, 0, sizeof(struct ocfs2_extent_rec));
+	xr->xt_list.l_recs[0].e_cpos = 0;
+	xr->xt_list.l_recs[0].e_blkno = cpu_to_le64(blkno);
+	xr->xt_list.l_recs[0].e_leaf_clusters = cpu_to_le16(1);
+
+	xb->xb_flags = cpu_to_le16(xb_flags | OCFS2_XATTR_INDEXED);
+
+	ret = ocfs2_journal_dirty(handle, xb_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+out_commit:
+	ocfs2_commit_trans(osb, handle);
+
+out_sem:
+	up_write(&oi->ip_alloc_sem);
+
+out:
+	if (data_ac)
+		ocfs2_free_alloc_context(data_ac);
+
+	brelse(xh_bh);
+	brelse(data_bh);
+
+	return ret;
+}
+
+static int cmp_xe_offset(const void *a, const void *b)
+{
+	const struct ocfs2_xattr_entry *l = a, *r = b;
+	u32 l_name_offset = le16_to_cpu(l->xe_name_offset);
+	u32 r_name_offset = le16_to_cpu(r->xe_name_offset);
+
+	if (l_name_offset < r_name_offset)
+		return 1;
+	if (l_name_offset > r_name_offset)
+		return -1;
+	return 0;
+}
+
+static int ocfs2_defrag_xattr_bucket(struct inode *inode,
+				     struct buffer_head *header_bh,
+				     char *bucket_buf,
+				     size_t *free)
+{
+	int ret, i;
+	size_t end, offset, len, value_len;
+	struct ocfs2_xattr_header *xh =
+			(struct ocfs2_xattr_header *)header_bh->b_data;
+	u16 count = le16_to_cpu(xh->xh_count), val_start;
+	char *entries, *buf, *bucket = NULL;
+	u64 blkno = header_bh->b_blocknr;
+	u16 block_num = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	size_t blocksize = inode->i_sb->s_blocksize;
+	handle_t *handle;
+	struct buffer_head **bhs;
+	struct ocfs2_xattr_entry *xe;
+
+	mlog(0, "adjust xattr bucket in %llu, count = %u, "
+	     "xh_offset = %u, xh_name_value_len = %u.\n",
+	     blkno, count, le16_to_cpu(xh->xh_offset),
+	     le16_to_cpu(xh->xh_name_value_len));
+
+	bhs = kcalloc(block_num, sizeof(struct buffer_head *), GFP_NOFS);
+	if (!bhs)
+		return -ENOMEM;
+
+	ret = ocfs2_read_blocks(osb, blkno, block_num, bhs,
+				OCFS2_BH_CACHED, inode);
+	if (ret)
+		goto out;
+
+	/*
+	 * In order to make the operation more efficient and generic,
+	 * we copy all the blocks into a contiguous memory.
+	 */
+	bucket = kmalloc(OCFS2_XATTR_BUCKET_SIZE, GFP_NOFS);
+	if (!bucket) {
+		ret = -EIO;
+		goto out;
+	}
+
+	buf = bucket;
+	for (i = 0; i < block_num; i++, buf += blocksize)
+		memcpy(buf, bhs[i]->b_data, blocksize);
+
+	handle = ocfs2_start_trans((OCFS2_SB(inode->i_sb)), block_num);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		handle = NULL;
+		mlog_errno(ret);
+		goto out;
+	}
+
+	for (i = 0; i < block_num; i++) {
+		ret = ocfs2_journal_access(handle, inode, bhs[i],
+					   OCFS2_JOURNAL_ACCESS_WRITE);
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto commit;
+		}
+	}
+
+	xh = (struct ocfs2_xattr_header *)bucket;
+	entries = (char *)xh->xh_entries;
+
+	/*
+	 * sort all the entries by their offset.
+	 * the largest will be the first, so that we can
+	 * move them to the end one by one.
+	 */
+	sort(entries, count, sizeof(struct ocfs2_xattr_entry),
+	     cmp_xe_offset, swap_xe);
+
+	/* Move all name/values to the end of the bucket. */
+	xe = xh->xh_entries;
+	end = OCFS2_XATTR_BUCKET_SIZE;
+	for (i = 0; i < le16_to_cpu(xh->xh_count); i++, xe++) {
+		offset = le16_to_cpu(xe->xe_name_offset);
+		if (xe->xe_local)
+			value_len = OCFS2_XATTR_SIZE(
+					le64_to_cpu(xe->xe_value_size));
+		else
+			value_len = OCFS2_XATTR_ROOT_SIZE;
+		len = OCFS2_XATTR_SIZE(xe->xe_name_len) + value_len;
+
+		/*
+		 * We must make sure that the xattr_value_root
+		 * exist in the same block. So adjust end to
+		 * the previous block end if needed.
+		 */
+		if (!xe->xe_local &&
+		    ((end -value_len) / blocksize !=
+			(end -1) / blocksize))
+			end = end -end % blocksize;
+
+		if (end > offset + len) {
+			val_start = end -len;
+			memmove(bucket + end -len, bucket + offset, len);
+			xe->xe_name_offset = cpu_to_le16(end -len);
+		}
+		end -= len;
+	}
+
+	BUG_ON(le16_to_cpu(xh->xh_offset) > end);
+
+	if (free)
+		*free += end -le16_to_cpu(xh->xh_offset);
+	if (le16_to_cpu(xh->xh_offset) == end)
+		goto commit;
+	xh->xh_offset = cpu_to_le16(end);
+
+	/* sort the entries by their name_hash. */
+	sort(entries, count, sizeof(struct ocfs2_xattr_entry),
+	     cmp_xe, swap_xe);
+
+	buf = bucket;
+	for (i = 0; i < block_num; i++, buf += blocksize) {
+		memcpy(bhs[i]->b_data, buf, blocksize);
+		ocfs2_journal_dirty(handle, bhs[i]);
+	}
+
+	if (bucket_buf)
+		memcpy(bucket_buf, bucket, OCFS2_XATTR_BUCKET_SIZE);
+commit:
+	ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
+out:
+	for (i = 0; i < block_num; i++)
+		brelse(bhs[i]);
+
+	kfree(bhs);
+	kfree(bucket);
+	return ret;
+}
+
+/*
+ * Move half nums of the xattr bucket in the previous cluster to this new
+ * cluster. We only touch the last cluster of the previous extend record.
+ *
+ * first_bh and header_bh will be udpated if we move the data header_bh
+ * contains. first_hash will be set as the 1st xe's name_hash.
+ */
+static int ocfs2_mv_xattr_bucket_cross_cluster(struct inode *inode,
+					       handle_t *handle,
+					       struct buffer_head **first_bh,
+					       struct buffer_head **header_bh,
+					       u64 new_blkno,
+					       u64 prev_blkno,
+					       u32 num_clusters,
+					       u32 *first_hash)
+{
+	int i, ret, credits;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	int block_num = ocfs2_clusters_to_blocks(inode->i_sb, 1);
+	int bucket_num = ocfs2_xattr_buckets_per_cluster(osb);
+	int blocksize = inode->i_sb->s_blocksize;
+	struct buffer_head *old_bh, *new_bh, *prev_bh, *new_first_bh = NULL;
+	struct ocfs2_xattr_header *new_xh;
+	struct ocfs2_xattr_header *xh =
+			(struct ocfs2_xattr_header *)((*first_bh)->b_data);
+
+	BUG_ON(le16_to_cpu(xh->xh_reserved1) < bucket_num);
+	BUG_ON(OCFS2_XATTR_BUCKET_SIZE == osb->s_clustersize);
+
+	prev_bh = *first_bh;
+	get_bh(prev_bh);
+	xh = (struct ocfs2_xattr_header *)prev_bh->b_data;
+
+	prev_blkno += (num_clusters - 1) * block_num + block_num / 2;
+
+	mlog(0, "move half of xattrs in cluster %llu to %llu\n",
+	     prev_blkno, new_blkno);
+
+	/*
+	 * We need to update the 1st half of the cluster and
+	 * 1 more for the update of the 1st bucket of the previous
+	 * extent record.
+	 */
+	credits = block_num / 2 + 1;
+	ret = ocfs2_extend_trans(handle, credits);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_journal_access(handle, inode, prev_bh,
+				   OCFS2_JOURNAL_ACCESS_CREATE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	for (i = 0; i < block_num / 2; i++, prev_blkno++, new_blkno++) {
+		old_bh = new_bh = NULL;
+		new_bh = sb_getblk(inode->i_sb, new_blkno);
+		if (!new_bh) {
+			ret = -EIO;
+			mlog_errno(ret);
+			goto out;
+		}
+
+		ocfs2_set_new_buffer_uptodate(inode, new_bh);
+
+		ret = ocfs2_journal_access(handle, inode, new_bh,
+					   OCFS2_JOURNAL_ACCESS_CREATE);
+		if (ret < 0) {
+			mlog_errno(ret);
+			brelse(new_bh);
+			goto out;
+		}
+
+		ret = ocfs2_read_block(osb, prev_blkno,
+					&old_bh, OCFS2_BH_CACHED, inode);
+		if (ret < 0) {
+			mlog_errno(ret);
+			brelse(new_bh);
+			goto out;
+		}
+
+		memcpy(new_bh->b_data, old_bh->b_data, blocksize);
+
+		if (i == 0) {
+			new_xh = (struct ocfs2_xattr_header *)new_bh->b_data;
+			new_xh->xh_reserved1 = cpu_to_le16(bucket_num / 2);
+			if (first_hash)
+				*first_hash = le32_to_cpu(
+					new_xh->xh_entries[0].xe_name_hash);
+			new_first_bh = new_bh;
+			get_bh(new_first_bh);
+		}
+
+		ocfs2_journal_dirty(handle, new_bh);
+
+		if (*header_bh == old_bh) {
+			brelse(*header_bh);
+			*header_bh = new_bh;
+			get_bh(*header_bh);
+
+			brelse(*first_bh);
+			*first_bh = new_first_bh;
+			get_bh(*first_bh);
+		}
+		brelse(new_bh);
+		brelse(old_bh);
+	}
+
+	le16_add_cpu(&xh->xh_reserved1, -(bucket_num / 2));
+
+	ocfs2_journal_dirty(handle, prev_bh);
+out:
+	brelse(new_first_bh);
+	return ret;
+}
+
+static int ocfs2_half_xattr_bucket(struct inode *inode,
+				   handle_t *handle,
+				   u64 blk,
+				   u64 new_blk,
+				   u32 *first_hash,
+				   int new_bucket_head)
+{
+	int ret, i;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	u16 count, start, len, name_value_len, xe_len, name_offset;
+	u16 blk_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
+	struct buffer_head **s_bhs, **t_bhs = NULL;
+	struct ocfs2_xattr_header *xh;
+	struct ocfs2_xattr_entry *xe;
+	char *bucket = NULL, *buffer;
+	int blocksize = inode->i_sb->s_blocksize;
+
+	mlog(0, "move half of xattrs from bucket %llu to %llu\n",
+	     blk, new_blk);
+
+	s_bhs = kcalloc(blk_per_bucket, sizeof(struct buffer_head *), GFP_NOFS);
+	if (!s_bhs)
+		return -ENOMEM;
+
+	ret = ocfs2_read_blocks(osb, blk, blk_per_bucket, s_bhs,
+				OCFS2_BH_CACHED, inode);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	t_bhs = kcalloc(blk_per_bucket, sizeof(struct buffer_head *), GFP_NOFS);
+	if (!t_bhs) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = ocfs2_read_blocks(osb, new_blk, blk_per_bucket, t_bhs,
+				OCFS2_BH_CACHED, inode);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_journal_access(handle, inode, s_bhs[0],
+				   OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	for (i = 0; i < blk_per_bucket; i++) {
+		ret = ocfs2_journal_access(handle, inode, t_bhs[i],
+					   OCFS2_JOURNAL_ACCESS_WRITE);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+	}
+
+	/*
+	 * In order to simplify the process, we copy the source bucket to a
+	 * buffer first, adjust it and then copy it to the dest.
+	 */
+	bucket = kmalloc(OCFS2_XATTR_BUCKET_SIZE, GFP_NOFS);
+	if (!bucket) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	buffer = bucket;
+	for (i = 0; i < blk_per_bucket; i++, buffer += blocksize)
+		memcpy(buffer, s_bhs[i]->b_data, blocksize);
+
+	xh = (struct ocfs2_xattr_header *)bucket;
+	count = le16_to_cpu(xh->xh_count);
+	start = count / 2;
+
+	/*
+	 * Calculate the total name/value len and xh_offset for
+	 * the source bucket first.
+	 */
+	name_offset = OCFS2_XATTR_BUCKET_SIZE;
+	name_value_len = 0;
+	for (i = 0; i < start; i++) {
+		xe = &xh->xh_entries[i];
+		xe_len = OCFS2_XATTR_SIZE(xe->xe_name_len);
+		if (le64_to_cpu(xe->xe_value_size) > OCFS2_XATTR_INLINE_SIZE)
+			xe_len += OCFS2_XATTR_ROOT_SIZE;
+		else
+			xe_len +=
+			   OCFS2_XATTR_SIZE(le64_to_cpu(xe->xe_value_size));
+		name_value_len += xe_len;
+		if (le16_to_cpu(xe->xe_name_offset) < name_offset)
+			name_offset = le16_to_cpu(xe->xe_name_offset);
+	}
+
+	/*
+	 * Now begin the modification to the dest bucket.
+	 *
+	 * In the dest bucket, We just move the xattr entry to the beginning
+	 * and don't touch the name/value. So there will be some holes in the
+	 * bucket, and they will be removed when ocfs2_defrag_xattr_bucket is
+	 * called.
+	 */
+	xe = &xh->xh_entries[start];
+	len = sizeof(struct ocfs2_xattr_entry) * (count - start);
+	mlog(0, "mv xattr entry len %d from %d to %d\n", len,
+		(char *)xe - bucket, (char *)xh->xh_entries - bucket);
+	memmove((char *)xh->xh_entries, (char *)xe, len);
+	xe = &xh->xh_entries[count - start];
+	len = sizeof(struct ocfs2_xattr_entry) * start;
+	memset((char *)xe, 0, len);
+
+	le16_add_cpu(&xh->xh_count, -start);
+	le16_add_cpu(&xh->xh_name_value_len, -name_value_len);
+
+	/* Calculate xh_offset for the new bucket. */
+	xh->xh_offset = cpu_to_le16(OCFS2_XATTR_BUCKET_SIZE);
+	for (i = 0; i < le16_to_cpu(xh->xh_count); i++) {
+		xe = &xh->xh_entries[i];
+		xe_len = OCFS2_XATTR_SIZE(xe->xe_name_len);
+		if (le64_to_cpu(xe->xe_value_size) > OCFS2_XATTR_INLINE_SIZE)
+			xe_len += OCFS2_XATTR_ROOT_SIZE;
+		else
+			xe_len +=
+			   OCFS2_XATTR_SIZE(le64_to_cpu(xe->xe_value_size));
+		if (le16_to_cpu(xe->xe_name_offset) <
+		    le16_to_cpu(xh->xh_offset))
+			xh->xh_offset = xe->xe_name_offset;
+	}
+
+	/* set xh->xh_reserved1 for the new xh. */
+	if (new_bucket_head)
+		xh->xh_reserved1 = cpu_to_le16(1);
+	else
+		xh->xh_reserved1 = 0;
+
+	buffer = bucket;
+	for (i = 0; i < blk_per_bucket; i++, buffer += blocksize) {
+		memcpy(t_bhs[i]->b_data, buffer, blocksize);
+		ocfs2_journal_dirty(handle, s_bhs[0]);
+		if (ret)
+			mlog_errno(ret);
+	}
+
+	/* store the first_hash of the new bucket. */
+	if (first_hash)
+		*first_hash = le32_to_cpu(xh->xh_entries[0].xe_name_hash);
+
+	/* Now update the source bucket. */
+	xh = (struct ocfs2_xattr_header *)s_bhs[0]->b_data;
+	xh->xh_count = cpu_to_le16(start);
+	xh->xh_offset = cpu_to_le16(name_offset);
+	xh->xh_name_value_len = cpu_to_le16(name_value_len);
+
+	ocfs2_journal_dirty(handle, s_bhs[0]);
+	if (ret)
+		mlog_errno(ret);
+
+out:
+	if (s_bhs) {
+		for (i = 0; i < blk_per_bucket; i++)
+			brelse(s_bhs[i]);
+	}
+	kfree(s_bhs);
+
+	if (t_bhs) {
+		for (i = 0; i < blk_per_bucket; i++)
+			brelse(t_bhs[i]);
+	}
+	kfree(t_bhs);
+
+	kfree(bucket);
+
+	return ret;
+}
+
+/*
+ * Copy xattr from one bucket to another bucket.
+ *
+ * The caller must make sure that the journal transaction
+ * has enough space for journaling.
+ */
+static int ocfs2_cp_xattr_bucket(struct inode *inode,
+				 handle_t *handle,
+				 u64 s_blkno,
+				 u64 t_blkno,
+				 int t_is_new)
+{
+	int ret, i;
+	int block_num = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
+	int blocksize = inode->i_sb->s_blocksize;
+	struct buffer_head **s_bhs, **t_bhs = NULL;
+
+	BUG_ON(s_blkno == t_blkno);
+
+	mlog(0, "cp bucket %llu to %llu, target is %d\n",
+	     s_blkno, t_blkno, t_is_new);
+
+	s_bhs = kzalloc(sizeof(struct buffer_head *) * block_num, GFP_NOFS);
+	ret = ocfs2_read_xattr_bucket(inode, s_blkno, s_bhs, 0);
+	if (ret)
+		goto out;
+
+	t_bhs = kzalloc(sizeof(struct buffer_head *) * block_num, GFP_NOFS);
+	ret = ocfs2_read_xattr_bucket(inode, t_blkno, t_bhs, t_is_new);
+	if (ret)
+		goto out;
+
+	for (i = 0; i < block_num; i++) {
+		ret = ocfs2_journal_access(handle, inode, t_bhs[i],
+					   OCFS2_JOURNAL_ACCESS_WRITE);
+		if (ret)
+			goto out;
+	}
+
+	for (i = 0; i < block_num; i++) {
+		memcpy(t_bhs[i]->b_data, s_bhs[i]->b_data, blocksize);
+		ocfs2_journal_dirty(handle, t_bhs[i]);
+	}
+
+out:
+	if (s_bhs) {
+		for (i = 0; i < block_num; i++)
+			brelse(s_bhs[i]);
+	}
+	kfree(s_bhs);
+
+	if (t_bhs) {
+		for (i = 0; i < block_num; i++)
+			brelse(t_bhs[i]);
+	}
+	kfree(t_bhs);
+
+	return ret;
+}
+
+/*
+ * Copy one xattr cluster from src_blk to to_blk.
+ * The to_blk will become the first bucket header of the cluster, so its
+ * xh_reserved1 will be initialized as the bucket num in the cluster.
+ */
+static int ocfs2_cp_xattr_cluster(struct inode *inode,
+				  handle_t *handle,
+				  struct buffer_head *first_bh,
+				  u64 src_blk,
+				  u64 to_blk,
+				  u32 *first_hash)
+{
+	int i, ret, credits;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	int block_num = ocfs2_clusters_to_blocks(inode->i_sb, 1);
+	int bucket_num = ocfs2_xattr_buckets_per_cluster(osb);
+	struct buffer_head *bh = NULL;
+	struct ocfs2_xattr_header *xh;
+
+	mlog(0, "cp xattrs from cluster %llu to %llu\n", src_blk, to_blk);
+
+	/*
+	 * We need to update the new cluster and 1 more for the update of
+	 * the 1st bucket of the previous extent rec.
+	 */
+	credits = block_num + 1;
+	ret = ocfs2_extend_trans(handle, credits);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_journal_access(handle, inode, first_bh,
+				   OCFS2_JOURNAL_ACCESS_CREATE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	for (i = 0; i < bucket_num; i++) {
+		ret = ocfs2_cp_xattr_bucket(inode, handle,
+					    src_blk, to_blk, 1);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		src_blk += ocfs2_blocks_per_xattr_bucket(inode->i_sb);
+		to_blk += ocfs2_blocks_per_xattr_bucket(inode->i_sb);
+	}
+
+	/* update the old bucket header. */
+	xh = (struct ocfs2_xattr_header *)first_bh->b_data;
+	le16_add_cpu(&xh->xh_reserved1, -bucket_num);
+
+	ocfs2_journal_dirty(handle, first_bh);
+
+	/* update the new bucket header. */
+	to_blk -= block_num;
+	ret = ocfs2_read_block(osb, to_blk, &bh, OCFS2_BH_CACHED, inode);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	xh = (struct ocfs2_xattr_header *)bh->b_data;
+	xh->xh_reserved1 = cpu_to_le16(bucket_num);
+
+	ocfs2_journal_dirty(handle, bh);
+
+	if (first_hash)
+		*first_hash = le32_to_cpu(xh->xh_entries[0].xe_name_hash);
+out:
+	brelse(bh);
+	return ret;
+}
+
+/*
+ * Move half of the xattrs in this cluster to the new cluster.
+ * This function should only be called when bucket size == cluster size.
+ * Otherwise ocfs2_mv_xattr_bucket_cross_cluster should be used instead.
+ */
+static inline int ocfs2_half_xattr_cluster(struct inode *inode,
+					   handle_t *handle,
+					   u64 prev_blk,
+					   u64 new_blk,
+					   u32 *first_hash)
+{
+	BUG_ON(OCFS2_XATTR_BUCKET_SIZE < OCFS2_SB(inode->i_sb)->s_clustersize);
+
+	/* Move half of the xattr in start_blk to the next bucket. */
+	return  ocfs2_half_xattr_bucket(inode, handle, prev_blk,
+					new_blk, first_hash, 1);
+}
+
+/*
+ * This is a new separate cluster, we will move some xattrs in the previous
+ * cluster to it. v_start will be set as the first name hash value in this
+ * new cluster so that it can be used as e_cpos during tree insertion and
+ * don't collide with our original b-tree operations. first_bh and header_bh
+ * will also be updated since they will be used in ocfs2_extend_xattr_bucket
+ * to extend the insert bucket.
+ *
+ * The problem is how much xattr should we move to the new one and when should
+ * we update first_bh and header_bh?
+ * 1. If cluster size > bucket size, that means the previous cluster has more
+ *    than 1 bucket, so just move half nums of bucket into the new cluster and
+ *    update the first_bh and header_bh if the insert bucket has been moved
+ *    to the new cluster.
+ * 2. If cluster_size == bucket_size:
+ *    a) If the previous extent rec has more than one cluster and the insert
+ *       place isn't in the last cluster, copy the entire last cluster to the
+ *       new one. This time, we don't need to upate the first_bh and header_bh
+ *       since they will not be moved into the new cluster.
+ *    b) Otherwise, move the bottom half of the xattrs in the last cluster into
+ *       the new one. And we set the extend flag to zero if the insert place is
+ *       moved into the new allocated cluster since no extend is needed.
+ */
+static int ocfs2_adjust_xattr_cross_cluster(struct inode *inode,
+					    handle_t *handle,
+					    struct buffer_head **first_bh,
+					    struct buffer_head **header_bh,
+					    u64 new_blk,
+					    u64 prev_blk,
+					    u32 prev_clusters,
+					    u32 *v_start,
+					    int *extend)
+{
+	int ret = 0;
+	int bpc = ocfs2_clusters_to_blocks(inode->i_sb, 1);
+
+	mlog(0, "adjust xattrs from cluster %llu len %u to %llu\n",
+	     prev_blk, prev_clusters, new_blk);
+
+	if (ocfs2_xattr_buckets_per_cluster(OCFS2_SB(inode->i_sb)) > 1)
+		ret = ocfs2_mv_xattr_bucket_cross_cluster(inode,
+							  handle,
+							  first_bh,
+							  header_bh,
+							  new_blk,
+							  prev_blk,
+							  prev_clusters,
+							  v_start);
+	else {
+		u64 last_blk = prev_blk + bpc * (prev_clusters - 1);
+
+		if (prev_clusters > 1 && (*header_bh)->b_blocknr != last_blk)
+			ret = ocfs2_cp_xattr_cluster(inode, handle, *first_bh,
+						     last_blk, new_blk,
+						     v_start);
+		else {
+			ret = ocfs2_half_xattr_cluster(inode, handle,
+						       last_blk, new_blk,
+						       v_start);
+
+			if ((*header_bh)->b_blocknr == last_blk && extend)
+				*extend = 0;
+		}
+	}
+
+	return ret;
+}
+
+/*
+ * Add a new cluster for xattr storage.
+ *
+ * If the new cluster is contiguous with the previous one, it will be
+ * appended to the same extent record, and num_clusters will be updated.
+ *
+ * If not, we will insert a new extent for it and move some xattrs in
+ * the last cluster into the new allocated one.
+ * first_bh is the first block of the previous extent rec and header_bh
+ * indicates the bucket we will insert the new xattrs. They will be updated
+ * when the header_bh is moved into the new cluster.
+ */
+static int ocfs2_add_new_xattr_cluster(struct inode *inode,
+				       struct buffer_head *root_bh,
+				       struct buffer_head **first_bh,
+				       struct buffer_head **header_bh,
+				       u32 *num_clusters,
+				       u32 prev_cpos,
+				       u64 prev_blkno,
+				       int *extend)
+{
+	int ret, credits;
+	u16 bpc = ocfs2_clusters_to_blocks(inode->i_sb, 1);
+	u32 prev_clusters = *num_clusters;
+	u32 clusters_to_add = 1, bit_off, num_bits, v_start = 0;
+	u64 block;
+	handle_t *handle = NULL;
+	struct buffer_head *new_bh = NULL;
+	struct ocfs2_alloc_context *data_ac = NULL;
+	struct ocfs2_alloc_context *meta_ac = NULL;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_xattr_header *first_xh =
+			(struct ocfs2_xattr_header *)(*first_bh)->b_data;
+	struct ocfs2_xattr_block *xb =
+			(struct ocfs2_xattr_block *)root_bh->b_data;
+	struct ocfs2_xattr_tree_root *xb_root = &xb->xb_attrs.xb_root;
+	struct ocfs2_extent_list *root_el = &xb_root->xt_list;
+	enum ocfs2_extent_tree_type type = OCFS2_XATTR_TREE_EXTENT;
+
+	mlog(0, "Add new xattr cluster for %llu, previous xattr hash = %u, "
+	     "previous xattr blkno = %llu\n",
+	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
+	     prev_cpos, prev_blkno);
+
+	ret = ocfs2_lock_allocators(inode, root_bh, root_el,
+				    clusters_to_add, 0, &data_ac,
+				    &meta_ac, type, NULL);
+	if (ret) {
+		mlog_errno(ret);
+		goto leave;
+	}
+
+	credits = ocfs2_calc_extend_credits(osb->sb, root_el, clusters_to_add);
+	handle = ocfs2_start_trans(osb, credits);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		handle = NULL;
+		mlog_errno(ret);
+		goto leave;
+	}
+
+	ret = ocfs2_journal_access(handle, inode, root_bh,
+				   OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto leave;
+	}
+
+	ret = __ocfs2_claim_clusters(osb, handle, data_ac, 1,
+				     clusters_to_add, &bit_off, &num_bits);
+	if (ret < 0) {
+		if (ret != -ENOSPC)
+			mlog_errno(ret);
+		goto leave;
+	}
+
+	BUG_ON(num_bits > clusters_to_add);
+
+	block = ocfs2_clusters_to_blocks(osb->sb, bit_off);
+	mlog(0, "Allocating %u clusters at block %u for xattr in inode %llu\n",
+	     num_bits, bit_off, (unsigned long long)OCFS2_I(inode)->ip_blkno);
+
+	if (prev_blkno + prev_clusters * bpc == block &&
+	    le16_to_cpu(first_xh->xh_reserved1) +
+	    num_bits * ocfs2_xattr_buckets_per_cluster(osb) >
+	    le16_to_cpu(first_xh->xh_reserved1)) {
+		/*
+		 * If this cluster is contiguous with the old one and
+		 * adding this new cluster, we don't surpass the limit of
+		 * xh_reserved1, cool. We will let it be initialized
+		 * and used like other buckets in the previous cluster.
+		 * So add it as a contiguous one. The caller will handle
+		 * its init process.
+		 */
+		v_start = prev_cpos + prev_clusters;
+		*num_clusters = prev_clusters + clusters_to_add;
+		mlog(0, "Add contiguous %u clusters to previous extent rec.\n",
+		     clusters_to_add);
+	} else {
+		ret = ocfs2_adjust_xattr_cross_cluster(inode,
+						       handle,
+						       first_bh,
+						       header_bh,
+						       block,
+						       prev_blkno,
+						       prev_clusters,
+						       &v_start,
+						       extend);
+		if (ret) {
+			mlog_errno(ret);
+			goto leave;
+		}
+	}
+
+	mlog(0, "Insert %u clusters at block %llu for xattr at %u\n",
+	     num_bits, block, v_start);
+	ret = ocfs2_insert_extent(osb, handle, inode, root_bh,
+				  v_start, block, num_bits,
+				  0, meta_ac, type, NULL);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto leave;
+	}
+
+	ret = ocfs2_journal_dirty(handle, root_bh);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto leave;
+	}
+
+leave:
+	if (handle) {
+		ocfs2_commit_trans(osb, handle);
+		handle = NULL;
+	}
+	if (data_ac) {
+		ocfs2_free_alloc_context(data_ac);
+		data_ac = NULL;
+	}
+	if (meta_ac) {
+		ocfs2_free_alloc_context(meta_ac);
+		meta_ac = NULL;
+	}
+
+	brelse(new_bh);
+	mlog_exit(ret);
+	return ret;
+}
+
+/*
+ * Extend a new xattr bucket and mv the data to the end one by one.
+ * for the start_bh, move half of the xattr to the bucket after it.
+ */
+static int ocfs2_extend_xattr_bucket(struct inode *inode,
+				     struct buffer_head *first_bh,
+				     struct buffer_head *start_bh,
+				     u32 num_clusters)
+{
+	int ret, credits;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	u16 blk_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
+	u64 start_blk = start_bh->b_blocknr, end_blk;
+	u32 bucket_num = num_clusters * ocfs2_xattr_buckets_per_cluster(osb);
+	handle_t *handle;
+	struct ocfs2_xattr_header *first_xh =
+				(struct ocfs2_xattr_header *)first_bh->b_data;
+	u16 bucket = le16_to_cpu(first_xh->xh_reserved1);
+
+	mlog(0, "extend xattr bucket in %llu, xattr extend rec starting "
+	     "from %llu, len = %u\n", start_blk,
+	     (unsigned long long)first_bh->b_blocknr, num_clusters);
+
+	BUG_ON(bucket >= bucket_num);
+
+	end_blk = first_bh->b_blocknr + (bucket - 1) * blk_per_bucket;
+
+	/*
+	 * We will touch all the buckets after the start_bh(include it).
+	 * Add one more bucket and modify the first_bh.
+	 */
+	credits = end_blk - start_blk + 2 * blk_per_bucket + 1;
+	handle = ocfs2_start_trans(osb, credits);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		handle = NULL;
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_journal_access(handle, inode, first_bh,
+				   OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto commit;
+	}
+
+	while (end_blk != start_blk) {
+		ret = ocfs2_cp_xattr_bucket(inode, handle, end_blk,
+					    end_blk + blk_per_bucket, 0);
+		if (ret)
+			goto commit;
+		end_blk -= blk_per_bucket;
+	}
+
+	/* Move half of the xattr in start_blk to the next bucket. */
+	ret = ocfs2_half_xattr_bucket(inode, handle, start_blk,
+				      start_blk + blk_per_bucket, NULL, 0);
+
+	le16_add_cpu(&first_xh->xh_reserved1, 1);
+	ocfs2_journal_dirty(handle, first_bh);
+
+commit:
+	ocfs2_commit_trans(osb, handle);
+out:
+	return ret;
+}
+
+/*
+ * Add new xattr bucket in a extent record and adjust the buckets accordingly.
+ * xb_bh is the ocfs2_xattr_block and header_bh is one header of a bucket.
+ * We will move all the buckets starting from it to the next place. As for
+ * this one, half of its xattr will be moved to the next one.
+ */
+static int ocfs2_add_new_xattr_bucket(struct inode *inode,
+				      struct buffer_head *xb_bh,
+				      struct buffer_head *header_bh)
+{
+	struct ocfs2_xattr_header *first_xh = NULL;
+	struct buffer_head *first_bh = NULL;
+	struct ocfs2_xattr_block *xb =
+			(struct ocfs2_xattr_block *)xb_bh->b_data;
+	struct ocfs2_xattr_tree_root *xb_root = &xb->xb_attrs.xb_root;
+	struct ocfs2_extent_list *el = &xb_root->xt_list;
+	struct ocfs2_xattr_header *xh =
+			(struct ocfs2_xattr_header *)header_bh->b_data;
+	u32 name_hash = le32_to_cpu(xh->xh_entries[0].xe_name_hash);
+	struct super_block *sb = inode->i_sb;
+	struct ocfs2_super *osb = OCFS2_SB(sb);
+	int ret, bucket_num, extend = 1;
+	u64 p_blkno;
+	u32 e_cpos, num_clusters;
+
+	mlog(0, "Add new xattr bucket starting form %llu\n",
+	     (unsigned long long)header_bh->b_blocknr);
+	ret = ocfs2_xattr_get_bucket(inode, name_hash, &p_blkno, &e_cpos,
+				     &num_clusters, el);
+	if (ret)
+		goto out;
+
+	ret = ocfs2_read_block(osb, p_blkno,
+				&first_bh, OCFS2_BH_CACHED, inode);
+	if (ret)
+		goto out;
+
+	bucket_num = ocfs2_xattr_buckets_per_cluster(osb) * num_clusters;
+	first_xh = (struct ocfs2_xattr_header *)first_bh->b_data;
+
+	if (bucket_num == le16_to_cpu(first_xh->xh_reserved1)) {
+		ret = ocfs2_add_new_xattr_cluster(inode,
+						  xb_bh,
+						  &first_bh,
+						  &header_bh,
+						  &num_clusters,
+						  e_cpos,
+						  p_blkno,
+						  &extend);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+	}
+
+	if (extend)
+		ret = ocfs2_extend_xattr_bucket(inode,
+						first_bh,
+						header_bh,
+						num_clusters);
+	if (ret)
+		mlog_errno(ret);
+out:
+	brelse(first_bh);
+	return ret;
+}
+
+static void ocfs2_xattr_set_entry_normal(struct inode *inode,
+					 char *bucket,
+					 struct ocfs2_xattr_info *xi,
+					 struct ocfs2_xattr_search *xs,
+					 u32 name_hash,
+					 int local,
+					 int *is_empty)
+{
+	struct ocfs2_xattr_entry *last, *xe;
+	int name_len = strlen(xi->name);
+	struct ocfs2_xattr_header *xh = (struct ocfs2_xattr_header *)xs->base;
+	u16 count = le16_to_cpu(xh->xh_count);
+	size_t blocksize = inode->i_sb->s_blocksize;
+	void *val;
+	size_t offs, size, new_size;
+
+	last = &xh->xh_entries[count];
+	if (!xs->not_found) {
+		xe = xs->here;
+		offs = le16_to_cpu(xe->xe_name_offset);
+		val = xs->base + offs;
+		if (xe->xe_local)
+			size = OCFS2_XATTR_SIZE(name_len) +
+			OCFS2_XATTR_SIZE(le64_to_cpu(xe->xe_value_size));
+		else
+			size = OCFS2_XATTR_SIZE(name_len) +
+			OCFS2_XATTR_SIZE(OCFS2_XATTR_ROOT_SIZE);
+
+		/*
+		 * If the new value will be stored outside, xi->value has been
+		 * initalized as an empty ocfs2_xattr_value_root, and the same
+		 * goes with xi->value_len, so we can set new_size safely here.
+		 * See ocfs2_xattr_set_in_bucket.
+		 */
+		new_size = OCFS2_XATTR_SIZE(name_len) +
+			   OCFS2_XATTR_SIZE(xi->value_len);
+
+		le16_add_cpu(&xh->xh_name_value_len, -size);
+		if (xi->value) {
+			if (new_size > size)
+				goto set_new_name_value;
+
+			/*
+			 * We must make sure that the xattr_value_root exist in
+			 * the same block and if the old place doesn't meet with
+			 * our need, we have to alloc a new space in the bucket.
+			 */
+			if (!local && offs / blocksize !=
+				      (offs + new_size - 1) / blocksize)
+					goto set_new_name_value;
+
+			/* Now replace the old value with new one. */
+			if (local)
+				xe->xe_value_size = cpu_to_le64(xi->value_len);
+			else
+				xe->xe_value_size = 0;
+
+			memset(val + OCFS2_XATTR_SIZE(name_len), 0,
+			       size - OCFS2_XATTR_SIZE(name_len));
+			if (OCFS2_XATTR_SIZE(xi->value_len) > 0)
+				memcpy(val + OCFS2_XATTR_SIZE(name_len),
+				       xi->value, xi->value_len);
+
+			le16_add_cpu(&xh->xh_name_value_len, new_size);
+			xe->xe_local = local;
+			return;
+		} else {
+			/* Remove the old entry. */
+			last -= 1;
+			memmove(xe, xe + 1,
+				(void *)last - (void *)xe);
+			memset(last, 0, sizeof(struct ocfs2_xattr_entry));
+			le16_add_cpu(&xh->xh_count, -1);
+			if (xh->xh_count == 0 && is_empty)
+				*is_empty = 1;
+			return;
+		}
+	} else {
+		/* find a new entry for insert. */
+		int low = 0, high = count - 1, tmp;
+		struct ocfs2_xattr_entry *tmp_xe;
+
+		while (low <= high) {
+			tmp = (low + high) / 2;
+			tmp_xe = &xh->xh_entries[tmp];
+
+			if (name_hash > le32_to_cpu(tmp_xe->xe_name_hash))
+				low = tmp + 1;
+			else if (name_hash <
+				 le32_to_cpu(tmp_xe->xe_name_hash))
+				high = tmp - 1;
+			else
+				break;
+		}
+
+		xe = &xh->xh_entries[low];
+		if (low != count)
+			memmove(xe + 1, xe, (void *)last - (void *)xe);
+
+		le16_add_cpu(&xh->xh_count, 1);
+		memset(xe, 0, sizeof(struct ocfs2_xattr_entry));
+		xe->xe_name_hash = cpu_to_le32(name_hash);
+		xe->xe_name_len = name_len;
+		xe->xe_type = xi->name_index;
+	}
+
+set_new_name_value:
+	/* Insert the new name+value. */
+	size = OCFS2_XATTR_SIZE(name_len) + OCFS2_XATTR_SIZE(xi->value_len);
+	/*
+	 * We must make sure that the xattr_value_root
+	 * exist in the same block.
+	 */
+	offs = le16_to_cpu(xh->xh_offset);
+	if (!local) {
+		u16 val_start = offs - OCFS2_XATTR_ROOT_SIZE;
+
+		if (val_start >> inode->i_sb->s_blocksize_bits !=
+		    (offs - 1) >> inode->i_sb->s_blocksize_bits) {
+			offs = offs - offs % blocksize;
+			xh->xh_offset = cpu_to_le16(offs);
+		}
+	}
+	val = xs->base + offs - size;
+	xe->xe_name_offset = cpu_to_le16(offs - size);
+
+	memset(val + OCFS2_XATTR_SIZE(name_len) - OCFS2_XATTR_PAD,
+	       0, OCFS2_XATTR_PAD);
+	memcpy(val, xi->name, name_len);
+
+	memset(val + size - OCFS2_XATTR_PAD, 0, OCFS2_XATTR_PAD);
+	memcpy(val + OCFS2_XATTR_SIZE(name_len), xi->value, xi->value_len);
+	xe->xe_value_size = cpu_to_le64(xi->value_len);
+	xe->xe_local = local;
+	xs->here = xe;
+	le16_add_cpu(&xh->xh_offset, -size);
+	le16_add_cpu(&xh->xh_name_value_len, size);
+
+	return;
+}
+
+static int ocfs2_xattr_bucket_handle_journal(struct inode *inode,
+					     handle_t *handle,
+					     struct ocfs2_xattr_search *xs,
+					     struct buffer_head **bhs,
+					     u16 bh_num)
+{
+	int ret = 0, i, len, off, block_off, block_end;
+	struct ocfs2_xattr_entry *xe = xs->here;
+	struct ocfs2_xattr_header *xh =
+				(struct ocfs2_xattr_header *)xs->base;
+	u16 xh_count = le16_to_cpu(xh->xh_count);
+	size_t blocksize = inode->i_sb->s_blocksize;
+	char touched[OCFS2_XATTR_MAX_BLOCKS_PER_BUCKET];
+
+	memset(touched, 0, sizeof(touched));
+
+	/*
+	 * First calculate all the blocks we should journal_access
+	 * and journal_dirty. The first block should always be touched.
+	 */
+	touched[0] = 1;
+
+	/* calc the data first. */
+	off = le16_to_cpu(xe->xe_name_offset);
+	block_off = off >> inode->i_sb->s_blocksize_bits;
+	len = OCFS2_XATTR_SIZE(xe->xe_name_len);
+	if (xe->xe_local)
+		len += OCFS2_XATTR_SIZE(le64_to_cpu(xe->xe_value_size));
+	else
+		len += OCFS2_XATTR_ROOT_SIZE;
+	off += len - 1;
+	block_end = off >> inode->i_sb->s_blocksize_bits;
+	for (i = block_off; i <= block_end; i++)
+		touched[i] = 1;
+
+	/* Now the xe_entry. */
+	off = (char *)xe - (char *)xh;
+	block_off = off >> inode->i_sb->s_blocksize_bits;
+	len = ((char *)&xh->xh_entries[xh_count]) - (char *)xe;
+	block_end = (off + len - 1) >> inode->i_sb->s_blocksize_bits;
+	for (i = block_off; i <= block_end; i++)
+		touched[i] = 1;
+
+	for (i = 0; i < bh_num; i++) {
+		if (!touched[i])
+			continue;
+
+		ret = ocfs2_journal_access(handle, inode, bhs[i],
+					   OCFS2_JOURNAL_ACCESS_WRITE);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+	}
+
+	for (i = 0; i < bh_num; i++) {
+		if (!touched[i])
+			continue;
+
+		memcpy(bhs[i]->b_data, xs->base + i * blocksize, blocksize);
+		ret = ocfs2_journal_dirty(handle, bhs[i]);
+		if (ret)
+			mlog_errno(ret);
+	}
+out:
+	return ret;
+}
+
+static int ocfs2_xattr_set_entry_in_bucket(struct inode *inode,
+					   struct ocfs2_xattr_info *xi,
+					   struct ocfs2_xattr_search *xs,
+					   u32 name_hash,
+					   int local,
+					   int *bucket_empty)
+{
+	int i, ret;
+	handle_t *handle = NULL;
+	struct buffer_head **bhs = NULL;
+	u16 blk_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
+	size_t blocksize = inode->i_sb->s_blocksize;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	u64 blk = xs->header_bh->b_blocknr;
+	char *buf;
+
+	mlog(0, "Set xattr entry len = %d index = %d in bucket %llu\n",
+	     xi->value_len, xi->name_index, blk);
+
+	bhs = kcalloc(blk_per_bucket, sizeof(struct buffer_head *), GFP_NOFS);
+	if (!bhs)
+		return -ENOMEM;
+
+	ret = ocfs2_read_blocks(osb, blk, blk_per_bucket,
+				bhs, OCFS2_BH_CACHED, inode);
+	if (ret)
+		goto out;
+
+	if (!xs->base) {
+		/* we should already set xs->base if we have found the xattr. */
+		BUG_ON(!xs->not_found);
+
+		if (blocksize < OCFS2_XATTR_BUCKET_SIZE) {
+			/*
+			 * This is a new entry and we haven't find it before,
+			 * So base isn't set in entry_find.
+			 */
+			xs->base = kmalloc(OCFS2_XATTR_BUCKET_SIZE, GFP_NOFS);
+			if (!xs->base) {
+				ret = -ENOMEM;
+				goto out;
+			}
+			xs->alloc_base = 1;
+
+			buf = xs->base;
+			for (i = 0; i < blk_per_bucket; i++, buf += blocksize)
+				memcpy(buf, bhs[i]->b_data, blocksize);
+		} else
+			xs->base = bhs[0]->b_data;
+	}
+
+	handle = ocfs2_start_trans(osb, blk_per_bucket);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		handle = NULL;
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ocfs2_xattr_set_entry_normal(inode, xs->base, xi, xs,
+				     name_hash, local, bucket_empty);
+
+	/*Only_access and dirty the blocks we have touched in set xattr. */
+	ret = ocfs2_xattr_bucket_handle_journal(inode, handle, xs,
+						bhs, blk_per_bucket);
+	if (ret)
+		mlog_errno(ret);
+out:
+	ocfs2_commit_trans(osb, handle);
+
+	if (bhs) {
+		for (i = 0; i < blk_per_bucket; i++)
+			brelse(bhs[i]);
+		kfree(bhs);
+	}
+
+	mlog_exit(ret);
+	return ret;
+}
+
+static int ocfs2_xattr_value_update_size(struct inode *inode,
+				    struct buffer_head *xe_bh,
+				    struct ocfs2_xattr_entry *xe,
+				    u64 new_size)
+{
+	int ret;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	handle_t *handle = NULL;
+
+	handle = ocfs2_start_trans(osb, 1);
+	if (handle == NULL) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_journal_access(handle, inode, xe_bh,
+				   OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	xe->xe_value_size = cpu_to_le64(new_size);
+
+	ret = ocfs2_journal_dirty(handle, xe_bh);
+	if (ret < 0)
+		mlog_errno(ret);
+
+out_commit:
+	ocfs2_commit_trans(osb, handle);
+out:
+	return ret;
+}
+
+static int ocfs2_xattr_bucket_value_truncate(struct inode *inode,
+					     struct buffer_head *header_bh,
+					     int xe_off,
+					     int len,
+					     char *new_xe,
+					     char *new_xv)
+{
+	int ret, offset;
+	u64 value_blk;
+	struct buffer_head *value_bh = NULL, *xe_bh = NULL;
+	struct ocfs2_xattr_value_root *xv;
+	struct ocfs2_xattr_entry *xe;
+	struct ocfs2_xattr_header *xh =
+			(struct ocfs2_xattr_header *)header_bh->b_data;
+	size_t blocksize = inode->i_sb->s_blocksize;
+
+	if (blocksize == OCFS2_XATTR_BUCKET_SIZE) {
+		xe_bh = header_bh;
+		get_bh(xe_bh);
+		xe = &xh->xh_entries[xe_off];
+	} else {
+		xe = ocfs2_get_xe_in_bucket(inode, header_bh,
+					    &xe_bh, xe_off);
+		if (!xe) {
+			ret = -EIO;
+			goto out;
+		}
+		if (!xe_bh) {
+			xe_bh = header_bh;
+			get_bh(xe_bh);
+		}
+	}
+
+	BUG_ON(!xe || xe->xe_local);
+
+	offset = le16_to_cpu(xe->xe_name_offset) +
+		 OCFS2_XATTR_SIZE(xe->xe_name_len);
+
+	value_blk = offset / blocksize;
+
+	/* We don't allow ocfs2_xattr_value to be stored in different block. */
+	BUG_ON(value_blk != (offset + OCFS2_XATTR_ROOT_SIZE - 1) / blocksize);
+	value_blk += header_bh->b_blocknr;
+
+	ret = ocfs2_read_block(OCFS2_SB(inode->i_sb), value_blk,
+			       &value_bh, OCFS2_BH_CACHED, inode);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	xv = (struct ocfs2_xattr_value_root *)
+		(value_bh->b_data + offset % blocksize);
+
+	mlog(0, "truncate %u in xattr bucket %llu to %d bytes.\n",
+	     xe_off, (unsigned long long)header_bh->b_blocknr, len);
+	ret = ocfs2_xattr_value_truncate(inode, value_bh, xv, len);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_xattr_value_update_size(inode, xe_bh, xe, len);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	if (new_xe && new_xe != (char *)xe)
+		memcpy(new_xe, xe, sizeof(struct ocfs2_xattr_entry));
+	if (new_xv && new_xv != (char *)xv)
+		memcpy(new_xv, xv, OCFS2_XATTR_ROOT_SIZE);
+out:
+	brelse(xe_bh);
+	brelse(value_bh);
+	return ret;
+}
+
+static int ocfs2_xattr_bucket_value_truncate_xs(struct inode *inode,
+						struct ocfs2_xattr_search *xs,
+						int len)
+{
+	int ret, offset;
+	struct ocfs2_xattr_entry *xe = xs->here;
+	struct ocfs2_xattr_header *xh = (struct ocfs2_xattr_header *)xs->base;
+	u16 val_offset = le16_to_cpu(xe->xe_name_offset) +
+			 OCFS2_XATTR_SIZE(xe->xe_name_len);
+
+	BUG_ON(!xs->base || !xe || xe->xe_local);
+
+	offset = xe - xh->xh_entries;
+	ret = ocfs2_xattr_bucket_value_truncate(inode, xs->header_bh,
+						offset, len, (char *)xe,
+						xs->base + val_offset);
+	if (ret)
+		mlog_errno(ret);
+
+	return ret;
+}
+
+static int ocfs2_xattr_bucket_set_value_outside(struct inode *inode,
+						struct ocfs2_xattr_search *xs,
+						char *val,
+						int value_len)
+{
+	int offset;
+	struct ocfs2_xattr_value_root *xv;
+	struct ocfs2_xattr_entry *xe = xs->here;
+
+	BUG_ON(!xs->base || !xe || xe->xe_local);
+
+	offset = le16_to_cpu(xe->xe_name_offset) +
+		 OCFS2_XATTR_SIZE(xe->xe_name_len);
+
+	xv = (struct ocfs2_xattr_value_root *)(xs->base + offset);
+
+	return __ocfs2_xattr_set_value_outside(inode, xv, val, value_len);
+}
+
+/*
+ * Remove the xattr bucket pointed by bucket_bh.
+ * All the buckets after it in the same xattr extent rec will be
+ * move forward one by one.
+ */
+static int ocfs2_rm_xattr_bucket(struct inode *inode,
+				 struct buffer_head *first_bh,
+				 struct buffer_head *bucket_bh)
+{
+	int ret = 0, credits;
+	struct ocfs2_xattr_header *xh =
+				(struct ocfs2_xattr_header *)first_bh->b_data;
+	u16 bucket_num = le16_to_cpu(xh->xh_reserved1);
+	u64 end, start = bucket_bh->b_blocknr;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	handle_t *handle;
+	u16 blk_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
+
+	end = first_bh->b_blocknr + (bucket_num - 1) * blk_per_bucket;
+
+	mlog(0, "rm xattr bucket %llu\n",
+	     (unsigned long long)bucket_bh->b_blocknr);
+	/*
+	 * We need to update the first xattr_header and all the buckets starting
+	 * from start in this xattr rec.
+	 *
+	 * XXX: Should we empty the old last bucket here?
+	 */
+	credits = 1 + end -start;
+	handle = ocfs2_start_trans(osb, credits);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		mlog_errno(ret);
+		return ret;
+	}
+
+	ret = ocfs2_journal_access(handle, inode, first_bh,
+				   OCFS2_JOURNAL_ACCESS_CREATE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+
+	while (start < end) {
+		ret = ocfs2_cp_xattr_bucket(inode, handle,
+					    start + blk_per_bucket,
+					    start, 0);
+		if (ret) {
+			mlog_errno(ret);
+			goto out_commit;
+		}
+		start += blk_per_bucket;
+	}
+
+	/* update the first_bh. */
+	xh->xh_reserved1 = cpu_to_le16(bucket_num - 1);
+	ocfs2_journal_dirty(handle, first_bh);
+
+out_commit:
+	ocfs2_commit_trans(osb, handle);
+	return ret;
+}
+
+static int ocfs2_rm_xattr_cluster(struct inode *inode,
+				  struct buffer_head *root_bh,
+				  u64 blkno,
+				  u32 cpos,
+				  u32 len)
+{
+	int ret;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct inode *tl_inode = osb->osb_tl_inode;
+	handle_t *handle;
+	struct ocfs2_xattr_block *xb =
+			(struct ocfs2_xattr_block *)root_bh->b_data;
+	struct ocfs2_extent_list *root_el = &xb->xb_attrs.xb_root.xt_list;
+	struct ocfs2_alloc_context *meta_ac = NULL;
+	struct ocfs2_cached_dealloc_ctxt dealloc;
+
+	ocfs2_init_dealloc_ctxt(&dealloc);
+
+	mlog(0, "rm xattr extent rec at %u len = %u, start from %llu\n",
+	     cpos, len, (unsigned long long)blkno);
+
+	ret = ocfs2_lock_allocators(inode, root_bh, root_el,
+				    0, 1, NULL, &meta_ac,
+				    OCFS2_XATTR_TREE_EXTENT, NULL);
+	if (ret) {
+		mlog_errno(ret);
+		return ret;
+	}
+
+	mutex_lock(&tl_inode->i_mutex);
+
+	if (ocfs2_truncate_log_needs_flush(osb)) {
+		ret = __ocfs2_flush_truncate_log(osb);
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto out;
+		}
+	}
+
+	handle = ocfs2_start_trans(osb, OCFS2_REMOVE_EXTENT_CREDITS);
+	if (handle == NULL) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_journal_access(handle, inode, root_bh,
+				   OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	ret = ocfs2_remove_extent(inode, root_bh, cpos, len, handle, meta_ac,
+				  &dealloc, OCFS2_XATTR_TREE_EXTENT, NULL);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	le32_add_cpu(&xb->xb_attrs.xb_root.xt_clusters, -len);
+
+	ret = ocfs2_journal_dirty(handle, root_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	ret = ocfs2_truncate_log_append(osb, handle, blkno, len);
+	if (ret)
+		mlog_errno(ret);
+
+out_commit:
+	ocfs2_commit_trans(osb, handle);
+out:
+	ocfs2_schedule_truncate_log_flush(osb, 1);
+
+	mutex_unlock(&tl_inode->i_mutex);
+
+	if (meta_ac)
+		ocfs2_free_alloc_context(meta_ac);
+
+	ocfs2_run_deallocs(osb, &dealloc);
+
+	return ret;
+}
+
+static int ocfs2_xattr_bucket_shrink(struct inode *inode,
+				     struct ocfs2_xattr_info *xi,
+				     struct ocfs2_xattr_search *xs,
+				     u32 name_hash)
+{
+	int ret;
+	u32 e_cpos, num_clusters;
+	u64 p_blkno;
+	struct buffer_head *first_bh = NULL;
+	struct ocfs2_xattr_header *first_xh;
+	struct ocfs2_xattr_block *xb =
+			(struct ocfs2_xattr_block *)xs->xattr_bh->b_data;
+
+	BUG_ON(xs->header->xh_count != 0);
+
+	ret = ocfs2_xattr_get_bucket(inode, name_hash, &p_blkno,
+				     &e_cpos, &num_clusters,
+				     &xb->xb_attrs.xb_root.xt_list);
+
+	ret = ocfs2_read_block(OCFS2_SB(inode->i_sb), p_blkno,
+			       &first_bh, OCFS2_BH_CACHED, inode);
+	if (ret) {
+		mlog_errno(ret);
+		return ret;
+	}
+
+	ret = ocfs2_rm_xattr_bucket(inode, first_bh, xs->header_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	first_xh = (struct ocfs2_xattr_header *)first_bh->b_data;
+	if (first_xh->xh_reserved1 == 0)
+		ret = ocfs2_rm_xattr_cluster(inode, xs->xattr_bh,
+					     p_blkno, e_cpos,
+					     num_clusters);
+
+out:
+	brelse(first_bh);
+	return ret;
+}
+
+static int ocfs2_xattr_set_in_bucket(struct inode *inode,
+				     struct ocfs2_xattr_info *xi,
+				     struct ocfs2_xattr_search *xs)
+{
+	int ret, local = 1, bucket_empty = 0;
+	size_t value_len;
+	char *val = (char *)xi->value;
+	struct ocfs2_xattr_entry *xe = xs->here;
+	u32 name_hash = ocfs2_xattr_hash_by_name(xi->name_index, xi->name);
+
+	if (!xs->not_found && !xe->xe_local) {
+		/*
+		 * We need to truncate the xattr storage first.
+		 *
+		 * If both the old and new value are stored to
+		 * outside block, we only need to truncate
+		 * the storage and then set the value outside.
+		 *
+		 * If the new value should be stored within block,
+		 * we should free all the outside block first and
+		 * the modification to the xattr block will be done
+		 * by following steps.
+		 */
+		if (xi->value_len > OCFS2_XATTR_INLINE_SIZE)
+			value_len = xi->value_len;
+		else
+			value_len = 0;
+
+		ret = ocfs2_xattr_bucket_value_truncate_xs(inode, xs,
+							   value_len);
+		if (ret)
+			goto out;
+
+		if (value_len)
+			goto set_value_outside;
+	}
+
+	value_len = xi->value_len;
+	/* So we have to handle the inside block change now. */
+	if (value_len > OCFS2_XATTR_INLINE_SIZE) {
+		/*
+		 * If the new value will be stored outside of block,
+		 * initalize a new empty value root and insert it first.
+		 */
+		local = 0;
+		xi->value = &def_xv;
+		xi->value_len = OCFS2_XATTR_ROOT_SIZE;
+	}
+
+	ret = ocfs2_xattr_set_entry_in_bucket(inode, xi, xs, name_hash,
+					      local, &bucket_empty);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	if (value_len > OCFS2_XATTR_INLINE_SIZE) {
+		/* allocate the space now for the outside block storage. */
+		ret = ocfs2_xattr_bucket_value_truncate_xs(inode, xs,
+							   value_len);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+	} else {
+		if (bucket_empty)
+			ret = ocfs2_xattr_bucket_shrink(inode, xi,
+							xs, name_hash);
+		goto out;
+	}
+
+set_value_outside:
+	ret = ocfs2_xattr_bucket_set_value_outside(inode, xs, val, value_len);
+out:
+	return ret;
+}
+
+/* check whether the xattr bucket is filled up with the same hash value. */
+static int ocfs2_check_xattr_bucket_collision(struct inode *inode,
+					      struct buffer_head *header_bh)
+{
+	int ret = 0;
+	struct ocfs2_xattr_header *xh =
+				(struct ocfs2_xattr_header *)header_bh->b_data;
+	u16 count = le16_to_cpu(xh->xh_count);
+	struct buffer_head *xe_bh = NULL;
+	struct ocfs2_xattr_entry *xe;
+
+	xe = ocfs2_get_xe_in_bucket(inode, header_bh, &xe_bh, count - 1);
+	if (!xe)
+		return -EIO;
+
+	if (xe->xe_name_hash == xh->xh_entries[0].xe_name_hash) {
+		mlog(ML_ERROR, "Too much hash collision in xattr bucket %llu, "
+		     "hash = %u\n", (unsigned long long)header_bh->b_blocknr,
+		      le32_to_cpu(xe->xe_name_hash));
+		ret = -ENOSPC;
+	}
+
+	brelse(xe_bh);
+	return ret;
+}
+
+static int ocfs2_xattr_set_entry_index_block(struct inode *inode,
+					     struct ocfs2_xattr_info *xi,
+					     struct ocfs2_xattr_search *xs)
+{
+	struct ocfs2_xattr_header *xh;
+	struct ocfs2_xattr_entry *xe;
+	u16 count, header_size;
+	size_t free, max_free, need, old;
+	size_t value_size = 0, name_len = strlen(xi->name);
+	int ret, allocation = 0, new_outside = 0;
+
+	mlog_entry("Set xattr %s in xattr index block\n", xi->name);
+
+try_again:
+	xh = xs->header;
+	count = le16_to_cpu(xh->xh_count);
+	header_size = sizeof(struct ocfs2_xattr_header) +
+			count * sizeof(struct ocfs2_xattr_entry);
+	free = le16_to_cpu(xh->xh_offset) - header_size;
+	max_free = OCFS2_XATTR_BUCKET_SIZE -
+		le16_to_cpu(xh->xh_name_value_len) - header_size;
+
+	if (xi->value && xi->value_len > OCFS2_XATTR_INLINE_SIZE) {
+		new_outside = 1;
+		value_size = OCFS2_XATTR_ROOT_SIZE;
+	} else if (xi->value)
+		value_size = OCFS2_XATTR_SIZE(xi->value_len);
+
+	if (xs->not_found)
+		need = sizeof(struct ocfs2_xattr_entry) +
+			OCFS2_XATTR_SIZE(name_len) + value_size;
+	else {
+		need = value_size + OCFS2_XATTR_SIZE(name_len);;
+
+		/*
+		 * We only replace the old value if the new length is smaller
+		 * than the old one. Otherwise we will allocate new space in the
+		 * bucket to store it.
+		 *
+		 * If the new value will be stored outside and the old value
+		 * is an in-bucket xattr, there are some cases that old space
+		 * isn't suitable(e.g, the space is cross-block and the new
+		 * xattr value root can't be stored in the same block),
+		 * so calculate "need" in this case.
+		 */
+		xe = xs->here;
+		if (xe->xe_local)
+			old = OCFS2_XATTR_SIZE(le64_to_cpu(xe->xe_value_size));
+		else
+			old = OCFS2_XATTR_SIZE(OCFS2_XATTR_ROOT_SIZE);
+
+		if (old >= value_size && (!new_outside || !xe->xe_local))
+			need = 0;
+	}
+
+	mlog(0, "xs->not_found = %d, in xattr bucket %llu: free = %d, "
+	     "need = %d, max_free = %d\n", xs->not_found,
+	     (unsigned long long)xs->header_bh->b_blocknr,
+	     free, need, max_free);
+
+	if (free < need) {
+		if (need <= max_free) {
+			/*
+			 * We can create the space by packing. Since only the
+			 * name/value will be moved, the xe shouldn't be changed
+			 * in xs.
+			 */
+			ret = ocfs2_defrag_xattr_bucket(inode, xs->header_bh,
+							xs->base, &free);
+			if (ret) {
+				mlog_errno(ret);
+				goto out;
+			}
+
+			if (free >= need)
+				goto xattr_set;
+
+			mlog(0, "Can't get enough space for xattr insert by "
+			     "defragment. Need %u bytes, but we have %d, so "
+			     "allocate new clusters for it.\n", need, free);
+		}
+
+		/*
+		 * We have to add new buckets or clusters and one
+		 * allocation should leave us enough space for insert.
+		 */
+		BUG_ON(allocation);
+
+		/*
+		 * We do not allow for overlapping ranges between buckets. And
+		 * the maximum number of collisions we will allow for then is
+		 * one bucket's worth, so check it here whether we need to
+		 * add a new bucket for the insert.
+		 */
+		ret = ocfs2_check_xattr_bucket_collision(inode, xs->header_bh);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		ret = ocfs2_add_new_xattr_bucket(inode,
+						 xs->xattr_bh,
+						 xs->header_bh);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		brelse(xs->header_bh);
+		xs->header_bh = NULL;
+		if (xs->alloc_base) {
+			kfree(xs->base);
+			xs->base = NULL;
+			xs->alloc_base = 0;
+		}
+		ret = ocfs2_xattr_index_block_find(inode, xs->xattr_bh,
+						   xi->name_index,
+						   xi->name, xs);
+		if (ret && ret != -ENODATA)
+			goto out;
+		xs->not_found = ret;
+		allocation = 1;
+		goto try_again;
+	}
+
+xattr_set:
+	ret = ocfs2_xattr_set_in_bucket(inode, xi, xs);
+out:
+	mlog_exit(ret);
+	return ret;
+}
+
+static int ocfs2_delete_xattr_in_bucket(struct inode *inode,
+					struct buffer_head *header_bh,
+					struct ocfs2_xattr_header *xh,
+					void *para)
+{
+	int ret = 0;
+	u16 i, count = le16_to_cpu(xh->xh_count);
+	struct ocfs2_xattr_entry *xe;
+
+
+	for (i = 0; i < count; i++) {
+		xe = &xh->xh_entries[i];
+		if (xe->xe_local)
+			continue;
+
+		ret = ocfs2_xattr_bucket_value_truncate(inode,
+							header_bh,
+							i, 0,
+							NULL,
+							NULL);
+		if (ret) {
+			mlog_errno(ret);
+			break;
+		}
+	}
+
+	return ret;
+}
+
+static int ocfs2_delete_xattr_index_block(struct inode *inode,
+					  struct buffer_head *xb_bh)
+{
+	struct ocfs2_xattr_block *xb =
+			(struct ocfs2_xattr_block *)xb_bh->b_data;
+	struct ocfs2_extent_list *el = &xb->xb_attrs.xb_root.xt_list;
+	int ret = 0;
+	u32 name_hash = UINT_MAX, e_cpos, num_clusters;
+	u64 p_blkno;
+
+	if (le16_to_cpu(el->l_next_free_rec) == 0)
+		return 0;
+
+	while (name_hash > 0) {
+		ret = ocfs2_xattr_get_bucket(inode, name_hash, &p_blkno,
+					     &e_cpos, &num_clusters, el);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		ret = ocfs2_iterate_xattr_buckets(inode, p_blkno, num_clusters,
+						  ocfs2_delete_xattr_in_bucket,
+						  NULL);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		ret = ocfs2_rm_xattr_cluster(inode, xb_bh,
+					     p_blkno, e_cpos, num_clusters);
+		if (ret) {
+			mlog_errno(ret);
+			break;
+		}
+
+		if (e_cpos == 0)
+			break;
+
+		name_hash = e_cpos - 1;
+	}
+
+out:
+	return ret;
+}
diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
index 6e17242..84484ca 100644
--- a/fs/ocfs2/xattr.h
+++ b/fs/ocfs2/xattr.h
@@ -56,7 +56,9 @@ struct ocfs2_xattr_header {
 	__le16	xh_count;
 	__le16	xh_reserved1;
 	__le32	xh_csum;
-	__le16  xh_reserved2[4];
+	__le16  xh_offset;
+	__le16  xh_name_value_len;
+	__le16  xh_reserved2[2];
 	struct ocfs2_xattr_entry	xh_entries[0];
 };
 
@@ -119,4 +121,5 @@ extern int ocfs2_xattr_remove(struct inode *inode, struct buffer_head *di_bh);
 
 extern struct xattr_handler *ocfs2_xattr_handlers[];
 
+void ocfs2_init_xattr_value_root(void);
 #endif /* OCFS2_XATTR_H */
-- 
1.5.4.GIT
