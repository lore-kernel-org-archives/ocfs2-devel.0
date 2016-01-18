From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Mon, 18 Jan 2016 12:28:20 +0800
Subject: [Ocfs2-devel] ocfs2: A race between refmap setting and clearing
In-Reply-To: <569609BE.8050802@huawei.com>
References: <56931785.2090603@huawei.com> <56947B02.7030503@oracle.com>
	<5694A857.5020906@huawei.com> <5695BA7D.90009@oracle.com>
	<5695ECE6.7050709@huawei.com> <5695F616.9040105@oracle.com>
	<569609BE.8050802@huawei.com>
Message-ID: <569C69E4.6030500@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 01/13/2016 04:24 PM, Joseph Qi wrote:
> Hi Junxiao,
> 
> On 2016/1/13 15:00, Junxiao Bi wrote:
>> On 01/13/2016 02:21 PM, xuejiufei wrote:
>>> Hi Junxiao,
>>> I have not describe the issue clearly.
>>>
>>> Node 1                               Node 2(master)
>>> dlmlock
>>> dlm_do_master_request
>>>                                 dlm_master_request_handler
>>>                                 -> dlm_lockres_set_refmap_bit
>>> dlmlock succeed
>>> dlmunlock succeed
>>>
>>> dlm_purge_lockres
>>>                                 dlm_deref_handler
>>>                                 -> find lock resource is in
>>>                                    DLM_LOCK_RES_SETREF_INPROG state,
>>>                                    so dispatch a deref work
>>> dlm_purge_lockres succeed.
>>>
>>> call dlmlock again
>>> dlm_do_master_request
>>>                                 dlm_master_request_handler
>>>                                 -> dlm_lockres_set_refmap_bit
>>>
>>>                                 deref work trigger, call
>>>                                 dlm_lockres_clear_refmap_bit
>>>                                 to clear Node 1 from refmap
>>>
>>>                                 dlm_purge_lockres succeed
>>>
>>> dlm_send_remote_lock_request
>>>                                 return DLM_IVLOCKID because
>>>                                 the lockres is not exist
>> More clear now. Thank you.
>> This is a very complicated race. I didn't have a good solution to fix it
>> now. Your fix looks work, but I am afraid if we keep going fix this
>> kinds of races case by case, we will make dlm harder to understand and
>> easy to involve bugs, maybe we should think about refactor dlm.
>>
> Agree. IMO, the root cause is bit op cannot handle such a case.
> I wonder if we have to change it to refcount, which may require a much
> bigger refactoring.
one bit for each node seems reasonable, as lockres is per node. I think
the cause is the dis-order of set/clear, i am trying to see whether they
can be made happen in order.

Thanks,
Junxiao.
> 
> Thanks,
> Joseph
> 
>> Thanks,
>> Junxiao.
>>
>>> BUG if the lockres is $RECOVERY
>>>
>>> On 2016/1/13 10:46, Junxiao Bi wrote:
>>>> On 01/12/2016 03:16 PM, xuejiufei wrote:
>>>>> Hi, Junxiao
>>>>>
>>>>> On 2016/1/12 12:03, Junxiao Bi wrote:
>>>>>> Hi Jiufei,
>>>>>>
>>>>>> On 01/11/2016 10:46 AM, xuejiufei wrote:
>>>>>>> Hi all,
>>>>>>> We have found a race between refmap setting and clearing which
>>>>>>> will cause the lock resource on master is freed before other nodes
>>>>>>> purge it.
>>>>>>>
>>>>>>> Node 1                               Node 2(master)
>>>>>>> dlm_do_master_request
>>>>>>>                                 dlm_master_request_handler
>>>>>>>                                 -> dlm_lockres_set_refmap_bit
>>>>>>> call dlm_purge_lockres after unlock
>>>>>>>                                 dlm_deref_handler
>>>>>>>                                 -> find lock resource is in
>>>>>>>                                    DLM_LOCK_RES_SETREF_INPROG state,
>>>>>>>                                    so dispatch a deref work
>>>>>>> dlm_purge_lockres succeed.
>>>>>>>
>>>>>>> dlm_do_master_request
>>>>>>>                                 dlm_master_request_handler
>>>>>>>                                 -> dlm_lockres_set_refmap_bit
>>>>>>>
>>>>>>>                                 deref work trigger, call
>>>>>>>                                 dlm_lockres_clear_refmap_bit
>>>>>>>                                 to clear Node 1 from refmap
>>>>>>>
>>>>>>> Now Node 2 can purge the lock resource but the owner of lock resource
>>>>>>> on Node 1 is still Node 2 which may trigger BUG if the lock resource
>>>>>>> is $RECOVERY or other problems.
>>>>>>>
>>>>>>> We have discussed 2 solutions:
>>>>>>> 1)The master return error to Node 1 if the DLM_LOCK_RES_SETREF_INPROG
>>>>>>> is set. Node 1 will not retry and master send another message to Node 1
>>>>>>> after clearing the refmap. Node 1 can purge the lock resource after the
>>>>>>> refmap on master is cleared.
>>>>>>> 2) The master return error to Node 1 if the DLM_LOCK_RES_SETREF_INPROG
>>>>>>> is set, and Node 1 will retry to deref the lockres.
>>>>>>>
>>>>>>> Does anybody has better ideas?
>>>>>>>
>>>>>> dlm_purge_lockres() will wait to drop ref until
>>>>>> DLM_LOCK_RES_SETREF_INPROG cleared. So if set this flag when find the
>>>>>> master during doing master request. And then this flag was cleared when
>>>>>> receiving assert master message, can this fix the issue?
>>>>>>
>>>>> I don't think this can fix. Before doing master request, the lock resource is
>>>>> already purged. The master should clear the refmap before client purge it.
>>>> inflight_locks is increased in dlm_get_lock_resource() which will stop
>>>> lockres purged? Set DLM_LOCK_RES_SETREF_INPROG when found lockres owner
>>>> during master request, then this will stop lockres purged after unlock?
>>>>
>>>> Thanks,
>>>> Junxiao.
>>>>
>>>>>
>>>>> Thanks,
>>>>> Jiufei
>>>>>
>>>>>> Thanks,
>>>>>> Junxiao.
>>>>>>> Thanks,
>>>>>>> --Jiufei
>>>>>>>
>>>>>>
>>>>>>
>>>>>> .
>>>>>>
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
> 
