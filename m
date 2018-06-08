From: Joseph Qi <jiangqi903@gmail.com>
Date: Fri, 8 Jun 2018 11:17:04 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: return -EROFS when filesystem
	becomes read-only
In-Reply-To: <5B191B26.9010501@huawei.com>
References: <5B191B26.9010501@huawei.com>
Message-ID: <228cfcfb-d57e-2125-adcf-033810aae164@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 18/6/7 19:46, piaojun wrote:
> We should return -EROFS rather than other errno if filesystem becomes
> read-only.
> 
> Signed-off-by: Jun Piao <piaojun@huawei.com>
> Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>

Acked-by: Joseph Qi <jiangqi903@gmail.com>
> ---
>  fs/ocfs2/alloc.c       | 43 +++++++++++++++++++------------------------
>  fs/ocfs2/localalloc.c  |  9 ++++-----
>  fs/ocfs2/quota_local.c | 15 +++++++--------
>  3 files changed, 30 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 0f157bb..ccf8093 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -1481,19 +1481,17 @@ static int ocfs2_find_branch_target(struct ocfs2_extent_tree *et,
> 
>  	while(le16_to_cpu(el->l_tree_depth) > 1) {
>  		if (le16_to_cpu(el->l_next_free_rec) == 0) {
> -			ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
> -				    "Owner %llu has empty extent list (next_free_rec == 0)\n",
> -				    (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci));
> -			status = -EIO;
> +			status = ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
> +				             "Owner %llu has empty extent list (next_free_rec == 0)\n",
> +				             (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci));
>  			goto bail;
>  		}
>  		i = le16_to_cpu(el->l_next_free_rec) - 1;
>  		blkno = le64_to_cpu(el->l_recs[i].e_blkno);
>  		if (!blkno) {
> -			ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
> -				    "Owner %llu has extent list where extent # %d has no physical block start\n",
> -				    (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci), i);
> -			status = -EIO;
> +			status = ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
> +				             "Owner %llu has extent list where extent # %d has no physical block start\n",
> +				             (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci), i);
>  			goto bail;
>  		}
> 
> @@ -3214,11 +3212,10 @@ static int ocfs2_rotate_tree_left(handle_t *handle,
>  			goto rightmost_no_delete;
> 
>  		if (le16_to_cpu(el->l_next_free_rec) == 0) {
> -			ret = -EIO;
> -			ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
> -				    "Owner %llu has empty extent block at %llu\n",
> -				    (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
> -				    (unsigned long long)le64_to_cpu(eb->h_blkno));
> +			ret = ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
> +				          "Owner %llu has empty extent block at %llu\n",
> +				          (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
> +				          (unsigned long long)le64_to_cpu(eb->h_blkno));
>  			goto out;
>  		}
> 
> @@ -4411,12 +4408,11 @@ static int ocfs2_figure_merge_contig_type(struct ocfs2_extent_tree *et,
>  			    le16_to_cpu(new_el->l_count)) {
>  				bh = path_leaf_bh(left_path);
>  				eb = (struct ocfs2_extent_block *)bh->b_data;
> -				ocfs2_error(sb,
> -					    "Extent block #%llu has an invalid l_next_free_rec of %d.  It should have matched the l_count of %d\n",
> -					    (unsigned long long)le64_to_cpu(eb->h_blkno),
> -					    le16_to_cpu(new_el->l_next_free_rec),
> -					    le16_to_cpu(new_el->l_count));
> -				status = -EINVAL;
> +				status = ocfs2_error(sb,
> +					             "Extent block #%llu has an invalid l_next_free_rec of %d.  It should have matched the l_count of %d\n",
> +					             (unsigned long long)le64_to_cpu(eb->h_blkno),
> +					             le16_to_cpu(new_el->l_next_free_rec),
> +					             le16_to_cpu(new_el->l_count));
>  				goto free_left_path;
>  			}
>  			rec = &new_el->l_recs[
> @@ -4466,11 +4462,10 @@ static int ocfs2_figure_merge_contig_type(struct ocfs2_extent_tree *et,
>  			if (le16_to_cpu(new_el->l_next_free_rec) <= 1) {
>  				bh = path_leaf_bh(right_path);
>  				eb = (struct ocfs2_extent_block *)bh->b_data;
> -				ocfs2_error(sb,
> -					    "Extent block #%llu has an invalid l_next_free_rec of %d\n",
> -					    (unsigned long long)le64_to_cpu(eb->h_blkno),
> -					    le16_to_cpu(new_el->l_next_free_rec));
> -				status = -EINVAL;
> +				status = ocfs2_error(sb,
> +					             "Extent block #%llu has an invalid l_next_free_rec of %d\n",
> +					             (unsigned long long)le64_to_cpu(eb->h_blkno),
> +					             le16_to_cpu(new_el->l_next_free_rec));
>  				goto free_right_path;
>  			}
>  			rec = &new_el->l_recs[1];
> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> index fe0d1f9..1b56c22 100644
> --- a/fs/ocfs2/localalloc.c
> +++ b/fs/ocfs2/localalloc.c
> @@ -663,11 +663,10 @@ int ocfs2_reserve_local_alloc_bits(struct ocfs2_super *osb,
>  #ifdef CONFIG_OCFS2_DEBUG_FS
>  	if (le32_to_cpu(alloc->id1.bitmap1.i_used) !=
>  	    ocfs2_local_alloc_count_bits(alloc)) {
> -		ocfs2_error(osb->sb, "local alloc inode %llu says it has %u used bits, but a count shows %u\n",
> -			    (unsigned long long)le64_to_cpu(alloc->i_blkno),
> -			    le32_to_cpu(alloc->id1.bitmap1.i_used),
> -			    ocfs2_local_alloc_count_bits(alloc));
> -		status = -EIO;
> +		status = ocfs2_error(osb->sb, "local alloc inode %llu says it has %u used bits, but a count shows %u\n",
> +			             (unsigned long long)le64_to_cpu(alloc->i_blkno),
> +			             le32_to_cpu(alloc->id1.bitmap1.i_used),
> +			             ocfs2_local_alloc_count_bits(alloc));
>  		goto bail;
>  	}
>  #endif
> diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
> index 16c42ed..9c2e4fa 100644
> --- a/fs/ocfs2/quota_local.c
> +++ b/fs/ocfs2/quota_local.c
> @@ -137,14 +137,13 @@ static int ocfs2_read_quota_block(struct inode *inode, u64 v_block,
>  	int rc = 0;
>  	struct buffer_head *tmp = *bh;
> 
> -	if (i_size_read(inode) >> inode->i_sb->s_blocksize_bits <= v_block) {
> -		ocfs2_error(inode->i_sb,
> -			    "Quota file %llu is probably corrupted! Requested to read block %Lu but file has size only %Lu\n",
> -			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
> -			    (unsigned long long)v_block,
> -			    (unsigned long long)i_size_read(inode));
> -		return -EIO;
> -	}
> +	if (i_size_read(inode) >> inode->i_sb->s_blocksize_bits <= v_block)
> +		return ocfs2_error(inode->i_sb,
> +			           "Quota file %llu is probably corrupted! Requested to read block %Lu but file has size only %Lu\n",
> +			           (unsigned long long)OCFS2_I(inode)->ip_blkno,
> +			           (unsigned long long)v_block,
> +			           (unsigned long long)i_size_read(inode));
> +
>  	rc = ocfs2_read_virt_blocks(inode, v_block, 1, &tmp, 0,
>  				    ocfs2_validate_quota_block);
>  	if (rc)
> 
