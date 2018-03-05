From: Guozhonghua <guozhonghua@h3c.com>
Date: Mon, 5 Mar 2018 01:42:40 +0000
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: Without quota support,
 try to avoid calling quota recovery.
Message-ID: <71604351584F6A4EBAE558C676F37CA401071AC9FB@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

During one dead node's recovery by other node, quota recovery work will be queued.
We should avoid calling quota while it is not supported, so reading the quota flags.

Signed-off-by: guozhonghua <guozhonghua@h3c.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/journal.c |   51 ++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 17 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index e5dcea6..5f1a054 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1378,15 +1378,23 @@ static int __ocfs2_recovery_thread(void *arg)
 	int rm_quota_used = 0, i;
 	struct ocfs2_quota_recovery *qrec;
 
+	/* Whether the quota supported. */
+	int quota_enabled = OCFS2_HAS_RO_COMPAT_FEATURE(osb->sb,
+			OCFS2_FEATURE_RO_COMPAT_USRQUOTA)
+		|| OCFS2_HAS_RO_COMPAT_FEATURE(osb->sb,
+			OCFS2_FEATURE_RO_COMPAT_GRPQUOTA);
+
 	status = ocfs2_wait_on_mount(osb);
 	if (status < 0) {
 		goto bail;
 	}
 
-	rm_quota = kzalloc(osb->max_slots * sizeof(int), GFP_NOFS);
-	if (!rm_quota) {
-		status = -ENOMEM;
-		goto bail;
+	if (quota_enabled) {
+		rm_quota = kzalloc(osb->max_slots * sizeof(int), GFP_NOFS);
+		if (!rm_quota) {
+			status = -ENOMEM;
+			goto bail;
+		}
 	}
 restart:
 	status = ocfs2_super_lock(osb, 1);
@@ -1422,9 +1430,14 @@ static int __ocfs2_recovery_thread(void *arg)
 		 * then quota usage would be out of sync until some node takes
 		 * the slot. So we remember which nodes need quota recovery
 		 * and when everything else is done, we recover quotas. */
-		for (i = 0; i < rm_quota_used && rm_quota[i] != slot_num; i++);
-		if (i == rm_quota_used)
-			rm_quota[rm_quota_used++] = slot_num;
+		if (quota_enabled) {
+			for (i = 0; i < rm_quota_used
+					&& rm_quota[i] != slot_num; i++)
+				;
+
+			if (i == rm_quota_used)
+				rm_quota[rm_quota_used++] = slot_num;
+		}
 
 		status = ocfs2_recover_node(osb, node_num, slot_num);
 skip_recovery:
@@ -1452,16 +1465,19 @@ static int __ocfs2_recovery_thread(void *arg)
 	/* Now it is right time to recover quotas... We have to do this under
 	 * superblock lock so that no one can start using the slot (and crash)
 	 * before we recover it */
-	for (i = 0; i < rm_quota_used; i++) {
-		qrec = ocfs2_begin_quota_recovery(osb, rm_quota[i]);
-		if (IS_ERR(qrec)) {
-			status = PTR_ERR(qrec);
-			mlog_errno(status);
-			continue;
+	if (quota_enabled) {
+		for (i = 0; i < rm_quota_used; i++) {
+			qrec = ocfs2_begin_quota_recovery(osb, rm_quota[i]);
+			if (IS_ERR(qrec)) {
+				status = PTR_ERR(qrec);
+				mlog_errno(status);
+				continue;
+			}
+			ocfs2_queue_recovery_completion(osb->journal,
+					rm_quota[i],
+					NULL, NULL, qrec,
+					ORPHAN_NEED_TRUNCATE);
 		}
-		ocfs2_queue_recovery_completion(osb->journal, rm_quota[i],
-						NULL, NULL, qrec,
-						ORPHAN_NEED_TRUNCATE);
 	}
 
 	ocfs2_super_unlock(osb, 1);
@@ -1483,7 +1499,8 @@ static int __ocfs2_recovery_thread(void *arg)
 
 	mutex_unlock(&osb->recovery_lock);
 
-	kfree(rm_quota);
+	if (quota_enabled)
+		kfree(rm_quota);
 
 	/* no one is callint kthread_stop() for us so the kthread() api
 	 * requires that we call do_exit().  And it isn't exported, but
-- 
1.7.9.5
