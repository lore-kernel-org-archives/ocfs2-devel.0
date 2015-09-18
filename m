From: Joseph Qi <joseph.qi@huawei.com>
Date: Fri, 18 Sep 2015 15:28:45 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: fix race between convert and
 recovery
In-Reply-To: <55FB9280.30503@oracle.com>
References: <55FABD65.4010107@huawei.com> <55FB9280.30503@oracle.com>
Message-ID: <55FBBD2D.6090903@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2015/9/18 12:26, Tariq Saeed wrote:
> On 09/17/2015 06:17 AM, Joseph Qi wrote:
>> There is a race window between dlmconvert_remote and
>> dlm_move_lockres_to_recovery_list, which will cause a lock with
>> OCFS2_LOCK_BUSY in grant list, thus system hangs.
>>
>> dlmconvert_remote
>> {
>>     spin_lock(&res->spinlock);
>>     list_move_tail(&lock->list, &res->converting);
>>     lock->convert_pending = 1;
>>     spin_unlock(&res->spinlock);
>>
>>     status = dlm_send_remote_convert_request();
>>     >>>>>> race window, master has queued ast and return DLM_NORMAL,
>>            and then down before sending ast.
>>            this node detects master down and call
>>            dlm_move_lockres_to_recovery_list, which will revert the
>>            lock to grant list.
>>            Then OCFS2_LOCK_BUSY won't be cleared as new master won't
>>            send ast any more because it thinks already be authorized.
>>
>>     spin_lock(&res->spinlock);
>>     lock->convert_pending = 0;
>>     if (status != DLM_NORMAL)
>>         dlm_revert_pending_convert(res, lock);
>>     spin_unlock(&res->spinlock);
>> }
>>
>> In this case, just leave it in convert list and new master will take
>> care of it after recovery. And if convert request returns other than
>> DLM_NORMAL, convert thread will do the revert itself.
>> So remove the revert logic in dlm_move_lockres_to_recovery_list.
>>
> First, I have a question  about the old code  you are removing.
> How did this scenario ever worked?
> convert req has been sent to the master and caller of __ocfs2_cluster_lock()
> is waiting in ocfs2_wait_for_mask(&mw) when master dies. new master
> receives the res with our lock in granted state (since we move it there
>  in dlm_move_lockres_to_recovery_list). Now, the new master has no idea
>  that this lock needs upconversion. How will it get converted?
As you can see, dlm_shuffle_lists won't handle this kind of lock.
That means the convert won't be finished forever.

> 
> Now, back to your fix.This is my understanding.
> If we leave it in the converting list as you propose, then
> new master will also have it in converting list , its correct place.
> 
> dlm_shuffle_lists runs after recovery. Will send BAST to the new master which
> would behave just like the original master would have. If lock can be converted,
> it will send AST, otherwise it will wait until it can be, just like the old master would
> have done etc etc. Am I correct?
Yes.

> Thanks
> -Tariq
> 
> .
> 
