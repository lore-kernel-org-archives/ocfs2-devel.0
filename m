From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 1 May 2009 20:53:19 -0700
Subject: [Ocfs2-devel] [PATCH 10/39] ocfs2: Add support for	incrementing
	refcount in the tree.
In-Reply-To: <1241045931-24607-10-git-send-email-tao.ma@oracle.com>
References: <49F95A79.6040806@oracle.com>
	<1241045931-24607-10-git-send-email-tao.ma@oracle.com>
Message-ID: <20090502035318.GC17236@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Apr 30, 2009 at 06:58:22AM +0800, Tao Ma wrote:
> +
> +static void ocfs2_get_refcount_rec_from_list(struct ocfs2_caching_info *ci,
> +					struct buffer_head *ref_leaf_bh,
> +					u64 cpos, unsigned int len,
> +					struct ocfs2_refcount_rec *ret_rec,
> +					int *index)
> +{
> +	int i = 0;
> +	struct ocfs2_refcount_block *rb =
> +		(struct ocfs2_refcount_block *)ref_leaf_bh->b_data;
> +	struct ocfs2_refcount_rec *rec = NULL;
> +
> +	for (; i < le16_to_cpu(rb->rf_records.rl_used); i++) {
> +		rec = &rb->rf_records.rl_recs[i];
> +
> +		if (le64_to_cpu(rec->r_cpos) +
> +		    le32_to_cpu(rec->r_clusters) <= cpos)
> +			continue;
> +		else if (le64_to_cpu(rec->r_cpos) > cpos)
> +			break;
> +
> +		/* ok, cpos fail in this rec. Just return. */
> +		if (ret_rec)
> +			*ret_rec = *rec;
> +		goto out;
> +	}
> +
> +	if (ret_rec) {
> +		/* We meet with a hole here, so fake the rec. */
> +		ret_rec->r_cpos = cpu_to_le64(cpos);
> +		ret_rec->r_refcount = 0;
> +		if (i < le16_to_cpu(rb->rf_records.rl_used) &&
> +		    le64_to_cpu(rec->r_cpos) < cpos + len)
> +			ret_rec->r_clusters =
> +				cpu_to_le32(le64_to_cpu(rec->r_cpos) - cpos);
> +		else
> +			ret_rec->r_clusters = cpu_to_le32(len);
> +	}
> +
> +out:
> +	*index = i;
> +	return;
> +}

	No need for 'return' at the end of a void function.

> +static int ocfs2_expand_inline_ref_root(handle_t *handle,
> +					struct ocfs2_caching_info *ci,
> +					struct buffer_head *ref_root_bh,
> +					struct buffer_head **ref_leaf_bh,
> +					struct ocfs2_alloc_context *meta_ac)
> +{
> +	int ret;
> +	u16 suballoc_bit_start;
> +	u32 num_got;
> +	u64 blkno;
> +	struct super_block *sb = ocfs2_metadata_cache_get_super(ci);
> +	struct buffer_head *new_bh = NULL;
> +	struct ocfs2_refcount_block *new_rb;
> +	struct ocfs2_refcount_block *root_rb =
> +			(struct ocfs2_refcount_block *)ref_root_bh->b_data;
> +
> +	ret = ocfs2_journal_access_rb(handle, ci, ref_root_bh,
> +				      OCFS2_JOURNAL_ACCESS_WRITE);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +
> +	ret = ocfs2_claim_metadata(OCFS2_SB(sb), handle, meta_ac, 1,
> +				   &suballoc_bit_start, &num_got,
> +				   &blkno);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +
> +	new_bh = sb_getblk(sb, blkno);
> +	if (new_bh == NULL) {
> +		ret = -EIO;
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +	ocfs2_set_new_buffer_uptodate(ci, new_bh);
> +
> +	ret = ocfs2_journal_access_rb(handle, ci, new_bh,
> +				      OCFS2_JOURNAL_ACCESS_CREATE);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +
> +	/*
> +	 * Initialize ocfs2_refcount_block.
> +	 * It should contain the same information as the old root.
> +	 * so just memcpy it and change the corresponding field.
> +	 */
> +	memcpy(new_bh->b_data, ref_root_bh->b_data, sb->s_blocksize);
> +
> +	new_rb = (struct ocfs2_refcount_block *)new_bh->b_data;
> +	new_rb->rf_suballoc_slot = cpu_to_le16(OCFS2_SB(sb)->slot_num);
> +	new_rb->rf_suballoc_bit = cpu_to_le16(suballoc_bit_start);
> +	new_rb->rf_blkno = cpu_to_le64(blkno);
> +	new_rb->rf_cpos = cpu_to_le32(0);
> +	ocfs2_journal_dirty(handle, new_bh);

	The new leaf needs to set the LEAF flag and set rf_parent to the
root.

> +static void swap_refcount_rec(void *a, void *b, int size)
> +{
> +	struct ocfs2_refcount_rec *l = a, *r = b, tmp;
> +
> +	tmp = *l;
> +	memcpy(l, r, sizeof(struct ocfs2_refcount_rec));
> +	memcpy(r, &tmp, sizeof(struct ocfs2_refcount_rec));

	You don't need the memcpy's here.  You can just do:

	tmp = *l;
	*l = *r;
	*r = tmp;

> +static int ocfs2_new_leaf_refcount_block(handle_t *handle,
> +					 struct ocfs2_caching_info *ci,
> +					 struct buffer_head *ref_root_bh,
> +					 struct buffer_head *ref_leaf_bh,
> +					 struct ocfs2_alloc_context *meta_ac)
> +{
> +	int ret;
> +	u16 suballoc_bit_start;
> +	u32 num_got;
> +	u64 blkno;
> +	struct super_block *sb = ocfs2_metadata_cache_get_super(ci);
> +	struct ocfs2_refcount_block *root_rb =
> +			(struct ocfs2_refcount_block *)ref_root_bh->b_data;
> +	struct buffer_head *new_bh = NULL;
> +	struct ocfs2_refcount_block *new_rb;
> +
> +	BUG_ON(!ref_root_bh);
> +	BUG_ON(!(le32_to_cpu(root_rb->rf_flags) & OCFS2_REFCOUNT_TREE_FL));
> +
> +	ret = ocfs2_journal_access_rb(handle, ci, ref_root_bh,
> +				      OCFS2_JOURNAL_ACCESS_WRITE);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +
> +	ret = ocfs2_journal_access_rb(handle, ci, ref_leaf_bh,
> +				      OCFS2_JOURNAL_ACCESS_WRITE);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +
> +	ret = ocfs2_claim_metadata(OCFS2_SB(sb), handle, meta_ac, 1,
> +				   &suballoc_bit_start, &num_got,
> +				   &blkno);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +
> +	new_bh = sb_getblk(sb, blkno);
> +	if (new_bh == NULL) {
> +		ret = -EIO;
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +	ocfs2_set_new_buffer_uptodate(ci, new_bh);
> +
> +	ret = ocfs2_journal_access_rb(handle, ci, new_bh,
> +				      OCFS2_JOURNAL_ACCESS_CREATE);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +
> +	/* Initialize ocfs2_refcount_block. */
> +	new_rb = (struct ocfs2_refcount_block *)new_bh->b_data;
> +	memset(new_rb, 0, sb->s_blocksize);
> +	strcpy((void *)new_rb, OCFS2_REFCOUNT_BLOCK_SIGNATURE);
> +	new_rb->rf_suballoc_slot = cpu_to_le16(OCFS2_SB(sb)->slot_num);
> +	new_rb->rf_suballoc_bit = cpu_to_le16(suballoc_bit_start);
> +	new_rb->rf_fs_generation = cpu_to_le32(OCFS2_SB(sb)->fs_generation);
> +	new_rb->rf_blkno = cpu_to_le64(blkno);
> +	new_rb->rf_flags = cpu_to_le32(OCFS2_REFCOUNT_LEAF_FL);
> +	new_rb->rf_records.rl_count =
> +				cpu_to_le16(ocfs2_refcount_recs_per_rb(sb));

	Need to set rf_parent to the root of the btree.

> +static int ocfs2_split_refcount_rec(handle_t *handle,
> +				    struct ocfs2_caching_info *ci,
> +				    struct buffer_head *ref_root_bh,
> +				    struct buffer_head *ref_leaf_bh,
> +				    struct ocfs2_refcount_rec *split_rec,
> +				    int index,
> +				    struct ocfs2_alloc_context *meta_ac,
> +				    struct ocfs2_cached_dealloc_ctxt *dealloc)
> +{
> +	int ret, recs_need;
> +	u32 len;
> +	struct ocfs2_refcount_block *rb =
> +			(struct ocfs2_refcount_block *)ref_leaf_bh->b_data;
> +	struct ocfs2_refcount_list *rf_list = &rb->rf_records;
> +	struct ocfs2_refcount_rec *orig_rec = &rf_list->rl_recs[index];
> +	struct ocfs2_refcount_rec *tail_rec = NULL;
> +	struct buffer_head *new_bh = NULL;
> +
> +	BUG_ON(!(le32_to_cpu(rb->rf_flags) & OCFS2_REFCOUNT_LEAF_FL));

	This should be:

	BUG_ON(le32_to_cpu(rb->rf_flags) & OCFS2_REFCOUNT_TREE_FL);

Also, split_refcount_rec could probably use a couple comments at each
stage.  Short hings like "ok, remove the entries we just moved over to
the other block".

Joel

-- 

Life's Little Instruction Book #337

	"Reread your favorite book."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
