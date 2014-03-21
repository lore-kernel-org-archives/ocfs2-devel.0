From: Joseph Qi <joseph.qi@huawei.com>
Date: Fri, 21 Mar 2014 15:41:06 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: fix dead lock risk when kmalloc
	failed in dlm_query_region_handler
Message-ID: <532BED12.5020408@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Zhonghua Guo <guozhonghua@h3c.com>

In dlm_query_region_handler(), once kmalloc failed, it will unlock
dlm_domain_lock without lock first, then dead lock happens.

Signed-off-by: Zhonghua Guo <guozhonghua@h3c.com>
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/dlm/dlmdomain.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 33660a4..01c4e9e 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -1123,7 +1123,6 @@ static int dlm_query_region_handler(struct o2net_msg *msg, u32 len,
 	struct dlm_ctxt *dlm = NULL;
 	char *local = NULL;
 	int status = 0;
-	int locked = 0;
 
 	qr = (struct dlm_query_region *) msg->buf;
 
@@ -1132,10 +1131,8 @@ static int dlm_query_region_handler(struct o2net_msg *msg, u32 len,
 
 	/* buffer used in dlm_mast_regions() */
 	local = kmalloc(sizeof(qr->qr_regions), GFP_KERNEL);
-	if (!local) {
-		status = -ENOMEM;
-		goto bail;
-	}
+	if (!local)
+		return -ENOMEM;
 
 	status = -EINVAL;
 
@@ -1144,16 +1141,15 @@ static int dlm_query_region_handler(struct o2net_msg *msg, u32 len,
 	if (!dlm) {
 		mlog(ML_ERROR, "Node %d queried hb regions on domain %s "
 		     "before join domain\n", qr->qr_node, qr->qr_domain);
-		goto bail;
+		goto out_domain_lock;
 	}
 
 	spin_lock(&dlm->spinlock);
-	locked = 1;
 	if (dlm->joining_node != qr->qr_node) {
 		mlog(ML_ERROR, "Node %d queried hb regions on domain %s "
 		     "but joining node is %d\n", qr->qr_node, qr->qr_domain,
 		     dlm->joining_node);
-		goto bail;
+		goto out_dlm_lock;
 	}
 
 	/* Support for global heartbeat was added in 1.1 */
@@ -1163,14 +1159,15 @@ static int dlm_query_region_handler(struct o2net_msg *msg, u32 len,
 		     "but active dlm protocol is %d.%d\n", qr->qr_node,
 		     qr->qr_domain, dlm->dlm_locking_proto.pv_major,
 		     dlm->dlm_locking_proto.pv_minor);
-		goto bail;
+		goto out_dlm_lock;
 	}
 
 	status = dlm_match_regions(dlm, qr, local, sizeof(qr->qr_regions));
 
-bail:
-	if (locked)
-		spin_unlock(&dlm->spinlock);
+out_dlm_lock:
+	spin_unlock(&dlm->spinlock);
+
+out_domain_lock:
 	spin_unlock(&dlm_domain_lock);
 
 	kfree(local);
-- 
1.8.4.3
