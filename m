From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 23 Jan 2008 22:08:16 -0000
Subject: [Ocfs2-devel] [PATCH 13/30] ocfs2: Implement group add for
	online resize
In-Reply-To: <1200609356-17788-14-git-send-email-mark.fasheh@oracle.com>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
	<1200609356-17788-14-git-send-email-mark.fasheh@oracle.com>
Message-ID: <20080123140554.bf3981e5.akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, tao.ma@oracle.com

> On Thu, 17 Jan 2008 14:35:39 -0800 Mark Fasheh <mark.fasheh@oracle.com> wrote:
> From: Tao Ma <tao.ma@oracle.com>
> 
> This patch adds the ability for a userspace program to request that a
> properly formatted cluster group be added to the main allocation bitmap for
> an Ocfs2 file system. The request is made via an ioctl, OCFS2_IOC_GROUP_ADD.
> On a high level, this is similar to ext3, but we use a different ioctl as
> the structure which has to be passed through is different.
> 
> During an online resize, tunefs.ocfs2 will format any new cluster groups
> which must be added to complete the resize, and call OCFS2_IOC_GROUP_ADD on
> each one. Kernel verifies that the core cluster group information is valid
> and then does the work of linking it into the global allocation bitmap.
> 
>  ...
>
> +/* Used to pass group descriptor data when online resize is done */
> +struct ocfs2_new_group_input {
> +	__u64 group;		/* Group descriptor's blkno. */
> +	__u32 clusters;		/* Total number of clusters in this group */
> +	__u32 frees;		/* Total free clusters in this group */
> +	__u16 chain;		/* Chain for this group */
> +	__u16 reserved1;
> +	__u32 reserved2;
> +};

Are we sure that all architectures will lay this out in the same way with
both 32-bit and 64-bit userspace?

> +/* Add a new group descriptor to global_bitmap. */
> +int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
> +{
> +	int ret;
> +	handle_t *handle;
> +	struct buffer_head *main_bm_bh = NULL;
> +	struct inode *main_bm_inode = NULL;
> +	struct ocfs2_dinode *fe = NULL;
> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +	struct buffer_head *group_bh = NULL;
> +	struct ocfs2_group_desc *group = NULL;
> +	struct ocfs2_chain_list *cl;
> +	struct ocfs2_chain_rec *cr;
> +	u16 cl_bpc;
> +
> +	mlog_entry_void();
> +
> +	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> +		return -EROFS;
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
> +	ret = ocfs2_inode_lock(main_bm_inode, &main_bm_bh, 1);
> +	if (ret < 0) {
> +		mlog_errno(ret);
> +		goto out_mutex;
> +	}
> +
> +	fe = (struct ocfs2_dinode *)main_bm_bh->b_data;
> +
> +	if (le16_to_cpu(fe->id2.i_chain.cl_cpg) !=
> +				 ocfs2_group_bitmap_size(osb->sb) * 8) {
> +		mlog(ML_ERROR, "The disk is too old and small."
> +		     " Force to do offline resize.");
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	ret = ocfs2_read_block(osb, input->group, &group_bh, 0, NULL);
> +	if (ret < 0) {
> +		mlog(ML_ERROR, "Can't read the group descriptor # %llu "
> +		     "from the device.", input->group);
> +		goto out;

Bug: goto wrong_place.  (Points at fault-injection code)

> +	}
> +
> +	ocfs2_set_new_buffer_uptodate(inode, group_bh);
> +
> +	ret = ocfs2_verify_group_and_input(main_bm_inode, fe, input, group_bh);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out_unlock;
> +	}
> +
> +	mlog(0, "Add a new group  %llu in chain = %u, length = %u\n",
> +	     input->group, input->chain, input->clusters);
> +
> +	handle = ocfs2_start_trans(osb, OCFS2_GROUP_ADD_CREDITS);
> +	if (IS_ERR(handle)) {
> +		mlog_errno(PTR_ERR(handle));
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	cl_bpc = le16_to_cpu(fe->id2.i_chain.cl_bpc);
> +	cl = &fe->id2.i_chain;
> +	cr = &cl->cl_recs[input->chain];
> +
> +	ret = ocfs2_journal_access(handle, main_bm_inode, group_bh,
> +				   OCFS2_JOURNAL_ACCESS_WRITE);
> +	if (ret < 0) {
> +		mlog_errno(ret);
> +		goto out_commit;
> +	}
> +
> +	group = (struct ocfs2_group_desc *)group_bh->b_data;
> +	group->bg_next_group = cr->c_blkno;
> +
> +	ret = ocfs2_journal_dirty(handle, group_bh);
> +	if (ret < 0) {
> +		mlog_errno(ret);
> +		goto out_commit;
> +	}
> +
> +	ret = ocfs2_journal_access(handle, main_bm_inode, main_bm_bh,
> +				   OCFS2_JOURNAL_ACCESS_WRITE);

hm.  Do we need to do that again?

> +	if (ret < 0) {
> +		mlog_errno(ret);
> +		goto out_commit;
> +	}
> +
> +	if (input->chain == le16_to_cpu(cl->cl_next_free_rec)) {
> +		le16_add_cpu(&cl->cl_next_free_rec, 1);
> +		memset(cr, 0, sizeof(struct ocfs2_chain_rec));
> +	}
> +
> +	cr->c_blkno = le64_to_cpu(input->group);
> +	le32_add_cpu(&cr->c_total, input->clusters * cl_bpc);
> +	le32_add_cpu(&cr->c_free, input->frees * cl_bpc);
> +
> +	le32_add_cpu(&fe->id1.bitmap1.i_total, input->clusters *cl_bpc);
> +	le32_add_cpu(&fe->id1.bitmap1.i_used,
> +		     (input->clusters - input->frees) * cl_bpc);
> +	le32_add_cpu(&fe->i_clusters, input->clusters);
> +
> +	ocfs2_journal_dirty(handle, main_bm_bh);
> +
> +	spin_lock(&OCFS2_I(main_bm_inode)->ip_lock);
> +	OCFS2_I(main_bm_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
> +	le64_add_cpu(&fe->i_size, input->clusters << osb->s_clustersize_bits);
> +	spin_unlock(&OCFS2_I(main_bm_inode)->ip_lock);
> +	i_size_write(main_bm_inode, le64_to_cpu(fe->i_size));

Is i_mutex held?

> +	ocfs2_update_super_and_backups(main_bm_inode, input->clusters);
> +
> +out_commit:
> +	ocfs2_commit_trans(osb, handle);
> +out_unlock:
> +	if (group_bh)
> +		brelse(group_bh);
> +
> +	if (main_bm_bh)
> +		brelse(main_bm_bh);

brelse(NULL) is legal.

> +	ocfs2_inode_unlock(main_bm_inode, 1);
> +
> +out_mutex:
> +	mutex_unlock(&main_bm_inode->i_mutex);
> +	iput(main_bm_inode);
> +
> +out:
> +	mlog_exit_void();
> +	return ret;
> +}
