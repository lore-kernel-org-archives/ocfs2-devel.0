From: piaojun <piaojun@huawei.com>
Date: Wed, 27 Dec 2017 16:47:54 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: try to reuse extent block in
 dealloc without meta_alloc
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E373F2908FC7@H3CMLB12-EX.srv.huawei-3com.com>
References: <63ADC13FD55D6546B7DECE290D39E373F2908FC7@H3CMLB12-EX.srv.huawei-3com.com>
Message-ID: <5A435E3A.2060501@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Changwei,

On 2017/12/26 15:55, Changwei Ge wrote:
> A crash issue was reported by John.
> The call trace follows:
> ocfs2_split_extent+0x1ad3/0x1b40 [ocfs2]
> ocfs2_change_extent_flag+0x33a/0x470 [ocfs2]
> ocfs2_mark_extent_written+0x172/0x220 [ocfs2]
> ocfs2_dio_end_io+0x62d/0x910 [ocfs2]
> dio_complete+0x19a/0x1a0
> do_blockdev_direct_IO+0x19dd/0x1eb0
> __blockdev_direct_IO+0x43/0x50
> ocfs2_direct_IO+0x8f/0xa0 [ocfs2]
> generic_file_direct_write+0xb2/0x170
> __generic_file_write_iter+0xc3/0x1b0
> ocfs2_file_write_iter+0x4bb/0xca0 [ocfs2]
> __vfs_write+0xae/0xf0
> vfs_write+0xb8/0x1b0
> SyS_write+0x4f/0xb0
> system_call_fastpath+0x16/0x75
> 
> The BUG code told that extent tree wants to grow but no metadata
> was reserved ahead of time.
>  From my investigation into this issue, the root cause it that although
> enough metadata is not reserved, there should be enough for following use.
> Rightmost extent is merged into its left one due to a certain times of
> marking extent written. Because during marking extent written, we got many
> physically continuous extents. At last, an empty extent showed up and the
> rightmost path is removed from extent tree.
> 
> Add a new mechanism to reuse extent block cached in dealloc which were
> just unlinked from extent tree to solve this crash issue.
> 
> Criteria is that during marking extents *written*, if extent rotation
> and merging results in unlinking extent with growing extent tree later
> without any metadata reserved ahead of time, try to reuse those extents
> in dealloc in which deleted extents are cached.
> 
> Also, this patch addresses the issue John reported that ::dw_zero_count is
> not calculated properly.

Does you patch solve two different problems? If so, I suggest split it
in two patch.

> 
> After applying this patch, the issue John reported was gone.
> Thanks for the reproducer provided by John.
> And this patch has passed ocfs2-test(29 cases) suite running by New H3C Group.
> 
> Reported-by: John Lightsey <john@nixnuts.net>
> Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
> Reviewed-by: Duan Zhang <zhang.duan@h3c.com>
> ---
>   fs/ocfs2/alloc.c | 140 ++++++++++++++++++++++++++++++++++++++++++++++++++++---
>   fs/ocfs2/alloc.h |   1 +
>   fs/ocfs2/aops.c  |  14 ++++--
>   3 files changed, 145 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index ab5105f..56aba96 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -165,6 +165,13 @@ static int ocfs2_dinode_insert_check(struct ocfs2_extent_tree *et,
>   				     struct ocfs2_extent_rec *rec);
>   static int ocfs2_dinode_sanity_check(struct ocfs2_extent_tree *et);
>   static void ocfs2_dinode_fill_root_el(struct ocfs2_extent_tree *et);
> +
> +static int ocfs2_reuse_blk_from_dealloc(handle_t *handle,
> +					struct ocfs2_extent_tree *et,
> +					struct buffer_head **new_eb_bh,
> +					int blk_cnt);
> +static int ocfs2_is_dealloc_empty(struct ocfs2_extent_tree *et);
> +
>   static const struct ocfs2_extent_tree_operations ocfs2_dinode_et_ops = {
>   	.eo_set_last_eb_blk	= ocfs2_dinode_set_last_eb_blk,
>   	.eo_get_last_eb_blk	= ocfs2_dinode_get_last_eb_blk,
> @@ -448,6 +455,7 @@ static void __ocfs2_init_extent_tree(struct ocfs2_extent_tree *et,
>   	if (!obj)
>   		obj = (void *)bh->b_data;
>   	et->et_object = obj;
> +	et->et_dealloc = NULL;

I wonder if there is necessity setting NULL here, as we will resign it
later.

thanks,
Jun

>   
>   	et->et_ops->eo_fill_root_el(et);
>   	if (!et->et_ops->eo_fill_max_leaf_clusters)
> @@ -1213,8 +1221,15 @@ static int ocfs2_add_branch(handle_t *handle,
>   		goto bail;
>   	}
>   
> -	status = ocfs2_create_new_meta_bhs(handle, et, new_blocks,
> -					   meta_ac, new_eb_bhs);
> +	if (meta_ac) {
> +		status = ocfs2_create_new_meta_bhs(handle, et, new_blocks,
> +						   meta_ac, new_eb_bhs);
> +	} else if (!ocfs2_is_dealloc_empty(et)) {
> +		status = ocfs2_reuse_blk_from_dealloc(handle, et,
> +						      new_eb_bhs, new_blocks);
> +	} else {
> +		BUG();
> +	}
>   	if (status < 0) {
>   		mlog_errno(status);
>   		goto bail;
> @@ -1347,8 +1362,15 @@ static int ocfs2_shift_tree_depth(handle_t *handle,
>   	struct ocfs2_extent_list  *root_el;
>   	struct ocfs2_extent_list  *eb_el;
>   
> -	status = ocfs2_create_new_meta_bhs(handle, et, 1, meta_ac,
> -					   &new_eb_bh);
> +	if (meta_ac) {
> +		status = ocfs2_create_new_meta_bhs(handle, et, 1, meta_ac,
> +						   &new_eb_bh);
> +	} else if (!ocfs2_is_dealloc_empty(et)) {
> +		status = ocfs2_reuse_blk_from_dealloc(handle, et,
> +						      &new_eb_bh, 1);
> +	} else {
> +		BUG();
> +	}
>   	if (status < 0) {
>   		mlog_errno(status);
>   		goto bail;
> @@ -1511,7 +1533,7 @@ static int ocfs2_grow_tree(handle_t *handle, struct ocfs2_extent_tree *et,
>   	int depth = le16_to_cpu(el->l_tree_depth);
>   	struct buffer_head *bh = NULL;
>   
> -	BUG_ON(meta_ac == NULL);
> +	BUG_ON(meta_ac == NULL && ocfs2_is_dealloc_empty(et));
>   
>   	shift = ocfs2_find_branch_target(et, &bh);
>   	if (shift < 0) {
> @@ -6562,7 +6584,7 @@ int ocfs2_run_deallocs(struct ocfs2_super *osb,
>   static struct ocfs2_per_slot_free_list *
>   ocfs2_find_per_slot_free_list(int type,
>   			      int slot,
> -			      struct ocfs2_cached_dealloc_ctxt *ctxt)
> +			      struct ocfs2_cached_dealloc_ctxt *ctxt, int new)
>   {
>   	struct ocfs2_per_slot_free_list *fl = ctxt->c_first_suballocator;
>   
> @@ -6573,6 +6595,10 @@ ocfs2_find_per_slot_free_list(int type,
>   		fl = fl->f_next_suballocator;
>   	}
>   
> +	/* we didn't find any, just return NULL if _new_is not set. */
> +	if (!new)
> +		return NULL;
> +
>   	fl = kmalloc(sizeof(*fl), GFP_NOFS);
>   	if (fl) {
>   		fl->f_inode_type = type;
> @@ -6585,6 +6611,106 @@ ocfs2_find_per_slot_free_list(int type,
>   	return fl;
>   }
>   
> +/* Return Value 1 indicates empty */
> +static int ocfs2_is_dealloc_empty(struct ocfs2_extent_tree *et)
> +{
> +	struct ocfs2_per_slot_free_list *fl;
> +	struct ocfs2_super *osb =
> +		OCFS2_SB(ocfs2_metadata_cache_get_super(et->et_ci));
> +
> +	if (!et->et_dealloc)
> +		return 1;
> +
> +	fl = ocfs2_find_per_slot_free_list(EXTENT_ALLOC_SYSTEM_INODE,
> +					   osb->slot_num, et->et_dealloc, 0);
> +
> +	return fl ? 0 : 1;
> +}
> +
> +/* If extent was deleted from tree due to extent rotation and merging, and
> + * no metadata is reserved ahead of time. Try to reuse some extents
> + * just deleted. This is only used to reuse extent blocks.
> + * It is supposed to find enough extent blocks in dealloc if our estimation
> + * on metadata is accurate.
> + */
> +static int ocfs2_reuse_blk_from_dealloc(handle_t *handle,
> +					struct ocfs2_extent_tree *et,
> +					struct buffer_head **new_eb_bh,
> +					int blk_cnt)
> +{
> +	int i, status = -ENOSPC;
> +	struct ocfs2_cached_dealloc_ctxt *dealloc;
> +	struct ocfs2_per_slot_free_list *fl;
> +	struct ocfs2_cached_block_free *bf;
> +	struct ocfs2_extent_block *eb;
> +	struct ocfs2_super *osb =
> +		OCFS2_SB(ocfs2_metadata_cache_get_super(et->et_ci));
> +
> +	dealloc = et->et_dealloc;
> +	if (!dealloc)
> +		goto bail;
> +
> +	for (i = 0; i < blk_cnt; i++) {
> +		fl = ocfs2_find_per_slot_free_list(EXTENT_ALLOC_SYSTEM_INODE,
> +						   osb->slot_num, dealloc, 0);
> +		/* The caller should guarantee that dealloc has cached some
> +		 * extent blocks.
> +		 */
> +		BUG_ON(!fl);
> +
> +		bf = fl->f_first;
> +		fl->f_first = bf->free_next;
> +
> +		new_eb_bh[i] = sb_getblk(osb->sb, bf->free_blk);
> +		if (new_eb_bh[i] == NULL) {
> +			status = -ENOMEM;
> +			mlog_errno(status);
> +			goto bail;
> +		}
> +
> +		mlog(0, "Reusing block(%llu) from dealloc\n", bf->free_blk);
> +
> +		ocfs2_set_new_buffer_uptodate(et->et_ci, new_eb_bh[i]);
> +
> +		status = ocfs2_journal_access_eb(handle, et->et_ci,
> +						 new_eb_bh[i],
> +						 OCFS2_JOURNAL_ACCESS_CREATE);
> +		if (status < 0) {
> +			mlog_errno(status);
> +			goto bail;
> +		}
> +
> +		memset(new_eb_bh[i]->b_data, 0, osb->sb->s_blocksize);
> +		eb = (struct ocfs2_extent_block *) new_eb_bh[i]->b_data;
> +
> +		/* We can't guarantee that buffer head is still cached, so
> +		 * polutlate the extent block again.
> +		 */
> +		strcpy(eb->h_signature, OCFS2_EXTENT_BLOCK_SIGNATURE);
> +		eb->h_blkno = cpu_to_le64(bf->free_blk);
> +		eb->h_fs_generation = cpu_to_le32(osb->fs_generation);
> +		eb->h_suballoc_slot = cpu_to_le16(osb->slot_num);
> +		eb->h_suballoc_loc = cpu_to_le64(bf->free_bg);
> +		eb->h_suballoc_bit = cpu_to_le16(bf->free_bit);
> +		eb->h_list.l_count =
> +			cpu_to_le16(ocfs2_extent_recs_per_eb(osb->sb));
> +
> +		/* We'll also be dirtied by the caller, so
> +		 * this isn't absolutely necessary.
> +		 */
> +		ocfs2_journal_dirty(handle, new_eb_bh[i]);
> +
> +		if (!fl->f_first) {
> +			dealloc->c_first_suballocator = fl->f_next_suballocator;
> +			kfree(fl);
> +		}
> +		kfree(bf);
> +	}
> +
> +bail:
> +	return status;
> +}
> +
>   int ocfs2_cache_block_dealloc(struct ocfs2_cached_dealloc_ctxt *ctxt,
>   			      int type, int slot, u64 suballoc,
>   			      u64 blkno, unsigned int bit)
> @@ -6593,7 +6719,7 @@ int ocfs2_cache_block_dealloc(struct ocfs2_cached_dealloc_ctxt *ctxt,
>   	struct ocfs2_per_slot_free_list *fl;
>   	struct ocfs2_cached_block_free *item;
>   
> -	fl = ocfs2_find_per_slot_free_list(type, slot, ctxt);
> +	fl = ocfs2_find_per_slot_free_list(type, slot, ctxt, 1);
>   	if (fl == NULL) {
>   		ret = -ENOMEM;
>   		mlog_errno(ret);
> diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
> index 27b75cf..250bcac 100644
> --- a/fs/ocfs2/alloc.h
> +++ b/fs/ocfs2/alloc.h
> @@ -61,6 +61,7 @@ struct ocfs2_extent_tree {
>   	ocfs2_journal_access_func		et_root_journal_access;
>   	void					*et_object;
>   	unsigned int				et_max_leaf_clusters;
> +	struct ocfs2_cached_dealloc_ctxt	*et_dealloc;
>   };
>   
>   /*
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index d151632..1bbd5c8 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -797,6 +797,7 @@ struct ocfs2_write_ctxt {
>   	struct ocfs2_cached_dealloc_ctxt w_dealloc;
>   
>   	struct list_head		w_unwritten_list;
> +	unsigned int			w_unwritten_count;
>   };
>   
>   void ocfs2_unlock_and_free_pages(struct page **pages, int num_pages)
> @@ -1386,6 +1387,7 @@ static int ocfs2_unwritten_check(struct inode *inode,
>   	desc->c_clear_unwritten = 0;
>   	list_add_tail(&new->ue_ip_node, &oi->ip_unwritten_list);
>   	list_add_tail(&new->ue_node, &wc->w_unwritten_list);
> +	wc->w_unwritten_count++;
>   	new = NULL;
>   unlock:
>   	spin_unlock(&oi->ip_lock);
> @@ -1762,8 +1764,8 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
>   		 */
>   		ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode),
>   					      wc->w_di_bh);
> -		ret = ocfs2_lock_allocators(inode, &et,
> -					    clusters_to_alloc, extents_to_split,
> +		ret = ocfs2_lock_allocators(inode, &et, clusters_to_alloc,
> +					    2*extents_to_split,
>   					    &data_ac, &meta_ac);
>   		if (ret) {
>   			mlog_errno(ret);
> @@ -2256,7 +2258,7 @@ static int ocfs2_dio_wr_get_block(struct inode *inode, sector_t iblock,
>   		ue->ue_phys = desc->c_phys;
>   
>   		list_splice_tail_init(&wc->w_unwritten_list, &dwc->dw_zero_list);
> -		dwc->dw_zero_count++;
> +		dwc->dw_zero_count += wc->w_unwritten_count;
>   	}
>   
>   	ret = ocfs2_write_end_nolock(inode->i_mapping, pos, len, len, wc);
> @@ -2330,6 +2332,12 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>   
>   	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), di_bh);
>   
> +	/* Attach dealloc with extent tree in case that we may reuse extents
> +	 * which are already unlinked from current extent tree due to extent
> +	 * rotation and merging.
> +	 */
> +	et.et_dealloc = &dealloc;
> +
>   	ret = ocfs2_lock_allocators(inode, &et, 0, dwc->dw_zero_count*2,
>   				    &data_ac, &meta_ac);
>   	if (ret) {
> 
