From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Wed, 6 Jul 2011 12:38:29 +0800
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2: scan orphan for only our slot and
	those dead
Message-ID: <201107060539.p665dRHO020413@acsmt356.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Let's scan and recovery orphan dir for only the slot for local and those dead.
For the slot for local, always do it at each scan time. For those dead, we do it
when we "should".

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/journal.c |   32 ++++++++++++++++++++++++++++----
 1 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 295d564..7994823 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1819,7 +1819,7 @@ static inline unsigned long ocfs2_orphan_scan_timeout(void)
 void ocfs2_queue_orphan_scan(struct ocfs2_super *osb)
 {
 	struct ocfs2_orphan_scan *os;
-	int status, i;
+	int status, i, node_num;
 	u32 seqno = 0;
 
 	os = &osb->osb_orphan_scan;
@@ -1841,14 +1841,38 @@ void ocfs2_queue_orphan_scan(struct ocfs2_super *osb)
 	if (atomic_read(&os->os_state) == ORPHAN_SCAN_INACTIVE)
 		goto unlock;
 
+	/*
+	 * For live nodes, one node only scan and recover this slot where
+	 * the node resides. And always do it at each scan time. For those dead
+	 * (not mounted), we do it when we "should". This helps performance.
+	 */
+
+	for (i = 0; i < osb->max_slots; i++) {
+		spin_lock(&osb->osb_lock);
+		status = ocfs2_slot_to_node_num_locked(osb, i, &node_num);
+		spin_unlock(&osb->osb_lock);
+		if (status != -ENOENT && node_num == osb->node_num) {
+			ocfs2_queue_recovery_completion(osb->journal, i, NULL,
+					NULL, NULL);
+			break;
+		}
+	}
+
 	if (os->os_seqno != seqno) {
 		os->os_seqno = seqno;
 		goto unlock;
 	}
 
-	for (i = 0; i < osb->max_slots; i++)
-		ocfs2_queue_recovery_completion(osb->journal, i, NULL, NULL,
-						NULL);
+	ocfs2_refresh_slot_info(osb);
+	for (i = 0; i < osb->max_slots; i++) {
+		spin_lock(&osb->osb_lock);
+		status = ocfs2_slot_to_node_num_locked(osb, i, &node_num);
+		spin_unlock(&osb->osb_lock);
+		if (status == -ENOENT)
+			ocfs2_queue_recovery_completion(osb->journal, i, NULL,
+					NULL, NULL);
+	}
+
 	/*
 	 * We queued a recovery on orphan slots, increment the sequence
 	 * number and update LVB so other node will skip the scan for a while
-- 
1.7.5.2
