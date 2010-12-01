From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Wed, 1 Dec 2010 10:52:18 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: queue ast in lockres->spinlock
In-Reply-To: <4CF54F55.8080007@oracle.com>
References: <201011301551.oAUD3n5c002863@rcsinet13.oracle.com>
	<4CF54F55.8080007@oracle.com>
Message-ID: <20101201025218.GA3709@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10-11-30 11:24, Sunil Mushran wrote:
> http://oss.oracle.com/pipermail/ocfs2-devel/2010-January/005801.html
> 
> The above bug/fix fits better.
> 
> Having said that, I am not discounting your point. But I will need more
> to analyse it. Questions inlined.
> 
> On 11/30/2010 07:48 AM, Wengang Wang wrote:
> >There is bug hitting the BUG() in ocfs2_prepare_downconvert(), in 1.4 code
> >though.
> >
> >static unsigned int ocfs2_prepare_downconvert(struct ocfs2_lock_res *lockres,
> >                                               int new_level)
> >{
> >         assert_spin_locked(&lockres->l_lock);
> >
> >         BUG_ON(lockres->l_blocking<= DLM_LOCK_NL);
> >
> >         if (lockres->l_level<= new_level) {
> >                 mlog(ML_ERROR, "lockres %s, lvl %d<= %d, blcklst %d, mask %d, "
> >                      "type %d, flags 0x%lx, hold %d %d, act %d %d, req %d, "
> >                      "block %d, pgen %d\n", lockres->l_name, lockres->l_level,
> >                      new_level, list_empty(&lockres->l_blocked_list),
> >                      list_empty(&lockres->l_mask_waiters), lockres->l_type,
> >                      lockres->l_flags, lockres->l_ro_holders,
> >                      lockres->l_ex_holders, lockres->l_action,
> >                      lockres->l_unlock_action, lockres->l_requested,
> >                      lockres->l_blocking, lockres->l_pending_gen);
> >                 BUG();
> >         }
> >....
> >
> >By checking vmcore, lockres->l_level == new_level == 0.
> >
> >Though no tcpdump shows that, I think it's caused by a BAST before AST.
> >It can happen in the following case(steps in time order):
> >
> >1) Node A send a "up convert" request(for a EX) to the master node, node B.
> >
> >2) Node C send a "create lock" request(for a PR) to the master node, node B
> >against the same lockres.
> >
> >3) The "convert request" was added to dlm_thread because the lock can't be
> >granted immediately. So that the "create lock" thread and the "up convert"
> >thread can run in parallel.
> >
> >4) the "create lock" thread get the lockres->spinlock and found no conflict for
> >the lock request, so it put the lock to granted list. then lockres->spinlock is
> >released. (see dlmlock_master()).
> >
> >5) the dlm_thread get the spinlcok and found the conflict lock, which was
> >granted in 4), and queue a BAST that will send to node C.
> >(see dlm_shuffle_lists()).
> >
> >6) the "create lock" thread then continue to queue the AST for the granted lock
> >to node C. So the BAST and AST come to Node C in order.
> >
> >7) node C crashes when responding the BAST.
> 
> So in your scenario, the upconvert request is before create lock. If that is
> so, then even if the new level cannot be granted, the lock will be moved
> to the convert queue. The create lock request is always added to the
> blocked queue which always has the lowest priority.
> 
> Note that the dlm always processes convert queues before blocked queues.
> Also, o2dlm, always processes all ASTs before BASTs.
> 
> That is not to say what you have said cannot happen. But I will need more
> information. Like, Node A was up converting to EX from what level? Were
> there any other locks on the resource?
> 

First I have to say that the scenario is in my thought only, no tcpdump
shows that. Only the node C wanting a PR is the truth from the vmcore.

Let's consider this situation:

The create lock(CL) is for a PR;
the up convert(UC) is PR->EX;
there is an existing PR granted for another node(say node D) before the UC comes

The UC comes. Because of the existing PR, the UC lock is moved to converting list.
dlm_thread takes care it later.
The CL comes. no conflict found(see dlm_can_grant_new_lock, convert_type not
checked there). so it's not added to blocked list.

Seems the above scenario can trigger a BAST before AST.

regards,
wengang.
