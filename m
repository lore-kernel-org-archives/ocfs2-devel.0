From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 1 May 2009 20:55:55 -0700
Subject: [Ocfs2-devel] [PATCH 04/39] ocfs2: Basic tree root operation.
In-Reply-To: <1241045931-24607-4-git-send-email-tao.ma@oracle.com>
References: <49F95A79.6040806@oracle.com>
	<1241045931-24607-4-git-send-email-tao.ma@oracle.com>
Message-ID: <20090502035555.GD17236@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Apr 30, 2009 at 06:58:16AM +0800, Tao Ma wrote:
> +int ocfs2_create_refcount_tree(struct inode *inode, struct buffer_head *di_bh)
> +{
> +	int ret;
> +	handle_t *handle = NULL;
> +	struct ocfs2_alloc_context *meta_ac = NULL;
> +	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
> +	struct ocfs2_inode_info *oi = OCFS2_I(inode);
> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +	struct buffer_head *new_bh = NULL;
> +	struct ocfs2_refcount_block *rb;
> +	u16 suballoc_bit_start;
> +	u32 num_got;
> +	u64 first_blkno;
> +
> +	BUG_ON(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL);
> +	BUG_ON(di->i_refcount_loc);
> +
> +	mlog(0, "create tree for inode %lu\n", inode->i_ino);
> +
> +	ret = ocfs2_reserve_new_metadata_blocks(osb, 1, &meta_ac);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +
> +	handle = ocfs2_start_trans(osb, OCFS2_REFCOUNT_TREE_CREATE_CREDITS);
> +	if (IS_ERR(handle)) {
> +		ret = PTR_ERR(handle);
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +
> +	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
> +				      OCFS2_JOURNAL_ACCESS_WRITE);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out_commit;
> +	}
> +
> +	ret = ocfs2_claim_metadata(osb, handle, meta_ac, 1,
> +				   &suballoc_bit_start, &num_got,
> +				   &first_blkno);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out_commit;
> +	}
> +
> +	new_bh = sb_getblk(inode->i_sb, first_blkno);
> +	ocfs2_set_new_buffer_uptodate(INODE_CACHE(inode), new_bh);
> +
> +	ret = ocfs2_journal_access_rb(handle, INODE_CACHE(inode), new_bh,
> +				      OCFS2_JOURNAL_ACCESS_CREATE);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out_commit;
> +	}
> +
> +	/* Initialize ocfs2_refcount_block. */
> +	rb = (struct ocfs2_refcount_block *)new_bh->b_data;
> +	memset(rb, 0, inode->i_sb->s_blocksize);
> +	strcpy((void *)rb, OCFS2_REFCOUNT_BLOCK_SIGNATURE);
> +	rb->rf_suballoc_slot = cpu_to_le16(osb->slot_num);
> +	rb->rf_suballoc_bit = cpu_to_le16(suballoc_bit_start);
> +	rb->rf_fs_generation = cpu_to_le32(osb->fs_generation);
> +	rb->rf_blkno = cpu_to_le64(first_blkno);
> +	rb->rf_count = cpu_to_le32(1);
> +	rb->rf_flags = cpu_to_le32(OCFS2_REFCOUNT_LEAF_FL);
> +	rb->rf_records.rl_count =
> +			cpu_to_le16(ocfs2_refcount_recs_per_rb(osb->sb));

	Ouch, I missed this the first pass.  The root of the tree is not
a LEAF, so it should have flags==0.  OCFS2_REFCOUNT_LEAF_FL does not
mean "I have refcount records".  It means "I am hanging off of a btree
and rf_parent points to the top of my btree".  To determine whether
rf_records is valid, you check OCFS2_REFCOUNT_TREE_FL.  If not set,
rf_records is valid.

Joel

-- 

"Always give your best, never get discouraged, never be petty; always
 remember, others may hate you.  Those who hate you don't win unless
 you hate them.  And then you destroy yourself."
	- Richard M. Nixon

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
