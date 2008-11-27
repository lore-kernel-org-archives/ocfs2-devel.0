From: Joel Becker <joel.becker@oracle.com>
Date: Wed, 26 Nov 2008 16:06:14 -0800
Subject: [Ocfs2-devel] [PATCH 01/13] ocfs2: Dirty the entire bucket in
	ocfs2_bucket_value_truncate()
In-Reply-To: <1227744386-10502-1-git-send-email-joel.becker@oracle.com>
References: <1227744386-10502-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1227744386-10502-2-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_bucket_value_truncate() currently takes the first bh of the
bucket, and magically plays around with the value bh - even though
the bucket structure in the calling function already has it.

In addition, future code wants to always dirty the entire bucket when it
is changed.  So let's pass the entire bucket into this function, skip
any block reads (we have them), and add the access/dirty logic

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |   44 ++++++++++++++++++++++++++------------------
 1 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 7e0d62a..4571df8 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -4619,7 +4619,7 @@ out:
  * Copy the new updated xe and xe_value_root to new_xe and new_xv if needed.
  */
 static int ocfs2_xattr_bucket_value_truncate(struct inode *inode,
-					     struct buffer_head *header_bh,
+					     struct ocfs2_xattr_bucket *bucket,
 					     int xe_off,
 					     int len,
 					     struct ocfs2_xattr_set_ctxt *ctxt)
@@ -4629,8 +4629,7 @@ static int ocfs2_xattr_bucket_value_truncate(struct inode *inode,
 	struct buffer_head *value_bh = NULL;
 	struct ocfs2_xattr_value_root *xv;
 	struct ocfs2_xattr_entry *xe;
-	struct ocfs2_xattr_header *xh =
-			(struct ocfs2_xattr_header *)header_bh->b_data;
+	struct ocfs2_xattr_header *xh = bucket_xh(bucket);
 	size_t blocksize = inode->i_sb->s_blocksize;
 
 	xe = &xh->xh_entries[xe_off];
@@ -4644,34 +4643,44 @@ static int ocfs2_xattr_bucket_value_truncate(struct inode *inode,
 
 	/* We don't allow ocfs2_xattr_value to be stored in different block. */
 	BUG_ON(value_blk != (offset + OCFS2_XATTR_ROOT_SIZE - 1) / blocksize);
-	value_blk += header_bh->b_blocknr;
 
-	ret = ocfs2_read_block(inode, value_blk, &value_bh, NULL);
+	value_bh = bucket->bu_bhs[value_blk];
+	BUG_ON(!value_bh);
+
+	xv = (struct ocfs2_xattr_value_root *)
+		(value_bh->b_data + offset % blocksize);
+
+	ret = ocfs2_xattr_bucket_journal_access(ctxt->handle, bucket,
+						OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
 	}
 
-	xv = (struct ocfs2_xattr_value_root *)
-		(value_bh->b_data + offset % blocksize);
-
+	/*
+	 * From here on out we have to dirty the bucket.  The generic
+	 * value calls only modify one of the bucket's bhs, but we need
+	 * to send the bucket at once.  So if they error, they *could* have
+	 * modified something.  We have to assume they did, and dirty
+	 * the whole bucket.  This leaves us in a consistent state.
+	 */
 	mlog(0, "truncate %u in xattr bucket %llu to %d bytes.\n",
-	     xe_off, (unsigned long long)header_bh->b_blocknr, len);
+	     xe_off, (unsigned long long)bucket_blkno(bucket), len);
 	ret = ocfs2_xattr_value_truncate(inode, value_bh, xv, len, ctxt);
 	if (ret) {
 		mlog_errno(ret);
-		goto out;
+		goto out_dirty;
 	}
 
 	ret = ocfs2_xattr_value_update_size(inode, ctxt->handle,
-					    header_bh, xe, len);
-	if (ret) {
+					    bucket->bu_bhs[0], xe, len);
+	if (ret)
 		mlog_errno(ret);
-		goto out;
-	}
+
+out_dirty:
+	ocfs2_xattr_bucket_journal_dirty(ctxt->handle, bucket);
 
 out:
-	brelse(value_bh);
 	return ret;
 }
 
@@ -4687,7 +4696,7 @@ static int ocfs2_xattr_bucket_value_truncate_xs(struct inode *inode,
 	BUG_ON(!xs->bucket->bu_bhs[0] || !xe || ocfs2_xattr_is_local(xe));
 
 	offset = xe - xh->xh_entries;
-	ret = ocfs2_xattr_bucket_value_truncate(inode, xs->bucket->bu_bhs[0],
+	ret = ocfs2_xattr_bucket_value_truncate(inode, xs->bucket,
 						offset, len, ctxt);
 	if (ret)
 		mlog_errno(ret);
@@ -5129,8 +5138,7 @@ static int ocfs2_delete_xattr_in_bucket(struct inode *inode,
 		if (ocfs2_xattr_is_local(xe))
 			continue;
 
-		ret = ocfs2_xattr_bucket_value_truncate(inode,
-							bucket->bu_bhs[0],
+		ret = ocfs2_xattr_bucket_value_truncate(inode, bucket,
 							i, 0, &ctxt);
 		if (ret) {
 			mlog_errno(ret);
-- 
1.5.6.5
