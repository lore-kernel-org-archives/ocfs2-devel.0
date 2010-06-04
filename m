From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Thu, 03 Jun 2010 18:06:55 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: cancel the migration or redo
 deref to recovery master
Message-ID: <4C0851AF.1030803@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Comments inline

On 6/3/2010 9:37 AM, Wengang Wang wrote:
> Changes to V1:
> 1 move the msleep to the second runs when the lockres is in recovery so the
>   purging work on other lockres' can go.
> 2 do not inform recovery master if DLM_LOCK_RES_DROPPING_REF is set and don't
>   resend deref in this case.
>
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
>  fs/ocfs2/dlm/dlmcommon.h   |    1 +
>  fs/ocfs2/dlm/dlmrecovery.c |   25 +++++++++++++++
>  fs/ocfs2/dlm/dlmthread.c   |   73 ++++++++++++++++++++++++++++++++++++++-----
>  3 files changed, 90 insertions(+), 9 deletions(-)
>
> diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
> index 4b6ae2c..4194087 100644
> --- a/fs/ocfs2/dlm/dlmcommon.h
> +++ b/fs/ocfs2/dlm/dlmcommon.h
> @@ -280,6 +280,7 @@ static inline void __dlm_set_joining_node(struct dlm_ctxt *dlm,
>  #define DLM_LOCK_RES_IN_PROGRESS          0x00000010
>  #define DLM_LOCK_RES_MIGRATING            0x00000020
>  #define DLM_LOCK_RES_DROPPING_REF         0x00000040
> +#define DLM_LOCK_RES_DE_DROP_REF          0x00000080
>   
Can you please explain the idea of the new flag DLM_LOCK_RES_DE_DROP_REF :)

If the idea of the fix is to address the race between purging and 
recovery, I am wondering DLM_LOCK_RES_DROPPING_REF and 
DLM_LOCK_RES_RECOVERING flags may be enough to fix this problem. 
dlm_move_lockres_to_recovery_list moves lockres to resources list (which 
tracks of resources that needs recovery) and sets the flag 
DLM_LOCK_RES_RECOVERING. If we do not call 
dlm_move_lockres_to_recovery_list for the resource which have 
DLM_LOCK_RES_DROPPING_REF set they will not get migrated. In that case 
DLM_LOCK_RES_RECOVERING will not get set and the recovery master 
wouldn't know about this and the lockres that is in the middle of 
purging will get purged.

For the lockres that got moved to resource list they will get migrated. 
In that case lockres has DLM_LOCK_RES_RECOVERING.flag set. So 
dlm_purge_list should consider this as being used and should defer 
purging. the lockres will get recovered and the new owner will be set 
and the flag DLM_LOCK_RES_RECOVERING. will get removed. dlm_purge_list 
can now go ahead and purge this lockres.
>  #define DLM_LOCK_RES_BLOCK_DIRTY          0x00001000
>  #define DLM_LOCK_RES_SETREF_INPROG        0x00002000
>  
> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
> index f8b75ce..7241070 100644
> --- a/fs/ocfs2/dlm/dlmrecovery.c
> +++ b/fs/ocfs2/dlm/dlmrecovery.c
> @@ -913,6 +913,27 @@ static void dlm_request_all_locks_worker(struct dlm_work_item *item, void *data)
>  	/* any errors returned will be due to the new_master dying,
>  	 * the dlm_reco_thread should detect this */
>  	list_for_each_entry(res, &resources, recovering) {
> +		int ignore_mig = 0;
> +		spin_lock(&res->spinlock);
> +		/*
> +		 * if we are dropping the lockres, no need to let the new master
> +		 * know the reference of this node. That is don't migrate the
> +		 * lockres to the new master. Also make sure we don't send DEREF
> +		 * request for the same lockres to the new master either.
> +		 */
> +		if (unlikely(res->state & DLM_LOCK_RES_DROPPING_REF)) {
> +			ignore_mig = 1;
> +			res->state |= DLM_LOCK_RES_DE_DROP_REF;
> +		}
> +		spin_unlock(&res->spinlock);
> +		if (ignore_mig) {
> +			mlog(ML_NOTICE, "ignore migrating %.*s to recovery "
> +			     "master %u as we are dropping it\n",
> +			     res->lockname.len, res->lockname.name,
> +			     reco_master);
> +			continue;
> +		}
> +
>  		ret = dlm_send_one_lockres(dlm, res, mres, reco_master,
>  				   	DLM_MRES_RECOVERY);
>  		if (ret < 0) {
> @@ -1997,7 +2018,11 @@ void dlm_move_lockres_to_recovery_list(struct dlm_ctxt *dlm,
>  	struct list_head *queue;
>  	struct dlm_lock *lock, *next;
>  
> +	assert_spin_locked(&res->spinlock);
> +
>  	res->state |= DLM_LOCK_RES_RECOVERING;
> +	res->state &= ~DLM_LOCK_RES_DE_DROP_REF;
> +
>  	if (!list_empty(&res->recovering)) {
>  		mlog(0,
>  		     "Recovering res %s:%.*s, is already on recovery list!\n",
> diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
> index d4f73ca..c4aa2ec 100644
> --- a/fs/ocfs2/dlm/dlmthread.c
> +++ b/fs/ocfs2/dlm/dlmthread.c
> @@ -157,6 +157,9 @@ static int dlm_purge_lockres(struct dlm_ctxt *dlm,
>  {
>  	int master;
>  	int ret = 0;
> +	int remote_drop = 1;
> +
> +	assert_spin_locked(&dlm->spinlock);
>  
>  	spin_lock(&res->spinlock);
>  	if (!__dlm_lockres_unused(res)) {
> @@ -184,12 +187,19 @@ static int dlm_purge_lockres(struct dlm_ctxt *dlm,
>  
>  	if (!master)
>  		res->state |= DLM_LOCK_RES_DROPPING_REF;
> +
> +	/*
> +	 * If we didn't migrate this lockres to recovery master, don't send
> +	 * DEREF request to it.
> +	 */
> +	if (res->state & DLM_LOCK_RES_DE_DROP_REF)
> +		remote_drop = 0;
>  	spin_unlock(&res->spinlock);
>  
>  	mlog(0, "purging lockres %.*s, master = %d\n", res->lockname.len,
>  	     res->lockname.name, master);
>  
> -	if (!master) {
> +	if (!master && remote_drop) {
>  		/* drop spinlock...  retake below */
>  		spin_unlock(&dlm->spinlock);
>  
> @@ -211,18 +221,34 @@ static int dlm_purge_lockres(struct dlm_ctxt *dlm,
>  	}
>  
>  	spin_lock(&res->spinlock);
> +	/*
> +	 * we dropped dlm->spinlock and res->spinlock when sending the DEREF
> +	 * request, there is a chance that a recovery happened on this lockres.
> +	 * in that case, we have to DEREF to the new master(recovery master)
> +	 * when recovery finished. otherwise, there can be an incorrect ref on
> +	 * the lockres on the new master on behalf of this node.
>   
When we send deref message DLM_LOCK_RES_DROPPING_REF would be set. So 
recovery shouldn't be happening on this resource.
> +	 */
> +	if (unlikely(res->state & DLM_LOCK_RES_RECOVERING)) {
> +		spin_unlock(&res->spinlock);
> +		/*
> +		 * try deref again, keeping DLM_LOCK_RES_DROPPING_REF prevents
> +		 * this lockres from being "in use" again.
> +		 */
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
> @@ -241,6 +267,9 @@ static void dlm_run_purge_list(struct dlm_ctxt *dlm,
>  	unsigned int run_max, unused;
>  	unsigned long purge_jiffies;
>  	struct dlm_lock_resource *lockres;
> +	int ret;
> +
> +#define DLM_WAIT_RECOVERY_FINISH_MS 500
>  
>  	spin_lock(&dlm->spinlock);
>  	run_max = dlm->purge_count;
> @@ -258,10 +287,22 @@ static void dlm_run_purge_list(struct dlm_ctxt *dlm,
>  		 * spinlock. */
>  		spin_lock(&lockres->spinlock);
>  		unused = __dlm_lockres_unused(lockres);
> -		spin_unlock(&lockres->spinlock);
> -
> -		if (!unused)
> +		if (!unused) {
> +			spin_unlock(&lockres->spinlock);
>  			continue;
> +		}
> +		if (lockres->state & DLM_LOCK_RES_RECOVERING) {
> +			list_move_tail(&lockres->purge, &dlm->purge_list);
> +			spin_unlock(&lockres->spinlock);
> +			spin_unlock(&dlm->spinlock);
> +			mlog(ML_NOTICE, "retry to purge %.*s after %dms\n",
> +			     lockres->lockname.len, lockres->lockname.name,
> +			     DLM_WAIT_RECOVERY_FINISH_MS);
> +			msleep(DLM_WAIT_RECOVERY_FINISH_MS);
>   
I prefer the idea of keeping the lockres on the purge list longer if it 
has to be than putting dlm_thread to sleep. Not sure if it has to sleep, 
if a lockres cannot be purged dlmthread should move to next one or move 
the lockres to the end of the purgelist. there is no harm in having the 
lockres on the purge list longer if it has to be.
> +			spin_lock(&dlm->spinlock);
> +			continue;
> +		}
> +		spin_unlock(&lockres->spinlock);
>  
>  		purge_jiffies = lockres->last_used +
>  			msecs_to_jiffies(DLM_PURGE_INTERVAL_MS);
> @@ -280,8 +321,22 @@ static void dlm_run_purge_list(struct dlm_ctxt *dlm,
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
> +				spin_lock(&lockres->spinlock);
> +				list_move_tail(&lockres->purge,
> +					       &dlm->purge_list);
> +				spin_unlock(&lockres->spinlock);
> +				continue;
> +			} else
> +				BUG();
> +		}
>  
>  		dlm_lockres_put(lockres);
>  
>   
