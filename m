From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Wed, 23 Mar 2016 13:12:09 -0700
Subject: [Ocfs2-devel] [patch 09/25] ocfs2: fix ip_unaligned_aio deadlock
 with dio work queue
Message-ID: <56f2f899.3BIexEaPTpR1F6ZV%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Ryan Ding <ryan.ding@oracle.com>
Subject: ocfs2: fix ip_unaligned_aio deadlock with dio work queue

In the current implementation of unaligned aio+dio, lock order behave as
follow:

in user process context:
  -> call io_submit()
    -> get i_mutex
		<== window1
      -> get ip_unaligned_aio
        -> submit direct io to block device
    -> release i_mutex
  -> io_submit() return

in dio work queue context(the work queue is created in __blockdev_direct_IO):
  -> release ip_unaligned_aio
		<== window2
    -> get i_mutex
      -> clear unwritten flag & change i_size
    -> release i_mutex

There is a limitation to the thread number of dio work queue.  256 at
default.  If all 256 thread are in the above 'window2' stage, and there is
a user process in the 'window1' stage, the system will became deadlock. 
Since the user process hold i_mutex to wait ip_unaligned_aio lock, while
there is a direct bio hold ip_unaligned_aio mutex who is waiting for a dio
work queue thread to be schedule.  But all the dio work queue thread is
waiting for i_mutex lock in 'window2'.

This case only happened in a test which send a large number(more than 256)
of aio at one io_submit() call.

My design is to remove ip_unaligned_aio lock.  Change it to a sync io
instead.  Just like ip_unaligned_aio lock, serialize the unaligned aio
dio.

[akpm at linux-foundation.org: remove OCFS2_IOCB_UNALIGNED_IO, per Junxiao Bi]
Signed-off-by: Ryan Ding <ryan.ding@oracle.com>
Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c  |    6 ------
 fs/ocfs2/aops.h  |    8 --------
 fs/ocfs2/file.c  |   27 +++++++++------------------
 fs/ocfs2/inode.h |    3 ---
 fs/ocfs2/super.c |    1 -
 5 files changed, 9 insertions(+), 36 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue
+++ a/fs/ocfs2/aops.c
@@ -2391,12 +2391,6 @@ static int ocfs2_dio_end_io(struct kiocb
 	/* this io's submitter should not have unlocked this before we could */
 	BUG_ON(!ocfs2_iocb_is_rw_locked(iocb));
 
-	if (ocfs2_iocb_is_unaligned_aio(iocb)) {
-		ocfs2_iocb_clear_unaligned_aio(iocb);
-
-		mutex_unlock(&OCFS2_I(inode)->ip_unaligned_aio);
-	}
-
 	if (private)
 		ocfs2_dio_end_io_write(inode, private, offset, bytes);
 
diff -puN fs/ocfs2/aops.h~ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue fs/ocfs2/aops.h
--- a/fs/ocfs2/aops.h~ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue
+++ a/fs/ocfs2/aops.h
@@ -84,7 +84,6 @@ static inline void ocfs2_iocb_set_rw_loc
 enum ocfs2_iocb_lock_bits {
 	OCFS2_IOCB_RW_LOCK = 0,
 	OCFS2_IOCB_RW_LOCK_LEVEL,
-	OCFS2_IOCB_UNALIGNED_IO,
 	OCFS2_IOCB_NUM_LOCKS
 };
 
@@ -93,11 +92,4 @@ enum ocfs2_iocb_lock_bits {
 #define ocfs2_iocb_rw_locked_level(iocb) \
 	test_bit(OCFS2_IOCB_RW_LOCK_LEVEL, (unsigned long *)&iocb->private)
 
-#define ocfs2_iocb_set_unaligned_aio(iocb) \
-	set_bit(OCFS2_IOCB_UNALIGNED_IO, (unsigned long *)&iocb->private)
-#define ocfs2_iocb_clear_unaligned_aio(iocb) \
-	clear_bit(OCFS2_IOCB_UNALIGNED_IO, (unsigned long *)&iocb->private)
-#define ocfs2_iocb_is_unaligned_aio(iocb) \
-	test_bit(OCFS2_IOCB_UNALIGNED_IO, (unsigned long *)&iocb->private)
-
 #endif /* OCFS2_FILE_H */
diff -puN fs/ocfs2/file.c~ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue
+++ a/fs/ocfs2/file.c
@@ -2178,7 +2178,7 @@ static ssize_t ocfs2_file_write_iter(str
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	int full_coherency = !(osb->s_mount_opt &
 			       OCFS2_MOUNT_COHERENCY_BUFFERED);
-	int unaligned_dio = 0;
+	void *saved_ki_complete = NULL;
 	int append_write = ((iocb->ki_pos + count) >=
 			i_size_read(inode) ? 1 : 0);
 
@@ -2241,17 +2241,12 @@ static ssize_t ocfs2_file_write_iter(str
 		goto out;
 	}
 
-	if (direct_io && !is_sync_kiocb(iocb))
-		unaligned_dio = ocfs2_is_io_unaligned(inode, count, iocb->ki_pos);
-
-	if (unaligned_dio) {
+	if (direct_io && !is_sync_kiocb(iocb) &&
+	    ocfs2_is_io_unaligned(inode, count, iocb->ki_pos)) {
 		/*
-		 * Wait on previous unaligned aio to complete before
-		 * proceeding.
+		 * Make it a sync io if it's an unaligned aio.
 		 */
-		mutex_lock(&OCFS2_I(inode)->ip_unaligned_aio);
-		/* Mark the iocb as needing an unlock in ocfs2_dio_end_io */
-		ocfs2_iocb_set_unaligned_aio(iocb);
+		saved_ki_complete = xchg(&iocb->ki_complete, NULL);
 	}
 
 	/* communicate with ocfs2_dio_end_io */
@@ -2272,11 +2267,10 @@ static ssize_t ocfs2_file_write_iter(str
 	 */
 	if ((written == -EIOCBQUEUED) || (!ocfs2_iocb_is_rw_locked(iocb))) {
 		rw_level = -1;
-		unaligned_dio = 0;
 	}
 
 	if (unlikely(written <= 0))
-		goto no_sync;
+		goto out;
 
 	if (((file->f_flags & O_DSYNC) && !direct_io) ||
 	    IS_SYNC(inode)) {
@@ -2298,13 +2292,10 @@ static ssize_t ocfs2_file_write_iter(str
 						      iocb->ki_pos - 1);
 	}
 
-no_sync:
-	if (unaligned_dio && ocfs2_iocb_is_unaligned_aio(iocb)) {
-		ocfs2_iocb_clear_unaligned_aio(iocb);
-		mutex_unlock(&OCFS2_I(inode)->ip_unaligned_aio);
-	}
-
 out:
+	if (saved_ki_complete)
+		xchg(&iocb->ki_complete, saved_ki_complete);
+
 	if (rw_level != -1)
 		ocfs2_rw_unlock(inode, rw_level);
 
diff -puN fs/ocfs2/inode.h~ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue fs/ocfs2/inode.h
--- a/fs/ocfs2/inode.h~ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue
+++ a/fs/ocfs2/inode.h
@@ -43,9 +43,6 @@ struct ocfs2_inode_info
 	/* protects extended attribute changes on this inode */
 	struct rw_semaphore		ip_xattr_sem;
 
-	/* Number of outstanding AIO's which are not page aligned */
-	struct mutex			ip_unaligned_aio;
-
 	/* These fields are protected by ip_lock */
 	spinlock_t			ip_lock;
 	u32				ip_open_count;
diff -puN fs/ocfs2/super.c~ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue
+++ a/fs/ocfs2/super.c
@@ -1747,7 +1747,6 @@ static void ocfs2_inode_init_once(void *
 	INIT_LIST_HEAD(&oi->ip_io_markers);
 	INIT_LIST_HEAD(&oi->ip_unwritten_list);
 	oi->ip_dir_start_lookup = 0;
-	mutex_init(&oi->ip_unaligned_aio);
 	init_rwsem(&oi->ip_alloc_sem);
 	init_rwsem(&oi->ip_xattr_sem);
 	mutex_init(&oi->ip_io_mutex);
_
