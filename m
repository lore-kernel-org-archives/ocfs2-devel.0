From: Joel Becker <jlbec@evilplan.org>
Date: Tue, 3 Jul 2012 23:26:23 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: remove redundant and incorrect
	mlog_error
In-Reply-To: <1340611404-17808-1-git-send-email-tiger.yang@oracle.com>
References: <4FE81A93.6010200@oracle.com>
	<1340611404-17808-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <20120704062623.GA9863@dhcp-172-17-9-228.mtv.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I have Jan's patch, which keeps mlog_errno near the errors.  this is
good for locating the problem.

Joel

On Mon, Jun 25, 2012 at 04:03:24PM +0800, Tiger Yang wrote:
> out_err already logged all the negative status, so remove mlog_errno
> before goto there. If quota_read succeed, positive (non zero)
> status should be return and it's not a error.
> 
> Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
> ---
>  fs/ocfs2/quota_global.c |   11 +++--------
>  1 files changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
> index 92fcd57..cb0f017 100644
> --- a/fs/ocfs2/quota_global.c
> +++ b/fs/ocfs2/quota_global.c
> @@ -358,10 +358,8 @@ int ocfs2_global_read_info(struct super_block *sb, int type)
>  	oinfo->dqi_gqi_count = 0;
>  	oinfo->dqi_gqinode = gqinode;
>  	status = ocfs2_lock_global_qf(oinfo, 0);
> -	if (status < 0) {
> -		mlog_errno(status);
> +	if (status < 0)
>  		goto out_err;
> -	}
>  
>  	status = ocfs2_extent_map_get_blocks(gqinode, 0, &oinfo->dqi_giblk,
>  					     &pcount, NULL);
> @@ -381,7 +379,6 @@ int ocfs2_global_read_info(struct super_block *sb, int type)
>  		     status);
>  		if (status >= 0)
>  			status = -EIO;
> -		mlog_errno(status);
>  		goto out_err;
>  	}
>  	info->dqi_bgrace = le32_to_cpu(dinfo.dqi_bgrace);
> @@ -398,14 +395,12 @@ int ocfs2_global_read_info(struct super_block *sb, int type)
>  	schedule_delayed_work(&oinfo->dqi_sync_work,
>  			      msecs_to_jiffies(oinfo->dqi_syncms));
>  
> -out_err:
> -	if (status)
> -		mlog_errno(status);
>  	return status;
>  out_unlock:
>  	ocfs2_unlock_global_qf(oinfo, 0);
> +out_err:
>  	mlog_errno(status);
> -	goto out_err;
> +	return status;
>  }
>  
>  /* Write information to global quota file. Expects exlusive lock on quota
> -- 
> 1.7.4.4
> 

-- 

Life's Little Instruction Book #451

	"Don't be afraid to say, 'I'm sorry.'"

			http://www.jlbec.org/
			jlbec at evilplan.org
