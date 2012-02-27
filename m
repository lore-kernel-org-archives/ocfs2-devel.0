From: Dave Kleikamp <dave.kleikamp@oracle.com>
Date: Mon, 27 Feb 2012 21:20:29 -0000
Subject: [Ocfs2-devel] [RFC PATCH 19/22] ocfs2: add support for read_iter,
	write_iter, and direct_IO_bvec
In-Reply-To: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
References: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
Message-ID: <1330377576-3659-20-git-send-email-dave.kleikamp@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>, Dave Kleikamp <dave.kleikamp@oracle.com>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com

From: Zach Brown <zab@zabbo.net>

ocfs2's .aio_read and .aio_write methods are changed to take
iov_iter and pass it to generic functions.  Wrappers are made to pack
the iovecs into iters and call these new functions.

ocfs2_direct_IO() is trivial enough that a new function is made which
passes the bvec down to the generic direct path.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel at oss.oracle.com
---
 fs/ocfs2/aops.c        |   31 ++++++++++++++++++
 fs/ocfs2/file.c        |   82 ++++++++++++++++++++++++++++++++++--------------
 fs/ocfs2/ocfs2_trace.h |    6 +++-
 3 files changed, 94 insertions(+), 25 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 78b68af..80183df 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -645,6 +645,36 @@ static ssize_t ocfs2_direct_IO(int rw,
 				    ocfs2_dio_end_io, NULL, 0);
 }
 
+static ssize_t ocfs2_direct_IO_bvec(int rw,
+				    struct kiocb *iocb,
+				    struct bio_vec *bvec,
+				    loff_t offset,
+				    unsigned long bvec_len)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file->f_path.dentry->d_inode->i_mapping->host;
+	int ret;
+
+	/*
+	 * Fallback to buffered I/O if we see an inode without
+	 * extents.
+	 */
+	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
+		return 0;
+
+	/* Fallback to buffered I/O if we are appending. */
+	if (i_size_read(inode) <= offset)
+		return 0;
+
+	ret = blockdev_direct_IO_bvec_no_locking(rw, iocb, inode,
+						 inode->i_sb->s_bdev, bvec,
+						 offset, bvec_len,
+						 ocfs2_direct_IO_get_blocks,
+						 ocfs2_dio_end_io);
+
+	return ret;
+}
+
 static void ocfs2_figure_cluster_boundaries(struct ocfs2_super *osb,
 					    u32 cpos,
 					    unsigned int *start,
@@ -2091,6 +2121,7 @@ const struct address_space_operations ocfs2_aops = {
 	.write_end		= ocfs2_write_end,
 	.bmap			= ocfs2_bmap,
 	.direct_IO		= ocfs2_direct_IO,
+	.direct_IO_bvec		= ocfs2_direct_IO_bvec,
 	.invalidatepage		= ocfs2_invalidatepage,
 	.releasepage		= ocfs2_releasepage,
 	.migratepage		= buffer_migrate_page,
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 061591a..f636813 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2233,15 +2233,13 @@ out:
 	return ret;
 }
 
-static ssize_t ocfs2_file_aio_write(struct kiocb *iocb,
-				    const struct iovec *iov,
-				    unsigned long nr_segs,
-				    loff_t pos)
+static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
+				     struct iov_iter *iter,
+				     loff_t pos)
 {
 	int ret, direct_io, appending, rw_level, have_alloc_sem  = 0;
 	int can_do_direct, has_refcount = 0;
 	ssize_t written = 0;
-	size_t ocount;		/* original count */
 	size_t count;		/* after file limit checks */
 	loff_t old_size, *ppos = &iocb->ki_pos;
 	u32 old_clusters;
@@ -2252,11 +2250,11 @@ static ssize_t ocfs2_file_aio_write(struct kiocb *iocb,
 			       OCFS2_MOUNT_COHERENCY_BUFFERED);
 	int unaligned_dio = 0;
 
-	trace_ocfs2_file_aio_write(inode, file, file->f_path.dentry,
+	trace_ocfs2_file_write_iter(inode, file, file->f_path.dentry,
 		(unsigned long long)OCFS2_I(inode)->ip_blkno,
 		file->f_path.dentry->d_name.len,
 		file->f_path.dentry->d_name.name,
-		(unsigned int)nr_segs);
+		(unsigned long long)pos);
 
 	if (iocb->ki_left == 0)
 		return 0;
@@ -2358,28 +2356,24 @@ relock:
 	/* communicate with ocfs2_dio_end_io */
 	ocfs2_iocb_set_rw_locked(iocb, rw_level);
 
-	ret = generic_segment_checks(iov, &nr_segs, &ocount,
-				     VERIFY_READ);
-	if (ret)
-		goto out_dio;
 
-	count = ocount;
+	count = iov_iter_count(iter);
 	ret = generic_write_checks(file, ppos, &count,
 				   S_ISBLK(inode->i_mode));
 	if (ret)
 		goto out_dio;
 
 	if (direct_io) {
-		written = generic_file_direct_write(iocb, iov, &nr_segs, *ppos,
-						    ppos, count, ocount);
+		written = generic_file_direct_write_iter(iocb, iter, *ppos,
+						    ppos, count);
 		if (written < 0) {
 			ret = written;
 			goto out_dio;
 		}
 	} else {
 		current->backing_dev_info = file->f_mapping->backing_dev_info;
-		written = generic_file_buffered_write(iocb, iov, nr_segs, *ppos,
-						      ppos, count, 0);
+		written = generic_file_buffered_write_iter(iocb, iter, *ppos,
+							   ppos, 0);
 		current->backing_dev_info = NULL;
 	}
 
@@ -2440,6 +2434,25 @@ out_sems:
 	return ret;
 }
 
+static ssize_t ocfs2_file_aio_write(struct kiocb *iocb,
+				    const struct iovec *iov,
+				    unsigned long nr_segs,
+				    loff_t pos)
+{
+	struct iov_iter iter;
+	size_t count;
+	int ret;
+
+	count = 0;
+	ret = generic_segment_checks(iov, &nr_segs, &count, VERIFY_READ);
+	if (ret)
+		return ret;
+
+	iov_iter_init(&iter, iov, nr_segs, count, 0);
+
+	return ocfs2_file_write_iter(iocb, &iter, pos);
+}
+
 static int ocfs2_splice_to_file(struct pipe_inode_info *pipe,
 				struct file *out,
 				struct splice_desc *sd)
@@ -2553,19 +2566,18 @@ bail:
 	return ret;
 }
 
-static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
-				   const struct iovec *iov,
-				   unsigned long nr_segs,
+static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
+				   struct iov_iter *iter,
 				   loff_t pos)
 {
 	int ret = 0, rw_level = -1, have_alloc_sem = 0, lock_level = 0;
 	struct file *filp = iocb->ki_filp;
 	struct inode *inode = filp->f_path.dentry->d_inode;
 
-	trace_ocfs2_file_aio_read(inode, filp, filp->f_path.dentry,
+	trace_ocfs2_file_read_iter(inode, filp, filp->f_path.dentry,
 			(unsigned long long)OCFS2_I(inode)->ip_blkno,
 			filp->f_path.dentry->d_name.len,
-			filp->f_path.dentry->d_name.name, nr_segs);
+			filp->f_path.dentry->d_name.name, pos);
 
 
 	if (!inode) {
@@ -2601,7 +2613,7 @@ static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
 	 *
 	 * Take and drop the meta data lock to update inode fields
 	 * like i_size. This allows the checks down below
-	 * generic_file_aio_read() a chance of actually working.
+	 * generic_file_read_iter() a chance of actually working.
 	 */
 	ret = ocfs2_inode_lock_atime(inode, filp->f_vfsmnt, &lock_level);
 	if (ret < 0) {
@@ -2610,8 +2622,8 @@ static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
 	}
 	ocfs2_inode_unlock(inode, lock_level);
 
-	ret = generic_file_aio_read(iocb, iov, nr_segs, iocb->ki_pos);
-	trace_generic_file_aio_read_ret(ret);
+	ret = generic_file_read_iter(iocb, iter, iocb->ki_pos);
+	trace_generic_file_read_iter_ret(ret);
 
 	/* buffered aio wouldn't have proper lock coverage today */
 	BUG_ON(ret == -EIOCBQUEUED && !(filp->f_flags & O_DIRECT));
@@ -2683,6 +2695,24 @@ out:
 	return offset;
 }
 
+static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
+				   const struct iovec *iov,
+				   unsigned long nr_segs,
+				   loff_t pos)
+{
+	struct iov_iter iter;
+	size_t count;
+	int ret;
+
+	ret = generic_segment_checks(iov, &nr_segs, &count, VERIFY_WRITE);
+	if (ret)
+		return ret;
+
+	iov_iter_init(&iter, iov, nr_segs, count, 0);
+
+	return ocfs2_file_read_iter(iocb, &iter, pos);
+}
+
 const struct inode_operations ocfs2_file_iops = {
 	.setattr	= ocfs2_setattr,
 	.getattr	= ocfs2_getattr,
@@ -2716,6 +2746,8 @@ const struct file_operations ocfs2_fops = {
 	.open		= ocfs2_file_open,
 	.aio_read	= ocfs2_file_aio_read,
 	.aio_write	= ocfs2_file_aio_write,
+	.read_iter	= ocfs2_file_read_iter,
+	.write_iter	= ocfs2_file_write_iter,
 	.unlocked_ioctl	= ocfs2_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl   = ocfs2_compat_ioctl,
@@ -2764,6 +2796,8 @@ const struct file_operations ocfs2_fops_no_plocks = {
 	.open		= ocfs2_file_open,
 	.aio_read	= ocfs2_file_aio_read,
 	.aio_write	= ocfs2_file_aio_write,
+	.read_iter	= ocfs2_file_read_iter,
+	.write_iter	= ocfs2_file_write_iter,
 	.unlocked_ioctl	= ocfs2_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl   = ocfs2_compat_ioctl,
diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index 3b481f4..8409f00 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -1312,12 +1312,16 @@ DEFINE_OCFS2_FILE_OPS(ocfs2_sync_file);
 
 DEFINE_OCFS2_FILE_OPS(ocfs2_file_aio_write);
 
+DEFINE_OCFS2_FILE_OPS(ocfs2_file_write_iter);
+
 DEFINE_OCFS2_FILE_OPS(ocfs2_file_splice_write);
 
 DEFINE_OCFS2_FILE_OPS(ocfs2_file_splice_read);
 
 DEFINE_OCFS2_FILE_OPS(ocfs2_file_aio_read);
 
+DEFINE_OCFS2_FILE_OPS(ocfs2_file_read_iter);
+
 DEFINE_OCFS2_ULL_ULL_ULL_EVENT(ocfs2_truncate_file);
 
 DEFINE_OCFS2_ULL_ULL_EVENT(ocfs2_truncate_file_error);
@@ -1474,7 +1478,7 @@ TRACE_EVENT(ocfs2_prepare_inode_for_write,
 		  __entry->direct_io, __entry->has_refcount)
 );
 
-DEFINE_OCFS2_INT_EVENT(generic_file_aio_read_ret);
+DEFINE_OCFS2_INT_EVENT(generic_file_read_iter_ret);
 
 /* End of trace events for fs/ocfs2/file.c. */
 
-- 
1.7.9.2
