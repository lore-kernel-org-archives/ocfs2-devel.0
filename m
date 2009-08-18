From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 18 Aug 2009 14:19:42 +0800
Subject: [Ocfs2-devel] [PATCH 41/41] ocfs2: Add ioctl for reflink.
In-Reply-To: <4A8A47DF.8020707@oracle.com>
References: <4A8A47DF.8020707@oracle.com>
Message-ID: <1250576382-27080-41-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The ioctl will take 3 parameters: old_path, new_path and
preserve and call vfs_reflink. It is useful when we backport
reflink features to old kernels.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/ioctl.c        |   14 ++++++
 fs/ocfs2/ocfs2_fs.h     |    9 ++++
 fs/ocfs2/refcounttree.c |  102 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/refcounttree.h |    4 ++
 4 files changed, 129 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index 9fcd36d..a68d0e4 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -22,6 +22,7 @@
 #include "ocfs2_fs.h"
 #include "ioctl.h"
 #include "resize.h"
+#include "refcounttree.h"
 
 #include <linux/ext2_fs.h>
 
@@ -116,6 +117,9 @@ long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	int status;
 	struct ocfs2_space_resv sr;
 	struct ocfs2_new_group_input input;
+	struct reflink_arguments args;
+	const char *old_path, *new_path;
+	bool preserve;
 
 	switch (cmd) {
 	case OCFS2_IOC_GETFLAGS:
@@ -161,6 +165,15 @@ long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			return -EFAULT;
 
 		return ocfs2_group_add(inode, &input);
+	case OCFS2_IOC_REFLINK:
+		if (copy_from_user(&args, (struct reflink_arguments *)arg,
+				   sizeof(args)))
+			return -EFAULT;
+		old_path = (const char *)(unsigned long)args.old_path;
+		new_path = (const char *)(unsigned long)args.new_path;
+		preserve = (args.preserve != 0);
+
+		return ocfs2_reflink_ioctl(inode, old_path, new_path, preserve);
 	default:
 		return -ENOTTY;
 	}
@@ -183,6 +196,7 @@ long ocfs2_compat_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	case OCFS2_IOC_GROUP_EXTEND:
 	case OCFS2_IOC_GROUP_ADD:
 	case OCFS2_IOC_GROUP_ADD64:
+	case OCFS2_IOC_REFLINK:
 		break;
 	default:
 		return -ENOIOCTLCMD;
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 4a4565b..e9431e4 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -301,6 +301,15 @@ struct ocfs2_new_group_input {
 #define OCFS2_IOC_GROUP_ADD	_IOW('o', 2,struct ocfs2_new_group_input)
 #define OCFS2_IOC_GROUP_ADD64	_IOW('o', 3,struct ocfs2_new_group_input)
 
+/* Used to pass 2 file names to reflink. */
+struct reflink_arguments {
+	__u64 old_path;
+	__u64 new_path;
+	__u64 preserve;
+};
+#define OCFS2_IOC_REFLINK	_IOW('o', 4, struct reflink_arguments)
+
+
 /*
  * Journal Flags (ocfs2_dinode.id1.journal1.i_flags)
  */
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 711d5b0..d59860d 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -42,6 +42,11 @@
 #include <linux/writeback.h>
 #include <linux/pagevec.h>
 #include <linux/swap.h>
+#include <linux/security.h>
+#include <linux/fsnotify.h>
+#include <linux/quotaops.h>
+#include <linux/namei.h>
+#include <linux/mount.h>
 
 struct ocfs2_cow_context {
 	struct inode *inode;
@@ -4002,3 +4007,100 @@ out:
 
 	return error;
 }
+
+/*
+ * Below here are the bits used by OCFS2_IOC_REFLINK() to fake
+ * sys_reflink().  This will go away when vfs_reflink() exists in
+ * fs/namei.c.
+ */
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
+int ocfs2_reflink_ioctl(struct inode *inode,
+			const char __user *oldname,
+			const char __user *newname,
+			bool preserve)
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
+	error = vfs_reflink(old_path.dentry,
+			    nd.path.dentry->d_inode,
+			    new_dentry, preserve);
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
index 89d55ef..4bdf45a 100644
--- a/fs/ocfs2/refcounttree.h
+++ b/fs/ocfs2/refcounttree.h
@@ -101,4 +101,8 @@ int ocfs2_increase_refcount(handle_t *handle,
 			    struct ocfs2_cached_dealloc_ctxt *dealloc);
 int ocfs2_reflink(struct dentry *old_dentry, struct inode *dir,
 		  struct dentry *new_dentry, bool preserve);
+int ocfs2_reflink_ioctl(struct inode *inode,
+			const char __user *oldname,
+			const char __user *newname,
+			bool preserve);
 #endif /* OCFS2_REFCOUNTTREE_H */
-- 
1.6.2.rc2.16.gf474c
