From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Thu, 19 Feb 2009 14:45:08 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] Patch to clean orphans in all offline
	slots during recovery.
In-Reply-To: <1235083508-11408-1-git-send-email-srinivas.eeda@oracle.com>
References: <1235083508-11408-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <1235083508-11408-2-git-send-email-srinivas.eeda@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In the current recovery procedure, a node recovers orphans from the slot it
is holding and the nodes being recovered. If a dead node was holding an orphan
in another offline node's slot then it may be left around for a while.

This patch clears orphans in all offline slots. This patch does two things:
a) Recover orphans during mount of the slot that it is using.
b) Recover orphans in all offline slots during recovery.

Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
---
 fs/ocfs2/journal.c |   44 +++++++++++++++++++++++++++-----------------
 1 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 03fb378..3d55892 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -845,24 +845,22 @@ void ocfs2_complete_mount_recovery(struct ocfs2_super *osb)
 {
 	struct ocfs2_journal *journal = osb->journal;
 
-	if (osb->dirty) {
-		/* No need to queue up our truncate_log as regular
-		 * cleanup will catch that. */
-		ocfs2_queue_recovery_completion(journal,
-						osb->slot_num,
-						osb->local_alloc_copy,
-						NULL);
-		ocfs2_schedule_truncate_log_flush(osb, 0);
-
-		osb->local_alloc_copy = NULL;
-		osb->dirty = 0;
-	}
+	/* No need to queue up our truncate_log as regular cleanup will 
+	 * catch that. */
+	ocfs2_queue_recovery_completion(journal, osb->slot_num,
+					osb->local_alloc_copy, NULL);
+	ocfs2_schedule_truncate_log_flush(osb, 0);
+
+	osb->local_alloc_copy = NULL;
+	osb->dirty = 0;
 }
 
 static int __ocfs2_recovery_thread(void *arg)
 {
 	int status, node_num;
 	struct ocfs2_super *osb = arg;
+	int slot_arr[OCFS2_MAX_SLOTS];
+	int i, saveslots = 1;
 
 	mlog_entry_void();
 
@@ -878,6 +876,16 @@ restart:
 		goto bail;
 	}
 
+	/* 
+	 * copy slots array so we can recovery offline slots that were not
+	 * recovered
+	 */
+	if (saveslots) {
+		saveslots = 0;
+		for (i = 0; i < osb->slot_info->si_num_slots; i++)
+			slot_arr[i] = osb->slot_info->si_global_node_nums[i];
+	}
+
 	while(!ocfs2_node_map_is_empty(osb, &osb->recovery_map)) {
 		node_num = ocfs2_node_map_first_set_bit(osb,
 							&osb->recovery_map);
@@ -905,14 +913,16 @@ restart:
 	if (status < 0)
 		mlog_errno(status);
 
-	ocfs2_super_unlock(osb, 1);
-
-	/* We always run recovery on our own orphan dir - the dead
-	 * node(s) may have disallowd a previos inode delete. Re-processing
+	/* We always run recovery on our own and offline orphan dirs - the dead
+	 * node(s) may have disallowed a previous inode delete. Re-processing
 	 * is therefore required. */
-	ocfs2_queue_recovery_completion(osb->journal, osb->slot_num, NULL,
+	for (i = 0; i < osb->slot_info->si_num_slots; i++)
+		if (slot_arr[i] == OCFS2_INVALID_SLOT || osb->slot_num == i)
+			ocfs2_queue_recovery_completion(osb->journal, i, NULL,
 					NULL);
 
+	ocfs2_super_unlock(osb, 1);
+
 bail:
 	mutex_lock(&osb->recovery_lock);
 	if (!status &&
-- 
1.5.6.5
