From: Mark Fasheh <mfasheh@suse.de>
Date: Mon, 31 Aug 2015 14:31:17 -0700
Subject: [Ocfs2-devel] [patch 09/28] ocfs2: extend transaction for
 ocfs2_remove_rightmost_path() and ocfs2_update_edge_lengths() before to
 avoid inconsistency between inode and et
In-Reply-To: <55de399f.yPaGHMUq09ui5Z7/%akpm@linux-foundation.org>
References: <55de399f.yPaGHMUq09ui5Z7/%akpm@linux-foundation.org>
Message-ID: <20150831213117.GE1145@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Aug 26, 2015 at 03:11:43PM -0700, Andrew Morton wrote:
> From: Xue jiufei <xuejiufei@huawei.com>
> Subject: ocfs2: extend transaction for ocfs2_remove_rightmost_path() and ocfs2_update_edge_lengths() before to avoid inconsistency between inode and et
> 
> I found that jbd2_journal_restart() is called in some places without
> keeping things consistently before.  However, jbd2_journal_restart() may
> commit the handle's transaction and restart another one.  If the first
> transaction is committed successfully while another not, it may cause
> filesystem inconsistency or read only.  This is an effort to fix this kind
> of problems.
> 
> 
> This patch (of 3):
> 
> The following functions will be called while truncating an extent:
> ocfs2_remove_btree_range
>   -> ocfs2_start_trans
>   -> ocfs2_remove_extent
>      -> ocfs2_truncate_rec
>        -> ocfs2_extend_rotate_transaction
>          -> jbd2_journal_restart if jbd2_journal_extend fail
>        -> ocfs2_rotate_tree_left
>          -> ocfs2_remove_rightmost_path
>              -> ocfs2_extend_rotate_transaction
>                -> ocfs2_unlink_subtree
>                 -> ocfs2_update_edge_lengths
>                   -> ocfs2_extend_trans
>                     -> jbd2_journal_restart if jbd2_journal_extend fail
>   -> ocfs2_et_update_clusters
>   -> ocfs2_commit_trans
> 
> jbd2_journal_restart() may be called and it may happened that the buffers
> dirtied in ocfs2_truncate_rec() are committed while buffers dirtied in
> ocfs2_et_update_clusters() are not, the total clusters on extent tree and
> i_clusters in ocfs2_dinode is inconsistency.  So the clusters got from
> ocfs2_dinode is incorrect, and it also cause read-only problem when call
> ocfs2_commit_truncate() with the error message: "Inode %llu has empty
> extent block at %llu".
> 
> We should extend enough credits for function ocfs2_remove_rightmost_path
> and ocfs2_update_edge_lengths to avoid this inconsistency.
> 
> Signed-off-by: joyce.xue <xuejiufei@huawei.com>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/ocfs2/alloc.c |   82 +++++++++++++++++++++++++++++----------------
>  1 file changed, 54 insertions(+), 28 deletions(-)
> 
> diff -puN fs/ocfs2/alloc.c~ocfs2-extend-transaction-for-ocfs2_remove_rightmost_path-and-ocfs2_update_edge_lengths-before-to-avoid-inconsistency-between-inode-and-et fs/ocfs2/alloc.c
> --- a/fs/ocfs2/alloc.c~ocfs2-extend-transaction-for-ocfs2_remove_rightmost_path-and-ocfs2_update_edge_lengths-before-to-avoid-inconsistency-between-inode-and-et
> +++ a/fs/ocfs2/alloc.c
> @@ -2526,21 +2526,6 @@ static int ocfs2_update_edge_lengths(han
>  	struct ocfs2_extent_block *eb;
>  	u32 range;
>  
> -	/*
> -	 * In normal tree rotation process, we will never touch the
> -	 * tree branch above subtree_index and ocfs2_extend_rotate_transaction
> -	 * doesn't reserve the credits for them either.
> -	 *
> -	 * But we do have a special case here which will update the rightmost
> -	 * records for all the bh in the path.
> -	 * So we have to allocate extra credits and access them.
> -	 */
> -	ret = ocfs2_extend_trans(handle, subtree_index);
> -	if (ret) {
> -		mlog_errno(ret);
> -		goto out;
> -	}
> -
>  	ret = ocfs2_journal_access_path(et->et_ci, handle, path);
>  	if (ret) {
>  		mlog_errno(ret);
> @@ -2967,7 +2952,7 @@ static int __ocfs2_rotate_tree_left(hand
>  		     right_path->p_node[subtree_root].bh->b_blocknr,
>  		     right_path->p_tree_depth);
>  
> -		ret = ocfs2_extend_rotate_transaction(handle, subtree_root,
> +		ret = ocfs2_extend_rotate_transaction(handle, 0,

I don't understand why you changed the subtree depth parameter here to zero.

Also, I don't understand why it's zero in all the calls below either. Is
there something wrong with the way the math in
ocfs2_extend_rotate_transaction() is working out?


>  						      orig_credits, left_path);
>  		if (ret) {
>  			mlog_errno(ret);
> @@ -3040,21 +3025,9 @@ static int ocfs2_remove_rightmost_path(h
>  	struct ocfs2_extent_block *eb;
>  	struct ocfs2_extent_list *el;
>  
> -
>  	ret = ocfs2_et_sanity_check(et);
>  	if (ret)
>  		goto out;
> -	/*
> -	 * There's two ways we handle this depending on
> -	 * whether path is the only existing one.
> -	 */
> -	ret = ocfs2_extend_rotate_transaction(handle, 0,
> -					      handle->h_buffer_credits,
> -					      path);
> -	if (ret) {
> -		mlog_errno(ret);
> -		goto out;
> -	}
>  
>  	ret = ocfs2_journal_access_path(et->et_ci, handle, path);
>  	if (ret) {
> @@ -3628,6 +3601,14 @@ static int ocfs2_merge_rec_left(struct o
>  		 */
>  		if (le16_to_cpu(right_rec->e_leaf_clusters) == 0 &&
>  		    le16_to_cpu(el->l_next_free_rec) == 1) {
> +			/* extend credit for ocfs2_remove_rightmost_path */
> +			ret = ocfs2_extend_rotate_transaction(handle, 0,
> +					handle->h_buffer_credits,
> +					right_path);
> +			if (ret) {
> +				mlog_errno(ret);
> +				goto out;
> +			}
>  
>  			ret = ocfs2_remove_rightmost_path(handle, et,
>  							  right_path,
> @@ -3666,6 +3647,14 @@ static int ocfs2_try_to_merge_extent(han
>  	BUG_ON(ctxt->c_contig_type == CONTIG_NONE);
>  
>  	if (ctxt->c_split_covers_rec && ctxt->c_has_empty_extent) {
> +		/* extend credit for ocfs2_remove_rightmost_path */
> +		ret = ocfs2_extend_rotate_transaction(handle, 0,
> +				handle->h_buffer_credits,
> +				path);
> +		if (ret) {
> +			mlog_errno(ret);
> +			goto out;
> +		}
>  		/*
>  		 * The merge code will need to create an empty
>  		 * extent to take the place of the newly
> @@ -3714,6 +3703,15 @@ static int ocfs2_try_to_merge_extent(han
>  		 */
>  		BUG_ON(!ocfs2_is_empty_extent(&el->l_recs[0]));
>  
> +		/* extend credit for ocfs2_remove_rightmost_path */
> +		ret = ocfs2_extend_rotate_transaction(handle, 0,
> +					handle->h_buffer_credits,
> +					path);
> +		if (ret) {
> +			mlog_errno(ret);
> +			goto out;
> +		}
> +
>  		/* The merge left us with an empty extent, remove it. */
>  		ret = ocfs2_rotate_tree_left(handle, et, path, dealloc);
>  		if (ret) {

A few of these were added, where we do the transaction extend before calling
ocfs2_rotate_tree_left(), can we move the call into ocfs2_rotate_tree_left()
then?

Thanks,
	--Mark

--
Mark Fasheh
