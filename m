From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Tue, 10 May 2016 12:53:43 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: fix posix_acl_create deadlock
In-Reply-To: <1462856023-13801-1-git-send-email-junxiao.bi@oracle.com>
References: <1462856023-13801-1-git-send-email-junxiao.bi@oracle.com>
Message-ID: <1462856023-13801-3-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

commit 702e5bc68ad2 ("ocfs2: use generic posix ACL infrastructure")
refactored code to use posix_acl_create. The problem with this function
is that it is not mindful of the cluster wide inode lock making it
unsuitable for use with ocfs2 inode creation with ACLs. For example,
when used in ocfs2_mknod, this function can cause deadlock as follows.
The parent dir inode lock is taken when calling posix_acl_create ->
get_acl -> ocfs2_iop_get_acl which takes the inode lock again. This can
cause deadlock if there is a blocked remote lock request waiting for the
lock to be downconverted. And same deadlock happened in ocfs2_reflink.
This fix is to revert back using ocfs2_init_acl.

Fixes: 702e5bc68ad2 ("ocfs2: use generic posix ACL infrastructure")
Signed-off-by: Tariq Saeed <tariq.x.saeed@oracle.com>
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 fs/ocfs2/acl.c          |   63 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/acl.h          |    4 +++
 fs/ocfs2/namei.c        |   23 ++---------------
 fs/ocfs2/refcounttree.c |   17 ++-----------
 fs/ocfs2/xattr.c        |   14 ++++-------
 fs/ocfs2/xattr.h        |    4 +--
 6 files changed, 77 insertions(+), 48 deletions(-)

diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
index 749d3bc41232..2162434728c0 100644
--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -346,3 +346,66 @@ int ocfs2_acl_chmod(struct inode *inode, struct buffer_head *bh)
 	posix_acl_release(acl);
 	return ret;
 }
+
+/*
+ * Initialize the ACLs of a new inode. If parent directory has default ACL,
+ * then clone to new inode. Called from ocfs2_mknod.
+ */
+int ocfs2_init_acl(handle_t *handle,
+		   struct inode *inode,
+		   struct inode *dir,
+		   struct buffer_head *di_bh,
+		   struct buffer_head *dir_bh,
+		   struct ocfs2_alloc_context *meta_ac,
+		   struct ocfs2_alloc_context *data_ac)
+{
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct posix_acl *acl = NULL;
+	int ret = 0, ret2;
+	umode_t mode;
+
+	if (!S_ISLNK(inode->i_mode)) {
+		if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) {
+			acl = ocfs2_get_acl_nolock(dir, ACL_TYPE_DEFAULT,
+						   dir_bh);
+			if (IS_ERR(acl))
+				return PTR_ERR(acl);
+		}
+		if (!acl) {
+			mode = inode->i_mode & ~current_umask();
+			ret = ocfs2_acl_set_mode(inode, di_bh, handle, mode);
+			if (ret) {
+				mlog_errno(ret);
+				goto cleanup;
+			}
+		}
+	}
+	if ((osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) && acl) {
+		if (S_ISDIR(inode->i_mode)) {
+			ret = ocfs2_set_acl(handle, inode, di_bh,
+					    ACL_TYPE_DEFAULT, acl,
+					    meta_ac, data_ac);
+			if (ret)
+				goto cleanup;
+		}
+		mode = inode->i_mode;
+		ret = __posix_acl_create(&acl, GFP_NOFS, &mode);
+		if (ret < 0)
+			return ret;
+
+		ret2 = ocfs2_acl_set_mode(inode, di_bh, handle, mode);
+		if (ret2) {
+			mlog_errno(ret2);
+			ret = ret2;
+			goto cleanup;
+		}
+		if (ret > 0) {
+			ret = ocfs2_set_acl(handle, inode,
+					    di_bh, ACL_TYPE_ACCESS,
+					    acl, meta_ac, data_ac);
+		}
+	}
+cleanup:
+	posix_acl_release(acl);
+	return ret;
+}
diff --git a/fs/ocfs2/acl.h b/fs/ocfs2/acl.h
index 035e5878db06..2783a75b3999 100644
--- a/fs/ocfs2/acl.h
+++ b/fs/ocfs2/acl.h
@@ -36,5 +36,9 @@ int ocfs2_set_acl(handle_t *handle,
 			 struct ocfs2_alloc_context *meta_ac,
 			 struct ocfs2_alloc_context *data_ac);
 extern int ocfs2_acl_chmod(struct inode *, struct buffer_head *);
+extern int ocfs2_init_acl(handle_t *, struct inode *, struct inode *,
+			  struct buffer_head *, struct buffer_head *,
+			  struct ocfs2_alloc_context *,
+			  struct ocfs2_alloc_context *);
 
 #endif /* OCFS2_ACL_H */
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 6b3e87189a64..a8f1225e6d9b 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -259,7 +259,6 @@ static int ocfs2_mknod(struct inode *dir,
 	struct ocfs2_dir_lookup_result lookup = { NULL, };
 	sigset_t oldset;
 	int did_block_signals = 0;
-	struct posix_acl *default_acl = NULL, *acl = NULL;
 	struct ocfs2_dentry_lock *dl = NULL;
 
 	trace_ocfs2_mknod(dir, dentry, dentry->d_name.len, dentry->d_name.name,
@@ -367,12 +366,6 @@ static int ocfs2_mknod(struct inode *dir,
 		goto leave;
 	}
 
-	status = posix_acl_create(dir, &inode->i_mode, &default_acl, &acl);
-	if (status) {
-		mlog_errno(status);
-		goto leave;
-	}
-
 	handle = ocfs2_start_trans(osb, ocfs2_mknod_credits(osb->sb,
 							    S_ISDIR(mode),
 							    xattr_credits));
@@ -421,16 +414,8 @@ static int ocfs2_mknod(struct inode *dir,
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
@@ -472,10 +457,6 @@ static int ocfs2_mknod(struct inode *dir,
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
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 744d5d90c363..92bbe93bfe10 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -4248,20 +4248,12 @@ static int ocfs2_reflink(struct dentry *old_dentry, struct inode *dir,
 	struct inode *inode = d_inode(old_dentry);
 	struct buffer_head *old_bh = NULL;
 	struct inode *new_orphan_inode = NULL;
-	struct posix_acl *default_acl, *acl;
-	umode_t mode;
 
 	if (!ocfs2_refcount_tree(OCFS2_SB(inode->i_sb)))
 		return -EOPNOTSUPP;
 
-	mode = inode->i_mode;
-	error = posix_acl_create(dir, &mode, &default_acl, &acl);
-	if (error) {
-		mlog_errno(error);
-		return error;
-	}
 
-	error = ocfs2_create_inode_in_orphan(dir, mode,
+	error = ocfs2_create_inode_in_orphan(dir, inode->i_mode,
 					     &new_orphan_inode);
 	if (error) {
 		mlog_errno(error);
@@ -4300,16 +4292,11 @@ static int ocfs2_reflink(struct dentry *old_dentry, struct inode *dir,
 	/* If the security isn't preserved, we need to re-initialize them. */
 	if (!preserve) {
 		error = ocfs2_init_security_and_acl(dir, new_orphan_inode,
-						    &new_dentry->d_name,
-						    default_acl, acl);
+						    &new_dentry->d_name);
 		if (error)
 			mlog_errno(error);
 	}
 out:
-	if (default_acl)
-		posix_acl_release(default_acl);
-	if (acl)
-		posix_acl_release(acl);
 	if (!error) {
 		error = ocfs2_mv_orphaned_inode_to_new(dir, new_orphan_inode,
 						       new_dentry);
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 72eef4cfe8a9..ad16995c9e7a 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -7216,12 +7216,10 @@ out:
  */
 int ocfs2_init_security_and_acl(struct inode *dir,
 				struct inode *inode,
-				const struct qstr *qstr,
-				struct posix_acl *default_acl,
-				struct posix_acl *acl)
+				const struct qstr *qstr)
 {
-	struct buffer_head *dir_bh = NULL;
 	int ret = 0;
+	struct buffer_head *dir_bh = NULL;
 
 	ret = ocfs2_init_security_get(inode, dir, qstr, NULL);
 	if (ret) {
@@ -7234,11 +7232,9 @@ int ocfs2_init_security_and_acl(struct inode *dir,
 		mlog_errno(ret);
 		goto leave;
 	}
-
-	if (!ret && default_acl)
-		ret = ocfs2_iop_set_acl(inode, default_acl, ACL_TYPE_DEFAULT);
-	if (!ret && acl)
-		ret = ocfs2_iop_set_acl(inode, acl, ACL_TYPE_ACCESS);
+	ret = ocfs2_init_acl(NULL, inode, dir, NULL, dir_bh, NULL, NULL);
+	if (ret)
+		mlog_errno(ret);
 
 	ocfs2_inode_unlock(dir, 0);
 	brelse(dir_bh);
diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
index f10d5b93c366..1633cc15ea1f 100644
--- a/fs/ocfs2/xattr.h
+++ b/fs/ocfs2/xattr.h
@@ -94,7 +94,5 @@ int ocfs2_reflink_xattrs(struct inode *old_inode,
 			 bool preserve_security);
 int ocfs2_init_security_and_acl(struct inode *dir,
 				struct inode *inode,
-				const struct qstr *qstr,
-				struct posix_acl *default_acl,
-				struct posix_acl *acl);
+				const struct qstr *qstr);
 #endif /* OCFS2_XATTR_H */
-- 
1.7.9.5
