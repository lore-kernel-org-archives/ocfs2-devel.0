From: Christoph Hellwig <hch@lst.de>
Date: Mon Jun 14 08:35:05 2004
Subject: [Ocfs2-devel] [PATCH] dcache.c polishing
Message-ID: <20040614133500.GA30415@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

kill dead ocfs_empty stuff, cleanup d_revalidate handling.


Index: dcache.c
===================================================================
--- dcache.c	(revision 1091)
+++ dcache.c	(working copy)
@@ -44,24 +44,11 @@
 #define OCFS_DEBUG_CONTEXT    OCFS_DEBUG_CONTEXT_DCACHE
 
 
-static int ocfs_empty_func(struct dentry *dentry, void *ignore);
-
-/*
- * ocfs_dentry_revalidate()
- *
- */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-int ocfs_dentry_revalidate (struct dentry *dentry, struct nameidata *nd)
-#else
-int ocfs_dentry_revalidate (struct dentry *dentry, int flags)
-#endif
+static int ocfs_dentry_revalidate24(struct dentry *dentry, int flags)
 {
-	int ret = 0;    /* if all else fails, just return false */
 	struct inode *inode = dentry->d_inode;
+	int ret = 0;    /* if all else fails, just return false */
 	ocfs_super *osb;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-	int flags = nd ? nd->flags : 0;
-#endif
 
 	LOG_ENTRY_ARGS ("(0x%p, %d, '%*s')\n", dentry, flags,
 			dentry->d_name.len, dentry->d_name.name);
@@ -106,24 +93,21 @@
 
 	LOG_EXIT_INT (ret);
 	return ret;
-}				/* ocfs_dentry_revalidate */
-
-
-/* exits if it finds any hashed dentries */
-static int ocfs_empty_func(struct dentry *dentry, void *ignore)
-{
-	return 1;
 }
 
-
-/*
- * ocfs_empty()
- *
- */
-int ocfs_empty (struct dentry *dentry)
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+static int ocfs_dentry_revalidate(struct dentry *dentry, struct nameidata *nd)
 {
-	return ocfs_foreach_child (dentry, ocfs_empty_func, NULL);
+	return ocfs_dentry_revalidate24(dentry, nd ? nd->flags : 0);
 }
+struct dentry_operations ocfs_dentry_ops = {
+	.d_revalidate		= ocfs_dentry_revalidate,
+};
+#else
+struct dentry_operations ocfs_dentry_ops = {
+	.d_revalidate		= ocfs_dentry_revalidate24,
+};
+#endif
 
 /*
  * ocfs_foreach_child()
@@ -157,6 +141,4 @@
 
 	LOG_EXIT_INT (ret);
 	return ret;
-}				/* ocfs_foreach_child */
-
-
+}
Index: dcache.h
===================================================================
--- dcache.h	(revision 1091)
+++ dcache.h	(working copy)
@@ -29,12 +29,8 @@
 #ifndef OCFS2_DCACHE_H
 #define OCFS2_DCACHE_H
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-int ocfs_dentry_revalidate(struct dentry *dentry, struct nameidata *nd);
-#else
-int ocfs_dentry_revalidate(struct dentry *dentry, int flags);
-#endif
-int ocfs_empty(struct dentry *dentry);
+extern struct dentry_operations ocfs_dentry_ops;
+
 int ocfs_foreach_child(struct dentry *dentry,
 		       int (*func)(struct dentry *, void *),
 		       void *data);
Index: namei.c
===================================================================
--- namei.c	(revision 1091)
+++ namei.c	(working copy)
@@ -105,10 +105,6 @@
 static int ocfs_orphan_add(ocfs_super *osb, ocfs_journal_handle *handle,
 			   struct inode *inode, ocfs2_dinode *fe);
 
-static struct dentry_operations ocfs_dentry_ops = {
-	.d_revalidate = ocfs_dentry_revalidate	// let's test it out!
-};
-
 static inline int ocfs_add_entry(ocfs_journal_handle *handle, 
 				 struct dentry *dentry, 
 				 struct inode *inode, __u64 inode_off, 
