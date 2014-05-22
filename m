From: Xue jiufei <xuejiufei@huawei.com>
Date: Thu, 22 May 2014 20:14:48 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: Do not purge lockres that is
 queued for assert master
Message-ID: <537DEA38.50804@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When workqueue is delayed, it may occured that a lockres is purged
while it is still queued for master assert. it may trigger BUS() as
follows.

N1                                         N2
dlm_get_lockres()
->dlm_do_master_requery
                                  is the master of lockres,
                                  so queue assert_master work

                                  dlm_thread() start running
                                  and purge the lockres

                                  dlm_assert_master_worker()
                                  send assert master message
                                  to other nodes
receiving the assert_master
message, set master to N2

dlmlock_remote() send
create_lock message to N2,
but receive DLM_IVLOCKID,
if it is RECOVERY lockres,
it triggers the BUG().

Another BUG() is triggered when N3 become the new master and send
assert_master to N1, N1 will trigger the BUG() because owner
doesn't match. So we should not purge lockres when it is queued
for assert master.

Signed-off-by: joyce.xue <xuejiufei@huawei.com>
---
 fs/ocfs2/dlm/dlmcommon.h   |  4 ++++
 fs/ocfs2/dlm/dlmmaster.c   | 43 ++++++++++++++++++++++++++++++++++++++++++-
 fs/ocfs2/dlm/dlmrecovery.c |  3 ++-
 fs/ocfs2/dlm/dlmthread.c   | 11 +++++++----
 4 files changed, 55 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index e051776..fa2bd21 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -332,6 +332,7 @@ struct dlm_lock_resource
 	u16 state;
 	char lvb[DLM_LVB_LEN];
 	unsigned int inflight_locks;
+	unsigned int inflight_assert_workers;
 	unsigned long refmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
 };
 
@@ -911,6 +912,9 @@ void dlm_lockres_drop_inflight_ref(struct dlm_ctxt *dlm,
 void dlm_lockres_grab_inflight_ref(struct dlm_ctxt *dlm,
 				   struct dlm_lock_resource *res);
 
+void __dlm_lockres_grab_inflight_worker(struct dlm_ctxt *dlm,
+		struct dlm_lock_resource *res);
+
 void dlm_queue_ast(struct dlm_ctxt *dlm, struct dlm_lock *lock);
 void dlm_queue_bast(struct dlm_ctxt *dlm, struct dlm_lock *lock);
 void __dlm_queue_ast(struct dlm_ctxt *dlm, struct dlm_lock *lock);
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index af3f7aa..65f0e12 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -577,6 +577,7 @@ static void dlm_init_lockres(struct dlm_ctxt *dlm,
 	atomic_set(&res->asts_reserved, 0);
 	res->migration_pending = 0;
 	res->inflight_locks = 0;
+	res->inflight_assert_workers = 0;
 
 	res->dlm = dlm;
 
@@ -679,6 +680,43 @@ void dlm_lockres_drop_inflight_ref(struct dlm_ctxt *dlm,
 	wake_up(&res->wq);
 }
 
+void __dlm_lockres_grab_inflight_worker(struct dlm_ctxt *dlm,
+		struct dlm_lock_resource *res)
+{
+	assert_spin_locked(&res->spinlock);
+	res->inflight_assert_workers++;
+	mlog(0, "%s:%.*s: inflight assert worker++: now %u\n",
+			dlm->name, res->lockname.len, res->lockname.name,
+			res->inflight_assert_workers);
+}
+
+void dlm_lockres_grab_inflight_worker(struct dlm_ctxt *dlm,
+		struct dlm_lock_resource *res)
+{
+	spin_lock(&res->spinlock);
+	__dlm_lockres_grab_inflight_worker(dlm, res);
+	spin_unlock(&res->spinlock);
+}
+
+void __dlm_lockres_drop_inflight_worker(struct dlm_ctxt *dlm,
+		struct dlm_lock_resource *res)
+{
+	assert_spin_locked(&res->spinlock);
+	BUG_ON(res->inflight_assert_workers == 0);
+	res->inflight_assert_workers--;
+	mlog(0, "%s:%.*s: inflight assert worker--: now %u\n",
+			dlm->name, res->lockname.len, res->lockname.name,
+			res->inflight_assert_workers);
+}
+
+void dlm_lockres_drop_inflight_worker(struct dlm_ctxt *dlm,
+		struct dlm_lock_resource *res)
+{
+	spin_lock(&res->spinlock);
+	__dlm_lockres_drop_inflight_worker(dlm, res);
+	spin_unlock(&res->spinlock);
+}
+
 /*
  * lookup a lock resource by name.
  * may already exist in the hashtable.
@@ -1599,7 +1637,8 @@ send_response:
 			mlog(ML_ERROR, "failed to dispatch assert master work\n");
 			response = DLM_MASTER_RESP_ERROR;
 			dlm_lockres_put(res);
-		}
+		} else
+			dlm_lockres_grab_inflight_worker(dlm, res);
 	} else {
 		if (res)
 			dlm_lockres_put(res);
@@ -2114,6 +2153,8 @@ static void dlm_assert_master_worker(struct dlm_work_item *item, void *data)
 	dlm_lockres_release_ast(dlm, res);
 
 put:
+	dlm_lockres_drop_inflight_worker(dlm, res);
+
 	dlm_lockres_put(res);
 
 	mlog(0, "finished with dlm_assert_master_worker\n");
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 5de0194..45067fa 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1708,7 +1708,8 @@ int dlm_master_requery_handler(struct o2net_msg *msg, u32 len, void *data,
 				mlog_errno(-ENOMEM);
 				/* retry!? */
 				BUG();
-			}
+			} else
+				__dlm_lockres_grab_inflight_worker(dlm, res);
 		} else /* put.. incase we are not the master */
 			dlm_lockres_put(res);
 		spin_unlock(&res->spinlock);
diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
index 9db869d..f68bd4e 100644
--- a/fs/ocfs2/dlm/dlmthread.c
+++ b/fs/ocfs2/dlm/dlmthread.c
@@ -259,11 +259,14 @@ static void dlm_run_purge_list(struct dlm_ctxt *dlm,
 		 * refs on it. */
 		unused = __dlm_lockres_unused(lockres);
 		if (!unused ||
-		    (lockres->state & DLM_LOCK_RES_MIGRATING)) {
+		    (lockres->state & DLM_LOCK_RES_MIGRATING) ||
+		    (lockres->inflight_assert_workers != 0)) {
 			mlog(0, "%s: res %.*s is in use or being remastered, "
-			     "used %d, state %d\n", dlm->name,
-			     lockres->lockname.len, lockres->lockname.name,
-			     !unused, lockres->state);
+			     "used %d, state %d, assert master workers %u\n",
+			     dlm->name, lockres->lockname.len,
+			     lockres->lockname.name,
+			     !unused, lockres->state,
+			     lockres->inflight_assert_workers);
 			list_move_tail(&dlm->purge_list, &lockres->purge);
 			spin_unlock(&lockres->spinlock);
 			continue;
-- 
1.8.3.4
