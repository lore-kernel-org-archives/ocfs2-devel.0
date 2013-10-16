From: Dave Kleikamp <dave.kleikamp@oracle.com>
Date: Wed, 16 Oct 2013 09:04:34 -0500
Subject: [Ocfs2-devel] [PATCH V9 21/33] ocfs2: add support for read_iter and
	write_iter
In-Reply-To: <1381932286-14978-1-git-send-email-dave.kleikamp@oracle.com>
References: <1381932286-14978-1-git-send-email-dave.kleikamp@oracle.com>
Message-ID: <1381932286-14978-22-git-send-email-dave.kleikamp@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mfasheh@suse.com>, Christoph Hellwig <hch@infradead.org>, Dave Kleikamp <dave.kleikamp@oracle.com>, linux-fsdevel@vger.kernel.org, Zach Brown <zab@zabbo.net>, "Maxim V. Patlasov" <mpatlasov@parallels.com>, ocfs2-devel@oss.oracle.com

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Acked-by: Joel Becker <jlbec@evilplan.org>
Cc: Zach Brown <zab@zabbo.net>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: ocfs2-devel at oss.oracle.com
---
 fs/ocfs2/aops.h        |  2 +-
 fs/ocfs2/file.c        | 55 ++++++++++++++++++++++----------------------------
 fs/ocfs2/ocfs2_trace.h |  6 +++---
 3 files changed, 28 insertions(+), 35 deletions(-)

diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
index f671e49..573f41d 100644
--- a/fs/ocfs2/aops.h
+++ b/fs/ocfs2/aops.h
@@ -74,7 +74,7 @@ static inline void ocfs2_iocb_set_rw_locked(struct kiocb *iocb, int level)
 /*
  * Using a named enum representing lock types in terms of #N bit stored in
  * iocb->private, which is going to be used for communication between
- * ocfs2_dio_end_io() and ocfs2_file_aio_write/read().
+ * ocfs2_dio_end_io() and ocfs2_file_write/read_iter().
  */
 enum ocfs2_iocb_lock_bits {
 	OCFS2_IOCB_RW_LOCK = 0,
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index d71903c..1d85492 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2217,15 +2217,13 @@ out:
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
@@ -2236,11 +2234,11 @@ static ssize_t ocfs2_file_aio_write(struct kiocb *iocb,
 			       OCFS2_MOUNT_COHERENCY_BUFFERED);
 	int unaligned_dio = 0;
 
-	trace_ocfs2_file_aio_write(inode, file, file->f_path.dentry,
+	trace_ocfs2_file_write_iter(inode, file, file->f_path.dentry,
 		(unsigned long long)OCFS2_I(inode)->ip_blkno,
 		file->f_path.dentry->d_name.len,
 		file->f_path.dentry->d_name.name,
-		(unsigned int)nr_segs);
+		(unsigned long)pos);
 
 	if (iocb->ki_nbytes == 0)
 		return 0;
@@ -2340,28 +2338,24 @@ relock:
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
+							   ppos, count, 0);
 		current->backing_dev_info = NULL;
 	}
 
@@ -2517,7 +2511,7 @@ static ssize_t ocfs2_file_splice_read(struct file *in,
 			in->f_path.dentry->d_name.name, len);
 
 	/*
-	 * See the comment in ocfs2_file_aio_read()
+	 * See the comment in ocfs2_file_read_iter()
 	 */
 	ret = ocfs2_inode_lock_atime(inode, in->f_path.mnt, &lock_level);
 	if (ret < 0) {
@@ -2532,19 +2526,18 @@ bail:
 	return ret;
 }
 
-static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
-				   const struct iovec *iov,
-				   unsigned long nr_segs,
-				   loff_t pos)
+static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
+				    struct iov_iter *iter,
+				    loff_t pos)
 {
 	int ret = 0, rw_level = -1, have_alloc_sem = 0, lock_level = 0;
 	struct file *filp = iocb->ki_filp;
 	struct inode *inode = file_inode(filp);
 
-	trace_ocfs2_file_aio_read(inode, filp, filp->f_path.dentry,
+	trace_ocfs2_file_read_iter(inode, filp, filp->f_path.dentry,
 			(unsigned long long)OCFS2_I(inode)->ip_blkno,
 			filp->f_path.dentry->d_name.len,
-			filp->f_path.dentry->d_name.name, nr_segs);
+			filp->f_path.dentry->d_name.name, pos);
 
 
 	if (!inode) {
@@ -2580,7 +2573,7 @@ static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
 	 *
 	 * Take and drop the meta data lock to update inode fields
 	 * like i_size. This allows the checks down below
-	 * generic_file_aio_read() a chance of actually working.
+	 * generic_file_read_iter() a chance of actually working.
 	 */
 	ret = ocfs2_inode_lock_atime(inode, filp->f_path.mnt, &lock_level);
 	if (ret < 0) {
@@ -2589,13 +2582,13 @@ static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
 	}
 	ocfs2_inode_unlock(inode, lock_level);
 
-	ret = generic_file_aio_read(iocb, iov, nr_segs, iocb->ki_pos);
-	trace_generic_file_aio_read_ret(ret);
+	ret = generic_file_read_iter(iocb, iter, iocb->ki_pos);
+	trace_generic_file_read_iter_ret(ret);
 
 	/* buffered aio wouldn't have proper lock coverage today */
 	BUG_ON(ret == -EIOCBQUEUED && !(filp->f_flags & O_DIRECT));
 
-	/* see ocfs2_file_aio_write */
+	/* see ocfs2_file_write_iter */
 	if (ret == -EIOCBQUEUED || !ocfs2_iocb_is_rw_locked(iocb)) {
 		rw_level = -1;
 		have_alloc_sem = 0;
@@ -2683,8 +2676,8 @@ const struct file_operations ocfs2_fops = {
 	.fsync		= ocfs2_sync_file,
 	.release	= ocfs2_file_release,
 	.open		= ocfs2_file_open,
-	.aio_read	= ocfs2_file_aio_read,
-	.aio_write	= ocfs2_file_aio_write,
+	.read_iter	= ocfs2_file_read_iter,
+	.write_iter	= ocfs2_file_write_iter,
 	.unlocked_ioctl	= ocfs2_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl   = ocfs2_compat_ioctl,
@@ -2731,8 +2724,8 @@ const struct file_operations ocfs2_fops_no_plocks = {
 	.fsync		= ocfs2_sync_file,
 	.release	= ocfs2_file_release,
 	.open		= ocfs2_file_open,
-	.aio_read	= ocfs2_file_aio_read,
-	.aio_write	= ocfs2_file_aio_write,
+	.read_iter	= ocfs2_file_read_iter,
+	.write_iter	= ocfs2_file_write_iter,
 	.unlocked_ioctl	= ocfs2_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl   = ocfs2_compat_ioctl,
diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index 1b60c62..67f08ba 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -1310,13 +1310,13 @@ DEFINE_OCFS2_FILE_OPS(ocfs2_file_release);
 
 DEFINE_OCFS2_FILE_OPS(ocfs2_sync_file);
 
-DEFINE_OCFS2_FILE_OPS(ocfs2_file_aio_write);
+DEFINE_OCFS2_FILE_OPS(ocfs2_file_write_iter);
 
 DEFINE_OCFS2_FILE_OPS(ocfs2_file_splice_write);
 
 DEFINE_OCFS2_FILE_OPS(ocfs2_file_splice_read);
 
-DEFINE_OCFS2_FILE_OPS(ocfs2_file_aio_read);
+DEFINE_OCFS2_FILE_OPS(ocfs2_file_read_iter);
 
 DEFINE_OCFS2_ULL_ULL_ULL_EVENT(ocfs2_truncate_file);
 
@@ -1474,7 +1474,7 @@ TRACE_EVENT(ocfs2_prepare_inode_for_write,
 		  __entry->direct_io, __entry->has_refcount)
 );
 
-DEFINE_OCFS2_INT_EVENT(generic_file_aio_read_ret);
+DEFINE_OCFS2_INT_EVENT(generic_file_read_iter_ret);
 
 /* End of trace events for fs/ocfs2/file.c. */
 
-- 
1.8.4
