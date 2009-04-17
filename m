From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 17 Apr 2009 13:37:39 -0700
Subject: [Ocfs2-devel] [PATCH 26/26] ocfs2: recover orphans in offline slots
	during recovery and mount
In-Reply-To: <1240000659-6201-1-git-send-email-sunil.mushran@oracle.com>
References: <1240000659-6201-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1240000659-6201-27-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Srinivas Eeda <srinivas.eeda@oracle.com>

Mainline commit 9140db04ef185f934acf2b1b15b3dd5e6a6bfc22

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
 fs/ocfs2/journal.c |  141 +++++++++++++++++++++++++++++++++++++++++++++-------
 fs/ocfs2/journal.h |    2 +
 fs/ocfs2/ocfs2.h   |    2 +
 fs/ocfs2/super.c   |    6 ++
 4 files changed, 133 insertions(+), 18 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 03fb378..484ccb5 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -63,6 +63,102 @@ static int ocfs2_trylock_journal(struct ocfs2_super *osb,
 static int ocfs2_recover_orphans(struct ocfs2_super *osb,
 				 int slot);
 static int ocfs2_commit_thread(void *arg);
+static void ocfs2_queue_recovery_completion(struct ocfs2_journal *journal,
+					    int slot_num,
+					    struct ocfs2_dinode *la_dinode,
+					    struct ocfs2_dinode *tl_dinode);
+
+/*
+ * This replay_map is to track online/offline slots, so we could recover
+ * offline slots during recovery and mount
+ */
+
+enum ocfs2_replay_state {
+	REPLAY_UNNEEDED = 0,	/* Replay is not needed, so ignore this map */
+	REPLAY_NEEDED, 		/* Replay slots marked in rm_replay_slots */
+	REPLAY_DONE 		/* Replay was already queued */
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
+	/* If we've already queued the replay, we don't have any more to do */
+	if (osb->replay_map->rm_state == REPLAY_DONE)
+		return;
+
+	osb->replay_map->rm_state = state;
+}
+
+int ocfs2_compute_replay_slots(struct ocfs2_super *osb)
+{
+	struct ocfs2_replay_map *replay_map;
+	struct ocfs2_slot_info *si = osb->slot_info;
+	int i;
+
+	/* If replay map is already set, we don't do it again */
+	if (osb->replay_map)
+		return 0;
+
+	replay_map = kzalloc(sizeof(struct ocfs2_replay_map) +
+			     (osb->max_slots * sizeof(char)), GFP_KERNEL);
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
+		if (si->si_global_node_nums[i] == OCFS2_INVALID_SLOT)
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
+							NULL);
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
 
 static int ocfs2_commit_cache(struct ocfs2_super *osb)
 {
@@ -840,23 +936,24 @@ static void ocfs2_queue_recovery_completion(struct ocfs2_journal *journal,
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
-						NULL);
-		ocfs2_schedule_truncate_log_flush(osb, 0);
-
-		osb->local_alloc_copy = NULL;
-		osb->dirty = 0;
-	}
+	/* No need to queue up our truncate_log as regular cleanup will catch
+	 * that. */
+	ocfs2_queue_recovery_completion(journal, osb->slot_num,
+					osb->local_alloc_copy, NULL);
+	ocfs2_schedule_truncate_log_flush(osb, 0);
+
+	osb->local_alloc_copy = NULL;
+	osb->dirty = 0;
+
+	/* queue to recover orphan slots for all offline slots */
+	ocfs2_replay_map_set_state(osb, REPLAY_NEEDED);
+	ocfs2_queue_replay_slots(osb);
+	ocfs2_free_replay_slots(osb);
 }
 
 static int __ocfs2_recovery_thread(void *arg)
@@ -878,6 +975,13 @@ restart:
 		goto bail;
 	}
 
+	status = ocfs2_compute_replay_slots(osb);
+	if (status < 0)
+		mlog_errno(status);
+
+	/* queue recovery for our own slot */
+	ocfs2_queue_recovery_completion(osb->journal, osb->slot_num, NULL, NULL);
+
 	while(!ocfs2_node_map_is_empty(osb, &osb->recovery_map)) {
 		node_num = ocfs2_node_map_first_set_bit(osb,
 							&osb->recovery_map);
@@ -907,11 +1011,8 @@ restart:
 
 	ocfs2_super_unlock(osb, 1);
 
-	/* We always run recovery on our own orphan dir - the dead
-	 * node(s) may have disallowd a previos inode delete. Re-processing
-	 * is therefore required. */
-	ocfs2_queue_recovery_completion(osb->journal, osb->slot_num, NULL,
-					NULL);
+	/* queue recovery for offline slots */
+	ocfs2_queue_replay_slots(osb);
 
 bail:
 	mutex_lock(&osb->recovery_lock);
@@ -921,6 +1022,7 @@ bail:
 		goto restart;
 	}
 
+	ocfs2_free_replay_slots(osb);
 	osb->recovery_thread_task = NULL;
 	mb(); /* sync with ocfs2_recovery_thread_running */
 	wake_up(&osb->recovery_event);
@@ -1069,6 +1171,9 @@ static int ocfs2_replay_journal(struct ocfs2_super *osb,
 		goto done;
 	}
 
+	/* we need to run complete recovery for offline orphan slots */
+	ocfs2_replay_map_set_state(osb, REPLAY_NEEDED);
+
 	mlog(ML_NOTICE, "Recovering node %d from slot %d on device (%u,%u)\n",
 	     node_num, slot_num,
 	     MAJOR(osb->sb->s_dev), MINOR(osb->sb->s_dev));
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index dc27100..df8e9de 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -135,6 +135,8 @@ static inline void ocfs2_inode_set_new(struct ocfs2_super *osb,
 /* Exported only for the journal struct init code in super.c. Do not call. */
 void ocfs2_complete_recovery(kapi_work_struct_t *work);
 
+int ocfs2_compute_replay_slots(struct ocfs2_super *osb);
+
 /*
  *  Journal Control:
  *  Initialize, Load, Shutdown, Wipe a journal.
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 7c79c84..e84185d 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -198,6 +198,7 @@ enum ocfs2_mount_options
 #define OCFS2_DEFAULT_ATIME_QUANTUM	60
 
 struct ocfs2_journal;
+struct ocfs2_replay_map;
 struct ocfs2_super
 {
 	struct task_struct *commit_task;
@@ -249,6 +250,7 @@ struct ocfs2_super
 
 	atomic_t vol_state;
 	struct mutex recovery_lock;
+	struct ocfs2_replay_map *replay_map;
 	struct task_struct *recovery_thread_task;
 	int disable_recovery;
 	wait_queue_head_t checkpoint_event;
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index fc806d6..a421e7d 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1962,6 +1962,12 @@ static int ocfs2_check_volume(struct ocfs2_super *osb)
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
1.5.6.3
