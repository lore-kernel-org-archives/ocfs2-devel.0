From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 27 Jan 2016 09:36:04 +0800
Subject: [Ocfs2-devel] [PATCH 2/4] ocfs2/dlm: return in progress if
 master can not clear the refmap bit right now
In-Reply-To: <56A73F5F.8070903@huawei.com>
References: <56A73F5F.8070903@huawei.com>
Message-ID: <56A81F04.4000805@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2016/1/26 17:41, xuejiufei wrote:
> Master returns in-progress to non-master node when it can not clear
> the refmap bit right now. And non-master node will not purge the
> lock resource until receiving deref done message.
> 
> Signed-off-by: xuejiufei <xuejiufei@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>

> ---
>  fs/ocfs2/dlm/dlmcommon.h | 5 +++++
>  fs/ocfs2/dlm/dlmmaster.c | 8 +++++---
>  fs/ocfs2/dlm/dlmthread.c | 7 +++++++
>  3 files changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
> index 57a7cd5..ce695f1 100644
> --- a/fs/ocfs2/dlm/dlmcommon.h
> +++ b/fs/ocfs2/dlm/dlmcommon.h
> @@ -783,6 +783,11 @@ struct dlm_deref_lockres
>  	u8 name[O2NM_MAX_NAME_LEN];
>  };
> 
> +enum {
> +	DLM_DEREF_RESPONSE_DONE = 0,
> +	DLM_DEREF_RESPONSE_INPROG = 1,
> +};
> +
>  struct dlm_deref_lockres_done {
>  	u32 pad1;
>  	u16 pad2;
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index 8913e7d..87e2254 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -2278,7 +2278,7 @@ int dlm_drop_lockres_ref(struct dlm_ctxt *dlm, struct dlm_lock_resource *res)
>  		dlm_print_one_lock_resource(res);
>  		BUG();
>  	}
> -	return ret;
> +	return ret ? ret : r;
>  }
> 
>  int dlm_deref_lockres_handler(struct o2net_msg *msg, u32 len, void *data,
> @@ -2345,7 +2345,7 @@ int dlm_deref_lockres_handler(struct o2net_msg *msg, u32 len, void *data,
>  		     	res->lockname.len, res->lockname.name, node);
>  			dlm_print_one_lock_resource(res);
>  		}
> -		ret = 0;
> +		ret = DLM_DEREF_RESPONSE_DONE;
>  		goto done;
>  	}
> 
> @@ -2365,7 +2365,7 @@ int dlm_deref_lockres_handler(struct o2net_msg *msg, u32 len, void *data,
>  	spin_unlock(&dlm->work_lock);
> 
>  	queue_work(dlm->dlm_worker, &dlm->dispatched_work);
> -	return 0;
> +	return DLM_DEREF_RESPONSE_INPROG;
> 
>  done:
>  	if (res)
> @@ -2511,6 +2511,8 @@ static void dlm_deref_lockres_worker(struct dlm_work_item *item, void *data)
>  	}
>  	spin_unlock(&res->spinlock);
> 
> +	dlm_drop_lockres_ref_done(dlm, res, node);
> +
>  	if (cleared) {
>  		mlog(0, "%s:%.*s node %u ref dropped in dispatch\n",
>  		     dlm->name, res->lockname.len, res->lockname.name, node);
> diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
> index c5f6c24..22e6eb8 100644
> --- a/fs/ocfs2/dlm/dlmthread.c
> +++ b/fs/ocfs2/dlm/dlmthread.c
> @@ -202,6 +202,13 @@ static void dlm_purge_lockres(struct dlm_ctxt *dlm,
>  		dlm->purge_count--;
>  	}
> 
> +	if (!master && ret != 0) {
> +		mlog(0, "%s: deref %.*s in progress or master goes down\n",
> +			dlm->name, res->lockname.len, res->lockname.name);
> +		spin_unlock(&res->spinlock);
> +		return;
> +	}
> +
>  	if (!__dlm_lockres_unused(res)) {
>  		mlog(ML_ERROR, "%s: res %.*s in use after deref\n",
>  		     dlm->name, res->lockname.len, res->lockname.name);
> 
