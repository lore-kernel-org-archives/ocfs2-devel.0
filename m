From: Tao Ma <tm@tao.ma>
Date: Thu, 23 Dec 2010 15:30:55 +0800
Subject: [Ocfs2-devel] [PATCH 12/34] ocfs2: Remove FILE_IO from masklog.
In-Reply-To: <4D12F7E7.1090204@tao.ma>
References: <4D12F7E7.1090204@tao.ma>
Message-ID: <1293089477-5019-12-git-send-email-tm@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <tao.ma@oracle.com>

Change all the "mlog(0," in fs/ocfs2/mmap.c to trace events.
And finally remove masklog FILE_IO.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/cluster/masklog.c |    1 -
 fs/ocfs2/cluster/masklog.h |    1 -
 fs/ocfs2/mmap.c            |    7 +++----
 fs/ocfs2/ocfs2_trace.h     |   28 ++++++++++++++++++++++++++++
 4 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index b8939c4..c654038 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -94,7 +94,6 @@ static struct mlog_attribute mlog_attrs[MLOG_MAX_BITS] = {
 	define_mask(AIO),
 	define_mask(JOURNAL),
 	define_mask(SUPER),
-	define_mask(FILE_IO),
 	define_mask(EXTENT_MAP),
 	define_mask(DLM_GLUE),
 	define_mask(BH_IO),
diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
index 8379361..de412aa 100644
--- a/fs/ocfs2/cluster/masklog.h
+++ b/fs/ocfs2/cluster/masklog.h
@@ -96,7 +96,6 @@
 #define ML_AIO		0x0000000000002000ULL /* ocfs2 aio read and write */
 #define ML_JOURNAL	0x0000000000004000ULL /* ocfs2 journalling functions */
 #define ML_SUPER	0x0000000000010000ULL /* ocfs2 mount / umount */
-#define ML_FILE_IO	0x0000000000020000ULL /* ocfs2 file I/O */
 #define ML_EXTENT_MAP	0x0000000000040000ULL /* ocfs2 extent map caching */
 #define ML_DLM_GLUE	0x0000000000080000ULL /* ocfs2 dlm glue layer */
 #define ML_BH_IO	0x0000000000100000ULL /* ocfs2 buffer I/O */
diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
index 49730b5..3e9393c 100644
--- a/fs/ocfs2/mmap.c
+++ b/fs/ocfs2/mmap.c
@@ -31,7 +31,6 @@
 #include <linux/signal.h>
 #include <linux/rbtree.h>
 
-#define MLOG_MASK_PREFIX ML_FILE_IO
 #include <cluster/masklog.h>
 
 #include "ocfs2.h"
@@ -42,6 +41,7 @@
 #include "inode.h"
 #include "mmap.h"
 #include "super.h"
+#include "ocfs2_trace.h"
 
 
 static int ocfs2_fault(struct vm_area_struct *area, struct vm_fault *vmf)
@@ -49,13 +49,12 @@ static int ocfs2_fault(struct vm_area_struct *area, struct vm_fault *vmf)
 	sigset_t oldset;
 	int ret;
 
-	mlog(0, "(area=%p, page offset=%lu)\n", area, vmf->pgoff);
-
 	ocfs2_block_signals(&oldset);
 	ret = filemap_fault(area, vmf);
 	ocfs2_unblock_signals(&oldset);
 
-	mlog(0, "%p\n", vmf->page);
+	trace_ocfs2_fault(OCFS2_I(area->vm_file->f_mapping->host)->ip_blkno,
+			  area, vmf->page, vmf->pgoff);
 	return ret;
 }
 
diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index 26d9a05..efda83e 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -1630,6 +1630,34 @@ TRACE_EVENT(ocfs2_write_end_inline,
 		  __entry->id_count, __entry->features)
 );
 /* End of trace events for fs/ocfs2/aops.c. */
+
+/* Trace events for fs/ocfs2/mmap.c. */
+TRACE_EVENT(ocfs2_fault,
+
+	TP_PROTO(unsigned long long ino,
+		 void *area, void *page, unsigned long pgoff),
+
+	TP_ARGS(ino, area, page, pgoff),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	ino		)
+		__field(	void *,			area		)
+		__field(	void *,			page		)
+		__field(	unsigned long,		pgoff		)
+	),
+
+	TP_fast_assign(
+		__entry->ino		= ino;
+		__entry->area		= area;
+		__entry->page		= page;
+		__entry->pgoff		= pgoff;
+	),
+
+	TP_printk("%llu %p %p %lu",
+		  __entry->ino, __entry->area, __entry->page, __entry->pgoff)
+);
+/* End of trace events for fs/ocfs2/mmap.c. */
+
 #endif /* _TRACE_OCFS2_H */
 
 /* This part must be outside protection */
-- 
1.7.0.4
