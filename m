From: Joseph Qi <joseph.qi@huawei.com>
Date: Mon, 11 Jul 2016 19:04:45 +0800
Subject: [Ocfs2-devel] [PATCH v3] ocfs2: retry on ENOSPC if sufficient
 space in truncate log
In-Reply-To: <1468031546-4797-1-git-send-email-zren@suse.com>
References: <1468031546-4797-1-git-send-email-zren@suse.com>
Message-ID: <57837D4D.2070509@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2016/7/9 10:32, Eric Ren wrote:
> The testcase "mmaptruncate" in ocfs2 test suite always fails with
> ENOSPC error on small volume (say less than 10G). This testcase
> repeatedly performs "extend" and "truncate" on a file. Continuously,
> it truncates the file to 1/2 of the size, and then extends to 100% of
> the size. The main bitmap will quickly run out of space because the
> "truncate" code prevent truncate log from being flushed by
> ocfs2_schedule_truncate_log_flush(osb, 1), while truncate log may
> have cached lots of clusters.
> 
> So retry to allocate after flushing truncate log when ENOSPC is
> returned. And we cannot reuse the deleted blocks before the transaction
> committed. Fortunately, we already have a function to do this -
> ocfs2_try_to_free_truncate_log(). Just need to remove the "static"
> modifier and put it into the right place.
> 
> The "unlock"/"lock" code isn't elegant, but looks no better option.
> 
> v3:
> 1. Also need to lock allocator inode when "= 0" is returned from
> ocfs2_schedule_truncate_log_flush(), which means no space really.
> -- spotted by Joseph Qi
> 
> v2:
> 1. Lock allocator inode again if ocfs2_schedule_truncate_log_flush()
> fails. -- spotted by Joseph Qi <joseph.qi@huawei.com>
> 
> Signed-off-by: Eric Ren <zren@suse.com>

Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
> ---
>  fs/ocfs2/alloc.c    | 37 +++++++++++++++++++++++++++++++++++++
>  fs/ocfs2/alloc.h    |  2 ++
>  fs/ocfs2/aops.c     | 37 -------------------------------------
>  fs/ocfs2/suballoc.c | 20 +++++++++++++++++++-
>  4 files changed, 58 insertions(+), 38 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 460c0ce..7dabbc3 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -6106,6 +6106,43 @@ void ocfs2_schedule_truncate_log_flush(struct ocfs2_super *osb,
>  	}
>  }
>  
> +/*
> + * Try to flush truncate logs if we can free enough clusters from it.
> + * As for return value, "< 0" means error, "0" no space and "1" means
> + * we have freed enough spaces and let the caller try to allocate again.
> + */
> +int ocfs2_try_to_free_truncate_log(struct ocfs2_super *osb,
> +					unsigned int needed)
> +{
> +	tid_t target;
> +	int ret = 0;
> +	unsigned int truncated_clusters;
> +
> +	inode_lock(osb->osb_tl_inode);
> +	truncated_clusters = osb->truncated_clusters;
> +	inode_unlock(osb->osb_tl_inode);
> +
> +	/*
> +	 * Check whether we can succeed in allocating if we free
> +	 * the truncate log.
> +	 */
> +	if (truncated_clusters < needed)
> +		goto out;
> +
> +	ret = ocfs2_flush_truncate_log(osb);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +
> +	if (jbd2_journal_start_commit(osb->journal->j_journal, &target)) {
> +		jbd2_log_wait_commit(osb->journal->j_journal, target);
> +		ret = 1;
> +	}
> +out:
> +	return ret;
> +}
> +
>  static int ocfs2_get_truncate_log_info(struct ocfs2_super *osb,
>  				       int slot_num,
>  				       struct inode **tl_inode,
> diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
> index f3dc1b0..4a5152e 100644
> --- a/fs/ocfs2/alloc.h
> +++ b/fs/ocfs2/alloc.h
> @@ -188,6 +188,8 @@ int ocfs2_truncate_log_append(struct ocfs2_super *osb,
>  			      u64 start_blk,
>  			      unsigned int num_clusters);
>  int __ocfs2_flush_truncate_log(struct ocfs2_super *osb);
> +int ocfs2_try_to_free_truncate_log(struct ocfs2_super *osb,
> +				   unsigned int needed);
>  
>  /*
>   * Process local structure which describes the block unlinks done
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index c034edf..1802aef 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -1645,43 +1645,6 @@ static int ocfs2_zero_tail(struct inode *inode, struct buffer_head *di_bh,
>  	return ret;
>  }
>  
> -/*
> - * Try to flush truncate logs if we can free enough clusters from it.
> - * As for return value, "< 0" means error, "0" no space and "1" means
> - * we have freed enough spaces and let the caller try to allocate again.
> - */
> -static int ocfs2_try_to_free_truncate_log(struct ocfs2_super *osb,
> -					  unsigned int needed)
> -{
> -	tid_t target;
> -	int ret = 0;
> -	unsigned int truncated_clusters;
> -
> -	inode_lock(osb->osb_tl_inode);
> -	truncated_clusters = osb->truncated_clusters;
> -	inode_unlock(osb->osb_tl_inode);
> -
> -	/*
> -	 * Check whether we can succeed in allocating if we free
> -	 * the truncate log.
> -	 */
> -	if (truncated_clusters < needed)
> -		goto out;
> -
> -	ret = ocfs2_flush_truncate_log(osb);
> -	if (ret) {
> -		mlog_errno(ret);
> -		goto out;
> -	}
> -
> -	if (jbd2_journal_start_commit(osb->journal->j_journal, &target)) {
> -		jbd2_log_wait_commit(osb->journal->j_journal, target);
> -		ret = 1;
> -	}
> -out:
> -	return ret;
> -}
> -
>  int ocfs2_write_begin_nolock(struct address_space *mapping,
>  			     loff_t pos, unsigned len, ocfs2_write_type_t type,
>  			     struct page **pagep, void **fsdata,
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 2f19aee..ea47120 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -1164,7 +1164,8 @@ static int ocfs2_reserve_clusters_with_limit(struct ocfs2_super *osb,
>  					     int flags,
>  					     struct ocfs2_alloc_context **ac)
>  {
> -	int status;
> +	int status, ret = 0;
> +	int retried = 0;
>  
>  	*ac = kzalloc(sizeof(struct ocfs2_alloc_context), GFP_KERNEL);
>  	if (!(*ac)) {
> @@ -1189,7 +1190,24 @@ static int ocfs2_reserve_clusters_with_limit(struct ocfs2_super *osb,
>  	}
>  
>  	if (status == -ENOSPC) {
> +retry:
>  		status = ocfs2_reserve_cluster_bitmap_bits(osb, *ac);
> +		/* Retry if there is sufficient space cached in truncate log */
> +		if (status == -ENOSPC && !retried) {
> +			retried = 1;
> +			ocfs2_inode_unlock((*ac)->ac_inode, 1);
> +			inode_unlock((*ac)->ac_inode);
> +
> +			ret = ocfs2_try_to_free_truncate_log(osb, bits_wanted);
> +			if (ret == 1)
> +				goto retry;
> +
> +			if (ret < 0)
> +				mlog_errno(ret);
> +
> +			inode_lock((*ac)->ac_inode);
> +			ocfs2_inode_lock((*ac)->ac_inode, NULL, 1);
> +		}
>  		if (status < 0) {
>  			if (status != -ENOSPC)
>  				mlog_errno(status);
> 
