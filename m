From: wangang wang <wen.gang.wang@oracle.com>
Date: Mon, 22 Sep 2008 16:47:42 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: protects generic_fillattr in
	metalock/unlock in ocfs2_getattr()
Message-ID: <200809220847.m8M8lgKM004354@wengang.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

we need do generic_fillattr() bettwen meta lock and meata unlock in ocfs2_getattr().
1) move generic_fillattr() bettwen meta lock and meata unlock
2) fails this call if nlink is zero.

the patches are against 1.4 git and 1.2 svn respectively.

Signed-off-by: Wengang wang <wen.gang.wang@oracle.com>
--
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index e2f74fb..9808e9f 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1158,13 +1158,27 @@ int ocfs2_getattr(struct vfsmount *mnt,
 		  struct kstat *stat)
 {
 	struct inode *inode = dentry->d_inode;
-	struct super_block *sb = dentry->d_inode->i_sb;
-	struct ocfs2_super *osb = sb->s_fs_info;
+	struct ocfs2_super *osb = dentry->d_inode->i_sb->s_fs_info;
 	int err;
 
 	mlog_entry_void();
 
-	err = ocfs2_inode_revalidate(dentry);
+	if (!inode) {
+		mlog(0, "eep, no inode!\n");
+		err = -ENOENT;
+		goto bail;
+	}
+
+	spin_lock(&OCFS2_I(inode)->ip_lock);
+	if ((OCFS2_I(inode)->ip_flags & OCFS2_INODE_DELETED)) {
+		spin_unlock(&OCFS2_I(inode)->ip_lock);
+		mlog(0, "inode deleted!\n");
+		err = -ENOENT;
+		goto bail;
+	}
+	spin_unlock(&OCFS2_I(inode)->ip_lock);
+	
+	err = ocfs2_inode_lock(inode, NULL, 0);
 	if (err) {
 		if (err != -ENOENT)
 			mlog_errno(err);
@@ -1172,10 +1186,16 @@ int ocfs2_getattr(struct vfsmount *mnt,
 	}
 
 	generic_fillattr(inode, stat);
-
+	
 	/* We set the blksize from the cluster size for performance */
 	stat->blksize = osb->s_clustersize;
 
+	if (!stat->nlink) {
+		mlog(0, "inode deleted!\n");
+		err = -ENOENT;
+	}
+
+	ocfs2_inode_unlock(inode, 0);
 bail:
 	mlog_exit(err);
 
Index: fs/ocfs2/file.c
===================================================================
--- fs/ocfs2/file.c	(revision 3101)
+++ fs/ocfs2/file.c	(working copy)
@@ -1162,14 +1162,28 @@
 		  struct kstat *stat)
 {
 	struct inode *inode = dentry->d_inode;
-	struct super_block *sb = dentry->d_inode->i_sb;
-	struct ocfs2_super *osb = sb->s_fs_info;
+	struct ocfs2_super *osb = dentry->d_inode->i_sb->s_fs_info;
 	int err;
 
 	mlog_entry_void();
 
-	err = ocfs2_inode_revalidate(dentry);
-	if (err) {
+	if (!inode) {
+		mlog(0, "eep, no inode!\n");
+		err = -ENOENT;
+		goto bail;
+	}
+
+	spin_lock(&OCFS2_I(inode)->ip_lock);
+	if ((OCFS2_I(inode)->ip_flags & OCFS2_INODE_DELETED)) {
+		spin_unlock(&OCFS2_I(inode)->ip_lock);
+		mlog(0, "inode deleted!\n");
+		err = -ENOENT;
+		goto bail;
+	}
+	spin_unlock(&OCFS2_I(inode)->ip_lock);
+
+	err =  ocfs2_meta_lock(inode, NULL, NULL, 0);
+	if (err<0) {
 		if (err != -ENOENT)
 			mlog_errno(err);
 		goto bail;
@@ -1180,6 +1194,12 @@
 	/* We set the blksize from the cluster size for performance */
 	stat->blksize = osb->s_clustersize;
 
+	if (!stat->nlink) {
+		mlog(0, "inode deleted!\n");
+		err = -ENOENT;
+	}
+
+	ocfs2_meta_unlock(inode, 0);
 bail:
 	mlog_exit(err);
 
