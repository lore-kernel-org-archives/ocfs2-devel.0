From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 25 May 2010 10:22:12 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: remove unreasonable BUG_ON()
In-Reply-To: <201005251058.o4PAhNOK013998@acsinet15.oracle.com>
References: <201005251058.o4PAhNOK013998@acsinet15.oracle.com>
Message-ID: <4BFC0744.6050804@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

NAK

How did this lockres get into the dirty list? The dlm only adds locks that
it owns to that list. And such locks, by definition, can never be in the
recovery list.

On 05/25/2010 03:57 AM, Wengang Wang wrote:
> A node "down" can happen at any time. When that happens, all locres' owned
> by the "down" node are move to recovery list. They also are marked as in
> recovery and the owner are set to "unknown" under dlm->spinlock and
> res->spinlock.
>
> Any place shouldn't believe the owner is not changed to "unknown" after
> dropping the lockres and retaking them.
>
> Signed-off-by: Wengang Wang<wen.gang.wang@oracle.com>
> ---
>   fs/ocfs2/dlm/dlmthread.c |   17 +++++++++--------
>   1 files changed, 9 insertions(+), 8 deletions(-)
>
> diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
> index 11a6d1f..cf86b43 100644
> --- a/fs/ocfs2/dlm/dlmthread.c
> +++ b/fs/ocfs2/dlm/dlmthread.c
> @@ -675,15 +675,16 @@ static int dlm_thread(void *data)
>   			 * dirty_list in this gap, but that is ok */
>
>   			spin_lock(&res->spinlock);
> -			if (res->owner != dlm->node_num) {
> -				__dlm_print_one_lock_resource(res);
> -				mlog(ML_ERROR, "inprog:%s, mig:%s, reco:%s, dirty:%s\n",
> -				     res->state&  DLM_LOCK_RES_IN_PROGRESS ? "yes" : "no",
> -				     res->state&  DLM_LOCK_RES_MIGRATING ? "yes" : "no",
> -				     res->state&  DLM_LOCK_RES_RECOVERING ? "yes" : "no",
> -				     res->state&  DLM_LOCK_RES_DIRTY ? "yes" : "no");
> +			if (unlikely(res->owner != dlm->node_num)) {
> +				/*
> +				 * there is chance that the lockres is marked
> +				 * as in recovery if a node down happened.
> +				 */
> +				if (!(res->state&  DLM_LOCK_RES_RECOVERING)) {
> +					__dlm_print_one_lock_resource(res);
> +					BUG();
> +				}
>   			}
> -			BUG_ON(res->owner != dlm->node_num);
>
>   			/* it is now ok to move lockreses in these states
>   			 * to the dirty list, assuming that they will only be
>    
