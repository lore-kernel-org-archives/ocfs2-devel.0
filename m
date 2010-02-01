From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 01 Feb 2010 11:30:01 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Optimize truncting codes for
 ocfs2 to use ocfs2_remove_btree_range instead.
In-Reply-To: <1264671228-2077-1-git-send-email-tristan.ye@oracle.com>
References: <1264671228-2077-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <4B664AB9.1040202@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Tristan,
	Sorry for the delay. This patch looks good. Just some minor comments.

Tristan Ye wrote:
<snip>
>  int ocfs2_commit_truncate(struct ocfs2_super *osb,
>  			  struct inode *inode,
> -			  struct buffer_head *fe_bh,
> -			  struct ocfs2_truncate_context *tc)
> +			  struct buffer_head *fe_bh)
>  {
> -	int status, i, credits, tl_sem = 0;
> -	u32 clusters_to_del, new_highest_cpos, range;
> +	int status = 0, i, flags = 0;
> +	u32 new_highest_cpos, range, trunc_cpos, trunc_len, phys_cpos, coff;
>  	u64 blkno = 0;
> +
Why you always want to separate the declaration with blank lines? I have 
never seen such one in the original codes. So please remove this 
redundant line. The same goes for the following codes.
>  	struct ocfs2_extent_list *el;
> -	handle_t *handle = NULL;
> -	struct inode *tl_inode = osb->osb_tl_inode;
> +	struct ocfs2_extent_rec *rec;
>  	struct ocfs2_path *path = NULL;
>  	struct ocfs2_dinode *di = (struct ocfs2_dinode *)fe_bh->b_data;
> -	struct ocfs2_alloc_context *meta_ac = NULL;
> -	struct ocfs2_refcount_tree *ref_tree = NULL;
> +	u64 refcount_loc = le64_to_cpu(di->i_refcount_loc);
> +
> +	struct ocfs2_extent_tree et;
> +	struct ocfs2_cached_dealloc_ctxt dealloc;
>  
>  	mlog_entry_void();
> +	
> +	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), fe_bh);
> +	ocfs2_init_dealloc_ctxt(&dealloc);
>  
>  	new_highest_cpos = ocfs2_clusters_for_bytes(osb->sb,
>  						     i_size_read(inode));
> @@ -7433,8 +7110,6 @@ int ocfs2_commit_truncate(struct ocfs2_super *osb,
>  		goto bail;
>  	}
>  
> -	ocfs2_extent_map_trunc(inode, new_highest_cpos);
> -
I remembered that I have said this line should be reserved.
Oh, I just checked the previous e-mail and you replied "I guess it's 
safe to remove extent map here, since ocfs2_remove_extent() will do the 
same. ". This isn't right.
Check the ocfs2_remove_extent, and the code looks like this:
	/*
  	 * XXX: Why are we truncating to 0 instead of wherever this
	 * affects us?
	 */
	ocfs2_et_extent_map_truncate(et, 0);
So you see, it is "XXX", and we may change it somehow later. We can't 
trust it.

>  start:
>  	/*
>  	 * Check that we still have allocation to delete.
> @@ -7444,8 +7119,6 @@ start:
>  		goto bail;
>  	}
>  
> -	credits = 0;
> -
>  	/*
>  	 * Truncate always works against the rightmost tree branch.
>  	 */
> @@ -7480,101 +7153,56 @@ start:
>  	}
>  
>  	i = le16_to_cpu(el->l_next_free_rec) - 1;
> -	range = le32_to_cpu(el->l_recs[i].e_cpos) +
> -		ocfs2_rec_clusters(el, &el->l_recs[i]);
> -	if (i == 0 && ocfs2_is_empty_extent(&el->l_recs[i])) {
> -		clusters_to_del = 0;
> -	} else if (le32_to_cpu(el->l_recs[i].e_cpos) >= new_highest_cpos) {
> -		clusters_to_del = ocfs2_rec_clusters(el, &el->l_recs[i]);
> -		blkno = le64_to_cpu(el->l_recs[i].e_blkno);
> +	rec = &el->l_recs[i];
> +	flags = rec->e_flags;
> +	range = le32_to_cpu(rec->e_cpos) + ocfs2_rec_clusters(el, rec);
> +
> +	if (i == 0 && ocfs2_is_empty_extent(rec)) {
> +		/*
> +		 * Should remove this extent block.
> +		 */
> +		trunc_cpos = le32_to_cpu(rec->e_cpos);
> +		trunc_len = 0;
> +		coff = 0;
> +		blkno = 0;
In this case, I guess we need to work like the original ocfs2_do_truncate:
	/*
	 * Lower levels depend on this never happening, but it's best
	 * to check it up here before changing the tree.
	 */
	if (el->l_tree_depth && el->l_recs[0].e_int_clusters == 0) {
		ocfs2_error(inode->i_sb,
			    "Inode %lu has an empty extent record, depth %u\n",
			    inode->i_ino, le16_to_cpu(el->l_tree_depth));
		status = -EROFS;
		goto bail;
	}
> +	} else if (le32_to_cpu(rec->e_cpos) >= new_highest_cpos) {
> +		/* 
> +		 * Truncate entire record.
> +		 */
> +		trunc_cpos = le32_to_cpu(rec->e_cpos);
> +		trunc_len = ocfs2_rec_clusters(el, rec);
> +		coff = 0;
I just notice you only use coff in the below "else if"? Please remove it.
> +		blkno = le64_to_cpu(rec->e_blkno);
>  	} else if (range > new_highest_cpos) {
> -		clusters_to_del = (ocfs2_rec_clusters(el, &el->l_recs[i]) +
> -				   le32_to_cpu(el->l_recs[i].e_cpos)) -
> -				  new_highest_cpos;
> -		blkno = le64_to_cpu(el->l_recs[i].e_blkno) +
> -			ocfs2_clusters_to_blocks(inode->i_sb,
> -				ocfs2_rec_clusters(el, &el->l_recs[i]) -
> -				clusters_to_del);
> +		/*
> +		 * Partial truncate. it also should be
> +		 * the last truncate we're doing.
> +		 */
> +		trunc_cpos = new_highest_cpos;
> +		trunc_len = range - new_highest_cpos;
> +		coff = new_highest_cpos - le32_to_cpu(rec->e_cpos);
> +		blkno = le64_to_cpu(rec->e_blkno) +
> +				ocfs2_clusters_to_blocks(inode->i_sb, coff);
>  	} else {
> +		/*
> +		 * Truncate completed, leave happily.
> +		 */
>  		status = 0;
>  		goto bail;
>  	}

Regards,
Tao
