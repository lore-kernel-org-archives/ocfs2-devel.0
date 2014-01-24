From: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 24 Jan 2014 12:34:55 -0800
Subject: [Ocfs2-devel] [PATCH] make ocfs2 do not log ENOENT error
In-Reply-To: <1390543869-9884-1-git-send-email-xiaowei.hu@oracle.com>
References: <1390543869-9884-1-git-send-email-xiaowei.hu@oracle.com>
Message-ID: <20140124123455.d9c8a1e1e41ff0eb5a51238b@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

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
