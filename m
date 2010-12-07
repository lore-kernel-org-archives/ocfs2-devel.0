From: Tristan Ye <tristan.ye@oracle.com>
Date: Tue,  7 Dec 2010 14:35:07 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Teach 'coherency=full' O_DIRECT
	writes to correctly up_read i_alloc_sem.
Message-ID: <1291703707-11505-1-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Due to newly-introduced 'coherency=full' O_DIRECT writes also takes the EX
rw_lock like buffered writes did(rw_level == 1), it turns out messing the
usage of 'level' in ocfs2_dio_end_io() up, which caused i_alloc_sem being
failed to get up_read'd correctly.

This patch tries to teach ocfs2_dio_end_io to understand well on all locking
stuffs by explicitly introducing a new bit for i_alloc_sem in iocb's private
data, just like what we did for rw_lock.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/aops.c |    7 +++++--
 fs/ocfs2/aops.h |   23 +++++++++++++++++++++--
 fs/ocfs2/file.c |   15 +++++++++++++--
 3 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index f1e962c..0d7c554 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -573,11 +573,14 @@ static void ocfs2_dio_end_io(struct kiocb *iocb,
 	/* this io's submitter should not have unlocked this before we could */
 	BUG_ON(!ocfs2_iocb_is_rw_locked(iocb));
 
+	if (ocfs2_iocb_is_sem_locked(iocb)) {
+		up_read(&inode->i_alloc_sem);
+		ocfs2_iocb_clear_sem_locked(iocb);
+	}
+
 	ocfs2_iocb_clear_rw_locked(iocb);
 
 	level = ocfs2_iocb_rw_locked_level(iocb);
-	if (!level)
-		up_read(&inode->i_alloc_sem);
 	ocfs2_rw_unlock(inode, level);
 
 	if (is_async)
diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
index 76bfdfd..d6db4ee 100644
--- a/fs/ocfs2/aops.h
+++ b/fs/ocfs2/aops.h
@@ -68,8 +68,27 @@ static inline void ocfs2_iocb_set_rw_locked(struct kiocb *iocb, int level)
 	else
 		clear_bit(1, (unsigned long *)&iocb->private);
 }
+
+/*
+ * Using a named enum representing lock types in terms of #N bit stored in
+ * iocb->private, which is going to be used for communication bewteen 
+ * ocfs2_dio_end_io() and ocfs2_file_aio_write/read().
+ */
+enum ocfs2_iocb_lock_bits {
+	OCFS2_IOCB_RW_LOCK = 0,
+	OCFS2_IOCB_RW_LOCK_LEVEL,
+	OCFS2_IOCB_SEM,
+	OCFS2_IOCB_NUM_LOCKS
+};
+
 #define ocfs2_iocb_clear_rw_locked(iocb) \
-	clear_bit(0, (unsigned long *)&iocb->private)
+	clear_bit(OCFS2_IOCB_RW_LOCK, (unsigned long *)&iocb->private)
 #define ocfs2_iocb_rw_locked_level(iocb) \
-	test_bit(1, (unsigned long *)&iocb->private)
+	test_bit(OCFS2_IOCB_RW_LOCK_LEVEL, (unsigned long *)&iocb->private)
+#define ocfs2_iocb_set_sem_locked(iocb) \
+	set_bit(OCFS2_IOCB_SEM, (unsigned long *)&iocb->private)
+#define ocfs2_iocb_clear_sem_locked(iocb) \
+	clear_bit(OCFS2_IOCB_SEM, (unsigned long *)&iocb->private)
+#define ocfs2_iocb_is_sem_locked(iocb) \
+	test_bit(OCFS2_IOCB_SEM, (unsigned long *)&iocb->private)
 #endif /* OCFS2_FILE_H */
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 77b4c04..f6cba56 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2241,11 +2241,15 @@ static ssize_t ocfs2_file_aio_write(struct kiocb *iocb,
 
 	mutex_lock(&inode->i_mutex);
 
+	ocfs2_iocb_clear_sem_locked(iocb);
+
 relock:
 	/* to match setattr's i_mutex -> i_alloc_sem -> rw_lock ordering */
 	if (direct_io) {
 		down_read(&inode->i_alloc_sem);
 		have_alloc_sem = 1;
+		/* communicate with ocfs2_dio_end_io */
+		ocfs2_iocb_set_sem_locked(iocb);
 	}
 
 	/*
@@ -2382,8 +2386,10 @@ out:
 		ocfs2_rw_unlock(inode, rw_level);
 
 out_sems:
-	if (have_alloc_sem)
+	if (have_alloc_sem) {
 		up_read(&inode->i_alloc_sem);
+		ocfs2_iocb_clear_sem_locked(iocb);
+	}
 
 	mutex_unlock(&inode->i_mutex);
 
@@ -2527,6 +2533,8 @@ static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
 		goto bail;
 	}
 
+	ocfs2_iocb_clear_sem_locked(iocb);
+
 	/*
 	 * buffered reads protect themselves in ->readpage().  O_DIRECT reads
 	 * need locks to protect pending reads from racing with truncate.
@@ -2534,6 +2542,7 @@ static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
 	if (filp->f_flags & O_DIRECT) {
 		down_read(&inode->i_alloc_sem);
 		have_alloc_sem = 1;
+		ocfs2_iocb_set_sem_locked(iocb);
 
 		ret = ocfs2_rw_lock(inode, 0);
 		if (ret < 0) {
@@ -2575,8 +2584,10 @@ static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
 	}
 
 bail:
-	if (have_alloc_sem)
+	if (have_alloc_sem) {
 		up_read(&inode->i_alloc_sem);
+		ocfs2_iocb_clear_sem_locked(iocb);
+	}
 	if (rw_level != -1)
 		ocfs2_rw_unlock(inode, rw_level);
 	mlog_exit(ret);
-- 
1.5.5
