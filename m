From: WeiWei Wang <wangww631@huawei.com>
Date: Thu, 28 May 2015 11:41:29 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix wrong check in
	ocfs2_direct_IO_get_blocks
In-Reply-To: <55601A42.8080803@huawei.com>
References: <55601A42.8080803@huawei.com>
Message-ID: <55668E69.8050004@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2015/5/23 14:12, Joseph Qi wrote:
> contig_blocks gotten from ocfs2_extent_map_get_blocks cannot be compared
> with clusters_to_alloc. So convert it to clusters first.
> 
> Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
> Cc: Weiwei Wang <wangww631@huawei.com>

Reviewed-by: Weiwei Wang <wangww631@huawei.com>
> ---
>  fs/ocfs2/aops.c  |  8 +++++---
>  fs/ocfs2/ocfs2.h | 10 ++++++++++
>  2 files changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index d3eccc0..d922365 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -523,7 +523,7 @@ static int ocfs2_direct_IO_get_blocks(struct inode *inode, sector_t iblock,
>  	unsigned char blocksize_bits = inode->i_sb->s_blocksize_bits;
>  	unsigned long max_blocks = bh_result->b_size >> inode->i_blkbits;
>  	unsigned long len = bh_result->b_size;
> -	unsigned int clusters_to_alloc = 0;
> +	unsigned int clusters_to_alloc = 0, contig_clusters = 0;
> 
>  	cpos = ocfs2_blocks_to_clusters(inode->i_sb, iblock);
> 
> @@ -560,8 +560,10 @@ static int ocfs2_direct_IO_get_blocks(struct inode *inode, sector_t iblock,
>  		/* fill hole, allocate blocks can't be larger than the size
>  		 * of the hole */
>  		clusters_to_alloc = ocfs2_clusters_for_bytes(inode->i_sb, len);
> -		if (clusters_to_alloc > contig_blocks)
> -			clusters_to_alloc = contig_blocks;
> +		contig_clusters = ocfs2_clusters_for_blocks(inode->i_sb,
> +				contig_blocks);
> +		if (clusters_to_alloc > contig_clusters)
> +			clusters_to_alloc = contig_clusters;
> 
>  		/* allocate extent and insert them into the extent tree */
>  		ret = ocfs2_extend_allocation(inode, cpos,
> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index 460c6c3..690ddc6 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -717,6 +717,16 @@ static inline u64 ocfs2_clusters_to_blocks(struct super_block *sb,
>  	return (u64)clusters << c_to_b_bits;
>  }
> 
> +static inline u32 ocfs2_clusters_for_blocks(struct super_block *sb,
> +		u64 blocks)
> +{
> +	int b_to_c_bits = OCFS2_SB(sb)->s_clustersize_bits -
> +			sb->s_blocksize_bits;
> +
> +	blocks += (1 << b_to_c_bits) - 1;
> +	return (u32)(blocks >> b_to_c_bits);
> +}
> +
>  static inline u32 ocfs2_blocks_to_clusters(struct super_block *sb,
>  					   u64 blocks)
>  {
> 
