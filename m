From: Theodore Tso <tytso@mit.edu>
Date: Tue, 5 May 2009 13:29:49 -0400
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <20090505170058.GD7835@mail.oracle.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
	<20090505010703.GA12731@shareable.org>
	<20090505071608.GB10258@mail.oracle.com>
	<20090505130114.GD17486@mit.edu>
	<20090505170058.GD7835@mail.oracle.com>
Message-ID: <20090505172949.GG17486@mit.edu>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jamie Lokier <jamie@shareable.org>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Tue, May 05, 2009 at 10:00:58AM -0700, Joel Becker wrote:
> On Tue, May 05, 2009 at 09:01:14AM -0400, Theodore Tso wrote:
> > I'm guessing that OCFS2 has implemented (or is planning on
> > implementing) reflinks, you can't modify the metadata?  Or is there
> > some really important reason why it's not a good idea for OCFS2?
> 
> 	I think I'm confusing you.  ocfs2 creates a new inode, with a
> new tree of extent blocks, pointing to the same data extents as the
> source.  You can do *anything* POSIX to that new inode.  You can chown
> it, chmod it, truncate it, futimes it, whatever.  The only thing at
> issue is what the state of the inode is at the return of the reflink()
> call.

OK, cool.  But in that case, if in every user-visible sense of the
word, it's equivalent to a file copy --- which is to say, it gets a
new inode number, and, then why not make it work *exactly* like a file
copy, which is to say make the ownership be the user who asked for the
reflink to be created?  That way /bin/cp could potentially use
reflinks, and aside from the fact that a cp -r of an existing
directory hierarchy takes no extra disk space and runs *much* faster,
a reflink acts exactly like a file copy.  The semantics are easy to
describe, we don't need CAP_FOWNER nonsense, it becomes much easier to
deal with the semantics vis-a-vis quota, etc.

> 	I'm not defining reflink() as "creates a new inode" because I
> can see something like btrfs using the same storage inode with a new
> inode number until it needs to CoW.  But from the user-visible
> perspective, that's exactly what happens.

Well, we can talk about inodes even for filesystems like FAT that
don't really have inodes; the user-visible perspective is the only
thing that we really care when we try to define the semantics of the
system call in a way that causes the least amount of surprise; given
that the new file gets a new inode number, it is *not* a hard link,
and it looks much more like a file copy.

       	     	       	      	   - Ted
