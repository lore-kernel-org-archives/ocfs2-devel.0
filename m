From: Li Dongyang <lidongyang@novell.com>
Date: Wed, 21 Apr 2010 20:13:55 +0800
Subject: [Ocfs2-devel] Ocfs2 leaking inodes on failed allocation
In-Reply-To: <20100420191853.GB17187@wotan.suse.de>
References: <20100420180053.GD3885@quack.suse.cz>
	<20100420191853.GB17187@wotan.suse.de>
Message-ID: <201004212013.55202.lidongyang@novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wednesday 21 April 2010 03:18:53 Mark Fasheh wrote:
> On Tue, Apr 20, 2010 at 08:00:54PM +0200, Jan Kara wrote:
> >   Hi,
> >
> >   when running fsstress test on an almost full filesystem we observe
> > the following errors:
> > 1163.522931] (4774,1):ocfs2_query_inode_wipe:898 ERROR: bug expression:
> > !(di->i_flags & cpu_to_le32(OCFS2_ORPHANED_FL))
> > [ 1163.522938] (4774,1):ocfs2_query_inode_wipe:898 ERROR: Inode 77233
> > (on-disk 77233) not orphaned! Disk flags  0x1, inode flags 0x0
> >
> > This is caused by the fact that we succeed in allocating inode in
> > ocfs2_mknod_locked but later fail to allocate block for symlink data
> > or directory data because of ENOSPC. So we set i_nlink to 0 and
> > by doing iput() we continue through standard inode deletion path but the
> > inode is not orphaned and thus the error check is triggered.
> >
> > Now this isn't trivial to fix (at least AFAICS) so I wanted to share my
> > thoughts before investing too much time in writing the patch which would
> > be then rejected.
> >
> > The easiest solution would be to always create inodes in the orphan
> > directory (we even have a function ocfs2_create_inode_in_orphan for
> > this). The downside this has would be that I expect we would start
> > contending on orphan dir i_mutex quite early and thus fs scalability
> > would suffer a lot. Also there's some additional IO and CPU cost
> > involved...
> >
> > Adding inode to orphan dir after we find out we cannot finish allocation
> > is IMHO no-go. Because the filesystem is close to ENOSPC, we even don't
> > have to have a block to extend orphan directory to accomodate new
> > directory entry. Also adding to orphan directory has to happen outside of
> > a transaction (due to lock ordering) but we have a transaction already
> > started and cannot stop it without adding a link to the inode somewhere
> > (otherwise we would leak the inode in case of crash).
> >
> > The last idea I have is that we could "undo" the inode allocation and
> > other operations we did in the transaction so far. But looking at the
> > code it would get nasty quickly - all the xattr handling which gets inode
> > locks, starts & stops transactions, etc...
> >
> > Any other ideas? What would make things much easier would be if orphan
> > handling was more lightweight like it is e.g. in ext3 / ext4 - there we
> > have just linked list of orphaned inodes and so if we decide an inode
> > needs to be orphaned, we just have to modify the superblock (orphan list
> > head) and the inode (to point at the current orphan list head)... In
> > OCFS2 we could have a per-slot lists like this but a change like this
> > would probably be an overkill for the above bug so it would make sence
> > only if there would be other benefits from this.
> 
> Flag the failed inodes in memory (see ocfs2_inode_info->ip_flags) and
> special case it in ocfs2_delete_inode(). That's the easiest way to go about
> this without impacting performance. Then our window for leaking blocks is
> only if the box takes a reboot (or crash) right before we hit
> delete_inode(). That's an acceptable risk (we're talking a very small
>  number of blocks and a very small window of time).
> 	--Mark
I think we have the same issue with ocfs2_mknod,
but there is a bit difference with ocfs2_mknod:
we will mutex_lock(&alloc_inode->i_mutex) earlier in ocfs2_mknod,
the call trace is: ocfs2_mknod -> ocfs2_reserve_new_inode -> 
ocfs2_reserve_suballoc_bits
and we will mutex_unlock it in ocfs2_free_alloc_context(inode_ac) later in 
ocfs2_mknod after the potential iput().
the problem is iput() might trigger ocfs2_delete_inode with will try to 
mutex_lock before we unlock it by ocfs2_free_alloc_context(inode_ac), the call 
trace is: ocfs2_delete_inode -> ocfs2_wipe_inode -> ocfs2_remove_inode

so I think for ocfs2_mknod, we shoud call ocfs2_free_alloc_context to 
mutex_unlock before we check the return value and call iput.

Li Dongyang
> 
> --
> Mark Fasheh
> 
