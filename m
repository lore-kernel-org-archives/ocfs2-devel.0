From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Mon, 14 Dec 2015 13:49:27 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: wait until
 DLM_LOCK_RES_SETREF_INPROG is cleared in dlm_deref_lockres_worker
In-Reply-To: <5668002C.3070107@huawei.com>
References: <5668002C.3070107@huawei.com>
Message-ID: <566E5867.7080506@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 12/09/2015 06:19 PM, jiangyiwen wrote:
> commit f3f854648de6("ocfs2_dlm: Ensure correct ordering of set/clear
> refmap bit on lockres") still exists a race which can't ensure the
> ordering is exactly correct.
> 
> Node1               Node2                    Node3
> umount, migrate
> lockres to Node2
>                     migrate finished,
>                     send migrate request
>                     to Node3
>                                               received migrate request,
>                                               create a migration_mle,
>                                               respond to Node2.
>                     set DLM_LOCK_RES_SETREF_INPROG
>                     and send assert master to
>                     Node3
>                                               delete migration_mle in
>                                               assert_master_handler,
>                                               Node3 umount without response
>                                               dlm_thread purge
>                                               this lockres, send drop
>                                               deref message to Node2
>                     found the flag of
>                     DLM_LOCK_RES_SETREF_INPROG
>                     is set, dispatch
>                     dlm_deref_lockres_worker to
>                     clear refmap, but in function of
>                     dlm_deref_lockres_worker,
>                     only if node in refmap it wait
>                     DLM_LOCK_RES_SETREF_INPROG
>                     to be cleared. So worker is
>                     done successfully
> 
>                                               purge lockres, send
>                                               assert master response
>                                               to Node1, and finish umount
>                     set Node3 in refmap, and it
>                     won't be cleared forever, thus
>                     lead to umount hung
> 
> so wait until DLM_LOCK_RES_SETREF_INPROG is cleared in
> dlm_deref_lockres_worker.
> 
> Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
> Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Looks good.

Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
> ---
>  fs/ocfs2/dlm/dlmmaster.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index ce38b4c..666ea67 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -2388,8 +2388,8 @@ static void dlm_deref_lockres_worker(struct dlm_work_item *item, void *data)
> 
>  	spin_lock(&res->spinlock);
>  	BUG_ON(res->state & DLM_LOCK_RES_DROPPING_REF);
> +	__dlm_wait_on_lockres_flags(res, DLM_LOCK_RES_SETREF_INPROG);
>  	if (test_bit(node, res->refmap)) {
> -		__dlm_wait_on_lockres_flags(res, DLM_LOCK_RES_SETREF_INPROG);
>  		dlm_lockres_clear_refmap_bit(dlm, res, node);
>  		cleared = 1;
>  	}
> 
