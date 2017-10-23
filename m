From: Eric Ren <zren@suse.com>
Date: Mon, 23 Oct 2017 12:06:39 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: the ip_alloc_sem should be taken
 in ocfs2_get_block()
In-Reply-To: <59E9BBEF.1060601@huawei.com>
References: <59E9BBEF.1060601@huawei.com>
Message-ID: <e2e2922f-004c-b779-b7ed-0062837dbdd6@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

On 10/20/2017 05:03 PM, alex chen wrote:
> The ip_alloc_sem should be taken in ocfs2_get_block() when reading file
> in DIRECT mode to prevent concurrent access to extent tree with
> ocfs2_dio_end_io_write(), which may cause BUGON in
> ocfs2_get_clusters_nocache()->BUG_ON(v_cluster < le32_to_cpu(rec->e_cpos))

This maybe seem a obvious fix, but it would be great if you can
write a more detailed commit log, like paste the crash backtrace
here so that people can pick this fix easily when they see the same issue.

Thanks,
Eric
>
> Signed-off-by: Alex Chen <alex.chen@huawei.com>
> Reviewed-by: Jun Piao <piaojun@huawei.com>
>
> ---
>   fs/ocfs2/aops.c | 21 +++++++++++++++------
>   1 file changed, 15 insertions(+), 6 deletions(-)
>
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 88a31e9..5cb939f 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -134,6 +134,19 @@ static int ocfs2_symlink_get_block(struct inode *inode, sector_t iblock,
>   	return err;
>   }
>
> +static int ocfs2_get_block_lock(struct inode *inode, sector_t iblock,
> +		    struct buffer_head *bh_result, int create)
> +{
> +	int ret;
> +	struct ocfs2_inode_info *oi = OCFS2_I(inode);
> +
> +	down_read(&oi->ip_alloc_sem);
> +	ret = ocfs2_get_block(inode, iblock, bh_result, create);
> +	up_read(&oi->ip_alloc_sem);
> +
> +	return ret;
> +}
> +
>   int ocfs2_get_block(struct inode *inode, sector_t iblock,
>   		    struct buffer_head *bh_result, int create)
>   {
> @@ -2154,12 +2167,8 @@ static int ocfs2_dio_get_block(struct inode *inode, sector_t iblock,
>   	 * while file size will be changed.
>   	 */
>   	if (pos + total_len <= i_size_read(inode)) {
> -		down_read(&oi->ip_alloc_sem);
>   		/* This is the fast path for re-write. */
> -		ret = ocfs2_get_block(inode, iblock, bh_result, create);
> -
> -		up_read(&oi->ip_alloc_sem);
> -
> +		ret = ocfs2_get_block_lock(inode, iblock, bh_result, create);
>   		if (buffer_mapped(bh_result) &&
>   		    !buffer_new(bh_result) &&
>   		    ret == 0)
> @@ -2424,7 +2433,7 @@ static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>   		return 0;
>
>   	if (iov_iter_rw(iter) == READ)
> -		get_block = ocfs2_get_block;
> +		get_block = ocfs2_get_block_lock;
>   	else
>   		get_block = ocfs2_dio_get_block;
>
> -- 1.9.5.msysgit.1
>
>
>
