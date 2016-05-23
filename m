From: Joseph Qi <joseph.qi@huawei.com>
Date: Mon, 23 May 2016 11:14:32 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix a redundant re-initialization
In-Reply-To: <1463970605-18354-1-git-send-email-zren@suse.com>
References: <1463970605-18354-1-git-send-email-zren@suse.com>
Message-ID: <57427598.9060000@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2016/5/23 10:30, Eric Ren wrote:
> Obviously, memset() has zeroed the whole struct locking_max_version.
> So, it's no need to zero its two fields individually.
> 
> Signed-off-by: Eric Ren <zren@suse.com>
Looks good, thanks.
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>

> ---
>  fs/ocfs2/stackglue.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
> index 5d965e8..855fb44 100644
> --- a/fs/ocfs2/stackglue.c
> +++ b/fs/ocfs2/stackglue.c
> @@ -734,8 +734,6 @@ static void __exit ocfs2_stack_glue_exit(void)
>  {
>  	memset(&locking_max_version, 0,
>  	       sizeof(struct ocfs2_protocol_version));
> -	locking_max_version.pv_major = 0;
> -	locking_max_version.pv_minor = 0;
>  	ocfs2_sysfs_exit();
>  	if (ocfs2_table_header)
>  		unregister_sysctl_table(ocfs2_table_header);
> 
