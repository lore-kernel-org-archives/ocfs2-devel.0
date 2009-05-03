From: Joel Becker <joel.becker@oracle.com>
Date: Sat,  2 May 2009 23:15:03 -0700
Subject: [Ocfs2-devel] [PATCH 3/3] fs: Add the reflink(2) system call.
In-Reply-To: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1241331303-23753-4-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

This implements reflinkat(2) and reflink(2).  See
Documentation/reflink.txt for a description of the reflink(2) system
call.

XXX: Currently only adds the x86_32 linkage.  The rest of the
architectures belong here too.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 arch/x86/include/asm/unistd_32.h   |    1 +
 arch/x86/kernel/syscall_table_32.S |    1 +
 fs/namei.c                         |   56 ++++++++++++++++++++++++++++++++++++
 3 files changed, 58 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
index 6e72d74..ea8eb94 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -340,6 +340,7 @@
 #define __NR_inotify_init1	332
 #define __NR_preadv		333
 #define __NR_pwritev		334
+#define __NR_reflink		335
 
 #ifdef __KERNEL__
 
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index ff5c873..866705d 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -334,3 +334,4 @@ ENTRY(sys_call_table)
 	.long sys_inotify_init1
 	.long sys_preadv
 	.long sys_pwritev
+	.long sys_reflink		/* 335 */
diff --git a/fs/namei.c b/fs/namei.c
index 45cbe7a..cf739a3 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2524,6 +2524,62 @@ int vfs_reflink(struct dentry *old_dentry, struct inode *dir, struct dentry *new
 	return error;
 }
 
+SYSCALL_DEFINE5(reflinkat, int, olddfd, const char __user *, oldname,
+		int, newdfd, const char __user *, newname, int, flags)
+{
+	struct dentry *new_dentry;
+	struct nameidata nd;
+	struct path old_path;
+	int error;
+	char *to;
+
+	if ((flags & ~AT_SYMLINK_FOLLOW) != 0)
+		return -EINVAL;
+
+	error = user_path_at(olddfd, oldname,
+			     flags & AT_SYMLINK_FOLLOW ? LOOKUP_FOLLOW : 0,
+			     &old_path);
+	if (error)
+		return error;
+
+	error = user_path_parent(newdfd, newname, &nd, &to);
+	if (error)
+		goto out;
+	error = -EXDEV;
+	if (old_path.mnt != nd.path.mnt)
+		goto out_release;
+	new_dentry = lookup_create(&nd, 0);
+	error = PTR_ERR(new_dentry);
+	if (IS_ERR(new_dentry))
+		goto out_unlock;
+	error = mnt_want_write(nd.path.mnt);
+	if (error)
+		goto out_dput;
+	error = security_path_mknod(&nd.path, new_dentry,
+				    old_path.dentry->d_inode->i_mode, 0);
+	if (error)
+		goto out_drop_write;
+	error = vfs_reflink(old_path.dentry, nd.path.dentry->d_inode, new_dentry);
+out_drop_write:
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
+
+SYSCALL_DEFINE2(reflink, const char __user *, oldname, const char __user *, newname)
+{
+	return sys_reflinkat(AT_FDCWD, oldname, AT_FDCWD, newname, 0);
+}
+
 
 /*
  * The worst of all namespace operations - renaming directory. "Perverted"
-- 
1.6.1.3
