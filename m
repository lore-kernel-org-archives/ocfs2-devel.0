From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 27 Jan 2016 09:39:07 +0800
Subject: [Ocfs2-devel] [PATCH 4/4] ocfs2/dlm: return EINVAL when the
 lockres on migration target is in DROPPING_REF state
In-Reply-To: <56A73FE9.3010007@huawei.com>
References: <56A73FE9.3010007@huawei.com>
Message-ID: <56A81FBB.9080002@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2016/1/26 17:44, xuejiufei wrote:
> If master migrate this lock resource to node when it happened to purge
> it, a new lock resource will be created and inserted into hash list. If
> then master goes down, the lock resource being purged is recovered, so
> there exist two lock resource with different owner. So return error to
> master if the lock resource is in DROPPING state, master will retry to
> migrate this lock resource.
> 
> Signed-off-by: xuejiufei <xuejiufei@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>

> ---
>  fs/ocfs2/dlm/dlmrecovery.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
> index c19059a..4c7b548 100644
> --- a/fs/ocfs2/dlm/dlmrecovery.c
> +++ b/fs/ocfs2/dlm/dlmrecovery.c
> @@ -1403,12 +1403,24 @@ int dlm_mig_lockres_handler(struct o2net_msg *msg, u32 len, void *data,
>  	 * and RECOVERY flag changed when it completes. */
>  	hash = dlm_lockid_hash(mres->lockname, mres->lockname_len);
>  	spin_lock(&dlm->spinlock);
> -	res = __dlm_lookup_lockres(dlm, mres->lockname, mres->lockname_len,
> +	res = __dlm_lookup_lockres_full(dlm, mres->lockname, mres->lockname_len,
>  			hash);
>  	if (res) {
>  	 	/* this will get a ref on res */
>  		/* mark it as recovering/migrating and hash it */
>  		spin_lock(&res->spinlock);
> +		if (res->state & DLM_LOCK_RES_DROPPING_REF) {
> +			mlog(0, "%s: node is attempting to migrate "
> +				"lockres %.*s, but marked as dropping "
> +				" ref!\n", dlm->name,
> +				mres->lockname_len, mres->lockname);
> +			ret = -EINVAL;
> +			spin_unlock(&res->spinlock);
> +			spin_unlock(&dlm->spinlock);
> +			dlm_lockres_put(res);
> +			goto leave;
> +		}
> +
>  		if (mres->flags & DLM_MRES_RECOVERY) {
>  			res->state |= DLM_LOCK_RES_RECOVERING;
>  		} else {
> 
