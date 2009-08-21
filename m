From: Jan Kara <jack@suse.cz>
Date: Fri, 21 Aug 2009 19:23:52 +0200
Subject: [Ocfs2-devel] [PATCH 02/17] vfs: Export __generic_file_aio_write()
	and add some comments
In-Reply-To: <1250875447-15622-1-git-send-email-jack@suse.cz>
References: <1250875447-15622-1-git-send-email-jack@suse.cz>
Message-ID: <1250875447-15622-3-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, ocfs2-devel@oss.oracle.com

Rename __generic_file_aio_write_nolock() to __generic_file_aio_write(), add
comments to write helpers explaining how they should be used and export
__generic_file_aio_write() since it will be used by some filesystems.

CC: ocfs2-devel at oss.oracle.com
CC: Joel Becker <joel.becker@oracle.com>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/fs.h |    2 +
 mm/filemap.c       |   57 +++++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 52 insertions(+), 7 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index cb365ad..1edd159 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2195,6 +2195,8 @@ extern int generic_file_readonly_mmap(struct file *, struct vm_area_struct *);
 extern int file_read_actor(read_descriptor_t * desc, struct page *page, unsigned long offset, unsigned long size);
 int generic_write_checks(struct file *file, loff_t *pos, size_t *count, int isblk);
 extern ssize_t generic_file_aio_read(struct kiocb *, const struct iovec *, unsigned long, loff_t);
+extern ssize_t __generic_file_aio_write(struct kiocb *, const struct iovec *, unsigned long,
+		loff_t *);
 extern ssize_t generic_file_aio_write(struct kiocb *, const struct iovec *, unsigned long, loff_t);
 extern ssize_t generic_file_aio_write_nolock(struct kiocb *, const struct iovec *,
 		unsigned long, loff_t);
diff --git a/mm/filemap.c b/mm/filemap.c
index 65b2e50..554a396 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2368,9 +2368,27 @@ generic_file_buffered_write(struct kiocb *iocb, const struct iovec *iov,
 }
 EXPORT_SYMBOL(generic_file_buffered_write);
 
-static ssize_t
-__generic_file_aio_write_nolock(struct kiocb *iocb, const struct iovec *iov,
-				unsigned long nr_segs, loff_t *ppos)
+/**
+ * __generic_file_aio_write - write data to a file
+ * @iocb:	IO state structure (file, offset, etc.)
+ * @iov:	vector with data to write
+ * @nr_segs:	number of segments in the vector
+ * @ppos:	position where to write
+ *
+ * This function does all the work needed for actually writing data to a
+ * file. It does all basic checks, removes SUID from the file, updates
+ * modification times and calls proper subroutines depending on whether we
+ * do direct IO or a standard buffered write.
+ *
+ * It expects i_mutex to be grabbed unless we work on a block device or similar
+ * object which does not need locking at all.
+ *
+ * This function does *not* take care of syncing data in case of O_SYNC write.
+ * A caller has to handle it. This is mainly due to the fact that we want to
+ * avoid syncing under i_mutex.
+ */
+ssize_t __generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
+				 unsigned long nr_segs, loff_t *ppos)
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space * mapping = file->f_mapping;
@@ -2467,7 +2485,23 @@ out:
 	current->backing_dev_info = NULL;
 	return written ? written : err;
 }
+EXPORT_SYMBOL(__generic_file_aio_write);
+
 
+/**
+ * generic_file_aio_write_nolock - write data, usually to a device
+ * @iocb:	IO state structure
+ * @iov:	vector with data to write
+ * @nr_segs:	number of segments in the vector
+ * @pos:	position in file where to write
+ *
+ * This is a wrapper around __generic_file_aio_write() which takes care of
+ * syncing the file in case of O_SYNC file. It does not take i_mutex for the
+ * write itself but may do so during syncing. It is meant for users like block
+ * devices which do not need i_mutex during write. If your filesystem needs to
+ * do a write but already holds i_mutex, use __generic_file_aio_write()
+ * directly and then sync the file like generic_file_aio_write().
+ */
 ssize_t generic_file_aio_write_nolock(struct kiocb *iocb,
 		const struct iovec *iov, unsigned long nr_segs, loff_t pos)
 {
@@ -2478,8 +2512,7 @@ ssize_t generic_file_aio_write_nolock(struct kiocb *iocb,
 
 	BUG_ON(iocb->ki_pos != pos);
 
-	ret = __generic_file_aio_write_nolock(iocb, iov, nr_segs,
-			&iocb->ki_pos);
+	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
 
 	if (ret > 0 && ((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
 		ssize_t err;
@@ -2492,6 +2525,17 @@ ssize_t generic_file_aio_write_nolock(struct kiocb *iocb,
 }
 EXPORT_SYMBOL(generic_file_aio_write_nolock);
 
+/**
+ * generic_file_aio_write - write data to a file
+ * @iocb:	IO state structure
+ * @iov:	vector with data to write
+ * @nr_segs:	number of segments in the vector
+ * @pos:	position in file where to write
+ *
+ * This is a wrapper around __generic_file_aio_write() to be used by most
+ * filesystems. It takes care of syncing the file in case of O_SYNC file
+ * and acquires i_mutex as needed.
+ */
 ssize_t generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 		unsigned long nr_segs, loff_t pos)
 {
@@ -2503,8 +2547,7 @@ ssize_t generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	BUG_ON(iocb->ki_pos != pos);
 
 	mutex_lock(&inode->i_mutex);
-	ret = __generic_file_aio_write_nolock(iocb, iov, nr_segs,
-			&iocb->ki_pos);
+	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
 	mutex_unlock(&inode->i_mutex);
 
 	if (ret > 0 && ((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
-- 
1.6.0.2
