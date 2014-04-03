From: Joseph Qi <joseph.qi@huawei.com>
Date: Thu, 3 Apr 2014 20:45:44 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: retry once dlm_dispatch_assert_master
 failed with ENOMEM
Message-ID: <533D57F8.6010201@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Once dlm_dispatch_assert_master failed in dlm_master_requery_handler,
the only reason is ENOMEM. So just retry it instead of BUG().

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/dlm/dlmrecovery.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 7035af0..f772d64 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1685,6 +1685,7 @@ int dlm_master_requery_handler(struct o2net_msg *msg, u32 len, void *data,
 
 	hash = dlm_lockid_hash(req->name, req->namelen);
 
+retry:
 	spin_lock(&dlm->spinlock);
 	res = __dlm_lookup_lockres(dlm, req->name, req->namelen, hash);
 	if (res) {
@@ -1693,10 +1694,14 @@ int dlm_master_requery_handler(struct o2net_msg *msg, u32 len, void *data,
 		if (master == dlm->node_num) {
 			int ret = dlm_dispatch_assert_master(dlm, res,
 							     0, 0, flags);
+			/* ENOMEM returns, just retry */
 			if (ret < 0) {
-				mlog_errno(-ENOMEM);
-				/* retry!? */
-				BUG();
+				spin_unlock(&res->spinlock);
+				dlm_lockres_put(res);
+				spin_unlock(&dlm->spinlock);
+				mlog_errno(ret);
+				msleep(50);
+				goto retry;
 			}
 		} else /* put.. incase we are not the master */
 			dlm_lockres_put(res);
-- 
1.8.4.3
