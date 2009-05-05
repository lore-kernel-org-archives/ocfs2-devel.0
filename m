From: Theodore Tso <tytso@mit.edu>
Date: Tue, 5 May 2009 10:21:02 -0400
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <20090505131907.GF25328@shareable.org>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
	<20090505010703.GA12731@shareable.org>
	<20090505071608.GB10258@mail.oracle.com>
	<20090505130114.GD17486@mit.edu>
	<20090505131907.GF25328@shareable.org>
Message-ID: <20090505142102.GE17486@mit.edu>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jamie Lokier <jamie@shareable.org>
Cc: linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Tue, May 05, 2009 at 02:19:07PM +0100, Jamie Lokier wrote:
> There was an attempt at something like that for ext3 a year or two ago.
> Search for "cowlink" if you're interested.

Yeah, I remember that discussion.  The hard part was always the VM
infrastructure, not the fs metadata.

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

It's a tradeoff.  If you use a separate "host" inode on the first
reflink, then then if you burn 3 inodes instead of two for which is
"copied"/"reflinked" once.  The only reason why we need to reserve an
extra field in the inode structure is for the pointer from the "host"
inode to the circular linked list.  (The space for the circular linked
list gets stored in i_data in the reflink inodes.)  If we are using
256 byte inodes we have the space to spare --- and if we really cared
about not utilizing the space in the inode structure if it wasn't
necessary, it could always be stored as an extended attribute
(although that has a greater overhead).

The question of which of these design tradeoffs is preferable is
really one of how many inodes will get copied via reflinks, and how
many times will a particular inode will be copied by a reflink.  If it
is common (for example, in a virtualization or container workload) for
a single file to be copied via reflink 50 or 100 times, then the extra
inode created when you create the first reflink is no big deal.  If
most of the time a file is only going to be reflink'ed once or twice,
then the overhead is much bigger.

This is really a design detail, though.

The bigger questions, which we really need to answer are:

1) If someone other than the owner of a file uses reflink to "make a
copy" of the file, is it new inode, with the new inode number, owned
by the original owner (making it look more like a link), or owned by
the person creating the reflink (making it look more like a copy).

2) Does changing the metadata --- atime, user/group ownership, ctime,
etc., break the COW link and cause a copy?

(2) could be a per-filesystem implementation detail, but (1) goes to
the semantics of the how the reflink() system call will work, so I
think we need to have a common answer which is the same across all
filesystems.  

Maybe some filesystems could simply refuse to support a user who isn't
the owner creating a reflink, but saying that some filesystems might
CAP_FOWNER (because the inode will be created with owner of the uid)
would still mean that in the case where you had a setuid binary, or if
the system supports fine-grained capability support, so a user with a
non-zero UID has CAP_FOWNER, it would be unfortunate if a file owned
by uid 23, when copied via reflink by uid 45 with CAP_FOWNER privs, on
some filesystems creates a reflinked inode which when stat'ed, st_uid
is 23, and on other filesystems creates a reflink inode which when
stat'ed, st_uid is 45.

							- Ted
