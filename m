From: Tao Ma <tm@tao.ma>
Date: Thu, 23 Dec 2010 15:31:14 +0800
Subject: [Ocfs2-devel] [PATCH 31/34] ocfs2: Remove masklog ML_BH_IO.
In-Reply-To: <4D12F7E7.1090204@tao.ma>
References: <4D12F7E7.1090204@tao.ma>
Message-ID: <1293089477-5019-31-git-send-email-tm@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <boyu.mt@taobao.com>

Remove mlog(0,...) and mlog(ML_BH_IO,...) from
fs/ocfs2/buffer_head_io.c.
The masklog BH_IO is removed finally.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ocfs2/buffer_head_io.c  |   37 +++++++--------------
 fs/ocfs2/cluster/masklog.c |    1 -
 fs/ocfs2/cluster/masklog.h |    1 -
 fs/ocfs2/ocfs2_trace.h     |   76 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 89 insertions(+), 26 deletions(-)

diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index c23846d..d1cf9ab 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -35,8 +35,8 @@
 #include "inode.h"
 #include "journal.h"
 #include "uptodate.h"
-
 #include "buffer_head_io.h"
+#include "ocfs2_trace.h"
 
 /*
  * Bits on bh->b_state used by ocfs2.
@@ -55,8 +55,7 @@ int ocfs2_write_block(struct ocfs2_super *osb, struct buffer_head *bh,
 {
 	int ret = 0;
 
-	mlog(0, "(bh->b_blocknr = %llu, ci=%p)\n",
-	     (unsigned long long)bh->b_blocknr, ci);
+	trace_ocfs2_write_block((unsigned long long)bh->b_blocknr, ci);
 
 	BUG_ON(bh->b_blocknr < OCFS2_SUPER_BLOCK_BLKNO);
 	BUG_ON(buffer_jbd(bh));
@@ -107,10 +106,10 @@ int ocfs2_read_blocks_sync(struct ocfs2_super *osb, u64 block,
 	unsigned int i;
 	struct buffer_head *bh;
 
-	if (!nr) {
-		mlog(ML_BH_IO, "No buffers will be read!\n");
+	trace_ocfs2_read_blocks_sync((unsigned long long)block, nr);
+
+	if (!nr)
 		goto bail;
-	}
 
 	for (i = 0 ; i < nr ; i++) {
 		if (bhs[i] == NULL) {
@@ -124,10 +123,8 @@ int ocfs2_read_blocks_sync(struct ocfs2_super *osb, u64 block,
 		bh = bhs[i];
 
 		if (buffer_jbd(bh)) {
-			mlog(ML_BH_IO,
-			     "trying to sync read a jbd "
-			     "managed bh (blocknr = %llu), skipping\n",
-			     (unsigned long long)bh->b_blocknr);
+			trace_ocfs2_read_blocks_sync_jbd(
+					(unsigned long long)bh->b_blocknr);
 			continue;
 		}
 
@@ -187,8 +184,7 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
 	struct buffer_head *bh;
 	struct super_block *sb = ocfs2_metadata_cache_get_super(ci);
 
-	mlog(0, "(ci=%p, block=(%llu), nr=(%d), flags=%d)\n",
-	     ci, (unsigned long long)block, nr, flags);
+	trace_ocfs2_read_blocks_begin(ci, (unsigned long long)block, nr, flags);
 
 	BUG_ON(!ci);
 	BUG_ON((flags & OCFS2_BH_READAHEAD) &&
@@ -208,7 +204,6 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
 	}
 
 	if (nr == 0) {
-		mlog(ML_BH_IO, "No buffers will be read!\n");
 		status = 0;
 		goto bail;
 	}
@@ -261,11 +256,10 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
 			ignore_cache = 1;
 		}
 
+		trace_ocfs2_read_blocks_bh((unsigned long long)bh->b_blocknr,
+			ignore_cache, buffer_jbd(bh), buffer_dirty(bh));
+
 		if (buffer_jbd(bh)) {
-			if (ignore_cache)
-				mlog(ML_BH_IO, "trying to sync read a jbd "
-					       "managed bh (blocknr = %llu)\n",
-				     (unsigned long long)bh->b_blocknr);
 			continue;
 		}
 
@@ -273,9 +267,6 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
 			if (buffer_dirty(bh)) {
 				/* This should probably be a BUG, or
 				 * at least return an error. */
-				mlog(ML_BH_IO, "asking me to sync read a dirty "
-					       "buffer! (blocknr = %llu)\n",
-				     (unsigned long long)bh->b_blocknr);
 				continue;
 			}
 
@@ -368,10 +359,8 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
 	}
 	ocfs2_metadata_cache_io_unlock(ci);
 
-	mlog(ML_BH_IO, "block=(%llu), nr=(%d), cached=%s, flags=0x%x\n",
-	     (unsigned long long)block, nr,
-	     ((flags & OCFS2_BH_IGNORE_CACHE) || ignore_cache) ? "no" : "yes",
-	     flags);
+	trace_ocfs2_read_blocks_end((unsigned long long)block, nr,
+				    flags, ignore_cache);
 
 bail:
 
diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index 3f1e995..137e7e8 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -93,7 +93,6 @@ static struct mlog_attribute mlog_attrs[MLOG_MAX_BITS] = {
 	define_mask(DLM_RECOVERY),
 	define_mask(AIO),
 	define_mask(DLM_GLUE),
-	define_mask(BH_IO),
 	define_mask(UPTODATE),
 	define_mask(VOTE),
 	define_mask(CONN),
diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
index 61e8f6c..5c7e38a 100644
--- a/fs/ocfs2/cluster/masklog.h
+++ b/fs/ocfs2/cluster/masklog.h
@@ -95,7 +95,6 @@
 #define ML_DLM_RECOVERY	0x0000000000001000ULL /* dlm master functions */
 #define ML_AIO		0x0000000000002000ULL /* ocfs2 aio read and write */
 #define ML_DLM_GLUE	0x0000000000080000ULL /* ocfs2 dlm glue layer */
-#define ML_BH_IO	0x0000000000100000ULL /* ocfs2 buffer I/O */
 #define ML_UPTODATE	0x0000000000200000ULL /* ocfs2 caching sequence #'s */
 #define ML_VOTE		0x0000000001000000ULL /* ocfs2 node messaging  */
 #define ML_CONN		0x0000000004000000ULL /* net connection management */
diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index 736cb40..9cd8670 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -4177,6 +4177,82 @@ DEFINE_EVENT(ocfs2__int, ocfs2_wait_on_mount,
 	TP_ARGS(state)
 );
 /* End of trace events for fs/ocfs2/journal.c. */
+
+/* Trace events for fs/ocfs2/buffer_head_io.c. */
+DEFINE_EVENT(ocfs2__ull_uint, ocfs2_read_blocks_sync,
+
+	TP_PROTO(unsigned long long block, unsigned int nr),
+
+	TP_ARGS(block, nr)
+);
+
+DEFINE_EVENT(ocfs2__ull, ocfs2_read_blocks_sync_jbd,
+
+	TP_PROTO(unsigned long long block),
+
+	TP_ARGS(block)
+);
+
+DEFINE_EVENT(ocfs2__ull_int_int_int, ocfs2_read_blocks_bh,
+
+	TP_PROTO(unsigned long long block, int ignore_cache,
+		 int buffer_jbd, int buffer_dirty),
+
+	TP_ARGS(block, ignore_cache, buffer_jbd, buffer_dirty)
+);
+
+DEFINE_EVENT(ocfs2__ull_int_int_int, ocfs2_read_blocks_end,
+
+	TP_PROTO(unsigned long long block, int nr, int flags, int ignore_cache),
+
+	TP_ARGS(block, nr, flags, ignore_cache)
+);
+
+TRACE_EVENT(ocfs2_write_block,
+
+	TP_PROTO(unsigned long long block, void *ci),
+
+	TP_ARGS(block, ci),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	block	)
+		__field(	void *,			ci	)
+	),
+
+	TP_fast_assign(
+		__entry->block		= 	block;
+		__entry->ci		= 	ci;
+	),
+
+	TP_printk("%llu %p", __entry->block, __entry->ci)
+);
+
+TRACE_EVENT(ocfs2_read_blocks_begin,
+
+	TP_PROTO(void *ci, unsigned long long block,
+		 unsigned int nr, int flags),
+
+	TP_ARGS(ci, block, nr, flags),
+
+	TP_STRUCT__entry(
+		__field(	void *,			ci	)
+		__field(	unsigned long long,	block	)
+		__field(	unsigned int,		nr	)
+		__field(	int,			flags	)
+	),
+
+	TP_fast_assign(
+		__entry->ci		= 	ci;
+		__entry->block		= 	block;
+		__entry->nr		= 	nr;
+		__entry->flags		= 	flags;
+	),
+
+	TP_printk("%p %llu %u %d", __entry->ci, __entry->block,
+		  __entry->nr, __entry->flags)
+);
+
+/* End of trace events for fs/ocfs2/buffer_head_io.c. */
 #endif /* _TRACE_OCFS2_H */
 
 /* This part must be outside protection */
-- 
1.7.0.4
