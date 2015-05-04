From: Joseph Qi <joseph.qi@huawei.com>
Date: Mon, 4 May 2015 09:22:32 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: dlm: fix race between purge and
	get lock resource
In-Reply-To: <1430403891-30132-1-git-send-email-junxiao.bi@oracle.com>
References: <1430403891-30132-1-git-send-email-junxiao.bi@oracle.com>
Message-ID: <5546C9D8.5080304@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Andrew,
As discussed, this fix is better than mine.
So please discard mine (linux-next commit 71bd4edae86b) and take this,
thanks.

On 2015/4/30 22:24, Junxiao Bi wrote:
> There is a race window in dlm_get_lock_resource(), which may
> return a lock resource which have been purged. This will cause
> the process hung forever in dlmlock() as the ast msg can't be
> handled due to its lock resource not exist.
> 
> dlm_get_lock_resource {
> 	...
> 	spin_lock(&dlm->spinlock);
> 	tmpres = __dlm_lookup_lockres_full(dlm, lockid, namelen, hash);
> 	if (tmpres) {
> 		spin_unlock(&dlm->spinlock);
> 		>>>>>>>> race window, dlm_run_purge_list() may run and purge
> 				 the lock resource
> 		spin_lock(&tmpres->spinlock);
> 		...
> 		spin_unlock(&tmpres->spinlock);
> 	}
> }
> 
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> Cc: Joseph Qi <joseph.qi@huawei.com>
> Cc: <stable@vger.kernel.org>
> ---
>  fs/ocfs2/dlm/dlmmaster.c |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index a6944b2..fdf4b41 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -757,6 +757,19 @@ lookup:
>  	if (tmpres) {
>  		spin_unlock(&dlm->spinlock);
>  		spin_lock(&tmpres->spinlock);
> +
> +		/*
> +		 * Right after dlm spinlock was released, dlm_thread could have
> +		 * purged the lockres. Check if lockres got unhashed. If so
> +		 * start over.
> +		 */
> +		if (hlist_unhashed(&tmpres->hash_node)) {
> +			spin_unlock(&tmpres->spinlock);
> +			dlm_lockres_put(tmpres);
> +			tmpres = NULL;
> +			goto lookup;
> +		}
> +
>  		/* Wait on the thread that is mastering the resource */
>  		if (tmpres->owner == DLM_LOCK_RES_OWNER_UNKNOWN) {
>  			__dlm_wait_on_lockres(tmpres);
> 
