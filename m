From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Wed, 24 Nov 2010 18:50:22 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: a missing
 DLM_LOCK_RES_IN_PROGRESS set
In-Reply-To: <201011190425.oAJ4P6WC020935@rcsinet13.oracle.com>
References: <201011190425.oAJ4P6WC020935@rcsinet13.oracle.com>
Message-ID: <20101124105022.GA10050@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

A reminder.

thanks,
wengang.
On 10-11-19 12:23, Wengang Wang wrote:
> For remote dlm operations, local node sets DLM_LOCK_RES_IN_PROGRESS flag on
> the lockres to prevent parallel remote dlm requests.
> There is a miss of setting that flag in dlmunlock_common() for the remote
> case which leads to a later remote dlm request goes on.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
>  fs/ocfs2/dlm/dlmunlock.c |   11 ++++++++---
>  1 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmunlock.c b/fs/ocfs2/dlm/dlmunlock.c
> index 817287c..a45be2f 100644
> --- a/fs/ocfs2/dlm/dlmunlock.c
> +++ b/fs/ocfs2/dlm/dlmunlock.c
> @@ -104,7 +104,7 @@ static enum dlm_status dlmunlock_common(struct dlm_ctxt *dlm,
>  {
>  	enum dlm_status status;
>  	int actions = 0;
> -	int in_use;
> +	int in_use, can_block;
>          u8 owner;
>  
>  	mlog(0, "master_node = %d, valblk = %d\n", master_node,
> @@ -127,9 +127,10 @@ static enum dlm_status dlmunlock_common(struct dlm_ctxt *dlm,
>  		return DLM_BADPARAM;
>  	}
>  
> +	can_block = master_node? (flags & LKM_CANCEL) : 1;
>  	spin_lock(&res->spinlock);
>  	if (res->state & DLM_LOCK_RES_IN_PROGRESS) {
> -		if (master_node && !(flags & LKM_CANCEL)) {
> +		if (!can_block) {
>  			mlog(ML_ERROR, "lockres in progress!\n");
>  			spin_unlock(&res->spinlock);
>  			return DLM_FORWARD;
> @@ -137,6 +138,9 @@ static enum dlm_status dlmunlock_common(struct dlm_ctxt *dlm,
>  		/* ok for this to sleep if not in a network handler */
>  		__dlm_wait_on_lockres(res);
>  		res->state |= DLM_LOCK_RES_IN_PROGRESS;
> +	} else {
> +		if (can_block)
> +			res->state |= DLM_LOCK_RES_IN_PROGRESS;
>  	}
>  	spin_lock(&lock->spinlock);
>  
> @@ -232,7 +236,8 @@ static enum dlm_status dlmunlock_common(struct dlm_ctxt *dlm,
>  	dlm_lock_put(lock);
>  
>  leave:
> -	res->state &= ~DLM_LOCK_RES_IN_PROGRESS;
> +	if (can_block)
> +		res->state &= ~DLM_LOCK_RES_IN_PROGRESS;
>  	if (!dlm_lock_on_list(&res->converting, lock))
>  		BUG_ON(lock->ml.convert_type != LKM_IVMODE);
>  	else
> -- 
> 1.7.2.3
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
