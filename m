From: Joseph Qi <jiangqi903@gmail.com>
Date: Wed, 13 Dec 2017 13:38:23 +0800
Subject: [Ocfs2-devel] [PATCH v3] ocfs2: clean dead code in suballoc.c
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E373F1F5A8DD@H3CMLB14-EX.srv.huawei-3com.com>
References: <63ADC13FD55D6546B7DECE290D39E373F1F5A8DD@H3CMLB14-EX.srv.huawei-3com.com>
Message-ID: <888d858d-980b-e982-fcc3-ea26b18ddab6@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 17/12/13 12:54, Changwei Ge wrote:
> Stack variable fe is no longer used, so trim it to save some CPU cycles
> and stack space.
> 
> Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
Reviewed-by: Joseph Qi <jiangqi903@gmail.com>

> ---
>   fs/ocfs2/suballoc.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 71f22c8fbffd..508422b0032f 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -2566,16 +2566,16 @@ static int _ocfs2_free_clusters(handle_t *handle,
>   	int status;
>   	u16 bg_start_bit;
>   	u64 bg_blkno;
> -	struct ocfs2_dinode *fe;
>   
>   	/* You can't ever have a contiguous set of clusters
>   	 * bigger than a block group bitmap so we never have to worry
>   	 * about looping on them.
>   	 * This is expensive. We can safely remove once this stuff has
>   	 * gotten tested really well. */
> -	BUG_ON(start_blk != ocfs2_clusters_to_blocks(bitmap_inode->i_sb, ocfs2_blocks_to_clusters(bitmap_inode->i_sb, start_blk)));
> +	BUG_ON(start_blk != ocfs2_clusters_to_blocks(bitmap_inode->i_sb,
> +				ocfs2_blocks_to_clusters(bitmap_inode->i_sb,
> +							 start_blk)));
>   
> -	fe = (struct ocfs2_dinode *) bitmap_bh->b_data;
>   
>   	ocfs2_block_to_cluster_group(bitmap_inode, start_blk, &bg_blkno,
>   				     &bg_start_bit);
> 
