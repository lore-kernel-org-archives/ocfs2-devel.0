From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Tue, 12 Jan 2010 20:04:19 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix __ocfs2_cluster_lock()
	dead	lock
In-Reply-To: <20100112111802.GB3821@mail.oracle.com>
References: <201001060835.o067n0EO000623@rcsinet13.oracle.com>
	<20100107020005.GC20095@mail.oracle.com>
	<20100109180521.GA5148@laptop.oracle.com>
	<20100112015946.GE20285@mail.oracle.com>
	<20100112035835.GA3675@laptop.oracle.com>
	<20100112111802.GB3821@mail.oracle.com>
Message-ID: <20100112120419.GA4209@laptop.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel,

On 10-01-12 03:18, Joel Becker wrote:
> > > Date: Wed, 6 Jan 2010 16:34:44 +0800
> > > Subject: [PATCH] ocfs2: fix __ocfs2_cluster_lock() livelock
> > > 
> > > There is livelock possibility in __ocfs2_cluster_lock().  Here's what
> > > happens:
> > > 
> > > 1) node A(the lock owner) is doing an up-convert(UC, PR->EX). it gets
> > > the lock but doesn't check BUSY again because the level is right.
> > > 
> > > 2) node B requested an UC on the same lock resource. since node A has an
> > > EX on the lockres, a bast is issued and OCFS2_LOCK_BLOCKED flag is set
> > > to the lockres meanting that a DC is should be done. the DC asks for
> > > agreement of node A to release EX.  The downconvert starts because BUSY
> > > is cleared by the ast.
> > > 
> > > 3) the UC on node A runs into the check of OCFS2_LOCK_BLOCKED:
> > > 
> > >         if (lockres->l_flags & OCFS2_LOCK_BLOCKED &&
> > >             !ocfs2_may_continue_on_blocked_lock(lockres, level)) {
> > > 
> > > analysis:
> > > the BLOCKED flag is set in 2), and the UC can't continue to get the lock
> > > (ocfs2_may_continue_on_blocked_lock() returns false), so it waits on the
> > > DC to finish.
> > > 
> > > 4) The DC finishes, and BLOCKED is cleared.  The UC on node A starts over
> > >    getting the UC, now from NL->EX.  It asks node B for the lock.
> > 
> > I am wondering why DC can finish.
> > although BUSY is cleared. I think the check_downconvert() should return
> > false since we have not done whatever we want to do. and then the DC should
> > be requeued.
> 
> 	DC thread only waits on PENDING and holders.  If BUSY, it will
> cancel the upconvert.  If not BUSY, it will schedule a downconvert.
> There's nothing stopping the downconvert, in other words.

I think I am talking about the scheduled downconvert. let me copy src here.
the downconvert kernel thread does a call stack like this:
ocfs2_downconvert_thread_do_work()
  -->ocfs2_process_blocked_lock
    -->ocfs2_unblock_lock()

in ocfs2_unblock_lock() there are lines after checking for BUSY flag:

        if (lockres->l_ops->check_downconvert
            && !lockres->l_ops->check_downconvert(lockres, new_level))
                goto leave_requeue;

[snip...]
leave_requeue:
        spin_unlock_irqrestore(&lockres->l_lock, flags);
        ctl->requeue = 1;

if ctl->requeue is set, ocfs2_schedule_blocked_lock() will add the
lockres to blocked_lock_list. the downconvert will then be rescheduled only
if ocfs2_wake_downconvert_thread() is called somewhere. 
in this simple case:
the "somewhere", I think, is in __ocfs2_cluster_unlock().
so before __ocfs2_cluster_unlock() is called(surely after
 __ocfs2_cluster_lock() returns), the downconvert couldn't
be rescheduled.
thus __ocfs2_cluster_lock() is waiting for DC to finish and the DC is
waiting __ocfs2_cluster_unlock() to be called. --deadlock.

so maybe you don't notice the lockres->l_ops->check_downconvert()?

> > #don't hate me if I am wrong/stupid :)
> 
> 	Won't hate you at all.  And you're not stupid even if you are
> wrong.  It's not easy code.  Heck, you may be right and I might be wrong
> in the end.  Remember, you found the bug in the first place!
> 
great!

regards,
wengang.
