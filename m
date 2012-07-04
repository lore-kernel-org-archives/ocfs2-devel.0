From: Joel Becker <jlbec@evilplan.org>
Date: Wed, 4 Jul 2012 00:33:52 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix bogus error message from
 ocfs2_global_read_info
In-Reply-To: <1328867407-11557-1-git-send-email-jack@suse.cz>
References: <1328867407-11557-1-git-send-email-jack@suse.cz>
Message-ID: <20120704073352.GE9863@dhcp-172-17-9-228.mtv.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 10, 2012 at 10:50:07AM +0100, Jan Kara wrote:
> 'status' variable in ocfs2_global_read_info() is always != 0 when leaving the
> function because it happens to contain number of read bytes. Thus we always log
> error message although everything is OK. Since all error cases properly call
> mlog_errno() before jumping to out_err, there's no reason to call mlog_errno()
> on exit at all. This is a fallout of c1e8d35e (conversion of mlog_exit()
> calls).
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

This patch is (finally) now part of the 'fixes' branch of ocfs2.git.

Joel

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
> 1.7.1
> 

-- 

"Here's something to think about:  How come you never see a headline
 like ``Psychic Wins Lottery''?"
	- Jay Leno

			http://www.jlbec.org/
			jlbec at evilplan.org
