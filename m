From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 10 Nov 2010 10:52:23 +0800
Subject: [Ocfs2-devel] [PATCH 5/5] ocfs2: Remove mlog(0) from
	fs/ocfs2/alloc.c
In-Reply-To: <4CDA08B6.2070002@oracle.com>
References: <4CDA08B6.2070002@oracle.com>
Message-ID: <1289357543-2538-5-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This is the first try of replacing debug mlog(0,...) to
trace events. Wengang has did some work in his original
patch
http://oss.oracle.com/pipermail/ocfs2-devel/2009-November/005513.html
But he didn't finished it.

So this patch removes all mlog(0,...) from alloc.c and adds
the corresponding tracepoints. Different mlogs have different
solutions.
1. Some are replaced with trace event directly.
2. Some are replaced and some new parameters are added since
   I think we need to know the btree owner in that case.
3. Some are combined into one trace events.
4. Some redundant mlogs are removed.

What's more, it defines some event classes so that we can use
them later.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c       |  165 +++++++++--------
 fs/ocfs2/ocfs2_trace.h |  485 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 573 insertions(+), 77 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 9ab3f27..9bdfaf8 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -50,6 +50,7 @@
 #include "uptodate.h"
 #include "xattr.h"
 #include "refcounttree.h"
+#include "ocfs2_trace.h"
 
 #include "buffer_head_io.h"
 
@@ -886,8 +887,7 @@ static int ocfs2_validate_extent_block(struct super_block *sb,
 	struct ocfs2_extent_block *eb =
 		(struct ocfs2_extent_block *)bh->b_data;
 
-	mlog(0, "Validating extent block %llu\n",
-	     (unsigned long long)bh->b_blocknr);
+	trace_ocfs2_validate_extent_block((unsigned long long)bh->b_blocknr);
 
 	BUG_ON(!buffer_uptodate(bh));
 
@@ -985,7 +985,7 @@ int ocfs2_num_free_extents(struct ocfs2_super *osb,
 bail:
 	brelse(eb_bh);
 
-	mlog(0, "retval = %d\n", retval);
+	trace_ocfs2_num_free_extents(retval);
 	return retval;
 }
 
@@ -1194,8 +1194,11 @@ static int ocfs2_add_branch(handle_t *handle,
 	 * from new_cpos).
 	 */
 	if (root_end > new_cpos) {
-		mlog(0, "adjust the cluster end from %u to %u\n",
-		     root_end, new_cpos);
+		trace_ocfs2_adjust_rightmost_branch(
+			(unsigned long long)
+			ocfs2_metadata_cache_owner(et->et_ci),
+			root_end, new_cpos);
+
 		status = ocfs2_adjust_rightmost_branch(handle, et);
 		if (status) {
 			mlog_errno(status);
@@ -1527,7 +1530,10 @@ static int ocfs2_grow_tree(handle_t *handle, struct ocfs2_extent_tree *et,
 	 * another tree level */
 	if (shift) {
 		BUG_ON(bh);
-		mlog(0, "need to shift tree depth (current = %d)\n", depth);
+		trace_ocfs2_grow_tree(
+			(unsigned long long)
+			ocfs2_metadata_cache_owner(et->et_ci),
+			depth);
 
 		/* ocfs2_shift_tree_depth will return us a buffer with
 		 * the new extent block (so we can pass that to
@@ -1557,7 +1563,6 @@ static int ocfs2_grow_tree(handle_t *handle, struct ocfs2_extent_tree *et,
 
 	/* call ocfs2_add_branch to add the final part of the tree with
 	 * the new data. */
-	mlog(0, "add branch. bh = %p\n", bh);
 	ret = ocfs2_add_branch(handle, et, bh, last_eb_bh,
 			       meta_ac);
 	if (ret < 0) {
@@ -1632,8 +1637,9 @@ static void ocfs2_rotate_leaf(struct ocfs2_extent_list *el,
 	}
 	insert_index = i;
 
-	mlog(0, "ins %u: index %d, has_empty %d, next_free %d, count %d\n",
-	     insert_cpos, insert_index, has_empty, next_free, le16_to_cpu(el->l_count));
+	trace_ocfs2_rotate_leaf(insert_cpos, insert_index,
+				has_empty, next_free,
+				le16_to_cpu(el->l_count));
 
 	BUG_ON(insert_index < 0);
 	BUG_ON(insert_index >= le16_to_cpu(el->l_count));
@@ -2046,7 +2052,7 @@ static void ocfs2_complete_edge_insert(handle_t *handle,
 	left_el = path_leaf_el(left_path);
 	right_el = path_leaf_el(right_path);
 	for(i = left_path->p_tree_depth - 1; i > subtree_index; i--) {
-		mlog(0, "Adjust records at index %u\n", i);
+		trace_ocfs2_complete_edge_insert(i);
 
 		/*
 		 * One nice property of knowing that all of these
@@ -2376,7 +2382,9 @@ static int ocfs2_rotate_tree_right(handle_t *handle,
 		goto out;
 	}
 
-	mlog(0, "Insert: %u, first left path cpos: %u\n", insert_cpos, cpos);
+	trace_ocfs2_rotate_tree_right(
+		(unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
+		insert_cpos, cpos);
 
 	/*
 	 * What we want to do here is:
@@ -2405,8 +2413,10 @@ static int ocfs2_rotate_tree_right(handle_t *handle,
 	 * rotating subtrees.
 	 */
 	while (cpos && insert_cpos <= cpos) {
-		mlog(0, "Rotating a tree: ins. cpos: %u, left path cpos: %u\n",
-		     insert_cpos, cpos);
+		trace_ocfs2_rotate_tree_right(
+			(unsigned long long)
+			ocfs2_metadata_cache_owner(et->et_ci),
+			insert_cpos, cpos);
 
 		ret = ocfs2_find_path(et->et_ci, left_path, cpos);
 		if (ret) {
@@ -2448,10 +2458,10 @@ static int ocfs2_rotate_tree_right(handle_t *handle,
 
 		start = ocfs2_find_subtree_root(et, left_path, right_path);
 
-		mlog(0, "Subtree root at index %d (blk %llu, depth %d)\n",
-		     start,
-		     (unsigned long long) right_path->p_node[start].bh->b_blocknr,
-		     right_path->p_tree_depth);
+		trace_ocfs2_rotate_subtree(start,
+			(unsigned long long)
+			right_path->p_node[start].bh->b_blocknr,
+			right_path->p_tree_depth);
 
 		ret = ocfs2_extend_rotate_transaction(handle, start,
 						      orig_credits, right_path);
@@ -2951,8 +2961,7 @@ static int __ocfs2_rotate_tree_left(handle_t *handle,
 		subtree_root = ocfs2_find_subtree_root(et, left_path,
 						       right_path);
 
-		mlog(0, "Subtree root at index %d (blk %llu, depth %d)\n",
-		     subtree_root,
+		trace_ocfs2_rotate_subtree(subtree_root,
 		     (unsigned long long)
 		     right_path->p_node[subtree_root].bh->b_blocknr,
 		     right_path->p_tree_depth);
@@ -3976,9 +3985,11 @@ static int ocfs2_append_rec_to_path(handle_t *handle,
 			goto out;
 		}
 
-		mlog(0, "Append may need a left path update. cpos: %u, "
-		     "left_cpos: %u\n", le32_to_cpu(insert_rec->e_cpos),
-		     left_cpos);
+		trace_ocfs2_append_rec_to_path(
+			(unsigned long long)
+			ocfs2_metadata_cache_owner(et->et_ci),
+			le32_to_cpu(insert_rec->e_cpos),
+			left_cpos);
 
 		/*
 		 * No need to worry if the append is already in the
@@ -4665,9 +4676,9 @@ int ocfs2_insert_extent(handle_t *handle,
 	struct ocfs2_insert_type insert = {0, };
 	struct ocfs2_extent_rec rec;
 
-	mlog(0, "add %u clusters at position %u to owner %llu\n",
-	     new_clusters, cpos,
-	     (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci));
+	trace_ocfs2_insert_extent_start(
+		(unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
+		cpos, new_clusters);
 
 	memset(&rec, 0, sizeof(rec));
 	rec.e_cpos = cpu_to_le32(cpos);
@@ -4687,11 +4698,9 @@ int ocfs2_insert_extent(handle_t *handle,
 		goto bail;
 	}
 
-	mlog(0, "Insert.appending: %u, Insert.Contig: %u, "
-	     "Insert.contig_index: %d, Insert.free_records: %d, "
-	     "Insert.tree_depth: %d\n",
-	     insert.ins_appending, insert.ins_contig, insert.ins_contig_index,
-	     free_records, insert.ins_tree_depth);
+	trace_ocfs2_insert_extent(insert.ins_appending, insert.ins_contig,
+				  insert.ins_contig_index, free_records,
+				  insert.ins_tree_depth);
 
 	if (insert.ins_contig == CONTIG_NONE && free_records == 0) {
 		status = ocfs2_grow_tree(handle, et,
@@ -4732,7 +4741,7 @@ int ocfs2_add_clusters_in_btree(handle_t *handle,
 				struct ocfs2_alloc_context *meta_ac,
 				enum ocfs2_alloc_restarted *reason_ret)
 {
-	int status = 0;
+	int status = 0, err = 0;
 	int free_extents;
 	enum ocfs2_alloc_restarted reason = RESTART_NONE;
 	u32 bit_off, num_bits;
@@ -4759,14 +4768,14 @@ int ocfs2_add_clusters_in_btree(handle_t *handle,
 	 * 2) we are so fragmented, we've needed to add metadata too
 	 *    many times. */
 	if (!free_extents && !meta_ac) {
-		mlog(0, "we haven't reserved any metadata!\n");
+		err = -1;
 		status = -EAGAIN;
 		reason = RESTART_META;
 		goto leave;
 	} else if ((!free_extents)
 		   && (ocfs2_alloc_context_bits_left(meta_ac)
 		       < ocfs2_extend_meta_needed(et->et_root_el))) {
-		mlog(0, "filesystem is really fragmented...\n");
+		err = -2;
 		status = -EAGAIN;
 		reason = RESTART_META;
 		goto leave;
@@ -4791,9 +4800,9 @@ int ocfs2_add_clusters_in_btree(handle_t *handle,
 	}
 
 	block = ocfs2_clusters_to_blocks(osb->sb, bit_off);
-	mlog(0, "Allocating %u clusters at block %u for owner %llu\n",
-	     num_bits, bit_off,
-	     (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci));
+	trace_ocfs2_add_clusters_in_btree(
+	     (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
+	     bit_off, num_bits);
 	status = ocfs2_insert_extent(handle, et, *logical_offset, block,
 				     num_bits, flags, meta_ac);
 	if (status < 0) {
@@ -4807,8 +4816,7 @@ int ocfs2_add_clusters_in_btree(handle_t *handle,
 	*logical_offset += num_bits;
 
 	if (clusters_to_add) {
-		mlog(0, "need to alloc once more, wanted = %u\n",
-		     clusters_to_add);
+		err = clusters_to_add;
 		status = -EAGAIN;
 		reason = RESTART_TRANS;
 	}
@@ -4816,6 +4824,7 @@ int ocfs2_add_clusters_in_btree(handle_t *handle,
 leave:
 	if (reason_ret)
 		*reason_ret = reason;
+	trace_ocfs2_add_clusters_in_btree_ret(status, reason, err);
 	return status;
 }
 
@@ -5041,9 +5050,9 @@ int ocfs2_split_extent(handle_t *handle,
 
 	ctxt.c_has_empty_extent = ocfs2_is_empty_extent(&el->l_recs[0]);
 
-	mlog(0, "index: %d, contig: %u, has_empty: %u, split_covers: %u\n",
-	     split_index, ctxt.c_contig_type, ctxt.c_has_empty_extent,
-	     ctxt.c_split_covers_rec);
+	trace_ocfs2_split_extent(split_index, ctxt.c_contig_type,
+				 ctxt.c_has_empty_extent,
+				 ctxt.c_split_covers_rec);
 
 	if (ctxt.c_contig_type == CONTIG_NONE) {
 		if (ctxt.c_split_covers_rec)
@@ -5177,8 +5186,9 @@ int ocfs2_mark_extent_written(struct inode *inode,
 {
 	int ret;
 
-	mlog(0, "Inode %lu cpos %u, len %u, phys clusters %u\n",
-	     inode->i_ino, cpos, len, phys);
+	trace_ocfs2_mark_extent_written(
+		(unsigned long long)OCFS2_I(inode)->ip_blkno,
+		cpos, len, phys);
 
 	if (!ocfs2_writes_unwritten_extents(OCFS2_SB(inode->i_sb))) {
 		ocfs2_error(inode->i_sb, "Inode %llu has unwritten extents "
@@ -5497,11 +5507,10 @@ int ocfs2_remove_extent(handle_t *handle,
 
 	BUG_ON(cpos < le32_to_cpu(rec->e_cpos) || trunc_range > rec_range);
 
-	mlog(0, "Owner %llu, remove (cpos %u, len %u). Existing index %d "
-	     "(cpos %u, len %u)\n",
-	     (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
-	     cpos, len, index,
-	     le32_to_cpu(rec->e_cpos), ocfs2_rec_clusters(el, rec));
+	trace_ocfs2_remove_extent(
+		(unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
+		cpos, len, index, le32_to_cpu(rec->e_cpos),
+		ocfs2_rec_clusters(el, rec));
 
 	if (le32_to_cpu(rec->e_cpos) == cpos || rec_range == trunc_range) {
 		ret = ocfs2_truncate_rec(handle, et, path, index, dealloc,
@@ -5780,9 +5789,6 @@ int ocfs2_truncate_log_append(struct ocfs2_super *osb,
 	struct ocfs2_dinode *di;
 	struct ocfs2_truncate_log *tl;
 
-	mlog(0, "start_blk = %llu, num_clusters = %u\n",
-	     (unsigned long long)start_blk, num_clusters);
-
 	BUG_ON(mutex_trylock(&tl_inode->i_mutex));
 
 	start_cluster = ocfs2_blocks_to_clusters(osb->sb, start_blk);
@@ -5819,10 +5825,9 @@ int ocfs2_truncate_log_append(struct ocfs2_super *osb,
 		goto bail;
 	}
 
-	mlog(0, "Log truncate of %u clusters starting at cluster %u to "
-	     "%llu (index = %d)\n", num_clusters, start_cluster,
-	     (unsigned long long)OCFS2_I(tl_inode)->ip_blkno, index);
-
+	trace_ocfs2_truncate_log_append(
+		(unsigned long long)OCFS2_I(tl_inode)->ip_blkno, index,
+		start_cluster, num_clusters);
 	if (ocfs2_truncate_log_can_coalesce(tl, start_cluster)) {
 		/*
 		 * Move index back to the record we are coalescing with.
@@ -5831,9 +5836,10 @@ int ocfs2_truncate_log_append(struct ocfs2_super *osb,
 		index--;
 
 		num_clusters += le32_to_cpu(tl->tl_recs[index].t_clusters);
-		mlog(0, "Coalesce with index %u (start = %u, clusters = %u)\n",
-		     index, le32_to_cpu(tl->tl_recs[index].t_start),
-		     num_clusters);
+		trace_ocfs2_truncate_log_append(
+			(unsigned long long)OCFS2_I(tl_inode)->ip_blkno,
+			index, le32_to_cpu(tl->tl_recs[index].t_start),
+			num_clusters);
 	} else {
 		tl->tl_recs[index].t_start = cpu_to_le32(start_cluster);
 		tl->tl_used = cpu_to_le16(index + 1);
@@ -5896,8 +5902,9 @@ static int ocfs2_replay_truncate_records(struct ocfs2_super *osb,
 		/* if start_blk is not set, we ignore the record as
 		 * invalid. */
 		if (start_blk) {
-			mlog(0, "free record %d, start = %u, clusters = %u\n",
-			     i, le32_to_cpu(rec.t_start), num_clusters);
+			trace_ocfs2_replay_truncate_records(
+				(unsigned long long)OCFS2_I(tl_inode)->ip_blkno,
+				i, le32_to_cpu(rec.t_start), num_clusters);
 
 			status = ocfs2_free_clusters(handle, data_alloc_inode,
 						     data_alloc_bh, start_blk,
@@ -5938,8 +5945,9 @@ int __ocfs2_flush_truncate_log(struct ocfs2_super *osb)
 
 	tl = &di->id2.i_dealloc;
 	num_to_flush = le16_to_cpu(tl->tl_used);
-	mlog(0, "Flush %u records from truncate log #%llu\n",
-	     num_to_flush, (unsigned long long)OCFS2_I(tl_inode)->ip_blkno);
+	trace_ocfs2_flush_truncate_log(
+		(unsigned long long)OCFS2_I(tl_inode)->ip_blkno,
+		num_to_flush);
 	if (!num_to_flush) {
 		status = 0;
 		goto out;
@@ -6076,7 +6084,7 @@ int ocfs2_begin_truncate_log_recovery(struct ocfs2_super *osb,
 
 	*tl_copy = NULL;
 
-	mlog(0, "recover truncate log from slot %d\n", slot_num);
+	trace_ocfs2_begin_truncate_log_recovery(slot_num);
 
 	status = ocfs2_get_truncate_log_info(osb, slot_num, &tl_inode, &tl_bh);
 	if (status < 0) {
@@ -6093,8 +6101,7 @@ int ocfs2_begin_truncate_log_recovery(struct ocfs2_super *osb,
 
 	tl = &di->id2.i_dealloc;
 	if (le16_to_cpu(tl->tl_used)) {
-		mlog(0, "We'll have %u logs to recover\n",
-		     le16_to_cpu(tl->tl_used));
+		trace_ocfs2_truncate_log_recovery_num(le16_to_cpu(tl->tl_used));
 
 		*tl_copy = kmalloc(tl_bh->b_size, GFP_KERNEL);
 		if (!(*tl_copy)) {
@@ -6151,8 +6158,9 @@ int ocfs2_complete_truncate_log_recovery(struct ocfs2_super *osb,
 
 	tl = &tl_copy->id2.i_dealloc;
 	num_recs = le16_to_cpu(tl->tl_used);
-	mlog(0, "cleanup %u records from %llu\n", num_recs,
-	     (unsigned long long)le64_to_cpu(tl_copy->i_blkno));
+	trace_ocfs2_complete_truncate_log_recovery(
+		(unsigned long long)le64_to_cpu(tl_copy->i_blkno),
+		num_recs);
 
 	mutex_lock(&tl_inode->i_mutex);
 	for(i = 0; i < num_recs; i++) {
@@ -6310,8 +6318,8 @@ static int ocfs2_free_cached_blocks(struct ocfs2_super *osb,
 		else
 			bg_blkno = ocfs2_which_suballoc_group(head->free_blk,
 							      head->free_bit);
-		mlog(0, "Free bit: (bit %u, blkno %llu)\n",
-		     head->free_bit, (unsigned long long)head->free_blk);
+		trace_ocfs2_free_cached_blocks(
+		     (unsigned long long)head->free_blk, head->free_bit);
 
 		ret = ocfs2_free_suballoc_bits(handle, inode, di_bh,
 					       head->free_bit, bg_blkno, 1);
@@ -6364,8 +6372,7 @@ int ocfs2_cache_cluster_dealloc(struct ocfs2_cached_dealloc_ctxt *ctxt,
 		return ret;
 	}
 
-	mlog(0, "Insert clusters: (bit %u, blk %llu)\n",
-	     bit, (unsigned long long)blkno);
+	trace_ocfs2_cache_cluster_dealloc((unsigned long long)blkno, bit);
 
 	item->free_blk = blkno;
 	item->free_bit = bit;
@@ -6440,8 +6447,8 @@ int ocfs2_run_deallocs(struct ocfs2_super *osb,
 		fl = ctxt->c_first_suballocator;
 
 		if (fl->f_first) {
-			mlog(0, "Free items: (type %u, slot %d)\n",
-			     fl->f_inode_type, fl->f_slot);
+			trace_ocfs2_run_deallocs(fl->f_inode_type,
+						 fl->f_slot);
 			ret2 = ocfs2_free_cached_blocks(osb,
 							fl->f_inode_type,
 							fl->f_slot,
@@ -6518,8 +6525,9 @@ int ocfs2_cache_block_dealloc(struct ocfs2_cached_dealloc_ctxt *ctxt,
 		goto out;
 	}
 
-	mlog(0, "Insert: (type %d, slot %u, bit %u, blk %llu)\n",
-	     type, slot, bit, (unsigned long long)blkno);
+	trace_ocfs2_cache_block_dealloc(type, slot,
+					(unsigned long long)suballoc,
+					(unsigned long long)blkno, bit);
 
 	item->free_bg = suballoc;
 	item->free_blk = blkno;
@@ -6999,8 +7007,11 @@ start:
 		goto bail;
 	}
 
-	mlog(0, "inode->ip_clusters = %u, tree_depth = %u\n",
-	     OCFS2_I(inode)->ip_clusters, path->p_tree_depth);
+	trace_ocfs2_commit_truncate(
+		(unsigned long long)OCFS2_I(inode)->ip_blkno,
+		new_highest_cpos,
+		OCFS2_I(inode)->ip_clusters,
+		path->p_tree_depth);
 
 	/*
 	 * By now, el will point to the extent list on the bottom most
diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index 8d4e49a..d7db843 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -6,6 +6,491 @@
 
 #include <linux/tracepoint.h>
 
+DECLARE_EVENT_CLASS(ocfs2__show_int,
+	TP_PROTO(int num),
+
+	TP_ARGS(num),
+
+	TP_STRUCT__entry(
+		__field(	int,	num			)
+	),
+
+	TP_fast_assign(
+		__entry->num	= 	num;
+	),
+
+	TP_printk("%d", __entry->num)
+);
+
+DECLARE_EVENT_CLASS(ocfs2__show_int_int,
+	TP_PROTO(int value1, int value2),
+
+	TP_ARGS(value1, value2),
+
+	TP_STRUCT__entry(
+		__field(	int,	value1			)
+		__field(	int,	value2			)
+	),
+
+	TP_fast_assign(
+		__entry->value1	= 	value1;
+		__entry->value2	= 	value2;
+	),
+
+	TP_printk("%d %d", __entry->value1, __entry->value2)
+);
+
+DECLARE_EVENT_CLASS(ocfs2__show_ull_uint,
+	TP_PROTO(unsigned long long value1, u32 value2),
+
+	TP_ARGS(value1, value2),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	value1	)
+		__field(	int,	value2			)
+	),
+
+	TP_fast_assign(
+		__entry->value1	= 	value1;
+		__entry->value2	= 	value2;
+	),
+
+	TP_printk("%llu %d", __entry->value1, __entry->value2)
+);
+
+DECLARE_EVENT_CLASS(ocfs2__btree_ops,
+
+	TP_PROTO(unsigned long long owner, u32 value1, u32 value2),
+
+	TP_ARGS(owner, value1, value2),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	owner	)
+		__field(	u32,	value1			)
+		__field(	u32,	value2			)
+	),
+
+	TP_fast_assign(
+		__entry->owner		= owner;
+		__entry->value1		= value1;
+		__entry->value2		= value2;
+	),
+
+	TP_printk("%llu %u %u",
+		  __entry->owner, __entry->value1, __entry->value2)
+);
+
+DEFINE_EVENT(ocfs2__btree_ops, ocfs2_adjust_rightmost_branch,
+
+	TP_PROTO(unsigned long long owner, u32 root_end, u32 new_cpos),
+
+	TP_ARGS(owner, root_end, new_cpos)
+);
+
+DEFINE_EVENT(ocfs2__show_int, ocfs2_num_free_extents,
+
+	TP_PROTO(int retval),
+
+	TP_ARGS(retval)
+);
+
+DEFINE_EVENT(ocfs2__show_int, ocfs2_complete_edge_insert,
+
+	TP_PROTO(int index),
+
+	TP_ARGS(index)
+);
+
+TRACE_EVENT(ocfs2_grow_tree,
+
+	TP_PROTO(unsigned long long owner, int depth),
+
+	TP_ARGS(owner, depth),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	owner	)
+		__field(	int,	depth			)
+	),
+
+	TP_fast_assign(
+		__entry->owner	= owner;
+		__entry->depth	= depth;
+	),
+
+	TP_printk("%llu %d", __entry->owner, __entry->depth)
+);
+
+DEFINE_EVENT(ocfs2__btree_ops, ocfs2_rotate_tree_right,
+
+	TP_PROTO(unsigned long long owner, u32 insert_cpos, u32 cpos),
+
+	TP_ARGS(owner, insert_cpos, cpos)
+);
+
+DEFINE_EVENT(ocfs2__btree_ops, ocfs2_append_rec_to_path,
+
+	TP_PROTO(unsigned long long owner, u32 cpos, u32 left_cpos),
+
+	TP_ARGS(owner, cpos, left_cpos)
+);
+
+DEFINE_EVENT(ocfs2__btree_ops, ocfs2_insert_extent_start,
+
+	TP_PROTO(unsigned long long owner, u32 cpos, u32 clusters),
+
+	TP_ARGS(owner, cpos, clusters)
+);
+
+TRACE_EVENT(ocfs2_rotate_subtree,
+
+	TP_PROTO(int subtree_root, unsigned long long blkno,
+		 int depth),
+
+	TP_ARGS(subtree_root, blkno, depth),
+
+	TP_STRUCT__entry(
+		__field(	int,	subtree_root		)
+		__field(	unsigned long long,	blkno	)
+		__field(	int,	depth			)
+	),
+
+	TP_fast_assign(
+		__entry->subtree_root	= subtree_root;
+		__entry->blkno		= blkno;
+		__entry->depth		= depth;
+	),
+
+	TP_printk("%d %llu %d", __entry->subtree_root,
+		  __entry->blkno, __entry->depth)
+);
+
+TRACE_EVENT(ocfs2_insert_extent,
+
+	TP_PROTO(u32 ins_appending, u32 ins_contig, int ins_contig_index,
+		 int free_records, int ins_tree_depth),
+
+	TP_ARGS(ins_appending, ins_contig, ins_contig_index, free_records,
+		ins_tree_depth),
+
+	TP_STRUCT__entry(
+		__field(	u32,	ins_appending		)
+		__field(	u32,	ins_contig		)
+		__field(	int,	ins_contig_index	)
+		__field(	int,	free_records		)
+		__field(	int,	ins_tree_depth		)
+	),
+
+	TP_fast_assign(
+		__entry->ins_appending		= ins_appending;
+		__entry->ins_contig		= ins_contig;
+		__entry->ins_contig_index	= ins_contig_index;
+		__entry->free_records		= free_records;
+		__entry->ins_tree_depth		= ins_tree_depth;
+	),
+
+	TP_printk("%u %u %d %d %d",
+		  __entry->ins_appending, __entry->ins_contig,
+		  __entry->ins_contig_index, __entry->free_records,
+		  __entry->ins_tree_depth)
+);
+
+TRACE_EVENT(ocfs2_split_extent,
+
+	TP_PROTO(int split_index, u32 c_contig_type, u32 c_has_empty_extent,
+		 u32 c_split_covers_rec),
+
+	TP_ARGS(split_index, c_contig_type,
+		c_has_empty_extent, c_split_covers_rec),
+
+	TP_STRUCT__entry(
+		__field(	int,	split_index		)
+		__field(	u32,	c_contig_type		)
+		__field(	u32,	c_has_empty_extent	)
+		__field(	u32,	c_split_covers_rec	)
+	),
+
+	TP_fast_assign(
+		__entry->split_index		= split_index;
+		__entry->c_contig_type		= c_contig_type;
+		__entry->c_has_empty_extent	= c_has_empty_extent;
+		__entry->c_split_covers_rec	= c_split_covers_rec;
+	),
+
+	TP_printk("%d %u %u %u", __entry->split_index, __entry->c_contig_type,
+		  __entry->c_has_empty_extent, __entry->c_split_covers_rec)
+);
+
+TRACE_EVENT(ocfs2_remove_extent,
+
+	TP_PROTO(unsigned long long owner, u32 cpos, u32 len, int index,
+		 u32 e_cpos, u32 clusters),
+
+	TP_ARGS(owner, cpos, len, index, e_cpos, clusters),
+
+	TP_STRUCT__entry(
+		__field(        unsigned long long,	owner	)
+		__field(	u32,	cpos			)
+		__field(	u32,	len			)
+		__field(	int,	index			)
+		__field(	u32,	e_cpos			)
+		__field(	u32,	clusters		)
+	),
+
+	TP_fast_assign(
+		__entry->owner		= owner;
+		__entry->cpos		= cpos;
+		__entry->len		= len;
+		__entry->index		= index;
+		__entry->e_cpos		= e_cpos;
+		__entry->clusters	= clusters;
+	),
+
+	TP_printk("%llu %u %u %d %u %u",
+		  __entry->owner, __entry->cpos, __entry->len, __entry->index,
+		  __entry->e_cpos, __entry->clusters)
+);
+
+TRACE_EVENT(ocfs2_commit_truncate,
+
+	TP_PROTO(unsigned long long ino, u32 new_cpos,
+		 u32 clusters, u32 depth),
+
+	TP_ARGS(ino, new_cpos, clusters, depth),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	ino	)
+		__field(	u32,	new_cpos		)
+		__field(	u32,	clusters		)
+		__field(	u32,	depth			)
+	),
+
+	TP_fast_assign(
+		__entry->ino		= ino;
+		__entry->new_cpos	= new_cpos;
+		__entry->clusters	= clusters;
+		__entry->depth		= depth;
+	),
+
+	TP_printk("%llu %u %u %u",
+		  __entry->ino, __entry->new_cpos,
+		  __entry->clusters, __entry->depth)
+);
+
+TRACE_EVENT(ocfs2_validate_extent_block,
+
+	TP_PROTO(unsigned long long blkno),
+
+	TP_ARGS(blkno),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	blkno	)
+	),
+
+	TP_fast_assign(
+		__entry->blkno		= blkno;
+	),
+
+	TP_printk("%llu ", __entry->blkno)
+);
+
+TRACE_EVENT(ocfs2_rotate_leaf,
+
+	TP_PROTO(u32 insert_cpos, int insert_index,
+		 int has_empty, int next_free,
+		 u16 l_count),
+
+	TP_ARGS(insert_cpos, insert_index, has_empty,
+		next_free, l_count),
+
+	TP_STRUCT__entry(
+		__field(	u32,	insert_cpos		)
+		__field(	int,	insert_index		)
+		__field(	int,	has_empty		)
+		__field(	int,	next_free		)
+		__field(	u16,	l_count			)
+	),
+
+	TP_fast_assign(
+		__entry->insert_cpos	= insert_cpos;
+		__entry->insert_index	= insert_index;
+		__entry->has_empty	= has_empty;
+		__entry->next_free	= next_free;
+		__entry->l_count	= l_count;
+	),
+
+	TP_printk("%u %d %d %d %d", __entry->insert_cpos,
+		  __entry->insert_index, __entry->has_empty,
+		  __entry->next_free, __entry->l_count)
+);
+
+DEFINE_EVENT(ocfs2__btree_ops, ocfs2_add_clusters_in_btree,
+
+	TP_PROTO(unsigned long long owner, u32 cpos, u32 clusters),
+
+	TP_ARGS(owner, cpos, clusters)
+);
+
+TRACE_EVENT(ocfs2_add_clusters_in_btree_ret,
+
+	TP_PROTO(int status, int reason, int err),
+
+	TP_ARGS(status, reason, err),
+
+	TP_STRUCT__entry(
+		__field(	int,	status			)
+		__field(	int,	reason			)
+		__field(	int,	err			)
+	),
+
+	TP_fast_assign(
+		__entry->status	= status;
+		__entry->reason	= reason;
+		__entry->err	= err;
+	),
+
+	TP_printk("%d %d %d", __entry->status,
+		  __entry->reason, __entry->err)
+);
+
+TRACE_EVENT(ocfs2_mark_extent_written,
+
+	TP_PROTO(unsigned long long owner, u32 cpos,
+		 u32 len, u32 phys),
+
+	TP_ARGS(owner, cpos, len, phys),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	owner	)
+		__field(	u32,	cpos			)
+		__field(	u32,	len			)
+		__field(	u32,	phys			)
+	),
+
+	TP_fast_assign(
+		__entry->owner		= owner;
+		__entry->cpos		= cpos;
+		__entry->len		= len;
+		__entry->phys		= phys;
+	),
+
+	TP_printk("%llu %u %u %u",
+		  __entry->owner, __entry->cpos, __entry->len, __entry->phys)
+);
+
+DECLARE_EVENT_CLASS(ocfs2__truncate_log_ops,
+
+	TP_PROTO(unsigned long long blkno, int index, u32 start, u32 num),
+
+	TP_ARGS(blkno, index, start, num),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	blkno	)
+		__field(	int,			index	)
+		__field(	u32,			start	)
+		__field(	u32,			num	)
+	),
+
+	TP_fast_assign(
+		__entry->blkno	= blkno;
+		__entry->index	= index;
+		__entry->start	= start;
+		__entry->num	= num;
+	),
+	TP_printk("%llu %d %u %u",
+		  __entry->blkno, __entry->index,
+		  __entry->start, __entry->num)
+);
+
+DEFINE_EVENT(ocfs2__truncate_log_ops, ocfs2_truncate_log_append,
+
+	TP_PROTO(unsigned long long blkno, int index, u32 start, u32 num),
+
+	TP_ARGS(blkno, index, start, num)
+);
+
+DEFINE_EVENT(ocfs2__truncate_log_ops, ocfs2_replay_truncate_records,
+
+	TP_PROTO(unsigned long long blkno, int index, u32 start, u32 num),
+
+	TP_ARGS(blkno, index, start, num)
+);
+
+DEFINE_EVENT(ocfs2__show_ull_uint, ocfs2_flush_truncate_log,
+
+	TP_PROTO(unsigned long long owner, u32 num_to_flush),
+
+	TP_ARGS(owner, num_to_flush)
+);
+
+DEFINE_EVENT(ocfs2__show_int, ocfs2_begin_truncate_log_recovery,
+
+	TP_PROTO(int slot),
+
+	TP_ARGS(slot)
+);
+
+DEFINE_EVENT(ocfs2__show_int, ocfs2_truncate_log_recovery_num,
+
+	TP_PROTO(int num),
+
+	TP_ARGS(num)
+);
+
+DEFINE_EVENT(ocfs2__show_ull_uint, ocfs2_complete_truncate_log_recovery,
+
+	TP_PROTO(unsigned long long owner, u32 num_flush),
+
+	TP_ARGS(owner, num_flush)
+);
+
+DEFINE_EVENT(ocfs2__show_ull_uint, ocfs2_free_cached_blocks,
+
+	TP_PROTO(unsigned long long blkno, u32 bit),
+
+	TP_ARGS(blkno, bit)
+);
+
+DEFINE_EVENT(ocfs2__show_ull_uint, ocfs2_cache_cluster_dealloc,
+
+	TP_PROTO(unsigned long long blkno, u32 bit),
+
+	TP_ARGS(blkno, bit)
+);
+
+DEFINE_EVENT(ocfs2__show_int_int, ocfs2_run_deallocs,
+
+	TP_PROTO(int inode_type, int slot),
+
+	TP_ARGS(inode_type, slot)
+);
+
+TRACE_EVENT(ocfs2_cache_block_dealloc,
+
+	TP_PROTO(int type, int slot, unsigned long long suballoc,
+		 unsigned long long blkno, unsigned int bit),
+
+	TP_ARGS(type, slot, suballoc, blkno, bit),
+
+	TP_STRUCT__entry(
+		__field(	int,			type		)
+		__field(	int,			slot		)
+		__field(	unsigned long long,	suballoc	)
+		__field(	unsigned long long,	blkno		)
+		__field(	unsigned int,		bit		)
+	),
+
+	TP_fast_assign(
+		__entry->type		= type;
+		__entry->slot		= slot;
+		__entry->suballoc	= suballoc;
+		__entry->blkno		= blkno;
+		__entry->bit		= bit;
+	),
+
+	TP_printk("%d %d %llu %llu %u",
+		  __entry->type, __entry->slot, __entry->suballoc,
+		  __entry->blkno, __entry->bit)
+);
 
 #endif /* _TRACE_OCFS2_H */
 
-- 
1.7.1.GIT
