From: TaoMa <tao.ma@oracle.com>
Date: Thu, 21 Aug 2008 11:55:08 +0800
Subject: [Ocfs2-devel] [PATCH 03/10] ocfs2: Make ocfs2_extent_tree
 get/put instead of alloc.
In-Reply-To: <1219286905-28104-4-git-send-email-joel.becker@oracle.com>
References: <1219286905-28104-1-git-send-email-joel.becker@oracle.com>
	<1219286905-28104-4-git-send-email-joel.becker@oracle.com>
Message-ID: <48ACE71C.4000700@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> Rather than allocating a struct ocfs2_extent_tree, just put it on the
> stack.  Fill it with ocfs2_get_extent_tree() and drop it with
> ocfs2_put_extent_tree().  Now the callers don't have to ENOMEM, yet
> still safely ref the root_bh.
>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
> ---
>  fs/ocfs2/alloc.c |  117 ++++++++++++++++-------------------------------------
>  1 files changed, 36 insertions(+), 81 deletions(-)
>
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index ab16b89..0abf11e 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -223,22 +223,17 @@ static struct ocfs2_extent_tree_operations ocfs2_xattr_tree_et_ops = {
>  	.eo_sanity_check	= ocfs2_xattr_tree_sanity_check,
>  };
>  
>
>  
> -static void ocfs2_free_extent_tree(struct ocfs2_extent_tree *et)
> +static void ocfs2_put_extent_tree(struct ocfs2_extent_tree *et)
>  {
> -	if (et) {
> -		brelse(et->et_root_bh);
> -		kfree(et);
> -	}
> +	brelse(et->et_root_bh);
>  }
>   
Can we inline this since it is just a one-line function?
>  
>  static inline void ocfs2_et_set_last_eb_blk(struct ocfs2_extent_tree *et,
> @@ -4439,22 +4429,15 @@ int ocfs2_dinode_insert_extent(struct ocfs2_super *osb,
>  			       struct ocfs2_alloc_context *meta_ac)
>  {
>  	int status;
> -	struct ocfs2_extent_tree *et = NULL;
> -
> -	et = ocfs2_new_extent_tree(inode, root_bh, OCFS2_DINODE_EXTENT, NULL);
> -	if (!et) {
> -		status = -ENOMEM;
> -		mlog_errno(status);
> -		goto bail;
> -	}
> +	struct ocfs2_extent_tree et;
>  
> +	ocfs2_get_extent_tree(&et, inode, root_bh, OCFS2_DINODE_EXTENT,
> +			      NULL);
>  	status = ocfs2_insert_extent(osb, handle, inode, root_bh,
>  				     cpos, start_blk, new_clusters,
> -				     flags, meta_ac, et);
> +				     flags, meta_ac, &et);
> +	ocfs2_put_extent_tree(&et);
>  
> -	if (et)
> -		ocfs2_free_extent_tree(et);
> -bail:
>  	return status;
>  }
>  
> @@ -4470,23 +4453,15 @@ int ocfs2_xattr_value_insert_extent(struct ocfs2_super *osb,
>  				    void *private)
>  {
>  	int status;
> -	struct ocfs2_extent_tree *et = NULL;
> -
> -	et = ocfs2_new_extent_tree(inode, root_bh,
> -				   OCFS2_XATTR_VALUE_EXTENT, private);
> -	if (!et) {
> -		status = -ENOMEM;
> -		mlog_errno(status);
> -		goto bail;
> -	}
> +	struct ocfs2_extent_tree et;
>  
> +	ocfs2_get_extent_tree(&et, inode, root_bh,
> +			      OCFS2_XATTR_VALUE_EXTENT, private);
>  	status = ocfs2_insert_extent(osb, handle, inode, root_bh,
>  				     cpos, start_blk, new_clusters,
> -				     flags, meta_ac, et);
> +				     flags, meta_ac, &et);
> +	ocfs2_put_extent_tree(&et);
>  
> -	if (et)
> -		ocfs2_free_extent_tree(et);
> -bail:
>  	return status;
>  }
>  
> @@ -4501,23 +4476,15 @@ int ocfs2_xattr_tree_insert_extent(struct ocfs2_super *osb,
>  				   struct ocfs2_alloc_context *meta_ac)
>  {
>  	int status;
> -	struct ocfs2_extent_tree *et = NULL;
> -
> -	et = ocfs2_new_extent_tree(inode, root_bh, OCFS2_XATTR_TREE_EXTENT,
> -				   NULL);
> -	if (!et) {
> -		status = -ENOMEM;
> -		mlog_errno(status);
> -		goto bail;
> -	}
> +	struct ocfs2_extent_tree et;
>  
> +	ocfs2_get_extent_tree(&et, inode, root_bh, OCFS2_XATTR_TREE_EXTENT,
> +			      NULL);
>  	status = ocfs2_insert_extent(osb, handle, inode, root_bh,
>  				     cpos, start_blk, new_clusters,
> -				     flags, meta_ac, et);
> +				     flags, meta_ac, &et);
> +	ocfs2_put_extent_tree(&et);
>  
> -	if (et)
> -		ocfs2_free_extent_tree(et);
> -bail:
>  	return status;
>  }
>  
> @@ -4906,11 +4873,13 @@ int ocfs2_mark_extent_written(struct inode *inode, struct buffer_head *root_bh,
>  	struct ocfs2_extent_rec split_rec;
>  	struct ocfs2_path *left_path = NULL;
>  	struct ocfs2_extent_list *el;
> -	struct ocfs2_extent_tree *et = NULL;
> +	struct ocfs2_extent_tree et;
>  
>  	mlog(0, "Inode %lu cpos %u, len %u, phys %u (%llu)\n",
>  	     inode->i_ino, cpos, len, phys, (unsigned long long)start_blkno);
>  
> +	ocfs2_get_extent_tree(&et, inode, root_bh, et_type, private);
> +
>  	if (!ocfs2_writes_unwritten_extents(OCFS2_SB(inode->i_sb))) {
>  		ocfs2_error(inode->i_sb, "Inode %llu has unwritten extents "
>  			    "that are being written to, but the feature bit "
> @@ -4920,13 +4889,6 @@ int ocfs2_mark_extent_written(struct inode *inode, struct buffer_head *root_bh,
>  		goto out;
>  	}
>  
> -	et = ocfs2_new_extent_tree(inode, root_bh, et_type, private);
> -	if (!et) {
> -		ret = -ENOMEM;
> -		mlog_errno(ret);
> -		goto out;
> -	}
> -
>   
I think you can get the extent tree here, since if the above judgement 
returns error, we can go out directly without initializing the extent tree.

Regards,
Tao
