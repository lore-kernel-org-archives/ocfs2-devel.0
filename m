From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu,  1 Mar 2012 11:34:23 -0800
Subject: [Ocfs2-devel] [PATCH 9/9] ocfs2: Fix tiny race in unaligned aio+dio
In-Reply-To: <1330630463-30305-1-git-send-email-sunil.mushran@oracle.com>
References: <1330630463-30305-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1330630463-30305-9-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch fixes a tiny race in unaligned aio+dio that leads to a hang.

Commit a11f7e63c59810a81494d4c4b028af707d4c7ca4 serialized unaligned
aio+dio writes. However the serialize code in end_io() was not
differentiating between writes and reads and thus allowing reads to
interfere with the serialization accounting for writes. This patch
seperates the handler functions to avoid this issue.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/aops.c |   44 ++++++++++++++++++++++++++++++++------------
 1 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 78b68af..3783ba3 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -558,20 +558,15 @@ bail:
 }
 
 /*
- * ocfs2_dio_end_io is called by the dio core when a dio is finished.  We're
- * particularly interested in the aio/dio case.  We use the rw_lock DLM lock
- * to protect io on one node from truncation on another.
+ * ocfs2_dio_end_io_[read|write] is called by the dio core when a dio is
+ * finished.  We're particularly interested in the aio/dio case.  We use
+ * the rw_lock DLM lock to protect io on one node from truncation on another.
  */
-static void ocfs2_dio_end_io(struct kiocb *iocb,
-			     loff_t offset,
-			     ssize_t bytes,
-			     void *private,
-			     int ret,
-			     bool is_async)
+static void ocfs2_dio_end_io(struct kiocb *iocb, loff_t offset, ssize_t bytes,
+			     void *private, int ret, bool is_async, int rw)
 {
 	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
 	int level;
-	wait_queue_head_t *wq = ocfs2_ioend_wq(inode);
 
 	/* this io's submitter should not have unlocked this before we could */
 	BUG_ON(!ocfs2_iocb_is_rw_locked(iocb));
@@ -579,7 +574,9 @@ static void ocfs2_dio_end_io(struct kiocb *iocb,
 	if (ocfs2_iocb_is_sem_locked(iocb))
 		ocfs2_iocb_clear_sem_locked(iocb);
 
-	if (ocfs2_iocb_is_unaligned_aio(iocb)) {
+	if (rw == WRITE && ocfs2_iocb_is_unaligned_aio(iocb)) {
+		wait_queue_head_t *wq = ocfs2_ioend_wq(inode);
+
 		ocfs2_iocb_clear_unaligned_aio(iocb);
 
 		if (atomic_dec_and_test(&OCFS2_I(inode)->ip_unaligned_aio) &&
@@ -598,6 +595,23 @@ static void ocfs2_dio_end_io(struct kiocb *iocb,
 	inode_dio_done(inode);
 }
 
+static void ocfs2_dio_end_io_write(struct kiocb *iocb, loff_t offset,
+				   ssize_t bytes, void *private, int ret,
+				   bool is_async)
+{
+
+	return ocfs2_dio_end_io(iocb, offset, bytes, private, ret,
+				is_async, WRITE);
+}
+
+static void ocfs2_dio_end_io_read(struct kiocb *iocb, loff_t offset,
+				  ssize_t bytes, void *private, int ret,
+				  bool is_async)
+{
+	return ocfs2_dio_end_io(iocb, offset, bytes, private, ret,
+				is_async, READ);
+}
+
 /*
  * ocfs2_invalidatepage() and ocfs2_releasepage() are shamelessly stolen
  * from ext3.  PageChecked() bits have been removed as OCFS2 does not
@@ -627,6 +641,7 @@ static ssize_t ocfs2_direct_IO(int rw,
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_path.dentry->d_inode->i_mapping->host;
+	dio_iodone_t *end_io;
 
 	/*
 	 * Fallback to buffered I/O if we see an inode without
@@ -639,10 +654,15 @@ static ssize_t ocfs2_direct_IO(int rw,
 	if (i_size_read(inode) <= offset)
 		return 0;
 
+	if (rw == WRITE)
+		end_io = ocfs2_dio_end_io_write;
+	else
+		end_io = ocfs2_dio_end_io_read;
+
 	return __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev,
 				    iov, offset, nr_segs,
 				    ocfs2_direct_IO_get_blocks,
-				    ocfs2_dio_end_io, NULL, 0);
+				    end_io, NULL, 0);
 }
 
 static void ocfs2_figure_cluster_boundaries(struct ocfs2_super *osb,
-- 
1.7.7.6
