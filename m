From: Tao Ma <tm@tao.ma>
Date: Thu, 23 Dec 2010 15:30:50 +0800
Subject: [Ocfs2-devel] [PATCH 07/34] ocfs2: Remove mlog(0) from
	fs/ocfs2/suballoc.c
In-Reply-To: <4D12F7E7.1090204@tao.ma>
References: <4D12F7E7.1090204@tao.ma>
Message-ID: <1293089477-5019-7-git-send-email-tm@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <tao.ma@oracle.com>

This is the 3rd step to remove the debug info of DISK_ALLOC.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/ocfs2_trace.h |  329 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ocfs2/suballoc.c    |  107 ++++++++--------
 2 files changed, 381 insertions(+), 55 deletions(-)

diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index b94458b..196a995 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -40,6 +40,23 @@ DECLARE_EVENT_CLASS(ocfs2__uint,
 	TP_printk("%u", __entry->num)
 );
 
+DECLARE_EVENT_CLASS(ocfs2__ull,
+
+	TP_PROTO(unsigned long long blkno),
+
+	TP_ARGS(blkno),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	blkno		)
+	),
+
+	TP_fast_assign(
+		__entry->blkno	= 	blkno;
+	),
+
+	TP_printk("%llu", __entry->blkno)
+);
+
 DECLARE_EVENT_CLASS(ocfs2__int_int,
 
 	TP_PROTO(int value1, int value2),
@@ -59,6 +76,25 @@ DECLARE_EVENT_CLASS(ocfs2__int_int,
 	TP_printk("%d %d", __entry->value1, __entry->value2)
 );
 
+DECLARE_EVENT_CLASS(ocfs2__uint_uint,
+
+	TP_PROTO(unsigned int value1, unsigned int value2),
+
+	TP_ARGS(value1, value2),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	value1		)
+		__field(	unsigned int,	value2		)
+	),
+
+	TP_fast_assign(
+		__entry->value1	= 	value1;
+		__entry->value2	= 	value2;
+	),
+
+	TP_printk("%u %u", __entry->value1, __entry->value2)
+);
+
 DECLARE_EVENT_CLASS(ocfs2__ull_uint,
 
 	TP_PROTO(unsigned long long value1, unsigned int value2),
@@ -78,6 +114,48 @@ DECLARE_EVENT_CLASS(ocfs2__ull_uint,
 	TP_printk("%llu %u", __entry->value1, __entry->value2)
 );
 
+DECLARE_EVENT_CLASS(ocfs2__ull_ull,
+
+	TP_PROTO(unsigned long long value1, unsigned long long value2),
+
+	TP_ARGS(value1, value2),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	value1	)
+		__field(	unsigned long long,	value2	)
+	),
+
+	TP_fast_assign(
+		__entry->value1	= 	value1;
+		__entry->value2	= 	value2;
+	),
+
+	TP_printk("%llu %llu", __entry->value1, __entry->value2)
+);
+
+DECLARE_EVENT_CLASS(ocfs2__ull_uint_uint,
+
+	TP_PROTO(unsigned long long value1,
+		 unsigned int value2, unsigned int value3),
+
+	TP_ARGS(value1, value2, value3),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	value1	)
+		__field(	unsigned int,		value2	)
+		__field(	unsigned int,		value3	)
+	),
+
+	TP_fast_assign(
+		__entry->value1	= 	value1;
+		__entry->value2	= 	value2;
+		__entry->value3	= 	value3;
+	),
+
+	TP_printk("%llu %u %u", __entry->value1,
+		  __entry->value2, __entry->value3)
+);
+
 DECLARE_EVENT_CLASS(ocfs2__uint_uint_uint,
 
 	TP_PROTO(unsigned int value1, unsigned int value2,
@@ -125,6 +203,32 @@ DECLARE_EVENT_CLASS(ocfs2__ull_int_int_int,
 		  __entry->value2, __entry->value3)
 );
 
+DECLARE_EVENT_CLASS(ocfs2__ull_uint_uint_uint,
+
+	TP_PROTO(unsigned long long ull, unsigned int value1,
+		 unsigned int value2, unsigned int value3),
+
+	TP_ARGS(ull, value1, value2, value3),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	ull	)
+		__field(	unsigned int,		value1	)
+		__field(	unsigned int,		value2	)
+		__field(	unsigned int,		value3	)
+	),
+
+	TP_fast_assign(
+		__entry->ull		= ull;
+		__entry->value1		= value1;
+		__entry->value2		= value2;
+		__entry->value3		= value3;
+	),
+
+	TP_printk("%llu %u %u %u",
+		  __entry->ull, __entry->value1,
+		  __entry->value2, __entry->value3)
+);
+
 /* Trace events for fs/ocfs2/alloc.c. */
 DECLARE_EVENT_CLASS(ocfs2__btree_ops,
 
@@ -678,8 +782,231 @@ DEFINE_EVENT(ocfs2__ull_uint, ocfs2_local_alloc_new_window_result,
 
 	TP_ARGS(bm_off, total)
 );
-
 /* End of trace events for fs/ocfs2/localalloc.c. */
+
+/* Trace events for fs/ocfs2/suballoc.c. */
+DEFINE_EVENT(ocfs2__ull, ocfs2_validate_group_descriptor,
+
+	TP_PROTO(unsigned long long bg_blkno),
+
+	TP_ARGS(bg_blkno)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint, ocfs2_block_group_alloc_contig,
+
+	TP_PROTO(unsigned long long bg_blkno, unsigned int chain),
+
+	TP_ARGS(bg_blkno, chain)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint, ocfs2_block_group_alloc_discontig,
+
+	TP_PROTO(unsigned long long bg_blkno, unsigned int chain),
+
+	TP_ARGS(bg_blkno, chain)
+);
+
+DEFINE_EVENT(ocfs2__ull, ocfs2_block_group_alloc,
+
+	TP_PROTO(unsigned long long group_blkno),
+
+	TP_ARGS(group_blkno)
+);
+
+DEFINE_EVENT(ocfs2__uint_uint, ocfs2_reserve_suballoc_bits_nospc,
+
+	TP_PROTO(unsigned int wanted, unsigned int free),
+
+	TP_ARGS(wanted, free)
+);
+
+DEFINE_EVENT(ocfs2__uint_uint_uint, ocfs2_reserve_suballoc_bits_no_new_group,
+
+	TP_PROTO(unsigned int slot, unsigned int wanted, unsigned int free),
+
+	TP_ARGS(slot, wanted, free)
+);
+
+DEFINE_EVENT(ocfs2__ull, ocfs2_reserve_new_inode_new_group,
+
+	TP_PROTO(unsigned long long group_blkno),
+
+	TP_ARGS(group_blkno)
+);
+
+DEFINE_EVENT(ocfs2__uint_uint, ocfs2_block_group_set_bits,
+
+	TP_PROTO(unsigned int bit_off, unsigned int num_bits),
+
+	TP_ARGS(bit_off, num_bits)
+);
+
+TRACE_EVENT(ocfs2_relink_block_group,
+
+	TP_PROTO(unsigned long long i_blkno, unsigned int chain,
+		 unsigned long long bg_blkno,
+		 unsigned long long prev_blkno),
+
+	TP_ARGS(i_blkno, chain, bg_blkno, prev_blkno),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	i_blkno		)
+		__field(	unsigned int,		chain		)
+		__field(	unsigned long long,	bg_blkno	)
+		__field(	unsigned long long,	prev_blkno	)
+	),
+
+	TP_fast_assign(
+		__entry->i_blkno	= i_blkno;
+		__entry->chain		= chain;
+		__entry->bg_blkno	= bg_blkno;
+		__entry->prev_blkno	= prev_blkno;
+	),
+
+	TP_printk("%llu %u %llu %llu",
+		  __entry->i_blkno, __entry->chain, __entry->bg_blkno,
+		  __entry->prev_blkno)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint_uint_uint,
+	     ocfs2_cluster_group_search_wrong_max_bits,
+
+	TP_PROTO(unsigned long long bg_blkno, unsigned int bg_bits,
+		 unsigned int clusters, unsigned int max_bits),
+
+	TP_ARGS(bg_blkno, bg_bits, clusters, max_bits)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull, ocfs2_cluster_group_search_max_block,
+
+	TP_PROTO(unsigned long long blkno,
+		 unsigned long long max_block),
+
+	TP_ARGS(blkno, max_block)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull, ocfs2_block_group_search_max_block,
+
+	TP_PROTO(unsigned long long blkno,
+		 unsigned long long max_block),
+
+	TP_ARGS(blkno, max_block)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint_uint, ocfs2_search_chain_begin,
+
+	TP_PROTO(unsigned long long blkno,
+		 unsigned int chain, unsigned int bits),
+
+	TP_ARGS(blkno, chain, bits)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint, ocfs2_search_chain_succ,
+
+	TP_PROTO(unsigned long long blkno, unsigned int bits),
+
+	TP_ARGS(blkno, bits)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint, ocfs2_search_chain_end,
+
+	TP_PROTO(unsigned long long blkno, unsigned int bits),
+
+	TP_ARGS(blkno, bits)
+);
+
+DEFINE_EVENT(ocfs2__uint, ocfs2_claim_suballoc_bits,
+
+	TP_PROTO(unsigned int chain),
+
+	TP_ARGS(chain)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint, ocfs2_claim_new_inode_at_loc,
+
+	TP_PROTO(unsigned long long blkno, unsigned int bits),
+
+	TP_ARGS(blkno, bits)
+);
+
+DEFINE_EVENT(ocfs2__uint_uint, ocfs2_block_group_clear_bits,
+
+	TP_PROTO(unsigned int bit_off, unsigned int num_bits),
+
+	TP_ARGS(bit_off, num_bits)
+);
+
+TRACE_EVENT(ocfs2_free_suballoc_bits,
+
+	TP_PROTO(unsigned long long inode, unsigned long long group,
+		 unsigned int start_bit, unsigned int count),
+
+	TP_ARGS(inode, group, start_bit, count),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	inode		)
+		__field(	unsigned long long,	group		)
+		__field(	unsigned int,		start_bit	)
+		__field(	unsigned int,		count		)
+	),
+
+	TP_fast_assign(
+		__entry->inode		= inode;
+		__entry->group		= group;
+		__entry->start_bit	= start_bit;
+		__entry->count		= count;
+	),
+
+	TP_printk("%llu %llu %u %u", __entry->inode, __entry->group,
+		  __entry->start_bit, __entry->count)
+);
+
+TRACE_EVENT(ocfs2_free_clusters,
+
+	TP_PROTO(unsigned long long bg_blkno, unsigned long long start_blk,
+		 unsigned int start_bit, unsigned int count),
+
+	TP_ARGS(bg_blkno, start_blk, start_bit, count),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	bg_blkno	)
+		__field(	unsigned long long,	start_blk	)
+		__field(	unsigned int,		start_bit	)
+		__field(	unsigned int,		count		)
+	),
+
+	TP_fast_assign(
+		__entry->bg_blkno	= bg_blkno;
+		__entry->start_blk	= start_blk;
+		__entry->start_bit	= start_bit;
+		__entry->count		= count;
+	),
+
+	TP_printk("%llu %llu %u %u", __entry->bg_blkno, __entry->start_blk,
+		  __entry->start_bit, __entry->count)
+);
+
+DEFINE_EVENT(ocfs2__ull, ocfs2_get_suballoc_slot_bit,
+
+	TP_PROTO(unsigned long long blkno),
+
+	TP_ARGS(blkno)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint, ocfs2_test_suballoc_bit,
+
+	TP_PROTO(unsigned long long blkno, unsigned int bit),
+
+	TP_ARGS(blkno, bit)
+);
+
+DEFINE_EVENT(ocfs2__ull, ocfs2_test_inode_bit,
+
+	TP_PROTO(unsigned long long blkno),
+
+	TP_ARGS(blkno)
+);
+/* End of trace events for fs/ocfs2/suballoc.c. */
 #endif /* _TRACE_OCFS2_H */
 
 /* This part must be outside protection */
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 709851f..f656e81 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -44,6 +44,7 @@
 #include "super.h"
 #include "sysfile.h"
 #include "uptodate.h"
+#include "ocfs2_trace.h"
 
 #include "buffer_head_io.h"
 
@@ -308,8 +309,8 @@ static int ocfs2_validate_group_descriptor(struct super_block *sb,
 	int rc;
 	struct ocfs2_group_desc *gd = (struct ocfs2_group_desc *)bh->b_data;
 
-	mlog(0, "Validating group descriptor %llu\n",
-	     (unsigned long long)bh->b_blocknr);
+	trace_ocfs2_validate_group_descriptor(
+					(unsigned long long)bh->b_blocknr);
 
 	BUG_ON(!buffer_uptodate(bh));
 
@@ -476,8 +477,8 @@ ocfs2_block_group_alloc_contig(struct ocfs2_super *osb, handle_t *handle,
 
 	/* setup the group */
 	bg_blkno = ocfs2_clusters_to_blocks(osb->sb, bit_off);
-	mlog(0, "new descriptor, record %u, at block %llu\n",
-	     alloc_rec, (unsigned long long)bg_blkno);
+	trace_ocfs2_block_group_alloc_contig(
+	     (unsigned long long)bg_blkno, alloc_rec);
 
 	bg_bh = sb_getblk(osb->sb, bg_blkno);
 	if (!bg_bh) {
@@ -656,8 +657,8 @@ ocfs2_block_group_alloc_discontig(handle_t *handle,
 
 	/* setup the group */
 	bg_blkno = ocfs2_clusters_to_blocks(osb->sb, bit_off);
-	mlog(0, "new descriptor, record %u, at block %llu\n",
-	     alloc_rec, (unsigned long long)bg_blkno);
+	trace_ocfs2_block_group_alloc_discontig(
+				(unsigned long long)bg_blkno, alloc_rec);
 
 	bg_bh = sb_getblk(osb->sb, bg_blkno);
 	if (!bg_bh) {
@@ -727,8 +728,8 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 	}
 
 	if (last_alloc_group && *last_alloc_group != 0) {
-		mlog(0, "use old allocation group %llu for block group alloc\n",
-		     (unsigned long long)*last_alloc_group);
+		trace_ocfs2_block_group_alloc(
+				(unsigned long long)*last_alloc_group);
 		ac->ac_last_group = *last_alloc_group;
 	}
 
@@ -851,16 +852,15 @@ static int ocfs2_reserve_suballoc_bits(struct ocfs2_super *osb,
 	if (bits_wanted > free_bits) {
 		/* cluster bitmap never grows */
 		if (ocfs2_is_cluster_bitmap(alloc_inode)) {
-			mlog(0, "Disk Full: wanted=%u, free_bits=%u\n",
-			     bits_wanted, free_bits);
+			trace_ocfs2_reserve_suballoc_bits_nospc(bits_wanted,
+								free_bits);
 			status = -ENOSPC;
 			goto bail;
 		}
 
 		if (!(flags & ALLOC_NEW_GROUP)) {
-			mlog(0, "Alloc File %u Full: wanted=%u, free_bits=%u, "
-			     "and we don't alloc a new group for it.\n",
-			     slot, bits_wanted, free_bits);
+			trace_ocfs2_reserve_suballoc_bits_no_new_group(
+						slot, bits_wanted, free_bits);
 			status = -ENOSPC;
 			goto bail;
 		}
@@ -1117,8 +1117,8 @@ int ocfs2_reserve_new_inode(struct ocfs2_super *osb,
 		spin_lock(&osb->osb_lock);
 		osb->osb_inode_alloc_group = alloc_group;
 		spin_unlock(&osb->osb_lock);
-		mlog(0, "after reservation, new allocation group is "
-		     "%llu\n", (unsigned long long)alloc_group);
+		trace_ocfs2_reserve_new_inode_new_group(
+			(unsigned long long)alloc_group);
 
 		/*
 		 * Some inodes must be freed by us, so try to allocate
@@ -1360,8 +1360,7 @@ static inline int ocfs2_block_group_set_bits(handle_t *handle,
 	BUG_ON(!OCFS2_IS_VALID_GROUP_DESC(bg));
 	BUG_ON(le16_to_cpu(bg->bg_free_bits_count) < num_bits);
 
-	mlog(0, "block_group_set_bits: off = %u, num = %u\n", bit_off,
-	     num_bits);
+	trace_ocfs2_block_group_set_bits(bit_off, num_bits);
 
 	if (ocfs2_is_cluster_bitmap(alloc_inode))
 		journal_type = OCFS2_JOURNAL_ACCESS_UNDO;
@@ -1434,10 +1433,10 @@ static int ocfs2_relink_block_group(handle_t *handle,
 	BUG_ON(!OCFS2_IS_VALID_GROUP_DESC(bg));
 	BUG_ON(!OCFS2_IS_VALID_GROUP_DESC(prev_bg));
 
-	mlog(0, "Suballoc %llu, chain %u, move group %llu to top, prev = %llu\n",
-	     (unsigned long long)le64_to_cpu(fe->i_blkno), chain,
-	     (unsigned long long)le64_to_cpu(bg->bg_blkno),
-	     (unsigned long long)le64_to_cpu(prev_bg->bg_blkno));
+	trace_ocfs2_relink_block_group(
+		(unsigned long long)le64_to_cpu(fe->i_blkno), chain,
+		(unsigned long long)le64_to_cpu(bg->bg_blkno),
+		(unsigned long long)le64_to_cpu(prev_bg->bg_blkno));
 
 	fe_ptr = le64_to_cpu(fe->id2.i_chain.cl_recs[chain].c_blkno);
 	bg_ptr = le64_to_cpu(bg->bg_next_group);
@@ -1523,10 +1522,10 @@ static int ocfs2_cluster_group_search(struct inode *inode,
 		if ((gd_cluster_off + max_bits) >
 		    OCFS2_I(inode)->ip_clusters) {
 			max_bits = OCFS2_I(inode)->ip_clusters - gd_cluster_off;
-			mlog(0, "Desc %llu, bg_bits %u, clusters %u, use %u\n",
-			     (unsigned long long)le64_to_cpu(gd->bg_blkno),
-			     le16_to_cpu(gd->bg_bits),
-			     OCFS2_I(inode)->ip_clusters, max_bits);
+			trace_ocfs2_cluster_group_search_wrong_max_bits(
+				(unsigned long long)le64_to_cpu(gd->bg_blkno),
+				le16_to_cpu(gd->bg_bits),
+				OCFS2_I(inode)->ip_clusters, max_bits);
 		}
 
 		ret = ocfs2_block_group_find_clear_bits(OCFS2_SB(inode->i_sb),
@@ -1540,9 +1539,9 @@ static int ocfs2_cluster_group_search(struct inode *inode,
 							  gd_cluster_off +
 							  res->sr_bit_offset +
 							  res->sr_bits);
-			mlog(0, "Checking %llu against %llu\n",
-			     (unsigned long long)blkoff,
-			     (unsigned long long)max_block);
+			trace_ocfs2_cluster_group_search_max_block(
+				(unsigned long long)blkoff,
+				(unsigned long long)max_block);
 			if (blkoff > max_block)
 				return -ENOSPC;
 		}
@@ -1586,9 +1585,9 @@ static int ocfs2_block_group_search(struct inode *inode,
 		if (!ret && max_block) {
 			blkoff = le64_to_cpu(bg->bg_blkno) +
 				res->sr_bit_offset + res->sr_bits;
-			mlog(0, "Checking %llu against %llu\n",
-			     (unsigned long long)blkoff,
-			     (unsigned long long)max_block);
+			trace_ocfs2_block_group_search_max_block(
+				(unsigned long long)blkoff,
+				(unsigned long long)max_block);
 			if (blkoff > max_block)
 				ret = -ENOSPC;
 		}
@@ -1754,9 +1753,9 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
 	struct ocfs2_group_desc *bg;
 
 	chain = ac->ac_chain;
-	mlog(0, "trying to alloc %u bits from chain %u, inode %llu\n",
-	     bits_wanted, chain,
-	     (unsigned long long)OCFS2_I(alloc_inode)->ip_blkno);
+	trace_ocfs2_search_chain_begin(
+		(unsigned long long)OCFS2_I(alloc_inode)->ip_blkno,
+		bits_wanted, chain);
 
 	status = ocfs2_read_group_descriptor(alloc_inode, fe,
 					     le64_to_cpu(cl->cl_recs[chain].c_blkno),
@@ -1797,8 +1796,8 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
 		goto bail;
 	}
 
-	mlog(0, "alloc succeeds: we give %u bits from block group %llu\n",
-	     res->sr_bits, (unsigned long long)le64_to_cpu(bg->bg_blkno));
+	trace_ocfs2_search_chain_succ(
+		(unsigned long long)le64_to_cpu(bg->bg_blkno), res->sr_bits);
 
 	res->sr_bg_blkno = le64_to_cpu(bg->bg_blkno);
 
@@ -1859,8 +1858,9 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
 		goto bail;
 	}
 
-	mlog(0, "Allocated %u bits from suballocator %llu\n", res->sr_bits,
-	     (unsigned long long)le64_to_cpu(fe->i_blkno));
+	trace_ocfs2_search_chain_end(
+			(unsigned long long)le64_to_cpu(fe->i_blkno),
+			res->sr_bits);
 
 out_loc_only:
 	*bits_left = le16_to_cpu(bg->bg_free_bits_count);
@@ -1942,8 +1942,7 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
 		goto bail;
 	}
 
-	mlog(0, "Search of victim chain %u came up with nothing, "
-	     "trying all chains now.\n", victim);
+	trace_ocfs2_claim_suballoc_bits(victim);
 
 	/* If we didn't pick a good victim, then just default to
 	 * searching each chain in order. Don't allow chain relinking
@@ -2171,8 +2170,8 @@ int ocfs2_claim_new_inode_at_loc(handle_t *handle,
 		goto out;
 	}
 
-	mlog(0, "Allocated %u bits from suballocator %llu\n", res->sr_bits,
-	     (unsigned long long)di_blkno);
+	trace_ocfs2_claim_new_inode_at_loc((unsigned long long)di_blkno,
+					   res->sr_bits);
 
 	atomic_inc(&OCFS2_SB(ac->ac_inode->i_sb)->alloc_stats.bg_allocs);
 
@@ -2393,7 +2392,7 @@ static int ocfs2_block_group_clear_bits(handle_t *handle,
 	 * ocfs2_read_group_descriptor().  Any corruption is a code bug. */
 	BUG_ON(!OCFS2_IS_VALID_GROUP_DESC(bg));
 
-	mlog(0, "off = %u, num = %u\n", bit_off, num_bits);
+	trace_ocfs2_block_group_clear_bits(bit_off, num_bits);
 
 	BUG_ON(undo_fn && !ocfs2_is_cluster_bitmap(alloc_inode));
 	status = ocfs2_journal_access_gd(handle, INODE_CACHE(alloc_inode),
@@ -2466,9 +2465,10 @@ static int _ocfs2_free_suballoc_bits(handle_t *handle,
 	BUG_ON(!OCFS2_IS_VALID_DINODE(fe));
 	BUG_ON((count + start_bit) > ocfs2_bits_per_group(cl));
 
-	mlog(0, "%llu: freeing %u bits from group %llu, starting at %u\n",
-	     (unsigned long long)OCFS2_I(alloc_inode)->ip_blkno, count,
-	     (unsigned long long)bg_blkno, start_bit);
+	trace_ocfs2_free_suballoc_bits(
+		(unsigned long long)OCFS2_I(alloc_inode)->ip_blkno,
+		(unsigned long long)bg_blkno,
+		start_bit, count);
 
 	status = ocfs2_read_group_descriptor(alloc_inode, fe, bg_blkno,
 					     &group_bh);
@@ -2560,10 +2560,9 @@ static int _ocfs2_free_clusters(handle_t *handle,
 	ocfs2_block_to_cluster_group(bitmap_inode, start_blk, &bg_blkno,
 				     &bg_start_bit);
 
-	mlog(0, "want to free %u clusters starting at block %llu\n",
-	     num_clusters, (unsigned long long)start_blk);
-	mlog(0, "bg_blkno = %llu, bg_start_bit = %u\n",
-	     (unsigned long long)bg_blkno, bg_start_bit);
+	trace_ocfs2_free_clusters((unsigned long long)bg_blkno,
+			(unsigned long long)start_blk,
+			bg_start_bit, num_clusters);
 
 	status = _ocfs2_free_suballoc_bits(handle, bitmap_inode, bitmap_bh,
 					   bg_start_bit, bg_blkno,
@@ -2748,7 +2747,7 @@ static int ocfs2_get_suballoc_slot_bit(struct ocfs2_super *osb, u64 blkno,
 	struct buffer_head *inode_bh = NULL;
 	struct ocfs2_dinode *inode_fe;
 
-	mlog(0, "blkno: %llu\n", (unsigned long long)blkno);
+	trace_ocfs2_get_suballoc_slot_bit((unsigned long long)blkno);
 
 	/* dirty read disk */
 	status = ocfs2_read_blocks_sync(osb, blkno, 1, &inode_bh);
@@ -2809,8 +2808,8 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
 	u64 bg_blkno;
 	int status;
 
-	mlog(0, "blkno: %llu bit: %u\n", (unsigned long long)blkno,
-	     (unsigned int)bit);
+	trace_ocfs2_test_suballoc_bit((unsigned long long)blkno,
+				      (unsigned int)bit);
 
 	alloc_di = (struct ocfs2_dinode *)alloc_bh->b_data;
 	if ((bit + 1) > ocfs2_bits_per_group(&alloc_di->id2.i_chain)) {
@@ -2863,7 +2862,7 @@ int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
 	struct inode *inode_alloc_inode;
 	struct buffer_head *alloc_bh = NULL;
 
-	mlog(0, "blkno: %llu", (unsigned long long)blkno);
+	trace_ocfs2_test_inode_bit((unsigned long long)blkno);
 
 	status = ocfs2_get_suballoc_slot_bit(osb, blkno, &suballoc_slot,
 					     &group_blkno, &suballoc_bit);
-- 
1.7.0.4
