From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 22 Dec 2008 13:48:30 -0800
Subject: [Ocfs2-devel] [PATCH 49/56] ocfs2: ocfs2_mv_xattr_buckets() can
	handle a partial cluster now.
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Message-ID: <1229982517-3455-50-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Joel Becker <joel.becker@oracle.com>

If you look at ocfs2_mv_xattr_bucket_cross_cluster(), you'll notice that
two-thirds of the code is almost identical to ocfs2_mv_xattr_buckets().
The only difference is that ocfs2_mv_xattr_buckets() moves a whole
cluster's worth, while ocfs2_mv_xattr_bucket_cross_cluster() moves half
the cluster.

We change ocfs2_mv_xattr_buckets() to allow moving partial clusters.
The original caller of ocfs2_mv_xattr_buckets() still moves the whole
cluster's worth - it just passes a start_bucket of 0.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/xattr.c |   33 ++++++++++++++++++++-------------
 1 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index c1f2e06..9734094 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -3995,18 +3995,19 @@ out:
 /*
  * src_blk points to the start of an existing extent.  last_blk points to
  * last cluster in that extent.  to_blk points to a newly allocated
- * extent.  We copy the buckets from cluster at last_blk to the new extent,
- * initializing its xh_num_buckets.  The old extent's xh_num_buckets
- * shrinks by the same amount.
+ * extent.  We copy the buckets from the cluster at last_blk to the new
+ * extent.  If start_bucket is non-zero, we skip that many buckets before
+ * we start copying.  The new extent's xh_num_buckets gets set to the
+ * number of buckets we copied.  The old extent's xh_num_buckets shrinks
+ * by the same amount.
  */
-static int ocfs2_mv_xattr_buckets(struct inode *inode,
-				  handle_t *handle,
-				  u64 src_blk, u64 last_blk,
-				  u64 to_blk, u32 *first_hash)
+static int ocfs2_mv_xattr_buckets(struct inode *inode, handle_t *handle,
+				  u64 src_blk, u64 last_blk, u64 to_blk,
+				  unsigned int start_bucket,
+				  u32 *first_hash)
 {
 	int i, ret, credits;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	int bpc = ocfs2_clusters_to_blocks(inode->i_sb, 1);
 	int blks_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
 	int num_buckets = ocfs2_xattr_buckets_per_cluster(osb);
 	struct ocfs2_xattr_bucket *old_first, *new_first;
@@ -4014,6 +4015,12 @@ static int ocfs2_mv_xattr_buckets(struct inode *inode,
 	mlog(0, "mv xattrs from cluster %llu to %llu\n",
 	     (unsigned long long)last_blk, (unsigned long long)to_blk);
 
+	BUG_ON(start_bucket >= num_buckets);
+	if (start_bucket) {
+		num_buckets -= start_bucket;
+		last_blk += (start_bucket * blks_per_bucket);
+	}
+
 	/* The first bucket of the original extent */
 	old_first = ocfs2_xattr_bucket_new(inode);
 	/* The first bucket of the new extent */
@@ -4031,10 +4038,11 @@ static int ocfs2_mv_xattr_buckets(struct inode *inode,
 	}
 
 	/*
-	 * We need to update the first bucket of the old extent and the
-	 * entire first cluster of the new extent.
+	 * We need to update the first bucket of the old extent and all
+	 * the buckets going to the new extent.
 	 */
-	credits = blks_per_bucket + bpc + handle->h_buffer_credits;
+	credits = ((num_buckets + 1) * blks_per_bucket) +
+		handle->h_buffer_credits;
 	ret = ocfs2_extend_trans(handle, credits);
 	if (ret) {
 		mlog_errno(ret);
@@ -4177,8 +4185,7 @@ static int ocfs2_adjust_xattr_cross_cluster(struct inode *inode,
 		if (prev_clusters > 1 && (*header_bh)->b_blocknr != last_blk)
 			ret = ocfs2_mv_xattr_buckets(inode, handle,
 						     (*first_bh)->b_blocknr,
-						     last_blk,
-						     new_blk,
+						     last_blk, new_blk, 0,
 						     v_start);
 		else {
 			ret = ocfs2_divide_xattr_cluster(inode, handle,
-- 
1.5.6
