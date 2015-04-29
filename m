From: Mark Fasheh <mfasheh@suse.de>
Date: Wed, 29 Apr 2015 14:44:40 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: fix race between purge and get
 lock resource
In-Reply-To: <553B3CAB.9020102@huawei.com>
References: <553B3CAB.9020102@huawei.com>
Message-ID: <20150429214440.GW17170@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joseph, thanks for finding and trying to fix this bug.

On Sat, Apr 25, 2015 at 03:05:15PM +0800, Joseph Qi wrote:
> There is a race between purge and get lock resource, which will lead to
> ast unfinished and system hung. The case is described below:
> 
> mkdir                                  dlm_thread
> -----------------------------------------------------------------------
> o2cb_dlm_lock                        |
> -> dlmlock                           |
>   -> dlm_get_lock_resource           |
>     -> __dlm_lookup_lockres_full     |
>       -> spin_unlock(&dlm->spinlock) |
>                                      | dlm_run_purge_list
>                                      | -> dlm_purge_lockres
>                                      |   -> dlm_drop_lockres_ref
>                                      |   -> spin_lock(&dlm->spinlock)
>                                      |   -> spin_lock(&res->spinlock)
>                                      |   -> ~DLM_LOCK_RES_DROPPING_REF
>                                      |   -> spin_unlock(&res->spinlock)
>                                      |   -> spin_unlock(&dlm->spinlock)
>       -> spin_lock(&tmpres->spinlock)|
>       DLM_LOCK_RES_DROPPING_REF cleared |
>       -> spin_unlock(&tmpres->spinlock) |
>       return the purged lockres         |
> 
> So after this, once ast comes, it will ingore the ast because the
> lockres cannot be found anymore. Thus the OCFS2_LOCK_BUSY won't be
> cleared and corresponding thread hangs.
> The &dlm->spinlock was hold when checking DLM_LOCK_RES_DROPPING_REF at
> the very begining. And commit 7b791d6856 (ocfs2/dlm: Fix race during
> lockres mastery) moved it up because of the possible wait.
> So take the &dlm->spinlock and introduce a new wait function to fix the
> race.

Ok, I _think_ I understand the deadlock. But we can't say for sure who will
come and wake up the sleeping process? If that's the case I don't think we
want this for -stable right now.


> 
> Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
> Reviewed-by: joyce.xue <xuejiufei@huawei.com>
> ---
>  fs/ocfs2/dlm/dlmcommon.h |  2 ++
>  fs/ocfs2/dlm/dlmmaster.c | 13 +++++++++----
>  fs/ocfs2/dlm/dlmthread.c | 23 +++++++++++++++++++++++
>  3 files changed, 34 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
> index e88ccf8..c6b76f4 100644
> --- a/fs/ocfs2/dlm/dlmcommon.h
> +++ b/fs/ocfs2/dlm/dlmcommon.h
> @@ -1014,6 +1014,8 @@ void dlm_move_lockres_to_recovery_list(struct dlm_ctxt *dlm,
> 
>  /* will exit holding res->spinlock, but may drop in function */
>  void __dlm_wait_on_lockres_flags(struct dlm_lock_resource *res, int flags);
> +void __dlm_wait_on_lockres_flags_new(struct dlm_ctxt *dlm,
> +		struct dlm_lock_resource *res, int flags);

If we retain this function, it should have a more descriptive name than
'_new'.


>  /* will exit holding res->spinlock, but may drop in function */
>  static inline void __dlm_wait_on_lockres(struct dlm_lock_resource *res)
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index a6944b2..9a5f45d 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -755,13 +755,16 @@ lookup:
>  	spin_lock(&dlm->spinlock);
>  	tmpres = __dlm_lookup_lockres_full(dlm, lockid, namelen, hash);
>  	if (tmpres) {
> -		spin_unlock(&dlm->spinlock);
>  		spin_lock(&tmpres->spinlock);
>  		/* Wait on the thread that is mastering the resource */
>  		if (tmpres->owner == DLM_LOCK_RES_OWNER_UNKNOWN) {
> -			__dlm_wait_on_lockres(tmpres);
> +			__dlm_wait_on_lockres_flags_new(dlm, tmpres,
> +					(DLM_LOCK_RES_IN_PROGRESS|
> +					DLM_LOCK_RES_RECOVERING|
> +					DLM_LOCK_RES_MIGRATING));
>  			BUG_ON(tmpres->owner == DLM_LOCK_RES_OWNER_UNKNOWN);
>  			spin_unlock(&tmpres->spinlock);
> +			spin_unlock(&dlm->spinlock);
>  			dlm_lockres_put(tmpres);
>  			tmpres = NULL;
>  			goto lookup;
> @@ -770,9 +773,10 @@ lookup:
>  		/* Wait on the resource purge to complete before continuing */
>  		if (tmpres->state & DLM_LOCK_RES_DROPPING_REF) {
>  			BUG_ON(tmpres->owner == dlm->node_num);
> -			__dlm_wait_on_lockres_flags(tmpres,
> -						    DLM_LOCK_RES_DROPPING_REF);
> +			__dlm_wait_on_lockres_flags_new(dlm, tmpres,
> +				DLM_LOCK_RES_DROPPING_REF);
>  			spin_unlock(&tmpres->spinlock);
> +			spin_unlock(&dlm->spinlock);
>  			dlm_lockres_put(tmpres);
>  			tmpres = NULL;
>  			goto lookup;
> @@ -782,6 +786,7 @@ lookup:
>  		dlm_lockres_grab_inflight_ref(dlm, tmpres);
> 
>  		spin_unlock(&tmpres->spinlock);
> +		spin_unlock(&dlm->spinlock);
>  		if (res)
>  			dlm_lockres_put(res);
>  		res = tmpres;
> diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
> index 69aac6f..505730a 100644
> --- a/fs/ocfs2/dlm/dlmthread.c
> +++ b/fs/ocfs2/dlm/dlmthread.c
> @@ -77,6 +77,29 @@ repeat:
>  	__set_current_state(TASK_RUNNING);
>  }
> 
> +void __dlm_wait_on_lockres_flags_new(struct dlm_ctxt *dlm,
> +		struct dlm_lock_resource *res, int flags)
> +{
> +	DECLARE_WAITQUEUE(wait, current);
> +
> +	assert_spin_locked(&dlm->spinlock);
> +	assert_spin_locked(&res->spinlock);
> +
> +	add_wait_queue(&res->wq, &wait);
> +repeat:
> +	set_current_state(TASK_UNINTERRUPTIBLE);
> +	if (res->state & flags) {
> +		spin_unlock(&res->spinlock);
> +		spin_unlock(&dlm->spinlock);
> +		schedule();
> +		spin_lock(&dlm->spinlock);
> +		spin_lock(&res->spinlock);
> +		goto repeat;
> +	}
> +	remove_wait_queue(&res->wq, &wait);
> +	__set_current_state(TASK_RUNNING);
> +}

Is it possible to rework this using wait_event()? The code you copied from
__dlm_wait_on_lockres_flags() is seriously ugly :(
	--Mark

--
Mark Fasheh
