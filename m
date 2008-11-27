From: Joel Becker <joel.becker@oracle.com>
Date: Wed, 26 Nov 2008 16:06:18 -0800
Subject: [Ocfs2-devel] [PATCH 05/13] ocfs2: Use ocfs2_cp_xattr_bucket() in
	ocfs2_mv_xattr_bucket_cross_cluster().
In-Reply-To: <1227744386-10502-1-git-send-email-joel.becker@oracle.com>
References: <1227744386-10502-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1227744386-10502-6-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The buffer copy loop of ocfs2_mv_xattr_bucket_cross_cluster() actually
looks a lot like ocfs2_cp_xattr_bucket().  Let's just use that instead.
We also use bucket operations to update the buckets at the start of each
extent.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |  169 +++++++++++++++++++++++++++++++++---------------------
 1 files changed, 104 insertions(+), 65 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index cb71dcc..c9e2f77 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -170,6 +170,11 @@ static int ocfs2_xattr_set_entry_index_block(struct inode *inode,
 
 static int ocfs2_delete_xattr_index_block(struct inode *inode,
 					  struct buffer_head *xb_bh);
+static int ocfs2_cp_xattr_bucket(struct inode *inode,
+				 handle_t *handle,
+				 u64 s_blkno,
+				 u64 t_blkno,
+				 int t_is_new);
 
 static inline u16 ocfs2_xattr_buckets_per_cluster(struct ocfs2_super *osb)
 {
@@ -3532,13 +3537,21 @@ out:
 }
 
 /*
- * Move half nums of the xattr bucket in the previous cluster to this new
- * cluster. We only touch the last cluster of the previous extend record.
+ * prev_blkno points to the start of an existing extent.  new_blkno
+ * points to a newly allocated extent.  Because we know each of our
+ * clusters contains more than bucket, we can easily split one cluster
+ * at a bucket boundary.  So we take the last cluster of the existing
+ * extent and split it down the middle.  We move the last half of the
+ * buckets in the last cluster of the existing extent over to the new
+ * extent.
+ *
+ * first_bh is the buffer at prev_blkno so we can update the existing
+ * extent's bucket count.  header_bh is the bucket were we were hoping
+ * to insert our xattr.  If the bucket move places the target in the new
+ * extent, we'll update first_bh and header_bh after modifying the old
+ * extent.
  *
- * first_bh is the first buffer_head of a series of bucket in the same
- * extent rec and header_bh is the header of one bucket in this cluster.
- * They will be updated if we move the data header_bh contains to the new
- * cluster. first_hash will be set as the 1st xe's name_hash of the new cluster.
+ * first_hash will be set as the 1st xe's name_hash in the new extent.
  */
 static int ocfs2_mv_xattr_bucket_cross_cluster(struct inode *inode,
 					       handle_t *handle,
@@ -3551,105 +3564,131 @@ static int ocfs2_mv_xattr_bucket_cross_cluster(struct inode *inode,
 {
 	int i, ret, credits;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	int blks_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
 	int bpc = ocfs2_clusters_to_blocks(inode->i_sb, 1);
 	int num_buckets = ocfs2_xattr_buckets_per_cluster(osb);
-	int blocksize = inode->i_sb->s_blocksize;
-	struct buffer_head *old_bh, *new_bh, *prev_bh, *new_first_bh = NULL;
-	struct ocfs2_xattr_header *new_xh;
+	int to_move = num_buckets / 2;
+	u64 last_cluster_blkno, src_blkno;
 	struct ocfs2_xattr_header *xh =
 			(struct ocfs2_xattr_header *)((*first_bh)->b_data);
+	struct ocfs2_xattr_bucket *old_first, *new_first;
 
 	BUG_ON(le16_to_cpu(xh->xh_num_buckets) < num_buckets);
 	BUG_ON(OCFS2_XATTR_BUCKET_SIZE == osb->s_clustersize);
 
-	prev_bh = *first_bh;
-	get_bh(prev_bh);
-	xh = (struct ocfs2_xattr_header *)prev_bh->b_data;
-
-	prev_blkno += (num_clusters - 1) * bpc + bpc / 2;
+	last_cluster_blkno = prev_blkno + ((num_clusters - 1) * bpc);
+	src_blkno = last_cluster_blkno + (to_move * blks_per_bucket);
 
 	mlog(0, "move half of xattrs in cluster %llu to %llu\n",
 	     (unsigned long long)prev_blkno, (unsigned long long)new_blkno);
 
+	/* The first bucket of the original extent */
+	old_first = ocfs2_xattr_bucket_new(inode);
+	/* The first bucket of the new extent */
+	new_first = ocfs2_xattr_bucket_new(inode);
+	if (!old_first || !new_first) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_read_xattr_bucket(old_first, prev_blkno);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
 	/*
-	 * We need to update the 1st half of the new cluster and
-	 * 1 more for the update of the 1st bucket of the previous
-	 * extent record.
+	 * We need to update the 1st half of the new extent, and we
+	 * need to update the first bucket of the old extent.
 	 */
-	credits = bpc / 2 + 1 + handle->h_buffer_credits;
+	credits = ((to_move + 1) * blks_per_bucket) + handle->h_buffer_credits;
 	ret = ocfs2_extend_trans(handle, credits);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
 	}
 
-	ret = ocfs2_journal_access(handle, inode, prev_bh,
-				   OCFS2_JOURNAL_ACCESS_WRITE);
+	ret = ocfs2_xattr_bucket_journal_access(handle, old_first,
+						OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
 	}
 
-	for (i = 0; i < bpc / 2; i++, prev_blkno++, new_blkno++) {
-		old_bh = new_bh = NULL;
-		new_bh = sb_getblk(inode->i_sb, new_blkno);
-		if (!new_bh) {
-			ret = -EIO;
+	for (i = 0; i < to_move; i++) {
+		ret = ocfs2_cp_xattr_bucket(inode, handle,
+					    src_blkno + (i * blks_per_bucket),
+					    new_blkno + (i * blks_per_bucket),
+					    1);
+		if (ret) {
 			mlog_errno(ret);
 			goto out;
 		}
+	}
 
-		ocfs2_set_new_buffer_uptodate(inode, new_bh);
+	/*
+	 * Get the new bucket ready before we dirty anything
+	 * (This actually shouldn't fail, because we already dirtied
+	 * it once in ocfs2_cp_xattr_bucket()).
+	 */
+	ret = ocfs2_read_xattr_bucket(new_first, new_blkno);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+	ret = ocfs2_xattr_bucket_journal_access(handle, new_first,
+						OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
 
-		ret = ocfs2_journal_access(handle, inode, new_bh,
-					   OCFS2_JOURNAL_ACCESS_CREATE);
-		if (ret < 0) {
-			mlog_errno(ret);
-			brelse(new_bh);
-			goto out;
-		}
+	/* Now update the headers */
+	le16_add_cpu(&bucket_xh(old_first)->xh_num_buckets, -to_move);
+	ocfs2_xattr_bucket_journal_dirty(handle, old_first);
 
-		ret = ocfs2_read_block(inode, prev_blkno, &old_bh, NULL);
-		if (ret < 0) {
-			mlog_errno(ret);
-			brelse(new_bh);
-			goto out;
-		}
+	bucket_xh(new_first)->xh_num_buckets = cpu_to_le16(to_move);
+	ocfs2_xattr_bucket_journal_dirty(handle, new_first);
 
-		memcpy(new_bh->b_data, old_bh->b_data, blocksize);
+	if (first_hash)
+		*first_hash = le32_to_cpu(bucket_xh(new_first)->xh_entries[0].xe_name_hash);
 
-		if (i == 0) {
-			new_xh = (struct ocfs2_xattr_header *)new_bh->b_data;
-			new_xh->xh_num_buckets = cpu_to_le16(num_buckets / 2);
+	/*
+	 * If the target bucket is anywhere past src_blkno, we moved
+	 * it to the new extent.  We need to update first_bh and header_bh.
+	 */
+	if ((*header_bh)->b_blocknr >= src_blkno) {
+		/* We're done with old_first, so we can re-use it. */
+		ocfs2_xattr_bucket_relse(old_first);
 
-			if (first_hash)
-				*first_hash = le32_to_cpu(
-					new_xh->xh_entries[0].xe_name_hash);
-			new_first_bh = new_bh;
-			get_bh(new_first_bh);
-		}
+		/* Find the block for the new target bucket */
+		src_blkno = new_blkno +
+			((*header_bh)->b_blocknr - src_blkno);
 
-		ocfs2_journal_dirty(handle, new_bh);
+		/*
+		 * This shouldn't fail - the buffers are in the
+		 * journal from ocfs2_cp_xattr_bucket().
+		 */
+		ret = ocfs2_read_xattr_bucket(old_first, src_blkno);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
 
-		if (*header_bh == old_bh) {
-			brelse(*header_bh);
-			*header_bh = new_bh;
-			get_bh(*header_bh);
+		brelse(*first_bh);
+		*first_bh = new_first->bu_bhs[0];
+		get_bh(*first_bh);
 
-			brelse(*first_bh);
-			*first_bh = new_first_bh;
-			get_bh(*first_bh);
-		}
-		brelse(new_bh);
-		brelse(old_bh);
+		brelse(*header_bh);
+		*header_bh = old_first->bu_bhs[0];
+		get_bh(*header_bh);
 	}
 
-	le16_add_cpu(&xh->xh_num_buckets, -(num_buckets / 2));
-
-	ocfs2_journal_dirty(handle, prev_bh);
 out:
-	brelse(prev_bh);
-	brelse(new_first_bh);
+	ocfs2_xattr_bucket_free(new_first);
+	ocfs2_xattr_bucket_free(old_first);
+
 	return ret;
 }
 
-- 
1.5.6.5
