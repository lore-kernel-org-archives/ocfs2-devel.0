From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 18 May 2010 11:50:08 -0700
Subject: [Ocfs2-devel] [PATCH 1/4] Ocfs2: Optimize truncting codes for
	ocfs2 to use ocfs2_remove_btree_range instead.
In-Reply-To: <1273571685-28000-2-git-send-email-tristan.ye@oracle.com>
References: <1273571685-28000-1-git-send-email-tristan.ye@oracle.com>
	<1273571685-28000-2-git-send-email-tristan.ye@oracle.com>
Message-ID: <20100518185008.GH20644@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, May 11, 2010 at 05:54:42PM +0800, Tristan Ye wrote:
> As we known, truncate is just a special case of punching holes(from new i_size
> to end), we therefore could take advantage of existing ocfs2_remove_btree_range()
> codes to reduce the comlexity and redundancy in alloc.c, the goal here is to make
> truncate codes more generic and straightforward.
> 
> Several former functions only used by ocfs2_commit_truncate() will be simply wiped off.
> 
> ocfs2_remove_btree_range() was originally used by punching holes codes, which didn't
> take refcount into account(definitely it's a BUG), we therefore need to change that
> func a bit to handle refcount treee lock, calculate and reserve block for refcount
> tree changes, also decrease refcount at the end, to move these logics in, we needs
> to replace the ocfs2_lock_allocators() by adding a new func ocfs2_reserve_blocks_for_rec_trunc()
> which accepts some extra blocks to reserve. such changes will not hurt any other codes
> who're using ocfs2_remove_btree_range(such as dir truncate and punching holes), actually
> punching holes codes do benefit from this.
> 
> I merge the following steps into one patch since they may be logically doing one thing,
> Though I knew it looks a little bit fat to review.
> 
> 1). Remove redundant codes used by ocfs2_commit_truncate before, since we're moving to
>     ocfs2_remove_btree_range anyway.
> 
> 2). Add a new func ocfs2_reserve_blocks_for_rec_trunc() for purpose of accepting  some
>     extra blocks to reserve.
> 
> 3). Change ocfs2_prepare_refcount_change_for_del() a bit to fit our needs, it's safe to
>     do this since it's only being called by truncating codes.
> 
> 4). Change ocfs2_remove_btree_range() a bit to take refcount case into account.
> 
> 5). Finally, we change ocfs2_commit_truncate() to call ocfs2_remove_btree_range() in
>     a proper way.
> 
> The patch has been tested normally for sanity check, stress tests with heavier workload
> will be expected.
> 
> Based on this patch, our fixing to punching holes bug will be fairly easy.
> 
> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
> ---
>  fs/ocfs2/alloc.c        |  685 +++++++++++------------------------------------

Excellent - that's a lot of redundant code we get to remove  :) Thanks
Tristan for taking this on!


>  fs/ocfs2/alloc.h        |    8 +-
>  fs/ocfs2/dir.c          |    4 +-
>  fs/ocfs2/file.c         |   11 +-
>  fs/ocfs2/inode.c        |    9 +-
>  fs/ocfs2/refcounttree.c |   29 +--
>  fs/ocfs2/refcounttree.h |    4 +-
>  7 files changed, 178 insertions(+), 572 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 0cb2945..0cb4248 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -5587,19 +5587,97 @@ out:
>  	return ret;
>  }
>  
> +/*
> + * ocfs2_reserve_blocks_for_rec_trunc() would look basically the
> + * same as ocfs2_lock_alloctors(), except for it accepts a blocks
> + * number to reserve some extra blocks, and it only handles meta
> + * data allocations.
> + *
> + * Currently, only ocfs2_remove_btree_range() uses it for truncating
> + * and punching holes.
> + */
> +static int ocfs2_reserve_blocks_for_rec_trunc(struct inode *inode,
> +					      struct ocfs2_extent_tree *et,
> +					      u32 extents_to_split,
> +					      struct ocfs2_alloc_context **ac,
> +					      int extra_blocks)
> +{
> +	int ret = 0, num_free_extents;
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
> +		extra_blocks += ocfs2_extend_meta_needed(et->et_root_el);
> +
> +	if (extra_blocks) {
> +		ret = ocfs2_reserve_new_metadata_blocks(osb, extra_blocks, ac);
> +		if (ret < 0) {
> +			if (ret != -ENOSPC)
> +				mlog_errno(ret);

This means we could possibly -ENOSPC while trying to truncate a reflinked
file (to free space perhaps). This problem is out of the scope of your patch
so I'm not asking you to fix it here, but it seems worth noting.



Rest of the patch looks good. The testing results are promising too.

Silly question - did you test that a 'punch hole' for the entire range of a
file produces a result identical to that of truncating the file to zero size?


Acked-by: Mark Fasheh <mfasheh@suse.com>
	--Mark

--
Mark Fasheh
