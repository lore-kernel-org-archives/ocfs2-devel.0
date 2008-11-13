From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 12 Nov 2008 19:28:19 -0800
Subject: [Ocfs2-devel] [PATCH 3/4] ocfs2: Add a name indexed b-tree to
	directory	inodes
In-Reply-To: <1226543048-911-4-git-send-email-mfasheh@suse.com>
References: <1226543048-911-1-git-send-email-mfasheh@suse.com>
	<1226543048-911-4-git-send-email-mfasheh@suse.com>
Message-ID: <20081113032819.GD27602@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Nov 12, 2008 at 06:24:07PM -0800, Mark Fasheh wrote:
> This patch makes use of Ocfs2's flexible btree code to add an additional
> tree to directory inodes. The new tree stores an array of small,
> fixed-length records in each leaf block. Each record stores a hash value,
> and pointer to a block in the traditional (unindexed) directory tree where a
> dirent with the given name hash resides. Lookup exclusively uses this tree
> to find dirents, thus providing us with constant time name lookups.

	Whee!

> +static struct ocfs2_extent_tree_operations ocfs2_dx_root_et_ops = {
> +	.eo_set_last_eb_blk	= ocfs2_dx_root_set_last_eb_blk,
> +	.eo_get_last_eb_blk	= ocfs2_dx_root_get_last_eb_blk,
> +	.eo_update_clusters	= ocfs2_dx_root_update_clusters,
> +	.eo_sanity_check	= ocfs2_dx_root_sanity_check,
> +	.eo_fill_root_el	= ocfs2_dx_root_fill_root_el,
> +};

	This makes me happy.

> +static int ocfs2_dx_dir_lookup(struct inode *inode,
> +			       struct ocfs2_extent_list *el,
> +			       struct ocfs2_dx_hinfo *hinfo,
> +			       u32 *ret_cpos,
> +			       u64 *ret_phys_blkno)
> +{
> +	int ret = 0;
> +	unsigned int cend, uninitialized_var(clen);
> +	u32 uninitialized_var(cpos);
> +	u64 uninitialized_var(blkno);
> +	u32 name_hash = hinfo->major_hash;
> +
> +	ret = ocfs2_dx_dir_lookup_rec(inode, el, name_hash, &cpos, &blkno,
> +				      &clen);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +
> +	cend = cpos + clen;
> +	if (name_hash >= cend) {
> +		/* We want the last cluster */
> +		blkno += ocfs2_clusters_to_blocks(inode->i_sb, clen - 1);
> +		cpos += clen - 1;

	I assume this means that we have an "anything at the end"
behavior going on here?  Perhaps an explicit comment on that.

> +static int ocfs2_delete_entry_dx(handle_t *handle, struct inode *dir,
> +				 struct ocfs2_dir_lookup_result *lookup)
> +{
> +	int ret, index;
> +	struct buffer_head *leaf_bh = lookup->dl_leaf_bh;
> +	struct ocfs2_dx_leaf *dx_leaf;
> +	struct ocfs2_dx_entry *dx_entry = lookup->dl_dx_entry;
> +
> +	dx_leaf = (struct ocfs2_dx_leaf *) lookup->dl_dx_leaf_bh->b_data;
> +	/* Neither of these are a disk corruption - that should have
> +	 * been caught by lookup, before we got here. */
> +	BUG_ON(le16_to_cpu(dx_leaf->dl_count) <= 0);
> +	BUG_ON(le16_to_cpu(dx_leaf->dl_num_used) <= 0);
> +
> +	index = (char *)dx_entry - (char *)dx_leaf->dl_entries;
> +	index /= sizeof(*dx_entry);
> +
> +	if (index >= le16_to_cpu(dx_leaf->dl_num_used)) {
> +		mlog(ML_ERROR, "Dir %llu: Bad dx_entry ptr idx %d, (%p, %p)\n",
> +		     (unsigned long long)OCFS2_I(dir)->ip_blkno, index, dx_leaf,
> +		     dx_entry);
> +		return -EIO;
> +	}
> +
> +	mlog(0, "Dir %llu: delete entry at index: %d\n",
> +	     (unsigned long long)OCFS2_I(dir)->ip_blkno, index);
> +
> +	/*
> +	 * Add the index leaf into the journal before removing the
> +	 * unindexed entry. If we get an error return from
> +	 * __ocfs2_delete_entry(), then it hasn't removed the entry
> +	 * yet. Likewise, successful return means we *must* remove the
> +	 * indexed entry.
> +	 */
> +	ret = ocfs2_journal_access(handle, dir, lookup->dl_dx_leaf_bh,
> +				   OCFS2_JOURNAL_ACCESS_WRITE);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +
> +	ret = __ocfs2_delete_entry(handle, dir, lookup->dl_entry,
> +				   leaf_bh, leaf_bh->b_data, leaf_bh->b_size);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +
> +	ocfs2_dx_leaf_remove_entry(dx_leaf, index);
> +
> +	ocfs2_journal_dirty(handle, lookup->dl_dx_leaf_bh);
> +
> +out:
> +	return ret;
> +}

	I love using indexed lookup for unlink(2).

>  static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
>  				   unsigned int blocks_wanted,
> +				   struct ocfs2_dir_lookup_result *lookup,
>  				   struct buffer_head **first_block_bh)
>  {

<snip>

> +	if (ocfs2_supports_indexed_dirs(osb)) {

	The multiple places you have to stick this check in for proper
ordering is fun.  I understand why, though.

>  /*
> + * A directory indexing block. Each indexed directory has one of these,
> + * pointed to by ocfs2_dinode.
> + *
> + * This block stores an indexed btree root, and a set of free space
> + * start-of-list pointers.
> + */
> +struct ocfs2_dx_root_block {
> +	__u8		dr_signature[8];	/* Signature for verification */
> +	__le64		dr_csum;		/* Checksum (unused) */
> +	__le16		dr_suballoc_slot;	/* Slot suballocator this
> +						 * block belongs to. */
> +	__le16		dr_suballoc_bit;	/* Bit offset in suballocator
> +						 * block group */
> +	__le32		dr_fs_generation;	/* Must match super block */
> +	__le64		dr_blkno;		/* Offset on disk, in blocks */
> +	__le64		dr_last_eb_blk;		/* Pointer to last
> +						 * extent block */
> +	__le32		dr_clusters;		/* Clusters allocated
> +						 * to the indexed tree. */
> +	__le32		dr_reserved1;
> +	__le64		dr_dir_blkno;		/* Pointer to parent inode */
> +	__le64		dr_reserved2;
> +	__le64		dr_reserved3[16];
> +	struct ocfs2_extent_list	dr_list; /* Keep this aligned to 128
> +						  * bits for maximum space
> +						  * efficiency. */
> +};
> +
> +/*
> + * A directory entry in the indexed tree. We don't store the full name here,
> + * but instead provide a pointer to the full dirent in the unindexed tree.
> + *
> + * We also store name_len here so as to reduce the number of leaf blocks we
> + * need to search in case of collisions.
> + */
> +struct ocfs2_dx_entry {
> +	__le32		dx_major_hash;	/* Used to find logical
> +					 * cluster in index */
> +	__le32		dx_minor_hash;	/* Lower bits used to find
> +					 * block in cluster */
> +	__le64		dx_dirent_blk;	/* Physical block in unindexed
> +					 * tree holding this dirent. */
> +};
> +
> +/*
> + * The header of a leaf block in the indexed tree.
> + */
> +struct ocfs2_dx_leaf {
> +	__u8		dl_signature[8];/* Signature for verification */
> +	__le64		dl_csum;	/* Checksum (unused) */
> +	__le64		dl_reserved1;
> +	__le32		dl_reserved2;
> +	__le16		dl_count;	/* Maximum number of entries
> +					 * possible in ih_entries */
> +	__le16		dl_num_used;	/* Current number of
> +					 * ih_entries entries */
> +	struct	ocfs2_dx_entry		dl_entries[0];	/* Indexed dir entries
> +							 * in a packed array of
> +							 * length ih_num_used */
> +};

	I'd love to see offset annotations on these structures.
	Otherwise, this is awesome!

Joel

-- 

"The first requisite of a good citizen in this republic of ours
 is that he shall be able and willing to pull his weight."
	- Theodore Roosevelt

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
