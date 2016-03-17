From: Joseph Qi <joseph.qi@huawei.com>
Date: Thu, 17 Mar 2016 17:23:21 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: clean up an unused variable
 'wants_rotate' in ocfs2_truncate_rec
In-Reply-To: <56EA74BF.7090201@huawei.com>
References: <56EA74BF.7090201@huawei.com>
Message-ID: <56EA7789.3070700@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2016/3/17 17:11, piaojun wrote:
> Clean up an unused variable 'wants_rotate' in ocfs2_truncate_rec.
> 
> Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>

> ---
>  alloc.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/alloc.c b/alloc.c
> index d002579..2b8b721 100644
> --- a/alloc.c
> +++ b/alloc.c
> @@ -5334,7 +5334,7 @@ static int ocfs2_truncate_rec(handle_t *handle,
>  {
>  	int ret;
>  	u32 left_cpos, rec_range, trunc_range;
> -	int wants_rotate = 0, is_rightmost_tree_rec = 0;
> +	int is_rightmost_tree_rec = 0;
>  	struct super_block *sb = ocfs2_metadata_cache_get_super(et->et_ci);
>  	struct ocfs2_path *left_path = NULL;
>  	struct ocfs2_extent_list *el = path_leaf_el(path);
> @@ -5431,7 +5431,6 @@ static int ocfs2_truncate_rec(handle_t *handle,
> 
>  		memset(rec, 0, sizeof(*rec));
>  		ocfs2_cleanup_merge(el, index);
> -		wants_rotate = 1;
> 
>  		next_free = le16_to_cpu(el->l_next_free_rec);
>  		if (is_rightmost_tree_rec && next_free > 1) {
> 
