From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 28 Apr 2015 13:45:31 -0700
Subject: [Ocfs2-devel] [PATCH V3] ocfs2: return error while
 ocfs2_figure_merge_contig_type failing
In-Reply-To: <553B5BE3.8080307@huawei.com>
References: <553B5BE3.8080307@huawei.com>
Message-ID: <20150428134531.6fbd57fcd9231ec26e119859@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, 25 Apr 2015 17:18:27 +0800 Xue jiufei <xuejiufei@huawei.com> wrote:

> Now function ocfs2_figure_merge_contig_type() still return CONTIG_NONE
> when some error occurs which will cause unpredictable error.
> So return error while ocfs2_figure_merge_contig_type failing.
> 
> @@ -4336,8 +4336,11 @@ ocfs2_figure_merge_contig_type(struct ocfs2_extent_tree *et,
>  
>  		if (left_cpos != 0) {
>  			left_path = ocfs2_new_path_from_path(path);
> -			if (!left_path)
> +			if (!left_path) {
> +				status = -ENOMEM;
> +				mlog_errno(status);
>  				goto exit;
> +			}
>  
>  			status = ocfs2_find_path(et->et_ci, left_path,
>
>
> ...
>  						 left_cpos);
> @@ -4392,8 +4395,11 @@ ocfs2_figure_merge_contig_type(struct ocfs2_extent_tree *et,
>  			goto free_left_path;
>  
>  		right_path = ocfs2_new_path_from_path(path);
> -		if (!right_path)
> +		if (!right_path) {
> +			status = -ENOMEM;
> +			mlog_errno(status);
>  			goto free_left_path;
> +		}
>  
>  		status = ocfs2_find_path(et->et_ci, right_path, right_cpos);
>  		if (status)
> ...
>
> +	ret = ocfs2_figure_merge_contig_type(et, path, el,
> +					     split_index,
> +					     split_rec,
> +					     &ctxt);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out;
> +	}

This guarantees that mlog_errno() will be called twice for a single error.

But I suppose that ocfs2 does this a lot.  I guess the place to fix it
is in mlog_errno(): teach it to filter out duplicates somehow.
