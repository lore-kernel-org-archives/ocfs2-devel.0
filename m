From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Thu,  5 Mar 2009 01:53:33 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] Patch to recover orphans in offline slots
	during recovery and mount
Message-ID: <1236246813-16263-1-git-send-email-srinivas.eeda@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

During recovery, a node recovers orphans in it's slot and the dead node(s). But
if the dead nodes were holding orphans in offline slots, they will be left
unrecovered.

If the dead node is the last one to die and is holding orphans in other slots
and is the first one to mount, then it only recovers it's own slot, which
leaves orphans in offline slots.

This patch queues complete_recovery to clean orphans for all offline slots
during mount and node recovery.

Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
---
 fs/ocfs2/journal.c |  136 +++++++++++++++++++++++++++++++++++++++++++++-------
 fs/ocfs2/journal.h |    1 +
 fs/ocfs2/ocfs2.h   |    2 +
 fs/ocfs2/super.c   |    6 ++
 4 files changed, 127 insertions(+), 18 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 57d7d25..e1b11d6 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -65,6 +65,11 @@ static int ocfs2_trylock_journal(struct ocfs2_super *osb,
 static int ocfs2_recover_orphans(struct ocfs2_super *osb,
 				 int slot);
 static int ocfs2_commit_thread(void *arg);
+static void ocfs2_queue_recovery_completion(struct ocfs2_journal *journal,
+					    int slot_num,
+					    struct ocfs2_dinode *la_dinode,
+					    struct ocfs2_dinode *tl_dinode,
+					    struct ocfs2_quota_recovery *qrec);
 
 static inline int ocfs2_wait_on_mount(struct ocfs2_super *osb)
 {
@@ -77,6 +82,92 @@ static inline int ocfs2_wait_on_quotas(struct ocfs2_super *osb)
 }
 
 
+/*
+ * This replay_map is to track online/offline slots, so we could recover
+ * offline slots during recovery and mount
+ */
+
+enum ocfs2_replay_state {
+	REPLAY_UNNEEDED,
+	REPLAY_NEEDED,
+	REPLAY_DONE
+};
+
+struct ocfs2_replay_map {
+	unsigned int rm_slots;
+	enum ocfs2_replay_state rm_state;
+	unsigned char rm_replay_slots[0];
+};
+
+void ocfs2_replay_map_set_state(struct ocfs2_super *osb, int state)
+{
+	if (!osb->replay_map)
+		return;
+
+	osb->replay_map->rm_state = state;
+}
+
+int ocfs2_compute_replay_slots(struct ocfs2_super *osb)
+{
+	struct ocfs2_replay_map *replay_map;
+	int i, node_num;
+
+	replay_map = osb->replay_map;
+
+	if (!replay_map)
+		replay_map = kzalloc(sizeof(struct ocfs2_replay_map) +
+				     (osb->max_slots * sizeof(char)),
+				     GFP_KERNEL);
+
+	if (!replay_map) {
+		mlog_errno(-ENOMEM);
+		return -ENOMEM;
+	}
+
+	spin_lock(&osb->osb_lock);
+
+	replay_map->rm_slots = osb->max_slots;
+	replay_map->rm_state = REPLAY_UNNEEDED;
+
+	/* set rm_replay_slots for offline slot(s) */
+	for (i = 0; i < replay_map->rm_slots; i++) {
+		if (ocfs2_slot_to_node_num_locked(osb, i, &node_num) == -ENOENT)
+			replay_map->rm_replay_slots[i] = 1;
+	}
+
+	osb->replay_map = replay_map;
+	spin_unlock(&osb->osb_lock);
+	return 0;
+}
+
+void ocfs2_queue_replay_slots(struct ocfs2_super *osb)
+{
+	struct ocfs2_replay_map *replay_map = osb->replay_map;
+	int i;
+
+	if (!replay_map)
+		return;
+
+	if (replay_map->rm_state != REPLAY_NEEDED)
+		return;
+
+	for (i = 0; i < replay_map->rm_slots; i++)
+		if (replay_map->rm_replay_slots[i])
+			ocfs2_queue_recovery_completion(osb->journal, i, NULL,
+							NULL, NULL);
+	replay_map->rm_state = REPLAY_DONE;
+}
+
+void ocfs2_free_replay_slots(struct ocfs2_super *osb)
+{
+	struct ocfs2_replay_map *replay_map = osb->replay_map;
+
+	if (!osb->replay_map)
+		return;
+
+	kfree(replay_map);
+	osb->replay_map = NULL;
+}
 
 /*
  * The recovery_list is a simple linked list of node numbers to recover.
@@ -1176,24 +1267,24 @@ static void ocfs2_queue_recovery_completion(struct ocfs2_journal *journal,
 }
 
 /* Called by the mount code to queue recovery the last part of
- * recovery for it's own slot. */
+ * recovery for it's own and offline slot(s). */
 void ocfs2_complete_mount_recovery(struct ocfs2_super *osb)
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
+	/* No need to queue up our truncate_log as regular cleanup will catch
+	 * that */
+	ocfs2_queue_recovery_completion(journal, osb->slot_num,
+					osb->local_alloc_copy, NULL, NULL);
+	ocfs2_schedule_truncate_log_flush(osb, 0);
 
-		osb->local_alloc_copy = NULL;
-		osb->dirty = 0;
-	}
+	osb->local_alloc_copy = NULL;
+	osb->dirty = 0;
+
+	/* queue to recover orphan slots for all offline slots */
+	ocfs2_replay_map_set_state(osb, REPLAY_NEEDED);
+	ocfs2_queue_replay_slots(osb);
+	ocfs2_free_replay_slots(osb);
 }
 
 void ocfs2_complete_quota_recovery(struct ocfs2_super *osb)
@@ -1236,6 +1327,14 @@ restart:
 		goto bail;
 	}
 
+	status = ocfs2_compute_replay_slots(osb);
+	if (status < 0)
+		mlog_errno(status);
+
+	/* queue recovery for our own slot */
+	ocfs2_queue_recovery_completion(osb->journal, osb->slot_num, NULL,
+					NULL, NULL);
+
 	spin_lock(&osb->osb_lock);
 	while (rm->rm_used) {
 		/* It's always safe to remove entry zero, as we won't
@@ -1301,11 +1400,8 @@ skip_recovery:
 
 	ocfs2_super_unlock(osb, 1);
 
-	/* We always run recovery on our own orphan dir - the dead
-	 * node(s) may have disallowd a previos inode delete. Re-processing
-	 * is therefore required. */
-	ocfs2_queue_recovery_completion(osb->journal, osb->slot_num, NULL,
-					NULL, NULL);
+	/* queue recovery for offline slots */
+	ocfs2_queue_replay_slots(osb);
 
 bail:
 	mutex_lock(&osb->recovery_lock);
@@ -1314,6 +1410,7 @@ bail:
 		goto restart;
 	}
 
+	ocfs2_free_replay_slots(osb);
 	osb->recovery_thread_task = NULL;
 	mb(); /* sync with ocfs2_recovery_thread_running */
 	wake_up(&osb->recovery_event);
@@ -1465,6 +1562,9 @@ static int ocfs2_replay_journal(struct ocfs2_super *osb,
 		goto done;
 	}
 
+	/* we need to run complete recovery for offline orphan slots */
+	ocfs2_replay_map_set_state(osb, REPLAY_NEEDED);
+
 	mlog(ML_NOTICE, "Recovering node %d from slot %d on device (%u,%u)\n",
 	     node_num, slot_num,
 	     MAJOR(osb->sb->s_dev), MINOR(osb->sb->s_dev));
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 172850a..6909ed9 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -139,6 +139,7 @@ void ocfs2_wait_for_recovery(struct ocfs2_super *osb);
 int ocfs2_recovery_init(struct ocfs2_super *osb);
 void ocfs2_recovery_exit(struct ocfs2_super *osb);
 
+int ocfs2_compute_replay_slots(struct ocfs2_super *osb);
 /*
  *  Journal Control:
  *  Initialize, Load, Shutdown, Wipe a journal.
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 0773841..9cbec07 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -209,6 +209,7 @@ enum ocfs2_mount_options
 struct ocfs2_journal;
 struct ocfs2_slot_info;
 struct ocfs2_recovery_map;
+struct ocfs2_replay_map;
 struct ocfs2_quota_recovery;
 struct ocfs2_dentry_lock;
 struct ocfs2_super
@@ -264,6 +265,7 @@ struct ocfs2_super
 	atomic_t vol_state;
 	struct mutex recovery_lock;
 	struct ocfs2_recovery_map *recovery_map;
+	struct ocfs2_replay_map *replay_map;
 	struct task_struct *recovery_thread_task;
 	int disable_recovery;
 	wait_queue_head_t checkpoint_event;
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index b1cb38f..fa459d6 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2122,6 +2122,12 @@ static int ocfs2_check_volume(struct ocfs2_super *osb)
 	 * lock, and it's marked as dirty, set the bit in the recover
 	 * map and launch a recovery thread for it. */
 	status = ocfs2_mark_dead_nodes(osb);
+	if (status < 0) {
+		mlog_errno(status);
+		goto finally;
+	}
+
+	status = ocfs2_compute_replay_slots(osb);
 	if (status < 0)
 		mlog_errno(status);
 
-- 
1.5.6.5
