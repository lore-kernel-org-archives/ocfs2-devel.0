From: Tao Ma <tao.ma@oracle.com>
Date: Mon Mar  3 01:00:50 2008
Subject: [Ocfs2-devel] [PATCH 0/3] Add inode stealing in ocfs2.V3
Message-ID: <20080303090022.GA18049@tma-pc1.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,
This patch series add inode steal mechanism for inode allocation.

Modification from V2 to V3:
1. Add a new member to record the times we have stealed inode from
   other slots so that we can go directly to inode steal without
   trying our own slot every time.

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
slot. 2 new variables are added for it. They are:
1) ocfs2_super->inode_steal_slot. It is initalized as invalid and only
   set valid when we steal inode from other slots successfully. When we
   flush the truncate log, complete local alloc recovery or allocate
   from our own slot successfully, it will be reset to invalid.
2) inode_steal_times. It is used to record the times we try to steal
   inode from other nodes. And it is increased no matter whether our steal
   succeed or not. It is reset to zero when we try to allocate from our
   own slot.

So with this 2 new variables, now the whole inode allocation process is:
1. Check whether the ocfs2_super->inode_steal_slot is valid. If it is
   invalid, goto step 2, that is to try to allocate from our own. If it
   is valid, then we must have stealed inode successfully just now, so
   verify whether we have steal "inode_steal_times". If yes, goto step 2
   since now we need to try own slot in case there is some space for us.
   If not, goto step 3 and steal from other nodes directly.
2. Allocate from its own inode_alloc:000X and zero inode_steal_times.
   1) If we can reserve, OK.
   2) If fails, try to allocate a large chunk and reserve once again.
   3) If OK, clear ocfs2_super->inode_steal_slot and exit directly.
3. Try to allocate from other nodes.
   1) If ocfs2_super->inode_steal_slot is valid, start from that node,
      otherwise start from the node next to us. This time, Just try to
      reserve in inode_alloc, we don't go for global_bitmap if this
      node also can't allocate the inode.
   3) Try the node next until we reach the first steal slot again.
   4) If we succeed in one node's inode_alloc, set
      ocfs2_super->inode_steal_slot to it.
   5) increase inode_steal_times.
