From: Jamie Lokier <jamie@shareable.org>
Date: Tue, 5 May 2009 23:30:16 +0100
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <20090505170058.GD7835@mail.oracle.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
	<20090505010703.GA12731@shareable.org>
	<20090505071608.GB10258@mail.oracle.com>
	<20090505130114.GD17486@mit.edu>
	<20090505170058.GD7835@mail.oracle.com>
Message-ID: <20090505223016.GF7574@shareable.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

Joel Becker wrote:
> 	I think I'm confusing you.  ocfs2 creates a new inode, with a
> new tree of extent blocks, pointing to the same data extents as the
> source.  You can do *anything* POSIX to that new inode.  You can chown
> it, chmod it, truncate it, futimes it, whatever.  The only thing at
> issue is what the state of the inode is at the return of the reflink()
> call.

Ok, but does chown/chmod/futimes trigger a COW copy, unsharing the data?
This is still not clear. :-)

Behaviourally, whether a massive copy is triggered by chmod is quite a
significant thing.  It dictates whether programs and scripts should be
careful to avoid chmod on reflinked files because it may very
expensive (think chmod triggering a 200GB copy), or can do so cheaply.

> 	I'm not defining reflink() as "creates a new inode" because I
> can see something like btrfs using the same storage inode with a new
> inode number until it needs to CoW.  But from the user-visible
> perspective, that's exactly what happens.

I'm still not clear from the above explanation whether full data
unsharing (i.e. it's all copied, takes a long time, can trigger
ENOSPC) happens on chown/chmod etc.

But assuming it stays shared until you modify the actual data, could
the documentation make this important fact a bit more prominent:

    reflink() creates a new file which initially shares the same
    underlying data storage as the source file, and has all the same
    attributes including security context and extended attributes.

    After creating the new file, you can do *anything* POSIX to that
    new file.  You can chown it, chmod it, futimes it, truncate it,
    write to it, whatever.  When the data is modified, that will
    trigger a copy-on-write operation so that the underlying data is
    not completely shared any more.

    The amount and timing of copying is filesystem-dependent, but only
    happens when a data write or extended attribute change takes place.

    Opening a file, reading it, read-only or private mappings, and
    simple attribute updates (chown, chmod, futimes, as well as
    automatic atime updates) will not trigger copy-on-write and will
    not return ENOSPC errors.

Thanks,
-- Jamie
