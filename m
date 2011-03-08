From: xiaowei.hu at oracle.com <xiaowei.hu@oracle.com>
Date: Tue,  8 Mar 2011 13:32:07 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Fix a potential piece of code that may
	induce kernel bug.
Message-ID: <1299562327-21019-1-git-send-email-xiaowei.hu@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: XiaoweiHu <xiaowei.hu@oracle.com>

In function dlm_migrate_lockres, it calls dlm_add_migration_mle() before 
the dlm_add_migration_mle() ,this dlm_add_migration_mle() should make sure 
the lockres is not dirty ,if it is dirty wait until it becomes undirty, 
and then mark this lockres as migrating. but the dlm_add_migration_mle() 
doesn't check this dirty flag , it just adds the mle with migrate type, 
this could have problem, if the migrate target dean at this point then 
another node becames the recovery master, current node will migrate this 
lockres to the recovery master ,no matter if it is in the dirty list.
So this makes the lockres in the dirty lists but this owner becomes the 
recovery master, then panic.

Signed-off-by: XiaoweiHu <xiaowei.hu@oracle.com>
Reviewed-by: WengangWang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/dlm/dlmmaster.c |   62 +++++++++++++++++++++++-----------------------
 1 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 59f0f6b..bdb2323 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -2402,6 +2402,16 @@ leave:
 	return ret;
 }
 
+static int dlm_lockres_is_dirty(struct dlm_ctxt *dlm,
+				struct dlm_lock_resource *res)
+{
+	int ret;
+	spin_lock(&res->spinlock);
+	ret = !!(res->state & DLM_LOCK_RES_DIRTY);
+	spin_unlock(&res->spinlock);
+	return ret;
+}
+
 /*
  * DLM_MIGRATE_LOCKRES
  */
@@ -2463,6 +2473,20 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
 	}
 	ret = 0;
 
+	/* moved this out from dlm_mark_lockres_migrating,
+	 * to pervent the local recovery handler, migrate a dirty lockres.*/
+
+	/* now flush all the pending asts */
+	dlm_kick_thread(dlm, res);
+	/* before waiting on DIRTY, block processes which may
+	 * try to dirty the lockres before MIGRATING is set */
+	spin_lock(&res->spinlock);
+	BUG_ON(res->state & DLM_LOCK_RES_BLOCK_DIRTY);
+	res->state |= DLM_LOCK_RES_BLOCK_DIRTY;
+	spin_unlock(&res->spinlock);
+	/* now wait on any pending asts and the DIRTY state */
+	wait_event(dlm->ast_wq, !dlm_lockres_is_dirty(dlm, res));
+
 	/*
 	 * find a node to migrate the lockres to
 	 */
@@ -2521,6 +2545,13 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
 	}
 
 fail:
+	/* now no matter if it fails or not the block dirty state needs to
+	 * be cleared.*/
+	spin_lock(&res->spinlock);
+	BUG_ON(!(res->state & DLM_LOCK_RES_BLOCK_DIRTY));
+	res->state &= ~DLM_LOCK_RES_BLOCK_DIRTY;
+	spin_unlock(&res->spinlock);
+
 	if (oldmle) {
 		/* master is known, detach if not already detached */
 		dlm_mle_detach_hb_events(dlm, oldmle);
@@ -2748,16 +2779,6 @@ static int dlm_migration_can_proceed(struct dlm_ctxt *dlm,
 	return can_proceed;
 }
 
-static int dlm_lockres_is_dirty(struct dlm_ctxt *dlm,
-				struct dlm_lock_resource *res)
-{
-	int ret;
-	spin_lock(&res->spinlock);
-	ret = !!(res->state & DLM_LOCK_RES_DIRTY);
-	spin_unlock(&res->spinlock);
-	return ret;
-}
-
 
 static int dlm_mark_lockres_migrating(struct dlm_ctxt *dlm,
 				       struct dlm_lock_resource *res,
@@ -2778,16 +2799,6 @@ static int dlm_mark_lockres_migrating(struct dlm_ctxt *dlm,
 	__dlm_lockres_reserve_ast(res);
 	spin_unlock(&res->spinlock);
 
-	/* now flush all the pending asts */
-	dlm_kick_thread(dlm, res);
-	/* before waiting on DIRTY, block processes which may
-	 * try to dirty the lockres before MIGRATING is set */
-	spin_lock(&res->spinlock);
-	BUG_ON(res->state & DLM_LOCK_RES_BLOCK_DIRTY);
-	res->state |= DLM_LOCK_RES_BLOCK_DIRTY;
-	spin_unlock(&res->spinlock);
-	/* now wait on any pending asts and the DIRTY state */
-	wait_event(dlm->ast_wq, !dlm_lockres_is_dirty(dlm, res));
 	dlm_lockres_release_ast(dlm, res);
 
 	mlog(0, "about to wait on migration_wq, dirty=%s\n",
@@ -2823,17 +2834,6 @@ again:
 	}
 	spin_unlock(&dlm->spinlock);
 
-	/*
-	 * if target is down, we need to clear DLM_LOCK_RES_BLOCK_DIRTY for
-	 * another try; otherwise, we are sure the MIGRATING state is there,
-	 * drop the unneded state which blocked threads trying to DIRTY
-	 */
-	spin_lock(&res->spinlock);
-	BUG_ON(!(res->state & DLM_LOCK_RES_BLOCK_DIRTY));
-	res->state &= ~DLM_LOCK_RES_BLOCK_DIRTY;
-	if (!ret)
-		BUG_ON(!(res->state & DLM_LOCK_RES_MIGRATING));
-	spin_unlock(&res->spinlock);
 
 	/*
 	 * at this point:
-- 
1.7.0.4
