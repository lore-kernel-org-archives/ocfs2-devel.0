From: Tao Ma <tm@tao.ma>
Date: Thu, 23 Dec 2010 15:31:05 +0800
Subject: [Ocfs2-devel] [PATCH 22/34] ocfs2: Remove masklog ML_RESERVATIONS.
In-Reply-To: <4D12F7E7.1090204@tao.ma>
References: <4D12F7E7.1090204@tao.ma>
Message-ID: <1293089477-5019-22-git-send-email-tm@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <boyu.mt@taobao.com>

Remove mlog(0) from fs/ocfs2/reservations.c and the masklog RESERVATIONS.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ocfs2/cluster/masklog.c |    1 -
 fs/ocfs2/cluster/masklog.h |    1 -
 fs/ocfs2/ocfs2_trace.h     |  170 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/reservations.c    |   57 +++++++--------
 4 files changed, 196 insertions(+), 33 deletions(-)

diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index d31c5f1..64bf0b2 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -107,7 +107,6 @@ static struct mlog_attribute mlog_attrs[MLOG_MAX_BITS] = {
 	define_mask(ERROR),
 	define_mask(NOTICE),
 	define_mask(KTHREAD),
-	define_mask(RESERVATIONS),
 };
 
 static struct attribute *mlog_attr_ptrs[MLOG_MAX_BITS] = {NULL, };
diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
index 736d18c..57e12a8 100644
--- a/fs/ocfs2/cluster/masklog.h
+++ b/fs/ocfs2/cluster/masklog.h
@@ -110,7 +110,6 @@
 #define ML_ERROR	0x0000000100000000ULL /* sent to KERN_ERR */
 #define ML_NOTICE	0x0000000200000000ULL /* setn to KERN_NOTICE */
 #define ML_KTHREAD	0x0000000400000000ULL /* kernel thread activity */
-#define ML_RESERVATIONS	0x0000000800000000ULL /* ocfs2 alloc reservations */
 #define ML_CLUSTER	0x0000001000000000ULL /* cluster stack */
 
 #define MLOG_INITIAL_AND_MASK (ML_ERROR|ML_NOTICE)
diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index 676e75d..b0bb9a6 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -2806,6 +2806,176 @@ DEFINE_EVENT(ocfs2__ull_uint, ocfs2_reflink_xattr_rec,
 	TP_ARGS(blkno, len)
 );
 /* End of trace events for fs/ocfs2/xattr.c. */
+
+/* Trace events for fs/ocfs2/reservations.c. */
+DEFINE_EVENT(ocfs2__uint_uint, ocfs2_resv_insert,
+
+	TP_PROTO(unsigned int r_start, unsigned int r_len),
+
+	TP_ARGS(r_start, r_len)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint_uint_uint, ocfs2_resmap_find_free_bits_begin,
+
+	TP_PROTO(unsigned long long search_start, unsigned int search_len,
+		 unsigned int wanted, unsigned int len),
+
+	TP_ARGS(search_start, search_len, wanted, len)
+);
+
+DEFINE_EVENT(ocfs2__uint_uint, ocfs2_resmap_find_free_bits_end,
+
+	TP_PROTO(unsigned int best_start, unsigned int best_len),
+
+	TP_ARGS(best_start, best_len)
+);
+
+TRACE_EVENT(ocfs2_resv_find_window_begin,
+
+	TP_PROTO(unsigned int r_start, unsigned int r_end, unsigned int goal,
+		 unsigned int wanted, int empty_root),
+
+	TP_ARGS(r_start, r_end, goal, wanted, empty_root),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,		r_start		)
+		__field(	unsigned int,		r_end		)
+		__field(	unsigned int,		goal		)
+		__field(	unsigned int,		wanted		)
+		__field(	int,			empty_root	)
+	),
+
+	TP_fast_assign(
+		__entry->r_start	= r_start;
+		__entry->r_end		= r_end;
+		__entry->goal		= goal;
+		__entry->wanted		= wanted;
+		__entry->empty_root	= empty_root;
+	),
+
+	TP_printk("%u %u %u %u %d", __entry->r_start, __entry->r_end,
+		  __entry->goal, __entry->wanted, __entry->empty_root)
+);
+
+DEFINE_EVENT(ocfs2__uint_uint, ocfs2_resv_find_window_prev,
+
+	TP_PROTO(unsigned int r_start, unsigned int r_end),
+
+	TP_ARGS(r_start, r_end)
+);
+
+DEFINE_EVENT(ocfs2__int_int, ocfs2_resv_find_window_next,
+
+	TP_PROTO(int next_start, int next_end),
+
+	TP_ARGS(next_start, next_end)
+);
+
+DEFINE_EVENT(ocfs2__uint_uint_uint, ocfs2_cannibalize_resv_begin,
+
+	TP_PROTO(unsigned int start, unsigned int len, unsigned int end),
+
+	TP_ARGS(start, len, end)
+);
+
+TRACE_EVENT(ocfs2_cannibalize_resv_end,
+
+	TP_PROTO(unsigned int start, unsigned int end, unsigned int len,
+		 unsigned int last_start, unsigned int last_len),
+
+	TP_ARGS(start, end, len, last_start, last_len),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	start		)
+		__field(	unsigned int,	end		)
+		__field(	unsigned int,	len		)
+		__field(	unsigned int,	last_start	)
+		__field(	unsigned int,	last_len	)
+	),
+
+	TP_fast_assign(
+		__entry->start		= 	start;
+		__entry->end		= 	end;
+		__entry->len		= 	len;
+		__entry->last_start	= 	last_start;
+		__entry->last_len	= 	last_len;
+	),
+
+	TP_printk("%u %u %u %u %u", __entry->start, __entry->end,
+		  __entry->len, __entry->last_start, __entry->last_len)
+);
+
+DEFINE_EVENT(ocfs2__uint_uint, ocfs2_resmap_resv_bits,
+
+	TP_PROTO(unsigned int start, unsigned int len),
+
+	TP_ARGS(start, len)
+);
+
+TRACE_EVENT(ocfs2_resmap_claimed_bits_begin,
+
+	TP_PROTO(unsigned int cstart, unsigned int cend, unsigned int clen,
+		 unsigned int r_start, unsigned int r_end, unsigned int r_len,
+		 unsigned int last_start, unsigned int last_len),
+
+	TP_ARGS(cstart, cend, clen, r_start, r_end,
+		r_len, last_start, last_len),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	cstart		)
+		__field(	unsigned int,	cend		)
+		__field(	unsigned int,	clen		)
+		__field(	unsigned int,	r_start		)
+		__field(	unsigned int,	r_end		)
+		__field(	unsigned int,	r_len		)
+		__field(	unsigned int,	last_start	)
+		__field(	unsigned int,	last_len	)
+	),
+
+	TP_fast_assign(
+		__entry->cstart		= 	cstart;
+		__entry->cend		= 	cend;
+		__entry->clen		= 	clen;
+		__entry->r_start	= 	r_start;
+		__entry->r_end		= 	r_end;
+		__entry->r_len		= 	r_len;
+		__entry->last_start	= 	last_start;
+		__entry->last_len	= 	last_len;
+	),
+
+	TP_printk("%u %u %u %u %u %u %u %u",
+		  __entry->cstart, __entry->cend, __entry->clen,
+		  __entry->r_start, __entry->r_end, __entry->r_len,
+		  __entry->last_start, __entry->last_len)
+);
+
+TRACE_EVENT(ocfs2_resmap_claimed_bits_end,
+
+	TP_PROTO(unsigned int start, unsigned int end, unsigned int len,
+		 unsigned int last_start, unsigned int last_len),
+
+	TP_ARGS(start, end, len, last_start, last_len),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	start		)
+		__field(	unsigned int,	end		)
+		__field(	unsigned int,	len		)
+		__field(	unsigned int,	last_start	)
+		__field(	unsigned int,	last_len	)
+	),
+
+	TP_fast_assign(
+		__entry->start		= 	start;
+		__entry->end		= 	end;
+		__entry->len		= 	len;
+		__entry->last_start	= 	last_start;
+		__entry->last_len	= 	last_len;
+	),
+
+	TP_printk("%u %u %u %u %u", __entry->start, __entry->end,
+		  __entry->len, __entry->last_start, __entry->last_len)
+);
+/* End of trace events for fs/ocfs2/reservations.c. */
 #endif /* _TRACE_OCFS2_H */
 
 /* This part must be outside protection */
diff --git a/fs/ocfs2/reservations.c b/fs/ocfs2/reservations.c
index 3e78db3..41ffd36 100644
--- a/fs/ocfs2/reservations.c
+++ b/fs/ocfs2/reservations.c
@@ -30,10 +30,10 @@
 #include <linux/bitops.h>
 #include <linux/list.h>
 
-#define MLOG_MASK_PREFIX ML_RESERVATIONS
 #include <cluster/masklog.h>
 
 #include "ocfs2.h"
+#include "ocfs2_trace.h"
 
 #ifdef CONFIG_OCFS2_DEBUG_FS
 #define OCFS2_CHECK_RESERVATIONS
@@ -321,8 +321,7 @@ static void ocfs2_resv_insert(struct ocfs2_reservation_map *resmap,
 
 	assert_spin_locked(&resv_lock);
 
-	mlog(0, "Insert reservation start: %u len: %u\n", new->r_start,
-	     new->r_len);
+	trace_ocfs2_resv_insert(new->r_start, new->r_len);
 
 	while (*p) {
 		parent = *p;
@@ -423,8 +422,8 @@ static int ocfs2_resmap_find_free_bits(struct ocfs2_reservation_map *resmap,
 	unsigned int best_start, best_len = 0;
 	int offset, start, found;
 
-	mlog(0, "Find %u bits within range (%u, len %u) resmap len: %u\n",
-	     wanted, search_start, search_len, resmap->m_bitmap_len);
+	trace_ocfs2_resmap_find_free_bits_begin(search_start, search_len,
+						wanted, resmap->m_bitmap_len);
 
 	found = best_start = best_len = 0;
 
@@ -463,7 +462,7 @@ static int ocfs2_resmap_find_free_bits(struct ocfs2_reservation_map *resmap,
 	*rlen = best_len;
 	*rstart = best_start;
 
-	mlog(0, "Found start: %u len: %u\n", best_start, best_len);
+	trace_ocfs2_resmap_find_free_bits_end(best_start, best_len);
 
 	return *rlen;
 }
@@ -487,9 +486,8 @@ static void __ocfs2_resv_find_window(struct ocfs2_reservation_map *resmap,
 	 * - our window should be last in all reservations
 	 * - need to make sure we don't go past end of bitmap
 	 */
-
-	mlog(0, "resv start: %u resv end: %u goal: %u wanted: %u\n",
-	     resv->r_start, ocfs2_resv_end(resv), goal, wanted);
+	trace_ocfs2_resv_find_window_begin(resv->r_start, ocfs2_resv_end(resv),
+					   goal, wanted, RB_EMPTY_ROOT(root));
 
 	assert_spin_locked(&resv_lock);
 
@@ -498,9 +496,6 @@ static void __ocfs2_resv_find_window(struct ocfs2_reservation_map *resmap,
 		 * Easiest case - empty tree. We can just take
 		 * whatever window of free bits we want.
 		 */
-
-		mlog(0, "Empty root\n");
-
 		clen = ocfs2_resmap_find_free_bits(resmap, wanted, goal,
 						   resmap->m_bitmap_len - goal,
 						   &cstart, &clen);
@@ -524,8 +519,6 @@ static void __ocfs2_resv_find_window(struct ocfs2_reservation_map *resmap,
 	prev_resv = ocfs2_find_resv_lhs(resmap, goal);
 
 	if (prev_resv == NULL) {
-		mlog(0, "Goal on LHS of leftmost window\n");
-
 		/*
 		 * A NULL here means that the search code couldn't
 		 * find a window that starts before goal.
@@ -570,13 +563,15 @@ static void __ocfs2_resv_find_window(struct ocfs2_reservation_map *resmap,
 		next_resv = NULL;
 	}
 
+	trace_ocfs2_resv_find_window_prev(prev_resv->r_start,
+					  ocfs2_resv_end(prev_resv));
+
 	prev = &prev_resv->r_node;
 
 	/* Now we do a linear search for a window, starting at 'prev_rsv' */
 	while (1) {
 		next = rb_next(prev);
 		if (next) {
-			mlog(0, "One more resv found in linear search\n");
 			next_resv = rb_entry(next,
 					     struct ocfs2_alloc_reservation,
 					     r_node);
@@ -585,7 +580,6 @@ static void __ocfs2_resv_find_window(struct ocfs2_reservation_map *resmap,
 			gap_end = next_resv->r_start - 1;
 			gap_len = gap_end - gap_start + 1;
 		} else {
-			mlog(0, "No next node\n");
 			/*
 			 * We're at the rightmost edge of the
 			 * tree. See if a reservation between this
@@ -596,6 +590,8 @@ static void __ocfs2_resv_find_window(struct ocfs2_reservation_map *resmap,
 			gap_end = resmap->m_bitmap_len - 1;
 		}
 
+		trace_ocfs2_resv_find_window_next(next ? next_resv->r_start: -1,
+					next ? ocfs2_resv_end(next_resv) : -1);
 		/*
 		 * No need to check this gap if we have already found
 		 * a larger region of free bits.
@@ -654,8 +650,9 @@ static void ocfs2_cannibalize_resv(struct ocfs2_reservation_map *resmap,
 	lru_resv = list_first_entry(&resmap->m_lru,
 				    struct ocfs2_alloc_reservation, r_lru);
 
-	mlog(0, "lru resv: start: %u len: %u end: %u\n", lru_resv->r_start,
-	     lru_resv->r_len, ocfs2_resv_end(lru_resv));
+	trace_ocfs2_cannibalize_resv_begin(lru_resv->r_start,
+					   lru_resv->r_len,
+					   ocfs2_resv_end(lru_resv));
 
 	/*
 	 * Cannibalize (some or all) of the target reservation and
@@ -684,10 +681,9 @@ static void ocfs2_cannibalize_resv(struct ocfs2_reservation_map *resmap,
 		resv->r_len = shrink;
 	}
 
-	mlog(0, "Reservation now looks like: r_start: %u r_end: %u "
-	     "r_len: %u r_last_start: %u r_last_len: %u\n",
-	     resv->r_start, ocfs2_resv_end(resv), resv->r_len,
-	     resv->r_last_start, resv->r_last_len);
+	trace_ocfs2_cannibalize_resv_end(resv->r_start, ocfs2_resv_end(resv),
+					 resv->r_len, resv->r_last_start,
+					 resv->r_last_len);
 
 	ocfs2_resv_insert(resmap, resv);
 }
@@ -748,7 +744,6 @@ int ocfs2_resmap_resv_bits(struct ocfs2_reservation_map *resmap,
 		if ((resv->r_flags & OCFS2_RESV_FLAG_TMP) || wanted < *clen)
 			wanted = *clen;
 
-		mlog(0, "empty reservation, find new window\n");
 		/*
 		 * Try to get a window here. If it works, we must fall
 		 * through and test the bitmap . This avoids some
@@ -757,6 +752,7 @@ int ocfs2_resmap_resv_bits(struct ocfs2_reservation_map *resmap,
 		 * that inode.
 		 */
 		ocfs2_resv_find_window(resmap, resv, wanted);
+		trace_ocfs2_resmap_resv_bits(resv->r_start, resv->r_len);
 	}
 
 	BUG_ON(ocfs2_resv_empty(resv));
@@ -813,10 +809,10 @@ void ocfs2_resmap_claimed_bits(struct ocfs2_reservation_map *resmap,
 
 	spin_lock(&resv_lock);
 
-	mlog(0, "claim bits: cstart: %u cend: %u clen: %u r_start: %u "
-	     "r_end: %u r_len: %u, r_last_start: %u r_last_len: %u\n",
-	     cstart, cend, clen, resv->r_start, ocfs2_resv_end(resv),
-	     resv->r_len, resv->r_last_start, resv->r_last_len);
+	trace_ocfs2_resmap_claimed_bits_begin(cstart, cend, clen, resv->r_start,
+					      ocfs2_resv_end(resv), resv->r_len,
+					      resv->r_last_start,
+					      resv->r_last_len);
 
 	BUG_ON(cstart < resv->r_start);
 	BUG_ON(cstart > ocfs2_resv_end(resv));
@@ -833,10 +829,9 @@ void ocfs2_resmap_claimed_bits(struct ocfs2_reservation_map *resmap,
 	if (!ocfs2_resv_empty(resv))
 		ocfs2_resv_mark_lru(resmap, resv);
 
-	mlog(0, "Reservation now looks like: r_start: %u r_end: %u "
-	     "r_len: %u r_last_start: %u r_last_len: %u\n",
-	     resv->r_start, ocfs2_resv_end(resv), resv->r_len,
-	     resv->r_last_start, resv->r_last_len);
+	trace_ocfs2_resmap_claimed_bits_end(resv->r_start, ocfs2_resv_end(resv),
+					    resv->r_len, resv->r_last_start,
+					    resv->r_last_len);
 
 	ocfs2_check_resmap(resmap);
 
-- 
1.7.0.4
