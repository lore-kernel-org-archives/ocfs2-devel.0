From: Christoph Hellwig <hch@lst.de>
Date: Sun Jun 20 09:39:00 2004
Subject: [Ocfs2-devel] [PATCH] cleanup read_super ifdef mess a little
Message-ID: <20040620143856.GA16073@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Index: src/super.c
===================================================================
--- src/super.c	(revision 1156)
+++ src/super.c	(working copy)
@@ -323,11 +301,7 @@
 	return(status);
 } /* ocfs_release_system_inodes */
 
-/*
- * __ocfs_read_super()
- *
- */
-static int __ocfs_read_super(struct super_block *sb, void *data, int silent)
+static int ocfs_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct dentry *root;
 	int status;
@@ -396,17 +370,12 @@
 
 	LOG_EXIT_STATUS(status);
 	return status;
-}				/* __ocfs_read_super */
-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-static int ocfs_read_super (struct super_block *sb, void *data, int silent)
-{
-	return __ocfs_read_super(sb, data, silent);
 }
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 static struct super_block *ocfs_get_sb(struct file_system_type *fs_type, int flags, const char *dev_name, void *data)
 {
-	return get_sb_bdev(fs_type, flags, dev_name, data, ocfs_read_super);
+	return get_sb_bdev(fs_type, flags, dev_name, data, ocfs_fill_super);
 }
 
 static struct file_system_type ocfs_fs_type = {
@@ -427,7 +396,7 @@
 {
 	MOD_INC_USE_COUNT;
 
-	if (__ocfs_read_super(sb, data, silent) < 0) {
+	if (ocfs_fill_super(sb, data, silent) < 0) {
 		MOD_DEC_USE_COUNT;
 		return NULL;
 	}
