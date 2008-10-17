From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 17 Oct 2008 12:44:38 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2/xattr: Proper hash collision handle
	in bucket division.
In-Reply-To: <48F81730.9020809@oracle.com>
References: <48F81730.9020809@oracle.com>
Message-ID: <1224218678-32196-3-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2/xattr, we must make sure the xattrs which have the same
hash value exist in the same bucket so that the search schema can
work. But in the old implementation, when we want to extend a bucket,
we just move half number of xattrs to the new bucket. This works
in most cases, but if we are lucky enough we will make 2 xattrs
into 2 different buckets. This cause a problem that the xattr
existing in the previous bucket can be found any more. This patch
fix this problem by finding the right position during extending
the bucket and extend an empty bucket if needed.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |  167 +++++++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 134 insertions(+), 33 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 1bf72da..57b51fc 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -3267,25 +3267,92 @@ static int ocfs2_read_xattr_bucket(struct inode *inode,
 }
 
 /*
- * Move half num of the xattrs in old bucket(blk) to new bucket(new_blk).
+ * Find the suitable pos when we divide a bucket into 2.
+ *
+ * We have to make sure the xattrs with the same hash value exist in the same
+ * bucket. So we start from the middle pos and go backward first and then
+ * forward. If all the xattrs in this bucket have the same hash value, just
+ * return count-1 and let the caller handle this.
+ */
+static u16 ocfs2_xattr_find_divide_pos(struct ocfs2_xattr_header *xh)
+{
+	u16 middle, pos, count = le16_to_cpu(xh->xh_count);
+	struct ocfs2_xattr_entry *xe, *xe_low;
+
+	BUG_ON(count == 0);
+	middle = count / 2;
+
+	/*
+	 * If the bucket only have one xattr(for blocksize == 512 and large
+	 * xattr name, it could be possible), let it go.
+	 */
+	if (middle == 0)
+		return middle;
+
+	/*
+	 * Find a xe before middle which doesn't have the same hash value
+	 * with the previous one.
+	 */
+	pos = middle;
+	while (pos > 0) {
+		xe = &xh->xh_entries[pos];
+		xe_low = &xh->xh_entries[pos - 1];
+		if (le32_to_cpu(xe_low->xe_name_hash) !=
+		    le32_to_cpu(xe->xe_name_hash))
+			return pos;
+
+		pos--;
+	}
+
+	/* now all the xe before middle(include it) has the same hash value. */
+	if (middle == count - 1)
+		return middle;
+
+	/*
+	 * Find a xe after middle which doesn't have the same hash value
+	 * with the later one.
+	 */
+	pos = middle;
+	while (pos < count - 1) {
+		xe_low = &xh->xh_entries[pos];
+		xe = &xh->xh_entries[pos + 1];
+		if (le32_to_cpu(xe_low->xe_name_hash) !=
+		    le32_to_cpu(xe->xe_name_hash))
+			return pos + 1;
+
+		pos++;
+	}
+
+	/* now all the xe in the bucket hash the same hash value. */
+	return count - 1;
+}
+
+/*
+ * Move some xattrs in old bucket(blk) to new bucket(new_blk).
  * first_hash will record the 1st hash of the new bucket.
+ *
+ * Normally half nums will be moved. But we have to make sure
+ * that the xattr with same hash value is stored in the same
+ * bucket. If all the xattrs in this bucket has the same hash
+ * value, the new bucket will be initialized as an empty one
+ * and the first_hash will be initialized as (hash_value+1).
  */
-static int ocfs2_half_xattr_bucket(struct inode *inode,
-				   handle_t *handle,
-				   u64 blk,
-				   u64 new_blk,
-				   u32 *first_hash,
-				   int new_bucket_head)
+static int ocfs2_divide_xattr_bucket(struct inode *inode,
+				    handle_t *handle,
+				    u64 blk,
+				    u64 new_blk,
+				    u32 *first_hash,
+				    int new_bucket_head)
 {
 	int ret, i;
-	u16 count, start, len, name_value_len, xe_len, name_offset;
+	u16 count, start, len, name_value_len = 0, xe_len, name_offset = 0;
 	u16 blk_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
 	struct buffer_head **s_bhs, **t_bhs = NULL;
 	struct ocfs2_xattr_header *xh;
 	struct ocfs2_xattr_entry *xe;
 	int blocksize = inode->i_sb->s_blocksize;
 
-	mlog(0, "move half of xattrs from bucket %llu to %llu\n",
+	mlog(0, "move some of xattrs from bucket %llu to %llu\n",
 	     blk, new_blk);
 
 	s_bhs = kcalloc(blk_per_bucket, sizeof(struct buffer_head *), GFP_NOFS);
@@ -3326,14 +3393,33 @@ static int ocfs2_half_xattr_bucket(struct inode *inode,
 		}
 	}
 
-	/* copy the whole bucket to the new first. */
-	for (i = 0; i < blk_per_bucket; i++)
-		memcpy(t_bhs[i]->b_data, s_bhs[i]->b_data, blocksize);
+	xh = (struct ocfs2_xattr_header *)s_bhs[0]->b_data;
+	count = le16_to_cpu(xh->xh_count);
+	start = ocfs2_xattr_find_divide_pos(xh);
+	xe = &xh->xh_entries[start];
 
 	/* update the new bucket. */
 	xh = (struct ocfs2_xattr_header *)t_bhs[0]->b_data;
-	count = le16_to_cpu(xh->xh_count);
-	start = count / 2;
+
+	if (start == count - 1) {
+		/*
+		 * initialized a new empty bucket here.
+		 * The hash value is set as one larger than
+		 * that of the last entry in the previous bucket.
+		 */
+		for (i = 0; i < blk_per_bucket; i++)
+			memset(t_bhs[i]->b_data, 0, blocksize);
+
+		xh->xh_free_start = cpu_to_le16(blocksize);
+		xh->xh_entries[0].xe_name_hash = xe->xe_name_hash;
+		le32_add_cpu(&xh->xh_entries[0].xe_name_hash, 1);
+
+		goto set_num_buckets;
+	}
+
+	/* copy the whole bucket to the new first. */
+	for (i = 0; i < blk_per_bucket; i++)
+		memcpy(t_bhs[i]->b_data, s_bhs[i]->b_data, blocksize);
 
 	/*
 	 * Calculate the total name/value len and xh_free_start for
@@ -3390,6 +3476,7 @@ static int ocfs2_half_xattr_bucket(struct inode *inode,
 			xh->xh_free_start = xe->xe_name_offset;
 	}
 
+set_num_buckets:
 	/* set xh->xh_num_buckets for the new xh. */
 	if (new_bucket_head)
 		xh->xh_num_buckets = cpu_to_le16(1);
@@ -3406,10 +3493,12 @@ static int ocfs2_half_xattr_bucket(struct inode *inode,
 	if (first_hash)
 		*first_hash = le32_to_cpu(xh->xh_entries[0].xe_name_hash);
 
-	/*
-	 * Now only update the 1st block of the old bucket.
-	 * Please note that the entry has been sorted already above.
+	/* Now only update the 1st block of the old bucket.
+	 * If we just add a new empty bucket after it, no needs to modify it.
 	 */
+	if (start == count - 1)
+		goto out;
+
 	xh = (struct ocfs2_xattr_header *)s_bhs[0]->b_data;
 	memset(&xh->xh_entries[start], 0,
 	       sizeof(struct ocfs2_xattr_entry) * (count - start));
@@ -3592,15 +3681,15 @@ out:
 }
 
 /*
- * Move half of the xattrs in this cluster to the new cluster.
+ * Move some xattrs in this cluster to the new cluster.
  * This function should only be called when bucket size == cluster size.
  * Otherwise ocfs2_mv_xattr_bucket_cross_cluster should be used instead.
  */
-static int ocfs2_half_xattr_cluster(struct inode *inode,
-				    handle_t *handle,
-				    u64 prev_blk,
-				    u64 new_blk,
-				    u32 *first_hash)
+static int ocfs2_divide_xattr_cluster(struct inode *inode,
+				      handle_t *handle,
+				      u64 prev_blk,
+				      u64 new_blk,
+				      u32 *first_hash)
 {
 	u16 blk_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
 	int ret, credits = 2 * blk_per_bucket;
@@ -3614,8 +3703,8 @@ static int ocfs2_half_xattr_cluster(struct inode *inode,
 	}
 
 	/* Move half of the xattr in start_blk to the next bucket. */
-	return  ocfs2_half_xattr_bucket(inode, handle, prev_blk,
-					new_blk, first_hash, 1);
+	return  ocfs2_divide_xattr_bucket(inode, handle, prev_blk,
+					  new_blk, first_hash, 1);
 }
 
 /*
@@ -3677,9 +3766,9 @@ static int ocfs2_adjust_xattr_cross_cluster(struct inode *inode,
 						     last_blk, new_blk,
 						     v_start);
 		else {
-			ret = ocfs2_half_xattr_cluster(inode, handle,
-						       last_blk, new_blk,
-						       v_start);
+			ret = ocfs2_divide_xattr_cluster(inode, handle,
+							 last_blk, new_blk,
+							 v_start);
 
 			if ((*header_bh)->b_blocknr == last_blk && extend)
 				*extend = 0;
@@ -3877,8 +3966,8 @@ static int ocfs2_extend_xattr_bucket(struct inode *inode,
 	}
 
 	/* Move half of the xattr in start_blk to the next bucket. */
-	ret = ocfs2_half_xattr_bucket(inode, handle, start_blk,
-				      start_blk + blk_per_bucket, NULL, 0);
+	ret = ocfs2_divide_xattr_bucket(inode, handle, start_blk,
+					start_blk + blk_per_bucket, NULL, 0);
 
 	le16_add_cpu(&first_xh->xh_num_buckets, 1);
 	ocfs2_journal_dirty(handle, first_bh);
@@ -4554,11 +4643,21 @@ out:
 	return ret;
 }
 
-/* check whether the xattr bucket is filled up with the same hash value. */
+/*
+ * check whether the xattr bucket is filled up with the same hash value.
+ * If we want to insert the xattr with the same hash, return -ENOSPC.
+ * If we want to insert a xattr with different hash value, go ahead
+ * and ocfs2_divide_xattr_bucket will handle this.
+ */
 static int ocfs2_check_xattr_bucket_collision(struct inode *inode,
-					      struct ocfs2_xattr_bucket *bucket)
+					      struct ocfs2_xattr_bucket *bucket,
+					      const char *name)
 {
 	struct ocfs2_xattr_header *xh = bucket->xh;
+	u32 name_hash = ocfs2_xattr_name_hash(inode, name, strlen(name));
+
+	if (name_hash != le16_to_cpu(xh->xh_entries[0].xe_name_hash))
+		return 0;
 
 	if (xh->xh_entries[le16_to_cpu(xh->xh_count) - 1].xe_name_hash ==
 	    xh->xh_entries[0].xe_name_hash) {
@@ -4684,7 +4783,9 @@ try_again:
 		 * one bucket's worth, so check it here whether we need to
 		 * add a new bucket for the insert.
 		 */
-		ret = ocfs2_check_xattr_bucket_collision(inode, &xs->bucket);
+		ret = ocfs2_check_xattr_bucket_collision(inode,
+							 &xs->bucket,
+							 xi->name);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
-- 
1.5.4.GIT
