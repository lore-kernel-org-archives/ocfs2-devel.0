From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 3 Apr 2008 16:20:10 -0700
Subject: [Ocfs2-devel] [PATCH 3/3] Extent tree operation
	refactoring.take 1
In-Reply-To: <20080328084559.GA6352@dhcp-beijing-cdc-10-182-120-173.cn.oracle.com>
References: <20080328084559.GA6352@dhcp-beijing-cdc-10-182-120-173.cn.oracle
	.com>
Message-ID: <20080403232010.GL21261@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 28, 2008 at 04:45:59PM +0800, Tao Ma wrote:
> In the old extent tree operation, we take the hypothesis that we
> are using the ocfs2_extent_list in ocfs2_dinode as the tree root.
> As xattr will also use ocfs2_extent_list to store large values
> xattr enty, we refactor the tree operation so that xattr can use
> it directly.
> 
> The refactoring includes 3 steps:
> 1. Abstract the set/get of last_eb_blk since it may be stored
>    in different location for dinode and xattr.
> 2. Add a new structure named ocfs2_extent_tree to indicate the
>    extent tree the operation will work on.
> 3. Remove all the use of fe_bh and di, use root_bh and root_el in
>    extent tree instead. So now all the fe_bh is replaced with
>    et->root_bh, el with root_el accordingly.

Most of this looks fine - I've got a couple of comments below.


> +static void ocfs2_free_extent_tree(struct ocfs2_extent_tree *et)
> +{
> +	if (et) {
> +		brelse(et->root_bh);
> +		kfree(et);
> +	}
> +}
> +
> +static int ocfs2_extent_tree_sanity_check(struct inode *inode,
> +					  struct ocfs2_extent_tree *et)
> +{
> +	int ret = 0;

Wouldn't it be cleaner if this were also a callback type in struct
ocfs2_extent_tree_operations?


> +	/* current we only support dinode extent. */
> +	BUG_ON(et->type != OCFS2_DINODE_EXTENT);
> +	if (et->type == OCFS2_DINODE_EXTENT) {
> +		struct ocfs2_dinode *di;
> +
> +		di = (struct ocfs2_dinode *)et->root_bh->b_data;
> +		if (!OCFS2_IS_VALID_DINODE(di)) {
> +			ret = -EIO;
> +			ocfs2_error(inode->i_sb,
> +				"Inode %llu has invalid path root",
> +				(unsigned long long)OCFS2_I(inode)->ip_blkno);
> +		}
> +	}
> +
> +	return ret;
> +}
> +
>  static void ocfs2_free_truncate_context(struct ocfs2_truncate_context *tc);
>  static int ocfs2_cache_extent_block_free(struct ocfs2_cached_dealloc_ctxt *ctxt,
>  					 struct ocfs2_extent_block *eb);
> @@ -205,17 +294,6 @@ static struct ocfs2_path *ocfs2_new_path(struct buffer_head *root_bh,
>  }
>  
>  /*
> - * Allocate and initialize a new path based on a disk inode tree.
> - */
> -static struct ocfs2_path *ocfs2_new_inode_path(struct buffer_head *di_bh)
> -{
> -	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
> -	struct ocfs2_extent_list *el = &di->id2.i_list;
> -
> -	return ocfs2_new_path(di_bh, el);
> -}
> -
> -/*
>   * Convenience function to journal all components in a path.
>   */
>  static int ocfs2_journal_access_path(struct inode *inode, handle_t *handle,
> @@ -368,24 +446,35 @@ struct ocfs2_merge_ctxt {
>   */
>  int ocfs2_num_free_extents(struct ocfs2_super *osb,
>  			   struct inode *inode,
> -			   struct buffer_head *bh)
> +			   struct buffer_head *root_bh,
> +			   enum ocfs2_extent_tree_type type)
>  {
>  	int retval;
> -	struct ocfs2_extent_list *el;
> +	struct ocfs2_extent_list *el = NULL;
>  	struct ocfs2_extent_block *eb;
>  	struct buffer_head *eb_bh = NULL;
> -	struct ocfs2_dinode *fe = (struct ocfs2_dinode *)bh->b_data;
> +	u64 last_eb_blk = 0;
>  
>  	mlog_entry_void();
>  
> -	if (!OCFS2_IS_VALID_DINODE(fe)) {
> -		OCFS2_RO_ON_INVALID_DINODE(inode->i_sb, fe);
> -		retval = -EIO;
> -		goto bail;
> +	/* current we only support dinode extent. */
> +	BUG_ON(type != OCFS2_DINODE_EXTENT);

Outside of your allocation function and each callback, I'd say we probably
don't need so many of these. The others will catch any problem before these
do.


> @@ -6043,13 +6161,14 @@ int ocfs2_commit_truncate(struct ocfs2_super *osb,
>  	handle_t *handle = NULL;
>  	struct inode *tl_inode = osb->osb_tl_inode;
>  	struct ocfs2_path *path = NULL;
> +	struct ocfs2_dinode *di = (struct ocfs2_dinode *)fe_bh->b_data;
>  
>  	mlog_entry_void();
>  
>  	new_highest_cpos = ocfs2_clusters_for_bytes(osb->sb,
>  						     i_size_read(inode));
>  
> -	path = ocfs2_new_inode_path(fe_bh);
> +	path = ocfs2_new_path(fe_bh, &di->id2.i_list);
>  	if (!path) {
>  		status = -ENOMEM;
>  		mlog_errno(status);
> @@ -6339,3 +6458,5 @@ static void ocfs2_free_truncate_context(struct ocfs2_truncate_context *tc)
>  
>  	kfree(tc);
>  }
> +
> +

You've added whitespace here for no reason.
	--Mark

--
Mark Fasheh
