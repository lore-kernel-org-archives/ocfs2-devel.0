From: tao.ma <tao.ma@oracle.com>
Date: Tue Nov 27 17:34:27 2007
Subject: [Ocfs2-devel] 	[PATCH 2/3] Add group extend for online resize,
	take 2
In-Reply-To: <20071127082135.GA4480@tma-pc1.cn.oracle.com>
References: <20071127082135.GA4480@tma-pc1.cn.oracle.com>
Message-ID: <474CC527.5020209@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Tao Ma wrote:
> +/*
> + * Extend the filesystem to the new number of clusters specified.  This entry
> + * point is only used to extend the current filesystem to the end of the last
> + * existing group.
> + */
> +int ocfs2_group_extend(struct inode * inode, u32 new_clusters)
> +{
> +	int ret;
> +	handle_t *handle;
> +	struct buffer_head *main_bm_bh = NULL;
> +	struct buffer_head *group_bh = NULL;
> +	struct inode *main_bm_inode = NULL;
> +	struct ocfs2_dinode *fe = NULL;
> +	struct ocfs2_group_desc *group = NULL;
> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +	u16 cl_bpc;
> +	u32 first_new_cluster;
> +	u64 lgd_blkno;
> +
> +	mlog_entry_void();
> +
> +	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> +		return -EROFS;
> +
> +	if (new_clusters == 0)
> +		return 0;
> +
> +	main_bm_inode = ocfs2_get_system_file_inode(osb,
> +						    GLOBAL_BITMAP_SYSTEM_INODE,
> +						    OCFS2_INVALID_SLOT);
> +	if (!main_bm_inode) {
> +		ret = -EINVAL;
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +
> +	mutex_lock(&main_bm_inode->i_mutex);
> +
> +	ret = ocfs2_meta_lock(main_bm_inode, &main_bm_bh, 1);
> +	if (ret < 0) {
> +		mlog_errno(ret);
> +		goto out_mutex;
> +	}
> +
> +	fe = (struct ocfs2_dinode *)main_bm_bh->b_data;
> +
> +	if (le16_to_cpu(fe->id2.i_chain.cl_cpg) !=
> +				 ocfs2_group_bitmap_size(osb->sb) * 8) {
> +		mlog(0, "The disk is too old. Force to do offline resize.");
> +		ret = -EINVAL;
> +		goto out_mutex;
> +	}
>   
A bug here. It should be "goto out_unlock".
I will modify it after I collect all the feedback.
