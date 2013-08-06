From: Younger Liu <younger.liu@huawei.com>
Date: Tue, 6 Aug 2013 16:39:21 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix a memory leak at
	__ocfs2_move_extents()
In-Reply-To: <5200968A.1050403@oracle.com>
References: <5200968A.1050403@oracle.com>
Message-ID: <5200B639.7000303@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2013/8/6 14:24, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> The ocfs2 path is not properly freed which leads to a
> memory leak at __ocfs2_move_extents().
> 
> This patch stops the leaks of the ocfs2_path structure.
> 
> Cc: Younger Liu <younger.liu@huawei.com>
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>

This patch looks fine to me.
Reviewed-by: Younger Liu <younger.liu@huawei.com>

> ---
>  fs/ocfs2/move_extents.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
> index f1fc172..37231d1 100644
> --- a/fs/ocfs2/move_extents.c
> +++ b/fs/ocfs2/move_extents.c
> @@ -152,6 +152,7 @@ static int __ocfs2_move_extent(handle_t *handle,
>  	}
>  
>  out:
> +	ocfs2_free_path(path);
>  	return ret;
>  }
>  
> 
