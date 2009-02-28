From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Fri, 27 Feb 2009 18:01:24 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] Patch to recover orphans from the slot
	during mount
Message-ID: <1235786484-17784-1-git-send-email-srinivas.eeda@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Currently we only queue recovery during mount if the journal is dirty.

If the last node holding orphans in other node's orphan directory dies and
is the first one to mount then it only recovers its orphan directory which
leaves the orphans in other nodes slots. Since the other nodes journals are
clean they will not queue to recover their orphan directory.

This patch queues to recover orphans when the slot is next used.

Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
---
 fs/ocfs2/journal.c |   21 ++++++++-------------
 1 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 57d7d25..71b2ea4 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1181,19 +1181,14 @@ void ocfs2_complete_mount_recovery(struct ocfs2_super *osb)
 {
 	struct ocfs2_journal *journal = osb->journal;
 
-	if (osb->dirty) {
-		/* No need to queue up our truncate_log as regular
-		 * cleanup will catch that. */
-		ocfs2_queue_recovery_completion(journal,
-						osb->slot_num,
-						osb->local_alloc_copy,
-						NULL,
-						NULL);
-		ocfs2_schedule_truncate_log_flush(osb, 0);
-
-		osb->local_alloc_copy = NULL;
-		osb->dirty = 0;
-	}
+	/* No need to queue up our truncate_log as regular cleanup will
+	 * catch that. */
+	ocfs2_queue_recovery_completion(journal, osb->slot_num,
+					osb->local_alloc_copy, NULL, NULL);
+	ocfs2_schedule_truncate_log_flush(osb, 0);
+
+	osb->local_alloc_copy = NULL;
+	osb->dirty = 0;
 }
 
 void ocfs2_complete_quota_recovery(struct ocfs2_super *osb)
-- 
1.5.6.5
