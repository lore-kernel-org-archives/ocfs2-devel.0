From: alex chen <alex.chen@huawei.com>
Date: Fri, 22 Dec 2017 14:19:14 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: fix a potential deadlock in
	dlm_reset_mleres_owner()
In-Reply-To: <c241ab1d-03c6-6727-80d0-1f785cb00d06@gmail.com>
References: <5A3B0668.2030104@huawei.com>
	<53ed49bc-6fcd-0883-eb14-a2912630d809@gmail.com>
	<5A3B5077.7090806@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E373F2907E6E@H3CMLB12-EX.srv.huawei-3com.com>
	<c241ab1d-03c6-6727-80d0-1f785cb00d06@gmail.com>
Message-ID: <5A3CA3E2.8090503@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joseph and Changwei,

On 2017/12/22 11:17, Joseph Qi wrote:
> 
> 
> On 17/12/22 10:34, Changwei Ge wrote:
>> On 2017/12/21 14:36, alex chen wrote:
>>> Hi Joseph,
>>>
>>> On 2017/12/21 9:30, Joseph Qi wrote:
>>>> Hi Alex,
>>>>
>>>> On 17/12/21 08:55, alex chen wrote:
>>>>> In dlm_reset_mleres_owner(), we will lock
>>>>> dlm_lock_resource->spinlock after locking dlm_ctxt->master_lock,
>>>>> which breaks the spinlock lock ordering:
>>>>>   dlm_domain_lock
>>>>>   struct dlm_ctxt->spinlock
>>>>>   struct dlm_lock_resource->spinlock
>>>>>   struct dlm_ctxt->master_lock
>>>>>
>>>>> Fix it by unlocking dlm_ctxt->master_lock before locking
>>>>> dlm_lock_resource->spinlock and restarting to clean master list.
>>>>>
>>>>> Signed-off-by: Alex Chen <alex.chen@huawei.com>
>>>>> Reviewed-by: Jun Piao <piaojun@huawei.com>
>>>>> ---
>>>>>   fs/ocfs2/dlm/dlmmaster.c | 14 ++++++++++----
>>>>>   1 file changed, 10 insertions(+), 4 deletions(-)
>>>>>
>>>>> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
>>>>> index 3e04279..d83ccdc 100644
>>>>> --- a/fs/ocfs2/dlm/dlmmaster.c
>>>>> +++ b/fs/ocfs2/dlm/dlmmaster.c
>>>>> @@ -3287,16 +3287,22 @@ static struct dlm_lock_resource *dlm_reset_mleres_owner(struct dlm_ctxt *dlm,
>>>>>   {
>>>>>   	struct dlm_lock_resource *res;
>>>>>
>>>>> +	assert_spin_locked(&dlm->spinlock);
>>>>> +	assert_spin_locked(&dlm->master_lock);
>>>>> +
>>>>>   	/* Find the lockres associated to the mle and set its owner to UNK */
>>>>> -	res = __dlm_lookup_lockres(dlm, mle->mname, mle->mnamelen,
>>>>> +	res = __dlm_lookup_lockres_full(dlm, mle->mname, mle->mnamelen,
>>>>>   				   mle->mnamehash);
>>>>>   	if (res) {
>>>>>   		spin_unlock(&dlm->master_lock);
>>>>>
>>>>> -		/* move lockres onto recovery list */
>>>>>   		spin_lock(&res->spinlock);
>>>>> -		dlm_set_lockres_owner(dlm, res, DLM_LOCK_RES_OWNER_UNKNOWN);
>>>>> -		dlm_move_lockres_to_recovery_list(dlm, res);
>>>>> +		if (!(res->state & DLM_LOCK_RES_DROPPING_REF)) {
>>>>> +			/* move lockres onto recovery list */
>>>>> +			dlm_set_lockres_owner(dlm, res, DLM_LOCK_RES_OWNER_UNKNOWN);
>>>>> +			dlm_move_lockres_to_recovery_list(dlm, res);
>>>>> +		}
>>>>> +
>>>> I don't think this change is lock re-ordering *only*. It definitely
>>>> changes the logic of resetting mle resource owner.
>>>> Why do you detach mle from heartbeat if lock resource is in the process
>>>> of dropping its mastery reference? And why we have to restart in this
>>>> case?
>>> I think if the lock resource is being purge we don't need to set its owner to UNKNOWN and
>>> it is the same as the original logic. We should drop the master lock if we want to judge
>>> if the state of the lock resource is DLM_LOCK_RES_DROPPING_REF. Once we drop the master lock
>>> we should restart to clean master list.
>>> Here the mle is not useful and will be released, so we detach it from heartbeat.
>>> In fact, the mle has been detached in dlm_clean_migration_mle().
>> Hi Alex,
>>
>> Perhaps, you can just judge if lock resource is marked  DLM_LOCK_RES_DROPPING_REF and if so directly
>> return NULL with ::master_lock locked :)
>> Umm... We can't do this with unlocking master lock first and then
> re-taking it. It breaks the logic.
> What my concern is the behavior change. e.g. Currently for lock resource
> in the process of dropping mastery reference, we just ignore it and
> continue with the next. But after this patch, we have to restart at the
> beginning.
Before this patch, we can continue when we find the lock resource is marked  DLM_LOCK_RES_DROPPING_REF,
that is because we use a wrong spin lock ordering.
Once we drop the master lock we should restart to iterate over the master list, otherwise, we may miss some mles
which are inserted during we are dropping the master lock.

In this patch, we may increase the times to restart, but we can not avoid it for solving the deadlock.

Thanks,
Alex

> 
>> Thanks,
>> Changwei
>>
>>>
>>> Thanks,
>>> Alex
>>>>
>>>> Thanks,
>>>> Joseph
>>>>
>>>>>   		spin_unlock(&res->spinlock);
>>>>>   		dlm_lockres_put(res);
>>>>>
>>>>
>>>> .
>>>>
>>>
>>>
>>> _______________________________________________
>>> Ocfs2-devel mailing list
>>> Ocfs2-devel at oss.oracle.com
>>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>>
>>
> 
> .
> 
