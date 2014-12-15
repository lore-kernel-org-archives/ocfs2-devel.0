From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Mon, 15 Dec 2014 14:51:03 -0800
Subject: [Ocfs2-devel] [patch 05/15] ocfs2/dlm: fix race between
 dispatched_work and dlm_lockres_grab_inflight_worker
Message-ID: <548f65d7.mLvwv5K/G+Eyb58w%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2/dlm: fix race between dispatched_work and dlm_lockres_grab_inflight_worker

ac4fef4d23ed ("ocfs2/dlm: do not purge lockres that is queued for assert
master") may have the following possible race case:

dlm_dispatch_assert_master       dlm_wq
========================================================================
queue_work(dlm->quedlm_worker,
	&dlm->dispatched_work);
                                 dispatch work,
				 dlm_lockres_drop_inflight_worker
				 *BUG_ON(res->inflight_assert_workers == 0)*
dlm_lockres_grab_inflight_worker
inflight_assert_workers++

So ensure inflight_assert_workers to be increased first.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Xue jiufei <xuejiufei@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-fix-race-between-dispatched_work-and-dlm_lockres_grab_inflight_worker fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-fix-race-between-dispatched_work-and-dlm_lockres_grab_inflight_worker
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -685,14 +685,6 @@ void __dlm_lockres_grab_inflight_worker(
 			res->inflight_assert_workers);
 }
 
-static void dlm_lockres_grab_inflight_worker(struct dlm_ctxt *dlm,
-		struct dlm_lock_resource *res)
-{
-	spin_lock(&res->spinlock);
-	__dlm_lockres_grab_inflight_worker(dlm, res);
-	spin_unlock(&res->spinlock);
-}
-
 static void __dlm_lockres_drop_inflight_worker(struct dlm_ctxt *dlm,
 		struct dlm_lock_resource *res)
 {
@@ -1636,6 +1628,7 @@ send_response:
 		}
 		mlog(0, "%u is the owner of %.*s, cleaning everyone else\n",
 			     dlm->node_num, res->lockname.len, res->lockname.name);
+		spin_lock(&res->spinlock);
 		ret = dlm_dispatch_assert_master(dlm, res, 0, request->node_idx,
 						 DLM_ASSERT_MASTER_MLE_CLEANUP);
 		if (ret < 0) {
@@ -1643,7 +1636,8 @@ send_response:
 			response = DLM_MASTER_RESP_ERROR;
 			dlm_lockres_put(res);
 		} else
-			dlm_lockres_grab_inflight_worker(dlm, res);
+			__dlm_lockres_grab_inflight_worker(dlm, res);
+		spin_unlock(&res->spinlock);
 	} else {
 		if (res)
 			dlm_lockres_put(res);
_
