From: Tao Ma <tm@tao.ma>
Date: Thu, 23 Dec 2010 15:31:06 +0800
Subject: [Ocfs2-devel] [PATCH 23/34] ocfs2: Remove mlog(0) from
	quota_local.c.
In-Reply-To: <4D12F7E7.1090204@tao.ma>
References: <4D12F7E7.1090204@tao.ma>
Message-ID: <1293089477-5019-23-git-send-email-tm@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <boyu.mt@taobao.com>

Remove mlog(0) from fs/ocfs2/quota_local.c.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ocfs2/ocfs2_trace.h |   24 ++++++++++++++++++++++++
 fs/ocfs2/quota_local.c |   13 +++++++------
 2 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index b0bb9a6..fef6478 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -2976,6 +2976,30 @@ TRACE_EVENT(ocfs2_resmap_claimed_bits_end,
 		  __entry->len, __entry->last_start, __entry->last_len)
 );
 /* End of trace events for fs/ocfs2/reservations.c. */
+
+/* Trace events for fs/ocfs2/quota_local.c. */
+DEFINE_EVENT(ocfs2__ull_uint, ocfs2_recover_local_quota_file,
+
+	TP_PROTO(unsigned long long ino, unsigned int type),
+
+	TP_ARGS(ino, type)
+);
+
+DEFINE_EVENT(ocfs2__int, ocfs2_finish_quota_recovery,
+
+	TP_PROTO(int slot_num),
+
+	TP_ARGS(slot_num)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull_uint, olq_set_dquot,
+
+	TP_PROTO(unsigned long long space,
+		 unsigned long long inode, unsigned int id),
+
+	TP_ARGS(space, inode, id)
+);
+/* End of trace events for fs/ocfs2/quota_local.c. */
 #endif /* _TRACE_OCFS2_H */
 
 /* This part must be outside protection */
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 88ec451..dc8007f 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -8,7 +8,6 @@
 #include <linux/quotaops.h>
 #include <linux/module.h>
 
-#define MLOG_MASK_PREFIX ML_QUOTA
 #include <cluster/masklog.h>
 
 #include "ocfs2_fs.h"
@@ -23,6 +22,7 @@
 #include "quota.h"
 #include "uptodate.h"
 #include "super.h"
+#include "ocfs2_trace.h"
 
 /* Number of local quota structures per block */
 static inline unsigned int ol_quota_entries_per_block(struct super_block *sb)
@@ -475,7 +475,7 @@ static int ocfs2_recover_local_quota_file(struct inode *lqinode,
 	struct ocfs2_recovery_chunk *rchunk, *next;
 	qsize_t spacechange, inodechange;
 
-	mlog(0, "ino=%lu type=%u", (unsigned long)lqinode->i_ino, type);
+	trace_ocfs2_recover_local_quota_file((unsigned long)lqinode->i_ino, type);
 
 	list_for_each_entry_safe(rchunk, next, &(rec->r_list[type]), rc_list) {
 		chunk = rchunk->rc_chunk;
@@ -601,7 +601,7 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
 	for (type = 0; type < MAXQUOTAS; type++) {
 		if (list_empty(&(rec->r_list[type])))
 			continue;
-		mlog(0, "Recovering quota in slot %d\n", slot_num);
+		trace_ocfs2_finish_quota_recovery(slot_num);
 		lqinode = ocfs2_get_system_file_inode(osb, ino[type], slot_num);
 		if (!lqinode) {
 			status = -ENOENT;
@@ -883,9 +883,10 @@ static void olq_set_dquot(struct buffer_head *bh, void *private)
 	dqblk->dqb_inodemod = cpu_to_le64(od->dq_dquot.dq_dqb.dqb_curinodes -
 					  od->dq_originodes);
 	spin_unlock(&dq_data_lock);
-	mlog(0, "Writing local dquot %u space %lld inodes %lld\n",
-	     od->dq_dquot.dq_id, (long long)le64_to_cpu(dqblk->dqb_spacemod),
-	     (long long)le64_to_cpu(dqblk->dqb_inodemod));
+	trace_olq_set_dquot(
+		(unsigned long long)le64_to_cpu(dqblk->dqb_spacemod),
+		(unsigned long long)le64_to_cpu(dqblk->dqb_inodemod),
+		od->dq_dquot.dq_id);
 }
 
 /* Write dquot to local quota file */
-- 
1.7.0.4
