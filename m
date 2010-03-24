From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 24 Mar 2010 14:41:51 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: be within spinlock when checking
 the owner of a lockres
In-Reply-To: <201003241442.o2NAdfs4028087@acsinet15.oracle.com>
References: <201003241442.o2NAdfs4028087@acsinet15.oracle.com>
Message-ID: <4BAA871F.7030200@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>


Wengang Wang wrote:
> The checking of lockres owner in dlm_update_lvb() is not with spinlock
> protection. I don't see problem in current call path of dlm_update_lvb().
> But just for code robustness.
>
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
>  fs/ocfs2/dlm/dlmast.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ocfs2/dlm/dlmast.c b/fs/ocfs2/dlm/dlmast.c
> index dccc439..b7a25ef 100644
> --- a/fs/ocfs2/dlm/dlmast.c
> +++ b/fs/ocfs2/dlm/dlmast.c
> @@ -185,9 +185,8 @@ static void dlm_update_lvb(struct dlm_ctxt *dlm, struct dlm_lock_resource *res,
>  	BUG_ON(!lksb);
>  
>  	/* only updates if this node masters the lockres */
> +	spin_lock(&res->spinlock);
>  	if (res->owner == dlm->node_num) {
> -
> -		spin_lock(&res->spinlock);
>  		/* check the lksb flags for the direction */
>  		if (lksb->flags & DLM_LKSB_GET_LVB) {
>  			mlog(0, "getting lvb from lockres for %s node\n",
> @@ -202,8 +201,8 @@ static void dlm_update_lvb(struct dlm_ctxt *dlm, struct dlm_lock_resource *res,
>   		 * here. In the future we might want to clear it at the time
>   		 * the put is actually done.
>  		 */
> -		spin_unlock(&res->spinlock);
>  	}
> +	spin_unlock(&res->spinlock);
>  
>  	/* reset any lvb flags on the lksb */
>  	lksb->flags &= ~(DLM_LKSB_PUT_LVB|DLM_LKSB_GET_LVB);
>   
