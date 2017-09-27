From: Joseph Qi <jiangqi903@gmail.com>
Date: Wed, 27 Sep 2017 09:32:32 +0800
Subject: [Ocfs2-devel] [patch 1/2] ocfs2/dlm: protect 'tracking_list' by
 'track_lock'
In-Reply-To: <59C9A1C3.4060502@huawei.com>
References: <59C5D77F.2030303@huawei.com>
	<a3302b2c-3492-5d77-ffe1-af630a1a8028@gmail.com>
	<59C9A1C3.4060502@huawei.com>
Message-ID: <4d2338a1-0799-214d-aa6d-d2236fe6906e@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 17/9/26 08:39, piaojun wrote:
> 
> 
> On 2017/9/25 18:35, Joseph Qi wrote:
>>
>>
>> On 17/9/23 11:39, piaojun wrote:
>>> 'dlm->tracking_list' need to be protected by 'dlm->track_lock'.
>>>
>>> Signed-off-by: Jun Piao <piaojun@huawei.com>
>>> Reviewed-by: Alex Chen <alex.chen@huawei.com>
>>> ---
>>>  fs/ocfs2/dlm/dlmdomain.c | 7 ++++++-
>>>  fs/ocfs2/dlm/dlmmaster.c | 4 ++--
>>>  2 files changed, 8 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
>>> index a2b19fb..b118525 100644
>>> --- a/fs/ocfs2/dlm/dlmdomain.c
>>> +++ b/fs/ocfs2/dlm/dlmdomain.c
>>> @@ -726,12 +726,17 @@ void dlm_unregister_domain(struct dlm_ctxt *dlm)
>>>  		}
>>>
>>>  		/* This list should be empty. If not, print remaining lockres */
>>> +		spin_lock(&dlm->track_lock);
>>>  		if (!list_empty(&dlm->tracking_list)) {
>>>  			mlog(ML_ERROR, "Following lockres' are still on the "
>>>  			     "tracking list:\n");
>>> -			list_for_each_entry(res, &dlm->tracking_list, tracking)
>>> +			list_for_each_entry(res, &dlm->tracking_list, tracking) {
>>> +				spin_unlock(&dlm->track_lock);
>>
>> Um... If we unlock here, the iterator still has chance to be corrupted.
>>
>> Thanks,
>> Joseph
>>
> 
> we don't need care much about the corrupted 'tracking_list' because we
> have already picked up 'res' from 'tracking_list'. then we will get
> 'track_lock' again to prevent 'tracking_list' from being corrupted. but
> I'd better make sure that 'res' is not NULL before printing, just like:
> 
> list_for_each_entry(res, &dlm->tracking_list, tracking) {
> 		spin_unlock(&dlm->track_lock);
> 		if (res)
> 			dlm_print_one_lock_resource(res);
> 		spin_lock(&dlm->track_lock);
> }
> 
> Thanks
> Jun

IIUC, your intent to add track lock here is to protect tracking list
when iterate the loop, right? I am saying that if unlock track lock
here, the loop is still unsafe.
Checking res here is meaningless. Maybe list_for_each_entry_safe
could work here.
BTW, how this race case happens? The above code is during umount,
what is the other flow?

Thanks,
Joseph
