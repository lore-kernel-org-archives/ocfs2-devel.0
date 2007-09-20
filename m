From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Sep 20 11:22:56 2007
Subject: [Ocfs2-devel] [PATCH 01/15] ocfs2: move nonsparse hole-filling
	into ocfs2_write_begin()
In-Reply-To: <200709192012.l8JKCFfG012138@agmgw2.us.oracle.com>
References: <200709192012.l8JKCFfG012138@agmgw2.us.oracle.com>
Message-ID: <20070920182219.GD30391@tasint.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Aug 28, 2007 at 05:13:23PM -0700, Mark Fasheh wrote:
> By doing this, we can remove any higher level logic which has to have
> knowledge of btree functionality - any callers of ocfs2_write_begin() can
> now expect it to do anything necessary to prepare the inode for new data.

I like the way extend_file gains smarts - it knows what it's doing.  I
also like the clean comments about how we prevent cluster and local
concurrent access.

Signed-off-by: Joel Becker <joel.becker@oracle.com>

> 
> Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
> ---
>  fs/ocfs2/aops.c |   40 +++++++++-
>  fs/ocfs2/file.c |  217 ++++++++++++++++++++-----------------------------------
>  fs/ocfs2/file.h |    2 +
>  3 files changed, 115 insertions(+), 144 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 460d440..97394c5 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -301,12 +301,8 @@ int ocfs2_prepare_write_nolock(struct inode *inode, struct page *page,
>  {
>  	int ret;
>  
> -	down_read(&OCFS2_I(inode)->ip_alloc_sem);
> -
>  	ret = block_prepare_write(page, from, to, ocfs2_get_block);
>  
> -	up_read(&OCFS2_I(inode)->ip_alloc_sem);
> -
>  	return ret;
>  }
>  
> @@ -1353,6 +1349,36 @@ out:
>  	return ret;
>  }
>  
> +/*
> + * This function only does anything for file systems which can't
> + * handle sparse files.
> + *
> + * What we want to do here is fill in any hole between the current end
> + * of allocation and the end of our write. That way the rest of the
> + * write path can treat it as an non-allocating write, which has no
> + * special case code for sparse/nonsparse files.
> + */
> +static int ocfs2_expand_nonsparse_inode(struct inode *inode, loff_t pos,
> +					unsigned len,
> +					struct ocfs2_write_ctxt *wc)
> +{
> +	int ret;
> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +	loff_t newsize = pos + len;
> +
> +	if (ocfs2_sparse_alloc(osb))
> +		return 0;
> +
> +	if (newsize <= i_size_read(inode))
> +		return 0;
> +
> +	ret = ocfs2_extend_no_holes(inode, newsize, newsize - len);
> +	if (ret)
> +		mlog_errno(ret);
> +
> +	return ret;
> +}
> +
>  int ocfs2_write_begin_nolock(struct address_space *mapping,
>  			     loff_t pos, unsigned len, unsigned flags,
>  			     struct page **pagep, void **fsdata,
> @@ -1374,6 +1400,12 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
>  		return ret;
>  	}
>  
> +	ret = ocfs2_expand_nonsparse_inode(inode, pos, len, wc);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +
>  	ret = ocfs2_populate_write_desc(inode, wc, &clusters_to_alloc,
>  					&extents_to_split);
>  	if (ret) {
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 4ffa715..429ebcb 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -780,25 +780,6 @@ leave:
>  	return status;
>  }
>  
> -static int ocfs2_extend_allocation(struct inode *inode, u32 logical_start,
> -				   u32 clusters_to_add, int mark_unwritten)
> -{
> -	int ret;
> -
> -	/*
> -	 * The alloc sem blocks peope in read/write from reading our
> -	 * allocation until we're done changing it. We depend on
> -	 * i_mutex to block other extend/truncate calls while we're
> -	 * here.
> -	 */
> -	down_write(&OCFS2_I(inode)->ip_alloc_sem);
> -	ret = __ocfs2_extend_allocation(inode, logical_start, clusters_to_add,
> -					mark_unwritten);
> -	up_write(&OCFS2_I(inode)->ip_alloc_sem);
> -
> -	return ret;
> -}
> -
>  /* Some parts of this taken from generic_cont_expand, which turned out
>   * to be too fragile to do exactly what we need without us having to
>   * worry about recursive locking in ->prepare_write() and
> @@ -890,25 +871,47 @@ out:
>  	return ret;
>  }
>  
> -/* 
> - * A tail_to_skip value > 0 indicates that we're being called from
> - * ocfs2_file_aio_write(). This has the following implications:
> - *
> - * - we don't want to update i_size
> - * - di_bh will be NULL, which is fine because it's only used in the
> - *   case where we want to update i_size.
> - * - ocfs2_zero_extend() will then only be filling the hole created
> - *   between i_size and the start of the write.
> - */
> +int ocfs2_extend_no_holes(struct inode *inode, u64 new_i_size, u64 zero_to)
> +{
> +	int ret;
> +	u32 clusters_to_add;
> +	struct ocfs2_inode_info *oi = OCFS2_I(inode);
> +
> +	clusters_to_add = ocfs2_clusters_for_bytes(inode->i_sb, new_i_size);
> +	if (clusters_to_add < oi->ip_clusters)
> +		clusters_to_add = 0;
> +	else
> +		clusters_to_add -= oi->ip_clusters;
> +
> +	if (clusters_to_add) {
> +		ret = __ocfs2_extend_allocation(inode, oi->ip_clusters,
> +						clusters_to_add, 0);
> +		if (ret) {
> +			mlog_errno(ret);
> +			goto out;
> +		}
> +	}
> +
> +	/*
> +	 * Call this even if we don't add any clusters to the tree. We
> +	 * still need to zero the area between the old i_size and the
> +	 * new i_size.
> +	 */
> +	ret = ocfs2_zero_extend(inode, zero_to);
> +	if (ret < 0)
> +		mlog_errno(ret);
> +
> +out:
> +	return ret;
> +}
> +
>  static int ocfs2_extend_file(struct inode *inode,
>  			     struct buffer_head *di_bh,
> -			     u64 new_i_size,
> -			     size_t tail_to_skip)
> +			     u64 new_i_size)
>  {
>  	int ret = 0;
> -	u32 clusters_to_add = 0;
>  
> -	BUG_ON(!tail_to_skip && !di_bh);
> +	BUG_ON(!di_bh);
>  
>  	/* setattr sometimes calls us like this. */
>  	if (new_i_size == 0)
> @@ -918,13 +921,8 @@ static int ocfs2_extend_file(struct inode *inode,
>    		goto out;
>  	BUG_ON(new_i_size < i_size_read(inode));
>  
> -	if (ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb))) {
> -		BUG_ON(tail_to_skip != 0);
> +	if (ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)))
>  		goto out_update_size;
> -	}
> -
> -	clusters_to_add = ocfs2_clusters_for_bytes(inode->i_sb, new_i_size) - 
> -		OCFS2_I(inode)->ip_clusters;
>  
>  	/* 
>  	 * protect the pages that ocfs2_zero_extend is going to be
> @@ -939,35 +937,25 @@ static int ocfs2_extend_file(struct inode *inode,
>  		goto out;
>  	}
>  
> -	if (clusters_to_add) {
> -		ret = ocfs2_extend_allocation(inode,
> -					      OCFS2_I(inode)->ip_clusters,
> -					      clusters_to_add, 0);
> -		if (ret < 0) {
> -			mlog_errno(ret);
> -			goto out_unlock;
> -		}
> -	}
> -
>  	/*
> -	 * Call this even if we don't add any clusters to the tree. We
> -	 * still need to zero the area between the old i_size and the
> -	 * new i_size.
> +	 * The alloc sem blocks people in read/write from reading our
> +	 * allocation until we're done changing it. We depend on
> +	 * i_mutex to block other extend/truncate calls while we're
> +	 * here.
>  	 */
> -	ret = ocfs2_zero_extend(inode, (u64)new_i_size - tail_to_skip);
> +	down_write(&OCFS2_I(inode)->ip_alloc_sem);
> +	ret = ocfs2_extend_no_holes(inode, new_i_size, new_i_size);
> +	up_write(&OCFS2_I(inode)->ip_alloc_sem);
> +
>  	if (ret < 0) {
>  		mlog_errno(ret);
>  		goto out_unlock;
>  	}
>  
>  out_update_size:
> -	if (!tail_to_skip) {
> -		/* We're being called from ocfs2_setattr() which wants
> -		 * us to update i_size */
> -		ret = ocfs2_simple_size_update(inode, di_bh, new_i_size);
> -		if (ret < 0)
> -			mlog_errno(ret);
> -	}
> +	ret = ocfs2_simple_size_update(inode, di_bh, new_i_size);
> +	if (ret < 0)
> +		mlog_errno(ret);
>  
>  out_unlock:
>  	if (!ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)))
> @@ -1036,7 +1024,7 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
>  		if (i_size_read(inode) > attr->ia_size)
>  			status = ocfs2_truncate_file(inode, bh, attr->ia_size);
>  		else
> -			status = ocfs2_extend_file(inode, bh, attr->ia_size, 0);
> +			status = ocfs2_extend_file(inode, bh, attr->ia_size);
>  		if (status < 0) {
>  			if (status != -ENOSPC)
>  				mlog_errno(status);
> @@ -1714,15 +1702,13 @@ static int ocfs2_prepare_inode_for_write(struct dentry *dentry,
>  					 int appending,
>  					 int *direct_io)
>  {
> -	int ret = 0, meta_level = appending;
> +	int ret = 0, meta_level = 0;
>  	struct inode *inode = dentry->d_inode;
> -	u32 clusters;
> -	loff_t newsize, saved_pos;
> +	loff_t saved_pos, end;
>  
>  	/* 
> -	 * We sample i_size under a read level meta lock to see if our write
> -	 * is extending the file, if it is we back off and get a write level
> -	 * meta lock.
> +	 * We start with a read level meta lock and only jump to an ex
> +	 * if we need to make modifications here.
>  	 */
>  	for(;;) {
>  		ret = ocfs2_meta_lock(inode, NULL, meta_level);
> @@ -1764,87 +1750,38 @@ static int ocfs2_prepare_inode_for_write(struct dentry *dentry,
>  			saved_pos = *ppos;
>  		}
>  
> -		if (ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb))) {
> -			loff_t end = saved_pos + count;
> -
> -			/*
> -			 * Skip the O_DIRECT checks if we don't need
> -			 * them.
> -			 */
> -			if (!direct_io || !(*direct_io))
> -				break;
> -
> -			/*
> -			 * Allowing concurrent direct writes means
> -			 * i_size changes wouldn't be synchronized, so
> -			 * one node could wind up truncating another
> -			 * nodes writes.
> -			 */
> -			if (end > i_size_read(inode)) {
> -				*direct_io = 0;
> -				break;
> -			}
> +		end = saved_pos + count;
>  
> -			/*
> -			 * We don't fill holes during direct io, so
> -			 * check for them here. If any are found, the
> -			 * caller will have to retake some cluster
> -			 * locks and initiate the io as buffered.
> -			 */
> -			ret = ocfs2_check_range_for_holes(inode, saved_pos,
> -							  count);
> -			if (ret == 1) {
> -				*direct_io = 0;
> -				ret = 0;
> -			} else if (ret < 0)
> -				mlog_errno(ret);
> +		/*
> +		 * Skip the O_DIRECT checks if we don't need
> +		 * them.
> +		 */
> +		if (!direct_io || !(*direct_io))
>  			break;
> -		}
>  
>  		/*
> -		 * The rest of this loop is concerned with legacy file
> -		 * systems which don't support sparse files.
> +		 * Allowing concurrent direct writes means
> +		 * i_size changes wouldn't be synchronized, so
> +		 * one node could wind up truncating another
> +		 * nodes writes.
>  		 */
> -
> -		newsize = count + saved_pos;
> -
> -		mlog(0, "pos=%lld newsize=%lld cursize=%lld\n",
> -		     (long long) saved_pos, (long long) newsize,
> -		     (long long) i_size_read(inode));
> -
> -		/* No need for a higher level metadata lock if we're
> -		 * never going past i_size. */
> -		if (newsize <= i_size_read(inode))
> +		if (end > i_size_read(inode)) {
> +			*direct_io = 0;
>  			break;
> -
> -		if (meta_level == 0) {
> -			ocfs2_meta_unlock(inode, meta_level);
> -			meta_level = 1;
> -			continue;
>  		}
>  
> -		spin_lock(&OCFS2_I(inode)->ip_lock);
> -		clusters = ocfs2_clusters_for_bytes(inode->i_sb, newsize) -
> -			OCFS2_I(inode)->ip_clusters;
> -		spin_unlock(&OCFS2_I(inode)->ip_lock);
> -
> -		mlog(0, "Writing at EOF, may need more allocation: "
> -		     "i_size = %lld, newsize = %lld, need %u clusters\n",
> -		     (long long) i_size_read(inode), (long long) newsize,
> -		     clusters);
> -
> -		/* We only want to continue the rest of this loop if
> -		 * our extend will actually require more
> -		 * allocation. */
> -		if (!clusters)
> -			break;
> -
> -		ret = ocfs2_extend_file(inode, NULL, newsize, count);
> -		if (ret < 0) {
> -			if (ret != -ENOSPC)
> -				mlog_errno(ret);
> -			goto out_unlock;
> -		}
> +		/*
> +		 * We don't fill holes during direct io, so
> +		 * check for them here. If any are found, the
> +		 * caller will have to retake some cluster
> +		 * locks and initiate the io as buffered.
> +		 */
> +		ret = ocfs2_check_range_for_holes(inode, saved_pos, count);
> +		if (ret == 1) {
> +			*direct_io = 0;
> +			ret = 0;
> +		} else if (ret < 0)
> +			mlog_errno(ret);
>  		break;
>  	}
>  
> diff --git a/fs/ocfs2/file.h b/fs/ocfs2/file.h
> index 36fe27f..066f14a 100644
> --- a/fs/ocfs2/file.h
> +++ b/fs/ocfs2/file.h
> @@ -47,6 +47,8 @@ int ocfs2_do_extend_allocation(struct ocfs2_super *osb,
>  			       struct ocfs2_alloc_context *data_ac,
>  			       struct ocfs2_alloc_context *meta_ac,
>  			       enum ocfs2_alloc_restarted *reason_ret);
> +int ocfs2_extend_no_holes(struct inode *inode, u64 new_i_size,
> +			  u64 zero_to);
>  int ocfs2_lock_allocators(struct inode *inode, struct ocfs2_dinode *di,
>  			  u32 clusters_to_add, u32 extents_to_split,
>  			  struct ocfs2_alloc_context **data_ac,
> -- 
> 1.5.0.6
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

"People with narrow minds usually have broad tongues."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
