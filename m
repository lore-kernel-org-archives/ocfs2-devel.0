From: Christoph Hellwig <hch@lst.de>
Date: Fri, 31 Dec 2010 14:15:24 +0100
Subject: [Ocfs2-devel] [PATCH 05/34] ocfs2: Remove mlog(0) from
	fs/ocfs2/alloc.c
In-Reply-To: <1293089477-5019-5-git-send-email-tm@tao.ma>
References: <4D12F7E7.1090204@tao.ma>
	<1293089477-5019-5-git-send-email-tm@tao.ma>
Message-ID: <20101231131524.GB27129@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

> +		(unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
> +		cpos, len, index, le32_to_cpu(rec->e_cpos),
> +		ocfs2_rec_clusters(el, rec));
>  
>  	if (le32_to_cpu(rec->e_cpos) == cpos || rec_range == trunc_range) {
>  		ret = ocfs2_truncate_rec(handle, et, path, index, dealloc,
> @@ -5780,9 +5789,6 @@ int ocfs2_truncate_log_append(struct ocfs2_super *osb,
>  	struct ocfs2_dinode *di;
>  	struct ocfs2_truncate_log *tl;
>  
> -	mlog(0, "start_blk = %llu, num_clusters = %u\n",
> -	     (unsigned long long)start_blk, num_clusters);
> -
>  	BUG_ON(mutex_trylock(&tl_inode->i_mutex));
>  
>  	start_cluster = ocfs2_blocks_to_clusters(osb->sb, start_blk);
> @@ -5819,10 +5825,9 @@ int ocfs2_truncate_log_append(struct ocfs2_super *osb,
>  		goto bail;
>  	}
>  
> -	mlog(0, "Log truncate of %u clusters starting at cluster %u to "
> -	     "%llu (index = %d)\n", num_clusters, start_cluster,
> -	     (unsigned long long)OCFS2_I(tl_inode)->ip_blkno, index);
> -
> +	trace_ocfs2_truncate_log_append(
> +		(unsigned long long)OCFS2_I(tl_inode)->ip_blkno, index,
> +		start_cluster, num_clusters);
>  	if (ocfs2_truncate_log_can_coalesce(tl, start_cluster)) {
>  		/*
>  		 * Move index back to the record we are coalescing with.
> @@ -5831,9 +5836,10 @@ int ocfs2_truncate_log_append(struct ocfs2_super *osb,
>  		index--;
>  
>  		num_clusters += le32_to_cpu(tl->tl_recs[index].t_clusters);
> -		mlog(0, "Coalesce with index %u (start = %u, clusters = %u)\n",
> -		     index, le32_to_cpu(tl->tl_recs[index].t_start),
> -		     num_clusters);
> +		trace_ocfs2_truncate_log_append(
> +			(unsigned long long)OCFS2_I(tl_inode)->ip_blkno,
> +			index, le32_to_cpu(tl->tl_recs[index].t_start),
> +			num_clusters);
>  	} else {
>  		tl->tl_recs[index].t_start = cpu_to_le32(start_cluster);
>  		tl->tl_used = cpu_to_le16(index + 1);
> @@ -5896,8 +5902,9 @@ static int ocfs2_replay_truncate_records(struct ocfs2_super *osb,
>  		/* if start_blk is not set, we ignore the record as
>  		 * invalid. */
>  		if (start_blk) {
> -			mlog(0, "free record %d, start = %u, clusters = %u\n",
> -			     i, le32_to_cpu(rec.t_start), num_clusters);
> +			trace_ocfs2_replay_truncate_records(
> +				(unsigned long long)OCFS2_I(tl_inode)->ip_blkno,
> +				i, le32_to_cpu(rec.t_start), num_clusters);
>  
>  			status = ocfs2_free_clusters(handle, data_alloc_inode,
>  						     data_alloc_bh, start_blk,
> @@ -5938,8 +5945,9 @@ int __ocfs2_flush_truncate_log(struct ocfs2_super *osb)
>  
>  	tl = &di->id2.i_dealloc;
>  	num_to_flush = le16_to_cpu(tl->tl_used);
> -	mlog(0, "Flush %u records from truncate log #%llu\n",
> -	     num_to_flush, (unsigned long long)OCFS2_I(tl_inode)->ip_blkno);
> +	trace_ocfs2_flush_truncate_log(
> +		(unsigned long long)OCFS2_I(tl_inode)->ip_blkno,
> +		num_to_flush);
>  	if (!num_to_flush) {
>  		status = 0;
>  		goto out;
> @@ -6076,7 +6084,7 @@ int ocfs2_begin_truncate_log_recovery(struct ocfs2_super *osb,
>  
>  	*tl_copy = NULL;
>  
> -	mlog(0, "recover truncate log from slot %d\n", slot_num);
> +	trace_ocfs2_begin_truncate_log_recovery(slot_num);
>  
>  	status = ocfs2_get_truncate_log_info(osb, slot_num, &tl_inode, &tl_bh);
>  	if (status < 0) {
> @@ -6093,8 +6101,7 @@ int ocfs2_begin_truncate_log_recovery(struct ocfs2_super *osb,
>  
>  	tl = &di->id2.i_dealloc;
>  	if (le16_to_cpu(tl->tl_used)) {
> -		mlog(0, "We'll have %u logs to recover\n",
> -		     le16_to_cpu(tl->tl_used));
> +		trace_ocfs2_truncate_log_recovery_num(le16_to_cpu(tl->tl_used));
>  
>  		*tl_copy = kmalloc(tl_bh->b_size, GFP_KERNEL);
>  		if (!(*tl_copy)) {
> @@ -6151,8 +6158,9 @@ int ocfs2_complete_truncate_log_recovery(struct ocfs2_super *osb,
>  
>  	tl = &tl_copy->id2.i_dealloc;
>  	num_recs = le16_to_cpu(tl->tl_used);
> -	mlog(0, "cleanup %u records from %llu\n", num_recs,
> -	     (unsigned long long)le64_to_cpu(tl_copy->i_blkno));
> +	trace_ocfs2_complete_truncate_log_recovery(
> +		(unsigned long long)le64_to_cpu(tl_copy->i_blkno),
> +		num_recs);
>  
>  	mutex_lock(&tl_inode->i_mutex);
>  	for(i = 0; i < num_recs; i++) {
> @@ -6310,8 +6318,8 @@ static int ocfs2_free_cached_blocks(struct ocfs2_super *osb,
>  		else
>  			bg_blkno = ocfs2_which_suballoc_group(head->free_blk,
>  							      head->free_bit);
> -		mlog(0, "Free bit: (bit %u, blkno %llu)\n",
> -		     head->free_bit, (unsigned long long)head->free_blk);
> +		trace_ocfs2_free_cached_blocks(
> +		     (unsigned long long)head->free_blk, head->free_bit);
>  
>  		ret = ocfs2_free_suballoc_bits(handle, inode, di_bh,
>  					       head->free_bit, bg_blkno, 1);
> @@ -6364,8 +6372,7 @@ int ocfs2_cache_cluster_dealloc(struct ocfs2_cached_dealloc_ctxt *ctxt,
>  		return ret;
>  	}
>  
> -	mlog(0, "Insert clusters: (bit %u, blk %llu)\n",
> -	     bit, (unsigned long long)blkno);
> +	trace_ocfs2_cache_cluster_dealloc((unsigned long long)blkno, bit);
>  
>  	item->free_blk = blkno;
>  	item->free_bit = bit;
> @@ -6440,8 +6447,8 @@ int ocfs2_run_deallocs(struct ocfs2_super *osb,
>  		fl = ctxt->c_first_suballocator;
>  
>  		if (fl->f_first) {
> -			mlog(0, "Free items: (type %u, slot %d)\n",
> -			     fl->f_inode_type, fl->f_slot);
> +			trace_ocfs2_run_deallocs(fl->f_inode_type,
> +						 fl->f_slot);
>  			ret2 = ocfs2_free_cached_blocks(osb,
>  							fl->f_inode_type,
>  							fl->f_slot,
> @@ -6518,8 +6525,9 @@ int ocfs2_cache_block_dealloc(struct ocfs2_cached_dealloc_ctxt *ctxt,
>  		goto out;
>  	}
>  
> -	mlog(0, "Insert: (type %d, slot %u, bit %u, blk %llu)\n",
> -	     type, slot, bit, (unsigned long long)blkno);
> +	trace_ocfs2_cache_block_dealloc(type, slot,
> +					(unsigned long long)suballoc,
> +					(unsigned long long)blkno, bit);
>  
>  	item->free_bg = suballoc;
>  	item->free_blk = blkno;
> @@ -6999,8 +7007,11 @@ start:
>  		goto bail;
>  	}
>  
> -	mlog(0, "inode->ip_clusters = %u, tree_depth = %u\n",
> -	     OCFS2_I(inode)->ip_clusters, path->p_tree_depth);
> +	trace_ocfs2_commit_truncate(
> +		(unsigned long long)OCFS2_I(inode)->ip_blkno,
> +		new_highest_cpos,
> +		OCFS2_I(inode)->ip_clusters,
> +		path->p_tree_depth);
>  
>  	/*
>  	 * By now, el will point to the extent list on the bottom most
> diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
> index 8d4e49a..2dfc3b0 100644
> --- a/fs/ocfs2/ocfs2_trace.h
> +++ b/fs/ocfs2/ocfs2_trace.h
> @@ -6,6 +6,507 @@
>  
>  #include <linux/tracepoint.h>
>  
> +DECLARE_EVENT_CLASS(ocfs2__int,
> +
> +	TP_PROTO(int num),
> +
> +	TP_ARGS(num),
> +
> +	TP_STRUCT__entry(
> +		__field(	int,	num			)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->num	= 	num;
> +	),
> +
> +	TP_printk("%d", __entry->num)
> +);

If you'd split the even up into classes depending on the actual meaning
of num the trace could contain a descriptive name that makes it a lot
more readable.  And btw, the above would be a lot more readable if
formatted like normal kernel code:

DECLARE_EVENT_CLASS(ocfs2__int,
	TP_PROTO(int num),
	TP_ARGS(num),
	TP_STRUCT__entry(
		__field(int, num)
	),
	TP_fast_assign(
		__entry->num = num;
	),

	TP_printk("%d", __entry->num)
);

> +DEFINE_EVENT(ocfs2__truncate_log_ops, ocfs2_truncate_log_append,
> +
> +	TP_PROTO(unsigned long long blkno, int index,
> +		 unsigned int start, unsigned int num),
> +
> +	TP_ARGS(blkno, index, start, num)
> +);

FYI, if you have a lot of instances ofa given even class using a little
macro makes declaring them a lot simpler, take a look at
fs/xfs/linux-2.6/xfs_trace.h for examples.
