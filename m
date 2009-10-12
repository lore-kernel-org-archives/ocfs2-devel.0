From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 12 Oct 2009 15:58:42 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: duplicate inline data properly
	during reflink.
In-Reply-To: <1255332589-12578-1-git-send-email-tao.ma@oracle.com>
References: <1255332589-12578-1-git-send-email-tao.ma@oracle.com>
Message-ID: <4AD2E1B2.5060007@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel,
	Sorry, I sent the patch I generated this morning. But it is wrong. So 
please disregard this patch. A new patch set will be sent soon.

Regards,
Tao

Tao Ma wrote:
> The old reflink fails to handle inline-data and can cause kernel
> oops. So this patch fix it. It will try to copy the whole inline
> content to the new inode and set the corresponding feature flag.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> ---
>  fs/ocfs2/refcounttree.c |   57 ++++++++++++++++++++++++++++++++++++++++++++--
>  1 files changed, 54 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> index 60287fc..9b73cbf 100644
> --- a/fs/ocfs2/refcounttree.c
> +++ b/fs/ocfs2/refcounttree.c
> @@ -3743,6 +3743,9 @@ static int ocfs2_attach_refcount_tree(struct inode *inode,
>  		goto out;
>  	}
>  
> +	if (oi->ip_dyn_features & OCFS2_INLINE_DATA_FL)
> +		goto attach_xattr;
> +
>  	ocfs2_init_dinode_extent_tree(&di_et, INODE_CACHE(inode), di_bh);
>  
>  	size = i_size_read(inode);
> @@ -3769,6 +3772,7 @@ static int ocfs2_attach_refcount_tree(struct inode *inode,
>  		cpos += num_clusters;
>  	}
>  
> +attach_xattr:
>  	if (oi->ip_dyn_features & OCFS2_HAS_XATTR_FL) {
>  		ret = ocfs2_xattr_attach_refcount_tree(inode, di_bh,
>  						       &ref_tree->rf_ci,
> @@ -3858,6 +3862,49 @@ out:
>  	return ret;
>  }
>  
> +static int ocfs2_duplicate_inline_data(struct inode *s_inode,
> +				       struct buffer_head *s_bh,
> +				       struct inode *t_inode,
> +				       struct buffer_head *t_bh)
> +{
> +	int ret;
> +	handle_t *handle;
> +	struct ocfs2_super *osb = OCFS2_SB(s_inode->i_sb);
> +	struct ocfs2_dinode *s_di = (struct ocfs2_dinode *)s_bh->b_data;
> +	struct ocfs2_dinode *t_di = (struct ocfs2_dinode *)t_bh->b_data;
> +
> +	BUG_ON(!(OCFS2_I(s_inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL));
> +
> +	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
> +	if (IS_ERR(handle)) {
> +		ret = PTR_ERR(handle);
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +
> +	ret = ocfs2_journal_access_di(handle, INODE_CACHE(t_inode), t_bh,
> +				      OCFS2_JOURNAL_ACCESS_WRITE);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out_commit;
> +	}
> +
> +	t_di->id2.i_data.id_count = s_di->id2.i_data.id_count;
> +	memcpy(t_di->id2.i_data.id_data, s_di->id2.i_data.id_data,
> +	       le16_to_cpu(s_di->id2.i_data.id_count));
> +	spin_lock(&OCFS2_I(t_inode)->ip_lock);
> +	OCFS2_I(t_inode)->ip_dyn_features |= OCFS2_INLINE_DATA_FL;
> +	t_di->i_dyn_features = cpu_to_le16(OCFS2_I(t_inode)->ip_dyn_features);
> +	spin_unlock(&OCFS2_I(t_inode)->ip_lock);
> +
> +	ocfs2_journal_dirty(handle, t_bh);
> +
> +out_commit:
> +	ocfs2_commit_trans(osb, handle);
> +out:
> +	return ret;
> +}
> +
>  static int ocfs2_duplicate_extent_list(struct inode *s_inode,
>  				struct inode *t_inode,
>  				struct buffer_head *t_bh,
> @@ -4005,9 +4052,13 @@ static int ocfs2_create_reflink_node(struct inode *s_inode,
>  	}
>  	rb = (struct ocfs2_refcount_block *)ref_root_bh->b_data;
>  
> -	ret = ocfs2_duplicate_extent_list(s_inode, t_inode, t_bh,
> -					  &ref_tree->rf_ci, ref_root_bh,
> -					  &dealloc);
> +	if (OCFS2_I(s_inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
> +		ret = ocfs2_duplicate_inline_data(s_inode, s_bh,
> +						  t_inode, t_bh);
> +	else
> +		ret = ocfs2_duplicate_extent_list(s_inode, t_inode, t_bh,
> +						  &ref_tree->rf_ci, ref_root_bh,
> +						  &dealloc);
>  	if (ret) {
>  		mlog_errno(ret);
>  		goto out_unlock_refcount;
