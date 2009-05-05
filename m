From: Theodore Tso <tytso@mit.edu>
Date: Tue, 5 May 2009 09:01:14 -0400
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <20090505071608.GB10258@mail.oracle.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
	<20090505010703.GA12731@shareable.org>
	<20090505071608.GB10258@mail.oracle.com>
Message-ID: <20090505130114.GD17486@mit.edu>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jamie Lokier <jamie@shareable.org>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Tue, May 05, 2009 at 12:16:09AM -0700, Joel Becker wrote:
> On Tue, May 05, 2009 at 02:07:03AM +0100, Jamie Lokier wrote:
> > Joel Becker wrote:
> > > +All file attributes and extended attributes of the new file must
> > > +identical to the source file with the following exceptions:
> > 
> > reflink() sounds useful already, but is there a compelling reason why
> > both files must have the same attributes, and changing attributes will
> > break the COW?
> 
> 	Yeah, because without it you can't use it for snapshotting.
> That's where the original design came from - inode snapshots.  The big
> thing that excited me was that defining reflink() as I did, instead of
> a more specific snapshot call, allows all sorts of generic uses (some of
> which you outline below).

I guess it depends on your implementation.  At least the way I would
implement this in ext4, for example, I'd simply set a new flag
indicating this was a "reflink", and then the i_data[0..3] field would
contain the inode number of the "host" inode, and i_data [4..7] and
i_data[8..11] would contain a circular linked list of all reflinks
associated with that inode.  I'd then grab a spare inode field so the
"host" inode could point to the reflink'ed inodes.

If you ever need to delete the host inode, you simply pick one of the
reflink inodes and copy i_data from the host inode one of the reflink
inodes and promote it to be the "host" inode, and then update all of
the other reflink inodes to point at the new host inode.

The advantage of this scheme is not only does the reflink'ed inode
have a new inode number (as in your design), it actually has an
entirely new inode.  So we can change the ownership, the mtime, ctime;
it behaves *entirely* as a separate, free-standing inode except it is
sharing the data blocks.

This allows me to easily set a new owner, and indeed any other inode
metadata, on the reflink'ed inode, which I would argue is a Good
Thing.

I'm guessing that OCFS2 has implemented (or is planning on
implementing) reflinks, you can't modify the metadata?  Or is there
some really important reason why it's not a good idea for OCFS2?

> > Since each reflink has its own nlink and ino, I'm wondering why the
> > other attributes cannot also be separate.  (I realise extended
> > attributes complicate the picture and it's desirable to share them,
> > especially if they are large).
> 
> 	The biggest reason is snapshotting.

I guess this doesn't mean much to me.  Can you say more about what you
have in mind when you say "snapshotting"?  Is this in the WAFL sense?
What's the use case?

> > Can you hard link to the source file and the reflink afterwards,
> > incrementing the reflink's link count?  (I presume yes).  Can you
> > reflink to both of them too?
> 
> 	Yes, absolutely.  Once reflinked, they look like two separate
> POSIX files.

... but in your implementation, if you ever chown or chmod (or even
touch the atime?) of the file, it instantly does a copy-on-write?

            	  	     	       	  - Ted
