From: Chris Mason <chris.mason@oracle.com>
Date: Tue, 05 May 2009 09:39:58 -0400
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <20090505131907.GF25328@shareable.org>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
	<20090505010703.GA12731@shareable.org>
	<20090505071608.GB10258@mail.oracle.com>
	<20090505130114.GD17486@mit.edu>
	<20090505131907.GF25328@shareable.org>
Message-ID: <1241530798.7244.65.camel@think.oraclecorp.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jamie Lokier <jamie@shareable.org>
Cc: Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Tue, 2009-05-05 at 14:19 +0100, Jamie Lokier wrote:
> Theodore Tso wrote:
> > I guess it depends on your implementation.  At least the way I would
> > implement this in ext4, for example, I'd simply set a new flag
> > indicating this was a "reflink", and then the i_data[0..3] field would
> > contain the inode number of the "host" inode, and i_data [4..7] and
> > i_data[8..11] would contain a circular linked list of all reflinks
> > associated with that inode.  I'd then grab a spare inode field so the
> > "host" inode could point to the reflink'ed inodes.
> > 
> > If you ever need to delete the host inode, you simply pick one of the
> > reflink inodes and copy i_data from the host inode one of the reflink
> > inodes and promote it to be the "host" inode, and then update all of
> > the other reflink inodes to point at the new host inode.
> > 
> > The advantage of this scheme is not only does the reflink'ed inode
> > have a new inode number (as in your design), it actually has an
> > entirely new inode.  So we can change the ownership, the mtime, ctime;
> > it behaves *entirely* as a separate, free-standing inode except it is
> > sharing the data blocks.
> > 
> > This allows me to easily set a new owner, and indeed any other inode
> > metadata, on the reflink'ed inode, which I would argue is a Good
> > Thing.
> 
> There was an attempt at something like that for ext3 a year or two ago.
> Search for "cowlink" if you're interested.
> 
> Most of the discussion ended up around how to handle copying on writes
> to shared-writable mmaps, something which I guess is solved these days.
> 
> Instead of a circular list, a proposed implementation was to create a
> separate "host" inode on the first reflink, converting the source
> inode to a reflink inode and moving the data block references to the
> new host inode.  Each reflink was simply a reference to the host
> inode, much like your design, and the host inode was only to hold the
> data blocks, with it's i_nlink counting the number of reflinks
> pointing to it.
> 
> Using a circular list means the space must be reserved in every inode,
> even those which are not (yet) reflinks.  It also does a bit more
> writing sometimes, because of having to update next and previous
> entries on the list.
> 
> Hmm.  The data pointers could live in all the inodes, since they are
> identical and the whole data is cloned on write.  That would make
> reading a bit faster.
> 
> > I'm guessing that OCFS2 has implemented (or is planning on
> > implementing) reflinks, you can't modify the metadata?  Or is there
> > some really important reason why it's not a good idea for OCFS2?
> 
> I would have thought for OCFS2 and BTRFS, with their nice keyed tree
> structure, it would be quite natural to implement separate inodes for
> the reflinks pointing at a shared data-holding inode.  Something a
> little bit like that must be happening to permit separate inode numbers.
> 

Thanks for getting this discussion going Joel, its really good to get
this behavior well defined.

The btrfs implementation is just that you have two separate files
pointing to the same extents on disk.  Each file has a reference on each
extent, and deleting or chowning fileA doesn't change the metadata in
fileB.

The btrfs cow code makes sure that modifications in either file (even
when mounted in -o nodatacow) are written to new extents instead of
changing the original.  If you write one block in a 1TB file, the new
space used by the clone is only one block.  (Thanks to the ceph
developers for coding all of this up a while ago).

The main difference between reflink and the btrfs ioctl is that in the
btrfs ioctl the destination file must already exist.  The btrfs code can
also do range replacements in the destination file, but I'd agree with
Joel that we don't want to toss the kitchen sink into something nice and
clean like reflink.

-chris
