From: Christoph Hellwig <hch@lst.de>
Date: Mon Jul  5 15:19:17 2004
Subject: [Ocfs2-devel] [PATCH] kill OCFS_NODEV and ocfs_dev
Message-ID: <20040705201911.GA5516@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

NODEV is always 0 in 2.4, and OCFS_NODEV is 0 in 2.6, so it can go away.
use a _24 wrapper for mknod, and internally we can just use dev_t
anyway.


Index: src/namei.c
===================================================================
--- src/namei.c	(revision 1238)
+++ src/namei.c	(working copy)
@@ -85,7 +85,7 @@
 
 static int ocfs_mknod_locked(ocfs_super *osb, struct inode *dir, 
 			     struct dentry *dentry, int mode, 
-			     ocfs_dev dev,
+			     dev_t dev,
 			     struct buffer_head **new_fe_bh, 
 			     struct buffer_head *parent_fe_bh,
 			     ocfs_journal_handle *handle,
@@ -178,8 +178,8 @@
 	return ret;
 }				/* ocfs_lookup */
 
-static int ocfs_mknod(struct inode *dir, struct dentry *dentry, int mode, 
-	       ocfs_dev dev)
+static int ocfs_mknod(struct inode *dir, struct dentry *dentry,
+		int mode, dev_t dev)
 {
 	int status = 0;
 	struct buffer_head *parent_fe_bh = NULL;
@@ -359,7 +361,7 @@
  */
 static int ocfs_mknod_locked(ocfs_super *osb, struct inode *dir, 
 			     struct dentry *dentry, int mode, 
-			     ocfs_dev dev,
+			     dev_t dev,
 			     struct buffer_head **new_fe_bh, 
 			     struct buffer_head *parent_fe_bh,
 			     ocfs_journal_handle *handle,
@@ -502,7 +504,7 @@
 
 	LOG_ENTRY_ARGS ("(0x%p, 0x%p, %d, '%*s')\n", dir, dentry, mode,
 			dentry->d_name.len, dentry->d_name.name);
-	ret = ocfs_mknod (dir, dentry, mode | S_IFDIR, OCFS_NODEV);
+	ret = ocfs_mknod (dir, dentry, mode | S_IFDIR, 0);
 	LOG_EXIT_INT (ret);
 
 	LOG_CLEAR_CONTEXT();
@@ -521,7 +523,7 @@
 
 	LOG_ENTRY_ARGS ("(0x%p, 0x%p, %d, '%*s')\n", dir, dentry, mode,
 			dentry->d_name.len, dentry->d_name.name);
-	ret = ocfs_mknod (dir, dentry, mode | S_IFREG, OCFS_NODEV);
+	ret = ocfs_mknod (dir, dentry, mode | S_IFREG, 0);
 	LOG_EXIT_INT (ret);
 
 	LOG_CLEAR_CONTEXT();
@@ -1556,7 +1558,7 @@
 	got_lock = 1;
 
 	status = ocfs_mknod_locked(osb, dir, dentry, 
- 				   S_IFLNK | S_IRWXUGO, OCFS_NODEV,
+ 				   S_IFLNK | S_IRWXUGO, 0,
  				   &new_fe_bh, parent_fe_bh, handle,
 				   inode);
 	if (status < 0) {
@@ -1584,7 +1588,7 @@
 		}
 		goto abort_trans;
 	}
-	inode->i_rdev = OCFS_NODEV;
+	inode->i_rdev = 0;
 	inode->i_size = newsize;
 	inode->i_blocks = (newsize + sb->s_blocksize - 1) >> sb->s_blocksize_bits;
 
@@ -2181,6 +2185,12 @@
 	return ocfs_create(dir, dentry, mode, NULL);
 }
 
+static int ocfs_mknod_24(struct inode *dir, struct dentry *dentry,
+		int mode, int dev)
+{
+	return ocfs_mknod(dir, dentry, mode, dev);
+}
+
 struct inode_operations ocfs_dir_iops = {
 	.create		= ocfs_create_24,
 	.lookup		= ocfs_lookup_24,
@@ -2189,7 +2199,7 @@
 	.rmdir		= ocfs_unlink,
 	.symlink	= ocfs_symlink,
 	.mkdir		= ocfs_mkdir,
-	.mknod		= ocfs_mknod,
+	.mknod		= ocfs_mknod_24,
 	.rename		= ocfs_rename,
 	.setattr	= ocfs_setattr,
 	.revalidate	= ocfs_inode_revalidate,
Index: src/inode.c
===================================================================
--- src/inode.c	(revision 1238)
+++ src/inode.c	(working copy)
@@ -2010,7 +2010,7 @@
 	       	    S_ISBLK(fe->i_mode) ||
 	      	    S_ISFIFO(fe->i_mode) ||
 	     	    S_ISSOCK(fe->i_mode)) {
-			inode->i_rdev = OCFS_NODEV;
+			inode->i_rdev = 0;
 			init_special_inode(inode, inode->i_mode,
 					   huge_decode_dev(le64_to_cpu(fe->id1.dev1.i_rdev)));
 		}
Index: src/ocfs.h
===================================================================
--- src/ocfs.h	(revision 1238)
+++ src/ocfs.h	(working copy)
@@ -306,15 +306,6 @@
 #define  OCFS_IOC_MAGIC          'O'
 #define  OCFS_IOC_GETTYPE        _IOR(OCFS_IOC_MAGIC, 1, struct ocfs_ioc)
 
-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-typedef dev_t ocfs_dev;
-#define OCFS_NODEV     0
-#else /* 2.4 kernel */
-typedef int ocfs_dev;
-#define OCFS_NODEV     NODEV
-#endif
-
 #define OCFS_SB(sb)	    ((ocfs_super *)OCFS_GENERIC_SB_MEMBER(sb))
 #define OCFS2_SB(sb)	    ((ocfs_super *)OCFS_GENERIC_SB_MEMBER(sb))
 
