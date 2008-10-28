From: Joel Becker <joel.becker@oracle.com>
Date: Mon, 27 Oct 2008 18:20:21 -0700
Subject: [Ocfs2-devel] [PATCH 06/13] ocfs2: Improve
	ocfs2_read_xattr_bucket().
In-Reply-To: <1225156828-32189-1-git-send-email-joel.becker@oracle.com>
References: <1225156828-32189-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1225156828-32189-7-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The ocfs2_read_xattr_bucket() function would read an xattr bucket into a
list of buffer heads.  However, we have a nice ocfs2_xattr_bucket
structure.  Let's have it fill that out instead.

In addition, ocfs2_read_xattr_bucket() would initialize buffer heads for
a bucket that's never been on disk before.  That's confusing.  Let's
call that functionality ocfs2_init_xattr_bucket().

The functions ocfs2_cp_xattr_bucket() and ocfs2_half_xattr_bucket() are
updated to use the ocfs2_xattr_bucket structure rather than raw bh
lists.  That way they can use the new read/init calls.  In addition,
they drop the wasted read of an existing target bucket.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |  159 ++++++++++++++++++++++++++----------------------------
 1 files changed, 76 insertions(+), 83 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 1f0569f..61dee99 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -168,6 +168,48 @@ static void ocfs2_xattr_bucket_relse(struct inode *inode,
 	}
 }
 
+/*
+ * A bucket that has never been written to disk doesn't need to be
+ * read.  We just need the buffer_heads.  Don't call this for
+ * buckets that are already on disk.  ocfs2_read_xattr_bucket() initializes
+ * them fully.
+ */
+static int ocfs2_init_xattr_bucket(struct inode *inode,
+				   struct ocfs2_xattr_bucket *bucket,
+				   u64 xb_blkno)
+{
+	int i, rc = 0;
+	int blks = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
+
+	for (i = 0; i < blks; i++) {
+		bucket->bu_bhs[i] = sb_getblk(inode->i_sb, xb_blkno + i);
+		if (!bucket->bu_bhs[i]) {
+			rc = -EIO;
+			mlog_errno(rc);
+			break;
+		}
+
+		ocfs2_set_new_buffer_uptodate(inode, bucket->bu_bhs[i]);
+	}
+
+	if (rc)
+		ocfs2_xattr_bucket_relse(inode, bucket);
+	return rc;
+}
+
+/* Read the xattr bucket at xb_blkno */
+static int ocfs2_read_xattr_bucket(struct inode *inode,
+				   struct ocfs2_xattr_bucket *bucket,
+				   u64 xb_blkno)
+{
+	int rc, blks = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
+
+	rc = ocfs2_read_blocks(inode, xb_blkno, blks, bucket->bu_bhs, 0);
+	if (rc)
+		ocfs2_xattr_bucket_relse(inode, bucket);
+	return rc;
+}
+
 static inline const char *ocfs2_xattr_prefix(int name_index)
 {
 	struct xattr_handler *handler = NULL;
@@ -3089,31 +3131,6 @@ out:
 	return ret;
 }
 
-static int ocfs2_read_xattr_bucket(struct inode *inode,
-				   u64 blkno,
-				   struct buffer_head **bhs,
-				   int new)
-{
-	int ret = 0;
-	u16 i, blk_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
-
-	if (!new)
-		return ocfs2_read_blocks(inode, blkno,
-					 blk_per_bucket, bhs, 0);
-
-	for (i = 0; i < blk_per_bucket; i++) {
-		bhs[i] = sb_getblk(inode->i_sb, blkno + i);
-		if (bhs[i] == NULL) {
-			ret = -EIO;
-			mlog_errno(ret);
-			break;
-		}
-		ocfs2_set_new_buffer_uptodate(inode, bhs[i]);
-	}
-
-	return ret;
-}
-
 /*
  * Move half num of the xattrs in old bucket(blk) to new bucket(new_blk).
  * first_hash will record the 1st hash of the new bucket.
@@ -3128,7 +3145,7 @@ static int ocfs2_half_xattr_bucket(struct inode *inode,
 	int ret, i;
 	u16 count, start, len, name_value_len, xe_len, name_offset;
 	u16 blk_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
-	struct buffer_head **s_bhs, **t_bhs = NULL;
+	struct ocfs2_xattr_bucket s_bucket, t_bucket;
 	struct ocfs2_xattr_header *xh;
 	struct ocfs2_xattr_entry *xe;
 	int blocksize = inode->i_sb->s_blocksize;
@@ -3136,37 +3153,34 @@ static int ocfs2_half_xattr_bucket(struct inode *inode,
 	mlog(0, "move half of xattrs from bucket %llu to %llu\n",
 	     blk, new_blk);
 
-	s_bhs = kcalloc(blk_per_bucket, sizeof(struct buffer_head *), GFP_NOFS);
-	if (!s_bhs)
-		return -ENOMEM;
+	memset(&s_bucket, 0, sizeof(struct ocfs2_xattr_bucket));
+	memset(&t_bucket, 0, sizeof(struct ocfs2_xattr_bucket));
 
-	ret = ocfs2_read_xattr_bucket(inode, blk, s_bhs, 0);
+	ret = ocfs2_read_xattr_bucket(inode, &s_bucket, blk);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
 	}
 
-	ret = ocfs2_journal_access(handle, inode, s_bhs[0],
+	ret = ocfs2_journal_access(handle, inode, s_bucket.bu_bhs[0],
 				   OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
 	}
 
-	t_bhs = kcalloc(blk_per_bucket, sizeof(struct buffer_head *), GFP_NOFS);
-	if (!t_bhs) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	ret = ocfs2_read_xattr_bucket(inode, new_blk, t_bhs, new_bucket_head);
+	/*
+	 * Even if !new_bucket_head, we're overwriting t_bucket.  Thus,
+	 * there's no need to read it.
+	 */
+	ret = ocfs2_init_xattr_bucket(inode, &t_bucket, new_blk);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
 	}
 
 	for (i = 0; i < blk_per_bucket; i++) {
-		ret = ocfs2_journal_access(handle, inode, t_bhs[i],
+		ret = ocfs2_journal_access(handle, inode, t_bucket.bu_bhs[i],
 					   new_bucket_head ?
 					   OCFS2_JOURNAL_ACCESS_CREATE :
 					   OCFS2_JOURNAL_ACCESS_WRITE);
@@ -3178,10 +3192,11 @@ static int ocfs2_half_xattr_bucket(struct inode *inode,
 
 	/* copy the whole bucket to the new first. */
 	for (i = 0; i < blk_per_bucket; i++)
-		memcpy(t_bhs[i]->b_data, s_bhs[i]->b_data, blocksize);
+		memcpy(bucket_block(&t_bucket, i), bucket_block(&s_bucket, i),
+		       blocksize);
 
 	/* update the new bucket. */
-	xh = (struct ocfs2_xattr_header *)t_bhs[0]->b_data;
+	xh = bucket_xh(&t_bucket);
 	count = le16_to_cpu(xh->xh_count);
 	start = count / 2;
 
@@ -3247,7 +3262,7 @@ static int ocfs2_half_xattr_bucket(struct inode *inode,
 		xh->xh_num_buckets = 0;
 
 	for (i = 0; i < blk_per_bucket; i++) {
-		ocfs2_journal_dirty(handle, t_bhs[i]);
+		ocfs2_journal_dirty(handle, t_bucket.bu_bhs[i]);
 		if (ret)
 			mlog_errno(ret);
 	}
@@ -3260,29 +3275,20 @@ static int ocfs2_half_xattr_bucket(struct inode *inode,
 	 * Now only update the 1st block of the old bucket.
 	 * Please note that the entry has been sorted already above.
 	 */
-	xh = (struct ocfs2_xattr_header *)s_bhs[0]->b_data;
+	xh = bucket_xh(&s_bucket);
 	memset(&xh->xh_entries[start], 0,
 	       sizeof(struct ocfs2_xattr_entry) * (count - start));
 	xh->xh_count = cpu_to_le16(start);
 	xh->xh_free_start = cpu_to_le16(name_offset);
 	xh->xh_name_value_len = cpu_to_le16(name_value_len);
 
-	ocfs2_journal_dirty(handle, s_bhs[0]);
+	ocfs2_journal_dirty(handle, s_bucket.bu_bhs[0]);
 	if (ret)
 		mlog_errno(ret);
 
 out:
-	if (s_bhs) {
-		for (i = 0; i < blk_per_bucket; i++)
-			brelse(s_bhs[i]);
-	}
-	kfree(s_bhs);
-
-	if (t_bhs) {
-		for (i = 0; i < blk_per_bucket; i++)
-			brelse(t_bhs[i]);
-	}
-	kfree(t_bhs);
+	ocfs2_xattr_bucket_relse(inode, &s_bucket);
+	ocfs2_xattr_bucket_relse(inode, &t_bucket);
 
 	return ret;
 }
@@ -3302,35 +3308,30 @@ static int ocfs2_cp_xattr_bucket(struct inode *inode,
 	int ret, i;
 	int blk_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
 	int blocksize = inode->i_sb->s_blocksize;
-	struct buffer_head **s_bhs, **t_bhs = NULL;
+	struct ocfs2_xattr_bucket s_bucket, t_bucket;
 
 	BUG_ON(s_blkno == t_blkno);
 
 	mlog(0, "cp bucket %llu to %llu, target is %d\n",
 	     s_blkno, t_blkno, t_is_new);
 
-	s_bhs = kzalloc(sizeof(struct buffer_head *) * blk_per_bucket,
-			GFP_NOFS);
-	if (!s_bhs)
-		return -ENOMEM;
+	memset(&s_bucket, 0, sizeof(struct ocfs2_xattr_bucket));
+	memset(&t_bucket, 0, sizeof(struct ocfs2_xattr_bucket));
 
-	ret = ocfs2_read_xattr_bucket(inode, s_blkno, s_bhs, 0);
+	ret = ocfs2_read_xattr_bucket(inode, &s_bucket, s_blkno);
 	if (ret)
 		goto out;
 
-	t_bhs = kzalloc(sizeof(struct buffer_head *) * blk_per_bucket,
-			GFP_NOFS);
-	if (!t_bhs) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	ret = ocfs2_read_xattr_bucket(inode, t_blkno, t_bhs, t_is_new);
+	/*
+	 * Even if !t_is_new, we're overwriting t_bucket.  Thus,
+	 * there's no need to read it.
+	 */
+	ret = ocfs2_init_xattr_bucket(inode, &t_bucket, t_blkno);
 	if (ret)
 		goto out;
 
 	for (i = 0; i < blk_per_bucket; i++) {
-		ret = ocfs2_journal_access(handle, inode, t_bhs[i],
+		ret = ocfs2_journal_access(handle, inode, t_bucket.bu_bhs[i],
 					   t_is_new ?
 					   OCFS2_JOURNAL_ACCESS_CREATE :
 					   OCFS2_JOURNAL_ACCESS_WRITE);
@@ -3339,22 +3340,14 @@ static int ocfs2_cp_xattr_bucket(struct inode *inode,
 	}
 
 	for (i = 0; i < blk_per_bucket; i++) {
-		memcpy(t_bhs[i]->b_data, s_bhs[i]->b_data, blocksize);
-		ocfs2_journal_dirty(handle, t_bhs[i]);
+		memcpy(bucket_block(&t_bucket, i), bucket_block(&s_bucket, i),
+		       blocksize);
+		ocfs2_journal_dirty(handle, t_bucket.bu_bhs[i]);
 	}
 
 out:
-	if (s_bhs) {
-		for (i = 0; i < blk_per_bucket; i++)
-			brelse(s_bhs[i]);
-	}
-	kfree(s_bhs);
-
-	if (t_bhs) {
-		for (i = 0; i < blk_per_bucket; i++)
-			brelse(t_bhs[i]);
-	}
-	kfree(t_bhs);
+	ocfs2_xattr_bucket_relse(inode, &s_bucket);
+	ocfs2_xattr_bucket_relse(inode, &t_bucket);
 
 	return ret;
 }
-- 
1.5.6.5
