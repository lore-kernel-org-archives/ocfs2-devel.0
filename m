From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 29 Aug 2008 09:19:26 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: support empty xattr bucket in find.
Message-ID: <1219972766-5486-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_xattr_buckets_find, when we meet with an empty
bucket, just skip it and try to find another non-empty one.

Note:
We erase empty bucket now when we find it has no xattr in it.
And there are actually many to-dos left if we really want to
disable automatic removal of empty buckets(e.g. when we insert
a new xattr cluster in xattr tree, we have to find a suitable
start hash, and an empty bucket can't give us such information.
That also means that we have to enhance our xattr bucket extension
process and so on). So I am not sure whether this patch should
be committed alone or with the future disabling patches.
Mark, it is up to you. ;)

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |  105 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 105 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 2bc53b1..782abce 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2241,6 +2241,80 @@ static int ocfs2_find_xe_in_bucket(struct inode *inode,
 }
 
 /*
+ * Try to find a non-empty bucket between low_bucket and high_bucket.
+ *
+ * First try to find one bucket that isn't empty between bucket and
+ * high_bucket. If none, try to find one bucket that isn't empty between
+ * bucket and low_bucket. If all are empty, return the lowest bucket.
+ */
+static int ocfs2_find_not_emtpy_bucket(struct inode *inode,
+				       struct buffer_head **bucket_bh,
+				       int *bucket,
+				       int low_bucket,
+				       int high_bucket,
+				       u64 p_blkno)
+{
+	int i, ret = 0;
+	int old_bucket = *bucket;
+	struct buffer_head *bh = NULL;
+	struct ocfs2_xattr_header *xh = NULL;
+	u16 blk_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
+	u64 blkno;
+
+	for (i = old_bucket + 1; i <= high_bucket; i++) {
+		blkno = p_blkno + i * blk_per_bucket;
+
+		ret = ocfs2_read_block(OCFS2_SB(inode->i_sb), blkno,
+				       &bh, OCFS2_BH_CACHED, inode);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		xh = (struct ocfs2_xattr_header *)bh->b_data;
+
+		if (xh->xh_count)
+			goto find_out;
+
+		brelse(bh);
+		bh = NULL;
+	}
+
+	/*
+	 * In case old_bucket is already the lowest one, and we
+	 * haven't find one non-empty bucket above us, return it
+	 * by starting iteration from itself.
+	 */
+	i = old_bucket == low_bucket ? old_bucket : old_bucket - 1;
+	for (; i >= low_bucket; i--) {
+		brelse(bh);
+		bh = NULL;
+		blkno = p_blkno + i * blk_per_bucket;
+
+		ret = ocfs2_read_block(OCFS2_SB(inode->i_sb), blkno,
+				       &bh, OCFS2_BH_CACHED, inode);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		xh = (struct ocfs2_xattr_header *)bh->b_data;
+
+		if (xh->xh_count)
+			break;
+	}
+
+find_out:
+	*bucket_bh = bh;
+	*bucket = i;
+
+	mlog(0, "Find non-empty Bucket %llu.\n",
+	     (unsigned long long)bh->b_blocknr);
+out:
+	return ret;
+}
+
+/*
  * Find the specified xattr entry in a series of buckets.
  * This series start from p_blkno and last for num_clusters.
  * The ocfs2_xattr_header.xh_num_buckets of the first bucket contains
@@ -2294,6 +2368,37 @@ static int ocfs2_xattr_bucket_find(struct inode *inode,
 		}
 
 		xh = (struct ocfs2_xattr_header *)bh->b_data;
+
+		if (!xh->xh_count) {
+			mlog(0, "Bucket %llu is empty.\n",
+			     (unsigned long long)bh->b_blocknr);
+			/*
+			 * this bucket is empty.
+			 * If we have comes to the end(low == high), just
+			 * exit the loop.
+			 *
+			 * If not, try to find one bucket which isn't empty.
+			 */
+			if (low_bucket == high_bucket)
+				break;
+
+			brelse(bh);
+			bh = NULL;
+			ret = ocfs2_find_not_emtpy_bucket(inode, &bh,
+							  &bucket,
+							  low_bucket,
+							  high_bucket,
+							  p_blkno);
+			if (ret) {
+				mlog_errno(ret);
+				goto out;
+			}
+
+			xh = (struct ocfs2_xattr_header *)bh->b_data;
+			if (!xh->xh_count)
+				break;
+		}
+
 		xe = &xh->xh_entries[0];
 		if (name_hash < le32_to_cpu(xe->xe_name_hash)) {
 			high_bucket = bucket - 1;
-- 
1.5.4.GIT
