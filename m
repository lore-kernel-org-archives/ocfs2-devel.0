From: piaojun <piaojun@huawei.com>
Date: Fri, 6 Jan 2017 10:07:27 +0800
Subject: [Ocfs2-devel] [PATCH v2 3/3] ocfs2/dlm: continue to purge
 recovery lockres when recovery master goes down
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E37342E73695@H3CMLB12-EX.srv.huawei-3com.com>
References: <578453AF.8030404@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E37342E72604@H3CMLB12-EX.srv.huawei-3com.com>
	<63ADC13FD55D6546B7DECE290D39E37342E73695@H3CMLB12-EX.srv.huawei-3com.com>
Message-ID: <586EFBDF.7090008@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 2017/1/5 15:44, Gechangwei wrote:
> On 2017/1/5 15:28, gechangwei 12382 (Cloud) wrote:
> 
> Hi Jun,
> I suppose that a defect hid your patch.
> 
> 
>> We found a dlm-blocked situation caused by continuous breakdown of recovery masters described below. To solve this problem, we should purge recovery lock once detecting recovery master goes down.
>>
>> N3                      N2                   N1(reco master)
>>                         go down
>>                                              pick up recovery lock and
>>                                              begin recoverying for N2
>>
>>                                              go down
>>
>> pick up recovery
>> lock failed, then
>> purge it:
>> dlm_purge_lockres
>>   ->DROPPING_REF is set
>>
>> send deref to N1 failed,
>> recovery lock is not purged
>>
>> find N1 go down, begin
>> recoverying for N1, but
>> blocked in dlm_do_recovery
>> as DROPPING_REF is set:
>> dlm_do_recovery
>>   ->dlm_pick_recovery_master
>>     ->dlmlock
>>       ->dlm_get_lock_resource
>>         ->__dlm_wait_on_lockres_flags(tmpres,
>>               DLM_LOCK_RES_DROPPING_REF);
>>
>> Fixes: 8c0343968163 ("ocfs2/dlm: clear DROPPING_REF flag when the master goes down")
>>
>> Signed-off-by: Jun Piao <piaojun@huawei.com>
>> Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
>> Reviewed-by: Jiufei Xue <xuejiufei@huawei.com>
>> ---
>>  fs/ocfs2/dlm/dlmcommon.h   |  2 ++
>>  fs/ocfs2/dlm/dlmmaster.c   | 38 +++------------------------------
>>  fs/ocfs2/dlm/dlmrecovery.c | 29 +++++++++++++++++++-------
>>  fs/ocfs2/dlm/dlmthread.c   | 52 ++++++++++++++++++++++++++++++++++++++++++----
>>  4 files changed, 74 insertions(+), 47 deletions(-)
>>
>> diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h index 004f2cb..3e3e9ba8 100644
>> --- a/fs/ocfs2/dlm/dlmcommon.h
>> +++ b/fs/ocfs2/dlm/dlmcommon.h
>> @@ -1004,6 +1004,8 @@ int dlm_finalize_reco_handler(struct o2net_msg *msg, u32 len, void *data,  int dlm_do_master_requery(struct dlm_ctxt *dlm, struct dlm_lock_resource *res,
>>                         u8 nodenum, u8 *real_master);
>>
>> +void __dlm_do_purge_lockres(struct dlm_ctxt *dlm,
>> +             struct dlm_lock_resource *res);
>>
>>  int dlm_dispatch_assert_master(struct dlm_ctxt *dlm,
>>                              struct dlm_lock_resource *res, diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c index 311404f..1d87e0f 100644
>> --- a/fs/ocfs2/dlm/dlmmaster.c
>> +++ b/fs/ocfs2/dlm/dlmmaster.c
>> @@ -2425,52 +2425,20 @@ int dlm_deref_lockres_done_handler(struct o2net_msg *msg, u32 len, void *data,
>>               mlog(ML_NOTICE, "%s:%.*s: node %u sends deref done "
>>                       "but it is already derefed!\n", dlm->name,
>>                       res->lockname.len, res->lockname.name, node);
>> -             dlm_lockres_put(res);
>>               ret = 0;
>>               goto done;
>>       }
>> -
>> -     if (!list_empty(&res->purge)) {
>> -             mlog(0, "%s: Removing res %.*s from purgelist\n",
>> -                     dlm->name, res->lockname.len, res->lockname.name);
>> -             list_del_init(&res->purge);
>> -             dlm_lockres_put(res);
>> -             dlm->purge_count--;
>> -     }
>> -
>> -     if (!__dlm_lockres_unused(res)) {
>> -             mlog(ML_ERROR, "%s: res %.*s in use after deref\n",
>> -                     dlm->name, res->lockname.len, res->lockname.name);
>> -             __dlm_print_one_lock_resource(res);
>> -             BUG();
>> -     }
>> -
>> -     __dlm_unhash_lockres(dlm, res);
>> -
>> -     spin_lock(&dlm->track_lock);
>> -     if (!list_empty(&res->tracking))
>> -             list_del_init(&res->tracking);
>> -     else {
>> -             mlog(ML_ERROR, "%s: Resource %.*s not on the Tracking list\n",
>> -                  dlm->name, res->lockname.len, res->lockname.name);
>> -             __dlm_print_one_lock_resource(res);
>> -     }
>> -     spin_unlock(&dlm->track_lock);
>> -
>> -     /* lockres is not in the hash now. drop the flag and wake up
>> -      * any processes waiting in dlm_get_lock_resource.
>> -      */
>> -     res->state &= ~DLM_LOCK_RES_DROPPING_REF;
>> +     __dlm_do_purge_lockres(dlm, res);
>>       spin_unlock(&res->spinlock);
>>       wake_up(&res->wq);
>>
>> -     dlm_lockres_put(res);
>> -
>>       spin_unlock(&dlm->spinlock);
>>
>>       ret = 0;
>>
>>  done:
>> +     if (res)
>> +             dlm_lockres_put(res);
>>       dlm_put(dlm);
>>       return ret;
>>  }
>> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c index f6b3138..dd5cb8b 100644
>> --- a/fs/ocfs2/dlm/dlmrecovery.c
>> +++ b/fs/ocfs2/dlm/dlmrecovery.c
>> @@ -2343,6 +2343,7 @@ static void dlm_do_local_recovery_cleanup(struct dlm_ctxt *dlm, u8 dead_node)
>>       struct dlm_lock_resource *res;
>>       int i;
>>       struct hlist_head *bucket;
>> +     struct hlist_node *tmp;
>>       struct dlm_lock *lock;
>>
>>
>> @@ -2365,7 +2366,7 @@ static void dlm_do_local_recovery_cleanup(struct dlm_ctxt *dlm, u8 dead_node)
>>        */
>>       for (i = 0; i < DLM_HASH_BUCKETS; i++) {
>>               bucket = dlm_lockres_hash(dlm, i);
>> -             hlist_for_each_entry(res, bucket, hash_node) {
>> +             hlist_for_each_entry_safe(res, tmp, bucket, hash_node) {
>>                       /* always prune any $RECOVERY entries for dead nodes,
>>                        * otherwise hangs can occur during later recovery */
>>                       if (dlm_is_recovery_lock(res->lockname.name,
>> @@ -2386,8 +2387,17 @@ static void dlm_do_local_recovery_cleanup(struct dlm_ctxt *dlm, u8 dead_node)
>>                                               break;
>>                                       }
>>                               }
>> -                             dlm_lockres_clear_refmap_bit(dlm, res,
>> -                                             dead_node);
>> +
>> +                             if ((res->owner == dead_node) &&
>> +                                                     (res->state & DLM_LOCK_RES_DROPPING_REF)) {
>> +                                     dlm_lockres_get(res);
>> +                                     __dlm_do_purge_lockres(dlm, res);
>> +                                     spin_unlock(&res->spinlock);
>> +                                     wake_up(&res->wq);
>> +                                     dlm_lockres_put(res);
>> +                                     continue;
>> +                             } else if (res->owner == dlm->node_num)
>> +                                     dlm_lockres_clear_refmap_bit(dlm, res, dead_node);
>>                               spin_unlock(&res->spinlock);
>>                               continue;
>>                       }
>> @@ -2398,14 +2408,17 @@ static void dlm_do_local_recovery_cleanup(struct dlm_ctxt *dlm, u8 dead_node)
>>                               if (res->state & DLM_LOCK_RES_DROPPING_REF) {
>>                                       mlog(0, "%s:%.*s: owned by "
>>                                               "dead node %u, this node was "
>> -                                             "dropping its ref when it died. "
>> -                                             "continue, dropping the flag.\n",
>> +                                             "dropping its ref when master died. "
>> +                                             "continue, purging the lockres.\n",
>>                                               dlm->name, res->lockname.len,
>>                                               res->lockname.name, dead_node);
>> +                                     dlm_lockres_get(res);
>> +                                     __dlm_do_purge_lockres(dlm, res);
>> +                                     spin_unlock(&res->spinlock);
>> +                                     wake_up(&res->wq);
>> +                                     dlm_lockres_put(res);
>> +                                     continue;
>>                               }
>> -                             res->state &= ~DLM_LOCK_RES_DROPPING_REF;
>> -                             dlm_move_lockres_to_recovery_list(dlm,
>> -                                             res);
> 
> Here, you just remove above line, thus, no chance for DLM to select lock
> resources to be recovered, is right?
> 
> 
> 
Here we purge lockres directly instead of moving to recovery list
when DLM_LOCK_RES_DROPPING_REF is set in case of deadlock.

Thanks,
Jun

>>                       } else if (res->owner == dlm->node_num) {
>>                               dlm_free_dead_locks(dlm, res, dead_node);
>>                               __dlm_lockres_calc_usage(dlm, res); diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c index ce39722..838a06d 100644
>> --- a/fs/ocfs2/dlm/dlmthread.c
>> +++ b/fs/ocfs2/dlm/dlmthread.c
>> @@ -160,6 +160,52 @@ void dlm_lockres_calc_usage(struct dlm_ctxt *dlm,
>>       spin_unlock(&dlm->spinlock);
>>  }
>>
>> +/*
>> + * Do the real purge work:
>> + *     unhash the lockres, and
>> + *     clear flag DLM_LOCK_RES_DROPPING_REF.
>> + * It requires dlm and lockres spinlock to be taken.
>> + */
>> +void __dlm_do_purge_lockres(struct dlm_ctxt *dlm,
>> +             struct dlm_lock_resource *res)
>> +{
>> +     assert_spin_locked(&dlm->spinlock);
>> +     assert_spin_locked(&res->spinlock);
>> +
>> +     if (!list_empty(&res->purge)) {
>> +             mlog(0, "%s: Removing res %.*s from purgelist\n",
>> +                  dlm->name, res->lockname.len, res->lockname.name);
>> +             list_del_init(&res->purge);
>> +             dlm_lockres_put(res);
>> +             dlm->purge_count--;
>> +     }
>> +
>> +     if (!__dlm_lockres_unused(res)) {
>> +             mlog(ML_ERROR, "%s: res %.*s in use after deref\n",
>> +                  dlm->name, res->lockname.len, res->lockname.name);
>> +             __dlm_print_one_lock_resource(res);
>> +             BUG();
>> +     }
>> +
>> +     __dlm_unhash_lockres(dlm, res);
>> +
>> +     spin_lock(&dlm->track_lock);
>> +     if (!list_empty(&res->tracking))
>> +             list_del_init(&res->tracking);
>> +     else {
>> +             mlog(ML_ERROR, "%s: Resource %.*s not on the Tracking list\n",
>> +                  dlm->name, res->lockname.len, res->lockname.name);
>> +             __dlm_print_one_lock_resource(res);
>> +     }
>> +     spin_unlock(&dlm->track_lock);
>> +
>> +     /*
>> +      * lockres is not in the hash now. drop the flag and wake up
>> +      * any processes waiting in dlm_get_lock_resource.
>> +      */
>> +     res->state &= ~DLM_LOCK_RES_DROPPING_REF; }
>> +
>>  static void dlm_purge_lockres(struct dlm_ctxt *dlm,
>>                            struct dlm_lock_resource *res)
>>  {
>> @@ -176,10 +222,8 @@ static void dlm_purge_lockres(struct dlm_ctxt *dlm,
>>
>>       if (!master) {
>>               if (res->state & DLM_LOCK_RES_DROPPING_REF) {
>> -                     mlog(ML_NOTICE, "%s: res %.*s already in "
>> -                             "DLM_LOCK_RES_DROPPING_REF state\n",
>> -                             dlm->name, res->lockname.len,
>> -                             res->lockname.name);
>> +                     mlog(ML_NOTICE, "%s: res %.*s already in DLM_LOCK_RES_DROPPING_REF state\n",
>> +                             dlm->name, res->lockname.len, res->lockname.name);
>>                       spin_unlock(&res->spinlock);
>>                       return;
>>               }
>> --
>> 1.8.4.3
>>
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
> 
> -------------------------------------------------------------------------------------------------------------------------------------
> ????????????????????????????????????????
> ????????????????????????????????????????
> ????????????????????????????????????????
> ???
> This e-mail and its attachments contain confidential information from H3C, which is
> intended only for the person or entity whose address is listed above. Any use of the
> information contained herein in any way (including, but not limited to, total or partial
> disclosure, reproduction, or dissemination) by persons other than the intended
> recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
> by phone or email immediately and delete it!
> 
