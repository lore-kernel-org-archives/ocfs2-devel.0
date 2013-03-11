From: Joel Becker <jlbec@evilplan.org>
Date: Mon, 11 Mar 2013 02:09:15 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: Delay inode update
 transactions after verifying the input flags
In-Reply-To: <513D6BAF.90707@oracle.com>
References: <513D6BAF.90707@oracle.com>
Message-ID: <20130311090914.GG7783@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Mar 11, 2013 at 01:29:19PM +0800, Jeff Liu wrote:
> There is no need to start the inode update transactions before/while verifying
> the input flags.  As a refinement, this patch delay the transactions utill the
> pre-check up is ok.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Mark Fasheh <mfasheh@suse.com>

Acked-by: Joel Becker <jlbec@evilplan.org>

> ---
>  fs/ocfs2/ioctl.c |   18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
> index f20edcb..c739c24 100644
> --- a/fs/ocfs2/ioctl.c
> +++ b/fs/ocfs2/ioctl.c
> @@ -101,13 +101,6 @@ static int ocfs2_set_inode_attr(struct inode *inode, unsigned flags,
>  	if (!S_ISDIR(inode->i_mode))
>  		flags &= ~OCFS2_DIRSYNC_FL;
>  
> -	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
> -	if (IS_ERR(handle)) {
> -		status = PTR_ERR(handle);
> -		mlog_errno(status);
> -		goto bail_unlock;
> -	}
> -
>  	oldflags = ocfs2_inode->ip_attr;
>  	flags = flags & mask;
>  	flags |= oldflags & ~mask;
> @@ -120,7 +113,14 @@ static int ocfs2_set_inode_attr(struct inode *inode, unsigned flags,
>  	if ((oldflags & OCFS2_IMMUTABLE_FL) || ((flags ^ oldflags) &
>  		(OCFS2_APPEND_FL | OCFS2_IMMUTABLE_FL))) {
>  		if (!capable(CAP_LINUX_IMMUTABLE))
> -			goto bail_commit;
> +			goto bail_unlock;
> +	}
> +
> +	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
> +	if (IS_ERR(handle)) {
> +		status = PTR_ERR(handle);
> +		mlog_errno(status);
> +		goto bail_unlock;
>  	}
>  
>  	ocfs2_inode->ip_attr = flags;
> @@ -130,8 +130,8 @@ static int ocfs2_set_inode_attr(struct inode *inode, unsigned flags,
>  	if (status < 0)
>  		mlog_errno(status);
>  
> -bail_commit:
>  	ocfs2_commit_trans(osb, handle);
> +
>  bail_unlock:
>  	ocfs2_inode_unlock(inode, 1);
>  bail:
> -- 
> 1.7.9.5

-- 

"Reader, suppose you were and idiot.  And suppose you were a member of
 Congress.  But I repeat myself."
	- Mark Twain

			http://www.jlbec.org/
			jlbec at evilplan.org
