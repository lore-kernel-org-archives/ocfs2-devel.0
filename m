From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Thu Feb  5 01:56:37 2004
Subject: [Ocfs2-devel] Adding ocfs support in blkid
Message-ID: <20040203224525.GA10331@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

FYI...

In recent discussion on the Data Center Linux (DCL) mailing list
about a proposed requirement for persistent device naming, 
Theodore Ts pointed to blkid functionality as one possible way
of providing the functionality.
 
I had personally never used blkid or libblkid (provided in the
e2fsprogs rpm on most distributions), but realized after reviewing
the man pages that it was a pretty useful technology.

We have an opportunity to add ocfs support in the next release
of e2fsprogs.  Does anyone see a problem with sending a patch
in for blkid for ocfs?

    --rusty


----- Forwarded message from Theodore Ts'o <tytso@mit.edu> -----

Date: Tue, 3 Feb 2004 17:02:33 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Rusty Lynch <rusty@penguin.co.intel.com>
Subject: Re: [Dcl_tech_board] Persistent Disk Naming: call for requirements
Cc: Greg KH <greg@kroah.com>, DCL Technical Board <dcl_tech_board@osdl.org>,
   Mary Edie Meredith <maryedie@osdl.org>

On Tue, Feb 03, 2004 at 08:21:33AM -0800, Rusty Lynch wrote:
> 
> Can you point me to some documentation on how to add support for other 
> filesystems.  I just recently started working with ocfs, and it looks 
> like blkid is not picking up and partitions formated for ocfs.
> 

No documentation, I'm afraid, although adding support for ocfs should
be fairly straightforward.  The relevant file is
e2fsprogs/lib/blkid/probe.c.  If the filesystem has a straightforward
magic number, it can just be placed in the blk_magic type array:

/*
 * Various filesystem magics that we can check for.  Note that kboff and
 * sboff are in kilobytes and bytes respectively.  All magics are in
 * byte strings so we don't worry about endian issues.
 */
static struct blkid_magic type_array[] = {
/*  type     kboff   sboff len  magic			probe */
	...
  { "xfs",	 0,	 0,  4, "XFSB",			probe_xfs },
	...
}

The probe function (probe_xfs in this case) can also be used to do a
more refined test.  The probe function is responsible for setting the
label and uuid information for the filesystem, or else returning a
non-zero value if it turns out that the filesystem is not of the
specified type.  lib/blkid/probe.c probably could be more paranoid
about identifying filesystems, but to date no one has reported any
false positives so I haven't bothered to put in more stringent tests.
(See the probe_reiserfs() function for an example of the sort of extra
testing that can be done to make sure the superblock is consistent.)
As always, patches are welcome.  :-)

						- Ted

P.S.  I'm about to release a new e2fsprogs release soon, so if you
have some additional filesystems that should be added (blkid currently
supports ext2, ext3, jbd, jfs, xfs, reiserfs, minix, vfat, msdos,
ntfs, hfs, vxfs, hpfs, sysv, romfs, bfs, cramfs, qnx4, udf, iso9660,
and swap, with LABEL and/or UUID support for all filesystems that
support such labelling), please let me know.  I'm aiming for blkid to
be as complete as possible.

----- End forwarded message -----
