From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 14 Aug 2008 12:55:22 -0700
Subject: [Ocfs2-devel] [PATCH 03/15] Abstract ocfs2_extent_tree
	in	b-tree operations.
In-Reply-To: <1218061894-7693-3-git-send-email-tao.ma@oracle.com>
References: <489A94F4.90903@oracle.com>
	<1218061894-7693-3-git-send-email-tao.ma@oracle.com>
Message-ID: <20080814195522.GA28875@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 07, 2008 at 06:31:25AM +0800, Tao Ma wrote:
> In the old extent tree operation, we take the hypothesis that we
> are using the ocfs2_extent_list in ocfs2_dinode as the tree root.
> As xattr will also use ocfs2_extent_list to store large value
> for a xattr entry, we refactor the tree operation so that xattr
> can use it directly.
> 
> The refactoring includes 4 steps:
> 1. Abstract set/get of last_eb_blk and update_clusters since they may
>    be stored in different location for dinode and xattr.
> 2. Add a new structure named ocfs2_extent_tree to indicate the
>    extent tree the operation will work on.
> 3. Remove all the use of fe_bh and di, use root_bh and root_el in
>    extent tree instead. So now all the fe_bh is replaced with
>    et->root_bh, el with root_el accordingly.
> 4. Make ocfs2_lock_allocators generic. Now it is limited to be only used
>    in file extend allocation. But the whole function is useful when we want
>    to store large EAs.
> 
> Note: This patch hasn't touch the code of ocfs2_commit_truncate since
> it isn't has been modified with the new tree operation.
> So all the truncating code deem that the tree root is ocfs2_dinode.

	Ok, I love this patch.  I just have a couple questions.

> +struct ocfs2_extent_tree_operations {
> +	void (*set_last_eb_blk) (struct ocfs2_extent_tree *et, u64 blkno);
> +	u64 (*get_last_eb_blk) (struct ocfs2_extent_tree *et);
> +	void (*update_clusters) (struct inode *inode,
> +				 struct ocfs2_extent_tree *et,
> +				 u32 new_clusters);
> +	int (*sanity_check) (struct inode *inode, struct ocfs2_extent_tree *et);
> +};

	Can we please prefix these?  et_set_last_eb_blk,
et_update_clusters, etc.

> +struct ocfs2_extent_tree {
> +	enum ocfs2_extent_tree_type type;
> +	struct ocfs2_extent_tree_operations *eops;
> +	struct buffer_head *root_bh;
> +	struct ocfs2_extent_list *root_el;
> +};

	And these too?  et_type, et_ops, et_root_bh, et_root_el.

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
> +	if (type == OCFS2_DINODE_EXTENT) {
> +		struct ocfs2_dinode *fe =
> +				(struct ocfs2_dinode *)root_bh->b_data;
> +		if (!OCFS2_IS_VALID_DINODE(fe)) {
> +			OCFS2_RO_ON_INVALID_DINODE(inode->i_sb, fe);
> +			retval = -EIO;
> +			goto bail;
> +		}
> +
> +		if (fe->i_last_eb_blk)
> +			last_eb_blk = le64_to_cpu(fe->i_last_eb_blk);
> +		el = &fe->id2.i_list;

	Why isn't this using ocfs2_new_extent_tree() and then
ocfs2_get_last_eb_lock()?  You do that every other place, and it keeps
you from having to special case each type here.


Joel

-- 

"Maybe the time has drawn the faces I recall.
 But things in this life change very slowly,
 If they ever change at all."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
