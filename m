From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Sep 20 12:05:01 2007
Subject: [Ocfs2-devel] [PATCH 05/15] ocfs2: Pass raw u64 to filldir
In-Reply-To: <20070920184047.GH30391@tasint.org>
References: <200709192012.l8JKCGhF012172@agmgw2.us.oracle.com>
	<20070920184047.GH30391@tasint.org>
Message-ID: <20070920190459.GC21356@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Sep 20, 2007 at 11:40:47AM -0700, Joel Becker wrote:
> On Mon, Sep 10, 2007 at 05:30:26PM -0700, Mark Fasheh wrote:
> > filldir_t can take this, so don't turn de->inode into a 32 bit value. Right
> > now this doesn't make a difference since no ocfs2 inodes overflow that, but
> > it could be a nasty surprise later on if some kernel code is calling
> > ocfs2_dir_foreach_blk() and expecting real inode numbers back...
> 
> 	How come we don't have inodes overflowing 32bits?  Is this a
> limit imposed elsewhere?  Refresh my (swiss cheese) memory :-)

Sure - basically since JBD (version 1) doesn't allow for larger than 32 bits
worth of blocks, mkfs.ocfs2 prevents such a file system from being created
and hence there's no way that we can overflow 32 bits with i_ino today.

Last I checked, JBD2 has Zach's patches to understand 64 bit block numbers.

Once we move over to that, we're going to have to figure out what to do and
it's at that point where I figure we'll have to revisit this anyway. It
seems that we might have to just always restrict inode blocks to 32 bits
anyway because of abi issues beyond our control, but that's a conversation
for another day :)


> 	I actually think that the -EOVERFLOW from filldir(7) is better
> than our truncated ino, so I still say

Yeah, agreed. I'd rather get an obvious error and be force to fix it at the
source than silently return bad information.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
