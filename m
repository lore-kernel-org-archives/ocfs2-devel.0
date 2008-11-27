From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 26 Nov 2008 19:01:09 -0800
Subject: [Ocfs2-devel] [PATCH 01/13] ocfs2: Dirty the entire bucket
	in	ocfs2_bucket_value_truncate()
In-Reply-To: <492DF6A8.4080309@oracle.com>
References: <1227744386-10502-1-git-send-email-joel.becker@oracle.com>
	<1227744386-10502-2-git-send-email-joel.becker@oracle.com>
	<492DF6A8.4080309@oracle.com>
Message-ID: <20081127030109.GC6259@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Nov 27, 2008 at 09:23:52AM +0800, Tao Ma wrote:
> ocfs2_xattr_value_update_size only access the first_bh, update the size  
> and then dirty it. Since you now access and dirty the whole bucket, I  
> think maybe you can just remove this function and move the size update 
> here.

	Good point.  Here's an updated version.

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 7e0d62a..aae4fe2 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -4586,31 +4586,6 @@ out:
 	return ret;
 }
 
-static int ocfs2_xattr_value_update_size(struct inode *inode,
-					 handle_t *handle,
-					 struct buffer_head *xe_bh,
-					 struct ocfs2_xattr_entry *xe,
-					 u64 new_size)
-{
-	int ret;
-
-	ret = ocfs2_journal_access(handle, inode, xe_bh,
-				   OCFS2_JOURNAL_ACCESS_WRITE);
-	if (ret < 0) {
-		mlog_errno(ret);
-		goto out;
-	}
-
-	xe->xe_value_size = cpu_to_le64(new_size);
-
-	ret = ocfs2_journal_dirty(handle, xe_bh);
-	if (ret < 0)
-		mlog_errno(ret);
-
-out:
-	return ret;
-}
-
 /*
  * Truncate the specified xe_off entry in xattr bucket.
  * bucket is indicated by header_bh and len is the new length.
@@ -4619,7 +4594,7 @@ out:
  * Copy the new updated xe and xe_value_root to new_xe and new_xv if needed.
  */
 static int ocfs2_xattr_bucket_value_truncate(struct inode *inode,
-					     struct buffer_head *header_bh,
+					     struct ocfs2_xattr_bucket *bucket,
 					     int xe_off,
 					     int len,
 					     struct ocfs2_xattr_set_ctxt *ctxt)
@@ -4629,8 +4604,7 @@ static int ocfs2_xattr_bucket_value_truncate(struct inode *inode,
 	struct buffer_head *value_bh = NULL;
 	struct ocfs2_xattr_value_root *xv;
 	struct ocfs2_xattr_entry *xe;
-	struct ocfs2_xattr_header *xh =
-			(struct ocfs2_xattr_header *)header_bh->b_data;
+	struct ocfs2_xattr_header *xh = bucket_xh(bucket);
 	size_t blocksize = inode->i_sb->s_blocksize;
 
 	xe = &xh->xh_entries[xe_off];
@@ -4644,34 +4618,41 @@ static int ocfs2_xattr_bucket_value_truncate(struct inode *inode,
 
 	/* We don't allow ocfs2_xattr_value to be stored in different block. */
 	BUG_ON(value_blk != (offset + OCFS2_XATTR_ROOT_SIZE - 1) / blocksize);
-	value_blk += header_bh->b_blocknr;
 
-	ret = ocfs2_read_block(inode, value_blk, &value_bh, NULL);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
+	value_bh = bucket->bu_bhs[value_blk];
+	BUG_ON(!value_bh);
 
 	xv = (struct ocfs2_xattr_value_root *)
 		(value_bh->b_data + offset % blocksize);
 
-	mlog(0, "truncate %u in xattr bucket %llu to %d bytes.\n",
-	     xe_off, (unsigned long long)header_bh->b_blocknr, len);
-	ret = ocfs2_xattr_value_truncate(inode, value_bh, xv, len, ctxt);
+	ret = ocfs2_xattr_bucket_journal_access(ctxt->handle, bucket,
+						OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
 	}
 
-	ret = ocfs2_xattr_value_update_size(inode, ctxt->handle,
-					    header_bh, xe, len);
+	/*
+	 * From here on out we have to dirty the bucket.  The generic
+	 * value calls only modify one of the bucket's bhs, but we need
+	 * to send the bucket at once.  So if they error, they *could* have
+	 * modified something.  We have to assume they did, and dirty
+	 * the whole bucket.  This leaves us in a consistent state.
+	 */
+	mlog(0, "truncate %u in xattr bucket %llu to %d bytes.\n",
+	     xe_off, (unsigned long long)bucket_blkno(bucket), len);
+	ret = ocfs2_xattr_value_truncate(inode, value_bh, xv, len, ctxt);
 	if (ret) {
 		mlog_errno(ret);
-		goto out;
+		goto out_dirty;
 	}
 
+	xe->xe_value_size = cpu_to_le64(len);
+
+out_dirty:
+	ocfs2_xattr_bucket_journal_dirty(ctxt->handle, bucket);
+
 out:
-	brelse(value_bh);
 	return ret;
 }
 
@@ -4687,7 +4668,7 @@ static int ocfs2_xattr_bucket_value_truncate_xs(struct inode *inode,
 	BUG_ON(!xs->bucket->bu_bhs[0] || !xe || ocfs2_xattr_is_local(xe));
 
 	offset = xe - xh->xh_entries;
-	ret = ocfs2_xattr_bucket_value_truncate(inode, xs->bucket->bu_bhs[0],
+	ret = ocfs2_xattr_bucket_value_truncate(inode, xs->bucket,
 						offset, len, ctxt);
 	if (ret)
 		mlog_errno(ret);
@@ -5129,8 +5110,7 @@ static int ocfs2_delete_xattr_in_bucket(struct inode *inode,
 		if (ocfs2_xattr_is_local(xe))
 			continue;
 
-		ret = ocfs2_xattr_bucket_value_truncate(inode,
-							bucket->bu_bhs[0],
+		ret = ocfs2_xattr_bucket_value_truncate(inode, bucket,
 							i, 0, &ctxt);
 		if (ret) {
 			mlog_errno(ret);
-- 

Life's Little Instruction Book #347

	"Never waste the oppourtunity to tell someone you love them."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
