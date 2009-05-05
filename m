From: Jamie Lokier <jamie@shareable.org>
Date: Tue, 5 May 2009 02:07:03 +0100
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <1241331303-23753-2-git-send-email-joel.becker@oracle.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
Message-ID: <20090505010703.GA12731@shareable.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <joel.becker@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

Joel Becker wrote:
> +All file attributes and extended attributes of the new file must
> +identical to the source file with the following exceptions:

reflink() sounds useful already, but is there a compelling reason why
both files must have the same attributes, and changing attributes will
break the COW?

Being able to have different attributes would allow:

   - reflink() to be used for fast space-efficient copying, i.e. an
     optimisation to "cp", "git checkout" and things like that.

   - reflink() to be used for merging files with identical contents
     (something I find surprisingly often on my disks).

   - reflink() to be used for merging files from different
     cgroup-style VMs in particular.

Requiring all attributes except nlink and ino to be identical makes
reflink() unsuitable for transparently doing those things, except in
cases where they happen to have the same attributes anyway.

I'm thinking particularly of file permissions, owner/group and atime.

Since each reflink has its own nlink and ino, I'm wondering why the
other attributes cannot also be separate.  (I realise extended
attributes complicate the picture and it's desirable to share them,
especially if they are large).

> +- The new file must have a new inode number.  This allows POSIX
> +  programs to treat the source and new files as separate objects.  From
> +  the view of the POSIX application, the files are distinct.  The
> +  sharing is invisible outside the filesystem.

Invisible sharing is good and different inode number is obviously required.

But is there an efficient way for reflink-aware applications to detect
these files have the same contents, other than reading the contents
twice and comparing?  Occasionally that would be good.  E.g. It would
be nice if "diff -r" could be patched to do that.

> +- The ctime of the source file only changes if the source's metadata
> +  must be changed to accommodate the copy-on-write linkage.  The ctime of
> +  the new file is set to represent its creation.

What change to the source metadata would require ctime to change?

> +- The link count of the source file is unchanged, and the link count of
> +  the new file is one.

Can you hard link to the source file and the reflink afterwards,
incrementing the reflink's link count?  (I presume yes).  Can you
reflink to both of them too?

> +EPERM::
> +	oldpath is a directory.

I've always been surprised this isn't EISDIR :-)

> +EXDEV::
> +	oldpath and newpath are not on the same mounted file system.
> +	(Linux permits a file system to be mounted at multiple points,
> +	but reflink() does not work across different mount points, even if
> +	the same file system is mounted on both.)

That's in interesting restriction, though I see link() does the same.

> +reflink() deferences symbolic links in the same manner that link(2)
> +does.

Would that be "reflink() does not dereference symbolic links as the
final path component, in the same manner that link() does not" :-)

> For precise control over the treatment of symbolic links, see
> reflinkat().

As others have said, there's no need for a reflink() kernel system
call, as reflinkat() can be used for the same thing, and wrapped in
libc if reflink() is desirable as a userspace C function.

Also, reflinkat() has room for reflink-specific flags to be added
later if needed, which may come in handy.

-- Jamie
