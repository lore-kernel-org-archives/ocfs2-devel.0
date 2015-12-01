From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Tue, 1 Dec 2015 14:44:54 +0800
Subject: [Ocfs2-devel] [PATCH 3/4] ocfs2: fix disk file size and memory
 file size mismatch
In-Reply-To: <1448007799-10914-3-git-send-email-ryan.ding@oracle.com>
References: <1448007799-10914-1-git-send-email-ryan.ding@oracle.com>
	<1448007799-10914-3-git-send-email-ryan.ding@oracle.com>
Message-ID: <565D41E6.9040706@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 11/20/2015 04:23 PM, Ryan Ding wrote:
> When doing append direct write in an already allocated cluster, and fast path
> in ocfs2_dio_get_block() is triggered, function ocfs2_dio_end_io_write() will
> be skipped as there is no context allocated. So disk file size will not be
> changed as it should be.
> The solution is to skip fast path when we are about to change file size.
> 
> Fixes: af1310367f41 ("ocfs2: fix sparse file & data ordering issue in direct io.")
Patch looks good. But this tag is useless for a commit not merged into
mainline. Maybe we can fold this patch into above commit.

Thanks,
Junxiao.

> Signed-off-by: Ryan Ding <ryan.ding@oracle.com>
> ---
>  fs/ocfs2/aops.c |   27 +++++++++++++++++----------
>  1 files changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index d571509..f33cfe4 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -2167,19 +2167,26 @@ static int ocfs2_dio_get_block(struct inode *inode, sector_t iblock,
>  	mlog(0, "get block of %lu at %llu:%u req %u\n",
>  			inode->i_ino, pos, len, total_len);
>  
> -	down_read(&oi->ip_alloc_sem);
> -	/* This is the fast path for re-write. */
> -	ret = ocfs2_get_block(inode, iblock, bh_result, create);
> +	/*
> +	 * Because we need to change file size in ocfs2_dio_end_io_write(), or
> +	 * we may need to add it to orphan dir. So can not fall to fast path
> +	 * while file size will be changed.
> +	 */
> +	if (pos + total_len <= i_size_read(inode)) {
> +		down_read(&oi->ip_alloc_sem);
> +		/* This is the fast path for re-write. */
> +		ret = ocfs2_get_block(inode, iblock, bh_result, create);
>  
> -	up_read(&oi->ip_alloc_sem);
> +		up_read(&oi->ip_alloc_sem);
>  
> -	if (buffer_mapped(bh_result) &&
> -	    !buffer_new(bh_result) &&
> -	    ret == 0)
> -		goto out;
> +		if (buffer_mapped(bh_result) &&
> +		    !buffer_new(bh_result) &&
> +		    ret == 0)
> +			goto out;
>  
> -	/* Clear state set by ocfs2_get_block. */
> -	bh_result->b_state = 0;
> +		/* Clear state set by ocfs2_get_block. */
> +		bh_result->b_state = 0;
> +	}
>  
>  	dwc = ocfs2_dio_alloc_write_ctx(bh_result, &first_get_block);
>  	if (unlikely(dwc == NULL)) {
> 
