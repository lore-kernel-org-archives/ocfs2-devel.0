From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Mon, 21 Jun 2010 13:19:53 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2 fix o2dlm dlm run purgelist
In-Reply-To: <1276977371-13911-1-git-send-email-srinivas.eeda@oracle.com>
References: <1276977371-13911-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <20100621051953.GA2801@laptop.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10-06-19 12:56, Srinivas Eeda wrote:
> There are two problems in dlm_run_purgelist
> 
> 1. If a lockres is found to be in use, dlm_run_purgelist keeps trying to purge
> the same lockres instead of trying the next lockres.
> 
> 2. When a lockres is found unused, dlm_run_purgelist releases lockres spinlock
> before setting DLM_LOCK_RES_DROPPING_REF and calls dlm_purge_lockres.
> spinlock is reacquired but in this window lockres can get reused. This leads
> to BUG.
> 
> This patch modifies dlm_run_purgelist to skip lockres if it's in use and purge
>  next lockres. It also sets DLM_LOCK_RES_DROPPING_REF before releasing the
> lockres spinlock protecting it from getting reused.
> 
> Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
> ---
>  fs/ocfs2/dlm/dlmthread.c |   55 +++++++++++++++++++++------------------------
>  1 files changed, 26 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
> index 11a6d1f..79d1ef6 100644
> --- a/fs/ocfs2/dlm/dlmthread.c
> +++ b/fs/ocfs2/dlm/dlmthread.c
> @@ -158,15 +158,6 @@ static int dlm_purge_lockres(struct dlm_ctxt *dlm,
>  	int master;
>  	int ret = 0;
>  
> -	spin_lock(&res->spinlock);
> -	if (!__dlm_lockres_unused(res)) {
> -		mlog(0, "%s:%.*s: tried to purge but not unused\n",
> -		     dlm->name, res->lockname.len, res->lockname.name);
> -		__dlm_print_one_lock_resource(res);
> -		spin_unlock(&res->spinlock);
> -		BUG();
> -	}
> -
>  	if (res->state & DLM_LOCK_RES_MIGRATING) {
>  		mlog(0, "%s:%.*s: Delay dropref as this lockres is "
>  		     "being remastered\n", dlm->name, res->lockname.len,
> @@ -184,13 +175,13 @@ static int dlm_purge_lockres(struct dlm_ctxt *dlm,
>  
>  	if (!master)
>  		res->state |= DLM_LOCK_RES_DROPPING_REF;
> -	spin_unlock(&res->spinlock);
>  
>  	mlog(0, "purging lockres %.*s, master = %d\n", res->lockname.len,
>  	     res->lockname.name, master);
>  
>  	if (!master) {
>  		/* drop spinlock...  retake below */
> +		spin_unlock(&res->spinlock);
>  		spin_unlock(&dlm->spinlock);
>  
>  		spin_lock(&res->spinlock);
> @@ -208,30 +199,34 @@ static int dlm_purge_lockres(struct dlm_ctxt *dlm,
>  		mlog(0, "%s:%.*s: dlm_deref_lockres returned %d\n",
>  		     dlm->name, res->lockname.len, res->lockname.name, ret);
>  		spin_lock(&dlm->spinlock);
> +		spin_lock(&res->spinlock);
>  	}
>  
> -	spin_lock(&res->spinlock);
>  	if (!list_empty(&res->purge)) {
>  		mlog(0, "removing lockres %.*s:%p from purgelist, "
>  		     "master = %d\n", res->lockname.len, res->lockname.name,
>  		     res, master);
>  		list_del_init(&res->purge);
> -		spin_unlock(&res->spinlock);
>  		dlm_lockres_put(res);
>  		dlm->purge_count--;
> -	} else
> -		spin_unlock(&res->spinlock);
> +	}
>  
> -	__dlm_unhash_lockres(res);
> +	if (__dlm_lockres_unused(res))
> +		__dlm_unhash_lockres(res);
> +	else {
> +		mlog(ML_ERROR, "found lockres %s:%.*s: in use after deref\n",
> +		     dlm->name, res->lockname.len, res->lockname.name);
> +		__dlm_print_one_lock_resource(res);
> +	}

This is not an error. ML_NOTICE instead?

regards,
wengang.
