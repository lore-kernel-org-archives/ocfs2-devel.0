From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Mon, 14 Jun 2010 22:58:52 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: o2dlm fix race in purge
 lockres and newlock (orabug 9094491)
In-Reply-To: <1276135652-15250-1-git-send-email-srinivas.eeda@oracle.com>
References: <1276135652-15250-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <4C17169C.9090504@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Please ignore this patch. I'll resend this patch along with dlm purge 
lockres for completeness.

On 6/9/2010 7:07 PM, Srinivas Eeda wrote:
> dlm_thread sends a deref message to the master node. At the same time,
> another thread sends a new lock request to the master node.
> Since dlm_thread wouldn't know about it, it would unhash the lockres
> after it gets the response. lock request AST would then won't find
> the lockres and hence BUGs.
>
> The fix is to add new state DLM_LOCK_RES_IN_USE which would prevent
> dlm_thread from purging the lockres and/or unhashing lockres.
>
> Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
> ---
>  fs/ocfs2/dlm/dlmcommon.h |    1 +
>  fs/ocfs2/dlm/dlmlock.c   |    4 ++++
>  fs/ocfs2/dlm/dlmmaster.c |    5 ++++-
>  fs/ocfs2/dlm/dlmthread.c |    4 +++-
>  4 files changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
> index 0102be3..0290612 100644
> --- a/fs/ocfs2/dlm/dlmcommon.h
> +++ b/fs/ocfs2/dlm/dlmcommon.h
> @@ -280,6 +280,7 @@ static inline void __dlm_set_joining_node(struct dlm_ctxt *dlm,
>  #define DLM_LOCK_RES_IN_PROGRESS          0x00000010
>  #define DLM_LOCK_RES_MIGRATING            0x00000020
>  #define DLM_LOCK_RES_DROPPING_REF         0x00000040
> +#define DLM_LOCK_RES_IN_USE               0x00000100
>  #define DLM_LOCK_RES_BLOCK_DIRTY          0x00001000
>  #define DLM_LOCK_RES_SETREF_INPROG        0x00002000
>  
> diff --git a/fs/ocfs2/dlm/dlmlock.c b/fs/ocfs2/dlm/dlmlock.c
> index 7333377..501ac40 100644
> --- a/fs/ocfs2/dlm/dlmlock.c
> +++ b/fs/ocfs2/dlm/dlmlock.c
> @@ -134,6 +134,8 @@ static enum dlm_status dlmlock_master(struct dlm_ctxt *dlm,
>  	if (status != DLM_NORMAL &&
>  	    lock->ml.node != dlm->node_num) {
>  		/* erf.  state changed after lock was dropped. */
> +		/* DLM_LOCK_RES_IN_USE is set in dlm_get_lock_resource */
> +		res->state &= ~DLM_LOCK_RES_IN_USE;
>  		spin_unlock(&res->spinlock);
>  		dlm_error(status);
>  		return status;
> @@ -180,6 +182,7 @@ static enum dlm_status dlmlock_master(struct dlm_ctxt *dlm,
>  			kick_thread = 1;
>  		}
>  	}
> +	res->state &= ~DLM_LOCK_RES_IN_USE;
>  	/* reduce the inflight count, this may result in the lockres
>  	 * being purged below during calc_usage */
>  	if (lock->ml.node == dlm->node_num)
> @@ -246,6 +249,7 @@ static enum dlm_status dlmlock_remote(struct dlm_ctxt *dlm,
>  
>  	spin_lock(&res->spinlock);
>  	res->state &= ~DLM_LOCK_RES_IN_PROGRESS;
> +	res->state &= ~DLM_LOCK_RES_IN_USE;
>  	lock->lock_pending = 0;
>  	if (status != DLM_NORMAL) {
>  		if (status == DLM_RECOVERING &&
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index 9289b43..f0f2d97 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -719,6 +719,7 @@ lookup:
>  	if (tmpres) {
>  		int dropping_ref = 0;
>  
> +		tmpres->state |= DLM_LOCK_RES_IN_USE;
>  		spin_unlock(&dlm->spinlock);
>  
>  		spin_lock(&tmpres->spinlock);
> @@ -731,8 +732,10 @@ lookup:
>  		if (tmpres->owner == dlm->node_num) {
>  			BUG_ON(tmpres->state & DLM_LOCK_RES_DROPPING_REF);
>  			dlm_lockres_grab_inflight_ref(dlm, tmpres);
> -		} else if (tmpres->state & DLM_LOCK_RES_DROPPING_REF)
> +		} else if (tmpres->state & DLM_LOCK_RES_DROPPING_REF) {
> +			tmpres->state &= ~DLM_LOCK_RES_IN_USE;
>  			dropping_ref = 1;
> +		}
>  		spin_unlock(&tmpres->spinlock);
>  
>  		/* wait until done messaging the master, drop our ref to allow
> diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
> index 11a6d1f..b2315cb 100644
> --- a/fs/ocfs2/dlm/dlmthread.c
> +++ b/fs/ocfs2/dlm/dlmthread.c
> @@ -93,6 +93,7 @@ int __dlm_lockres_has_locks(struct dlm_lock_resource *res)
>  int __dlm_lockres_unused(struct dlm_lock_resource *res)
>  {
>  	if (!__dlm_lockres_has_locks(res) &&
> +	    !(res->state & DLM_LOCK_RES_IN_USE) &&
>  	    (list_empty(&res->dirty) && !(res->state & DLM_LOCK_RES_DIRTY))) {
>  		/* try not to scan the bitmap unless the first two
>  		 * conditions are already true */
> @@ -222,7 +223,8 @@ static int dlm_purge_lockres(struct dlm_ctxt *dlm,
>  	} else
>  		spin_unlock(&res->spinlock);
>  
> -	__dlm_unhash_lockres(res);
> +	if (__dlm_lockres_unused(res))
> +		__dlm_unhash_lockres(res);
>  
>  	/* lockres is not in the hash now.  drop the flag and wake up
>  	 * any processes waiting in dlm_get_lock_resource. */
>   
