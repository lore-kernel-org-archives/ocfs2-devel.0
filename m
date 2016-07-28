From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Thu, 28 Jul 2016 14:06:02 -0700
Subject: [Ocfs2-devel] [patch 3/5] ocfs2/dlm: disable BUG_ON when
 DLM_LOCK_RES_DROPPING_REF is cleared before dlm_deref_lockres_done_handler
Message-ID: <579a73ba.w6r/vSvvhIAjJAxY%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: piaojun <piaojun@huawei.com>
Subject: ocfs2/dlm: disable BUG_ON when DLM_LOCK_RES_DROPPING_REF is cleared before dlm_deref_lockres_done_handler

We found a BUG situation in which DLM_LOCK_RES_DROPPING_REF is cleared
unexpected that described below.  To solve the bug, we disable the BUG_ON
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

[akpm at linux-foundation.org: fix duplicated write to `ret']
Fixes: 60d663cb5273 ("ocfs2/dlm: add DEREF_DONE message")
Link: http://lkml.kernel.org/r/57845055.9080702 at huawei.com
Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Jiufei Xue <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-disable-bug_on-when-dlm_lock_res_dropping_ref-is-cleared-before-dlm_deref_lockres_done_handler fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-disable-bug_on-when-dlm_lock_res_dropping_ref-is-cleared-before-dlm_deref_lockres_done_handler
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -2416,7 +2416,17 @@ int dlm_deref_lockres_done_handler(struc
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
+		ret = 0;
+		goto done;
+	}
+
 	if (!list_empty(&res->purge)) {
 		mlog(0, "%s: Removing res %.*s from purgelist\n",
 			dlm->name, res->lockname.len, res->lockname.name);
@@ -2456,7 +2466,6 @@ int dlm_deref_lockres_done_handler(struc
 	spin_unlock(&dlm->spinlock);
 
 	ret = 0;
-
 done:
 	dlm_put(dlm);
 	return ret;
_
