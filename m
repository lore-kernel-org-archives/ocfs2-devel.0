From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Tue, 20 Sep 2011 10:11:43 -0500
Subject: [Ocfs2-devel] [PATCH 1/2] Use ocfs2_recovery_node instead of
	recovery map
Message-ID: <CAJtY7HUtgwwvtVgvH-BXw-BbZe-zOCiw1OVHdn9D2Jw22BA9yA@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The ocfs2_recovery_node structure replaces the ocfs2_recovery_map.
For each node to be recovered, a recovery node structure is added to
s_active_reco_list. ocfs2rec kernel thread picks up the recovery node
structure from s_active_reco_list and processes it.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>
---
 fs/ocfs2/heartbeat.c |   12 +++-
 fs/ocfs2/journal.c   |  174 +++++++++++++++++++++-----------------------------
 fs/ocfs2/journal.h   |   10 ++-
 fs/ocfs2/ocfs2.h     |    4 +-
 fs/ocfs2/super.c     |   10 ++-
 5 files changed, 98 insertions(+), 112 deletions(-)

diff --git a/fs/ocfs2/heartbeat.c b/fs/ocfs2/heartbeat.c
index d8208b2..2218721 100644
--- a/fs/ocfs2/heartbeat.c
+++ b/fs/ocfs2/heartbeat.c
@@ -37,7 +37,7 @@
 #include "inode.h"
 #include "journal.h"
 #include "ocfs2_trace.h"
-
+#include "slot_map.h"
 #include "buffer_head_io.h"

 static inline void __ocfs2_node_map_set_bit(struct ocfs2_node_map *map,
@@ -63,6 +63,7 @@ void ocfs2_init_node_maps(struct ocfs2_super *osb)
 void ocfs2_do_node_down(int node_num, void *data)
 {
 	struct ocfs2_super *osb = data;
+	int slot_num;

 	BUG_ON(osb->node_num == node_num);

@@ -78,7 +79,14 @@ void ocfs2_do_node_down(int node_num, void *data)
 		return;
 	}

-	ocfs2_recovery_thread(osb, node_num);
+	slot_num = ocfs2_node_num_to_slot(osb, node_num);
+	if (slot_num == -ENOENT) {
+		mlog(ML_ERROR, "Skipping recovery on node %d because "
+		     "could not find corresponding slot.\n", node_num);
+		return;
+	}
+
+	ocfs2_recovery_thread(osb, node_num, slot_num);
 }

 static inline void __ocfs2_node_map_set_bit(struct ocfs2_node_map *map,
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 295d564..2e07c67 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -58,8 +58,7 @@ DEFINE_SPINLOCK(trans_inc_lock);
 #define ORPHAN_SCAN_SCHEDULE_TIMEOUT 300000

 static int ocfs2_force_read_journal(struct inode *inode);
-static int ocfs2_recover_node(struct ocfs2_super *osb,
-			      int node_num, int slot_num);
+static int ocfs2_recover_node(struct ocfs2_recovery_node *rn);
 static int __ocfs2_recovery_thread(void *arg);
 static int ocfs2_commit_cache(struct ocfs2_super *osb);
 static int __ocfs2_wait_on_mount(struct ocfs2_super *osb, int quota);
@@ -179,25 +178,21 @@ void ocfs2_free_replay_slots(struct ocfs2_super *osb)

 int ocfs2_recovery_init(struct ocfs2_super *osb)
 {
-	struct ocfs2_recovery_map *rm;
-
+	struct ocfs2_recovery_node *rn;
+	int i;
 	mutex_init(&osb->recovery_lock);
 	osb->disable_recovery = 0;
 	osb->recovery_thread_task = NULL;
 	init_waitqueue_head(&osb->recovery_event);
-
-	rm = kzalloc(sizeof(struct ocfs2_recovery_map) +
-		     osb->max_slots * sizeof(unsigned int),
-		     GFP_KERNEL);
-	if (!rm) {
-		mlog_errno(-ENOMEM);
-		return -ENOMEM;
+	INIT_LIST_HEAD(&osb->s_active_reco_list);
+	INIT_LIST_HEAD(&osb->s_recovery_list);
+	for (i = 0; i < osb->max_slots - 1; i++) {
+		rn = kzalloc(sizeof(struct ocfs2_recovery_node), GFP_KERNEL);
+		if (!rn)
+			return -ENOMEM;
+		rn->rn_osb = osb;
+		list_add(&rn->rn_list, &osb->s_recovery_list);
 	}
-
-	rm->rm_entries = (unsigned int *)((char *)rm +
-					  sizeof(struct ocfs2_recovery_map));
-	osb->recovery_map = rm;
-
 	return 0;
 }

@@ -212,8 +207,7 @@ static int ocfs2_recovery_thread_running(struct
ocfs2_super *osb)

 void ocfs2_recovery_exit(struct ocfs2_super *osb)
 {
-	struct ocfs2_recovery_map *rm;
-
+	struct ocfs2_recovery_node *rn, *tmp;
 	/* disable any new recovery threads and wait for any currently
 	 * running ones to exit. Do this before setting the vol_state. */
 	mutex_lock(&osb->recovery_lock);
@@ -226,75 +220,57 @@ void ocfs2_recovery_exit(struct ocfs2_super *osb)
 	 * complete. */
 	flush_workqueue(ocfs2_wq);

-	/*
-	 * Now that recovery is shut down, and the osb is about to be
-	 * freed,  the osb_lock is not taken here.
-	 */
-	rm = osb->recovery_map;
-	/* XXX: Should we bug if there are dirty entries? */
-
-	kfree(rm);
+	spin_lock(&osb->osb_lock);
+	list_for_each_entry_safe(rn, tmp, &osb->s_recovery_list, rn_list) {
+			list_del(&rn->rn_list);
+			kfree(rn);
+	}
+	spin_unlock(&osb->osb_lock);
 }

-static int __ocfs2_recovery_map_test(struct ocfs2_super *osb,
+static int __ocfs2_recovery_node_test(struct ocfs2_super *osb,
 				     unsigned int node_num)
 {
-	int i;
-	struct ocfs2_recovery_map *rm = osb->recovery_map;
+	struct ocfs2_recovery_node *rn;

 	assert_spin_locked(&osb->osb_lock);
-
-	for (i = 0; i < rm->rm_used; i++) {
-		if (rm->rm_entries[i] == node_num)
+	list_for_each_entry(rn, &osb->s_active_reco_list, rn_list) {
+		if (rn->rn_node_num == node_num)
 			return 1;
 	}
-
 	return 0;
 }

 /* Behaves like test-and-set.  Returns the previous value */
-static int ocfs2_recovery_map_set(struct ocfs2_super *osb,
-				  unsigned int node_num)
+static int ocfs2_recovery_node_set(struct ocfs2_super *osb,
+				  unsigned int node_num, unsigned int slot_num)
 {
-	struct ocfs2_recovery_map *rm = osb->recovery_map;
+	struct ocfs2_recovery_node *rn;
+	int ret = 0;

 	spin_lock(&osb->osb_lock);
-	if (__ocfs2_recovery_map_test(osb, node_num)) {
-		spin_unlock(&osb->osb_lock);
-		return 1;
+	if (unlikely(__ocfs2_recovery_node_test(osb, node_num))) {
+		ret = 1;
+		goto out;
 	}
-
-	/* XXX: Can this be exploited? Not from o2dlm... */
-	BUG_ON(rm->rm_used >= osb->max_slots);
-
-	rm->rm_entries[rm->rm_used] = node_num;
-	rm->rm_used++;
+	BUG_ON(list_empty(&osb->s_recovery_list));
+	rn = list_first_entry(&osb->s_recovery_list,
+			struct ocfs2_recovery_node, rn_list);
+	rn->rn_node_num = node_num;
+	rn->rn_slot_num = slot_num;
+	list_move(&rn->rn_list, &osb->s_active_reco_list);
+out:
 	spin_unlock(&osb->osb_lock);
-
-	return 0;
+	return ret;
 }

-static void ocfs2_recovery_map_clear(struct ocfs2_super *osb,
-				     unsigned int node_num)
+static void ocfs2_recovery_node_clear(struct ocfs2_recovery_node *rn)
 {
-	int i;
-	struct ocfs2_recovery_map *rm = osb->recovery_map;
-
+	struct ocfs2_super *osb = rn->rn_osb;
 	spin_lock(&osb->osb_lock);
-
-	for (i = 0; i < rm->rm_used; i++) {
-		if (rm->rm_entries[i] == node_num)
-			break;
-	}
-
-	if (i < rm->rm_used) {
-		/* XXX: be careful with the pointer math */
-		memmove(&(rm->rm_entries[i]), &(rm->rm_entries[i + 1]),
-			(rm->rm_used - i - 1) * sizeof(unsigned int));
-		rm->rm_used--;
-	}
-
+	list_move(&rn->rn_list, &osb->s_recovery_list);
 	spin_unlock(&osb->osb_lock);
+	kfree(rn);
 }

 static int ocfs2_commit_cache(struct ocfs2_super *osb)
@@ -1057,10 +1033,9 @@ bail:
 static int ocfs2_recovery_completed(struct ocfs2_super *osb)
 {
 	int empty;
-	struct ocfs2_recovery_map *rm = osb->recovery_map;

 	spin_lock(&osb->osb_lock);
-	empty = (rm->rm_used == 0);
+	empty = list_empty(&osb->s_active_reco_list);
 	spin_unlock(&osb->osb_lock);

 	return empty;
@@ -1292,12 +1267,12 @@ void ocfs2_complete_quota_recovery(struct
ocfs2_super *osb)

 static int __ocfs2_recovery_thread(void *arg)
 {
-	int status, node_num, slot_num;
+	int status;
 	struct ocfs2_super *osb = arg;
-	struct ocfs2_recovery_map *rm = osb->recovery_map;
 	int *rm_quota = NULL;
 	int rm_quota_used = 0, i;
 	struct ocfs2_quota_recovery *qrec;
+	struct ocfs2_recovery_node *rn;

 	status = ocfs2_wait_on_mount(osb);
 	if (status < 0) {
@@ -1325,17 +1300,10 @@ restart:
 					NULL, NULL);

 	spin_lock(&osb->osb_lock);
-	while (rm->rm_used) {
-		/* It's always safe to remove entry zero, as we won't
-		 * clear it until ocfs2_recover_node() has succeeded. */
-		node_num = rm->rm_entries[0];
+	list_for_each_entry(rn, &osb->s_active_reco_list, rn_list) {
 		spin_unlock(&osb->osb_lock);
-		slot_num = ocfs2_node_num_to_slot(osb, node_num);
-		trace_ocfs2_recovery_thread_node(node_num, slot_num);
-		if (slot_num == -ENOENT) {
-			status = 0;
-			goto skip_recovery;
-		}
+		trace_ocfs2_recovery_thread_node(rn->rn_node_num,
+				rn->rn_slot_num);

 		/* It is a bit subtle with quota recovery. We cannot do it
 		 * immediately because we have to obtain cluster locks from
@@ -1343,18 +1311,18 @@ restart:
 		 * then quota usage would be out of sync until some node takes
 		 * the slot. So we remember which nodes need quota recovery
 		 * and when everything else is done, we recover quotas. */
-		for (i = 0; i < rm_quota_used && rm_quota[i] != slot_num; i++);
+		for (i = 0; i < rm_quota_used && rm_quota[i] != rn->rn_slot_num;
+				i++);
 		if (i == rm_quota_used)
-			rm_quota[rm_quota_used++] = slot_num;
+			rm_quota[rm_quota_used++] = rn->rn_slot_num;

-		status = ocfs2_recover_node(osb, node_num, slot_num);
-skip_recovery:
+		status = ocfs2_recover_node(rn);
 		if (!status) {
-			ocfs2_recovery_map_clear(osb, node_num);
+			ocfs2_recovery_node_clear(rn);
 		} else {
 			mlog(ML_ERROR,
 			     "Error %d recovering node %d on device (%u,%u)!\n",
-			     status, node_num,
+			     status, rn->rn_node_num,
 			     MAJOR(osb->sb->s_dev), MINOR(osb->sb->s_dev));
 			mlog(ML_ERROR, "Volume requires unmount.\n");
 		}
@@ -1413,14 +1381,14 @@ bail:
 	return status;
 }

-void ocfs2_recovery_thread(struct ocfs2_super *osb, int node_num)
+void ocfs2_recovery_thread(struct ocfs2_super *osb, int node_num, int slot_num)
 {
 	mutex_lock(&osb->recovery_lock);

 	trace_ocfs2_recovery_thread(node_num, osb->node_num,
 		osb->disable_recovery, osb->recovery_thread_task,
 		osb->disable_recovery ?
-		-1 : ocfs2_recovery_map_set(osb, node_num));
+		-1 : ocfs2_recovery_node_set(osb, node_num, slot_num));

 	if (osb->disable_recovery)
 		goto out;
@@ -1626,23 +1594,26 @@ done:
  * second part of a nodes recovery process (local alloc recovery) is
  * far less concerning.
  */
-static int ocfs2_recover_node(struct ocfs2_super *osb,
-			      int node_num, int slot_num)
+static int ocfs2_recover_node(struct ocfs2_recovery_node *rn)
 {
 	int status = 0;
 	struct ocfs2_dinode *la_copy = NULL;
 	struct ocfs2_dinode *tl_copy = NULL;
+	struct ocfs2_super *osb = rn->rn_osb;

-	trace_ocfs2_recover_node(node_num, slot_num, osb->node_num);
+	trace_ocfs2_recover_node(rn->rn_node_num, rn->rn_slot_num,
+			osb->node_num);

 	/* Should not ever be called to recover ourselves -- in that
 	 * case we should've called ocfs2_journal_load instead. */
-	BUG_ON(osb->node_num == node_num);
+	BUG_ON(osb->node_num == rn->rn_node_num);

-	status = ocfs2_replay_journal(osb, node_num, slot_num);
+	status = ocfs2_replay_journal(osb, rn->rn_node_num,
+			rn->rn_slot_num);
 	if (status < 0) {
 		if (status == -EBUSY) {
-			trace_ocfs2_recover_node_skip(slot_num, node_num);
+			trace_ocfs2_recover_node_skip(rn->rn_slot_num,
+					rn->rn_node_num);
 			status = 0;
 			goto done;
 		}
@@ -1651,7 +1622,8 @@ static int ocfs2_recover_node(struct ocfs2_super *osb,
 	}

 	/* Stamp a clean local alloc file AFTER recovering the journal... */
-	status = ocfs2_begin_local_alloc_recovery(osb, slot_num, &la_copy);
+	status = ocfs2_begin_local_alloc_recovery(osb, rn->rn_slot_num,
+			&la_copy);
 	if (status < 0) {
 		mlog_errno(status);
 		goto done;
@@ -1660,23 +1632,23 @@ static int ocfs2_recover_node(struct ocfs2_super *osb,
 	/* An error from begin_truncate_log_recovery is not
 	 * serious enough to warrant halting the rest of
 	 * recovery. */
-	status = ocfs2_begin_truncate_log_recovery(osb, slot_num, &tl_copy);
+	status = ocfs2_begin_truncate_log_recovery(osb,
+			rn->rn_slot_num, &tl_copy);
 	if (status < 0)
 		mlog_errno(status);

 	/* Likewise, this would be a strange but ultimately not so
 	 * harmful place to get an error... */
-	status = ocfs2_clear_slot(osb, slot_num);
+	status = ocfs2_clear_slot(osb, rn->rn_slot_num);
 	if (status < 0)
 		mlog_errno(status);

 	/* This will kfree the memory pointed to by la_copy and tl_copy */
-	ocfs2_queue_recovery_completion(osb->journal, slot_num, la_copy,
-					tl_copy, NULL);
+	ocfs2_queue_recovery_completion(osb->journal, rn->rn_slot_num,
+				la_copy, tl_copy, NULL);

 	status = 0;
 done:
-
 	return status;
 }

@@ -1763,7 +1735,7 @@ int ocfs2_mark_dead_nodes(struct ocfs2_super *osb)
 			continue;
 		}

-		if (__ocfs2_recovery_map_test(osb, node_num)) {
+		if (__ocfs2_recovery_node_test(osb, node_num)) {
 			spin_unlock(&osb->osb_lock);
 			continue;
 		}
@@ -1777,7 +1749,7 @@ int ocfs2_mark_dead_nodes(struct ocfs2_super *osb)
 			/* Since we're called from mount, we know that
 			 * the recovery thread can't race us on
 			 * setting / checking the recovery bits. */
-			ocfs2_recovery_thread(osb, node_num);
+			ocfs2_recovery_thread(osb, node_num, i);
 		} else if ((status < 0) && (status != -EAGAIN)) {
 			mlog_errno(status);
 			goto bail;
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 68cf2f6..4447964 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -43,9 +43,11 @@ struct ocfs2_dinode;
  * It is protected by the recovery_lock.
  */

-struct ocfs2_recovery_map {
-	unsigned int rm_used;
-	unsigned int *rm_entries;
+struct ocfs2_recovery_node {
+	struct ocfs2_super *rn_osb;
+	int rn_node_num;
+	int rn_slot_num;
+	struct list_head rn_list;
 };


@@ -193,7 +195,7 @@ int    ocfs2_journal_load(struct ocfs2_journal
*journal, int local,
 			  int replayed);
 int    ocfs2_check_journals_nolocks(struct ocfs2_super *osb);
 void   ocfs2_recovery_thread(struct ocfs2_super *osb,
-			     int node_num);
+			     int node_num, int slot_num);
 int    ocfs2_mark_dead_nodes(struct ocfs2_super *osb);
 void   ocfs2_complete_mount_recovery(struct ocfs2_super *osb);
 void ocfs2_complete_quota_recovery(struct ocfs2_super *osb);
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 4092858..03a625e 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -342,7 +342,9 @@ struct ocfs2_super

 	atomic_t vol_state;
 	struct mutex recovery_lock;
-	struct ocfs2_recovery_map *recovery_map;
+	struct list_head s_active_reco_list;
+	struct list_head s_recovery_list;
+
 	struct ocfs2_replay_map *replay_map;
 	struct task_struct *recovery_thread_task;
 	int disable_recovery;
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 56f6102..6250ec2 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -222,7 +222,7 @@ static const match_table_t tokens = {
 static int ocfs2_osb_dump(struct ocfs2_super *osb, char *buf, int len)
 {
 	struct ocfs2_cluster_connection *cconn = osb->cconn;
-	struct ocfs2_recovery_map *rm = osb->recovery_map;
+	struct ocfs2_recovery_node *rn;
 	struct ocfs2_orphan_scan *os = &osb->osb_orphan_scan;
 	int i, out = 0;

@@ -274,12 +274,14 @@ static int ocfs2_osb_dump(struct ocfs2_super
*osb, char *buf, int len)
 			"Recovery",
 			(osb->recovery_thread_task ?
 			 task_pid_nr(osb->recovery_thread_task) : -1));
-	if (rm->rm_used == 0)
+	if (list_empty(&osb->s_active_reco_list))
 		out += snprintf(buf + out, len - out, " None\n");
 	else {
-		for (i = 0; i < rm->rm_used; i++)
+		list_for_each_entry(rn, &osb->s_active_reco_list,
+				rn_list) {
 			out += snprintf(buf + out, len - out, " %d",
-					rm->rm_entries[i]);
+					rn->rn_node_num);
+		}
 		out += snprintf(buf + out, len - out, "\n");
 	}
 	spin_unlock(&osb->osb_lock);
-- 
1.7.6
