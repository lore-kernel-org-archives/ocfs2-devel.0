From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Tue, 19 Jan 2016 17:02:39 +0800
Subject: [Ocfs2-devel] ocfs2: A race between refmap setting and clearing
In-Reply-To: <569DF19B.9000904@huawei.com>
References: <56931785.2090603@huawei.com> <56947B02.7030503@oracle.com>
	<5694A857.5020906@huawei.com> <5695BA7D.90009@oracle.com>
	<5695ECE6.7050709@huawei.com> <5695F616.9040105@oracle.com>
	<569609BE.8050802@huawei.com> <569C69E4.6030500@oracle.com>
	<569C8F39.6090802@huawei.com> <569DA777.4000909@oracle.com>
	<569DF19B.9000904@huawei.com>
Message-ID: <569DFBAF.6000703@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jiufei,

Right. Revert that patch will introduce that dis-order, thank you for
pointing it out. I will think about more about it. My idea is to do some
refactor to make it more smooth while not introducing complicated things
to just fix that bug.

Thanks,
Junxiao.
On 01/19/2016 04:19 PM, xuejiufei wrote:
> Hi Junxiao,
> commit f3f854648de64c4b6f13f6f13113bc9525c621e5 is to solve
> the disorder problem of set/clear refmap on master.
> If it is reverted, how to fix the problem the patch
> described?

> 
> I think the following is the issue that patch fixed.
> The set refmap bit message is sent before the clear refmap
> message. But these two message is processed by different
> processes, so the set refmap message may be handled before the clear.
> 
> Node 1                                    Node 2(master)
>                                dlm_wq                  o2net_wq
>                            dlm_do_assert_master
> dlm_do_assert_handler
> return MASTERY_REF
>                            receive MASTERY_REF
> dlm_purge_lockres
> send deref message
>                                            receive deref message
>                                            -> dlm_deref_lockres_handler
>                                               and clear refmap
>                            -> set refmap
> 
> On 2016/1/19 11:03, Junxiao Bi wrote:
>> Hi Jiufei & Joseph,
>>
>> On 01/18/2016 03:07 PM, xuejiufei wrote:
>>>
>>>
>>> On 2016/1/18 12:28, Junxiao Bi wrote:
>>>> On 01/13/2016 04:24 PM, Joseph Qi wrote:
>>>>> Hi Junxiao,
>>>>>
>>>>> On 2016/1/13 15:00, Junxiao Bi wrote:
>>>>>> On 01/13/2016 02:21 PM, xuejiufei wrote:
>>>>>>> Hi Junxiao,
>>>>>>> I have not describe the issue clearly.
>>>>>>>
>>>>>>> Node 1                               Node 2(master)
>>>>>>> dlmlock
>>>>>>> dlm_do_master_request
>>>>>>>                                 dlm_master_request_handler
>>>>>>>                                 -> dlm_lockres_set_refmap_bit
>>>>>>> dlmlock succeed
>>>>>>> dlmunlock succeed
>>>>>>>
>>>>>>> dlm_purge_lockres
>>>>>>>                                 dlm_deref_handler
>>>>>>>                                 -> find lock resource is in
>>>>>>>                                    DLM_LOCK_RES_SETREF_INPROG state,
>>>>>>>                                    so dispatch a deref work
>>>>>>> dlm_purge_lockres succeed.
>>>>>>>
>>>>>>> call dlmlock again
>>>>>>> dlm_do_master_request
>>>>>>>                                 dlm_master_request_handler
>>>>>>>                                 -> dlm_lockres_set_refmap_bit
>>>>>>>
>>>>>>>                                 deref work trigger, call
>>>>>>>                                 dlm_lockres_clear_refmap_bit
>>>>>>>                                 to clear Node 1 from refmap
>>>>>>>
>>>>>>>                                 dlm_purge_lockres succeed
>>>>>>>
>>>>>>> dlm_send_remote_lock_request
>>>>>>>                                 return DLM_IVLOCKID because
>>>>>>>                                 the lockres is not exist
>>>>>> More clear now. Thank you.
>>>>>> This is a very complicated race. I didn't have a good solution to fix it
>>>>>> now. Your fix looks work, but I am afraid if we keep going fix this
>>>>>> kinds of races case by case, we will make dlm harder to understand and
>>>>>> easy to involve bugs, maybe we should think about refactor dlm.
>>>>>>
>>>>> Agree. IMO, the root cause is bit op cannot handle such a case.
>>>>> I wonder if we have to change it to refcount, which may require a much
>>>>> bigger refactoring.
>>>> one bit for each node seems reasonable, as lockres is per node. I think
>>>> the cause is the dis-order of set/clear, i am trying to see whether they
>>>> can be made happen in order.
>>>>
>>> Agree. The solution 1) in my first mail is going to add a new message to
>>> keep the order of set and clear. Other nodes can purge the lock resource
>>> only after the refmap on master is cleared.
>> I am taking another way, try to delete deref_lockres_worker, and make
>> deref refmap happen directly in deref handler. This needs find the
>> dis-order part and fix. As I can see, the dis-order can only happen at
>> do_assert_master set refmap after deref_lockres_handler clear it?
>>
>> For this, need make sure not return MASTERY_REF to owner after purge.
>> SETREF_INPROG is designed to do this. It is set by assert_master_handler
>> and purge will wait it cleared before deref lockres. There are two cases
>> where SETREF_INPROG is not set when purge
>>
>> 1. assert master message not coming when purge()
>> This happened when lockres owner already exist when asking for a
>> lockres. Lockres owner will be known from master request message and
>> dlm_get_lock_resouces return. Soon dlmlock/dlmunlock is done, and purge
>> done. Then assert master message coming, but since MLE have been deleted
>> in dlm_get_lock_resouce, it will not return MASTERY_REF to owner to
>> reset refmap. So no problem in this case.
>>
>> 2. assert master handler set SETREF_INPROG too late
>> SETREF_INPROG is set after lockres owner has been updated and
>> dlm->spinlock released. That will make dlm_get_lock_resource waken up
>> too fast, and then purge may happen before SETREF_INPROG is set. This is
>> a bug and can be fix by the following patch.
>>
>> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
>> index 9477d6e1de37..83cd65b128d0 100644
>> --- a/fs/ocfs2/dlm/dlmmaster.c
>> +++ b/fs/ocfs2/dlm/dlmmaster.c
>> @@ -1965,6 +1965,7 @@ ok:
>>                 if (res) {
>>                         int wake = 0;
>>                         spin_lock(&res->spinlock);
>> +                       res->state |= DLM_LOCK_RES_SETREF_INPROG;
>>                         if (mle->type == DLM_MLE_MIGRATION) {
>>                                 mlog(0, "finishing off migration of
>> lockres %.*s, "
>>                                         "from %u to %u\n",
>> @@ -2029,12 +2030,8 @@ ok:
>>
>>  done:
>>         ret = 0;
>> -       if (res) {
>> -               spin_lock(&res->spinlock);
>> -               res->state |= DLM_LOCK_RES_SETREF_INPROG;
>> -               spin_unlock(&res->spinlock);
>> +       if (res)
>>                 *ret_data = (void *)res;
>> -       }
>>         dlm_put(dlm);
>>         if (master_request) {
>>                 mlog(0, "need to tell master to reassert\n");
>>
>>
>> Besides this path, revert commit
>> f3f854648de64c4b6f13f6f13113bc9525c621e5 ("ocfs2_dlm: Ensure correct
>> ordering of set/clear refmap bit on lockres"), can this fix this issue?
>>
>> Thanks,
>> Junxiao.
>>
>>
>>
>>>
>>> Thanks
>>> Jiufei
>>>
>>>> Thanks,
>>>> Junxiao.
>>>>>
>>>>> Thanks,
>>>>> Joseph
>>>>>
>>>>>> Thanks,
>>>>>> Junxiao.
>>>>>>
>>>>>>> BUG if the lockres is $RECOVERY
>>>>>>>
>>>>>>> On 2016/1/13 10:46, Junxiao Bi wrote:
>>>>>>>> On 01/12/2016 03:16 PM, xuejiufei wrote:
>>>>>>>>> Hi, Junxiao
>>>>>>>>>
>>>>>>>>> On 2016/1/12 12:03, Junxiao Bi wrote:
>>>>>>>>>> Hi Jiufei,
>>>>>>>>>>
>>>>>>>>>> On 01/11/2016 10:46 AM, xuejiufei wrote:
>>>>>>>>>>> Hi all,
>>>>>>>>>>> We have found a race between refmap setting and clearing which
>>>>>>>>>>> will cause the lock resource on master is freed before other nodes
>>>>>>>>>>> purge it.
>>>>>>>>>>>
>>>>>>>>>>> Node 1                               Node 2(master)
>>>>>>>>>>> dlm_do_master_request
>>>>>>>>>>>                                 dlm_master_request_handler
>>>>>>>>>>>                                 -> dlm_lockres_set_refmap_bit
>>>>>>>>>>> call dlm_purge_lockres after unlock
>>>>>>>>>>>                                 dlm_deref_handler
>>>>>>>>>>>                                 -> find lock resource is in
>>>>>>>>>>>                                    DLM_LOCK_RES_SETREF_INPROG state,
>>>>>>>>>>>                                    so dispatch a deref work
>>>>>>>>>>> dlm_purge_lockres succeed.
>>>>>>>>>>>
>>>>>>>>>>> dlm_do_master_request
>>>>>>>>>>>                                 dlm_master_request_handler
>>>>>>>>>>>                                 -> dlm_lockres_set_refmap_bit
>>>>>>>>>>>
>>>>>>>>>>>                                 deref work trigger, call
>>>>>>>>>>>                                 dlm_lockres_clear_refmap_bit
>>>>>>>>>>>                                 to clear Node 1 from refmap
>>>>>>>>>>>
>>>>>>>>>>> Now Node 2 can purge the lock resource but the owner of lock resource
>>>>>>>>>>> on Node 1 is still Node 2 which may trigger BUG if the lock resource
>>>>>>>>>>> is $RECOVERY or other problems.
>>>>>>>>>>>
>>>>>>>>>>> We have discussed 2 solutions:
>>>>>>>>>>> 1)The master return error to Node 1 if the DLM_LOCK_RES_SETREF_INPROG
>>>>>>>>>>> is set. Node 1 will not retry and master send another message to Node 1
>>>>>>>>>>> after clearing the refmap. Node 1 can purge the lock resource after the
>>>>>>>>>>> refmap on master is cleared.
>>>>>>>>>>> 2) The master return error to Node 1 if the DLM_LOCK_RES_SETREF_INPROG
>>>>>>>>>>> is set, and Node 1 will retry to deref the lockres.
>>>>>>>>>>>
>>>>>>>>>>> Does anybody has better ideas?
>>>>>>>>>>>
>>>>>>>>>> dlm_purge_lockres() will wait to drop ref until
>>>>>>>>>> DLM_LOCK_RES_SETREF_INPROG cleared. So if set this flag when find the
>>>>>>>>>> master during doing master request. And then this flag was cleared when
>>>>>>>>>> receiving assert master message, can this fix the issue?
>>>>>>>>>>
>>>>>>>>> I don't think this can fix. Before doing master request, the lock resource is
>>>>>>>>> already purged. The master should clear the refmap before client purge it.
>>>>>>>> inflight_locks is increased in dlm_get_lock_resource() which will stop
>>>>>>>> lockres purged? Set DLM_LOCK_RES_SETREF_INPROG when found lockres owner
>>>>>>>> during master request, then this will stop lockres purged after unlock?
>>>>>>>>
>>>>>>>> Thanks,
>>>>>>>> Junxiao.
>>>>>>>>
>>>>>>>>>
>>>>>>>>> Thanks,
>>>>>>>>> Jiufei
>>>>>>>>>
>>>>>>>>>> Thanks,
>>>>>>>>>> Junxiao.
>>>>>>>>>>> Thanks,
>>>>>>>>>>> --Jiufei
>>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> .
>>>>>>>>>>
>>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> .
>>>>>>>>
>>>>>>>
>>>>>>
>>>>>>
>>>>>> .
>>>>>>
>>>>>
>>>>>
>>>>
>>>>
>>>> .
>>>>
>>>
>>
>>
>> .
>>
> 
