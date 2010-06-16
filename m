From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Tue, 15 Jun 2010 21:43:02 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2 fix o2dlm dlm run purgelist
Message-ID: <1276663383-8238-1-git-send-email-srinivas.eeda@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

There are two problems in dlm_run_purgelist

1. If a lockres is found to be in use, dlm_run_purgelist keeps trying to purge
the same lockres instead of trying the next lockres.

2. When a lockres is found unused, dlm_run_purgelist releases lockres spinlock
before setting DLM_LOCK_RES_DROPPING_REF and calls dlm_purge_lockres.
spinlock is reacquired but in this window lockres can get reused. This leads
to BUG.

This patch modifies dlm_run_purgelist to skip lockres if it's in use and purge
 next lockres. It also sets DLM_LOCK_RES_DROPPING_REF before releasing the
lockres spinlock protecting it from getting reused.

Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
---
 fs/ocfs2/dlm/dlmthread.c |  125 +++++++++++++++++++++++-----------------------
 1 files changed, 63 insertions(+), 62 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
index 11a6d1f..fb0be6c 100644
--- a/fs/ocfs2/dlm/dlmthread.c
+++ b/fs/ocfs2/dlm/dlmthread.c
@@ -158,39 +158,17 @@ static int dlm_purge_lockres(struct dlm_ctxt *dlm,
 	int master;
 	int ret = 0;
 
-	spin_lock(&res->spinlock);
-	if (!__dlm_lockres_unused(res)) {
-		mlog(0, "%s:%.*s: tried to purge but not unused\n",
-		     dlm->name, res->lockname.len, res->lockname.name);
-		__dlm_print_one_lock_resource(res);
-		spin_unlock(&res->spinlock);
-		BUG();
-	}
-
-	if (res->state & DLM_LOCK_RES_MIGRATING) {
-		mlog(0, "%s:%.*s: Delay dropref as this lockres is "
-		     "being remastered\n", dlm->name, res->lockname.len,
-		     res->lockname.name);
-		/* Re-add the lockres to the end of the purge list */
-		if (!list_empty(&res->purge)) {
-			list_del_init(&res->purge);
-			list_add_tail(&res->purge, &dlm->purge_list);
-		}
-		spin_unlock(&res->spinlock);
-		return 0;
-	}
-
 	master = (res->owner == dlm->node_num);
 
 	if (!master)
 		res->state |= DLM_LOCK_RES_DROPPING_REF;
-	spin_unlock(&res->spinlock);
 
 	mlog(0, "purging lockres %.*s, master = %d\n", res->lockname.len,
 	     res->lockname.name, master);
 
 	if (!master) {
 		/* drop spinlock...  retake below */
+		spin_unlock(&res->spinlock);
 		spin_unlock(&dlm->spinlock);
 
 		spin_lock(&res->spinlock);
@@ -208,48 +186,37 @@ static int dlm_purge_lockres(struct dlm_ctxt *dlm,
 		mlog(0, "%s:%.*s: dlm_deref_lockres returned %d\n",
 		     dlm->name, res->lockname.len, res->lockname.name, ret);
 		spin_lock(&dlm->spinlock);
+		spin_lock(&res->spinlock);
 	}
 
-	spin_lock(&res->spinlock);
-	if (!list_empty(&res->purge)) {
-		mlog(0, "removing lockres %.*s:%p from purgelist, "
-		     "master = %d\n", res->lockname.len, res->lockname.name,
-		     res, master);
-		list_del_init(&res->purge);
-		spin_unlock(&res->spinlock);
-		dlm_lockres_put(res);
-		dlm->purge_count--;
-	} else
-		spin_unlock(&res->spinlock);
-
-	__dlm_unhash_lockres(res);
-
 	/* lockres is not in the hash now.  drop the flag and wake up
 	 * any processes waiting in dlm_get_lock_resource. */
-	if (!master) {
-		spin_lock(&res->spinlock);
+	if (!master)
 		res->state &= ~DLM_LOCK_RES_DROPPING_REF;
-		spin_unlock(&res->spinlock);
-		wake_up(&res->wq);
-	}
 	return 0;
 }
 
 static void dlm_run_purge_list(struct dlm_ctxt *dlm,
 			       int purge_now)
 {
-	unsigned int run_max, unused;
+	unsigned int run_max;
 	unsigned long purge_jiffies;
 	struct dlm_lock_resource *lockres;
+	struct dlm_lock_resource *nextres;
 
 	spin_lock(&dlm->spinlock);
 	run_max = dlm->purge_count;
 
-	while(run_max && !list_empty(&dlm->purge_list)) {
-		run_max--;
+	if (list_empty(&dlm->purge_list)) {
+		spin_unlock(&dlm->spinlock);
+		return;
+	}
+
+	lockres = list_entry(dlm->purge_list.next,
+			     struct dlm_lock_resource, purge);
 
-		lockres = list_entry(dlm->purge_list.next,
-				     struct dlm_lock_resource, purge);
+	while(run_max && lockres && !list_empty(&dlm->purge_list)) {
+		run_max--;
 
 		/* Status of the lockres *might* change so double
 		 * check. If the lockres is unused, holding the dlm
@@ -257,15 +224,12 @@ static void dlm_run_purge_list(struct dlm_ctxt *dlm,
 		 * refs on it -- there's no need to keep the lockres
 		 * spinlock. */
 		spin_lock(&lockres->spinlock);
-		unused = __dlm_lockres_unused(lockres);
-		spin_unlock(&lockres->spinlock);
-
-		if (!unused)
-			continue;
 
 		purge_jiffies = lockres->last_used +
 			msecs_to_jiffies(DLM_PURGE_INTERVAL_MS);
 
+		mlog(0, "purging lockres %.*s\n", lockres->lockname.len,
+		     lockres->lockname.name);
 		/* Make sure that we want to be processing this guy at
 		 * this time. */
 		if (!purge_now && time_after(purge_jiffies, jiffies)) {
@@ -273,20 +237,57 @@ static void dlm_run_purge_list(struct dlm_ctxt *dlm,
 			 * in tail order, we can stop at the first
 			 * unpurgable resource -- anyone added after
 			 * him will have a greater last_used value */
+			spin_unlock(&lockres->spinlock);
 			break;
 		}
 
-		dlm_lockres_get(lockres);
-
+		/* If lockres is being used, or migrating purge next lockres */
+		if (!__dlm_lockres_unused(lockres) ||
+		    (lockres->state & DLM_LOCK_RES_MIGRATING)) {
+			if (!list_is_last(&lockres->purge, &dlm->purge_list))
+				nextres = list_entry(lockres->purge.next,
+					     struct dlm_lock_resource, purge);
+			else
+				nextres = NULL;
+			spin_unlock(&lockres->spinlock);
+			lockres = nextres;
+			continue;
+		}
+		
 		/* This may drop and reacquire the dlm spinlock if it
 		 * has to do migration. */
-		if (dlm_purge_lockres(dlm, lockres))
-			BUG();
-
-		dlm_lockres_put(lockres);
-
-		/* Avoid adding any scheduling latencies */
-		cond_resched_lock(&dlm->spinlock);
+		dlm_purge_lockres(dlm, lockres);
+		
+		/* before we free the lockres we get the next lockres */
+		if (list_empty(&lockres->purge))
+			/* Shouldn't be in this state. Start from beginning */
+			nextres = list_entry(dlm->purge_list.next,
+					     struct dlm_lock_resource, purge);
+		else if (!list_is_last(&lockres->purge, &dlm->purge_list))
+			nextres = list_entry(lockres->purge.next,
+					     struct dlm_lock_resource, purge);
+		else
+			nextres = NULL;
+
+		if (__dlm_lockres_unused(lockres)) {
+			if (!list_empty(&lockres->purge)) {
+				list_del_init(&lockres->purge);
+				dlm->purge_count--;
+			}
+			__dlm_unhash_lockres(lockres);
+			spin_unlock(&lockres->spinlock);
+			wake_up(&lockres->wq);
+			dlm_lockres_put(lockres);
+		} else
+			spin_unlock(&lockres->spinlock);
+		lockres = nextres;
+
+		/* Avoid adding any scheduling latencies. If dlm spinlock is
+		 * dropped, retry again from the beginning as purgelist could
+		 * have been modified */
+		if (cond_resched_lock(&dlm->spinlock))
+			lockres = list_entry(dlm->purge_list.next,
+					     struct dlm_lock_resource, purge);
 	}
 
 	spin_unlock(&dlm->spinlock);
@@ -733,7 +734,7 @@ in_progress:
 			/* unlikely, but we may need to give time to
 			 * other tasks */
 			if (!--n) {
-				mlog(0, "throttling dlm_thread\n");
+				mlog(0, "throttling dlm_thread n=%d\n", n);
 				break;
 			}
 		}
-- 
1.5.6.5
