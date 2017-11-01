From: Changwei Ge <ge.changwei@h3c.com>
Date: Wed, 1 Nov 2017 09:00:23 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: wait for dlm recovery done
 when migrating all lockres
References: <59F91FEF.5020609@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E373CED73303@H3CMLB14-EX.srv.huawei-3com.com>
	<59F96136.3070307@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E373CED73541@H3CMLB14-EX.srv.huawei-3com.com>
	<59F97E2A.3000604@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E373CED7361B@H3CMLB14-EX.srv.huawei-3com.com>
	<59F9898C.4070902@huawei.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373CED736CA@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jun,

On 2017/11/1 16:46, piaojun wrote:
> Hi Changwei,
> 
> I do think we need follow the principle that use 'dlm_domain_lock' to
> protect 'dlm_state' as the NOTE says in 'dlm_ctxt':
> /* NOTE: Next three are protected by dlm_domain_lock */
> 
> deadnode won't be cleared from 'dlm->domain_map' if return from
> __dlm_hb_node_down(), and NodeA will retry migrating to NodeB forever
> if only NodeA and NodeB in domain. I suggest more testing needed in
> your solution.

I agree, however, my patch is just a draft to indicate my comments.

Perhaps we can figure out a better way to solve this, as your patch 
can't clear DLM RECOVERING flag on lock resource. I am not sure if it is 
reasonable, I suppose this may violate ocfs2/dlm design philosophy.

Thanks,
Changwei

> 
> thanks,
> Jun
> 
> On 2017/11/1 16:11, Changwei Ge wrote:
>> Hi Jun,
>>
>> Thanks for reviewing.
>> I don't think we have to worry about misusing *dlm_domain_lock* and
>> *dlm::spinlock*. I admit my change may look a little different from most
>> of other code snippets where using these two spin locks. But our purpose
>> is to close the race between __dlm_hb_node_down and
>> dlm_unregister_domain, right?  And my change meets that. :-)
>>
>> I suppose we can do it in a flexible way.
>>
>> Thanks,
>> Changwei
>>
>>
>> On 2017/11/1 15:57, piaojun wrote:
>>> Hi Changwei,
>>>
>>> thanks for reviewing, and I think waiting for recoverying done before
>>> migrating seems another solution, but I wonder if new problems will be
>>> invoked as following comments.
>>>
>>> thanks,
>>> Jun
>>>
>>> On 2017/11/1 15:13, Changwei Ge wrote:
>>>> Hi Jun,
>>>>
>>>> I probably get your point.
>>>>
>>>> You mean that dlm finds no lock resource to be migrated and no more lock
>>>> resource is managed by its hash table. After that a node dies all of a
>>>> sudden and the dead node is put into dlm's recovery map, right?
>>> that is it.
>>>> Furthermore, a lock resource is migrated from other nodes and local node
>>>> has already asserted master to them.
>>>>
>>>> If so, I want to suggest a easier way to solve it.
>>>> We don't have to add a new flag to dlm structure, just leverage existed
>>>> dlm status and bitmap.
>>>> It will bring a bonus - no lock resource will be marked with RECOVERING,
>>>> it's a safer way, I suppose.
>>>>
>>>> Please take a review.
>>>>
>>>> Thanks,
>>>> Changwei
>>>>
>>>>
>>>> Subject: [PATCH] ocfs2/dlm: a node can't be involved in recovery if it
>>>> is being shutdown
>>>>
>>>> Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
>>>> ---
>>>>     fs/ocfs2/dlm/dlmdomain.c   | 4 ++++
>>>>     fs/ocfs2/dlm/dlmrecovery.c | 3 +++
>>>>     2 files changed, 7 insertions(+)
>>>>
>>>> diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
>>>> index a2b19fbdcf46..5e9283e509a4 100644
>>>> --- a/fs/ocfs2/dlm/dlmdomain.c
>>>> +++ b/fs/ocfs2/dlm/dlmdomain.c
>>>> @@ -707,11 +707,15 @@ void dlm_unregister_domain(struct dlm_ctxt *dlm)
>>>>     		 * want new domain joins to communicate with us at
>>>>     		 * least until we've completed migration of our
>>>>     		 * resources. */
>>>> +		spin_lock(&dlm->spinlock);
>>>>     		dlm->dlm_state = DLM_CTXT_IN_SHUTDOWN;
>>>> +		spin_unlock(&dlm->spinlock);
>>> I guess there will be misuse of 'dlm->spinlock' and dlm_domain_lock.
>>>>     		leave = 1;
>>>>     	}
>>>>     	spin_unlock(&dlm_domain_lock);
>>>>
>>>> +	dlm_wait_for_recovery(dlm);
>>>> +
>>>>     	if (leave) {
>>>>     		mlog(0, "shutting down domain %s\n", dlm->name);
>>>>     		dlm_begin_exit_domain(dlm);
>>>> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
>>>> index 74407c6dd592..764c95b2b35c 100644
>>>> --- a/fs/ocfs2/dlm/dlmrecovery.c
>>>> +++ b/fs/ocfs2/dlm/dlmrecovery.c
>>>> @@ -2441,6 +2441,9 @@ static void __dlm_hb_node_down(struct dlm_ctxt
>>>> *dlm, int idx)
>>>>     {
>>>>     	assert_spin_locked(&dlm->spinlock);
>>>>
>>>> +	if (dlm->dlm_state == DLM_CTXT_IN_SHUTDOWN)
>>>> +		return;
>>>> +
>>> 'dlm->dlm_state' probably need be to protected by 'dlm_domain_lock'.
>>> and I wander if there is more work to be done when in
>>> 'DLM_CTXT_IN_SHUTDOWN'?
>>>>     	if (dlm->reco.new_master == idx) {
>>>>     		mlog(0, "%s: recovery master %d just died\n",
>>>>     		     dlm->name, idx);
>>>>
>>>
>>
>> .
>>
> 
