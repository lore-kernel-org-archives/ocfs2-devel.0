From: Christoph Hellwig <hch@lst.de>
Date: Sun Jun  6 03:11:52 2004
Subject: [Ocfs2-devel] [PATCH] use sb_getblk
Message-ID: <20040606081146.GB28366@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

It's both in 2.6 and recent 2.6 (for RH ASS2.1 you'll probably need to
copy the latest 2.4 defintion, but I don't care for obsolete junk).


Index: src/super.c
===================================================================
--- src/super.c	(revision 1014)
+++ src/super.c	(working copy)
@@ -799,7 +799,7 @@
 
 	/* get first two blocks */
 	for (i=0; i<2; i++) {
-		bhs[i] = getblk (OCFS_GET_BLOCKDEV(sb), i, 512);
+		bhs[i] = sb_getblk(sb, i);
 		if (bhs[i] == NULL) {
 			LOG_ERROR_STATUS(status = -EIO);
 			goto leave;
Index: src/journal.c
===================================================================
--- src/journal.c	(revision 1014)
+++ src/journal.c	(working copy)
@@ -583,8 +583,7 @@
 			 * turned off later. */
 			LOG_ERROR_ARGS("block %lu was modified but never "
 				       "dirtied!\n", co->blocknr);
-			bh = getblk(OCFS_GET_BLOCKDEV(osb->sb), co->blocknr,
-				    osb->sect_size);
+			bh = sb_getblk(osb->sb, co->blocknr);
 			if (bh == NULL)
 				BUG();
 
Index: src/file.c
===================================================================
--- src/file.c	(revision 1014)
+++ src/file.c	(working copy)
@@ -1220,7 +1220,8 @@
 			     block < (unsigned long)((actualDiskOffset+actualLength) >> osb->sect_size_bits);
 			     block++) {
 				LOG_TRACE_ARGS("setting block %lu as new!\n", block);
-				alloc_bh = getblk(OCFS_GET_BLOCKDEV(sb), block, sb->s_blocksize);
+				alloc_bh = sb_getblk(sb, block);
+#warning unchecked allocation here
 				alloc_bh->b_state |= (1UL << BH_New);
 				brelse(alloc_bh);
 			}
Index: src/volcfg.c
===================================================================
--- src/volcfg.c	(revision 1014)
+++ src/volcfg.c	(working copy)
@@ -496,7 +491,7 @@
 	}
 
 	blocknum = lock_off >> sb->s_blocksize_bits;
-	bh = getblk(OCFS_GET_BLOCKDEV(sb), blocknum, sb->s_blocksize);
+	bh = sb_getblk(sb, blocknum);
 	if (bh == NULL) {
 		LOG_ERROR_STATUS (status = -EIO);
 		goto finally;
@@ -646,7 +641,7 @@
 		((node_num + OCFS_VOLCFG_HDR_SECTORS) * osb->sect_size);
 	blocknum = offset >> sb->s_blocksize_bits;
 
-	bh = getblk(OCFS_GET_BLOCKDEV(sb), blocknum, sb->s_blocksize);
+	bh = sb_getblk(sb, blocknum);
 	if (bh == NULL) {
 		status = -EIO;
 		LOG_ERROR_STATUS(status);
Index: src/buffer_head_io.c
===================================================================
--- src/buffer_head_io.c	(revision 1014)
+++ src/buffer_head_io.c	(working copy)
@@ -64,7 +64,6 @@
 	int status = 0;
 	int i;
 	struct super_block *sb;
-	ocfs_blockdev dev;
 	struct buffer_head *bh;
 
 #ifdef OCFS_DBG_TIMING
@@ -89,7 +88,6 @@
 		LOG_TRACE_ARGS ("Getting write for %d blocks\n", nr);
 
 	sb = osb->sb;
-	dev = OCFS_GET_BLOCKDEV(sb);
 
 	/* we don't ever want cached writes -- those should go to the
 	 * journal so we can control when they actually hit disk and
@@ -204,7 +202,6 @@
 	struct super_block *sb;
 	int nr, i, ignore_cache = 0;
 	__u64 blocknum;
-	ocfs_blockdev dev;
 	struct buffer_head *bh;
 
 #ifdef OCFS_DBG_TIMING
@@ -243,7 +240,6 @@
 	}
 
 	sb = osb->sb;
-	dev = OCFS_GET_BLOCKDEV(sb);
 	blocknum = off >> sb->s_blocksize_bits;
 
 	nr = (len + 511) >> 9;
@@ -258,7 +254,7 @@
 
 	for (i = 0 ; i < nr ; i++) {
 		if (bhs[i] == NULL) {
-			bhs[i] = getblk (dev, blocknum++, sb->s_blocksize);
+			bhs[i] = sb_getblk(sb, blocknum++);
 			if (bhs[i] == NULL) {
 				LOG_TRACE_STR("bh == NULL");
 				status = -EIO;
Index: src/inc/ocfs.h
===================================================================
--- src/inc/ocfs.h	(revision 1014)
+++ src/inc/ocfs.h	(working copy)
@@ -542,21 +542,16 @@
 #endif
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-typedef struct block_device * ocfs_blockdev;
 typedef dev_t ocfs_dev;
 #define OCFS_NODEV     0
-#define OCFS_GET_BLOCKDEV(sb)   ((sb)->s_bdev)
 #else /* 2.4 kernel */
-typedef kdev_t ocfs_blockdev;
 typedef int ocfs_dev;
 #define OCFS_NODEV     NODEV
-#define OCFS_GET_BLOCKDEV(sb)   ((sb)->s_dev)
 #endif
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 /* No longer exists in 2.5 */
 #define fsync_inode_buffers(inode) sync_mapping_buffers(inode->i_mapping)
-#define getblk(dev, blk, sz)	__getblk(dev, blk, sz)
 #endif /* >= 2.6.0  */
 
 #define OCFS_SB(sb)	    ((ocfs_super *)OCFS_GENERIC_SB_MEMBER(sb))
@@ -617,11 +612,7 @@
 	struct semaphore s_sem;
 	struct list_head s_list;
 	unsigned long s_blocknr;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 	dev_t s_dev;
-#else
-	kdev_t s_dev;
-#endif
 	atomic_t s_refcnt;
 	struct buffer_head *s_bh;
 	wait_queue_head_t s_wait;
Index: src/inc/ocfs_compat.h
===================================================================
--- src/inc/ocfs_compat.h	(revision 1014)
+++ src/inc/ocfs_compat.h	(working copy)
@@ -62,6 +62,11 @@
 #define io_schedule            schedule
 #endif
 
+#define flush_scheduled_work	flush_scheduled_tasks
+#define work_struct		tq_struct
+#define INIT_WORK(w, f, d)	INIT_TQUEUE(w, f, d)
+#define schedule_work(w)	schedule_task(w)
+
 #ifdef HAVE_NPTL
 static inline void dequeue_signal_lock(struct task_struct *task,
 				       sigset_t *blocked, siginfo_t *info)
Index: src/alloc.c
===================================================================
--- src/alloc.c	(revision 1014)
+++ src/alloc.c	(working copy)
@@ -915,9 +915,7 @@
 	phys_blkno = physicalOffset >> osb->sb->s_blocksize_bits;
 
 	for (i = 0; i < numbhs; i++) {
-		bhs[i] = getblk(OCFS_GET_BLOCKDEV(osb->sb), 
-				phys_blkno + i,
-				osb->sb->s_blocksize);
+		bhs[i] = sb_getblk(osb->sb, phys_blkno + i);
 		if (bhs[i] == NULL) {
 			status = -EIO;
 			LOG_ERROR_STATUS(status);
