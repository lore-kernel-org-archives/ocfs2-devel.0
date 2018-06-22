From: piaojun <piaojun@huawei.com>
Date: Fri, 22 Jun 2018 08:34:14 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix locking for res->tracking and
 dlm->tracking_list
In-Reply-To: <1529625429-13901-1-git-send-email-ashish.samant@oracle.com>
References: <1529625429-13901-1-git-send-email-ashish.samant@oracle.com>
Message-ID: <5B2C4406.7030500@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Ashish,

I think we should get 'res->spinlock' before getting 'dlm->track_lock'
such as in __dlm_do_purge_lockres(). But your patch reverse the locking
sequence as we will get 'res->spinlock' in dlm_print_one_lock_resource()
which may cause 'ABBA' deadlock.

thanks,
Jun

On 2018/6/22 7:57, Ashish Samant wrote:
> In dlm_init_lockres() and dlm_unregister_domain() we access and modify
> res->tracking and dlm->tracking_list without holding dlm->track_lock.
> This can cause list corruptions and can end up in kernel panic.
> 
> Fix this by locking res->tracking and dlm->tracking_list with
> dlm->track_lock at all places.
> 
> Signed-off-by: Ashish Samant <ashish.samant@oracle.com>
> ---
>  fs/ocfs2/dlm/dlmdomain.c | 2 ++
>  fs/ocfs2/dlm/dlmmaster.c | 4 ++--
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
> index 2acd58b..cfb1edd 100644
> --- a/fs/ocfs2/dlm/dlmdomain.c
> +++ b/fs/ocfs2/dlm/dlmdomain.c
> @@ -723,6 +723,7 @@ void dlm_unregister_domain(struct dlm_ctxt *dlm)
>  			mlog(0, "%s: more migration to do\n", dlm->name);
>  		}
>  
> +		spin_lock(&dlm->track_lock);
>  		/* This list should be empty. If not, print remaining lockres */
>  		if (!list_empty(&dlm->tracking_list)) {
>  			mlog(ML_ERROR, "Following lockres' are still on the "
> @@ -730,6 +731,7 @@ void dlm_unregister_domain(struct dlm_ctxt *dlm)
>  			list_for_each_entry(res, &dlm->tracking_list, tracking)
>  				dlm_print_one_lock_resource(res);
>  		}
> +		spin_unlock(&dlm->track_lock);
>  
>  		dlm_mark_domain_leaving(dlm);
>  		dlm_leave_domain(dlm);
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index aaca094..826f056 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -584,9 +584,9 @@ static void dlm_init_lockres(struct dlm_ctxt *dlm,
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
