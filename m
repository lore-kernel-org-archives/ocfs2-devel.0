From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 10 May 2010 12:40:06 -0700
Subject: [Ocfs2-devel] [PATCH 1/4] Ocfs2: Optimize truncting codes for
 ocfs2 to use ocfs2_remove_btree_range instead.
In-Reply-To: <1273128618-4184-1-git-send-email-tristan.ye@oracle.com>
References: <1273128618-4184-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <20100510194006.GA2836@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, May 06, 2010 at 02:50:15PM +0800, Tristan Ye wrote:
> The patch has been tested normally for sanity check, stress tests with heavier workload
> will be expected.

	The patch looks functionally good.  A couple housekeeping
comments.

> +static int ocfs2_reserve_blocks_for_rec_trunc(struct inode *inode,
> +					      struct ocfs2_extent_tree *et,
> +					      u32 extents_to_split,
> +					      struct ocfs2_alloc_context **ac,
> +					      int extra_blocks)
> +{
> +	int ret = 0, num_free_extents, blocks = extra_blocks;
> +	unsigned int max_recs_needed = 2 * extents_to_split;
> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +
> +	*ac = NULL;
> +
> +	num_free_extents = ocfs2_num_free_extents(osb, et);
> +	if (num_free_extents < 0) {
> +		ret = num_free_extents;
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +
> +	if (!num_free_extents ||
> +	    (ocfs2_sparse_alloc(osb) && num_free_extents < max_recs_needed))
> +		blocks += ocfs2_extend_meta_needed(et->et_root_el);

	You don't need the blocks variable.  Just use extra_blocks here.
Save us a word on the stack.

>  int ocfs2_remove_btree_range(struct inode *inode,
>  			     struct ocfs2_extent_tree *et,
>  			     u32 cpos, u32 phys_cpos, u32 len,

	Move flags here:     u32 cpos, u32 phys_cpos, u32 len, int flags,

> -			     struct ocfs2_cached_dealloc_ctxt *dealloc)
> +			     struct ocfs2_cached_dealloc_ctxt *dealloc,
> +			     u64 refcount_loc, int flags)

It fits with the tuple representing the extent range.

> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> index 33dd2a1..cabdcf8 100644
> --- a/fs/ocfs2/refcounttree.c
> +++ b/fs/ocfs2/refcounttree.c
> @@ -2508,21 +2508,20 @@ out:
>   * we gonna touch and whether we need to create new blocks.
>   *
>   * Normally the refcount blocks store these refcount should be
> - * contiguous also, so that we can get the number easily.
> - * As for meta_ac, we will at most add split 2 refcount record and
> - * 2 more refcount block, so just check it in a rough way.
> + * continguous also, so that we can get the number easily.

	Whoops, you misspelled 'contiguous' here.

Joel

-- 

"You cannot bring about prosperity by discouraging thrift. You cannot
 strengthen the weak by weakening the strong. You cannot help the wage
 earner by pulling down the wage payer. You cannot further the
 brotherhood of man by encouraging class hatred. You cannot help the
 poor by destroying the rich. You cannot build character and courage by
 taking away a man's initiative and independence. You cannot help men
 permanently by doing for them what they could and should do for
 themselves."
	- Abraham Lincoln 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
