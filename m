From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Mon, 09 Jun 2014 13:04:03 -0700
Subject: [Ocfs2-devel] [patch 4/8] ocfs2/dlm: do not purge lockres that is
	queued for assert master
Message-ID: <20140609200403.6A34D31C75B@corp2gmr1-1.hot.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2/dlm: do not purge lockres that is queued for assert master

When workqueue is delayed, it may occur that a lockres is purged while it
is still queued for master assert.  it may trigger BUG() as follows.

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

dlmlock_remote() send create_lock message to N2, but receive DLM_IVLOCKID,
if it is RECOVERY lockres, it triggers the BUG().

Another BUG() is triggered when N3 become the new master and send
assert_master to N1, N1 will trigger the BUG() because owner doesn't
match.  So we should not purge lockres when it is queued for assert
master.

Signed-off-by: joyce.xue <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmcommon.h   |    4 +++
 fs/ocfs2/dlm/dlmmaster.c   |   43 ++++++++++++++++++++++++++++++++++-
 fs/ocfs2/dlm/dlmrecovery.c |    3 +-
 fs/ocfs2/dlm/dlmthread.c   |   11 +++++---
 4 files changed, 55 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/dlm/dlmcommon.h~ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master fs/ocfs2/dlm/dlmcommon.h
--- a/fs/ocfs2/dlm/dlmcommon.h~ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master
+++ a/fs/ocfs2/dlm/dlmcommon.h
@@ -332,6 +332,7 @@ struct dlm_lock_resource
 	u16 state;
 	char lvb[DLM_LVB_LEN];
 	unsigned int inflight_locks;
+	unsigned int inflight_assert_workers;
 	unsigned long refmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
 };
 
@@ -911,6 +912,9 @@ void dlm_lockres_drop_inflight_ref(struc
 void dlm_lockres_grab_inflight_ref(struct dlm_ctxt *dlm,
 				   struct dlm_lock_resource *res);
 
+void __dlm_lockres_grab_inflight_worker(struct dlm_ctxt *dlm,
+		struct dlm_lock_resource *res);
+
 void dlm_queue_ast(struct dlm_ctxt *dlm, struct dlm_lock *lock);
 void dlm_queue_bast(struct dlm_ctxt *dlm, struct dlm_lock *lock);
 void __dlm_queue_ast(struct dlm_ctxt *dlm, struct dlm_lock *lock);
diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -581,6 +581,7 @@ static void dlm_init_lockres(struct dlm_
 	atomic_set(&res->asts_reserved, 0);
 	res->migration_pending = 0;
 	res->inflight_locks = 0;
+	res->inflight_assert_workers = 0;
 
 	res->dlm = dlm;
 
@@ -683,6 +684,43 @@ void dlm_lockres_drop_inflight_ref(struc
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
@@ -1603,7 +1641,8 @@ send_response:
 			mlog(ML_ERROR, "failed to dispatch assert master work\n");
 			response = DLM_MASTER_RESP_ERROR;
 			dlm_lockres_put(res);
-		}
+		} else
+			dlm_lockres_grab_inflight_worker(dlm, res);
 	} else {
 		if (res)
 			dlm_lockres_put(res);
@@ -2118,6 +2157,8 @@ static void dlm_assert_master_worker(str
 	dlm_lockres_release_ast(dlm, res);
 
 put:
+	dlm_lockres_drop_inflight_worker(dlm, res);
+
 	dlm_lockres_put(res);
 
 	mlog(0, "finished with dlm_assert_master_worker\n");
diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -1708,7 +1708,8 @@ int dlm_master_requery_handler(struct o2
 				mlog_errno(-ENOMEM);
 				/* retry!? */
 				BUG();
-			}
+			} else
+				__dlm_lockres_grab_inflight_worker(dlm, res);
 		} else /* put.. incase we are not the master */
 			dlm_lockres_put(res);
 		spin_unlock(&res->spinlock);
diff -puN fs/ocfs2/dlm/dlmthread.c~ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master fs/ocfs2/dlm/dlmthread.c
--- a/fs/ocfs2/dlm/dlmthread.c~ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master
+++ a/fs/ocfs2/dlm/dlmthread.c
@@ -259,11 +259,14 @@ static void dlm_run_purge_list(struct dl
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
_
