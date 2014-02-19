From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Wed, 19 Feb 2014 11:24:06 +0800
Subject: [Ocfs2-devel] [PATCH] [ocfs2]: change ip_unaligned_aio to of type
	mutex from atomit_t
Message-ID: <1392780246-17982-1-git-send-email-wen.gang.wang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

There is a problem that waitqueue_active() may check stale data thus miss a
wakeup of threads waiting on ip_unaligned_aio.
The valid value of ip_unaligned_aio is only 0 and 1 so we can change it to
be of type mutex thus the above prolem is avoid. Another benifit is that mutex
which works as FIFO is fairer than wake_up_all().

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/aops.c  |  6 +-----
 fs/ocfs2/aops.h  |  5 -----
 fs/ocfs2/file.c  | 15 +++------------
 fs/ocfs2/inode.h |  2 +-
 fs/ocfs2/super.c |  9 ++-------
 5 files changed, 7 insertions(+), 30 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index aeb44e8..ebe44f7 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -571,7 +571,6 @@ static void ocfs2_dio_end_io(struct kiocb *iocb,
 {
 	struct inode *inode = file_inode(iocb->ki_filp);
 	int level;
-	wait_queue_head_t *wq = ocfs2_ioend_wq(inode);
 
 	/* this io's submitter should not have unlocked this before we could */
 	BUG_ON(!ocfs2_iocb_is_rw_locked(iocb));
@@ -582,10 +581,7 @@ static void ocfs2_dio_end_io(struct kiocb *iocb,
 	if (ocfs2_iocb_is_unaligned_aio(iocb)) {
 		ocfs2_iocb_clear_unaligned_aio(iocb);
 
-		if (atomic_dec_and_test(&OCFS2_I(inode)->ip_unaligned_aio) &&
-		    waitqueue_active(wq)) {
-			wake_up_all(wq);
-		}
+		mutex_unlock(&OCFS2_I(inode)->ip_unaligned_aio);
 	}
 
 	ocfs2_iocb_clear_rw_locked(iocb);
diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
index f671e49..6cae155 100644
--- a/fs/ocfs2/aops.h
+++ b/fs/ocfs2/aops.h
@@ -102,9 +102,4 @@ enum ocfs2_iocb_lock_bits {
 #define ocfs2_iocb_is_unaligned_aio(iocb) \
 	test_bit(OCFS2_IOCB_UNALIGNED_IO, (unsigned long *)&iocb->private)
 
-#define OCFS2_IOEND_WQ_HASH_SZ	37
-#define ocfs2_ioend_wq(v)   (&ocfs2__ioend_wq[((unsigned long)(v)) %\
-					    OCFS2_IOEND_WQ_HASH_SZ])
-extern wait_queue_head_t ocfs2__ioend_wq[OCFS2_IOEND_WQ_HASH_SZ];
-
 #endif /* OCFS2_FILE_H */
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 8450262bc..51f67cd 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2061,13 +2061,6 @@ out:
 	return ret;
 }
 
-static void ocfs2_aiodio_wait(struct inode *inode)
-{
-	wait_queue_head_t *wq = ocfs2_ioend_wq(inode);
-
-	wait_event(*wq, (atomic_read(&OCFS2_I(inode)->ip_unaligned_aio) == 0));
-}
-
 static int ocfs2_is_io_unaligned(struct inode *inode, size_t count, loff_t pos)
 {
 	int blockmask = inode->i_sb->s_blocksize - 1;
@@ -2345,10 +2338,8 @@ relock:
 		 * Wait on previous unaligned aio to complete before
 		 * proceeding.
 		 */
-		ocfs2_aiodio_wait(inode);
-
-		/* Mark the iocb as needing a decrement in ocfs2_dio_end_io */
-		atomic_inc(&OCFS2_I(inode)->ip_unaligned_aio);
+		mutex_lock(&OCFS2_I(inode)->ip_unaligned_aio);
+		/* Mark the iocb as needing an unlock in ocfs2_dio_end_io */
 		ocfs2_iocb_set_unaligned_aio(iocb);
 	}
 
@@ -2428,7 +2419,7 @@ out_dio:
 
 	if (unaligned_dio) {
 		ocfs2_iocb_clear_unaligned_aio(iocb);
-		atomic_dec(&OCFS2_I(inode)->ip_unaligned_aio);
+		mutex_unlock(&OCFS2_I(inode)->ip_unaligned_aio);
 	}
 
 out:
diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index 621fc73..9f1580b 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -44,7 +44,7 @@ struct ocfs2_inode_info
 	struct rw_semaphore		ip_xattr_sem;
 
 	/* Number of outstanding AIO's which are not page aligned */
-	atomic_t			ip_unaligned_aio;
+	struct mutex			ip_unaligned_aio;
 
 	/* These fields are protected by ip_lock */
 	spinlock_t			ip_lock;
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 49d84f8..d171455 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1612,14 +1612,9 @@ static int ocfs2_show_options(struct seq_file *s, struct dentry *root)
 	return 0;
 }
 
-wait_queue_head_t ocfs2__ioend_wq[OCFS2_IOEND_WQ_HASH_SZ];
-
 static int __init ocfs2_init(void)
 {
-	int status, i;
-
-	for (i = 0; i < OCFS2_IOEND_WQ_HASH_SZ; i++)
-		init_waitqueue_head(&ocfs2__ioend_wq[i]);
+	int status;
 
 	status = init_ocfs2_uptodate_cache();
 	if (status < 0)
@@ -1761,7 +1756,7 @@ static void ocfs2_inode_init_once(void *data)
 	ocfs2_extent_map_init(&oi->vfs_inode);
 	INIT_LIST_HEAD(&oi->ip_io_markers);
 	oi->ip_dir_start_lookup = 0;
-	atomic_set(&oi->ip_unaligned_aio, 0);
+	mutex_init(&oi->ip_unaligned_aio);
 	init_rwsem(&oi->ip_alloc_sem);
 	init_rwsem(&oi->ip_xattr_sem);
 	mutex_init(&oi->ip_io_mutex);
-- 
1.8.3.1
