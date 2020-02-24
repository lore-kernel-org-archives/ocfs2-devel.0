From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Mon, 24 Feb 2020 11:00:12 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: there is no need to log twice
 in several functions
In-Reply-To: <77eec86a-f634-5b98-4f7d-0cd15185a37b@huawei.com>
References: <77eec86a-f634-5b98-4f7d-0cd15185a37b@huawei.com>
Message-ID: <562704fd-9af9-e4f4-7891-7ac25bb1f6fa@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 2020/2/22 09:52, wangyan wrote:
> There is no need to log twice in several functions.
> 
> Signed-off-by: Yan Wang <wangyan122@huawei.com>
> Reviewed-by: Jun Piao <piaojun@huawei.com>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/alloc.c    | 1 -
>  fs/ocfs2/suballoc.c | 5 -----
>  2 files changed, 6 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 88534eb0e7c2..1e3b06fa4785 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -1060,7 +1060,6 @@ static int ocfs2_create_new_meta_bhs(handle_t *handle,
>  			brelse(bhs[i]);
>  			bhs[i] = NULL;
>  		}
> -		mlog_errno(status);
>  	}
>  	return status;
>  }
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 939df99d2dec..4836becb7578 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -2509,9 +2509,6 @@ static int _ocfs2_free_suballoc_bits(handle_t *handle,
> 
>  bail:
>  	brelse(group_bh);
> -
> -	if (status)
> -		mlog_errno(status);
>  	return status;
>  }
> 
> @@ -2582,8 +2579,6 @@ static int _ocfs2_free_clusters(handle_t *handle,
>  					 num_clusters);
> 
>  out:
> -	if (status)
> -		mlog_errno(status);
>  	return status;
>  }
> 
