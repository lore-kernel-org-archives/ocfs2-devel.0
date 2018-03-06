From: piaojun <piaojun@huawei.com>
Date: Tue, 6 Mar 2018 23:22:05 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: remove unnecessary null pointer check
 before kmem_cache_destroy()
Message-ID: <5A9EB21D.3000209@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

As kmem_cache_destroy already handles null pointers, so we can remove the
conditional test entirely.

Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
---
 fs/ocfs2/dlm/dlmlock.c   |  3 +--
 fs/ocfs2/dlm/dlmmaster.c | 15 +++++----------
 fs/ocfs2/super.c         | 18 ++++++------------
 fs/ocfs2/uptodate.c      |  3 +--
 4 files changed, 13 insertions(+), 26 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmlock.c b/fs/ocfs2/dlm/dlmlock.c
index 66c2a49..7496231 100644
--- a/fs/ocfs2/dlm/dlmlock.c
+++ b/fs/ocfs2/dlm/dlmlock.c
@@ -77,8 +77,7 @@ int dlm_init_lock_cache(void)

 void dlm_destroy_lock_cache(void)
 {
-	if (dlm_lock_cache)
-		kmem_cache_destroy(dlm_lock_cache);
+	kmem_cache_destroy(dlm_lock_cache);
 }

 /* Tell us whether we can grant a new lock request.
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 9c3e0f1..d82f12d 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -414,8 +414,7 @@ int dlm_init_mle_cache(void)

 void dlm_destroy_mle_cache(void)
 {
-	if (dlm_mle_cache)
-		kmem_cache_destroy(dlm_mle_cache);
+	kmem_cache_destroy(dlm_mle_cache);
 }

 static void dlm_mle_release(struct kref *kref)
@@ -472,15 +471,11 @@ int dlm_init_master_caches(void)

 void dlm_destroy_master_caches(void)
 {
-	if (dlm_lockname_cache) {
-		kmem_cache_destroy(dlm_lockname_cache);
-		dlm_lockname_cache = NULL;
-	}
+	kmem_cache_destroy(dlm_lockname_cache);
+	dlm_lockname_cache = NULL;

-	if (dlm_lockres_cache) {
-		kmem_cache_destroy(dlm_lockres_cache);
-		dlm_lockres_cache = NULL;
-	}
+	kmem_cache_destroy(dlm_lockres_cache);
+	dlm_lockres_cache = NULL;
 }

 static void dlm_lockres_release(struct kref *kref)
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 52435f5..b0f37f0 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1767,12 +1767,9 @@ static int ocfs2_initialize_mem_caches(void)
 					NULL);
 	if (!ocfs2_inode_cachep || !ocfs2_dquot_cachep ||
 	    !ocfs2_qf_chunk_cachep) {
-		if (ocfs2_inode_cachep)
-			kmem_cache_destroy(ocfs2_inode_cachep);
-		if (ocfs2_dquot_cachep)
-			kmem_cache_destroy(ocfs2_dquot_cachep);
-		if (ocfs2_qf_chunk_cachep)
-			kmem_cache_destroy(ocfs2_qf_chunk_cachep);
+		kmem_cache_destroy(ocfs2_inode_cachep);
+		kmem_cache_destroy(ocfs2_dquot_cachep);
+		kmem_cache_destroy(ocfs2_qf_chunk_cachep);
 		return -ENOMEM;
 	}

@@ -1786,16 +1783,13 @@ static void ocfs2_free_mem_caches(void)
 	 * destroy cache.
 	 */
 	rcu_barrier();
-	if (ocfs2_inode_cachep)
-		kmem_cache_destroy(ocfs2_inode_cachep);
+	kmem_cache_destroy(ocfs2_inode_cachep);
 	ocfs2_inode_cachep = NULL;

-	if (ocfs2_dquot_cachep)
-		kmem_cache_destroy(ocfs2_dquot_cachep);
+	kmem_cache_destroy(ocfs2_dquot_cachep);
 	ocfs2_dquot_cachep = NULL;

-	if (ocfs2_qf_chunk_cachep)
-		kmem_cache_destroy(ocfs2_qf_chunk_cachep);
+	kmem_cache_destroy(ocfs2_qf_chunk_cachep);
 	ocfs2_qf_chunk_cachep = NULL;
 }

diff --git a/fs/ocfs2/uptodate.c b/fs/ocfs2/uptodate.c
index 82e17b0..78f09c7 100644
--- a/fs/ocfs2/uptodate.c
+++ b/fs/ocfs2/uptodate.c
@@ -633,6 +633,5 @@ int __init init_ocfs2_uptodate_cache(void)

 void exit_ocfs2_uptodate_cache(void)
 {
-	if (ocfs2_uptodate_cachep)
-		kmem_cache_destroy(ocfs2_uptodate_cachep);
+	kmem_cache_destroy(ocfs2_uptodate_cachep);
 }
-- 
