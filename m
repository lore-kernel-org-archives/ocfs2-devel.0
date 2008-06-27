From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 27 Jun 2008 15:02:35 +0800
Subject: [Ocfs2-devel] [PATCH 12/15] Add xattr find process for xattr index
	btree.v2
In-Reply-To: <48648B3E.6050808@oracle.com>
Message-ID: <20080627070235.GA20375@tma-pc2.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We use bucket in ocfs2 to store large numbers of EAs, so when
we want to find a specified xattr, we do like this:
1. Use ocfs2_xattr_get_rec to find the xattr clusters.
2. Find the xattr bucket which may contain this xattr.
3. Iterate the bucket and find whether the xattr exist. In order
   to co-exist the code in ocfs2_xattr_block_get, we allocate
   a buffer and copy this bucket to the buffer if the xattr is
   found.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |  490 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 476 insertions(+), 14 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 9be7bc8..48efef5 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -112,13 +112,21 @@ struct ocfs2_xattr_search {
 	 * when extended attribute in inode, xattr_bh is equal to inode_bh.
 	 */
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
 static int ocfs2_xattr_tree_list_index_block(struct inode *inode,
 					struct ocfs2_xattr_tree_root *xt,
 					char *buffer,
@@ -754,12 +762,22 @@ static int ocfs2_xattr_block_get(struct inode *inode,
 
 	xs->xattr_bh = blk_bh;
 	xb = (struct ocfs2_xattr_block *)blk_bh->b_data;
-	xs->header = &xb->xb_attrs.xb_header;
-	xs->base = (void *)xs->header;
-	xs->end = (void *)(blk_bh->b_data) + blk_bh->b_size;
-	xs->here = xs->header->xh_entries;
 
-	ret = ocfs2_xattr_find_entry(name_index, name, xs);
+	if (!(le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED)) {
+		xs->header = &xb->xb_attrs.xb_header;
+		xs->base = (void *)xs->header;
+		xs->end = (void *)(blk_bh->b_data) + blk_bh->b_size;
+		xs->here = xs->header->xh_entries;
+
+		ret = ocfs2_xattr_find_entry(name_index, name, xs);
+	} else {
+		xs->header_bh = NULL;
+		xs->alloc_base = 0;
+		ret = ocfs2_xattr_index_block_find(inode, blk_bh,
+						   name_index,
+						   name, xs);
+	}
+
 	if (ret)
 		goto cleanup;
 	size = le64_to_cpu(xs->here->xe_value_size);
@@ -782,9 +800,13 @@ static int ocfs2_xattr_block_get(struct inode *inode,
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
 
@@ -1627,6 +1649,7 @@ static int ocfs2_xattr_block_find(struct inode *inode,
 {
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)xs->inode_bh->b_data;
 	struct buffer_head *blk_bh = NULL;
+	struct ocfs2_xattr_block *xb;
 	int ret = 0;
 
 	if (!di->i_xattr_loc)
@@ -1647,18 +1670,24 @@ static int ocfs2_xattr_block_find(struct inode *inode,
 	}
 
 	xs->xattr_bh = blk_bh;
-	xs->header = &((struct ocfs2_xattr_block *)blk_bh->b_data)->
-			xb_attrs.xb_header;
-	xs->base = (void *)xs->header;
-	xs->end = (void *)(blk_bh->b_data) + blk_bh->b_size;
-	xs->here = xs->header->xh_entries;
+	xb = (struct ocfs2_xattr_block *)blk_bh->b_data;
+
+	if (!(le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED)) {
+		xs->header = &xb->xb_attrs.xb_header;
+		xs->base = (void *)xs->header;
+		xs->end = (void *)(blk_bh->b_data) + blk_bh->b_size;
+		xs->here = xs->header->xh_entries;
+
+		ret = ocfs2_xattr_find_entry(name_index, name, xs);
+	} else
+		ret = ocfs2_xattr_index_block_find(inode, blk_bh,
+						   name_index,
+						   name, xs);
 
-	ret = ocfs2_xattr_find_entry(name_index, name, xs);
 	if (ret && ret != -ENODATA)
 		goto cleanup;
 	xs->not_found = ret;
 	return 0;
-
 cleanup:
 	if (blk_bh)
 		brelse(blk_bh);
@@ -1893,6 +1922,18 @@ cleanup:
 	return ret;
 }
 
+static inline u32 ocfs2_xattr_hash_by_name(struct inode *inode,
+					   int name_index,
+					   const char *suffix_name)
+{
+	struct xattr_handler *handler = ocfs2_xattr_handler(name_index);
+	char *prefix = handler->prefix;
+	int prefix_len = strlen(handler->prefix);
+
+	return ocfs2_xattr_name_hash(inode, prefix, prefix_len,
+				     (char *)suffix_name, strlen(suffix_name));
+}
+
 /*
  * Find the xattr extent rec which may contains name_hash.
  * e_cpos will be the first name hash of the xattr rec.
@@ -1959,6 +2000,427 @@ out:
 	return ret;
 }
 
+/*
+ * Get the xattr entry at offset in a bucket(starting from header_bh).
+ *
+ * The bh will be set as the block which contains this entry.
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
+	if (block_off == 0) {
+		xe = &xh->xh_entries[offset];
+		get_bh(header_bh);
+		*bh = header_bh;
+	} else {
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
+/* Get a range of bytes in the bucket and copy the bytes to store. */
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
+		else if (name_hash < le32_to_cpu(xe->xe_name_hash))
+			break;
+
+		cmp = name_index - xe->xe_type;
+		if (!cmp)
+			cmp = name_len - xe->xe_name_len;
+		if (cmp)
+			goto next;
+
+		/* now we have to compare the xattr name. */
+		xe_name = kzalloc(name_len, GFP_NOFS);
+		if (!xe_name) {
+			ret = -ENOMEM;
+			goto out;
+		}
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
+			ret = 0;
+			break;
+		}
+next:
+		brelse(xe_bh);
+		xe_bh = NULL;
+	}
+
+out:
+	brelse(xe_bh);
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
+ * the num of the valid buckets.
+ *
+ * Return the buffer_head this xattr should reside in. And if the xattr's
+ * hash is in the gap of 2 buckets, return the lower bucket.
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
+	struct buffer_head *lower_bh = NULL;
+	struct ocfs2_xattr_header *xh = NULL;
+	struct ocfs2_xattr_entry *xe = NULL;
+	u16 xh_count, xe_index = 0;
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
+			mlog_errno(ret);
+			goto out;
+		}
+
+		last_hash = le32_to_cpu(xe->xe_name_hash);
+		brelse(last_bh);
+
+		/* record lower_bh which may be the insert place. */
+		brelse(lower_bh);
+		lower_bh = bh;
+		bh = NULL;
+
+		if (name_hash > le32_to_cpu(xe->xe_name_hash)) {
+			low_bucket = bucket + 1;
+			continue;
+		}
+
+		/* the searched xattr should reside in this bucket if exists. */
+		ret = ocfs2_find_xe_in_bucket(inode, lower_bh,
+					      name_index, name, name_hash,
+					      &xe_index, &found);
+		break;
+	}
+
+	/*
+	 * Record the bucket we have found.
+	 * When the xattr's hash value is in the gap of 2 buckets, we will
+	 * always set it to the previous bucket so that it does't need to
+	 * move the xattr entries and speed up the insertion.
+	 * Here the "header" is initialized first as header_bh->b_data so that
+	 * the set function can use it to find the insert place.
+	 */
+	if (!lower_bh) {
+		/*
+		 * We can't find any bucket whose first name_hash is less
+		 * than the find name_hash.
+		 */
+		BUG_ON(bh->b_blocknr != p_blkno);
+		lower_bh = bh;
+		bh = NULL;
+	}
+	xs->header_bh = lower_bh;
+	xs->header = (struct ocfs2_xattr_header *)xs->header_bh->b_data;
+	lower_bh = NULL;
+	xs->base = NULL;
+
+	/*
+	 * Alloc buffer and get the xattr attribute if needed.
+	 * If the blocksize is equal to bucket size, we don't do allocation.
+	 */
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
+	brelse(lower_bh);
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
+	u32 name_hash = ocfs2_xattr_hash_by_name(inode, name_index, name);
+
+	if (le16_to_cpu(el->l_next_free_rec) == 0)
+		return -ENODATA;
+
+	mlog(0, "find xattr %s, hash = %u, index = %d in xattr tree\n",
+	     name, name_hash, name_index);
+
+	ret = ocfs2_xattr_get_rec(inode, name_hash, &p_blkno, &first_hash,
+				  &num_clusters, el);
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
 static int ocfs2_iterate_xattr_buckets(struct inode *inode,
 				       u64 blkno,
 				       u32 clusters,
-- 
1.5.4.GIT
