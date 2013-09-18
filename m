From: Jeff Liu <jeff.liu@oracle.com>
Date: Wed, 18 Sep 2013 17:12:54 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Add missing errno in
	ocfs2_ioctl_move_extents()
In-Reply-To: <52396549.6040906@huawei.com>
References: <52396549.6040906@huawei.com>
Message-ID: <52396E96.1070106@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 09/18/2013 04:33 PM, Younger Liu wrote:

> If the file is not regular or writeable, it should return errno(-EPERM).
> 
> This patch is based on commit 85a258b70d4891a443583530f48ab734a31e2d8d.
> 
> Signed-off-by: Younger Liu <younger.liu@huawei.com>
> Cc: Jie Liu <jeff.liu@oracle.com>
> Cc: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  fs/ocfs2/move_extents.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
> index 3d3f3c8..0ef308d 100644
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

This fix looks good, but we should also return an meaningful errno
if the defragment start offset is larger than the file size in this
function, i.e,

-       if (range.me_start > i_size_read(inode))
+       if (range.me_start > i_size_read(inode)) {
+               status = -EINVAL;
                goto out_free;
+       }

Thanks,
-Jeff
