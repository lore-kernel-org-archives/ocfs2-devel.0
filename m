From: xuejiufei <xuejiufei@huawei.com>
Date: Wed, 30 Dec 2015 17:56:56 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: ignore cleaning the migration
 mle that is inuse
In-Reply-To: <568346E8.1060105@oracle.com>
References: <567E3C07.2000305@huawei.com> <5680E845.8080509@huawei.com>
	<568346E8.1060105@oracle.com>
Message-ID: <5683AA68.2050304@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Junxiao,
You are right. But it may happen that mle->woken is set to 1 in
dlm_clean_migration_mle() just after atomic_read() in
dlm_migrate_lockres(). Actually we trigger this BUG when dlm_send_one_lockres()
return error.

And I think dlm_migrate_lockres() should not set owner to target and return 0
when mle->woken is set to 1 in dlm_clean_migration_mle(). This is another problem?

Thanks
Jiufei.

On 2015/12/30 10:52, Junxiao Bi wrote:
> Hi Jiufei,
> 
> When target node down, mle is cleared from
> dlm_do_local_recovery_cleanup()->dlm_clean_master_list()->dlm_clean_migration_mle()?
> mle->woken is set to 1 in dlm_clean_migration_mle(), so the code to
> detect target node down(if (dlm_is_node_dead(dlm, target))) will never
> be run in dlm_migrate_lockres()?
> 
> 
> 2621         while (1) {
> 2622                 ret = wait_event_interruptible_timeout(mle->wq,
> 2623                                         (atomic_read(&mle->woken)
> == 1),
> 2624                                         msecs_to_jiffies(5000));
> 2625
> 2626                 if (ret >= 0) {
> 2627                         if (atomic_read(&mle->woken) == 1 ||
> 2628                             res->owner == target)
> 2629                                 break;
> 2630
> 2631                         mlog(0, "%s:%.*s: timed out during
> migration\n",
> 2632                              dlm->name, res->lockname.len,
> res->lockname.name);
> 2633                         /* avoid hang during shutdown when
> migrating lockres
> 2634                          * to a node which also goes down */
> 2635                         if (dlm_is_node_dead(dlm, target)) {
> 2636                                 mlog(0, "%s:%.*s: expected migration "
> 2637                                      "target %u is no longer up,
> restarting\n",
> 2638                                      dlm->name, res->lockname.len,
> 2639                                      res->lockname.name, target);
> 2640                                 ret = -EINVAL;
> 2641                                 /* migration failed, detach and
> clean up mle */
> 2642                                 dlm_mle_detach_hb_events(dlm, mle);
> 2643                                 dlm_put_mle(mle);
> 2644                                 dlm_put_mle_inuse(mle);
> 2645                                 spin_lock(&res->spinlock);
> 2646                                 res->state &= ~DLM_LOCK_RES_MIGRATING;
> 2647                                 wake = 1;
> 2648                                 spin_unlock(&res->spinlock);
> 2649                                 goto leave;
> 2650                         }
> 2651                 } else
> 2652                         mlog(0, "%s:%.*s: caught signal during
> migration\n",
> 2653                              dlm->name, res->lockname.len,
> res->lockname.name);
> 2654         }
> 
> 
> Thanks,
> Junxiao.
> On 12/28/2015 03:44 PM, xuejiufei wrote:
>> We have found that migration source will trigger a BUG that the
>> refcount of mle is already zero before put when the target is
>> down during migration. The situation is as follows:
>>
>> dlm_migrate_lockres
>>   dlm_add_migration_mle
>>   dlm_mark_lockres_migrating
>>   dlm_get_mle_inuse
>>   <<<<<< Now the refcount of the mle is 2.
>>   dlm_send_one_lockres and wait for the target to become the
>>   new master.
>>   <<<<<< o2hb detect the target down and clean the migration
>>   mle. Now the refcount is 1.
>>
>> dlm_migrate_lockres woken, and put the mle twice when found
>> the target goes down which trigger the BUG with the following
>> message:
>> "ERROR: bad mle: ".
>>
>> Signed-off-by: Jiufei Xue <xuejiufei@huawei.com>
>> Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
>> ---
>>  fs/ocfs2/dlm/dlmmaster.c | 26 +++++++++++++++-----------
>>  1 file changed, 15 insertions(+), 11 deletions(-)
>>
>> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
>> index 936e11b..b713140 100644
>> --- a/fs/ocfs2/dlm/dlmmaster.c
>> +++ b/fs/ocfs2/dlm/dlmmaster.c
>> @@ -2519,6 +2519,11 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
>>  	spin_lock(&dlm->master_lock);
>>  	ret = dlm_add_migration_mle(dlm, res, mle, &oldmle, name,
>>  				    namelen, target, dlm->node_num);
>> +	/* get an extra reference on the mle.
>> +	 * otherwise the assert_master from the new
>> +	 * master will destroy this.
>> +	 */
>> +	dlm_get_mle_inuse(mle);
>>  	spin_unlock(&dlm->master_lock);
>>  	spin_unlock(&dlm->spinlock);
>>
>> @@ -2554,6 +2559,7 @@ fail:
>>  		if (mle_added) {
>>  			dlm_mle_detach_hb_events(dlm, mle);
>>  			dlm_put_mle(mle);
>> +			dlm_put_mle_inuse(mle);
>>  		} else if (mle) {
>>  			kmem_cache_free(dlm_mle_cache, mle);
>>  			mle = NULL;
>> @@ -2571,17 +2577,6 @@ fail:
>>  	 * ensure that all assert_master work is flushed. */
>>  	flush_workqueue(dlm->dlm_worker);
>>
>> -	/* get an extra reference on the mle.
>> -	 * otherwise the assert_master from the new
>> -	 * master will destroy this.
>> -	 * also, make sure that all callers of dlm_get_mle
>> -	 * take both dlm->spinlock and dlm->master_lock */
>> -	spin_lock(&dlm->spinlock);
>> -	spin_lock(&dlm->master_lock);
>> -	dlm_get_mle_inuse(mle);
>> -	spin_unlock(&dlm->master_lock);
>> -	spin_unlock(&dlm->spinlock);
>> -
>>  	/* notify new node and send all lock state */
>>  	/* call send_one_lockres with migration flag.
>>  	 * this serves as notice to the target node that a
>> @@ -3312,6 +3307,15 @@ top:
>>  			    mle->new_master != dead_node)
>>  				continue;
>>
>> +			if (mle->new_master == dead_node && mle->inuse) {
>> +				mlog(ML_NOTICE, "%s: target %u died during "
>> +						"migration from %u, the MLE is "
>> +						"still keep used, ignore it!\n",
>> +						dlm->name, dead_node,
>> +						mle->master);
>> +				continue;
>> +			}
>> +
>>  			/* If we have reached this point, this mle needs to be
>>  			 * removed from the list and freed. */
>>  			dlm_clean_migration_mle(dlm, mle);
>>
> 
> 
> .
> 
