From: Joseph Qi <jiangqi903@gmail.com>
Date: Mon, 22 May 2017 17:14:13 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix a static checker warning
In-Reply-To: <1495428877-7440-1-git-send-email-ghe@suse.com>
References: <1495428877-7440-1-git-send-email-ghe@suse.com>
Message-ID: <25bc4d76-b5d2-4ae7-7a1d-78e395b9778d@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gang He <ghe@suse.com>, mfasheh@versity.com, jlbec@evilplan.org
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com



On 17/5/22 12:54, Gang He wrote:
> This patch will fix a static checker warning, this warning was
> caused by commit d56a8f32e4c662509ce50a37e78fa66c777977d3. after
> apply this patch, the error return value will not be NULL(zero).
> 
> Signed-off-by: Gang He <ghe@suse.com>
Reviewed-by: Joseph Qi <jiangqi903@gmail.com>

Thanks,
Joseph
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
> 
