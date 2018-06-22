From: Joseph Qi <jiangqi903@gmail.com>
Date: Fri, 22 Jun 2018 16:55:37 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix locking for res->tracking and
 dlm->tracking_list
In-Reply-To: <HK0PR06MB253205ABB79272FE86BB16A0D5750@HK0PR06MB2532.apcprd06.prod.outlook.com>
References: <1529625429-13901-1-git-send-email-ashish.samant@oracle.com>
	<34fa7f8b-4ecb-9a1c-f490-dbef45e67457@gmail.com>
	<HK0PR06MB253205ABB79272FE86BB16A0D5750@HK0PR06MB2532.apcprd06.prod.outlook.com>
Message-ID: <205afb0a-ec76-0ca7-dd6d-401addeb1af1@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 18/6/22 16:50, Changwei Ge wrote:
> 
> 
> On 2018/6/22 16:32, Joseph Qi wrote:
>>
>> On 18/6/22 07:57, Ashish Samant wrote:
>>> In dlm_init_lockres() and dlm_unregister_domain() we access and modify
>>> res->tracking and dlm->tracking_list without holding dlm->track_lock.
>>> This can cause list corruptions and can end up in kernel panic.
>>>
>>> Fix this by locking res->tracking and dlm->tracking_list with
>>> dlm->track_lock at all places.
>>>
>>> Signed-off-by: Ashish Samant <ashish.samant@oracle.com>
>>> ---
>>>   fs/ocfs2/dlm/dlmdomain.c | 2 ++
>>>   fs/ocfs2/dlm/dlmmaster.c | 4 ++--
>>>   2 files changed, 4 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
>>> index 2acd58b..cfb1edd 100644
>>> --- a/fs/ocfs2/dlm/dlmdomain.c
>>> +++ b/fs/ocfs2/dlm/dlmdomain.c
>>> @@ -723,6 +723,7 @@ void dlm_unregister_domain(struct dlm_ctxt *dlm)
>>>   			mlog(0, "%s: more migration to do\n", dlm->name);
>>>   		}
>>>   
>>> +		spin_lock(&dlm->track_lock);
>>>   		/* This list should be empty. If not, print remaining lockres */
>>>   		if (!list_empty(&dlm->tracking_list)) {
>>>   			mlog(ML_ERROR, "Following lockres' are still on the "
>>> @@ -730,6 +731,7 @@ void dlm_unregister_domain(struct dlm_ctxt *dlm)
>>>   			list_for_each_entry(res, &dlm->tracking_list, tracking)
>>>   				dlm_print_one_lock_resource(res);
>>>   		}
>>> +		spin_unlock(&dlm->track_lock);
>>>   
>> The locking order should be res->spinlock > dlm->track_lock.
>> Since here just want to print error message for issue tracking, I'm
>> wandering if we can copy tracking list to local first.
> That won't be easy since I think the copying should also should lock 
> resource lock.

Copy tracking list only need taking track_lock.
Then access local tracking list we don't have to take it any more
and then we can call dlm_print_one_lock_resource() which will take
res->spinlock.

Thanks,
Joseph

> Perhaps, we can remove lock resource from dlm->track_list only when the 
> lock resource is released.
> It brings another benefit that we can easily find which lock resource is 
> leaked.
> 
> Thanks,
> Changwei
> 
>>
>> Thanks,
>> Joseph
>>
>>>   		dlm_mark_domain_leaving(dlm);
>>>   		dlm_leave_domain(dlm);
>>> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
>>> index aaca094..826f056 100644
>>> --- a/fs/ocfs2/dlm/dlmmaster.c
>>> +++ b/fs/ocfs2/dlm/dlmmaster.c
>>> @@ -584,9 +584,9 @@ static void dlm_init_lockres(struct dlm_ctxt *dlm,
>>>   
>>>   	res->last_used = 0;
>>>   
>>> -	spin_lock(&dlm->spinlock);
>>> +	spin_lock(&dlm->track_lock);
>>>   	list_add_tail(&res->tracking, &dlm->tracking_list);
>>> -	spin_unlock(&dlm->spinlock);
>>> +	spin_unlock(&dlm->track_lock);
>>>   
>>>   	memset(res->lvb, 0, DLM_LVB_LEN);
>>>   	memset(res->refmap, 0, sizeof(res->refmap));
>>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
