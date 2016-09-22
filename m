From: Eric Ren <zren@suse.com>
Date: Thu, 22 Sep 2016 09:13:22 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix undefined struct variable in
 inode.h
In-Reply-To: <57E1E49D.8050503@huawei.com>
References: <57E1E49D.8050503@huawei.com>
Message-ID: <41cf826a-9a2c-c757-e9a9-8259a0393737@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

On 09/21/2016 09:38 AM, Joseph Qi wrote:
> The extern struct variable ocfs2_inode_cache is not defined. It meant to
> use ocfs2_inode_cachep defined in super.c, I think. Fortunately it is
> not used anywhere now, so no impact actually. Clean it up to fix this
> mistake.
>
> Signed-off-by: Joseph Qi <joseph.qi@huawei.com>

LGTM
Reviewed-by: Eric Ren<zren@suse.com>

> ---
>   fs/ocfs2/inode.h | 2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
> index 50cc550..5af68fc 100644
> --- a/fs/ocfs2/inode.h
> +++ b/fs/ocfs2/inode.h
> @@ -123,8 +123,6 @@ static inline struct ocfs2_inode_info *OCFS2_I(struct inode *inode)
>   #define INODE_JOURNAL(i) (OCFS2_I(i)->ip_flags & OCFS2_INODE_JOURNAL)
>   #define SET_INODE_JOURNAL(i) (OCFS2_I(i)->ip_flags |= OCFS2_INODE_JOURNAL)
>
> -extern struct kmem_cache *ocfs2_inode_cache;
> -
>   extern const struct address_space_operations ocfs2_aops;
>   extern const struct ocfs2_caching_operations ocfs2_inode_caching_ops;
>

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20160922/d0acd4f0/attachment.html 
