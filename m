From: Christoph Hellwig <hch@lst.de>
Date: Wed Jun  2 13:10:23 2004
Subject: [Ocfs2-devel] [PATCH] fix the getattr mess
Message-ID: <20040602093202.GA23092@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

2.4 never calls getattr, so no need to implement it.
In 2.6 use generic_fillattr and avoid tons of useless NULL-checks - if
either of those was true we're in really deep problems and better panic
then papering over it.


Index: src/inode.c
===================================================================
--- src/inode.c	(revision 969)
+++ src/inode.c	(working copy)
@@ -123,16 +125,18 @@
 	.mknod = ocfs_mknod,
 	.rename = ocfs_rename,
 	.setattr = ocfs_setattr,
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 	.getattr = ocfs_getattr,
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
+#else
 	.revalidate = ocfs_inode_revalidate,
 #endif
 };
 
 static struct inode_operations ocfs_file_iops = {
 	.setattr = ocfs_setattr,
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 	.getattr = ocfs_getattr,
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
+#else
 	.revalidate = ocfs_inode_revalidate,
 #endif
 };
Index: src/file.c
===================================================================
--- src/file.c	(revision 969)
+++ src/file.c	(working copy)
@@ -1489,86 +1489,25 @@
  */
 int ocfs_getattr (struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 {
-	struct inode *inode;
-	struct super_block *sb;
-	ocfs_super *osb;
-	int err = -1;
+	struct inode *inode = dentry->d_inode;
+	struct super_block *sb = dentry->d_inode->i_sb;
+	ocfs_super *osb = ((ocfs_super *) sb->s_fs_info);
+	int err;
 
 	LOG_ENTRY();
 
-	if (!dentry || !stat)
-		goto bail;
-
-	inode = dentry->d_inode;
-	if (!inode)
-		goto bail;
-	sb = dentry->d_inode->i_sb;
-	osb = ((ocfs_super *) sb->s_fs_info);
-
 	err = ocfs_inode_revalidate(dentry);
-	if (err < 0) {
+	if (err) {
 		if (err != -ENOENT)
 			LOG_ERROR_STATUS(err);
 		goto bail;
 	}
 
-	stat->dev = inode->i_sb->s_dev;
-	stat->ino = inode->i_ino;
-	stat->mode = inode->i_mode;
-	stat->nlink = inode->i_nlink;
-	stat->uid = inode->i_uid;
-	stat->gid = inode->i_gid;
-	stat->rdev = inode->i_rdev;
-	stat->atime = inode->i_atime;
-	stat->mtime = inode->i_mtime;
-	stat->ctime = inode->i_ctime;
-	stat->size = inode->i_size;
-	stat->blocks = inode->i_blocks;
-
+	generic_fillattr(inode, stat);
 	/* We set the blksize from the cluster size for performance */
 	stat->blksize = (__u32) osb->vol_layout.cluster_size;
-
-	err = 0;
 bail:
 	LOG_EXIT_INT (err);
 	return err;
-}				/* ocfs_getattr */
-
-#else
-/*
- * ocfs_getattr()
- * THIS FUNCTION IS UNUSED IN 2.4.x
- */
-int ocfs_getattr (struct dentry *dentry, struct iattr *attr)
-{
-	struct inode *inode;
-	int status, needs_trunc = 0;
-	ocfs_super *osb;
-
-	LOG_ENTRY_ARGS ("(0x%p, 0x%p, '%*s')\n", dentry, attr,
-			dentry->d_name.len, dentry->d_name.name);
-
-	inode = dentry->d_inode;
-	if (inode == NULL || !OCFS_I(inode)->open_hndl_cnt)
-		goto bail;
-
-	osb = OCFS_SB(inode->i_sb);
-	if (inode == osb->root_inode)
-		goto bail;
-
-	/* yay, locking hell! Why do we hit disk for this?! */
-	down(&inode->i_sem);
-	down (&(OCFS_I(inode)->priv_sem));
-	status = ocfs_verify_update_inode (osb, inode, &needs_trunc, 0);
-	up (&(OCFS_I(inode)->priv_sem));
-	if (needs_trunc)
-		ocfs_truncate_inode_pages(inode, 0);
-	if (status < 0)
-		LOG_ERROR_STATUS (status);
-	up(&inode->i_sem);
-bail:
-	LOG_EXIT_INT (0);
-	return 0;
-}				/* ocfs_getattr */
+}
 #endif
-
