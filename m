From: Tao Ma <tm@tao.ma>
Date: Thu, 23 Dec 2010 15:30:53 +0800
Subject: [Ocfs2-devel] [PATCH 10/34] ocfs2: Remove masklog ML_REFCOUNT.
In-Reply-To: <4D12F7E7.1090204@tao.ma>
References: <4D12F7E7.1090204@tao.ma>
Message-ID: <1293089477-5019-10-git-send-email-tm@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <tao.ma@oracle.com>

Change all the "mlog(0," in fs/ocfs2/refcounttree.c to trace events.
And finally remove masklog ML_REFCOUNT.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/cluster/masklog.c |    1 -
 fs/ocfs2/cluster/masklog.h |    1 -
 fs/ocfs2/ocfs2_trace.h     |  430 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/refcounttree.c    |  158 ++++++++--------
 4 files changed, 508 insertions(+), 82 deletions(-)

diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index b395c6a..b8939c4 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -108,7 +108,6 @@ static struct mlog_attribute mlog_attrs[MLOG_MAX_BITS] = {
 	define_mask(EXPORT),
 	define_mask(XATTR),
 	define_mask(QUOTA),
-	define_mask(REFCOUNT),
 	define_mask(BASTS),
 	define_mask(ERROR),
 	define_mask(NOTICE),
diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
index 70df956..8379361 100644
--- a/fs/ocfs2/cluster/masklog.h
+++ b/fs/ocfs2/cluster/masklog.h
@@ -110,7 +110,6 @@
 #define ML_EXPORT	0x0000000010000000ULL /* ocfs2 export operations */
 #define ML_XATTR	0x0000000020000000ULL /* ocfs2 extended attributes */
 #define ML_QUOTA	0x0000000040000000ULL /* ocfs2 quota operations */
-#define ML_REFCOUNT	0x0000000080000000ULL /* refcount tree operations */
 #define ML_BASTS	0x0000001000000000ULL /* dlmglue asts and basts */
 /* bits that are infrequently given and frequently matched in the high word */
 #define ML_ERROR	0x0000000100000000ULL /* sent to KERN_ERR */
diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index 1d518d5..3671151 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -133,6 +133,29 @@ DECLARE_EVENT_CLASS(ocfs2__ull_ull,
 	TP_printk("%llu %llu", __entry->value1, __entry->value2)
 );
 
+DECLARE_EVENT_CLASS(ocfs2__ull_ull_uint,
+
+	TP_PROTO(unsigned long long value1,
+		 unsigned long long value2, unsigned int value3),
+
+	TP_ARGS(value1, value2, value3),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	value1		)
+		__field(	unsigned long long,	value2		)
+		__field(	unsigned int,		value3		)
+	),
+
+	TP_fast_assign(
+		__entry->value1		= value1;
+		__entry->value2		= value2;
+		__entry->value3		= value3;
+	),
+
+	TP_printk("%llu %llu %u",
+		  __entry->value1, __entry->value2, __entry->value3)
+);
+
 DECLARE_EVENT_CLASS(ocfs2__ull_uint_uint,
 
 	TP_PROTO(unsigned long long value1,
@@ -1032,6 +1055,413 @@ DEFINE_EVENT(ocfs2__ull, ocfs2_test_inode_bit,
 	TP_ARGS(blkno)
 );
 /* End of trace events for fs/ocfs2/suballoc.c. */
+
+/* Trace events for fs/ocfs2/refcounttree.c. */
+DEFINE_EVENT(ocfs2__ull, ocfs2_validate_refcount_block,
+
+	TP_PROTO(unsigned long long blkno),
+
+	TP_ARGS(blkno)
+);
+
+DEFINE_EVENT(ocfs2__ull, ocfs2_purge_refcount_trees,
+
+	TP_PROTO(unsigned long long tree_blkno),
+
+	TP_ARGS(tree_blkno)
+);
+
+DEFINE_EVENT(ocfs2__ull, ocfs2_create_refcount_tree,
+
+	TP_PROTO(unsigned long long i_blkno),
+
+	TP_ARGS(i_blkno)
+);
+
+DEFINE_EVENT(ocfs2__ull, ocfs2_create_refcount_tree_blkno,
+
+	TP_PROTO(unsigned long long tree_blkno),
+
+	TP_ARGS(tree_blkno)
+);
+
+DEFINE_EVENT(ocfs2__ull_int_int_int, ocfs2_change_refcount_rec,
+
+	TP_PROTO(unsigned long long owner, int index,
+		 int count, int change),
+
+	TP_ARGS(owner, index, count, change)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint, ocfs2_expand_inline_ref_root,
+
+	TP_PROTO(unsigned long long owner, unsigned int used),
+
+	TP_ARGS(owner, used)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint_uint, ocfs2_divide_leaf_refcount_block,
+
+	TP_PROTO(unsigned long long blkno,
+		 unsigned int count, unsigned int used),
+
+	TP_ARGS(blkno, count, used)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint, ocfs2_new_leaf_refcount_block,
+
+	TP_PROTO(unsigned long long owner, unsigned int new_cpos),
+
+	TP_ARGS(owner, new_cpos)
+);
+
+DECLARE_EVENT_CLASS(ocfs2__refcount_tree_ops,
+
+	TP_PROTO(unsigned long long blkno, int index,
+		 unsigned long long cpos,
+		 unsigned int clusters, unsigned int refcount),
+
+	TP_ARGS(blkno, index, cpos, clusters, refcount),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	blkno		)
+		__field(	int,			index		)
+		__field(	unsigned long long,	cpos		)
+		__field(	unsigned int,		clusters	)
+		__field(	unsigned int,		refcount	)
+	),
+
+	TP_fast_assign(
+		__entry->blkno		= blkno;
+		__entry->index		= index;
+		__entry->cpos		= cpos;
+		__entry->clusters	= clusters;
+		__entry->refcount	= refcount;
+	),
+
+	TP_printk("%llu %d %llu %u %u", __entry->blkno, __entry->index,
+		  __entry->cpos, __entry->clusters, __entry->refcount)
+);
+
+DEFINE_EVENT(ocfs2__refcount_tree_ops, ocfs2_insert_refcount_rec,
+
+	TP_PROTO(unsigned long long blkno, int index,
+		 unsigned long long cpos,
+		 unsigned int count, unsigned int refcount),
+
+	TP_ARGS(blkno, index, cpos, count, refcount)
+);
+
+TRACE_EVENT(ocfs2_split_refcount_rec,
+
+	TP_PROTO(unsigned long long cpos,
+		 unsigned int clusters, unsigned int refcount,
+		 unsigned long long split_cpos,
+		 unsigned int split_clusters, unsigned int split_refcount),
+
+	TP_ARGS(cpos, clusters, refcount,
+		split_cpos, split_clusters, split_refcount),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	cpos		)
+		__field(	unsigned int,		clusters	)
+		__field(	unsigned int,		refcount	)
+		__field(	unsigned long long,	split_cpos	)
+		__field(	unsigned int,		split_clusters	)
+		__field(	unsigned int,		split_refcount	)
+	),
+
+	TP_fast_assign(
+		__entry->cpos		= cpos;
+		__entry->clusters	= clusters;
+		__entry->refcount	= refcount;
+		__entry->split_cpos	= split_cpos;
+		__entry->split_clusters	= split_clusters;
+		__entry->split_refcount	= split_refcount;
+	),
+
+	TP_printk("%llu %u %u %llu %u %u",
+		  __entry->cpos, __entry->clusters, __entry->refcount,
+		  __entry->split_cpos, __entry->split_clusters,
+		  __entry->split_refcount)
+);
+
+DEFINE_EVENT(ocfs2__refcount_tree_ops, ocfs2_split_refcount_rec_insert,
+
+	TP_PROTO(unsigned long long blkno, int index,
+		 unsigned long long cpos,
+		 unsigned int count, unsigned int refcount),
+
+	TP_ARGS(blkno, index, cpos, count, refcount)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull_uint, ocfs2_increase_refcount_begin,
+
+	TP_PROTO(unsigned long long owner,
+		 unsigned long long cpos, unsigned int clusters),
+
+	TP_ARGS(owner, cpos, clusters)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint_uint, ocfs2_increase_refcount_change,
+
+	TP_PROTO(unsigned long long cpos,
+		 unsigned int len, unsigned int refcount),
+
+	TP_ARGS(cpos, len, refcount)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint, ocfs2_increase_refcount_insert,
+
+	TP_PROTO(unsigned long long cpos, unsigned int len),
+
+	TP_ARGS(cpos, len)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint_uint, ocfs2_increase_refcount_split,
+
+	TP_PROTO(unsigned long long cpos,
+		 unsigned int len, unsigned int refcount),
+
+	TP_ARGS(cpos, len, refcount)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull_uint, ocfs2_remove_refcount_extent,
+
+	TP_PROTO(unsigned long long owner,
+		 unsigned long long leaf_blkno, unsigned int cpos),
+
+	TP_ARGS(owner, leaf_blkno, cpos)
+);
+
+DEFINE_EVENT(ocfs2__ull, ocfs2_restore_refcount_block,
+
+	TP_PROTO(unsigned long long owner),
+
+	TP_ARGS(owner)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull_uint, ocfs2_decrease_refcount_rec,
+
+	TP_PROTO(unsigned long long owner,
+		 unsigned long long cpos, unsigned int len),
+
+	TP_ARGS(owner, cpos, len)
+);
+
+TRACE_EVENT(ocfs2_decrease_refcount,
+
+	TP_PROTO(unsigned long long owner,
+		 unsigned long long cpos,
+		 unsigned int len, int delete),
+
+	TP_ARGS(owner, cpos, len, delete),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	owner		)
+		__field(	unsigned long long,	cpos		)
+		__field(	unsigned int,		len		)
+		__field(	int,			delete		)
+	),
+
+	TP_fast_assign(
+		__entry->owner		= owner;
+		__entry->cpos		= cpos;
+		__entry->len		= len;
+		__entry->delete		= delete;
+	),
+
+	TP_printk("%llu %llu %u %d",
+		  __entry->owner, __entry->cpos, __entry->len, __entry->delete)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint_uint_uint, ocfs2_mark_extent_refcounted,
+
+	TP_PROTO(unsigned long long owner, unsigned int cpos,
+		 unsigned int len, unsigned int phys),
+
+	TP_ARGS(owner, cpos, len, phys)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint_uint_uint, ocfs2_calc_refcount_meta_credits,
+
+	TP_PROTO(unsigned long long cpos, unsigned int clusters,
+		 unsigned int meta_add, unsigned int credits),
+
+	TP_ARGS(cpos, clusters, meta_add, credits)
+);
+
+TRACE_EVENT(ocfs2_calc_refcount_meta_credits_iterate,
+
+	TP_PROTO(int recs_add, unsigned long long cpos,
+		 unsigned int clusters, unsigned long long r_cpos,
+		 unsigned int r_clusters, unsigned int refcount, int index),
+
+	TP_ARGS(recs_add, cpos, clusters, r_cpos, r_clusters, refcount, index),
+
+	TP_STRUCT__entry(
+		__field(	int,			recs_add	)
+		__field(	unsigned long long,	cpos		)
+		__field(	unsigned int,		clusters	)
+		__field(	unsigned long long,	r_cpos		)
+		__field(	unsigned int,		r_clusters	)
+		__field(	unsigned int,		refcount	)
+		__field(	int,			index		)
+	),
+
+	TP_fast_assign(
+		__entry->recs_add	= recs_add;
+		__entry->cpos		= cpos;
+		__entry->clusters	= clusters;
+		__entry->r_cpos		= r_cpos;
+		__entry->r_clusters	= r_clusters;
+		__entry->refcount	= refcount;
+		__entry->index		= index;
+	),
+
+	TP_printk("%d %llu %u %llu %u %u %d",
+		  __entry->recs_add, __entry->cpos, __entry->clusters,
+		  __entry->r_cpos, __entry->r_clusters,
+		  __entry->refcount, __entry->index)
+);
+
+DEFINE_EVENT(ocfs2__int_int, ocfs2_add_refcount_flag,
+
+	TP_PROTO(int blocks,  int credits),
+
+	TP_ARGS(blocks, credits)
+);
+
+DEFINE_EVENT(ocfs2__int_int, ocfs2_prepare_refcount_change_for_del,
+
+	TP_PROTO(int blocks,  int credits),
+
+	TP_ARGS(blocks, credits)
+);
+
+DEFINE_EVENT(ocfs2__int_int, ocfs2_lock_refcount_allocators,
+
+	TP_PROTO(int blocks,  int credits),
+
+	TP_ARGS(blocks, credits)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint_uint_uint, ocfs2_duplicate_clusters_by_page,
+
+	TP_PROTO(unsigned long long cpos, unsigned int old_cluster,
+		 unsigned int new_cluster, unsigned int new_len),
+
+	TP_ARGS(cpos, old_cluster, new_cluster, new_len)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint_uint_uint, ocfs2_duplicate_clusters_by_jbd,
+
+	TP_PROTO(unsigned long long cpos, unsigned int old_cluster,
+		 unsigned int new_cluster, unsigned int new_len),
+
+	TP_ARGS(cpos, old_cluster, new_cluster, new_len)
+);
+
+TRACE_EVENT(ocfs2_clear_ext_refcount,
+
+	TP_PROTO(unsigned long long ino, unsigned int cpos,
+		 unsigned int len, unsigned int p_cluster,
+		 unsigned int ext_flags),
+
+	TP_ARGS(ino, cpos, len, p_cluster, ext_flags),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	ino		)
+		__field(	unsigned int,		cpos		)
+		__field(	unsigned int,		len		)
+		__field(	unsigned int,		p_cluster	)
+		__field(	unsigned int,		ext_flags	)
+	),
+
+	TP_fast_assign(
+		__entry->ino		= ino;
+		__entry->cpos		= cpos;
+		__entry->len		= len;
+		__entry->p_cluster	= p_cluster;
+		__entry->ext_flags	= ext_flags;
+	),
+
+	TP_printk("%llu %u %u %u %u",
+		  __entry->ino, __entry->cpos, __entry->len,
+		  __entry->p_cluster, __entry->ext_flags)
+);
+
+TRACE_EVENT(ocfs2_replace_clusters,
+
+	TP_PROTO(unsigned long long ino, unsigned int cpos,
+		 unsigned int old, unsigned int new, unsigned int len,
+		 unsigned int ext_flags),
+
+	TP_ARGS(ino, cpos, old, new, len, ext_flags),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	ino		)
+		__field(	unsigned int,		cpos		)
+		__field(	unsigned int,		old		)
+		__field(	unsigned int,		new		)
+		__field(	unsigned int,		len		)
+		__field(	unsigned int,		ext_flags	)
+	),
+
+	TP_fast_assign(
+		__entry->ino		= ino;
+		__entry->cpos		= cpos;
+		__entry->old		= old;
+		__entry->new		= new;
+		__entry->len		= len;
+		__entry->ext_flags	= ext_flags;
+	),
+
+	TP_printk("%llu %u %u %u %u %u",
+		  __entry->ino, __entry->cpos, __entry->old, __entry->new,
+		  __entry->len, __entry->ext_flags)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint_uint_uint, ocfs2_make_clusters_writable,
+
+	TP_PROTO(unsigned long long cpos, unsigned int p_cluster,
+		 unsigned int num_clusters, unsigned int e_flags),
+
+	TP_ARGS(cpos, p_cluster, num_clusters, e_flags)
+);
+
+TRACE_EVENT(ocfs2_refcount_cow_hunk,
+
+	TP_PROTO(unsigned long long ino, unsigned int cpos,
+		 unsigned int write_len, unsigned int max_cpos,
+		 unsigned int cow_start, unsigned int cow_len),
+
+	TP_ARGS(ino, cpos, write_len, max_cpos, cow_start, cow_len),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	ino		)
+		__field(	unsigned int,		cpos		)
+		__field(	unsigned int,		write_len	)
+		__field(	unsigned int,		max_cpos	)
+		__field(	unsigned int,		cow_start	)
+		__field(	unsigned int,		cow_len		)
+	),
+
+	TP_fast_assign(
+		__entry->ino		= ino;
+		__entry->cpos		= cpos;
+		__entry->write_len	= write_len;
+		__entry->max_cpos	= max_cpos;
+		__entry->cow_start	= cow_start;
+		__entry->cow_len	= cow_len;
+	),
+
+	TP_printk("%llu %u %u %u %u %u",
+		  __entry->ino, __entry->cpos, __entry->write_len,
+		  __entry->max_cpos, __entry->cow_start, __entry->cow_len)
+);
+
+/* End of trace events for fs/ocfs2/refcounttree.c. */
 #endif /* _TRACE_OCFS2_H */
 
 /* This part must be outside protection */
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index b5f9160..ae1d4ae 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -16,7 +16,6 @@
  */
 
 #include <linux/sort.h>
-#define MLOG_MASK_PREFIX ML_REFCOUNT
 #include <cluster/masklog.h>
 #include "ocfs2.h"
 #include "inode.h"
@@ -34,6 +33,7 @@
 #include "aops.h"
 #include "xattr.h"
 #include "namei.h"
+#include "ocfs2_trace.h"
 
 #include <linux/bio.h>
 #include <linux/blkdev.h>
@@ -84,8 +84,7 @@ static int ocfs2_validate_refcount_block(struct super_block *sb,
 	struct ocfs2_refcount_block *rb =
 		(struct ocfs2_refcount_block *)bh->b_data;
 
-	mlog(0, "Validating refcount block %llu\n",
-	     (unsigned long long)bh->b_blocknr);
+	trace_ocfs2_validate_refcount_block((unsigned long long)bh->b_blocknr);
 
 	BUG_ON(!buffer_uptodate(bh));
 
@@ -545,8 +544,8 @@ void ocfs2_purge_refcount_trees(struct ocfs2_super *osb)
 	while ((node = rb_last(root)) != NULL) {
 		tree = rb_entry(node, struct ocfs2_refcount_tree, rf_node);
 
-		mlog(0, "Purge tree %llu\n",
-		     (unsigned long long) tree->rf_blkno);
+		trace_ocfs2_purge_refcount_trees(
+				(unsigned long long) tree->rf_blkno);
 
 		rb_erase(&tree->rf_node, root);
 		ocfs2_free_refcount_tree(tree);
@@ -575,7 +574,8 @@ static int ocfs2_create_refcount_tree(struct inode *inode,
 
 	BUG_ON(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL);
 
-	mlog(0, "create tree for inode %lu\n", inode->i_ino);
+	trace_ocfs2_create_refcount_tree(
+		(unsigned long long)OCFS2_I(inode)->ip_blkno);
 
 	ret = ocfs2_reserve_new_metadata_blocks(osb, 1, &meta_ac);
 	if (ret) {
@@ -646,8 +646,7 @@ static int ocfs2_create_refcount_tree(struct inode *inode,
 	di->i_refcount_loc = cpu_to_le64(first_blkno);
 	spin_unlock(&oi->ip_lock);
 
-	mlog(0, "created tree for inode %lu, refblock %llu\n",
-	     inode->i_ino, (unsigned long long)first_blkno);
+	trace_ocfs2_create_refcount_tree_blkno((unsigned long long)first_blkno);
 
 	ocfs2_journal_dirty(handle, di_bh);
 
@@ -1256,8 +1255,9 @@ static int ocfs2_change_refcount_rec(handle_t *handle,
 		goto out;
 	}
 
-	mlog(0, "change index %d, old count %u, change %d\n", index,
-	     le32_to_cpu(rec->r_refcount), change);
+	trace_ocfs2_change_refcount_rec(
+		(unsigned long long)ocfs2_metadata_cache_owner(ci),
+		index, le32_to_cpu(rec->r_refcount), change);
 	le32_add_cpu(&rec->r_refcount, change);
 
 	if (!rec->r_refcount) {
@@ -1353,8 +1353,8 @@ static int ocfs2_expand_inline_ref_root(handle_t *handle,
 
 	ocfs2_journal_dirty(handle, ref_root_bh);
 
-	mlog(0, "new leaf block %llu, used %u\n", (unsigned long long)blkno,
-	     le16_to_cpu(new_rb->rf_records.rl_used));
+	trace_ocfs2_expand_inline_ref_root((unsigned long long)blkno,
+		le16_to_cpu(new_rb->rf_records.rl_used));
 
 	*ref_leaf_bh = new_bh;
 	new_bh = NULL;
@@ -1466,9 +1466,9 @@ static int ocfs2_divide_leaf_refcount_block(struct buffer_head *ref_leaf_bh,
 			(struct ocfs2_refcount_block *)new_bh->b_data;
 	struct ocfs2_refcount_list *new_rl = &new_rb->rf_records;
 
-	mlog(0, "split old leaf refcount block %llu, count = %u, used = %u\n",
-	     (unsigned long long)ref_leaf_bh->b_blocknr,
-	     le32_to_cpu(rl->rl_count), le32_to_cpu(rl->rl_used));
+	trace_ocfs2_divide_leaf_refcount_block(
+		(unsigned long long)ref_leaf_bh->b_blocknr,
+		le32_to_cpu(rl->rl_count), le32_to_cpu(rl->rl_used));
 
 	/*
 	 * XXX: Improvement later.
@@ -1601,8 +1601,8 @@ static int ocfs2_new_leaf_refcount_block(handle_t *handle,
 
 	ocfs2_init_refcount_extent_tree(&ref_et, ci, ref_root_bh);
 
-	mlog(0, "insert new leaf block %llu at %u\n",
-	     (unsigned long long)new_bh->b_blocknr, new_cpos);
+	trace_ocfs2_new_leaf_refcount_block(
+			(unsigned long long)new_bh->b_blocknr, new_cpos);
 
 	/* Insert the new leaf block with the specific offset cpos. */
 	ret = ocfs2_insert_extent(handle, &ref_et, new_cpos, new_bh->b_blocknr,
@@ -1794,11 +1794,10 @@ static int ocfs2_insert_refcount_rec(handle_t *handle,
 			(le16_to_cpu(rf_list->rl_used) - index) *
 			 sizeof(struct ocfs2_refcount_rec));
 
-	mlog(0, "insert refcount record start %llu, len %u, count %u "
-	     "to leaf block %llu at index %d\n",
-	     (unsigned long long)le64_to_cpu(rec->r_cpos),
-	     le32_to_cpu(rec->r_clusters), le32_to_cpu(rec->r_refcount),
-	     (unsigned long long)ref_leaf_bh->b_blocknr, index);
+	trace_ocfs2_insert_refcount_rec(
+		(unsigned long long)ref_leaf_bh->b_blocknr, index,
+		(unsigned long long)le64_to_cpu(rec->r_cpos),
+		le32_to_cpu(rec->r_clusters), le32_to_cpu(rec->r_refcount));
 
 	rf_list->rl_recs[index] = *rec;
 
@@ -1850,10 +1849,12 @@ static int ocfs2_split_refcount_rec(handle_t *handle,
 
 	BUG_ON(le32_to_cpu(rb->rf_flags) & OCFS2_REFCOUNT_TREE_FL);
 
-	mlog(0, "original r_pos %llu, cluster %u, split %llu, cluster %u\n",
-	     le64_to_cpu(orig_rec->r_cpos), le32_to_cpu(orig_rec->r_clusters),
-	     le64_to_cpu(split_rec->r_cpos),
-	     le32_to_cpu(split_rec->r_clusters));
+	trace_ocfs2_split_refcount_rec(le64_to_cpu(orig_rec->r_cpos),
+		le32_to_cpu(orig_rec->r_clusters),
+		le32_to_cpu(orig_rec->r_refcount),
+		le64_to_cpu(split_rec->r_cpos),
+		le32_to_cpu(split_rec->r_clusters),
+		le32_to_cpu(split_rec->r_refcount));
 
 	/*
 	 * If we just need to split the header or tail clusters,
@@ -1967,12 +1968,11 @@ static int ocfs2_split_refcount_rec(handle_t *handle,
 
 	if (split_rec->r_refcount) {
 		rf_list->rl_recs[index] = *split_rec;
-		mlog(0, "insert refcount record start %llu, len %u, count %u "
-		     "to leaf block %llu at index %d\n",
-		     (unsigned long long)le64_to_cpu(split_rec->r_cpos),
-		     le32_to_cpu(split_rec->r_clusters),
-		     le32_to_cpu(split_rec->r_refcount),
-		     (unsigned long long)ref_leaf_bh->b_blocknr, index);
+		trace_ocfs2_split_refcount_rec_insert(
+			(unsigned long long)ref_leaf_bh->b_blocknr, index,
+			(unsigned long long)le64_to_cpu(split_rec->r_cpos),
+			le32_to_cpu(split_rec->r_clusters),
+			le32_to_cpu(split_rec->r_refcount));
 
 		if (merge)
 			ocfs2_refcount_rec_merge(rb, index);
@@ -1997,7 +1997,7 @@ static int __ocfs2_increase_refcount(handle_t *handle,
 	struct ocfs2_refcount_rec rec;
 	unsigned int set_len = 0;
 
-	mlog(0, "Tree owner %llu, add refcount start %llu, len %u\n",
+	trace_ocfs2_increase_refcount_begin(
 	     (unsigned long long)ocfs2_metadata_cache_owner(ci),
 	     (unsigned long long)cpos, len);
 
@@ -2024,9 +2024,9 @@ static int __ocfs2_increase_refcount(handle_t *handle,
 		 */
 		if (rec.r_refcount && le64_to_cpu(rec.r_cpos) == cpos &&
 		    set_len <= len) {
-			mlog(0, "increase refcount rec, start %llu, len %u, "
-			     "count %u\n", (unsigned long long)cpos, set_len,
-			     le32_to_cpu(rec.r_refcount));
+			trace_ocfs2_increase_refcount_change(
+				(unsigned long long)cpos, set_len,
+				le32_to_cpu(rec.r_refcount));
 			ret = ocfs2_change_refcount_rec(handle, ci,
 							ref_leaf_bh, index,
 							merge, 1);
@@ -2037,7 +2037,7 @@ static int __ocfs2_increase_refcount(handle_t *handle,
 		} else if (!rec.r_refcount) {
 			rec.r_refcount = cpu_to_le32(1);
 
-			mlog(0, "insert refcount rec, start %llu, len %u\n",
+			trace_ocfs2_increase_refcount_insert(
 			     (unsigned long long)le64_to_cpu(rec.r_cpos),
 			     set_len);
 			ret = ocfs2_insert_refcount_rec(handle, ci, ref_root_bh,
@@ -2055,8 +2055,7 @@ static int __ocfs2_increase_refcount(handle_t *handle,
 			rec.r_clusters = cpu_to_le32(set_len);
 			le32_add_cpu(&rec.r_refcount, 1);
 
-			mlog(0, "split refcount rec, start %llu, "
-			     "len %u, count %u\n",
+			trace_ocfs2_increase_refcount_split(
 			     (unsigned long long)le64_to_cpu(rec.r_cpos),
 			     set_len, le32_to_cpu(rec.r_refcount));
 			ret = ocfs2_split_refcount_rec(handle, ci,
@@ -2095,6 +2094,11 @@ static int ocfs2_remove_refcount_extent(handle_t *handle,
 
 	BUG_ON(rb->rf_records.rl_used);
 
+	trace_ocfs2_remove_refcount_extent(
+		(unsigned long long)ocfs2_metadata_cache_owner(ci),
+		(unsigned long long)ref_leaf_bh->b_blocknr,
+		le32_to_cpu(rb->rf_cpos));
+
 	ocfs2_init_refcount_extent_tree(&et, ci, ref_root_bh);
 	ret = ocfs2_remove_extent(handle, &et, le32_to_cpu(rb->rf_cpos),
 				  1, meta_ac, dealloc);
@@ -2137,7 +2141,7 @@ static int ocfs2_remove_refcount_extent(handle_t *handle,
 	if (!rb->rf_list.l_next_free_rec) {
 		BUG_ON(rb->rf_clusters);
 
-		mlog(0, "reset refcount tree root %llu to be a record block.\n",
+		trace_ocfs2_restore_refcount_block(
 		     (unsigned long long)ref_root_bh->b_blocknr);
 
 		rb->rf_flags = 0;
@@ -2184,6 +2188,10 @@ static int ocfs2_decrease_refcount_rec(handle_t *handle,
 	BUG_ON(cpos + len >
 	       le64_to_cpu(rec->r_cpos) + le32_to_cpu(rec->r_clusters));
 
+	trace_ocfs2_decrease_refcount_rec(
+		(unsigned long long)ocfs2_metadata_cache_owner(ci),
+		(unsigned long long)cpos, len);
+
 	if (cpos == le64_to_cpu(rec->r_cpos) &&
 	    len == le32_to_cpu(rec->r_clusters))
 		ret = ocfs2_change_refcount_rec(handle, ci,
@@ -2195,12 +2203,6 @@ static int ocfs2_decrease_refcount_rec(handle_t *handle,
 
 		le32_add_cpu(&split.r_refcount, -1);
 
-		mlog(0, "split refcount rec, start %llu, "
-		     "len %u, count %u, original start %llu, len %u\n",
-		     (unsigned long long)le64_to_cpu(split.r_cpos),
-		     len, le32_to_cpu(split.r_refcount),
-		     (unsigned long long)le64_to_cpu(rec->r_cpos),
-		     le32_to_cpu(rec->r_clusters));
 		ret = ocfs2_split_refcount_rec(handle, ci,
 					       ref_root_bh, ref_leaf_bh,
 					       &split, index, 1,
@@ -2239,10 +2241,9 @@ static int __ocfs2_decrease_refcount(handle_t *handle,
 	struct super_block *sb = ocfs2_metadata_cache_get_super(ci);
 	struct buffer_head *ref_leaf_bh = NULL;
 
-	mlog(0, "Tree owner %llu, decrease refcount start %llu, "
-	     "len %u, delete %u\n",
-	     (unsigned long long)ocfs2_metadata_cache_owner(ci),
-	     (unsigned long long)cpos, len, delete);
+	trace_ocfs2_decrease_refcount(
+		(unsigned long long)ocfs2_metadata_cache_owner(ci),
+		(unsigned long long)cpos, len, delete);
 
 	while (len) {
 		ret = ocfs2_get_refcount_rec(ci, ref_root_bh,
@@ -2352,8 +2353,8 @@ static int ocfs2_mark_extent_refcounted(struct inode *inode,
 {
 	int ret;
 
-	mlog(0, "Inode %lu refcount tree cpos %u, len %u, phys cluster %u\n",
-	     inode->i_ino, cpos, len, phys);
+	trace_ocfs2_mark_extent_refcounted(OCFS2_I(inode)->ip_blkno,
+					   cpos, len, phys);
 
 	if (!ocfs2_refcount_tree(OCFS2_SB(inode->i_sb))) {
 		ocfs2_error(inode->i_sb, "Inode %lu want to use refcount "
@@ -2392,8 +2393,6 @@ static int ocfs2_calc_refcount_meta_credits(struct super_block *sb,
 	struct buffer_head *ref_leaf_bh = NULL, *prev_bh = NULL;
 	u32 len;
 
-	mlog(0, "start_cpos %llu, clusters %u\n",
-	     (unsigned long long)start_cpos, clusters);
 	while (clusters) {
 		ret = ocfs2_get_refcount_rec(ci, ref_root_bh,
 					     cpos, clusters, &rec,
@@ -2427,12 +2426,11 @@ static int ocfs2_calc_refcount_meta_credits(struct super_block *sb,
 
 		rb = (struct ocfs2_refcount_block *)ref_leaf_bh->b_data;
 
-		mlog(0, "recs_add %d,cpos %llu, clusters %u, rec->r_cpos %llu,"
-		     "rec->r_clusters %u, rec->r_refcount %u, index %d\n",
-		     recs_add, (unsigned long long)cpos, clusters,
-		     (unsigned long long)le64_to_cpu(rec.r_cpos),
-		     le32_to_cpu(rec.r_clusters),
-		     le32_to_cpu(rec.r_refcount), index);
+		trace_ocfs2_calc_refcount_meta_credits_iterate(
+				recs_add, (unsigned long long)cpos, clusters,
+				(unsigned long long)le64_to_cpu(rec.r_cpos),
+				le32_to_cpu(rec.r_clusters),
+				le32_to_cpu(rec.r_refcount), index);
 
 		len = min((u64)cpos + clusters, le64_to_cpu(rec.r_cpos) +
 			  le32_to_cpu(rec.r_clusters)) - cpos;
@@ -2488,7 +2486,6 @@ static int ocfs2_calc_refcount_meta_credits(struct super_block *sb,
 	if (!ref_blocks)
 		goto out;
 
-	mlog(0, "we need ref_blocks %d\n", ref_blocks);
 	*meta_add += ref_blocks;
 	*credits += ref_blocks;
 
@@ -2514,6 +2511,10 @@ static int ocfs2_calc_refcount_meta_credits(struct super_block *sb,
 	}
 
 out:
+
+	trace_ocfs2_calc_refcount_meta_credits(
+		(unsigned long long)start_cpos, clusters,
+		*meta_add, *credits);
 	brelse(ref_leaf_bh);
 	brelse(prev_bh);
 	return ret;
@@ -2578,8 +2579,7 @@ int ocfs2_prepare_refcount_change_for_del(struct inode *inode,
 		goto out;
 	}
 
-	mlog(0, "reserve new metadata %d blocks, credits = %d\n",
-	     *ref_blocks, *credits);
+	trace_ocfs2_prepare_refcount_change_for_del(*ref_blocks, *credits);
 
 out:
 	brelse(ref_root_bh);
@@ -2886,8 +2886,7 @@ static int ocfs2_lock_refcount_allocators(struct super_block *sb,
 		goto out;
 	}
 
-	mlog(0, "reserve new metadata %d, clusters %u, credits = %d\n",
-	     meta_add, num_clusters, *credits);
+	trace_ocfs2_lock_refcount_allocators(meta_add, *credits);
 	ret = ocfs2_reserve_new_metadata_blocks(OCFS2_SB(sb), meta_add,
 						meta_ac);
 	if (ret) {
@@ -2937,8 +2936,8 @@ static int ocfs2_duplicate_clusters_by_page(handle_t *handle,
 	loff_t offset, end, map_end;
 	struct address_space *mapping = context->inode->i_mapping;
 
-	mlog(0, "old_cluster %u, new %u, len %u at offset %u\n", old_cluster,
-	     new_cluster, new_len, cpos);
+	trace_ocfs2_duplicate_clusters_by_page(cpos, old_cluster,
+					       new_cluster, new_len);
 
 	readahead_pages =
 		(ocfs2_cow_contig_clusters(sb) <<
@@ -3031,8 +3030,8 @@ static int ocfs2_duplicate_clusters_by_jbd(handle_t *handle,
 	struct buffer_head *old_bh = NULL;
 	struct buffer_head *new_bh = NULL;
 
-	mlog(0, "old_cluster %u, new %u, len %u\n", old_cluster,
-	     new_cluster, new_len);
+	trace_ocfs2_duplicate_clusters_by_page(cpos, old_cluster,
+					       new_cluster, new_len);
 
 	for (i = 0; i < blocks; i++, old_block++, new_block++) {
 		new_bh = sb_getblk(osb->sb, new_block);
@@ -3085,8 +3084,8 @@ static int ocfs2_clear_ext_refcount(handle_t *handle,
 	struct super_block *sb = ocfs2_metadata_cache_get_super(et->et_ci);
 	u64 ino = ocfs2_metadata_cache_owner(et->et_ci);
 
-	mlog(0, "inode %llu cpos %u, len %u, p_cluster %u, ext_flags %u\n",
-	     (unsigned long long)ino, cpos, len, p_cluster, ext_flags);
+	trace_ocfs2_clear_ext_refcount((unsigned long long)ino,
+				       cpos, len, p_cluster, ext_flags);
 
 	memset(&replace_rec, 0, sizeof(replace_rec));
 	replace_rec.e_cpos = cpu_to_le32(cpos);
@@ -3141,8 +3140,8 @@ static int ocfs2_replace_clusters(handle_t *handle,
 	struct ocfs2_caching_info *ci = context->data_et.et_ci;
 	u64 ino = ocfs2_metadata_cache_owner(ci);
 
-	mlog(0, "inode %llu, cpos %u, old %u, new %u, len %u, ext_flags %u\n",
-	     (unsigned long long)ino, cpos, old, new, len, ext_flags);
+	trace_ocfs2_replace_clusters((unsigned long long)ino,
+				     cpos, old, new, len, ext_flags);
 
 	/*If the old clusters is unwritten, no need to duplicate. */
 	if (!(ext_flags & OCFS2_EXT_UNWRITTEN)) {
@@ -3236,8 +3235,8 @@ static int ocfs2_make_clusters_writable(struct super_block *sb,
 	struct ocfs2_caching_info *ref_ci = &context->ref_tree->rf_ci;
 	struct ocfs2_refcount_rec rec;
 
-	mlog(0, "cpos %u, p_cluster %u, num_clusters %u, e_flags %u\n",
-	     cpos, p_cluster, num_clusters, e_flags);
+	trace_ocfs2_make_clusters_writable(cpos, p_cluster,
+					   num_clusters, e_flags);
 
 	ret = ocfs2_lock_refcount_allocators(sb, p_cluster, num_clusters,
 					     &context->data_et,
@@ -3472,9 +3471,9 @@ static int ocfs2_refcount_cow_hunk(struct inode *inode,
 		goto out;
 	}
 
-	mlog(0, "CoW inode %lu, cpos %u, write_len %u, cow_start %u, "
-	     "cow_len %u\n", inode->i_ino,
-	     cpos, write_len, cow_start, cow_len);
+	trace_ocfs2_refcount_cow_hunk(OCFS2_I(inode)->ip_blkno,
+				      cpos, write_len, max_cpos,
+				      cow_start, cow_len);
 
 	BUG_ON(cow_len == 0);
 
@@ -3753,8 +3752,7 @@ int ocfs2_add_refcount_flag(struct inode *inode,
 		goto out;
 	}
 
-	mlog(0, "reserve new metadata %d, credits = %d\n",
-	     ref_blocks, credits);
+	trace_ocfs2_add_refcount_flag(ref_blocks, credits);
 
 	if (ref_blocks) {
 		ret = ocfs2_reserve_new_metadata_blocks(OCFS2_SB(inode->i_sb),
-- 
1.7.0.4
