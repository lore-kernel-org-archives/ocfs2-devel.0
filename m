From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Mon Mar  1 10:47:46 2004
Subject: [Ocfs2-devel] [PATCH]revised misc 2.6 prototype fixes
Message-ID: <200403011647.i21GlLlr015972@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I am rechecking out my tree this morning and recreating patches to
fix compile errors/warnings triggered on a 2.6 build.

The following is some misc prototype fixes that still need to make
it into the tree.

    --rusty

Index: src/dcache.c
===================================================================
--- src/dcache.c	(revision 738)
+++ src/dcache.c	(working copy)
@@ -35,7 +35,11 @@
  * ocfs_dentry_revalidate()
  *
  */
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+int ocfs_dentry_revalidate (struct dentry *dentry, struct nameidata *nd)
+#else
 int ocfs_dentry_revalidate (struct dentry *dentry, int flags)
+#endif
 {
 	int tmpstat, ret = 0;    /* if all else fails, just return false */
 	ocfs_file_entry *fe = NULL;
@@ -46,7 +50,9 @@
         struct qstr q;
 	struct buffer_head *fe_bh = NULL;
 	int needs_trunc;
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+	int flags = nd->flags;
+#else
 	ocfs_find_inode_args args;
 #endif
 
Index: src/inc/ocfs.h
===================================================================
--- src/inc/ocfs.h	(revision 738)
+++ src/inc/ocfs.h	(working copy)
@@ -92,6 +92,7 @@
 #include <linux/blkdev.h>
 #include <linux/in.h>
 #include <linux/buffer_head.h>
+#include <linux/namei.h>
 #endif
 #include <linux/smp_lock.h>
 
Index: src/namei.c
===================================================================
--- src/namei.c	(revision 738)
+++ src/namei.c	(working copy)
@@ -58,7 +58,11 @@
  * ocfs_lookup()
  *
  */
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+struct dentry *ocfs_lookup (struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+#else
 struct dentry *ocfs_lookup (struct inode *dir, struct dentry *dentry)
+#endif
 {
 	int status;
 	ocfs_find_inode_args args;
@@ -542,7 +546,11 @@
  * ocfs_create()
  *
  */
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+int ocfs_create (struct inode *dir, struct dentry *dentry, int mode, struct nameidata *nd)
+#else
 int ocfs_create (struct inode *dir, struct dentry *dentry, int mode)
+#endif
 {
 	int ret;
 
