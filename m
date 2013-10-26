From: Jeff Liu <jeff.liu@oracle.com>
Date: Sat, 26 Oct 2013 17:58:07 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix possible double free in
	ocfs2_write_begin_nolock
In-Reply-To: <526B86E0.9080009@huawei.com>
References: <526B86E0.9080009@huawei.com>
Message-ID: <526B922F.2020700@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10/26/2013 05:09 PM, Xue jiufei wrote:

> When ocfs2_write_cluster_by_desc() failed in ocfs2_write_begin_nolock()
> because of ENOSPC, it goes to out_quota, freeing data_ac(meta_ac). Then
> it calls ocfs2_try_to_free_truncate_log() to free space. If enough
> space freed, it will try to write again. Unfortunately, some error
> happenes before ocfs2_lock_allocators(), it goes to out and free 
> data_ac(meta_ac) again.

Looks good to me, thanks.

Reviewed-by: Jie Liu <jeff.liu@oracle.com>

> 
> Signed-off-by: joyce <xuejiufei@huawei.com>
> ---
>  fs/ocfs2/aops.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index f37d3c0..8ad0a41 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -1897,10 +1897,14 @@ out_commit:
>  out:
>  	ocfs2_free_write_ctxt(wc);
>  
> -	if (data_ac)
> +	if (data_ac) {
>  		ocfs2_free_alloc_context(data_ac);
> -	if (meta_ac)
> +		data_ac = NULL;
> +	}
> +	if (meta_ac) {
>  		ocfs2_free_alloc_context(meta_ac);
> +		meta_ac = NULL;
> +	}
>  
>  	if (ret == -ENOSPC && try_free) {
>  		/*
