From: Joel Becker <joel.becker@oracle.com>
Date: Wed Mar  5 14:52:31 2008
Subject: [Ocfs2-devel] [PATCH 3/7] ocfs2: Change the recovery map to an
	array of node numbers.
In-Reply-To: <1204757524-21343-1-git-send-email-joel.becker@oracle.com>
References: <1204757524-21343-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1204757524-21343-4-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

The old recovery map was a bitmap of node numbers.  This was sufficient
for the maximum node number of 254.  Going forward, we want node numbers
to be UINT32.  Thus, we need a new recovery map.

Note that we can't keep track of slots here.  We must write down the
node number to recovery *before* we get the locks needed to convert a
node number into a slot number.

The recovery map is now an array of unsigned ints, max_slots in size.
It moves to journal.c with the rest of recovery.

Because it needs to be initialized, we move all of recovery initialization
into a new function, ocfs2_recovery_init().  This actually cleans up
ocfs2_initialize_super() a little as well.  Following on, recovery cleaup
becomes part of ocfs2_recovery_exit().

A number of node map functions are rendered obsolete and are removed.

Finally, waiting on recovery is wrapped in a function rather than naked
checks on the recovery_event.  This is a cleanup from Mark.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/dlmglue.c   |    6 +-
 fs/ocfs2/heartbeat.c |  111 ------------------------------
 fs/ocfs2/heartbeat.h |   14 ----
 fs/ocfs2/journal.c   |  181 +++++++++++++++++++++++++++++++++++++++++++++----
 fs/ocfs2/journal.h   |    4 +
 fs/ocfs2/ocfs2.h     |    3 +-
 fs/ocfs2/super.c     |   33 ++-------
 7 files changed, 182 insertions(+), 170 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 33c8a65..b4108fe 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -1950,8 +1950,7 @@ int ocfs2_inode_lock_full(struct inode *inode,
 		goto local;
 
 	if (!(arg_flags & OCFS2_META_LOCK_RECOVERY))
-		wait_event(osb->recovery_event,
-			   ocfs2_node_map_is_empty(osb, &osb->recovery_map));
+		ocfs2_wait_for_recovery(osb);
 
 	lockres = &OCFS2_I(inode)->ip_inode_lockres;
 	level = ex ? LKM_EXMODE : LKM_PRMODE;
@@ -1974,8 +1973,7 @@ int ocfs2_inode_lock_full(struct inode *inode,
 	 * committed to owning this lock so we don't allow signals to
 	 * abort the operation. */
 	if (!(arg_flags & OCFS2_META_LOCK_RECOVERY))
-		wait_event(osb->recovery_event,
-			   ocfs2_node_map_is_empty(osb, &osb->recovery_map));
+		ocfs2_wait_for_recovery(osb);
 
 local:
 	/*
diff --git a/fs/ocfs2/heartbeat.c b/fs/ocfs2/heartbeat.c
index 0758daf..80de239 100644
--- a/fs/ocfs2/heartbeat.c
+++ b/fs/ocfs2/heartbeat.c
@@ -48,7 +48,6 @@ static inline void __ocfs2_node_map_set_bit(struct ocfs2_node_map *map,
 					    int bit);
 static inline void __ocfs2_node_map_clear_bit(struct ocfs2_node_map *map,
 					      int bit);
-static inline int __ocfs2_node_map_is_empty(struct ocfs2_node_map *map);
 
 /* special case -1 for now
  * TODO: should *really* make sure the calling func never passes -1!!  */
@@ -62,7 +61,6 @@ static void ocfs2_node_map_init(struct ocfs2_node_map *map)
 void ocfs2_init_node_maps(struct ocfs2_super *osb)
 {
 	spin_lock_init(&osb->node_map_lock);
-	ocfs2_node_map_init(&osb->recovery_map);
 	ocfs2_node_map_init(&osb->osb_recovering_orphan_dirs);
 }
 
@@ -192,112 +190,3 @@ int ocfs2_node_map_test_bit(struct ocfs2_super *osb,
 	return ret;
 }
 
-static inline int __ocfs2_node_map_is_empty(struct ocfs2_node_map *map)
-{
-	int bit;
-	bit = find_next_bit(map->map, map->num_nodes, 0);
-	if (bit < map->num_nodes)
-		return 0;
-	return 1;
-}
-
-int ocfs2_node_map_is_empty(struct ocfs2_super *osb,
-			    struct ocfs2_node_map *map)
-{
-	int ret;
-	BUG_ON(map->num_nodes == 0);
-	spin_lock(&osb->node_map_lock);
-	ret = __ocfs2_node_map_is_empty(map);
-	spin_unlock(&osb->node_map_lock);
-	return ret;
-}
-
-#if 0
-
-static void __ocfs2_node_map_dup(struct ocfs2_node_map *target,
-				 struct ocfs2_node_map *from)
-{
-	BUG_ON(from->num_nodes == 0);
-	ocfs2_node_map_init(target);
-	__ocfs2_node_map_set(target, from);
-}
-
-/* returns 1 if bit is the only bit set in target, 0 otherwise */
-int ocfs2_node_map_is_only(struct ocfs2_super *osb,
-			   struct ocfs2_node_map *target,
-			   int bit)
-{
-	struct ocfs2_node_map temp;
-	int ret;
-
-	spin_lock(&osb->node_map_lock);
-	__ocfs2_node_map_dup(&temp, target);
-	__ocfs2_node_map_clear_bit(&temp, bit);
-	ret = __ocfs2_node_map_is_empty(&temp);
-	spin_unlock(&osb->node_map_lock);
-
-	return ret;
-}
-
-static void __ocfs2_node_map_set(struct ocfs2_node_map *target,
-				 struct ocfs2_node_map *from)
-{
-	int num_longs, i;
-
-	BUG_ON(target->num_nodes != from->num_nodes);
-	BUG_ON(target->num_nodes == 0);
-
-	num_longs = BITS_TO_LONGS(target->num_nodes);
-	for (i = 0; i < num_longs; i++)
-		target->map[i] = from->map[i];
-}
-
-#endif  /*  0  */
-
-/* Returns whether the recovery bit was actually set - it may not be
- * if a node is still marked as needing recovery */
-int ocfs2_recovery_map_set(struct ocfs2_super *osb,
-			   int num)
-{
-	int set = 0;
-
-	spin_lock(&osb->node_map_lock);
-
-	if (!test_bit(num, osb->recovery_map.map)) {
-	    __ocfs2_node_map_set_bit(&osb->recovery_map, num);
-	    set = 1;
-	}
-
-	spin_unlock(&osb->node_map_lock);
-
-	return set;
-}
-
-void ocfs2_recovery_map_clear(struct ocfs2_super *osb,
-			      int num)
-{
-	ocfs2_node_map_clear_bit(osb, &osb->recovery_map, num);
-}
-
-int ocfs2_node_map_iterate(struct ocfs2_super *osb,
-			   struct ocfs2_node_map *map,
-			   int idx)
-{
-	int i = idx;
-
-	idx = O2NM_INVALID_NODE_NUM;
-	spin_lock(&osb->node_map_lock);
-	if ((i != O2NM_INVALID_NODE_NUM) &&
-	    (i >= 0) &&
-	    (i < map->num_nodes)) {
-		while(i < map->num_nodes) {
-			if (test_bit(i, map->map)) {
-				idx = i;
-				break;
-			}
-			i++;
-		}
-	}
-	spin_unlock(&osb->node_map_lock);
-	return idx;
-}
diff --git a/fs/ocfs2/heartbeat.h b/fs/ocfs2/heartbeat.h
index eac63ae..98d8ffc 100644
--- a/fs/ocfs2/heartbeat.h
+++ b/fs/ocfs2/heartbeat.h
@@ -33,8 +33,6 @@ void ocfs2_stop_heartbeat(struct ocfs2_super *osb);
 
 /* node map functions - used to keep track of mounted and in-recovery
  * nodes. */
-int ocfs2_node_map_is_empty(struct ocfs2_super *osb,
-			    struct ocfs2_node_map *map);
 void ocfs2_node_map_set_bit(struct ocfs2_super *osb,
 			    struct ocfs2_node_map *map,
 			    int bit);
@@ -44,17 +42,5 @@ void ocfs2_node_map_clear_bit(struct ocfs2_super *osb,
 int ocfs2_node_map_test_bit(struct ocfs2_super *osb,
 			    struct ocfs2_node_map *map,
 			    int bit);
-int ocfs2_node_map_iterate(struct ocfs2_super *osb,
-			   struct ocfs2_node_map *map,
-			   int idx);
-static inline int ocfs2_node_map_first_set_bit(struct ocfs2_super *osb,
-					       struct ocfs2_node_map *map)
-{
-	return ocfs2_node_map_iterate(osb, map, 0);
-}
-int ocfs2_recovery_map_set(struct ocfs2_super *osb,
-			   int num);
-void ocfs2_recovery_map_clear(struct ocfs2_super *osb,
-			      int num);
 
 #endif /* OCFS2_HEARTBEAT_H */
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index ed0c6d0..fe679f3 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -64,6 +64,137 @@ static int ocfs2_recover_orphans(struct ocfs2_super *osb,
 				 int slot);
 static int ocfs2_commit_thread(void *arg);
 
+
+/*
+ * The recovery_list is a simple linked list of node numbers to recover.
+ * It is protected by the recovery_lock.
+ */
+
+struct ocfs2_recovery_map {
+	int rm_used;
+	unsigned int *rm_entries;
+};
+
+int ocfs2_recovery_init(struct ocfs2_super *osb)
+{
+	struct ocfs2_recovery_map *rm;
+
+	mutex_init(&osb->recovery_lock);
+	osb->disable_recovery = 0;
+	osb->recovery_thread_task = NULL;
+	init_waitqueue_head(&osb->recovery_event);
+
+	rm = kzalloc(sizeof(struct ocfs2_recovery_map) +
+		     osb->max_slots * sizeof(unsigned int),
+		     GFP_KERNEL);
+	if (!rm) {
+		mlog_errno(-ENOMEM);
+		return -ENOMEM;
+	}
+
+	rm->rm_entries = (unsigned int *)((char *)rm +
+					  sizeof(struct ocfs2_recovery_map));
+	osb->recovery_map = rm;
+
+	return 0;
+}
+
+/* we can't grab the goofy sem lock from inside wait_event, so we use
+ * memory barriers to make sure that we'll see the null task before
+ * being woken up */
+static int ocfs2_recovery_thread_running(struct ocfs2_super *osb)
+{
+	mb();
+	return osb->recovery_thread_task != NULL;
+}
+
+void ocfs2_recovery_exit(struct ocfs2_super *osb)
+{
+	struct ocfs2_recovery_map *rm;
+
+	/* disable any new recovery threads and wait for any currently
+	 * running ones to exit. Do this before setting the vol_state. */
+	mutex_lock(&osb->recovery_lock);
+	osb->disable_recovery = 1;
+	mutex_unlock(&osb->recovery_lock);
+	wait_event(osb->recovery_event, !ocfs2_recovery_thread_running(osb));
+
+	/* At this point, we know that no more recovery threads can be
+	 * launched, so wait for any recovery completion work to
+	 * complete. */
+	flush_workqueue(ocfs2_wq);
+
+	/*
+	 * Now that recovery is shut down, and the osb is about to be
+	 * freed,  the osb_lock is not taken here.
+	 */
+	rm = osb->recovery_map;
+	/* XXX: Should we bug if there are dirty entries? */
+
+	kfree(rm);
+}
+
+/* Behaves like test-and-set.  Returns the previous value */
+static int __ocfs2_recovery_map_test(struct ocfs2_super *osb,
+				     unsigned int node_num)
+{
+	int i;
+	struct ocfs2_recovery_map *rm = osb->recovery_map;
+
+	assert_spin_locked(&osb->osb_lock);
+
+	for (i = 0; i < rm->rm_used; i++) {
+		if (rm->rm_entries[i] == node_num)
+			return 1;
+	}
+
+	return 0;
+}
+
+static int ocfs2_recovery_map_set(struct ocfs2_super *osb,
+				  unsigned int node_num)
+{
+	struct ocfs2_recovery_map *rm = osb->recovery_map;
+
+	spin_lock(&osb->osb_lock);
+	if (__ocfs2_recovery_map_test(osb, node_num)) {
+		spin_unlock(&osb->osb_lock);
+		return 1;
+	}
+
+	/* XXX: Can this be exploited? Not from o2dlm... */
+	BUG_ON(rm->rm_used >= osb->max_slots);
+
+	rm->rm_entries[rm->rm_used] = node_num;
+	rm->rm_used++;
+	spin_unlock(&osb->osb_lock);
+
+	return 0;
+}
+
+static void ocfs2_recovery_map_clear(struct ocfs2_super *osb,
+				     unsigned int node_num)
+{
+	int i;
+	struct ocfs2_recovery_map *rm = osb->recovery_map;
+
+	spin_lock(&osb->osb_lock);
+
+	for (i = 0; i < rm->rm_used; i++) {
+		if (rm->rm_entries[i] == node_num)
+			break;
+	}
+
+	if (i < rm->rm_used) {
+		/* XXX: be careful with the pointer math */
+		memmove(&(rm->rm_entries[i]), &(rm->rm_entries[i + 1]),
+			(rm->rm_used - i - 1) * sizeof(unsigned int));
+		rm->rm_used--;
+	}
+
+	spin_unlock(&osb->osb_lock);
+}
+
 static int ocfs2_commit_cache(struct ocfs2_super *osb)
 {
 	int status = 0;
@@ -650,6 +781,23 @@ bail:
 	return status;
 }
 
+static int ocfs2_recovery_completed(struct ocfs2_super *osb)
+{
+	int empty;
+	struct ocfs2_recovery_map *rm = osb->recovery_map;
+
+	spin_lock(&osb->osb_lock);
+	empty = (rm->rm_used == 0);
+	spin_unlock(&osb->osb_lock);
+
+	return empty;
+}
+
+void ocfs2_wait_for_recovery(struct ocfs2_super *osb)
+{
+	wait_event(osb->recovery_event, ocfs2_recovery_completed(osb));
+}
+
 /*
  * JBD Might read a cached version of another nodes journal file. We
  * don't want this as this file changes often and we get no
@@ -848,6 +996,7 @@ static int __ocfs2_recovery_thread(void *arg)
 {
 	int status, node_num;
 	struct ocfs2_super *osb = arg;
+	struct ocfs2_recovery_map *rm = osb->recovery_map;
 
 	mlog_entry_void();
 
@@ -863,26 +1012,29 @@ restart:
 		goto bail;
 	}
 
-	while(!ocfs2_node_map_is_empty(osb, &osb->recovery_map)) {
-		node_num = ocfs2_node_map_first_set_bit(osb,
-							&osb->recovery_map);
-		if (node_num == O2NM_INVALID_NODE_NUM) {
-			mlog(0, "Out of nodes to recover.\n");
-			break;
-		}
+	spin_lock(&osb->osb_lock);
+	while (rm->rm_used) {
+		/* It's always safe to remove entry zero, as we won't
+		 * clear it until ocfs2_recover_node() has succeeded. */
+		node_num = rm->rm_entries[0];
+		spin_unlock(&osb->osb_lock);
 
 		status = ocfs2_recover_node(osb, node_num);
-		if (status < 0) {
+		if (!status) {
+			ocfs2_recovery_map_clear(osb, node_num);
+		} else {
 			mlog(ML_ERROR,
 			     "Error %d recovering node %d on device (%u,%u)!\n",
 			     status, node_num,
 			     MAJOR(osb->sb->s_dev), MINOR(osb->sb->s_dev));
 			mlog(ML_ERROR, "Volume requires unmount.\n");
-			continue;
 		}
 
-		ocfs2_recovery_map_clear(osb, node_num);
+		spin_lock(&osb->osb_lock);
 	}
+	spin_unlock(&osb->osb_lock);
+	mlog(0, "All nodes recovered\n");
+
 	ocfs2_super_unlock(osb, 1);
 
 	/* We always run recovery on our own orphan dir - the dead
@@ -893,8 +1045,7 @@ restart:
 
 bail:
 	mutex_lock(&osb->recovery_lock);
-	if (!status &&
-	    !ocfs2_node_map_is_empty(osb, &osb->recovery_map)) {
+	if (!status && !ocfs2_recovery_completed(osb)) {
 		mutex_unlock(&osb->recovery_lock);
 		goto restart;
 	}
@@ -924,8 +1075,8 @@ void ocfs2_recovery_thread(struct ocfs2_super *osb, int node_num)
 
 	/* People waiting on recovery will wait on
 	 * the recovery map to empty. */
-	if (!ocfs2_recovery_map_set(osb, node_num))
-		mlog(0, "node %d already be in recovery.\n", node_num);
+	if (ocfs2_recovery_map_set(osb, node_num))
+		mlog(0, "node %d already in recovery map.\n", node_num);
 
 	mlog(0, "starting recovery thread...\n");
 
@@ -1197,7 +1348,7 @@ int ocfs2_mark_dead_nodes(struct ocfs2_super *osb)
 		if (status == -ENOENT)
 			continue;
 
-		if (ocfs2_node_map_test_bit(osb, &osb->recovery_map, node_num))
+		if (__ocfs2_recovery_map_test(osb, node_num))
 			continue;
 		spin_unlock(&osb->osb_lock);
 
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 220f3e8..db82be2 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -134,6 +134,10 @@ static inline void ocfs2_inode_set_new(struct ocfs2_super *osb,
 
 /* Exported only for the journal struct init code in super.c. Do not call. */
 void ocfs2_complete_recovery(struct work_struct *work);
+void ocfs2_wait_for_recovery(struct ocfs2_super *osb);
+
+int ocfs2_recovery_init(struct ocfs2_super *osb);
+void ocfs2_recovery_exit(struct ocfs2_super *osb);
 
 /*
  *  Journal Control:
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index ee3f675..c6ed8c3 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -180,6 +180,7 @@ enum ocfs2_mount_options
 
 struct ocfs2_journal;
 struct ocfs2_slot_info;
+struct ocfs2_recovery_map;
 struct ocfs2_super
 {
 	struct task_struct *commit_task;
@@ -191,7 +192,6 @@ struct ocfs2_super
 	struct ocfs2_slot_info *slot_info;
 
 	spinlock_t node_map_lock;
-	struct ocfs2_node_map recovery_map;
 
 	u64 root_blkno;
 	u64 system_dir_blkno;
@@ -226,6 +226,7 @@ struct ocfs2_super
 
 	atomic_t vol_state;
 	struct mutex recovery_lock;
+	struct ocfs2_recovery_map *recovery_map;
 	struct task_struct *recovery_thread_task;
 	int disable_recovery;
 	wait_queue_head_t checkpoint_event;
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index fad37af..1a4c7c7 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1224,15 +1224,6 @@ leave:
 	return status;
 }
 
-/* we can't grab the goofy sem lock from inside wait_event, so we use
- * memory barriers to make sure that we'll see the null task before
- * being woken up */
-static int ocfs2_recovery_thread_running(struct ocfs2_super *osb)
-{
-	mb();
-	return osb->recovery_thread_task != NULL;
-}
-
 static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 {
 	int tmp;
@@ -1249,17 +1240,8 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 
 	ocfs2_truncate_log_shutdown(osb);
 
-	/* disable any new recovery threads and wait for any currently
-	 * running ones to exit. Do this before setting the vol_state. */
-	mutex_lock(&osb->recovery_lock);
-	osb->disable_recovery = 1;
-	mutex_unlock(&osb->recovery_lock);
-	wait_event(osb->recovery_event, !ocfs2_recovery_thread_running(osb));
-
-	/* At this point, we know that no more recovery threads can be
-	 * launched, so wait for any recovery completion work to
-	 * complete. */
-	flush_workqueue(ocfs2_wq);
+	/* This will disable recovery and flush any recovery work. */
+	ocfs2_recovery_exit(osb);
 
 	ocfs2_journal_shutdown(osb);
 
@@ -1368,7 +1350,6 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	osb->s_sectsize_bits = blksize_bits(sector_size);
 	BUG_ON(!osb->s_sectsize_bits);
 
-	init_waitqueue_head(&osb->recovery_event);
 	spin_lock_init(&osb->dc_task_lock);
 	init_waitqueue_head(&osb->dc_event);
 	osb->dc_work_sequence = 0;
@@ -1388,10 +1369,12 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	snprintf(osb->dev_str, sizeof(osb->dev_str), "%u,%u",
 		 MAJOR(osb->sb->s_dev), MINOR(osb->sb->s_dev));
 
-	mutex_init(&osb->recovery_lock);
-
-	osb->disable_recovery = 0;
-	osb->recovery_thread_task = NULL;
+	status = ocfs2_recovery_init(osb);
+	if (status) {
+		mlog(ML_ERROR, "Unable to initialize recovery state\n");
+		mlog_errno(status);
+		goto bail;
+	}
 
 	init_waitqueue_head(&osb->checkpoint_event);
 	atomic_set(&osb->needs_checkpoint, 0);
-- 
1.5.3.8
