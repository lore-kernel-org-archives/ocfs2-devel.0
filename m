From: Joseph Qi <joseph.qi@huawei.com>
Date: Tue, 20 Jan 2015 16:10:22 +0800
Subject: [Ocfs2-devel] [PATCH 7/9 v6] ocfs2: complete the rest request
	through buffer io
Message-ID: <54BE0D6E.9020906@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Complte the rest request thourgh buffer io after direct write performed.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Weiwei Wang <wangww631@huawei.com>
---
 fs/ocfs2/file.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index c1446cf..4a712cf 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2253,6 +2253,7 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 	u32 old_clusters;
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
+	struct address_space *mapping = file->f_mapping;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	int full_coherency = !(osb->s_mount_opt &
 			       OCFS2_MOUNT_COHERENCY_BUFFERED);
@@ -2367,11 +2368,51 @@ relock:

 	iov_iter_truncate(from, count);
 	if (direct_io) {
+		loff_t endbyte;
+		ssize_t written_buffered;
 		written = generic_file_direct_write(iocb, from, *ppos);
-		if (written < 0) {
+		if (written < 0 || written == count) {
 			ret = written;
 			goto out_dio;
 		}
+
+		/*
+		 * for completing the rest of the request.
+		 */
+		*ppos += written;
+		count -= written;
+		written_buffered = generic_perform_write(file, from, *ppos);
+		/*
+		 * If generic_file_buffered_write() returned a synchronous error
+		 * then we want to return the number of bytes which were
+		 * direct-written, or the error code if that was zero. Note
+		 * that this differs from normal direct-io semantics, which
+		 * will return -EFOO even if some bytes were written.
+		 */
+		if (written_buffered < 0) {
+			ret = written_buffered;
+			goto out_dio;
+		}
+
+		iocb->ki_pos = *ppos + written_buffered;
+		/* We need to ensure that the page cache pages are written to
+		 * disk and invalidated to preserve the expected O_DIRECT
+		 * semantics.
+		 */
+		endbyte = *ppos + written_buffered - 1;
+		ret = filemap_write_and_wait_range(file->f_mapping, *ppos,
+				endbyte);
+		if (ret == 0) {
+			written += written_buffered;
+			invalidate_mapping_pages(mapping,
+					*ppos >> PAGE_CACHE_SHIFT,
+					endbyte >> PAGE_CACHE_SHIFT);
+		} else {
+			/*
+			 * We don't know how much we wrote, so just return
+			 * the number of bytes which were direct-written
+			 */
+		}
 	} else {
 		current->backing_dev_info = file->f_mapping->backing_dev_info;
 		written = generic_perform_write(file, from, *ppos);
-- 
1.8.4.3
