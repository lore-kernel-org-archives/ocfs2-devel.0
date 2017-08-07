From: Changwei Ge <ge.changwei@h3c.com>
Date: Mon, 7 Aug 2017 07:13:31 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: re-queue AST or BAST if sending is
 failed to improve the reliability
Message-ID: <63ADC13FD55D6546B7DECE290D39E373AC2CB721@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

In current code, while flushing AST, we don't handle an exception that
sending AST or BAST is failed.
But it is indeed possible that AST or BAST is lost due to some kind of
networks fault.

If above exception happens, the requesting node will never obtain an AST
back, hence, it will never acquire the lock or abort current locking.

With this patch, I'd like to fix this issue by re-queuing the AST or
BAST if sending is failed due to networks fault.

And the re-queuing AST or BAST will be dropped if the requesting node is
dead!

It will improve the reliability a lot.


Thanks.

Changwei.

Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
---
 fs/ocfs2/dlm/dlmrecovery.c |   51
++++++++++++++++++++++++++++++++++++++++++--
 fs/ocfs2/dlm/dlmthread.c   |   39 +++++++++++++++++++++++++++------
 2 files changed, 81 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 74407c6..ddfaf74 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -2263,11 +2263,45 @@ static void dlm_revalidate_lvb(struct dlm_ctxt *dlm,
     }
 }
 
+static int dlm_drop_pending_ast_bast(struct dlm_ctxt *dlm,
+                     struct dlm_lock *lock)
+{
+    int reserved = 0;
+
+    spin_lock(&dlm->ast_lock);
+    if (!list_empty(&lock->ast_list)) {
+        mlog(0, "%s: drop pending AST for lock(cookie=%u:%llu).\n",
+             dlm->name,
+             dlm_get_lock_cookie_node(be64_to_cpu(lock->ml.cookie)),
+             dlm_get_lock_cookie_seq(be64_to_cpu(lock->ml.cookie)));
+        list_del_init(&lock->ast_list);
+        lock->ast_pending = 0;
+        dlm_lock_put(lock);
+        reserved++;
+    }
+
+    if (!list_empty(&lock->bast_list)) {
+        mlog(0, "%s: drop pending BAST for lock(cookie=%u:%llu).\n",
+             dlm->name,
+             dlm_get_lock_cookie_node(be64_to_cpu(lock->ml.cookie)),
+             dlm_get_lock_cookie_seq(be64_to_cpu(lock->ml.cookie)));
+        list_del_init(&lock->bast_list);
+        lock->bast_pending = 0;
+        dlm_lock_put(lock);
+        reserved++;
+    }
+    spin_unlock(&dlm->ast_lock);
+
+    return reserved;
+}
+
 static void dlm_free_dead_locks(struct dlm_ctxt *dlm,
-                struct dlm_lock_resource *res, u8 dead_node)
+                struct dlm_lock_resource *res, u8 dead_node,
+                int *reserved)
 {
     struct dlm_lock *lock, *next;
     unsigned int freed = 0;
+    int reserved_tmp = 0;
 
     /* this node is the lockres master:
      * 1) remove any stale locks for the dead node
@@ -2284,6 +2318,9 @@ static void dlm_free_dead_locks(struct dlm_ctxt *dlm,
         if (lock->ml.node == dead_node) {
             list_del_init(&lock->list);
             dlm_lock_put(lock);
+
+            reserved_tmp += dlm_drop_pending_ast_bast(dlm, lock);
+
             /* Can't schedule DLM_UNLOCK_FREE_LOCK - do manually */
             dlm_lock_put(lock);
             freed++;
@@ -2293,6 +2330,9 @@ static void dlm_free_dead_locks(struct dlm_ctxt *dlm,
         if (lock->ml.node == dead_node) {
             list_del_init(&lock->list);
             dlm_lock_put(lock);
+
+            reserved_tmp += dlm_drop_pending_ast_bast(dlm, lock);
+
             /* Can't schedule DLM_UNLOCK_FREE_LOCK - do manually */
             dlm_lock_put(lock);
             freed++;
@@ -2308,6 +2348,8 @@ static void dlm_free_dead_locks(struct dlm_ctxt *dlm,
         }
     }
 
+    *reserved = reserved_tmp;
+
     if (freed) {
         mlog(0, "%s:%.*s: freed %u locks for dead node %u, "
              "dropping ref from lockres\n", dlm->name,
@@ -2367,6 +2409,7 @@ static void dlm_do_local_recovery_cleanup(struct
dlm_ctxt *dlm, u8 dead_node)
     for (i = 0; i < DLM_HASH_BUCKETS; i++) {
         bucket = dlm_lockres_hash(dlm, i);
         hlist_for_each_entry_safe(res, tmp, bucket, hash_node) {
+            int reserved = 0;
              /* always prune any $RECOVERY entries for dead nodes,
               * otherwise hangs can occur during later recovery */
             if (dlm_is_recovery_lock(res->lockname.name,
@@ -2420,7 +2463,7 @@ static void dlm_do_local_recovery_cleanup(struct
dlm_ctxt *dlm, u8 dead_node)
                     continue;
                 }
             } else if (res->owner == dlm->node_num) {
-                dlm_free_dead_locks(dlm, res, dead_node);
+                dlm_free_dead_locks(dlm, res, dead_node, &reserved);
                 __dlm_lockres_calc_usage(dlm, res);
             } else if (res->owner == DLM_LOCK_RES_OWNER_UNKNOWN) {
                 if (test_bit(dead_node, res->refmap)) {
@@ -2432,6 +2475,10 @@ static void dlm_do_local_recovery_cleanup(struct
dlm_ctxt *dlm, u8 dead_node)
                 }
             }
             spin_unlock(&res->spinlock);
+            while (reserved) {
+                dlm_lockres_release_ast(dlm, res);
+                reserved--;
+            }
         }
     }
 
diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
index 838a06d..c34a619 100644
--- a/fs/ocfs2/dlm/dlmthread.c
+++ b/fs/ocfs2/dlm/dlmthread.c
@@ -587,13 +587,13 @@ static int dlm_dirty_list_empty(struct dlm_ctxt *dlm)
 
 static void dlm_flush_asts(struct dlm_ctxt *dlm)
 {
-    int ret;
+    int ret = 0;
     struct dlm_lock *lock;
     struct dlm_lock_resource *res;
     u8 hi;
 
     spin_lock(&dlm->ast_lock);
-    while (!list_empty(&dlm->pending_asts)) {
+    while (!list_empty(&dlm->pending_asts) && !ret) {
         lock = list_entry(dlm->pending_asts.next,
                   struct dlm_lock, ast_list);
         /* get an extra ref on lock */
@@ -628,8 +628,20 @@ static void dlm_flush_asts(struct dlm_ctxt *dlm)
             mlog(0, "%s: res %.*s, AST queued while flushing last "
                  "one\n", dlm->name, res->lockname.len,
                  res->lockname.name);
-        } else
-            lock->ast_pending = 0;
+        } else {
+            if (unlikely(ret < 0)) {
+                /* If this AST is not sent back successfully,
+                 * there is no chance that the second lock
+                 * request comes.
+                 */
+                spin_lock(&res->spinlock);
+                __dlm_lockres_reserve_ast(res);
+                spin_unlock(&res->spinlock);
+                __dlm_queue_ast(dlm, lock);
+            } else {
+                lock->ast_pending = 0;
+            }
+        }
 
         /* drop the extra ref.
          * this may drop it completely. */
@@ -637,7 +649,9 @@ static void dlm_flush_asts(struct dlm_ctxt *dlm)
         dlm_lockres_release_ast(dlm, res);
     }
 
-    while (!list_empty(&dlm->pending_basts)) {
+    ret = 0;
+
+    while (!list_empty(&dlm->pending_basts) && !ret) {
         lock = list_entry(dlm->pending_basts.next,
                   struct dlm_lock, bast_list);
         /* get an extra ref on lock */
@@ -650,7 +664,6 @@ static void dlm_flush_asts(struct dlm_ctxt *dlm)
         spin_lock(&lock->spinlock);
         BUG_ON(lock->ml.highest_blocked <= LKM_IVMODE);
         hi = lock->ml.highest_blocked;
-        lock->ml.highest_blocked = LKM_IVMODE;
         spin_unlock(&lock->spinlock);
 
         /* remove from list (including ref) */
@@ -681,7 +694,19 @@ static void dlm_flush_asts(struct dlm_ctxt *dlm)
                  "one\n", dlm->name, res->lockname.len,
                  res->lockname.name);
         } else
-            lock->bast_pending = 0;
+            if (unlikely(ret)) {
+                spin_lock(&res->spinlock);
+                __dlm_lockres_reserve_ast(res);
+                spin_unlock(&res->spinlock);
+                __dlm_queue_bast(dlm, lock);
+            } else {
+                lock->bast_pending = 0;
+                /* Set ::highest_blocked to invalid after
+                 * sending BAST successfully so that
+                 * no more BAST would be queued.
+                 */
+                lock->ml.highest_blocked = LKM_IVMODE;
+            }
 
         /* drop the extra ref.
          * this may drop it completely. */
-- 
1.7.9.5
