From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Sat, 10 Dec 2016 12:43:09 -0800
Subject: [Ocfs2-devel] [PATCH 02/11] vfs: refactor clone/dedupe_file_range
	common functions
In-Reply-To: <148140257493.24628.6724911560073347399.stgit@birch.djwong.org>
References: <148140257493.24628.6724911560073347399.stgit@birch.djwong.org>
Message-ID: <148140258895.24628.5698855412967429160.stgit@birch.djwong.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@versity.com, akpm@linux-foundation.org, jlbec@evilplan.org, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, ocfs2-devel@oss.oracle.com

Hoist both the XFS reflink inode state and preparation code and the XFS
file blocks compare functions into the VFS so that ocfs2 can take
advantage of it for reflink and dedupe.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/read_write.c      |  204 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.c |  213 ++------------------------------------------------
 include/linux/fs.h   |    6 +
 3 files changed, 219 insertions(+), 204 deletions(-)


diff --git a/fs/read_write.c b/fs/read_write.c
index 6674a4b..dbf3f7f 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1667,6 +1667,114 @@ static int clone_verify_area(struct file *file, loff_t pos, u64 len, bool write)
 	return security_file_permission(file, write ? MAY_WRITE : MAY_READ);
 }
 
+/*
+ * Check that the two inodes are eligible for cloning, the ranges make
+ * sense, and then flush all dirty data.  Caller must ensure that the
+ * inodes have been locked against any other modifications.
+ */
+int vfs_clone_file_prep_inodes(struct inode *inode_in, loff_t pos_in,
+			       struct inode *inode_out, loff_t pos_out,
+			       u64 *len, bool is_dedupe)
+{
+	loff_t bs = inode_out->i_sb->s_blocksize;
+	loff_t blen;
+	loff_t isize;
+	bool same_inode = (inode_in == inode_out);
+	int ret;
+
+	/* Don't touch certain kinds of inodes */
+	if (IS_IMMUTABLE(inode_out))
+		return -EPERM;
+
+	if (IS_SWAPFILE(inode_in) || IS_SWAPFILE(inode_out))
+		return -ETXTBSY;
+
+	/* Don't reflink dirs, pipes, sockets... */
+	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
+		return -EISDIR;
+	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
+		return -EINVAL;
+
+	/* Are we going all the way to the end? */
+	isize = i_size_read(inode_in);
+	if (isize == 0) {
+		*len = 0;
+		return 0;
+	}
+
+	/* Zero length dedupe exits immediately; reflink goes to EOF. */
+	if (*len == 0) {
+		if (is_dedupe) {
+			*len = 0;
+			return 0;
+		}
+		*len = isize - pos_in;
+	}
+
+	/* Ensure offsets don't wrap and the input is inside i_size */
+	if (pos_in + *len < pos_in || pos_out + *len < pos_out ||
+	    pos_in + *len > isize)
+		return -EINVAL;
+
+	/* Don't allow dedupe past EOF in the dest file */
+	if (is_dedupe) {
+		loff_t	disize;
+
+		disize = i_size_read(inode_out);
+		if (pos_out >= disize || pos_out + *len > disize)
+			return -EINVAL;
+	}
+
+	/* If we're linking to EOF, continue to the block boundary. */
+	if (pos_in + *len == isize)
+		blen = ALIGN(isize, bs) - pos_in;
+	else
+		blen = *len;
+
+	/* Only reflink if we're aligned to block boundaries */
+	if (!IS_ALIGNED(pos_in, bs) || !IS_ALIGNED(pos_in + blen, bs) ||
+	    !IS_ALIGNED(pos_out, bs) || !IS_ALIGNED(pos_out + blen, bs))
+		return -EINVAL;
+
+	/* Don't allow overlapped reflink within the same file */
+	if (same_inode) {
+		if (pos_out + blen > pos_in && pos_out < pos_in + blen)
+			return -EINVAL;
+	}
+
+	/* Wait for the completion of any pending IOs on both files */
+	inode_dio_wait(inode_in);
+	if (!same_inode)
+		inode_dio_wait(inode_out);
+
+	ret = filemap_write_and_wait_range(inode_in->i_mapping,
+			pos_in, pos_in + *len - 1);
+	if (ret)
+		return ret;
+
+	ret = filemap_write_and_wait_range(inode_out->i_mapping,
+			pos_out, pos_out + *len - 1);
+	if (ret)
+		return ret;
+
+	/*
+	 * Check that the extents are the same.
+	 */
+	if (is_dedupe) {
+		bool		is_same = false;
+
+		ret = vfs_dedupe_file_range_compare(inode_in, pos_in,
+				inode_out, pos_out, *len, &is_same);
+		if (ret)
+			return ret;
+		if (!is_same)
+			return -EBADE;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(vfs_clone_file_prep_inodes);
+
 int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
 		struct file *file_out, loff_t pos_out, u64 len)
 {
@@ -1718,6 +1826,102 @@ int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
 }
 EXPORT_SYMBOL(vfs_clone_file_range);
 
+/*
+ * Read a page's worth of file data into the page cache.  Return the page
+ * locked.
+ */
+static struct page *vfs_dedupe_get_page(struct inode *inode, loff_t offset)
+{
+	struct address_space *mapping;
+	struct page *page;
+	pgoff_t n;
+
+	n = offset >> PAGE_SHIFT;
+	mapping = inode->i_mapping;
+	page = read_mapping_page(mapping, n, NULL);
+	if (IS_ERR(page))
+		return page;
+	if (!PageUptodate(page)) {
+		put_page(page);
+		return ERR_PTR(-EIO);
+	}
+	lock_page(page);
+	return page;
+}
+
+/*
+ * Compare extents of two files to see if they are the same.
+ * Caller must have locked both inodes to prevent write races.
+ */
+int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
+				  struct inode *dest, loff_t destoff,
+				  loff_t len, bool *is_same)
+{
+	loff_t src_poff;
+	loff_t dest_poff;
+	void *src_addr;
+	void *dest_addr;
+	struct page *src_page;
+	struct page *dest_page;
+	loff_t cmp_len;
+	bool same;
+	int error;
+
+	error = -EINVAL;
+	same = true;
+	while (len) {
+		src_poff = srcoff & (PAGE_SIZE - 1);
+		dest_poff = destoff & (PAGE_SIZE - 1);
+		cmp_len = min(PAGE_SIZE - src_poff,
+			      PAGE_SIZE - dest_poff);
+		cmp_len = min(cmp_len, len);
+		if (cmp_len <= 0)
+			goto out_error;
+
+		src_page = vfs_dedupe_get_page(src, srcoff);
+		if (IS_ERR(src_page)) {
+			error = PTR_ERR(src_page);
+			goto out_error;
+		}
+		dest_page = vfs_dedupe_get_page(dest, destoff);
+		if (IS_ERR(dest_page)) {
+			error = PTR_ERR(dest_page);
+			unlock_page(src_page);
+			put_page(src_page);
+			goto out_error;
+		}
+		src_addr = kmap_atomic(src_page);
+		dest_addr = kmap_atomic(dest_page);
+
+		flush_dcache_page(src_page);
+		flush_dcache_page(dest_page);
+
+		if (memcmp(src_addr + src_poff, dest_addr + dest_poff, cmp_len))
+			same = false;
+
+		kunmap_atomic(dest_addr);
+		kunmap_atomic(src_addr);
+		unlock_page(dest_page);
+		unlock_page(src_page);
+		put_page(dest_page);
+		put_page(src_page);
+
+		if (!same)
+			break;
+
+		srcoff += cmp_len;
+		destoff += cmp_len;
+		len -= cmp_len;
+	}
+
+	*is_same = same;
+	return 0;
+
+out_error:
+	return error;
+}
+EXPORT_SYMBOL(vfs_dedupe_file_range_compare);
+
 int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
 {
 	struct file_dedupe_range_info *info;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index a279b4e..95d6828 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1165,111 +1165,6 @@ xfs_reflink_remap_blocks(
 }
 
 /*
- * Read a page's worth of file data into the page cache.  Return the page
- * locked.
- */
-static struct page *
-xfs_get_page(
-	struct inode	*inode,
-	xfs_off_t	offset)
-{
-	struct address_space	*mapping;
-	struct page		*page;
-	pgoff_t			n;
-
-	n = offset >> PAGE_SHIFT;
-	mapping = inode->i_mapping;
-	page = read_mapping_page(mapping, n, NULL);
-	if (IS_ERR(page))
-		return page;
-	if (!PageUptodate(page)) {
-		put_page(page);
-		return ERR_PTR(-EIO);
-	}
-	lock_page(page);
-	return page;
-}
-
-/*
- * Compare extents of two files to see if they are the same.
- */
-static int
-xfs_compare_extents(
-	struct inode	*src,
-	xfs_off_t	srcoff,
-	struct inode	*dest,
-	xfs_off_t	destoff,
-	xfs_off_t	len,
-	bool		*is_same)
-{
-	xfs_off_t	src_poff;
-	xfs_off_t	dest_poff;
-	void		*src_addr;
-	void		*dest_addr;
-	struct page	*src_page;
-	struct page	*dest_page;
-	xfs_off_t	cmp_len;
-	bool		same;
-	int		error;
-
-	error = -EINVAL;
-	same = true;
-	while (len) {
-		src_poff = srcoff & (PAGE_SIZE - 1);
-		dest_poff = destoff & (PAGE_SIZE - 1);
-		cmp_len = min(PAGE_SIZE - src_poff,
-			      PAGE_SIZE - dest_poff);
-		cmp_len = min(cmp_len, len);
-		ASSERT(cmp_len > 0);
-
-		trace_xfs_reflink_compare_extents(XFS_I(src), srcoff, cmp_len,
-				XFS_I(dest), destoff);
-
-		src_page = xfs_get_page(src, srcoff);
-		if (IS_ERR(src_page)) {
-			error = PTR_ERR(src_page);
-			goto out_error;
-		}
-		dest_page = xfs_get_page(dest, destoff);
-		if (IS_ERR(dest_page)) {
-			error = PTR_ERR(dest_page);
-			unlock_page(src_page);
-			put_page(src_page);
-			goto out_error;
-		}
-		src_addr = kmap_atomic(src_page);
-		dest_addr = kmap_atomic(dest_page);
-
-		flush_dcache_page(src_page);
-		flush_dcache_page(dest_page);
-
-		if (memcmp(src_addr + src_poff, dest_addr + dest_poff, cmp_len))
-			same = false;
-
-		kunmap_atomic(dest_addr);
-		kunmap_atomic(src_addr);
-		unlock_page(dest_page);
-		unlock_page(src_page);
-		put_page(dest_page);
-		put_page(src_page);
-
-		if (!same)
-			break;
-
-		srcoff += cmp_len;
-		destoff += cmp_len;
-		len -= cmp_len;
-	}
-
-	*is_same = same;
-	return 0;
-
-out_error:
-	trace_xfs_reflink_compare_extents_error(XFS_I(dest), error, _RET_IP_);
-	return error;
-}
-
-/*
  * Link a range of blocks from one file to another.
  */
 int
@@ -1286,14 +1181,11 @@ xfs_reflink_remap_range(
 	struct inode		*inode_out = file_inode(file_out);
 	struct xfs_inode	*dest = XFS_I(inode_out);
 	struct xfs_mount	*mp = src->i_mount;
-	loff_t			bs = inode_out->i_sb->s_blocksize;
 	bool			same_inode = (inode_in == inode_out);
 	xfs_fileoff_t		sfsbno, dfsbno;
 	xfs_filblks_t		fsblen;
 	xfs_extlen_t		cowextsize;
-	loff_t			isize;
 	ssize_t			ret;
-	loff_t			blen;
 
 	if (!xfs_sb_version_hasreflink(&mp->m_sb))
 		return -EOPNOTSUPP;
@@ -1310,26 +1202,8 @@ xfs_reflink_remap_range(
 		xfs_lock_two_inodes(src, dest, XFS_MMAPLOCK_EXCL);
 	}
 
-	/* Don't touch certain kinds of inodes */
-	ret = -EPERM;
-	if (IS_IMMUTABLE(inode_out))
-		goto out_unlock;
-
-	ret = -ETXTBSY;
-	if (IS_SWAPFILE(inode_in) || IS_SWAPFILE(inode_out))
-		goto out_unlock;
-
-
-	/* Don't reflink dirs, pipes, sockets... */
-	ret = -EISDIR;
-	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
-		goto out_unlock;
+	/* Check file eligibility and prepare for block sharing. */
 	ret = -EINVAL;
-	if (S_ISFIFO(inode_in->i_mode) || S_ISFIFO(inode_out->i_mode))
-		goto out_unlock;
-	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
-		goto out_unlock;
-
 	/* Don't reflink realtime inodes */
 	if (XFS_IS_REALTIME_INODE(src) || XFS_IS_REALTIME_INODE(dest))
 		goto out_unlock;
@@ -1338,91 +1212,18 @@ xfs_reflink_remap_range(
 	if (IS_DAX(inode_in) || IS_DAX(inode_out))
 		goto out_unlock;
 
-	/* Are we going all the way to the end? */
-	isize = i_size_read(inode_in);
-	if (isize == 0) {
-		ret = 0;
-		goto out_unlock;
-	}
-
-	if (len == 0)
-		len = isize - pos_in;
-
-	/* Ensure offsets don't wrap and the input is inside i_size */
-	if (pos_in + len < pos_in || pos_out + len < pos_out ||
-	    pos_in + len > isize)
-		goto out_unlock;
-
-	/* Don't allow dedupe past EOF in the dest file */
-	if (is_dedupe) {
-		loff_t	disize;
-
-		disize = i_size_read(inode_out);
-		if (pos_out >= disize || pos_out + len > disize)
-			goto out_unlock;
-	}
-
-	/* If we're linking to EOF, continue to the block boundary. */
-	if (pos_in + len == isize)
-		blen = ALIGN(isize, bs) - pos_in;
-	else
-		blen = len;
-
-	/* Only reflink if we're aligned to block boundaries */
-	if (!IS_ALIGNED(pos_in, bs) || !IS_ALIGNED(pos_in + blen, bs) ||
-	    !IS_ALIGNED(pos_out, bs) || !IS_ALIGNED(pos_out + blen, bs))
-		goto out_unlock;
-
-	/* Don't allow overlapped reflink within the same file */
-	if (same_inode) {
-		if (pos_out + blen > pos_in && pos_out < pos_in + blen)
-			goto out_unlock;
-	}
-
-	/* Wait for the completion of any pending IOs on both files */
-	inode_dio_wait(inode_in);
-	if (!same_inode)
-		inode_dio_wait(inode_out);
-
-	ret = filemap_write_and_wait_range(inode_in->i_mapping,
-			pos_in, pos_in + len - 1);
-	if (ret)
-		goto out_unlock;
-
-	ret = filemap_write_and_wait_range(inode_out->i_mapping,
-			pos_out, pos_out + len - 1);
-	if (ret)
+	ret = vfs_clone_file_prep_inodes(inode_in, pos_in, inode_out, pos_out,
+			&len, is_dedupe);
+	if (ret || len == 0)
 		goto out_unlock;
 
 	trace_xfs_reflink_remap_range(src, pos_in, len, dest, pos_out);
 
-	/*
-	 * Check that the extents are the same.
-	 */
-	if (is_dedupe) {
-		bool		is_same = false;
-
-		ret = xfs_compare_extents(inode_in, pos_in, inode_out, pos_out,
-				len, &is_same);
-		if (ret)
-			goto out_unlock;
-		if (!is_same) {
-			ret = -EBADE;
-			goto out_unlock;
-		}
-	}
-
+	/* Set flags and remap blocks. */
 	ret = xfs_reflink_set_inode_flag(src, dest);
 	if (ret)
 		goto out_unlock;
 
-	/*
-	 * Invalidate the page cache so that we can clear any CoW mappings
-	 * in the destination file.
-	 */
-	truncate_inode_pages_range(&inode_out->i_data, pos_out,
-				   PAGE_ALIGN(pos_out + len) - 1);
-
 	dfsbno = XFS_B_TO_FSBT(mp, pos_out);
 	sfsbno = XFS_B_TO_FSBT(mp, pos_in);
 	fsblen = XFS_B_TO_FSB(mp, len);
@@ -1431,6 +1232,10 @@ xfs_reflink_remap_range(
 	if (ret)
 		goto out_unlock;
 
+	/* Zap any page cache for the destination file's range. */
+	truncate_inode_pages_range(&inode_out->i_data, pos_out,
+				   PAGE_ALIGN(pos_out + len) - 1);
+
 	/*
 	 * Carry the cowextsize hint from src to dest if we're sharing the
 	 * entire source file to the entire destination file, the source file
diff --git a/include/linux/fs.h b/include/linux/fs.h
index dc0478c..caea736 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1778,8 +1778,14 @@ extern ssize_t vfs_writev(struct file *, const struct iovec __user *,
 		unsigned long, loff_t *, int);
 extern ssize_t vfs_copy_file_range(struct file *, loff_t , struct file *,
 				   loff_t, size_t, unsigned int);
+extern int vfs_clone_file_prep_inodes(struct inode *inode_in, loff_t pos_in,
+				      struct inode *inode_out, loff_t pos_out,
+				      u64 *len, bool is_dedupe);
 extern int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
 		struct file *file_out, loff_t pos_out, u64 len);
+extern int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
+					 struct inode *dest, loff_t destoff,
+					 loff_t len, bool *is_same);
 extern int vfs_dedupe_file_range(struct file *file,
 				 struct file_dedupe_range *same);
 
