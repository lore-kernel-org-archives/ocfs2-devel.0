From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Tue, 10 Sep 2019 14:45:03 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix passing zero to 'PTR_ERR'
	warning
In-Reply-To: <1568023466-1486-1-git-send-email-dingxiang@cmss.chinamobile.com>
References: <1568023466-1486-1-git-send-email-dingxiang@cmss.chinamobile.com>
Message-ID: <1dee278b-6c96-eec2-ce76-fe6e07c6e20f@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ding Xiang <dingxiang@cmss.chinamobile.com>, mark@fasheh.com, jlbec@evilplan.org, Andrew Morton <akpm@linux-foundation.org>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org


On 19/9/9 18:04, Ding Xiang wrote:
> Fix a static code checker warning:
> fs/ocfs2/acl.c:331
> 	ocfs2_acl_chmod() warn: passing zero to 'PTR_ERR'
> 
> Fixes: 5ee0fbd50fd ("ocfs2: revert using ocfs2_acl_chmod to avoid inode cluster lock hang")
> Signed-off-by: Ding Xiang <dingxiang@cmss.chinamobile.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/acl.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
> index 3e7da39..bb981ec 100644
> --- a/fs/ocfs2/acl.c
> +++ b/fs/ocfs2/acl.c
> @@ -327,8 +327,8 @@ int ocfs2_acl_chmod(struct inode *inode, struct buffer_head *bh)
>  	down_read(&OCFS2_I(inode)->ip_xattr_sem);
>  	acl = ocfs2_get_acl_nolock(inode, ACL_TYPE_ACCESS, bh);
>  	up_read(&OCFS2_I(inode)->ip_xattr_sem);
> -	if (IS_ERR(acl) || !acl)
> -		return PTR_ERR(acl);
> +	if (IS_ERR_OR_NULL(acl))
> +		return PTR_ERR_OR_ZERO(acl);
>  	ret = __posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
>  	if (ret)
>  		return ret;
> 
