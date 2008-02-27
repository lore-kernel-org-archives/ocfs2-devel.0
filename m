From: Tao Ma <tao.ma@oracle.com>
Date: Wed Feb 27 22:36:33 2008
Subject: [Ocfs2-devel] [PATCH 0/3] Add inode steal for ocfs2.V2
Message-ID: <20080228063438.GA27318@tma-pc1.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,
This patch series add inode steal mechanism for inode allocation.

Modification from V1 to V2:
1. Add a new member in ocfs2_super which will record the slot we steal
   the inode successfully. This will speed up the next steal.
2. Modify the mechanism of inode stealing. Now we will start our search
   from the node next to it. 
3. Remove the last and extra inode allocation in the local slot since
   there is no evidence that we will have our global bitmap be emptied
   enough in the time it takes us to search the other allocators.

In OCFS2, we allocate the inodes from slot specific inode_alloc to avoid
inode creation congestion. The local alloc file grows in a large contiguous
chunk. As for a 4K bs, it grows 4M every time. So 1024 inodes will be
allocated at a time.

Over time, if the fs gets fragmented enough(e.g, the user has created many
small files and also delete some of them), we can end up in a situation,
whereby we cannot extend the inode_alloc as we don't have a large chunk
free in the global_bitmap even if df shows few gigs free. More annoying is
that this situation will invariably mean that while one cannot create inodes
on one node but can from another node. Still more annoying is that an unused
slot may have space for plenty of inodes but is unusable as the user may not
be mounting as many nodes anymore.

This patch series implement a solution which is to steal inodes from another
slot. Now the whole inode allocation process looks like this:
1. Allocate from its own inode_alloc:000X
   1) If we can reserve, OK.
   2) If fails, try to allocate a large chunk and reserve once again.
2. If 1 fails, try to allocate from the ocfs2_super->inode_steal_slot.
   This time, Just try to reserve, we don't go for global_bitmap if
   this inode also can't allocate the inode.
3. If 2 fails, try the node next until we reach that steal slot again.

ocfs2_super->inode_steal_slot is initalized as the node next to our own
slot. And once the inode stealing successes, we will refresh it with
the slot we steal inode from. It will also be reinitalized when the local
truncate log or local alloc recovery is flushed in which case the global
bitmap may be refreshed.
