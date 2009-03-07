From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 6 Mar 2009 16:06:09 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: anti stale inode for nfs
	(for	1.4git)
In-Reply-To: <200903061331.n26DVFIX003385@acsinet13.oracle.com>
References: <200903061331.n26DVFIX003385@acsinet13.oracle.com>
Message-ID: <20090307000609.GA19522@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 06, 2009 at 09:29:56PM +0800, wengang wang wrote:
> Back porting from mainline.
> 
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

	I think this looks good.  Is there any way a customer with this
problem can test the 1.4 backport?

Joel

-- 

Life's Little Instruction Book #173

	"Be kinder than necessary."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
