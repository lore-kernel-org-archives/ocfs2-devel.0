From: Tao Ma <tm@tao.ma>
Date: Thu, 23 Dec 2010 15:30:47 +0800
Subject: [Ocfs2-devel] [PATCH 04/34] ocfs2: Add ocfs2_trace.h.
In-Reply-To: <4D12F7E7.1090204@tao.ma>
References: <4D12F7E7.1090204@tao.ma>
Message-ID: <1293089477-5019-4-git-send-email-tm@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Wengang Wang <wen.gang.wang@oracle.com>

About one year ago, Wengang Wang tried some first steps
to add tracepoints to ocfs2. But at that time we don't
have ocfs2 1.6 introduced, so we delay this work until now
after ocfs2 1.6 and UEK(Unbreakable Enterprise Kernel) are
released.

Wengang's original patch is here:
http://oss.oracle.com/pipermail/ocfs2-devel/2009-November/005512.html

But as Steven Rostedt indicated in his article
http://lwn.net/Articles/383362/, we'd better have our trace
files resides in fs/ocfs2, so I rewrited the patch using the
method Steven mentioned in that article.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/ocfs2_trace.h |   16 ++++++++++++++++
 fs/ocfs2/super.c       |    3 +++
 2 files changed, 19 insertions(+), 0 deletions(-)
 create mode 100644 fs/ocfs2/ocfs2_trace.h

diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
new file mode 100644
index 0000000..8d4e49a
--- /dev/null
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -0,0 +1,16 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM ocfs2
+
+#if !defined(_TRACE_OCFS2_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_OCFS2_H
+
+#include <linux/tracepoint.h>
+
+
+#endif /* _TRACE_OCFS2_H */
+
+/* This part must be outside protection */
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE ocfs2_trace
+#include <trace/define_trace.h>
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 9e41894..e88013c 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -42,6 +42,9 @@
 #include <linux/seq_file.h>
 #include <linux/quotaops.h>
 
+#define CREATE_TRACE_POINTS
+#include "ocfs2_trace.h"
+
 #define MLOG_MASK_PREFIX ML_SUPER
 #include <cluster/masklog.h>
 
-- 
1.7.0.4
