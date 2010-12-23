From: Tao Ma <tm@tao.ma>
Date: Thu, 23 Dec 2010 15:31:00 +0800
Subject: [Ocfs2-devel] [PATCH 17/34] ocfs2: Remove masklog ML_EXTENT_MAP.
In-Reply-To: <4D12F7E7.1090204@tao.ma>
References: <4D12F7E7.1090204@tao.ma>
Message-ID: <1293089477-5019-17-git-send-email-tm@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <boyu.mt@taobao.com>

Remove mlog(0) from fs/ocfs2/extent_map.c and the masklog EXTENT_MAP.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ocfs2/cluster/masklog.c |    1 -
 fs/ocfs2/cluster/masklog.h |    1 -
 fs/ocfs2/extent_map.c      |    5 ++---
 fs/ocfs2/ocfs2_trace.h     |   32 ++++++++++++++++++++++++++++++++
 4 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index 1c1fa9d..de807d2 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -94,7 +94,6 @@ static struct mlog_attribute mlog_attrs[MLOG_MAX_BITS] = {
 	define_mask(AIO),
 	define_mask(JOURNAL),
 	define_mask(SUPER),
-	define_mask(EXTENT_MAP),
 	define_mask(DLM_GLUE),
 	define_mask(BH_IO),
 	define_mask(UPTODATE),
diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
index d6dab10..fca684c 100644
--- a/fs/ocfs2/cluster/masklog.h
+++ b/fs/ocfs2/cluster/masklog.h
@@ -96,7 +96,6 @@
 #define ML_AIO		0x0000000000002000ULL /* ocfs2 aio read and write */
 #define ML_JOURNAL	0x0000000000004000ULL /* ocfs2 journalling functions */
 #define ML_SUPER	0x0000000000010000ULL /* ocfs2 mount / umount */
-#define ML_EXTENT_MAP	0x0000000000040000ULL /* ocfs2 extent map caching */
 #define ML_DLM_GLUE	0x0000000000080000ULL /* ocfs2 dlm glue layer */
 #define ML_BH_IO	0x0000000000100000ULL /* ocfs2 buffer I/O */
 #define ML_UPTODATE	0x0000000000200000ULL /* ocfs2 caching sequence #'s */
diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index 7d74d17..23457b4 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -28,7 +28,6 @@
 #include <linux/types.h>
 #include <linux/fiemap.h>
 
-#define MLOG_MASK_PREFIX ML_EXTENT_MAP
 #include <cluster/masklog.h>
 
 #include "ocfs2.h"
@@ -39,6 +38,7 @@
 #include "inode.h"
 #include "super.h"
 #include "symlink.h"
+#include "ocfs2_trace.h"
 
 #include "buffer_head_io.h"
 
@@ -841,8 +841,7 @@ int ocfs2_read_virt_blocks(struct inode *inode, u64 v_block, int nr,
 	u64 p_block, p_count;
 	int i, count, done = 0;
 
-	mlog(0, "(inode = %p, v_block = %llu, nr = %d, bhs = %p, "
-	     "flags = %x, validate = %p)\n",
+	trace_ocfs2_read_virt_blocks(
 	     inode, (unsigned long long)v_block, nr, bhs, flags,
 	     validate);
 
diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index d9b13c1..af7a87e 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -2252,6 +2252,38 @@ DEFINE_EVENT(ocfs2__ull, ocfs2_mark_inode_dirty,
 );
 
 /* End of trace events for fs/ocfs2/inode.c. */
+
+/* Trace events for fs/ocfs2/extent_map.c. */
+TRACE_EVENT(ocfs2_read_virt_blocks,
+
+	TP_PROTO(void *inode, unsigned long long vblock, int nr,
+		 void *bhs, unsigned int flags, void *validate),
+
+	TP_ARGS(inode, vblock, nr, bhs, flags, validate),
+
+	TP_STRUCT__entry(
+		__field(	void *,			inode		)
+		__field(	unsigned long long,	vblock		)
+		__field(	int,			nr		)
+		__field(	void *,			bhs		)
+		__field(	unsigned int,		flags		)
+		__field(	void *,			validate	)
+	),
+
+	TP_fast_assign(
+		__entry->inode		= inode;
+		__entry->vblock		= vblock;
+		__entry->nr		= nr;
+		__entry->bhs		= bhs;
+		__entry->flags		= flags;
+		__entry->validate	= validate;
+	),
+
+	TP_printk("%p %llu %d %p %x %p", __entry->inode, __entry->vblock,
+		  __entry->nr, __entry->bhs, __entry->flags, __entry->validate)
+);
+/* End of trace events for fs/ocfs2/extent_map.c. */
+
 #endif /* _TRACE_OCFS2_H */
 
 /* This part must be outside protection */
-- 
1.7.0.4
