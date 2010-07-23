From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 23 Jul 2010 20:15:57 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: avoid incorrect bit set in refmap
	on recovery master
Message-ID: <201007231218.o6N8t0CD005308@acsinet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In the following situation, there remains an incorrect bit in refmap on the
recovery master. Finally the recovery master will fail at purging the lockres
due to the incorrect bit in refmap.

1) node A has no interest on lockres A any longer, so it is purging it.
2) the owner of lockres A is node B, so node A is sending de-ref message
to node B.
3) at this time, node B crashed. node C becomes the recovery master. it recovers
lockres A(because the master is the dead node B).
4) node A migrated lockres A to node C with a refbit there.
5) node A failed to send de-ref message to node B because it crashed. The failure
is ignored. no other action is done for lockres A any more.

For mormal, re-send the deref message to it to recovery master can fix it. Well,
ignoring the failure of deref to the original master and not recovering the lockres
to recovery master has the same effect. And the later is simpler.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/dlm/dlmrecovery.c |   17 +++++++++++++++--
 fs/ocfs2/dlm/dlmthread.c   |   28 +++++++++++++++++-----------
 2 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 9dfaac7..06640f6 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1997,6 +1997,8 @@ void dlm_move_lockres_to_recovery_list(struct dlm_ctxt *dlm,
 	struct list_head *queue;
 	struct dlm_lock *lock, *next;
 
+	assert_spin_locked(&dlm->spinlock);
+	assert_spin_locked(&res->spinlock);
 	res->state |= DLM_LOCK_RES_RECOVERING;
 	if (!list_empty(&res->recovering)) {
 		mlog(0,
@@ -2336,9 +2338,20 @@ static void dlm_do_local_recovery_cleanup(struct dlm_ctxt *dlm, u8 dead_node)
 
 				/* the wake_up for this will happen when the
 				 * RECOVERING flag is dropped later */
-				res->state &= ~DLM_LOCK_RES_DROPPING_REF;
+				if (res->state & DLM_LOCK_RES_DROPPING_REF) {
+					/*
+					 * don't migrate a lockres which is in
+					 * progress of dropping ref
+					 */
+					mlog(ML_NOTICE, "%.*s ignored for "
+					     "migration\n", res->lockname.len,
+					     res->lockname.name);
+					res->state &=
+						~DLM_LOCK_RES_DROPPING_REF;
+				} else
+					dlm_move_lockres_to_recovery_list(dlm,
+									  res);
 
-				dlm_move_lockres_to_recovery_list(dlm, res);
 			} else if (res->owner == dlm->node_num) {
 				dlm_free_dead_locks(dlm, res, dead_node);
 				__dlm_lockres_calc_usage(dlm, res);
diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
index dd78ca3..47420ce 100644
--- a/fs/ocfs2/dlm/dlmthread.c
+++ b/fs/ocfs2/dlm/dlmthread.c
@@ -92,17 +92,23 @@ int __dlm_lockres_has_locks(struct dlm_lock_resource *res)
  * truly ready to be freed. */
 int __dlm_lockres_unused(struct dlm_lock_resource *res)
 {
-	if (!__dlm_lockres_has_locks(res) &&
-	    (list_empty(&res->dirty) && !(res->state & DLM_LOCK_RES_DIRTY))) {
-		/* try not to scan the bitmap unless the first two
-		 * conditions are already true */
-		int bit = find_next_bit(res->refmap, O2NM_MAX_NODES, 0);
-		if (bit >= O2NM_MAX_NODES) {
-			/* since the bit for dlm->node_num is not
-			 * set, inflight_locks better be zero */
-			BUG_ON(res->inflight_locks != 0);
-			return 1;
-		}
+	int bit;
+
+	if (__dlm_lockres_has_locks(res))
+		return 0;
+
+	if (!list_empty(&res->dirty) || res->state & DLM_LOCK_RES_DIRTY)
+		return 0;
+
+	if (res->state & DLM_LOCK_RES_RECOVERING)
+		return 0;
+
+	bit = find_next_bit(res->refmap, O2NM_MAX_NODES, 0);
+	if (bit >= O2NM_MAX_NODES) {
+		/* since the bit for dlm->node_num is not
+		 * set, inflight_locks better be zero */
+		BUG_ON(res->inflight_locks != 0);
+		return 1;
 	}
 	return 0;
 }
-- 
1.7.1.1
