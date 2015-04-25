From: Joseph Qi <joseph.qi@huawei.com>
Date: Sat, 25 Apr 2015 11:14:36 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: cleanup unused function
	__dlm_wait_on_lockres_flags_set
Message-ID: <553B069C.6070206@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Function __dlm_wait_on_lockres_flags_set is declared but not implemented
and used. So remove it.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/dlm/dlmcommon.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index fae17c6..e88ccf8 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -1014,7 +1014,6 @@ void dlm_move_lockres_to_recovery_list(struct dlm_ctxt *dlm,

 /* will exit holding res->spinlock, but may drop in function */
 void __dlm_wait_on_lockres_flags(struct dlm_lock_resource *res, int flags);
-void __dlm_wait_on_lockres_flags_set(struct dlm_lock_resource *res, int flags);

 /* will exit holding res->spinlock, but may drop in function */
 static inline void __dlm_wait_on_lockres(struct dlm_lock_resource *res)
-- 
1.8.4.3
