From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 27 Jan 2011 17:10:02 -0800
Subject: [Ocfs2-devel] [PATCH 06/14] Ocfs2/move_extents: move a range of
	extent.
In-Reply-To: <1295605231-15991-7-git-send-email-tristan.ye@oracle.com>
References: <1295605231-15991-1-git-send-email-tristan.ye@oracle.com>
	<1295605231-15991-7-git-send-email-tristan.ye@oracle.com>
Message-ID: <20110128011002.GE23899@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jan 21, 2011 at 06:20:23PM +0800, Tristan Ye wrote:
> The moving range of __ocfs2_move_extent() was within one extent always, it
> consists following parts:
> 
> 1. Duplicates the clusters in pages to new_blkoffset, where extent to be moved.
> 
> 2. Split the original extent with new extent, coalecse the nearby extents if possible.
> 
> 3. Append old clusters to truncate log, or decrease_refcount if the extent was refcounted.
> 
> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
> ---
>  fs/ocfs2/move_extents.c |  104 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 104 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
> index 9b30636..e28bd7d 100644
> --- a/fs/ocfs2/move_extents.c
> +++ b/fs/ocfs2/move_extents.c
> @@ -56,6 +56,110 @@ struct ocfs2_move_extents_context {
>  	struct ocfs2_cached_dealloc_ctxt dealloc;
>  };
>  
> +static int __ocfs2_move_extent(handle_t *handle,
> +			       struct ocfs2_move_extents_context *context,
> +			       u32 cpos, u32 len, u32 p_cpos, u32 new_p_cpos,
> +			       int ext_flags)
> +{
> +	int ret = 0, index;
> +	struct inode *inode = context->inode;
> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +	struct ocfs2_extent_rec *rec, replace_rec;
> +	struct ocfs2_path *path = NULL;
> +	struct ocfs2_extent_list *el;
> +	u64 ino = ocfs2_metadata_cache_owner(context->et.et_ci);
> +	u64 old_blkno = ocfs2_clusters_to_blocks(inode->i_sb, p_cpos);
> +
> +	ret = ocfs2_duplicate_clusters_by_page(handle, context->file, cpos,
> +					       p_cpos, new_p_cpos, len);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +
> +	memset(&replace_rec, 0, sizeof(replace_rec));
> +	replace_rec.e_cpos = cpu_to_le32(cpos);
> +	replace_rec.e_leaf_clusters = cpu_to_le16(len);
> +	replace_rec.e_blkno = cpu_to_le64(ocfs2_clusters_to_blocks(inode->i_sb,
> +								   new_p_cpos));
> +
> +	path = ocfs2_new_path_from_et(&context->et);
> +	if (!path) {
> +		ret = -ENOMEM;
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +
> +	ret = ocfs2_find_path(INODE_CACHE(inode), path, cpos);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +
> +	el = path_leaf_el(path);
> +
> +	index = ocfs2_search_extent_list(el, cpos);
> +	if (index == -1 || index >= le16_to_cpu(el->l_next_free_rec)) {
> +		ocfs2_error(inode->i_sb,
> +			    "Inode %llu has an extent at cpos %u which can no "
> +			    "longer be found.\n",
> +			    (unsigned long long)ino, cpos);
> +		ret = -EROFS;
> +		goto out;
> +	}
> +
> +	rec = &el->l_recs[index];
> +
> +	BUG_ON(ext_flags != rec->e_flags);
> +	/*
> +	 * after moving/defraging to new location, the extent is not going
> +	 * to be refcounted anymore.
> +	 */
> +	if (ext_flags & OCFS2_EXT_REFCOUNTED)
> +		replace_rec.e_flags = ext_flags & ~OCFS2_EXT_REFCOUNTED;
> +	else
> +		replace_rec.e_flags = ext_flags;

You can remove the if statement here and just leave it as:

	replace_rec.e_flags = ext_flags & ~OCFS2_EXT_REFCOUNTED;

which will do the same thing.
	--Mark

--
Mark Fasheh
