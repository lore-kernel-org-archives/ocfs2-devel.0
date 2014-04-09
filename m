From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 9 Apr 2014 14:44:59 -0700
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: retry once
 dlm_dispatch_assert_master failed with ENOMEM
In-Reply-To: <5343D3A8.1080302@huawei.com>
References: <5343D3A8.1080302@huawei.com>
Message-ID: <20140409144459.ffbb36cc9e6c15382d5a2674@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, 8 Apr 2014 18:47:04 +0800 Joseph Qi <joseph.qi@huawei.com> wrote:

> Once dlm_dispatch_assert_master failed in dlm_master_requery_handler,
> the only reason is ENOMEM.
> Add retry logic to avoid BUG() in case of not enough memory
> temporarily.
> 
> ...
>
> --- a/fs/ocfs2/dlm/dlmrecovery.c
> +++ b/fs/ocfs2/dlm/dlmrecovery.c
> @@ -1676,6 +1676,9 @@ int dlm_master_requery_handler(struct o2net_msg *msg, u32 len, void *data,
>  	unsigned int hash;
>  	int master = DLM_LOCK_RES_OWNER_UNKNOWN;
>  	u32 flags = DLM_ASSERT_MASTER_REQUERY;
> +	int ret, retries = 0;
> +
> +#define DISPATCH_ASSERT_RETRY_TIMES 3
>  
>  	if (!dlm_grab(dlm)) {
>  		/* since the domain has gone away on this
> @@ -1685,18 +1688,30 @@ int dlm_master_requery_handler(struct o2net_msg *msg, u32 len, void *data,
>  
>  	hash = dlm_lockid_hash(req->name, req->namelen);
>  
> +retry:
>  	spin_lock(&dlm->spinlock);
>  	res = __dlm_lookup_lockres(dlm, req->name, req->namelen, hash);
>  	if (res) {
>  		spin_lock(&res->spinlock);
>  		master = res->owner;
>  		if (master == dlm->node_num) {
> -			int ret = dlm_dispatch_assert_master(dlm, res,
> -							     0, 0, flags);
> +			ret = dlm_dispatch_assert_master(dlm, res,
> +					0, 0, flags);
>  			if (ret < 0) {
> -				mlog_errno(-ENOMEM);
> -				/* retry!? */
> -				BUG();
> +				mlog_errno(ret);
> +
> +				/* ENOMEM returns, retry until
> +				 * DISPATCH_ASSERT_RETRY_TIMES reached */
> +				if (retries < DISPATCH_ASSERT_RETRY_TIMES) {
> +					spin_unlock(&res->spinlock);
> +					dlm_lockres_put(res);
> +					spin_unlock(&dlm->spinlock);
> +					msleep(50);
> +					retries++;
> +					goto retry;
> +				} else {
> +					BUG();
> +				}

urgh, this is not good.  dlm_dispatch_assert_master() uses GFP_ATOMIC
and the chances of that failing are relatively high.  The msleep()
might save us, but what happens if we cannot get more memory until some
writeback occurs to this filesystem?

It would be much better to use GFP_KERNEL in
dlm_dispatch_assert_master().  That means preallocating the
dlm_work_item in the caller before taking the spinlock.
