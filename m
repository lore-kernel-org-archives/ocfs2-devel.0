From: alex chen <alex.chen@huawei.com>
Date: Fri, 2 Feb 2018 10:48:32 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: use 'osb' instead of
	'OCFS2_SB()'
In-Reply-To: <5A702111.7090907@huawei.com>
References: <5A702111.7090907@huawei.com>
Message-ID: <5A73D180.9000405@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Looks good to me.

On 2018/1/30 15:38, piaojun wrote:
> We could use 'osb' instead of 'OCFS2_SB()' to make code more elegant.
> 
> Signed-off-by: Jun Piao <piaojun@huawei.com>
> Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
Reviewed-by: Alex Chen <alex.chen@huawei.com>

> ---
>  fs/ocfs2/aops.c         |  2 +-
>  fs/ocfs2/dir.c          |  2 +-
>  fs/ocfs2/dlmglue.c      | 21 ++++++++-------------
>  fs/ocfs2/file.c         |  2 +-
>  fs/ocfs2/inode.c        |  6 +++---
>  fs/ocfs2/refcounttree.c |  4 ++--
>  fs/ocfs2/suballoc.c     |  4 ++--
>  fs/ocfs2/super.c        |  4 ++--
>  fs/ocfs2/xattr.c        |  2 +-
>  9 files changed, 21 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 4dae836..e9c2360 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -2211,7 +2211,7 @@ static int ocfs2_dio_wr_get_block(struct inode *inode, sector_t iblock,
>  	down_write(&oi->ip_alloc_sem);
> 
>  	if (first_get_block) {
> -		if (ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)))
> +		if (ocfs2_sparse_alloc(osb))
>  			ret = ocfs2_zero_tail(inode, di_bh, pos);
>  		else
>  			ret = ocfs2_expand_nonsparse_inode(inode, di_bh, pos,
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index febe631..0a38408 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -3071,7 +3071,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
>  			 * We need to return the correct block within the
>  			 * cluster which should hold our entry.
>  			 */
> -			off = ocfs2_dx_dir_hash_idx(OCFS2_SB(dir->i_sb),
> +			off = ocfs2_dx_dir_hash_idx(osb,
>  						    &lookup->dl_hinfo);
>  			get_bh(dx_leaves[off]);
>  			lookup->dl_dx_leaf_bh = dx_leaves[off];
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 4689940..9f937a2 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -1734,8 +1734,7 @@ int ocfs2_rw_lock(struct inode *inode, int write)
> 
>  	level = write ? DLM_LOCK_EX : DLM_LOCK_PR;
> 
> -	status = ocfs2_cluster_lock(OCFS2_SB(inode->i_sb), lockres, level, 0,
> -				    0);
> +	status = ocfs2_cluster_lock(osb, lockres, level, 0, 0);
>  	if (status < 0)
>  		mlog_errno(status);
> 
> @@ -1753,7 +1752,7 @@ void ocfs2_rw_unlock(struct inode *inode, int write)
>  	     write ? "EXMODE" : "PRMODE");
> 
>  	if (!ocfs2_mount_local(osb))
> -		ocfs2_cluster_unlock(OCFS2_SB(inode->i_sb), lockres, level);
> +		ocfs2_cluster_unlock(osb, lockres, level);
>  }
> 
>  /*
> @@ -1773,8 +1772,7 @@ int ocfs2_open_lock(struct inode *inode)
> 
>  	lockres = &OCFS2_I(inode)->ip_open_lockres;
> 
> -	status = ocfs2_cluster_lock(OCFS2_SB(inode->i_sb), lockres,
> -				    DLM_LOCK_PR, 0, 0);
> +	status = ocfs2_cluster_lock(osb, lockres, DLM_LOCK_PR, 0, 0);
>  	if (status < 0)
>  		mlog_errno(status);
> 
> @@ -1811,8 +1809,7 @@ int ocfs2_try_open_lock(struct inode *inode, int write)
>  	 * other nodes and the -EAGAIN will indicate to the caller that
>  	 * this inode is still in use.
>  	 */
> -	status = ocfs2_cluster_lock(OCFS2_SB(inode->i_sb), lockres,
> -				    level, DLM_LKF_NOQUEUE, 0);
> +	status = ocfs2_cluster_lock(osb, lockres, level, DLM_LKF_NOQUEUE, 0);
> 
>  out:
>  	return status;
> @@ -1833,11 +1830,9 @@ void ocfs2_open_unlock(struct inode *inode)
>  		goto out;
> 
>  	if(lockres->l_ro_holders)
> -		ocfs2_cluster_unlock(OCFS2_SB(inode->i_sb), lockres,
> -				     DLM_LOCK_PR);
> +		ocfs2_cluster_unlock(osb, lockres, DLM_LOCK_PR);
>  	if(lockres->l_ex_holders)
> -		ocfs2_cluster_unlock(OCFS2_SB(inode->i_sb), lockres,
> -				     DLM_LOCK_EX);
> +		ocfs2_cluster_unlock(osb, lockres, DLM_LOCK_EX);
> 
>  out:
>  	return;
> @@ -2539,9 +2534,9 @@ void ocfs2_inode_unlock(struct inode *inode,
>  	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
>  	     ex ? "EXMODE" : "PRMODE");
> 
> -	if (!ocfs2_is_hard_readonly(OCFS2_SB(inode->i_sb)) &&
> +	if (!ocfs2_is_hard_readonly(osb) &&
>  	    !ocfs2_mount_local(osb))
> -		ocfs2_cluster_unlock(OCFS2_SB(inode->i_sb), lockres, level);
> +		ocfs2_cluster_unlock(osb, lockres, level);
>  }
> 
>  /*
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 2188af4..9c9388f 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -294,7 +294,7 @@ int ocfs2_update_inode_atime(struct inode *inode,
>  	ocfs2_journal_dirty(handle, bh);
> 
>  out_commit:
> -	ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
> +	ocfs2_commit_trans(osb, handle);
>  out:
>  	return ret;
>  }
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 2c48395..3cfbce0 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1134,7 +1134,7 @@ static void ocfs2_clear_inode(struct inode *inode)
>  	trace_ocfs2_clear_inode((unsigned long long)oi->ip_blkno,
>  				inode->i_nlink);
> 
> -	mlog_bug_on_msg(OCFS2_SB(inode->i_sb) == NULL,
> +	mlog_bug_on_msg(osb == NULL,
>  			"Inode=%lu\n", inode->i_ino);
> 
>  	dquot_drop(inode);
> @@ -1149,7 +1149,7 @@ static void ocfs2_clear_inode(struct inode *inode)
>  	ocfs2_mark_lockres_freeing(osb, &oi->ip_inode_lockres);
>  	ocfs2_mark_lockres_freeing(osb, &oi->ip_open_lockres);
> 
> -	ocfs2_resv_discard(&OCFS2_SB(inode->i_sb)->osb_la_resmap,
> +	ocfs2_resv_discard(&osb->osb_la_resmap,
>  			   &oi->ip_la_data_resv);
>  	ocfs2_resv_init_once(&oi->ip_la_data_resv);
> 
> @@ -1222,7 +1222,7 @@ static void ocfs2_clear_inode(struct inode *inode)
>  	 * the journal is flushed before journal shutdown. Thus it is safe to
>  	 * have inodes get cleaned up after journal shutdown.
>  	 */
> -	jbd2_journal_release_jbd_inode(OCFS2_SB(inode->i_sb)->journal->j_journal,
> +	jbd2_journal_release_jbd_inode(osb->journal->j_journal,
>  				       &oi->ip_jinode);
>  }
> 
> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> index 50e288e..01c6b38 100644
> --- a/fs/ocfs2/refcounttree.c
> +++ b/fs/ocfs2/refcounttree.c
> @@ -3359,7 +3359,7 @@ static int ocfs2_replace_cow(struct ocfs2_cow_context *context)
>  	unsigned int ext_flags;
>  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> 
> -	if (!ocfs2_refcount_tree(OCFS2_SB(inode->i_sb))) {
> +	if (!ocfs2_refcount_tree(osb)) {
>  		return ocfs2_error(inode->i_sb, "Inode %lu want to use refcount tree, but the feature bit is not set in the super block\n",
>  				   inode->i_ino);
>  	}
> @@ -3707,7 +3707,7 @@ int ocfs2_add_refcount_flag(struct inode *inode,
>  	trace_ocfs2_add_refcount_flag(ref_blocks, credits);
> 
>  	if (ref_blocks) {
> -		ret = ocfs2_reserve_new_metadata_blocks(OCFS2_SB(inode->i_sb),
> +		ret = ocfs2_reserve_new_metadata_blocks(osb,
>  							ref_blocks, &meta_ac);
>  		if (ret) {
>  			mlog_errno(ret);
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 9f0b95a..2714902 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -387,7 +387,7 @@ static int ocfs2_block_group_fill(handle_t *handle,
> 
>  	memset(bg, 0, sb->s_blocksize);
>  	strcpy(bg->bg_signature, OCFS2_GROUP_DESC_SIGNATURE);
> -	bg->bg_generation = cpu_to_le32(OCFS2_SB(sb)->fs_generation);
> +	bg->bg_generation = cpu_to_le32(osb->fs_generation);
>  	bg->bg_size = cpu_to_le16(ocfs2_group_bitmap_size(sb, 1,
>  						osb->s_feature_incompat));
>  	bg->bg_chain = cpu_to_le16(my_chain);
> @@ -1521,7 +1521,7 @@ static int ocfs2_cluster_group_search(struct inode *inode,
>  				OCFS2_I(inode)->ip_clusters, max_bits);
>  		}
> 
> -		ret = ocfs2_block_group_find_clear_bits(OCFS2_SB(inode->i_sb),
> +		ret = ocfs2_block_group_find_clear_bits(osb,
>  							group_bh, bits_wanted,
>  							max_bits, res);
>  		if (ret)
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 4e4bb27..52435f5 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -423,10 +423,10 @@ static int ocfs2_sync_fs(struct super_block *sb, int wait)
>  		ocfs2_schedule_truncate_log_flush(osb, 0);
>  	}
> 
> -	if (jbd2_journal_start_commit(OCFS2_SB(sb)->journal->j_journal,
> +	if (jbd2_journal_start_commit(osb->journal->j_journal,
>  				      &target)) {
>  		if (wait)
> -			jbd2_log_wait_commit(OCFS2_SB(sb)->journal->j_journal,
> +			jbd2_log_wait_commit(osb->journal->j_journal,
>  					     target);
>  	}
>  	return 0;
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index adeebcb..1ab8b9c 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -3564,7 +3564,7 @@ int ocfs2_xattr_set(struct inode *inode,
>  		.not_found = -ENODATA,
>  	};
> 
> -	if (!ocfs2_supports_xattr(OCFS2_SB(inode->i_sb)))
> +	if (!ocfs2_supports_xattr(osb))
>  		return -EOPNOTSUPP;
> 
>  	/*
> 
