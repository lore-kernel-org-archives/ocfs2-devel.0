From: Christoph Hellwig <hch@lst.de>
Date: Tue Jun 22 07:32:44 2004
Subject: [Ocfs2-devel] mount_cnt_inc?
Message-ID: <20040622123238.GA14994@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The code just doesn't make sense to me.  We get a module reference per
mount anyway, no need to add another one on the first mount.


Index: src/super.c
===================================================================
--- src/super.c	(revision 1182)
+++ src/super.c	(working copy)
@@ -78,10 +78,6 @@
 spinlock_t mount_cnt_lock;
 __u32 mount_cnt;          /* Number of volumes currently mounted */
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
-int mount_cnt_inc;       /* true when mount_cnt is inc by 1 during first mount */
-#endif
-
 char *node_name = NULL;
 __u32 node_number = OCFS_INVALID_NODE_NUM;
 __u32 debug_context = 0;
@@ -399,16 +395,9 @@
 };
 
 #else
-
 static struct super_block *ocfs_read_super (struct super_block *sb, void *data, int silent)
 {
-	MOD_INC_USE_COUNT;
-
-	if (ocfs_fill_super(sb, data, silent) < 0) {
-		MOD_DEC_USE_COUNT;
-		return NULL;
-	}
-	return sb;
+	return (ocfs_fill_super(sb, data, silent) < 0) ? NULL : sb;
 }
 
 static DECLARE_FSTYPE (ocfs_fs_type, "ocfs2", ocfs_read_super, FS_REQUIRES_DEV);
@@ -535,9 +518,6 @@
 	spin_lock_init (&mount_cnt_lock);
 	spin_lock (&mount_cnt_lock);
 	mount_cnt = 0;
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
-	mount_cnt_inc = 0;
-#endif
 	spin_unlock (&mount_cnt_lock);
 
 	spin_lock_init (&OcfsGlobalCtxt.comm_seq_lock);
@@ -691,9 +671,6 @@
 
 	ocfs_sync_blockdev(sb);
 	LOG_TRACE_STR ("put super... do nothing!  DONE!!!!");
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
-	MOD_DEC_USE_COUNT;
-#endif
 	LOG_EXIT ();
 
 	LOG_CLEAR_CONTEXT();
@@ -1005,13 +982,6 @@
 			LOG_ERROR_ARGS ("unable to launch ocfs2lsnr thread, error=%d", child_pid);
 			goto leave;
 		}
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
-		if (mount_cnt_inc == 0) {
-			MOD_INC_USE_COUNT;
-			mount_cnt_inc = 1;
-		}	
-#endif
 	}
 	spin_unlock (&mount_cnt_lock);
 
@@ -1200,15 +1170,6 @@
 	kfree(osb);
 	sb->s_dev = 0;
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
-	spin_lock (&mount_cnt_lock);
-	if (!mount_cnt && mount_cnt_inc) {
-		MOD_DEC_USE_COUNT;
-		mount_cnt_inc = 0;
-	}
-	spin_unlock (&mount_cnt_lock);
-#endif
-
 leave:
 	if (AcquiredOSB) {
 		up (&(osb->osb_res));
