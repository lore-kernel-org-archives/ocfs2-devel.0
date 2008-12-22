From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 22 Dec 2008 13:48:29 -0800
Subject: [Ocfs2-devel] [PATCH 48/56] ocfs2: Rename ocfs2_cp_xattr_cluster()
	to ocfs2_mv_xattr_buckets().
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Message-ID: <1229982517-3455-49-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Joel Becker <joel.becker@oracle.com>

ocfs2_cp_xattr_cluster() takes the last cluster of an xattr extent,
copies its buckets to the front of a new extent, and then shrinks the bucket
count of the original extent.  So it's really moving the data, not
copying it.

While we're here, the function doesn't need a buffer_head for the old
extent, just the block number.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/xattr.c |   42 ++++++++++++++++++++++--------------------
 1 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 5be9966..c1f2e06 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -3965,11 +3965,12 @@ static int ocfs2_cp_xattr_bucket(struct inode *inode,
 	/*
 	 * Hey, if we're overwriting t_bucket, what difference does
 	 * ACCESS_CREATE vs ACCESS_WRITE make?  Well, if we allocated a new
-	 * cluster to fill, we came here from ocfs2_cp_xattr_cluster(), and
-	 * it is really new - ACCESS_CREATE is required.  But we also
-	 * might have moved data out of t_bucket before extending back
-	 * into it.  ocfs2_add_new_xattr_bucket() can do this - its call
-	 * to ocfs2_add_new_xattr_cluster() may have created a new extent
+	 * cluster to fill, we came here from
+	 * ocfs2_mv_xattr_buckets(), and it is really new -
+	 * ACCESS_CREATE is required.  But we also might have moved data
+	 * out of t_bucket before extending back into it.
+	 * ocfs2_add_new_xattr_bucket() can do this - its call to
+	 * ocfs2_add_new_xattr_cluster() may have created a new extent
 	 * and copied out the end of the old extent.  Then it re-extends
 	 * the old extent back to create space for new xattrs.  That's
 	 * how we get here, and the bucket isn't really new.
@@ -3992,17 +3993,16 @@ out:
 }
 
 /*
- * src_blk points to the last cluster of an existing extent.  to_blk
- * points to a newly allocated extent.  We copy the cluster over to the
- * new extent, initializing its xh_num_buckets.  The old extent's
- * xh_num_buckets shrinks by the same amount.
+ * src_blk points to the start of an existing extent.  last_blk points to
+ * last cluster in that extent.  to_blk points to a newly allocated
+ * extent.  We copy the buckets from cluster at last_blk to the new extent,
+ * initializing its xh_num_buckets.  The old extent's xh_num_buckets
+ * shrinks by the same amount.
  */
-static int ocfs2_cp_xattr_cluster(struct inode *inode,
+static int ocfs2_mv_xattr_buckets(struct inode *inode,
 				  handle_t *handle,
-				  struct buffer_head *first_bh,
-				  u64 src_blk,
-				  u64 to_blk,
-				  u32 *first_hash)
+				  u64 src_blk, u64 last_blk,
+				  u64 to_blk, u32 *first_hash)
 {
 	int i, ret, credits;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
@@ -4011,8 +4011,8 @@ static int ocfs2_cp_xattr_cluster(struct inode *inode,
 	int num_buckets = ocfs2_xattr_buckets_per_cluster(osb);
 	struct ocfs2_xattr_bucket *old_first, *new_first;
 
-	mlog(0, "cp xattrs from cluster %llu to %llu\n",
-	     (unsigned long long)src_blk, (unsigned long long)to_blk);
+	mlog(0, "mv xattrs from cluster %llu to %llu\n",
+	     (unsigned long long)last_blk, (unsigned long long)to_blk);
 
 	/* The first bucket of the original extent */
 	old_first = ocfs2_xattr_bucket_new(inode);
@@ -4024,7 +4024,7 @@ static int ocfs2_cp_xattr_cluster(struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_read_xattr_bucket(old_first, first_bh->b_blocknr);
+	ret = ocfs2_read_xattr_bucket(old_first, src_blk);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -4050,7 +4050,7 @@ static int ocfs2_cp_xattr_cluster(struct inode *inode,
 
 	for (i = 0; i < num_buckets; i++) {
 		ret = ocfs2_cp_xattr_bucket(inode, handle,
-					    src_blk + (i * blks_per_bucket),
+					    last_blk + (i * blks_per_bucket),
 					    to_blk + (i * blks_per_bucket),
 					    1);
 		if (ret) {
@@ -4175,8 +4175,10 @@ static int ocfs2_adjust_xattr_cross_cluster(struct inode *inode,
 		u64 last_blk = prev_blk + bpc * (prev_clusters - 1);
 
 		if (prev_clusters > 1 && (*header_bh)->b_blocknr != last_blk)
-			ret = ocfs2_cp_xattr_cluster(inode, handle, *first_bh,
-						     last_blk, new_blk,
+			ret = ocfs2_mv_xattr_buckets(inode, handle,
+						     (*first_bh)->b_blocknr,
+						     last_blk,
+						     new_blk,
 						     v_start);
 		else {
 			ret = ocfs2_divide_xattr_cluster(inode, handle,
-- 
1.5.6
