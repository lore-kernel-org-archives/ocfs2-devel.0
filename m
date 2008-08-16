From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 15 Aug 2008 19:18:54 -0700
Subject: [Ocfs2-devel] [PATCH 07/15] Add extent tree operation for	xattr
	value.v3
In-Reply-To: <1218061894-7693-7-git-send-email-tao.ma@oracle.com>
References: <489A94F4.90903@oracle.com>
	<1218061894-7693-7-git-send-email-tao.ma@oracle.com>
Message-ID: <20080816021854.GA31499@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 07, 2008 at 06:31:29AM +0800, Tao Ma wrote:
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -78,6 +78,7 @@ struct ocfs2_extent_tree {
>  	struct ocfs2_extent_tree_operations *eops;
>  	struct buffer_head *root_bh;
>  	struct ocfs2_extent_list *root_el;
> +	void *private;
>  };

	Why 'private'?  Why not 'object'?  I don't like this if block:

>  static struct ocfs2_extent_tree*
>  	 ocfs2_new_extent_tree(struct buffer_head *bh,
> -			       enum ocfs2_extent_tree_type et_type)
> +			       enum ocfs2_extent_tree_type et_type,
> +			       void *private)
>  {
>  	struct ocfs2_extent_tree *et;
>  
> @@ -149,12 +191,16 @@ static struct ocfs2_extent_tree*
>  	et->type = et_type;
>  	get_bh(bh);
>  	et->root_bh = bh;
> +	et->private = private;
>  
> -	/* current we only support dinode extent. */
> -	BUG_ON(et->type != OCFS2_DINODE_EXTENT);
>  	if (et_type == OCFS2_DINODE_EXTENT) {
>  		et->root_el = &((struct ocfs2_dinode *)bh->b_data)->id2.i_list;
>  		et->eops = &ocfs2_dinode_et_ops;
> +	} else if (et_type == OCFS2_XATTR_VALUE_EXTENT) {
> +		struct ocfs2_xattr_value_root *xv =
> +			(struct ocfs2_xattr_value_root *) private;
> +		et->root_el = &xv->xr_list;
> +		et->eops = &ocfs2_xattr_et_ops;
>  	}

	Why don't you have an operation for getting the el?  Really, the
way I see it, you should have:

    void ocfs2_fill_extent_tree(*et, *bh, void *object, type)
    {
            et->et_type = type;
            et->et_ops = extent_tree_ops[type];
            get_bh(bh);
            et->et_root_bh = bh;
            et->et_object = object ? object : (void *)bh->b_data;
            et->et_root_el = et->et_ops->et_get_root_el(et);
    }

If you pass NULL for *object, it knows to use the start of the bh.  This
works for dinode, etc.  But you can pass a non-NULL object for the
xattr_value_root.  The get_root_el operations know how to take et_object
and return the el:

    ocfs2_dinode_get_root_el(*et)
    {
            struct ocfs2_dinode *di = et->et_object;
            return &di->id2.i_list;
    }
    ocfs2_xattr_value_root_get_el(*et)
    {
            struct ocfs2_xattr_value_root *xv = et->et_object;
            return &xv->xr_list;
    }

> @@ -495,7 +541,8 @@ struct ocfs2_merge_ctxt {
>  int ocfs2_num_free_extents(struct ocfs2_super *osb,
>  			   struct inode *inode,
>  			   struct buffer_head *root_bh,
> -			   enum ocfs2_extent_tree_type type)
> +			   enum ocfs2_extent_tree_type type,
> +			   void *private)
>  {
>  	int retval;
>  	struct ocfs2_extent_list *el = NULL;
> @@ -517,6 +564,12 @@ int ocfs2_num_free_extents(struct ocfs2_super *osb,
>  		if (fe->i_last_eb_blk)
>  			last_eb_blk = le64_to_cpu(fe->i_last_eb_blk);
>  		el = &fe->id2.i_list;
> +	} else if (type == OCFS2_XATTR_VALUE_EXTENT) {
> +		struct ocfs2_xattr_value_root *xv =
> +			(struct ocfs2_xattr_value_root *) private;
> +
> +		last_eb_blk = le64_to_cpu(xv->xr_last_eb_blk);
> +		el = &xv->xr_list;

	Again, just to avoid the extent_tree object, you are
hand-accessing the last_eb_block and el entries.  I really think you
should be passing an *et into this function.

> -int ocfs2_insert_extent(struct ocfs2_super *osb,
> -			handle_t *handle,
> -			struct inode *inode,
> -			struct buffer_head *root_bh,
> -			u32 cpos,
> -			u64 start_blk,
> -			u32 new_clusters,
> -			u8 flags,
> -			struct ocfs2_alloc_context *meta_ac,
> -			enum ocfs2_extent_tree_type et_type)
> +static int ocfs2_insert_extent(struct ocfs2_super *osb,
> +			       handle_t *handle,
> +			       struct inode *inode,
> +			       struct buffer_head *root_bh,
> +			       u32 cpos,
> +			       u64 start_blk,
> +			       u32 new_clusters,
> +			       u8 flags,
> +			       struct ocfs2_alloc_context *meta_ac,
> +			       struct ocfs2_extent_tree *et)

	Here you are passing in the et, so you don't need root_bh
anymore, right

> @@ -4554,7 +4658,8 @@ int ocfs2_mark_extent_written(struct inode *inode, struct buffer_head *root_bh,
>  			      handle_t *handle, u32 cpos, u32 len, u32 phys,
>  			      struct ocfs2_alloc_context *meta_ac,
>  			      struct ocfs2_cached_dealloc_ctxt *dealloc,
> -			      enum ocfs2_extent_tree_type et_type)
> +			      enum ocfs2_extent_tree_type et_type,
> +			      void *private)

	Here again you're passing root_bh, et_type, and private.  Why
not just pass in the et?

> +int ocfs2_xattr_get_clusters(struct inode *inode, u32 v_cluster,
> +			     u32 *p_cluster, u32 *num_clusters,
> +			     struct ocfs2_extent_list *el)
> +{
> +	int ret = 0, i;
> +	struct buffer_head *eb_bh = NULL;
> +	struct ocfs2_extent_block *eb;
> +	struct ocfs2_extent_rec *rec;
> +	u32 coff;
> +
> +	if (el->l_tree_depth) {
> +		ret = ocfs2_find_leaf(inode, el, v_cluster, &eb_bh);
> +		if (ret) {
> +			mlog_errno(ret);
> +			goto out;
> +		}
> +
> +		eb = (struct ocfs2_extent_block *) eb_bh->b_data;
> +		el = &eb->h_list;
> +
> +		if (el->l_tree_depth) {
> +			ocfs2_error(inode->i_sb,
> +				    "Inode %lu has non zero tree depth in "
> +				    "xattr leaf block %llu\n", inode->i_ino,
> +				    (unsigned long long)eb_bh->b_blocknr);
> +			ret = -EROFS;
> +			goto out;
> +		}
> +	}
> +
> +	i = ocfs2_search_extent_list(el, v_cluster);
> +	if (i == -1) {
> +		ret = -EROFS;
> +		mlog_errno(ret);
> +		goto out;
> +	} else {
> +		rec = &el->l_recs[i];
> +		BUG_ON(v_cluster < le32_to_cpu(rec->e_cpos));
> +
> +		if (!rec->e_blkno) {
> +			ocfs2_error(inode->i_sb, "Inode %lu has bad extent "
> +				    "record (%u, %u, 0) in xattr", inode->i_ino,
> +				    le32_to_cpu(rec->e_cpos),
> +				    ocfs2_rec_clusters(el, rec));
> +			ret = -EROFS;
> +			goto out;
> +		}
> +		coff = v_cluster - le32_to_cpu(rec->e_cpos);
> +		*p_cluster = ocfs2_blocks_to_clusters(inode->i_sb,
> +						    le64_to_cpu(rec->e_blkno));
> +		*p_cluster = *p_cluster + coff;
> +		if (num_clusters)
> +			*num_clusters = ocfs2_rec_clusters(el, rec) - coff;
> +	}
> +out:
> +	if (eb_bh)
> +		brelse(eb_bh);
> +	return ret;
> +}

	Part of me wonders if you could have refactored
ocfs2_get_clusters to share most of this duplicated code.  But I do see
the difference, and we can always come back to it.

> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index d82a9a0..00d0fff 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -1906,7 +1906,8 @@ int ocfs2_lock_allocators(struct inode *inode, struct buffer_head *root_bh,
>  			  struct ocfs2_extent_list *root_el,
>  			  u32 clusters_to_add, u32 extents_to_split,
>  			  struct ocfs2_alloc_context **data_ac,
> -			  struct ocfs2_alloc_context **meta_ac)
> +			  struct ocfs2_alloc_context **meta_ac,
> +			  enum ocfs2_extent_tree_type type, void *private)

	Pass in a struct ocfs2_extent_list and you don't have to pass
root_bh. root_el, type, or private.

> @@ -1992,7 +1993,8 @@ int ocfs2_add_clusters_in_btree(struct ocfs2_super *osb,
>  				struct ocfs2_alloc_context *data_ac,
>  				struct ocfs2_alloc_context *meta_ac,
>  				enum ocfs2_alloc_restarted *reason_ret,
> -				enum ocfs2_extent_tree_type type)
> +				enum ocfs2_extent_tree_type type,
> +				void *private)

	Same here.  I'll stop repeating this.

> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> new file mode 100644
> index 0000000..9604a4c
> --- /dev/null
> +++ b/fs/ocfs2/xattr.c

	This file I like :-)  Pretty straightforward and clean.

Joel

-- 

"Too much walking shoes worn thin.
 Too much trippin' and my soul's worn thin.
 Time to catch a ride it leaves today
 Her name is what it means.
 Too much walking shoes worn thin."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
