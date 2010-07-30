From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 30 Jul 2010 10:06:04 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: remove potential deadlock -V3
In-Reply-To: <201007301519.o6UFJ5ch018098@acsinet15.oracle.com>
References: <201007301519.o6UFJ5ch018098@acsinet15.oracle.com>
Message-ID: <4C53067C.4090204@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Acked-by: Sunil Mushran <sunil.mushran@oracle.com>

On 07/30/2010 08:18 AM, Wengang Wang wrote:
> When we need to take both dlm_domain_lock and dlm->spinlock, we should take
> them in order of: dlm_domain_lock then dlm->spinlock.
>
> There is pathes disobey this order. That is calling dlm_lockres_put() with
> dlm->spinlock held in dlm_run_purge_list. dlm_lockres_put() calls dlm_put() at
> the ref and dlm_put() locks on dlm_domain_lock.
>
> Fix:
> Don't grab/put the dlm when the initialising/releasing lockres.
> That grab is not required because we don't call dlm_unregister_domain()
> based on refcount.
>
> Signed-off-by: Wengang Wang<wen.gang.wang@oracle.com>
> ---
>   fs/ocfs2/dlm/dlmmaster.c |    4 ----
>   1 file changed, 4 deletions(-)
>
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index 94b97fc..0fe7c4d 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -511,8 +511,6 @@ static void dlm_lockres_release(struct kref *kref)
>
>   	atomic_dec(&dlm->res_cur_count);
>
> -	dlm_put(dlm);
> -
>   	if (!hlist_unhashed(&res->hash_node) ||
>   	    !list_empty(&res->granted) ||
>   	    !list_empty(&res->converting) ||
> @@ -585,8 +583,6 @@ static void dlm_init_lockres(struct dlm_ctxt *dlm,
>   	res->migration_pending = 0;
>   	res->inflight_locks = 0;
>
> -	/* put in dlm_lockres_release */
> -	dlm_grab(dlm);
>   	res->dlm = dlm;
>
>   	kref_init(&res->refs);
>    
