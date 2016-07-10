From: piaojun <piaojun@huawei.com>
Date: Sun, 10 Jul 2016 18:01:45 +0800
Subject: [Ocfs2-devel] ocfs2/dlm: disable BUG_ON when
 DLM_LOCK_RES_DROPPING_REF, is cleared before dlm_deref_lockres_done_handler
Message-ID: <57821D09.1040306@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We found a BUG situation in which DLM_LOCK_RES_DROPPING_REF is cleared
unexpected that described below. To solve the bug, we disable the BUG_ON
and purge lockres in dlm_do_local_recovery_cleanup.

Node 1                               Node 2(master)
dlm_purge_lockres
                                     dlm_deref_lockres_handler

                                     DLM_LOCK_RES_SETREF_INPROG is set
                                     response DLM_DEREF_RESPONSE_INPROG

receive DLM_DEREF_RESPONSE_INPROG
stop puring in dlm_purge_lockres
and wait for DLM_DEREF_RESPONSE_DONE

                                     dispatch dlm_deref_lockres_worker
                                     response DLM_DEREF_RESPONSE_DONE

receive DLM_DEREF_RESPONSE_DONE and
prepare to purge lockres

                                     Node 2 goes down

find Node2 down and do local
clean up for Node2:
dlm_do_local_recovery_cleanup
  -> clear DLM_LOCK_RES_DROPPING_REF

when purging lockres, BUG_ON happens
because DLM_LOCK_RES_DROPPING_REF is clear:
dlm_deref_lockres_done_handler
  ->BUG_ON(!(res->state & DLM_LOCK_RES_DROPPING_REF));

Fixes: 60d663cb5273 ("ocfs2/dlm: add DEREF_DONE message")
Signed-off-by: Jun Piao <piaojun@huawei.com>
---
 fs/ocfs2/dlm/dlmmaster.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 9aed6e2..f72e7ae 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -2416,7 +2416,16 @@ int dlm_deref_lockres_done_handler(struct o2net_msg *msg, u32 len, void *data,
 	}
 
 	spin_lock(&res->spinlock);
-	BUG_ON(!(res->state & DLM_LOCK_RES_DROPPING_REF));
+	if (!(res->state & DLM_LOCK_RES_DROPPING_REF)) {
+		spin_unlock(&res->spinlock);
+		spin_unlock(&dlm->spinlock);
+		mlog(ML_NOTICE, "%s:%.*s: node %u sends deref done "
+			"but it is already derefed!\n", dlm->name,
+			res->lockname.len, res->lockname.name, node);
+		dlm_lockres_put(res);
+		goto done;
+	}
+
 	if (!list_empty(&res->purge)) {
 		mlog(0, "%s: Removing res %.*s from purgelist\n",
 			dlm->name, res->lockname.len, res->lockname.name);
@@ -2455,6 +2464,8 @@ int dlm_deref_lockres_done_handler(struct o2net_msg *msg, u32 len, void *data,
 
 	spin_unlock(&dlm->spinlock);
 
+	ret = 0;
+
 done:
 	dlm_put(dlm);
 	return ret;
-- 
1.8.4.3
