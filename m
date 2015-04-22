From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Wed, 22 Apr 2015 13:19:23 +0800
Subject: [Ocfs2-devel] [PATCH V2] ocfs2: return error while
 ocfs2_figure_merge_contig_type failing
In-Reply-To: <5536ECFA.5080400@huawei.com>
References: <5536ECFA.5080400@huawei.com>
Message-ID: <55372F5B.7080204@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 04/22/2015 08:36 AM, Xue jiufei wrote:
> Now function ocfs2_figure_merge_contig_type() still return CONTIG_NONE
> when some error occurs which will cause unpredictable error.
> So return error while ocfs2_figure_merge_contig_type failing.
> 
> Signed-off-by: joyce.xue <xuejiufei@huawei.com>
Looks fine.

Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
> ---
>  fs/ocfs2/alloc.c | 22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 044158b..2d07b38 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -4313,11 +4313,11 @@ out:
>  	return ret;
>  }
>  
> -static enum ocfs2_contig_type
> -ocfs2_figure_merge_contig_type(struct ocfs2_extent_tree *et,
> +static int ocfs2_figure_merge_contig_type(struct ocfs2_extent_tree *et,
>  			       struct ocfs2_path *path,
>  			       struct ocfs2_extent_list *el, int index,
> -			       struct ocfs2_extent_rec *split_rec)
> +			       struct ocfs2_extent_rec *split_rec,
> +			       struct ocfs2_merge_ctxt *ctxt)
>  {
>  	int status;
>  	enum ocfs2_contig_type ret = CONTIG_NONE;
> @@ -4431,12 +4431,15 @@ ocfs2_figure_merge_contig_type(struct ocfs2_extent_tree *et,
>  	}
>  
>  out:
> +	if (status == 0)
> +		ctxt->c_contig_type = ret;
> +
>  	if (left_path)
>  		ocfs2_free_path(left_path);
>  	if (right_path)
>  		ocfs2_free_path(right_path);
>  
> -	return ret;
> +	return status;
>  }
>  
>  static void ocfs2_figure_contig_type(struct ocfs2_extent_tree *et,
> @@ -5042,9 +5045,14 @@ int ocfs2_split_extent(handle_t *handle,
>  		goto out;
>  	}
>  
> -	ctxt.c_contig_type = ocfs2_figure_merge_contig_type(et, path, el,
> -							    split_index,
> -							    split_rec);
> +	ret =  ocfs2_figure_merge_contig_type(et, path, el,
> +					      split_index,
> +					      split_rec,
> +					      &ctxt);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out;
> +	}
>  
>  	/*
>  	 * The core merge / split code wants to know how much room is
> 
