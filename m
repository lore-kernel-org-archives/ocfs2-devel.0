From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Mon, 24 May 2010 22:41:01 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2/dlm: resend deref to new master
 if recovery occures
In-Reply-To: <201005241436.o4OAZKAW024757@acsinet15.oracle.com>
References: <201005241436.o4OAZKAW024757@acsinet15.oracle.com>
Message-ID: <20100524144101.GA8642@laptop.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

s/ignore/ignoring/g  for the following 2 lines. 
> When purge a lockres, we unhash the lockres ignore the result of deref request
> and ignore the lockres state.

regards,
wengang.

> There is a problem that rarely happen. It can happen when recovery take places.
> Say node A is the master of the lockres with node B wants to deref and there is
> a node C. If things happen in the following order, the bug is triggered.
> 
> 1) node B send DEREF to node A for lockres A and waiting for result.
> 2) node A crashed, node C become the recovery master.
> 3) node C mastered lockres A with node B has a ref on it.
> 4) node B goes to unhashes the lockres A with a ref on node C.
>  
> After step 4), if a umount comes on node C, it will hang at migrate lockres A 
> since node B has a ref on it.
> 
> The fix is that we check if recovery happened on lockres A after sending DEREF
> request. If that happened, we keep lockres A in hash and in purge list for
> another try to send DEREF to the new master(node C). So that node C can clear
> the incorrect refbit.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
>  fs/ocfs2/dlm/dlmthread.c |   44 +++++++++++++++++++++++++++++++++++++++-----
>  1 files changed, 39 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
> index d4f73ca..946ff1a 100644
> --- a/fs/ocfs2/dlm/dlmthread.c
> +++ b/fs/ocfs2/dlm/dlmthread.c
> @@ -158,6 +158,8 @@ static int dlm_purge_lockres(struct dlm_ctxt *dlm,
>  	int master;
>  	int ret = 0;
>  
> +	assert_spin_locked(&dlm->spinlock);
> +
>  	spin_lock(&res->spinlock);
>  	if (!__dlm_lockres_unused(res)) {
>  		mlog(0, "%s:%.*s: tried to purge but not unused\n",
> @@ -211,18 +213,30 @@ static int dlm_purge_lockres(struct dlm_ctxt *dlm,
>  	}
>  
>  	spin_lock(&res->spinlock);
> +	/*
> +	 * we dropped dlm->spinlock and res->spinlock when sending the DEREF
> +	 * request, there is a chance that a recovery happend on this lockres.
> +	 * in that case, we have to DEREF to the new master when recovery
> +	 * finished. otherwise, there can be an incorrect ref on the lockres
> +	 * on the new master  on behalf of this node.
> +	 */
> +	if (unlikely(res->state & DLM_LOCK_RES_RECOVERING)) {
> +		spin_unlock(&res->spinlock);
> +		return -EAGAIN;
> +	}
> +
>  	if (!list_empty(&res->purge)) {
>  		mlog(0, "removing lockres %.*s:%p from purgelist, "
>  		     "master = %d\n", res->lockname.len, res->lockname.name,
>  		     res, master);
>  		list_del_init(&res->purge);
> -		spin_unlock(&res->spinlock);
> +		/* not the last ref */
>  		dlm_lockres_put(res);
>  		dlm->purge_count--;
> -	} else
> -		spin_unlock(&res->spinlock);
> +	}
>  
>  	__dlm_unhash_lockres(res);
> +	spin_unlock(&res->spinlock);
>  
>  	/* lockres is not in the hash now.  drop the flag and wake up
>  	 * any processes waiting in dlm_get_lock_resource. */
> @@ -241,6 +255,9 @@ static void dlm_run_purge_list(struct dlm_ctxt *dlm,
>  	unsigned int run_max, unused;
>  	unsigned long purge_jiffies;
>  	struct dlm_lock_resource *lockres;
> +	int ret;
> +
> +#define DLM_WAIT_RECOVERY_FINISH_MS 500
>  
>  	spin_lock(&dlm->spinlock);
>  	run_max = dlm->purge_count;
> @@ -280,8 +297,25 @@ static void dlm_run_purge_list(struct dlm_ctxt *dlm,
>  
>  		/* This may drop and reacquire the dlm spinlock if it
>  		 * has to do migration. */
> -		if (dlm_purge_lockres(dlm, lockres))
> -			BUG();
> +		ret = dlm_purge_lockres(dlm, lockres);
> +		if (ret) {
> +			if (ret == -EAGAIN) {
> +				/*
> +				 * recovery occured on this lockres. try to
> +				 * DEREF to the new master.
> +				 */
> +				dlm_lockres_put(lockres);
> +				spin_unlock(&dlm->spinlock);
> +				mlog(ML_ERROR, "retry to purge %.*s after %d"
> +				     "ms\n", lockres->lockname.len,
> +				     lockres->lockname.name,
> +				     DLM_WAIT_RECOVERY_FINISH_MS);
> +				msleep(DLM_WAIT_RECOVERY_FINISH_MS);
> +				spin_lock(&dlm->spinlock);
> +				continue;
> +			} else
> +				BUG();
> +		}
>  
>  		dlm_lockres_put(lockres);
>  
> -- 
> 1.6.6.1
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
