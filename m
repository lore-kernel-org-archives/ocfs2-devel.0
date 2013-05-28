From: Jeff Liu <jeff.liu@oracle.com>
Date: Tue, 28 May 2013 19:08:50 +0800
Subject: [Ocfs2-devel] [PATCH]Remove unecessary ERROR when removing
 non-empty directory
In-Reply-To: <1369703559-25053-1-git-send-email-xiaowei.hu@oracle.com>
References: <1369703559-25053-1-git-send-email-xiaowei.hu@oracle.com>
Message-ID: <51A49042.1080402@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 05/28/2013 09:12 AM, xiaowei.hu at oracle.com wrote:

> From: "Xiaowei.Hu" <xiaowei.hu@oracle.com>
> 
> Suppress the error message from being printed in ocfs2_rename
> Did same thing with Goldwyn Rodrigues last patch.
> 
> While removing a non-empty directory, the kernel dumps a message:
> (mv,29521,1):ocfs2_rename:1474 ERROR: status = -39 
> 
> Signed-off-by: Xiaowei Hu <xiaowei.hu@oracle.com>

Reviewed-by: Jie Liu <jeff.liu@oracle.com>

> 
> ---
>  fs/ocfs2/namei.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index 50c93a8..8ef1776 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -1470,7 +1470,7 @@ bail:
>  	brelse(old_dir_bh);
>  	brelse(new_dir_bh);
>  
> -	if (status)
> +	if (status && (status != -ENOTEMPTY))
>  		mlog_errno(status);
>  
>  	return status;
