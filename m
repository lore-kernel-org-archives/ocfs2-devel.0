From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 14 Jul 2011 15:50:16 -0700
Subject: [Ocfs2-devel] [PATCH 05/16] ocfs2/dlm: Cleanup up
	dlm_finish_local_lockres_recovery()
In-Reply-To: <1310683827-19157-1-git-send-email-sunil.mushran@oracle.com>
References: <1310683827-19157-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1310683827-19157-6-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

dlm_finish_local_lockres_recovery() needed a facelift.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmrecovery.c |   59 +++++++++++++++++++------------------------
 1 files changed, 26 insertions(+), 33 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index a3c312c..41e74f0 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -2093,6 +2093,9 @@ static void dlm_finish_local_lockres_recovery(struct dlm_ctxt *dlm,
 
 	list_for_each_entry_safe(res, next, &dlm->reco.resources, recovering) {
 		if (res->owner == dead_node) {
+			mlog(0, "%s: res %.*s, Changing owner from %u to %u\n",
+			     dlm->name, res->lockname.len, res->lockname.name,
+			     res->owner, new_master);
 			list_del_init(&res->recovering);
 			spin_lock(&res->spinlock);
 			/* new_master has our reference from
@@ -2114,40 +2117,30 @@ static void dlm_finish_local_lockres_recovery(struct dlm_ctxt *dlm,
 	for (i = 0; i < DLM_HASH_BUCKETS; i++) {
 		bucket = dlm_lockres_hash(dlm, i);
 		hlist_for_each_entry(res, hash_iter, bucket, hash_node) {
-			if (res->state & DLM_LOCK_RES_RECOVERING) {
-				if (res->owner == dead_node) {
-					mlog(0, "(this=%u) res %.*s owner=%u "
-					     "was not on recovering list, but "
-					     "clearing state anyway\n",
-					     dlm->node_num, res->lockname.len,
-					     res->lockname.name, new_master);
-				} else if (res->owner == dlm->node_num) {
-					mlog(0, "(this=%u) res %.*s owner=%u "
-					     "was not on recovering list, "
-					     "owner is THIS node, clearing\n",
-					     dlm->node_num, res->lockname.len,
-					     res->lockname.name, new_master);
-				} else
-					continue;
+			if (!(res->state & DLM_LOCK_RES_RECOVERING))
+				continue;
 
-				if (!list_empty(&res->recovering)) {
-					mlog(0, "%s:%.*s: lockres was "
-					     "marked RECOVERING, owner=%u\n",
-					     dlm->name, res->lockname.len,
-					     res->lockname.name, res->owner);
-					list_del_init(&res->recovering);
-					dlm_lockres_put(res);
-				}
-				spin_lock(&res->spinlock);
-				/* new_master has our reference from
-				 * the lock state sent during recovery */
-				dlm_change_lockres_owner(dlm, res, new_master);
-				res->state &= ~DLM_LOCK_RES_RECOVERING;
-				if (__dlm_lockres_has_locks(res))
-					__dlm_dirty_lockres(dlm, res);
-				spin_unlock(&res->spinlock);
-				wake_up(&res->wq);
+			if (res->owner != dead_node &&
+			    res->owner != dlm->node_num)
+				continue;
+
+			if (!list_empty(&res->recovering)) {
+				list_del_init(&res->recovering);
+				dlm_lockres_put(res);
 			}
+
+			/* new_master has our reference from
+			 * the lock state sent during recovery */
+			mlog(0, "%s: res %.*s, Changing owner from %u to %u\n",
+			     dlm->name, res->lockname.len, res->lockname.name,
+			     res->owner, new_master);
+			spin_lock(&res->spinlock);
+			dlm_change_lockres_owner(dlm, res, new_master);
+			res->state &= ~DLM_LOCK_RES_RECOVERING;
+			if (__dlm_lockres_has_locks(res))
+				__dlm_dirty_lockres(dlm, res);
+			spin_unlock(&res->spinlock);
+			wake_up(&res->wq);
 		}
 	}
 }
-- 
1.7.4.1
