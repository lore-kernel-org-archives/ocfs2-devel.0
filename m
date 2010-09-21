From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Tue, 21 Sep 2010 12:15:18 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] o2dlm: free block mles during shutdown
In-Reply-To: <1285019993-9920-1-git-send-email-srinivas.eeda@oracle.com>
References: <1285019993-9920-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <20100921041518.GA3919@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Srini,

On 10-09-20 14:59, Srinivas Eeda wrote:
> If a node initiates shutdown after another node initiated the lock mastery
> process, this node might have created block mle but will not release it if it
> doesn't get the assert master from the other node. This causes block mle's to
> lie around unfreed.
> 
> This patch frees any block mles that exists on master list after the node sent
> DLM_EXIT_DOMAIN_MSG to other nodes.
> 
> Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
> ---
>  fs/ocfs2/dlm/dlmcommon.h |    1 +
>  fs/ocfs2/dlm/dlmdomain.c |    1 +
>  fs/ocfs2/dlm/dlmmaster.c |   33 +++++++++++++++++++++++++++++++++
>  3 files changed, 35 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
> index 4b6ae2c..48282dd 100644
> --- a/fs/ocfs2/dlm/dlmcommon.h
> +++ b/fs/ocfs2/dlm/dlmcommon.h
> @@ -1030,6 +1030,7 @@ int dlm_drop_lockres_ref(struct dlm_ctxt *dlm,
>  			 struct dlm_lock_resource *res);
>  void dlm_clean_master_list(struct dlm_ctxt *dlm,
>  			   u8 dead_node);
> +void dlm_free_block_mles(struct dlm_ctxt *dlm);
>  int dlm_lock_basts_flushed(struct dlm_ctxt *dlm, struct dlm_lock *lock);
>  int __dlm_lockres_has_locks(struct dlm_lock_resource *res);
>  int __dlm_lockres_unused(struct dlm_lock_resource *res);
> diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
> index 153abb5..8744fff 100644
> --- a/fs/ocfs2/dlm/dlmdomain.c
> +++ b/fs/ocfs2/dlm/dlmdomain.c
> @@ -693,6 +693,7 @@ void dlm_unregister_domain(struct dlm_ctxt *dlm)
>  
>  		dlm_mark_domain_leaving(dlm);
>  		dlm_leave_domain(dlm);
> +		dlm_free_block_mles(dlm);
>  		dlm_complete_dlm_shutdown(dlm);
>  	}
>  	dlm_put(dlm);
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index ffb4c68..5f4d6fd 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -3433,3 +3433,36 @@ void dlm_lockres_release_ast(struct dlm_ctxt *dlm,
>  	wake_up(&res->wq);
>  	wake_up(&dlm->migration_wq);
>  }
> +
> +void dlm_free_block_mles(struct dlm_ctxt *dlm)
> +{
> +	int i;
> +	struct hlist_head *bucket;
> +	struct dlm_master_list_entry *mle;
> +	struct hlist_node *list;
> +
> +	spin_lock(&dlm->spinlock);
> +	spin_lock(&dlm->master_lock);
> +	for (i = 0; i < DLM_HASH_BUCKETS; i++) {
> +		bucket = dlm_master_hash(dlm, i);
> +		hlist_for_each(list, bucket) {

I guess it can be the last reference on mles?
If so, don't we need "hlist_for_each_safe" here since we are removing entries?

regards,
wengang.

> +			mle = hlist_entry(list, struct dlm_master_list_entry,
> +					  master_hash_node);
> +			if (mle->type != DLM_MLE_BLOCK) {
> +				mlog(ML_ERROR, "mle for %.*s not destroyed, "
> +				     "type %d\n",
> +				     mle->mnamelen, mle->mname, mle->type);
> +				continue;
> +			}
> +			spin_lock(&mle->spinlock);
> +			atomic_set(&mle->woken, 1);
> +			spin_unlock(&mle->spinlock);
> +			wake_up(&mle->wq);
> +
> +			__dlm_mle_detach_hb_events(dlm, mle);
> +			__dlm_put_mle(mle);
> +		}
> +	}
> +	spin_unlock(&dlm->master_lock);
> +	spin_unlock(&dlm->spinlock);
> +}
> -- 
> 1.5.6.5
