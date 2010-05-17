From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Mon, 17 May 2010 20:20:44 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2:dlm: avoid dlm->ast_lock
	lockres->spinlock dependency break
Message-ID: <201005171221.o4H8oUwB022995@rcsinet13.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Currently we process a dirty lockres with the lockres->spinlock taken. While
during the process, we may need to lock on dlm->ast_lock. This breaks the
dependency of dlm->ast_lock(lock first) and lockres->spinlock(lock second).

This patch fixes the problem.
Since we can't release lockres->spinlock, we have to take dlm->ast_lock
just before taking the lockres->spinlock and release it after lockres->spinlock
is released. And use __dlm_queue_bast()/__dlm_queue_ast(), the nolock version,
in dlm_shuffle_lists(). There are no too many locks on a lockres, so there is no
performance harm.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/dlm/dlmast.c    |    4 ++--
 fs/ocfs2/dlm/dlmcommon.h |    2 ++
 fs/ocfs2/dlm/dlmthread.c |   16 ++++++++++------
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmast.c b/fs/ocfs2/dlm/dlmast.c
index 12d5eb7..992b0ae 100644
--- a/fs/ocfs2/dlm/dlmast.c
+++ b/fs/ocfs2/dlm/dlmast.c
@@ -88,7 +88,7 @@ static int dlm_should_cancel_bast(struct dlm_ctxt *dlm, struct dlm_lock *lock)
 	return 0;
 }
 
-static void __dlm_queue_ast(struct dlm_ctxt *dlm, struct dlm_lock *lock)
+void __dlm_queue_ast(struct dlm_ctxt *dlm, struct dlm_lock *lock)
 {
 	mlog_entry_void();
 
@@ -145,7 +145,7 @@ void dlm_queue_ast(struct dlm_ctxt *dlm, struct dlm_lock *lock)
 }
 
 
-static void __dlm_queue_bast(struct dlm_ctxt *dlm, struct dlm_lock *lock)
+void __dlm_queue_bast(struct dlm_ctxt *dlm, struct dlm_lock *lock)
 {
 	mlog_entry_void();
 
diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index 0102be3..453d955 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -904,6 +904,8 @@ void __dlm_lockres_grab_inflight_ref(struct dlm_ctxt *dlm,
 
 void dlm_queue_ast(struct dlm_ctxt *dlm, struct dlm_lock *lock);
 void dlm_queue_bast(struct dlm_ctxt *dlm, struct dlm_lock *lock);
+void __dlm_queue_ast(struct dlm_ctxt *dlm, struct dlm_lock *lock);
+void __dlm_queue_bast(struct dlm_ctxt *dlm, struct dlm_lock *lock);
 void dlm_do_local_ast(struct dlm_ctxt *dlm,
 		      struct dlm_lock_resource *res,
 		      struct dlm_lock *lock);
diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
index 11a6d1f..d4f73ca 100644
--- a/fs/ocfs2/dlm/dlmthread.c
+++ b/fs/ocfs2/dlm/dlmthread.c
@@ -309,6 +309,7 @@ static void dlm_shuffle_lists(struct dlm_ctxt *dlm,
 	 * spinlock, and because we know that it is not migrating/
 	 * recovering/in-progress, it is fine to reserve asts and
 	 * basts right before queueing them all throughout */
+	assert_spin_locked(&dlm->ast_lock);
 	assert_spin_locked(&res->spinlock);
 	BUG_ON((res->state & (DLM_LOCK_RES_MIGRATING|
 			      DLM_LOCK_RES_RECOVERING|
@@ -337,7 +338,7 @@ converting:
 			/* queue the BAST if not already */
 			if (lock->ml.highest_blocked == LKM_IVMODE) {
 				__dlm_lockres_reserve_ast(res);
-				dlm_queue_bast(dlm, lock);
+				__dlm_queue_bast(dlm, lock);
 			}
 			/* update the highest_blocked if needed */
 			if (lock->ml.highest_blocked < target->ml.convert_type)
@@ -355,7 +356,7 @@ converting:
 			can_grant = 0;
 			if (lock->ml.highest_blocked == LKM_IVMODE) {
 				__dlm_lockres_reserve_ast(res);
-				dlm_queue_bast(dlm, lock);
+				__dlm_queue_bast(dlm, lock);
 			}
 			if (lock->ml.highest_blocked < target->ml.convert_type)
 				lock->ml.highest_blocked =
@@ -383,7 +384,7 @@ converting:
 		spin_unlock(&target->spinlock);
 
 		__dlm_lockres_reserve_ast(res);
-		dlm_queue_ast(dlm, target);
+		__dlm_queue_ast(dlm, target);
 		/* go back and check for more */
 		goto converting;
 	}
@@ -402,7 +403,7 @@ blocked:
 			can_grant = 0;
 			if (lock->ml.highest_blocked == LKM_IVMODE) {
 				__dlm_lockres_reserve_ast(res);
-				dlm_queue_bast(dlm, lock);
+				__dlm_queue_bast(dlm, lock);
 			}
 			if (lock->ml.highest_blocked < target->ml.type)
 				lock->ml.highest_blocked = target->ml.type;
@@ -418,7 +419,7 @@ blocked:
 			can_grant = 0;
 			if (lock->ml.highest_blocked == LKM_IVMODE) {
 				__dlm_lockres_reserve_ast(res);
-				dlm_queue_bast(dlm, lock);
+				__dlm_queue_bast(dlm, lock);
 			}
 			if (lock->ml.highest_blocked < target->ml.type)
 				lock->ml.highest_blocked = target->ml.type;
@@ -444,7 +445,7 @@ blocked:
 		spin_unlock(&target->spinlock);
 
 		__dlm_lockres_reserve_ast(res);
-		dlm_queue_ast(dlm, target);
+		__dlm_queue_ast(dlm, target);
 		/* go back and check for more */
 		goto converting;
 	}
@@ -674,6 +675,7 @@ static int dlm_thread(void *data)
 		 	/* lockres can be re-dirtied/re-added to the
 			 * dirty_list in this gap, but that is ok */
 
+			spin_lock(&dlm->ast_lock);
 			spin_lock(&res->spinlock);
 			if (res->owner != dlm->node_num) {
 				__dlm_print_one_lock_resource(res);
@@ -694,6 +696,7 @@ static int dlm_thread(void *data)
 				/* move it to the tail and keep going */
 				res->state &= ~DLM_LOCK_RES_DIRTY;
 				spin_unlock(&res->spinlock);
+				spin_unlock(&dlm->ast_lock);
 				mlog(0, "delaying list shuffling for in-"
 				     "progress lockres %.*s, state=%d\n",
 				     res->lockname.len, res->lockname.name,
@@ -715,6 +718,7 @@ static int dlm_thread(void *data)
 			dlm_shuffle_lists(dlm, res);
 			res->state &= ~DLM_LOCK_RES_DIRTY;
 			spin_unlock(&res->spinlock);
+			spin_unlock(&dlm->ast_lock);
 
 			dlm_lockres_calc_usage(dlm, res);
 
-- 
1.6.6.1
