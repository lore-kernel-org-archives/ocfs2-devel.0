From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Tue Feb 17 21:12:30 2004
Subject: [Ocfs2-devel] [PATCH]2.6 fixes in super.c
Message-ID: <200402180312.i1I3CH7Y015248@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following patch fixes 2.6 port issues in super.c (which
spills into ocfs.h)

Specifically:
* The module inc/dec stuff is out for 2.6
* small changes in super_operations like the
  use of the new kstatfs struct

    --rusty

Index: super.c
===================================================================
--- super.c	(revision 31)
+++ super.c	(working copy)
@@ -37,9 +37,11 @@
 __u32 osb_id;             /* Keeps track of next available OSB Id */
 spinlock_t mount_cnt_lock;
 __u32 mount_cnt;          /* Number of volumes currently mounted */
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
 bool mount_cnt_inc;       /* true when mount_cnt is inc by 1 during first mount */
+#endif
 
-
 char *node_name = NULL;
 __u32 node_number = OCFS_INVALID_NODE_NUM;
 __u32 debug_context = 0;
@@ -123,17 +125,22 @@
 #endif /* Linux 2.4 stuff */
 
 static int ocfs_parse_options (char *options, __u32 * uid, __u32 * gid, bool * reclaim_id);
-static struct super_block *ocfs_read_super (struct super_block *sb, void *data, int silent);
 static int __init ocfs_driver_entry (void);
 static void __exit ocfs_driver_exit (void);
 static void ocfs_put_super (struct super_block *sb);
-static int ocfs_statfs (struct super_block *sb, struct statfs *buf);
+
 static void lockres_hash_free_func (const void *p);
 static int ocfs_mount_volume (struct super_block *sb, bool reclaim_id, struct inode *root);
 static int ocfs_read_params(void);
 static int ocfs_initialize_mem_lists (void);
 static void ocfs_free_mem_lists (void);
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+static int ocfs_statfs (struct super_block *sb, struct kstatfs *buf);
+#else
+static int ocfs_statfs (struct super_block *sb, struct statfs *buf);
+#endif
+
 static struct super_operations ocfs_sops = {
 	.statfs = ocfs_statfs,
 	.put_inode = ocfs_put_inode,
@@ -148,22 +155,8 @@
 
 };
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 
-#ifdef LINUX_2_5
-
-static struct file_system_type ocfs_fs_type = {
-        .owner          = THIS_MODULE,
-        .name           = "ocfs2",
-        .get_sb         = ocfs_get_sb, /* is this called when we mount
-					* the fs? */
-        .kill_sb        = kill_block_super, /* set to the generic one
-					     * right now, but do we
-					     * need to change that? */
-        .fs_flags       = FS_REQUIRES_DEV,
-	.next           = NULL
-};
-
-
 static int ocfs_fill_super (struct super_block *sb, void *data, int silent)
 {
 	struct dentry *root_dentry;
@@ -238,11 +231,23 @@
 	return status;
 }				/* ocfs_fill_super */
 
-static struct super_block *ocfs_get_sb(struct file_system_type *fs_type, int flags, char *dev_name, void *data)
+static struct super_block *ocfs_get_sb(struct file_system_type *fs_type, int flags, const char *dev_name, void *data)
 {
 	return get_sb_bdev(fs_type, flags, dev_name, data, ocfs_fill_super);
 }
 
+static struct file_system_type ocfs_fs_type = {
+        .owner          = THIS_MODULE,
+        .name           = "ocfs2",
+        .get_sb         = ocfs_get_sb, /* is this called when we mount
+					* the fs? */
+        .kill_sb        = kill_block_super, /* set to the generic one
+					     * right now, but do we
+					     * need to change that? */
+        .fs_flags       = FS_REQUIRES_DEV,
+	.next           = NULL
+};
+
 #else  /* We're a 2.4 kernel */
 
 
@@ -335,7 +340,6 @@
 #endif /* #if LINUX_2_5 ... #else */
 
 
-
 /*
  * ocfs_parse_options()
  *
@@ -478,7 +482,9 @@
 	spin_lock_init (&mount_cnt_lock);
 	spin_lock (&mount_cnt_lock);
 	mount_cnt = 0;
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
 	mount_cnt_inc = false;
+#endif
 	spin_unlock (&mount_cnt_lock);
 
 	spin_lock_init (&OcfsGlobalCtxt.comm_seq_lock);
@@ -679,18 +685,79 @@
 
 	ocfs_sync_blockdev(sb);
 	LOG_TRACE_STR ("put super... do nothing!  DONE!!!!");
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
+	LOG_TRACE_STR("decrementing module use count");
 	MOD_DEC_USE_COUNT;
+#endif
 
 	LOG_EXIT ();
 	return;
 }				/* ocfs_put_super */
 
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 
 /*
  * ocfs_statfs()
  *
  */
+static int ocfs_statfs (struct super_block *sb, struct kstatfs *buf)
+{
+        ocfs_super *osb = NULL;
+        __u32 numbits, freebits = 0;
+        // ocfs_lock_res *pLockResource;
+        int status = 0;
+        ocfs_bitmap_lock *bm_lock = NULL;
+	struct buffer_head *bh = NULL;
+
+        LOG_ENTRY_ARGS ("(0x%08x, 0x%08x)\n", sb, buf);
+
+        osb = (ocfs_super *) OCFS_GENERIC_SB_P(sb);
+        numbits = osb->cluster_bitmap.validbits;
+ 
+	status = ocfs_read_bh (osb, OCFS_BITMAP_LOCK_OFFSET, &bh, 0, NULL);
+	if (status < 0) {
+		LOG_ERROR_STR("failed to read bitmap data");
+		return -EIO;
+	}
+	bm_lock = (ocfs_bitmap_lock *)OCFS_BH_GET_DATA_READ(bh); /* read */
+
+        if (numbits >= bm_lock->used_bits)
+            freebits = numbits - bm_lock->used_bits;
+
+	/* take out the space reserved for system files */
+	freebits -= (8 * ONE_MEGA_BYTE / osb->vol_layout.cluster_size);	
+
+        buf->f_type = OCFS_MAGIC;
+        buf->f_bsize = sb->s_blocksize;
+        buf->f_namelen = OCFS_MAX_FILENAME_LENGTH;
+        buf->f_blocks =
+            (sector_t) ((unsigned long) (numbits) *
+			(unsigned long) (osb->vol_layout.cluster_size >> 9) -
+			(8 * ONE_MEGA_BYTE / osb->vol_layout.cluster_size)); 
+        buf->f_bfree =
+            (sector_t) (freebits * (osb->vol_layout.cluster_size >> 9));
+        buf->f_bavail = buf->f_bfree;
+        buf->f_files = (sector_t) (numbits);
+        buf->f_ffree = (sector_t) (numbits) - freebits;
+
+	OCFS_BH_PUT_DATA(bh);
+	lock_buffer(bh);
+	clear_buffer_uptodate(bh);
+	unlock_buffer(bh);
+	brelse(bh);
+
+        LOG_EXIT_LONG (0);
+        return 0;
+}                               /* ocfs_statfs */
+
+#else /* 2.4.x kernel */
+
+/*
+ * ocfs_statfs()
+ *
+ */
 static int ocfs_statfs (struct super_block *sb, struct statfs *buf)
 {
         ocfs_super *osb = NULL;
@@ -741,6 +808,8 @@
         return 0;
 }                               /* ocfs_statfs */
 
+#endif /* 2.4.x kernel */
+
 #ifdef CDTOR_FOR_SLAB
 static void lockres_ctor(void *p, kmem_cache_t *slab, unsigned long flags)
 {
@@ -981,10 +1050,13 @@
 		}
 
 		OcfsIpcCtxt.init = true;
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
 		if (mount_cnt_inc == false) {
+			LOG_TRACE_STR("incrementing module use count");
 			MOD_INC_USE_COUNT;
 			mount_cnt_inc = true;
 		}	
+#endif
 	}
 	spin_unlock (&mount_cnt_lock);
 
@@ -1180,8 +1252,10 @@
 	ocfs_safefree (osb);
 	sb->s_dev = 0;
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
 	spin_lock (&mount_cnt_lock);
 	if (!mount_cnt && !atomic_read(&OcfsGlobalCtxt.cnt_lockres) && mount_cnt_inc) {
+		LOG_TRACE_STR("decrementing module use count");
 		MOD_DEC_USE_COUNT;
 		mount_cnt_inc = false;
 	} else {
@@ -1190,6 +1264,7 @@
 			       atomic_read(&OcfsGlobalCtxt.cnt_lockres));
 	}
 	spin_unlock (&mount_cnt_lock);
+#endif /* 2.4.x kernel */
 
 leave:
 	if (AcquiredOSB) {
Index: inc/ocfs.h
===================================================================
--- inc/ocfs.h	(revision 31)
+++ inc/ocfs.h	(working copy)
@@ -88,7 +88,7 @@
 #endif
 #include  <linux/inet.h>
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-#include <asm/statfs.h>
+#include <linux/statfs.h>
 #include <linux/blkdev.h>
 #include <linux/in.h>
 #include <linux/buffer_head.h>
@@ -205,7 +205,7 @@
 		*t += (__u64)(CURRENT_TIME.tv_nsec) / (__u64) 100;	      \
 	} while (0)
 #define OCFS_CURRENT_TIME   (CURRENT_TIME.tv_sec)
-#define OCFS_SET_INODE_TIME(i, x, y)   i->##x.tv_sec = (y)
+#define OCFS_SET_INODE_TIME(i, x, y)   (i->x.tv_sec = (y))
 #else
 /* time is in 0.1 microsecs */
 #define OcfsQuerySystemTime(t)                                                \
