From: Tao Ma <tm@tao.ma>
Date: Thu, 23 Dec 2010 15:31:15 +0800
Subject: [Ocfs2-devel] [PATCH 32/34] ocfs2: Remove masklog ML_UPTODATE.
In-Reply-To: <4D12F7E7.1090204@tao.ma>
References: <4D12F7E7.1090204@tao.ma>
Message-ID: <1293089477-5019-32-git-send-email-tm@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <boyu.mt@taobao.com>

Remove mlog(0,...) and mlog(ML_UPTODATE,...) from
fs/ocfs2/uptodate.c and fs/ocfs2/buffer_head_io.c.

The masklog UPTODATE is removed finally.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ocfs2/buffer_head_io.c  |    3 +-
 fs/ocfs2/cluster/masklog.c |    1 -
 fs/ocfs2/cluster/masklog.h |    1 -
 fs/ocfs2/ocfs2_trace.h     |  116 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/uptodate.c        |   73 ++++++++++++++--------------
 5 files changed, 153 insertions(+), 41 deletions(-)

diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index d1cf9ab..5d18ad1 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -247,8 +247,7 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
 		 */
 
 		if (!ignore_cache && !ocfs2_buffer_uptodate(ci, bh)) {
-			mlog(ML_UPTODATE,
-			     "bh (%llu), owner %llu not uptodate\n",
+			trace_ocfs2_read_blocks_from_disk(
 			     (unsigned long long)bh->b_blocknr,
 			     (unsigned long long)ocfs2_metadata_cache_owner(ci));
 			/* We're using ignore_cache here to say
diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index 137e7e8..89235aa 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -93,7 +93,6 @@ static struct mlog_attribute mlog_attrs[MLOG_MAX_BITS] = {
 	define_mask(DLM_RECOVERY),
 	define_mask(AIO),
 	define_mask(DLM_GLUE),
-	define_mask(UPTODATE),
 	define_mask(VOTE),
 	define_mask(CONN),
 	define_mask(QUORUM),
diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
index 5c7e38a..a81b883 100644
--- a/fs/ocfs2/cluster/masklog.h
+++ b/fs/ocfs2/cluster/masklog.h
@@ -95,7 +95,6 @@
 #define ML_DLM_RECOVERY	0x0000000000001000ULL /* dlm master functions */
 #define ML_AIO		0x0000000000002000ULL /* ocfs2 aio read and write */
 #define ML_DLM_GLUE	0x0000000000080000ULL /* ocfs2 dlm glue layer */
-#define ML_UPTODATE	0x0000000000200000ULL /* ocfs2 caching sequence #'s */
 #define ML_VOTE		0x0000000001000000ULL /* ocfs2 node messaging  */
 #define ML_CONN		0x0000000004000000ULL /* net connection management */
 #define ML_QUORUM	0x0000000008000000ULL /* net connection quorum */
diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index 9cd8670..482c02a 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -4193,6 +4193,13 @@ DEFINE_EVENT(ocfs2__ull, ocfs2_read_blocks_sync_jbd,
 	TP_ARGS(block)
 );
 
+DEFINE_EVENT(ocfs2__ull_ull, ocfs2_read_blocks_from_disk,
+
+	TP_PROTO(unsigned long long block, unsigned long long owner),
+
+	TP_ARGS(block, owner)
+);
+
 DEFINE_EVENT(ocfs2__ull_int_int_int, ocfs2_read_blocks_bh,
 
 	TP_PROTO(unsigned long long block, int ignore_cache,
@@ -4253,6 +4260,115 @@ TRACE_EVENT(ocfs2_read_blocks_begin,
 );
 
 /* End of trace events for fs/ocfs2/buffer_head_io.c. */
+
+/* Trace events for fs/ocfs2/uptodate.c. */
+DEFINE_EVENT(ocfs2__ull, ocfs2_purge_copied_metadata_tree,
+
+	TP_PROTO(unsigned long long block),
+
+	TP_ARGS(block)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint_uint, ocfs2_metadata_cache_purge,
+
+	TP_PROTO(unsigned long long owner,
+		 unsigned int to_purge, unsigned int tree),
+
+	TP_ARGS(owner, to_purge, tree)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull_uint, ocfs2_buffer_cached_begin,
+
+	TP_PROTO(unsigned long long owner,
+		 unsigned long long block, unsigned int inlined),
+
+	TP_ARGS(owner, block, inlined)
+);
+
+TRACE_EVENT(ocfs2_buffer_cached_end,
+
+	TP_PROTO(int index, void *item),
+
+	TP_ARGS(index, item),
+
+	TP_STRUCT__entry(
+		__field(	int,			index	)
+		__field(	void *,			item	)
+	),
+
+	TP_fast_assign(
+		__entry->index		= 	index;
+		__entry->item		= 	item;
+	),
+
+	TP_printk("%d %p", __entry->index, __entry->item)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull_uint, ocfs2_append_cache_array,
+
+	TP_PROTO(unsigned long long owner,
+		 unsigned long long block, unsigned int index),
+
+	TP_ARGS(owner, block, index)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull_uint, ocfs2_insert_cache_tree,
+
+	TP_PROTO(unsigned long long owner,
+		 unsigned long long block, unsigned int num),
+
+	TP_ARGS(owner, block, num)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint_uint, ocfs2_expand_cache,
+
+	TP_PROTO(unsigned long long owner,
+		 unsigned int flags, unsigned int num),
+
+	TP_ARGS(owner, flags, num)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull_uint, ocfs2_set_buffer_uptodate,
+
+	TP_PROTO(unsigned long long owner,
+		 unsigned long long block, unsigned int expand_tree),
+
+	TP_ARGS(owner, block, expand_tree)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull, ocfs2_set_buffer_uptodate_begin,
+
+	TP_PROTO(unsigned long long owner,
+		 unsigned long long block),
+
+	TP_ARGS(owner, block)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint_uint, ocfs2_remove_metadata_array,
+
+	TP_PROTO(unsigned long long owner,
+		 unsigned int index, unsigned int num_cached),
+
+	TP_ARGS(owner, index, num_cached)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull, ocfs2_remove_metadata_tree,
+
+	TP_PROTO(unsigned long long owner,
+		 unsigned long long block),
+
+	TP_ARGS(owner, block)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull_uint_uint, ocfs2_remove_block_from_cache,
+
+	TP_PROTO(unsigned long long owner, unsigned long long block,
+		 unsigned int num_cached, unsigned int flags),
+
+	TP_ARGS(owner, block, num_cached, flags)
+);
+
+/* End of trace events for fs/ocfs2/uptodate.c. */
 #endif /* _TRACE_OCFS2_H */
 
 /* This part must be outside protection */
diff --git a/fs/ocfs2/uptodate.c b/fs/ocfs2/uptodate.c
index a0a120e..52eaf33 100644
--- a/fs/ocfs2/uptodate.c
+++ b/fs/ocfs2/uptodate.c
@@ -54,14 +54,13 @@
 #include <linux/buffer_head.h>
 #include <linux/rbtree.h>
 
-#define MLOG_MASK_PREFIX ML_UPTODATE
-
 #include <cluster/masklog.h>
 
 #include "ocfs2.h"
 
 #include "inode.h"
 #include "uptodate.h"
+#include "ocfs2_trace.h"
 
 struct ocfs2_meta_cache_item {
 	struct rb_node	c_node;
@@ -152,8 +151,8 @@ static unsigned int ocfs2_purge_copied_metadata_tree(struct rb_root *root)
 	while ((node = rb_last(root)) != NULL) {
 		item = rb_entry(node, struct ocfs2_meta_cache_item, c_node);
 
-		mlog(0, "Purge item %llu\n",
-		     (unsigned long long) item->c_block);
+		trace_ocfs2_purge_copied_metadata_tree(
+					(unsigned long long) item->c_block);
 
 		rb_erase(&item->c_node, root);
 		kmem_cache_free(ocfs2_uptodate_cachep, item);
@@ -180,9 +179,9 @@ void ocfs2_metadata_cache_purge(struct ocfs2_caching_info *ci)
 	tree = !(ci->ci_flags & OCFS2_CACHE_FL_INLINE);
 	to_purge = ci->ci_num_cached;
 
-	mlog(0, "Purge %u %s items from Owner %llu\n", to_purge,
-	     tree ? "array" : "tree",
-	     (unsigned long long)ocfs2_metadata_cache_owner(ci));
+	trace_ocfs2_metadata_cache_purge(
+		(unsigned long long)ocfs2_metadata_cache_owner(ci),
+		to_purge, tree);
 
 	/* If we're a tree, save off the root so that we can safely
 	 * initialize the cache. We do the work to free tree members
@@ -249,10 +248,10 @@ static int ocfs2_buffer_cached(struct ocfs2_caching_info *ci,
 
 	ocfs2_metadata_cache_lock(ci);
 
-	mlog(0, "Owner %llu, query block %llu (inline = %u)\n",
-	     (unsigned long long)ocfs2_metadata_cache_owner(ci),
-	     (unsigned long long) bh->b_blocknr,
-	     !!(ci->ci_flags & OCFS2_CACHE_FL_INLINE));
+	trace_ocfs2_buffer_cached_begin(
+		(unsigned long long)ocfs2_metadata_cache_owner(ci),
+		(unsigned long long) bh->b_blocknr,
+		!!(ci->ci_flags & OCFS2_CACHE_FL_INLINE));
 
 	if (ci->ci_flags & OCFS2_CACHE_FL_INLINE)
 		index = ocfs2_search_cache_array(ci, bh->b_blocknr);
@@ -261,7 +260,7 @@ static int ocfs2_buffer_cached(struct ocfs2_caching_info *ci,
 
 	ocfs2_metadata_cache_unlock(ci);
 
-	mlog(0, "index = %d, item = %p\n", index, item);
+	trace_ocfs2_buffer_cached_end(index, item);
 
 	return (index != -1) || (item != NULL);
 }
@@ -306,8 +305,9 @@ static void ocfs2_append_cache_array(struct ocfs2_caching_info *ci,
 {
 	BUG_ON(ci->ci_num_cached >= OCFS2_CACHE_INFO_MAX_ARRAY);
 
-	mlog(0, "block %llu takes position %u\n", (unsigned long long) block,
-	     ci->ci_num_cached);
+	trace_ocfs2_append_cache_array(
+		(unsigned long long)ocfs2_metadata_cache_owner(ci),
+		(unsigned long long)block, ci->ci_num_cached);
 
 	ci->ci_cache.ci_array[ci->ci_num_cached] = block;
 	ci->ci_num_cached++;
@@ -324,8 +324,9 @@ static void __ocfs2_insert_cache_tree(struct ocfs2_caching_info *ci,
 	struct rb_node **p = &ci->ci_cache.ci_tree.rb_node;
 	struct ocfs2_meta_cache_item *tmp;
 
-	mlog(0, "Insert block %llu num = %u\n", (unsigned long long) block,
-	     ci->ci_num_cached);
+	trace_ocfs2_insert_cache_tree(
+		(unsigned long long)ocfs2_metadata_cache_owner(ci),
+		(unsigned long long)block, ci->ci_num_cached);
 
 	while(*p) {
 		parent = *p;
@@ -389,9 +390,9 @@ static void ocfs2_expand_cache(struct ocfs2_caching_info *ci,
 		tree[i] = NULL;
 	}
 
-	mlog(0, "Expanded %llu to a tree cache: flags 0x%x, num = %u\n",
-	     (unsigned long long)ocfs2_metadata_cache_owner(ci),
-	     ci->ci_flags, ci->ci_num_cached);
+	trace_ocfs2_expand_cache(
+		(unsigned long long)ocfs2_metadata_cache_owner(ci),
+		ci->ci_flags, ci->ci_num_cached);
 }
 
 /* Slow path function - memory allocation is necessary. See the
@@ -405,9 +406,9 @@ static void __ocfs2_set_buffer_uptodate(struct ocfs2_caching_info *ci,
 	struct ocfs2_meta_cache_item *tree[OCFS2_CACHE_INFO_MAX_ARRAY] =
 		{ NULL, };
 
-	mlog(0, "Owner %llu, block %llu, expand = %d\n",
-	     (unsigned long long)ocfs2_metadata_cache_owner(ci),
-	     (unsigned long long)block, expand_tree);
+	trace_ocfs2_set_buffer_uptodate(
+		(unsigned long long)ocfs2_metadata_cache_owner(ci),
+		(unsigned long long)block, expand_tree);
 
 	new = kmem_cache_alloc(ocfs2_uptodate_cachep, GFP_NOFS);
 	if (!new) {
@@ -433,7 +434,6 @@ static void __ocfs2_set_buffer_uptodate(struct ocfs2_caching_info *ci,
 
 	ocfs2_metadata_cache_lock(ci);
 	if (ocfs2_insert_can_use_array(ci)) {
-		mlog(0, "Someone cleared the tree underneath us\n");
 		/* Ok, items were removed from the cache in between
 		 * locks. Detect this and revert back to the fast path */
 		ocfs2_append_cache_array(ci, block);
@@ -490,9 +490,9 @@ void ocfs2_set_buffer_uptodate(struct ocfs2_caching_info *ci,
 	if (ocfs2_buffer_cached(ci, bh))
 		return;
 
-	mlog(0, "Owner %llu, inserting block %llu\n",
-	     (unsigned long long)ocfs2_metadata_cache_owner(ci),
-	     (unsigned long long)bh->b_blocknr);
+	trace_ocfs2_set_buffer_uptodate_begin(
+		(unsigned long long)ocfs2_metadata_cache_owner(ci),
+		(unsigned long long)bh->b_blocknr);
 
 	/* No need to recheck under spinlock - insertion is guarded by
 	 * co_io_lock() */
@@ -542,8 +542,9 @@ static void ocfs2_remove_metadata_array(struct ocfs2_caching_info *ci,
 	BUG_ON(index >= ci->ci_num_cached);
 	BUG_ON(!ci->ci_num_cached);
 
-	mlog(0, "remove index %d (num_cached = %u\n", index,
-	     ci->ci_num_cached);
+	trace_ocfs2_remove_metadata_array(
+		(unsigned long long)ocfs2_metadata_cache_owner(ci),
+		index, ci->ci_num_cached);
 
 	ci->ci_num_cached--;
 
@@ -559,8 +560,9 @@ static void ocfs2_remove_metadata_array(struct ocfs2_caching_info *ci,
 static void ocfs2_remove_metadata_tree(struct ocfs2_caching_info *ci,
 				       struct ocfs2_meta_cache_item *item)
 {
-	mlog(0, "remove block %llu from tree\n",
-	     (unsigned long long) item->c_block);
+	trace_ocfs2_remove_metadata_tree(
+		(unsigned long long)ocfs2_metadata_cache_owner(ci),
+		(unsigned long long)item->c_block);
 
 	rb_erase(&item->c_node, &ci->ci_cache.ci_tree);
 	ci->ci_num_cached--;
@@ -573,10 +575,10 @@ static void ocfs2_remove_block_from_cache(struct ocfs2_caching_info *ci,
 	struct ocfs2_meta_cache_item *item = NULL;
 
 	ocfs2_metadata_cache_lock(ci);
-	mlog(0, "Owner %llu, remove %llu, items = %u, array = %u\n",
-	     (unsigned long long)ocfs2_metadata_cache_owner(ci),
-	     (unsigned long long) block, ci->ci_num_cached,
-	     ci->ci_flags & OCFS2_CACHE_FL_INLINE);
+	trace_ocfs2_remove_block_from_cache(
+		(unsigned long long)ocfs2_metadata_cache_owner(ci),
+		(unsigned long long) block, ci->ci_num_cached,
+		ci->ci_flags);
 
 	if (ci->ci_flags & OCFS2_CACHE_FL_INLINE) {
 		index = ocfs2_search_cache_array(ci, block);
@@ -626,9 +628,6 @@ int __init init_ocfs2_uptodate_cache(void)
 	if (!ocfs2_uptodate_cachep)
 		return -ENOMEM;
 
-	mlog(0, "%u inlined cache items per inode.\n",
-	     OCFS2_CACHE_INFO_MAX_ARRAY);
-
 	return 0;
 }
 
-- 
1.7.0.4
