From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 26 Nov 2009 20:15:32 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: add trace event log to alloc.c
Message-ID: <200911261218.nAPMpBYX026104@rgminet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

this patche adds trace event log to alloc.c.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/alloc.c             |   47 +++++-----
 include/trace/events/ocfs2.h |  202 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 224 insertions(+), 25 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 38a42f5..1ccae54 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -53,6 +53,9 @@
 
 #include "buffer_head_io.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/ocfs2.h>
+
 enum ocfs2_contig_type {
 	CONTIG_NONE = 0,
 	CONTIG_LEFT,
@@ -1204,8 +1207,8 @@ static int ocfs2_add_branch(handle_t *handle,
 	 * from new_cpos).
 	 */
 	if (root_end > new_cpos) {
-		mlog(0, "adjust the cluster end from %u to %u\n",
-		     root_end, new_cpos);
+		trace_ocfs2_add_branch(root_end, new_cpos);
+
 		status = ocfs2_adjust_rightmost_branch(handle, et);
 		if (status) {
 			mlog_errno(status);
@@ -1564,7 +1567,7 @@ static int ocfs2_grow_tree(handle_t *handle, struct ocfs2_extent_tree *et,
 	 * another tree level */
 	if (shift) {
 		BUG_ON(bh);
-		mlog(0, "need to shift tree depth (current = %d)\n", depth);
+		trace_ocfs2_grow_tree(depth);
 
 		/* ocfs2_shift_tree_depth will return us a buffer with
 		 * the new extent block (so we can pass that to
@@ -2463,8 +2466,7 @@ static int ocfs2_rotate_tree_right(handle_t *handle,
 	 * rotating subtrees.
 	 */
 	while (cpos && insert_cpos <= cpos) {
-		mlog(0, "Rotating a tree: ins. cpos: %u, left path cpos: %u\n",
-		     insert_cpos, cpos);
+		trace_ocfs2_rotate_tree_right(insert_cpos, cpos);
 
 		ret = ocfs2_find_path(et->et_ci, left_path, cpos);
 		if (ret) {
@@ -4779,11 +4781,9 @@ int ocfs2_insert_extent(handle_t *handle,
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
@@ -5139,9 +5139,8 @@ int ocfs2_split_extent(handle_t *handle,
 
 	ctxt.c_has_empty_extent = ocfs2_is_empty_extent(&el->l_recs[0]);
 
-	mlog(0, "index: %d, contig: %u, has_empty: %u, split_covers: %u\n",
-	     split_index, ctxt.c_contig_type, ctxt.c_has_empty_extent,
-	     ctxt.c_split_covers_rec);
+	trace_ocfs2_split_extent(split_index, ctxt.c_contig_type,
+			   ctxt.c_has_empty_extent, ctxt.c_split_covers_rec);
 
 	if (ctxt.c_contig_type == CONTIG_NONE) {
 		if (ctxt.c_split_covers_rec)
@@ -5595,11 +5594,9 @@ int ocfs2_remove_extent(handle_t *handle,
 
 	BUG_ON(cpos < le32_to_cpu(rec->e_cpos) || trunc_range > rec_range);
 
-	mlog(0, "Owner %llu, remove (cpos %u, len %u). Existing index %d "
-	     "(cpos %u, len %u)\n",
-	     (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
-	     cpos, len, index,
-	     le32_to_cpu(rec->e_cpos), ocfs2_rec_clusters(el, rec));
+	trace_ocfs2_remove_extent((unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
+				  cpos, len, index, le32_to_cpu(rec->e_cpos),
+				  ocfs2_rec_clusters(el, rec));
 
 	if (le32_to_cpu(rec->e_cpos) == cpos || rec_range == trunc_range) {
 		ret = ocfs2_truncate_rec(handle, et, path, index, dealloc,
@@ -5828,9 +5825,9 @@ int ocfs2_truncate_log_append(struct ocfs2_super *osb,
 		goto bail;
 	}
 
-	mlog(0, "Log truncate of %u clusters starting at cluster %u to "
-	     "%llu (index = %d)\n", num_clusters, start_cluster,
-	     (unsigned long long)OCFS2_I(tl_inode)->ip_blkno, index);
+	trace_ocfs2_truncate_log_append(num_clusters, start_cluster,
+					(unsigned long long)OCFS2_I(tl_inode)->ip_blkno,
+					index);
 
 	if (ocfs2_truncate_log_can_coalesce(tl, start_cluster)) {
 		/*
@@ -7455,8 +7452,8 @@ start:
 		goto bail;
 	}
 
-	mlog(0, "inode->ip_clusters = %u, tree_depth = %u\n",
-	     OCFS2_I(inode)->ip_clusters, path->p_tree_depth);
+	trace_ocfs2_commit_truncate_1(OCFS2_I(inode)->ip_clusters,
+				      path->p_tree_depth);
 
 	/*
 	 * By now, el will point to the extent list on the bottom most
@@ -7500,8 +7497,8 @@ start:
 		goto bail;
 	}
 
-	mlog(0, "clusters_to_del = %u in this pass, tail blk=%llu\n",
-	     clusters_to_del, (unsigned long long)path_leaf_bh(path)->b_blocknr);
+	trace_ocfs2_commit_truncate_2(clusters_to_del,
+				      (unsigned long long)path_leaf_bh(path)->b_blocknr);
 
 	if (el->l_recs[i].e_flags & OCFS2_EXT_REFCOUNTED && clusters_to_del) {
 		BUG_ON(!(OCFS2_I(inode)->ip_dyn_features &
diff --git a/include/trace/events/ocfs2.h b/include/trace/events/ocfs2.h
index fa86758..39cc84f 100644
--- a/include/trace/events/ocfs2.h
+++ b/include/trace/events/ocfs2.h
@@ -5,10 +5,212 @@
 #define TRACE_SYSTEM ocfs2
 /* add ocfs2 relevant header files below */
 
+#include "../../../fs/ocfs2/ocfs2.h"
+
 /* add ocfs2 relevant header files above */
 #include <linux/tracepoint.h>
 
 /* add tracing declarations below */
+TRACE_EVENT(ocfs2_add_branch,
+
+	TP_PROTO(u32 root_end, u32 new_cpos),
+
+	TP_ARGS(root_end, new_cpos),
+
+	TP_STRUCT__entry(
+		__field(	u32,				root_end)
+		__field(	u32,				new_cpos)
+	),
+
+	TP_fast_assign(
+		__entry->root_end		= root_end;
+		__entry->new_cpos		= new_cpos;
+	),
+
+	TP_printk("%u %u", __entry->root_end, __entry->new_cpos)
+);
+
+TRACE_EVENT(ocfs2_grow_tree,
+
+	TP_PROTO(int depth),
+
+	TP_ARGS(depth),
+
+	TP_STRUCT__entry(
+		__field(	int,				depth)
+	),
+
+	TP_fast_assign(
+		__entry->depth			= depth;
+	),
+
+	TP_printk("%d", __entry->depth)
+);
+
+TRACE_EVENT(ocfs2_rotate_tree_right,
+
+	TP_PROTO(u32 insert_cpos, u32 cpos),
+
+	TP_ARGS(insert_cpos, cpos),
+
+	TP_STRUCT__entry(
+		__field(	u32,				insert_cpos)
+		__field(	u32,				cpos)
+	),
+
+	TP_fast_assign(
+		__entry->insert_cpos		= insert_cpos;
+		__entry->cpos			= cpos;
+	),
+
+	TP_printk("%u %u", __entry->insert_cpos, __entry->cpos)
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
+		__field(	u32,				ins_appending)
+		__field(	u32,				ins_contig)
+		__field(	int,				ins_contig_index)
+		__field(	int,				free_records)
+		__field(	int,				ins_tree_depth)
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
+	TP_printk("%u %u %d %d %d", __entry->ins_appending, __entry->ins_contig,
+		  __entry->ins_contig_index, __entry->free_records,
+		  __entry->ins_tree_depth)
+);
+
+TRACE_EVENT(ocfs2_split_extent,
+
+	TP_PROTO(int split_index, u32 c_contig_type, u32 c_has_empty_extent,
+		 u32 c_split_covers_rec),
+
+	TP_ARGS(split_index, c_contig_type, c_has_empty_extent, c_split_covers_rec),
+
+	TP_STRUCT__entry(
+		__field(	int,				split_index)
+		__field(	u32,				c_contig_type)
+		__field(	u32,				c_has_empty_extent)
+		__field(	u32,				c_split_covers_rec)
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
+		__field(        unsigned long long,		owner)
+		__field(	u32,				cpos)
+		__field(	u32,				len)
+		__field(	int,				index)
+		__field(	u32,				e_cpos)
+		__field(	u32,				clusters)
+	),
+
+	TP_fast_assign(
+		__entry->owner			= owner;
+		__entry->cpos			= cpos;
+		__entry->len			= len;
+		__entry->index			= index;
+		__entry->e_cpos			= e_cpos;
+		__entry->clusters		= clusters;
+	),
+
+	TP_printk("%llu %u %u %d %u %u",
+		  __entry->owner, __entry->cpos, __entry->len, __entry->index,
+		  __entry->e_cpos, __entry->clusters)
+);
+
+TRACE_EVENT(ocfs2_truncate_log_append,
+
+	TP_PROTO(u32 num, u32 start, unsigned long long blkno, int index),
+
+	TP_ARGS(num, start, blkno, index),
+
+	TP_STRUCT__entry(
+		__field(	u32,				num)
+		__field(	u32,				start)
+		__field(	unsigned long long,		blkno)
+		__field(	int,				index)
+	),
+
+	TP_fast_assign(
+		__entry->num			= num;
+		__entry->start			= start;
+		__entry->blkno			= blkno;
+		__entry->index			= index;
+	),
+
+	TP_printk("%u %u %llu %d",
+		  __entry->num, __entry->start, __entry->blkno, __entry->index)
+);
+
+TRACE_EVENT(ocfs2_commit_truncate_1,
+
+	TP_PROTO(u32 clusters, u32 depth),
+
+	TP_ARGS(clusters, depth),
+
+	TP_STRUCT__entry(
+		__field(	u32,				clusters)
+		__field(	u32,				depth)
+	),
+
+	TP_fast_assign(
+		__entry->clusters		= clusters;
+		__entry->depth			= depth;
+	),
+
+	TP_printk("%u %u", __entry->clusters, __entry->depth)
+);
+
+TRACE_EVENT(ocfs2_commit_truncate_2,
+
+	TP_PROTO(u32 del, unsigned long long blkno),
+
+	TP_ARGS(del, blkno),
+
+	TP_STRUCT__entry(
+		__field(	u32,				del)
+		__field(	unsigned long long,		blkno)
+	),
+
+	TP_fast_assign(
+		__entry->del			= del;
+		__entry->blkno			= blkno;
+	),
+
+	TP_printk("%u %llu", __entry->del, __entry->blkno)
+);
 
 /* add tracing declarations above */
 #endif /* _TRACE_OCFS2_H */
-- 
1.6.2.5
