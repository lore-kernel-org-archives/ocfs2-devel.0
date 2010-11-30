From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 30 Nov 2010 11:24:05 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: queue ast in lockres->spinlock
In-Reply-To: <201011301551.oAUD3n5c002863@rcsinet13.oracle.com>
References: <201011301551.oAUD3n5c002863@rcsinet13.oracle.com>
Message-ID: <4CF54F55.8080007@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

http://oss.oracle.com/pipermail/ocfs2-devel/2010-January/005801.html

The above bug/fix fits better.

Having said that, I am not discounting your point. But I will need more
to analyse it. Questions inlined.

On 11/30/2010 07:48 AM, Wengang Wang wrote:
> There is bug hitting the BUG() in ocfs2_prepare_downconvert(), in 1.4 code
> though.
>
> static unsigned int ocfs2_prepare_downconvert(struct ocfs2_lock_res *lockres,
>                                                int new_level)
> {
>          assert_spin_locked(&lockres->l_lock);
>
>          BUG_ON(lockres->l_blocking<= DLM_LOCK_NL);
>
>          if (lockres->l_level<= new_level) {
>                  mlog(ML_ERROR, "lockres %s, lvl %d<= %d, blcklst %d, mask %d, "
>                       "type %d, flags 0x%lx, hold %d %d, act %d %d, req %d, "
>                       "block %d, pgen %d\n", lockres->l_name, lockres->l_level,
>                       new_level, list_empty(&lockres->l_blocked_list),
>                       list_empty(&lockres->l_mask_waiters), lockres->l_type,
>                       lockres->l_flags, lockres->l_ro_holders,
>                       lockres->l_ex_holders, lockres->l_action,
>                       lockres->l_unlock_action, lockres->l_requested,
>                       lockres->l_blocking, lockres->l_pending_gen);
>                  BUG();
>          }
> ....
>
> By checking vmcore, lockres->l_level == new_level == 0.
>
> Though no tcpdump shows that, I think it's caused by a BAST before AST.
> It can happen in the following case(steps in time order):
>
> 1) Node A send a "up convert" request(for a EX) to the master node, node B.
>
> 2) Node C send a "create lock" request(for a PR) to the master node, node B
> against the same lockres.
>
> 3) The "convert request" was added to dlm_thread because the lock can't be
> granted immediately. So that the "create lock" thread and the "up convert"
> thread can run in parallel.
>
> 4) the "create lock" thread get the lockres->spinlock and found no conflict for
> the lock request, so it put the lock to granted list. then lockres->spinlock is
> released. (see dlmlock_master()).
>
> 5) the dlm_thread get the spinlcok and found the conflict lock, which was
> granted in 4), and queue a BAST that will send to node C.
> (see dlm_shuffle_lists()).
>
> 6) the "create lock" thread then continue to queue the AST for the granted lock
> to node C. So the BAST and AST come to Node C in order.
>
> 7) node C crashes when responding the BAST.

So in your scenario, the upconvert request is before create lock. If that is
so, then even if the new level cannot be granted, the lock will be moved
to the convert queue. The create lock request is always added to the
blocked queue which always has the lowest priority.

Note that the dlm always processes convert queues before blocked queues.
Also, o2dlm, always processes all ASTs before BASTs.

That is not to say what you have said cannot happen. But I will need more
information. Like, Node A was up converting to EX from what level? Were
there any other locks on the resource?

>
> This patch tries to fix it by moving the queue_ast into protection of
> lockres->spinlock.
>
> This patch is based on
> http://oss.oracle.com/pipermail/ocfs2-devel/2010-November/007523.html
> Otherwise, it could cause deadlock.(by different order of lockres->spinlock and
> dlm->ast_lock)
>
> Signed-off-by: Wengang Wang<wen.gang.wang@oracle.com>
> ---
>   fs/ocfs2/dlm/dlmconvert.c |   14 ++++++--------
>   fs/ocfs2/dlm/dlmlock.c    |    6 ++----
>   2 files changed, 8 insertions(+), 12 deletions(-)
>
> diff --git a/fs/ocfs2/dlm/dlmconvert.c b/fs/ocfs2/dlm/dlmconvert.c
> index 9f30491..ff0b84f 100644
> --- a/fs/ocfs2/dlm/dlmconvert.c
> +++ b/fs/ocfs2/dlm/dlmconvert.c
> @@ -90,15 +90,14 @@ enum dlm_status dlmconvert_master(struct dlm_ctxt *dlm,
>   				&call_ast,&kick_thread);
>
>   	res->state&= ~DLM_LOCK_RES_IN_PROGRESS;
> +	if (call_ast)
> +		dlm_queue_ast(dlm, lock);
>   	spin_unlock(&res->spinlock);
>   	wake_up(&res->wq);
>   	if (status != DLM_NORMAL&&  status != DLM_NOTQUEUED)
>   		dlm_error(status);
>
> -	/* either queue the ast or release it */
> -	if (call_ast)
> -		dlm_queue_ast(dlm, lock);
> -	else
> +	if (!call_ast)
>   		dlm_lockres_release_ast(dlm, res);
>
>   	if (kick_thread)
> @@ -514,6 +513,8 @@ int dlm_convert_lock_handler(struct o2net_msg *msg, u32 len, void *data,
>   					     cnv->requested_type,
>   					&call_ast,&kick_thread);
>   		res->state&= ~DLM_LOCK_RES_IN_PROGRESS;
> +		if (call_ast)
> +			dlm_queue_ast(dlm, lock);
>   		wake = 1;
>   	}
>   	spin_unlock(&res->spinlock);
> @@ -530,10 +531,7 @@ leave:
>   	if (lock)
>   		dlm_lock_put(lock);
>
> -	/* either queue the ast or release it, if reserved */
> -	if (call_ast)
> -		dlm_queue_ast(dlm, lock);
> -	else if (ast_reserved)
> +	if ((!call_ast)&&  ast_reserved)
>   		dlm_lockres_release_ast(dlm, res);
>
>   	if (kick_thread)
> diff --git a/fs/ocfs2/dlm/dlmlock.c b/fs/ocfs2/dlm/dlmlock.c
> index 69cf369..f84d1fb 100644
> --- a/fs/ocfs2/dlm/dlmlock.c
> +++ b/fs/ocfs2/dlm/dlmlock.c
> @@ -157,6 +157,7 @@ static enum dlm_status dlmlock_master(struct dlm_ctxt *dlm,
>   		if (!dlm_is_recovery_lock(res->lockname.name,
>   					  res->lockname.len)) {
>   			kick_thread = 1;
> +			dlm_queue_ast(dlm, lock);
>   			call_ast = 1;
>   		} else {
>   			mlog(0, "%s: returning DLM_NORMAL to "
> @@ -188,10 +189,7 @@ static enum dlm_status dlmlock_master(struct dlm_ctxt *dlm,
>   	spin_unlock(&res->spinlock);
>   	wake_up(&res->wq);
>
> -	/* either queue the ast or release it */
> -	if (call_ast)
> -		dlm_queue_ast(dlm, lock);
> -	else
> +	if (!call_ast)
>   		dlm_lockres_release_ast(dlm, res);
>
>   	dlm_lockres_calc_usage(dlm, res);
