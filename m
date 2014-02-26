From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Wed, 26 Feb 2014 15:47:37 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: dlm: fix lock migration crash
Message-ID: <1393400857-12294-1-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This issue was introduced by commit 800deef3 where it replaced list_for_each
with list_for_each_entry. The variable "lock" will point to invalid data if
"tmpq" list is empty and a panic will be triggered due to this.
Sunil advised reverting it back, but the old version was also not right. At
the end of the outer for loop, that list_for_each_entry will also set "lock"
to an invalid data, then in the next loop, if the "tmpq" list is empty, "lock"
will be an stale invalid data and cause the panic. So reverting the list_for_each
back and reset "lock" to NULL to fix this issue.

Another concern is that this seemes can not happen because the "tmpq" list should
not be empty. Let me describe how.
old lock resource owner(node 1):                                  migratation target(node 2):
image there's lockres with a EX lock from node 2 in
granted list, a NR lock from node x with convert_type
EX in converting list.
dlm_empty_lockres() {
 dlm_pick_migration_target() {
   pick node 2 as target as its lock is the first one
   in granted list.
 }
 dlm_migrate_lockres() {
   dlm_mark_lockres_migrating() {
     res->state |= DLM_LOCK_RES_BLOCK_DIRTY;
     wait_event(dlm->ast_wq, !dlm_lockres_is_dirty(dlm, res));
	 //after the above code, we can not dirty lockres any more,
     // so dlm_thread shuffle list will not run
                                                                   downconvert lock from EX to NR
                                                                   upconvert lock from NR to EX
<<< migration may schedule out here, then
<<< node 2 send down convert request to convert type from EX to
<<< NR, then send up convert request to convert type from NR to
<<< EX,@this time, lockres granted list is empty, and two locks
<<< in the converting list, node x up convert lock followed by
<<< node 2 up convert lock.

	 // will set lockres RES_MIGRATING flag, the following
	 // lock/unlock can not run
     dlm_lockres_release_ast(dlm, res);
   }

   dlm_send_one_lockres()
                                                                 dlm_process_recovery_data()
                                                                   for (i=0; i<mres->num_locks; i++)
                                                                     if (ml->node == dlm->node_num)
                                                                       for (j = DLM_GRANTED_LIST; j <= DLM_BLOCKED_LIST; j++) {
                                                                        list_for_each_entry(lock, tmpq, list)
                                                                        if (lock) break; <<< lock is invalid as grant list is empty.
                                                                       }
                                                                       if (lock->ml.node != ml->node)
                                                                         BUG() >>> crash here
 }
I see the above locks status from a vmcore of our internal bug.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Sunil Mushran <sunil.mushran@gmail.com>
Cc: Srinivas Eeda <srinivas.eeda@oracle.com>
Cc: <stable@vger.kernel.org>
---
 fs/ocfs2/dlm/dlmrecovery.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 7035af0..c2dd258 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1750,13 +1750,13 @@ static int dlm_process_recovery_data(struct dlm_ctxt *dlm,
 				     struct dlm_migratable_lockres *mres)
 {
 	struct dlm_migratable_lock *ml;
-	struct list_head *queue;
+	struct list_head *queue, *iter;
 	struct list_head *tmpq = NULL;
 	struct dlm_lock *newlock = NULL;
 	struct dlm_lockstatus *lksb = NULL;
 	int ret = 0;
 	int i, j, bad;
-	struct dlm_lock *lock = NULL;
+	struct dlm_lock *lock;
 	u8 from = O2NM_MAX_NODES;
 	unsigned int added = 0;
 	__be64 c;
@@ -1791,14 +1791,16 @@ static int dlm_process_recovery_data(struct dlm_ctxt *dlm,
 			/* MIGRATION ONLY! */
 			BUG_ON(!(mres->flags & DLM_MRES_MIGRATION));
 
+			lock = NULL;
 			spin_lock(&res->spinlock);
 			for (j = DLM_GRANTED_LIST; j <= DLM_BLOCKED_LIST; j++) {
 				tmpq = dlm_list_idx_to_ptr(res, j);
-				list_for_each_entry(lock, tmpq, list) {
-					if (lock->ml.cookie != ml->cookie)
-						lock = NULL;
-					else
+				list_for_each(iter, tmpq) {
+					lock = list_entry(iter,
+						  struct dlm_lock, list);
+					if (lock->ml.cookie == ml->cookie)
 						break;
+					lock = NULL;
 				}
 				if (lock)
 					break;
-- 
1.7.9.5
