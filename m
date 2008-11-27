From: Joel Becker <joel.becker@oracle.com>
Date: Wed, 26 Nov 2008 16:06:22 -0800
Subject: [Ocfs2-devel] [PATCH 09/13] ocfs2: Start using buckets in
	ocfs2_adjust_xattr_cross_cluster().
In-Reply-To: <1227744386-10502-1-git-send-email-joel.becker@oracle.com>
References: <1227744386-10502-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1227744386-10502-10-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We want to be passing around buckets instead of buffer_heads.  Let's get
them into ocfs2_adjust_xattr_cross_cluster.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |   46 ++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 38 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 2c9b673..4dcbc21 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -3613,7 +3613,7 @@ static int ocfs2_mv_xattr_bucket_cross_cluster(struct inode *inode,
 		 * These shouldn't fail - the buffers are in the
 		 * journal from ocfs2_cp_xattr_bucket().
 		 */
-		ret = ocfs2_read_xattr_bucket(new_first, src_blkno);
+		ret = ocfs2_read_xattr_bucket(new_first, new_blkno);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -4117,28 +4117,54 @@ static int ocfs2_adjust_xattr_cross_cluster(struct inode *inode,
 					    u32 *v_start,
 					    int *extend)
 {
-	int ret = 0;
-	int bpc = ocfs2_clusters_to_blocks(inode->i_sb, 1);
+	int ret;
+	struct ocfs2_xattr_bucket *first, *target;
 
 	mlog(0, "adjust xattrs from cluster %llu len %u to %llu\n",
 	     (unsigned long long)prev_blk, prev_clusters,
 	     (unsigned long long)new_blk);
 
+	/* The first bucket of the original extent */
+	first = ocfs2_xattr_bucket_new(inode);
+	/* The target bucket for insert */
+	target = ocfs2_xattr_bucket_new(inode);
+	if (!first || !target) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto out;
+	}
+
+	BUG_ON(prev_blk != (*first_bh)->b_blocknr);
+	ret = ocfs2_read_xattr_bucket(first, prev_blk);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_read_xattr_bucket(target, (*header_bh)->b_blocknr);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
 	if (ocfs2_xattr_buckets_per_cluster(OCFS2_SB(inode->i_sb)) > 1)
 		ret = ocfs2_mv_xattr_bucket_cross_cluster(inode,
 							  handle,
 							  first_bh,
 							  header_bh,
 							  new_blk,
-							  prev_blk,
+							  bucket_blkno(first),
 							  prev_clusters,
 							  v_start);
 	else {
-		u64 last_blk = prev_blk + bpc * (prev_clusters - 1);
+		/* The start of the last cluster in the first extent */
+		u64 last_blk = bucket_blkno(first) +
+			((prev_clusters - 1) *
+			 ocfs2_clusters_to_blocks(inode->i_sb, 1));
 
-		if (prev_clusters > 1 && (*header_bh)->b_blocknr != last_blk)
+		if (prev_clusters > 1 && bucket_blkno(target) != last_blk)
 			ret = ocfs2_mv_xattr_buckets(inode, handle,
-						     (*first_bh)->b_blocknr,
+						     bucket_blkno(first),
 						     last_blk, new_blk, 0,
 						     v_start);
 		else {
@@ -4146,11 +4172,15 @@ static int ocfs2_adjust_xattr_cross_cluster(struct inode *inode,
 							 last_blk, new_blk,
 							 v_start);
 
-			if ((*header_bh)->b_blocknr == last_blk && extend)
+			if ((bucket_blkno(target) == last_blk) && extend)
 				*extend = 0;
 		}
 	}
 
+out:
+	ocfs2_xattr_bucket_free(first);
+	ocfs2_xattr_bucket_free(target);
+
 	return ret;
 }
 
-- 
1.5.6.5
