From: Gang He <ghe@suse.com>
Date: Mon, 23 Oct 2017 01:16:29 -0600
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: the ip_alloc_sem should be
 taken in ocfs2_get_block()
In-Reply-To: <59ED80E6.4030600@huawei.com>
References: <59E9BBEF.1060601@huawei.com> <59ED80E6.4030600@huawei.com>
Message-ID: <59EE07CD020000F9000945D8@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello Alex,

Base on your bug description, I think that the fix should be OK.
But I suggest you to use more clear function name in this patch.
1) For new-added function ocfs2_get_block_lock(), I think that it is better if the function name is ocfs2_dio_rd_get_block().
2) Then, rename the original function ocfs2_dio_get_block() to ocfs2_dio_wr_get_block().
Why? 
Since this function looks to only be used by direct IO (read) mode, 
we should make the function name more clear, do NOT make other developer to misunderstand/misuse it in the future.

Thanks
Gang 


>>> 
> The ip_alloc_sem should be taken in ocfs2_get_block() when reading file
> in DIRECT mode to prevent concurrent access to extent tree with
> ocfs2_dio_end_io_write(), which may cause BUGON in
> ocfs2_get_clusters_nocache()->BUG_ON(v_cluster < le32_to_cpu(rec->e_cpos))
> 
> Fixes: c15471f79506 ("ocfs2: fix sparse file & data ordering issue in direct 
> io")
> 
> Signed-off-by: Alex Chen <alex.chen@huawei.com>
> Reviewed-by: Jun Piao <piaojun@huawei.com>
> Acked-by: Changwei Ge <ge.changwei@h3c.com>
> 
> ---
>  fs/ocfs2/aops.c | 22 ++++++++++++++++------
>  1 file changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 88a31e9..29607d9 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -134,6 +134,19 @@ static int ocfs2_symlink_get_block(struct inode *inode, 
> sector_t iblock,
>  	return err;
>  }
> 
> +static int ocfs2_get_block_lock(struct inode *inode, sector_t iblock,
> +		    struct buffer_head *bh_result, int create)
> +{
> +	int ret = 0;
> +	struct ocfs2_inode_info *oi = OCFS2_I(inode);
> +
> +	down_read(&oi->ip_alloc_sem);
> +	ret = ocfs2_get_block(inode, iblock, bh_result, create);
> +	up_read(&oi->ip_alloc_sem);
> +
> +	return ret;
> +}
> +
>  int ocfs2_get_block(struct inode *inode, sector_t iblock,
>  		    struct buffer_head *bh_result, int create)
>  {
> @@ -2154,12 +2167,9 @@ static int ocfs2_dio_get_block(struct inode *inode, 
> sector_t iblock,
>  	 * while file size will be changed.
>  	 */
>  	if (pos + total_len <= i_size_read(inode)) {
> -		down_read(&oi->ip_alloc_sem);
> -		/* This is the fast path for re-write. */
> -		ret = ocfs2_get_block(inode, iblock, bh_result, create);
> -
> -		up_read(&oi->ip_alloc_sem);
> 
> +		/* This is the fast path for re-write. */
> +		ret = ocfs2_get_block_lock(inode, iblock, bh_result, create);
>  		if (buffer_mapped(bh_result) &&
>  		    !buffer_new(bh_result) &&
>  		    ret == 0)
> @@ -2424,7 +2434,7 @@ static ssize_t ocfs2_direct_IO(struct kiocb *iocb, 
> struct iov_iter *iter)
>  		return 0;
> 
>  	if (iov_iter_rw(iter) == READ)
> -		get_block = ocfs2_get_block;
> +		get_block = ocfs2_get_block_lock;
>  	else
>  		get_block = ocfs2_dio_get_block;
> 
> -- 
> 1.9.5.msysgit.1
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com 
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
