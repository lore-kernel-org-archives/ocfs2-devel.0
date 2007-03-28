From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Mar 28 13:29:58 2007
Subject: [Ocfs2-devel] [git patches] ocfs2 fixes
Message-ID: <20070328202952.GG2919@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Hi Linus,

	These two fixes are for ocfs2 dlm regressions introduced during the
merge window.

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/ocfs2/dlm/dlmdomain.c |    8 ++-
 fs/ocfs2/dlm/dlmmaster.c |   99 ++++++++++++++++++++++++++++++-----------------
 fs/ocfs2/dlm/dlmthread.c |   10 ----
 3 files changed, 73 insertions(+), 44 deletions(-)

Sunil Mushran:
      ocfs2_dlm: Fix lockres ref counting bug
      ocfs2_dlm: Check for migrateable lockres in dlm_empty_lockres()

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 6087c47..c558442 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -138,8 +138,10 @@ static void dlm_unregister_domain_handle
 
 void __dlm_unhash_lockres(struct dlm_lock_resource *lockres)
 {
-	hlist_del_init(&lockres->hash_node);
-	dlm_lockres_put(lockres);
+	if (!hlist_unhashed(&lockres->hash_node)) {
+		hlist_del_init(&lockres->hash_node);
+		dlm_lockres_put(lockres);
+	}
 }
 
 void __dlm_insert_lockres(struct dlm_ctxt *dlm,
@@ -655,6 +657,8 @@ void dlm_unregister_domain(struct dlm_ct
 		dlm_kick_thread(dlm, NULL);
 
 		while (dlm_migrate_all_locks(dlm)) {
+			/* Give dlm_thread time to purge the lockres' */
+			msleep(500);
 			mlog(0, "%s: more migration to do\n", dlm->name);
 		}
 		dlm_mark_domain_leaving(dlm);
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 9229e04..6edffca 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -2424,6 +2424,57 @@ static void dlm_deref_lockres_worker(str
 	dlm_lockres_put(res);
 }
 
+/* Checks whether the lockres can be migrated. Returns 0 if yes, < 0
+ * if not. If 0, numlocks is set to the number of locks in the lockres.
+ */
+static int dlm_is_lockres_migrateable(struct dlm_ctxt *dlm,
+				      struct dlm_lock_resource *res,
+				      int *numlocks)
+{
+	int ret;
+	int i;
+	int count = 0;
+	struct list_head *queue, *iter;
+	struct dlm_lock *lock;
+
+	assert_spin_locked(&res->spinlock);
+
+	ret = -EINVAL;
+	if (res->owner == DLM_LOCK_RES_OWNER_UNKNOWN) {
+		mlog(0, "cannot migrate lockres with unknown owner!\n");
+		goto leave;
+	}
+
+	if (res->owner != dlm->node_num) {
+		mlog(0, "cannot migrate lockres this node doesn't own!\n");
+		goto leave;
+	}
+
+	ret = 0;
+	queue = &res->granted;
+	for (i = 0; i < 3; i++) {
+		list_for_each(iter, queue) {
+			lock = list_entry(iter, struct dlm_lock, list);
+			++count;
+			if (lock->ml.node == dlm->node_num) {
+				mlog(0, "found a lock owned by this node still "
+				     "on the %s queue!  will not migrate this "
+				     "lockres\n", (i == 0 ? "granted" :
+						   (i == 1 ? "converting" :
+						    "blocked")));
+				ret = -ENOTEMPTY;
+				goto leave;
+			}
+		}
+		queue++;
+	}
+
+	*numlocks = count;
+	mlog(0, "migrateable lockres having %d locks\n", *numlocks);
+
+leave:
+	return ret;
+}
 
 /*
  * DLM_MIGRATE_LOCKRES
@@ -2437,14 +2488,12 @@ static int dlm_migrate_lockres(struct dl
 	struct dlm_master_list_entry *mle = NULL;
 	struct dlm_master_list_entry *oldmle = NULL;
  	struct dlm_migratable_lockres *mres = NULL;
-	int ret = -EINVAL;
+	int ret = 0;
 	const char *name;
 	unsigned int namelen;
 	int mle_added = 0;
-	struct list_head *queue, *iter;
-	int i;
-	struct dlm_lock *lock;
-	int empty = 1, wake = 0;
+	int numlocks;
+	int wake = 0;
 
 	if (!dlm_grab(dlm))
 		return -EINVAL;
@@ -2458,42 +2507,16 @@ static int dlm_migrate_lockres(struct dl
 	 * ensure this lockres is a proper candidate for migration
 	 */
 	spin_lock(&res->spinlock);
-	if (res->owner == DLM_LOCK_RES_OWNER_UNKNOWN) {
-		mlog(0, "cannot migrate lockres with unknown owner!\n");
-		spin_unlock(&res->spinlock);
-		goto leave;
-	}
-	if (res->owner != dlm->node_num) {
-		mlog(0, "cannot migrate lockres this node doesn't own!\n");
+	ret = dlm_is_lockres_migrateable(dlm, res, &numlocks);
+	if (ret < 0) {
 		spin_unlock(&res->spinlock);
 		goto leave;
 	}
-	mlog(0, "checking queues...\n");
-	queue = &res->granted;
-	for (i=0; i<3; i++) {
-		list_for_each(iter, queue) {
-			lock = list_entry (iter, struct dlm_lock, list);
-			empty = 0;
-			if (lock->ml.node == dlm->node_num) {
-				mlog(0, "found a lock owned by this node "
-				     "still on the %s queue!  will not "
-				     "migrate this lockres\n",
-				     i==0 ? "granted" :
-				     (i==1 ? "converting" : "blocked"));
-				spin_unlock(&res->spinlock);
-				ret = -ENOTEMPTY;
-				goto leave;
-			}
-		}
-		queue++;
-	}
-	mlog(0, "all locks on this lockres are nonlocal.  continuing\n");
 	spin_unlock(&res->spinlock);
 
 	/* no work to do */
-	if (empty) {
+	if (numlocks == 0) {
 		mlog(0, "no locks were found on this lockres! done!\n");
-		ret = 0;
 		goto leave;
 	}
 
@@ -2729,6 +2752,7 @@ int dlm_empty_lockres(struct dlm_ctxt *d
 {
 	int ret;
 	int lock_dropped = 0;
+	int numlocks;
 
 	spin_lock(&res->spinlock);
 	if (res->owner != dlm->node_num) {
@@ -2740,6 +2764,13 @@ int dlm_empty_lockres(struct dlm_ctxt *d
 		spin_unlock(&res->spinlock);
 		goto leave;
 	}
+
+	/* No need to migrate a lockres having no locks */
+	ret = dlm_is_lockres_migrateable(dlm, res, &numlocks);
+	if (ret >= 0 && numlocks == 0) {
+		spin_unlock(&res->spinlock);
+		goto leave;
+	}
 	spin_unlock(&res->spinlock);
 
 	/* Wheee! Migrate lockres here! Will sleep so drop spinlock. */
diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
index 6421a8f..2b264c6 100644
--- a/fs/ocfs2/dlm/dlmthread.c
+++ b/fs/ocfs2/dlm/dlmthread.c
@@ -256,20 +256,14 @@ static void dlm_run_purge_list(struct dl
 			break;
 		}
 
-		mlog(0, "removing lockres %.*s:%p from purgelist\n",
-		     lockres->lockname.len, lockres->lockname.name, lockres);
-		list_del_init(&lockres->purge);
-		dlm_lockres_put(lockres);
-		dlm->purge_count--;
+		dlm_lockres_get(lockres);
 
 		/* This may drop and reacquire the dlm spinlock if it
 		 * has to do migration. */
-		mlog(0, "calling dlm_purge_lockres!\n");
-		dlm_lockres_get(lockres);
 		if (dlm_purge_lockres(dlm, lockres))
 			BUG();
+
 		dlm_lockres_put(lockres);
-		mlog(0, "DONE calling dlm_purge_lockres!\n");
 
 		/* Avoid adding any scheduling latencies */
 		cond_resched_lock(&dlm->spinlock);
