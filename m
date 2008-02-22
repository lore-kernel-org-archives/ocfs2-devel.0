From: wengang wang <wen.gang.wang@oracle.com>
Date: Fri Feb 22 00:57:44 2008
Subject: [Ocfs2-devel] [PATCH 0/3] Add inode stealing for ocfs2.V1
In-Reply-To: <20080222084149.GA29738@tma-pc1.cn.oracle.com>
References: <20080222084149.GA29738@tma-pc1.cn.oracle.com>
Message-ID: <47BE89FE.1090204@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

not know it clearly, but I remember when extending a file, meta is 
allocated in extent_alloc instead of inode_alloc if necessary(correct me 
if i am wrong).
if so, do we need to take extent_alloc into consideration as well?

thanks,
wengang.

Tao Ma wrote:
> Hi all,
> 	This patch set improve the method for inode allocation. Now they
> are divided into 3 small patches, but I think maybe they can be merged
> together as one. Any comments are welcomed.
>
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
> 2. If 1 fails, try to allocate from the last node's inode_alloc. This time,
>    Just try to reserve, we don't go for global_bitmap if this inode also
>    can't allocate the inode.
> 3. If 2 fails, try the node before it until we reach inode_alloc:0000.
>    In the process, we will skip its own inode_alloc.
> 4. If 3 fails, try to allocate from its own inode_alloc:000X once again. Here
>    is a chance that the global_bitmap may has a large enough chunk now during
>    the inode iteration process.
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>   

-- 
Wengang Wang
Member of Technical Staff
Oracle Asia R&D Center
Open Source Technologies Development

Tel:      +86 10 8278 6265
Mobile:   +86 13381078925
