From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Tue, 12 Jan 2010 11:58:35 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix __ocfs2_cluster_lock()
	dead	lock
In-Reply-To: <20100112015946.GE20285@mail.oracle.com>
References: <201001060835.o067n0EO000623@rcsinet13.oracle.com>
	<20100107020005.GC20095@mail.oracle.com>
	<20100109180521.GA5148@laptop.oracle.com>
	<20100112015946.GE20285@mail.oracle.com>
Message-ID: <20100112035835.GA3675@laptop.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel,

On 10-01-11 17:59, Joel Becker wrote:
> [Cc'd Mark and Dave]
> 
> On Sun, Jan 10, 2010 at 02:05:22AM +0800, Wengang Wang wrote:
> > > 2) It sure looks like you're right.
> > well, this doesn't sounds like a sob :)
> 
> 	With good reason, too.  You've got a bug.  Dave Teigland (copied
> now) found it while testing with fs/dlm.
> 	The short description is that you didn't notice the handling of
> async -EAGAIN.  Not really your fault, there are no obvious comments.
> With o2dlm, you get -EAGAIN from the call to ocfs2_dlm_lock().  That's
> safe with your patch.  However, with fs/dlm, EAGAIN comes
> asynchronously.  ocfs2_dlm_lock() will return 0.  When the ast fires,
> the ast notices the -EAGAIN and clears the locking state for a retry.
> In your patch, however, you take the 'lock_done' + !BUSY and immediately
> increment the holders - even though the lock hasn't been acquired!

ah, yes. I fault.
I should check more deeper.

> 	The fix is pretty simple, though - when lock_done is set, you
> know we've at least tried to upconvert.  If the locking level is good,
> we know the upconvert succeeded.  We can then go to inc_holders.  I've
> attached a new version of your patch that does this.
> 	I've also modified the patch to reflect that the original
> problem you found is actually a livelock, not a deadlock.  And I added a
> little comment about the async -EAGAIN.
> 	I've attached the full patch with my changes.  Dave, please test
> my version (the attached one) instead of Wengang's.  Mark, can you do a
> sanity check here?
> 	Here's the diff between your patch and mine:

snip...

> Date: Wed, 6 Jan 2010 16:34:44 +0800
> Subject: [PATCH] ocfs2: fix __ocfs2_cluster_lock() livelock
> 
> There is livelock possibility in __ocfs2_cluster_lock().  Here's what
> happens:
> 
> 1) node A(the lock owner) is doing an up-convert(UC, PR->EX). it gets
> the lock but doesn't check BUSY again because the level is right.
> 
> 2) node B requested an UC on the same lock resource. since node A has an
> EX on the lockres, a bast is issued and OCFS2_LOCK_BLOCKED flag is set
> to the lockres meanting that a DC is should be done. the DC asks for
> agreement of node A to release EX.  The downconvert starts because BUSY
> is cleared by the ast.
> 
> 3) the UC on node A runs into the check of OCFS2_LOCK_BLOCKED:
> 
>         if (lockres->l_flags & OCFS2_LOCK_BLOCKED &&
>             !ocfs2_may_continue_on_blocked_lock(lockres, level)) {
> 
> analysis:
> the BLOCKED flag is set in 2), and the UC can't continue to get the lock
> (ocfs2_may_continue_on_blocked_lock() returns false), so it waits on the
> DC to finish.
> 
> 4) The DC finishes, and BLOCKED is cleared.  The UC on node A starts over
>    getting the UC, now from NL->EX.  It asks node B for the lock.

I am wondering why DC can finish.
although BUSY is cleared. I think the check_downconvert() should return
false since we have not done whatever we want to do. and then the DC should
be requeued.

#don't hate me if I am wrong/stupid :)

regards,
wengang.
