From: Tao Ma <tm@tao.ma>
Date: Thu, 23 Dec 2010 15:31:02 +0800
Subject: [Ocfs2-devel] [PATCH 19/34] ocfs2: Remove mlog(0) from
	fs/ocfs2/heartbeat.c
In-Reply-To: <4D12F7E7.1090204@tao.ma>
References: <4D12F7E7.1090204@tao.ma>
Message-ID: <1293089477-5019-19-git-send-email-tm@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <boyu.mt@taobao.com>

This is the 2nd step to remove the debug info of SUPER.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ocfs2/heartbeat.c   |    4 ++--
 fs/ocfs2/ocfs2_trace.h |    9 +++++++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/heartbeat.c b/fs/ocfs2/heartbeat.c
index 1aa863d..d8208b2 100644
--- a/fs/ocfs2/heartbeat.c
+++ b/fs/ocfs2/heartbeat.c
@@ -28,7 +28,6 @@
 #include <linux/types.h>
 #include <linux/highmem.h>
 
-#define MLOG_MASK_PREFIX ML_SUPER
 #include <cluster/masklog.h>
 
 #include "ocfs2.h"
@@ -37,6 +36,7 @@
 #include "heartbeat.h"
 #include "inode.h"
 #include "journal.h"
+#include "ocfs2_trace.h"
 
 #include "buffer_head_io.h"
 
@@ -66,7 +66,7 @@ void ocfs2_do_node_down(int node_num, void *data)
 
 	BUG_ON(osb->node_num == node_num);
 
-	mlog(0, "ocfs2: node down event for %d\n", node_num);
+	trace_ocfs2_do_node_down(node_num);
 
 	if (!osb->cconn) {
 		/*
diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index 0856f29..576af58 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -2284,6 +2284,15 @@ TRACE_EVENT(ocfs2_read_virt_blocks,
 );
 /* End of trace events for fs/ocfs2/extent_map.c. */
 
+/* Trace events for fs/ocfs2/heartbeat.c. */
+DEFINE_EVENT(ocfs2__int, ocfs2_do_node_down,
+
+	TP_PROTO(int node_num),
+
+	TP_ARGS(node_num)
+);
+/* End of trace events for fs/ocfs2/heartbeat.c. */
+
 /* Trace events for fs/ocfs2/slot_map.c. */
 DEFINE_EVENT(ocfs2__uint, ocfs2_refresh_slot_info,
 
-- 
1.7.0.4
