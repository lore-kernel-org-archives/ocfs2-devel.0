From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 23 May 2017 15:30:23 -0700
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: fix a static checker warning
In-Reply-To: <1495516634-1952-1-git-send-email-ghe@suse.com>
References: <1495516634-1952-1-git-send-email-ghe@suse.com>
Message-ID: <20170523153023.9831db2fd6d5403445509cf3@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gang He <ghe@suse.com>
Cc: mfasheh@versity.com, jlbec@evilplan.org, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Tue, 23 May 2017 13:17:14 +0800 Gang He <ghe@suse.com> wrote:

> This patch will fix a static code checker warning, which looks 
> like below,
> fs/ocfs2/inode.c:179 ocfs2_iget()
> warn: passing zero to 'ERR_PTR'
> 
> this warning was caused by the 
> commit d56a8f32e4c6 ("ocfs2: check/fix inode block for online file check").
> after apply this patch, the error return value will not be NULL(zero).
> 
> Signed-off-by: Gang He <ghe@suse.com>
> ---
>  fs/ocfs2/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 382401d..1a1e007 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -136,7 +136,7 @@ struct inode *ocfs2_ilookup(struct super_block *sb, u64 blkno)
>  struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
>  			 int sysfile_type)
>  {
> -	int rc = 0;
> +	int rc = -ESTALE;
>  	struct inode *inode = NULL;
>  	struct super_block *sb = osb->sb;
>  	struct ocfs2_find_inode_args args;

hm, OK, thanks.  The resulting code still looks rather weird.  Could
someone who works in this area please take a look?
