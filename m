From: Eric Ren <zren@suse.com>
Date: Tue, 17 Jan 2017 14:30:54 +0800
Subject: [Ocfs2-devel] [PATCH v3 2/2] ocfs2: fix deadlock issue when taking
	inode lock at vfs entry points
In-Reply-To: <20170117063054.30519-1-zren@suse.com>
References: <20170117063054.30519-1-zren@suse.com>
Message-ID: <20170117063054.30519-3-zren@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com
Cc: akpm@linux-foundation.org, mfasheh@versity.com, jlbec@evilplan.org, ghe@suse.com, junxiao.bi@oracle.com, jiangqi903@gmail.com, sfr@canb.auug.org.au, hch@lst.de, linux-kernel@vger.kernel.org

Commit 743b5f1434f5 ("ocfs2: take inode lock in ocfs2_iop_set/get_acl()")
results in a deadlock, as the author "Tariq Saeed" realized shortly
after the patch was merged. The discussion happened here
(https://oss.oracle.com/pipermail/ocfs2-devel/2015-September/011085.html).

The reason why taking cluster inode lock at vfs entry points opens up
a self deadlock window, is explained in the previous patch of this
series.

So far, we have seen two different code paths that have this issue.
1. do_sys_open
     may_open
      inode_permission
       ocfs2_permission
        ocfs2_inode_lock() <=== take PR
         generic_permission
          get_acl
           ocfs2_iop_get_acl
            ocfs2_inode_lock() <=== take PR
2. fchmod|fchmodat
    chmod_common
     notify_change
      ocfs2_setattr <=== take EX
       posix_acl_chmod
        get_acl
         ocfs2_iop_get_acl <=== take PR
        ocfs2_iop_set_acl <=== take EX

Fixes them by adding the tracking logic (in the previous patch) for
these funcs above, ocfs2_permission(), ocfs2_iop_[set|get]_acl(),
ocfs2_setattr().

Changes since v1:
- Let ocfs2_is_locked_by_me() just return true/false to indicate if the
process gets the cluster lock - suggested by: Joseph Qi <jiangqi903@gmail.com>
and Junxiao Bi <junxiao.bi@oracle.com>.

- Change "struct ocfs2_holder" to a more meaningful name "ocfs2_lock_holder",
suggested by: Junxiao Bi.

- Add debugging output at ocfs2_setattr() and ocfs2_permission() to
catch exceptional cases, suggested by: Junxiao Bi.

Changes since v2:
- Use new wrappers of tracking logic code, suggested by: Junxiao Bi.

Signed-off-by: Eric Ren <zren@suse.com>
---
 fs/ocfs2/acl.c  | 29 +++++++++++++----------------
 fs/ocfs2/file.c | 58 ++++++++++++++++++++++++++++++++++++++++++++-------------
 2 files changed, 58 insertions(+), 29 deletions(-)

diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
index bed1fcb..dc22ba8 100644
--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -283,16 +283,14 @@ int ocfs2_set_acl(handle_t *handle,
 int ocfs2_iop_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 {
 	struct buffer_head *bh = NULL;
-	int status = 0;
+	int status, had_lock;
+	struct ocfs2_lock_holder oh;
 
-	status = ocfs2_inode_lock(inode, &bh, 1);
-	if (status < 0) {
-		if (status != -ENOENT)
-			mlog_errno(status);
-		return status;
-	}
+	had_lock = ocfs2_inode_lock_tracker(inode, &bh, 1, &oh);
+	if (had_lock < 0)
+		return had_lock;
 	status = ocfs2_set_acl(NULL, inode, bh, type, acl, NULL, NULL);
-	ocfs2_inode_unlock(inode, 1);
+	ocfs2_inode_unlock_tracker(inode, 1, &oh, had_lock);
 	brelse(bh);
 	return status;
 }
@@ -302,21 +300,20 @@ struct posix_acl *ocfs2_iop_get_acl(struct inode *inode, int type)
 	struct ocfs2_super *osb;
 	struct buffer_head *di_bh = NULL;
 	struct posix_acl *acl;
-	int ret;
+	int had_lock;
+	struct ocfs2_lock_holder oh;
 
 	osb = OCFS2_SB(inode->i_sb);
 	if (!(osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL))
 		return NULL;
-	ret = ocfs2_inode_lock(inode, &di_bh, 0);
-	if (ret < 0) {
-		if (ret != -ENOENT)
-			mlog_errno(ret);
-		return ERR_PTR(ret);
-	}
+
+	had_lock = ocfs2_inode_lock_tracker(inode, &di_bh, 0, &oh);
+	if (had_lock < 0)
+		return ERR_PTR(had_lock);
 
 	acl = ocfs2_get_acl_nolock(inode, type, di_bh);
 
-	ocfs2_inode_unlock(inode, 0);
+	ocfs2_inode_unlock_tracker(inode, 0, &oh, had_lock);
 	brelse(di_bh);
 	return acl;
 }
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index c488965..7b6a146 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1138,6 +1138,8 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 	handle_t *handle = NULL;
 	struct dquot *transfer_to[MAXQUOTAS] = { };
 	int qtype;
+	int had_lock;
+	struct ocfs2_lock_holder oh;
 
 	trace_ocfs2_setattr(inode, dentry,
 			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
@@ -1173,11 +1175,30 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 		}
 	}
 
-	status = ocfs2_inode_lock(inode, &bh, 1);
-	if (status < 0) {
-		if (status != -ENOENT)
-			mlog_errno(status);
+	had_lock = ocfs2_inode_lock_tracker(inode, &bh, 1, &oh);
+	if (had_lock < 0) {
+		status = had_lock;
 		goto bail_unlock_rw;
+	} else if (had_lock) {
+		/*
+		 * As far as we know, ocfs2_setattr() could only be the first
+		 * VFS entry point in the call chain of recursive cluster
+		 * locking issue.
+		 *
+		 * For instance:
+		 * chmod_common()
+		 *  notify_change()
+		 *   ocfs2_setattr()
+		 *    posix_acl_chmod()
+		 *     ocfs2_iop_get_acl()
+		 *
+		 * But, we're not 100% sure if it's always true, because the
+		 * ordering of the VFS entry points in the call chain is out
+		 * of our control. So, we'd better dump the stack here to
+		 * catch the other cases of recursive locking.
+		 */
+		mlog(ML_ERROR, "Another case of recursive locking:\n");
+		dump_stack();
 	}
 	inode_locked = 1;
 
@@ -1260,8 +1281,8 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 bail_commit:
 	ocfs2_commit_trans(osb, handle);
 bail_unlock:
-	if (status) {
-		ocfs2_inode_unlock(inode, 1);
+	if (status && inode_locked) {
+		ocfs2_inode_unlock_tracker(inode, 1, &oh, had_lock);
 		inode_locked = 0;
 	}
 bail_unlock_rw:
@@ -1279,7 +1300,7 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 			mlog_errno(status);
 	}
 	if (inode_locked)
-		ocfs2_inode_unlock(inode, 1);
+		ocfs2_inode_unlock_tracker(inode, 1, &oh, had_lock);
 
 	brelse(bh);
 	return status;
@@ -1320,21 +1341,32 @@ int ocfs2_getattr(struct vfsmount *mnt,
 
 int ocfs2_permission(struct inode *inode, int mask)
 {
-	int ret;
+	int ret, had_lock;
+	struct ocfs2_lock_holder oh;
 
 	if (mask & MAY_NOT_BLOCK)
 		return -ECHILD;
 
-	ret = ocfs2_inode_lock(inode, NULL, 0);
-	if (ret) {
-		if (ret != -ENOENT)
-			mlog_errno(ret);
+	had_lock = ocfs2_inode_lock_tracker(inode, NULL, 0, &oh);
+	if (had_lock < 0) {
+		ret = had_lock;
 		goto out;
+	} else if (had_lock) {
+		/* See comments in ocfs2_setattr() for details.
+		 * The call chain of this case could be:
+		 * do_sys_open()
+		 *  may_open()
+		 *   inode_permission()
+		 *    ocfs2_permission()
+		 *     ocfs2_iop_get_acl()
+		 */
+		mlog(ML_ERROR, "Another case of recursive locking:\n");
+		dump_stack();
 	}
 
 	ret = generic_permission(inode, mask);
 
-	ocfs2_inode_unlock(inode, 0);
+	ocfs2_inode_unlock_tracker(inode, 0, &oh, had_lock);
 out:
 	return ret;
 }
-- 
2.10.2
