From: Tariq Saeed <tariq.x.saeed@oracle.com>
Date: Mon, 11 Jan 2016 17:35:06 -0800
Subject: [Ocfs2-devel] [PATCH 2/2] inode deadlock in ocfs2_mknode due to
	using posix_acl_create
Message-ID: <1452562506-27230-1-git-send-email-tariq.x.saeed@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

commit 702e5bc68ad2 ("ocfs2: use generic posix ACL infrastructure")
refactored code to use posix_acl_create. The problem with this function is
that it is not mindful of the cluster wide inode lock making it unsuitable
for use with ocfs2 inode creation with ACLS. When used in ocfs2_mknod,
this function can cause deadlock as follows.  The parent dir inode lock
is taken when calling posix_acl_create -> get_acl -> ocfs2_iop_get_acl
which takes the inode lock again. This can cause deadlock if there is
a blocked remote lock request waiting for the lock to be downconverted.
This fix we chose is to revert back to ocfs2_init_acl.

Signed-off-by: Tariq Saeed <tariq.x.saeed@oracle.com> Reviewed-by:
---
 fs/ocfs2/namei.c |   23 ++---------------------
 1 files changed, 2 insertions(+), 21 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index b7dfac2..bc9f406 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -261,7 +261,6 @@ static int ocfs2_mknod(struct inode *dir,
 	struct ocfs2_dir_lookup_result lookup = { NULL, };
 	sigset_t oldset;
 	int did_block_signals = 0;
-	struct posix_acl *default_acl = NULL, *acl = NULL;
 	struct ocfs2_dentry_lock *dl = NULL;
 
 	trace_ocfs2_mknod(dir, dentry, dentry->d_name.len, dentry->d_name.name,
@@ -369,12 +368,6 @@ static int ocfs2_mknod(struct inode *dir,
 		goto leave;
 	}
 
-	status = posix_acl_create(dir, &mode, &default_acl, &acl);
-	if (status) {
-		mlog_errno(status);
-		goto leave;
-	}
-
 	handle = ocfs2_start_trans(osb, ocfs2_mknod_credits(osb->sb,
 							    S_ISDIR(mode),
 							    xattr_credits));
@@ -423,16 +416,8 @@ static int ocfs2_mknod(struct inode *dir,
 		inc_nlink(dir);
 	}
 
-	if (default_acl) {
-		status = ocfs2_set_acl(handle, inode, new_fe_bh,
-				       ACL_TYPE_DEFAULT, default_acl,
-				       meta_ac, data_ac);
-	}
-	if (!status && acl) {
-		status = ocfs2_set_acl(handle, inode, new_fe_bh,
-				       ACL_TYPE_ACCESS, acl,
-				       meta_ac, data_ac);
-	}
+	status = ocfs2_init_acl(handle, inode, dir, new_fe_bh, parent_fe_bh,
+			 meta_ac, data_ac);
 
 	if (status < 0) {
 		mlog_errno(status);
@@ -474,10 +459,6 @@ static int ocfs2_mknod(struct inode *dir,
 	d_instantiate(dentry, inode);
 	status = 0;
 leave:
-	if (default_acl)
-		posix_acl_release(default_acl);
-	if (acl)
-		posix_acl_release(acl);
 	if (status < 0 && did_quota_inode)
 		dquot_free_inode(inode);
 	if (handle)
-- 
1.7.1
