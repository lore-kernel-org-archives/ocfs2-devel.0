From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 19 Dec 2008 13:53:57 -0800
Subject: [Ocfs2-devel] [PATCH 38/45] ocfs2: Wrap dirblock reads in a
	dedicated function.
In-Reply-To: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
References: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
Message-ID: <1229723644-13630-39-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Joel Becker <joel.becker@oracle.com>

We have ocfs2_bread() as a vestige of the original ext-based dir code.
It's only used by directories, though.  Turn it into
ocfs2_read_dir_block(), with a prototype matching the other metadata
read functions.  It's set up to validate dirblocks when the time comes.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dir.c |  150 +++++++++++++++++++++++++++++++++-----------------------
 1 files changed, 88 insertions(+), 62 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 5777045..c2f3fd9 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -82,49 +82,6 @@ static int ocfs2_do_extend_dir(struct super_block *sb,
 			       struct ocfs2_alloc_context *meta_ac,
 			       struct buffer_head **new_bh);
 
-static struct buffer_head *ocfs2_bread(struct inode *inode,
-				       int block, int *err, int reada)
-{
-	struct buffer_head *bh = NULL;
-	int tmperr;
-	u64 p_blkno;
-	int readflags = 0;
-
-	if (reada)
-		readflags |= OCFS2_BH_READAHEAD;
-
-	if (((u64)block << inode->i_sb->s_blocksize_bits) >=
-	    i_size_read(inode)) {
-		BUG_ON(!reada);
-		return NULL;
-	}
-
-	down_read(&OCFS2_I(inode)->ip_alloc_sem);
-	tmperr = ocfs2_extent_map_get_blocks(inode, block, &p_blkno, NULL,
-					     NULL);
-	up_read(&OCFS2_I(inode)->ip_alloc_sem);
-	if (tmperr < 0) {
-		mlog_errno(tmperr);
-		goto fail;
-	}
-
-	tmperr = ocfs2_read_blocks(inode, p_blkno, 1, &bh, readflags);
-	if (tmperr < 0)
-		goto fail;
-
-	tmperr = 0;
-
-	*err = 0;
-	return bh;
-
-fail:
-	brelse(bh);
-	bh = NULL;
-
-	*err = -EIO;
-	return NULL;
-}
-
 /*
  * bh passed here can be an inode block or a dir data block, depending
  * on the inode inline data flag.
@@ -250,6 +207,76 @@ out:
 	return NULL;
 }
 
+static int ocfs2_validate_dir_block(struct super_block *sb,
+				    struct buffer_head *bh)
+{
+	/*
+	 * Nothing yet.  We don't validate dirents here, that's handled
+	 * in-place when the code walks them.
+	 */
+
+	return 0;
+}
+
+/*
+ * This function forces all errors to -EIO for consistency with its
+ * predecessor, ocfs2_bread().  We haven't audited what returning the
+ * real error codes would do to callers.  We log the real codes with
+ * mlog_errno() before we squash them.
+ */
+static int ocfs2_read_dir_block(struct inode *inode, u64 v_block,
+				struct buffer_head **bh, int flags)
+{
+	int rc = 0;
+	struct buffer_head *tmp = *bh;
+	u64 p_blkno;
+
+	if (((u64)v_block << inode->i_sb->s_blocksize_bits) >=
+	    i_size_read(inode)) {
+		BUG_ON(!(flags & OCFS2_BH_READAHEAD));
+		goto out;
+	}
+
+	down_read(&OCFS2_I(inode)->ip_alloc_sem);
+	rc = ocfs2_extent_map_get_blocks(inode, v_block, &p_blkno, NULL,
+					 NULL);
+	up_read(&OCFS2_I(inode)->ip_alloc_sem);
+	if (rc) {
+		mlog_errno(rc);
+		goto out;
+	}
+
+	if (!p_blkno) {
+		rc = -EIO;
+		mlog(ML_ERROR,
+		     "Directory #%llu contains a hole at offset %llu\n",
+		     (unsigned long long)OCFS2_I(inode)->ip_blkno,
+		     (unsigned long long)v_block << inode->i_sb->s_blocksize_bits);
+		goto out;
+	}
+
+	rc = ocfs2_read_blocks(inode, p_blkno, 1, &tmp, flags);
+	if (rc) {
+		mlog_errno(rc);
+		goto out;
+	}
+
+	if (!(flags & OCFS2_BH_READAHEAD)) {
+		rc = ocfs2_validate_dir_block(inode->i_sb, tmp);
+		if (rc) {
+			brelse(tmp);
+			goto out;
+		}
+	}
+
+	/* If ocfs2_read_blocks() got us a new bh, pass it up.  */
+	if (!*bh)
+		*bh = tmp;
+
+out:
+	return rc ? -EIO : 0;
+}
+
 static struct buffer_head *ocfs2_find_entry_el(const char *name, int namelen,
 					       struct inode *dir,
 					       struct ocfs2_dir_entry **res_dir)
@@ -296,15 +323,17 @@ restart:
 				}
 				num++;
 
-				bh = ocfs2_bread(dir, b++, &err, 1);
+				bh = NULL;
+				err = ocfs2_read_dir_block(dir, b++, &bh,
+							   OCFS2_BH_READAHEAD);
 				bh_use[ra_max] = bh;
 			}
 		}
 		if ((bh = bh_use[ra_ptr++]) == NULL)
 			goto next;
-		if (ocfs2_read_block(dir, block, &bh)) {
+		if (ocfs2_read_dir_block(dir, block, &bh, 0)) {
 			/* read error, skip block & hope for the best.
-			 * ocfs2_read_block() has released the bh. */
+			 * ocfs2_read_dir_block() has released the bh. */
 			ocfs2_error(dir->i_sb, "reading directory %llu, "
 				    "offset %lu\n",
 				    (unsigned long long)OCFS2_I(dir)->ip_blkno,
@@ -724,7 +753,6 @@ static int ocfs2_dir_foreach_blk_el(struct inode *inode,
 	int i, stored;
 	struct buffer_head * bh, * tmp;
 	struct ocfs2_dir_entry * de;
-	int err;
 	struct super_block * sb = inode->i_sb;
 	unsigned int ra_sectors = 16;
 
@@ -735,12 +763,8 @@ static int ocfs2_dir_foreach_blk_el(struct inode *inode,
 
 	while (!error && !stored && *f_pos < i_size_read(inode)) {
 		blk = (*f_pos) >> sb->s_blocksize_bits;
-		bh = ocfs2_bread(inode, blk, &err, 0);
-		if (!bh) {
-			mlog(ML_ERROR,
-			     "directory #%llu contains a hole at offset %lld\n",
-			     (unsigned long long)OCFS2_I(inode)->ip_blkno,
-			     *f_pos);
+		if (ocfs2_read_dir_block(inode, blk, &bh, 0)) {
+			/* Skip the corrupt dirblock and keep trying */
 			*f_pos += sb->s_blocksize - offset;
 			continue;
 		}
@@ -754,8 +778,10 @@ static int ocfs2_dir_foreach_blk_el(struct inode *inode,
 		    || (((last_ra_blk - blk) << 9) <= (ra_sectors / 2))) {
 			for (i = ra_sectors >> (sb->s_blocksize_bits - 9);
 			     i > 0; i--) {
-				tmp = ocfs2_bread(inode, ++blk, &err, 1);
-				brelse(tmp);
+				tmp = NULL;
+				if (!ocfs2_read_dir_block(inode, ++blk, &tmp,
+							  OCFS2_BH_READAHEAD))
+					brelse(tmp);
 			}
 			last_ra_blk = blk;
 			ra_sectors = 8;
@@ -828,6 +854,7 @@ revalidate:
 		}
 		offset = 0;
 		brelse(bh);
+		bh = NULL;
 	}
 
 	stored = 0;
@@ -1680,8 +1707,8 @@ static int ocfs2_find_dir_space_el(struct inode *dir, const char *name,
 	struct super_block *sb = dir->i_sb;
 	int status;
 
-	bh = ocfs2_bread(dir, 0, &status, 0);
-	if (!bh) {
+	status = ocfs2_read_dir_block(dir, 0, &bh, 0);
+	if (status) {
 		mlog_errno(status);
 		goto bail;
 	}
@@ -1702,11 +1729,10 @@ static int ocfs2_find_dir_space_el(struct inode *dir, const char *name,
 				status = -ENOSPC;
 				goto bail;
 			}
-			bh = ocfs2_bread(dir,
-					 offset >> sb->s_blocksize_bits,
-					 &status,
-					 0);
-			if (!bh) {
+			status = ocfs2_read_dir_block(dir,
+					     offset >> sb->s_blocksize_bits,
+					     &bh, 0);
+			if (status) {
 				mlog_errno(status);
 				goto bail;
 			}
-- 
1.5.6
