From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Fri, 27 Feb 2009 18:02:06 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] Patch to recover orphans in offline slots
	during recovery.
Message-ID: <1235786526-17868-1-git-send-email-srinivas.eeda@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In the current recovery procedure, recovering node recovers orphans from the
slot it is holding and the slots that dead nodes were holding. Other online
nodes recover orphans from their slots. But orphans in offline slots are left
un-recovered.

This patch queues recovery_completion for offline slots.

Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
---
 fs/ocfs2/journal.c |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 71b2ea4..5434eb4 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1209,8 +1209,9 @@ static int __ocfs2_recovery_thread(void *arg)
 	struct ocfs2_super *osb = arg;
 	struct ocfs2_recovery_map *rm = osb->recovery_map;
 	int *rm_quota = NULL;
-	int rm_quota_used = 0, i;
+	int rm_quota_used = 0, i, saveslots = 1;
 	struct ocfs2_quota_recovery *qrec;
+	int slot_arr[OCFS2_MAX_SLOTS];
 
 	mlog_entry_void();
 
@@ -1224,6 +1225,7 @@ static int __ocfs2_recovery_thread(void *arg)
 		status = -ENOMEM;
 		goto bail;
 	}
+
 restart:
 	status = ocfs2_super_lock(osb, 1);
 	if (status < 0) {
@@ -1231,6 +1233,13 @@ restart:
 		goto bail;
 	}
 
+	/* save slots status so we can recover offline slots */
+	if (saveslots) {
+		saveslots = 0;
+		for (i = 0; i < osb->slot_info->si_num_slots; i++)
+			slot_arr[i] = osb->slot_info->si_slots[i].sl_valid;
+	}
+
 	spin_lock(&osb->osb_lock);
 	while (rm->rm_used) {
 		/* It's always safe to remove entry zero, as we won't
@@ -1296,11 +1305,13 @@ skip_recovery:
 
 	ocfs2_super_unlock(osb, 1);
 
-	/* We always run recovery on our own orphan dir - the dead
-	 * node(s) may have disallowd a previos inode delete. Re-processing
+	/* We always run recovery on our own and offline orphan slots - the dead
+	 * node(s) may have disallowed a previous inode delete. Re-processing
 	 * is therefore required. */
-	ocfs2_queue_recovery_completion(osb->journal, osb->slot_num, NULL,
-					NULL, NULL);
+	for (i = 0; i < osb->slot_info->si_num_slots; i++)
+		if ((!slot_arr[i]) || osb->slot_num == i)
+			ocfs2_queue_recovery_completion(osb->journal, i,
+							NULL, NULL, NULL);
 
 bail:
 	mutex_lock(&osb->recovery_lock);
-- 
1.5.6.5
