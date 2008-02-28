From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Feb 28 16:32:39 2008
Subject: [Ocfs2-devel] [PATCH 06/18] ocfs2_dlm: Link all lockres' to a
	tracking list
In-Reply-To: <1203970862-8790-7-git-send-email-sunil.mushran@oracle.com>
References: <1203970862-8790-1-git-send-email-sunil.mushran@oracle.com>
	<1203970862-8790-7-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080229003113.GI23975@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Feb 25, 2008 at 12:20:50PM -0800, Sunil Mushran wrote:
> This patch links all the lockres' to a tracking list in dlm_ctxt.
> We will use this in the upcoming patch that will walk the entire
> list and to dump the lockres states to a debugfs file.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>


> ---
>  fs/ocfs2/dlm/dlmcommon.h |    4 ++++
>  fs/ocfs2/dlm/dlmdomain.c |   11 +++++++++++
>  fs/ocfs2/dlm/dlmmaster.c |   11 +++++++++++
>  3 files changed, 26 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
> index eac1b3b..a3b22bf 100644
> --- a/fs/ocfs2/dlm/dlmcommon.h
> +++ b/fs/ocfs2/dlm/dlmcommon.h
> @@ -101,6 +101,7 @@ struct dlm_ctxt
>  	struct list_head purge_list;
>  	struct list_head pending_asts;
>  	struct list_head pending_basts;
> +	struct list_head tracking_list;
>  	unsigned int purge_count;
>  	spinlock_t spinlock;
>  	spinlock_t ast_lock;
> @@ -266,6 +267,9 @@ struct dlm_lock_resource
>  	struct list_head dirty;
>  	struct list_head recovering; // dlm_recovery_ctxt.resources list
>  
> +	/* Added during init and removed during release */
> +	struct list_head tracking;	/* dlm->tracking_list */
> +
>  	/* unused lock resources have their last_used stamped and are
>  	 * put on a list for the dlm thread to run. */
>  	unsigned long    last_used;
> diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
> index 6d02ef5..1d382f1 100644
> --- a/fs/ocfs2/dlm/dlmdomain.c
> +++ b/fs/ocfs2/dlm/dlmdomain.c
> @@ -634,6 +634,7 @@ int dlm_shutting_down(struct dlm_ctxt *dlm)
>  void dlm_unregister_domain(struct dlm_ctxt *dlm)
>  {
>  	int leave = 0;
> +	struct dlm_lock_resource *res;
>  
>  	spin_lock(&dlm_domain_lock);
>  	BUG_ON(dlm->dlm_state != DLM_CTXT_JOINED);
> @@ -663,6 +664,15 @@ void dlm_unregister_domain(struct dlm_ctxt *dlm)
>  			msleep(500);
>  			mlog(0, "%s: more migration to do\n", dlm->name);
>  		}
> +
> +		/* This list should be empty. If not, print remaining lockres */
> +		if (!list_empty(&dlm->tracking_list)) {
> +			mlog(ML_ERROR, "Following lockres' are still on the "
> +			     "tracking list:\n");
> +			list_for_each_entry(res, &dlm->tracking_list, tracking)
> +				dlm_print_one_lock_resource(res);
> +		}
> +
>  		dlm_mark_domain_leaving(dlm);
>  		dlm_leave_domain(dlm);
>  		dlm_complete_dlm_shutdown(dlm);
> @@ -1404,6 +1414,7 @@ static struct dlm_ctxt *dlm_alloc_ctxt(const char *domain,
>  	INIT_LIST_HEAD(&dlm->reco.node_data);
>  	INIT_LIST_HEAD(&dlm->purge_list);
>  	INIT_LIST_HEAD(&dlm->dlm_domain_handlers);
> +	INIT_LIST_HEAD(&dlm->tracking_list);
>  	dlm->reco.state = 0;
>  
>  	INIT_LIST_HEAD(&dlm->pending_asts);
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index d07a30a..d10fe48 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -642,6 +642,14 @@ static void dlm_lockres_release(struct kref *kref)
>  	mlog(0, "destroying lockres %.*s\n", res->lockname.len,
>  	     res->lockname.name);
>  
> +	if (!list_empty(&res->tracking))
> +		list_del_init(&res->tracking);
> +	else {
> +		mlog(ML_ERROR, "Resource %.*s not on the Tracking list\n",
> +		     res->lockname.len, res->lockname.name);
> +		dlm_print_one_lock_resource(res);
> +	}
> +
>  	if (!hlist_unhashed(&res->hash_node) ||
>  	    !list_empty(&res->granted) ||
>  	    !list_empty(&res->converting) ||
> @@ -709,6 +717,7 @@ static void dlm_init_lockres(struct dlm_ctxt *dlm,
>  	INIT_LIST_HEAD(&res->dirty);
>  	INIT_LIST_HEAD(&res->recovering);
>  	INIT_LIST_HEAD(&res->purge);
> +	INIT_LIST_HEAD(&res->tracking);
>  	atomic_set(&res->asts_reserved, 0);
>  	res->migration_pending = 0;
>  	res->inflight_locks = 0;
> @@ -724,6 +733,8 @@ static void dlm_init_lockres(struct dlm_ctxt *dlm,
>  
>  	res->last_used = 0;
>  
> +	list_add_tail(&res->tracking, &dlm->tracking_list);
> +
>  	memset(res->lvb, 0, DLM_LVB_LEN);
>  	memset(res->refmap, 0, sizeof(res->refmap));
>  }
> -- 
> 1.5.2.5
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

Life's Little Instruction Book #222

	"Think twice before burdening a friend with a secret."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
