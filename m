From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 21 Sep 2010 15:56:45 -0700
Subject: [Ocfs2-devel] [PATCH] o2dlm: force free mles during dlm exit
In-Reply-To: <1285108226-21280-1-git-send-email-srinivas.eeda@oracle.com>
References: <1285108226-21280-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <4C99382D.3040107@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Comments inlined.

On 09/21/2010 03:30 PM, Srinivas Eeda wrote:
> While umounting, a block mle doesn't get freed if dlm is shutdown after
> master request is received but before assert master. This results in unclean
> shutdown of dlm domain.
>
> This patch frees all mles that lie around after other nodes were notified about
> exiting the dlm and marking dlm state as leaving. Only block mles are expected
> to be around, so we log ERROR for other mles but still free them.
>
> Signed-off-by: Srinivas Eeda<srinivas.eeda@oracle.com>
> ---
>   fs/ocfs2/dlm/dlmcommon.h |    1 +
>   fs/ocfs2/dlm/dlmdomain.c |    1 +
>   fs/ocfs2/dlm/dlmmaster.c |   34 ++++++++++++++++++++++++++++++++++
>   3 files changed, 36 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
> index 4b6ae2c..7652989 100644
> --- a/fs/ocfs2/dlm/dlmcommon.h
> +++ b/fs/ocfs2/dlm/dlmcommon.h
> @@ -1030,6 +1030,7 @@ int dlm_drop_lockres_ref(struct dlm_ctxt *dlm,
>   			 struct dlm_lock_resource *res);
>   void dlm_clean_master_list(struct dlm_ctxt *dlm,
>   			   u8 dead_node);
> +void dlm_force_free_mles(struct dlm_ctxt *dlm);
>   int dlm_lock_basts_flushed(struct dlm_ctxt *dlm, struct dlm_lock *lock);
>   int __dlm_lockres_has_locks(struct dlm_lock_resource *res);
>   int __dlm_lockres_unused(struct dlm_lock_resource *res);
> diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
> index 153abb5..11a5c87 100644
> --- a/fs/ocfs2/dlm/dlmdomain.c
> +++ b/fs/ocfs2/dlm/dlmdomain.c
> @@ -693,6 +693,7 @@ void dlm_unregister_domain(struct dlm_ctxt *dlm)
>
>   		dlm_mark_domain_leaving(dlm);
>   		dlm_leave_domain(dlm);
> +		dlm_force_free_mles(dlm);
>   		dlm_complete_dlm_shutdown(dlm);
>   	}
>   	dlm_put(dlm);
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index ffb4c68..156f420 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -3433,3 +3433,37 @@ void dlm_lockres_release_ast(struct dlm_ctxt *dlm,
>   	wake_up(&res->wq);
>   	wake_up(&dlm->migration_wq);
>   }
> +
> +void dlm_force_free_mles(struct dlm_ctxt *dlm)
> +{
> +	int i;
> +	struct hlist_head *bucket;
> +	struct dlm_master_list_entry *mle;
> +	struct hlist_node *tmp, *list;
> +
> +	/* We notified all other nodes that we are exiting the domain and
> +	 * marked the dlm state to DLM_CTXT_LEAVING. If any mles are still
> +	 * around we force free them and wake any processes that are waiting
> +	 * on the mles */
>    

Multi-line comments should be in the format below.

/*
  * Add comment here
  * and here.
  */

> +	spin_lock(&dlm->spinlock);
> +	spin_lock(&dlm->master_lock);
>    

Add:

BUG_ON(dlm->dlm_state != DLM_CTXT_LEAVING);
BUG_ON((find_next_bit(dlm->domain_map, O2NM_MAX_NODES, 0) < 
O2NM_MAX_NODES));

We want to ensure that we don't call this function from some other
context. The BUG_ONs ensure that the state is leaving and that the
message has been sent to all nodes. The latter is important because
we are force freeing the mles with the understanding that the other
nodes are aware that this node has left the domain.

> +	for (i = 0; i<  DLM_HASH_BUCKETS; i++) {
> +		bucket = dlm_master_hash(dlm, i);
> +		hlist_for_each_safe(list, tmp, bucket) {
> +			mle = hlist_entry(list, struct dlm_master_list_entry,
> +					  master_hash_node);
> +			if (mle->type != DLM_MLE_BLOCK) {
> +				mlog(ML_ERROR, "bad mle: %p\n", mle);
> +				dlm_print_one_mle(mle);
> +			}
> +			atomic_set(&mle->woken, 1);
> +			wake_up(&mle->wq);
> +
> +			__dlm_unlink_mle(dlm, mle);
> +			__dlm_mle_detach_hb_events(dlm, mle);
> +			__dlm_put_mle(mle);
> +		}
> +	}
> +	spin_unlock(&dlm->master_lock);
> +	spin_unlock(&dlm->spinlock);
> +}
>    
