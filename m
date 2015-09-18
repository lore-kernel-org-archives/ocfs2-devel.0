From: Joseph Qi <joseph.qi@huawei.com>
Date: Fri, 18 Sep 2015 15:25:15 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: fix race between convert and
	recovery
In-Reply-To: <55FB79E9.7090507@oracle.com>
References: <55FABD65.4010107@huawei.com> <55FB79E9.7090507@oracle.com>
Message-ID: <55FBBC5B.1090900@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2015/9/18 10:41, Junxiao Bi wrote:
> Hi Joseph,
> 
> On 09/17/2015 09:17 PM, Joseph Qi wrote:
>> > There is a race window between dlmconvert_remote and
>> > dlm_move_lockres_to_recovery_list, which will cause a lock with
>> > OCFS2_LOCK_BUSY in grant list, thus system hangs.
>> > 
>> > dlmconvert_remote
>> > {
>> > 	spin_lock(&res->spinlock);
>> > 	list_move_tail(&lock->list, &res->converting);
>> > 	lock->convert_pending = 1;
>> > 	spin_unlock(&res->spinlock);
>> > 
>> > 	status = dlm_send_remote_convert_request();
>> > 	>>>>>> race window, master has queued ast and return DLM_NORMAL,
>> > 	       and then down before sending ast.
>> > 	       this node detects master down and call
>> > 	       dlm_move_lockres_to_recovery_list, which will revert the
>> > 	       lock to grant list.
>> > 	       Then OCFS2_LOCK_BUSY won't be cleared as new master won't
>> > 	       send ast any more because it thinks already be authorized.
>> > 
>> > 	spin_lock(&res->spinlock);
>> > 	lock->convert_pending = 0;
>> > 	if (status != DLM_NORMAL)
>> > 		dlm_revert_pending_convert(res, lock);
>> > 	spin_unlock(&res->spinlock);
>> > }
>> > 
>> > In this case, just leave it in convert list and new master will take
>> > care of it after recovery. And if convert request returns other than
>> > DLM_NORMAL, convert thread will do the revert itself.
>> > So remove the revert logic in dlm_move_lockres_to_recovery_list.
> Yes, looks good. The lock was already in convert list. Recovery process
> will shuffle the list and send ast again. So why not clean up
> convert_pending, it is useless now?
You are right. convert_pending is now useless. I will send a new version
later.
One more concern is, does it have relations with LVB?

> The same thing happen for lock_pending, the lock was already in block
> list. I think it can also be removed.
I'll investigate on it.

> 
> Thanks,
> Junxiao.
> 
