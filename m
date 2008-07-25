From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 25 Jul 2008 14:57:55 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Add extended attribute support
	v3
Message-ID: <20080725215755.GH28014@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Ok, your handling of symlinks looks fine. Thanks very much for doing this.
Other comments on this patch below.

On Fri, Jul 25, 2008 at 05:03:06PM +0800, Tiger Yang wrote:
> diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
> index 390a855..0977569 100644
> --- a/fs/ocfs2/inode.h
> +++ b/fs/ocfs2/inode.h
> @@ -40,6 +40,14 @@ struct ocfs2_inode_info
>  	/* protects allocation changes on this inode. */
>  	struct rw_semaphore		ip_alloc_sem;
>  
> +	/*
> +	 * Extended attributes can be read independently of the main file
> +	 * data. Taking i_mutex even when reading would cause contention
> +	 * between readers of EAs and writers of regular file data, so
> +	 * instead we synchronize on xattr_sem when reading or changing EAs.
> +	 */
> +	struct rw_semaphore		xattr_sem;

Nice comment - thanks for making this clear. I hate to say this though,
but... Could you please remove it and go back to i_mutex / ip_alloc_sem
locking for now?

The thing is, the locking as you have it here isn't protecting against
racing a data write, which is reading l_count on the extent list (or id_count on
inline data) and an xattr write which might want to shrink those. You'll
need at least ip_alloc_sem around those, since ocfs2_page_mkwrite() doesn't
take i_mutex because it doesn't want to deadlock against the mmap
semaphore.


Or are you trying to protect xattr against itself? If that's the case, you
could push this lock up to the top and take it around entire operations.


>   * On disk structure for xattr block.
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 00d0fff..d521362 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -532,6 +532,45 @@ bail:
>  	return status;
>  }
>  
> +int ocfs2_reserve_new_metadata_blocks(struct ocfs2_super *osb,
> +				      int blocks,
> +				      struct ocfs2_alloc_context **ac)
> +{
> +	int status;
> +	u32 slot;
> +
> +	*ac = kzalloc(sizeof(struct ocfs2_alloc_context), GFP_KERNEL);
> +	if (!(*ac)) {
> +		status = -ENOMEM;
> +		mlog_errno(status);
> +		goto bail;
> +	}
> +
> +	(*ac)->ac_bits_wanted = blocks;
> +	(*ac)->ac_which = OCFS2_AC_USE_META;
> +	slot = osb->slot_num;
> +	(*ac)->ac_group_search = ocfs2_block_group_search;
> +
> +	status = ocfs2_reserve_suballoc_bits(osb, (*ac),
> +					     EXTENT_ALLOC_SYSTEM_INODE,
> +					     slot, ALLOC_NEW_GROUP);
> +	if (status < 0) {
> +		if (status != -ENOSPC)
> +			mlog_errno(status);
> +		goto bail;
> +	}
> +
> +	status = 0;
> +bail:
> +	if ((status < 0) && *ac) {
> +		ocfs2_free_alloc_context(*ac);
> +		*ac = NULL;
> +	}
> +
> +	mlog_exit(status);
> +	return status;
> +}


Ok, I see what you're doing here, but you should just refactor
ocfs2_reserve_new_metadata() as a small wrapper around this function:

int ocfs2_reserve_new_metadata(struct ocfs2_super *osb,
			       struct ocfs2_extent_list *root_el,
			       struct ocfs2_alloc_context **ac)
{
	return ocfs2_reserve_new_metadata_blocks(osb, ocfs2_extend_meta_needed(root_el), ac);
}

Thanks,
	--Mark

--
Mark Fasheh
