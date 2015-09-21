From: Joseph Qi <joseph.qi@huawei.com>
Date: Mon, 21 Sep 2015 17:23:43 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2/dlm: fix race between convert
	and recovery
In-Reply-To: <C60669F9-0021-4753-A41A-FA6B3E615E55@oracle.com>
References: <55FBF4BA.30000@huawei.com>
	<C60669F9-0021-4753-A41A-FA6B3E615E55@oracle.com>
Message-ID: <55FFCC9F.90201@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Junxiao,
This solution may have problem in the following scenario:
Consider dlm_send_remote_convert_request has taken too much time, and
dlm_move_lockres_to_recovery_list runs first and new master will see
this node is currently in convert list after recovery.
Then dlm_send_remote_convert_request returns other than DLM_NORMAL and
it will revert it to grant list, then retry convert. This will makes
this node and master inconsistent.
I will try to find another solution to resolve the race issue.

On 2015/9/20 15:20, Junxiao Bi wrote:
> Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
> 
>> > ? 2015?9?18????7:25?Joseph Qi <joseph.qi@huawei.com> ???
>> > 
>> > There is a race window between dlmconvert_remote and
>> > dlm_move_lockres_to_recovery_list, which will cause a lock with
>> > OCFS2_LOCK_BUSY in grant list, thus system hangs.
>> > 
>> > dlmconvert_remote
>> > {
>> >        spin_lock(&res->spinlock);
>> >        list_move_tail(&lock->list, &res->converting);
>> >        lock->convert_pending = 1;
>> >        spin_unlock(&res->spinlock);
>> > 
>> >        status = dlm_send_remote_convert_request();
>>>>>>>> >>>>>>> race window, master has queued ast and return DLM_NORMAL,
>> >               and then down before sending ast.
>> >               this node detects master down and calls
>> >               dlm_move_lockres_to_recovery_list, which will revert the
>> >               lock to grant list.
>> >               Then OCFS2_LOCK_BUSY won't be cleared as new master won't
>> >               send ast any more because it thinks already be authorized.
>> > 
>> >        spin_lock(&res->spinlock);
>> >        lock->convert_pending = 0;
>> >        if (status != DLM_NORMAL)
>> >                dlm_revert_pending_convert(res, lock);
>> >        spin_unlock(&res->spinlock);
>> > }
>> > 
>> > In this case, just leave it in convert list and new master will take care
>> > of it after recovery.  And if convert request returns other than
>> > DLM_NORMAL, convert thread will do the revert itself. So remove the
>> > revert logic in dlm_move_lockres_to_recovery_list.
>> > 
>> > changelog since v1:
>> > Clean up convert_pending since it is now useless.
