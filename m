From: piaojun <piaojun@huawei.com>
Date: Tue, 16 Jan 2018 19:07:43 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/acl: use 'ip_xattr_sem' to protect
 getting extended attribute
Message-ID: <5A5DDCFF.7030001@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The race between *set_acl and *get_acl will cause getting incomplete
xattr data as below:

processA                                    processB

ocfs2_set_acl
  ocfs2_xattr_set
    __ocfs2_xattr_set_handle

                                            ocfs2_get_acl_nolock
                                              ocfs2_xattr_get_nolock:

processB may get incomplete xattr data if processA hasn't set_acl done.
So we should use 'ip_xattr_sem' to protect getting extended attribute
in ocfs2_get_acl_nolock(), as other processes could be changing it
concurrently.

Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Alex Chen <alex.chen@huawei.com>
---
 fs/ocfs2/acl.c   | 6 ++++++
 fs/ocfs2/xattr.c | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
index 40b5cc9..917fadc 100644
--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -311,7 +311,9 @@ struct posix_acl *ocfs2_iop_get_acl(struct inode *inode, int type)
 	if (had_lock < 0)
 		return ERR_PTR(had_lock);

+	down_read(&OCFS2_I(inode)->ip_xattr_sem);
 	acl = ocfs2_get_acl_nolock(inode, type, di_bh);
+	up_read(&OCFS2_I(inode)->ip_xattr_sem);

 	ocfs2_inode_unlock_tracker(inode, 0, &oh, had_lock);
 	brelse(di_bh);
@@ -330,7 +332,9 @@ int ocfs2_acl_chmod(struct inode *inode, struct buffer_head *bh)
 	if (!(osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL))
 		return 0;

+	down_read(&OCFS2_I(inode)->ip_xattr_sem);
 	acl = ocfs2_get_acl_nolock(inode, ACL_TYPE_ACCESS, bh);
+	up_read(&OCFS2_I(inode)->ip_xattr_sem);
 	if (IS_ERR(acl) || !acl)
 		return PTR_ERR(acl);
 	ret = __posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
@@ -361,8 +365,10 @@ int ocfs2_init_acl(handle_t *handle,

 	if (!S_ISLNK(inode->i_mode)) {
 		if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) {
+			down_read(&OCFS2_I(dir)->ip_xattr_sem);
 			acl = ocfs2_get_acl_nolock(dir, ACL_TYPE_DEFAULT,
 						   dir_bh);
+			up_read(&OCFS2_I(dir)->ip_xattr_sem);
 			if (IS_ERR(acl))
 				return PTR_ERR(acl);
 		}
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 439f567..adeebcb 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -638,9 +638,11 @@ int ocfs2_calc_xattr_init(struct inode *dir,
 						     si->value_len);

 	if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) {
+		down_read(&OCFS2_I(dir)->ip_xattr_sem);
 		acl_len = ocfs2_xattr_get_nolock(dir, dir_bh,
 					OCFS2_XATTR_INDEX_POSIX_ACL_DEFAULT,
 					"", NULL, 0);
+		up_read(&OCFS2_I(dir)->ip_xattr_sem);
 		if (acl_len > 0) {
 			a_size = ocfs2_xattr_entry_real_size(0, acl_len);
 			if (S_ISDIR(mode))
-- 
