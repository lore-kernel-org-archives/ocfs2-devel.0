From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 5 May 2009 10:00:58 -0700
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <20090505130114.GD17486@mit.edu>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
	<20090505010703.GA12731@shareable.org>
	<20090505071608.GB10258@mail.oracle.com>
	<20090505130114.GD17486@mit.edu>
Message-ID: <20090505170058.GD7835@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>
Cc: Jamie Lokier <jamie@shareable.org>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Tue, May 05, 2009 at 09:01:14AM -0400, Theodore Tso wrote:
> I guess it depends on your implementation.  At least the way I would
> implement this in ext4, for example, I'd simply set a new flag
> indicating this was a "reflink", and then the i_data[0..3] field would
> contain the inode number of the "host" inode, and i_data [4..7] and
> i_data[8..11] would contain a circular linked list of all reflinks
> associated with that inode.  I'd then grab a spare inode field so the
> "host" inode could point to the reflink'ed inodes.
> 
> If you ever need to delete the host inode, you simply pick one of the
> reflink inodes and copy i_data from the host inode one of the reflink
> inodes and promote it to be the "host" inode, and then update all of
> the other reflink inodes to point at the new host inode.
> 
> The advantage of this scheme is not only does the reflink'ed inode
> have a new inode number (as in your design), it actually has an
> entirely new inode.  So we can change the ownership, the mtime, ctime;
> it behaves *entirely* as a separate, free-standing inode except it is
> sharing the data blocks.
> 
> This allows me to easily set a new owner, and indeed any other inode
> metadata, on the reflink'ed inode, which I would argue is a Good
> Thing.
> 
> I'm guessing that OCFS2 has implemented (or is planning on
> implementing) reflinks, you can't modify the metadata?  Or is there
> some really important reason why it's not a good idea for OCFS2?

	I think I'm confusing you.  ocfs2 creates a new inode, with a
new tree of extent blocks, pointing to the same data extents as the
source.  You can do *anything* POSIX to that new inode.  You can chown
it, chmod it, truncate it, futimes it, whatever.  The only thing at
issue is what the state of the inode is at the return of the reflink()
call.
	I'm not defining reflink() as "creates a new inode" because I
can see something like btrfs using the same storage inode with a new
inode number until it needs to CoW.  But from the user-visible
perspective, that's exactly what happens.

Joel

-- 

Life's Little Instruction Book #347

	"Never waste the oppourtunity to tell someone you love them."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
