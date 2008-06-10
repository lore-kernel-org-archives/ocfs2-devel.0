From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 9 Jun 2008 17:38:15 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Silence an error message in
	ocfs2_file_aio_read()
In-Reply-To: <1213035881-25108-1-git-send-email-sunil.mushran@oracle.com>
References: <1213035881-25108-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080610003815.GD28100@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jun 09, 2008 at 11:24:41AM -0700, Sunil Mushran wrote:
> This patch silences an EINVAL error message in ocfs2_file_aio_read()
> that is always due to a user error.
> 

Ok, Thanks.

> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> ---
>  fs/ocfs2/file.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 57e0d30..e8514e8 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -2202,7 +2202,7 @@ static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
>  
>  	ret = generic_file_aio_read(iocb, iov, nr_segs, iocb->ki_pos);
>  	if (ret == -EINVAL)
> -		mlog(ML_ERROR, "generic_file_aio_read returned -EINVAL\n");
> +		mlog(0, "generic_file_aio_read returned -EINVAL\n");
>  
>  	/* buffered aio wouldn't have proper lock coverage today */
>  	BUG_ON(ret == -EIOCBQUEUED && !(filp->f_flags & O_DIRECT));
> -- 
> 1.5.4.5
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
--
Mark Fasheh
