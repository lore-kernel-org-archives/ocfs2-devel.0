From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 4 Mar 2009 17:24:06 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: anti stale inode for nfs (V6)
In-Reply-To: <200903030232.n232W2xF026375@acsinet13.oracle.com>
References: <200903030232.n232W2xF026375@acsinet13.oracle.com>
Message-ID: <20090305012406.GA8700@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Mar 03, 2009 at 10:30:50AM +0800, wengang wang wrote:
> For nfs exporting, ocfs2_get_dentry() returns the dentry for fh.
> ocfs2_get_dentry() may read from disk(when inode not in memory) without
> any cross cluster lock. this leads to load a stale inode.
> 
> this patch fixes above problem.
> solution is that in case of inode is not in memory, we get the cluster lock(PR)
> of alloc inode where the inode in question is allocated from(this causes node
> on which deletion is done sync the alloc inode) before reading out the inode
> its self. then we check the bitmap in the group(the inode in question
> allcated from) to see if the bit is clear. if it's clear then it's stale.
> if the bit is set, we then check generation as the existing code does.
> 
> actually we have to read out the inode in question from disk(not cache) first
> to know its alloc slot(tells alloc inode) and allot bit(tells alloc group). and
> if its not stale(by above logic) we read it out using ocfs2_iget(). the second
> read should from cache.
> 
> and also we have to add a per superblock nfs_sync_lock to cover the lock for
> alloc inode and that for inode in question. this is because ocfs2_get_dentry()
> and ocfs2_delete_inode() lock on them in reverse order. nfs_sync_lock is locked
> in EX mode in ocfs2_get_dentry() and in PR mode in ocfs2_delete_inode(). so
> that mutliple ocfs2_delete_inode() can run concurrently in normal case.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>

Acked-by: Joel Becker <joel.becker@oracle.com>

Wengang,
	Thanks for working so hard on this.  I'm going to poke Mark to
include it.  Now we can go back and do the 1.4 patch.  Can you cook that
up?  It should be almost the same.

Joel

-- 

"A narcissist is someone better looking than you are."  
         - Gore Vidal

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
