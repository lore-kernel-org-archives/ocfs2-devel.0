From: Joel Becker <joel.becker@oracle.com>
Date: Wed, 26 Nov 2008 16:06:23 -0800
Subject: [Ocfs2-devel] [PATCH 10/13] ocfs2: Pass buckets into
	ocfs2_mv_xattr_bucket_cross_cluster().
In-Reply-To: <1227744386-10502-1-git-send-email-joel.becker@oracle.com>
References: <1227744386-10502-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1227744386-10502-11-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Now that ocfs2_adjust_xattr_cross_cluster() has buckets, it can pass
them into ocfs2_mv_xattr_bucket_cross_cluster().  It no longer has to
care about buffer_heads.  The manipulation of first_bh and header_bh
moves up to ocfs2_adjust_xattr_cross_cluster().

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |   84 +++++++++++++++++++++++------------------------------
 1 files changed, 37 insertions(+), 47 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 4dcbc21..8ea4032 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -3554,42 +3554,28 @@ out:
  */
 static int ocfs2_mv_xattr_bucket_cross_cluster(struct inode *inode,
 					       handle_t *handle,
-					       struct buffer_head **first_bh,
-					       struct buffer_head **header_bh,
+					       struct ocfs2_xattr_bucket *first,
+					       struct ocfs2_xattr_bucket *target,
 					       u64 new_blkno,
-					       u64 prev_blkno,
 					       u32 num_clusters,
 					       u32 *first_hash)
 {
 	int ret;
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	int blks_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
-	int num_buckets = ocfs2_xattr_buckets_per_cluster(osb);
+	struct super_block *sb = inode->i_sb;
+	int blks_per_bucket = ocfs2_blocks_per_xattr_bucket(sb);
+	int num_buckets = ocfs2_xattr_buckets_per_cluster(OCFS2_SB(sb));
 	int to_move = num_buckets / 2;
 	u64 src_blkno;
-	u64 last_cluster_blkno = prev_blkno +
-		((num_clusters - 1) * ocfs2_clusters_to_blocks(inode->i_sb, 1));
-	struct ocfs2_xattr_header *xh =
-			(struct ocfs2_xattr_header *)((*first_bh)->b_data);
-	struct ocfs2_xattr_bucket *new_target, *new_first;
+	u64 last_cluster_blkno = bucket_blkno(first) +
+		((num_clusters - 1) * ocfs2_clusters_to_blocks(sb, 1));
 
-	BUG_ON(le16_to_cpu(xh->xh_num_buckets) < num_buckets);
-	BUG_ON(OCFS2_XATTR_BUCKET_SIZE == osb->s_clustersize);
+	BUG_ON(le16_to_cpu(bucket_xh(first)->xh_num_buckets) < num_buckets);
+	BUG_ON(OCFS2_XATTR_BUCKET_SIZE == OCFS2_SB(sb)->s_clustersize);
 
 	mlog(0, "move half of xattrs in cluster %llu to %llu\n",
 	     (unsigned long long)last_cluster_blkno, (unsigned long long)new_blkno);
 
-	/* The first bucket of the new extent */
-	new_first = ocfs2_xattr_bucket_new(inode);
-	/* The target bucket if it was moved to the new extent */
-	new_target = ocfs2_xattr_bucket_new(inode);
-	if (!new_target || !new_first) {
-		ret = -ENOMEM;
-		mlog_errno(ret);
-		goto out;
-	}
-
-	ret = ocfs2_mv_xattr_buckets(inode, handle, prev_blkno,
+	ret = ocfs2_mv_xattr_buckets(inode, handle, bucket_blkno(first),
 				     last_cluster_blkno, new_blkno,
 				     to_move, first_hash);
 	if (ret) {
@@ -3602,41 +3588,32 @@ static int ocfs2_mv_xattr_bucket_cross_cluster(struct inode *inode,
 
 	/*
 	 * If the target bucket was part of the moved buckets, we need to
-	 * update first_bh and header_bh.
+	 * update first and target.
 	 */
-	if ((*header_bh)->b_blocknr >= src_blkno) {
+	if (bucket_blkno(target) >= src_blkno) {
 		/* Find the block for the new target bucket */
 		src_blkno = new_blkno +
-			((*header_bh)->b_blocknr - src_blkno);
+			(bucket_blkno(target) - src_blkno);
+
+		ocfs2_xattr_bucket_relse(first);
+		ocfs2_xattr_bucket_relse(target);
 
 		/*
 		 * These shouldn't fail - the buffers are in the
 		 * journal from ocfs2_cp_xattr_bucket().
 		 */
-		ret = ocfs2_read_xattr_bucket(new_first, new_blkno);
+		ret = ocfs2_read_xattr_bucket(first, new_blkno);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
 		}
-		ret = ocfs2_read_xattr_bucket(new_target, src_blkno);
-		if (ret) {
+		ret = ocfs2_read_xattr_bucket(target, src_blkno);
+		if (ret)
 			mlog_errno(ret);
-			goto out;
-		}
 
-		brelse(*first_bh);
-		*first_bh = new_first->bu_bhs[0];
-		get_bh(*first_bh);
-
-		brelse(*header_bh);
-		*header_bh = new_target->bu_bhs[0];
-		get_bh(*header_bh);
 	}
 
 out:
-	ocfs2_xattr_bucket_free(new_first);
-	ocfs2_xattr_bucket_free(new_target);
-
 	return ret;
 }
 
@@ -4147,16 +4124,29 @@ static int ocfs2_adjust_xattr_cross_cluster(struct inode *inode,
 		goto out;
 	}
 
-	if (ocfs2_xattr_buckets_per_cluster(OCFS2_SB(inode->i_sb)) > 1)
+	if (ocfs2_xattr_buckets_per_cluster(OCFS2_SB(inode->i_sb)) > 1) {
 		ret = ocfs2_mv_xattr_bucket_cross_cluster(inode,
 							  handle,
-							  first_bh,
-							  header_bh,
+							  first, target,
 							  new_blk,
-							  bucket_blkno(first),
 							  prev_clusters,
 							  v_start);
-	else {
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		/* Did first+target get moved? */
+		if (prev_blk != bucket_blkno(first)) {
+			brelse(*first_bh);
+			*first_bh = first->bu_bhs[0];
+			get_bh(*first_bh);
+
+			brelse(*header_bh);
+			*header_bh = target->bu_bhs[0];
+			get_bh(*header_bh);
+		}
+	} else {
 		/* The start of the last cluster in the first extent */
 		u64 last_blk = bucket_blkno(first) +
 			((prev_clusters - 1) *
-- 
1.5.6.5
