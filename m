From: Christoph Hellwig <hch@lst.de>
Date: Tue Jun 22 07:24:24 2004
Subject: [Ocfs2-devel] [PATCH] move iops where they belong
Message-ID: <20040622122419.GA14904@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

also adds a missing .getattr for symlinks


Index: src/namei.c
===================================================================
--- src/namei.c	(revision 1182)
+++ src/namei.c	(working copy)
@@ -116,12 +116,8 @@
  * ocfs_lookup()
  *
  */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-struct dentry *ocfs_lookup(struct inode *dir, struct dentry *dentry,
+static struct dentry *ocfs_lookup(struct inode *dir, struct dentry *dentry,
 			   struct nameidata *nd)
-#else
-struct dentry *ocfs_lookup(struct inode *dir, struct dentry *dentry)
-#endif
 {
 	int status;
 	__u64 fe_off = 0;
@@ -176,7 +172,7 @@
 	return ret;
 }				/* ocfs_lookup */
 
-int ocfs_mknod(struct inode *dir, struct dentry *dentry, int mode, 
+static int ocfs_mknod(struct inode *dir, struct dentry *dentry, int mode, 
 	       ocfs_dev dev)
 {
 	int status = 0;
@@ -488,7 +484,7 @@
  * ocfs_mkdir()
  *
  */
-int ocfs_mkdir (struct inode *dir, struct dentry *dentry, int mode)
+static int ocfs_mkdir (struct inode *dir, struct dentry *dentry, int mode)
 {
 	int ret;
 
@@ -507,11 +503,7 @@
  * ocfs_create()
  *
  */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-int ocfs_create (struct inode *dir, struct dentry *dentry, int mode, struct nameidata *nd)
-#else
-int ocfs_create (struct inode *dir, struct dentry *dentry, int mode)
-#endif
+static int ocfs_create (struct inode *dir, struct dentry *dentry, int mode, struct nameidata *nd)
 {
 	int ret;
 
@@ -530,7 +522,7 @@
  * ocfs_link()
  *
  */
-int ocfs_link (struct dentry * old_dentry,
+static int ocfs_link (struct dentry * old_dentry,
 	       struct inode * dir, struct dentry *dentry)
 {
 	ocfs_journal_handle *handle = NULL;
@@ -673,7 +665,7 @@
  * ocfs_unlink()
  *
  */
-int ocfs_unlink (struct inode *dir, struct dentry *dentry)
+static int ocfs_unlink (struct inode *dir, struct dentry *dentry)
 {
 	int status, tmpstat;
 	int got_parent = 0, got_file = 0;
@@ -1015,7 +1007,7 @@
  * ocfs_rename()
  *
  */
-int ocfs_rename (struct inode *old_dir, struct dentry *old_dentry, struct inode *new_dir, struct dentry *new_dentry)
+static int ocfs_rename (struct inode *old_dir, struct dentry *old_dentry, struct inode *new_dir, struct dentry *new_dentry)
 {
 	int status = 0;
 	struct inode *old_inode = old_dentry->d_inode;
@@ -1372,7 +1364,7 @@
  * ocfs_symlink()
  *
  */
-int ocfs_symlink (struct inode *dir, struct dentry *dentry, const char *symname)
+static int ocfs_symlink (struct inode *dir, struct dentry *dentry, const char *symname)
 {
 	ocfs_super *osb = NULL;
 	struct inode *inode = NULL;
@@ -2032,3 +2024,43 @@
 	LOG_EXIT_STATUS(status);
 	return status;
 }
+
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,0)
+struct inode_operations ocfs_dir_iops = {
+	.create		= ocfs_create,
+	.lookup		= ocfs_lookup,
+	.link		= ocfs_link,
+	.unlink		= ocfs_unlink,
+	.rmdir		= ocfs_unlink,
+	.symlink	= ocfs_symlink,
+	.mkdir		= ocfs_mkdir,
+	.mknod		= ocfs_mknod,
+	.rename		= ocfs_rename,
+	.setattr	= ocfs_setattr,
+	.getattr	= ocfs_getattr,
+};
+#else
+static struct dentry *ocfs_lookup_24(struct inode *dir, struct dentry *dentry)
+{
+	return ocfs_lookup(dir, dentry, NULL);
+}
+
+static int ocfs_create_24(struct inode *dir, struct dentry *dentry, int mode)
+{
+	return ocfs_create(dirm dentry, mode, NULL);
+}
+
+struct inode_operations ocfs_dir_iops = {
+	.create		= ocfs_create_24,
+	.lookup		= ocfs_lookup_24,
+	.link		= ocfs_link,
+	.unlink		= ocfs_unlink,
+	.rmdir		= ocfs_unlink,
+	.symlink	= ocfs_symlink,
+	.mkdir		= ocfs_mkdir,
+	.mknod		= ocfs_mknod,
+	.rename		= ocfs_rename,
+	.setattr	= ocfs_setattr,
+	.revalidate	= ocfs_inode_revalidate,
+};
+#endif
Index: src/inode.c
===================================================================
--- src/inode.c	(revision 1182)
+++ src/inode.c	(working copy)
@@ -120,41 +120,6 @@
 #endif
 };
 
-static struct inode_operations ocfs_dir_iops = {
-	.create = ocfs_create,
-	.lookup = ocfs_lookup,
-	.link = ocfs_link,
-	.unlink = ocfs_unlink,
-	.rmdir = ocfs_unlink,
-	.symlink = ocfs_symlink,
-	.mkdir = ocfs_mkdir,
-	.mknod = ocfs_mknod,
-	.rename = ocfs_rename,
-	.setattr = ocfs_setattr,
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-	.getattr = ocfs_getattr,
-#else
-	.revalidate = ocfs_inode_revalidate,
-#endif
-};
-
-static struct inode_operations ocfs_file_iops = {
-	.setattr = ocfs_setattr,
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-	.getattr = ocfs_getattr,
-#else
-	.revalidate = ocfs_inode_revalidate,
-#endif
-};
-
-struct inode_operations ocfs_symlink_inode_operations = {
-	.readlink = page_readlink,
-	.follow_link = ocfs_follow_link,
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
-	.revalidate = ocfs_inode_revalidate,
-#endif
-};
-
 /* 
  * ocfs_iget()
  * feoff is *required*
Index: src/namei.h
===================================================================
--- src/namei.h	(revision 1182)
+++ src/namei.h	(working copy)
@@ -29,33 +29,14 @@
 #ifndef OCFS2_NAMEI_H
 #define OCFS2_NAMEI_H
 
+extern struct inode_operations ocfs_dir_iops;
+
 int ocfs_check_dir_entry (struct inode *dir,
 			  struct ocfs2_dir_entry *de,
 			  struct buffer_head *bh, unsigned long offset);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-int ocfs_create (struct inode *dir, struct dentry *dentry, int mode, struct nameidata *nd);
-#else
-int ocfs_create (struct inode *dir, struct dentry *dentry, int mode);
-#endif
 struct buffer_head *ocfs_find_entry(const char *name, int namelen,
 				    struct inode *dir,
 				    struct ocfs2_dir_entry **res_dir);
-int ocfs_link(struct dentry *old_dentry, struct inode *dir,
-	      struct dentry *dentry);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-struct dentry *ocfs_lookup(struct inode *dir, struct dentry *dentry,
-			   struct nameidata *nd);
-#else
-struct dentry *ocfs_lookup(struct inode *dir, struct dentry *dentry);
-#endif
-int ocfs_mkdir(struct inode *dir, struct dentry *dentry, int mode);
-int ocfs_mknod(struct inode *dir, struct dentry *dentry, int mode,
-	       ocfs_dev dev);
-int ocfs_rename(struct inode *old_dir, struct dentry *old_dentry,
-		struct inode *new_dir, struct dentry *new_dentry);
-int ocfs_symlink(struct inode *dir, struct dentry *dentry,
-		 const char *symname);
-int ocfs_unlink(struct inode *dir, struct dentry *dentry);
 int ocfs_orphan_del(ocfs_super *osb, ocfs_journal_handle *handle,
 		    struct inode *orphan_dir_inode, struct inode *inode,
 		    struct buffer_head *orphan_dir_bh);
Index: src/file.c
===================================================================
--- src/file.c	(revision 1182)
+++ src/file.c	(working copy)
@@ -1545,4 +1545,15 @@
 	LOG_CLEAR_CONTEXT();
 	return err;
 }
+
+struct inode_operations ocfs_file_iops = {
+	.setattr	= ocfs_setattr,
+	.getattr	= ocfs_getattr,
+};
+#else
+struct inode_operations ocfs_file_iops = {
+	.setattr	= ocfs_setattr,
+	.revalidate	= ocfs_inode_revalidate,
+};
 #endif
+
Index: src/file.h
===================================================================
--- src/file.h	(revision 1182)
+++ src/file.h	(working copy)
@@ -31,6 +31,7 @@
 
 extern struct file_operations ocfs_fops;
 extern struct file_operations ocfs_dops;
+extern struct inode_operations ocfs_file_iops;
 
 int ocfs_extend_file (ocfs_super * osb, __u64 file_size, __u64 file_off, 
 		      ocfs_journal_handle *passed_handle, 
Index: src/symlink.c
===================================================================
--- src/symlink.c	(revision 1182)
+++ src/symlink.c	(working copy)
@@ -43,6 +43,7 @@
 #include "ocfs_log.h"
 #include "ocfs.h"
 
+#include "file.h"
 #include "symlink.h"
 
 #define OCFS_DEBUG_CONTEXT    OCFS_DEBUG_CONTEXT_SYMLINK
@@ -56,9 +57,6 @@
 static unsigned int ocfs_link_size(struct ocfs_symlink_ops *ops, char *str, struct inode *inode);
 static void ocfs_link_expand(struct ocfs_symlink_ops *ops, char *out, char *in, struct inode *inode);
 
-int ocfs_follow_link(struct dentry *dentry, struct nameidata *nd);
-
-
 /* Context Dependent Symbolic Link (CDSL) code  */
 
 /**
@@ -181,7 +179,7 @@
 }
 
 
-int ocfs_follow_link(struct dentry *dentry, struct nameidata *nd)
+static int ocfs_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
 	struct inode *inode = dentry->d_inode;
 	struct page *page = NULL;
@@ -274,3 +272,16 @@
 	return len + 1;
 }
 
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,0)
+struct inode_operations ocfs_symlink_inode_operations = {
+	.readlink	= page_readlink,
+	.follow_link	= ocfs_follow_link,
+	.getattr	= ocfs_getattr,
+};
+#else
+struct inode_operations ocfs_symlink_inode_operations = {
+	.readlink	= page_readlink,
+	.follow_link	= ocfs_follow_link,
+	.revalidate	= ocfs_inode_revalidate,
+};
+#endif
Index: src/symlink.h
===================================================================
--- src/symlink.h	(revision 1182)
+++ src/symlink.h	(working copy)
@@ -29,6 +29,6 @@
 #ifndef OCFS2_SYMLINK_H
 #define OCFS2_SYMLINK_H
 
-int ocfs_follow_link(struct dentry *dentry, struct nameidata *nd);
+extern struct inode_operations ocfs_symlink_inode_operations;
 
 #endif /* OCFS2_SYMLINK_H */
