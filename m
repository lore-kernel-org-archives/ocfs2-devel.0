From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 26 Nov 2008 09:41:04 +0800
Subject: [Ocfs2-devel] [PATCH 01/10] ocfs2: Add missing initialization
In-Reply-To: <1227623495-16708-1-git-send-email-jack@suse.cz>
References: <y> <1227623495-16708-1-git-send-email-jack@suse.cz>
Message-ID: <492CA930.2000000@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jan,
	I have already found this and generate a patch for it. 
http://oss.oracle.com/pipermail/ocfs2-devel/2008-November/003413.html

but since Mark hasn't push it to his merge_window, I think either of the 
patch is OK.

Regards,
Tao

Jan Kara wrote:
> Add missing variable initialization to ocfs2_dquot_drop_slow().
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ocfs2/quota_global.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
> index d2a5bfa..7f561e4 100644
> --- a/fs/ocfs2/quota_global.c
> +++ b/fs/ocfs2/quota_global.c
> @@ -873,7 +873,7 @@ out:
>  
>  static int ocfs2_dquot_drop_slow(struct inode *inode)
>  {
> -	int status;
> +	int status = 0;
>  	int cnt;
>  	int got_lock[MAXQUOTAS] = {0, 0};
>  	handle_t *handle;
