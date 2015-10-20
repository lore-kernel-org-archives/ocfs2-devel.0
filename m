From: Joseph Qi <joseph.qi@huawei.com>
Date: Tue, 20 Oct 2015 09:00:50 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: unlock lockres spinlock before
	dlm_lockres_put
Message-ID: <56259242.9010103@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

dlm_lockres_put will call dlm_lockres_release if it is the last
reference, and then it may call dlm_print_one_lock_resource and take
lockres spinlock.
So unlock lockres spinlock before dlm_lockres_put to avoid deadlock.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/dlm/dlmmaster.c   | 3 ++-
 fs/ocfs2/dlm/dlmrecovery.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 482cfd3..a0070e6 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -1658,12 +1658,13 @@ send_response:
 		if (ret < 0) {
 			mlog(ML_ERROR, "failed to dispatch assert master work\n");
 			response = DLM_MASTER_RESP_ERROR;
+			spin_unlock(&res->spinlock);
 			dlm_lockres_put(res);
 		} else {
 			dispatched = 1;
 			__dlm_lockres_grab_inflight_worker(dlm, res);
+			spin_unlock(&res->spinlock);
 		}
-		spin_unlock(&res->spinlock);
 	} else {
 		if (res)
 			dlm_lockres_put(res);
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 5c0f761..a43f9ef 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1723,8 +1723,8 @@ int dlm_master_requery_handler(struct o2net_msg *msg, u32 len, void *data,
 			} else {
 				dispatched = 1;
 				__dlm_lockres_grab_inflight_worker(dlm, res);
+				spin_unlock(&res->spinlock);
 			}
-			spin_unlock(&res->spinlock);
 		} else {
 			/* put.. incase we are not the master */
 			spin_unlock(&res->spinlock);
-- 
1.8.4.3
