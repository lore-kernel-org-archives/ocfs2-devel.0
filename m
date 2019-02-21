From: Changwei Ge <ge.changwei@h3c.com>
Date: Thu, 21 Feb 2019 06:23:21 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: wait for recovering done after
 direct unlock request
References: <1550124866-20367-1-git-send-email-ge.changwei@h3c.com>
	<5C6659FA.2000100@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E3730127854170@H3CMLB14-EX.srv.huawei-3com.com>
	<5C6679F3.3020306@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E3730127854352@H3CMLB14-EX.srv.huawei-3com.com>
	<63ADC13FD55D6546B7DECE290D39E37301278653BC@H3CMLB14-EX.srv.huawei-3com.com>
	<5C6B58C0.1040506@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E37301278659A8@H3CMLB14-EX.srv.huawei-3com.com>
	<5C6BBFEA.2080205@huawei.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E37301278674BF@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jun,

On 2019/2/19 16:36, piaojun wrote:
		recovery_wait = 1;
>>>
>>> Could we just check if res->state is in DLM_LOCK_RES_RECOVERING or
>>> status is DLM_RECOVERING? And there is no need to define an extra
>>> variable.
>>
>> As the lock resource master had died, DLM_RECOVERING can't be returned.
>>
>> I prefer adding a stack variable like *recovery_wait* to tell if involved lock resource has a chance to be recovered.
>> In this way, we won't make code subtle comparing with normal code path. As you know, the case we discuss here is not
>> that possible to happen when each node in cluster works well. And we can also save some CPU cycles this way.
> 
> I mean we could check if the res->state is in DLM_LOCK_RES_RECOVERING.
> As when lock->unlock_pending is cleared in
> dlm_move_lockres_to_recovery_list, res->state must be set
> DLM_LOCK_RES_RECOVERING.
> 
> And I think of another solution which seems a little easier and save
> some CPU work. We could call __dlm_lockres_calc_usage to put unused
> lockres into purge list in dlm_finish_local_lockres_recovery. And this
> will not stuck the unlocking process.

Sounds a good idea, I will make some test and if feasible, I will send V2

Thanks,
Changwei

> 
>>
>> Thanks,
>> Changwei
>>
>>>
>>>>>>>>> +			else
>>>>>>>>> +				lock->unlock_pending = 0;
>>>>>>>>> +		}
>>>>>>>>>       	}
>>>>>>>>>       
>>>>>>>>>       	/* get an extra ref on lock.  if we are just switching
>>>>>>>>> @@ -244,6 +248,17 @@ static enum dlm_status dlmunlock_common(struct dlm_ctxt *dlm,
>>>>>>>>>       	spin_unlock(&res->spinlock);
>>>>>>>>>       	wake_up(&res->wq);
>>>>>>>>>       
>>>>>>>>> +	if (recovery_wait) {
>>>>>>>>> +		spin_lock(&res->spinlock);
>>>>>>>>> +		/* Unlock request will directly succeed after owner dies,
>>>>>>>>> +		 * and the lock is already removed from grant list. We have to
>>>>>>>>> +		 * wait for RECOVERING done or we miss the chance to purge it
>>>>>>>>> +		 * since the removement is much faster than RECOVERING proc.
>>>>>>>>> +		 */
>>>>>>>>> +		__dlm_wait_on_lockres_flags(res, DLM_LOCK_RES_RECOVERING);
>>>>>>>>> +		spin_unlock(&res->spinlock);
>>>>>>>>> +	}
>>>>>>>>> +
>>>>>>>>>       	/* let the caller's final dlm_lock_put handle the actual kfree */
>>>>>>>>>       	if (actions & DLM_UNLOCK_FREE_LOCK) {
>>>>>>>>>       		/* this should always be coupled with list removal */
>>>>>>>>>
>>>>>>>>
>>>>>>> .
>>>>>>>
>>>>>>
>>>>>
>>>>> _______________________________________________
>>>>> Ocfs2-devel mailing list
>>>>> Ocfs2-devel at oss.oracle.com
>>>>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>>>>
>>>> .
>>>>
>>>
>> .
>>
> 
