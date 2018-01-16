From: piaojun <piaojun@huawei.com>
Date: Tue, 16 Jan 2018 20:40:41 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: clean dead code up in alloc.c
In-Reply-To: <1516105069-12643-1-git-send-email-ge.changwei@h3c.com>
References: <1516105069-12643-1-git-send-email-ge.changwei@h3c.com>
Message-ID: <5A5DF2C9.6050509@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Changwei,

LGTM

On 2018/1/16 20:17, Changwei Ge wrote:
> Some stack variables are no longer used but still assigned.
> Trim them.
> 
> Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
Reviewed-by: Jun Piao <piaojun@huawei.com>
> ---
>  fs/ocfs2/alloc.c | 11 ++---------
>  1 file changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index addd7c5..edef99c 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -2598,11 +2598,8 @@ static void ocfs2_unlink_subtree(handle_t *handle,
>  	int i;
>  	struct buffer_head *root_bh = left_path->p_node[subtree_index].bh;
>  	struct ocfs2_extent_list *root_el = left_path->p_node[subtree_index].el;
> -	struct ocfs2_extent_list *el;
>  	struct ocfs2_extent_block *eb;
>  
> -	el = path_leaf_el(left_path);
> -
>  	eb = (struct ocfs2_extent_block *)right_path->p_node[subtree_index + 1].bh->b_data;
>  
>  	for(i = 1; i < le16_to_cpu(root_el->l_next_free_rec); i++)
> @@ -3940,7 +3937,7 @@ static void ocfs2_adjust_rightmost_records(handle_t *handle,
>  					   struct ocfs2_path *path,
>  					   struct ocfs2_extent_rec *insert_rec)
>  {
> -	int ret, i, next_free;
> +	int i, next_free;
>  	struct buffer_head *bh;
>  	struct ocfs2_extent_list *el;
>  	struct ocfs2_extent_rec *rec;
> @@ -3957,7 +3954,6 @@ static void ocfs2_adjust_rightmost_records(handle_t *handle,
>  			ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
>  				    "Owner %llu has a bad extent list\n",
>  				    (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci));
> -			ret = -EIO;
>  			return;
>  		}
>  
> @@ -5059,7 +5055,6 @@ int ocfs2_split_extent(handle_t *handle,
>  	struct buffer_head *last_eb_bh = NULL;
>  	struct ocfs2_extent_rec *rec = &el->l_recs[split_index];
>  	struct ocfs2_merge_ctxt ctxt;
> -	struct ocfs2_extent_list *rightmost_el;
>  
>  	if (le32_to_cpu(rec->e_cpos) > le32_to_cpu(split_rec->e_cpos) ||
>  	    ((le32_to_cpu(rec->e_cpos) + le16_to_cpu(rec->e_leaf_clusters)) <
> @@ -5095,9 +5090,7 @@ int ocfs2_split_extent(handle_t *handle,
>  		}
>  
>  		eb = (struct ocfs2_extent_block *) last_eb_bh->b_data;
> -		rightmost_el = &eb->h_list;
> -	} else
> -		rightmost_el = path_root_el(path);
> +	}
>  
>  	if (rec->e_cpos == split_rec->e_cpos &&
>  	    rec->e_leaf_clusters == split_rec->e_leaf_clusters)
> 
