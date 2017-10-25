From: Gang He <ghe@suse.com>
Date: Tue, 24 Oct 2017 20:05:32 -0600
Subject: [Ocfs2-devel] [PATCH v3] ocfs2: the ip_alloc_sem should be
 taken in ocfs2_get_block()
In-Reply-To: <59EF3614.6050008@huawei.com>
References: <59EF3614.6050008@huawei.com>
Message-ID: <59F061EC020000F900094DCC@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com




>>> 
> The ip_alloc_sem should be taken in ocfs2_get_block() when reading file
> in DIRECT mode to prevent concurrent access to extent tree with
> ocfs2_dio_end_io_write(), which may cause BUGON in the following situation:
> 
> read file 'A'                                  end_io of writing file 'A'
> vfs_read
>  __vfs_read
>   ocfs2_file_read_iter
>    generic_file_read_iter
>     ocfs2_direct_IO
>      __blockdev_direct_IO
>       do_blockdev_direct_IO
>        do_direct_IO
>         get_more_blocks
>          ocfs2_get_block
>           ocfs2_extent_map_get_blocks
>            ocfs2_get_clusters
>             ocfs2_get_clusters_nocache()
>              ocfs2_search_extent_list
>               return the index of record which
>               contains the v_cluster, that is
>               v_cluster > rec[i]->e_cpos.
>                                                 ocfs2_dio_end_io
>                                                  ocfs2_dio_end_io_write
>                                                   
> down_write(&oi->ip_alloc_sem);
>                                                   ocfs2_mark_extent_written
>                                                    ocfs2_change_extent_flag
>                                                     ocfs2_split_extent
>                                                      ...
>                                                  --> modify the rec[i]->e_cpos, 
> resulting
>                                                      in v_cluster < 
> rec[i]->e_cpos.
>              BUG_ON(v_cluster < le32_to_cpu(rec->e_cpos))
> 
> Fixes: c15471f79506 ("ocfs2: fix sparse file & data ordering issue in direct 
> io")
> 
> Signed-off-by: Alex Chen <alex.chen@huawei.com>
> Reviewed-by: Jun Piao <piaojun@huawei.com>
> Acked-by: Changwei Ge <ge.changwei@h3c.com>
Reviewed-by: Gang He <ghe@suse.com>
> 
> ---
>  fs/ocfs2/aops.c | 26 ++++++++++++++++++--------
>  1 file changed, 18 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 88a31e9..d151632 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -134,6 +134,19 @@ static int ocfs2_symlink_get_block(struct inode *inode, 
> sector_t iblock,
>  	return err;
>  }
> 
> +static int ocfs2_lock_get_block(struct inode *inode, sector_t iblock,
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
> @@ -2128,7 +2141,7 @@ static void ocfs2_dio_free_write_ctx(struct inode 
> *inode,
>   * called like this: dio->get_blocks(dio->inode, fs_startblk,
>   * 					fs_count, map_bh, dio->rw == WRITE);
>   */
> -static int ocfs2_dio_get_block(struct inode *inode, sector_t iblock,
> +static int ocfs2_dio_wr_get_block(struct inode *inode, sector_t iblock,
>  			       struct buffer_head *bh_result, int create)
>  {
>  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
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
> +		ret = ocfs2_lock_get_block(inode, iblock, bh_result, create);
>  		if (buffer_mapped(bh_result) &&
>  		    !buffer_new(bh_result) &&
>  		    ret == 0)
> @@ -2424,9 +2434,9 @@ static ssize_t ocfs2_direct_IO(struct kiocb *iocb, 
> struct iov_iter *iter)
>  		return 0;
> 
>  	if (iov_iter_rw(iter) == READ)
> -		get_block = ocfs2_get_block;
> +		get_block = ocfs2_lock_get_block;
>  	else
> -		get_block = ocfs2_dio_get_block;
> +		get_block = ocfs2_dio_wr_get_block;
> 
>  	return __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev,
>  				    iter, get_block,
> -- 
> 1.9.5.msysgit.1
