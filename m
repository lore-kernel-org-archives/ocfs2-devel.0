From: Jan Kara <jack@suse.cz>
Date: Mon, 4 Jan 2016 10:59:21 +0100
Subject: [Ocfs2-devel] [PATCH] quota: constify qtree_fmt_operations
	structures
In-Reply-To: <1451634817-1903-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1451634817-1903-1-git-send-email-Julia.Lawall@lip6.fr>
Message-ID: <20160104095921.GA13014@quack.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Jan Kara <jack@suse.com>, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com

On Fri 01-01-16 08:53:37, Julia Lawall wrote:
> The qtree_fmt_operations structures are never modified, so declare them as
> const.
> 
> Done with the help of Coccinelle.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Thanks! I've merged the patch to my tree.

								Honza
> 
> ---
>  fs/ocfs2/quota.h            |    2 +-
>  fs/ocfs2/quota_global.c     |    2 +-
>  fs/quota/quota_v2.c         |    4 ++--
>  include/linux/dqblk_qtree.h |    2 +-
>  4 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/dqblk_qtree.h b/include/linux/dqblk_qtree.h
> index 82a1652..ff8b553 100644
> --- a/include/linux/dqblk_qtree.h
> +++ b/include/linux/dqblk_qtree.h
> @@ -34,7 +34,7 @@ struct qtree_mem_dqinfo {
>  	unsigned int dqi_entry_size;	/* Size of quota entry in quota file */
>  	unsigned int dqi_usable_bs;	/* Space usable in block for quota data */
>  	unsigned int dqi_qtree_depth;	/* Precomputed depth of quota tree */
> -	struct qtree_fmt_operations *dqi_ops;	/* Operations for entry manipulation */
> +	const struct qtree_fmt_operations *dqi_ops; /* Operations for entry manipulation */
>  };
>  
>  int qtree_write_dquot(struct qtree_mem_dqinfo *info, struct dquot *dquot);
> diff --git a/fs/quota/quota_v2.c b/fs/quota/quota_v2.c
> index 2aa012a..ed85d4f 100644
> --- a/fs/quota/quota_v2.c
> +++ b/fs/quota/quota_v2.c
> @@ -30,13 +30,13 @@ static void v2r1_mem2diskdqb(void *dp, struct dquot *dquot);
>  static void v2r1_disk2memdqb(struct dquot *dquot, void *dp);
>  static int v2r1_is_id(void *dp, struct dquot *dquot);
>  
> -static struct qtree_fmt_operations v2r0_qtree_ops = {
> +static const struct qtree_fmt_operations v2r0_qtree_ops = {
>  	.mem2disk_dqblk = v2r0_mem2diskdqb,
>  	.disk2mem_dqblk = v2r0_disk2memdqb,
>  	.is_id = v2r0_is_id,
>  };
>  
> -static struct qtree_fmt_operations v2r1_qtree_ops = {
> +static const struct qtree_fmt_operations v2r1_qtree_ops = {
>  	.mem2disk_dqblk = v2r1_mem2diskdqb,
>  	.disk2mem_dqblk = v2r1_disk2memdqb,
>  	.is_id = v2r1_is_id,
> diff --git a/fs/ocfs2/quota.h b/fs/ocfs2/quota.h
> index b6d5133..d153e6e 100644
> --- a/fs/ocfs2/quota.h
> +++ b/fs/ocfs2/quota.h
> @@ -82,7 +82,7 @@ struct ocfs2_quota_chunk {
>  extern struct kmem_cache *ocfs2_dquot_cachep;
>  extern struct kmem_cache *ocfs2_qf_chunk_cachep;
>  
> -extern struct qtree_fmt_operations ocfs2_global_ops;
> +extern const struct qtree_fmt_operations ocfs2_global_ops;
>  
>  struct ocfs2_quota_recovery *ocfs2_begin_quota_recovery(
>  				struct ocfs2_super *osb, int slot_num);
> diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
> index 44df24b..f0c7ae1 100644
> --- a/fs/ocfs2/quota_global.c
> +++ b/fs/ocfs2/quota_global.c
> @@ -123,7 +123,7 @@ static int ocfs2_global_is_id(void *dp, struct dquot *dquot)
>  		      dquot->dq_id);
>  }
>  
> -struct qtree_fmt_operations ocfs2_global_ops = {
> +const struct qtree_fmt_operations ocfs2_global_ops = {
>  	.mem2disk_dqblk = ocfs2_global_mem2diskdqb,
>  	.disk2mem_dqblk = ocfs2_global_disk2memdqb,
>  	.is_id = ocfs2_global_is_id,
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
