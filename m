From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 26 Apr 2011 16:03:23 -0700
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2/dlm: dlm_is_lockres_migrateable()
	returns boolean
Message-ID: <1303859005-29529-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Patch cleans up the gunk added by commit 388c4bcb4e63e88fb1f312a2f5f9eb2623afcf5b.
dlm_is_lockres_migrateable() now returns 1 if lockresource is deemed
migrateable and 0 if not.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmcommon.h |   12 ++++
 fs/ocfs2/dlm/dlmmaster.c |  135 +++++++++++++++++----------------------------
 2 files changed, 63 insertions(+), 84 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index 4bdf7ba..1aac42a 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -401,6 +401,18 @@ static inline int dlm_lvb_is_empty(char *lvb)
 	return 1;
 }
 
+static inline char *dlm_list_in_text(enum dlm_lockres_list idx)
+{
+	if (idx == DLM_GRANTED_LIST)
+		return "granted";
+	else if (idx == DLM_CONVERTING_LIST)
+		return "converting";
+	else if (idx == DLM_BLOCKED_LIST)
+		return "blocked";
+	else
+		return "unknown";
+}
+
 static inline struct list_head *
 dlm_list_idx_to_ptr(struct dlm_lock_resource *res, enum dlm_lockres_list idx)
 {
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 9d67610..3e59ff9 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -2339,65 +2339,55 @@ static void dlm_deref_lockres_worker(struct dlm_work_item *item, void *data)
 	dlm_lockres_put(res);
 }
 
-/* Checks whether the lockres can be migrated. Returns 0 if yes, < 0
- * if not. If 0, numlocks is set to the number of locks in the lockres.
+/*
+ * A migrateable resource is one that is :
+ * 1. locally mastered, and,
+ * 2. zero local locks, and,
+ * 3. one or more non-local locks, or, one or more references
+ * Returns 1 if yes, 0 if not.
  */
 static int dlm_is_lockres_migrateable(struct dlm_ctxt *dlm,
-				      struct dlm_lock_resource *res,
-				      int *numlocks,
-				      int *hasrefs)
+				      struct dlm_lock_resource *res)
 {
-	int ret;
-	int i;
-	int count = 0;
+	enum dlm_lockres_list idx;
+	int nonlocal = 0;
 	struct list_head *queue;
 	struct dlm_lock *lock;
+	u64 cookie;
 
 	assert_spin_locked(&res->spinlock);
 
-	*numlocks = 0;
-	*hasrefs = 0;
-
-	ret = -EINVAL;
-	if (res->owner == DLM_LOCK_RES_OWNER_UNKNOWN) {
-		mlog(0, "cannot migrate lockres with unknown owner!\n");
-		goto leave;
-	}
-
-	if (res->owner != dlm->node_num) {
-		mlog(0, "cannot migrate lockres this node doesn't own!\n");
-		goto leave;
-	}
+	if (res->owner != dlm->node_num)
+		return 0;
 
-	ret = 0;
-	queue = &res->granted;
-	for (i = 0; i < 3; i++) {
+        for (idx = DLM_GRANTED_LIST; idx <= DLM_BLOCKED_LIST; idx++) {
+		queue = dlm_list_idx_to_ptr(res, idx);
 		list_for_each_entry(lock, queue, list) {
-			++count;
-			if (lock->ml.node == dlm->node_num) {
-				mlog(0, "found a lock owned by this node still "
-				     "on the %s queue!  will not migrate this "
-				     "lockres\n", (i == 0 ? "granted" :
-						   (i == 1 ? "converting" :
-						    "blocked")));
-				ret = -ENOTEMPTY;
-				goto leave;
+			if (lock->ml.node != dlm->node_num) {
+				nonlocal++;
+				continue;
 			}
+			cookie = be64_to_cpu(lock->ml.cookie);
+			mlog(0, "%s: Not migrateable res %.*s, lock %u:%llu on "
+			     "%s list\n", dlm->name, res->lockname.len,
+			     res->lockname.name,
+			     dlm_get_lock_cookie_node(cookie),
+			     dlm_get_lock_cookie_seq(cookie),
+			     dlm_list_in_text(idx));
+			return 0;
 		}
-		queue++;
 	}
 
-	*numlocks = count;
-
-	count = find_next_bit(res->refmap, O2NM_MAX_NODES, 0);
-	if (count < O2NM_MAX_NODES)
-		*hasrefs = 1;
+	if (!nonlocal) {
+		nonlocal = find_next_bit(res->refmap, O2NM_MAX_NODES, 0);
+		if (nonlocal >= O2NM_MAX_NODES)
+			return 0;
+	}
 
-	mlog(0, "%s: res %.*s, Migrateable, locks %d, refs %d\n", dlm->name,
-	     res->lockname.len, res->lockname.name, *numlocks, *hasrefs);
+	mlog(0, "%s: res %.*s, Migrateable\n", dlm->name, res->lockname.len,
+	     res->lockname.name);
 
-leave:
-	return ret;
+	return 1;
 }
 
 /*
@@ -2416,7 +2406,6 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
 	const char *name;
 	unsigned int namelen;
 	int mle_added = 0;
-	int numlocks, hasrefs;
 	int wake = 0;
 
 	if (!dlm_grab(dlm))
@@ -2427,19 +2416,13 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
 
 	mlog(0, "%s: Migrating %.*s to %u\n", dlm->name, namelen, name, target);
 
-	/*
-	 * ensure this lockres is a proper candidate for migration
-	 */
+	/* Ensure this lockres is a proper candidate for migration */
 	spin_lock(&res->spinlock);
-	ret = dlm_is_lockres_migrateable(dlm, res, &numlocks, &hasrefs);
-	if (ret < 0) {
-		spin_unlock(&res->spinlock);
-		goto leave;
-	}
+	ret = dlm_is_lockres_migrateable(dlm, res);
 	spin_unlock(&res->spinlock);
 
-	/* no work to do */
-	if (numlocks == 0 && !hasrefs)
+	/* No work to do */
+	if (!ret)
 		goto leave;
 
 	/*
@@ -2655,44 +2638,35 @@ leave:
 
 	dlm_put(dlm);
 
-	mlog(0, "returning %d\n", ret);
+	mlog(0, "%s: Migrating %.*s to %u, returns %d\n", dlm->name, namelen,
+	     name, target, ret);
 	return ret;
 }
 
 #define DLM_MIGRATION_RETRY_MS  100
 
-/* Should be called only after beginning the domain leave process.
+/*
+ * Should be called only after beginning the domain leave process.
  * There should not be any remaining locks on nonlocal lock resources,
  * and there should be no local locks left on locally mastered resources.
  *
  * Called with the dlm spinlock held, may drop it to do migration, but
  * will re-acquire before exit.
  *
- * Returns: 1 if dlm->spinlock was dropped/retaken, 0 if never dropped */
+ * Returns: 1 if dlm->spinlock was dropped/retaken, 0 if never dropped
+ */
 int dlm_empty_lockres(struct dlm_ctxt *dlm, struct dlm_lock_resource *res)
 {
-	int ret;
+	int mig, ret;
 	int lock_dropped = 0;
-	int numlocks, hasrefs;
 
-	spin_lock(&res->spinlock);
-	if (res->owner != dlm->node_num) {
-		if (!__dlm_lockres_unused(res)) {
-			mlog(ML_ERROR, "%s:%.*s: this node is not master, "
-			     "trying to free this but locks remain\n",
-			     dlm->name, res->lockname.len, res->lockname.name);
-		}
-		spin_unlock(&res->spinlock);
-		goto leave;
-	}
+	assert_spin_locked(&dlm->spinlock);
 
-	/* No need to migrate a lockres having no locks */
-	ret = dlm_is_lockres_migrateable(dlm, res, &numlocks, &hasrefs);
-	if (ret >= 0 && numlocks == 0 && !hasrefs) {
-		spin_unlock(&res->spinlock);
-		goto leave;
-	}
+	spin_lock(&res->spinlock);
+	mig = dlm_is_lockres_migrateable(dlm, res);
 	spin_unlock(&res->spinlock);
+	if (!mig)
+		goto leave;
 
 	/* Wheee! Migrate lockres here! Will sleep so drop spinlock. */
 	spin_unlock(&dlm->spinlock);
@@ -2701,15 +2675,8 @@ int dlm_empty_lockres(struct dlm_ctxt *dlm, struct dlm_lock_resource *res)
 		ret = dlm_migrate_lockres(dlm, res, O2NM_MAX_NODES);
 		if (ret >= 0)
 			break;
-		if (ret == -ENOTEMPTY) {
-			mlog(ML_ERROR, "lockres %.*s still has local locks!\n",
-		     		res->lockname.len, res->lockname.name);
-			BUG();
-		}
-
-		mlog(0, "lockres %.*s: migrate failed, "
-		     "retrying\n", res->lockname.len,
-		     res->lockname.name);
+		mlog(0, "%s: res %.*s, Migrate failed, retrying\n", dlm->name,
+		     res->lockname.len, res->lockname.name);
 		msleep(DLM_MIGRATION_RETRY_MS);
 	}
 	spin_lock(&dlm->spinlock);
-- 
1.7.1
