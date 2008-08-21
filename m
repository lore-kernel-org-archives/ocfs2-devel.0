From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 21 Aug 2008 15:52:39 -0700
Subject: [Ocfs2-devel] [PATCH 09/10] ocfs2: Add an insertion check to
	ocfs2_extent_tree_operations.
In-Reply-To: <1219286905-28104-10-git-send-email-joel.becker@oracle.com>
References: <1219286905-28104-1-git-send-email-joel.becker@oracle.com>
	<1219286905-28104-10-git-send-email-joel.becker@oracle.com>
Message-ID: <20080821225238.GS4563@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Aug 20, 2008 at 07:48:24PM -0700, Joel Becker wrote:
> The op eo_sanity_check() was really a check on remove_right_path().
> Let's call it eo_remove_check().  Let's add an eo_insert_check() that
> can be called from ocfs2_insert_extent().
> 
> Let's have the wrapper calls ocfs2_et_insert_check() and
> ocfs2_et_remove_check() ignore NULL ops.  That way we don't have to
> provide useless operations for xattr types.
> 
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
> ---
>  fs/ocfs2/alloc.c |   88 +++++++++++++++++++++++++++++++++---------------------
>  1 files changed, 54 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 243bacf..38abdf1 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -71,7 +71,10 @@ struct ocfs2_extent_tree_operations {
>  	void (*eo_update_clusters)(struct inode *inode,
>  				   struct ocfs2_extent_tree *et,
>  				   u32 new_clusters);
> -	int (*eo_sanity_check)(struct inode *inode, struct ocfs2_extent_tree *et);
> +	int (*eo_insert_check)(struct inode *inode,
> +			       struct ocfs2_extent_tree *et,
> +			       struct ocfs2_extent_rec *rec);
> +	int (*eo_remove_check)(struct inode *inode, struct ocfs2_extent_tree *et);
>  
>  	/* These are internal to ocfs2_extent_tree and don't have
>  	 * accessor functions */
> @@ -125,7 +128,26 @@ static void ocfs2_dinode_update_clusters(struct inode *inode,
>  	spin_unlock(&OCFS2_I(inode)->ip_lock);
>  }
>  
> -static int ocfs2_dinode_sanity_check(struct inode *inode,
> +static int ocfs2_dinode_insert_check(struct inode *inode,
> +				     struct ocfs2_extent_tree *et,
> +				     struct ocfs2_extent_rec *rec)
> +{
> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +
> +	BUG_ON(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL);
> +	mlog_bug_on_msg(!ocfs2_sparse_alloc(osb) &&
> +			(OCFS2_I(inode)->ip_clusters != rec->e_cpos),
> +			"Device %s, asking for sparse allocation: inode %llu, "
> +			"cpos %u, clusters %u\n",
> +			osb->dev_str,
> +			(unsigned long long)OCFS2_I(inode)->ip_blkno,
> +			rec->e_cpos,
> +			OCFS2_I(inode)->ip_clusters);
> +
> +	return 0;
> +}
> +
> +static int ocfs2_dinode_remove_check(struct inode *inode,
>  				     struct ocfs2_extent_tree *et)
>  {
>  	int ret = 0;
> @@ -148,7 +170,8 @@ static struct ocfs2_extent_tree_operations ocfs2_dinode_et_ops = {
>  	.eo_set_last_eb_blk	= ocfs2_dinode_set_last_eb_blk,
>  	.eo_get_last_eb_blk	= ocfs2_dinode_get_last_eb_blk,
>  	.eo_update_clusters	= ocfs2_dinode_update_clusters,
> -	.eo_sanity_check	= ocfs2_dinode_sanity_check,
> +	.eo_insert_check	= ocfs2_dinode_insert_check,
> +	.eo_remove_check	= ocfs2_dinode_remove_check,
>  	.eo_fill_root_el	= ocfs2_dinode_fill_root_el,
>  };
>  
> @@ -186,17 +209,10 @@ static void ocfs2_xattr_value_update_clusters(struct inode *inode,
>  	le32_add_cpu(&xv->xr_clusters, clusters);
>  }
>  
> -static int ocfs2_xattr_value_sanity_check(struct inode *inode,
> -					  struct ocfs2_extent_tree *et)
> -{
> -	return 0;
> -}
> -
>  static struct ocfs2_extent_tree_operations ocfs2_xattr_value_et_ops = {
>  	.eo_set_last_eb_blk	= ocfs2_xattr_value_set_last_eb_blk,
>  	.eo_get_last_eb_blk	= ocfs2_xattr_value_get_last_eb_blk,
>  	.eo_update_clusters	= ocfs2_xattr_value_update_clusters,
> -	.eo_sanity_check	= ocfs2_xattr_value_sanity_check,
>  	.eo_fill_root_el	= ocfs2_xattr_value_fill_root_el,
>  };
>  
> @@ -241,17 +257,10 @@ static void ocfs2_xattr_tree_update_clusters(struct inode *inode,
>  	le32_add_cpu(&xb->xb_attrs.xb_root.xt_clusters, clusters);
>  }
>  
> -static int ocfs2_xattr_tree_sanity_check(struct inode *inode,
> -					 struct ocfs2_extent_tree *et)
> -{
> -	return 0;
> -}
> -
>  static struct ocfs2_extent_tree_operations ocfs2_xattr_tree_et_ops = {
>  	.eo_set_last_eb_blk	= ocfs2_xattr_tree_set_last_eb_blk,
>  	.eo_get_last_eb_blk	= ocfs2_xattr_tree_get_last_eb_blk,
>  	.eo_update_clusters	= ocfs2_xattr_tree_update_clusters,
> -	.eo_sanity_check	= ocfs2_xattr_tree_sanity_check,
>  	.eo_fill_root_el	= ocfs2_xattr_tree_fill_root_el,
>  	.eo_fill_max_leaf_clusters = ocfs2_xattr_tree_fill_max_leaf_clusters,
>  };
> @@ -344,10 +353,25 @@ static inline void ocfs2_et_update_clusters(struct inode *inode,
>  	et->et_ops->eo_update_clusters(inode, et, clusters);
>  }
>  
> -static inline int ocfs2_et_sanity_check(struct inode *inode,
> +static inline int ocfs2_et_insert_check(struct inode *inode,
> +					struct ocfs2_extent_tree *et,
> +					struct ocfs2_extent_rec *rec)
> +{
> +	int ret = 0;
> +
> +	if (et->et_ops->eo_insert_check)
> +		ret = et->et_ops->eo_insert_check(inode, et, rec);
> +	return ret;
> +}
> +
> +static inline int ocfs2_et_remove_check(struct inode *inode,
>  					struct ocfs2_extent_tree *et)
>  {
> -	return et->et_ops->eo_sanity_check(inode, et);
> +	int ret = 0;
> +
> +	if (et->et_ops->eo_remove_check)
> +		ret = et->et_ops->eo_remove_check(inode, et);
> +	return ret;
>  }
>  
>  static void ocfs2_free_truncate_context(struct ocfs2_truncate_context *tc);
> @@ -2744,7 +2768,7 @@ static int ocfs2_remove_rightmost_path(struct inode *inode, handle_t *handle,
>  	struct ocfs2_extent_list *el;
>  
>  
> -	ret = ocfs2_et_sanity_check(inode, et);
> +	ret = ocfs2_et_remove_check(inode, et);
>  	if (ret)
>  		goto out;
>  	/*
> @@ -4406,26 +4430,22 @@ static int ocfs2_insert_extent(struct ocfs2_super *osb,
>  	int uninitialized_var(free_records);
>  	struct buffer_head *last_eb_bh = NULL;
>  	struct ocfs2_insert_type insert = {0, };
> -	struct ocfs2_extent_rec rec;
> -
> -	BUG_ON(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL);
> +	struct ocfs2_extent_rec rec = {
> +		.e_cpos = cpu_to_le32(cpos),
> +		.e_blkno = cpu_to_le64(start_blk),
> +	};
>  
>  	mlog(0, "add %u clusters at position %u to inode %llu\n",
>  	     new_clusters, cpos, (unsigned long long)OCFS2_I(inode)->ip_blkno);
>  
> -	mlog_bug_on_msg(!ocfs2_sparse_alloc(osb) &&
> -			(OCFS2_I(inode)->ip_clusters != cpos),
> -			"Device %s, asking for sparse allocation: inode %llu, "
> -			"cpos %u, clusters %u\n",
> -			osb->dev_str,
> -			(unsigned long long)OCFS2_I(inode)->ip_blkno, cpos,
> -			OCFS2_I(inode)->ip_clusters);
> -
> -	memset(&rec, 0, sizeof(rec));
> -	rec.e_cpos = cpu_to_le32(cpos);
> -	rec.e_blkno = cpu_to_le64(start_blk);
> +	/* gcc doesn't understand anonymous unions in the initializer */
>  	rec.e_leaf_clusters = cpu_to_le16(new_clusters);
>  	rec.e_flags = flags;

Is there a reason why you changed the way we initialize "rec" for this
patch? I guess the end result is the same - specifically, I want to be 100%
certain that rec.e_reserved1 gets zero'd. Still though, I think the flow we
had before was better.


> +	status = ocfs2_et_insert_check(inode, et, &rec);
> +	if (status) {
> +		mlog_errno(status);
> +		goto bail;
> +	}
>  
>  	status = ocfs2_figure_insert_type(inode, et, &last_eb_bh, &rec,
>  					  &free_records, &insert);
> -- 
> 1.5.6.3
--
Mark Fasheh
