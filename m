From: Christoph Hellwig <hch@lst.de>
Date: Mon Jun 14 08:03:10 2004
Subject: [Ocfs2-devel] Re: [PATCH] use sb_getblk
In-Reply-To: <20040606081146.GB28366@lst.de>
References: <20040606081146.GB28366@lst.de>
Message-ID: <20040614130303.GA29918@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sun, Jun 06, 2004 at 10:11:46AM +0200, Christoph Hellwig wrote:
> It's both in 2.6 and recent 2.6 (for RH ASS2.1 you'll probably need to
> copy the latest 2.4 defintion, but I don't care for obsolete junk).

rediffed for current f-c branch and fixed some more OCFS_GET_BLOCKDEV
crap.


Index: src/super.c
===================================================================
--- src/super.c	(revision 1091)
+++ src/super.c	(working copy)
@@ -840,19 +840,6 @@
 	OCFS_CLEAR_FLAG (OcfsGlobalCtxt.flags, OCFS_FLAG_MEM_LISTS_INITIALIZED);
 }				/* ocfs_free_mem_lists */
 
-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-static inline int ocfs_hardsect_size(struct block_device *bdev)
-{
-        return bdev_hardsect_size(bdev);
-}
-#else
-static inline int ocfs_hardsect_size(dev_t dev)
-{
-        return get_hardsect_size(dev);
-}
-#endif /* 2.6.0 */
-
 static int ocfs2_sb_probe(struct super_block *sb,
 			  struct buffer_head **bh, 
 			  int *sector_size)
@@ -865,7 +852,7 @@
 	*bh = NULL;
 
 	/* may be > 512 */
-	*sector_size = ocfs_hardsect_size(OCFS_GET_BLOCKDEV(sb));
+	*sector_size = bdev_hardsect_size(sb->s_bdev);
 	if (*sector_size > 4096) {
 		LOG_ERROR_ARGS("Hardware sector size too large: %d (max=4096)\n", *sector_size);
 		status = -EINVAL;
@@ -947,7 +934,7 @@
 		return status;
 	}
 
-	*bh = getblk (OCFS_GET_BLOCKDEV(sb), block, sect_size);
+	*bh = sb_getblk(sb, block);
 	if (!*bh) {
 		LOG_ERROR_STATUS(-EIO);
 		return -EIO;
Index: src/ocfs_compat.h
===================================================================
--- src/ocfs_compat.h	(revision 1091)
+++ src/ocfs_compat.h	(working copy)
@@ -63,6 +63,7 @@
 
 #define io_schedule		schedule
 #define io_schedule_timeout	schedule_timeout
+#define bdev_hardsect_size(b)	get_hardsect_size((b)->bd_dev);
 
 #ifdef HAVE_NPTL
 static inline void dequeue_signal_lock(struct task_struct *task,
Index: src/journal.c
===================================================================
--- src/journal.c	(revision 1091)
+++ src/journal.c	(working copy)
@@ -540,9 +540,9 @@
 			 * turned off later. */
 			LOG_ERROR_ARGS("block %lu was modified but never "
 				       "dirtied!\n", co->blocknr);
-			bh = getblk(OCFS_GET_BLOCKDEV(osb->sb), co->blocknr,
-				    osb->sb->s_blocksize);
+			bh = sb_getblk(osb->sb, co->blocknr);
 			if (bh == NULL)
+#warning bingo, oops on oom
 				BUG();
 
 			dirtied = 0;
Index: src/volcfg.c
===================================================================
--- src/volcfg.c	(revision 1091)
+++ src/volcfg.c	(working copy)
@@ -489,7 +489,7 @@
 	sb = osb->sb;
 
 	blocknum = lock_off >> sb->s_blocksize_bits;
-	bh = getblk(OCFS_GET_BLOCKDEV(sb), blocknum, sb->s_blocksize);
+	bh = sb_getblk(sb, blocknum);
 	if (bh == NULL) {
 		LOG_ERROR_STATUS (status = -EIO);
 		goto finally;
@@ -636,7 +636,7 @@
 	/* Write the node details */
 	blocknum = osb->autoconfig_blkno + OCFS_VOLCFG_HDR_SECTORS + node_num;
 
-	bh = getblk(OCFS_GET_BLOCKDEV(sb), blocknum, sb->s_blocksize);
+	bh = sb_getblk(sb, blocknum);
 	if (bh == NULL) {
 		status = -EIO;
 		LOG_ERROR_STATUS(status);
Index: src/namei.c
===================================================================
--- src/namei.c	(revision 1091)
+++ src/namei.c	(working copy)
@@ -405,9 +405,7 @@
 		goto leave;
 	}
 
-	*new_fe_bh = getblk(OCFS_GET_BLOCKDEV(osb->sb), 
-			    disk_off >> osb->sb->s_blocksize_bits, 
-			    osb->sb->s_blocksize);
+	*new_fe_bh = sb_getblk(osb->sb, disk_off >> osb->sb->s_blocksize_bits);
 	if (!*new_fe_bh) {
 		status = -EIO;
 		LOG_ERROR_STATUS(status);
Index: src/inode.c
===================================================================
--- src/inode.c	(revision 1091)
+++ src/inode.c	(working copy)
@@ -1064,9 +1064,7 @@
 		goto fail;
 
 	if (new) {
-		bh = getblk(OCFS_GET_BLOCKDEV(osb->sb), 
-			    lbo >> osb->sb->s_blocksize_bits, 
-			    osb->sb->s_blocksize);
+		bh = sb_getblk(osb->sb, lbo >> osb->sb->s_blocksize_bits);
 		if (!bh) {
 			tmperr = -EIO;
 			goto fail;
Index: src/ocfs.h
===================================================================
--- src/ocfs.h	(revision 1091)
+++ src/ocfs.h	(working copy)
@@ -393,21 +393,16 @@
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
@@ -452,11 +447,7 @@
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
Index: src/file.c
===================================================================
--- src/file.c	(revision 1091)
+++ src/file.c	(working copy)
@@ -1228,7 +1228,8 @@
 			     block < (unsigned long)((actualDiskOffset+actualLength) >> sb->s_blocksize_bits);
 			     block++) {
 				LOG_TRACE_ARGS("setting block %lu as new!\n", block);
-				alloc_bh = getblk(OCFS_GET_BLOCKDEV(sb), block, sb->s_blocksize);
+				alloc_bh = sb_getblk(sb, block);
+#warning unchecked allocation here
 				alloc_bh->b_state |= (1UL << BH_New);
 				brelse(alloc_bh);
 			}
Index: src/buffer_head_io.c
===================================================================
--- src/buffer_head_io.c	(revision 1091)
+++ src/buffer_head_io.c	(working copy)
@@ -71,7 +71,6 @@
 	int status = 0;
 	int i;
 	struct super_block *sb;
-	ocfs_blockdev dev;
 	struct buffer_head *bh;
 
 #ifdef OCFS_DBG_TIMING
@@ -96,7 +95,6 @@
 		LOG_TRACE_ARGS ("Getting write for %d blocks\n", nr);
 
 	sb = osb->sb;
-	dev = OCFS_GET_BLOCKDEV(sb);
 
 	/* we don't ever want cached writes -- those should go to the
 	 * journal so we can control when they actually hit disk and
@@ -211,7 +209,6 @@
 	struct super_block *sb;
 	int nr, i, ignore_cache = 0;
 	__u64 blocknum;
-	ocfs_blockdev dev;
 	struct buffer_head *bh;
 
 #ifdef OCFS_DBG_TIMING
@@ -248,7 +245,6 @@
 	}
 
 	sb = osb->sb;
-	dev = OCFS_GET_BLOCKDEV(sb);
 	blocknum = off >> sb->s_blocksize_bits;
 
 	nr = (len + 511) >> 9;
@@ -263,7 +259,7 @@
 
 	for (i = 0 ; i < nr ; i++) {
 		if (bhs[i] == NULL) {
-			bhs[i] = getblk (dev, blocknum++, sb->s_blocksize);
+			bhs[i] = sb_getblk(sb, blocknum++);
 			if (bhs[i] == NULL) {
 				LOG_TRACE_STR("bh == NULL");
 				status = -EIO;
Index: src/alloc.c
===================================================================
--- src/alloc.c	(revision 1091)
+++ src/alloc.c	(working copy)
@@ -934,9 +934,7 @@
 	phys_blkno = physicalOffset >> osb->sb->s_blocksize_bits;
 
 	for (i = 0; i < numbhs; i++) {
-		bhs[i] = getblk(OCFS_GET_BLOCKDEV(osb->sb), 
-				phys_blkno + i,
-				osb->sb->s_blocksize);
+		bhs[i] = sb_getblk(osb->sb, phys_blkno + i);
 		if (bhs[i] == NULL) {
 			status = -EIO;
 			LOG_ERROR_STATUS(status);
