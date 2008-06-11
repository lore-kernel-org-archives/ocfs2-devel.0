From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 11 Jun 2008 16:31:08 -0700
Subject: [Ocfs2-devel] [PATCH 3/8] Make ocfs2_lock_allocators generic
	for extent	allocation.v1
In-Reply-To: <20080605073240.GA19775@tma-pc2.cn.oracle.com>
References: <484792D1.3080802@oracle.com>
	<20080605073240.GA19775@tma-pc2.cn.oracle.com>
Message-ID: <20080611233108.GN28100@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


[ Btw, patches 1 and 2 looked fine to me ]

On Thu, Jun 05, 2008 at 03:32:40PM +0800, Tao Ma wrote:
> Now ocfs2_lock_allocators is localized to be only used in
> file extend allocation. But the whole function is useful
> when we want to store large EAs. So make it generic.

There's a lot more going on in this patch than your subject line and
description let on about  ;) Next time around, an explanation of the
extent_tree_operations + interface would be nice.


> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> ---
>  fs/ocfs2/alloc.c    |  460 ++++++++++++++++++++++++++++++++-------------------
>  fs/ocfs2/alloc.h    |   23 ++-
>  fs/ocfs2/aops.c     |   11 +-
>  fs/ocfs2/dir.c      |    7 +-
>  fs/ocfs2/file.c     |  104 ++----------
>  fs/ocfs2/file.h     |    4 -
>  fs/ocfs2/suballoc.c |   82 +++++++++
>  fs/ocfs2/suballoc.h |    5 +
>  8 files changed, 418 insertions(+), 278 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index dc844df..71a89b2 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -49,6 +49,94 @@
>  
>  #include "buffer_head_io.h"
>  
> +struct ocfs2_extent_tree_operations {
> +	void (*set_last_eb_blk) (void *et, u64 blkno);
> +	u64 (*get_last_eb_blk) (void *et);
> +	int (*sanity_check) (struct inode *inode, void *et);
> +};

Shouldn't the 'et' argument to these functions be properly typed?

Also, this entire interface should be very well commented.


> @@ -663,7 +745,7 @@ static int ocfs2_add_branch(struct ocfs2_super *osb,
>  	}
>  
>  	/* Link the new branch into the rest of the tree (el will
> -	 * either be on the fe, or the extent block passed in. */
> +	 * either be on the root_bh, or the extent block passed in. */
>  	i = le16_to_cpu(el->l_next_free_rec);
>  	el->l_recs[i].e_blkno = cpu_to_le64(next_blkno);
>  	el->l_recs[i].e_cpos = cpu_to_le32(new_cpos);
> @@ -672,7 +754,7 @@ static int ocfs2_add_branch(struct ocfs2_super *osb,
>  
>  	/* fe needs a new last extent block pointer, as does the
>  	 * next_leaf on the previously last-extent-block. */
> -	fe->i_last_eb_blk = cpu_to_le64(new_last_eb_blk);
> +	et->eops->set_last_eb_blk(et, new_last_eb_blk);

It might be less akward if we had some small wrappers around these calls:

static inline void ocfs2_set_last_eb_blk(struct ocfs2_extent_tree *et,
					u64 new_last_eb_blk)
{
	et->eops->set_last_eb_blk(et, new_last_eb_blk);
}

and the same could be done for ->get_last_eb_blk.


> +static void ocfs2_update_clusters(struct inode *inode,
> +				  struct ocfs2_extent_tree *et,
> +				  u32 clusters)
> +{
> +	if (et->type == OCFS2_DINODE_EXTENT) {
> +		struct ocfs2_dinode *di =
> +			(struct ocfs2_dinode *)et->root_bh->b_data;
> +		ocfs2_update_dinode_clusters(inode, di, clusters);
> +	}
> +}

Shouldn't 'update clusters' be an ocfs2_extent_tree_operation?


The rest of this looks good. It's a big patch, but it looks good :) The only
conern I have isn't really with your code per se, but with layout of our
source files. Alloc.c keeps growing... and growing... and growing... At some
point it might be worth our while to split things out at least so that we
have a 'core btree operations' file.
	--Mark

--
Mark Fasheh
