From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Thu, 24 Sep 2015 12:21:11 +0800
Subject: [Ocfs2-devel] [PATCH 1/2 v3] ocfs2/dlm: fix race between
	convert and recovery
In-Reply-To: <5603780C.2040400@huawei.com>
References: <56036AAB.7070102@huawei.com> <560374F4.10307@oracle.com>
	<5603780C.2040400@huawei.com>
Message-ID: <56037A37.6040008@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 09/24/2015 12:11 PM, Joseph Qi wrote:
> Hi Junxiao,
> 
> On 2015/9/24 11:58, Junxiao Bi wrote:
>> On 09/24/2015 11:14 AM, Joseph Qi wrote:
>>> There is a race window between dlmconvert_remote and
>>> dlm_move_lockres_to_recovery_list, which will cause a lock with
>>> OCFS2_LOCK_BUSY in grant list, thus system hangs.
>>>
>>> dlmconvert_remote
>>> {
>>>         spin_lock(&res->spinlock);
>>>         list_move_tail(&lock->list, &res->converting);
>>>         lock->convert_pending = 1;
>>>         spin_unlock(&res->spinlock);
>>>
>>>         status = dlm_send_remote_convert_request();
>>>         >>>>>> race window, master has queued ast and return DLM_NORMAL,
>>>                and then down before sending ast.
>>>                this node detects master down and calls
>>>                dlm_move_lockres_to_recovery_list, which will revert the
>>>                lock to grant list.
>>>                Then OCFS2_LOCK_BUSY won't be cleared as new master won't
>>>                send ast any more because it thinks already be authorized.
>> How this race windowed fixed?
>> the process have sent convert request to master node successfully(return
>> value DLM_NORMAL) then wait on LOCK_BUSY, then when master node panic
>> before send out ast, dlm_move_lockres_to_recovery_list() move the lock
>> to grant list. Ast never come.
> res->state is now having DLM_LOCK_RES_RECOVERING set. 
But what happened if master node panic after
dlm_send_remote_convert_request() return DLM_NORMAL and wait on LOCK_BUSY?

Thanks,
Junxiao.

This patch will
> reset the status to DLM_RECOVERING and then retry convert request. Then
> new master will handle it and send ast.
> 
>>
>> Thanks,
>> Junxiao.
>>
>>>
>>>         spin_lock(&res->spinlock);
>>>         lock->convert_pending = 0;
>>>         if (status != DLM_NORMAL)
>>>                 dlm_revert_pending_convert(res, lock);
>>>         spin_unlock(&res->spinlock);
>>> }
>>>
>>> In this case, check if res->state has DLM_LOCK_RES_RECOVERING bit set
>>> (res is still in recovering) or res master changed (new master has
>>> finished recovery), reset the status to DLM_RECOVERING, then it will
>>> retry convert.
>>>
>>> Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
>>> Reported-by: Yiwen Jiang <jiangyiwen@huawei.com>
>>> Cc: <stable@vger.kernel.org>
>>> ---
>>>  fs/ocfs2/dlm/dlmconvert.c | 11 ++++++++++-
>>>  1 file changed, 10 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/ocfs2/dlm/dlmconvert.c b/fs/ocfs2/dlm/dlmconvert.c
>>> index e36d63f..9e6116e 100644
>>> --- a/fs/ocfs2/dlm/dlmconvert.c
>>> +++ b/fs/ocfs2/dlm/dlmconvert.c
>>> @@ -262,6 +262,7 @@ enum dlm_status dlmconvert_remote(struct dlm_ctxt *dlm,
>>>  				  struct dlm_lock *lock, int flags, int type)
>>>  {
>>>  	enum dlm_status status;
>>> +	u8 old_owner = res->owner;
>>>
>>>  	mlog(0, "type=%d, convert_type=%d, busy=%d\n", lock->ml.type,
>>>  	     lock->ml.convert_type, res->state & DLM_LOCK_RES_IN_PROGRESS);
>>> @@ -316,11 +317,19 @@ enum dlm_status dlmconvert_remote(struct dlm_ctxt *dlm,
>>>  	spin_lock(&res->spinlock);
>>>  	res->state &= ~DLM_LOCK_RES_IN_PROGRESS;
>>>  	lock->convert_pending = 0;
>>> -	/* if it failed, move it back to granted queue */
>>> +	/* if it failed, move it back to granted queue.
>>> +	 * if master returns DLM_NORMAL and then down before sending ast,
>>> +	 * it may have already been moved to granted queue, reset to
>>> +	 * DLM_RECOVERING and retry convert */
>>>  	if (status != DLM_NORMAL) {
>>>  		if (status != DLM_NOTQUEUED)
>>>  			dlm_error(status);
>>>  		dlm_revert_pending_convert(res, lock);
>>> +	} else if ((res->state & DLM_LOCK_RES_RECOVERING) ||
>>> +			(old_owner != res->owner)) {
>>> +		mlog(0, "res %.*s is in recovering or has been recovered.\n",
>>> +				res->lockname.len, res->lockname.name);
>>> +		status = DLM_RECOVERING;
>>>  	}
>>>  bail:
>>>  	spin_unlock(&res->spinlock);
>>>
>>
>>
>> .
>>
> 
> 
