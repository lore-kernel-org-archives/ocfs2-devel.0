From: Eric Ren <zren@suse.com>
Date: Wed, 9 Nov 2016 12:55:34 +0800
Subject: [Ocfs2-devel] [DRAFT 2/2] ocfs2: fix deadlock caused by
 recursive cluster locking
In-Reply-To: <1476854382-28101-3-git-send-email-zren@suse.com>
References: <1476854382-28101-1-git-send-email-zren@suse.com>
	<1476854382-28101-3-git-send-email-zren@suse.com>
Message-ID: <ed21016a-4e68-9a9e-4b54-91c970d5629f@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,

On 10/19/2016 01:19 PM, Eric Ren wrote:
> diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
> index bed1fcb..7e3544e 100644
> --- a/fs/ocfs2/acl.c
> +++ b/fs/ocfs2/acl.c
> @@ -283,16 +283,24 @@ int ocfs2_set_acl(handle_t *handle,
>   int ocfs2_iop_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>   {
>   	struct buffer_head *bh = NULL;
> +	struct ocfs2_holder *oh;
> +	struct ocfs2_lock_res *lockres = &OCFS2_I(inode)->ip_inode_lockres;
>   	int status = 0;
>   
> -	status = ocfs2_inode_lock(inode, &bh, 1);
> -	if (status < 0) {
> -		if (status != -ENOENT)
> -			mlog_errno(status);
> -		return status;
> +	oh = ocfs2_is_locked_by_me(lockres);
> +	if (!oh) {
> +		status = ocfs2_inode_lock(inode, &bh, 1);
> +		if (status < 0) {
> +			if (status != -ENOENT)
> +				mlog_errno(status);
> +			return status;
> +		}
>   	}
This is wrong. We also depend ocfs2_inode_lock() pass out "bh" for later use.

So, we may need another function something like ocfs2_inode_getbh():
      if (!oh)
         ocfs2_inode_lock();
    else
        ocfs2_inode_getbh();

Eric
> +
>   	status = ocfs2_set_acl(NULL, inode, bh, type, acl, NULL, NULL);
> -	ocfs2_inode_unlock(inode, 1);
> +
> +	if (!oh)
> +		ocfs2_inode_unlock(inode, 1);
>   	brelse(bh);
>   	return status;
>   }
> @@ -302,21 +310,28 @@ struct posix_acl *ocfs2_iop_get_acl(struct inode *inode, int type)
>   	struct ocfs2_super *osb;
>   	struct buffer_head *di_bh = NULL;
>   	struct posix_acl *acl;
> +	struct ocfs2_holder *oh;
> +	struct ocfs2_lock_res *lockres = &OCFS2_I(inode)->ip_inode_lockres;
>   	int ret;
>   
>   	osb = OCFS2_SB(inode->i_sb);
>   	if (!(osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL))
>   		return NULL;
> -	ret = ocfs2_inode_lock(inode, &di_bh, 0);
> -	if (ret < 0) {
> -		if (ret != -ENOENT)
> -			mlog_errno(ret);
> -		return ERR_PTR(ret);
> +
> +	oh = ocfs2_is_locked_by_me(lockres);
> +	if (!oh) {
> +		ret = ocfs2_inode_lock(inode, &di_bh, 0);
> +		if (ret < 0) {
> +			if (ret != -ENOENT)
> +				mlog_errno(ret);
> +			return ERR_PTR(ret);
> +		}
>   	}
>   
>   	acl = ocfs2_get_acl_nolock(inode, type, di_bh);
>   
> -	ocfs2_inode_unlock(inode, 0);
> +	if (!oh)
> +		ocfs2_inode_unlock(inode, 0);
>   	brelse(di_bh);
>   	return acl;
>   }


-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20161109/ddb6d0e4/attachment.html 
