From: Jan Kara <jack@suse.cz>
Date: Thu, 16 Jan 2014 03:47:43 +0100
Subject: [Ocfs2-devel] [PATCH] Revert iput deferring code in
	ocfs2_drop_dentry_lock
In-Reply-To: <52D71723.2080305@suse.de>
References: <20140115125144.GA2953@shrek.lan>
	<20140115133344.GB9141@quack.suse.cz> <52D6AA17.6040101@suse.de>
	<20140115155354.GB13988@quack.suse.cz> <52D71723.2080305@suse.de>
Message-ID: <20140116024743.GA25833@quack.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed 15-01-14 17:17:55, Goldwyn Rodrigues wrote:
> On 01/15/2014 09:53 AM, Jan Kara wrote:
> >On Wed 15-01-14 09:32:39, Goldwyn Rodrigues wrote:
> >>On 01/15/2014 07:33 AM, Jan Kara wrote:
> >>>On Wed 15-01-14 06:51:51, Goldwyn Rodrigues wrote:
> >>>>The following patches are reverted in this patch because these
> >>>>patches caused regression in the unlink() calls.
> >>>>
> >>>>ea455f8ab68338ba69f5d3362b342c115bea8e13 - ocfs2: Push out dropping
> >>>>of dentry lock to ocfs2_wq
> >>>>f7b1aa69be138ad9d7d3f31fa56f4c9407f56b6a - ocfs2: Fix deadlock on umount
> >>>>5fd131893793567c361ae64cbeb28a2a753bbe35 - ocfs2: Don't oops in
> >>>>ocfs2_kill_sb on a failed mount
> >>>>
> >>>>The regression is caused because these patches delay the iput() in case
> >>>>of dentry unlocks. This also delays the unlocking of the open lockres.
> >>>>The open lockresource is required to test if the inode can be wiped from
> >>>>disk on not. When the deleting node does not get the open lock, it marks
> >>>>it as orphan (even though it is not in use by another node/process)
> >>>>and causes a journal checkpoint. This delays operations following the
> >>>>inode eviction. This also moves the inode to the orphaned inode
> >>>>which further causes more I/O and a lot of unneccessary orphans.
> >>>>
> >>>>As for the fix, I tried reproducing the problem by using quotas and enabling
> >>>>lockdep, but the issue could not be reproduced.
> >>>   So I was thinking about this for a while trying to remember... What it
> >>>really boils down to is whether it is OK to call ocfs2_delete_inode() from
> >>>DLM downconvert thread. Bear in mind that ocfs2_delete_inode() takes all
> >>>kinds of interesting cluster locks meaning that the downconvert thread can
> >>>block waiting to acquire some cluster lock. That seems like asking for
> >>>trouble to me (i.e., what if the node holding the lock we need from
> >>>downconvert thread needs a lock from us first?) but maybe it is OK these
> >>>days.
> >>>
> >>
> >>The only lock it tries to take is the "inode lock" resource, which
> >>seems to be fine to take.
> >   Why is it obviously fine? Some other node might be holding the inode lock
> >and still write to the inode. If that needs a cluster lock for block
> >allocation and that allocation cluster lock is currently hold by our node,
> >we are screwed. Aren't we?
> >
> 
> No. If another thread is using the allocation cluster lock implies
> we already have the inode lock. Cluster locks are also taken in a
> strict order in order to avoid ABBA locking.
  I agree with what you wrote above but it's not exactly what I'm talking
about. What seems to be possible is:
NODE 1					NODE2
holds dentry lock for 'foo'
holds inode lock for GLOBAL_BITMAP_SYSTEM_INODE
					dquot_initialize(bar)
					  ocfs2_dquot_acquire()
					    ocfs2_inode_lock(USER_QUOTA_SYSTEM_INODE)
					    ...
downconvert thread (triggered from another
node or a different process from NODE2)
  ocfs2_dentry_post_unlock()
    ...
    iput(foo)
      ocfs2_evict_inode(foo)
        ocfs2_clear_inode(foo)
          dquot_drop(inode)
	    ...
            ocfs2_inode_lock(USER_QUOTA_SYSTEM_INODE)
             - blocks
					    finds we need more space in
					    quota file
					    ...
					    ocfs2_extend_no_holes()
					      ocfs2_inode_lock(GLOBAL_BITMAP_SYSTEM_INODE)
						- deadlocks waiting for
						  downconvert thread

However the positive part of this is that the race I was originally afraid
of - when ocfs2_delete_inode() would be triggered from
ocfs2_dentry_post_unlock() - isn't possible because ocfs2 seems to keep
invariant that node can cache dentry for 'foo' without holding inode lock
for 'foo' only if foo->i_nlink > 0. Thus iput() from downconvert thread
should never go into ocfs2_delete_inode() (however it would be nice to
assert this in ocfs2_dentry_post_unlock() for a peace of mind).

Since the deadlock seems to be quota specific, it should be possible
postpone just the quota processing for the workqueue. It isn't completely
trivial because we still have to cleanup inode quota pointers but it should
be doable. I'll try to have a look at this tomorrow.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
