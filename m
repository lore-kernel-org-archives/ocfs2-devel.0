From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 27 Mar 2009 07:02:27 +0800
Subject: [Ocfs2-devel] [PATCH 21/42] ocfs2: Use proper parameter for some
	inode operation.
In-Reply-To: <49CC86FC.2070906@oracle.com>
References: <49CC86FC.2070906@oracle.com>
Message-ID: <1238108568-23740-21-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In order to make the original function more suitable for relink,
we modify the following inode operations. Both are tiny.

1. ocfs2_mknod_locked only use dentry for mlog and it don't use
   dir and parent_fe_bh so remove these 3 parameters and move
   the mlog to its caller.
2. ocfs2_prepare_orphan_dir only want inode to get its ip_blkno.
   So use ip_blkno instead.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/namei.c |   42 +++++++++++++++++++-----------------------
 1 files changed, 19 insertions(+), 23 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 7a309bd..d0baa05 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -67,18 +67,15 @@
 #include "buffer_head_io.h"
 
 static int ocfs2_mknod_locked(struct ocfs2_super *osb,
-			      struct inode *dir,
 			      struct inode *inode,
-			      struct dentry *dentry,
 			      dev_t dev,
 			      struct buffer_head **new_fe_bh,
-			      struct buffer_head *parent_fe_bh,
 			      handle_t *handle,
 			      struct ocfs2_alloc_context *inode_ac);
 
 static int ocfs2_prepare_orphan_dir(struct ocfs2_super *osb,
 				    struct inode **ret_orphan_dir,
-				    struct inode *inode,
+				    u64 blkno,
 				    char *name,
 				    struct buffer_head **de_bh);
 
@@ -342,10 +339,13 @@ int ocfs2_mknod(struct inode *dir, struct dentry *dentry,
 	}
 	did_quota_inode = 1;
 
+	mlog_entry("(0x%p, 0x%p, %d, %lu, '%.*s')\n", dir, dentry,
+		   inode->i_mode, (unsigned long)dev, dentry->d_name.len,
+		   dentry->d_name.name);
+
 	/* do the real work now. */
-	status = ocfs2_mknod_locked(osb, dir, inode, dentry, dev,
-				    &new_fe_bh, parent_fe_bh, handle,
-				    inode_ac);
+	status = ocfs2_mknod_locked(osb, inode, dev,
+				    &new_fe_bh, handle, inode_ac);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
@@ -447,12 +447,9 @@ leave:
 }
 
 static int ocfs2_mknod_locked(struct ocfs2_super *osb,
-			      struct inode *dir,
 			      struct inode *inode,
-			      struct dentry *dentry,
 			      dev_t dev,
 			      struct buffer_head **new_fe_bh,
-			      struct buffer_head *parent_fe_bh,
 			      handle_t *handle,
 			      struct ocfs2_alloc_context *inode_ac)
 {
@@ -462,10 +459,6 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 	u64 fe_blkno = 0;
 	u16 suballoc_bit;
 
-	mlog_entry("(0x%p, 0x%p, %d, %lu, '%.*s')\n", dir, dentry,
-		   inode->i_mode, (unsigned long)dev, dentry->d_name.len,
-		   dentry->d_name.name);
-
 	*new_fe_bh = NULL;
 
 	status = ocfs2_claim_new_inode(osb, handle, inode_ac, &suballoc_bit,
@@ -834,7 +827,8 @@ static int ocfs2_unlink(struct inode *dir,
 	}
 
 	if (inode_is_unlinkable(inode)) {
-		status = ocfs2_prepare_orphan_dir(osb, &orphan_dir, inode,
+		status = ocfs2_prepare_orphan_dir(osb, &orphan_dir,
+						  OCFS2_I(inode)->ip_blkno,
 						  orphan_name,
 						  &orphan_entry_bh);
 		if (status < 0) {
@@ -1222,9 +1216,8 @@ static int ocfs2_rename(struct inode *old_dir,
 
 		if (S_ISDIR(new_inode->i_mode) || (new_inode->i_nlink == 1)) {
 			status = ocfs2_prepare_orphan_dir(osb, &orphan_dir,
-							  new_inode,
-							  orphan_name,
-							  &orphan_entry_bh);
+						OCFS2_I(new_inode)->ip_blkno,
+						orphan_name, &orphan_entry_bh);
 			if (status < 0) {
 				mlog_errno(status);
 				goto bail;
@@ -1678,9 +1671,12 @@ static int ocfs2_symlink(struct inode *dir,
 	}
 	did_quota_inode = 1;
 
-	status = ocfs2_mknod_locked(osb, dir, inode, dentry,
-				    0, &new_fe_bh, parent_fe_bh, handle,
-				    inode_ac);
+	mlog_entry("(0x%p, 0x%p, %d, '%.*s')\n", dir, dentry,
+		   inode->i_mode, dentry->d_name.len,
+		   dentry->d_name.name);
+
+	status = ocfs2_mknod_locked(osb, inode,
+				    0, &new_fe_bh, handle, inode_ac);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -1828,7 +1824,7 @@ bail:
 
 static int ocfs2_prepare_orphan_dir(struct ocfs2_super *osb,
 				    struct inode **ret_orphan_dir,
-				    struct inode *inode,
+				    u64 blkno,
 				    char *name,
 				    struct buffer_head **de_bh)
 {
@@ -1836,7 +1832,7 @@ static int ocfs2_prepare_orphan_dir(struct ocfs2_super *osb,
 	struct buffer_head *orphan_dir_bh = NULL;
 	int status = 0;
 
-	status = ocfs2_blkno_stringify(OCFS2_I(inode)->ip_blkno, name);
+	status = ocfs2_blkno_stringify(blkno, name);
 	if (status < 0) {
 		mlog_errno(status);
 		return status;
-- 
1.6.2.rc2.16.gf474c
