From: Joel Becker <joel.becker@oracle.com>
Date: Sat,  2 May 2009 23:15:02 -0700
Subject: [Ocfs2-devel] [PATCH 2/3] fs: Add vfs_reflink() and the ->reflink()
	inode operation.
In-Reply-To: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1241331303-23753-3-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

Implement vfs_reflink(), which calls iops->reflink().  See
Documentation/reflink.txt for a description of the reflink(2) system
call.

I'm not quite certain of the security model to follow.
security_inode_link() is clearly not correct as the resulting file is
not the source inode.  I have chosen security_inode_create() to reflect
the creation of a new file in the directory.  This matches the
fsnotify_create() I've decided to use.  However, it does not reflect
that the new file will have the same contents as the source file.  The
real solution is probably either to check read access on the source or
define a new security_inode_reflink().

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/namei.c         |   40 ++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |    2 ++
 2 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 78f253c..45cbe7a 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2486,6 +2486,45 @@ SYSCALL_DEFINE2(link, const char __user *, oldname, const char __user *, newname
 	return sys_linkat(AT_FDCWD, oldname, AT_FDCWD, newname, 0);
 }
 
+int vfs_reflink(struct dentry *old_dentry, struct inode *dir, struct dentry *new_dentry)
+{
+	struct inode *inode = old_dentry->d_inode;
+	int error;
+
+	if (!inode)
+		return -ENOENT;
+
+	error = may_create(dir, new_dentry);
+	if (error)
+		return error;
+
+	if (dir->i_sb != inode->i_sb)
+		return -EXDEV;
+
+	/*
+	 * A reflink to an append-only or immutable file cannot be created.
+	 */
+	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
+		return -EPERM;
+	if (!dir->i_op->reflink)
+		return -EPERM;
+	if (S_ISDIR(inode->i_mode))
+		return -EPERM;
+
+	error = security_inode_create(dir, new_dentry, inode->i_mode);
+	if (error)
+		return error;
+
+	mutex_lock(&inode->i_mutex);
+	vfs_dq_init(dir);
+	error = dir->i_op->reflink(old_dentry, dir, new_dentry);
+	mutex_unlock(&inode->i_mutex);
+	if (!error)
+		fsnotify_create(dir, new_dentry);
+	return error;
+}
+
+
 /*
  * The worst of all namespace operations - renaming directory. "Perverted"
  * doesn't even start to describe it. Somebody in UCB had a heck of a trip...
@@ -2890,6 +2929,7 @@ EXPORT_SYMBOL(unlock_rename);
 EXPORT_SYMBOL(vfs_create);
 EXPORT_SYMBOL(vfs_follow_link);
 EXPORT_SYMBOL(vfs_link);
+EXPORT_SYMBOL(vfs_reflink);
 EXPORT_SYMBOL(vfs_mkdir);
 EXPORT_SYMBOL(vfs_mknod);
 EXPORT_SYMBOL(generic_permission);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 5bed436..3c9e4ec 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1415,6 +1415,7 @@ extern int vfs_link(struct dentry *, struct inode *, struct dentry *);
 extern int vfs_rmdir(struct inode *, struct dentry *);
 extern int vfs_unlink(struct inode *, struct dentry *);
 extern int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
+extern int vfs_reflink(struct dentry *, struct inode *, struct dentry *);
 
 /*
  * VFS dentry helper functions.
@@ -1537,6 +1538,7 @@ struct inode_operations {
 			  loff_t len);
 	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start,
 		      u64 len);
+	int (*reflink) (struct dentry *,struct inode *,struct dentry *);
 };
 
 struct seq_file;
-- 
1.6.1.3
