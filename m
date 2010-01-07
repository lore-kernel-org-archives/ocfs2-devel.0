From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 6 Jan 2010 18:00:06 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix __ocfs2_cluster_lock() dead
 lock
In-Reply-To: <201001060835.o067n0EO000623@rcsinet13.oracle.com>
References: <201001060835.o067n0EO000623@rcsinet13.oracle.com>
Message-ID: <20100107020005.GC20095@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jan 06, 2010 at 04:34:44PM +0800, Wengang Wang wrote:
> there is deadlock possibility in __ocfs2_cluster_lock().
> the case is like following.
> 
> #in time order
> 1) node A(the lock owner) is doing an up-convert(UC, PR->EX). it got the lock
> but didn't check BUSY flag again.
> 
> 2) node B requested an UC on the same lock resource. since node A has an EX on
> the lockres, a bast is issued and OCFS2_LOCK_BLOCKED flag is set to the lockres
> meanting that a DC is should be done. the DC asks for agreement of node A to
> release EX. and for now node A refuses that(still in process of getting that
> lock:) ).
> 
> 3) the UC on node A runs into the phrase of checking OCFS2_LOCK_BLOCKED flag and
> if it can continue without waiting for any DC. code is:
> 
>         if (lockres->l_flags & OCFS2_LOCK_BLOCKED &&
>             !ocfs2_may_continue_on_blocked_lock(lockres, level)) {
> 
> analysis:
> the BLOCKED flag is set in 2), and the UC can't continue to get the lock(
> ocfs2_may_continue_on_blocked_lock() returns false), so it the DC to finish.
> 
> so both UC and DC are waiting for each other --a dead lock.

1) Do you have a test case?  Have you seen this happen, or are you just
   postulating from reading the code?
2) It sure looks like you're right.
3) I hate our locking spaghetti!

Joel

-- 

"I don't know anything about music. In my line you don't have
 to."
        - Elvis Presley

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
