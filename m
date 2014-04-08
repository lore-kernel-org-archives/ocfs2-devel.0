From: Joseph Qi <joseph.qi@huawei.com>
Date: Tue, 8 Apr 2014 18:47:04 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: retry once
 dlm_dispatch_assert_master failed with ENOMEM
Message-ID: <5343D3A8.1080302@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Once dlm_dispatch_assert_master failed in dlm_master_requery_handler,
the only reason is ENOMEM.
Add retry logic to avoid BUG() in case of not enough memory
temporarily.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/dlm/dlmrecovery.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 7035af0..7db0465 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1676,6 +1676,9 @@ int dlm_master_requery_handler(struct o2net_msg *msg, u32 len, void *data,
 	unsigned int hash;
 	int master = DLM_LOCK_RES_OWNER_UNKNOWN;
 	u32 flags = DLM_ASSERT_MASTER_REQUERY;
+	int ret, retries = 0;
+
+#define DISPATCH_ASSERT_RETRY_TIMES 3
 
 	if (!dlm_grab(dlm)) {
 		/* since the domain has gone away on this
@@ -1685,18 +1688,30 @@ int dlm_master_requery_handler(struct o2net_msg *msg, u32 len, void *data,
 
 	hash = dlm_lockid_hash(req->name, req->namelen);
 
+retry:
 	spin_lock(&dlm->spinlock);
 	res = __dlm_lookup_lockres(dlm, req->name, req->namelen, hash);
 	if (res) {
 		spin_lock(&res->spinlock);
 		master = res->owner;
 		if (master == dlm->node_num) {
-			int ret = dlm_dispatch_assert_master(dlm, res,
-							     0, 0, flags);
+			ret = dlm_dispatch_assert_master(dlm, res,
+					0, 0, flags);
 			if (ret < 0) {
-				mlog_errno(-ENOMEM);
-				/* retry!? */
-				BUG();
+				mlog_errno(ret);
+
+				/* ENOMEM returns, retry until
+				 * DISPATCH_ASSERT_RETRY_TIMES reached */
+				if (retries < DISPATCH_ASSERT_RETRY_TIMES) {
+					spin_unlock(&res->spinlock);
+					dlm_lockres_put(res);
+					spin_unlock(&dlm->spinlock);
+					msleep(50);
+					retries++;
+					goto retry;
+				} else {
+					BUG();
+				}
 			}
 		} else /* put.. incase we are not the master */
 			dlm_lockres_put(res);
-- 
1.8.4.3
