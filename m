From: Christoph Hellwig <hch@lst.de>
Date: Sat Sep  4 04:53:16 2004
Subject: [Ocfs2-devel] [PATCH] remove ocfs_put_inode
Message-ID: <20040904095307.GA18592@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

this doesn't do anything but noisy debug printks anymore


Index: src/super.c
===================================================================
--- src/super.c	(revision 1426)
+++ src/super.c	(working copy)
@@ -196,9 +196,7 @@
 
 static struct super_operations ocfs_sops = {
 	.statfs = ocfs_statfs,
-	.put_inode = ocfs_put_inode,
 	.clear_inode = ocfs_clear_inode,
-	//put_inode =           force_delete,
 	.delete_inode =        ocfs_delete_inode, 
 	.sync_fs = ocfs_sync_fs,
 	.write_super = ocfs_write_super,
Index: src/inode.c
===================================================================
--- src/inode.c	(revision 1426)
+++ src/inode.c	(working copy)
@@ -521,26 +521,6 @@
 	return status;
 }
 
-/*
- * ocfs_put_inode()
- *
- */
-void ocfs_put_inode (struct inode *inode)
-{
-	ocfs_super *osb;
-
-	LOG_SET_CONTEXT(PUT_INODE);
-
-	LOG_ENTRY_ARGS ("(0x%p, i_ino=%llu)\n", inode, OCFS_I(inode)->ip_blkno);
-	LOG_TRACE_ARGS ("put_inode: count=%d\n", atomic_read(&inode->i_count));
-	osb = OCFS_SB(inode->i_sb);
-	LOG_EXIT ();
-
-	LOG_CLEAR_CONTEXT();
-	return;
-}				/* ocfs_put_inode */
-
-
 void ocfs_sync_blockdev(struct super_block *sb)
 {
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
Index: src/inode.h
===================================================================
--- src/inode.h	(revision 1426)
+++ src/inode.h	(working copy)
@@ -40,7 +40,6 @@
 int ocfs_inode_revalidate(struct dentry *dentry);
 int ocfs_populate_inode(struct inode *inode, ocfs2_dinode *fe,
 			 int create_ino);
-void ocfs_put_inode(struct inode *inode);
 void ocfs_read_inode(struct inode *inode);
 void ocfs_read_inode2(struct inode *inode, void *opaque);
 ssize_t ocfs_rw_direct(int rw, struct file *filp, char *buf,
