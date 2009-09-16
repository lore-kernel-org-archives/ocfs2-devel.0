From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 17 Sep 2009 06:19:44 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: add trace event header for ocfs2
Message-ID: <200909170419.n8H4JQAI019684@acsinet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

add trace event header for ocfs2.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 include/trace/events/ocfs2.h |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)
 create mode 100644 include/trace/events/ocfs2.h

diff --git a/include/trace/events/ocfs2.h b/include/trace/events/ocfs2.h
new file mode 100644
index 0000000..fa86758
--- /dev/null
+++ b/include/trace/events/ocfs2.h
@@ -0,0 +1,17 @@
+#if !defined(_TRACE_OCFS2_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_OCFS2_H
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM ocfs2
+/* add ocfs2 relevant header files below */
+
+/* add ocfs2 relevant header files above */
+#include <linux/tracepoint.h>
+
+/* add tracing declarations below */
+
+/* add tracing declarations above */
+#endif /* _TRACE_OCFS2_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.6.2.5
