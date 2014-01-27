From: Xiaowei Hu <xiaowei.hu@oracle.com>
Date: Mon, 27 Jan 2014 02:58:44 -0800 (PST)
Subject: [Ocfs2-devel] [PATCH] make ocfs2 do not log ENOENT error
Message-ID: <e6fe73ea-cc71-44d4-b239-07221837f7d1@default>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sorry for missing that.

signed-off-by: xiaowei.hu at oracle.com

On Fri, 24 Jan 2014 14:11:09 +0800 xiaowei.hu at oracle.com wrote:

> From: "Xiaowei.Hu" <xiaowei.hu@oracle.com>
> 
> suppress log message like this:
> (open_delete,8328,0):ocfs2_unlink:951 ERROR: status = -2
> 
> Orabug:17445485
> ---
>  fs/ocfs2/namei.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index 0ba1cf0..ca6c5ba 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -947,7 +947,7 @@ leave:
>  	ocfs2_free_dir_lookup_result(&orphan_insert);
>  	ocfs2_free_dir_lookup_result(&lookup);
>  
> -	if (status && (status != -ENOTEMPTY))
> +	if (status && (status != -ENOTEMPTY) && (status != -ENOENT))
>  		mlog_errno(status);
>  
>  	return status;

Please send a signed-off-by: for this patch.
