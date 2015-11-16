From: Joseph Qi <joseph.qi@huawei.com>
Date: Mon, 16 Nov 2015 11:14:14 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Optimize bad declarations and
 redundant assignment
In-Reply-To: <56493A1E.5050207@huawei.com>
References: <56493A1E.5050207@huawei.com>
Message-ID: <56494A06.6060503@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2015/11/16 10:06, Norton.Zhu wrote:
> In ocfs2_parse_options,
> a)it's better to declare variables(small size) outside of while loop;
> b)'option' will be set by match_int, 'option = 0;' makes no sense, if match_int failed,
>    it just goto bail and return.
> 
> Signed-off-by: Norton.Zhu <norton.zhu@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>

> ---
>  fs/ocfs2/super.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 403c566..8a6b48f 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1278,6 +1278,8 @@ static int ocfs2_parse_options(struct super_block *sb,
>  	int status, user_stack = 0;
>  	char *p;
>  	u32 tmp;
> +	int token, option;
> +	substring_t args[MAX_OPT_ARGS];
> 
>  	trace_ocfs2_parse_options(is_remount, options ? options : "(none)");
> 
> @@ -1296,9 +1298,6 @@ static int ocfs2_parse_options(struct super_block *sb,
>  	}
> 
>  	while ((p = strsep(&options, ",")) != NULL) {
> -		int token, option;
> -		substring_t args[MAX_OPT_ARGS];
> -
>  		if (!*p)
>  			continue;
> 
> @@ -1356,7 +1355,6 @@ static int ocfs2_parse_options(struct super_block *sb,
>  				mopt->atime_quantum = option;
>  			break;
>  		case Opt_slot:
> -			option = 0;
>  			if (match_int(&args[0], &option)) {
>  				status = 0;
>  				goto bail;
> @@ -1365,7 +1363,6 @@ static int ocfs2_parse_options(struct super_block *sb,
>  				mopt->slot = (s16)option;
>  			break;
>  		case Opt_commit:
> -			option = 0;
>  			if (match_int(&args[0], &option)) {
>  				status = 0;
>  				goto bail;
> @@ -1377,7 +1374,6 @@ static int ocfs2_parse_options(struct super_block *sb,
>  			mopt->commit_interval = HZ * option;
>  			break;
>  		case Opt_localalloc:
> -			option = 0;
>  			if (match_int(&args[0], &option)) {
>  				status = 0;
>  				goto bail;
> 
