From: Tao Ma <tm@tao.ma>
Date: Thu, 23 Dec 2010 15:31:01 +0800
Subject: [Ocfs2-devel] [PATCH 18/34] ocfs2: Remove mlog(0) from
	fs/ocfs2/slot_map.c
In-Reply-To: <4D12F7E7.1090204@tao.ma>
References: <4D12F7E7.1090204@tao.ma>
Message-ID: <1293089477-5019-18-git-send-email-tm@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <boyu.mt@taobao.com>

This is the 1st step to remove the debug info of SUPER.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ocfs2/ocfs2_trace.h |   30 ++++++++++++++++++++++++++++++
 fs/ocfs2/slot_map.c    |   13 +++++--------
 2 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index af7a87e..0856f29 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -2284,6 +2284,36 @@ TRACE_EVENT(ocfs2_read_virt_blocks,
 );
 /* End of trace events for fs/ocfs2/extent_map.c. */
 
+/* Trace events for fs/ocfs2/slot_map.c. */
+DEFINE_EVENT(ocfs2__uint, ocfs2_refresh_slot_info,
+
+	TP_PROTO(unsigned int blocks),
+
+	TP_ARGS(blocks)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint, ocfs2_map_slot_buffers,
+
+	TP_PROTO(unsigned long long bytes, unsigned int blocks),
+
+	TP_ARGS(bytes, blocks)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint, ocfs2_map_slot_buffers_block,
+
+	TP_PROTO(unsigned long long blkno, unsigned int i),
+
+	TP_ARGS(blkno, i)
+);
+
+DEFINE_EVENT(ocfs2__int, ocfs2_find_slot,
+
+	TP_PROTO(int slot),
+
+	TP_ARGS(slot)
+);
+
+/* End of trace events for fs/ocfs2/slot_map.c. */
 #endif /* _TRACE_OCFS2_H */
 
 /* This part must be outside protection */
diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index 93b449e..26fc001 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -27,7 +27,6 @@
 #include <linux/slab.h>
 #include <linux/highmem.h>
 
-#define MLOG_MASK_PREFIX ML_SUPER
 #include <cluster/masklog.h>
 
 #include "ocfs2.h"
@@ -39,6 +38,7 @@
 #include "slot_map.h"
 #include "super.h"
 #include "sysfile.h"
+#include "ocfs2_trace.h"
 
 #include "buffer_head_io.h"
 
@@ -142,8 +142,7 @@ int ocfs2_refresh_slot_info(struct ocfs2_super *osb)
 	BUG_ON(si->si_blocks == 0);
 	BUG_ON(si->si_bh == NULL);
 
-	mlog(0, "Refreshing slot map, reading %u block(s)\n",
-	     si->si_blocks);
+	trace_ocfs2_refresh_slot_info(si->si_blocks);
 
 	/*
 	 * We pass -1 as blocknr because we expect all of si->si_bh to
@@ -381,8 +380,7 @@ static int ocfs2_map_slot_buffers(struct ocfs2_super *osb,
 	/* The size checks above should ensure this */
 	BUG_ON((osb->max_slots / si->si_slots_per_block) > blocks);
 
-	mlog(0, "Slot map needs %u buffers for %llu bytes\n",
-	     si->si_blocks, bytes);
+	trace_ocfs2_map_slot_buffers(bytes, si->si_blocks);
 
 	si->si_bh = kzalloc(sizeof(struct buffer_head *) * si->si_blocks,
 			    GFP_KERNEL);
@@ -400,8 +398,7 @@ static int ocfs2_map_slot_buffers(struct ocfs2_super *osb,
 			goto bail;
 		}
 
-		mlog(0, "Reading slot map block %u at %llu\n", i,
-		     (unsigned long long)blkno);
+		trace_ocfs2_map_slot_buffers_block((unsigned long long)blkno, i);
 
 		bh = NULL;  /* Acquire a fresh bh */
 		status = ocfs2_read_blocks(INODE_CACHE(si->si_inode), blkno,
@@ -503,7 +500,7 @@ int ocfs2_find_slot(struct ocfs2_super *osb)
 	osb->slot_num = slot;
 	spin_unlock(&osb->osb_lock);
 
-	mlog(0, "taking node slot %d\n", osb->slot_num);
+	trace_ocfs2_find_slot(osb->slot_num);
 
 	status = ocfs2_update_disk_slot(osb, si, osb->slot_num);
 	if (status < 0)
-- 
1.7.0.4
