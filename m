From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Mon Feb 23 22:25:15 2004
Subject: [Ocfs2-devel] [PATCH]2.6 fixes in super.c
In-Reply-To: <20040223233523.GA1421@ca-server1.us.oracle.com>
References: <200402180312.i1I3CH7Y015248@penguin.co.intel.com>
	<20040219233755.GA24928@penguin.co.intel.com>
	<20040223233523.GA1421@ca-server1.us.oracle.com>
Message-ID: <20040224042501.GA20255@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Feb 23, 2004 at 03:35:23PM -0800, Mark Fasheh wrote:
> On Thu, Feb 19, 2004 at 03:37:55PM -0800, Rusty Lynch wrote:
> > On Tue, Feb 17, 2004 at 07:12:17PM -0800, Rusty Lynch wrote:
> > > The following patch fixes 2.6 port issues in super.c (which
> > > spills into ocfs.h)
<snip>
> > +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
> > +static int ocfs_statfs (struct super_block *sb, struct kstatfs *buf)
> 
> Is there a reason why we can't just combine the 2.4 / 2.6 versions of these
> functions? From a cursory glance, they seem mostly the same...

Here is a redone version of the patch that applies cleanly to the current 
svn repository.

    --rusty


diff -urN b/src/inc/ocfs.h c/src/inc/ocfs.h
--- b/src/inc/ocfs.h	2004-02-23 18:44:55.000000000 -0800
+++ c/src/inc/ocfs.h	2004-02-23 20:07:55.000000000 -0800
@@ -88,7 +88,7 @@
 #endif
 #include  <linux/inet.h>
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-#include <asm/statfs.h>
+#include <linux/statfs.h>
 #include <linux/blkdev.h>
 #include <linux/in.h>
 #include <linux/buffer_head.h>
diff -urN b/src/super.c c/src/super.c
--- b/src/super.c	2004-02-23 18:45:17.000000000 -0800
+++ c/src/super.c	2004-02-23 20:12:23.000000000 -0800
@@ -37,8 +37,10 @@
 __u32 osb_id;             /* Keeps track of next available OSB Id */
 spinlock_t mount_cnt_lock;
 __u32 mount_cnt;          /* Number of volumes currently mounted */
-bool mount_cnt_inc;       /* true when mount_cnt is inc by 1 during first mount */
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
+bool mount_cnt_inc;       /* true when mount_cnt is inc by 1 during first mount */
+#endif
 
 char *node_name = NULL;
 __u32 node_number = OCFS_INVALID_NODE_NUM;
@@ -123,17 +125,21 @@
 #endif /* Linux 2.4 stuff */
 
 static int ocfs_parse_options (char *options, __u32 * uid, __u32 * gid, bool * reclaim_id);
-static struct super_block *ocfs_read_super (struct super_block *sb, void *data, int silent);
 static int __init ocfs_driver_entry (void);
 static void __exit ocfs_driver_exit (void);
 static void ocfs_put_super (struct super_block *sb);
-static int ocfs_statfs (struct super_block *sb, struct statfs *buf);
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
@@ -151,19 +157,6 @@
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 
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
 
 
@@ -478,7 +483,9 @@
 	spin_lock_init (&mount_cnt_lock);
 	spin_lock (&mount_cnt_lock);
 	mount_cnt = 0;
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
 	mount_cnt_inc = false;
+#endif
 	spin_unlock (&mount_cnt_lock);
 
 	spin_lock_init (&OcfsGlobalCtxt.comm_seq_lock);
@@ -679,8 +686,9 @@
 
 	ocfs_sync_blockdev(sb);
 	LOG_TRACE_STR ("put super... do nothing!  DONE!!!!");
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
 	MOD_DEC_USE_COUNT;
-
+#endif
 	LOG_EXIT ();
 	return;
 }				/* ocfs_put_super */
@@ -691,7 +699,11 @@
  * ocfs_statfs()
  *
  */
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+static int ocfs_statfs (struct super_block *sb, struct kstatfs *buf)
+#else
 static int ocfs_statfs (struct super_block *sb, struct statfs *buf)
+#endif
 {
         ocfs_super *osb = NULL;
         __u32 numbits, freebits = 0;
@@ -700,7 +712,7 @@
         ocfs_bitmap_lock *bm_lock = NULL;
 	struct buffer_head *bh = NULL;
 
-        LOG_ENTRY_ARGS ("(0x%08x, 0x%08x)\n", sb, buf);
+        LOG_ENTRY_ARGS ("(%p, %p)\n", sb, buf);
 
         osb = (ocfs_super *) OCFS_GENERIC_SB_P(sb);
         numbits = osb->cluster_bitmap.validbits;
@@ -721,15 +733,27 @@
         buf->f_type = OCFS_MAGIC;
         buf->f_bsize = sb->s_blocksize;
         buf->f_namelen = OCFS_MAX_FILENAME_LENGTH;
+        buf->f_bavail = buf->f_bfree;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
         buf->f_blocks =
-            (unsigned long) ((unsigned long) (numbits) *
-                             (unsigned long) (osb->vol_layout.cluster_size >> 9) -
-			     (8 * ONE_MEGA_BYTE / osb->vol_layout.cluster_size)); 
+		(unsigned long) ((unsigned long) (numbits) *
+				 (unsigned long) (osb->vol_layout.cluster_size >> 9) -
+				 (8 * ONE_MEGA_BYTE / osb->vol_layout.cluster_size)); 
         buf->f_bfree =
             (unsigned long) (freebits * (osb->vol_layout.cluster_size >> 9));
         buf->f_bavail = buf->f_bfree;
         buf->f_files = (unsigned long) (numbits);
         buf->f_ffree = (unsigned long) (numbits) - freebits;
+#else
+        buf->f_blocks =
+		(sector_t) ((unsigned long) (numbits) *
+			    (unsigned long) (osb->vol_layout.cluster_size >> 9) -
+			    (8 * ONE_MEGA_BYTE / osb->vol_layout.cluster_size)); 
+        buf->f_bfree =
+            (sector_t) (freebits * (osb->vol_layout.cluster_size >> 9));
+        buf->f_files = (sector_t) (numbits);
+        buf->f_ffree = (sector_t) (numbits) - freebits;
+#endif
 
 	OCFS_BH_PUT_DATA(bh);
 	lock_buffer(bh);
@@ -981,10 +1005,12 @@
 		}
 
 		OcfsIpcCtxt.init = true;
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
 		if (mount_cnt_inc == false) {
 			MOD_INC_USE_COUNT;
 			mount_cnt_inc = true;
 		}	
+#endif
 	}
 	spin_unlock (&mount_cnt_lock);
 
@@ -1180,6 +1206,7 @@
 	ocfs_safefree (osb);
 	sb->s_dev = 0;
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
 	spin_lock (&mount_cnt_lock);
 	if (!mount_cnt && !atomic_read(&OcfsGlobalCtxt.cnt_lockres) && mount_cnt_inc) {
 		MOD_DEC_USE_COUNT;
@@ -1190,6 +1217,7 @@
 			       atomic_read(&OcfsGlobalCtxt.cnt_lockres));
 	}
 	spin_unlock (&mount_cnt_lock);
+#endif
 
 leave:
 	if (AcquiredOSB) {
