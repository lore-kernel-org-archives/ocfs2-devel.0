From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 17 Jul 2008 17:30:35 -0700
Subject: [Ocfs2-devel] [PATCH 13/15] Enable xattr set in index btree.v2
In-Reply-To: <20080627070254.GA20381@tma-pc2.cn.oracle.com>
References: <48648B3E.6050808@oracle.com>
	<20080627070254.GA20381@tma-pc2.cn.oracle.com>
Message-ID: <20080718003034.GN28014@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jun 27, 2008 at 03:02:54PM +0800, Tao Ma wrote:
> +static int ocfs2_xattr_create_index_block(struct inode *inode,
> +					  struct ocfs2_xattr_search *xs)
> +{
> +	int ret, credits = OCFS2_SUBALLOC_ALLOC;
> +	u32 bit_off, len;
> +	u64 blkno;
> +	handle_t *handle;
> +	struct super_block *sb = inode->i_sb;
> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +	struct ocfs2_inode_info *oi = OCFS2_I(inode);
> +	struct ocfs2_alloc_context *data_ac;
> +	struct buffer_head *xh_bh = NULL, *data_bh = NULL;
> +	struct buffer_head *xb_bh = xs->xattr_bh;
> +	struct ocfs2_xattr_block *xb =
> +			(struct ocfs2_xattr_block *)xb_bh->b_data;
> +	struct ocfs2_xattr_tree_root *xr;
> +	u16 xb_flags = le16_to_cpu(xb->xb_flags);
> +	u16 bpb = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
> +
> +	mlog(0, "create xattr index block for %llu\n",
> +	     (unsigned long long)xb_bh->b_blocknr);
> +
> +	BUG_ON(xb_flags & OCFS2_XATTR_INDEXED);
> +
> +	ret = ocfs2_reserve_clusters(osb, 1, &data_ac);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +
> +	/*
> +	 * XXX:
> +	 * Do we need this lock or should we use a new sem in xattr allocation?
> +	 */
> +	down_write(&oi->ip_alloc_sem);

We can use this for now, and move to a dedicated mutex if performance
becomes a problem later. You should update the comment to say this :)


> +	/*
> +	 * 3 more credits, one for xattr block update, one for the 1st block
> +	 * of the new xattr bucket and one for the value/data.
> +	 */
> +	credits += 3;
> +	handle = ocfs2_start_trans(osb, credits);
> +	if (IS_ERR(handle)) {
> +		ret = PTR_ERR(handle);
> +		mlog_errno(ret);
> +		goto out_sem;
> +	}
> +
> +	ret = ocfs2_journal_access(handle, inode, xb_bh,
> +				   OCFS2_JOURNAL_ACCESS_CREATE);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out_commit;
> +	}
> +
> +	ret = ocfs2_claim_clusters(osb, handle, data_ac, 1, &bit_off, &len);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out_commit;
> +	}
> +
> +	/*
> +	 * The bucket may spread in many blocks, and
> +	 * we will only touch the 1st block and the last block
> +	 * in the whole bucket(one for entry and one for data.
> +	 */
> +	blkno = ocfs2_clusters_to_blocks(sb, bit_off);
> +
> +	mlog(0, "allocate 1 cluster from %llu to xattr block\n", blkno);
> +
> +	ret = ocfs2_read_block(osb, blkno, &xh_bh,
> +			       OCFS2_BH_CACHED, inode);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out_commit;
> +	}

Ok, you're still reading in newly allocated blocks. Don't do this - you're
doing I/O for nothing.

Instead, you want to use sb_getblk() and ocfs2_set_new_buffer_uptodate(),
like we do elsewhere. This goes for all parts of the newly allocated cluster
you'll be updating in this function.

If we know that the disk block does not have valid data or that we will be
replacing an entire block (as opposed to just changing part of it), then
it's better to allocate the buffer with sb_getblk() and just force it's up
to date state with ocfs2_set_new_buffer_uptodate().


> +
> +	ret = ocfs2_journal_access(handle, inode, xh_bh,
> +				   OCFS2_JOURNAL_ACCESS_CREATE);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out_commit;
> +	}
> +
> +	if (bpb > 1) {
> +		ret = ocfs2_read_block(osb, blkno + bpb - 1, &data_bh,
> +				       OCFS2_BH_CACHED, inode);
> +		if (ret) {
> +			mlog_errno(ret);
> +			goto out_commit;
> +		}
> +
> +		ret = ocfs2_journal_access(handle, inode, data_bh,
> +					   OCFS2_JOURNAL_ACCESS_CREATE);
> +		if (ret) {
> +			mlog_errno(ret);
> +			goto out_commit;
> +		}
> +	}
> +
> +	ocfs2_cp_xattr_block_to_bucket(inode, xb_bh, xh_bh, data_bh);
> +
> +	ocfs2_journal_dirty(handle, xh_bh);
> +	if (data_bh)
> +		ocfs2_journal_dirty(handle, data_bh);
> +
> +	ocfs2_xattr_update_xattr_search(inode, xs, xb_bh, xh_bh);
> +
> +	/* Re-initalize the xattr block. */
> +	xr = &xb->xb_attrs.xb_root;
> +	memset(xr, 0, sizeof(struct ocfs2_xattr_tree_root));
> +	xr->xt_clusters = cpu_to_le32(1);
> +	xr->xt_last_eb_blk = 0;
> +	xr->xt_list.l_tree_depth = 0;
> +	xr->xt_list.l_count = cpu_to_le16(ocfs2_xattr_recs_per_xb(inode->i_sb));
> +	xr->xt_list.l_next_free_rec = cpu_to_le16(1);
> +
> +	memset(xr->xt_list.l_recs, 0, sizeof(struct ocfs2_extent_rec));

Why not just memset the entire block and re-initialize it? That way, all
unused space is zero'd for us from the start.

By the way, were the other newly allocated blocks cleared too? This is
extremely important. If we are not initializing ALL unused space to zero,
than we will _never_ be able to expand these structures in the future.


> +/*
> + * Add a new cluster for xattr storage.
> + *
> + * If the new cluster is contiguous with the previous one, it will be
> + * appended to the same extent record, and num_clusters will be updated.
> + *
> + * If not, we will insert a new extent for it and move some xattrs in
> + * the last cluster into the new allocated one.
> + * first_bh is the first block of the previous extent rec and header_bh
> + * indicates the bucket we will insert the new xattrs. They will be updated
> + * when the header_bh is moved into the new cluster.
> + */
> +static int ocfs2_add_new_xattr_cluster(struct inode *inode,
> +				       struct buffer_head *root_bh,
> +				       struct buffer_head **first_bh,
> +				       struct buffer_head **header_bh,
> +				       u32 *num_clusters,
> +				       u32 prev_cpos,
> +				       u64 prev_blkno,
> +				       int *extend)
> +{
> +	int ret, credits;
> +	u16 bpc = ocfs2_clusters_to_blocks(inode->i_sb, 1);
> +	u32 prev_clusters = *num_clusters;
> +	u32 clusters_to_add = 1, bit_off, num_bits, v_start = 0;
> +	u64 block;
> +	handle_t *handle = NULL;
> +	struct buffer_head *new_bh = NULL;
> +	struct ocfs2_alloc_context *data_ac = NULL;
> +	struct ocfs2_alloc_context *meta_ac = NULL;
> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +	struct ocfs2_xattr_header *first_xh =
> +			(struct ocfs2_xattr_header *)(*first_bh)->b_data;
> +	struct ocfs2_xattr_block *xb =
> +			(struct ocfs2_xattr_block *)root_bh->b_data;
> +	struct ocfs2_xattr_tree_root *xb_root = &xb->xb_attrs.xb_root;
> +	struct ocfs2_extent_list *root_el = &xb_root->xt_list;
> +	enum ocfs2_extent_tree_type type = OCFS2_XATTR_TREE_EXTENT;
> +
> +	mlog(0, "Add new xattr cluster for %llu, previous xattr hash = %u, "
> +	     "previous xattr blkno = %llu\n",
> +	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
> +	     prev_cpos, prev_blkno);
> +
> +	ret = ocfs2_lock_allocators(inode, root_bh, root_el,
> +				    clusters_to_add, 0, &data_ac,
> +				    &meta_ac, type, NULL);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto leave;
> +	}
> +
> +	credits = ocfs2_calc_extend_credits(osb->sb, root_el, clusters_to_add);
> +	handle = ocfs2_start_trans(osb, credits);
> +	if (IS_ERR(handle)) {
> +		ret = PTR_ERR(handle);
> +		handle = NULL;
> +		mlog_errno(ret);
> +		goto leave;
> +	}
> +
> +	ret = ocfs2_journal_access(handle, inode, root_bh,
> +				   OCFS2_JOURNAL_ACCESS_WRITE);
> +	if (ret < 0) {
> +		mlog_errno(ret);
> +		goto leave;
> +	}
> +
> +	ret = __ocfs2_claim_clusters(osb, handle, data_ac, 1,
> +				     clusters_to_add, &bit_off, &num_bits);
> +	if (ret < 0) {
> +		if (ret != -ENOSPC)
> +			mlog_errno(ret);
> +		goto leave;
> +	}
> +
> +	BUG_ON(num_bits > clusters_to_add);
> +
> +	block = ocfs2_clusters_to_blocks(osb->sb, bit_off);
> +	mlog(0, "Allocating %u clusters at block %u for xattr in inode %llu\n",
> +	     num_bits, bit_off, (unsigned long long)OCFS2_I(inode)->ip_blkno);
> +
> +	if (prev_blkno + prev_clusters * bpc == block &&
> +	    le16_to_cpu(first_xh->xh_reserved1) +
> +	    num_bits * ocfs2_xattr_buckets_per_cluster(osb) >
> +	    le16_to_cpu(first_xh->xh_reserved1)) {
> +		/*
> +		 * If this cluster is contiguous with the old one and
> +		 * adding this new cluster, we don't surpass the limit of
> +		 * xh_reserved1, cool. We will let it be initialized
> +		 * and used like other buckets in the previous cluster.
> +		 * So add it as a contiguous one. The caller will handle
> +		 * its init process.
> +		 */

We also need to limit the maximum size of a btree leaf, otherwise we'll lose
the benefits of hashing because we'll have to search large leaves. What the
maximum size is, I'm not sure of. I think maybe 64k (or clustersize, if it's
bigger) might be a good start. Btw, this means that if a leaf gets too big,
you might have to defeat the btree record merging code :) So, basically if
the leave is below a certain size, you allow it to be merged. Above that
size though, and we actually want a new record.

I think it should be pretty easy though to tell ocfs2_insert_extent to not
attempt merging an extent, even if it's contiguous.
	--Mark

--
Mark Fasheh
