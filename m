From: Joel Becker <joel.becker@oracle.com>
Date: Sat,  2 May 2009 23:15:01 -0700
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system call.
In-Reply-To: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1241331303-23753-2-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

int reflink(const char *oldpath, const char *newpath);

The reflink(2) system call creates reference-counted links.  It creates
a new file that shares the data extents of the source file in a
copy-on-write fashion.  Its calling semantics are identical to link(2).
Once complete, programs see the new file as a completely separate entry.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 Documentation/filesystems/reflink.txt |  129 +++++++++++++++++++++++++++++++++
 Documentation/filesystems/vfs.txt     |    4 +
 2 files changed, 133 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/filesystems/reflink.txt

diff --git a/Documentation/filesystems/reflink.txt b/Documentation/filesystems/reflink.txt
new file mode 100644
index 0000000..f3620f0
--- /dev/null
+++ b/Documentation/filesystems/reflink.txt
@@ -0,0 +1,129 @@
+reflink(2)
+==========
+
+NAME
+----
+reflink - make a reference-counted link of a file
+
+
+SYNOPSIS
+--------
+#include <unistd.h>
+
+int reflink(const char *oldpath, const char *newpath);
+
+DESCRIPTION
+-----------
+reflink() creates a new reflink (also known as a reference-counted link)
+to an existing file.  This reflink is a new file object that shares the
+attributes and data extents of the source object in a copy-on-write fashion.
+
+An easy way to think of it is that the semantics of the reflink() call
+are identical to the link(2) system call, but the resulting file object
+behaves as if it were a copy with identical attributes.
+
+Like the link(2) system call, if newpath exists, it will not be overwritten.
+oldpath must be a regular file.  oldpath and newpath must be on the same
+mounted filesystem.
+
+All data extents of the new file must be shared with the source file in
+a copy-on-write fashion.  This includes data extents for extended
+attributes.  If either the source or new files are written to, the
+changes do not show up in the other file.
+
+All file attributes and extended attributes of the new file must
+identical to the source file with the following exceptions:
+
+- The new file must have a new inode number.  This allows POSIX
+  programs to treat the source and new files as separate objects.  From
+  the view of the POSIX application, the files are distinct.  The
+  sharing is invisible outside the filesystem.
+- The ctime of the source file only changes if the source's metadata
+  must be changed to accommodate the copy-on-write linkage.  The ctime of
+  the new file is set to represent its creation.
+- The mtime of the source file is unmodified, and the mtime of the new file
+  is set identical to the source file.  This reflects that the data is
+  unchanged.
+- The link count of the source file is unchanged, and the link count of
+  the new file is one.
+
+RETURN VALUE
+------------
+On success, zero is returned.  On error, -1 is returned, and errno is
+set appropriately.
+
+ERRORS
+------
+EACCES::
+	Write access to the directory containing newpath is denied, or
+	search permission is denied for one of the directories in the
+	path prefix of oldpath or newpath.  (See also path_resolution(7).)
+
+EEXIST::
+	newpath already exists.
+
+EFAULT::
+	oldpath or newpath points outside your accessible address space.
+
+EIO::
+	An I/O error occurred.
+
+ELOOP::
+	Too many symbolic links were encountered in resolving oldpath or
+	newpath.
+
+ENAMETOOLONG::
+	oldpath or newpath was too long.
+
+ENOENT::
+	A directory component in oldpath or newpath does not exist or is
+	a dangling symbolic link.
+
+ENOMEM::
+	Insufficient kernel memory was available.
+
+ENOSPC::
+	The device containing the file has no room for the new directory
+	entry or file object.
+
+ENOTDIR::
+	A component used as a directory in oldpath or newpath is not, in
+	fact, a directory.
+
+EPERM::
+	oldpath is a directory.
+
+EPERM::
+	The file system containing oldpath and newpath does not support
+	the creation of reference-counted links.
+
+EROFS::
+	The file is on a read-only file system.
+
+EXDEV::
+	oldpath and newpath are not on the same mounted file system.
+	(Linux permits a file system to be mounted at multiple points,
+	but reflink() does not work across different mount points, even if
+	the same file system is mounted on both.)
+
+VERSIONS
+--------
+reflink() is available on Linux since kernel 2.6.31.
+
+CONFORMING TO
+-------------
+reflink() is Linux-specific.
+
+NOTES
+-----
+reflink() deferences symbolic links in the same manner that link(2)
+does.  For precise control over the treatment of symbolic links, see
+reflinkat().
+
+In the case of a crash, the new file must not appear partially complete
+in the filesystem.
+
+SEE ALSO
+--------
+ln(1), reflink(1), reflinkat(2), path_resolution(7)
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
-- 
1.6.1.3
