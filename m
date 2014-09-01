From: Xue jiufei <xuejiufei@huawei.com>
Date: Mon, 1 Sep 2014 20:47:42 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: remove unused code in dlm_new_lockres()
Message-ID: <54046AEE.9070009@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Remove the branch that free res->lockname.name because the condition
is never satisfied when jump to label error.

Signed-off-by: joyce.xue <xuejiufei@huawei.com>
---
 fs/ocfs2/dlm/dlmmaster.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 3ec906e..73a5013 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -625,9 +625,6 @@ struct dlm_lock_resource *dlm_new_lockres(struct dlm_ctxt *dlm,
 	return res;
 
 error:
-	if (res && res->lockname.name)
-		kmem_cache_free(dlm_lockname_cache, (void *)res->lockname.name);
-
 	if (res)
 		kmem_cache_free(dlm_lockres_cache, res);
 	return NULL;
-- 
1.8.4.3
