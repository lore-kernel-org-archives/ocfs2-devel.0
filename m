From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue, 25 Apr 2006 15:24:33 -0700
Subject: [Ocfs2-devel] OCFS2 features RFC
In-Reply-To: <20060425215548.GB16170@lst.de>
References: <20060425183553.GB10524@ca-server1.us.oracle.com>
	<20060425215548.GB16170@lst.de>
Message-ID: <20060425222433.GC10524@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Apr 25, 2006 at 11:55:48PM +0200, Christoph Hellwig wrote:
> On Tue, Apr 25, 2006 at 11:35:53AM -0700, Mark Fasheh wrote:
> > -Htree support
> 
> Please not.  htree is just the worst possible directory format around.
> Do some nice hashed or btree directories, but don't try this odd hack
> again. Especially as the only reason it was developed for in ext2/3
> doesn't work very well in a cluster filesystem anyway - to access the
> new htree all nodes would have to support the format anyway, so the
> whole easy up/downgrade thing doesn't matter at all.
Interesting. You make a good point about the up/downgrade code - we
certainly couldn't use that (at least not without jumping some hoops). I
have to admit that I haven't looked very deeply into htree yet but if it's
that bad and we won't be compatible in any case it certainly makes sense to
try something new. Would you mind pointing out a few of the htree issues
that make it so poor?

> 
> > -Extended attributes: This might be another area where we
> >  steal^H^H^H^H^Hcopy some good code from Ext3 :) On top of this one can
> >  trivially implement posix acls. We're not likely to support EA block
> >  sharing though as it becomes difficult to manage across the cluster.
> 
> again the ext3 implementation might not be the best.  I'd say look at
> jfs or xfs (in the latter case of course with a less monsterous btree
> implementation)
I agree the XFS implementation seems a bit overboard... The problem I'm
having is that I can't seem to determine what size the average set of
extended attributes will be. Basically, as far as I can tell, ext3 will
allow about 1 block plus whatever will fit in the inode, minus overhead.
We'd like to have inlined EA but want to be able to move them out to a block
in the case that the number of extents we need grows to the end of the inode
block - this is to avoid having to create an allocation btree. So then if we
take the one-block-attached-to-the-inode approach, we'd have a capacity a
little less than ext3.

I've also noticed that, while the ext3 EA entries are stored in sorted
order, the search for them is linear. I wonder if that could be improved
upon (or if it even matters if you're just limited to one block).

If one block is insufficient, then certainly we need to look at some other
format. My first inclination would be to have a single level tree with
pointers to leaf nodes stored in hashed order to speed up lookups.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh at oracle.com
