From: Jeff Liu <jeff.liu@oracle.com>
Date: Wed, 18 Sep 2013 18:20:38 +0800
Subject: [Ocfs2-devel] [PATCH V2] ocfs2: Add missing errno in
	ocfs2_ioctl_move_extents()
In-Reply-To: <52397BA0.6040004@huawei.com>
References: <52397BA0.6040004@huawei.com>
Message-ID: <52397E76.30508@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 09/18/2013 06:08 PM, Younger Liu wrote:

> If the file is not regular or writeable, it should return errno(EPERM).
> 
> This patch is based on commit 85a258b70d4891a443583530f48ab734a31e2d8d.
> 
> Signed-off-by: Younger Liu <younger.liu@huawei.com>
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

Looks good to me, thanks.
(BTW, there is no need to add my SOB because I'm not in patch submission path :)).

Reviewed-by: Jie Liu <jeff.liu@oracle.com>

> ---
>  fs/ocfs2/move_extents.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
> index 3d3f3c8..9385fa8 100644
> --- a/fs/ocfs2/move_extents.c
> +++ b/fs/ocfs2/move_extents.c
> @@ -1067,8 +1067,10 @@ int ocfs2_ioctl_move_extents(struct file *filp, void __user *argp)
>  	if (status)
>  		return status;
>  
> -	if ((!S_ISREG(inode->i_mode)) || !(filp->f_mode & FMODE_WRITE))
> +	if ((!S_ISREG(inode->i_mode)) || !(filp->f_mode & FMODE_WRITE)) {
> +		status = -EPERM;
>  		goto out_drop;
> +	}
>  
>  	if (inode->i_flags & (S_IMMUTABLE|S_APPEND)) {
>  		status = -EPERM;
> @@ -1090,8 +1092,10 @@ int ocfs2_ioctl_move_extents(struct file *filp, void __user *argp)
>  		goto out_free;
>  	}
>  
> -	if (range.me_start > i_size_read(inode))
> +	if (range.me_start > i_size_read(inode)) {
> +		status = -EINVAL;
>  		goto out_free;
> +	}
>  
>  	if (range.me_start + range.me_len > i_size_read(inode))
>  			range.me_len = i_size_read(inode) - range.me_start;
> -- 1.7.9.7
