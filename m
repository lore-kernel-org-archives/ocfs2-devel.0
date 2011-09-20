From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Tue, 20 Sep 2011 10:11:48 -0500
Subject: [Ocfs2-devel] [PATCH 2/2] Offload node recovery to work queues
Message-ID: <CAJtY7HWLwCpYWNZ7pG9qoL-750b-GyaffX4KZ7VzgSW=VAzzXQ@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The recovery nodes use the work structure to offload the work to work
queues. Finally, it waits for all the work to complete by flushing the
work scheduled. This is also a point to check if we might have missed on
scheduling work which was added to the queue by the mount/process after
the loop is over. In this case, we perform the scheduling again.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>
---
 fs/ocfs2/journal.c |   69 +++++++++++++++++++++++++++++++++++++--------------
 fs/ocfs2/journal.h |    8 ++++++
 2 files changed, 58 insertions(+), 19 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 2e07c67..3dc3cd9 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -58,7 +58,7 @@ DEFINE_SPINLOCK(trans_inc_lock);
 #define ORPHAN_SCAN_SCHEDULE_TIMEOUT 300000

 static int ocfs2_force_read_journal(struct inode *inode);
-static int ocfs2_recover_node(struct ocfs2_recovery_node *rn);
+static void ocfs2_recover_node(struct work_struct *work);
 static int __ocfs2_recovery_thread(void *arg);
 static int ocfs2_commit_cache(struct ocfs2_super *osb);
 static int __ocfs2_wait_on_mount(struct ocfs2_super *osb, int quota);
@@ -258,7 +258,9 @@ static int ocfs2_recovery_node_set(struct ocfs2_super *osb,
 			struct ocfs2_recovery_node, rn_list);
 	rn->rn_node_num = node_num;
 	rn->rn_slot_num = slot_num;
-	list_move(&rn->rn_list, &osb->s_active_reco_list);
+	rn->rn_state = OCFS2REC_NEEDED;
+	INIT_WORK(&rn->rn_work, ocfs2_recover_node);
+	list_move_tail(&rn->rn_list, &osb->s_active_reco_list);
 out:
 	spin_unlock(&osb->osb_lock);
 	return ret;
@@ -270,7 +272,7 @@ static void ocfs2_recovery_node_clear(struct
ocfs2_recovery_node *rn)
 	spin_lock(&osb->osb_lock);
 	list_move(&rn->rn_list, &osb->s_recovery_list);
 	spin_unlock(&osb->osb_lock);
-	kfree(rn);
+	rn->rn_state = OCFS2REC_DONE;
 }

 static int ocfs2_commit_cache(struct ocfs2_super *osb)
@@ -1265,6 +1267,32 @@ void ocfs2_complete_quota_recovery(struct
ocfs2_super *osb)
 	}
 }

+/* Flushes all the work structs scheduled to perform recovery
+ * This also closes a small race gap where a node is set after the
+ * scheduling loop in __ocfs2_recovery_thread
+ */
+static int ocfs2_recovery_flush(struct ocfs2_super *osb)
+{
+	struct ocfs2_recovery_node *rn;
+	int ret = 0;
+	spin_lock(&osb->osb_lock);
+	while (!list_empty(&osb->s_active_reco_list)) {
+		rn = list_first_entry(&osb->s_active_reco_list,
+				struct ocfs2_recovery_node, rn_list);
+		spin_unlock(&osb->osb_lock);
+		if (rn->rn_state == OCFS2REC_IN_PROGRESS) {
+			flush_work(&rn->rn_work);
+		} else if (rn->rn_state == OCFS2REC_NEEDED) {
+			ret = -EAGAIN;
+			goto out;
+		}
+		spin_lock(&osb->osb_lock);
+	}
+out:
+	spin_unlock(&osb->osb_lock);
+	return ret;
+}
+
 static int __ocfs2_recovery_thread(void *arg)
 {
 	int status;
@@ -1272,7 +1300,7 @@ static int __ocfs2_recovery_thread(void *arg)
 	int *rm_quota = NULL;
 	int rm_quota_used = 0, i;
 	struct ocfs2_quota_recovery *qrec;
-	struct ocfs2_recovery_node *rn;
+	struct ocfs2_recovery_node *rn, *tmp;

 	status = ocfs2_wait_on_mount(osb);
 	if (status < 0) {
@@ -1298,9 +1326,9 @@ restart:
 	/* queue recovery for our own slot */
 	ocfs2_queue_recovery_completion(osb->journal, osb->slot_num, NULL,
 					NULL, NULL);
-
+restart_recovery:
 	spin_lock(&osb->osb_lock);
-	list_for_each_entry(rn, &osb->s_active_reco_list, rn_list) {
+	list_for_each_entry_safe(rn, tmp, &osb->s_active_reco_list, rn_list) {
 		spin_unlock(&osb->osb_lock);
 		trace_ocfs2_recovery_thread_node(rn->rn_node_num,
 				rn->rn_slot_num);
@@ -1315,23 +1343,18 @@ restart:
 				i++);
 		if (i == rm_quota_used)
 			rm_quota[rm_quota_used++] = rn->rn_slot_num;
-
-		status = ocfs2_recover_node(rn);
-		if (!status) {
-			ocfs2_recovery_node_clear(rn);
-		} else {
-			mlog(ML_ERROR,
-			     "Error %d recovering node %d on device (%u,%u)!\n",
-			     status, rn->rn_node_num,
-			     MAJOR(osb->sb->s_dev), MINOR(osb->sb->s_dev));
-			mlog(ML_ERROR, "Volume requires unmount.\n");
+		if (rn->rn_state == OCFS2REC_NEEDED) {
+			rn->rn_state = OCFS2REC_IN_PROGRESS;
+			schedule_work(&rn->rn_work);
 		}
-
 		spin_lock(&osb->osb_lock);
 	}
 	spin_unlock(&osb->osb_lock);
 	trace_ocfs2_recovery_thread_end(status);

+	if (ocfs2_recovery_flush(osb) == -EAGAIN)
+		goto restart_recovery;
+
 	/* Refresh all journal recovery generations from disk */
 	status = ocfs2_check_journals_nolocks(osb);
 	status = (status == -EROFS) ? 0 : status;
@@ -1594,11 +1617,13 @@ done:
  * second part of a nodes recovery process (local alloc recovery) is
  * far less concerning.
  */
-static int ocfs2_recover_node(struct ocfs2_recovery_node *rn)
+static void ocfs2_recover_node(struct work_struct *work)
 {
 	int status = 0;
 	struct ocfs2_dinode *la_copy = NULL;
 	struct ocfs2_dinode *tl_copy = NULL;
+	struct ocfs2_recovery_node *rn = container_of(work,
+			struct ocfs2_recovery_node, rn_work);
 	struct ocfs2_super *osb = rn->rn_osb;

 	trace_ocfs2_recover_node(rn->rn_node_num, rn->rn_slot_num,
@@ -1649,7 +1674,13 @@ static int ocfs2_recover_node(struct
ocfs2_recovery_node *rn)

 	status = 0;
 done:
-	return status;
+	ocfs2_recovery_node_clear(rn);
+	if (status) {
+		mlog(ML_ERROR, "Error %d recovering node %d on device "
+		     "(%u,%u)!\n", status, rn->rn_node_num,
+		     MAJOR(osb->sb->s_dev), MINOR(osb->sb->s_dev));
+		mlog(ML_ERROR, "Volume requires unmount.\n");
+	}
 }

 /* Test node liveness by trylocking his journal. If we get the lock,
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 4447964..fe8e7eb 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -38,6 +38,12 @@ enum ocfs2_journal_state {
 struct ocfs2_super;
 struct ocfs2_dinode;

+enum ocfs2_recovery_state {
+	OCFS2REC_DONE = 0,
+	OCFS2REC_NEEDED,
+	OCFS2REC_IN_PROGRESS,
+};
+
 /*
  * The recovery_list is a simple linked list of node numbers to recover.
  * It is protected by the recovery_lock.
@@ -47,6 +53,8 @@ struct ocfs2_recovery_node {
 	struct ocfs2_super *rn_osb;
 	int rn_node_num;
 	int rn_slot_num;
+	enum ocfs2_recovery_state rn_state;
+	struct work_struct rn_work;
 	struct list_head rn_list;
 };

-- 
1.7.6
