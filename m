From: Joel Becker <joel.becker@oracle.com>
Date: Mon, 27 Oct 2008 18:20:22 -0700
Subject: [Ocfs2-devel] [PATCH 07/13] ocfs2: Wrap
	journal_access/journal_dirty for xattr buckets.
In-Reply-To: <1225156828-32189-1-git-send-email-joel.becker@oracle.com>
References: <1225156828-32189-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1225156828-32189-8-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

A common action is to call ocfs2_journal_access() and
ocfs2_journal_dirty() on the buffer heads of an xattr bucket.  Let's
create nice wrappers.

While we're there, let's drop the places that try to be smart by writing
only the first and last blocks of a bucket.  A bucket is contiguous, so
writing the whole thing is actually more efficient.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |  140 +++++++++++++++++++++++++-----------------------------
 1 files changed, 64 insertions(+), 76 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 61dee99..55e2c1a 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -210,6 +210,37 @@ static int ocfs2_read_xattr_bucket(struct inode *inode,
 	return rc;
 }
 
+static int ocfs2_xattr_bucket_journal_access(handle_t *handle,
+					     struct inode *inode,
+					     struct ocfs2_xattr_bucket *bucket,
+					     int type)
+{
+	int i, rc = 0;
+	int blks = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
+
+	for (i = 0; i < blks; i++) {
+		rc = ocfs2_journal_access(handle, inode,
+					  bucket->bu_bhs[i], type);
+		if (rc) {
+			mlog_errno(rc);
+			break;
+		}
+	}
+
+	return rc;
+}
+
+static void ocfs2_xattr_bucket_journal_dirty(handle_t *handle,
+					     struct inode *inode,
+					     struct ocfs2_xattr_bucket *bucket)
+{
+	int i, blks = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
+
+	for (i = 0; i < blks; i++)
+		ocfs2_journal_dirty(handle, bucket->bu_bhs[i]);
+}
+
+
 static inline const char *ocfs2_xattr_prefix(int name_index)
 {
 	struct xattr_handler *handler = NULL;
@@ -3162,8 +3193,8 @@ static int ocfs2_half_xattr_bucket(struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_journal_access(handle, inode, s_bucket.bu_bhs[0],
-				   OCFS2_JOURNAL_ACCESS_WRITE);
+	ret = ocfs2_xattr_bucket_journal_access(handle, inode, &s_bucket,
+						OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -3179,15 +3210,13 @@ static int ocfs2_half_xattr_bucket(struct inode *inode,
 		goto out;
 	}
 
-	for (i = 0; i < blk_per_bucket; i++) {
-		ret = ocfs2_journal_access(handle, inode, t_bucket.bu_bhs[i],
-					   new_bucket_head ?
-					   OCFS2_JOURNAL_ACCESS_CREATE :
-					   OCFS2_JOURNAL_ACCESS_WRITE);
-		if (ret) {
-			mlog_errno(ret);
-			goto out;
-		}
+	ret = ocfs2_xattr_bucket_journal_access(handle, inode, &t_bucket,
+						new_bucket_head ?
+						OCFS2_JOURNAL_ACCESS_CREATE :
+						OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
 	}
 
 	/* copy the whole bucket to the new first. */
@@ -3261,11 +3290,7 @@ static int ocfs2_half_xattr_bucket(struct inode *inode,
 	else
 		xh->xh_num_buckets = 0;
 
-	for (i = 0; i < blk_per_bucket; i++) {
-		ocfs2_journal_dirty(handle, t_bucket.bu_bhs[i]);
-		if (ret)
-			mlog_errno(ret);
-	}
+	ocfs2_xattr_bucket_journal_dirty(handle, inode, &t_bucket);
 
 	/* store the first_hash of the new bucket. */
 	if (first_hash)
@@ -3282,9 +3307,7 @@ static int ocfs2_half_xattr_bucket(struct inode *inode,
 	xh->xh_free_start = cpu_to_le16(name_offset);
 	xh->xh_name_value_len = cpu_to_le16(name_value_len);
 
-	ocfs2_journal_dirty(handle, s_bucket.bu_bhs[0]);
-	if (ret)
-		mlog_errno(ret);
+	ocfs2_xattr_bucket_journal_dirty(handle, inode, &s_bucket);
 
 out:
 	ocfs2_xattr_bucket_relse(inode, &s_bucket);
@@ -3330,20 +3353,18 @@ static int ocfs2_cp_xattr_bucket(struct inode *inode,
 	if (ret)
 		goto out;
 
-	for (i = 0; i < blk_per_bucket; i++) {
-		ret = ocfs2_journal_access(handle, inode, t_bucket.bu_bhs[i],
-					   t_is_new ?
-					   OCFS2_JOURNAL_ACCESS_CREATE :
-					   OCFS2_JOURNAL_ACCESS_WRITE);
-		if (ret)
-			goto out;
-	}
+	ret = ocfs2_xattr_bucket_journal_access(handle, inode, &t_bucket,
+						t_is_new ?
+						OCFS2_JOURNAL_ACCESS_CREATE :
+						OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret)
+		goto out;
 
 	for (i = 0; i < blk_per_bucket; i++) {
 		memcpy(bucket_block(&t_bucket, i), bucket_block(&s_bucket, i),
 		       blocksize);
-		ocfs2_journal_dirty(handle, t_bucket.bu_bhs[i]);
 	}
+	ocfs2_xattr_bucket_journal_dirty(handle, inode, &t_bucket);
 
 out:
 	ocfs2_xattr_bucket_relse(inode, &s_bucket);
@@ -3714,9 +3735,9 @@ static int ocfs2_extend_xattr_bucket(struct inode *inode,
 
 	/*
 	 * We will touch all the buckets after the start_bh(include it).
-	 * Add one more bucket and modify the first_bh.
+	 * Then we add one more bucket.
 	 */
-	credits = end_blk - start_blk + 2 * blk_per_bucket + 1;
+	credits = end_blk - start_blk + 3 * blk_per_bucket + 1;
 	handle = ocfs2_start_trans(osb, credits);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
@@ -3992,33 +4013,6 @@ set_new_name_value:
 	return;
 }
 
-static int ocfs2_xattr_bucket_handle_journal(struct inode *inode,
-					     handle_t *handle,
-					     struct ocfs2_xattr_search *xs,
-					     struct buffer_head **bhs,
-					     u16 bh_num)
-{
-	int ret = 0, off, block_off;
-	struct ocfs2_xattr_entry *xe = xs->here;
-
-	/*
-	 * First calculate all the blocks we should journal_access
-	 * and journal_dirty. The first block should always be touched.
-	 */
-	ret = ocfs2_journal_dirty(handle, bhs[0]);
-	if (ret)
-		mlog_errno(ret);
-
-	/* calc the data. */
-	off = le16_to_cpu(xe->xe_name_offset);
-	block_off = off >> inode->i_sb->s_blocksize_bits;
-	ret = ocfs2_journal_dirty(handle, bhs[block_off]);
-	if (ret)
-		mlog_errno(ret);
-
-	return ret;
-}
-
 /*
  * Set the xattr entry in the specified bucket.
  * The bucket is indicated by xs->bucket and it should have the enough
@@ -4030,7 +4024,7 @@ static int ocfs2_xattr_set_entry_in_bucket(struct inode *inode,
 					   u32 name_hash,
 					   int local)
 {
-	int i, ret;
+	int ret;
 	handle_t *handle = NULL;
 	u16 blk_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
@@ -4058,22 +4052,16 @@ static int ocfs2_xattr_set_entry_in_bucket(struct inode *inode,
 		goto out;
 	}
 
-	for (i = 0; i < blk_per_bucket; i++) {
-		ret = ocfs2_journal_access(handle, inode, xs->bucket.bu_bhs[i],
-					   OCFS2_JOURNAL_ACCESS_WRITE);
-		if (ret < 0) {
-			mlog_errno(ret);
-			goto out;
-		}
+	ret = ocfs2_xattr_bucket_journal_access(handle, inode, &xs->bucket,
+						OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out;
 	}
 
 	ocfs2_xattr_set_entry_normal(inode, xi, xs, name_hash, local);
+	ocfs2_xattr_bucket_journal_dirty(handle, inode, &xs->bucket);
 
-	/*Only dirty the blocks we have touched in set xattr. */
-	ret = ocfs2_xattr_bucket_handle_journal(inode, handle, xs,
-						xs->bucket.bu_bhs, blk_per_bucket);
-	if (ret)
-		mlog_errno(ret);
 out:
 	ocfs2_commit_trans(osb, handle);
 
@@ -4313,15 +4301,16 @@ static void ocfs2_xattr_bucket_remove_xs(struct inode *inode,
 						le16_to_cpu(xh->xh_count) - 1];
 	int ret = 0;
 
-	handle = ocfs2_start_trans((OCFS2_SB(inode->i_sb)), 1);
+	handle = ocfs2_start_trans((OCFS2_SB(inode->i_sb)),
+				   ocfs2_blocks_per_xattr_bucket(inode->i_sb));
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		mlog_errno(ret);
 		return;
 	}
 
-	ret = ocfs2_journal_access(handle, inode, xs->bucket.bu_bhs[0],
-				   OCFS2_JOURNAL_ACCESS_WRITE);
+	ret = ocfs2_xattr_bucket_journal_access(handle, inode, &xs->bucket,
+						OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
 		goto out_commit;
@@ -4333,9 +4322,8 @@ static void ocfs2_xattr_bucket_remove_xs(struct inode *inode,
 	memset(last, 0, sizeof(struct ocfs2_xattr_entry));
 	le16_add_cpu(&xh->xh_count, -1);
 
-	ret = ocfs2_journal_dirty(handle, xs->bucket.bu_bhs[0]);
-	if (ret < 0)
-		mlog_errno(ret);
+	ocfs2_xattr_bucket_journal_dirty(handle, inode, &xs->bucket);
+
 out_commit:
 	ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
 }
-- 
1.5.6.5
