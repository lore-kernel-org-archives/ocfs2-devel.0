From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 27 Jan 2016 09:38:01 +0800
Subject: [Ocfs2-devel] [PATCH 3/4] ocfs2/dlm: clear DROPPING_REF flag
 when the master goes down
In-Reply-To: <56A73FAF.40409@huawei.com>
References: <56A73FAF.40409@huawei.com>
Message-ID: <56A81F79.2080708@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2016/1/26 17:43, xuejiufei wrote:
> If the master goes down after return in-progress for deref message. The
> lock resource on non-master node can not be purged. Clear the
> DROPPING_REF flag and recovery it.
> 
> Signed-off-by: xuejiufei <xuejiufei@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>

> ---
>  fs/ocfs2/dlm/dlmrecovery.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
> index c5bdf02..c19059a 100644
> --- a/fs/ocfs2/dlm/dlmrecovery.c
> +++ b/fs/ocfs2/dlm/dlmrecovery.c
> @@ -2375,14 +2375,16 @@ static void dlm_do_local_recovery_cleanup(struct dlm_ctxt *dlm, u8 dead_node)
>  			dlm_revalidate_lvb(dlm, res, dead_node);
>  			if (res->owner == dead_node) {
>  				if (res->state & DLM_LOCK_RES_DROPPING_REF) {
> -					mlog(ML_NOTICE, "%s: res %.*s, Skip "
> -					     "recovery as it is being freed\n",
> -					     dlm->name, res->lockname.len,
> -					     res->lockname.name);
> -				} else
> -					dlm_move_lockres_to_recovery_list(dlm,
> -									  res);
> -
> +					mlog(0, "%s:%.*s: owned by "
> +						"dead node %u, this node was "
> +						"dropping its ref when it died. "
> +						"continue, dropping the flag.\n",
> +						dlm->name, res->lockname.len,
> +						res->lockname.name, dead_node);
> +				}
> +				res->state &= ~DLM_LOCK_RES_DROPPING_REF;
> +				dlm_move_lockres_to_recovery_list(dlm,
> +						res);
>  			} else if (res->owner == dlm->node_num) {
>  				dlm_free_dead_locks(dlm, res, dead_node);
>  				__dlm_lockres_calc_usage(dlm, res);
> 
