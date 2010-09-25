From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Sat, 25 Sep 2010 16:39:44 +0800
Subject: [Ocfs2-devel] [PATCH 03/20] ocfs2: Add support for
 heartbeat=global mount option
In-Reply-To: <1284504656-2434-4-git-send-email-sunil.mushran@oracle.com>
References: <1284504656-2434-1-git-send-email-sunil.mushran@oracle.com>
	<1284504656-2434-4-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20100925083944.GB3950@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10-09-14 15:50, Sunil Mushran wrote:
> Adds support for heartbeat=global mount option. It ensures that the heartbeat
> mode passed matches the one enabled on disk.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> ---
>  fs/ocfs2/ocfs2.h    |    4 ++-
>  fs/ocfs2/ocfs2_fs.h |    1 +
>  fs/ocfs2/super.c    |   55 ++++++++++++++++++++++++++++++++++++++-------------
>  3 files changed, 45 insertions(+), 15 deletions(-)
> 
> @@ -1291,6 +1301,7 @@ static int ocfs2_parse_options(struct super_block *sb,
>  {
>  	int status;
>  	char *p;
> +	u32 tmp;
>  
>  	mlog_entry("remount: %d, options: \"%s\"\n", is_remount,
>  		   options ? options : "(none)");
> @@ -1322,7 +1333,10 @@ static int ocfs2_parse_options(struct super_block *sb,
>  			mopt->mount_opt |= OCFS2_MOUNT_HB_LOCAL;
>  			break;
>  		case Opt_hb_none:
> -			mopt->mount_opt &= ~OCFS2_MOUNT_HB_LOCAL;
> +			mopt->mount_opt |= OCFS2_MOUNT_HB_NONE;
> +			break;
> +		case Opt_hb_global:
> +			mopt->mount_opt |= OCFS2_MOUNT_HB_GLOBAL;
>  			break;
>  		case Opt_barrier:
>  			if (match_int(&args[0], &option)) {
> @@ -1477,6 +1491,15 @@ static int ocfs2_parse_options(struct super_block *sb,
>  		}
>  	}
>  
> +	/* Ensure only one heartbeat mode */
> +	tmp = mopt->mount_opt & (OCFS2_MOUNT_HB_LOCAL | OCFS2_MOUNT_HB_GLOBAL |
> +				 OCFS2_MOUNT_HB_NONE);
> +	if (hweight32(tmp) != 1) {
> +		mlog(ML_ERROR, "Invalid heartbeat mount option: %s\n", options);

Coming here, the "options" doesn't hold orginal options yet.

regards,
wengang.
