From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Sep 19 13:12:22 2007
Subject: [Ocfs2-devel] [PATCH 04/15] ocfs2: Abstract out core dir listing
	functionality
Message-ID: <200709192012.l8JKCGaj029285@rgmgw2.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Put this in it's own function so that the functionality can be overridden.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/dir.c |  103 ++++++++++++++++++++++++++++++-------------------------
 1 files changed, 56 insertions(+), 47 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 8e0ae02..d1f92fd 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -414,11 +414,8 @@ bail:
 	return retval;
 }
 
-/*
- * ocfs2_readdir()
- *
- */
-int ocfs2_readdir(struct file * filp, void * dirent, filldir_t filldir)
+static int ocfs2_dir_foreach_blk(struct inode *inode, unsigned long *f_version,
+				 loff_t *f_pos, void *priv, filldir_t filldir)
 {
 	int error = 0;
 	unsigned long offset, blk, last_ra_blk = 0;
@@ -426,45 +423,23 @@ int ocfs2_readdir(struct file * filp, void * dirent, filldir_t filldir)
 	struct buffer_head * bh, * tmp;
 	struct ocfs2_dir_entry * de;
 	int err;
-	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct super_block * sb = inode->i_sb;
 	unsigned int ra_sectors = 16;
-	int lock_level = 0;
-
-	mlog_entry("dirino=%llu\n",
-		   (unsigned long long)OCFS2_I(inode)->ip_blkno);
 
 	stored = 0;
 	bh = NULL;
 
-	error = ocfs2_meta_lock_atime(inode, filp->f_vfsmnt, &lock_level);
-	if (lock_level && error >= 0) {
-		/* We release EX lock which used to update atime
-		 * and get PR lock again to reduce contention
-		 * on commonly accessed directories. */
-		ocfs2_meta_unlock(inode, 1);
-		lock_level = 0;
-		error = ocfs2_meta_lock(inode, NULL, 0);
-	}
-	if (error < 0) {
-		if (error != -ENOENT)
-			mlog_errno(error);
-		/* we haven't got any yet, so propagate the error. */
-		stored = error;
-		goto bail_nolock;
-	}
-
-	offset = filp->f_pos & (sb->s_blocksize - 1);
+	offset = (*f_pos) & (sb->s_blocksize - 1);
 
-	while (!error && !stored && filp->f_pos < i_size_read(inode)) {
-		blk = (filp->f_pos) >> sb->s_blocksize_bits;
+	while (!error && !stored && *f_pos < i_size_read(inode)) {
+		blk = (*f_pos) >> sb->s_blocksize_bits;
 		bh = ocfs2_bread(inode, blk, &err, 0);
 		if (!bh) {
 			mlog(ML_ERROR,
 			     "directory #%llu contains a hole at offset %lld\n",
 			     (unsigned long long)OCFS2_I(inode)->ip_blkno,
-			     filp->f_pos);
-			filp->f_pos += sb->s_blocksize - offset;
+			     *f_pos);
+			*f_pos += sb->s_blocksize - offset;
 			continue;
 		}
 
@@ -490,7 +465,7 @@ revalidate:
 		 * readdir(2), then we might be pointing to an invalid
 		 * dirent right now.  Scan from the start of the block
 		 * to make sure. */
-		if (filp->f_version != inode->i_version) {
+		if (*f_version != inode->i_version) {
 			for (i = 0; i < sb->s_blocksize && i < offset; ) {
 				de = (struct ocfs2_dir_entry *) (bh->b_data + i);
 				/* It's too expensive to do a full
@@ -505,21 +480,20 @@ revalidate:
 				i += le16_to_cpu(de->rec_len);
 			}
 			offset = i;
-			filp->f_pos = (filp->f_pos & ~(sb->s_blocksize - 1))
+			*f_pos = ((*f_pos) & ~(sb->s_blocksize - 1))
 				| offset;
-			filp->f_version = inode->i_version;
+			*f_version = inode->i_version;
 		}
 
-		while (!error && filp->f_pos < i_size_read(inode)
+		while (!error && *f_pos < i_size_read(inode)
 		       && offset < sb->s_blocksize) {
 			de = (struct ocfs2_dir_entry *) (bh->b_data + offset);
 			if (!ocfs2_check_dir_entry(inode, de, bh, offset)) {
 				/* On error, skip the f_pos to the
 				   next block. */
-				filp->f_pos = (filp->f_pos |
-					       (sb->s_blocksize - 1)) + 1;
+				*f_pos = ((*f_pos) | (sb->s_blocksize - 1)) + 1;
 				brelse(bh);
-				goto bail;
+				goto out;
 			}
 			offset += le16_to_cpu(de->rec_len);
 			if (le64_to_cpu(de->inode)) {
@@ -530,36 +504,71 @@ revalidate:
 				 * not the directory has been modified
 				 * during the copy operation.
 				 */
-				unsigned long version = filp->f_version;
+				unsigned long version = *f_version;
 				unsigned char d_type = DT_UNKNOWN;
 
 				if (de->file_type < OCFS2_FT_MAX)
 					d_type = ocfs2_filetype_table[de->file_type];
-				error = filldir(dirent, de->name,
+				error = filldir(priv, de->name,
 						de->name_len,
-						filp->f_pos,
+						*f_pos,
 						ino_from_blkno(sb, le64_to_cpu(de->inode)),
 						d_type);
 				if (error)
 					break;
-				if (version != filp->f_version)
+				if (version != *f_version)
 					goto revalidate;
 				stored ++;
 			}
-			filp->f_pos += le16_to_cpu(de->rec_len);
+			*f_pos += le16_to_cpu(de->rec_len);
 		}
 		offset = 0;
 		brelse(bh);
 	}
 
 	stored = 0;
-bail:
+out:
+	return stored;
+}
+
+/*
+ * ocfs2_readdir()
+ *
+ */
+int ocfs2_readdir(struct file * filp, void * dirent, filldir_t filldir)
+{
+	int error = 0;
+	struct inode *inode = filp->f_path.dentry->d_inode;
+	int lock_level = 0;
+
+	mlog_entry("dirino=%llu\n",
+		   (unsigned long long)OCFS2_I(inode)->ip_blkno);
+
+	error = ocfs2_meta_lock_atime(inode, filp->f_vfsmnt, &lock_level);
+	if (lock_level && error >= 0) {
+		/* We release EX lock which used to update atime
+		 * and get PR lock again to reduce contention
+		 * on commonly accessed directories. */
+		ocfs2_meta_unlock(inode, 1);
+		lock_level = 0;
+		error = ocfs2_meta_lock(inode, NULL, 0);
+	}
+	if (error < 0) {
+		if (error != -ENOENT)
+			mlog_errno(error);
+		/* we haven't got any yet, so propagate the error. */
+		goto bail_nolock;
+	}
+
+	error = ocfs2_dir_foreach_blk(inode, &filp->f_version, &filp->f_pos,
+				      dirent, filldir);
+
 	ocfs2_meta_unlock(inode, lock_level);
 
 bail_nolock:
-	mlog_exit(stored);
+	mlog_exit(error);
 
-	return stored;
+	return error;
 }
 
 /*
-- 
1.5.0.6
