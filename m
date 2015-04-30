From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Thu, 30 Apr 2015 22:30:25 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2/dlm: fix race between purge and
 get lock resource
In-Reply-To: <5541D418.20802@huawei.com>
References: <553B6FF3.8010805@huawei.com> <5541C8C4.1070005@oracle.com>
	<5541D418.20802@huawei.com>
Message-ID: <55423C81.4000907@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 04/30/2015 03:04 PM, Joseph Qi wrote:
> Hi Junxiao,
>
> On 2015/4/30 14:16, Junxiao Bi wrote:
>> On 04/25/2015 06:44 PM, Joseph Qi wrote:
>>> There is a race between purge and get lock resource, which will lead to
>>> ast unfinished and system hung. The case is described below:
>>>
>>> mkdir                                  dlm_thread
>>> -----------------------------------------------------------------------
>>> o2cb_dlm_lock                        |
>>> -> dlmlock                           |
>>>     -> dlm_get_lock_resource           |
>>>       -> __dlm_lookup_lockres_full     |
>>>         -> spin_unlock(&dlm->spinlock) |
>>>                                        | dlm_run_purge_list
>>>                                        | -> dlm_purge_lockres
>>>                                        |   -> dlm_drop_lockres_ref
>>>                                        |   -> spin_lock(&dlm->spinlock)
>>>                                        |   -> spin_lock(&res->spinlock)
>>>                                        |   -> ~DLM_LOCK_RES_DROPPING_REF
>>>                                        |   -> spin_unlock(&res->spinlock)
>>>                                        |   -> spin_unlock(&dlm->spinlock)
>>>         -> spin_lock(&tmpres->spinlock)|
>>>         DLM_LOCK_RES_DROPPING_REF cleared |
>>>         -> spin_unlock(&tmpres->spinlock) |
>>>         return the purged lockres         |
>>>
>>> So after this, once ast comes, it will ignore the ast because the
>>> lockres cannot be found anymore. Thus the OCFS2_LOCK_BUSY won't be
>>> cleared and corresponding thread hangs.
>>> The &dlm->spinlock was hold when checking DLM_LOCK_RES_DROPPING_REF at
>>> the very beginning. And commit 7b791d68562e ("ocfs2/dlm: Fix race during
>>> lockres mastery") moved it up because of the possible wait.
>>> So take the &dlm->spinlock and introduce a new wait function to fix the
>>> race.
>> The fix to this issue seemed a little complicated.
>>
>> Indeed this is a similar issue with commit cb79662bc2f83f7b3b60970ad88df43085f96514 ("ocfs2: o2dlm: fix a race between purge and master query"), we can reference that fix. How about the following fix?
>>
>> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
>> index a6944b2..25314d2 100644
>> --- a/fs/ocfs2/dlm/dlmmaster.c
>> +++ b/fs/ocfs2/dlm/dlmmaster.c
>> @@ -757,6 +757,18 @@ lookup:
>>          if (tmpres) {
>>                  spin_unlock(&dlm->spinlock);
>>                  spin_lock(&tmpres->spinlock);
>> +
>> +               /*
>> +                * Right after dlm spinlock was released, dlm_thread could have
>> +                * purged the lockres. Check if lockres got unhashed. If so
>> +                * start over.
>> +                */
>> +               if (hlist_unhashed(&tmpres->hash_node)) {
>> +                       spin_unlock(&tmpres->spinlock);
>> +                       dlm_lockres_put(tmpres);
>> +                       goto lookup;
>> +               }
>> +
>>                  /* Wait on the thread that is mastering the resource */
>>                  if (tmpres->owner == DLM_LOCK_RES_OWNER_UNKNOWN) {
>>                          __dlm_wait_on_lockres(tmpres);
>>
>> Thanks,
>> Junxiao.
> Thanks very much for the above fix.
> It looks good to me and much simpler than my fix.
> A small suggestion is setting tmpres to NULL after dlm_lockres_put to keep
> consistency.
> Could you please send a new version?
Sure, patch sent, thanks for your advice.

Thanks,
Junxiao.
>
>>> Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
>>> Reviewed-by: joyce.xue <xuejiufei@huawei.com>
>>> Cc: <stable@vger.kernel.org>
>>> ---
>>>    fs/ocfs2/dlm/dlmcommon.h |  2 ++
>>>    fs/ocfs2/dlm/dlmmaster.c | 13 +++++++++----
>>>    fs/ocfs2/dlm/dlmthread.c | 23 +++++++++++++++++++++++
>>>    3 files changed, 34 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
>>> index e88ccf8..c6b76f4 100644
>>> --- a/fs/ocfs2/dlm/dlmcommon.h
>>> +++ b/fs/ocfs2/dlm/dlmcommon.h
>>> @@ -1014,6 +1014,8 @@ void dlm_move_lockres_to_recovery_list(struct dlm_ctxt *dlm,
>>>
>>>    /* will exit holding res->spinlock, but may drop in function */
>>>    void __dlm_wait_on_lockres_flags(struct dlm_lock_resource *res, int flags);
>>> +void __dlm_wait_on_lockres_flags_new(struct dlm_ctxt *dlm,
>>> +        struct dlm_lock_resource *res, int flags);
>>>
>>>    /* will exit holding res->spinlock, but may drop in function */
>>>    static inline void __dlm_wait_on_lockres(struct dlm_lock_resource *res)
>>> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
>>> index a6944b2..9a5f45d 100644
>>> --- a/fs/ocfs2/dlm/dlmmaster.c
>>> +++ b/fs/ocfs2/dlm/dlmmaster.c
>>> @@ -755,13 +755,16 @@ lookup:
>>>        spin_lock(&dlm->spinlock);
>>>        tmpres = __dlm_lookup_lockres_full(dlm, lockid, namelen, hash);
>>>        if (tmpres) {
>>> -        spin_unlock(&dlm->spinlock);
>>>            spin_lock(&tmpres->spinlock);
>>>            /* Wait on the thread that is mastering the resource */
>>>            if (tmpres->owner == DLM_LOCK_RES_OWNER_UNKNOWN) {
>>> -            __dlm_wait_on_lockres(tmpres);
>>> +            __dlm_wait_on_lockres_flags_new(dlm, tmpres,
>>> +                    (DLM_LOCK_RES_IN_PROGRESS|
>>> +                    DLM_LOCK_RES_RECOVERING|
>>> +                    DLM_LOCK_RES_MIGRATING));
>>>                BUG_ON(tmpres->owner == DLM_LOCK_RES_OWNER_UNKNOWN);
>>>                spin_unlock(&tmpres->spinlock);
>>> +            spin_unlock(&dlm->spinlock);
>>>                dlm_lockres_put(tmpres);
>>>                tmpres = NULL;
>>>                goto lookup;
>>> @@ -770,9 +773,10 @@ lookup:
>>>            /* Wait on the resource purge to complete before continuing */
>>>            if (tmpres->state & DLM_LOCK_RES_DROPPING_REF) {
>>>                BUG_ON(tmpres->owner == dlm->node_num);
>>> -            __dlm_wait_on_lockres_flags(tmpres,
>>> -                            DLM_LOCK_RES_DROPPING_REF);
>>> +            __dlm_wait_on_lockres_flags_new(dlm, tmpres,
>>> +                DLM_LOCK_RES_DROPPING_REF);
>>>                spin_unlock(&tmpres->spinlock);
>>> +            spin_unlock(&dlm->spinlock);
>>>                dlm_lockres_put(tmpres);
>>>                tmpres = NULL;
>>>                goto lookup;
>>> @@ -782,6 +786,7 @@ lookup:
>>>            dlm_lockres_grab_inflight_ref(dlm, tmpres);
>>>
>>>            spin_unlock(&tmpres->spinlock);
>>> +        spin_unlock(&dlm->spinlock);
>>>            if (res)
>>>                dlm_lockres_put(res);
>>>            res = tmpres;
>>> diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
>>> index 69aac6f..505730a 100644
>>> --- a/fs/ocfs2/dlm/dlmthread.c
>>> +++ b/fs/ocfs2/dlm/dlmthread.c
>>> @@ -77,6 +77,29 @@ repeat:
>>>        __set_current_state(TASK_RUNNING);
>>>    }
>>>
>>> +void __dlm_wait_on_lockres_flags_new(struct dlm_ctxt *dlm,
>>> +        struct dlm_lock_resource *res, int flags)
>>> +{
>>> +    DECLARE_WAITQUEUE(wait, current);
>>> +
>>> +    assert_spin_locked(&dlm->spinlock);
>>> +    assert_spin_locked(&res->spinlock);
>>> +
>>> +    add_wait_queue(&res->wq, &wait);
>>> +repeat:
>>> +    set_current_state(TASK_UNINTERRUPTIBLE);
>>> +    if (res->state & flags) {
>>> +        spin_unlock(&res->spinlock);
>>> +        spin_unlock(&dlm->spinlock);
>>> +        schedule();
>>> +        spin_lock(&dlm->spinlock);
>>> +        spin_lock(&res->spinlock);
>>> +        goto repeat;
>>> +    }
>>> +    remove_wait_queue(&res->wq, &wait);
>>> +    __set_current_state(TASK_RUNNING);
>>> +}
>>> +
>>>    int __dlm_lockres_has_locks(struct dlm_lock_resource *res)
>>>    {
>>>        if (list_empty(&res->granted) &&
>>
>> .
>>
>
