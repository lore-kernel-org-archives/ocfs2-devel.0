From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 17 Sep 2009 19:56:39 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: add trace event for
	ocfs2_file_aio_read
Message-ID: <200909170419.n8H4JcaQ020085@acsinet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

add trace event for ocfs2_file_aio_read().

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/file.c              |    8 ++++----
 include/trace/events/ocfs2.h |   25 +++++++++++++++++++++++++
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 221c5e9..a1587ee 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -62,6 +62,9 @@
 
 #include "buffer_head_io.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/ocfs2.h>
+
 static int ocfs2_sync_inode(struct inode *inode)
 {
 	filemap_fdatawrite(inode->i_mapping);
@@ -2050,10 +2053,7 @@ static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
 	struct file *filp = iocb->ki_filp;
 	struct inode *inode = filp->f_path.dentry->d_inode;
 
-	mlog_entry("(0x%p, %u, '%.*s')\n", filp,
-		   (unsigned int)nr_segs,
-		   filp->f_path.dentry->d_name.len,
-		   filp->f_path.dentry->d_name.name);
+	trace_ocfs2_file_aio_read(iocb, iov, nr_segs, pos);
 
 	if (!inode) {
 		ret = -EINVAL;
diff --git a/include/trace/events/ocfs2.h b/include/trace/events/ocfs2.h
index fa86758..5310901 100644
--- a/include/trace/events/ocfs2.h
+++ b/include/trace/events/ocfs2.h
@@ -5,10 +5,35 @@
 #define TRACE_SYSTEM ocfs2
 /* add ocfs2 relevant header files below */
 
+#include "../../../fs/ocfs2/ocfs2.h"
 /* add ocfs2 relevant header files above */
 #include <linux/tracepoint.h>
 
 /* add tracing declarations below */
+TRACE_EVENT(ocfs2_file_aio_read,
+
+	TP_PROTO(struct kiocb *iocb, const struct iovec *iov,
+		 unsigned long nr_segs, loff_t pos),
+
+	TP_ARGS(iocb, iov, nr_segs, pos),
+
+	TP_STRUCT__entry(
+		__field(        void *,         iocb            )
+		__field(        void *,         iov             )
+		__field(        unsigned long,  nr_segs         )
+		__field(        loff_t,         pos             )
+	),
+
+	TP_fast_assign(
+		__entry->iocb           = (void*)iocb;
+		__entry->iov            = (void*)iov;
+		__entry->nr_segs        = nr_segs;
+		__entry->pos            = pos;
+	),
+
+	TP_printk("0x%p 0x%p %lu %llu\n",
+		  __entry->iocb, __entry->iov, __entry->nr_segs, __entry->pos)
+);
 
 /* add tracing declarations above */
 #endif /* _TRACE_OCFS2_H */
-- 
1.6.2.5
