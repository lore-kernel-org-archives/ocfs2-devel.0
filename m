From: Christoph Hellwig <hch@lst.de>
Date: Fri Aug 13 05:42:33 2004
Subject: [Ocfs2-devel] [PATCH] provide filemap_fdatawrite wrapper for 2.4
Message-ID: <20040813104229.GA5367@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Index: src/ocfs_compat.h
===================================================================
--- src/ocfs_compat.h	(revision 1352)
+++ src/ocfs_compat.h	(working copy)
@@ -121,6 +121,9 @@
 	return error;
 }
 
+#define filemap_fdatawrite(mapping) \
+	filemap_fdatasync(mapping);
+
 #ifdef HAVE_NPTL
 static inline void dequeue_signal_lock(struct task_struct *task,
 				       sigset_t *blocked, siginfo_t *info)
Index: src/file.c
===================================================================
--- src/file.c	(revision 1352)
+++ src/file.c	(working copy)
@@ -80,11 +81,7 @@
 
 int ocfs_sync_inode(struct inode *inode)
 {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 	filemap_fdatawrite(inode->i_mapping);
-#else
-	filemap_fdatasync(inode->i_mapping);
-#endif
 	return sync_mapping_buffers(inode->i_mapping);
 }
 
