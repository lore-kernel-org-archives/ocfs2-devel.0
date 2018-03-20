From: Changwei Ge <ge.changwei@h3c.com>
Date: Tue, 20 Mar 2018 14:02:14 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: correct spelling mistake for
	migratable for all
Message-ID: <1521525734-19576-1-git-send-email-ge.changwei@h3c.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Inspired from patch
ocfs2-fix-spelling-mistake-migrateable-migratable.patch,
I checked all ocfs2 files and found more spelling mistakes.
So correct them all.

Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
---
 fs/ocfs2/dlm/dlmmaster.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index a7df226..9e137d9 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -2495,13 +2495,13 @@ static void dlm_deref_lockres_worker(struct dlm_work_item *item, void *data)
 }
 
 /*
- * A migrateable resource is one that is :
+ * A migratable resource is one that is :
  * 1. locally mastered, and,
  * 2. zero local locks, and,
  * 3. one or more non-local locks, or, one or more references
  * Returns 1 if yes, 0 if not.
  */
-static int dlm_is_lockres_migrateable(struct dlm_ctxt *dlm,
+static int dlm_is_lockres_migratable(struct dlm_ctxt *dlm,
 				      struct dlm_lock_resource *res)
 {
 	enum dlm_lockres_list idx;
@@ -2532,7 +2532,7 @@ static int dlm_is_lockres_migrateable(struct dlm_ctxt *dlm,
 				continue;
 			}
 			cookie = be64_to_cpu(lock->ml.cookie);
-			mlog(0, "%s: Not migrateable res %.*s, lock %u:%llu on "
+			mlog(0, "%s: Not migratable res %.*s, lock %u:%llu on "
 			     "%s list\n", dlm->name, res->lockname.len,
 			     res->lockname.name,
 			     dlm_get_lock_cookie_node(cookie),
@@ -2548,7 +2548,7 @@ static int dlm_is_lockres_migrateable(struct dlm_ctxt *dlm,
 			return 0;
 	}
 
-	mlog(0, "%s: res %.*s, Migrateable\n", dlm->name, res->lockname.len,
+	mlog(0, "%s: res %.*s, migratable\n", dlm->name, res->lockname.len,
 	     res->lockname.name);
 
 	return 1;
@@ -2792,7 +2792,7 @@ int dlm_empty_lockres(struct dlm_ctxt *dlm, struct dlm_lock_resource *res)
 	assert_spin_locked(&dlm->spinlock);
 
 	spin_lock(&res->spinlock);
-	if (dlm_is_lockres_migrateable(dlm, res))
+	if (dlm_is_lockres_migratable(dlm, res))
 		target = dlm_pick_migration_target(dlm, res);
 	spin_unlock(&res->spinlock);
 
-- 
2.7.4
