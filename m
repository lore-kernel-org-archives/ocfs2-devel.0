From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 19 Nov 2010 14:56:43 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: check lockres owner in handler path
Message-ID: <201011190658.oAILihmm013474@acsinet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We have check lockres owner in handler path because the owner can change
during that time.

In case this node is in progress of unmount, it does migrations with
other node. If one of the migration target get crashed before the
migration finishes, recovery happens on this lockres. If this node is
not the (dlm) recovery master, it can lost the ownership.
On the other hand, in case another node is in progress of migration, and
this node is not the target. if the node doing unmount crashed,  This
node can gain the ownership if it becomes the recovery master.
So we should take care the above cases.
Also the ownership can move between two other different nodes. We
don't care that.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/dlm/dlmconvert.c |    9 +++++++++
 fs/ocfs2/dlm/dlmlock.c    |   10 ++++++++++
 fs/ocfs2/dlm/dlmunlock.c  |   33 +++++++++++++++++++++++++++------
 3 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmconvert.c b/fs/ocfs2/dlm/dlmconvert.c
index 9f30491..6d04a0e 100644
--- a/fs/ocfs2/dlm/dlmconvert.c
+++ b/fs/ocfs2/dlm/dlmconvert.c
@@ -279,6 +279,15 @@ enum dlm_status dlmconvert_remote(struct dlm_ctxt *dlm,
 	}
 	/* will exit this call with spinlock held */
 	__dlm_wait_on_lockres(res);
+	/*
+	 * see comments in dlmunlock_common() for why this node can take
+	 * ownership
+	 */
+	if (unlikely(res->owner == dlm->node_num)) {
+		mlog(ML_NOTICE, "owner changed\n");
+		status = DLM_FORWARD;
+		goto bail;
+	}
 
 	if (lock->ml.convert_type != LKM_IVMODE) {
 		__dlm_print_one_lock_resource(res);
diff --git a/fs/ocfs2/dlm/dlmlock.c b/fs/ocfs2/dlm/dlmlock.c
index 69cf369..4068e9e 100644
--- a/fs/ocfs2/dlm/dlmlock.c
+++ b/fs/ocfs2/dlm/dlmlock.c
@@ -232,6 +232,16 @@ static enum dlm_status dlmlock_remote(struct dlm_ctxt *dlm,
 
 	/* will exit this call with spinlock held */
 	__dlm_wait_on_lockres(res);
+	/*
+	 * see comments in dlmunlock_common() for why this node can take
+	 * ownership
+	 */
+	if (unlikely(res->owner == dlm->node_num)) {
+		spin_unlock(&res->spinlock);
+		mlog(ML_NOTICE, "onwer changed\n");
+		return DLM_FORWARD;
+	}
+
 	res->state |= DLM_LOCK_RES_IN_PROGRESS;
 
 	/* add lock to local (secondary) queue */
diff --git a/fs/ocfs2/dlm/dlmunlock.c b/fs/ocfs2/dlm/dlmunlock.c
index a45be2f..7439582 100644
--- a/fs/ocfs2/dlm/dlmunlock.c
+++ b/fs/ocfs2/dlm/dlmunlock.c
@@ -104,17 +104,12 @@ static enum dlm_status dlmunlock_common(struct dlm_ctxt *dlm,
 {
 	enum dlm_status status;
 	int actions = 0;
-	int in_use, can_block;
+	int in_use, can_block, owner_changed = 0;
         u8 owner;
 
 	mlog(0, "master_node = %d, valblk = %d\n", master_node,
 	     flags & LKM_VALBLK);
 
-	if (master_node)
-		BUG_ON(res->owner != dlm->node_num);
-	else
-		BUG_ON(res->owner == dlm->node_num);
-
 	spin_lock(&dlm->ast_lock);
 	/* We want to be sure that we're not freeing a lock
 	 * that still has AST's pending... */
@@ -154,6 +149,32 @@ static enum dlm_status dlmunlock_common(struct dlm_ctxt *dlm,
 		goto leave;
 	}
 
+	/*
+	 * In case this node is in progress of unmount, it does migrations with
+	 * other node. If one of the migration target get crashed before the
+	 * migration finishes, recovery happens on this lockres. If this node is
+	 * not the (dlm) recovery master, it can lost the ownership.
+	 * On the other hand, in case another node is in progress of migration, and
+	 * this node is not the target. if the node doing unmount crashed,  This
+	 * node can gain the ownership if it becomes the recovery master.
+	 * So we should take care the above cases.
+	 * Also the ownership can move between two other different nodes. We
+	 * don't care that.
+	 */ 
+	if (master_node) {
+		if (unlikely(res->owner != dlm->node_num))
+			owner_changed = 1;
+	} else {
+		if (unlikely(res->owner == dlm->node_num)) 
+			owner_changed = 1;
+	}
+
+	if (owner_changed) {
+		mlog(ML_NOTICE, "onwer changed\n");
+		status = DLM_FORWARD;
+		goto leave;
+	}
+
 	/* see above for what the spec says about
 	 * LKM_CANCEL and the lock queue state */
 	if (flags & LKM_CANCEL)
-- 
1.7.2.3
