From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Tue Mar 30 17:02:51 2004
Subject: [Ocfs2-devel] [PATCH][CLEANUP]remove ocfs_inode_read() 
Message-ID: <200403302257.i2UMvltD012465@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

If read_inode2 is defined in the super operations, then read_inode
will not be called.  The following patch removes just removes the
uncalled ocfs_read_inode().

    --rusty

Index: src/super.c
===================================================================
--- src/super.c	(revision 825)
+++ src/super.c	(working copy)
@@ -147,7 +147,6 @@
 	//put_inode =           force_delete,
 	//delete_inode =        ocfs_delete_inode, 
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
-	.read_inode = ocfs_read_inode,
 	.read_inode2 = ocfs_read_inode2,
 #endif
 	.put_super = ocfs_put_super,
Index: src/inode.c
===================================================================
--- src/inode.c	(revision 825)
+++ src/inode.c	(working copy)
@@ -534,14 +534,6 @@
 	return;
 }				/* ocfs_read_inode2 */
 
-/*
- * ocfs_read_inode()
- * Only used in Linux 2.4
- */
-void ocfs_read_inode (struct inode *inode)
-{
-	make_bad_inode (inode);
-}				/* ocfs_read_inode() */
 #endif
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
Index: src/inc/proto.h
===================================================================
--- src/inc/proto.h	(revision 825)
+++ src/inc/proto.h	(working copy)
@@ -92,7 +92,6 @@
 void ocfs_populate_inode (struct inode *inode, ocfs_file_entry *fe, umode_t mode, void *genptr, bool create_ino);
 void ocfs_read_locked_inode (struct inode *inode, ocfs_find_inode_args *args);
 void ocfs_read_inode2 (struct inode *inode, void *opaque);
-void ocfs_read_inode (struct inode *inode);
 struct inode * ocfs_iget(struct super_block *sb, ocfs_find_inode_args *args);
 void ocfs_put_inode (struct inode *inode);
 void ocfs_clear_inode (struct inode *inode);
