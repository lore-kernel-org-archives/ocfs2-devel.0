From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Fri, 18 Sep 2015 10:41:45 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: fix race between convert and
	recovery
In-Reply-To: <55FABD65.4010107@huawei.com>
References: <55FABD65.4010107@huawei.com>
Message-ID: <55FB79E9.7090507@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joseph,

On 09/17/2015 09:17 PM, Joseph Qi wrote:
> There is a race window between dlmconvert_remote and
> dlm_move_lockres_to_recovery_list, which will cause a lock with
> OCFS2_LOCK_BUSY in grant list, thus system hangs.
> 
> dlmconvert_remote
> {
> 	spin_lock(&res->spinlock);
> 	list_move_tail(&lock->list, &res->converting);
> 	lock->convert_pending = 1;
> 	spin_unlock(&res->spinlock);
> 
> 	status = dlm_send_remote_convert_request();
> 	>>>>>> race window, master has queued ast and return DLM_NORMAL,
> 	       and then down before sending ast.
> 	       this node detects master down and call
> 	       dlm_move_lockres_to_recovery_list, which will revert the
> 	       lock to grant list.
> 	       Then OCFS2_LOCK_BUSY won't be cleared as new master won't
> 	       send ast any more because it thinks already be authorized.
> 
> 	spin_lock(&res->spinlock);
> 	lock->convert_pending = 0;
> 	if (status != DLM_NORMAL)
> 		dlm_revert_pending_convert(res, lock);
> 	spin_unlock(&res->spinlock);
> }
> 
> In this case, just leave it in convert list and new master will take
> care of it after recovery. And if convert request returns other than
> DLM_NORMAL, convert thread will do the revert itself.
> So remove the revert logic in dlm_move_lockres_to_recovery_list.
Yes, looks good. The lock was already in convert list. Recovery process
will shuffle the list and send ast again. So why not clean up
convert_pending, it is useless now?
The same thing happen for lock_pending, the lock was already in block
list. I think it can also be removed.

Thanks,
Junxiao.

> 
> Reported-by: Yiwen Jiang <jiangyiwen@huawei.com>
> Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
> Cc: <stable@vger.kernel.org>
> ---
>  fs/ocfs2/dlm/dlmrecovery.c | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
> index ce12e0b..d797d49 100644
> --- a/fs/ocfs2/dlm/dlmrecovery.c
> +++ b/fs/ocfs2/dlm/dlmrecovery.c
> @@ -2058,15 +2058,7 @@ void dlm_move_lockres_to_recovery_list(struct dlm_ctxt *dlm,
>  		queue = dlm_list_idx_to_ptr(res, i);
>  		list_for_each_entry_safe(lock, next, queue, list) {
>  			dlm_lock_get(lock);
> -			if (lock->convert_pending) {
> -				/* move converting lock back to granted */
> -				BUG_ON(i != DLM_CONVERTING_LIST);
> -				mlog(0, "node died with convert pending "
> -				     "on %.*s. move back to granted list.\n",
> -				     res->lockname.len, res->lockname.name);
> -				dlm_revert_pending_convert(res, lock);
> -				lock->convert_pending = 0;
> -			} else if (lock->lock_pending) {
> +			if (lock->lock_pending) {
>  				/* remove pending lock requests completely */
>  				BUG_ON(i != DLM_BLOCKED_LIST);
>  				mlog(0, "node died with lock pending "
> 
