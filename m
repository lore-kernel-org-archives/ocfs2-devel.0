From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Thu Feb 19 22:14:03 2004
Subject: [Ocfs2-devel] [PATCH]2.6 fixes in nm.c
Message-ID: <200402200413.i1K4DwFC004269@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following patch enables inode syncing on 2.6 kernels in the 
nm.c file.

    --rusty

Index: src/nm.c
===================================================================
--- src/nm.c	(revision 32)
+++ src/nm.c	(working copy)
@@ -1014,10 +1014,14 @@
 				lockres->master_node_num = node_num;
 
 			if (inode) {
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+				sync_mapping_buffers(inode->i_mapping);
+#else
 				fsync_inode_buffers(inode);
-#if LINUX_VERSION_CODE >= LinuxVersionCode(2,4,18)
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,18)
 				fsync_inode_data_buffers(inode);
 #endif
+#endif
 			}
 			if (oin != NULL) {
 				lockres->lock_type = lockres->lock_state = OCFS_DLM_NO_LOCK;
@@ -1249,10 +1253,14 @@
 		       atomic_read(seq));
 
 	if (sync_buffers) {
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+		sync_mapping_buffers(inode->i_mapping);
+#else
 		fsync_inode_buffers(inode);
-#if LINUX_VERSION_CODE >= LinuxVersionCode(2,4,18)
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,18)
 		fsync_inode_data_buffers(inode);
 #endif
+#endif
 	}
 }
 
