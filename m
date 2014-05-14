From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 14 May 2014 18:59:33 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix double kmem_cache_destroy in
	dlm_init
Message-ID: <53734C95.4040300@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In dlm_init, if create dlm_lockname_cache failed in
dlm_init_master_caches, it will destroy dlm_lockres_cache which created
before twice. And this will cause system die when loading modules.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/dlm/dlmmaster.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index af3f7aa..ee1f884 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -472,11 +472,15 @@ bail:

 void dlm_destroy_master_caches(void)
 {
-	if (dlm_lockname_cache)
+	if (dlm_lockname_cache) {
 		kmem_cache_destroy(dlm_lockname_cache);
+		dlm_lockname_cache = NULL;
+	}

-	if (dlm_lockres_cache)
+	if (dlm_lockres_cache) {
 		kmem_cache_destroy(dlm_lockres_cache);
+		dlm_lockres_cache = NULL;
+	}
 }

 static void dlm_lockres_release(struct kref *kref)
-- 
1.8.4.3
