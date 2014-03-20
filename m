From: Joseph Qi <joseph.qi@huawei.com>
Date: Thu, 20 Mar 2014 12:25:14 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix dead lock risk when kmalloc failed
	in dlm_query_region_handler
Message-ID: <532A6DAA.9020707@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Zhonghua Guo <guozhonghua@h3c.com>

In dlm_query_region_handler(), once kmalloc failed, it will unlock
dlm_domain_lock without lock first, then dead lock happens.
This patch adds a flag domain_locked to fix this issue.

Signed-off-by: Zhonghua Guo <guozhonghua@h3c.com>
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Tested-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/dlm/dlmdomain.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 33660a4..119fafd 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -1124,6 +1124,7 @@ static int dlm_query_region_handler(struct o2net_msg *msg, u32 len,
 	char *local = NULL;
 	int status = 0;
 	int locked = 0;
+	int domain_locked = 0;
 
 	qr = (struct dlm_query_region *) msg->buf;
 
@@ -1140,6 +1141,7 @@ static int dlm_query_region_handler(struct o2net_msg *msg, u32 len,
 	status = -EINVAL;
 
 	spin_lock(&dlm_domain_lock);
+	domain_locked = 1;
 	dlm = __dlm_lookup_domain_full(qr->qr_domain, qr->qr_namelen);
 	if (!dlm) {
 		mlog(ML_ERROR, "Node %d queried hb regions on domain %s "
@@ -1171,7 +1173,8 @@ static int dlm_query_region_handler(struct o2net_msg *msg, u32 len,
 bail:
 	if (locked)
 		spin_unlock(&dlm->spinlock);
-	spin_unlock(&dlm_domain_lock);
+	if (domain_locked)
+		spin_unlock(&dlm_domain_lock);
 
 	kfree(local);
 
-- 
1.8.4.3
