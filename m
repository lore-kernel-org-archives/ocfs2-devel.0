From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri Feb 22 15:09:17 2008
Subject: [Ocfs2-devel] [PATCH 0/3] Add inode stealing for ocfs2.V1
In-Reply-To: <20080222084149.GA29738@tma-pc1.cn.oracle.com>
References: <20080222084149.GA29738@tma-pc1.cn.oracle.com>
Message-ID: <20080222230738.GH27865@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 22, 2008 at 04:41:49PM +0800, tao.ma wrote:
> 	This patch set improve the method for inode allocation. Now they
> are divided into 3 small patches, but I think maybe they can be merged
> together as one. Any comments are welcomed.

Thank you for the thorough description. One thing that was left out - could
you give me a short description of how these changes were tested?


> In OCFS2, we allocate the inodes from slot specific inode_alloc to avoid
> inode creation congestion. The local alloc file grows in a large contiguous
> chunk. As for a 4K bs, it grows 4M every time. So 1024 inodes will be
> allocated at a time.
> 
> Over time, if the fs gets fragmented enough(e.g, the user has created many
> small files and also delete some of them), we can end up in a situation,
> whereby we cannot extend the inode_alloc as we don't have a large chunk
> free in the global_bitmap even if df shows few gigs free. More annoying is
> that this situation will invariably mean that while one cannot create inodes
> on one node but can from another node. Still more annoying is that an unused
> slot may have space for plenty of inodes but is unusable as the user may not
> be mounting as many nodes anymore.
> 
> This patch series implement a solution which is to steal inodes from another
> slot. Now the whole inode allocation process looks like this:
> 1. Allocate from its own inode_alloc:000X
>    1) If we can reserve, OK.
>    2) If fails, try to allocate a large chunk and reserve once again.

Do you have a mechanism in place to remember which inode alloc file you were
last able to sucessfully allocate from? If you did that, then we could avoid
needlessly searching our own slot every time.

You could even reset your "last inode alloc slot" pointer to the local slot
when space is freed from the local allocator.


> 2. If 1 fails, try to allocate from the last node's inode_alloc. This time,
>    Just try to reserve, we don't go for global_bitmap if this inode also
>    can't allocate the inode.

Does every node go to the same inode allocator after it's own? Wouldn't this
create a lot of traffic in one slot?

Why not search inode alloc in the next slot and loop back until you reach
yours again? So, if the nodes slot is '3' and max slots is 6, it'd search
4, 5, 0, 1, 2 before giving up.


> 3. If 2 fails, try the node before it until we reach inode_alloc:0000.
>    In the process, we will skip its own inode_alloc.

> 4. If 3 fails, try to allocate from its own inode_alloc:000X once again. Here
>    is a chance that the global_bitmap may has a large enough chunk now during
>    the inode iteration process.

What are the chances that the global bitmap emptied enough in the time it
took us to search the other allocators? It doesn't seem like that would
happen very much, so I wouldn't bother with this last step unless we had
evidence that it would make a real difference.
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
