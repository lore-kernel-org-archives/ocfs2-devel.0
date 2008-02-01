From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri Feb  1 16:50:02 2008
Subject: [Ocfs2-devel] [PATCH 02/12] ocfs2_dlm: Creates slabcaches for the
	lockres' and the locks
In-Reply-To: <1201913371-1522-1-git-send-email-sunil.mushran@oracle.com>
References: <1201913371-1522-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1201913371-1522-3-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch makes the o2dlm allocate memory for lockres, lockname and lock
structures from slabcaches rather than kmalloc. This allows us to not only
make these allocs more efficient but also allows us to track the memory being
consumed by these structures.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmcommon.h |   10 +++++++
 fs/ocfs2/dlm/dlmdomain.c |   33 ++++++++++++++++++++---
 fs/ocfs2/dlm/dlmlock.c   |   23 +++++++++++++++-
 fs/ocfs2/dlm/dlmmaster.c |   65 +++++++++++++++++++++++++++++++++++++--------
 4 files changed, 113 insertions(+), 18 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index f3afb15..041ec68 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -944,9 +944,19 @@ static inline void __dlm_wait_on_lockres(struct dlm_lock_resource *res)
 					  DLM_LOCK_RES_MIGRATING));
 }
 
+/* create/destroy slab caches */
+int dlm_init_lockres_cache(void);
+void dlm_destroy_lockres_cache(void);
+
+int dlm_init_lockname_cache(void);
+void dlm_destroy_lockname_cache(void);
+
+int dlm_init_lock_cache(void);
+void dlm_destroy_lock_cache(void);
 
 int dlm_init_mle_cache(void);
 void dlm_destroy_mle_cache(void);
+
 void dlm_hb_event_notify_attached(struct dlm_ctxt *dlm, int idx, int node_up);
 int dlm_drop_lockres_ref(struct dlm_ctxt *dlm,
 			 struct dlm_lock_resource *res);
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 502712b..6d02ef5 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -1650,24 +1650,49 @@ static int __init dlm_init(void)
 	status = dlm_init_mle_cache();
 	if (status) {
 		mlog(ML_ERROR, "Could not create o2dlm_mle slabcache\n");
-		return -1;
+		goto error;
 	}
 
-	status = dlm_register_net_handlers();
+	status = dlm_init_lockres_cache();
+	if (status) {
+		mlog(ML_ERROR, "Could not create o2dlm_lockres slabcache\n");
+		goto error;
+	}
+
+	status = dlm_init_lockname_cache();
 	if (status) {
-		dlm_destroy_mle_cache();
-		return -1;
+		mlog(ML_ERROR, "Could not create o2dlm_lockname slabcache\n");
+		goto error;
 	}
 
+	status = dlm_init_lock_cache();
+	if (status) {
+		mlog(ML_ERROR, "Could not create o2dlm_lock slabcache\n");
+		goto error;
+	}
+
+	status = dlm_register_net_handlers();
+	if (status)
+		goto error;
+
 	dlm_init_proc();
 
 	return 0;
+error:
+	dlm_destroy_lock_cache();
+	dlm_destroy_lockname_cache();
+	dlm_destroy_lockres_cache();
+	dlm_destroy_mle_cache();
+	return -1;
 }
 
 static void __exit dlm_exit (void)
 {
 	dlm_remove_proc();
 	dlm_unregister_net_handlers();
+	dlm_destroy_lock_cache();
+	dlm_destroy_lockname_cache();
+	dlm_destroy_lockres_cache();
 	dlm_destroy_mle_cache();
 }
 
diff --git a/fs/ocfs2/dlm/dlmlock.c b/fs/ocfs2/dlm/dlmlock.c
index 52578d9..ea393b6 100644
--- a/fs/ocfs2/dlm/dlmlock.c
+++ b/fs/ocfs2/dlm/dlmlock.c
@@ -53,6 +53,8 @@
 #define MLOG_MASK_PREFIX ML_DLM
 #include "cluster/masklog.h"
 
+static struct kmem_cache *dlm_lock_cache = NULL;
+
 static DEFINE_SPINLOCK(dlm_cookie_lock);
 static u64 dlm_next_cookie = 1;
 
@@ -64,6 +66,22 @@ static void dlm_init_lock(struct dlm_lock *newlock, int type,
 static void dlm_lock_release(struct kref *kref);
 static void dlm_lock_detach_lockres(struct dlm_lock *lock);
 
+int dlm_init_lock_cache(void)
+{
+	dlm_lock_cache = kapi_kmem_cache_create("o2dlm_lock",
+						sizeof(struct dlm_lock),
+						0, SLAB_HWCACHE_ALIGN, NULL);
+	if (dlm_lock_cache == NULL)
+		return -ENOMEM;
+	return 0;
+}
+
+void dlm_destroy_lock_cache(void)
+{
+	if (dlm_lock_cache)
+		kmem_cache_destroy(dlm_lock_cache);
+}
+
 /* Tell us whether we can grant a new lock request.
  * locking:
  *   caller needs:  res->spinlock
@@ -353,7 +371,7 @@ static void dlm_lock_release(struct kref *kref)
 		mlog(0, "freeing kernel-allocated lksb\n");
 		kfree(lock->lksb);
 	}
-	kfree(lock);
+	kmem_cache_free(dlm_lock_cache, lock);
 }
 
 /* associate a lock with it's lockres, getting a ref on the lockres */
@@ -412,9 +430,10 @@ struct dlm_lock * dlm_new_lock(int type, u8 node, u64 cookie,
 	struct dlm_lock *lock;
 	int kernel_allocated = 0;
 
-	lock = kzalloc(sizeof(*lock), GFP_NOFS);
+	lock = (struct dlm_lock *) kmem_cache_alloc(dlm_lock_cache, GFP_NOFS);
 	if (!lock)
 		return NULL;
+	memset(lock, 0, sizeof(struct dlm_lock));
 
 	if (!lksb) {
 		/* zero memory only if kernel-allocated */
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index cc4e624..939b863 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -214,8 +214,9 @@ int dlm_dump_all_mles(const char __user *data, unsigned int len)
 EXPORT_SYMBOL_GPL(dlm_dump_all_mles);
 
 
-
-
+/* dlm slab caches */
+static struct kmem_cache *dlm_lockres_cache = NULL;
+static struct kmem_cache *dlm_lockname_cache = NULL;
 static struct kmem_cache *dlm_mle_cache = NULL;
 
 
@@ -559,6 +560,38 @@ static void dlm_mle_release(struct kref *kref)
  * LOCK RESOURCE FUNCTIONS
  */
 
+int dlm_init_lockres_cache(void)
+{
+	dlm_lockres_cache = kapi_kmem_cache_create("o2dlm_lockres",
+					sizeof(struct dlm_lock_resource), 0,
+					SLAB_HWCACHE_ALIGN, NULL);
+	if (dlm_lockres_cache == NULL)
+		return -ENOMEM;
+	return 0;
+}
+
+void dlm_destroy_lockres_cache(void)
+{
+	if (dlm_lockres_cache)
+		kmem_cache_destroy(dlm_lockres_cache);
+}
+
+int dlm_init_lockname_cache(void)
+{
+	dlm_lockname_cache = kapi_kmem_cache_create("o2dlm_lockname",
+						    DLM_LOCKID_NAME_MAX, 0,
+						    SLAB_HWCACHE_ALIGN, NULL);
+	if (dlm_lockname_cache == NULL)
+		return -ENOMEM;
+	return 0;
+}
+
+void dlm_destroy_lockname_cache(void)
+{
+	if (dlm_lockname_cache)
+		kmem_cache_destroy(dlm_lockname_cache);
+}
+
 static void dlm_set_lockres_owner(struct dlm_ctxt *dlm,
 				  struct dlm_lock_resource *res,
 				  u8 owner)
@@ -641,9 +674,9 @@ static void dlm_lockres_release(struct kref *kref)
 	BUG_ON(!list_empty(&res->recovering));
 	BUG_ON(!list_empty(&res->purge));
 
-	kfree(res->lockname.name);
+	kmem_cache_free(dlm_lockname_cache, (void *)res->lockname.name);
 
-	kfree(res);
+	kmem_cache_free(dlm_lockres_cache, res);
 }
 
 void dlm_lockres_put(struct dlm_lock_resource *res)
@@ -699,20 +732,28 @@ struct dlm_lock_resource *dlm_new_lockres(struct dlm_ctxt *dlm,
 				   const char *name,
 				   unsigned int namelen)
 {
-	struct dlm_lock_resource *res;
+	struct dlm_lock_resource *res = NULL;
 
-	res = kmalloc(sizeof(struct dlm_lock_resource), GFP_NOFS);
+	res = (struct dlm_lock_resource *)
+				kmem_cache_alloc(dlm_lockres_cache, GFP_NOFS);
 	if (!res)
-		return NULL;
+		goto error;
 
-	res->lockname.name = kmalloc(namelen, GFP_NOFS);
-	if (!res->lockname.name) {
-		kfree(res);
-		return NULL;
-	}
+	res->lockname.name = (char *)
+				kmem_cache_alloc(dlm_lockname_cache, GFP_NOFS);
+	if (!res->lockname.name)
+		goto error;
 
 	dlm_init_lockres(dlm, res, name, namelen);
 	return res;
+
+error:
+	if (res && res->lockname.name)
+		kmem_cache_free(dlm_lockname_cache, (void *)res->lockname.name);
+
+	if (res)
+		kmem_cache_free(dlm_lockres_cache, res);
+	return NULL;
 }
 
 void __dlm_lockres_grab_inflight_ref(struct dlm_ctxt *dlm,
-- 
1.5.2.5
