From: Jeff Liu <jeff.liu@oracle.com>
Date: Thu, 04 Apr 2013 17:21:02 +0800
Subject: [Ocfs2-devel] [patch 1/2] Ocfs2/move_extents: fix error
	handling in ioctl
In-Reply-To: <20130404063718.GE6494@longonot.mountain>
References: <20130404063718.GE6494@longonot.mountain>
Message-ID: <515D45FE.7020605@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Dan,

On 04/04/2013 02:37 PM, Dan Carpenter wrote:
> Smatch complains that if we hit an error (for example if the file is
> immutable) then "range" has uninitialized stack data and we copy it to
> the user.
Yes, We should copy the status of movement/defragmentation back to user
only if this procedure has been issued although it may be only partially
completed.

I personally would suggest to do a bit code adjustment for this function
combine your current fix if you like, the related comments are inline.

> 
> I've re-written the error handling to avoid this problem.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
> index 9f8dcad..995d1b4 100644
> --- a/fs/ocfs2/move_extents.c
> +++ b/fs/ocfs2/move_extents.c
> @@ -1057,25 +1057,25 @@ int ocfs2_ioctl_move_extents(struct file *filp, void __user *argp)
>  
>  	struct inode *inode = file_inode(filp);
>  	struct ocfs2_move_extents range;
> -	struct ocfs2_move_extents_context *context = NULL;
> +	struct ocfs2_move_extents_context *context;
>  
Just return if argv is invalid, i.e. NULL.
	if (!argv)
		return -EINVAL;

>  	status = mnt_want_write_file(filp);
>  	if (status)
>  		return status;
>  
>  	if ((!S_ISREG(inode->i_mode)) || !(filp->f_mode & FMODE_WRITE))
> -		goto out;
> +		goto out_drop;
>  
>  	if (inode->i_flags & (S_IMMUTABLE|S_APPEND)) {
>  		status = -EPERM;
> -		goto out;
> +		goto out_drop;
>  	}
>  
>  	context = kzalloc(sizeof(struct ocfs2_move_extents_context), GFP_NOFS);
>  	if (!context) {
>  		status = -ENOMEM;
>  		mlog_errno(status);
> -		goto out;
> +		goto out_drop;
>  	}
>  
>  	context->inode = inode;
> @@ -1084,15 +1084,15 @@ int ocfs2_ioctl_move_extents(struct file *filp, void __user *argp)
>  	if (argp) {
>  		if (copy_from_user(&range, argp, sizeof(range))) {
>  			status = -EFAULT;
> -			goto out;
> +			goto out_free;
>  		}
With above pre-checking up against 'argv', we can kill the following conditional code
block and try to copy the input range directly.
	if (copy_from_user(&range, ...)) {
		....
	}

>  	} else {
>  		status = -EINVAL;
> -		goto out;
> +		goto out_free;
>  	}
>  
>  	if (range.me_start > i_size_read(inode))
> -		goto out;
> +		goto out_free;
>  
>  	if (range.me_start + range.me_len > i_size_read(inode))
>  			range.me_len = i_size_read(inode) - range.me_start;
> @@ -1124,13 +1124,13 @@ int ocfs2_ioctl_move_extents(struct file *filp, void __user *argp)
>  
>  		status = ocfs2_validate_and_adjust_move_goal(inode, &range);
>  		if (status)
> -			goto out;
> +			goto out_copy;
>  	}
>  
>  	status = ocfs2_move_extents(context);
>  	if (status)
>  		mlog_errno(status);
> -out:
> +out_copy:
So with the beginning pre-checkup, we don't need to verify argp again that the
original code does.
-       if (argp) {
-               if (copy_to_user(argp, &range, sizeof(range)))
-                       status = -EFAULT;
-       }
+       if (copy_to_user(argp, &range, sizeof(range)))
+               status = -EFAULT;
>  	/*
>  	 * movement/defragmentation may end up being partially completed,
>  	 * that's the reason why we need to return userspace the finished
> @@ -1141,8 +1141,9 @@ out:
>  			status = -EFAULT;
>  	}
>  
> +out_free:
>  	kfree(context);
> -
> +out_drop:
>  	mnt_drop_write_file(filp);
>  
>  	return status;

Thanks,
-Jeff
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo at vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
