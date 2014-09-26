From: WeiWei Wang <wangww631@huawei.com>
Date: Fri, 26 Sep 2014 17:57:44 +0800
Subject: [Ocfs2-devel] [PATCH 3/7 v3] ocfs2: add orphan recovery types in
 ocfs2_recover_orphans
Message-ID: <54253898.2030304@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This commit defines three orphan recovery types, which used in mount complete, node recovery and orphan scan situation respectively.
In original, only deleted inode will be add to orphan dir, and inode->i_nlink is reduced to zero. In this patch, direct-io write will
add the inode to orphan dir first, after direct-io finished, remove the inode from orphan dir later, in this case, the inode->i_nlink
may be not reduced to zero but it does add to orphan dir however.

Signed-off-by: Weiwei Wang <wangww631@huawei.com>
---
 fs/ocfs2/journal.c | 90 ++++++++++++++++++++++++++++++++++++++++++++----------
 fs/ocfs2/journal.h |  5 +++
 fs/ocfs2/ocfs2.h   |  6 ++++
 3 files changed, 85 insertions(+), 16 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 4b0c688..c8dcb84 100644
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
 					    int slot_num,
 					    struct ocfs2_dinode *la_dinode,
 					    struct ocfs2_dinode *tl_dinode,
-					    struct ocfs2_quota_recovery *qrec);
+					    struct ocfs2_quota_recovery *qrec,
+				enum ocfs2_orphan_reco_type orphan_reco_type);

 static inline int ocfs2_wait_on_mount(struct ocfs2_super *osb)
 {
@@ -149,7 +153,8 @@ int ocfs2_compute_replay_slots(struct ocfs2_super *osb)
 	return 0;
 }

-void ocfs2_queue_replay_slots(struct ocfs2_super *osb)
+void ocfs2_queue_replay_slots(struct ocfs2_super *osb,
+				enum ocfs2_orphan_reco_type orphan_reco_type)
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
+					    orphan_reco_type);
 		if (ret < 0)
 			mlog_errno(ret);

@@ -1261,7 +1271,8 @@ static void ocfs2_queue_recovery_completion(struct ocfs2_journal *journal,
 					    int slot_num,
 					    struct ocfs2_dinode *la_dinode,
 					    struct ocfs2_dinode *tl_dinode,
-					    struct ocfs2_quota_recovery *qrec)
+					    struct ocfs2_quota_recovery *qrec,
+				enum ocfs2_orphan_reco_type orphan_reco_type)
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
+					ORPHAN_MOUNT_COMPLETE);
 	ocfs2_schedule_truncate_log_flush(osb, 0);

 	osb->local_alloc_copy = NULL;
@@ -1312,7 +1325,7 @@ void ocfs2_complete_mount_recovery(struct ocfs2_super *osb)

 	/* queue to recover orphan slots for all offline slots */
 	ocfs2_replay_map_set_state(osb, REPLAY_NEEDED);
-	ocfs2_queue_replay_slots(osb);
+	ocfs2_queue_replay_slots(osb, ORPHAN_MOUNT_COMPLETE);
 	ocfs2_free_replay_slots(osb);
 }

@@ -1323,7 +1336,8 @@ void ocfs2_complete_quota_recovery(struct ocfs2_super *osb)
 						osb->slot_num,
 						NULL,
 						NULL,
-						osb->quota_rec);
+						osb->quota_rec,
+						ORPHAN_MOUNT_COMPLETE);
 		osb->quota_rec = NULL;
 	}
 }
@@ -1360,7 +1374,7 @@ restart:

 	/* queue recovery for our own slot */
 	ocfs2_queue_recovery_completion(osb->journal, osb->slot_num, NULL,
-					NULL, NULL);
+					NULL, NULL, ORPHAN_NODE_RECOVERY);

 	spin_lock(&osb->osb_lock);
 	while (rm->rm_used) {
@@ -1419,13 +1433,14 @@ skip_recovery:
 			continue;
 		}
 		ocfs2_queue_recovery_completion(osb->journal, rm_quota[i],
-						NULL, NULL, qrec);
+						NULL, NULL, qrec,
+						ORPHAN_NODE_RECOVERY);
 	}

 	ocfs2_super_unlock(osb, 1);

 	/* queue recovery for offline slots */
-	ocfs2_queue_replay_slots(osb);
+	ocfs2_queue_replay_slots(osb, ORPHAN_NODE_RECOVERY);

 bail:
 	mutex_lock(&osb->recovery_lock);
@@ -1712,7 +1727,7 @@ static int ocfs2_recover_node(struct ocfs2_super *osb,

 	/* This will kfree the memory pointed to by la_copy and tl_copy */
 	ocfs2_queue_recovery_completion(osb->journal, slot_num, la_copy,
-					tl_copy, NULL);
+					tl_copy, NULL, ORPHAN_NODE_RECOVERY);

 	status = 0;
 done:
@@ -1902,7 +1917,7 @@ void ocfs2_queue_orphan_scan(struct ocfs2_super *osb)

 	for (i = 0; i < osb->max_slots; i++)
 		ocfs2_queue_recovery_completion(osb->journal, i, NULL, NULL,
-						NULL);
+						NULL, ORPHAN_SCAN_WORK);
 	/*
 	 * We queued a recovery on orphan slots, increment the sequence
 	 * number and update LVB so other node will skip the scan for a while
@@ -2107,12 +2122,15 @@ static void ocfs2_clear_recovering_orphan_dir(struct ocfs2_super *osb,
  *   advertising our state to ocfs2_delete_inode().
  */
 static int ocfs2_recover_orphans(struct ocfs2_super *osb,
-				 int slot)
+				 int slot,
+				 enum ocfs2_orphan_reco_type orphan_reco_type)
 {
 	int ret = 0;
 	struct inode *inode = NULL;
 	struct inode *iter;
 	struct ocfs2_inode_info *oi;
+	struct buffer_head *di_bh = NULL;
+	handle_t *handle = NULL;

 	trace_ocfs2_recover_orphans(slot);

@@ -2135,7 +2153,46 @@ static int ocfs2_recover_orphans(struct ocfs2_super *osb,
 		spin_lock(&oi->ip_lock);
 		/* Set the proper information to get us going into
 		 * ocfs2_delete_inode. */
-		oi->ip_flags |= OCFS2_INODE_MAYBE_ORPHANED;
+		if (!inode->i_nlink)
+			oi->ip_flags |= OCFS2_INODE_MAYBE_ORPHANED;
+		else if (orphan_reco_type == ORPHAN_MOUNT_COMPLETE ||
+			    orphan_reco_type == ORPHAN_NODE_RECOVERY) {
+			ret = ocfs2_inode_lock(inode, &di_bh, 1);
+			if (ret) {
+				mlog_errno(ret);
+				spin_unlock(&oi->ip_lock);
+				goto out;
+			}
+			ocfs2_truncate_file(inode, di_bh, i_size_read(inode));
+			ocfs2_inode_unlock(inode, 1);
+			brelse(di_bh);
+
+			/* after truncate file, remove the inode from
+			 * the orphan dir. */
+			handle = ocfs2_start_trans(osb,
+					OCFS2_INODE_DEL_FROM_ORPHAN_CREDITS);
+			if (IS_ERR(handle)) {
+				ret = PTR_ERR(handle);
+				goto out;
+			}
+			ret = ocfs2_del_inode_from_orphan(osb, handle, inode);
+			if (ret) {
+				mlog_errno(ret);
+				ocfs2_commit_trans(osb, handle);
+				spin_unlock(&oi->ip_lock);
+				goto out;
+			}
+			ocfs2_commit_trans(osb, handle);
+		}
+		/*
+		 * if the orphan scan work, continue to process the
+		 * next orphan.
+		 */
+		else if (orphan_reco_type == ORPHAN_SCAN_WORK) {
+			spin_unlock(&oi->ip_lock);
+			inode = iter;
+			continue;
+		}
 		spin_unlock(&oi->ip_lock);

 		iput(inode);
@@ -2143,6 +2200,7 @@ static int ocfs2_recover_orphans(struct ocfs2_super *osb,
 		inode = iter;
 	}

+out:
 	return ret;
 }

diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 7f8cde9..f4cd3c3 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -472,6 +472,11 @@ static inline int ocfs2_unlink_credits(struct super_block *sb)
  * orphan dir index leaf */
 #define OCFS2_DELETE_INODE_CREDITS (3 * OCFS2_INODE_UPDATE_CREDITS + 4)

+/* dinode + orphan dir dinode + extent tree leaf block + orphan dir entry +
+ * orphan dir index root + orphan dir index leaf */
+#define OCFS2_INODE_ADD_TO_ORPHAN_CREDITS  (2 * OCFS2_INODE_UPDATE_CREDITS + 4)
+#define OCFS2_INODE_DEL_FROM_ORPHAN_CREDITS  OCFS2_INODE_ADD_TO_ORPHAN_CREDITS
+
 /* dinode update, old dir dinode update, new dir dinode update, old
  * dir dir entry, new dir dir entry, dir entry update for renaming
  * directory + target unlink + 3 x dir index leaves */
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index bbec539..71c9dac 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -203,6 +203,12 @@ struct ocfs2_lock_res {
 #endif
 };

+enum ocfs2_orphan_reco_type {
+	ORPHAN_MOUNT_COMPLETE = 0,
+	ORPHAN_NODE_RECOVERY,
+	ORPHAN_SCAN_WORK,
+};
+
 enum ocfs2_orphan_scan_state {
 	ORPHAN_SCAN_ACTIVE,
 	ORPHAN_SCAN_INACTIVE
-- 
1.8.4.3
