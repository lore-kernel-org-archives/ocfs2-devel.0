From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Feb 28 17:54:47 2008
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix writeout in
	ocfs2_data_convert_worker()
In-Reply-To: <20080229012643.GA9349@ca-server1.us.oracle.com>
References: <20080229012643.GA9349@ca-server1.us.oracle.com>
Message-ID: <20080229015335.GF17860@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Feb 28, 2008 at 05:26:43PM -0800, Mark Fasheh wrote:
> Commit f1f540688eae66c274ff1c1133b5d9c687b28f58 "optimized"
> ocfs2_data_convert_worker() to "only do work for regular files".
> Unfortunately, I left out a '!', which casued it to *skip* regular files.
> This was hidden from testing until recently because the default data
> journaling mode (data=ordered) doesn't exercise this code.
> 
> Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>

> ---
>  fs/ocfs2/dlmglue.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 351130c..f4b3dab 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -3042,7 +3042,7 @@ static int ocfs2_data_convert_worker(struct ocfs2_lock_res *lockres,
>         	inode = ocfs2_lock_res_inode(lockres);
>  	mapping = inode->i_mapping;
>  
> -	if (S_ISREG(inode->i_mode))
> +	if (!S_ISREG(inode->i_mode))
>  		goto out;
>  
>  	/*
> -- 
> 1.5.3.6
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

"But then she looks me in the eye
 And says, 'We're going to last forever,'
 And man you know I can't begin to doubt it.
 Cause it just feels so good and so free and so right,
 I know we ain't never going to change our minds about it, Hey!
 Here comes my girl."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
