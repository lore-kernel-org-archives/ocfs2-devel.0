From: Changwei Ge <ge.changwei@h3c.com>
Date: Thu, 7 Dec 2017 11:59:40 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix a potential 'ABBA' deadlock
 caused by 'l_lock' and 'dentry_attach_lock'
References: <5A2925FB.2060908@huawei.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373F1F59145@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jun,

On 2017/12/7 19:30, piaojun wrote:
>         CPUA                                      CPUB
> 
> ocfs2_dentry_convert_worker
> get 'l_lock'

This lock belongs to ocfs2_dentry_lock::ocfs2_lock_res::l_lock

> 
>                                      get 'dentry_attach_lock'
> 
>                                      interruptted by dio_end_io:
>                                        dio_end_io
>                                          dio_bio_end_aio
>                                            dio_complete
>                                              dio->end_io
>                                                ocfs2_dio_end_io
>                                                  ocfs2_rw_unlock
>                                                  ...
>                                                  try to get 'l_lock'

This lock belongs to ocfs2_lock_res::l_lock though.

So I think they are totally two different locks.
So making spin_lock to interruption safe is pointless.

Thanks,
Changwei

>                                                  but CPUA has got it.
> 
> try to get 'dentry_attach_lock',
> but CPUB has got 'dentry_attach_lock',
> and would not release it.
> 
> so we need use spin_lock_irqsave for 'dentry_attach_lock' to prevent
> interruptted by softirq.
> 
> Signed-off-by: Jun Piao <piaojun@huawei.com>
> Reviewed-by: Alex Chen <alex.chen@huawei.com>
> ---
>   fs/ocfs2/dcache.c  | 14 ++++++++------
>   fs/ocfs2/dlmglue.c | 14 +++++++-------
>   fs/ocfs2/namei.c   |  5 +++--
>   3 files changed, 18 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
> index 2903730..6555fbf 100644
> --- a/fs/ocfs2/dcache.c
> +++ b/fs/ocfs2/dcache.c
> @@ -230,6 +230,7 @@ int ocfs2_dentry_attach_lock(struct dentry *dentry,
>   	int ret;
>   	struct dentry *alias;
>   	struct ocfs2_dentry_lock *dl = dentry->d_fsdata;
> +	unsigned long flags;
> 
>   	trace_ocfs2_dentry_attach_lock(dentry->d_name.len, dentry->d_name.name,
>   				       (unsigned long long)parent_blkno, dl);
> @@ -309,10 +310,10 @@ int ocfs2_dentry_attach_lock(struct dentry *dentry,
>   	ocfs2_dentry_lock_res_init(dl, parent_blkno, inode);
> 
>   out_attach:
> -	spin_lock(&dentry_attach_lock);
> +	spin_lock_irqsave(&dentry_attach_lock, flags);
>   	dentry->d_fsdata = dl;
>   	dl->dl_count++;
> -	spin_unlock(&dentry_attach_lock);
> +	spin_unlock_irqrestore(&dentry_attach_lock, flags);
> 
>   	/*
>   	 * This actually gets us our PRMODE level lock. From now on,
> @@ -333,9 +334,9 @@ int ocfs2_dentry_attach_lock(struct dentry *dentry,
>   	if (ret < 0 && !alias) {
>   		ocfs2_lock_res_free(&dl->dl_lockres);
>   		BUG_ON(dl->dl_count != 1);
> -		spin_lock(&dentry_attach_lock);
> +		spin_lock_irqsave(&dentry_attach_lock, flags);
>   		dentry->d_fsdata = NULL;
> -		spin_unlock(&dentry_attach_lock);
> +		spin_unlock_irqrestore(&dentry_attach_lock, flags);
>   		kfree(dl);
>   		iput(inode);
>   	}
> @@ -379,13 +380,14 @@ void ocfs2_dentry_lock_put(struct ocfs2_super *osb,
>   			   struct ocfs2_dentry_lock *dl)
>   {
>   	int unlock = 0;
> +	unsigned long flags;
> 
>   	BUG_ON(dl->dl_count == 0);
> 
> -	spin_lock(&dentry_attach_lock);
> +	spin_lock_irqsave(&dentry_attach_lock, flags);
>   	dl->dl_count--;
>   	unlock = !dl->dl_count;
> -	spin_unlock(&dentry_attach_lock);
> +	spin_unlock_irqrestore(&dentry_attach_lock, flags);
> 
>   	if (unlock)
>   		ocfs2_drop_dentry_lock(osb, dl);
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 4689940..9bff3d2 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -3801,7 +3801,7 @@ static int ocfs2_dentry_convert_worker(struct ocfs2_lock_res *lockres,
>   	struct ocfs2_dentry_lock *dl = ocfs2_lock_res_dl(lockres);
>   	struct ocfs2_inode_info *oi = OCFS2_I(dl->dl_inode);
>   	struct dentry *dentry;
> -	unsigned long flags;
> +	unsigned long flags, d_flags;
>   	int extra_ref = 0;
> 
>   	/*
> @@ -3831,13 +3831,13 @@ static int ocfs2_dentry_convert_worker(struct ocfs2_lock_res *lockres,
>   	 * flag.
>   	 */
>   	spin_lock_irqsave(&lockres->l_lock, flags);
> -	spin_lock(&dentry_attach_lock);
> +	spin_lock_irqsave(&dentry_attach_lock, d_flags);
>   	if (!(lockres->l_flags & OCFS2_LOCK_FREEING)
>   	    && dl->dl_count) {
>   		dl->dl_count++;
>   		extra_ref = 1;
>   	}
> -	spin_unlock(&dentry_attach_lock);
> +	spin_unlock_irqrestore(&dentry_attach_lock, d_flags);
>   	spin_unlock_irqrestore(&lockres->l_lock, flags);
> 
>   	mlog(0, "extra_ref = %d\n", extra_ref);
> @@ -3850,13 +3850,13 @@ static int ocfs2_dentry_convert_worker(struct ocfs2_lock_res *lockres,
>   	if (!extra_ref)
>   		return UNBLOCK_CONTINUE;
> 
> -	spin_lock(&dentry_attach_lock);
> +	spin_lock_irqsave(&dentry_attach_lock, d_flags);
>   	while (1) {
>   		dentry = ocfs2_find_local_alias(dl->dl_inode,
>   						dl->dl_parent_blkno, 1);
>   		if (!dentry)
>   			break;
> -		spin_unlock(&dentry_attach_lock);
> +		spin_unlock_irqrestore(&dentry_attach_lock, d_flags);
> 
>   		if (S_ISDIR(dl->dl_inode->i_mode))
>   			shrink_dcache_parent(dentry);
> @@ -3874,9 +3874,9 @@ static int ocfs2_dentry_convert_worker(struct ocfs2_lock_res *lockres,
>   		d_delete(dentry);
>   		dput(dentry);
> 
> -		spin_lock(&dentry_attach_lock);
> +		spin_lock_irqsave(&dentry_attach_lock, d_flags);
>   	}
> -	spin_unlock(&dentry_attach_lock);
> +	spin_unlock_irqrestore(&dentry_attach_lock, d_flags);
> 
>   	/*
>   	 * If we are the last holder of this dentry lock, there is no
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index 3b0a10d..a17454e 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -223,13 +223,14 @@ static void ocfs2_cleanup_add_entry_failure(struct ocfs2_super *osb,
>   		struct dentry *dentry, struct inode *inode)
>   {
>   	struct ocfs2_dentry_lock *dl = dentry->d_fsdata;
> +	unsigned long flags;
> 
>   	ocfs2_simple_drop_lockres(osb, &dl->dl_lockres);
>   	ocfs2_lock_res_free(&dl->dl_lockres);
>   	BUG_ON(dl->dl_count != 1);
> -	spin_lock(&dentry_attach_lock);
> +	spin_lock_irqsave(&dentry_attach_lock, flags);
>   	dentry->d_fsdata = NULL;
> -	spin_unlock(&dentry_attach_lock);
> +	spin_unlock_irqrestore(&dentry_attach_lock, flags);
>   	kfree(dl);
>   	iput(inode);
>   }
> 
