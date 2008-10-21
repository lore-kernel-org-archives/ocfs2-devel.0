From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 21 Oct 2008 13:35:03 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix checking of return value
	of	new_inode()
In-Reply-To: <12245234434014-git-send-email-jack@suse.cz>
References: <12245234434014-git-send-email-jack@suse.cz>
Message-ID: <20081021203503.GE2871@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Oct 20, 2008 at 07:23:53PM +0200, Jan Kara wrote:
> new_inode() does not return ERR_PTR() but NULL in case of failure. Correct
> checking of the return value.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Joel Becker <joel.becker@oracle.com>

Another upstream candidate.

> ---
>  fs/ocfs2/namei.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index d5d808f..0372ef0 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -382,8 +382,8 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
>  	}
>  
>  	inode = new_inode(dir->i_sb);
> -	if (IS_ERR(inode)) {
> -		status = PTR_ERR(inode);
> +	if (!inode) {
> +		status = -ENOMEM;
>  		mlog(ML_ERROR, "new_inode failed!\n");
>  		goto leave;
>  	}
> -- 
> 1.5.2.4
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

"Well-timed silence hath more eloquence than speech."  
         - Martin Fraquhar Tupper

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
