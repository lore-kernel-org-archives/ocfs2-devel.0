From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Tue Feb 17 16:53:25 2004
Subject: [Ocfs2-devel] [PATCH]2.6 friendly access to bh devices
Message-ID: <200402172253.i1HMrBsv011920@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The new buffer_head struct references a block_device which points
to a specific device instead of directly pointing to a device.

This patch adds a new BH_GET_DEVICE(bh) macro which will expand
correctly across 2.4 and 2.6 builds.

    --rusty

Index: src/hash.c
===================================================================
--- src/hash.c	(revision 31)
+++ src/hash.c	(working copy)
@@ -685,7 +685,7 @@
 		(((block)<<(ocfs_bh_hash_shift - 6)) ^ ((block) >> 13) ^ \
 		((block) << (ocfs_bh_hash_shift - 12))))
 #define ocfs_bh_sem_hash_fn(_b)   \
-	(_hashfn((unsigned int)((_b)->b_dev), (_b)->b_blocknr) & ocfs_bh_hash_shift)
+	(_hashfn((unsigned int)BH_GET_DEVICE(_b), (_b)->b_blocknr) & ocfs_bh_hash_shift)
 
 int ocfs_bh_sem_hash_init()
 {
@@ -748,7 +748,7 @@
 		}
 		sem = list_entry (iter, ocfs_bh_sem, s_list);
 		if (sem->s_blocknr == bh->b_blocknr &&
-		    sem->s_dev == bh->b_dev) {
+		    sem->s_dev == BH_GET_DEVICE(bh)) {
 			if (atomic_read(&sem->s_refcnt)==0) {
 				if (sem->s_bh) {
 					LOG_ERROR_STR("refcount was zero but s_bh not NULL!");
@@ -800,7 +800,7 @@
 			newsem->s_bh = NULL;
 			atomic_set(&newsem->s_refcnt, 0);
 			newsem->s_blocknr = bh->b_blocknr;
-			newsem->s_dev = bh->b_dev;
+			newsem->s_dev = BH_GET_DEVICE(bh);
 			init_MUTEX (&newsem->s_sem);
 			init_waitqueue_head(&newsem->s_wait);
 			newsem->s_pid = 0;
Index: src/inc/io.h
===================================================================
--- src/inc/io.h	(revision 31)
+++ src/inc/io.h	(working copy)
@@ -166,8 +166,12 @@
 }
 #endif
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+#define BH_GET_DEVICE(bh) ((bh->b_bdev)->bd_dev)
+#else
+#define BH_GET_DEVICE(bh) (bh->b_dev)
+#endif
 
-
 static inline void OCFS_BH_PUT_DATA(struct buffer_head *bh)
 {
 	kunmap((bh)->b_page);
