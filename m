From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Thu Feb 26 20:22:10 2004
Subject: [Ocfs2-devel] [PATCH]2.6 prototype fixes
Message-ID: <200402270221.i1R2Lxs4007447@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following is a patch for various function definition and prototype 
changes for a 2.6 kernel. (The ocfs_getattr definition was already
fixed in a previous patch.)

    --rusty

Index: src/inc/proto.h
===================================================================
--- src/inc/proto.h	(revision 36)
+++ src/inc/proto.h	(working copy)
@@ -78,9 +78,12 @@
 ssize_t ocfs_file_read (struct file *filp, char *buf, size_t count, loff_t * ppos);
 int ocfs_extend_file (ocfs_super * osb, __u64 parent_off, ocfs_inode * oin, __u64 file_size, __u64 * file_off, ocfs_journal_handle *passed_handle, struct inode *inode, struct iattr *attr);
 int ocfs_setattr (struct dentry *dentry, struct iattr *attr);
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+int ocfs_getattr (struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat);
+#else
 int ocfs_getattr (struct dentry *dentry, struct iattr *attr);
+#endif
 
-
 int ocfs_find_inode (struct inode *inode, unsigned long ino, void *opaque);
 void ocfs_populate_inode (struct inode *inode, ocfs_file_entry *fe, umode_t mode, void *genptr, bool create_ino);
 void ocfs_read_locked_inode (struct inode *inode, ocfs_file_entry *entry);
@@ -242,14 +245,25 @@
 
 
 int ocfs_empty (struct dentry *dentry);
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+int ocfs_dentry_revalidate (struct dentry *dentry, struct nameidata *nd);
+#else
 int ocfs_dentry_revalidate (struct dentry *dentry, int flags);
+#endif
 int ocfs_foreach_child (struct dentry *dentry, int (*func)(struct dentry *, void *), void *data);
-
 int ocfs_readdir (struct file *filp, void *dirent, filldir_t filldir);
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+struct dentry *ocfs_lookup (struct inode *dir, struct dentry *dentry, struct nameidata *nd);
+#else
 struct dentry *ocfs_lookup (struct inode *dir, struct dentry *dentry);
+#endif
 int ocfs_mknod (struct inode *dir, struct dentry *dentry, int mode, ocfs_dev dev);
 int ocfs_mkdir (struct inode *dir, struct dentry *dentry, int mode);
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+int ocfs_create (struct inode *dir, struct dentry *dentry, int mode, struct nameidata *nd);
+#else
 int ocfs_create (struct inode *dir, struct dentry *dentry, int mode);
+#endif
 int ocfs_link (struct dentry *old_dentry, struct inode *dir, struct dentry *dentry);
 int ocfs_unlink (struct inode *dir, struct dentry *dentry);
 int ocfs_rename (struct inode *old_dir, struct dentry *old_dentry, struct inode *new_dir, struct dentry *new_dentry);
Index: src/dcache.c
===================================================================
--- src/dcache.c	(revision 36)
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
 
Index: src/namei.c
===================================================================
--- src/namei.c	(revision 36)
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
@@ -533,7 +537,11 @@
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
 
