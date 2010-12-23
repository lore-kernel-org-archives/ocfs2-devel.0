From: Tao Ma <tm@tao.ma>
Date: Thu, 23 Dec 2010 15:30:49 +0800
Subject: [Ocfs2-devel] [PATCH 06/34] ocfs2: Remove mlog(0) from
	fs/ocfs2/localalloc.c
In-Reply-To: <4D12F7E7.1090204@tao.ma>
References: <4D12F7E7.1090204@tao.ma>
Message-ID: <1293089477-5019-6-git-send-email-tm@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <tao.ma@oracle.com>

This is the 2nd step to remove the debug info of DISK_ALLOC.

So this patch removes all mlog(0,...) from localalloc.c and adds
the corresponding tracepoints. Different mlogs have different
solutions.
1. Some are replaced with trace event directly.
2. Some are replaced while some new parameters are added.
3. Some are combined into one trace events.
4. Some redundant mlogs are removed.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/localalloc.c  |   57 +++++++----------
 fs/ocfs2/ocfs2_trace.h |  172 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 195 insertions(+), 34 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 36636e1..a311b1f 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -43,6 +43,7 @@
 #include "suballoc.h"
 #include "super.h"
 #include "sysfile.h"
+#include "ocfs2_trace.h"
 
 #include "buffer_head_io.h"
 
@@ -201,8 +202,7 @@ void ocfs2_la_set_sizes(struct ocfs2_super *osb, int requested_mb)
 	la_max_mb = ocfs2_clusters_to_megabytes(sb,
 						ocfs2_local_alloc_size(sb) * 8);
 
-	mlog(0, "requested: %dM, max: %uM, default: %uM\n",
-	     requested_mb, la_max_mb, la_default_mb);
+	trace_ocfs2_la_set_sizes(requested_mb, la_max_mb, la_default_mb);
 
 	if (requested_mb == -1) {
 		/* No user request - use defaults */
@@ -276,8 +276,8 @@ int ocfs2_alloc_should_use_local(struct ocfs2_super *osb, u64 bits)
 
 	ret = 1;
 bail:
-	mlog(0, "state=%d, bits=%llu, la_bits=%d, ret=%d\n",
-	     osb->local_alloc_state, (unsigned long long)bits, la_bits, ret);
+	trace_ocfs2_alloc_should_use_local(
+	     (unsigned long long)bits, osb->local_alloc_state, la_bits, ret);
 	spin_unlock(&osb->osb_lock);
 	return ret;
 }
@@ -362,7 +362,7 @@ bail:
 	if (inode)
 		iput(inode);
 
-	mlog(0, "Local alloc window bits = %d\n", osb->local_alloc_bits);
+	trace_ocfs2_load_local_alloc(osb->local_alloc_bits);
 
 	if (status)
 		mlog_errno(status);
@@ -497,7 +497,7 @@ int ocfs2_begin_local_alloc_recovery(struct ocfs2_super *osb,
 	struct inode *inode = NULL;
 	struct ocfs2_dinode *alloc;
 
-	mlog(0, "(slot_num = %d)\n", slot_num);
+	trace_ocfs2_begin_local_alloc_recovery(slot_num);
 
 	*alloc_copy = NULL;
 
@@ -705,10 +705,6 @@ int ocfs2_reserve_local_alloc_bits(struct ocfs2_super *osb,
 			goto bail;
 	}
 
-	if (ac->ac_max_block)
-		mlog(0, "Calling in_range for max block %llu\n",
-		     (unsigned long long)ac->ac_max_block);
-
 	ac->ac_inode = local_alloc_inode;
 	/* We should never use localalloc from another slot */
 	ac->ac_alloc_slot = osb->slot_num;
@@ -722,8 +718,9 @@ bail:
 		iput(local_alloc_inode);
 	}
 
-	mlog(0, "bits=%d, slot=%d, ret=%d\n", bits_wanted, osb->slot_num,
-	     status);
+	trace_ocfs2_reserve_local_alloc_bits(
+		(unsigned long long)ac->ac_max_block,
+		bits_wanted, osb->slot_num, status);
 
 	if (status)
 		mlog_errno(status);
@@ -797,7 +794,7 @@ static u32 ocfs2_local_alloc_count_bits(struct ocfs2_dinode *alloc)
 	for (i = 0; i < le16_to_cpu(la->la_size); i++)
 		count += hweight8(buffer[i]);
 
-	mlog(0, "count %u\n", count);
+	trace_ocfs2_local_alloc_count_bits(count);
 	return count;
 }
 
@@ -812,10 +809,7 @@ static int ocfs2_local_alloc_find_clear_bits(struct ocfs2_super *osb,
 	void *bitmap = NULL;
 	struct ocfs2_reservation_map *resmap = &osb->osb_la_resmap;
 
-	mlog(0, "(numbits wanted = %u)\n", *numbits);
-
 	if (!alloc->id1.bitmap1.i_total) {
-		mlog(0, "No bits in my window!\n");
 		bitoff = -1;
 		goto bail;
 	}
@@ -875,8 +869,7 @@ static int ocfs2_local_alloc_find_clear_bits(struct ocfs2_super *osb,
 		}
 	}
 
-	mlog(0, "Exiting loop, bitoff = %d, numfound = %d\n", bitoff,
-	     numfound);
+	trace_ocfs2_local_alloc_find_clear_bits_search_bitmap(bitoff, numfound);
 
 	if (numfound == *numbits)
 		bitoff = startoff - numfound;
@@ -887,7 +880,10 @@ bail:
 	if (local_resv)
 		ocfs2_resv_discard(resmap, resv);
 
-	mlog(0, "bitoff %d\n", bitoff);
+	trace_ocfs2_local_alloc_find_clear_bits(*numbits,
+		le32_to_cpu(alloc->id1.bitmap1.i_total),
+		bitoff, numfound);
+
 	return bitoff;
 }
 
@@ -941,18 +937,16 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
 	void *bitmap;
 	struct ocfs2_local_alloc *la = OCFS2_LOCAL_ALLOC(alloc);
 
-	mlog(0, "total = %u, used = %u\n",
+	trace_ocfs2_sync_local_to_main(
 	     le32_to_cpu(alloc->id1.bitmap1.i_total),
 	     le32_to_cpu(alloc->id1.bitmap1.i_used));
 
 	if (!alloc->id1.bitmap1.i_total) {
-		mlog(0, "nothing to sync!\n");
 		goto bail;
 	}
 
 	if (le32_to_cpu(alloc->id1.bitmap1.i_used) ==
 	    le32_to_cpu(alloc->id1.bitmap1.i_total)) {
-		mlog(0, "all bits were taken!\n");
 		goto bail;
 	}
 
@@ -974,8 +968,7 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
 				ocfs2_clusters_to_blocks(osb->sb,
 							 start - count);
 
-			mlog(0, "freeing %u bits starting at local alloc bit "
-			     "%u (la_start_blk = %llu, blkno = %llu)\n",
+			trace_ocfs2_sync_local_to_main_free(
 			     count, start - count,
 			     (unsigned long long)la_start_blk,
 			     (unsigned long long)blkno);
@@ -1142,12 +1135,9 @@ static int ocfs2_local_alloc_new_window(struct ocfs2_super *osb,
 	alloc = (struct ocfs2_dinode *) osb->local_alloc_bh->b_data;
 	la = OCFS2_LOCAL_ALLOC(alloc);
 
-	if (alloc->id1.bitmap1.i_total)
-		mlog(0, "asking me to alloc a new window over a non-empty "
-		     "one\n");
-
-	mlog(0, "Allocating %u clusters for a new window.\n",
-	     osb->local_alloc_bits);
+	trace_ocfs2_local_alloc_new_window(
+		le32_to_cpu(alloc->id1.bitmap1.i_total),
+		osb->local_alloc_bits);
 
 	/* Instruct the allocation code to try the most recently used
 	 * cluster group. We'll re-record the group used this pass
@@ -1209,10 +1199,9 @@ retry_enospc:
 	ocfs2_resmap_restart(&osb->osb_la_resmap, cluster_count,
 			     OCFS2_LOCAL_ALLOC(alloc)->la_bitmap);
 
-	mlog(0, "New window allocated:\n");
-	mlog(0, "window la_bm_off = %u\n",
-	     OCFS2_LOCAL_ALLOC(alloc)->la_bm_off);
-	mlog(0, "window bits = %u\n", le32_to_cpu(alloc->id1.bitmap1.i_total));
+	trace_ocfs2_local_alloc_new_window_result(
+		OCFS2_LOCAL_ALLOC(alloc)->la_bm_off,
+		le32_to_cpu(alloc->id1.bitmap1.i_total));
 
 bail:
 	if (status)
diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index 2dfc3b0..b94458b 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -23,6 +23,23 @@ DECLARE_EVENT_CLASS(ocfs2__int,
 	TP_printk("%d", __entry->num)
 );
 
+DECLARE_EVENT_CLASS(ocfs2__uint,
+
+	TP_PROTO(unsigned int num),
+
+	TP_ARGS(num),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	num		)
+	),
+
+	TP_fast_assign(
+		__entry->num	= 	num;
+	),
+
+	TP_printk("%u", __entry->num)
+);
+
 DECLARE_EVENT_CLASS(ocfs2__int_int,
 
 	TP_PROTO(int value1, int value2),
@@ -61,6 +78,53 @@ DECLARE_EVENT_CLASS(ocfs2__ull_uint,
 	TP_printk("%llu %u", __entry->value1, __entry->value2)
 );
 
+DECLARE_EVENT_CLASS(ocfs2__uint_uint_uint,
+
+	TP_PROTO(unsigned int value1, unsigned int value2,
+		 unsigned int value3),
+
+	TP_ARGS(value1, value2, value3),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	value1		)
+		__field(	unsigned int,	value2		)
+		__field(	unsigned int,	value3		)
+	),
+
+	TP_fast_assign(
+		__entry->value1	= 	value1;
+		__entry->value2	= 	value2;
+		__entry->value3	= 	value3;
+	),
+
+	TP_printk("%u %u %u", __entry->value1, __entry->value2, __entry->value3)
+);
+
+DECLARE_EVENT_CLASS(ocfs2__ull_int_int_int,
+
+	TP_PROTO(unsigned long long ull, int value1, int value2, int value3),
+
+	TP_ARGS(ull, value1, value2, value3),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	ull	)
+		__field(	int,	value1			)
+		__field(	int,	value2			)
+		__field(	int,	value3			)
+	),
+
+	TP_fast_assign(
+		__entry->ull		= ull;
+		__entry->value1		= value1;
+		__entry->value2		= value2;
+		__entry->value3		= value3;
+	),
+
+	TP_printk("%llu %d %d %d",
+		  __entry->ull, __entry->value1,
+		  __entry->value2, __entry->value3)
+);
+
 /* Trace events for fs/ocfs2/alloc.c. */
 DECLARE_EVENT_CLASS(ocfs2__btree_ops,
 
@@ -508,6 +572,114 @@ TRACE_EVENT(ocfs2_cache_block_dealloc,
 );
 /* End of trace events for fs/ocfs2/alloc.c. */
 
+/* Trace events for fs/ocfs2/localalloc.c. */
+DEFINE_EVENT(ocfs2__uint_uint_uint, ocfs2_la_set_sizes,
+
+	TP_PROTO(unsigned int requested_mb, unsigned int max_mb,
+		 unsigned int default_mb),
+
+	TP_ARGS(requested_mb, max_mb, default_mb)
+);
+
+DEFINE_EVENT(ocfs2__ull_int_int_int, ocfs2_alloc_should_use_local,
+
+	TP_PROTO(unsigned long long bit, int state, int la_bits, int ret),
+
+	TP_ARGS(bit, state, la_bits, ret)
+);
+
+DEFINE_EVENT(ocfs2__int, ocfs2_load_local_alloc,
+
+	TP_PROTO(int bit),
+
+	TP_ARGS(bit)
+);
+
+DEFINE_EVENT(ocfs2__int, ocfs2_begin_local_alloc_recovery,
+
+	TP_PROTO(int slot),
+
+	TP_ARGS(slot)
+);
+
+DEFINE_EVENT(ocfs2__ull_int_int_int, ocfs2_reserve_local_alloc_bits,
+
+	TP_PROTO(unsigned long long max_block, int bits_wanted,
+		int slot, int status),
+
+	TP_ARGS(max_block, bits_wanted, slot, status)
+);
+
+DEFINE_EVENT(ocfs2__uint, ocfs2_local_alloc_count_bits,
+
+	TP_PROTO(uint count),
+
+	TP_ARGS(count)
+);
+
+DEFINE_EVENT(ocfs2__int_int, ocfs2_local_alloc_find_clear_bits_search_bitmap,
+
+	TP_PROTO(int bitoff, int numfound),
+
+	TP_ARGS(bitoff, numfound)
+);
+
+DEFINE_EVENT(ocfs2__ull_int_int_int, ocfs2_local_alloc_find_clear_bits,
+
+	TP_PROTO(unsigned long long numbits,
+		 int total, int bitoff, int numfound),
+
+	TP_ARGS(numbits, total, bitoff, numfound)
+);
+
+DEFINE_EVENT(ocfs2__int_int, ocfs2_sync_local_to_main,
+
+	TP_PROTO(int total, int used),
+
+	TP_ARGS(total, used)
+);
+
+TRACE_EVENT(ocfs2_sync_local_to_main_free,
+
+	TP_PROTO(int count, int bit, unsigned long long start_blk,
+		 unsigned long long blkno),
+
+	TP_ARGS(count, bit, start_blk, blkno),
+
+	TP_STRUCT__entry(
+		__field(	int,			count		)
+		__field(	int,			bit		)
+		__field(	unsigned long long,	start_blk	)
+		__field(	unsigned long long,	blkno		)
+	),
+
+	TP_fast_assign(
+		__entry->count		= count;
+		__entry->bit		= bit;
+		__entry->start_blk	= start_blk;
+		__entry->blkno		= blkno;
+	),
+
+	TP_printk("%d %d %llu %llu",
+		  __entry->count, __entry->bit, __entry->start_blk,
+		  __entry->blkno)
+);
+
+DEFINE_EVENT(ocfs2__int_int, ocfs2_local_alloc_new_window,
+
+	TP_PROTO(int total, int alloc_bits),
+
+	TP_ARGS(total, alloc_bits)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint, ocfs2_local_alloc_new_window_result,
+
+	TP_PROTO(unsigned long long bm_off, unsigned int total),
+
+	TP_ARGS(bm_off, total)
+);
+
+/* End of trace events for fs/ocfs2/localalloc.c. */
 #endif /* _TRACE_OCFS2_H */
 
 /* This part must be outside protection */
-- 
1.7.0.4
