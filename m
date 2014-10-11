From: WeiWei Wang <wangww631@huawei.com>
Date: Sat, 11 Oct 2014 20:28:09 +0800
Subject: [Ocfs2-devel] [PATCH 3/7 v4] ocfs2: add orphan recovery types in
 ocfs2_recover_orphans
Message-ID: <54392259.5020904@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Define two orphan recovery types, which indicates if need truncate file
or not.
Originally, only deleted inode will be add to orphan dir.
We use orphan dir to temporary store the file in O_DIRECT write to
ensure the block allocation and inode size updating in the same handle
once the append O_DIRECT fails.
So now there may be not truly deleted files in orphan dir.

Signed-off-by: Weiwei Wang <wangww631@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/journal.c | 131 ++++++++++++++++++++++++++++++++++++++++++-----------
 fs/ocfs2/ocfs2.h   |   5 ++
 2 files changed, 110 insertions(+), 26 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 4b0c688..452ff5d 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -50,6 +50,8 @@
 #include "sysfile.h"
 #include "uptodate.h"
 #include "quota.h"
+#include "file.h"
+#include "namei.h"

 #include "buffer_head_io.h"
 #include "ocfs2_trace.h"
@@ -69,13 +71,15 @@ static int ocfs2_journal_toggle_dirty(struct ocfs2_super *osb,
 static int ocfs2_trylock_journal(struct ocfs2_super *osb,
 				 int slot_num);
 static int ocfs2_recover_orphans(struct ocfs2_super *osb,
-				 int slot);
+				 int slot,
+				 enum ocfs2_orphan_reco_type orphan_reco_type);
 static int ocfs2_commit_thread(void *arg);
 static void ocfs2_queue_recovery_completion(struct ocfs2_journal *journal,
-					    int slot_num,
-					    struct ocfs2_dinode *la_dinode,
-					    struct ocfs2_dinode *tl_dinode,
-					    struct ocfs2_quota_recovery *qrec);
+		int slot_num,
+		struct ocfs2_dinode *la_dinode,
+		struct ocfs2_dinode *tl_dinode,
+		struct ocfs2_quota_recovery *qrec,
+		enum ocfs2_orphan_reco_type orphan_reco_type);

 static inline int ocfs2_wait_on_mount(struct ocfs2_super *osb)
 {
@@ -149,7 +153,8 @@ int ocfs2_compute_replay_slots(struct ocfs2_super *osb)
 	return 0;
 }

-void ocfs2_queue_replay_slots(struct ocfs2_super *osb)
+void ocfs2_queue_replay_slots(struct ocfs2_super *osb,
+		enum ocfs2_orphan_reco_type orphan_reco_type)
 {
 	struct ocfs2_replay_map *replay_map = osb->replay_map;
 	int i;
@@ -163,7 +168,8 @@ void ocfs2_queue_replay_slots(struct ocfs2_super *osb)
 	for (i = 0; i < replay_map->rm_slots; i++)
 		if (replay_map->rm_replay_slots[i])
 			ocfs2_queue_recovery_completion(osb->journal, i, NULL,
-							NULL, NULL);
+							NULL, NULL,
+							orphan_reco_type);
 	replay_map->rm_state = REPLAY_DONE;
 }

@@ -1174,6 +1180,7 @@ struct ocfs2_la_recovery_item {
 	struct ocfs2_dinode	*lri_la_dinode;
 	struct ocfs2_dinode	*lri_tl_dinode;
 	struct ocfs2_quota_recovery *lri_qrec;
+	enum ocfs2_orphan_reco_type  lri_orphan_reco_type;
 };

 /* Does the second half of the recovery process. By this point, the
@@ -1195,6 +1202,7 @@ void ocfs2_complete_recovery(struct work_struct *work)
 	struct ocfs2_dinode *la_dinode, *tl_dinode;
 	struct ocfs2_la_recovery_item *item, *n;
 	struct ocfs2_quota_recovery *qrec;
+	enum ocfs2_orphan_reco_type orphan_reco_type;
 	LIST_HEAD(tmp_la_list);

 	trace_ocfs2_complete_recovery(
@@ -1212,6 +1220,7 @@ void ocfs2_complete_recovery(struct work_struct *work)
 		la_dinode = item->lri_la_dinode;
 		tl_dinode = item->lri_tl_dinode;
 		qrec = item->lri_qrec;
+		orphan_reco_type = item->lri_orphan_reco_type;

 		trace_ocfs2_complete_recovery_slot(item->lri_slot,
 			la_dinode ? le64_to_cpu(la_dinode->i_blkno) : 0,
@@ -1236,7 +1245,8 @@ void ocfs2_complete_recovery(struct work_struct *work)
 			kfree(tl_dinode);
 		}

-		ret = ocfs2_recover_orphans(osb, item->lri_slot);
+		ret = ocfs2_recover_orphans(osb, item->lri_slot,
+				orphan_reco_type);
 		if (ret < 0)
 			mlog_errno(ret);

@@ -1258,10 +1268,11 @@ void ocfs2_complete_recovery(struct work_struct *work)
  * tl_dinode, either manually on error, or by passing them to
  * ocfs2_complete_recovery */
 static void ocfs2_queue_recovery_completion(struct ocfs2_journal *journal,
-					    int slot_num,
-					    struct ocfs2_dinode *la_dinode,
-					    struct ocfs2_dinode *tl_dinode,
-					    struct ocfs2_quota_recovery *qrec)
+		int slot_num,
+		struct ocfs2_dinode *la_dinode,
+		struct ocfs2_dinode *tl_dinode,
+		struct ocfs2_quota_recovery *qrec,
+		enum ocfs2_orphan_reco_type orphan_reco_type)
 {
 	struct ocfs2_la_recovery_item *item;

@@ -1285,6 +1296,7 @@ static void ocfs2_queue_recovery_completion(struct ocfs2_journal *journal,
 	item->lri_slot = slot_num;
 	item->lri_tl_dinode = tl_dinode;
 	item->lri_qrec = qrec;
+	item->lri_orphan_reco_type = orphan_reco_type;

 	spin_lock(&journal->j_lock);
 	list_add_tail(&item->lri_list, &journal->j_la_cleanups);
@@ -1304,7 +1316,8 @@ void ocfs2_complete_mount_recovery(struct ocfs2_super *osb)
 	/* No need to queue up our truncate_log as regular cleanup will catch
 	 * that */
 	ocfs2_queue_recovery_completion(journal, osb->slot_num,
-					osb->local_alloc_copy, NULL, NULL);
+					osb->local_alloc_copy, NULL, NULL,
+					ORPHAN_NEED_TRUNCATE);
 	ocfs2_schedule_truncate_log_flush(osb, 0);

 	osb->local_alloc_copy = NULL;
@@ -1312,7 +1325,7 @@ void ocfs2_complete_mount_recovery(struct ocfs2_super *osb)

 	/* queue to recover orphan slots for all offline slots */
 	ocfs2_replay_map_set_state(osb, REPLAY_NEEDED);
-	ocfs2_queue_replay_slots(osb);
+	ocfs2_queue_replay_slots(osb, ORPHAN_NEED_TRUNCATE);
 	ocfs2_free_replay_slots(osb);
 }

@@ -1323,7 +1336,8 @@ void ocfs2_complete_quota_recovery(struct ocfs2_super *osb)
 						osb->slot_num,
 						NULL,
 						NULL,
-						osb->quota_rec);
+						osb->quota_rec,
+						ORPHAN_NEED_TRUNCATE);
 		osb->quota_rec = NULL;
 	}
 }
@@ -1360,7 +1374,7 @@ restart:

 	/* queue recovery for our own slot */
 	ocfs2_queue_recovery_completion(osb->journal, osb->slot_num, NULL,
-					NULL, NULL);
+					NULL, NULL, ORPHAN_NO_NEED_TRUNCATE);

 	spin_lock(&osb->osb_lock);
 	while (rm->rm_used) {
@@ -1419,13 +1433,14 @@ skip_recovery:
 			continue;
 		}
 		ocfs2_queue_recovery_completion(osb->journal, rm_quota[i],
-						NULL, NULL, qrec);
+						NULL, NULL, qrec,
+						ORPHAN_NEED_TRUNCATE);
 	}

 	ocfs2_super_unlock(osb, 1);

 	/* queue recovery for offline slots */
-	ocfs2_queue_replay_slots(osb);
+	ocfs2_queue_replay_slots(osb, ORPHAN_NEED_TRUNCATE);

 bail:
 	mutex_lock(&osb->recovery_lock);
@@ -1712,7 +1727,7 @@ static int ocfs2_recover_node(struct ocfs2_super *osb,

 	/* This will kfree the memory pointed to by la_copy and tl_copy */
 	ocfs2_queue_recovery_completion(osb->journal, slot_num, la_copy,
-					tl_copy, NULL);
+					tl_copy, NULL, ORPHAN_NEED_TRUNCATE);

 	status = 0;
 done:
@@ -1902,7 +1917,7 @@ void ocfs2_queue_orphan_scan(struct ocfs2_super *osb)

 	for (i = 0; i < osb->max_slots; i++)
 		ocfs2_queue_recovery_completion(osb->journal, i, NULL, NULL,
-						NULL);
+						NULL, ORPHAN_NO_NEED_TRUNCATE);
 	/*
 	 * We queued a recovery on orphan slots, increment the sequence
 	 * number and update LVB so other node will skip the scan for a while
@@ -2088,6 +2103,39 @@ static void ocfs2_clear_recovering_orphan_dir(struct ocfs2_super *osb,
 	ocfs2_node_map_clear_bit(osb, &osb->osb_recovering_orphan_dirs, slot);
 }

+static int ocfs2_truncate_file_locked(struct inode *inode)
+{
+	struct buffer_head *di_bh = NULL;
+	int ret;
+
+	ret = ocfs2_rw_lock(inode, 1);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_inode_lock(inode, &di_bh, 1);
+	if (ret < 0) {
+		ocfs2_rw_unlock(inode, 1);
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_truncate_file(inode, di_bh, i_size_read(inode));
+	if (ret < 0) {
+		if (ret != -ENOSPC)
+			mlog_errno(ret);
+		ret = -ENOSPC;
+	}
+
+	ocfs2_inode_unlock(inode, 1);
+	ocfs2_rw_unlock(inode, 1);
+	brelse(di_bh);
+
+out:
+	return ret;
+}
+
 /*
  * Orphan recovery. Each mounted node has it's own orphan dir which we
  * must run during recovery. Our strategy here is to build a list of
@@ -2107,7 +2155,8 @@ static void ocfs2_clear_recovering_orphan_dir(struct ocfs2_super *osb,
  *   advertising our state to ocfs2_delete_inode().
  */
 static int ocfs2_recover_orphans(struct ocfs2_super *osb,
-				 int slot)
+				 int slot,
+				 enum ocfs2_orphan_reco_type orphan_reco_type)
 {
 	int ret = 0;
 	struct inode *inode = NULL;
@@ -2132,12 +2181,42 @@ static int ocfs2_recover_orphans(struct ocfs2_super *osb,

 		iter = oi->ip_next_orphan;

-		spin_lock(&oi->ip_lock);
-		/* Set the proper information to get us going into
-		 * ocfs2_delete_inode. */
-		oi->ip_flags |= OCFS2_INODE_MAYBE_ORPHANED;
-		spin_unlock(&oi->ip_lock);
+		/*
+		 * We need to take and drop the inode lock to
+		 * force read inode from disk.
+		 */
+		ret = ocfs2_inode_lock(inode, NULL, 0);
+		if (ret) {
+			mlog_errno(ret);
+			goto next;
+		}
+		ocfs2_inode_unlock(inode, 0);
+
+		if (inode->i_nlink == 0) {
+			spin_lock(&oi->ip_lock);
+			/* The remote delete code may have set these on the
+			 * assumption that the other node would wipe them
+			 * successfully.  If they are still in the node's
+			 * orphan dir, we need to reset that state. */
+			oi->ip_flags &= ~(OCFS2_INODE_DELETED);
+
+			/* Set the proper information to get us going into
+			 * ocfs2_delete_inode. */
+			oi->ip_flags |= OCFS2_INODE_MAYBE_ORPHANED;
+			spin_unlock(&oi->ip_lock);
+		} else if (orphan_reco_type == ORPHAN_NEED_TRUNCATE) {
+			ret = ocfs2_truncate_file_locked(inode);
+			if (ret) {
+				mlog_errno(ret);
+				goto next;
+			}
+
+			ret = ocfs2_del_inode_from_orphan(osb, inode, 0, 0);
+			if (ret)
+				mlog_errno(ret);
+		} /* else if ORPHAN_NO_NEED_TRUNCATE, do nothing */

+next:
 		iput(inode);

 		inode = iter;
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index bbec539..f745565 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -203,6 +203,11 @@ struct ocfs2_lock_res {
 #endif
 };

+enum ocfs2_orphan_reco_type {
+	ORPHAN_NO_NEED_TRUNCATE = 0,
+	ORPHAN_NEED_TRUNCATE,
+};
+
 enum ocfs2_orphan_scan_state {
 	ORPHAN_SCAN_ACTIVE,
 	ORPHAN_SCAN_INACTIVE
-- 
1.8.4.3
