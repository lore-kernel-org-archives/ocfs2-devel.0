From: Christoph Hellwig <hch@lst.de>
Date: Sun Jun 20 09:07:19 2004
Subject: [Ocfs2-devel] [PATCH] file_operations belong to file.c
Message-ID: <20040620140706.GA15757@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

allows lots of function to become static in there.  The only problem is
the 2.4 aio support which uses file operations for what should be
address_space operations.  They're misplaced in both inode.c and file.c
so they'll get a file of their own one day.


Index: src/inode.c
===================================================================
--- src/inode.c	(revision 1156)
+++ src/inode.c	(working copy)
@@ -41,12 +41,10 @@
 #include "ocfs.h"
 
 #include "alloc.h"
-#include "dir.h"
 #include "dlm.h"
 #include "extmap.h"
 #include "file.h"
 #include "inode.h"
-#include "ioctl.h"
 #include "lockres.h"
 #include "namei.h"
 #include "super.h"
@@ -106,12 +104,6 @@
 #endif
 #endif
 
-#ifdef AIO_ENABLED
-int ocfs_kvec_read(struct file *file, kvec_cb_t cb, size_t size, loff_t pos); 
-int ocfs_kvec_write(struct file *file, kvec_cb_t cb, size_t size, loff_t pos); 
-int ocfs_kvec_rw(struct file *filp, int rw, kvec_cb_t cb, size_t size, loff_t pos);
-#endif /* AIO_ENABLED */
-
 static void __ocfs_read_inode2(struct inode *inode, 
 			       ocfs_find_inode_args *args);
 
@@ -131,31 +123,6 @@
 #endif
 };
 
-static struct file_operations ocfs_fops = {
-	.read = ocfs_file_read,
-	.write = ocfs_file_write,
-	.mmap = generic_file_mmap,
-	.fsync = ocfs_sync_file,
-	.flush = ocfs_flush,
-	.release = ocfs_file_release,
-	.open = ocfs_file_open,
-	.ioctl = ocfs_ioctl,
-#ifdef AIO_ENABLED
-	.kvec_read = ocfs_kvec_read,
-	.kvec_write = ocfs_kvec_write,
-	.aio_read = generic_file_aio_read,
-	.aio_write = generic_file_aio_write,
-#endif
-};
-
-static struct file_operations ocfs_dops = {
-	.read = generic_read_dir,
-	.readdir = ocfs_readdir,
-	.fsync = ocfs_sync_file,
-	.release = ocfs_file_release,
-	.ioctl = ocfs_ioctl
-};
-
 static struct inode_operations ocfs_dir_iops = {
 	.create = ocfs_create,
 	.lookup = ocfs_lookup,
@@ -1761,18 +1728,9 @@
 #endif /* 2.4.x kernel */
 
 #ifdef AIO_ENABLED
-int ocfs_kvec_read(struct file *file, kvec_cb_t cb, size_t size, loff_t pos) 
+static int ocfs_kvec_rw(struct file *filp, int rw, kvec_cb_t cb,
+		size_t size, loff_t pos)
 {
-	return ocfs_kvec_rw(file, READ, cb, size, pos);
-}
-
-int ocfs_kvec_write(struct file *file, kvec_cb_t cb, size_t size, loff_t pos) 
-{
-	return ocfs_kvec_rw(file, WRITE, cb, size, pos);
-}
-
-int ocfs_kvec_rw(struct file *filp, int rw, kvec_cb_t cb, size_t size, loff_t pos) 
-{
 	int	     err = 0;
 	int max_sectors = 25000;
 	struct inode *inode = filp->f_dentry->d_inode;
@@ -1863,6 +1821,15 @@
 
 }
 
+int ocfs_kvec_read(struct file *file, kvec_cb_t cb, size_t size, loff_t pos) 
+{
+	return ocfs_kvec_rw(file, READ, cb, size, pos);
+}
+
+int ocfs_kvec_write(struct file *file, kvec_cb_t cb, size_t size, loff_t pos) 
+{
+	return ocfs_kvec_rw(file, WRITE, cb, size, pos);
+}
 #endif
 
 /*
Index: src/inode.h
===================================================================
--- src/inode.h	(revision 1156)
+++ src/inode.h	(working copy)
@@ -50,4 +50,9 @@
 int ocfs_verify_update_inode(ocfs_super *osb, struct inode *inode,
 			     int *needs_trunc, int lockres_locked);
 
+#ifdef AIO_ENABLED
+int ocfs_kvec_read(struct file *file, kvec_cb_t cb, size_t size, loff_t pos); 
+int ocfs_kvec_write(struct file *file, kvec_cb_t cb, size_t size, loff_t pos); 
+#endif
+
 #endif /* OCFS2_INODE_H */
Index: src/file.c
===================================================================
--- src/file.c	(revision 1156)
+++ src/file.c	(working copy)
@@ -37,11 +37,13 @@
 #include "ocfs.h"
 
 #include "alloc.h"
+#include "dir.h"
 #include "dlm.h"
 #include "extmap.h"
 #include "file.h"
 #include "sysfile.h"
 #include "inode.h"
+#include "ioctl.h"
 #include "util.h"
 
 #include "ocfs_journal.h"
@@ -173,7 +175,7 @@
  * ocfs_file_open()
  *
  */
-int ocfs_file_open (struct inode *inode, struct file *file)
+static int ocfs_file_open(struct inode *inode, struct file *file)
 {
 	int ret =0, err = 0, status = 0;
 	int mode = file->f_flags;
@@ -332,7 +334,7 @@
  * ocfs_file_release()
  *
  */
-int ocfs_file_release (struct inode *inode, struct file *file)
+static int ocfs_file_release (struct inode *inode, struct file *file)
 {
 	ocfs_super * osb;
 	struct dentry *dentry;
@@ -516,7 +518,7 @@
  * ocfs_flush()
  *
  */
-int ocfs_flush (struct file *file)
+static int ocfs_flush(struct file *file)
 {
 	int err = 0;
 
@@ -532,7 +534,8 @@
  * ocfs_sync_file()
  *
  */
-int ocfs_sync_file (struct file *file, struct dentry *dentry, int datasync)
+static int ocfs_sync_file(struct file *file, struct dentry *dentry,
+		int datasync)
 {
 	int err = 0;
 	journal_t *journal;
@@ -670,7 +673,8 @@
  * Linux 2.5 TODO: Remove all O_DIRECT conditionals here, they are no longer
  * needed.
  */
-ssize_t ocfs_file_write (struct file *filp, const char *buf, size_t count, loff_t * ppos)
+static ssize_t ocfs_file_write(struct file *filp, const char *buf,
+		size_t count, loff_t *ppos)
 {
 	int ret = 0;
 	int saAcquired = 0, writingAtEOF = 0;
@@ -832,7 +836,8 @@
  * Linux 2.5 TODO: Remove all O_DIRECT conditionals here, they are no longer
  * needed.
  */
-ssize_t ocfs_file_read (struct file *filp, char *buf, size_t count, loff_t * ppos)
+static ssize_t ocfs_file_read(struct file *filp, char *buf,
+		size_t count, loff_t *ppos)
 {
 	int ret = 0;
 	ocfs_super *osb = NULL;
@@ -898,6 +903,31 @@
 	return ret;
 }				/* ocfs_file_read */
 
+struct file_operations ocfs_fops = {
+	.read = ocfs_file_read,
+	.write = ocfs_file_write,
+	.mmap = generic_file_mmap,
+	.fsync = ocfs_sync_file,
+	.flush = ocfs_flush,
+	.release = ocfs_file_release,
+	.open = ocfs_file_open,
+	.ioctl = ocfs_ioctl,
+#ifdef AIO_ENABLED
+	.kvec_read = ocfs_kvec_read,
+	.kvec_write = ocfs_kvec_write,
+	.aio_read = generic_file_aio_read,
+	.aio_write = generic_file_aio_write,
+#endif
+};
+
+struct file_operations ocfs_dops = {
+	.read = generic_read_dir,
+	.readdir = ocfs_readdir,
+	.fsync = ocfs_sync_file,
+	.release = ocfs_file_release,
+	.ioctl = ocfs_ioctl
+};
+
 /*
  * ocfs_truncate_file()
  *
Index: src/file.h
===================================================================
--- src/file.h	(revision 1156)
+++ src/file.h	(working copy)
@@ -29,29 +29,20 @@
 #ifndef OCFS2_FILE_H
 #define OCFS2_FILE_H
 
+extern struct file_operations ocfs_fops;
+extern struct file_operations ocfs_dops;
+
 int ocfs_extend_file (ocfs_super * osb, __u64 file_size, __u64 file_off, 
 		      ocfs_journal_handle *passed_handle, 
 		      struct inode *inode, struct iattr *attr, 
 		      int system_file, struct buffer_head *fe_bh);
-int ocfs_file_open(struct inode *inode, struct file *file);
-ssize_t ocfs_file_read(struct file *filp, char *buf, size_t count,
-		       loff_t * ppos);
-int ocfs_file_release(struct inode *inode, struct file *file);
-ssize_t ocfs_file_write(struct file *filp, const char *buf,
-			size_t count, loff_t *ppos);
-int ocfs_flush(struct file *file);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 int ocfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		 struct kstat *stat);
-#else
-int ocfs_getattr(struct dentry *dentry, struct iattr *attr);
-#endif
 int ocfs_inode_fill_ext_map(ocfs_super *osb, struct buffer_head *fe_bh,
 			    struct inode *inode);
 int ocfs_inode_notify_open(ocfs_super *osb, struct buffer_head *fe_bh, 
 			   ocfs_journal_handle *handle,
 			   struct inode *inode);
 int ocfs_setattr(struct dentry *dentry, struct iattr *attr);
-int ocfs_sync_file(struct file *file, struct dentry *dentry, int datasync);
 
 #endif /* OCFS2_FILE_H */
