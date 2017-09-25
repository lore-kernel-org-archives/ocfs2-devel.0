From: Joseph Qi <jiangqi903@gmail.com>
Date: Mon, 25 Sep 2017 18:35:34 +0800
Subject: [Ocfs2-devel] [patch 1/2] ocfs2/dlm: protect 'tracking_list' by
 'track_lock'
In-Reply-To: <59C5D77F.2030303@huawei.com>
References: <59C5D77F.2030303@huawei.com>
Message-ID: <a3302b2c-3492-5d77-ffe1-af630a1a8028@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 17/9/23 11:39, piaojun wrote:
> 'dlm->tracking_list' need to be protected by 'dlm->track_lock'.
> 
> Signed-off-by: Jun Piao <piaojun@huawei.com>
> Reviewed-by: Alex Chen <alex.chen@huawei.com>
> ---
>  fs/ocfs2/dlm/dlmdomain.c | 7 ++++++-
>  fs/ocfs2/dlm/dlmmaster.c | 4 ++--
>  2 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
> index a2b19fb..b118525 100644
> --- a/fs/ocfs2/dlm/dlmdomain.c
> +++ b/fs/ocfs2/dlm/dlmdomain.c
> @@ -726,12 +726,17 @@ void dlm_unregister_domain(struct dlm_ctxt *dlm)
>  		}
> 
>  		/* This list should be empty. If not, print remaining lockres */
> +		spin_lock(&dlm->track_lock);
>  		if (!list_empty(&dlm->tracking_list)) {
>  			mlog(ML_ERROR, "Following lockres' are still on the "
>  			     "tracking list:\n");
> -			list_for_each_entry(res, &dlm->tracking_list, tracking)
> +			list_for_each_entry(res, &dlm->tracking_list, tracking) {
> +				spin_unlock(&dlm->track_lock);

Um... If we unlock here, the iterator still has chance to be corrupted.

Thanks,
Joseph

>  				dlm_print_one_lock_resource(res);
> +				spin_lock(&dlm->track_lock);
> +			}
>  		}
> +		spin_unlock(&dlm->track_lock);
> 
>  		dlm_mark_domain_leaving(dlm);
>  		dlm_leave_domain(dlm);
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index 3e04279..44e7d18 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -589,9 +589,9 @@ static void dlm_init_lockres(struct dlm_ctxt *dlm,
> 
>  	res->last_used = 0;
> 
> -	spin_lock(&dlm->spinlock);
> +	spin_lock(&dlm->track_lock);
>  	list_add_tail(&res->tracking, &dlm->tracking_list);
> -	spin_unlock(&dlm->spinlock);
> +	spin_unlock(&dlm->track_lock);
> 
>  	memset(res->lvb, 0, DLM_LVB_LEN);
>  	memset(res->refmap, 0, sizeof(res->refmap));
> 
