From: piaojun <piaojun@huawei.com>
Date: Mon, 7 May 2018 08:52:49 +0800
Subject: [Ocfs2-devel] [PATCH] fix a compiling warning
In-Reply-To: <20180506094903.4331-1-lchen@suse.com>
References: <20180506094903.4331-1-lchen@suse.com>
Message-ID: <5AEFA361.8060400@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Larry,

'had_lock' will be initialized by ocfs2_inode_lock_tracker(), and the
'bail' branch above won't use it either as 'inode_locked' is still zero.

thanks,
Jun

On 2018/5/6 17:49, Larry Chen wrote:
> The variable had_lock might be used uninitialized.
> 
> Signed-off-by: Larry Chen <lchen@suse.com>
> ---
>  fs/ocfs2/file.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 6ee94bc23f5b..50f17f56db36 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1133,7 +1133,7 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
>  	handle_t *handle = NULL;
>  	struct dquot *transfer_to[MAXQUOTAS] = { };
>  	int qtype;
> -	int had_lock;
> +	int had_lock = 0;
>  	struct ocfs2_lock_holder oh;
>  
>  	trace_ocfs2_setattr(inode, dentry,
> 
