From: Joseph Qi <jiangqi903@gmail.com>
Date: Thu, 30 May 2019 09:04:04 +0800
Subject: [Ocfs2-devel] [PATCH v4] fs/ocfs2: fix race in
	ocfs2_dentry_attach_lock
In-Reply-To: <20190529174636.22364-1-wen.gang.wang@oracle.com>
References: <20190529174636.22364-1-wen.gang.wang@oracle.com>
Message-ID: <b2cb4fa6-2e07-4861-0003-a5b1db86fe73@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 19/5/30 01:46, Wengang Wang wrote:
> ocfs2_dentry_attach_lock() can be executed in parallel threads against the
> same dentry. Make that race safe.
> The race is like this:
> 
>             thread A                               thread B
> 
> (A1) enter ocfs2_dentry_attach_lock,
> seeing dentry->d_fsdata is NULL,
> and no alias found by
> ocfs2_find_local_alias, so kmalloc
> a new ocfs2_dentry_lock structure
> to local variable "dl", dl1
> 
>                .....
> 
>                                     (B1) enter ocfs2_dentry_attach_lock,
>                                     seeing dentry->d_fsdata is NULL,
>                                     and no alias found by
>                                     ocfs2_find_local_alias so kmalloc
>                                     a new ocfs2_dentry_lock structure
>                                     to local variable "dl", dl2.
> 
>                                                    ......
> 
> (A2) set dentry->d_fsdata with dl1,
> call ocfs2_dentry_lock() and increase
> dl1->dl_lockres.l_ro_holders to 1 on
> success.
>               ......
> 
>                                     (B2) set dentry->d_fsdata with dl2
>                                     call ocfs2_dentry_lock() and increase
> 				    dl2->dl_lockres.l_ro_holders to 1 on
> 				    success.
> 
>                                                   ......
> 
> (A3) call ocfs2_dentry_unlock()
> and decrease
> dl2->dl_lockres.l_ro_holders to 0
> on success.
>              ....
> 
>                                     (B3) call ocfs2_dentry_unlock(),
>                                     decreasing
> 				    dl2->dl_lockres.l_ro_holders, but
> 				    see it's zero now, panic
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> Reported-by: Daniel Sobe <daniel.sobe@nxp.com>
> Tested-by: Daniel Sobe <daniel.sobe@nxp.com>
> Reviewed-by: Changwei Ge <gechangwei@live.cn>

Looks fine.

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
> v4: return in place on race detection.
> 
> v3: add Reviewed-by, Reported-by and Tested-by only
> 
> v2: 1) removed lock on dentry_attach_lock at the first access of
>        dentry->d_fsdata since it helps very little.
>     2) do cleanups before freeing the duplicated dl
>     3) return after freeing the duplicated dl found.
> ---
> 
>  fs/ocfs2/dcache.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
> index 290373024d9d..e8ace3b54e9c 100644
> --- a/fs/ocfs2/dcache.c
> +++ b/fs/ocfs2/dcache.c
> @@ -310,6 +310,18 @@ int ocfs2_dentry_attach_lock(struct dentry *dentry,
>  
>  out_attach:
>  	spin_lock(&dentry_attach_lock);
> +	if (unlikely(dentry->d_fsdata && !alias)) {
> +		/* d_fsdata is set by a racing thread which is doing
> +		 * the same thing as this thread is doing. Leave the racing
> +		 * thread going ahead and we return here.
> +		 */
> +		spin_unlock(&dentry_attach_lock);
> +		iput(dl->dl_inode);
> +		ocfs2_lock_res_free(&dl->dl_lockres);
> +		kfree(dl);
> +		return 0;
> +	}
> +
>  	dentry->d_fsdata = dl;
>  	dl->dl_count++;
>  	spin_unlock(&dentry_attach_lock);
> 
