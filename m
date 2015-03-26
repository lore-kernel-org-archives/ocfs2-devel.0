From: Joseph Qi <joseph.qi@huawei.com>
Date: Thu, 26 Mar 2015 17:25:42 +0800
Subject: [Ocfs2-devel] [PATCH 4/4] ocfs2: do not use ocfs2_zero_extend
 during direct IO
In-Reply-To: <54ED9749.4030909@huawei.com>
References: <54ED9749.4030909@huawei.com>
Message-ID: <5513D096.4070201@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,
Could you please help review these 4 patches?

On 2015/2/25 17:35, Joseph Qi wrote:
> In ocfs2_direct_IO_write, we use ocfs2_zero_extend to zero allocated
> clusters in case of cluster not aligned. But ocfs2_zero_extend uses page
> cache, this may happen that it clears the data which blockdev_direct_IO
> has already witten.
> We should use blkdev_issue_zeroout instead of ocfs2_zero_extend
> during direct IO.
> So fix this issue by introducing ocfs2_direct_IO_zero_extend and
> ocfs2_direct_IO_extend_no_holes.
> 
> Reported-by: Yiwen Jiang <jiangyiwen@huawei.com>
> Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
> Tested-by: Yiwen Jiang <jiangyiwen@huawei.com>
> ---
>  fs/ocfs2/aops.c | 138 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 130 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 973a636..1b0463a 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -663,6 +663,117 @@ static int ocfs2_is_overwrite(struct ocfs2_super *osb,
>  	return 0;
>  }
> 
> +static int ocfs2_direct_IO_zero_extend(struct ocfs2_super *osb,
> +		struct inode *inode, loff_t offset,
> +		u64 zero_len, int cluster_align)
> +{
> +	u32 p_cpos = 0;
> +	u32 v_cpos = ocfs2_bytes_to_clusters(osb->sb, i_size_read(inode));
> +	unsigned int num_clusters = 0;
> +	unsigned int ext_flags = 0;
> +	int ret = 0;
> +
> +	if (offset <= i_size_read(inode) || cluster_align)
> +		return 0;
> +
> +	ret = ocfs2_get_clusters(inode, v_cpos, &p_cpos, &num_clusters,
> +			&ext_flags);
> +	if (ret < 0) {
> +		mlog_errno(ret);
> +		return ret;
> +	}
> +
> +	if (p_cpos && !(ext_flags & OCFS2_EXT_UNWRITTEN)) {
> +		u64 s = i_size_read(inode);
> +		sector_t sector = (p_cpos << (osb->s_clustersize_bits - 9)) +
> +			(do_div(s, osb->s_clustersize) >> 9);
> +
> +		ret = blkdev_issue_zeroout(osb->sb->s_bdev, sector,
> +				zero_len >> 9, GFP_NOFS, false);
> +		if (ret < 0)
> +			mlog_errno(ret);
> +	}
> +
> +	return ret;
> +}
> +
> +static int ocfs2_direct_IO_extend_no_holes(struct ocfs2_super *osb,
> +		struct inode *inode, loff_t offset)
> +{
> +	u64 zero_start, zero_len, total_zero_len;
> +	u32 p_cpos = 0, clusters_to_add;
> +	u32 v_cpos = ocfs2_bytes_to_clusters(osb->sb, i_size_read(inode));
> +	unsigned int num_clusters = 0;
> +	unsigned int ext_flags = 0;
> +	u32 size_div, offset_div;
> +	int ret = 0;
> +
> +	{
> +		u64 o = offset;
> +		u64 s = i_size_read(inode);
> +
> +		offset_div = do_div(o, osb->s_clustersize);
> +		size_div = do_div(s, osb->s_clustersize);
> +	}
> +
> +	if (offset <= i_size_read(inode))
> +		return 0;
> +
> +	clusters_to_add = ocfs2_bytes_to_clusters(inode->i_sb, offset) -
> +		ocfs2_bytes_to_clusters(inode->i_sb, i_size_read(inode));
> +	total_zero_len = offset - i_size_read(inode);
> +	if (clusters_to_add)
> +		total_zero_len -= offset_div;
> +
> +	/* Allocate clusters to fill out holes, and this is only needed
> +	 * when we add more than one clusters. Otherwise the cluster will
> +	 * be allocated during direct IO */
> +	if (clusters_to_add > 1) {
> +		ret = ocfs2_extend_allocation(inode,
> +				OCFS2_I(inode)->ip_clusters,
> +				clusters_to_add - 1, 0);
> +		if (ret) {
> +			mlog_errno(ret);
> +			goto out;
> +		}
> +	}
> +
> +	while (total_zero_len) {
> +		ret = ocfs2_get_clusters(inode, v_cpos, &p_cpos, &num_clusters,
> +				&ext_flags);
> +		if (ret < 0) {
> +			mlog_errno(ret);
> +			goto out;
> +		}
> +
> +		zero_start = ocfs2_clusters_to_bytes(osb->sb, p_cpos) +
> +			size_div;
> +		zero_len = ocfs2_clusters_to_bytes(osb->sb, num_clusters) -
> +			size_div;
> +		zero_len = min(total_zero_len, zero_len);
> +
> +		if (p_cpos && !(ext_flags & OCFS2_EXT_UNWRITTEN)) {
> +			ret = blkdev_issue_zeroout(osb->sb->s_bdev,
> +					zero_start >> 9, zero_len >> 9,
> +					GFP_NOFS, false);
> +			if (ret < 0) {
> +				mlog_errno(ret);
> +				goto out;
> +			}
> +		}
> +
> +		total_zero_len -= zero_len;
> +		v_cpos += ocfs2_bytes_to_clusters(osb->sb, zero_len + size_div);
> +
> +		/* Only at first iteration can be cluster not aligned.
> +		 * So set size_div to 0 for the rest */
> +		size_div = 0;
> +	}
> +
> +out:
> +	return ret;
> +}
> +
>  static ssize_t ocfs2_direct_IO_write(struct kiocb *iocb,
>  		struct iov_iter *iter,
>  		loff_t offset)
> @@ -677,8 +788,8 @@ static ssize_t ocfs2_direct_IO_write(struct kiocb *iocb,
>  	struct buffer_head *di_bh = NULL;
>  	size_t count = iter->count;
>  	journal_t *journal = osb->journal->j_journal;
> -	u32 zero_len;
> -	int cluster_align;
> +	u64 zero_len_head, zero_len_tail;
> +	int cluster_align_head, cluster_align_tail;
>  	loff_t final_size = offset + count;
>  	int append_write = offset >= i_size_read(inode) ? 1 : 0;
>  	unsigned int num_clusters = 0;
> @@ -686,9 +797,16 @@ static ssize_t ocfs2_direct_IO_write(struct kiocb *iocb,
> 
>  	{
>  		u64 o = offset;
> +		u64 s = i_size_read(inode);
> +
> +		zero_len_head = do_div(o, 1 << osb->s_clustersize_bits);
> +		cluster_align_head = !zero_len_head;
> 
> -		zero_len = do_div(o, 1 << osb->s_clustersize_bits);
> -		cluster_align = !zero_len;
> +		zero_len_tail = osb->s_clustersize -
> +			do_div(s, osb->s_clustersize);
> +		if ((offset - i_size_read(inode)) < zero_len_tail)
> +			zero_len_tail = offset - i_size_read(inode);
> +		cluster_align_tail = !zero_len_tail;
>  	}
> 
>  	/*
> @@ -712,10 +830,13 @@ static ssize_t ocfs2_direct_IO_write(struct kiocb *iocb,
>  			goto clean_orphan;
>  		}
> 
> +		/* zeroing out the previously allocated cluster tail
> +		 * that but not zeroed */
>  		if (ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)))
> -			ret = ocfs2_zero_extend(inode, di_bh, offset);
> +			ret = ocfs2_direct_IO_zero_extend(osb, inode, offset,
> +					zero_len_tail, cluster_align_tail);
>  		else
> -			ret = ocfs2_extend_no_holes(inode, di_bh, offset,
> +			ret = ocfs2_direct_IO_extend_no_holes(osb, inode,
>  					offset);
>  		if (ret < 0) {
>  			mlog_errno(ret);
> @@ -768,7 +889,8 @@ static ssize_t ocfs2_direct_IO_write(struct kiocb *iocb,
>  				mlog_errno(ret);
>  		}
>  	} else if (written > 0 && append_write && !is_overwrite &&
> -			!cluster_align) {
> +			!cluster_align_head) {
> +		/* zeroing out the allocated cluster head */
>  		u32 p_cpos = 0;
>  		u32 v_cpos = ocfs2_bytes_to_clusters(osb->sb, offset);
> 
> @@ -790,7 +912,7 @@ static ssize_t ocfs2_direct_IO_write(struct kiocb *iocb,
> 
>  		ret = blkdev_issue_zeroout(osb->sb->s_bdev,
>  				p_cpos << (osb->s_clustersize_bits - 9),
> -				zero_len >> 9, GFP_NOFS, false);
> +				zero_len_head >> 9, GFP_NOFS, false);
>  		if (ret < 0)
>  			mlog_errno(ret);
> 
