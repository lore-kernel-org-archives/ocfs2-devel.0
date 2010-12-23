From: Tao Ma <tm@tao.ma>
Date: Thu, 23 Dec 2010 15:31:04 +0800
Subject: [Ocfs2-devel] [PATCH 21/34] ocfs2: Remove masklog ML_XATTR.
In-Reply-To: <4D12F7E7.1090204@tao.ma>
References: <4D12F7E7.1090204@tao.ma>
Message-ID: <1293089477-5019-21-git-send-email-tm@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <boyu.mt@taobao.com>

Remove mlog(0) from fs/ocfs2/xattr.c and the masklog ML_XATTR.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ocfs2/cluster/masklog.c |    1 -
 fs/ocfs2/cluster/masklog.h |    1 -
 fs/ocfs2/ocfs2_trace.h     |  342 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/xattr.c           |  153 ++++++++++----------
 4 files changed, 417 insertions(+), 80 deletions(-)

diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index b1e1799..d31c5f1 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -102,7 +102,6 @@ static struct mlog_attribute mlog_attrs[MLOG_MAX_BITS] = {
 	define_mask(CONN),
 	define_mask(QUORUM),
 	define_mask(EXPORT),
-	define_mask(XATTR),
 	define_mask(QUOTA),
 	define_mask(BASTS),
 	define_mask(ERROR),
diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
index c6fc51f..736d18c 100644
--- a/fs/ocfs2/cluster/masklog.h
+++ b/fs/ocfs2/cluster/masklog.h
@@ -104,7 +104,6 @@
 #define ML_CONN		0x0000000004000000ULL /* net connection management */
 #define ML_QUORUM	0x0000000008000000ULL /* net connection quorum */
 #define ML_EXPORT	0x0000000010000000ULL /* ocfs2 export operations */
-#define ML_XATTR	0x0000000020000000ULL /* ocfs2 extended attributes */
 #define ML_QUOTA	0x0000000040000000ULL /* ocfs2 quota operations */
 #define ML_BASTS	0x0000001000000000ULL /* dlmglue asts and basts */
 /* bits that are infrequently given and frequently matched in the high word */
diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index 28c4a05..676e75d 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -74,6 +74,23 @@ DECLARE_EVENT_CLASS(ocfs2__pointer,
 	TP_printk("%p", __entry->pointer)
 );
 
+DECLARE_EVENT_CLASS(ocfs2__string,
+
+	TP_PROTO(const char *name),
+
+	TP_ARGS(name),
+
+	TP_STRUCT__entry(
+		__field(	const char *,	name	)
+	),
+
+	TP_fast_assign(
+		__entry->name	= 	name;
+	),
+
+	TP_printk("%s", __entry->name)
+);
+
 DECLARE_EVENT_CLASS(ocfs2__int_int,
 
 	TP_PROTO(int value1, int value2),
@@ -311,6 +328,32 @@ DECLARE_EVENT_CLASS(ocfs2__ull_uint_uint_uint,
 		  __entry->value2, __entry->value3)
 );
 
+DECLARE_EVENT_CLASS(ocfs2__ull_ull_uint_uint,
+
+	TP_PROTO(unsigned long long value1, unsigned long long value2,
+		 unsigned int value3, unsigned int value4),
+
+	TP_ARGS(value1, value2, value3, value4),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	value1		)
+		__field(	unsigned long long,	value2		)
+		__field(	unsigned int,		value3		)
+		__field(	unsigned int,		value4		)
+	),
+
+	TP_fast_assign(
+		__entry->value1		= value1;
+		__entry->value2		= value2;
+		__entry->value3		= value3;
+		__entry->value4		= value4;
+	),
+
+	TP_printk("%llu %llu %u %u",
+		  __entry->value1, __entry->value2,
+		  __entry->value3, __entry->value4)
+);
+
 /* Trace events for fs/ocfs2/alloc.c. */
 DECLARE_EVENT_CLASS(ocfs2__btree_ops,
 
@@ -2464,6 +2507,305 @@ TRACE_EVENT(ocfs2_initialize_super,
 		  __entry->root_dir, __entry->system_dir, __entry->cluster_bits)
 );
 /* End of trace events for fs/ocfs2/super.c. */
+
+/* Trace events for fs/ocfs2/xattr.c. */
+DEFINE_EVENT(ocfs2__ull, ocfs2_validate_xattr_block,
+
+	TP_PROTO(unsigned long long blkno),
+
+	TP_ARGS(blkno)
+);
+
+DEFINE_EVENT(ocfs2__uint, ocfs2_xattr_extend_allocation,
+
+	TP_PROTO(unsigned int clusters),
+
+	TP_ARGS(clusters)
+);
+
+TRACE_EVENT(ocfs2_init_xattr_set_ctxt,
+
+	TP_PROTO(const char *name, int meta, int clusters, int credits),
+
+	TP_ARGS(name, meta, clusters, credits),
+
+	TP_STRUCT__entry(
+		__field(	const char *,	name		)
+		__field(	int,		meta		)
+		__field(	int,		clusters	)
+		__field(	int,		credits		)
+	),
+
+	TP_fast_assign(
+		__entry->name		= name;
+		__entry->meta		= meta;
+		__entry->clusters	= clusters;
+		__entry->credits	= credits;
+	),
+
+	TP_printk("%s %d %d %d", __entry->name, __entry->meta,
+		  __entry->clusters, __entry->credits)
+);
+
+DECLARE_EVENT_CLASS(ocfs2__xattr_find,
+
+	TP_PROTO(unsigned long long ino, const char *name, int name_index,
+		 unsigned int hash, unsigned long long location,
+		 int xe_index),
+
+	TP_ARGS(ino, name, name_index, hash, location, xe_index),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	ino		)
+		__field(	const char *,		name		)
+		__field(	int,			name_index	)
+		__field(	unsigned int,		hash		)
+		__field(	unsigned long long,	location	)
+		__field(	int,			xe_index	)
+	),
+
+	TP_fast_assign(
+		__entry->ino		= ino;
+		__entry->name		= name;
+		__entry->name_index	= name_index;
+		__entry->hash		= hash;
+		__entry->location	= location;
+		__entry->xe_index	= xe_index;
+	),
+
+	TP_printk("%llu %s %d %u %llu %d", __entry->ino, __entry->name,
+		  __entry->name_index, __entry->hash, __entry->location,
+		  __entry->xe_index)
+);
+
+DEFINE_EVENT(ocfs2__xattr_find, ocfs2_xattr_bucket_find,
+
+	TP_PROTO(unsigned long long ino, const char *name, int name_index,
+		 unsigned int hash, unsigned long long bucket,
+		 int xe_index),
+
+	TP_ARGS(ino, name, name_index, hash, bucket, xe_index)
+);
+
+DEFINE_EVENT(ocfs2__xattr_find, ocfs2_xattr_index_block_find,
+
+	TP_PROTO(unsigned long long ino, const char *name, int name_index,
+		 unsigned int hash, unsigned long long bucket,
+		 int xe_index),
+
+	TP_ARGS(ino, name, name_index, hash, bucket, xe_index)
+);
+
+DEFINE_EVENT(ocfs2__xattr_find, ocfs2_xattr_index_block_find_rec,
+
+	TP_PROTO(unsigned long long ino, const char *name, int name_index,
+		 unsigned int hash, unsigned long long blkno,
+		 int num_clusters),
+
+	TP_ARGS(ino, name, name_index, hash, blkno, num_clusters)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull_uint, ocfs2_iterate_xattr_buckets,
+
+	TP_PROTO(unsigned long long ino,
+		 unsigned long long blkno, unsigned int clusters),
+
+	TP_ARGS(ino, blkno, clusters)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint, ocfs2_iterate_xattr_bucket,
+
+	TP_PROTO(unsigned long long blkno, unsigned int clusters),
+
+	TP_ARGS(blkno, clusters)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull, ocfs2_cp_xattr_block_to_bucket_begin,
+
+	TP_PROTO(unsigned long long blkno, unsigned long long bucket),
+
+	TP_ARGS(blkno, bucket)
+);
+
+DEFINE_EVENT(ocfs2__uint_uint_uint, ocfs2_cp_xattr_block_to_bucket_end,
+
+	TP_PROTO(unsigned int offset, unsigned int size,
+		 unsigned int off_change),
+
+	TP_ARGS(offset, size, off_change)
+);
+
+DEFINE_EVENT(ocfs2__ull, ocfs2_xattr_create_index_block_begin,
+
+	TP_PROTO(unsigned long long blkno),
+
+	TP_ARGS(blkno)
+);
+
+DEFINE_EVENT(ocfs2__ull, ocfs2_xattr_create_index_block,
+
+	TP_PROTO(unsigned long long bucket),
+
+	TP_ARGS(bucket)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint_uint_uint, ocfs2_defrag_xattr_bucket,
+
+	TP_PROTO(unsigned long long blkno, unsigned int count,
+		 unsigned int free_start, unsigned int name_value_len),
+
+	TP_ARGS(blkno, count, free_start, name_value_len)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull, ocfs2_mv_xattr_bucket_cross_cluster,
+
+	TP_PROTO(unsigned long long last_cluster, unsigned long long new_blkno),
+
+	TP_ARGS(last_cluster, new_blkno)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull, ocfs2_divide_xattr_bucket_begin,
+
+	TP_PROTO(unsigned long long blkno, unsigned long long new_blkno),
+
+	TP_ARGS(blkno, new_blkno)
+);
+
+DEFINE_EVENT(ocfs2__uint_uint_uint, ocfs2_divide_xattr_bucket_move,
+
+	TP_PROTO(unsigned int len, unsigned int from, unsigned int to),
+
+	TP_ARGS(len, from, to)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull_uint, ocfs2_cp_xattr_bucket,
+
+	TP_PROTO(unsigned long long s_blkno,
+		 unsigned long long t_blkno, unsigned int is_new),
+
+	TP_ARGS(s_blkno, t_blkno, is_new)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull, ocfs2_mv_xattr_buckets,
+
+	TP_PROTO(unsigned long long s_blkno,
+		 unsigned long long t_blkno),
+
+	TP_ARGS(s_blkno, t_blkno)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull_uint, ocfs2_adjust_xattr_cross_cluster,
+
+	TP_PROTO(unsigned long long blkno,
+		 unsigned long long new_blk, unsigned int clusters),
+
+	TP_ARGS(blkno, new_blk, clusters)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull_uint_uint, ocfs2_add_new_xattr_cluster_begin,
+
+	TP_PROTO(unsigned long long ino, unsigned long long bucket,
+		 unsigned int cpos, unsigned int clusters),
+
+	TP_ARGS(ino, bucket, cpos, clusters)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint, ocfs2_add_new_xattr_cluster,
+
+	TP_PROTO(unsigned long long new_blkno, unsigned int clusters),
+
+	TP_ARGS(new_blkno, clusters)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint_uint, ocfs2_add_new_xattr_cluster_insert,
+
+	TP_PROTO(unsigned long long new_blkno,
+		 unsigned int cpos, unsigned int clusters),
+
+	TP_ARGS(new_blkno, cpos, clusters)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull_uint_uint, ocfs2_extend_xattr_bucket,
+
+	TP_PROTO(unsigned long long target, unsigned long long bucket,
+		 unsigned int num_clusters, unsigned int num_buckets),
+
+	TP_ARGS(target, bucket, num_clusters, num_buckets)
+);
+
+DEFINE_EVENT(ocfs2__ull, ocfs2_add_new_xattr_bucket,
+
+	TP_PROTO(unsigned long long target),
+
+	TP_ARGS(target)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint_uint, ocfs2_xattr_bucket_value_truncate,
+
+	TP_PROTO(unsigned long long bucket,
+		 unsigned int index, unsigned int len),
+
+	TP_ARGS(bucket, index, len)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull_uint_uint, ocfs2_rm_xattr_cluster,
+
+	TP_PROTO(unsigned long long ino, unsigned long long blkno,
+		 unsigned int cpos, unsigned int len),
+
+	TP_ARGS(ino, blkno, cpos, len)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint, ocfs2_reflink_xattr_header,
+
+	TP_PROTO(unsigned long long blkno, unsigned int count),
+
+	TP_ARGS(blkno, count)
+);
+
+DEFINE_EVENT(ocfs2__ull_int, ocfs2_create_empty_xattr_block,
+
+	TP_PROTO(unsigned long long blkno, int indexed),
+
+	TP_ARGS(blkno, indexed)
+);
+
+DEFINE_EVENT(ocfs2__string, ocfs2_xattr_set_entry_bucket,
+
+	TP_PROTO(const char *name),
+
+	TP_ARGS(name)
+);
+
+DEFINE_EVENT(ocfs2__string, ocfs2_xattr_set_entry_index_block,
+
+	TP_PROTO(const char *name),
+
+	TP_ARGS(name)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint, ocfs2_xattr_bucket_value_refcount,
+
+	TP_PROTO(unsigned long long blkno, unsigned int count),
+
+	TP_ARGS(blkno, count)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint_uint, ocfs2_reflink_xattr_buckets,
+
+	TP_PROTO(unsigned long long new_blkno,
+		 unsigned int num_clusters, unsigned int cpos),
+
+	TP_ARGS(new_blkno, num_clusters, cpos)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint, ocfs2_reflink_xattr_rec,
+
+	TP_PROTO(unsigned long long blkno, unsigned int len),
+
+	TP_ARGS(blkno, len)
+);
+/* End of trace events for fs/ocfs2/xattr.c. */
 #endif /* _TRACE_OCFS2_H */
 
 /* This part must be outside protection */
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index d57c794..52e3dad 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -37,7 +37,6 @@
 #include <linux/string.h>
 #include <linux/security.h>
 
-#define MLOG_MASK_PREFIX ML_XATTR
 #include <cluster/masklog.h>
 
 #include "ocfs2.h"
@@ -57,6 +56,7 @@
 #include "xattr.h"
 #include "refcounttree.h"
 #include "acl.h"
+#include "ocfs2_trace.h"
 
 struct ocfs2_xattr_def_value_root {
 	struct ocfs2_xattr_value_root	xv;
@@ -474,8 +474,7 @@ static int ocfs2_validate_xattr_block(struct super_block *sb,
 	struct ocfs2_xattr_block *xb =
 		(struct ocfs2_xattr_block *)bh->b_data;
 
-	mlog(0, "Validating xattr block %llu\n",
-	     (unsigned long long)bh->b_blocknr);
+	trace_ocfs2_validate_xattr_block((unsigned long long)bh->b_blocknr);
 
 	BUG_ON(!buffer_uptodate(bh));
 
@@ -715,11 +714,11 @@ static int ocfs2_xattr_extend_allocation(struct inode *inode,
 	u32 prev_clusters, logical_start = le32_to_cpu(vb->vb_xv->xr_clusters);
 	struct ocfs2_extent_tree et;
 
-	mlog(0, "(clusters_to_add for xattr= %u)\n", clusters_to_add);
-
 	ocfs2_init_xattr_value_extent_tree(&et, INODE_CACHE(inode), vb);
 
 	while (clusters_to_add) {
+		trace_ocfs2_xattr_extend_allocation(clusters_to_add);
+
 		status = vb->vb_access(handle, INODE_CACHE(inode), vb->vb_bh,
 				       OCFS2_JOURNAL_ACCESS_WRITE);
 		if (status < 0) {
@@ -754,8 +753,6 @@ static int ocfs2_xattr_extend_allocation(struct inode *inode,
 			 */
 			BUG_ON(why == RESTART_META);
 
-			mlog(0, "restarting xattr value extension for %u"
-			     " clusters,.\n", clusters_to_add);
 			credits = ocfs2_calc_extend_credits(inode->i_sb,
 							    &vb->vb_xv->xr_list,
 							    clusters_to_add);
@@ -3246,8 +3243,8 @@ static int ocfs2_init_xattr_set_ctxt(struct inode *inode,
 	}
 
 	meta_add += extra_meta;
-	mlog(0, "Set xattr %s, reserve meta blocks = %d, clusters = %d, "
-	     "credits = %d\n", xi->xi_name, meta_add, clusters_add, *credits);
+	trace_ocfs2_init_xattr_set_ctxt(xi->xi_name, meta_add,
+					clusters_add, *credits);
 
 	if (meta_add) {
 		ret = ocfs2_reserve_new_metadata_blocks(osb, meta_add,
@@ -3887,8 +3884,10 @@ static int ocfs2_xattr_bucket_find(struct inode *inode,
 
 	if (found) {
 		xs->here = &xs->header->xh_entries[index];
-		mlog(0, "find xattr %s in bucket %llu, entry = %u\n", name,
-		     (unsigned long long)bucket_blkno(xs->bucket), index);
+		trace_ocfs2_xattr_bucket_find(OCFS2_I(inode)->ip_blkno,
+			name, name_index, name_hash,
+			(unsigned long long)bucket_blkno(xs->bucket),
+			index);
 	} else
 		ret = -ENODATA;
 
@@ -3915,8 +3914,10 @@ static int ocfs2_xattr_index_block_find(struct inode *inode,
 	if (le16_to_cpu(el->l_next_free_rec) == 0)
 		return -ENODATA;
 
-	mlog(0, "find xattr %s, hash = %u, index = %d in xattr tree\n",
-	     name, name_hash, name_index);
+	trace_ocfs2_xattr_index_block_find(OCFS2_I(inode)->ip_blkno,
+					name, name_index, name_hash,
+					(unsigned long long)root_bh->b_blocknr,
+					-1);
 
 	ret = ocfs2_xattr_get_rec(inode, name_hash, &p_blkno, &first_hash,
 				  &num_clusters, el);
@@ -3927,9 +3928,10 @@ static int ocfs2_xattr_index_block_find(struct inode *inode,
 
 	BUG_ON(p_blkno == 0 || num_clusters == 0 || first_hash > name_hash);
 
-	mlog(0, "find xattr extent rec %u clusters from %llu, the first hash "
-	     "in the rec is %u\n", num_clusters, (unsigned long long)p_blkno,
-	     first_hash);
+	trace_ocfs2_xattr_index_block_find_rec(OCFS2_I(inode)->ip_blkno,
+					name, name_index, first_hash,
+					(unsigned long long)p_blkno,
+					num_clusters);
 
 	ret = ocfs2_xattr_bucket_find(inode, name_index, name, name_hash,
 				      p_blkno, first_hash, num_clusters, xs);
@@ -3955,8 +3957,9 @@ static int ocfs2_iterate_xattr_buckets(struct inode *inode,
 		return -ENOMEM;
 	}
 
-	mlog(0, "iterating xattr buckets in %u clusters starting from %llu\n",
-	     clusters, (unsigned long long)blkno);
+	trace_ocfs2_iterate_xattr_buckets(
+		(unsigned long long)OCFS2_I(inode)->ip_blkno,
+		(unsigned long long)blkno, clusters);
 
 	for (i = 0; i < num_buckets; i++, blkno += bucket->bu_blocks) {
 		ret = ocfs2_read_xattr_bucket(bucket, blkno);
@@ -3972,8 +3975,7 @@ static int ocfs2_iterate_xattr_buckets(struct inode *inode,
 		if (i == 0)
 			num_buckets = le16_to_cpu(bucket_xh(bucket)->xh_num_buckets);
 
-		mlog(0, "iterating xattr bucket %llu, first hash %u\n",
-		     (unsigned long long)blkno,
+		trace_ocfs2_iterate_xattr_bucket((unsigned long long)blkno,
 		     le32_to_cpu(bucket_xh(bucket)->xh_entries[0].xe_name_hash));
 		if (func) {
 			ret = func(inode, bucket, para);
@@ -4173,9 +4175,9 @@ static void ocfs2_cp_xattr_block_to_bucket(struct inode *inode,
 	char *src = xb_bh->b_data;
 	char *target = bucket_block(bucket, blks - 1);
 
-	mlog(0, "cp xattr from block %llu to bucket %llu\n",
-	     (unsigned long long)xb_bh->b_blocknr,
-	     (unsigned long long)bucket_blkno(bucket));
+	trace_ocfs2_cp_xattr_block_to_bucket_begin(
+				(unsigned long long)xb_bh->b_blocknr,
+				(unsigned long long)bucket_blkno(bucket));
 
 	for (i = 0; i < blks; i++)
 		memset(bucket_block(bucket, i), 0, blocksize);
@@ -4211,8 +4213,7 @@ static void ocfs2_cp_xattr_block_to_bucket(struct inode *inode,
 	for (i = 0; i < count; i++)
 		le16_add_cpu(&xh->xh_entries[i].xe_name_offset, off_change);
 
-	mlog(0, "copy entry: start = %u, size = %u, offset_change = %u\n",
-	     offset, size, off_change);
+	trace_ocfs2_cp_xattr_block_to_bucket_end(offset, size, off_change);
 
 	sort(target + offset, count, sizeof(struct ocfs2_xattr_entry),
 	     cmp_xe, swap_xe);
@@ -4261,8 +4262,8 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
 	struct ocfs2_xattr_tree_root *xr;
 	u16 xb_flags = le16_to_cpu(xb->xb_flags);
 
-	mlog(0, "create xattr index block for %llu\n",
-	     (unsigned long long)xb_bh->b_blocknr);
+	trace_ocfs2_xattr_create_index_block_begin(
+				(unsigned long long)xb_bh->b_blocknr);
 
 	BUG_ON(xb_flags & OCFS2_XATTR_INDEXED);
 	BUG_ON(!xs->bucket);
@@ -4295,8 +4296,7 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
 	 */
 	blkno = ocfs2_clusters_to_blocks(inode->i_sb, bit_off);
 
-	mlog(0, "allocate 1 cluster from %llu to xattr block\n",
-	     (unsigned long long)blkno);
+	trace_ocfs2_xattr_create_index_block((unsigned long long)blkno);
 
 	ret = ocfs2_init_xattr_bucket(xs->bucket, blkno);
 	if (ret) {
@@ -4400,8 +4400,7 @@ static int ocfs2_defrag_xattr_bucket(struct inode *inode,
 	entries = (char *)xh->xh_entries;
 	xh_free_start = le16_to_cpu(xh->xh_free_start);
 
-	mlog(0, "adjust xattr bucket in %llu, count = %u, "
-	     "xh_free_start = %u, xh_name_value_len = %u.\n",
+	trace_ocfs2_defrag_xattr_bucket(
 	     (unsigned long long)blkno, le16_to_cpu(xh->xh_count),
 	     xh_free_start, le16_to_cpu(xh->xh_name_value_len));
 
@@ -4503,8 +4502,9 @@ static int ocfs2_mv_xattr_bucket_cross_cluster(struct inode *inode,
 	BUG_ON(le16_to_cpu(bucket_xh(first)->xh_num_buckets) < num_buckets);
 	BUG_ON(OCFS2_XATTR_BUCKET_SIZE == OCFS2_SB(sb)->s_clustersize);
 
-	mlog(0, "move half of xattrs in cluster %llu to %llu\n",
-	     (unsigned long long)last_cluster_blkno, (unsigned long long)new_blkno);
+	trace_ocfs2_mv_xattr_bucket_cross_cluster(
+				(unsigned long long)last_cluster_blkno,
+				(unsigned long long)new_blkno);
 
 	ret = ocfs2_mv_xattr_buckets(inode, handle, bucket_blkno(first),
 				     last_cluster_blkno, new_blkno,
@@ -4614,8 +4614,8 @@ static int ocfs2_divide_xattr_bucket(struct inode *inode,
 	struct ocfs2_xattr_entry *xe;
 	int blocksize = inode->i_sb->s_blocksize;
 
-	mlog(0, "move some of xattrs from bucket %llu to %llu\n",
-	     (unsigned long long)blk, (unsigned long long)new_blk);
+	trace_ocfs2_divide_xattr_bucket_begin((unsigned long long)blk,
+					      (unsigned long long)new_blk);
 
 	s_bucket = ocfs2_xattr_bucket_new(inode);
 	t_bucket = ocfs2_xattr_bucket_new(inode);
@@ -4714,9 +4714,9 @@ static int ocfs2_divide_xattr_bucket(struct inode *inode,
 	 */
 	xe = &xh->xh_entries[start];
 	len = sizeof(struct ocfs2_xattr_entry) * (count - start);
-	mlog(0, "mv xattr entry len %d from %d to %d\n", len,
-	     (int)((char *)xe - (char *)xh),
-	     (int)((char *)xh->xh_entries - (char *)xh));
+	trace_ocfs2_divide_xattr_bucket_move(len,
+			(int)((char *)xe - (char *)xh),
+			(int)((char *)xh->xh_entries - (char *)xh));
 	memmove((char *)xh->xh_entries, (char *)xe, len);
 	xe = &xh->xh_entries[count - start];
 	len = sizeof(struct ocfs2_xattr_entry) * start;
@@ -4788,9 +4788,9 @@ static int ocfs2_cp_xattr_bucket(struct inode *inode,
 
 	BUG_ON(s_blkno == t_blkno);
 
-	mlog(0, "cp bucket %llu to %llu, target is %d\n",
-	     (unsigned long long)s_blkno, (unsigned long long)t_blkno,
-	     t_is_new);
+	trace_ocfs2_cp_xattr_bucket((unsigned long long)s_blkno,
+				    (unsigned long long)t_blkno,
+				    t_is_new);
 
 	s_bucket = ocfs2_xattr_bucket_new(inode);
 	t_bucket = ocfs2_xattr_bucket_new(inode);
@@ -4862,8 +4862,8 @@ static int ocfs2_mv_xattr_buckets(struct inode *inode, handle_t *handle,
 	int num_buckets = ocfs2_xattr_buckets_per_cluster(osb);
 	struct ocfs2_xattr_bucket *old_first, *new_first;
 
-	mlog(0, "mv xattrs from cluster %llu to %llu\n",
-	     (unsigned long long)last_blk, (unsigned long long)to_blk);
+	trace_ocfs2_mv_xattr_buckets((unsigned long long)last_blk,
+				     (unsigned long long)to_blk);
 
 	BUG_ON(start_bucket >= num_buckets);
 	if (start_bucket) {
@@ -5013,9 +5013,9 @@ static int ocfs2_adjust_xattr_cross_cluster(struct inode *inode,
 {
 	int ret;
 
-	mlog(0, "adjust xattrs from cluster %llu len %u to %llu\n",
-	     (unsigned long long)bucket_blkno(first), prev_clusters,
-	     (unsigned long long)new_blk);
+	trace_ocfs2_adjust_xattr_cross_cluster(
+			(unsigned long long)bucket_blkno(first),
+			(unsigned long long)new_blk, prev_clusters);
 
 	if (ocfs2_xattr_buckets_per_cluster(OCFS2_SB(inode->i_sb)) > 1) {
 		ret = ocfs2_mv_xattr_bucket_cross_cluster(inode,
@@ -5088,10 +5088,10 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_extent_tree et;
 
-	mlog(0, "Add new xattr cluster for %llu, previous xattr hash = %u, "
-	     "previous xattr blkno = %llu\n",
-	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
-	     prev_cpos, (unsigned long long)bucket_blkno(first));
+	trace_ocfs2_add_new_xattr_cluster_begin(
+		(unsigned long long)OCFS2_I(inode)->ip_blkno,
+		(unsigned long long)bucket_blkno(first),
+		prev_cpos, prev_clusters);
 
 	ocfs2_init_xattr_tree_extent_tree(&et, INODE_CACHE(inode), root_bh);
 
@@ -5113,8 +5113,7 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 	BUG_ON(num_bits > clusters_to_add);
 
 	block = ocfs2_clusters_to_blocks(osb->sb, bit_off);
-	mlog(0, "Allocating %u clusters at block %u for xattr in inode %llu\n",
-	     num_bits, bit_off, (unsigned long long)OCFS2_I(inode)->ip_blkno);
+	trace_ocfs2_add_new_xattr_cluster((unsigned long long)block, num_bits);
 
 	if (bucket_blkno(first) + (prev_clusters * bpc) == block &&
 	    (prev_clusters + num_bits) << osb->s_clustersize_bits <=
@@ -5130,8 +5129,6 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 		 */
 		v_start = prev_cpos + prev_clusters;
 		*num_clusters = prev_clusters + num_bits;
-		mlog(0, "Add contiguous %u clusters to previous extent rec.\n",
-		     num_bits);
 	} else {
 		ret = ocfs2_adjust_xattr_cross_cluster(inode,
 						       handle,
@@ -5147,8 +5144,8 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 		}
 	}
 
-	mlog(0, "Insert %u clusters at block %llu for xattr@%u\n",
-	     num_bits, (unsigned long long)block, v_start);
+	trace_ocfs2_add_new_xattr_cluster_insert((unsigned long long)block,
+						 v_start, num_bits);
 	ret = ocfs2_insert_extent(handle, &et, v_start, block,
 				  num_bits, 0, ctxt->meta_ac);
 	if (ret < 0) {
@@ -5183,9 +5180,9 @@ static int ocfs2_extend_xattr_bucket(struct inode *inode,
 	u64 end_blk;
 	u16 new_bucket = le16_to_cpu(bucket_xh(first)->xh_num_buckets);
 
-	mlog(0, "extend xattr bucket in %llu, xattr extend rec starting "
-	     "from %llu, len = %u\n", (unsigned long long)target_blk,
-	     (unsigned long long)bucket_blkno(first), num_clusters);
+	trace_ocfs2_extend_xattr_bucket((unsigned long long)target_blk,
+					(unsigned long long)bucket_blkno(first),
+					num_clusters, new_bucket);
 
 	/* The extent must have room for an additional bucket */
 	BUG_ON(new_bucket >=
@@ -5265,8 +5262,8 @@ static int ocfs2_add_new_xattr_bucket(struct inode *inode,
 	/* The bucket at the front of the extent */
 	struct ocfs2_xattr_bucket *first;
 
-	mlog(0, "Add new xattr bucket starting from %llu\n",
-	     (unsigned long long)bucket_blkno(target));
+	trace_ocfs2_add_new_xattr_bucket(
+				(unsigned long long)bucket_blkno(target));
 
 	/* The first bucket of the original extent */
 	first = ocfs2_xattr_bucket_new(inode);
@@ -5382,8 +5379,8 @@ static int ocfs2_xattr_bucket_value_truncate(struct inode *inode,
 	 * modified something.  We have to assume they did, and dirty
 	 * the whole bucket.  This leaves us in a consistent state.
 	 */
-	mlog(0, "truncate %u in xattr bucket %llu to %d bytes.\n",
-	     xe_off, (unsigned long long)bucket_blkno(bucket), len);
+	trace_ocfs2_xattr_bucket_value_truncate(
+			(unsigned long long)bucket_blkno(bucket), xe_off, len);
 	ret = ocfs2_xattr_value_truncate(inode, &vb, len, ctxt);
 	if (ret) {
 		mlog_errno(ret);
@@ -5433,8 +5430,9 @@ static int ocfs2_rm_xattr_cluster(struct inode *inode,
 
 	ocfs2_init_dealloc_ctxt(&dealloc);
 
-	mlog(0, "rm xattr extent rec at %u len = %u, start from %llu\n",
-	     cpos, len, (unsigned long long)blkno);
+	trace_ocfs2_rm_xattr_cluster(
+			(unsigned long long)OCFS2_I(inode)->ip_blkno,
+			(unsigned long long)blkno, cpos, len);
 
 	ocfs2_remove_xattr_clusters_from_cache(INODE_CACHE(inode), blkno,
 					       len);
@@ -5538,7 +5536,7 @@ static int ocfs2_xattr_set_entry_bucket(struct inode *inode,
 	int ret;
 	struct ocfs2_xa_loc loc;
 
-	mlog(0, "Set xattr %s in xattr bucket\n", xi->xi_name);
+	trace_ocfs2_xattr_set_entry_bucket(xi->xi_name);
 
 	ocfs2_init_xattr_bucket_xa_loc(&loc, xs->bucket,
 				       xs->not_found ? NULL : xs->here);
@@ -5580,7 +5578,7 @@ static int ocfs2_xattr_set_entry_index_block(struct inode *inode,
 {
 	int ret;
 
-	mlog(0, "Set xattr %s in xattr index block\n", xi->xi_name);
+	trace_ocfs2_xattr_set_entry_index_block(xi->xi_name);
 
 	ret = ocfs2_xattr_set_entry_bucket(inode, xi, xs, ctxt);
 	if (!ret)
@@ -6039,9 +6037,9 @@ static int ocfs2_xattr_bucket_value_refcount(struct inode *inode,
 	if (ocfs2_meta_ecc(OCFS2_SB(inode->i_sb)))
 		p = &refcount;
 
-	mlog(0, "refcount bucket %llu, count = %u\n",
-	     (unsigned long long)bucket_blkno(bucket),
-	     le16_to_cpu(xh->xh_count));
+	trace_ocfs2_xattr_bucket_value_refcount(
+				(unsigned long long)bucket_blkno(bucket),
+				le16_to_cpu(xh->xh_count));
 	for (i = 0; i < le16_to_cpu(xh->xh_count); i++) {
 		xe = &xh->xh_entries[i];
 
@@ -6337,8 +6335,8 @@ static int ocfs2_reflink_xattr_header(handle_t *handle,
 	u32 clusters, cpos, p_cluster, num_clusters;
 	unsigned int ext_flags = 0;
 
-	mlog(0, "reflink xattr in container %llu, count = %u\n",
-	     (unsigned long long)old_bh->b_blocknr, le16_to_cpu(xh->xh_count));
+	trace_ocfs2_reflink_xattr_header((unsigned long long)old_bh->b_blocknr,
+					 le16_to_cpu(xh->xh_count));
 
 	last = &new_xh->xh_entries[le16_to_cpu(new_xh->xh_count)];
 	for (i = 0, j = 0; i < le16_to_cpu(xh->xh_count); i++, j++) {
@@ -6538,8 +6536,8 @@ static int ocfs2_create_empty_xattr_block(struct inode *inode,
 		goto out;
 	}
 
-	mlog(0, "create new xattr block for inode %llu, index = %d\n",
-	     (unsigned long long)fe_bh->b_blocknr, indexed);
+	trace_ocfs2_create_empty_xattr_block(
+				(unsigned long long)fe_bh->b_blocknr, indexed);
 	ret = ocfs2_create_xattr_block(inode, fe_bh, &ctxt, indexed,
 				       ret_bh);
 	if (ret)
@@ -6950,8 +6948,8 @@ static int ocfs2_reflink_xattr_buckets(handle_t *handle,
 		if (ret)
 			mlog_errno(ret);
 
-		mlog(0, "insert new xattr extent rec start %llu len %u to %u\n",
-		     (unsigned long long)new_blkno, num_clusters, reflink_cpos);
+		trace_ocfs2_reflink_xattr_buckets((unsigned long long)new_blkno,
+						  num_clusters, reflink_cpos);
 
 		len -= num_clusters;
 		blkno += ocfs2_clusters_to_blocks(inode->i_sb, num_clusters);
@@ -6980,8 +6978,7 @@ static int ocfs2_reflink_xattr_rec(struct inode *inode,
 	struct ocfs2_alloc_context *data_ac = NULL;
 	struct ocfs2_extent_tree et;
 
-	mlog(0, "reflink xattr buckets %llu len %u\n",
-	     (unsigned long long)blkno, len);
+	trace_ocfs2_reflink_xattr_rec((unsigned long long)blkno, len);
 
 	ocfs2_init_xattr_tree_extent_tree(&et,
 					  INODE_CACHE(args->reflink->new_inode),
-- 
1.7.0.4
