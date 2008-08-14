From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 14 Aug 2008 13:01:44 -0700
Subject: [Ocfs2-devel] [PATCH 04/15] Make extend allocation generic.
In-Reply-To: <1218061894-7693-4-git-send-email-tao.ma@oracle.com>
References: <489A94F4.90903@oracle.com>
	<1218061894-7693-4-git-send-email-tao.ma@oracle.com>
Message-ID: <20080814200144.GB28875@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 07, 2008 at 06:31:26AM +0800, Tao Ma wrote:
> The old ocfs2_do_extend_allocation is restrictly to be used in file
> extension. Now a new function named ocfs2_do_cluster_allocation will
> handle the issue of generic extend allocation and it is created in
> suballoc.c.

<snip> 

> +int ocfs2_add_clusters_in_btree(struct ocfs2_super *osb,
> +				struct inode *inode,
> +				u32 *logical_offset,
> +				u32 clusters_to_add,
> +				int mark_unwritten,
> +				struct buffer_head *root_bh,
> +				struct ocfs2_extent_list *root_el,
> +				handle_t *handle,
> +				struct ocfs2_alloc_context *data_ac,
> +				struct ocfs2_alloc_context *meta_ac,
> +				enum ocfs2_alloc_restarted *reason_ret,
> +				enum ocfs2_extent_tree_type type)

	It seems to me that if you have root_bh and type, you can create
an ocfs2_extent_tree and calculate root_el from that.  So you don't need
root_el in this function's arguments, and callers don't need to know how
to compute it.

Joel

> +{
> +	int status = 0;
> +	int free_extents;
> +	enum ocfs2_alloc_restarted reason = RESTART_NONE;
> +	u32 bit_off, num_bits;
> +	u64 block;
> +	u8 flags = 0;
> +
> +	BUG_ON(!clusters_to_add);
> +
> +	if (mark_unwritten)
> +		flags = OCFS2_EXT_UNWRITTEN;
> +
> +	free_extents = ocfs2_num_free_extents(osb, inode, root_bh, type);
> +	if (free_extents < 0) {
> +		status = free_extents;
> +		mlog_errno(status);
> +		goto leave;
> +	}
> +
> +	/* there are two cases which could cause us to EAGAIN in the
> +	 * we-need-more-metadata case:
> +	 * 1) we haven't reserved *any*
> +	 * 2) we are so fragmented, we've needed to add metadata too
> +	 *    many times. */
> +	if (!free_extents && !meta_ac) {
> +		mlog(0, "we haven't reserved any metadata!\n");
> +		status = -EAGAIN;
> +		reason = RESTART_META;
> +		goto leave;
> +	} else if ((!free_extents)
> +		   && (ocfs2_alloc_context_bits_left(meta_ac)
> +		       < ocfs2_extend_meta_needed(root_el))) {
> +		mlog(0, "filesystem is really fragmented...\n");
> +		status = -EAGAIN;
> +		reason = RESTART_META;
> +		goto leave;
> +	}
> +
> +	status = __ocfs2_claim_clusters(osb, handle, data_ac, 1,
> +					clusters_to_add, &bit_off, &num_bits);
> +	if (status < 0) {
> +		if (status != -ENOSPC)
> +			mlog_errno(status);
> +		goto leave;
> +	}
> +
> +	BUG_ON(num_bits > clusters_to_add);
> +
> +	/* reserve our write early -- insert_extent may update the inode */
> +	status = ocfs2_journal_access(handle, inode, root_bh,
> +				      OCFS2_JOURNAL_ACCESS_WRITE);
> +	if (status < 0) {
> +		mlog_errno(status);
> +		goto leave;
> +	}
> +
> +	block = ocfs2_clusters_to_blocks(osb->sb, bit_off);
> +	mlog(0, "Allocating %u clusters at block %u for inode %llu\n",
> +	     num_bits, bit_off, (unsigned long long)OCFS2_I(inode)->ip_blkno);
> +	status = ocfs2_insert_extent(osb, handle, inode, root_bh,
> +				     *logical_offset, block, num_bits,
> +				     flags, meta_ac, type);
> +	if (status < 0) {
> +		mlog_errno(status);
> +		goto leave;
> +	}
> +
> +	status = ocfs2_journal_dirty(handle, root_bh);
> +	if (status < 0) {
> +		mlog_errno(status);
> +		goto leave;
> +	}
> +
> +	clusters_to_add -= num_bits;
> +	*logical_offset += num_bits;
> +
> +	if (clusters_to_add) {
> +		mlog(0, "need to alloc once more, wanted = %u\n",
> +		     clusters_to_add);
> +		status = -EAGAIN;
> +		reason = RESTART_TRANS;
> +	}
> +
> +leave:
> +	mlog_exit(status);
> +	if (reason_ret)
> +		*reason_ret = reason;
> +	return status;
> +}

-- 

"You don't make the poor richer by making the rich poorer."
	- Sir Winston Churchill

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
