From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 14 Jul 2011 15:50:20 -0700
Subject: [Ocfs2-devel] [PATCH 09/16] ocfs2/dlm: Take inflight reference
	count for remotely mastered resources too
In-Reply-To: <1310683827-19157-1-git-send-email-sunil.mushran@oracle.com>
References: <1310683827-19157-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1310683827-19157-10-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The inflight reference count, in the lock resource, is taken to pin the resource
in memory. We take it when a new resource is created and release it after a
lock is attached to it. We do this to prevent the resource from getting purged
prematurely.

Earlier this reference count was being taken for locally mastered resources
only. This patch extends the same functionality for remotely mastered ones.

We are doing this because the same premature purging could occur for remotely
mastered resources if the remote node were to die before completion of the
create lock.

Fix for Oracle bug#12405575.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmlock.c   |   12 +++++++---
 fs/ocfs2/dlm/dlmmaster.c |   47 ++++++++++++++++-----------------------------
 fs/ocfs2/dlm/dlmthread.c |   12 ++++++----
 3 files changed, 32 insertions(+), 39 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmlock.c b/fs/ocfs2/dlm/dlmlock.c
index c7f3e22..3ef2c1a 100644
--- a/fs/ocfs2/dlm/dlmlock.c
+++ b/fs/ocfs2/dlm/dlmlock.c
@@ -183,10 +183,6 @@ static enum dlm_status dlmlock_master(struct dlm_ctxt *dlm,
 			kick_thread = 1;
 		}
 	}
-	/* reduce the inflight count, this may result in the lockres
-	 * being purged below during calc_usage */
-	if (lock->ml.node == dlm->node_num)
-		dlm_lockres_drop_inflight_ref(dlm, res);
 
 	spin_unlock(&res->spinlock);
 	wake_up(&res->wq);
@@ -737,6 +733,14 @@ retry_lock:
 			}
 		}
 
+		/* Inflight taken in dlm_get_lock_resource() is dropped here */
+		spin_lock(&res->spinlock);
+		dlm_lockres_drop_inflight_ref(dlm, res);
+		spin_unlock(&res->spinlock);
+
+		dlm_lockres_calc_usage(dlm, res);
+		dlm_kick_thread(dlm, res);
+
 		if (status != DLM_NORMAL) {
 			lock->lksb->flags &= ~DLM_LKSB_GET_LVB;
 			if (status != DLM_NOTQUEUED)
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 11e446f..005261c 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -659,11 +659,8 @@ void dlm_lockres_grab_inflight_ref(struct dlm_ctxt *dlm,
 {
 	assert_spin_locked(&res->spinlock);
 
-	if (!test_bit(dlm->node_num, res->refmap)) {
-		BUG_ON(res->inflight_locks != 0);
-		dlm_lockres_set_refmap_bit(dlm, res, dlm->node_num);
-	}
 	res->inflight_locks++;
+
 	mlog(0, "%s: res %.*s, inflight++: now %u, %ps()\n", dlm->name,
 	     res->lockname.len, res->lockname.name, res->inflight_locks,
 	     __builtin_return_address(0));
@@ -677,12 +674,11 @@ void dlm_lockres_drop_inflight_ref(struct dlm_ctxt *dlm,
 	BUG_ON(res->inflight_locks == 0);
 
 	res->inflight_locks--;
+
 	mlog(0, "%s: res %.*s, inflight--: now %u, %ps()\n", dlm->name,
 	     res->lockname.len, res->lockname.name, res->inflight_locks,
 	     __builtin_return_address(0));
 
-	if (res->inflight_locks == 0)
-		dlm_lockres_clear_refmap_bit(dlm, res, dlm->node_num);
 	wake_up(&res->wq);
 }
 
@@ -716,7 +712,6 @@ struct dlm_lock_resource * dlm_get_lock_resource(struct dlm_ctxt *dlm,
 	unsigned int hash;
 	int tries = 0;
 	int bit, wait_on_recovery = 0;
-	int drop_inflight_if_nonlocal = 0;
 
 	BUG_ON(!lockid);
 
@@ -728,36 +723,33 @@ lookup:
 	spin_lock(&dlm->spinlock);
 	tmpres = __dlm_lookup_lockres_full(dlm, lockid, namelen, hash);
 	if (tmpres) {
-		int dropping_ref = 0;
-
 		spin_unlock(&dlm->spinlock);
-
 		spin_lock(&tmpres->spinlock);
-		/* We wait for the other thread that is mastering the resource */
+		/* Wait on the thread that is mastering the resource */
 		if (tmpres->owner == DLM_LOCK_RES_OWNER_UNKNOWN) {
 			__dlm_wait_on_lockres(tmpres);
 			BUG_ON(tmpres->owner == DLM_LOCK_RES_OWNER_UNKNOWN);
+			spin_unlock(&tmpres->spinlock);
+			dlm_lockres_put(tmpres);
+			tmpres = NULL;
+			goto lookup;
 		}
 
-		if (tmpres->owner == dlm->node_num) {
-			BUG_ON(tmpres->state & DLM_LOCK_RES_DROPPING_REF);
-			dlm_lockres_grab_inflight_ref(dlm, tmpres);
-		} else if (tmpres->state & DLM_LOCK_RES_DROPPING_REF)
-			dropping_ref = 1;
-		spin_unlock(&tmpres->spinlock);
-
-		/* wait until done messaging the master, drop our ref to allow
-		 * the lockres to be purged, start over. */
-		if (dropping_ref) {
-			spin_lock(&tmpres->spinlock);
-			__dlm_wait_on_lockres_flags(tmpres, DLM_LOCK_RES_DROPPING_REF);
+		/* Wait on the resource purge to complete before continuing */
+		if (tmpres->state & DLM_LOCK_RES_DROPPING_REF) {
+			BUG_ON(tmpres->owner == dlm->node_num);
+			__dlm_wait_on_lockres_flags(tmpres,
+						    DLM_LOCK_RES_DROPPING_REF);
 			spin_unlock(&tmpres->spinlock);
 			dlm_lockres_put(tmpres);
 			tmpres = NULL;
 			goto lookup;
 		}
 
-		mlog(0, "found in hash!\n");
+		/* Grab inflight ref to pin the resource */
+		dlm_lockres_grab_inflight_ref(dlm, tmpres);
+
+		spin_unlock(&tmpres->spinlock);
 		if (res)
 			dlm_lockres_put(res);
 		res = tmpres;
@@ -863,14 +855,11 @@ lookup:
 	/* finally add the lockres to its hash bucket */
 	__dlm_insert_lockres(dlm, res);
 
+	/* Grab inflight ref to pin the resource */
 	spin_lock(&res->spinlock);
 	dlm_lockres_grab_inflight_ref(dlm, res);
 	spin_unlock(&res->spinlock);
 
-	/* if this node does not become the master make sure to drop
-	 * this inflight reference below */
-	drop_inflight_if_nonlocal = 1;
-
 	/* get an extra ref on the mle in case this is a BLOCK
 	 * if so, the creator of the BLOCK may try to put the last
 	 * ref at this time in the assert master handler, so we
@@ -973,8 +962,6 @@ wait:
 
 wake_waiters:
 	spin_lock(&res->spinlock);
-	if (res->owner != dlm->node_num && drop_inflight_if_nonlocal)
-		dlm_lockres_drop_inflight_ref(dlm, res);
 	res->state &= ~DLM_LOCK_RES_IN_PROGRESS;
 	spin_unlock(&res->spinlock);
 	wake_up(&res->wq);
diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
index 4eff65e..e73c833 100644
--- a/fs/ocfs2/dlm/dlmthread.c
+++ b/fs/ocfs2/dlm/dlmthread.c
@@ -94,24 +94,26 @@ int __dlm_lockres_unused(struct dlm_lock_resource *res)
 {
 	int bit;
 
+	assert_spin_locked(&res->spinlock);
+
 	if (__dlm_lockres_has_locks(res))
 		return 0;
 
+	/* Locks are in the process of being created */
+	if (res->inflight_locks)
+		return 0;
+
 	if (!list_empty(&res->dirty) || res->state & DLM_LOCK_RES_DIRTY)
 		return 0;
 
 	if (res->state & DLM_LOCK_RES_RECOVERING)
 		return 0;
 
+	/* Another node has this resource with this node as the master */
 	bit = find_next_bit(res->refmap, O2NM_MAX_NODES, 0);
 	if (bit < O2NM_MAX_NODES)
 		return 0;
 
-	/*
-	 * since the bit for dlm->node_num is not set, inflight_locks better
-	 * be zero
-	 */
-	BUG_ON(res->inflight_locks != 0);
 	return 1;
 }
 
-- 
1.7.4.1
