From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Thu, 16 Apr 2015 16:48:27 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2_iop_set/get_acl() are also
 called from the VFS so we must take inode lock
In-Reply-To: <1428097580-25352-2-git-send-email-tariq.x.saeed@oracle.com>
References: <1428097580-25352-1-git-send-email-tariq.x.saeed@oracle.com>
	<1428097580-25352-2-git-send-email-tariq.x.saeed@oracle.com>
Message-ID: <552F775B.6040203@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Tariq,

On 04/04/2015 05:46 AM, Tariq Saeed wrote:
> Orabug: 20189959
> 
> This bug in mainline code is pointed out by Mark Fasheh. When ocfs2_iop_set_acl
> and ocfs2_iop_ge_acl are entered from VFS layer, inode lock is not held. This
> seems to be regression from older kernels. The patch is to fix that.
> 
> Signed-off-by: Tariq Saeed <tariq.x.saeed@oracle.com>
> ---
>  fs/ocfs2/acl.c |   28 +++++++++++++++++++++-------
>  1 files changed, 21 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
> index 7e8282d..d7b5542 100644
> --- a/fs/ocfs2/acl.c
> +++ b/fs/ocfs2/acl.c
> @@ -286,7 +286,19 @@ int ocfs2_set_acl(handle_t *handle,
>  
>  int ocfs2_iop_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  {
> -	return ocfs2_set_acl(NULL, inode, NULL, type, acl, NULL, NULL);
> +	struct buffer_head *bh = NULL;
> +	int status = 0;
> +
> +	status = ocfs2_inode_lock(inode, &bh, 1);
> +	if (status < 0) {
> +		if (status != -ENOENT)
> +			mlog_errno(status);
> +		return status;
> +	}
> +	status = ocfs2_set_acl(NULL, inode, bh, type, acl, NULL, NULL);
> +	ocfs2_inode_unlock(inode, 1);
> +	brelse(bh);
> +	return status;
>  }
>  
>  struct posix_acl *ocfs2_iop_get_acl(struct inode *inode, int type)
> @@ -294,19 +306,21 @@ struct posix_acl *ocfs2_iop_get_acl(struct inode *inode, int type)
>  	struct ocfs2_super *osb;
>  	struct buffer_head *di_bh = NULL;
>  	struct posix_acl *acl;
> -	int ret = -EAGAIN;
> +	int ret;
>  
>  	osb = OCFS2_SB(inode->i_sb);
>  	if (!(osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL))
>  		return NULL;
> -
> -	ret = ocfs2_read_inode_block(inode, &di_bh);
> -	if (ret < 0)
> -		return ERR_PTR(ret);
> +	ret = ocfs2_inode_lock(inode, &di_bh, 0);
> +	if (ret < 0) {
> +		mlog_errno(ret);
> +		acl = ERR_PTR(ret);
> +		return acl;
I think "return ERR_PTR(ret);" is more simple here.
Also why you check "status != -ENOENT" in ocfs2_iop_set_acl() but not here?

Thanks,
Junxiao.

> +	}
>  
>  	acl = ocfs2_get_acl_nolock(inode, type, di_bh);
>  
> +	ocfs2_inode_unlock(inode, 0);
>  	brelse(di_bh);
> -
>  	return acl;
>  }
> 
