From: piaojun <piaojun@huawei.com>
Date: Thu, 14 Feb 2019 17:04:18 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: return DLM_CANCELGRANT if the
 lock is on granted list and the operation is canceled
In-Reply-To: <7420155e-f7d6-520c-5134-4a681399a68a@huawei.com>
References: <98f0e80c-9c13-dbb6-047c-b40e100082b1@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E37301277EFAA1@H3CMLB12-EX.srv.huawei-3com.com>
	<00607177-cb1b-d380-e6d3-3d5cb9b3c991@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E37301277F1589@H3CMLB12-EX.srv.huawei-3com.com>
	<7420155e-f7d6-520c-5134-4a681399a68a@huawei.com>
Message-ID: <5C652F12.9010408@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Changwei,

The problem can't be solved completely if clear ::cancel_pending in
dlm_proxy_ast_handler, as AST will come at anytime just before
::cancel_pendig is set. If there is not any other better solutions,
could we accept this patch? This bug is very harmful.

Thanks,
Jun

On 2018/12/8 18:05, wangjian wrote:
> Hi Changwei,
> 
> I understand your idea. But we should be aware that the cancel_convert process and
> other processes (accepting the AST process, the recovery process) are asynchronous.
> For example, according to your idea, check if the lock is in the grant queue before
> calling the dlm_send_remote_unlock_request function in the dlm_proxy_ast_handler function.
> Then decide whether to clear cancel_pending. But if the AST does not come at this time,
> the check passes and cancel_pendig will not be cleared. Then AST immediately came over again,
> which also led to a bug. I personally think that for asynchronous processes we can't guarantee
> the speed of execution of each process. All we can do is to avoid the BUG scene.
> 
> As for the question you said ("If you remove the BUG check why you still call dlm_commit_pending_cancel()
> to move the lock back to grant on matter it's on converting list or not?").
> I think we should first check if the lock is in the grant queue
> (at this time, dlm->spinlock and res->spinlock have been added), then decide whether to call
> dlm_commit_pending_cancel function. 
> 
> Thanks,
> Jian
> 
> On 12/7/2018 11:12 AM, Changwei Ge wrote:
>> Hi Jian,
>>
>> I suppose that the situation you described truly exists.
>> But the way you fix the issue is not in my favor.
>>
>> If you remove the BUG check why you still call dlm_commit_pending_cancel() to
>> move the lock back to grant on matter it's on converting list or not?
>>
>> So how about keeping the BUG check in dlm_move_lockres_to_recovery_list().
>> If the locking _ast_ comes back very fast just check ::cancel_pending in dlm_proxy_ast_handler() and clear it.
>> Then with the logic checking if the lock is on grant list (in dlmunlock_common() more less like your current method)
>> or not we can easily tell if the cancellation succeeds or not.
>>
>> That complies the original dlm design, which I think is better and easier for maintainers to understand.
>>
>> Thanks,
>> Changwei
>>
>> On 2018/12/6 20:06, wangjian wrote:
>>> Hi Changwei,
>>>
>>> I don't fully agree with your point of view. In my opinion, the lock cancellation process and the lock
>>> conversion process are asynchronous. We can't guarantee that the lock must be in the convert list
>>> during the lock conversion process, otherwise this BUG will not happen.
>>> So, I think this is a meaningless BUG.
>>>
>>> Thanks,
>>> Jian
>>>
>>> On 12/5/2018 9:49 AM, Changwei Ge wrote:
>>>> Hi Jian,
>>>>
>>>> I suppose you can't just remove the BUG_ON() check.
>>>> If you remove it, below code violates the original logic.
>>>>
>>>> '''
>>>> 2141                                 dlm_commit_pending_cancel(res, lock);
>>>> '''
>>>>
>>>> What's more important is *locking cancel* must be against a *locking conversion* progress.
>>>> So it makes sense to check if this lock is on converting list.
>>>>
>>>> So I have to NACK to this patch.
>>>>
>>>> Thanks,
>>>> Changwei
>>>>
>>>>
>>>> On 2018/12/3 20:23, wangjian wrote:
>>>>> In the dlm_move_lockres_to_recovery_list function, if the lock
>>>>> is in the granted queue and cancel_pending is set, it will
>>>>> encounter a BUG. I think this is a meaningless BUG,
>>>>> so be prepared to remove it. A scenario that causes
>>>>> this BUG will be given below.
>>>>>
>>>>> At the beginning, Node 1 is the master and has NL lock,
>>>>> Node 2 has PR lock, Node 3 has PR lock too.
>>>>>
>>>>> Node 1          Node 2          Node 3
>>>>>               want to get EX lock.
>>>>>
>>>>>                               want to get EX lock.
>>>>>
>>>>> Node 3 hinder
>>>>> Node 2 to get
>>>>> EX lock, send
>>>>> Node 3 a BAST.
>>>>>
>>>>>                               receive BAST from
>>>>>                               Node 1. downconvert
>>>>>                               thread begin to
>>>>>                               cancel PR to EX conversion.
>>>>>                               In dlmunlock_common function,
>>>>>                               downconvert thread has set
>>>>>                               lock->cancel_pending,
>>>>>                               but did not enter
>>>>>                               dlm_send_remote_unlock_request
>>>>>                               function.
>>>>>
>>>>>               Node2 dies because
>>>>>               the host is powered down.
>>>>>
>>>>> In recovery process,
>>>>> clean the lock that
>>>>> related to Node2.
>>>>> then finish Node 3
>>>>> PR to EX request.
>>>>> give Node 3 a AST.
>>>>>
>>>>>                               receive AST from Node 1.
>>>>>                               change lock level to EX,
>>>>>                               move lock to granted list.
>>>>>
>>>>> Node1 dies because
>>>>> the host is powered down.
>>>>>
>>>>>                               In dlm_move_lockres_to_recovery_list
>>>>>                               function. the lock is in the
>>>>>                               granted queue and cancel_pending
>>>>>                               is set. BUG_ON.
>>>>>
>>>>> But after clearing this BUG, process will encounter
>>>>> the second BUG in the ocfs2_unlock_ast function.
>>>>> Here is a scenario that will cause the second BUG
>>>>> in ocfs2_unlock_ast as follows:
>>>>>
>>>>> At the beginning, Node 1 is the master and has NL lock,
>>>>> Node 2 has PR lock, Node 3 has PR lock too.
>>>>>
>>>>> Node 1          Node 2          Node 3
>>>>>               want to get EX lock.
>>>>>
>>>>>                               want to get EX lock.
>>>>>
>>>>> Node 3 hinder
>>>>> Node 2 to get
>>>>> EX lock, send
>>>>> Node 3 a BAST.
>>>>>
>>>>>                               receive BAST from
>>>>>                               Node 1. downconvert
>>>>>                               thread begin to
>>>>>                               cancel PR to EX conversion.
>>>>>                               In dlmunlock_common function,
>>>>>                               downconvert thread has released
>>>>>                               lock->spinlock and res->spinlock,
>>>>>                               but did not enter
>>>>>                               dlm_send_remote_unlock_request
>>>>>                               function.
>>>>>
>>>>>               Node2 dies because
>>>>>               the host is powered down.
>>>>>
>>>>> In recovery process,
>>>>> clean the lock that
>>>>> related to Node2.
>>>>> then finish Node 3
>>>>> PR to EX request.
>>>>> give Node 3 a AST.
>>>>>
>>>>>                               receive AST from Node 1.
>>>>>                               change lock level to EX,
>>>>>                               move lock to granted list,
>>>>>                               set lockres->l_unlock_action
>>>>>                               as OCFS2_UNLOCK_INVALID
>>>>>                               in ocfs2_locking_ast function.
>>>>>
>>>>> Node2 dies because
>>>>> the host is powered down.
>>>>>
>>>>>                               Node 3 realize that Node 1
>>>>>                               is dead, remove Node 1 from
>>>>>                               domain_map. downconvert thread
>>>>>                               get DLM_NORMAL from
>>>>>                               dlm_send_remote_unlock_request
>>>>>                               function and set *call_ast as 1.
>>>>>                               Then downconvert thread meet
>>>>>                               BUG in ocfs2_unlock_ast function.
>>>>>
>>>>> To avoid meet the second BUG, function dlmunlock_common shuold
>>>>> return DLM_CANCELGRANT if the lock is on granted list and
>>>>> the operation is canceled.
>>>>>
>>>>> Signed-off-by: Jian Wang<wangjian161@huawei.com>
>>>>> Reviewed-by: Yiwen Jiang<jiangyiwen@huawei.com>
>>>>> ---
>>>>>    fs/ocfs2/dlm/dlmrecovery.c | 1 -
>>>>>    fs/ocfs2/dlm/dlmunlock.c   | 5 +++++
>>>>>    2 files changed, 5 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
>>>>> index 802636d..7489652 100644
>>>>> --- a/fs/ocfs2/dlm/dlmrecovery.c
>>>>> +++ b/fs/ocfs2/dlm/dlmrecovery.c
>>>>> @@ -2134,7 +2134,6 @@ void dlm_move_lockres_to_recovery_list(struct dlm_ctxt *dlm,
>>>>>    				 * if this had completed successfully
>>>>>    				 * before sending this lock state to the
>>>>>    				 * new master */
>>>>> -				BUG_ON(i != DLM_CONVERTING_LIST);
>>>>>    				mlog(0, "node died with cancel pending "
>>>>>    				     "on %.*s. move back to granted list.\n",
>>>>>    				     res->lockname.len, res->lockname.name);
>>>>> diff --git a/fs/ocfs2/dlm/dlmunlock.c b/fs/ocfs2/dlm/dlmunlock.c
>>>>> index 63d701c..505bb6c 100644
>>>>> --- a/fs/ocfs2/dlm/dlmunlock.c
>>>>> +++ b/fs/ocfs2/dlm/dlmunlock.c
>>>>> @@ -183,6 +183,11 @@ static enum dlm_status dlmunlock_common(struct dlm_ctxt *dlm,
>>>>>    							flags, owner);
>>>>>    		spin_lock(&res->spinlock);
>>>>>    		spin_lock(&lock->spinlock);
>>>>> +
>>>>> +		if ((flags & LKM_CANCEL) &&
>>>>> +				dlm_lock_on_list(&res->granted, lock))
>>>>> +			status = DLM_CANCELGRANT;
>>>>> +
>>>>>    		/* if the master told us the lock was already granted,
>>>>>    		 * let the ast handle all of these actions */
>>>>>    		if (status == DLM_CANCELGRANT) {
>>>>> -- 
>>>>> 1.8.3.1
>>>>>
>>>> .
>>>>
>> .
>>
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
