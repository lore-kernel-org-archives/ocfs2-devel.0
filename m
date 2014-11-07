From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Fri, 07 Nov 2014 13:54:25 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: do not set
 OCFS2_LOCK_UPCONVERT_FINISHING if nonblocking lock can not be granted at
 once
In-Reply-To: <545C3F4C.5070703@huawei.com>
References: <545C3F4C.5070703@huawei.com>
Message-ID: <545C5E91.5000501@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jiufei,

On 11/07/2014 11:41 AM, Xue jiufei wrote:
> Function ocfs2_readpages() use nonblocking flag to avoid page lock
> inversion. It will trigger cluster hang because that flag
> OCFS2_LOCK_UPCONVERT_FINISHING is not cleared if nonblocking lock
> cannot be granted at once. The flag would prevent dc thread from
> downconverting. So other nodes cannot acheive this lockres for ever.
> 
> So we should not set OCFS2_LOCK_UPCONVERT_FINISHING when receiving ast
> if nonblocking lock had already returned.
> 

Use OCFS2_LOCK_NONBLOCK_FINISHED can't fix this issue. Like there are
two processes doing non-blocking lock in the following order.
1. Process A issue non-blocking lock fail, set OCFS2_LOCK_NONBLOCK_FINISHED.
2. Process B issue non-blocking lock fail, set
OCFS2_LOCK_NONBLOCK_FINISHED again.
3. Ast for process A come, clear OCFS2_LOCK_NONBLOCK_FINISHED.
4. Ast for process B come, set OCFS2_LOCK_UPCONVERT_FINISHING.

So down convert can still be blocked.

To fix this issue, I think no need to call ocfs2_dlm_lock() for
non-blocking lock, just check local lockres->l_level is enough, if
request level equal or smaller than it, lock success, or lock fail.

Thanks,
Junxiao.

> Signed-off-by: joyce.xue <xuejiufei@huawei.com>
> ---
>  fs/ocfs2/dlmglue.c | 37 +++++++++++++++++++++++++++++++------
>  fs/ocfs2/ocfs2.h   |  6 ++++++
>  2 files changed, 37 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 21262f2..1ddb6f1 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -861,8 +861,13 @@ static inline void ocfs2_generic_handle_convert_action(struct ocfs2_lock_res *lo
>  	 * We set the OCFS2_LOCK_UPCONVERT_FINISHING flag before clearing
>  	 * the OCFS2_LOCK_BUSY flag to prevent the dc thread from
>  	 * downconverting the lock before the upconvert has fully completed.
> +	 * Do not prevent the dc thread from downconverting if NONBLOCK lock
> +	 * had already returned.
>  	 */
> -	lockres_or_flags(lockres, OCFS2_LOCK_UPCONVERT_FINISHING);
> +	if (!(lockres->l_flags & OCFS2_LOCK_NONBLOCK_FINISHED))
> +		lockres_or_flags(lockres, OCFS2_LOCK_UPCONVERT_FINISHING);
> +	else
> +		lockres_clear_flags(lockres, OCFS2_LOCK_NONBLOCK_FINISHED);
>  
>  	lockres_clear_flags(lockres, OCFS2_LOCK_BUSY);
>  }
> @@ -1324,13 +1329,12 @@ static void lockres_add_mask_waiter(struct ocfs2_lock_res *lockres,
>  
>  /* returns 0 if the mw that was removed was already satisfied, -EBUSY
>   * if the mask still hadn't reached its goal */
> -static int lockres_remove_mask_waiter(struct ocfs2_lock_res *lockres,
> +static int __lockres_remove_mask_waiter(struct ocfs2_lock_res *lockres,
>  				      struct ocfs2_mask_waiter *mw)
>  {
> -	unsigned long flags;
>  	int ret = 0;
>  
> -	spin_lock_irqsave(&lockres->l_lock, flags);
> +	assert_spin_locked(&lockres->l_lock);
>  	if (!list_empty(&mw->mw_item)) {
>  		if ((lockres->l_flags & mw->mw_mask) != mw->mw_goal)
>  			ret = -EBUSY;
> @@ -1338,6 +1342,18 @@ static int lockres_remove_mask_waiter(struct ocfs2_lock_res *lockres,
>  		list_del_init(&mw->mw_item);
>  		init_completion(&mw->mw_complete);
>  	}
> +
> +	return ret;
> +}
> +
> +static int lockres_remove_mask_waiter(struct ocfs2_lock_res *lockres,
> +				      struct ocfs2_mask_waiter *mw)
> +{
> +	unsigned long flags;
> +	int ret = 0;
> +
> +	spin_lock_irqsave(&lockres->l_lock, flags);
> +	ret = __lockres_remove_mask_waiter(lockres, mw);
>  	spin_unlock_irqrestore(&lockres->l_lock, flags);
>  
>  	return ret;
> @@ -1373,6 +1389,7 @@ static int __ocfs2_cluster_lock(struct ocfs2_super *osb,
>  	unsigned long flags;
>  	unsigned int gen;
>  	int noqueue_attempted = 0;
> +	int dlm_locked = 0;
>  
>  	ocfs2_init_mask_waiter(&mw);
>  
> @@ -1481,6 +1498,7 @@ again:
>  			ocfs2_recover_from_dlm_error(lockres, 1);
>  			goto out;
>  		}
> +		dlm_locked = 1;
>  
>  		mlog(0, "lock %s, successful return from ocfs2_dlm_lock\n",
>  		     lockres->l_name);
> @@ -1514,10 +1532,17 @@ out:
>  	if (wait && arg_flags & OCFS2_LOCK_NONBLOCK &&
>  	    mw.mw_mask & (OCFS2_LOCK_BUSY|OCFS2_LOCK_BLOCKED)) {
>  		wait = 0;
> -		if (lockres_remove_mask_waiter(lockres, &mw))
> +		spin_lock_irqsave(&lockres->l_lock, flags);
> +		if (__lockres_remove_mask_waiter(lockres, &mw)) {
> +			if (dlm_locked)
> +				lockres_or_flags(lockres,
> +					OCFS2_LOCK_NONBLOCK_FINISHED);
> +			spin_unlock_irqrestore(&lockres->l_lock, flags);
>  			ret = -EAGAIN;
> -		else
> +		} else {
> +			spin_unlock_irqrestore(&lockres->l_lock, flags);
>  			goto again;
> +		}
>  	}
>  	if (wait) {
>  		ret = ocfs2_wait_for_mask(&mw);
> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index bbec539..7d6b7d0 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -144,6 +144,12 @@ enum ocfs2_unlock_action {
>  						     * before the upconvert
>  						     * has completed */
>  
> +#define OCFS2_LOCK_NONBLOCK_FINISHED (0x00001000) /* NONBLOCK cluster
> +						   * lock has already
> +						   * returned, do not block
> +						   * dc thread from
> +						   * downconverting */
> +
>  struct ocfs2_lock_res_ops;
>  
>  typedef void (*ocfs2_lock_callback)(int status, unsigned long data);
> 
