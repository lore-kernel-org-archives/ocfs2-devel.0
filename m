From: Xue jiufei <xuejiufei@huawei.com>
Date: Wed, 5 Jun 2013 16:53:34 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: add missing lockres put in
	dlm_mig_lockres_handler
Message-ID: <51AEFC8E.3080507@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

dlm_mig_lockres_handler goes to leave, when lockres with state
DLM_LOCK_RES_RECOVERING, not putting lockres taken in dlm_lookup_lockres.

Signed-off-by: joyce <xuejiufei@huawei.com>
---
 fs/ocfs2/dlm/dlmrecovery.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index a145cf8..241ced4 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1408,6 +1408,7 @@ int dlm_mig_lockres_handler(struct o2net_msg *msg, u32 len, void *data,
 				     mres->lockname_len, mres->lockname);
 				ret = -EFAULT;
 				spin_unlock(&res->spinlock);
+				dlm_lockres_put(res);
 				goto leave;
 			}
 			res->state |= DLM_LOCK_RES_MIGRATING;
-- 
1.7.9.7
