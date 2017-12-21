From: Joseph Qi <jiangqi903@gmail.com>
Date: Thu, 21 Dec 2017 09:30:01 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: fix a potential deadlock in
 dlm_reset_mleres_owner()
In-Reply-To: <5A3B0668.2030104@huawei.com>
References: <5A3B0668.2030104@huawei.com>
Message-ID: <53ed49bc-6fcd-0883-eb14-a2912630d809@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Alex,

On 17/12/21 08:55, alex chen wrote:
> In dlm_reset_mleres_owner(), we will lock
> dlm_lock_resource->spinlock after locking dlm_ctxt->master_lock,
> which breaks the spinlock lock ordering:
>  dlm_domain_lock
>  struct dlm_ctxt->spinlock
>  struct dlm_lock_resource->spinlock
>  struct dlm_ctxt->master_lock
> 
> Fix it by unlocking dlm_ctxt->master_lock before locking
> dlm_lock_resource->spinlock and restarting to clean master list.
> 
> Signed-off-by: Alex Chen <alex.chen@huawei.com>
> Reviewed-by: Jun Piao <piaojun@huawei.com>
> ---
>  fs/ocfs2/dlm/dlmmaster.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index 3e04279..d83ccdc 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -3287,16 +3287,22 @@ static struct dlm_lock_resource *dlm_reset_mleres_owner(struct dlm_ctxt *dlm,
>  {
>  	struct dlm_lock_resource *res;
> 
> +	assert_spin_locked(&dlm->spinlock);
> +	assert_spin_locked(&dlm->master_lock);
> +
>  	/* Find the lockres associated to the mle and set its owner to UNK */
> -	res = __dlm_lookup_lockres(dlm, mle->mname, mle->mnamelen,
> +	res = __dlm_lookup_lockres_full(dlm, mle->mname, mle->mnamelen,
>  				   mle->mnamehash);
>  	if (res) {
>  		spin_unlock(&dlm->master_lock);
> 
> -		/* move lockres onto recovery list */
>  		spin_lock(&res->spinlock);
> -		dlm_set_lockres_owner(dlm, res, DLM_LOCK_RES_OWNER_UNKNOWN);
> -		dlm_move_lockres_to_recovery_list(dlm, res);
> +		if (!(res->state & DLM_LOCK_RES_DROPPING_REF)) {
> +			/* move lockres onto recovery list */
> +			dlm_set_lockres_owner(dlm, res, DLM_LOCK_RES_OWNER_UNKNOWN);
> +			dlm_move_lockres_to_recovery_list(dlm, res);
> +		}
> +
I don't think this change is lock re-ordering *only*. It definitely
changes the logic of resetting mle resource owner.
Why do you detach mle from heartbeat if lock resource is in the process
of dropping its mastery reference? And why we have to restart in this
case?

Thanks,
Joseph

>  		spin_unlock(&res->spinlock);
>  		dlm_lockres_put(res);
> 
