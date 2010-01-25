From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 25 Jan 2010 10:12:34 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Treat ocfs2 truncate as a
 special case of punching holes v1.
In-Reply-To: <1264148107-9341-1-git-send-email-tristan.ye@oracle.com>
References: <1264148107-9341-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <4B5CFE12.9010503@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Tristan,
	Thanks for the work.
	Some comments inlined.

Tristan Ye wrote:
> As we known, truncate is just a special case of punching holes(from new i_size
> to end), we therefore could take advantage of existing ocfs2_remove_extent() codes
> to reduce the comlexity and redundancy in alloc.c, the goal here is to make truncate
> codes more generic and straightforward.
> 
> Several former functions only used by ocfs2_commit_truncate() will be simply wiped off.
> New logic for truncating will remove extents from truncate_size to file end one by one,
> just like punching holes did.
> 
> v1 patch didn't include the codes for refcount supporting in truncate and holes punching,
> it will be added in next series.
> 
> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
> ---
>  fs/ocfs2/alloc.c |  630 ++++--------------------------------------------------
>  1 files changed, 40 insertions(+), 590 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 38a42f5..8598452 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
<snip>
> @@ -7409,198 +6986,73 @@ int ocfs2_commit_truncate(struct ocfs2_super *osb,
>  			  struct buffer_head *fe_bh,
>  			  struct ocfs2_truncate_context *tc)
>  {
> -	int status, i, credits, tl_sem = 0;
> -	u32 clusters_to_del, new_highest_cpos, range;
> -	u64 blkno = 0;
> -	struct ocfs2_extent_list *el;
> -	handle_t *handle = NULL;
> -	struct inode *tl_inode = osb->osb_tl_inode;
> -	struct ocfs2_path *path = NULL;
> +	int status, i;
> +	u32 trunc_start, trunc_end, trunc_len, cpos, phys_cpos, alloc_size;
>  	struct ocfs2_dinode *di = (struct ocfs2_dinode *)fe_bh->b_data;
> -	struct ocfs2_alloc_context *meta_ac = NULL;
> -	struct ocfs2_refcount_tree *ref_tree = NULL;
> +	struct ocfs2_extent_tree et;
> +	struct buffer_head *eb_bh;
> +	struct ocfs2_extent_block *last_eb;
> +	struct ocfs2_extent_list *el;
>  
>  	mlog_entry_void();
>  
> -	new_highest_cpos = ocfs2_clusters_for_bytes(osb->sb,
> -						     i_size_read(inode));
> -
> -	path = ocfs2_new_path(fe_bh, &di->id2.i_list,
> -			      ocfs2_journal_access_di);
> -	if (!path) {
> -		status = -ENOMEM;
> -		mlog_errno(status);
> -		goto bail;
> -	}
> -
> -	ocfs2_extent_map_trunc(inode, new_highest_cpos);
> +	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), fe_bh);
>  
> -start:
> -	/*
> -	 * Check that we still have allocation to delete.
> -	 */
> -	if (OCFS2_I(inode)->ip_clusters == 0) {
> -		status = 0;
> -		goto bail;
> -	}
> -
> -	credits = 0;
> -
> -	/*
> -	 * Truncate always works against the rightmost tree branch.
> -	 */
> -	status = ocfs2_find_path(INODE_CACHE(inode), path, UINT_MAX);
> -	if (status) {
> -		mlog_errno(status);
> -		goto bail;
> -	}
> -
> -	mlog(0, "inode->ip_clusters = %u, tree_depth = %u\n",
> -	     OCFS2_I(inode)->ip_clusters, path->p_tree_depth);
> -
> -	/*
> -	 * By now, el will point to the extent list on the bottom most
> -	 * portion of this tree. Only the tail record is considered in
> -	 * each pass.
> -	 *
> -	 * We handle the following cases, in order:
> -	 * - empty extent: delete the remaining branch
> -	 * - remove the entire record
> -	 * - remove a partial record
> -	 * - no record needs to be removed (truncate has completed)
> -	 */
> -	el = path_leaf_el(path);
> -	if (le16_to_cpu(el->l_next_free_rec) == 0) {
> -		ocfs2_error(inode->i_sb,
> -			    "Inode %llu has empty extent block at %llu\n",
> -			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
> -			    (unsigned long long)path_leaf_bh(path)->b_blocknr);
> -		status = -EROFS;
> -		goto bail;
> -	}
> +	trunc_start = ocfs2_clusters_for_bytes(osb->sb, i_size_read(inode));
> +	if (le64_to_cpu(di->i_last_eb_blk)) {
> +		eb_bh = tc->tc_last_eb_bh;
> +		last_eb = (struct ocfs2_extent_block *)eb_bh->b_data;
> +		el = &last_eb->h_list;
why not just check tc->tc_last_eb_bh? It is more readable. Say you check 
tc_last_eb_bh and then it has value, set el to it. btw, do we really 
need eb_bh? Minor issue.
> +	} else
> +		el = &di->id2.i_list;
>  
>  	i = le16_to_cpu(el->l_next_free_rec) - 1;
> -	range = le32_to_cpu(el->l_recs[i].e_cpos) +
> -		ocfs2_rec_clusters(el, &el->l_recs[i]);
> -	if (i == 0 && ocfs2_is_empty_extent(&el->l_recs[i])) {
> -		clusters_to_del = 0;
> -	} else if (le32_to_cpu(el->l_recs[i].e_cpos) >= new_highest_cpos) {
> -		clusters_to_del = ocfs2_rec_clusters(el, &el->l_recs[i]);
> -		blkno = le64_to_cpu(el->l_recs[i].e_blkno);
> -	} else if (range > new_highest_cpos) {
> -		clusters_to_del = (ocfs2_rec_clusters(el, &el->l_recs[i]) +
> -				   le32_to_cpu(el->l_recs[i].e_cpos)) -
> -				  new_highest_cpos;
> -		blkno = le64_to_cpu(el->l_recs[i].e_blkno) +
> -			ocfs2_clusters_to_blocks(inode->i_sb,
> -				ocfs2_rec_clusters(el, &el->l_recs[i]) -
> -				clusters_to_del);
> -	} else {
> -		status = 0;
> -		goto bail;
> -	}
>  
> -	mlog(0, "clusters_to_del = %u in this pass, tail blk=%llu\n",
> -	     clusters_to_del, (unsigned long long)path_leaf_bh(path)->b_blocknr);
> +	trunc_end = le32_to_cpu(el->l_recs[i].e_cpos) +
> +			ocfs2_rec_clusters(el, &el->l_recs[i]);
>  
> -	if (el->l_recs[i].e_flags & OCFS2_EXT_REFCOUNTED && clusters_to_del) {
> -		BUG_ON(!(OCFS2_I(inode)->ip_dyn_features &
> -			 OCFS2_HAS_REFCOUNT_FL));
> +	if (trunc_end >= trunc_start)
> +		trunc_len = trunc_end - trunc_start;
> +	else
> +		trunc_len = 0;
>  
> -		status = ocfs2_lock_refcount_tree(osb,
> -						le64_to_cpu(di->i_refcount_loc),
> -						1, &ref_tree, NULL);
> -		if (status) {
> -			mlog_errno(status);
> -			goto bail;
> -		}
> +	cpos = trunc_start;
> +	while (trunc_len) {
>  
> -		status = ocfs2_prepare_refcount_change_for_del(inode, fe_bh,
> -							       blkno,
> -							       clusters_to_del,
> -							       &credits,
> -							       &meta_ac);
> -		if (status < 0) {
> -			mlog_errno(status);
> +		if (OCFS2_I(inode)->ip_clusters == 0) {
> +			status = 0;
>  			goto bail;
>  		}
> -	}
>  
> -	mutex_lock(&tl_inode->i_mutex);
> -	tl_sem = 1;
> -	/* ocfs2_truncate_log_needs_flush guarantees us at least one
> -	 * record is free for use. If there isn't any, we flush to get
> -	 * an empty truncate log.  */
> -	if (ocfs2_truncate_log_needs_flush(osb)) {
> -		status = __ocfs2_flush_truncate_log(osb);
> -		if (status < 0) {
> +		status = ocfs2_get_clusters(inode, cpos, &phys_cpos,
> +					    &alloc_size, NULL);
> +		if (status) {
>  			mlog_errno(status);
>  			goto bail;
>  		}
> -	}
>  
> -	credits += ocfs2_calc_tree_trunc_credits(osb->sb, clusters_to_del,
> -						(struct ocfs2_dinode *)fe_bh->b_data,
> -						el);
> -	handle = ocfs2_start_trans(osb, credits);
> -	if (IS_ERR(handle)) {
> -		status = PTR_ERR(handle);
> -		handle = NULL;
> -		mlog_errno(status);
> -		goto bail;
> -	}
> +		if (alloc_size > trunc_len)
> +			alloc_size = trunc_len;
>  
> -	status = ocfs2_do_truncate(osb, clusters_to_del, inode, fe_bh, handle,
> -				   tc, path, meta_ac);
> -	if (status < 0) {
> -		mlog_errno(status);
> -		goto bail;
> -	}
> -
> -	mutex_unlock(&tl_inode->i_mutex);
> -	tl_sem = 0;
> -
> -	ocfs2_commit_trans(osb, handle);
> -	handle = NULL;
> -
> -	ocfs2_reinit_path(path, 1);
> -
> -	if (meta_ac) {
> -		ocfs2_free_alloc_context(meta_ac);
> -		meta_ac = NULL;
> -	}
> +		if (phys_cpos != 0) {
> +			status = ocfs2_remove_btree_range(inode, &et, cpos,
> +							  phys_cpos, alloc_size,
> +							  &tc->tc_dealloc);
> +			if (status) {
> +				mlog_errno(status);
> +				goto bail;
> +			}
> +		}
I would really appreciate it if we can start from the end to the 
beginning. You know, if we start from cpos, when we remove an extent, 
the b-tree codes will try to rotate_tree_left. So if there are many 
extents for us to truncate, the performance will decrease a lot. While 
in the old implementation, we remove extents from the tail, so no b-tree 
rotation at all.

Regards,
Tao
