From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 18 Aug 2008 17:38:50 +0800
Subject: [Ocfs2-devel] [PATCH 11/16] Add xattr bucket iteration for large
	numbers of EAs.
In-Reply-To: <48A929A4.90103@oracle.com>
References: <48A929A4.90103@oracle.com>
Message-ID: <1219052334-10415-9-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We use bucket in ocfs2 to store large numbers of EAs, and list
xattrs will iterate all the buckets and list all the names one by
one. This patch add the iteration for the xattr bucket. For how
xattr bucket looks like and their disk layout, please see
http://oss.oracle.com/osswiki/OCFS2/DesignDocs/IndexedEATrees.

A new abstration of ocfs2_xattr_bucket is added. It records bhs
in this bucket and ocfs2_xattr_header for quick refrence.

Now ocfs2_iterate_xattr_buckets will only read the bhs of the bucket,
creat a ocfs2_xattr_bucket and let the caller do all the rest of the work.

According to the discussion with Mark, now all the xe_entry will only
exist in the 1st block of the bucket and name/value pair will not spread
multiple blocks, so the efficiency will be improved and the code is much
easier.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/ocfs2_fs.h |   35 +++++++-
 fs/ocfs2/xattr.c    |  255 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ocfs2/xattr.h    |    9 ++
 3 files changed, 293 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 72fce63..f579039 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -752,8 +752,13 @@ struct ocfs2_xattr_header {
 	__le16	xh_count;                       /* contains the count of how
 						   many records are in the
 						   local xattr storage. */
-	__le16	xh_reserved1;
-	__le32	xh_reserved2;
+	__le16	xh_free_start;                  /* current offset for storing
+						   xattr. */
+	__le16	xh_name_value_len;              /* total length of name/value
+						   length in this bucket. */
+	__le16	xh_num_buckets;                 /* bucket nums in one extent
+						   record, only valid in the
+						   first bucket. */
 	__le64  xh_csum;
 	struct ocfs2_xattr_entry xh_entries[0]; /* xattr entry list. */
 };
@@ -790,6 +795,10 @@ struct ocfs2_xattr_tree_root {
 #define OCFS2_XATTR_SIZE(size)	(((size) + OCFS2_XATTR_ROUND) & \
 				~(OCFS2_XATTR_ROUND))
 
+#define OCFS2_XATTR_BUCKET_SIZE			4096
+#define OCFS2_XATTR_MAX_BLOCKS_PER_BUCKET 	(OCFS2_XATTR_BUCKET_SIZE \
+						 / OCFS2_MIN_BLOCKSIZE)
+
 /*
  * On disk structure for xattr block.
  */
@@ -960,6 +969,17 @@ static inline u64 ocfs2_backup_super_blkno(struct super_block *sb, int index)
 	return 0;
 
 }
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
 #else
 static inline int ocfs2_fast_symlink_chars(int blocksize)
 {
@@ -1043,6 +1063,17 @@ static inline uint64_t ocfs2_backup_super_blkno(int blocksize, int index)
 
 	return 0;
 }
+
+static inline int ocfs2_xattr_recs_per_xb(int blocksize)
+{
+	int size;
+
+	size = blocksize -
+		offsetof(struct ocfs2_xattr_block,
+			 xb_attrs.xb_root.xt_list.l_recs);
+
+	return size / sizeof(struct ocfs2_extent_rec);
+}
 #endif  /* __KERNEL__ */
 
 
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 3b3d7db..185847f 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -52,6 +52,7 @@
 #include "suballoc.h"
 #include "uptodate.h"
 #include "buffer_head_io.h"
+#include "super.h"
 #include "xattr.h"
 
 
@@ -60,6 +61,11 @@ struct ocfs2_xattr_def_value_root {
 	struct ocfs2_extent_rec		er;
 };
 
+struct ocfs2_xattr_bucket {
+	struct buffer_head *bhs[OCFS2_XATTR_MAX_BLOCKS_PER_BUCKET];
+	struct ocfs2_xattr_header *xh;
+};
+
 #define OCFS2_XATTR_ROOT_SIZE	(sizeof(struct ocfs2_xattr_def_value_root))
 #define OCFS2_XATTR_INLINE_SIZE	80
 
@@ -115,6 +121,11 @@ struct ocfs2_xattr_search {
 	int not_found;
 };
 
+static int ocfs2_xattr_tree_list_index_block(struct inode *inode,
+					struct ocfs2_xattr_tree_root *xt,
+					char *buffer,
+					size_t buffer_size);
+
 static inline struct xattr_handler *ocfs2_xattr_handler(int name_index)
 {
 	struct xattr_handler *handler = NULL;
@@ -499,7 +510,7 @@ static int ocfs2_xattr_block_list(struct inode *inode,
 				  size_t buffer_size)
 {
 	struct buffer_head *blk_bh = NULL;
-	struct ocfs2_xattr_header *header = NULL;
+	struct ocfs2_xattr_block *xb;
 	int ret = 0;
 
 	if (!di->i_xattr_loc)
@@ -519,10 +530,17 @@ static int ocfs2_xattr_block_list(struct inode *inode,
 		goto cleanup;
 	}
 
-	header = &((struct ocfs2_xattr_block *)blk_bh->b_data)->
-		 xb_attrs.xb_header;
+	xb = (struct ocfs2_xattr_block *)blk_bh->b_data;
 
-	ret = ocfs2_xattr_list_entries(inode, header, buffer, buffer_size);
+	if (!(le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED)) {
+		struct ocfs2_xattr_header *header = &xb->xb_attrs.xb_header;
+		ret = ocfs2_xattr_list_entries(inode, header,
+					       buffer, buffer_size);
+	} else {
+		struct ocfs2_xattr_tree_root *xt = &xb->xb_attrs.xb_root;
+		ret = ocfs2_xattr_tree_list_index_block(inode, xt,
+						   buffer, buffer_size);
+	}
 cleanup:
 	brelse(blk_bh);
 
@@ -1939,3 +1957,232 @@ cleanup:
 	return ret;
 }
 
+/*
+ * Find the xattr extent rec which may contains name_hash.
+ * e_cpos will be the first name hash of the xattr rec.
+ * el must be the ocfs2_xattr_header.xb_attrs.xb_root.xt_list.
+ */
+static int ocfs2_xattr_get_rec(struct inode *inode,
+			       u32 name_hash,
+			       u64 *p_blkno,
+			       u32 *e_cpos,
+			       u32 *num_clusters,
+			       struct ocfs2_extent_list *el)
+{
+	int ret = 0, i;
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
+	brelse(eb_bh);
+	return ret;
+}
+
+typedef int (xattr_bucket_func)(struct inode *inode,
+				struct ocfs2_xattr_bucket *bucket,
+				void *para);
+
+static int ocfs2_iterate_xattr_buckets(struct inode *inode,
+				       u64 blkno,
+				       u32 clusters,
+				       xattr_bucket_func *func,
+				       void *para)
+{
+	int i, j, ret = 0;
+	int blk_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
+	u32 bpc = ocfs2_xattr_buckets_per_cluster(OCFS2_SB(inode->i_sb));
+	u32 num_buckets = clusters * bpc;
+	struct ocfs2_xattr_bucket bucket;
+
+	memset(&bucket, 0, sizeof(bucket));
+
+	mlog(0, "iterating xattr buckets in %u clusters starting from %llu\n",
+	     clusters, blkno);
+
+	for (i = 0; i < num_buckets; i++, blkno += blk_per_bucket) {
+		ret = ocfs2_read_blocks(OCFS2_SB(inode->i_sb),
+					blkno, blk_per_bucket,
+					bucket.bhs, OCFS2_BH_CACHED, inode);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		bucket.xh = (struct ocfs2_xattr_header *)bucket.bhs[0]->b_data;
+		/*
+		 * The real bucket num in this series of blocks is stored
+		 * in the 1st bucket.
+		 */
+		if (i == 0)
+			num_buckets = le16_to_cpu(bucket.xh->xh_num_buckets);
+
+		mlog(0, "iterating xattr bucket %llu\n", blkno);
+		if (func) {
+			ret = func(inode, &bucket, para);
+			if (ret) {
+				mlog_errno(ret);
+				break;
+			}
+		}
+
+		for (j = 0; j < blk_per_bucket; j++)
+			brelse(bucket.bhs[j]);
+		memset(&bucket, 0, sizeof(bucket));
+	}
+
+out:
+	for (j = 0; j < blk_per_bucket; j++)
+		brelse(bucket.bhs[j]);
+
+	return ret;
+}
+
+struct ocfs2_xattr_tree_list {
+	char *buffer;
+	size_t buffer_size;
+};
+
+static int ocfs2_xattr_bucket_get_name_value(struct inode *inode,
+					     struct ocfs2_xattr_header *xh,
+					     int index,
+					     int *block_off,
+					     int *new_offset)
+{
+	u16 name_offset;
+
+	if (index < 0 || index >= le16_to_cpu(xh->xh_count))
+		return -EINVAL;
+
+	name_offset = le16_to_cpu(xh->xh_entries[index].xe_name_offset);
+
+	*block_off = name_offset >> inode->i_sb->s_blocksize_bits;
+	*new_offset = name_offset % inode->i_sb->s_blocksize;
+
+	return 0;
+}
+
+static int ocfs2_list_xattr_bucket(struct inode *inode,
+				   struct ocfs2_xattr_bucket *bucket,
+				   void *para)
+{
+	int ret = 0;
+	struct ocfs2_xattr_tree_list *xl = (struct ocfs2_xattr_tree_list *)para;
+	size_t size;
+	int i, block_off, new_offset;
+
+	for (i = 0 ; i < le16_to_cpu(bucket->xh->xh_count); i++) {
+		struct ocfs2_xattr_entry *entry = &bucket->xh->xh_entries[i];
+		struct xattr_handler *handler =
+			ocfs2_xattr_handler(ocfs2_xattr_get_type(entry));
+
+		if (handler) {
+			ret = ocfs2_xattr_bucket_get_name_value(inode,
+								bucket->xh,
+								i,
+								&block_off,
+								&new_offset);
+			if (ret)
+				break;
+			size = handler->list(inode, xl->buffer, xl->buffer_size,
+					     bucket->bhs[block_off]->b_data +
+					     new_offset,
+					     entry->xe_name_len);
+			if (xl->buffer) {
+				if (size > xl->buffer_size)
+					return -ERANGE;
+				xl->buffer += size;
+			}
+			xl->buffer_size -= size;
+		}
+	}
+
+	return ret;
+}
+
+static int ocfs2_xattr_tree_list_index_block(struct inode *inode,
+					     struct ocfs2_xattr_tree_root *xt,
+					     char *buffer,
+					     size_t buffer_size)
+{
+	struct ocfs2_extent_list *el = &xt->xt_list;
+	int ret = 0;
+	u32 name_hash = UINT_MAX, e_cpos = 0, num_clusters = 0;
+	u64 p_blkno = 0;
+	struct ocfs2_xattr_tree_list xl = {
+		.buffer = buffer,
+		.buffer_size = buffer_size,
+	};
+
+	if (le16_to_cpu(el->l_next_free_rec) == 0)
+		return 0;
+
+	while (name_hash > 0) {
+		ret = ocfs2_xattr_get_rec(inode, name_hash, &p_blkno,
+					  &e_cpos, &num_clusters, el);
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
diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
index f565c64..a69c8aa 100644
--- a/fs/ocfs2/xattr.h
+++ b/fs/ocfs2/xattr.h
@@ -55,4 +55,13 @@ extern int ocfs2_xattr_set(struct inode *, int, const char *, const void *,
 extern int ocfs2_xattr_remove(struct inode *inode, struct buffer_head *di_bh);
 extern struct xattr_handler *ocfs2_xattr_handlers[];
 
+static inline u16 ocfs2_xattr_buckets_per_cluster(struct ocfs2_super *osb)
+{
+	return (1 << osb->s_clustersize_bits) / OCFS2_XATTR_BUCKET_SIZE;
+}
+
+static inline u16 ocfs2_blocks_per_xattr_bucket(struct super_block *sb)
+{
+	return OCFS2_XATTR_BUCKET_SIZE / (1 << sb->s_blocksize_bits);
+}
 #endif /* OCFS2_XATTR_H */
-- 
1.5.4.1
