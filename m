From: Mihail Daskalov <mdaskalov@technologica.com>
Date: Mon, 25 May 2009 10:44:11 +0300
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v4. - Question
	for suitability
In-Reply-To: <20090511204011.GB30293@mail.oracle.com>
Message-ID: <15F26D0D9E18E24583D912511D668FF8026E0568@exchange.ad.tlogica.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel,
I would like to ask additional question on the reflink semantics. What I
want to know is what will be the behaviour if you have a file with
pending modifications, and you do a reflink to it. Will the reflink call
be atomic in terms of snapshoting ?

The context I am asking this is the following:
Suppose that we have an Oracle database running in a file system that
supports reflink.
Will it be possible and safe to use reflink for backup purposes ? e.g. 
   1) execute "alter tablespace XXX begin backup" sql command
   2) do a reflink of all datafiles to datafiles.reflinked (e.g. for X
in (datafiles) do ; reflink X X.reflinked ; done ).
   3) execute "alter tablespace XXX end backup"
   4) backup the datafiles.reflinked with some tool
?

I understand that Oracle datafile hot backup will not be affected even
if part of the pending notifications are accepted to the file, and some
are not - this is the way oracle hot backup is designed to work - so
this is not a really good example, but it probably illustrates what I
mean. There might be other cases that need some stability for the file.

Other related issues is which process would get an error if there is
insufficient space to store data for two different snapshots - will that
be the writer to the original file, or the reader of the snapshot? I
guess the writer will get ENOSPACE. But I ask this question anyway...
Will this be configurable (e.g. through some attribute - e.g.
GUARANTEE_SPACE_FOR_ORIGINAL_FILE, or ALLOW_ERRORS_READING_SNAPSHOT) ?

Regards,

Mihail Daskalov

-----Original Message-----
From: ocfs2-devel-bounces@oss.oracle.com
[mailto:ocfs2-devel-bounces at oss.oracle.com] On Behalf Of Joel Becker
Sent: Monday, May 11, 2009 11:40 PM
To: jim owens; jmorris at namei.org; ocfs2-devel at oss.oracle.com;
viro at zeniv.linux.org.uk; mtk.manpages at gmail.com;
linux-security-module at vger.kernel.org; linux-fsdevel at vger.kernel.org
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v4.


On Thu, May 07, 2009 at 08:10:18PM -0700, Joel Becker wrote:
> On Thu, May 07, 2009 at 10:59:04PM -0400, jim owens wrote:
> > You certainly did not address:
> >
> > - desire for one single system call to handle both
> >   owner preservation and create with current owner.
> 
> 	Nope, and I don't intend to.  reflink() is a snapshotting call,
> not a kitchen sink.

	I've been thinking about this all weekend.  The current state
doesn't make me happy.
	Now, what concerns me here is the interface to userspace.  The
system call itself.  I don't care if we implement it via one vfs_foo()
or 10 nor how many iops we end up with.  We can and will modify those as
we find better ideas.  But I want reflink(2) to have a semantic that is
easily understood and intuitive.
	When I initially designed reflink(), I hadn't thought about the
ownership and permission implications of snapshotting.  I was having too
much fun reflinking files around.  In that iteration, anyone could
reflink a file.  But a true snapshot needs ownership, permissions, acls,
and other security attributes (in all, I'm gonna call that the "security
context") as well.  So I defined reflink() as such.  This meant
requiring privileges, but lost some of the flexibility of the call.  I
call that a loss.
	What I'm not going to do is add optional behaviors to the system
call.  It should be pretty obvious what it does, or we're doing it
wrong.  The 'flags' field of reflinkat(2) is for AT_* flags.
	When I decided on requiring privileges, I thought that degrading
without privileges was too confusing.  I was wrong.  I want reflink() to
fit into the pantheon of file system operations in a way that makes
sense alongside the others, and this isn't it.
	Here's v4 of reflink().  If you have the privileges, you get the
full snapshot.  If you don't, you must have read access, and then you
get the entire snapshot (data and extended attributes) except that the
security context is reinitialized.  That's it.  It fits with most of the
other ops, and it's a clean degradation.
	I add a flag to ips->reflink() so that the filesystem knows what
to do with the security context.  That's the only change visible outside
of vfs_reflink().
	Security folks, check my work.  Everyone else, let me know if
this satisfies.

Joel

From 1ebf4c2cf36d38b22de025b03753497466e18941 Mon Sep 17 00:00:00 2001
From: Joel Becker <joel.becker@oracle.com>
Date: Sat, 2 May 2009 22:48:59 -0700
Subject: [PATCH] fs: Add the reflink() operation and reflinkat(2) system
call.

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

reflink() attempts to preserve ownership, permissions, and security
contexts in order to create a fully snapshot.  Preserving those
attributes requires ownership or CAP_CHOWN.  A caller without those
privileges will see the security context of the new file initialized to
their default.

In the VFS, ->reflink() is an inode_operation with the almost same
arguments as ->link(); an additional argument tells the filesystem to
copy over or reinitialize the security context on the new file.

A new LSM hook, security_inode_reflink(), is added.  None of the
existing LSM hooks appeared to fit.

XXX: Currently only adds the x86_32 linkage.  The rest of the
architectures belong here too.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 Documentation/filesystems/reflink.txt |  165
+++++++++++++++++++++++++++++++++
 Documentation/filesystems/vfs.txt     |    4 +
 arch/x86/include/asm/unistd_32.h      |    1 +
 arch/x86/kernel/syscall_table_32.S    |    1 +
 fs/namei.c                            |  113 ++++++++++++++++++++++
 include/linux/fs.h                    |    2 +
 include/linux/security.h              |   16 +++
 include/linux/syscalls.h              |    2 +
 security/capability.c                 |    6 +
 security/security.c                   |    7 ++
 10 files changed, 317 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/filesystems/reflink.txt

diff --git a/Documentation/filesystems/reflink.txt
b/Documentation/filesystems/reflink.txt
new file mode 100644
index 0000000..aa7380f
--- /dev/null
+++ b/Documentation/filesystems/reflink.txt
@@ -0,0 +1,165 @@
+reflink(2)
+==========
+
+
+INTRODUCTION
+------------
+
+A reflink is a reference-counted link.  The reflink(2) operation is
+analogous to the link(2) operation, except that instead of two
directory
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
+exact bytes up to the entire file.  ocfs2, for example, will copy out
an
+entire extent or 1MB, whichever is smaller.
+
+Preserving the security context of the source file obviously requires
+the privilege to do so.  Callers that do not own the source file and do
+not have CAP_CHOWN will get a new reflink with all non-security
+attributes preserved; the security context of the new reflink will be
+as a newly created file by that user.
+
+Partial reflinks are not allowed.  The new inode will only appear in
the
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
+or someone with elevated privileges (CAP_CHOWN) can preserve the
+security context (permissions, ownership, ACLs, etc) across a reflink.
+A reflink is a point-in-time snapshot of a file.  Without the
+appropriate privilege, the caller will see their own default security
+context applied to the file.
+
+A caller without the privileges to preserve the security context must
+have read access to reflink a file.
+
+
+SHARING
+-------
+
+A reflink creates a new inode.  It shares all data extents of the
source
+file; this includes file data and extended attribute data.  All of the
+sharing is in a CoW fashion, and any modification of the data will
break
+the sharing.
+
+For some filesystems, certain data structures are not in allocated
+storage extents.  Creating a reflink might make a copy of these
extents.
+An example is ext3's ability to store small extended attributes inside
+the ext3 inode.  Since a reflink is creating a new inode, those
extended
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
+- If the caller lacks the privileges to preserve the security context,
+  the file will have its security context initialized as would any new
+  file.
+
+The mtime of the source file is unmodified, and the mtime of the new
+file is set identical to the source file.  This reflects that the data
+is unchanged.
+
+
+INODE OPERATION
+---------------
+
+Filesystems implement the ->reflink() inode operation.  It has almost
+the same prototype as ->link():
+
+    int (*reflink)(struct dentry *old_dentry, struct inode *dir,
+                   struct dentry *new_dentry, int preserve_security);
+
+When the filesystem is called, the VFS has already checked the
+permissions and mountpoint of the operation.  It has determined whether
+the security context should be preserved or reinitialized, as specified
+by the preserve_security argument.  The filesystem just needs to create
+the new inode identical to the old one with the exceptions noted above,
+link up the shared data extents, and then link the new inode into dir.
+
+
+FOLLOWING SYMBOLIC LINKS
+------------------------
+
+reflink() deferences symbolic links in the same manner that link(2)
+does.  The AT_SYMLINK_FOLLOW flag is honored just as for linkat(2).
+
diff --git a/Documentation/filesystems/vfs.txt
b/Documentation/filesystems/vfs.txt
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
 
   truncate_range: a method provided by the underlying filesystem to
truncate a
   	range of blocks , i.e. punch a hole somewhere in a file.
+  reflink: called by the reflink(2) system call. Only required if you
want
+	to support reflinks.  For further information, see
+	Documentation/filesystems/reflink.txt.
 
 
 The Address Space Object
diff --git a/arch/x86/include/asm/unistd_32.h
b/arch/x86/include/asm/unistd_32.h
index 6e72d74..c368563 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -340,6 +340,7 @@
 #define __NR_inotify_init1	332
 #define __NR_preadv		333
 #define __NR_pwritev		334
+#define __NR_reflinkat		335
 
 #ifdef __KERNEL__
 
diff --git a/arch/x86/kernel/syscall_table_32.S
b/arch/x86/kernel/syscall_table_32.S
index ff5c873..d11c200 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -334,3 +334,4 @@ ENTRY(sys_call_table)
 	.long sys_inotify_init1
 	.long sys_preadv
 	.long sys_pwritev
+	.long sys_reflinkat		/* 335 */
diff --git a/fs/namei.c b/fs/namei.c
index 78f253c..34a6ce5 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2486,6 +2486,118 @@ SYSCALL_DEFINE2(link, const char __user *,
oldname, const char __user *, newname
 	return sys_linkat(AT_FDCWD, oldname, AT_FDCWD, newname, 0);
 }
 
+int vfs_reflink(struct dentry *old_dentry, struct inode *dir, struct
dentry *new_dentry)
+{
+	struct inode *inode = old_dentry->d_inode;
+	int error;
+	int preserve_security = 1;
+
+	if (!inode)
+		return -ENOENT;
+
+	/*
+	 * If the caller has the rights, reflink() will preserve the
+	 * security context of the source inode.
+	 */
+	if ((current_fsuid() != inode->i_uid) && !capable(CAP_CHOWN))
+		preserve_security = 0;
+	if ((current_fsuid() != inode->i_uid) &&
+	    !in_group_p(inode->i_gid) && !capable(CAP_CHOWN))
+		preserve_security = 0;
+
+	/*
+	 * If the caller doesn't have the right to preserve the security
+	 * context, the caller is only getting the data and extended
+	 * attributes.  They need read permission on the file.
+	 */
+	if (!preserve_security) {
+		error = inode_permission(inode, MAY_READ);
+		if (error)
+			return error;
+	}
+
+	error = may_create(dir, new_dentry);
+	if (error)
+		return error;
+
+	if (dir->i_sb != inode->i_sb)
+		return -EXDEV;
+
+	/*
+	 * A reflink to an append-only or immutable file cannot be
created.
+	 */
+	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
+		return -EPERM;
+	if (!dir->i_op->reflink)
+		return -EPERM;
+	if (S_ISDIR(inode->i_mode))
+		return -EPERM;
+
+	error = security_inode_reflink(old_dentry, dir);
+	if (error)
+		return error;
+
+	mutex_lock(&inode->i_mutex);
+	vfs_dq_init(dir);
+	error = dir->i_op->reflink(old_dentry, dir, new_dentry,
+				   preserve_security);
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
+			     flags & AT_SYMLINK_FOLLOW ? LOOKUP_FOLLOW :
0,
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
+	error = security_path_link(old_path.dentry, &nd.path,
new_dentry);
+	if (error)
+		goto out_drop_write;
+	error = vfs_reflink(old_path.dentry, nd.path.dentry->d_inode,
new_dentry);
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
  * The worst of all namespace operations - renaming directory.
"Perverted"
  * doesn't even start to describe it. Somebody in UCB had a heck of a
trip...
@@ -2890,6 +3002,7 @@ EXPORT_SYMBOL(unlock_rename);
 EXPORT_SYMBOL(vfs_create);
 EXPORT_SYMBOL(vfs_follow_link);
 EXPORT_SYMBOL(vfs_link);
+EXPORT_SYMBOL(vfs_reflink);
 EXPORT_SYMBOL(vfs_mkdir);
 EXPORT_SYMBOL(vfs_mknod);
 EXPORT_SYMBOL(generic_permission);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 5bed436..0a5c807 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1415,6 +1415,7 @@ extern int vfs_link(struct dentry *, struct inode
*, struct dentry *);
 extern int vfs_rmdir(struct inode *, struct dentry *);
 extern int vfs_unlink(struct inode *, struct dentry *);
 extern int vfs_rename(struct inode *, struct dentry *, struct inode *,
struct dentry *);
+extern int vfs_reflink(struct dentry *, struct inode *, struct dentry
*);
 
 /*
  * VFS dentry helper functions.
@@ -1537,6 +1538,7 @@ struct inode_operations {
 			  loff_t len);
 	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64
start,
 		      u64 len);
+	int (*reflink) (struct dentry *,struct inode *,struct dentry
*,int);
 };
 
 struct seq_file;
diff --git a/include/linux/security.h b/include/linux/security.h
index d5fd616..ea9cd93 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -528,6 +528,14 @@ static inline void security_free_mnt_opts(struct
security_mnt_opts *opts)
  *	@inode contains a pointer to the inode.
  *	@secid contains a pointer to the location where result will be
saved.
  *	In case of failure, @secid will be set to zero.
+ * @inode_reflink:
+ *	Check permission before creating a new reference-counted link to
+ *	a file.
+ *	@old_dentry contains the dentry structure for an existing link
to
+ *	the file.
+ *	@dir contains the inode structure of the parent directory of the
+ *	new reflink.
+ *	Return 0 if permission is granted.
  *
  * Security hooks for file operations
  *
@@ -1415,6 +1423,7 @@ struct security_operations {
 	int (*inode_unlink) (struct inode *dir, struct dentry *dentry);
 	int (*inode_symlink) (struct inode *dir,
 			      struct dentry *dentry, const char
*old_name);
+	int (*inode_reflink) (struct dentry *old_dentry, struct inode
*dir);
 	int (*inode_mkdir) (struct inode *dir, struct dentry *dentry,
int mode);
 	int (*inode_rmdir) (struct inode *dir, struct dentry *dentry);
 	int (*inode_mknod) (struct inode *dir, struct dentry *dentry,
@@ -1675,6 +1684,7 @@ int security_inode_link(struct dentry *old_dentry,
struct inode *dir,
 int security_inode_unlink(struct inode *dir, struct dentry *dentry);
 int security_inode_symlink(struct inode *dir, struct dentry *dentry,
 			   const char *old_name);
+int security_inode_reflink(struct dentry *old_dentry, struct inode
*dir);
 int security_inode_mkdir(struct inode *dir, struct dentry *dentry, int
mode);
 int security_inode_rmdir(struct inode *dir, struct dentry *dentry);
 int security_inode_mknod(struct inode *dir, struct dentry *dentry, int
mode, dev_t dev);
@@ -2056,6 +2066,12 @@ static inline int security_inode_symlink(struct
inode *dir,
 	return 0;
 }
 
+static inline int security_inode_reflink(struct dentry *old_dentry,
+					 struct inode *dir)
+{
+	return 0;
+}
+
 static inline int security_inode_mkdir(struct inode *dir,
 					struct dentry *dentry,
 					int mode)
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 40617c1..35a8743 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -692,6 +692,8 @@ asmlinkage long sys_symlinkat(const char __user *
oldname,
 			      int newdfd, const char __user * newname);
 asmlinkage long sys_linkat(int olddfd, const char __user *oldname,
 			   int newdfd, const char __user *newname, int
flags);
+asmlinkage long sys_reflinkat(int olddfd, const char __user *oldname,
+			      int newdfd, const char __user *newname,
int flags);
 asmlinkage long sys_renameat(int olddfd, const char __user * oldname,
 			     int newdfd, const char __user * newname);
 asmlinkage long sys_futimesat(int dfd, char __user *filename,
diff --git a/security/capability.c b/security/capability.c
index 21b6cea..3dcc4cc 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -172,6 +172,11 @@ static int cap_inode_symlink(struct inode *inode,
struct dentry *dentry,
 	return 0;
 }
 
+static int cap_inode_reflink(struct dentry *old_dentry, struct inode
*inode)
+{
+	return 0;
+}
+
 static int cap_inode_mkdir(struct inode *inode, struct dentry *dentry,
 			   int mask)
 {
@@ -905,6 +910,7 @@ void security_fixup_ops(struct security_operations
*ops)
 	set_to_cap_if_null(ops, inode_link);
 	set_to_cap_if_null(ops, inode_unlink);
 	set_to_cap_if_null(ops, inode_symlink);
+	set_to_cap_if_null(ops, inode_reflink);
 	set_to_cap_if_null(ops, inode_mkdir);
 	set_to_cap_if_null(ops, inode_rmdir);
 	set_to_cap_if_null(ops, inode_mknod);
diff --git a/security/security.c b/security/security.c
index 5284255..70d0ac3 100644
--- a/security/security.c
+++ b/security/security.c
@@ -470,6 +470,13 @@ int security_inode_symlink(struct inode *dir,
struct dentry *dentry,
 	return security_ops->inode_symlink(dir, dentry, old_name);
 }
 
+int security_inode_reflink(struct dentry *old_dentry, struct inode
*dir)
+{
+	if (unlikely(IS_PRIVATE(old_dentry->d_inode)))
+		return 0;
+	return security_ops->inode_reflink(old_dentry, dir);
+}
+
 int security_inode_mkdir(struct inode *dir, struct dentry *dentry, int
mode)
 {
 	if (unlikely(IS_PRIVATE(dir)))
-- 
1.6.1.3


-- 

"Three o'clock is always too late or too early for anything you
 want to do."
        - Jean-Paul Sartre

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel at oss.oracle.com
http://oss.oracle.com/mailman/listinfo/ocfs2-devel
