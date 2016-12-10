From: Christoph Hellwig <hch@lst.de>
Date: Sat, 10 Dec 2016 12:43:02 -0800
Subject: [Ocfs2-devel] [PATCH 01/11] fs: try to clone files first in
	vfs_copy_file_range
In-Reply-To: <148140257493.24628.6724911560073347399.stgit@birch.djwong.org>
References: <148140257493.24628.6724911560073347399.stgit@birch.djwong.org>
Message-ID: <148140258233.24628.15360929802122987958.stgit@birch.djwong.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@versity.com, akpm@linux-foundation.org, jlbec@evilplan.org, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, ocfs2-devel@oss.oracle.com

A clone is a perfectly fine implementation of a file copy, so most
file systems just implement the copy that way.  Instead of duplicating
this logic move it to the VFS.  Currently btrfs and XFS implement copies
the same way as clones and there is no behavior change for them, cifs
only implements clones and grow support for copy_file_range with this
patch.  NFS implements both, so this will allow copy_file_range to work
on servers that only implement CLONE and be lot more efficient on servers
that implements CLONE and COPY.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/btrfs/ctree.h  |    3 ---
 fs/btrfs/file.c   |    1 -
 fs/btrfs/ioctl.c  |   12 ------------
 fs/read_write.c   |   27 ++++++++++++++++++++++-----
 fs/xfs/xfs_file.c |   19 -------------------
 5 files changed, 22 insertions(+), 40 deletions(-)


diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0b8ce2b..05f75a9 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3232,9 +3232,6 @@ int btrfs_dirty_pages(struct btrfs_root *root, struct inode *inode,
 		      loff_t pos, size_t write_bytes,
 		      struct extent_state **cached);
 int btrfs_fdatawrite_range(struct inode *inode, loff_t start, loff_t end);
-ssize_t btrfs_copy_file_range(struct file *file_in, loff_t pos_in,
-			      struct file *file_out, loff_t pos_out,
-			      size_t len, unsigned int flags);
 int btrfs_clone_file_range(struct file *file_in, loff_t pos_in,
 			   struct file *file_out, loff_t pos_out, u64 len);
 
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 3a14c87..991cc99 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2998,7 +2998,6 @@ const struct file_operations btrfs_file_operations = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= btrfs_compat_ioctl,
 #endif
-	.copy_file_range = btrfs_copy_file_range,
 	.clone_file_range = btrfs_clone_file_range,
 	.dedupe_file_range = btrfs_dedupe_file_range,
 };
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7acbd2c..dab7462 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3980,18 +3980,6 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
 	return ret;
 }
 
-ssize_t btrfs_copy_file_range(struct file *file_in, loff_t pos_in,
-			      struct file *file_out, loff_t pos_out,
-			      size_t len, unsigned int flags)
-{
-	ssize_t ret;
-
-	ret = btrfs_clone_files(file_out, file_in, pos_in, len, pos_out);
-	if (ret == 0)
-		ret = len;
-	return ret;
-}
-
 int btrfs_clone_file_range(struct file *src_file, loff_t off,
 		struct file *dst_file, loff_t destoff, u64 len)
 {
diff --git a/fs/read_write.c b/fs/read_write.c
index 190e0d36..6674a4b 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1542,20 +1542,37 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 	if (ret)
 		return ret;
 
-	ret = -EOPNOTSUPP;
-	if (file_out->f_op->copy_file_range)
+	/*
+	 * Try cloning first, this is supported by more file systems, and
+	 * more efficient if both clone and copy are supported (e.g. NFS).
+	 */
+	if (file_in->f_op->clone_file_range) {
+		ret = file_in->f_op->clone_file_range(file_in, pos_in,
+				file_out, pos_out, len);
+		if (ret == 0) {
+			ret = len;
+			goto done;
+		}
+	}
+
+	if (file_out->f_op->copy_file_range) {
 		ret = file_out->f_op->copy_file_range(file_in, pos_in, file_out,
 						      pos_out, len, flags);
-	if (ret == -EOPNOTSUPP)
-		ret = do_splice_direct(file_in, &pos_in, file_out, &pos_out,
-				len > MAX_RW_COUNT ? MAX_RW_COUNT : len, 0);
+		if (ret != -EOPNOTSUPP)
+			goto done;
+	}
 
+	ret = do_splice_direct(file_in, &pos_in, file_out, &pos_out,
+			len > MAX_RW_COUNT ? MAX_RW_COUNT : len, 0);
+
+done:
 	if (ret > 0) {
 		fsnotify_access(file_in);
 		add_rchar(current, ret);
 		fsnotify_modify(file_out);
 		add_wchar(current, ret);
 	}
+
 	inc_syscr(current);
 	inc_syscw(current);
 
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 6e4f7f9..86ecc9b 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -909,24 +909,6 @@ xfs_file_fallocate(
 	return error;
 }
 
-STATIC ssize_t
-xfs_file_copy_range(
-	struct file	*file_in,
-	loff_t		pos_in,
-	struct file	*file_out,
-	loff_t		pos_out,
-	size_t		len,
-	unsigned int	flags)
-{
-	int		error;
-
-	error = xfs_reflink_remap_range(file_in, pos_in, file_out, pos_out,
-				     len, false);
-	if (error)
-		return error;
-	return len;
-}
-
 STATIC int
 xfs_file_clone_range(
 	struct file	*file_in,
@@ -1625,7 +1607,6 @@ const struct file_operations xfs_file_operations = {
 	.fsync		= xfs_file_fsync,
 	.get_unmapped_area = thp_get_unmapped_area,
 	.fallocate	= xfs_file_fallocate,
-	.copy_file_range = xfs_file_copy_range,
 	.clone_file_range = xfs_file_clone_range,
 	.dedupe_file_range = xfs_file_dedupe_range,
 };
