From: Eric Ren <zren@suse.com>
Date: Tue, 8 Dec 2015 14:05:02 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: dlm: fix deadlock due to nested
	lock
In-Reply-To: <5666433F.8090702@oracle.com>
References: <1449132603-4918-1-git-send-email-junxiao.bi@oracle.com>
	<20151204100741.GA6221@laptop.ha> <56652AC5.3080903@oracle.com>
	<20151207090118.GA4655@laptop.ha> <5666433F.8090702@oracle.com>
Message-ID: <20151208060502.GB19932@desktop.lab.bej.apac.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi junxiao,

On Tue, Dec 08, 2015 at 10:41:03AM +0800, Junxiao Bi wrote: 
> Hi Eric,
> 
> On 12/07/2015 05:01 PM, Eric Ren wrote:
> > Hi Junxiao,
> > 
> > On Mon, Dec 07, 2015 at 02:44:21PM +0800, Junxiao Bi wrote: 
> >> Hi Eric,
> >>
> >> On 12/04/2015 06:07 PM, Eric Ren wrote:
> >>> Hi Junxiao,
> >>>
> >>> The patch is likely unfair to the blocked lock on remote node(node Y in 
> >>> your case). The original code let the second request to go only if it's
> >>> compatible with the predicting level we would downconvert for node Y.
> >>> Considering more extremer situation, there're more acquiring from node
> >>> X, that way node Y could heavily starve, right?
> >> With this fix, lock request is not blocked if ex_holders and ro_holders
> >> not zero. So if new lock request is always coming before old lock is
> > Yes.
> >> released, node Y will starve. Could this happen in a real user case?
> > Actually, we're suffering from a customer's complaint about long time
> > IO delay peak when R/W access the same file from different nodes. By
> > peak, I mean for most of time, the IO time of both R/W is acceptable,
> > but there may be a long time delay occuring occasionally.
> > 
> > On sles10, that's before dlmglue layer introduced, the R/W time is very
> > constant and fair in this case. Though the throughoutput looks improved
> > now, but the comstomer still prefers consistent performance.
> I think the peak latency may be caused by downconvert, To downconvert a
> EX lock, all dirty data needs be flushed to the disk. So the latency
> depends on how much dirty data there is.
Yes, absolutely, but it's still possible that other factors may contribute to this
problem.
> 
> > 
> > I also tested this patch, and it could worsen the situation on my side.
> > Could you have a test so that we can confirm this each other if needed?
> I don't have a test case for it. Can you share yours and your perf data?
> If there is a starvation, I may need add a pid checking to cluster lock
> where not block nested locking in one process.
Sure, but the code is not written by me;-) you can get it here[1].
And the perf data is only useful when making comparasion in my environment.

[1] https://github.com/renzhengeek/zhen-coding/tree/master/test

Thanks,
Eric
> 
> Thanks,
> Junxiao.
> >>
> >> I think there would be a window where locks are released, at that time,
> >> node Y could get the lock. Indeed ping-pang locking between nodes will
> >> hurt performance, so holding a lock in a node for a short while will be
> >> good to performance.
> >>>
> >>> Just tring to provide some thoughts on this;-)
> >> That's good. Thank you for the review.
> >>>
> >>> On Thu, Dec 03, 2015 at 04:50:03PM +0800, Junxiao Bi wrote: 
> >>>> DLM allows nested cluster locking. One node X can acquire a cluster lock
> >>>> two times before release it. But between these two acquiring, if another
> >>>> node Y asks for the same lock and is blocked, then a bast will be sent to
> >>>> node X and OCFS2_LOCK_BLOCKED will be set in that lock's lockres. In this
> >>>> case, the second acquiring of that lock in node X will cause a deadlock.
> >>>> Not block for nested locking can fix this.
> >>> Could you please describe the deadlock more specifically?
> >> Process A on node X           Process B on node Y
> >> lock_XYZ(EX)
> >>                               lock_XYZ(EX)
> >> lock_XYZ(EX)  >>>> blocked forever
> > Thanks! Yeah, it's really bad...
> >>
> >>>>
> >>>> Use ocfs2-test multiple reflink test can reproduce this on v4.3 kernel,
> >>>> the whole cluster hung, and get the following call trace.
> >>> Could the deaklock happen on other older kernel? Because I didn't see this
> >>> issue when testing reflink on multiple nodes on older kernel.
> >> We never reproduce this on old kernels. commit 743b5f1434f5 is the key
> >> to reproduce this issue. As it locks one cluster lock twice in one
> >> process before releasing it.
> > Got it, thanks!
> > 
> > Thanks,
> > Eric
> >>
> >> Thanks,
> >> Junxiao.
> >>>
> >>> Thanks,
> >>> Eric
> >>>>
> >>>>  INFO: task multi_reflink_t:10118 blocked for more than 120 seconds.
> >>>>        Tainted: G           OE   4.3.0 #1
> >>>>  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >>>>  multi_reflink_t D ffff88003e816980     0 10118  10117 0x00000080
> >>>>   ffff880005b735f8 0000000000000082 ffffffff81a25500 ffff88003e750000
> >>>>   ffff880005b735c8 ffffffff8117992f ffffea0000929f80 ffff88003e816980
> >>>>   7fffffffffffffff 0000000000000000 0000000000000001 ffffea0000929f80
> >>>>  Call Trace:
> >>>>   [<ffffffff8117992f>] ? find_get_entry+0x2f/0xc0
> >>>>   [<ffffffff816a68fe>] schedule+0x3e/0x80
> >>>>   [<ffffffff816a9358>] schedule_timeout+0x1c8/0x220
> >>>>   [<ffffffffa067eee4>] ? ocfs2_inode_cache_unlock+0x14/0x20 [ocfs2]
> >>>>   [<ffffffffa06bb1e9>] ? ocfs2_metadata_cache_unlock+0x19/0x30 [ocfs2]
> >>>>   [<ffffffffa06bb399>] ? ocfs2_buffer_cached+0x99/0x170 [ocfs2]
> >>>>   [<ffffffffa067eee4>] ? ocfs2_inode_cache_unlock+0x14/0x20 [ocfs2]
> >>>>   [<ffffffffa06bb1e9>] ? ocfs2_metadata_cache_unlock+0x19/0x30 [ocfs2]
> >>>>   [<ffffffff810c5f41>] ? __raw_callee_save___pv_queued_spin_unlock+0x11/0x20
> >>>>   [<ffffffff816a78ae>] wait_for_completion+0xde/0x110
> >>>>   [<ffffffff810a81b0>] ? try_to_wake_up+0x240/0x240
> >>>>   [<ffffffffa066f65d>] __ocfs2_cluster_lock+0x20d/0x720 [ocfs2]
> >>>>   [<ffffffff810c5f41>] ? __raw_callee_save___pv_queued_spin_unlock+0x11/0x20
> >>>>   [<ffffffffa0674841>] ocfs2_inode_lock_full_nested+0x181/0x400 [ocfs2]
> >>>>   [<ffffffffa06d0db3>] ? ocfs2_iop_get_acl+0x53/0x113 [ocfs2]
> >>>>   [<ffffffff81210cd2>] ? igrab+0x42/0x70
> >>>>   [<ffffffffa06d0db3>] ocfs2_iop_get_acl+0x53/0x113 [ocfs2]
> >>>>   [<ffffffff81254583>] get_acl+0x53/0x70
> >>>>   [<ffffffff81254923>] posix_acl_create+0x73/0x130
> >>>>   [<ffffffffa068f0bf>] ocfs2_mknod+0x7cf/0x1140 [ocfs2]
> >>>>   [<ffffffffa068fba2>] ocfs2_create+0x62/0x110 [ocfs2]
> >>>>   [<ffffffff8120be25>] ? __d_alloc+0x65/0x190
> >>>>   [<ffffffff81201b3e>] ? __inode_permission+0x4e/0xd0
> >>>>   [<ffffffff81202cf5>] vfs_create+0xd5/0x100
> >>>>   [<ffffffff812009ed>] ? lookup_real+0x1d/0x60
> >>>>   [<ffffffff81203a03>] lookup_open+0x173/0x1a0
> >>>>   [<ffffffff810c59c6>] ? percpu_down_read+0x16/0x70
> >>>>   [<ffffffff81205fea>] do_last+0x31a/0x830
> >>>>   [<ffffffff81201b3e>] ? __inode_permission+0x4e/0xd0
> >>>>   [<ffffffff81201bd8>] ? inode_permission+0x18/0x50
> >>>>   [<ffffffff812046b0>] ? link_path_walk+0x290/0x550
> >>>>   [<ffffffff8120657c>] path_openat+0x7c/0x140
> >>>>   [<ffffffff812066c5>] do_filp_open+0x85/0xe0
> >>>>   [<ffffffff8120190f>] ? getname_flags+0x7f/0x1f0
> >>>>   [<ffffffff811f613a>] do_sys_open+0x11a/0x220
> >>>>   [<ffffffff8100374b>] ? syscall_trace_enter_phase1+0x15b/0x170
> >>>>   [<ffffffff811f627e>] SyS_open+0x1e/0x20
> >>>>   [<ffffffff816aa2ae>] entry_SYSCALL_64_fastpath+0x12/0x71
> >>>>
> >>>> commit 743b5f1434f5 ("ocfs2: take inode lock in ocfs2_iop_set/get_acl()")
> >>>> add a nested locking to ocfs2_mknod() which exports this deadlock, but
> >>>> indeed this is a common issue, it can be triggered in other place.
> >>>>
> >>>> Cc: <stable@vger.kernel.org>
> >>>> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> >>>> ---
> >>>>  fs/ocfs2/dlmglue.c |    4 +++-
> >>>>  1 file changed, 3 insertions(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> >>>> index 1c91103..5b7d9d4 100644
> >>>> --- a/fs/ocfs2/dlmglue.c
> >>>> +++ b/fs/ocfs2/dlmglue.c
> >>>> @@ -1295,7 +1295,9 @@ static inline int ocfs2_may_continue_on_blocked_lock(struct ocfs2_lock_res *lock
> >>>>  {
> >>>>  	BUG_ON(!(lockres->l_flags & OCFS2_LOCK_BLOCKED));
> >>>>  
> >>>> -	return wanted <= ocfs2_highest_compat_lock_level(lockres->l_blocking);
> >>>> +	/* allow nested lock request go to avoid deadlock. */
> >>>> +	return wanted <= ocfs2_highest_compat_lock_level(lockres->l_blocking)
> >>>> +		|| lockres->l_ro_holders || lockres->l_ex_holders;
> >>>>  }
> >>>>  
> >>>>  static void ocfs2_init_mask_waiter(struct ocfs2_mask_waiter *mw)
> >>>> -- 
> >>>> 1.7.9.5
> >>>>
> >>>>
> >>>> _______________________________________________
> >>>> Ocfs2-devel mailing list
> >>>> Ocfs2-devel at oss.oracle.com
> >>>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> >>>>
> >>
> >>
> >> _______________________________________________
> >> Ocfs2-devel mailing list
> >> Ocfs2-devel at oss.oracle.com
> >> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> >>
> > 
> > _______________________________________________
> > Ocfs2-devel mailing list
> > Ocfs2-devel at oss.oracle.com
> > https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> > 
> 
> 
