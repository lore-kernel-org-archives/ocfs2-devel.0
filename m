From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 30 Apr 2009 06:58:30 +0800
Subject: [Ocfs2-devel] [PATCH 18/39] ocfs2: Use proper parameter for some
	inode operation.
In-Reply-To: <49F95A79.6040806@oracle.com>
References: <49F95A79.6040806@oracle.com>
Message-ID: <1241045931-24607-18-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In order to make the original function more suitable for reflink,
we modify the following inode operations. Both are tiny.

1. ocfs2_mknod_locked only use dentry for mlog, so move it to
   the caller so that reflink can use it without dentry.
2. ocfs2_prepare_orphan_dir only want inode to get its ip_blkno.
   So use ip_blkno instead.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/namei.c |   32 +++++++++++++++++---------------
 1 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index e38b9dc..04ffbfe 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -69,7 +69,6 @@
 static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 			      struct inode *dir,
 			      struct inode *inode,
-			      struct dentry *dentry,
 			      dev_t dev,
 			      struct buffer_head **new_fe_bh,
 			      struct buffer_head *parent_fe_bh,
@@ -78,7 +77,7 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 
 static int ocfs2_prepare_orphan_dir(struct ocfs2_super *osb,
 				    struct inode **ret_orphan_dir,
-				    struct inode *inode,
+				    u64 blkno,
 				    char *name,
 				    struct ocfs2_dir_lookup_result *lookup);
 
@@ -356,8 +355,12 @@ int ocfs2_mknod(struct inode *dir, struct dentry *dentry,
 	}
 	did_quota_inode = 1;
 
+	mlog_entry("(0x%p, 0x%p, %d, %lu, '%.*s')\n", dir, dentry,
+		   inode->i_mode, (unsigned long)dev, dentry->d_name.len,
+		   dentry->d_name.name);
+
 	/* do the real work now. */
-	status = ocfs2_mknod_locked(osb, dir, inode, dentry, dev,
+	status = ocfs2_mknod_locked(osb, dir, inode, dev,
 				    &new_fe_bh, parent_fe_bh, handle,
 				    inode_ac);
 	if (status < 0) {
@@ -464,7 +467,6 @@ leave:
 static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 			      struct inode *dir,
 			      struct inode *inode,
-			      struct dentry *dentry,
 			      dev_t dev,
 			      struct buffer_head **new_fe_bh,
 			      struct buffer_head *parent_fe_bh,
@@ -478,10 +480,6 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 	u16 suballoc_bit;
 	u16 feat;
 
-	mlog_entry("(0x%p, 0x%p, %d, %lu, '%.*s')\n", dir, dentry,
-		   inode->i_mode, (unsigned long)dev, dentry->d_name.len,
-		   dentry->d_name.name);
-
 	*new_fe_bh = NULL;
 
 	status = ocfs2_claim_new_inode(osb, handle, dir, parent_fe_bh,
@@ -849,7 +847,8 @@ static int ocfs2_unlink(struct inode *dir,
 	}
 
 	if (inode_is_unlinkable(inode)) {
-		status = ocfs2_prepare_orphan_dir(osb, &orphan_dir, inode,
+		status = ocfs2_prepare_orphan_dir(osb, &orphan_dir,
+						  OCFS2_I(inode)->ip_blkno,
 						  orphan_name, &orphan_insert);
 		if (status < 0) {
 			mlog_errno(status);
@@ -1240,9 +1239,8 @@ static int ocfs2_rename(struct inode *old_dir,
 
 		if (S_ISDIR(new_inode->i_mode) || (new_inode->i_nlink == 1)) {
 			status = ocfs2_prepare_orphan_dir(osb, &orphan_dir,
-							  new_inode,
-							  orphan_name,
-							  &orphan_insert);
+						OCFS2_I(new_inode)->ip_blkno,
+						orphan_name, &orphan_insert);
 			if (status < 0) {
 				mlog_errno(status);
 				goto bail;
@@ -1698,7 +1696,11 @@ static int ocfs2_symlink(struct inode *dir,
 	}
 	did_quota_inode = 1;
 
-	status = ocfs2_mknod_locked(osb, dir, inode, dentry,
+	mlog_entry("(0x%p, 0x%p, %d, '%.*s')\n", dir, dentry,
+		   inode->i_mode, dentry->d_name.len,
+		   dentry->d_name.name);
+
+	status = ocfs2_mknod_locked(osb, dir, inode,
 				    0, &new_fe_bh, parent_fe_bh, handle,
 				    inode_ac);
 	if (status < 0) {
@@ -1848,7 +1850,7 @@ bail:
 
 static int ocfs2_prepare_orphan_dir(struct ocfs2_super *osb,
 				    struct inode **ret_orphan_dir,
-				    struct inode *inode,
+				    u64 blkno,
 				    char *name,
 				    struct ocfs2_dir_lookup_result *lookup)
 {
@@ -1856,7 +1858,7 @@ static int ocfs2_prepare_orphan_dir(struct ocfs2_super *osb,
 	struct buffer_head *orphan_dir_bh = NULL;
 	int status = 0;
 
-	status = ocfs2_blkno_stringify(OCFS2_I(inode)->ip_blkno, name);
+	status = ocfs2_blkno_stringify(blkno, name);
 	if (status < 0) {
 		mlog_errno(status);
 		return status;
-- 
1.6.2.rc2.16.gf474c
