From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 27 Oct 2008 14:35:11 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2/xattr: Proper hash collision
	handle in	bucket division.v3
In-Reply-To: <1225058784-15621-1-git-send-email-tao.ma@oracle.com>
References: <1225058784-15621-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20081027213511.GC25974@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Some comment text cleanups, but I'm good with this.  Mark, let's push it
to fixes.

Joel

On Mon, Oct 27, 2008 at 06:06:24AM +0800, Tao Ma wrote:
> Modification from V2 to V3:
> Use a more pefect code suggested by Joel. Thank Joel for it.
> 
> In ocfs2/xattr, we must make sure the xattrs which have the same
> hash value exist in the same bucket so that the search schema can
> work. But in the old implementation, when we want to extend a bucket,
> we just move half number of xattrs to the new bucket. This works
> in most cases, but if we are lucky enough we will make 2 xattrs

							move 2 xattrs
with the same hash

> into 2 different buckets. This cause a problem that the xattr

				 means that an xattr from the
previous bucket cannot be found anymore.

> existing in the previous bucket can be found any more. This patch
> fix this problem by finding the right position during extending
> the bucket and extend an empty bucket if needed.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> Cc: Joel Becker <joel.becker@oracle.com>

<snip>

> +/*
> + * Move some xattrs in old bucket(blk) to new bucket(new_blk).
>   * first_hash will record the 1st hash of the new bucket.
> + *
> + * Normally half nums will be moved. But we have to make sure

Normally half of the xattrs will be moved.  But we have to make sure

> + * that the xattr with same hash value is stored in the same

that the xattrs with the same hash value are stored in the same

> + * bucket. If all the xattrs in this bucket has the same hash

						have

> + * value, the new bucket will be initialized as an empty one
> + * and the first_hash will be initialized as (hash_value+1).
>   */
> -static int ocfs2_half_xattr_bucket(struct inode *inode,
> -				   handle_t *handle,
> -				   u64 blk,
> -				   u64 new_blk,
> -				   u32 *first_hash,
> -				   int new_bucket_head)
> +static int ocfs2_divide_xattr_bucket(struct inode *inode,
> +				    handle_t *handle,
> +				    u64 blk,
> +				    u64 new_blk,
> +				    u32 *first_hash,
> +				    int new_bucket_head)
>  {
>  	int ret, i;
> -	u16 count, start, len, name_value_len, xe_len, name_offset;
> +	int count, start, len, name_value_len = 0, xe_len, name_offset = 0;
>  	u16 blk_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
>  	struct buffer_head **s_bhs, **t_bhs = NULL;
>  	struct ocfs2_xattr_header *xh;
>  	struct ocfs2_xattr_entry *xe;
>  	int blocksize = inode->i_sb->s_blocksize;
>  
> -	mlog(0, "move half of xattrs from bucket %llu to %llu\n",
> +	mlog(0, "move some of xattrs from bucket %llu to %llu\n",
>  	     blk, new_blk);
>  
>  	s_bhs = kcalloc(blk_per_bucket, sizeof(struct buffer_head *), GFP_NOFS);
> @@ -3171,14 +3219,35 @@ static int ocfs2_half_xattr_bucket(struct inode *inode,
>  		}
>  	}
>  
> +	xh = (struct ocfs2_xattr_header *)s_bhs[0]->b_data;
> +	count = le16_to_cpu(xh->xh_count);
> +	start = ocfs2_xattr_find_divide_pos(xh);
> +
> +	if (start == count) {
> +		xe = &xh->xh_entries[start-1];
> +
> +		/*
> +		 * initialized a new empty bucket here.
> +		 * The hash value is set as one larger than
> +		 * that of the last entry in the previous bucket.
> +		 */
> +		for (i = 0; i < blk_per_bucket; i++)
> +			memset(t_bhs[i]->b_data, 0, blocksize);
> +
> +		xh = (struct ocfs2_xattr_header *)t_bhs[0]->b_data;
> +		xh->xh_free_start = cpu_to_le16(blocksize);
> +		xh->xh_entries[0].xe_name_hash = xe->xe_name_hash;
> +		le32_add_cpu(&xh->xh_entries[0].xe_name_hash, 1);
> +
> +		goto set_num_buckets;
> +	}
> +
>  	/* copy the whole bucket to the new first. */
>  	for (i = 0; i < blk_per_bucket; i++)
>  		memcpy(t_bhs[i]->b_data, s_bhs[i]->b_data, blocksize);
>  
>  	/* update the new bucket. */
>  	xh = (struct ocfs2_xattr_header *)t_bhs[0]->b_data;
> -	count = le16_to_cpu(xh->xh_count);
> -	start = count / 2;
>  
>  	/*
>  	 * Calculate the total name/value len and xh_free_start for
> @@ -3235,6 +3304,7 @@ static int ocfs2_half_xattr_bucket(struct inode *inode,
>  			xh->xh_free_start = xe->xe_name_offset;
>  	}
>  
> +set_num_buckets:
>  	/* set xh->xh_num_buckets for the new xh. */
>  	if (new_bucket_head)
>  		xh->xh_num_buckets = cpu_to_le16(1);
> @@ -3253,8 +3323,11 @@ static int ocfs2_half_xattr_bucket(struct inode *inode,
>  
>  	/*
>  	 * Now only update the 1st block of the old bucket.
> -	 * Please note that the entry has been sorted already above.
> +	 * If we just add a new empty bucket after it, no needs to modify it.

	If we just added a new empty bucket, there is no need to modify it.

>  	 */
> +	if (start == count)
> +		goto out;
> +
>  	xh = (struct ocfs2_xattr_header *)s_bhs[0]->b_data;
>  	memset(&xh->xh_entries[start], 0,
>  	       sizeof(struct ocfs2_xattr_entry) * (count - start));
> @@ -3439,15 +3512,15 @@ out:
>  }
>  
>  /*
> - * Move half of the xattrs in this cluster to the new cluster.
> + * Move some xattrs in this cluster to the new cluster.
>   * This function should only be called when bucket size == cluster size.
>   * Otherwise ocfs2_mv_xattr_bucket_cross_cluster should be used instead.
>   */
> -static int ocfs2_half_xattr_cluster(struct inode *inode,
> -				    handle_t *handle,
> -				    u64 prev_blk,
> -				    u64 new_blk,
> -				    u32 *first_hash)
> +static int ocfs2_divide_xattr_cluster(struct inode *inode,
> +				      handle_t *handle,
> +				      u64 prev_blk,
> +				      u64 new_blk,
> +				      u32 *first_hash)
>  {
>  	u16 blk_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
>  	int ret, credits = 2 * blk_per_bucket;
> @@ -3461,8 +3534,8 @@ static int ocfs2_half_xattr_cluster(struct inode *inode,
>  	}
>  
>  	/* Move half of the xattr in start_blk to the next bucket. */
> -	return  ocfs2_half_xattr_bucket(inode, handle, prev_blk,
> -					new_blk, first_hash, 1);
> +	return  ocfs2_divide_xattr_bucket(inode, handle, prev_blk,
> +					  new_blk, first_hash, 1);
>  }
>  
>  /*
> @@ -3524,9 +3597,9 @@ static int ocfs2_adjust_xattr_cross_cluster(struct inode *inode,
>  						     last_blk, new_blk,
>  						     v_start);
>  		else {
> -			ret = ocfs2_half_xattr_cluster(inode, handle,
> -						       last_blk, new_blk,
> -						       v_start);
> +			ret = ocfs2_divide_xattr_cluster(inode, handle,
> +							 last_blk, new_blk,
> +							 v_start);
>  
>  			if ((*header_bh)->b_blocknr == last_blk && extend)
>  				*extend = 0;
> @@ -3743,8 +3816,8 @@ static int ocfs2_extend_xattr_bucket(struct inode *inode,
>  	}
>  
>  	/* Move half of the xattr in start_blk to the next bucket. */
> -	ret = ocfs2_half_xattr_bucket(inode, handle, start_blk,
> -				      start_blk + blk_per_bucket, NULL, 0);
> +	ret = ocfs2_divide_xattr_bucket(inode, handle, start_blk,
> +					start_blk + blk_per_bucket, NULL, 0);
>  
>  	le16_add_cpu(&first_xh->xh_num_buckets, 1);
>  	ocfs2_journal_dirty(handle, first_bh);
> @@ -4435,11 +4508,21 @@ out:
>  	return ret;
>  }
>  
> -/* check whether the xattr bucket is filled up with the same hash value. */
> +/*
> + * check whether the xattr bucket is filled up with the same hash value.
> + * If we want to insert the xattr with the same hash, return -ENOSPC.
> + * If we want to insert a xattr with different hash value, go ahead
> + * and ocfs2_divide_xattr_bucket will handle this.
> + */
>  static int ocfs2_check_xattr_bucket_collision(struct inode *inode,
> -					      struct ocfs2_xattr_bucket *bucket)
> +					      struct ocfs2_xattr_bucket *bucket,
> +					      const char *name)
>  {
>  	struct ocfs2_xattr_header *xh = bucket->xh;
> +	u32 name_hash = ocfs2_xattr_name_hash(inode, name, strlen(name));
> +
> +	if (name_hash != le32_to_cpu(xh->xh_entries[0].xe_name_hash))
> +		return 0;
>  
>  	if (xh->xh_entries[le16_to_cpu(xh->xh_count) - 1].xe_name_hash ==
>  	    xh->xh_entries[0].xe_name_hash) {
> @@ -4562,7 +4645,9 @@ try_again:
>  		 * one bucket's worth, so check it here whether we need to
>  		 * add a new bucket for the insert.
>  		 */
> -		ret = ocfs2_check_xattr_bucket_collision(inode, &xs->bucket);
> +		ret = ocfs2_check_xattr_bucket_collision(inode,
> +							 &xs->bucket,
> +							 xi->name);
>  		if (ret) {
>  			mlog_errno(ret);
>  			goto out;
> -- 
> 1.5.4.GIT
> 

-- 

You can use a screwdriver to screw in screws or to clean your ears,
however, the latter needs real skill, determination and a lack of fear
of injuring yourself.  It is much the same with JavaScript.
	- Chris Heilmann

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
