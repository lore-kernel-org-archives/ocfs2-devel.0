From: Joseph Qi <joseph.qi@huawei.com>
Date: Thu, 6 Nov 2014 15:37:19 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix error handling when creating
 debugfs root in ocfs2_init()
In-Reply-To: <1415257654-17607-1-git-send-email-jack@suse.cz>
References: <1415257654-17607-1-git-send-email-jack@suse.cz>
Message-ID: <545B252F.7070601@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Looks good to me. Thanks.
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>

On 2014/11/6 15:07, Jan Kara wrote:
> Error handling if creation of root of debugfs in ocfs2_init() fails is
> broken. Although error code is set we fail to exit ocfs2_init() with
> error and thus initialization ends with success. Later when mounting a
> filesystem, ocfs2 debugfs entries end up being created in the root of
> debugfs filesystem which is confusing.
> 
> Fix the error handling to bail out.
> 
> Coverity-id: 1227009
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ocfs2/super.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> This replaces patch "ocfs2: Remove pointless assignment in ocfs2_init()".
> Things are safer this way and when debugfs dir creation fails, something is
> really wrong.
> 
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 93c85bc745e1..8e3ac25efb9f 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1622,8 +1622,9 @@ static int __init ocfs2_init(void)
>  
>  	ocfs2_debugfs_root = debugfs_create_dir("ocfs2", NULL);
>  	if (!ocfs2_debugfs_root) {
> -		status = -EFAULT;
> +		status = -ENOMEM;
>  		mlog(ML_ERROR, "Unable to create ocfs2 debugfs root.\n");
> +		goto out4;
>  	}
>  
>  	ocfs2_set_locking_protocol();
> 
