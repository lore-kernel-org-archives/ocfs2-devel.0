From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Tue, 31 Aug 2010 23:41:49 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: retry migrating if nomem or
	lockres is in recovery on target
Message-ID: <201008311544.o7VESwg1014110@acsinet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch tries to fix two problems:

problem 1):
It's a case of recovery + migration. That is a recovery is happening when node I
is in progress of umount. Node I is the recovery master.
Say lockres A was mastered by the dead node and need to be recovered. Node I(the
reco master) and node II both have reference on lockres A.
So lockres A is being recovered from node II to node I, with RECOVERING flag set.
The umounting process is going on, it happened to be migrating lockres A to node
II. Since recovery not finished yet(RECOVERING still set), node II reponds with
-EFAULT to kill node I. Then node I killed its self(BUGON).

There is a checking for recovery(on RECOVERING), but it droped res->spinlock and
dlm->spinlock. So the checking does not help much enough.

Since we have to drop any spinlock when we are sending migrate lockres(
DLM_MIG_LOCKRES_MSG) message, we have to deal with above case.

problem 2):
In the same context of problem 1), -ENOMEM from target node can trigger an
incorrect BUG() on the requester of "migrate lockres".

The fix is when target node returns -EFAULT or -ENOMEM, we retry the migration(
for umount).
Though they are two separated problems, the fixes are in the same way. So I
combined them together.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/dlm/dlmrecovery.c |   28 ++++++++++++++++++++++------
 1 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index aaaffbc..b7dd03f 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1122,6 +1122,8 @@ static int dlm_send_mig_lockres_msg(struct dlm_ctxt *dlm,
 	     orig_flags & DLM_MRES_MIGRATION ? "migration" : "recovery",
 	     send_to);
 
+#define WAIT_FOR_NOMEM_MS 30
+resend:
 	/* send it */
 	ret = o2net_send_message(DLM_MIG_LOCKRES_MSG, dlm->key, mres,
 				 sz, send_to, &status);
@@ -1132,16 +1134,30 @@ static int dlm_send_mig_lockres_msg(struct dlm_ctxt *dlm,
 		     "0x%x) to node %u\n", ret, DLM_MIG_LOCKRES_MSG,
 		     dlm->key, send_to);
 	} else {
-		/* might get an -ENOMEM back here */
-		ret = status;
 		if (ret < 0) {
 			mlog_errno(ret);
 
-			if (ret == -EFAULT) {
-				mlog(ML_ERROR, "node %u told me to kill "
-				     "myself!\n", send_to);
-				BUG();
+			/*
+			 * -ENOMEM or -EFAULT here.
+			 * -EFAULT means lockres is in recovery.
+			 * we should retry in both the two cases.
+			 */
+			ret = status;
+			if (ret == -ENOMEM) {
+				mlog(ML_NOTICE, "node %u no memory\n",
+				     send_to);
+				if (dlm_in_recovery(dlm)) {
+					dlm_wait_for_recovery(dlm);
+				} else {
+					msleep(WAIT_FOR_NOMEM_MS);
+				}
+			} else {
+				BUG_ON(ret != -EFAULT);
+				mlog(ML_NOTICE, "node %u in recovery\n",
+				     send_to);
+				dlm_wait_for_recovery(dlm);
 			}
+			goto resend;
 		}
 	}
 
-- 
1.7.2.2
