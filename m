From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 8 Oct 2014 13:44:33 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: let sender retry if
 dlm_dispatch_assert_master failed with -ENOMEM
Message-ID: <5434CF41.3040403@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Do not BUG() if GFP_ATOMIC allocation fails in
dlm_dispatch_assert_master.
Instead, return -ENOMEM to the sender and then retry.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Alex Chen <alex.chen@huawei.com>
---
 fs/ocfs2/dlm/dlmrecovery.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 3365839..79b5af5 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1656,14 +1656,18 @@ int dlm_do_master_requery(struct dlm_ctxt *dlm, struct dlm_lock_resource *res,
 	req.namelen = res->lockname.len;
 	memcpy(req.name, res->lockname.name, res->lockname.len);

+resend:
 	ret = o2net_send_message(DLM_MASTER_REQUERY_MSG, dlm->key,
 				 &req, sizeof(req), nodenum, &status);
-	/* XXX: negative status not handled properly here. */
 	if (ret < 0)
 		mlog(ML_ERROR, "Error %d when sending message %u (key "
 		     "0x%x) to node %u\n", ret, DLM_MASTER_REQUERY_MSG,
 		     dlm->key, nodenum);
-	else {
+	else if (status == -ENOMEM) {
+		mlog_errno(status);
+		msleep(50);
+		goto resend;
+	} else {
 		BUG_ON(status < 0);
 		BUG_ON(status > DLM_LOCK_RES_OWNER_UNKNOWN);
 		*real_master = (u8) (status & 0xff);
@@ -1705,9 +1709,13 @@ int dlm_master_requery_handler(struct o2net_msg *msg, u32 len, void *data,
 			int ret = dlm_dispatch_assert_master(dlm, res,
 							     0, 0, flags);
 			if (ret < 0) {
-				mlog_errno(-ENOMEM);
-				/* retry!? */
-				BUG();
+				mlog_errno(ret);
+				spin_unlock(&res->spinlock);
+				dlm_lockres_put(res);
+				spin_unlock(&dlm->spinlock);
+				dlm_put(dlm);
+				/* sender will take care of this and retry */
+				return ret;
 			} else
 				__dlm_lockres_grab_inflight_worker(dlm, res);
 			spin_unlock(&res->spinlock);
-- 
1.8.4.3
