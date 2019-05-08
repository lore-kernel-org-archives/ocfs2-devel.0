From: Changwei Ge <gechangwei@live.cn>
Date: Wed, 8 May 2019 02:06:57 +0000
Subject: [Ocfs2-devel] [PATCH v2] fs/ocfs2: fix race in
	ocfs2_dentry_attach_lock
In-Reply-To: <20190507185218.23770-1-wen.gang.wang@oracle.com>
References: <20190507185218.23770-1-wen.gang.wang@oracle.com>
Message-ID: <HK2PR02MB39244F2B8C362BA6F6F7F809D5320@HK2PR02MB3924.apcprd02.prod.outlook.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Wengang,


I think this version might need be improved.


On 2019/5/8 2:52 ??, Wengang Wang wrote:
> ocfs2_dentry_attach_lock() can be executed in parallel threads against the
> same dentry. Make that race safe.
> The race is like this:
>
>              thread A                               thread B
>
> (A1) enter ocfs2_dentry_attach_lock,
> seeing dentry->d_fsdata is NULL,
> and no alias found by
> ocfs2_find_local_alias, so kmalloc
> a new ocfs2_dentry_lock structure
> to local variable "dl", dl1
>
>                 .....
>
>                                      (B1) enter ocfs2_dentry_attach_lock,
>                                      seeing dentry->d_fsdata is NULL,
>                                      and no alias found by
>                                      ocfs2_find_local_alias so kmalloc
>                                      a new ocfs2_dentry_lock structure
>                                      to local variable "dl", dl2.
>
>                                                     ......
>
> (A2) set dentry->d_fsdata with dl1,
> call ocfs2_dentry_lock() and increase
> dl1->dl_lockres.l_ro_holders to 1 on
> success.
>                ......
>
>                                      (B2) set dentry->d_fsdata with dl2
>                                      call ocfs2_dentry_lock() and increase
> 				    dl2->dl_lockres.l_ro_holders to 1 on
> 				    success.
>
>                                                    ......
>
> (A3) call ocfs2_dentry_unlock()
> and decrease
> dl2->dl_lockres.l_ro_holders to 0
> on success.
>               ....
>
>                                      (B3) call ocfs2_dentry_unlock(),
>                                      decreasing
> 				    dl2->dl_lockres.l_ro_holders, but
> 				    see it's zero now, panic
>
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
> v2: 1) removed lock on dentry_attach_lock at the first access of
>         dentry->d_fsdata since it helps very little.
>      2) do cleanups before freeing the duplicated dl
>      3) return after freeing the duplicated dl found.
> ---
>   fs/ocfs2/dcache.c | 16 ++++++++++++++--
>   1 file changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
> index 290373024d9d..0d220a66297e 100644
> --- a/fs/ocfs2/dcache.c
> +++ b/fs/ocfs2/dcache.c
> @@ -230,6 +230,7 @@ int ocfs2_dentry_attach_lock(struct dentry *dentry,
>   	int ret;
>   	struct dentry *alias;
>   	struct ocfs2_dentry_lock *dl = dentry->d_fsdata;
> +	struct ocfs2_dentry_lock *dl_free_on_race = NULL;
>   
>   	trace_ocfs2_dentry_attach_lock(dentry->d_name.len, dentry->d_name.name,
>   				       (unsigned long long)parent_blkno, dl);
> @@ -310,10 +311,21 @@ int ocfs2_dentry_attach_lock(struct dentry *dentry,
>   
>   out_attach:
>   	spin_lock(&dentry_attach_lock);
> -	dentry->d_fsdata = dl;
> -	dl->dl_count++;
> +	/* d_fsdata could be set by parallel thread */
> +	if (unlikely(dentry->d_fsdata && !alias)) {
> +		dl_free_on_race = dl;
> +	} else {
> +		dentry->d_fsdata = dl;
> +		dl->dl_count++;
> +	}
>   	spin_unlock(&dentry_attach_lock);
>   
> +	if (unlikely(dl_free_on_race)) {
> +		iput(dl_free_on_race->dl_inode);
> +		ocfs2_lock_res_free(&dl_free_on_race->dl_lockres);


I am afraid we are meeting a great risk here as we don't know if the 
another dentry lock code path is still using the being freed lock resource.

So another code path might use a freed lock resource. This might be the 
cause of the problem Daniel reported last night(in China).


> +		kfree(dl_free_on_race);
> +		return 0;

Moreover, I think we can't directly return from here especially we are 
returning 0 here since we even don't increase dentry lock resource 
holders counter. :(


Thanks,

Changwei

> +	}
>   	/*
>   	 * This actually gets us our PRMODE level lock. From now on,
>   	 * we'll have a notification if one of these names is
