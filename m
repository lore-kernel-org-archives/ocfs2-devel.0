From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 25 Feb 2009 10:36:17 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: anti stale inode for nfs (V4)
In-Reply-To: <200902200924.n1K9Oqp1029041@rgminet15.oracle.com>
References: <200902200924.n1K9Oqp1029041@rgminet15.oracle.com>
Message-ID: <49A4AEA1.1050607@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi wengang,
	thanks for the work. Just one comment. See below.

wengang wang wrote:
> changes from v3:
> 1, move codes that checks inode allocation bit to subfunction
> ocfs2_test_inode_bit().
> 
> 2, release the suballoc lock just after we get it. we should release it asap
> and doing so doesn't affect functionility.
> 
> 3, add inode alloc slot validation.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
<snip>
> +/* reads(hit disk) the inode specified by blkno to get suballoc_slot
> + * and suballoc_bit
> + * */
> +static int ocfs2_get_suballoc_slot_bit(struct ocfs2_super *osb, u64 blkno,
> +				u16 *suballoc_slot, u16 *suballoc_bit)
> +{
> +	int status;
> +	struct buffer_head *inode_bh = NULL;
> +	struct ocfs2_dinode *inode_fe;
> +
> +	mlog_entry("blkno: %llu\n", blkno);
> +
> +	/* dirty read disk */
> +	status = ocfs2_read_blocks_sync(osb, blkno, 1, &inode_bh);
> +	if (status < 0)
> +		goto bail;
> +
> +	inode_fe = (struct ocfs2_dinode *) inode_bh->b_data;
> +	if (!OCFS2_IS_VALID_DINODE(inode_fe)) {
> +		status = -EINVAL;
> +		goto bail;
> +	}
> +
> +	if (le16_to_cpu(inode_fe->i_suballoc_slot) != OCFS2_INVALID_SLOT &&
> +	    (u32)le16_to_cpu(inode_fe->i_suballoc_slot) > osb->max_slots -1) {
> +		mlog(ML_ERROR, "inode %llu has invalid suballoc slot %u"
> +		     "this may be caused by file system crash", blkno,
> +		     (u32)le16_to_cpu(inode_fe->i_suballoc_slot));
> +		status = -EINVAL;
> +		goto bail;
> +	}
> +	if (suballoc_slot)
> +		*suballoc_slot = le16_to_cpu(inode_fe->i_suballoc_slot);
> +	if (suballoc_bit)
> +		*suballoc_bit= le16_to_cpu(inode_fe->i_suballoc_bit);
> +
> +bail:
> +	brelse(inode_bh);
> +
> +	mlog_exit(status);
> +	return status;
> +}
> +
> +/* test whether bit is SET in allocator bitmap or not.
> + * on success, 0 is returned and *res is 1 for SET; 0 otherwise.
> + * when fails, errno is returned and *res is meaningless.
> + * calls this after you have cluster locked against suballoc, or you may
> + * get a result based on non-up2date contents
> + * */
> +static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb, struct inode *suballoc,
> +			    struct buffer_head *alloc_bh, u64 blkno, u16 bit,
> +			    int *res)
> +{
> +	struct ocfs2_dinode *alloc_fe;
> +	struct ocfs2_group_desc *group;
> +	struct buffer_head *group_bh = NULL;
> +	u64 bg_blkno;
> +	int status;
> +
> +	mlog_entry("blkno: %llu bit: %u\n", blkno, (unsigned int)bit);
> +
> +	alloc_fe = (struct ocfs2_dinode *)alloc_bh->b_data;
> +	BUG_ON((bit + 1) > ocfs2_bits_per_group(&alloc_fe->id2.i_chain));
here, we shouldn't BUG_ON. It actually isn't a kernel bug. the 'bit' is 
got from the disk by function ocfs2_get_suballoc_slot_bit. So maybe a 
corrupt inode, maybe something else, but never a bug of ocfs2. ;) So 
just return error please.

Regards,
Tao
