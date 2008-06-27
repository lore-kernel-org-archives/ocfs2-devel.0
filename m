From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 27 Jun 2008 15:02:54 +0800
Subject: [Ocfs2-devel] [PATCH 13/15] Enable xattr set in index btree.v2
In-Reply-To: <48648B3E.6050808@oracle.com>
Message-ID: <20080627070254.GA20381@tma-pc2.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The previous 2 patches add the ability of list/get xattr in buckets for ocfs2.
This patch enables ocfs2 to store large numbers of EAs.

The original design doc is written by Mark Fasheh, and it can be found in
http://oss.oracle.com/osswiki/OCFS2/DesignDocs/IndexedEATrees. Just some little
modifications to it.

First, because the bucket size is 4K, a new field named as xh_offset is added
in ocfs2_xattr_header to indicate the next valid name/value offset in abucket.
It is used when we store new EA name/value. With this field, we can find the
place more quickly and what's more, we don't need to sort the name/value every
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

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c | 2248 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 2237 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 48efef5..89c8c16 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -36,6 +36,7 @@
 #include <linux/mount.h>
 #include <linux/writeback.h>
 #include <linux/falloc.h>
+#include <linux/sort.h>
 
 #define MLOG_MASK_PREFIX ML_XATTR
 #include <cluster/masklog.h>
@@ -132,6 +133,13 @@ static int ocfs2_xattr_tree_list_index_block(struct inode *inode,
 					char *buffer,
 					size_t buffer_size);
 
+static int ocfs2_xattr_create_index_block(struct inode *inode,
+					  struct ocfs2_xattr_search *xs);
+
+static int ocfs2_xattr_set_entry_index_block(struct inode *inode,
+					     struct ocfs2_xattr_info *xi,
+					     struct ocfs2_xattr_search *xs);
+
 static inline struct xattr_handler *ocfs2_xattr_handler(int name_index)
 {
 	struct xattr_handler *handler = NULL;
@@ -801,12 +809,10 @@ static int ocfs2_xattr_block_get(struct inode *inode,
 	ret = size;
 cleanup:
 
-	if (xs->header_bh)
-		brelse(xs->header_bh);
+	brelse(xs->header_bh);
+	brelse(xs->xattr_bh);
 	if (xs->alloc_base)
 		kfree(xs->base);
-	if (xs->xattr_bh)
-		brelse(xs->xattr_bh);
 	return ret;
 }
 
@@ -1695,6 +1701,46 @@ cleanup:
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
 /*
  * ocfs2_xattr_block_set()
  *
@@ -1793,12 +1839,26 @@ out:
 			ocfs2_free_alloc_context(meta_ac);
 		if (ret < 0)
 			return ret;
+	} else
+		xblk = (struct ocfs2_xattr_block *)xs->xattr_bh->b_data;
+
+	if (!(le16_to_cpu(xblk->xb_flags) & OCFS2_XATTR_INDEXED)) {
+		/* Set extended attribute into external block */
+		ret = ocfs2_xattr_set_entry(inode, xi, xs, OCFS2_HAS_XATTR_FL,
+					    xattrsize);
+		if (!ret || ret != -ENOSPC)
+			goto end;
+
+		ret = ocfs2_xattr_create_index_block(inode, xs);
+		if (ret)
+			goto end;
 	}
 
-	/* Set extended attribute into external block */
-	ret = ocfs2_xattr_set_entry(inode, xi, xs, OCFS2_HAS_XATTR_FL,
-				    xattrsize);
+	ret = ocfs2_xattr_set_entry_index_block(inode, xi, xs);
+	if (!ret && xblk->xb_attrs.xb_root.xt_list.l_next_free_rec == 0)
+		ret = ocfs2_restore_xattr_block(inode, xs);
 
+end:
 	return ret;
 }
 
@@ -1914,10 +1974,11 @@ int ocfs2_xattr_set(struct inode *inode,
 	}
 cleanup:
 	ocfs2_inode_unlock(inode, 1);
-	if (di_bh)
-		brelse(di_bh);
-	if (xbs.xattr_bh)
-		brelse(xbs.xattr_bh);
+	brelse(di_bh);
+	brelse(xbs.xattr_bh);
+	brelse(xbs.header_bh);
+	if (xbs.alloc_base)
+		kfree(xbs.base);
 
 	return ret;
 }
@@ -2576,3 +2637,2168 @@ static int ocfs2_xattr_tree_list_index_block(struct inode *inode,
 out:
 	return ret;
 }
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
+/*
+ * When the ocfs2_xattr_block is filled up, new bucket will be created
+ * and all the xattr entries will be moved to the new bucket.
+ * Note: we need to sort the entries since they are not saved in order
+ * in the ocfs2_xattr_block.
+ */
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
+	int ret = 0;
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
+		xs->base = kmalloc(OCFS2_XATTR_BUCKET_SIZE, GFP_NOFS);
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
+	return ret;
+}
+
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
+	 * XXX:
+	 * Do we need this lock or should we use a new sem in xattr allocation?
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
+/*
+ * defrag a xattr bucket if we find that the bucket has some
+ * holes in beteen name/value pairs.
+ * We will move all the name/value pairs to the end of the bucket
+ * so that we can spare some space for insertion.
+ */
+static int ocfs2_defrag_xattr_bucket(struct inode *inode,
+				     struct buffer_head *header_bh,
+				     char *bucket_buf,
+				     int *free)
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
+	 * we copy all the blocks into a contiguous memory and do the
+	 * defragment there, so if anything is error, we will not touch
+	 * the real block.
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
+ * first_bh is the first buffer_head of a series of bucket in the same
+ * extent rec and header_bh is the header of one bucket in this cluster.
+ * They will be updated if we move the data header_bh contains to the new
+ * cluster. first_hash will be set as the 1st xe's name_hash of the new cluster.
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
+/*
+ * Move half num of the xattrs in bucket(blk) to new bucket(new_blk).
+ * first_hash will record the 1st hash of the next bucket.
+ */
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
+	/* Now only update the source bucket header. */
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
+ * Move some xattrs from the old cluster to the new one since they are not
+ * contiguous in ocfs2 xattr tree.
+ *
+ * new_blk starts a new separate cluster, and we will move some xattrs from
+ * prev_blk to it. v_start will be set as the first name hash value in this
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
+ * Extend a new xattr bucket and move xattrs to the end one by one until
+ * We meet with start_bh. Only move half of the xattrs to the bucket after it.
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
+ *
+ * We will allocate a new cluster if current cluster is full and adjust
+ * header_bh and first_bh if the insert place is moved to the new cluster.
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
+	ret = ocfs2_xattr_get_rec(inode, name_hash, &p_blkno, &e_cpos,
+				  &num_clusters, el);
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
+/*
+ * Handle the normal xattr set, including replace, delete and new.
+ * When the bucket is empty, "is_empty" is set and the caller can
+ * free this bucket.
+ *
+ * Note: "local" indicates the real data's locality. So we can't
+ * just its bucket locality by its length.
+ */
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
+	memset(val, 0, size);
+	memcpy(val, xi->name, name_len);
+	memcpy(val + OCFS2_XATTR_SIZE(name_len), xi->value, xi->value_len);
+
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
+/*
+ * Set the xattr entry in the specified bucket.
+ * The bucket is indicated by xs->header_bh and it should have the enough
+ * space for the xattr insertion.
+ */
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
+	/*Only access and dirty the blocks we have touched in set xattr. */
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
+					 struct buffer_head *xe_bh,
+					 struct ocfs2_xattr_entry *xe,
+					 u64 new_size)
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
+/*
+ * Truncate the specified xe_off entry in xattr bucket.
+ * bucket is indicated by header_bh and len is the new length.
+ * Both the ocfs2_xattr_value_root and the entry will be updated here.
+ *
+ * Copy the new updated xe and xe_value_root to new_xe and new_xv if needed.
+ */
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
+	ocfs2_remove_xattr_clusters_from_cache(inode, blkno, len);
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
+/*
+ * Free the xattr bucket indicated by xs->header_bh and if all the buckets
+ * in the clusters is free, free the clusters also.
+ */
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
+	ret = ocfs2_xattr_get_rec(inode, name_hash, &p_blkno,
+				  &e_cpos, &num_clusters,
+				  &xb->xb_attrs.xb_root.xt_list);
+	if (ret) {
+		mlog_errno(ret);
+		return ret;
+	}
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
+/*
+ * Set the xattr name/value in the bucket specified in xs.
+ *
+ * As the new value in xi may be stored in the bucket or in an outside cluster,
+ * we divide the whole process into 3 steps:
+ * 1. insert name/value in the bucket(ocfs2_xattr_set_entry_in_bucket)
+ * 2. truncate of the outside cluster(ocfs2_xattr_bucket_value_truncate_xs)
+ * 3. Set the value to the outside cluster(ocfs2_xattr_bucket_set_value_outside)
+ */
+static int ocfs2_xattr_set_in_bucket(struct inode *inode,
+				     struct ocfs2_xattr_info *xi,
+				     struct ocfs2_xattr_search *xs)
+{
+	int ret, local = 1, bucket_empty = 0;
+	size_t value_len;
+	char *val = (char *)xi->value;
+	struct ocfs2_xattr_entry *xe = xs->here;
+	u32 name_hash = ocfs2_xattr_hash_by_name(inode,
+						 xi->name_index, xi->name);
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
+	u16 count, header_size, xh_offset;
+	int free, max_free, need, old;
+	size_t value_size = 0, name_len = strlen(xi->name);
+	size_t blocksize = inode->i_sb->s_blocksize;
+	int ret, allocation = 0, new_outside = 0;
+
+	mlog_entry("Set xattr %s in xattr index block\n", xi->name);
+
+try_again:
+	xh = xs->header;
+	count = le16_to_cpu(xh->xh_count);
+	xh_offset = le16_to_cpu(xh->xh_offset);
+	header_size = sizeof(struct ocfs2_xattr_header) +
+			count * sizeof(struct ocfs2_xattr_entry);
+	free = xh_offset - header_size;
+	max_free = OCFS2_XATTR_BUCKET_SIZE -
+		le16_to_cpu(xh->xh_name_value_len) - header_size;
+
+	if (xi->value && xi->value_len > OCFS2_XATTR_INLINE_SIZE) {
+		new_outside = 1;
+		value_size = OCFS2_XATTR_ROOT_SIZE;
+	} else if (xi->value)
+		value_size = OCFS2_XATTR_SIZE(xi->value_len);
+
+	if (xs->not_found) {
+		need = sizeof(struct ocfs2_xattr_entry) +
+			OCFS2_XATTR_SIZE(name_len) + value_size;
+		/* We have to handle xattr value root alignment. */
+		if (new_outside &&
+		    xh_offset % blocksize < OCFS2_XATTR_ROOT_SIZE)
+			free -= xh_offset % blocksize;
+	} else {
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
+	     "need = %d, max_free = %d, xh_offset = %u, xh_name_value_len = %u"
+	     "\n", xs->not_found, (unsigned long long)xs->header_bh->b_blocknr,
+	     free, need, max_free, le16_to_cpu(xh->xh_offset),
+	     le16_to_cpu(xh->xh_name_value_len));
+
+	if (free < need) {
+		if (need <= max_free) {
+			/*
+			 * We can create the space by defragment. Since only the
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
+			     "allocate new bucket for it.\n", need, free);
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
-- 
1.5.4.GIT
