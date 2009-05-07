From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 7 May 2009 15:15:36 -0700
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v2.
In-Reply-To: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
Message-ID: <20090507221535.GA31624@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: mtk.manpages@gmail.com, linux-security-module@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

Hi again,
	Here's version 2 of reflink.  Changes since the first version:

- One patch, not three.
- Documentation/filesystems/reflink.txt is no longer a pseudo-manpage.
  It also tries to encapsulate all the feedback from the discussion to
  make the operation clearer.
- LSM hooks added as recommended by the LSM folks.  This includes the
  default implementation in capability.c.
- Restricted reflink to owner or CAP_CHOWN.
- reflink(2) removed, only reflinkat(2) will be in the syscall table.
  Userspace can trivially write reflink(3).

	The patch still only defines sys_reflinkat() for x86_32.  The
final version will have all architectures.  The patch is also available
in my ocfs2 tree:

  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git reflink

	If you want to play with reflinks, here's what you need:

1) Tao's kernel code.  This is the ioctl-based ocfs2 implementation.
   Obviously we'll be putting it under the syscall shortly.  Compile and
   install as you'd expect.  It's in the 'refcount' branch of his git
   tree:

  git://oss.oracle.com/git/tma/linux-2.6.git refcount

2) My code for ocfs2-tools.  This is the mkfs.ocfs2(8) support to create
   a filesystem ready for reflink.  It's in the 'refcount' branch of the
   ocfs2-tools git tree:

  git://oss.oracle.com/git/ocfs2-tools.git refcount

   Once the branck is checked out, you can build and install it with:

  # ./autogen.sh; make; make install

   Create a non-clustered ocfs2 filesystem like so:

  # mkfs.ocfs2 -M local --fs-features=refcount /dev/XXX

   If you really want a clustered ocfs2, go right ahead, but I figure
   most people that want to play with reflinks want the quickest start
   possible, and a non-clustered ocfs2 means mkfs+mount just like any
   other local filesystem.

3) The reflink(1) program.  Grab the master branch from the reflink git
   tree:

  git://oss.oracle.com/git/jlbec/reflink.git master

   Type 'make' and 'make install' in the toplevel directory.  You now
   have the reflink(1) program.  It works with both the system call and
   the ocfs2 ioctl, so you can use it atop the current ocfs2 patch set.

4) Have fun!
 
Joel

From 3130be9651832cece277d30182a04274798ce7f2 Mon Sep 17 00:00:00 2001
From: Joel Becker <joel.becker@oracle.com>
Date: Sat, 2 May 2009 22:48:59 -0700
Subject: [PATCH] fs: Add the reflink() operation and reflinkat(2) system call.

The userpace visible idea of the operation is:

int reflink(const char *oldpath, const char *newpath);
int reflinkat(int olddirfd, const char *oldpath,
	      int newdirfd, const char *newpath, int flags);

The kernel only implements reflinkat(2).  reflink(3) is a trivial
wrapper around reflinkat(2).

The reflink() system call creates reference-counted links.  It creates
a new file that shares the data extents of the source file in a
copy-on-write fashion.  Its calling semantics are identical to link(2)
and linkat(2).  Once complete, programs see the new file as a completely
separate entry.

In the VFS, ->reflink() is an inode_operation with the same arguments as
->link().

reflink() requires the caller to own the source file or have CAP_CHOWN,
because a reflink preserves ownership, permissions, and security
contexts.  Without the priviledges, a regular user can't preserve
ownership.

Two new LSM hooks are added, security_path_reflink() and
security_inode_reflink().  None of the existing LSM hooks appear to
fit.

XXX: Currently only adds the x86_32 linkage.  The rest of the
architectures belong here too.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 Documentation/filesystems/reflink.txt |  152 +++++++++++++++++++++++++++++++++
 Documentation/filesystems/vfs.txt     |    4 +
 arch/x86/include/asm/unistd_32.h      |    1 +
 arch/x86/kernel/syscall_table_32.S    |    1 +
 fs/namei.c                            |  101 ++++++++++++++++++++++
 include/linux/fs.h                    |    2 +
 include/linux/security.h              |   38 ++++++++
 include/linux/syscalls.h              |    2 +
 security/capability.c                 |   13 +++
 security/security.c                   |   15 +++
 10 files changed, 329 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/filesystems/reflink.txt

diff --git a/Documentation/filesystems/reflink.txt b/Documentation/filesystems/reflink.txt
new file mode 100644
index 0000000..58a6b38
--- /dev/null
+++ b/Documentation/filesystems/reflink.txt
@@ -0,0 +1,152 @@
+reflink(2)
+==========
+
+
+INTRODUCTION
+------------
+
+A reflink is a reference-counted link.  The reflink(2) operation is
+analogous to the link(2) operation, except that instead of two directory
+entries pointing to the same inode, there are two identical inodes
+pointing to the same data.  Writes do not modify the shared data; they
+use copy-on-write (CoW).  Thus, after the reflink has been created, the
+inodes can diverge without impacting each other.
+
+
+SYNOPSIS
+--------
+
+The reflink(2) call looks just like link(2):
+
+    int reflink(const char *oldpath, const char *newpath);
+
+The actual system call is reflinkat(2):
+
+    int reflinkat(int olddirfd, const char *oldpath,
+                  int newdirfd, const char *newpath, int flags);
+
+For details on how olddirfd, newdirfd, and flags behave, see linkat(2).
+The reflink(2) call won't be implemented by the kernel, because it's a
+trivial wrapper around reflinkat(2).
+
+
+DESCRIPTION
+-----------
+
+One way of viewing reflink is to look at the level of sharing.  A
+symbolic link does its sharing at the directory entry level; many names
+end up pointing at the same directory entry.  Hard links are one step
+down.  Multiple directory entries are sharing one inode.  Reflinks are
+down one more level: multiple inodes share the same data extents.
+
+When you symlink a file, you can then access it via the symlink or the
+real directory entry, and for the most part they look identical.  When
+accessing more than one name for a hard link, the object returned looks
+identical.  Similarly, a newly created reflink is identical to its
+source in almost every way and can be treated as such.  This includes
+ownership, permissions, security context, and data.  The only things
+that are different are the inode number, the link count, and the ctime.
+
+A reflink is a snapshot of the source file at the time it is created.
+
+Once created, though, a reflink can be modified like any other normal
+file without affecting the source file.  Changes to trivial fields like
+permissions, owner, or times are guaranteed not to trigger CoW of file
+data and will not return any error that wouldn't happen on a truly
+distinct file.  Changes to the file's data will trigger CoW of the data
+affected - the actual CoW granularity is up to the filesystem, from
+exact bytes up to the entire file.  ocfs2, for example, will copy out an
+entire extent or 1MB, whichever is smaller.
+
+Partial reflinks are not allowed.  The new inode will only appear in the
+directory structure after it is fully formed.  This prevents a crash or
+lack of space from creating a partial reflink.
+
+If a filesystem does not support reflinks, the kernel and libc MUST NOT
+fake it.  Callers are expecting to get snapshots, and faking it will
+violate that trust.
+
+The userspace view is as follows.  When reflink(2) returns, opening
+oldpath and newpath returns identical-looking files, just like link(2).
+After that, oldpath and newpath behave as distinct files, and
+modifications to one have no impact on the other.
+
+
+RESTRICTIONS
+------------
+
+Just as the sharing gets lower as you move from symlink() -> link() ->
+reflink(), the restrictions on the call get tighter.  A symlink doesn't
+require any access permissions other than being able to create its
+inode.  It can cross filesystems and mount points, and it can point to
+any type of file.  A hard link requires both source and target to be on
+the same filesystem under the same mount point, and that the source not
+be a directory.   Like hard links and symlinks, a reflink cannot be
+created if newpath exists.
+
+Reflinks adds one big restriction on top of hard links: only the owner
+or someone with elevated privileges (CAP_CHOWN) can reflink a file.  A
+reflink is a point-in-time snapshot of a file.  It has the same
+ownership, attributes, and security context as the source file.  A
+regular user cannot change the ownership of files, so they cannot create
+a reflink of a file they do not own.
+
+
+SHARING
+-------
+
+A reflink creates a new inode.  It shares all data extents of the source
+file; this includes file data and extended attribute data.  All of the
+sharing is in a CoW fashion, and any modification of the data will break
+the sharing.
+
+For some filesystems, certain data structures are not in allocated
+storage extents.  Creating a reflink might make a copy of these extents.
+An example is ext3's ability to store small extended attributes inside
+the ext3 inode.  Since a reflink is creating a new inode, those extended
+attributes are merely copied to the new inode.
+
+
+EXCEPTIONS
+----------
+
+All file attributes and extended attributes of the new file must
+identical to the source file with the following exceptions:
+
+- The new file must have a new inode number.  This allows POSIX
+  programs to treat the source and new files as separate objects.  From
+  the view of the POSIX application, the files are distinct.  The
+  sharing is invisible outside of the filesystem's internal structures.
+- The ctime of the source file only changes if the source's metadata
+  must be changed to accommodate the copy-on-write linkage.  The ctime
+  of the new file is set to represent its creation.
+- The link count of the source file is unchanged, and the link count of
+  the new file is one.
+
+The mtime of the source file is unmodified, and the mtime of the new
+file is set identical to the source file.  This reflects that the data
+is unchanged.
+
+
+INODE OPERATION
+---------------
+
+Filesystems implement the ->reflink() inode operation.  It has the same
+prototype as ->link():
+
+    int (*reflink)(struct dentry *old_dentry, struct inode *dir,
+                   struct dentry *new_dentry);
+
+When the filesystem is called, the VFS has already checked the
+permissions and mountpoint of the operation.  The filesystem just needs
+to create the new inode identical to the old one with the exceptions
+noted above, link up the shared data extents, and then link the new
+inode into dir.
+
+
+FOLLOWING SYMBOLIC LINKS
+------------------------
+
+reflink() deferences symbolic links in the same manner that link(2)
+does.  The AT_SYMLINK_FOLLOW flag is honored just as for linkat(2).
+
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index f49eecf..01cd810 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -333,6 +333,7 @@ struct inode_operations {
 	ssize_t (*listxattr) (struct dentry *, char *, size_t);
 	int (*removexattr) (struct dentry *, const char *);
 	void (*truncate_range)(struct inode *, loff_t, loff_t);
+	int (*reflink) (struct dentry *,struct inode *,struct dentry *);
 };
 
 Again, all methods are called without any locks being held, unless
@@ -431,6 +432,9 @@ otherwise noted.
 
   truncate_range: a method provided by the underlying filesystem to truncate a
   	range of blocks , i.e. punch a hole somewhere in a file.
+  reflink: called by the reflink(2) system call. Only required if you want
+	to support reflinks.  For further information, see
+	Documentation/filesystems/reflink.txt.
 
 
 The Address Space Object
diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
index 6e72d74..c368563 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -340,6 +340,7 @@
 #define __NR_inotify_init1	332
 #define __NR_preadv		333
 #define __NR_pwritev		334
+#define __NR_reflinkat		335
 
 #ifdef __KERNEL__
 
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index ff5c873..d11c200 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -334,3 +334,4 @@ ENTRY(sys_call_table)
 	.long sys_inotify_init1
 	.long sys_preadv
 	.long sys_pwritev
+	.long sys_reflinkat		/* 335 */
diff --git a/fs/namei.c b/fs/namei.c
index 78f253c..3f80c2f 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2486,6 +2486,106 @@ SYSCALL_DEFINE2(link, const char __user *, oldname, const char __user *, newname
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
+	/*
+	 * reflink() preserves ownership, so the caller must have the
+	 * right to do so.
+	 */
+	if ((current_fsuid() != inode->i_uid) && !capable(CAP_CHOWN))
+		return -EPERM;
+
+	if ((current_fsuid() != inode->i_uid) &&
+	    !in_group_p(inode->i_gid) && !capable(CAP_CHOWN))
+		return -EPERM;
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
+	error = security_inode_reflink(old_dentry, dir, new_dentry);
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
+	error = security_path_reflink(old_path.dentry, &nd.path, new_dentry);
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
+
 /*
  * The worst of all namespace operations - renaming directory. "Perverted"
  * doesn't even start to describe it. Somebody in UCB had a heck of a trip...
@@ -2890,6 +2990,7 @@ EXPORT_SYMBOL(unlock_rename);
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
diff --git a/include/linux/security.h b/include/linux/security.h
index d5fd616..c647761 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -528,6 +528,23 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	@inode contains a pointer to the inode.
  *	@secid contains a pointer to the location where result will be saved.
  *	In case of failure, @secid will be set to zero.
+ * @inode_reflink:
+ *	Check permission before creating a new reference-counted link to
+ *	a file.
+ *	@old_dentry contains the dentry structure for an existing link to
+ *	the file.
+ *	@dir contains the inode structure of the parent directory of the
+ *	new reflink.
+ *	Return 0 if permission is granted.
+ * @path_reflink:
+ *	Check permission before creating a new reference-counted link to
+ *	a file.
+ *	@old_dentry contains the dentry structure for an existing link
+ *	to the file.
+ *	@new_dir contains the path structure of the parent directory of
+ *	the new reflink.
+ *	@new_dentry contains the dentry structure for the new reflink.
+ *	Return 0 if permission is granted.
  *
  * Security hooks for file operations
  *
@@ -1402,6 +1419,8 @@ struct security_operations {
 			  struct dentry *new_dentry);
 	int (*path_rename) (struct path *old_dir, struct dentry *old_dentry,
 			    struct path *new_dir, struct dentry *new_dentry);
+	int (*path_reflink) (struct dentry *old_dentry, struct path *new_dir,
+			     struct dentry *new_dentry);
 #endif
 
 	int (*inode_alloc_security) (struct inode *inode);
@@ -1415,6 +1434,7 @@ struct security_operations {
 	int (*inode_unlink) (struct inode *dir, struct dentry *dentry);
 	int (*inode_symlink) (struct inode *dir,
 			      struct dentry *dentry, const char *old_name);
+	int (*inode_reflink) (struct dentry *old_dentry, struct inode *dir);
 	int (*inode_mkdir) (struct inode *dir, struct dentry *dentry, int mode);
 	int (*inode_rmdir) (struct inode *dir, struct dentry *dentry);
 	int (*inode_mknod) (struct inode *dir, struct dentry *dentry,
@@ -1675,6 +1695,8 @@ int security_inode_link(struct dentry *old_dentry, struct inode *dir,
 int security_inode_unlink(struct inode *dir, struct dentry *dentry);
 int security_inode_symlink(struct inode *dir, struct dentry *dentry,
 			   const char *old_name);
+int security_inode_reflink(struct dentry *old_dentry, struct inode *dir,
+			   struct dentry *new_dentry);
 int security_inode_mkdir(struct inode *dir, struct dentry *dentry, int mode);
 int security_inode_rmdir(struct inode *dir, struct dentry *dentry);
 int security_inode_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev);
@@ -2056,6 +2078,13 @@ static inline int security_inode_symlink(struct inode *dir,
 	return 0;
 }
 
+static inline int security_inode_reflink(struct dentry *old_dentry,
+					 struct inode *dir,
+					 struct dentry *new_dentry)
+{
+	return 0;
+}
+
 static inline int security_inode_mkdir(struct inode *dir,
 					struct dentry *dentry,
 					int mode)
@@ -2802,6 +2831,8 @@ int security_path_link(struct dentry *old_dentry, struct path *new_dir,
 		       struct dentry *new_dentry);
 int security_path_rename(struct path *old_dir, struct dentry *old_dentry,
 			 struct path *new_dir, struct dentry *new_dentry);
+int security_path_reflink(struct dentry *old_dentry, struct path *new_dir,
+			  struct dentry *new_dentry);
 #else	/* CONFIG_SECURITY_PATH */
 static inline int security_path_unlink(struct path *dir, struct dentry *dentry)
 {
@@ -2851,6 +2882,13 @@ static inline int security_path_rename(struct path *old_dir,
 {
 	return 0;
 }
+
+static inline int security_path_reflink(struct dentry *old_dentry,
+					struct path *new_dir,
+					struct dentry *new_dentry)
+{
+	return 0;
+}
 #endif	/* CONFIG_SECURITY_PATH */
 
 #ifdef CONFIG_KEYS
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 40617c1..35a8743 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -692,6 +692,8 @@ asmlinkage long sys_symlinkat(const char __user * oldname,
 			      int newdfd, const char __user * newname);
 asmlinkage long sys_linkat(int olddfd, const char __user *oldname,
 			   int newdfd, const char __user *newname, int flags);
+asmlinkage long sys_reflinkat(int olddfd, const char __user *oldname,
+			      int newdfd, const char __user *newname, int flags);
 asmlinkage long sys_renameat(int olddfd, const char __user * oldname,
 			     int newdfd, const char __user * newname);
 asmlinkage long sys_futimesat(int dfd, char __user *filename,
diff --git a/security/capability.c b/security/capability.c
index 21b6cea..60c6eda 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -172,6 +172,11 @@ static int cap_inode_symlink(struct inode *inode, struct dentry *dentry,
 	return 0;
 }
 
+static int cap_inode_reflink(struct dentry *old_dentry, struct inode *inode)
+{
+	return 0;
+}
+
 static int cap_inode_mkdir(struct inode *inode, struct dentry *dentry,
 			   int mask)
 {
@@ -308,6 +313,12 @@ static int cap_path_truncate(struct path *path, loff_t length,
 {
 	return 0;
 }
+
+static int cap_path_reflink(struct dentry *old_dentry, struct path *new_dir,
+			    struct dentry *new_dentry)
+{
+	return 0;
+}
 #endif
 
 static int cap_file_permission(struct file *file, int mask)
@@ -905,6 +916,7 @@ void security_fixup_ops(struct security_operations *ops)
 	set_to_cap_if_null(ops, inode_link);
 	set_to_cap_if_null(ops, inode_unlink);
 	set_to_cap_if_null(ops, inode_symlink);
+	set_to_cap_if_null(ops, inode_reflink);
 	set_to_cap_if_null(ops, inode_mkdir);
 	set_to_cap_if_null(ops, inode_rmdir);
 	set_to_cap_if_null(ops, inode_mknod);
@@ -935,6 +947,7 @@ void security_fixup_ops(struct security_operations *ops)
 	set_to_cap_if_null(ops, path_link);
 	set_to_cap_if_null(ops, path_rename);
 	set_to_cap_if_null(ops, path_truncate);
+	set_to_cap_if_null(ops, path_reflink);
 #endif
 	set_to_cap_if_null(ops, file_permission);
 	set_to_cap_if_null(ops, file_alloc_security);
diff --git a/security/security.c b/security/security.c
index 5284255..fc40a29 100644
--- a/security/security.c
+++ b/security/security.c
@@ -437,6 +437,14 @@ int security_path_truncate(struct path *path, loff_t length,
 		return 0;
 	return security_ops->path_truncate(path, length, time_attrs);
 }
+
+int security_path_reflink(struct dentry *old_dentry, struct path *new_dir,
+			  struct dentry *new_dentry)
+{
+	if (unlikely(IS_PRIVATE(old_dentry->d_inode)))
+		return 0;
+	return security_ops->path_reflink(old_dentry, new_dir, new_dentry);
+}
 #endif
 
 int security_inode_create(struct inode *dir, struct dentry *dentry, int mode)
@@ -470,6 +478,13 @@ int security_inode_symlink(struct inode *dir, struct dentry *dentry,
 	return security_ops->inode_symlink(dir, dentry, old_name);
 }
 
+int security_inode_reflink(struct dentry *old_dentry, struct inode *dir)
+{
+	if (unlikely(IS_PRIVATE(old_dentry->d_inode)))
+		return 0;
+	return security_ops->inode_reflink(old_dentry, dir);
+}
+
 int security_inode_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 {
 	if (unlikely(IS_PRIVATE(dir)))
-- 
1.6.1.3

-- 

"Sometimes I think the surest sign intelligent
 life exists elsewhere in the universe is that
 none of it has tried to contact us."
                                -Calvin & Hobbes

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
