From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 22 Dec 2008 13:48:23 -0800
Subject: [Ocfs2-devel] [PATCH 42/56] ocfs2: Dirty the entire bucket in
	ocfs2_bucket_value_truncate()
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Message-ID: <1229982517-3455-43-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Joel Becker <joel.becker@oracle.com>

ocfs2_bucket_value_truncate() currently takes the first bh of the
bucket, and magically plays around with the value bh - even though
the bucket structure in the calling function already has it.

In addition, future code wants to always dirty the entire bucket when it
is changed.  So let's pass the entire bucket into this function, skip
any block reads (we have them), and add the access/dirty logic.

ocfs2_xattr_update_value_size() is no longer necessary, as it only did
one thing other than journal access/dirty.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/xattr.c |   74 ++++++++++++++++++++---------------------------------
 1 files changed, 28 insertions(+), 46 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 3b9634c..6db68a2 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -4580,31 +4580,6 @@ out:
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
@@ -4613,7 +4588,7 @@ out:
  * Copy the new updated xe and xe_value_root to new_xe and new_xv if needed.
  */
 static int ocfs2_xattr_bucket_value_truncate(struct inode *inode,
-					     struct buffer_head *header_bh,
+					     struct ocfs2_xattr_bucket *bucket,
 					     int xe_off,
 					     int len,
 					     struct ocfs2_xattr_set_ctxt *ctxt)
@@ -4623,8 +4598,7 @@ static int ocfs2_xattr_bucket_value_truncate(struct inode *inode,
 	struct buffer_head *value_bh = NULL;
 	struct ocfs2_xattr_value_root *xv;
 	struct ocfs2_xattr_entry *xe;
-	struct ocfs2_xattr_header *xh =
-			(struct ocfs2_xattr_header *)header_bh->b_data;
+	struct ocfs2_xattr_header *xh = bucket_xh(bucket);
 	size_t blocksize = inode->i_sb->s_blocksize;
 
 	xe = &xh->xh_entries[xe_off];
@@ -4638,34 +4612,41 @@ static int ocfs2_xattr_bucket_value_truncate(struct inode *inode,
 
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
 
@@ -4681,7 +4662,7 @@ static int ocfs2_xattr_bucket_value_truncate_xs(struct inode *inode,
 	BUG_ON(!xs->bucket->bu_bhs[0] || !xe || ocfs2_xattr_is_local(xe));
 
 	offset = xe - xh->xh_entries;
-	ret = ocfs2_xattr_bucket_value_truncate(inode, xs->bucket->bu_bhs[0],
+	ret = ocfs2_xattr_bucket_value_truncate(inode, xs->bucket,
 						offset, len, ctxt);
 	if (ret)
 		mlog_errno(ret);
@@ -5107,11 +5088,13 @@ static int ocfs2_delete_xattr_in_bucket(struct inode *inode,
 	struct ocfs2_xattr_entry *xe;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_xattr_set_ctxt ctxt = {NULL, NULL,};
+	int credits = ocfs2_remove_extent_credits(osb->sb) +
+		ocfs2_blocks_per_xattr_bucket(inode->i_sb);
+
 
 	ocfs2_init_dealloc_ctxt(&ctxt.dealloc);
 
-	ctxt.handle = ocfs2_start_trans(osb,
-					ocfs2_remove_extent_credits(osb->sb));
+	ctxt.handle = ocfs2_start_trans(osb, credits);
 	if (IS_ERR(ctxt.handle)) {
 		ret = PTR_ERR(ctxt.handle);
 		mlog_errno(ret);
@@ -5123,8 +5106,7 @@ static int ocfs2_delete_xattr_in_bucket(struct inode *inode,
 		if (ocfs2_xattr_is_local(xe))
 			continue;
 
-		ret = ocfs2_xattr_bucket_value_truncate(inode,
-							bucket->bu_bhs[0],
+		ret = ocfs2_xattr_bucket_value_truncate(inode, bucket,
 							i, 0, &ctxt);
 		if (ret) {
 			mlog_errno(ret);
-- 
1.5.6
