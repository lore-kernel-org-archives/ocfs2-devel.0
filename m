From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Wed, 23 Sep 2015 16:42:31 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2/dlm: fix race between convert
	and recovery
In-Reply-To: <5602595C.6000701@huawei.com>
References: <55FBF4BA.30000@huawei.com>
	<C60669F9-0021-4753-A41A-FA6B3E615E55@oracle.com>
	<55FFCC9F.90201@huawei.com> <5600A6FD.90901@oracle.com>
	<5601485F.4030506@huawei.com> <5601FFA6.4020407@oracle.com>
	<56020495.7070306@huawei.com> <56020774.1020102@oracle.com>
	<5602595C.6000701@huawei.com>
Message-ID: <560265F7.3070805@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 09/23/2015 03:48 PM, Joseph Qi wrote:
> On 2015/9/23 9:59, Junxiao Bi wrote:
>> On 09/23/2015 09:47 AM, Joseph Qi wrote:
>>> On 2015/9/23 9:25, Junxiao Bi wrote:
>>>> On 09/22/2015 08:23 PM, Joseph Qi wrote:
>>>>> Hi Junxiao,
>>>>>
>>>>> On 2015/9/22 8:55, Junxiao Bi wrote:
>>>>>> On 09/21/2015 05:23 PM, Joseph Qi wrote:
>>>>>>> Hi Junxiao,
>>>>>>> This solution may have problem in the following scenario:
>>>>>>> Consider dlm_send_remote_convert_request has taken too much time, and
>>>>>>> dlm_move_lockres_to_recovery_list runs first and new master will see
>>>>>>> this node is currently in convert list after recovery.
>>>>>>> Then dlm_send_remote_convert_request returns other than DLM_NORMAL and
>>>>>>> it will revert it to grant list, then retry convert. This will makes
>>>>>>> this node and master inconsistent.
>>>>>>> I will try to find another solution to resolve the race issue.
>>>>>>
>>>>>> If master is down, no need retry convert. May check the return value of
>>>>>> dlm_send_remote_convert_request(), if DLM_RECOVERING, don't retry,
>>>>>> otherwise retry?
>>>>>
>>>>> I want to keep the original logic. And for fixing the race case I
>>>>> described, how about the following idea?
>>>>>
>>>>> Check the status DLM_NORMAL. If res->state is currently
>>>>> DLM_LOCK_RES_RECOVERING (set in dlm_move_lockres_to_recovery_list, means
>>>>> still in recovery) or res master changed (means new master has finished
>>>>> the recovery), reset the status to DLM_RECOVERING, just like the check
>>>>> at the beginning of dlmconvert_remote. Then it is now in grant list and
>>>>> outer will retry.
>>>> How this idea fix the race windows you described in patch log? Lock is
>>>> reverted to granted list but dlm_send_remote_convert_request() return
>>>> DLM_NORMAL.
>>>>
>>> As I described in the former mail, status is now reset to DLM_RECOVERING,
>>> caller will retry. And the original way will just wait forever.
>> I mean convert request was sent to res master successfully,
>> dlm_send_remote_convert_request() have return DLM_NORMAL, but before res
>> master send ast it panic. Looks convert will not retry in this case.
>>
> The original way is just what you said.
> And my idea is letting dlmlock retry by resetting status to DLM_RECOVERING in
> such a case.
So convert_pending is still dropped? If so when
dlm_send_remote_convert_request() return DLM_RECOVERING, should reset it
to DLM_NORMAL and didn't revert lock to granted list. Retry is not needed.

Thanks,
Junxiao.

> 
>> Thanks,
>> Junxiao.
>>>
>>> Thanks
>>> Joseph
>>>
>>>> Thanks,
>>>> Junxiao.
>>>>>
>>>>>>
>>>>>> Thanks,
>>>>>> Junxiao.
>>>>>>
>>>>>>>
>>>>>>> On 2015/9/20 15:20, Junxiao Bi wrote:
>>>>>>>> Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
>>>>>>>>
>>>>>>>>>> ? 2015?9?18????7:25?Joseph Qi <joseph.qi@huawei.com> ???
>>>>>>>>>>
>>>>>>>>>> There is a race window between dlmconvert_remote and
>>>>>>>>>> dlm_move_lockres_to_recovery_list, which will cause a lock with
>>>>>>>>>> OCFS2_LOCK_BUSY in grant list, thus system hangs.
>>>>>>>>>>
>>>>>>>>>> dlmconvert_remote
>>>>>>>>>> {	
>>>>>>>>>>        spin_lock(&res->spinlock);
>>>>>>>>>>        list_move_tail(&lock->list, &res->converting);
>>>>>>>>>>        lock->convert_pending = 1;
>>>>>>>>>>        spin_unlock(&res->spinlock);
>>>>>>>>>>
>>>>>>>>>>        status = dlm_send_remote_convert_request();
>>>>>>>>>>>>>>>>>>>>>> race window, master has queued ast and return DLM_NORMAL,
>>>>>>>>>>               and then down before sending ast.
>>>>>>>>>>               this node detects master down and calls
>>>>>>>>>>               dlm_move_lockres_to_recovery_list, which will revert the
>>>>>>>>>>               lock to grant list.
>>>>>>>>>>               Then OCFS2_LOCK_BUSY won't be cleared as new master won't
>>>>>>>>>>               send ast any more because it thinks already be authorized.
>>>>>>>>>>
>>>>>>>>>>        spin_lock(&res->spinlock);
>>>>>>>>>>        lock->convert_pending = 0;
>>>>>>>>>>        if (status != DLM_NORMAL)
>>>>>>>>>>                dlm_revert_pending_convert(res, lock);
>>>>>>>>>>        spin_unlock(&res->spinlock);
>>>>>>>>>> }
>>>>>>>>>>
>>>>>>>>>> In this case, just leave it in convert list and new master will take care
>>>>>>>>>> of it after recovery.  And if convert request returns other than
>>>>>>>>>> DLM_NORMAL, convert thread will do the revert itself. So remove the
>>>>>>>>>> revert logic in dlm_move_lockres_to_recovery_list.
>>>>>>>>>>
>>>>>>>>>> changelog since v1:
>>>>>>>>>> Clean up convert_pending since it is now useless.
>>>>>>>
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
>>>
>>
>>
>> .
>>
> 
> 
