From: Boaz Harrosh <bharrosh@panasas.com>
Date: Sun, 03 May 2009 16:08:59 +0300
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <1241331303-23753-2-git-send-email-joel.becker@oracle.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
Message-ID: <49FD976B.3000508@panasas.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <joel.becker@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On 05/03/2009 09:15 AM, Joel Becker wrote:
> int reflink(const char *oldpath, const char *newpath);
> 
> The reflink(2) system call creates reference-counted links.  It creates
> a new file that shares the data extents of the source file in a
> copy-on-write fashion.  Its calling semantics are identical to link(2).
> Once complete, programs see the new file as a completely separate entry.
> 

Please forgive my complete Unix jargon novice-ness, but from here it looks like the
name is very wrong, and confusing.

if I put data to link graph then:

[data]<--[hard-link (one or more)]<--[soft-link(zero or more)]

The data is other-wise just there on disk but is un available until
it is linked to a dir-entry, at-least one. The middle hard-link is reference
counted and once all uses are removed data can be garbage collected. Soft links
don't follow on-disk data but follow a dir-entry. So if we have a completely
different on disk data we're still in agreement with the dir-entry.

In the graph above and has explained below. there is no reference counting
going on:
> +- The link count of the source file is unchanged, and the link count of
> +  the new file is one.

And and the "link" meaning is very vaguely kept, only half way until the next
write. (If it can be called a link at all being a different inode and cached
twice)

As my first impression when I read the title of the patch, an English reflink
I would imagine is something more to the left of above graph, between hard-link
and soft-link, something like: link to an invisible dir-entry that is gone once
all soft-links to it are gone.

So form my point of view. Call it something different like Copy-On-Write or
COW.

I do understand that there is something very fundamental in my misunderstanding,
but it was not explained below, in fact the below terminology confused me even
more. Please explain?

> Signed-off-by: Joel Becker <joel.becker@oracle.com>
> ---
>  Documentation/filesystems/reflink.txt |  129 +++++++++++++++++++++++++++++++++
>  Documentation/filesystems/vfs.txt     |    4 +
>  2 files changed, 133 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/filesystems/reflink.txt
> 
> diff --git a/Documentation/filesystems/reflink.txt b/Documentation/filesystems/reflink.txt
> new file mode 100644
> index 0000000..f3620f0
> --- /dev/null
> +++ b/Documentation/filesystems/reflink.txt
> @@ -0,0 +1,129 @@
> +reflink(2)
> +==========
> +
> +NAME
> +----
> +reflink - make a reference-counted link of a file
> +
> +
> +SYNOPSIS
> +--------
> +#include <unistd.h>
> +
> +int reflink(const char *oldpath, const char *newpath);
> +
> +DESCRIPTION
> +-----------
> +reflink() creates a new reflink (also known as a reference-counted link)
> +to an existing file.  This reflink is a new file object that shares the
> +attributes and data extents of the source object in a copy-on-write fashion.
> +

This is exactly my confusion how is the logical jump made from reflink (reference/link)
to copy-on-write. I fail to see any logical connection.

> +An easy way to think of it is that the semantics of the reflink() call
> +are identical to the link(2) system call, but the resulting file object
> +behaves as if it were a copy with identical attributes.
> +
> +Like the link(2) system call, if newpath exists, it will not be overwritten.
> +oldpath must be a regular file.  oldpath and newpath must be on the same
> +mounted filesystem.
> +
> +All data extents of the new file must be shared with the source file in
> +a copy-on-write fashion.  This includes data extents for extended
> +attributes.  If either the source or new files are written to, the
> +changes do not show up in the other file.
> +
> +All file attributes and extended attributes of the new file must
> +identical to the source file with the following exceptions:
> +
> +- The new file must have a new inode number.  This allows POSIX
> +  programs to treat the source and new files as separate objects.  From
> +  the view of the POSIX application, the files are distinct.  The
> +  sharing is invisible outside the filesystem.
> +- The ctime of the source file only changes if the source's metadata
> +  must be changed to accommodate the copy-on-write linkage.  The ctime of
> +  the new file is set to represent its creation.
> +- The mtime of the source file is unmodified, and the mtime of the new file
> +  is set identical to the source file.  This reflects that the data is
> +  unchanged.
> +- The link count of the source file is unchanged, and the link count of
> +  the new file is one.
> +
> +RETURN VALUE
> +------------
> +On success, zero is returned.  On error, -1 is returned, and errno is
> +set appropriately.
> +
> +ERRORS
> +------
> +EACCES::
> +	Write access to the directory containing newpath is denied, or
> +	search permission is denied for one of the directories in the
> +	path prefix of oldpath or newpath.  (See also path_resolution(7).)
> +
> +EEXIST::
> +	newpath already exists.
> +
> +EFAULT::
> +	oldpath or newpath points outside your accessible address space.
> +
> +EIO::
> +	An I/O error occurred.
> +
> +ELOOP::
> +	Too many symbolic links were encountered in resolving oldpath or
> +	newpath.
> +
> +ENAMETOOLONG::
> +	oldpath or newpath was too long.
> +
> +ENOENT::
> +	A directory component in oldpath or newpath does not exist or is
> +	a dangling symbolic link.
> +
> +ENOMEM::
> +	Insufficient kernel memory was available.
> +
> +ENOSPC::
> +	The device containing the file has no room for the new directory
> +	entry or file object.
> +
> +ENOTDIR::
> +	A component used as a directory in oldpath or newpath is not, in
> +	fact, a directory.
> +
> +EPERM::
> +	oldpath is a directory.
> +
> +EPERM::
> +	The file system containing oldpath and newpath does not support
> +	the creation of reference-counted links.
> +
> +EROFS::
> +	The file is on a read-only file system.
> +
> +EXDEV::
> +	oldpath and newpath are not on the same mounted file system.
> +	(Linux permits a file system to be mounted at multiple points,
> +	but reflink() does not work across different mount points, even if
> +	the same file system is mounted on both.)
> +
> +VERSIONS
> +--------
> +reflink() is available on Linux since kernel 2.6.31.
> +
> +CONFORMING TO
> +-------------
> +reflink() is Linux-specific.
> +
> +NOTES
> +-----
> +reflink() deferences symbolic links in the same manner that link(2)
> +does.  For precise control over the treatment of symbolic links, see
> +reflinkat().
> +
> +In the case of a crash, the new file must not appear partially complete
> +in the filesystem.
> +
> +SEE ALSO
> +--------
> +ln(1), reflink(1), reflinkat(2), path_resolution(7)
> +
> diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
> index f49eecf..01cd810 100644
> --- a/Documentation/filesystems/vfs.txt
> +++ b/Documentation/filesystems/vfs.txt
> @@ -333,6 +333,7 @@ struct inode_operations {
>  	ssize_t (*listxattr) (struct dentry *, char *, size_t);
>  	int (*removexattr) (struct dentry *, const char *);
>  	void (*truncate_range)(struct inode *, loff_t, loff_t);
> +	int (*reflink) (struct dentry *,struct inode *,struct dentry *);
>  };
>  
>  Again, all methods are called without any locks being held, unless
> @@ -431,6 +432,9 @@ otherwise noted.
>  
>    truncate_range: a method provided by the underlying filesystem to truncate a
>    	range of blocks , i.e. punch a hole somewhere in a file.
> +  reflink: called by the reflink(2) system call. Only required if you want
> +	to support reflinks.  For further information, see
> +	Documentation/filesystems/reflink.txt.
>  
>  
>  The Address Space Object

Please forgive my ignorance, again I would honestly like to understand, and
how else, then to just ask?

Thanks in advance
Boaz
