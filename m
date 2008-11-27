From: Joel Becker <joel.becker@oracle.com>
Date: Wed, 26 Nov 2008 16:06:21 -0800
Subject: [Ocfs2-devel] [PATCH 08/13] ocfs2: Use ocfs2_mv_xattr_buckets() in
	ocfs2_mv_xattr_bucket_cross_cluster().
In-Reply-To: <1227744386-10502-1-git-send-email-joel.becker@oracle.com>
References: <1227744386-10502-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1227744386-10502-9-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Now that ocfs2_mv_xattr_buckets() can move a partial cluster's worth of
buckets, ocfs2_mv_xattr_bucket_cross_cluster() can use it.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |  110 ++++++++++++++---------------------------------------
 1 files changed, 29 insertions(+), 81 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 652edaf..2c9b673 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -170,11 +170,10 @@ static int ocfs2_xattr_set_entry_index_block(struct inode *inode,
 
 static int ocfs2_delete_xattr_index_block(struct inode *inode,
 					  struct buffer_head *xb_bh);
-static int ocfs2_cp_xattr_bucket(struct inode *inode,
-				 handle_t *handle,
-				 u64 s_blkno,
-				 u64 t_blkno,
-				 int t_is_new);
+static int ocfs2_mv_xattr_buckets(struct inode *inode, handle_t *handle,
+				  u64 src_blk, u64 last_blk, u64 to_blk,
+				  unsigned int start_bucket,
+				  u32 *first_hash);
 
 static inline u16 ocfs2_xattr_buckets_per_cluster(struct ocfs2_super *osb)
 {
@@ -3562,115 +3561,64 @@ static int ocfs2_mv_xattr_bucket_cross_cluster(struct inode *inode,
 					       u32 num_clusters,
 					       u32 *first_hash)
 {
-	int i, ret, credits;
+	int ret;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	int blks_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
-	int bpc = ocfs2_clusters_to_blocks(inode->i_sb, 1);
 	int num_buckets = ocfs2_xattr_buckets_per_cluster(osb);
 	int to_move = num_buckets / 2;
-	u64 last_cluster_blkno, src_blkno;
+	u64 src_blkno;
+	u64 last_cluster_blkno = prev_blkno +
+		((num_clusters - 1) * ocfs2_clusters_to_blocks(inode->i_sb, 1));
 	struct ocfs2_xattr_header *xh =
 			(struct ocfs2_xattr_header *)((*first_bh)->b_data);
-	struct ocfs2_xattr_bucket *old_first, *new_first;
+	struct ocfs2_xattr_bucket *new_target, *new_first;
 
 	BUG_ON(le16_to_cpu(xh->xh_num_buckets) < num_buckets);
 	BUG_ON(OCFS2_XATTR_BUCKET_SIZE == osb->s_clustersize);
 
-	last_cluster_blkno = prev_blkno + ((num_clusters - 1) * bpc);
-	src_blkno = last_cluster_blkno + (to_move * blks_per_bucket);
-
 	mlog(0, "move half of xattrs in cluster %llu to %llu\n",
-	     (unsigned long long)prev_blkno, (unsigned long long)new_blkno);
+	     (unsigned long long)last_cluster_blkno, (unsigned long long)new_blkno);
 
-	/* The first bucket of the original extent */
-	old_first = ocfs2_xattr_bucket_new(inode);
 	/* The first bucket of the new extent */
 	new_first = ocfs2_xattr_bucket_new(inode);
-	if (!old_first || !new_first) {
+	/* The target bucket if it was moved to the new extent */
+	new_target = ocfs2_xattr_bucket_new(inode);
+	if (!new_target || !new_first) {
 		ret = -ENOMEM;
 		mlog_errno(ret);
 		goto out;
 	}
 
-	ret = ocfs2_read_xattr_bucket(old_first, prev_blkno);
+	ret = ocfs2_mv_xattr_buckets(inode, handle, prev_blkno,
+				     last_cluster_blkno, new_blkno,
+				     to_move, first_hash);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
 	}
 
-	/*
-	 * We need to update the 1st half of the new extent, and we
-	 * need to update the first bucket of the old extent.
-	 */
-	credits = ((to_move + 1) * blks_per_bucket) + handle->h_buffer_credits;
-	ret = ocfs2_extend_trans(handle, credits);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
-
-	ret = ocfs2_xattr_bucket_journal_access(handle, old_first,
-						OCFS2_JOURNAL_ACCESS_WRITE);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
-
-	for (i = 0; i < to_move; i++) {
-		ret = ocfs2_cp_xattr_bucket(inode, handle,
-					    src_blkno + (i * blks_per_bucket),
-					    new_blkno + (i * blks_per_bucket),
-					    1);
-		if (ret) {
-			mlog_errno(ret);
-			goto out;
-		}
-	}
-
-	/*
-	 * Get the new bucket ready before we dirty anything
-	 * (This actually shouldn't fail, because we already dirtied
-	 * it once in ocfs2_cp_xattr_bucket()).
-	 */
-	ret = ocfs2_read_xattr_bucket(new_first, new_blkno);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
-	ret = ocfs2_xattr_bucket_journal_access(handle, new_first,
-						OCFS2_JOURNAL_ACCESS_WRITE);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
-
-	/* Now update the headers */
-	le16_add_cpu(&bucket_xh(old_first)->xh_num_buckets, -to_move);
-	ocfs2_xattr_bucket_journal_dirty(handle, old_first);
-
-	bucket_xh(new_first)->xh_num_buckets = cpu_to_le16(to_move);
-	ocfs2_xattr_bucket_journal_dirty(handle, new_first);
-
-	if (first_hash)
-		*first_hash = le32_to_cpu(bucket_xh(new_first)->xh_entries[0].xe_name_hash);
+	/* This is the first bucket that got moved */
+	src_blkno = last_cluster_blkno + (to_move * blks_per_bucket);
 
 	/*
-	 * If the target bucket is anywhere past src_blkno, we moved
-	 * it to the new extent.  We need to update first_bh and header_bh.
+	 * If the target bucket was part of the moved buckets, we need to
+	 * update first_bh and header_bh.
 	 */
 	if ((*header_bh)->b_blocknr >= src_blkno) {
-		/* We're done with old_first, so we can re-use it. */
-		ocfs2_xattr_bucket_relse(old_first);
-
 		/* Find the block for the new target bucket */
 		src_blkno = new_blkno +
 			((*header_bh)->b_blocknr - src_blkno);
 
 		/*
-		 * This shouldn't fail - the buffers are in the
+		 * These shouldn't fail - the buffers are in the
 		 * journal from ocfs2_cp_xattr_bucket().
 		 */
-		ret = ocfs2_read_xattr_bucket(old_first, src_blkno);
+		ret = ocfs2_read_xattr_bucket(new_first, src_blkno);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+		ret = ocfs2_read_xattr_bucket(new_target, src_blkno);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -3681,13 +3629,13 @@ static int ocfs2_mv_xattr_bucket_cross_cluster(struct inode *inode,
 		get_bh(*first_bh);
 
 		brelse(*header_bh);
-		*header_bh = old_first->bu_bhs[0];
+		*header_bh = new_target->bu_bhs[0];
 		get_bh(*header_bh);
 	}
 
 out:
 	ocfs2_xattr_bucket_free(new_first);
-	ocfs2_xattr_bucket_free(old_first);
+	ocfs2_xattr_bucket_free(new_target);
 
 	return ret;
 }
-- 
1.5.6.5
