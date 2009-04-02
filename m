From: Tao Ma <tao.ma@oracle.com>
Date: Fri,  3 Apr 2009 07:45:59 +0800
Subject: [Ocfs2-devel] [PATCH 20/42] ocfs2: Add ioctl for reflink.
In-Reply-To: <49D5CAC2.4010201@oracle.com>
References: <49D5CAC2.4010201@oracle.com>
Message-ID: <1238715981-21488-20-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The ioctl will take 2 parameters: old_path and new_path and
works like link.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/ioctl.c        |   12 ++++
 fs/ocfs2/ocfs2_fs.h     |    8 +++
 fs/ocfs2/refcounttree.c |  147 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/refcounttree.h |    3 +
 4 files changed, 170 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index 9fcd36d..4f189b7 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -22,6 +22,7 @@
 #include "ocfs2_fs.h"
 #include "ioctl.h"
 #include "resize.h"
+#include "refcounttree.h"
 
 #include <linux/ext2_fs.h>
 
@@ -116,6 +117,8 @@ long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	int status;
 	struct ocfs2_space_resv sr;
 	struct ocfs2_new_group_input input;
+	struct reflink_arguments args;
+	const char *old_path, *new_path;
 
 	switch (cmd) {
 	case OCFS2_IOC_GETFLAGS:
@@ -161,6 +164,14 @@ long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			return -EFAULT;
 
 		return ocfs2_group_add(inode, &input);
+	case OCFS2_IOC_REFLINK:
+		if (copy_from_user(&args, (struct reflink_arguments *)arg,
+				   sizeof(args)))
+			return -EFAULT;
+		old_path = (const char *)(unsigned long)args.old_path;
+		new_path = (const char *)(unsigned long)args.new_path;
+
+		return ocfs2_reflink(inode, old_path, new_path);
 	default:
 		return -ENOTTY;
 	}
@@ -183,6 +194,7 @@ long ocfs2_compat_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	case OCFS2_IOC_GROUP_EXTEND:
 	case OCFS2_IOC_GROUP_ADD:
 	case OCFS2_IOC_GROUP_ADD64:
+	case OCFS2_IOC_REFLINK:
 		break;
 	default:
 		return -ENOIOCTLCMD;
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index b3e7bfd..fa550b8 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -297,6 +297,14 @@ struct ocfs2_new_group_input {
 #define OCFS2_IOC_GROUP_ADD	_IOW('o', 2,struct ocfs2_new_group_input)
 #define OCFS2_IOC_GROUP_ADD64	_IOW('o', 3,struct ocfs2_new_group_input)
 
+/* Used to pass 2 file names to reflink. */
+struct reflink_arguments {
+	__u64 old_path;
+	__u64 new_path;
+};
+#define OCFS2_IOC_REFLINK	_IOW('o', 4, struct reflink_arguments)
+
+
 /*
  * Journal Flags (ocfs2_dinode.id1.journal1.i_flags)
  */
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 7b8ffca..ed9e449 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -33,6 +33,11 @@
 #include "aops.h"
 #include "namei.h"
 
+#include <linux/security.h>
+#include <linux/quotaops.h>
+#include <linux/namei.h>
+#include <linux/mount.h>
+
 struct ocfs2_cow_context {
 	struct inode *inode;
 	struct ocfs2_extent_tree di_et;
@@ -1874,3 +1879,145 @@ out:
 
 	return ret;
 }
+
+/* copied from may_create in VFS. */
+static inline int ocfs2_may_create(struct inode *dir, struct dentry *child)
+{
+	if (child->d_inode)
+		return -EEXIST;
+	if (IS_DEADDIR(dir))
+		return -ENOENT;
+	return inode_permission(dir, MAY_WRITE | MAY_EXEC);
+}
+
+/* Most codes are copied from vfs_link. */
+static int ocfs2_vfs_reflink(struct dentry *old_dentry,
+			     struct inode *dir,
+			     struct dentry *new_dentry)
+{
+	struct buffer_head *old_bh = NULL;
+	struct inode *inode = old_dentry->d_inode;
+	int error;
+
+	if (!inode)
+		return -ENOENT;
+
+	error = ocfs2_may_create(dir, new_dentry);
+	if (error)
+		return error;
+
+	if (dir->i_sb != inode->i_sb)
+		return -EXDEV;
+
+	/*
+	 * A link to an append-only or immutable file cannot be created.
+	 */
+	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
+		return -EPERM;
+	if (S_ISDIR(inode->i_mode))
+		return -EPERM;
+
+	if (!OCFS2_I(inode)->ip_clusters) {
+		mlog(ML_ERROR, "reflink doesn't work with 0 cluster files.\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&inode->i_mutex);
+	error = ocfs2_inode_lock(inode, &old_bh, 1);
+	if (error) {
+		mlog_errno(error);
+		goto out_unlock;
+	}
+
+	down_write(&OCFS2_I(inode)->ip_alloc_sem);
+	DQUOT_INIT(dir);
+	error = __ocfs2_reflink(old_dentry, old_bh, dir, new_dentry);
+	up_write(&OCFS2_I(inode)->ip_alloc_sem);
+
+	ocfs2_inode_unlock(inode, 1);
+	brelse(old_bh);
+out_unlock:
+	mutex_unlock(&inode->i_mutex);
+
+	return error;
+}
+
+/* copied from user_path_parent. */
+static int ocfs2_user_path_parent(const char __user *path,
+				  struct nameidata *nd, char **name)
+{
+	char *s = getname(path);
+	int error;
+
+	if (IS_ERR(s))
+		return PTR_ERR(s);
+
+	error = path_lookup(s, LOOKUP_PARENT, nd);
+	if (error)
+		putname(s);
+	else
+		*name = s;
+
+	return error;
+}
+
+/*
+ * Most codes are copied from sys_linkat.
+ */
+int ocfs2_reflink(struct inode *inode,
+		  const char __user *oldname,
+		  const char __user *newname)
+{
+	struct dentry *new_dentry;
+	struct nameidata nd;
+	struct path old_path;
+	int error;
+	char *to = NULL;
+
+	if (!ocfs2_refcount_tree(OCFS2_SB(inode->i_sb)))
+		return -EOPNOTSUPP;
+
+	error = user_path_at(AT_FDCWD, oldname, 0, &old_path);
+	if (error) {
+		mlog_errno(error);
+		return error;
+	}
+
+	error = ocfs2_user_path_parent(newname, &nd, &to);
+	if (error) {
+		mlog_errno(error);
+		goto out;
+	}
+
+	error = -EXDEV;
+	if (old_path.mnt != nd.path.mnt)
+		goto out_release;
+	new_dentry = lookup_create(&nd, 0);
+	error = PTR_ERR(new_dentry);
+	if (IS_ERR(new_dentry)) {
+		mlog_errno(error);
+		goto out_unlock;
+	}
+
+	error = mnt_want_write(nd.path.mnt);
+	if (error) {
+		mlog_errno(error);
+		goto out_dput;
+	}
+
+	error = ocfs2_vfs_reflink(old_path.dentry,
+				  nd.path.dentry->d_inode,
+				  new_dentry);
+	mnt_drop_write(nd.path.mnt);
+out_dput:
+	dput(new_dentry);
+out_unlock:
+	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
+out_release:
+	path_put(&nd.path);
+	putname(to);
+out:
+	path_put(&old_path);
+
+	return error;
+}
diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
index b01a50e..790f918 100644
--- a/fs/ocfs2/refcounttree.h
+++ b/fs/ocfs2/refcounttree.h
@@ -34,4 +34,7 @@ int ocfs2_prepare_refcount_change_for_del(struct inode *inode,
 					  struct ocfs2_alloc_context **meta_ac);
 int ocfs2_refcount_cow(struct inode *inode, struct buffer_head *di_bh,
 		       u32 cpos, u32 write_len);
+int ocfs2_reflink(struct inode *inode,
+		  const char __user *oldname,
+		  const char __user *newname);
 #endif /* OCFS2_REFCOUNTTREE_H */
-- 
1.6.2.rc2.16.gf474c
