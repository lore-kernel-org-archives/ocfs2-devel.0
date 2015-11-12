From: Gang He <ghe@suse.com>
Date: Wed, 11 Nov 2015 19:13:38 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix umask ignored issue
In-Reply-To: <1447293433-23973-1-git-send-email-junxiao.bi@oracle.com>
References: <1447293433-23973-1-git-send-email-junxiao.bi@oracle.com>
Message-ID: <56446652020000F90001DFDC@relay2.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello Junxiao,

Thank for your fix, I also found that the issue happened on openSuSe13.2 (3.16.7-24-desktop), although the issue does not exist on sles11sp4 (3.0.101-63-default), I feel that this issue belongs to a regression bug.


Thanks
Gang 


>>> 
> New created file's mode is not masked with umask, and this makes
> umask not work for ocfs2 volume.
> 
> Fixes: 702e5bc ("ocfs2: use generic posix ACL infrastructure")
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> ---
>  fs/ocfs2/namei.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index 3b48ac2..a03f6f4 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -372,6 +372,8 @@ static int ocfs2_mknod(struct inode *dir,
>  		mlog_errno(status);
>  		goto leave;
>  	}
> +	/* update inode->i_mode after mask with "umask". */
> +	inode->i_mode = mode;
>  
>  	handle = ocfs2_start_trans(osb, ocfs2_mknod_credits(osb->sb,
>  							    S_ISDIR(mode),
> -- 
> 1.7.9.5
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com 
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
