From: Joel Becker <joel.becker@oracle.com>
Date: Wed, 19 Aug 2009 12:54:37 -0700
Subject: [Ocfs2-devel] [PATCH 12/14] ocfs2: Let ocfs2_xa_prepare_entry() do
	space checks.
In-Reply-To: <1250711679-12441-1-git-send-email-joel.becker@oracle.com>
References: <1250711679-12441-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1250711679-12441-13-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_xattr_set_in_bucket() doesn't need to do its own hacky space
checking.  Let's let ocfs2_xa_prepare_entry() (via ocfs2_xa_set()) do
the more accurate work.  Whenever it doesn't have space,
ocfs2_xattr_set_in_bucket() can try to get more space.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |  239 ++++++++++++++++-------------------------------------
 1 files changed, 72 insertions(+), 167 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 7527546..f0205e6 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -5105,42 +5105,6 @@ out:
 }
 
 /*
- * Set the xattr name/value in the bucket specified in xs.
- */
-static int ocfs2_xattr_set_in_bucket(struct inode *inode,
-				     struct ocfs2_xattr_info *xi,
-				     struct ocfs2_xattr_search *xs,
-				     struct ocfs2_xattr_set_ctxt *ctxt)
-{
-	int ret;
-	u64 blkno;
-	struct ocfs2_xa_loc loc;
-
-	if (!xs->bucket->bu_bhs[1]) {
-		blkno = bucket_blkno(xs->bucket);
-		ocfs2_xattr_bucket_relse(xs->bucket);
-		ret = ocfs2_read_xattr_bucket(xs->bucket, blkno);
-		if (ret) {
-			mlog_errno(ret);
-			goto out;
-		}
-	}
-
-	ocfs2_init_xattr_bucket_xa_loc(&loc, xs->bucket,
-				       xs->not_found ? NULL : xs->here);
-	ret = ocfs2_xa_set(&loc, xi, ctxt);
-	if (ret) {
-		if (ret != -ENOSPC)
-			mlog_errno(ret);
-		goto out;
-	}
-	xs->here = loc.xl_entry;
-
-out:
-	return ret;
-}
-
-/*
  * check whether the xattr bucket is filled up with the same hash value.
  * If we want to insert the xattr with the same hash, return -ENOSPC.
  * If we want to insert a xattr with different hash value, go ahead
@@ -5173,151 +5137,92 @@ static int ocfs2_xattr_set_entry_index_block(struct inode *inode,
 					     struct ocfs2_xattr_search *xs,
 					     struct ocfs2_xattr_set_ctxt *ctxt)
 {
-	struct ocfs2_xattr_header *xh;
-	struct ocfs2_xattr_entry *xe;
-	u16 count, header_size, xh_free_start;
-	int free, max_free, need, old;
-	size_t value_size = 0;
-	size_t blocksize = inode->i_sb->s_blocksize;
-	int ret, allocation = 0;
+	int ret;
+	struct ocfs2_xa_loc loc;
 
 	mlog_entry("Set xattr %s in xattr index block\n", xi->xi_name);
 
-try_again:
-	xh = xs->header;
-	count = le16_to_cpu(xh->xh_count);
-	xh_free_start = le16_to_cpu(xh->xh_free_start);
-	header_size = sizeof(struct ocfs2_xattr_header) +
-			count * sizeof(struct ocfs2_xattr_entry);
-	max_free = OCFS2_XATTR_BUCKET_SIZE - header_size -
-		le16_to_cpu(xh->xh_name_value_len) - OCFS2_XATTR_HEADER_GAP;
-
-	mlog_bug_on_msg(header_size > blocksize, "bucket %llu has header size "
-			"of %u which exceed block size\n",
-			(unsigned long long)bucket_blkno(xs->bucket),
-			header_size);
-
-	if (xi->xi_value && xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE)
-		value_size = OCFS2_XATTR_ROOT_SIZE;
-	else if (xi->xi_value)
-		value_size = OCFS2_XATTR_SIZE(xi->xi_value_len);
+	BUG_ON(!xs->bucket->bu_bhs[1]);
 
-	if (xs->not_found)
-		need = sizeof(struct ocfs2_xattr_entry) +
-			OCFS2_XATTR_SIZE(xi->xi_name_len) + value_size;
-	else {
-		need = value_size + OCFS2_XATTR_SIZE(xi->xi_name_len);
+	ocfs2_init_xattr_bucket_xa_loc(&loc, xs->bucket,
+				       xs->not_found ? NULL : xs->here);
+	ret = ocfs2_xa_set(&loc, xi, ctxt);
+	if (!ret) {
+		xs->here = loc.xl_entry;
+		goto out;
+	}
+	if (ret != -ENOSPC) {
+		mlog_errno(ret);
+		goto out;
+	}
 
-		/*
-		 * We only replace the old value if the new length is smaller
-		 * than the old one. Otherwise we will allocate new space in the
-		 * bucket to store it.
-		 */
-		xe = xs->here;
-		if (ocfs2_xattr_is_local(xe))
-			old = OCFS2_XATTR_SIZE(le64_to_cpu(xe->xe_value_size));
-		else
-			old = OCFS2_XATTR_SIZE(OCFS2_XATTR_ROOT_SIZE);
+	/* Ok, we need space.  Let's try defragmenting the bucket. */
+	ret = ocfs2_defrag_xattr_bucket(inode, ctxt->handle,
+					xs->bucket);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
 
-		if (old >= value_size)
-			need = 0;
+	ret = ocfs2_xa_set(&loc, xi, ctxt);
+	if (!ret) {
+		xs->here = loc.xl_entry;
+		goto out;
 	}
+	if (ret != -ENOSPC) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	/* Ack, need more space.  Let's try to get another bucket! */
 
-	free = xh_free_start - header_size - OCFS2_XATTR_HEADER_GAP;
 	/*
-	 * We need to make sure the new name/value pair
-	 * can exist in the same block.
+	 * We do not allow for overlapping ranges between buckets. And
+	 * the maximum number of collisions we will allow for then is
+	 * one bucket's worth, so check it here whether we need to
+	 * add a new bucket for the insert.
 	 */
-	if (xh_free_start % blocksize < need)
-		free -= xh_free_start % blocksize;
-
-	mlog(0, "xs->not_found = %d, in xattr bucket %llu: free = %d, "
-	     "need = %d, max_free = %d, xh_free_start = %u, xh_name_value_len ="
-	     " %u\n", xs->not_found,
-	     (unsigned long long)bucket_blkno(xs->bucket),
-	     free, need, max_free, le16_to_cpu(xh->xh_free_start),
-	     le16_to_cpu(xh->xh_name_value_len));
-
-	if (free < need ||
-	    (xs->not_found &&
-	     count == ocfs2_xattr_max_xe_in_bucket(inode->i_sb))) {
-		if (need <= max_free &&
-		    count < ocfs2_xattr_max_xe_in_bucket(inode->i_sb)) {
-			/*
-			 * We can create the space by defragment. Since only the
-			 * name/value will be moved, the xe shouldn't be changed
-			 * in xs.
-			 */
-			ret = ocfs2_defrag_xattr_bucket(inode, ctxt->handle,
-							xs->bucket);
-			if (ret) {
-				mlog_errno(ret);
-				goto out;
-			}
-
-			xh_free_start = le16_to_cpu(xh->xh_free_start);
-			free = xh_free_start - header_size
-				- OCFS2_XATTR_HEADER_GAP;
-			if (xh_free_start % blocksize < need)
-				free -= xh_free_start % blocksize;
-
-			if (free >= need)
-				goto xattr_set;
-
-			mlog(0, "Can't get enough space for xattr insert by "
-			     "defragment. Need %u bytes, but we have %d, so "
-			     "allocate new bucket for it.\n", need, free);
-		}
-
-		/*
-		 * We have to add new buckets or clusters and one
-		 * allocation should leave us enough space for insert.
-		 */
-		BUG_ON(allocation);
-
-		/*
-		 * We do not allow for overlapping ranges between buckets. And
-		 * the maximum number of collisions we will allow for then is
-		 * one bucket's worth, so check it here whether we need to
-		 * add a new bucket for the insert.
-		 */
-		ret = ocfs2_check_xattr_bucket_collision(inode,
-							 xs->bucket,
-							 xi->xi_name);
-		if (ret) {
-			mlog_errno(ret);
-			goto out;
-		}
-
-		ret = ocfs2_add_new_xattr_bucket(inode,
-						 xs->xattr_bh,
+	ret = ocfs2_check_xattr_bucket_collision(inode,
 						 xs->bucket,
-						 ctxt);
-		if (ret) {
-			mlog_errno(ret);
-			goto out;
-		}
+						 xi->xi_name);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
 
-		/*
-		 * ocfs2_add_new_xattr_bucket() will have updated
-		 * xs->bucket if it moved, but it will not have updated
-		 * any of the other search fields.  Thus, we drop it and
-		 * re-search.  Everything should be cached, so it'll be
-		 * quick.
-		 */
-		ocfs2_xattr_bucket_relse(xs->bucket);
-		ret = ocfs2_xattr_index_block_find(inode, xs->xattr_bh,
-						   xi->xi_name_index,
-						   xi->xi_name, xs);
-		if (ret && ret != -ENODATA)
-			goto out;
-		xs->not_found = ret;
-		allocation = 1;
-		goto try_again;
+	ret = ocfs2_add_new_xattr_bucket(inode,
+					 xs->xattr_bh,
+					 xs->bucket,
+					 ctxt);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
 	}
 
-xattr_set:
-	ret = ocfs2_xattr_set_in_bucket(inode, xi, xs, ctxt);
+	/*
+	 * ocfs2_add_new_xattr_bucket() will have updated
+	 * xs->bucket if it moved, but it will not have updated
+	 * any of the other search fields.  Thus, we drop it and
+	 * re-search.  Everything should be cached, so it'll be
+	 * quick.
+	 */
+	ocfs2_xattr_bucket_relse(xs->bucket);
+	ret = ocfs2_xattr_index_block_find(inode, xs->xattr_bh,
+					   xi->xi_name_index,
+					   xi->xi_name, xs);
+	if (ret && ret != -ENODATA)
+		goto out;
+	xs->not_found = ret;
+
+	/* We also need to re-init our ocfs2_xa_loc */
+	ocfs2_init_xattr_bucket_xa_loc(&loc, xs->bucket,
+				       xs->not_found ? NULL : xs->here);
+	ret = ocfs2_xa_set(&loc, xi, ctxt);
+	if (!ret)
+		xs->here = loc.xl_entry;
+	else if (ret != -ENOSPC)
+		mlog_errno(ret);
+
 out:
 	mlog_exit(ret);
 	return ret;
-- 
1.6.3.3
