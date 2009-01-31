From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 30 Jan 2009 17:09:40 -0800
Subject: [Ocfs2-devel] [PATCH 3/7] ocfs2: Store dir index records inline
In-Reply-To: <1233351753-14640-4-git-send-email-mfasheh@suse.com>
References: <1233351753-14640-1-git-send-email-mfasheh@suse.com>
	<1233351753-14640-4-git-send-email-mfasheh@suse.com>
Message-ID: <20090131010940.GC6155@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jan 30, 2009 at 01:42:29PM -0800, Mark Fasheh wrote:
> Allow us to store a small number of directory index records in the
> ocfs2_dx_root_block. This saves us a disk read on small to medium sized
> directories (less than about 250 entries). The inline root is automatically
> turned into a root block with extents if the directory size increases beyond
> it's capacity.
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.com>

Two tiny comments, but otherwise
Signed-off-by: Joel Becker <joel.becker@oracle.com>

> @@ -1407,14 +1498,14 @@ int __ocfs2_add_entry(handle_t *handle,
>  			else {
>  				status = ocfs2_journal_access_db(handle, dir,
>  								 insert_bh,
> -								 OCFS2_JOURNAL_ACCESS_WRITE);
> -				if (ocfs2_dir_indexed(dir)) {
> -					status = ocfs2_dx_dir_leaf_insert(dir,
> -									handle,
> -									lookup);
> -					if (status) {
> -						mlog_errno(status);
> -						goto bail;
> +					      OCFS2_JOURNAL_ACCESS_WRITE);
> +
> +			if (ocfs2_dir_indexed(dir)) {
> +				status = ocfs2_dx_dir_insert(dir, handle,
> +							     lookup);
> +				if (status) {
> +					mlog_errno(status);
> +					goto bail;

	This hunk looks indented wrong.  I think it's all inside the
else{, and should be indented the same as the journal_access_db() call.

> @@ -3504,6 +3644,133 @@ out:
>  	return ret;
>  }
>  
> +static int ocfs2_expand_inline_dx_root(struct inode *dir,
> +				       struct buffer_head *dx_root_bh)
> +{
> +	int ret, num_dx_leaves, i, j, did_quota = 0;
> +	struct buffer_head **dx_leaves = NULL;
> +	struct ocfs2_extent_tree et;
> +	u64 insert_blkno;
> +	struct ocfs2_alloc_context *data_ac = NULL;
> +	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
> +	handle_t *handle = NULL;
> +	struct ocfs2_dx_root_block *dx_root;
> +	struct ocfs2_dx_entry_list *entry_list;
> +	struct ocfs2_dx_entry *dx_entry;
> +	struct ocfs2_dx_leaf *target_leaf;
> +
> +	ret = ocfs2_reserve_clusters(osb, 1, &data_ac);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +
> +	dx_leaves = ocfs2_dx_dir_kmalloc_leaves(osb->sb, &num_dx_leaves);
> +	if (!dx_leaves) {
> +		ret = -ENOMEM;
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +
> +	handle = ocfs2_start_trans(osb, ocfs2_calc_dxi_expand_credits(osb->sb));
> +	if (IS_ERR(handle)) {
> +		ret = PTR_ERR(handle);
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +
> +	if (vfs_dq_alloc_space_nodirty(dir,
> +				       ocfs2_clusters_to_bytes(osb->sb, 1))) {
> +		ret = -EDQUOT;
> +		goto out_commit;
> +	}
> +	did_quota = 1;
> +
> +	ret = __ocfs2_dx_dir_new_cluster(dir, 0, handle, data_ac, dx_leaves,
> +					 num_dx_leaves, &insert_blkno);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out_commit;
> +	}
> +
> +	/*
> +	 * Transfer the entries from our dx_root into the appropriate
> +	 * block
> +	 */
> +	dx_root = (struct ocfs2_dx_root_block *) dx_root_bh->b_data;
> +	entry_list = &dx_root->dr_entries;
> +
> +	for (i = 0; i < le16_to_cpu(entry_list->de_num_used); i++) {
> +		dx_entry = &entry_list->de_entries[i];
> +
> +		j = __ocfs2_dx_dir_hash_idx(osb,
> +					    le32_to_cpu(dx_entry->dx_minor_hash));
> +		target_leaf = (struct ocfs2_dx_leaf *)dx_leaves[j]->b_data;
> +
> +		ocfs2_dx_dir_leaf_insert_tail(target_leaf, dx_entry);
> +
> +		/* Each leaf has been passed to the journal already
> +		 * via __ocfs2_dx_dir_new_cluster() */
> +	}
> +
> +	ret = ocfs2_journal_access_dr(handle, dir, dx_root_bh,
> +				      OCFS2_JOURNAL_ACCESS_WRITE);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out_commit;
> +	}

	Why wnot journal_access the dr before you claim the leaf
clusters, so that failure to get journal_access on the dr doesn't force
a commit of the allocated clusters?  Maybe I'm missing something.

Joel

-- 

"When choosing between two evils, I always like to try the one
 I've never tried before."
        - Mae West

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
