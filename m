From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Mon Feb  9 14:48:08 2004
Subject: [Ocfs2-devel] [PATCH][2.6 PORT] more ocfs.h cleanup
Message-ID: <200402092045.i19KjlKM000935@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following is a patch that cleans up src/inc/ocfs.h in another step
towards a port to the 2.6 kernel.

    --rusty

Index: src/inc/ocfs.h
===================================================================
--- src/inc/ocfs.h	(revision 29)
+++ src/inc/ocfs.h	(working copy)
@@ -5,19 +5,6 @@
 struct mem_dqinfo;
 extern inline void mark_info_dirty(struct mem_dqinfo *info);
 
-#ifndef LINUX_2_5
-#ifdef __ia64__
-extern inline void prefetch(const void *x);
-extern inline void prefetchw(const void *x);
-#else
-static inline void prefetch(const void *x);
-static inline void prefetchw(const void *x);
-#endif
-extern inline int generic_fls(int x);
-extern inline int get_bitmask_order(unsigned int count);
-#endif /* !LINUX_2_5 */
-
-
 /*
 ** System header files
 */
@@ -30,8 +17,20 @@
 #include  <linux/kernel.h>
 #include  <asm/byteorder.h>
 #include  <linux/spinlock.h>
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
+#ifdef __ia64__
+extern inline void prefetch(const void *x);
+extern inline void prefetchw(const void *x);
+#else
+static inline void prefetch(const void *x);
+static inline void prefetchw(const void *x);
+#endif
+extern inline int generic_fls(int x);
+extern inline int get_bitmask_order(unsigned int count);
+#endif /* 2.4 kernel */
+
 #include  <linux/slab.h>
-#include  <linux/slab.h>
 #include  <linux/sched.h>
 #include  <linux/delay.h>
 #include  <linux/wait.h>
@@ -41,7 +40,7 @@
 #include  <linux/random.h>
 #include  <linux/string.h>
 #include  <linux/jbd.h>
-#ifdef LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 #include <linux/writeback.h>
 #else
 #include  <linux/locks.h>
@@ -56,13 +55,13 @@
 #include  <linux/net.h>
 #include  <net/sock.h>
 #include  <linux/ctype.h>
-#ifdef LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 #include  <linux/workqueue.h>
 #else
 #include  <linux/tqueue.h>
 #endif
 #include  <linux/inet.h>
-#ifdef LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 #include <asm/statfs.h>
 #include <linux/blkdev.h>
 #include <linux/in.h>
@@ -71,8 +70,6 @@
 
 #include "journal.h"
 
-
-
 typedef enum { false = 0, true = 1 } ocfs_bool;
 
 /* This should be removed and all old code fixed to just use ocfs_bool */
@@ -90,7 +87,6 @@
 #define OCFS_GCC_ATTR_PACKALGN
 #endif
 
-
 enum
 {
 	OCFS_VOTE_REQUEST = 1,
@@ -116,19 +112,16 @@
 	REMASTER_REQUESTOR    // remaster lock to requestor
 };
 
-
 enum {
 	NOT_VOTING = 0, 
 	DOING_HEARTBEAT, 
 	SKIPPED_HEARTBEAT
 };
 
-
 #define  OCFS_MAX_DLM_PKT_SIZE			256
 #define  OCFS_DLM_MAX_MSG_SIZE			256
 #define  OCFS_DLM_MSG_MAGIC			0x79677083
 
-
 enum {
     OSB_DATA_LOCK,
     OSB_MD_LOCK,
@@ -179,7 +172,7 @@
 #endif
 
 
-#ifdef LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 #define OcfsQuerySystemTime(t)						      \
 	do {								      \
 		*t = (__u64)(CURRENT_TIME.tv_sec) * (__u64) 10000000;	      \
@@ -1084,7 +1077,7 @@
 #define  OCFS_IOC_GETTYPE        _IOR(OCFS_IOC_MAGIC, 1, struct ocfs_ioc)
 
 
-#ifndef LINUX_2_5
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
 typedef long sector_t;
 #define map_bh(bh, sb, blk)   \
 	({ \
@@ -1094,12 +1087,12 @@
 	})
 #endif
 
-#ifndef LINUX_2_5
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
 #include <linux/iobuf.h>
 #endif /* for 2.5 - no more kiovec, kiobuf structures - vfs handles
 	* this for us (direct i/o) */
 #include <linux/sysctl.h>
-#ifdef LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 #include <linux/moduleparam.h>
 #endif
 
@@ -1113,48 +1106,32 @@
 #endif
 
 /* Operates on a struct super_block * */
-#ifdef LINUX_2_5
-#define OCFS_SB_GET_KDEV(sb)  (to_kdev_t(sb->s_dev))
-#define OCFS_SET_INODE_DEV(sb, inode)   (inode->i_rdev = OCFS_SB_GET_KDEV(sb))
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+#define OCFS_SET_INODE_DEV(sb, inode)   (inode->i_rdev = sb->sdev)
 typedef struct block_device * ocfs_blockdev;
 typedef dev_t ocfs_dev;
 #define OCFS_NODEV     NODEV.value
 #define OCFS_GET_BLOCKDEV(sb)   ((sb)->s_bdev)
-#else
-#define OCFS_SB_GET_KDEV(sb)  (sb->s_dev)
-#define OCFS_SET_INODE_DEV(sb, inode)   (inode->i_dev = OCFS_SB_GET_KDEV(sb))
+#else /* 2.4 kernel */
+#define OCFS_SET_INODE_DEV(sb, inode)   (inode->i_dev = sb->s_dev)
 typedef kdev_t ocfs_blockdev;
 typedef int ocfs_dev;
 #define OCFS_NODEV     NODEV
 #define OCFS_GET_BLOCKDEV(sb)   ((sb)->s_dev)
 #endif
 
-
-
-
-//#if LINUX_VERSION_CODE >= LinuxVersionCode(2,5,0)
-
-//#ifndef LINUX_2_5
-//#define LINUX_2_5
-//#endif
-
-//#endif
-
-#if LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 /* No longer exists in 2.5 */
 #define fsync_inode_buffers(inode) sync_mapping_buffers(inode->i_mapping)
 #define getblk(dev, blk, sz)	__getblk(dev, blk, sz)
-#define MOD_INC_USE_COUNT do { } while(0)
-#define MOD_DEC_USE_COUNT do { } while(0)
-#endif /* LINUX_2_5 */
+#endif /* >= 2.6.0  */
 
-#ifdef LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 #define OCFS_GENERIC_SB_P(sb)	((ocfs_super *)(sb->s_fs_info))
 #else
 #define OCFS_GENERIC_SB_P(sb)	((ocfs_super *)(sb->u.generic_sbp))
 #endif
 
-
 extern __u32 debug_context;
 extern __u32 debug_level;
 extern __u32 debug_exclude;
@@ -1553,7 +1530,11 @@
 	struct semaphore s_sem;
 	struct list_head s_list;
 	unsigned long s_blocknr;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+	dev_t s_dev;
+#else
 	kdev_t s_dev;
+#endif
 	atomic_t s_refcnt;
 	struct buffer_head *s_bh;
 	wait_queue_head_t s_wait;
@@ -2345,7 +2326,7 @@
 	__s32 msg_len;
 	__u8 msg[OCFS_MAX_DLM_PKT_SIZE];
 	int status;
-#ifdef LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 	struct work_struct ipc_wq;
 #else
 	struct tq_struct ipc_tq;
@@ -2364,7 +2345,7 @@
 
 typedef struct _ocfs_cfg_task
 {
-#ifdef LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 	struct work_struct cfg_wq;
 #else
 	struct tq_struct cfg_tq;
