From: piaojun <piaojun@huawei.com>
Date: Tue, 19 Feb 2019 09:15:44 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: wait for recovering done after
 direct unlock request
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E37301278653BC@H3CMLB14-EX.srv.huawei-3com.com>
References: <1550124866-20367-1-git-send-email-ge.changwei@h3c.com>
	<5C6659FA.2000100@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E3730127854170@H3CMLB14-EX.srv.huawei-3com.com>
	<5C6679F3.3020306@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E3730127854352@H3CMLB14-EX.srv.huawei-3com.com>
	<63ADC13FD55D6546B7DECE290D39E37301278653BC@H3CMLB14-EX.srv.huawei-3com.com>
Message-ID: <5C6B58C0.1040506@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Changwei,

Thanks for your patient explaination, and I get your point. But I have
some suggestion about your patch below.

On 2019/2/18 17:46, Changwei Ge wrote:
> Hi Jun,
> 
> Ping...
> 
> Do you have any further question?
> If any question uncleared, please let me know.
> Otherwise, could you please give a feedback?
> 
> Thanks,
> Changwei
> 
> On 2019/2/15 16:48, Changwei Ge wrote:
>> Hi Jun,
>>
>> On 2019/2/15 16:36, piaojun wrote:
>>> Hi Changwei,
>>>
>>> Thanks for your explaination, and I still have a question below.
>>
>> Thank you for looking into this.
>>
>>>
>>> On 2019/2/15 14:29, Changwei Ge wrote:
>>>> Hi Jun,
>>>>
>>>> On 2019/2/15 14:20, piaojun wrote:
>>>>> Hi Changwei,
>>>>>
>>>>> The DLM process is a little bit complex, so I suggest pasting the code
>>>>> path. And I wonder if my code is right?
>>>>>
>>>>> Thanks,
>>>>> Jun
>>>>>
>>>>> On 2019/2/14 14:14, Changwei Ge wrote:
>>>>>> There is scenario causing ocfs2 umount hang when multiple hosts are
>>>>>> rebooting at the same time.
>>>>>>
>>>>>> NODE1                           NODE2               NODE3
>>>>>> send unlock requset to NODE2
>>>>>>                                    dies
>>>>>>                                                        become recovery master
>>>>>>                                                        recover NODE2
>>>>>> find NODE2 dead
>>>>>> mark resource RECOVERING
>>>>>> directly remove lock from grant list
>>>>> dlm_do_local_recovery_cleanup
>>>>>      dlm_move_lockres_to_recovery_list
>>>>>        res->state |= DLM_LOCK_RES_RECOVERING;
>>>>>        list_add_tail(&res->recovering, &dlm->reco.resources);
>>>>>
>>>>>> calculate usage but RECOVERING marked
>>>>>> **miss the window of purging
>>>>> dlmunlock
>>>>>      dlmunlock_remote
>>>>>        dlmunlock_common // unlock successfully directly
>>>>>
>>>>>      dlm_lockres_calc_usage
>>>>>        __dlm_lockres_calc_usage
>>>>>          __dlm_lockres_unused
>>>>>            if (res->state & (DLM_LOCK_RES_RECOVERING| // won't purge lock as DLM_LOCK_RES_RECOVERING is set
>>>>
>>>> True.
>>>>
>>>>>
>>>>>> clear RECOVERING
>>>>> dlm_finish_local_lockres_recovery
>>>>>      res->state &= ~DLM_LOCK_RES_RECOVERING;
>>>>>
>>>>> Could you help explaining where getting stuck?
>>>>
>>>> Sure,
>>>> As dlm missed the window to purge lock resource, it can't be unhashed.
>>>>
>>>> During umount:
>>>> dlm_unregister_domain
>>>>      dlm_migrate_all_locks -> there is always a lock resource hashed, so can't return from dlm_migrate_all_locks() thus hang during umount.
>>>
>>> In dlm_migrate_all_locks, lockres will be move to purge_list and purged again:
>>> dlm_migrate_all_locks
>>>     __dlm_lockres_calc_usage
>>>       list_add_tail(&res->purge, &dlm->purge_list);
>>>
>>> Do you mean this process does not work?
>>
>> Yes, only for Migrating lock resources, it has a chance to call __dlm_lockres_calc_usage()
>> But in our situation, the problematic lock resource is obviously no master. So no chance for it to set stack variable *dropped* in dlm_migrate_all_locks()
>>
>> Thanks,
>> Changwei
>>
>>>
>>>>
>>>> Thanks,
>>>> Changwei
>>>> 	
>>>>
>>>>>
>>>>>>
>>>>>> To reproduce this iusse, crash a host and then umount ocfs2
>>>>>> from another node.
>>>>>>
>>>>>> To sovle this, just let unlock progress wait for recovery done.
>>>>>>
>>>>>> Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
>>>>>> ---
>>>>>>     fs/ocfs2/dlm/dlmunlock.c | 23 +++++++++++++++++++----
>>>>>>     1 file changed, 19 insertions(+), 4 deletions(-)
>>>>>>
>>>>>> diff --git a/fs/ocfs2/dlm/dlmunlock.c b/fs/ocfs2/dlm/dlmunlock.c
>>>>>> index 63d701c..c8e9b70 100644
>>>>>> --- a/fs/ocfs2/dlm/dlmunlock.c
>>>>>> +++ b/fs/ocfs2/dlm/dlmunlock.c
>>>>>> @@ -105,7 +105,8 @@ static enum dlm_status dlmunlock_common(struct dlm_ctxt *dlm,
>>>>>>     	enum dlm_status status;
>>>>>>     	int actions = 0;
>>>>>>     	int in_use;
>>>>>> -        u8 owner;
>>>>>> +	u8 owner;
>>>>>> +	int recovery_wait = 0;
>>>>>>     
>>>>>>     	mlog(0, "master_node = %d, valblk = %d\n", master_node,
>>>>>>     	     flags & LKM_VALBLK);
>>>>>> @@ -208,9 +209,12 @@ static enum dlm_status dlmunlock_common(struct dlm_ctxt *dlm,
>>>>>>     		}
>>>>>>     		if (flags & LKM_CANCEL)
>>>>>>     			lock->cancel_pending = 0;
>>>>>> -		else
>>>>>> -			lock->unlock_pending = 0;
>>>>>> -
>>>>>> +		else {
>>>>>> +			if (!lock->unlock_pending)
>>>>>> +				recovery_wait = 1;

Could we just check if res->state is in DLM_LOCK_RES_RECOVERING or
status is DLM_RECOVERING? And there is no need to define an extra
variable.

>>>>>> +			else
>>>>>> +				lock->unlock_pending = 0;
>>>>>> +		}
>>>>>>     	}
>>>>>>     
>>>>>>     	/* get an extra ref on lock.  if we are just switching
>>>>>> @@ -244,6 +248,17 @@ static enum dlm_status dlmunlock_common(struct dlm_ctxt *dlm,
>>>>>>     	spin_unlock(&res->spinlock);
>>>>>>     	wake_up(&res->wq);
>>>>>>     
>>>>>> +	if (recovery_wait) {
>>>>>> +		spin_lock(&res->spinlock);
>>>>>> +		/* Unlock request will directly succeed after owner dies,
>>>>>> +		 * and the lock is already removed from grant list. We have to
>>>>>> +		 * wait for RECOVERING done or we miss the chance to purge it
>>>>>> +		 * since the removement is much faster than RECOVERING proc.
>>>>>> +		 */
>>>>>> +		__dlm_wait_on_lockres_flags(res, DLM_LOCK_RES_RECOVERING);
>>>>>> +		spin_unlock(&res->spinlock);
>>>>>> +	}
>>>>>> +
>>>>>>     	/* let the caller's final dlm_lock_put handle the actual kfree */
>>>>>>     	if (actions & DLM_UNLOCK_FREE_LOCK) {
>>>>>>     		/* this should always be coupled with list removal */
>>>>>>
>>>>>
>>>> .
>>>>
>>>
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>
> .
> 
