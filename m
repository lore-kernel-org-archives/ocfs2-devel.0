From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Wed, 11 May 2011 12:52:18 +0800
Subject: [Ocfs2-devel] [PATCH] o2dlm: check lockres validity in
	createlock
In-Reply-To: <201105110448.p4B4mErr019249@acsmt357.oracle.com>
References: <201105110448.p4B4mErr019249@acsmt357.oracle.com>
Message-ID: <20110511045218.GA14318@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sorry,
the ML_NOTICE log is for debugging purpose and should be removed.

thanks,
wengang.
On 11-05-11 07:47, Wengang Wang wrote:
> When we are to purge a lockres, we check if it's unused.
> the check includes
> 1. no locks attached to the lockres.
> 2. not dirty.
> 3. not in recovery.
> 4. no interested nodes in refmap.
> If the the above four are satisfied, we are going to purge it(remove it
> from hash table).
> 
> While, when a "create lock" is in progress especially when lockres is owned
> remotely(spinlocks are dropped when networking), the lockres can satisfy above
> four condition. If it's put to purge list, it can be purged out from hash table
> when we are still accessing on it(sending request to owner for example). That's
> not what we want. 
> 
> I have met such a problem (orabug 12405575).
> The lockres is in the purge list already(there is a delay for real purge work)
> and the create lock request comes. When we are sending network message to the
> owner in dlmlock_remote(), the owner crashed. So we get DLM_RECOVERING as return
> value and retries dlmlock_remote(). And before the owner crash, we have purged
> the lockres. So the lockres become stale(on lockres->onwer). Thus the code calls
> dlmlock_remote() infinitely.
> 
> fix 1
> This patch tries to fix it by checking if the lockres is still valid(in hash table)
> before make request on it for each retry. It passed regression test.
> 
> fix 2
> Another approch(not in this patch) is that we remove the lockres from purge list if
> it's there in dlm_get_lock_resource() which is called for only createlock case. So
> that the lockres can't be purged when we are in progress of createlock.
> I didn't test it.
> 
> I think fix 1 is the safer and fix 2 is the better. I choosed fix 1.
> 
> Sunil, what's your comment?
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
>  fs/ocfs2/dlm/dlmlock.c |   28 ++++++++++++++++++++++++++++
>  1 files changed, 28 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmlock.c b/fs/ocfs2/dlm/dlmlock.c
> index 8d39e0f..02abaa1 100644
> --- a/fs/ocfs2/dlm/dlmlock.c
> +++ b/fs/ocfs2/dlm/dlmlock.c
> @@ -570,6 +570,7 @@ enum dlm_status dlmlock(struct dlm_ctxt *dlm, int mode,
>  	struct dlm_lock_resource *res = NULL;
>  	struct dlm_lock *lock = NULL;
>  	int convert = 0, recovery = 0;
> +	bool lockres_purged = false;
>  
>  	/* yes this function is a mess.
>  	 * TODO: clean this up.  lots of common code in the
> @@ -681,6 +682,7 @@ retry_convert:
>  		if (!recovery)
>  			dlm_wait_for_recovery(dlm);
>  
> +lookup_res:
>  		/* find or create the lock resource */
>  		res = dlm_get_lock_resource(dlm, name, namelen, flags);
>  		if (!res) {
> @@ -698,6 +700,32 @@ retry_convert:
>  		lock->astdata = data;
>  
>  retry_lock:
> +		/* there is a chance that the lockres is already be purged out
> +		 * from the hash table and it can become a stale one. obviously
> +		 * accessing on a stale lockres is not what we want. the case
> +		 * we ever see is the owner dead(recovery didn't take care of
> +		 * this lockres since it's not in hashtable), and the code keep
> +		 * sending request to the dead node and getting DLM_RECOVERING
> +		 * and then retrying infinitely.
> +		 * we check if the lockres has been purged here and redo the
> +		 * lookup if it has been to avoid infinite loop.
> +		 */
> +		lockres_purged = false;
> +		spin_lock(&dlm->spinlock);
> +		spin_lock(&res->spinlock);
> +		if (unlikely(hlist_unhashed(&res->hash_node))) {
> +			lockres_purged = true;
> +		}
> +		spin_unlock(&res->spinlock);
> +		spin_unlock(&dlm->spinlock);
> +		if (lockres_purged) {
> +			dlm_lock_detach_lockres(lock);
> +			mlog(ML_NOTICE, "going to relookup lockres %.*s\n", res->lockname.len, res->lockname.name);
> +			dlm_lockres_put(res);
> +			res = NULL;
> +			goto lookup_res;
> +		}
> +
>  		if (flags & LKM_VALBLK) {
>  			mlog(0, "LKM_VALBLK passed by caller\n");
>  
> -- 
> 1.7.2.3
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
