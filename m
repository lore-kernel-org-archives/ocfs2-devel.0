From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 18 Nov 2010 00:44:02 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: a missed
 DLM_LOCK_RES_IN_PROGRESS set
In-Reply-To: <201011171556.oAH7aOht003969@rcsinet15.oracle.com>
References: <201011171556.oAH7aOht003969@rcsinet15.oracle.com>
Message-ID: <20101117164402.GA3401@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sorry, I want to take back the two patches.

It seems DLM_LOCK_RES_IN_PROGRESS is needed only for remote work, and
for master node, spin lock is enough.
dlmunlock_common() does need some fix since it includes remote case.
I will send the fix later.

regards,
wengang.

On 10-11-17 23:53, Wengang Wang wrote:
> We set DLM_LOCK_RES_IN_PROGRESS flag when we are processing a lock request.
> There is a miss in dlmunlock_common.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
>  fs/ocfs2/dlm/dlmunlock.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmunlock.c b/fs/ocfs2/dlm/dlmunlock.c
> index 817287c..ef219ac 100644
> --- a/fs/ocfs2/dlm/dlmunlock.c
> +++ b/fs/ocfs2/dlm/dlmunlock.c
> @@ -137,6 +137,8 @@ static enum dlm_status dlmunlock_common(struct dlm_ctxt *dlm,
>  		/* ok for this to sleep if not in a network handler */
>  		__dlm_wait_on_lockres(res);
>  		res->state |= DLM_LOCK_RES_IN_PROGRESS;
> +	} else {
> +		res->state |= DLM_LOCK_RES_IN_PROGRESS;
>  	}
>  	spin_lock(&lock->spinlock);
>  
> -- 
> 1.7.2.3
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
