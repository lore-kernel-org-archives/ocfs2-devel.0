From: Joel Becker <jlbec@evilplan.org>
Date: Tue, 31 May 2011 18:43:04 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: remove redundant and incorrect
	mlog_error
In-Reply-To: <1306514092-22962-1-git-send-email-tiger.yang@oracle.com>
References: <1306514092-22962-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <20110601014303.GA5468@noexit.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, May 28, 2011 at 12:34:52AM +0800, Tiger Yang wrote:
> We have already mlog all error and positive status is not error.

	Positive status is turned into -EIO.  There are actually a
couple of places in this function that do not mlog_errno(status) and
rely on this print.  I think you should add them to your patch.
	For example:

371         status = ocfs2_qinfo_lock(oinfo, 0);
372         if (status < 0)
373                 goto out_unlock;

Joel
 
> Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
> ---
>  fs/ocfs2/quota_global.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
> index 92fcd57..0a86e30 100644
> --- a/fs/ocfs2/quota_global.c
> +++ b/fs/ocfs2/quota_global.c
> @@ -399,8 +399,6 @@ int ocfs2_global_read_info(struct super_block *sb, int type)
>  			      msecs_to_jiffies(oinfo->dqi_syncms));
>  
>  out_err:
> -	if (status)
> -		mlog_errno(status);
>  	return status;
>  out_unlock:
>  	ocfs2_unlock_global_qf(oinfo, 0);
> -- 
> 1.7.4.4
> 

-- 

"Copy from one, it's plagiarism; copy from two, it's research."
        - Wilson Mizner

			http://www.jlbec.org/
			jlbec at evilplan.org
