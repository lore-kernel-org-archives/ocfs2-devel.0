From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 27 May 2009 17:24:26 -0700
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v5.
In-Reply-To: <20090511204011.GB30293@mail.oracle.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<20090507221535.GA31624@mail.oracle.com> <4A039FF8.7090807@hp.com>
	<20090508031018.GB8611@mail.oracle.com>
	<20090511204011.GB30293@mail.oracle.com>
Message-ID: <20090528002426.GE12914@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

	Here's v5 of reflink().  It adds a 'preserve' argument to the
call.  This argument may currently be one of REFLINK_ATTR_PRESERVE and
REFLINK_ATTR_NONE.  _ATTR_PRESERVE takes a full snapshot, and fails if
the caller lacks the privileges.  _ATTR_NONE links up the data extents
(data and xattrs) in a CoW fashion, but otherwise initializes the new
inode as a new file (new security state, acls, ownership, etc).  I took
everyone's advice and dropped attribute-specific flags for a single
_ATTR_PRESERVE.
	Inside the kernel, the iop and security op get 'bool preserve'
to tell them what to do.

Joel

From d3c4ed0cb3f5af75f2adf92346e7a3f23870cd16 Mon Sep 17 00:00:00 2001
From: Joel Becker <joel.becker@oracle.com>
Date: Sat, 2 May 2009 22:48:59 -0700
Subject: [PATCH] fs: Add the reflink() operation and reflinkat(2) system call.

The userpace visible idea of the operation is:

int reflink(const char *oldpath, const char *newpath, int preserve);
int reflinkat(int olddirfd, const char *oldpath,
	      int newdirfd, const char *newpath,
	      int preserve,  int flags);

The kernel only implements reflinkat(2).  reflink(3) is a trivial
wrapper around reflinkat(2).

The reflink() system call creates reference-counted links.  It creates
a new file that shares the data extents of the source file in a
copy-on-write fashion.  Its calling semantics are identical to link(2)
and linkat(2).  Once complete, programs see the new file as a completely
separate entry.

reflink() attempts to preserve ownership, permissions, and all other
security state in order to create a full snapshot.  A caller requests
this by passing REFLINK_ATTR_PRESERVE as the 'preserve' argument.
Preserving those attributes requires ownership or CAP_CHOWN.  A caller
without those privileges will get EPERM.  An unpriviledged caller can
specify REFLINK_ATTR_NONE.  They will acquire the data extent sharing
but will see the file's security state and attributes initialized as a
new file.  The unpriviledged reflink requires read access.

In the VFS, ->reflink() is an inode_operation with the almost same
arguments as ->link(); an additional argument tells the filesystem to
copy over or reinitialize the security state on the new file.

A new LSM hook, security_inode_reflink(), is added.  None of the
existing LSM hooks appeared to fit.

This only adds the x86 linkage.  The trend appears to be for other
architectures to add their own linkage.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 Documentation/filesystems/reflink.txt |  174 +++++++++++++++++++++++++++++++++
 Documentation/filesystems/vfs.txt     |    4 +
 arch/x86/ia32/ia32entry.S             |    1 +
 arch/x86/include/asm/unistd_32.h      |    1 +
 arch/x86/include/asm/unistd_64.h      |    2 +
 arch/x86/kernel/syscall_table_32.S    |    1 +
 fs/namei.c                            |  124 +++++++++++++++++++++++
 include/linux/fcntl.h                 |    8 ++
 include/linux/fs.h                    |    2 +
 include/linux/security.h              |   23 +++++
 include/linux/syscalls.h              |    3 +
 security/capability.c                 |    7 ++
 security/security.c                   |    8 ++
 13 files changed, 358 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/filesystems/reflink.txt

diff --git a/Documentation/filesystems/reflink.txt b/Documentation/filesystems/reflink.txt
new file mode 100644
index 0000000..7effe33
--- /dev/null
+++ b/Documentation/filesystems/reflink.txt
@@ -0,0 +1,174 @@
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
+The reflink(2) call looks almost like link(2):
+
+    int reflink(const char *oldpath, const char *newpath, int preserve);
+
+The actual system call is reflinkat(2):
+
+    int reflinkat(int olddirfd, const char *oldpath,
+                  int newdirfd, const char *newpath,
+                  int preserve, int flags);
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
+ownership, permissions, security state, and data.  The only things
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
+Preserving the security state of the source file obviously requires
+the privilege to do so.  Because of this, the reflink(2) call has the
+preserve argument.  If it is set to REFLINK_ATTR_PRESERVE, the security
+state and file attributes will match the source as described above.
+Callers that do not own the source file and do not have CAP_CHOWN will
+see reflink(2) fail with EPERM.  If preserve is set to
+REFLINK_ATTR_NONE, the new reflink will still share all the data extents
+of the source file, including extended attributes.  The security state
+and attributes of the new reflink will be as a newly created file by
+that user.  With REFLINK_ATTR_NONE, the caller must have read access to
+the source file.
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
+be a directory.  A reflink tightens that to regular files only.  Like
+hard links and symlinks, a reflink cannot be created if newpath exists.
+
+Reflinks adds one big restriction on top of hard links: only the owner
+or someone with elevated privileges (CAP_CHOWN) can preserve the
+security state (permissions, ownership, ACLs, etc) across a reflink.
+A reflink is a point-in-time snapshot of a file.  Without the
+appropriate privilege, the caller specifying REFLINK_ATTR_PRESERVE
+will receive EPERM.
+
+A caller specifying REFLINK_ATTR_NONE must have read access to reflink a
+file.
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
+When REFLINK_ATTR_PRESERVE is specified, all file attributes and
+extended attributes of the new file must identical to the source file
+with the following exceptions:
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
+If REFLINK_ATTR_NONE is specified, all data extents will be reflinked,
+but file attributes and security state will be as any new file.
+
+
+INODE OPERATION
+---------------
+
+Filesystems implement the ->reflink() inode operation.  It has almost
+the same prototype as ->link():
+
+    int (*reflink)(struct dentry *old_dentry, struct inode *dir,
+                   struct dentry *new_dentry, bool preserve);
+
+When the filesystem is called, the VFS has already checked the
+permissions and mountpoint of the operation.  It has determined whether
+the file attributes and security state should be preserved or
+reinitialized, as specified by the preserve argument.  The filesystem
+just needs to create the new inode identical to the old one with the
+exceptions noted above, link up the shared data extents, and then link
+the new inode into dir.
+
+
+FOLLOWING SYMBOLIC LINKS
+------------------------
+
+reflink() deferences symbolic links in the same manner that link(2)
+does.  The AT_SYMLINK_FOLLOW flag is honored just as for linkat(2).
+
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index f49eecf..0620d73 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -333,6 +333,7 @@ struct inode_operations {
 	ssize_t (*listxattr) (struct dentry *, char *, size_t);
 	int (*removexattr) (struct dentry *, const char *);
 	void (*truncate_range)(struct inode *, loff_t, loff_t);
+	int (*reflink) (struct dentry *,struct inode *,struct dentry *,bool);
 };
 
 Again, all methods are called without any locks being held, unless
@@ -431,6 +432,9 @@ otherwise noted.
 
   truncate_range: a method provided by the underlying filesystem to truncate a
   	range of blocks , i.e. punch a hole somewhere in a file.
+  reflink: called by the reflink(2) system call. Only required if you want
+	to support reflinks.  For further information, see
+	Documentation/filesystems/reflink.txt.
 
 
 The Address Space Object
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index a505202..ca832b4 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -830,4 +830,5 @@ ia32_sys_call_table:
 	.quad sys_inotify_init1
 	.quad compat_sys_preadv
 	.quad compat_sys_pwritev
+	.quad sys_reflinkat		/* 335 */
 ia32_syscall_end:
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
 
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index f818294..b20f68c 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -657,6 +657,8 @@ __SYSCALL(__NR_inotify_init1, sys_inotify_init1)
 __SYSCALL(__NR_preadv, sys_preadv)
 #define __NR_pwritev				296
 __SYSCALL(__NR_pwritev, sys_pwritev)
+#define __NR_reflink				297
+__SYSCALL(__NR_reflink, sys_reflink)
 
 
 #ifndef __NO_STUBS
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
index 78f253c..55f5c80 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2486,6 +2486,129 @@ SYSCALL_DEFINE2(link, const char __user *, oldname, const char __user *, newname
 	return sys_linkat(AT_FDCWD, oldname, AT_FDCWD, newname, 0);
 }
 
+int vfs_reflink(struct dentry *old_dentry, struct inode *dir,
+		struct dentry *new_dentry, bool preserve)
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
+
+	/*
+	 * Only regular files can be reflinked; if a user tries to
+	 * reflink a block device, do they expect copy-on-write of the
+	 * entire device?
+	 */
+	if (!S_ISREG(inode->i_mode))
+		return -EPERM;
+
+	/*
+	 * If the caller wants to preserve ownership, they require the
+	 * rights to do so.
+	 */
+	if (preserve) {
+		if ((current_fsuid() != inode->i_uid) && !capable(CAP_CHOWN))
+			return -EPERM;
+		if (!in_group_p(inode->i_gid) && !capable(CAP_CHOWN))
+			return -EPERM;
+	}
+
+	error = security_inode_reflink(old_dentry, dir, preserve);
+	if (error)
+		return error;
+
+	/*
+	 * If the caller is modifying any aspect of the attributes, they
+	 * are not creating a snapshot.  They need read permission on the
+	 * file.
+	 */
+	if (!preserve) {
+		error = inode_permission(inode, MAY_READ);
+		if (error)
+			return error;
+	}
+
+	mutex_lock(&inode->i_mutex);
+	vfs_dq_init(dir);
+	error = dir->i_op->reflink(old_dentry, dir, new_dentry, preserve);
+	mutex_unlock(&inode->i_mutex);
+	if (!error)
+		fsnotify_create(dir, new_dentry);
+	return error;
+}
+
+SYSCALL_DEFINE6(reflinkat, int, olddfd, const char __user *, oldname,
+		int, newdfd, const char __user *, newname, int, preserve,
+		int, flags)
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
+	if ((preserve & ~REFLINK_ATTR_PRESERVE) != 0)
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
+	error = security_path_link(old_path.dentry, &nd.path, new_dentry);
+	if (error)
+		goto out_drop_write;
+	error = vfs_reflink(old_path.dentry, nd.path.dentry->d_inode,
+			    new_dentry, preserve);
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
@@ -2890,6 +3013,7 @@ EXPORT_SYMBOL(unlock_rename);
 EXPORT_SYMBOL(vfs_create);
 EXPORT_SYMBOL(vfs_follow_link);
 EXPORT_SYMBOL(vfs_link);
+EXPORT_SYMBOL(vfs_reflink);
 EXPORT_SYMBOL(vfs_mkdir);
 EXPORT_SYMBOL(vfs_mknod);
 EXPORT_SYMBOL(generic_permission);
diff --git a/include/linux/fcntl.h b/include/linux/fcntl.h
index 8603740..96dc2f0 100644
--- a/include/linux/fcntl.h
+++ b/include/linux/fcntl.h
@@ -40,6 +40,14 @@
                                            unlinking file.  */
 #define AT_SYMLINK_FOLLOW	0x400   /* Follow symbolic links.  */
 
+/*
+ * A reflink call may preserve the file's attributes in toto or not at
+ * all.
+ */
+#define REFLINK_ATTR_PRESERVE	0x00000001
+#define REFLINK_ATTR_NONE	0
+
+
 #ifdef __KERNEL__
 
 #ifndef force_o_largefile
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 5bed436..c6f9cb0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1415,6 +1415,7 @@ extern int vfs_link(struct dentry *, struct inode *, struct dentry *);
 extern int vfs_rmdir(struct inode *, struct dentry *);
 extern int vfs_unlink(struct inode *, struct dentry *);
 extern int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
+extern int vfs_reflink(struct dentry *, struct inode *, struct dentry *, bool);
 
 /*
  * VFS dentry helper functions.
@@ -1537,6 +1538,7 @@ struct inode_operations {
 			  loff_t len);
 	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start,
 		      u64 len);
+	int (*reflink) (struct dentry *,struct inode *,struct dentry *,bool);
 };
 
 struct seq_file;
diff --git a/include/linux/security.h b/include/linux/security.h
index d5fd616..2f1f520 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -528,6 +528,18 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
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
+ *	@preserve specifies whether the caller wishes to preserve the
+ *	file's attributes.  If true, the caller wishes to clone the file's
+ *	attributes exactly.  If false, the caller expects to reflink the
+ *	data extents but reset the attributes.
+ *	Return 0 if permission is granted.
  *
  * Security hooks for file operations
  *
@@ -1415,6 +1427,8 @@ struct security_operations {
 	int (*inode_unlink) (struct inode *dir, struct dentry *dentry);
 	int (*inode_symlink) (struct inode *dir,
 			      struct dentry *dentry, const char *old_name);
+	int (*inode_reflink) (struct dentry *old_dentry, struct inode *dir,
+			      bool preserve);
 	int (*inode_mkdir) (struct inode *dir, struct dentry *dentry, int mode);
 	int (*inode_rmdir) (struct inode *dir, struct dentry *dentry);
 	int (*inode_mknod) (struct inode *dir, struct dentry *dentry,
@@ -1675,6 +1689,8 @@ int security_inode_link(struct dentry *old_dentry, struct inode *dir,
 int security_inode_unlink(struct inode *dir, struct dentry *dentry);
 int security_inode_symlink(struct inode *dir, struct dentry *dentry,
 			   const char *old_name);
+int security_inode_reflink(struct dentry *old_dentry, struct inode *dir,
+			   bool preserve);
 int security_inode_mkdir(struct inode *dir, struct dentry *dentry, int mode);
 int security_inode_rmdir(struct inode *dir, struct dentry *dentry);
 int security_inode_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev);
@@ -2056,6 +2072,13 @@ static inline int security_inode_symlink(struct inode *dir,
 	return 0;
 }
 
+static inline int security_inode_reflink(struct dentry *old_dentry,
+					 struct inode *dir,
+					 bool preserve)
+{
+	return 0;
+}
+
 static inline int security_inode_mkdir(struct inode *dir,
 					struct dentry *dentry,
 					int mode)
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 40617c1..a11f228 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -692,6 +692,9 @@ asmlinkage long sys_symlinkat(const char __user * oldname,
 			      int newdfd, const char __user * newname);
 asmlinkage long sys_linkat(int olddfd, const char __user *oldname,
 			   int newdfd, const char __user *newname, int flags);
+asmlinkage long sys_reflinkat(int olddfd, const char __user *oldname,
+			      int newdfd, const char __user *newname,
+			      int preserve, int flags);
 asmlinkage long sys_renameat(int olddfd, const char __user * oldname,
 			     int newdfd, const char __user * newname);
 asmlinkage long sys_futimesat(int dfd, char __user *filename,
diff --git a/security/capability.c b/security/capability.c
index 21b6cea..8047b7c 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -172,6 +172,12 @@ static int cap_inode_symlink(struct inode *inode, struct dentry *dentry,
 	return 0;
 }
 
+static int cap_inode_reflink(struct dentry *old_dentry, struct inode *inode,
+			     bool preserve)
+{
+	return 0;
+}
+
 static int cap_inode_mkdir(struct inode *inode, struct dentry *dentry,
 			   int mask)
 {
@@ -905,6 +911,7 @@ void security_fixup_ops(struct security_operations *ops)
 	set_to_cap_if_null(ops, inode_link);
 	set_to_cap_if_null(ops, inode_unlink);
 	set_to_cap_if_null(ops, inode_symlink);
+	set_to_cap_if_null(ops, inode_reflink);
 	set_to_cap_if_null(ops, inode_mkdir);
 	set_to_cap_if_null(ops, inode_rmdir);
 	set_to_cap_if_null(ops, inode_mknod);
diff --git a/security/security.c b/security/security.c
index 5284255..e2b12f9 100644
--- a/security/security.c
+++ b/security/security.c
@@ -470,6 +470,14 @@ int security_inode_symlink(struct inode *dir, struct dentry *dentry,
 	return security_ops->inode_symlink(dir, dentry, old_name);
 }
 
+int security_inode_reflink(struct dentry *old_dentry, struct inode *dir,
+			   bool preserve)
+{
+	if (unlikely(IS_PRIVATE(old_dentry->d_inode)))
+		return 0;
+	return security_ops->inode_reflink(old_dentry, dir, preserve);
+}
+
 int security_inode_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 {
 	if (unlikely(IS_PRIVATE(dir)))
-- 
1.6.3

-- 

"Anything that is too stupid to be spoken is sung."  
        - Voltaire

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
