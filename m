From: Julia Lawall <julia@diku.dk>
Date: Tue, 11 May 2010 18:28:24 -0000
Subject: [Ocfs2-devel] [PATCH 4/5] fs/ocfs2/dlm: Drop memory allocation cast
Message-ID: <Pine.LNX.4.64.1005112027000.4330@ask.diku.dk>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>, Joel Becker <joel.becker@oracle.com>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Drop cast on the result of kmalloc and similar functions.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
type T;
@@

- (T *)
  (\(kmalloc\|kzalloc\|kcalloc\|kmem_cache_alloc\|kmem_cache_zalloc\|
   kmem_cache_alloc_node\|kmalloc_node\|kzalloc_node\)(...))
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/ocfs2/dlm/dlmlock.c   |    2 +-
 fs/ocfs2/dlm/dlmmaster.c |   18 ++++++------------
 2 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmlock.c b/fs/ocfs2/dlm/dlmlock.c
index f1fba2a..69cf369 100644
--- a/fs/ocfs2/dlm/dlmlock.c
+++ b/fs/ocfs2/dlm/dlmlock.c
@@ -431,7 +431,7 @@ struct dlm_lock * dlm_new_lock(int type, u8 node, u64 cookie,
 	struct dlm_lock *lock;
 	int kernel_allocated = 0;
 
-	lock = (struct dlm_lock *) kmem_cache_zalloc(dlm_lock_cache, GFP_NOFS);
+	lock = kmem_cache_zalloc(dlm_lock_cache, GFP_NOFS);
 	if (!lock)
 		return NULL;
 
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 4fc6fd2..4a7506a 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -617,13 +617,11 @@ struct dlm_lock_resource *dlm_new_lockres(struct dlm_ctxt *dlm,
 {
 	struct dlm_lock_resource *res = NULL;
 
-	res = (struct dlm_lock_resource *)
-				kmem_cache_zalloc(dlm_lockres_cache, GFP_NOFS);
+	res = kmem_cache_zalloc(dlm_lockres_cache, GFP_NOFS);
 	if (!res)
 		goto error;
 
-	res->lockname.name = (char *)
-				kmem_cache_zalloc(dlm_lockname_cache, GFP_NOFS);
+	res->lockname.name = kmem_cache_zalloc(dlm_lockname_cache, GFP_NOFS);
 	if (!res->lockname.name)
 		goto error;
 
@@ -757,8 +755,7 @@ lookup:
 		spin_unlock(&dlm->spinlock);
 		mlog(0, "allocating a new resource\n");
 		/* nothing found and we need to allocate one. */
-		alloc_mle = (struct dlm_master_list_entry *)
-			kmem_cache_alloc(dlm_mle_cache, GFP_NOFS);
+		alloc_mle = kmem_cache_alloc(dlm_mle_cache, GFP_NOFS);
 		if (!alloc_mle)
 			goto leave;
 		res = dlm_new_lockres(dlm, lockid, namelen);
@@ -1542,8 +1539,7 @@ way_up_top:
 			spin_unlock(&dlm->master_lock);
 			spin_unlock(&dlm->spinlock);
 
-			mle = (struct dlm_master_list_entry *)
-				kmem_cache_alloc(dlm_mle_cache, GFP_NOFS);
+			mle = kmem_cache_alloc(dlm_mle_cache, GFP_NOFS);
 			if (!mle) {
 				response = DLM_MASTER_RESP_ERROR;
 				mlog_errno(-ENOMEM);
@@ -2456,8 +2452,7 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
 		goto leave;
 	}
 
-	mle = (struct dlm_master_list_entry *) kmem_cache_alloc(dlm_mle_cache,
-								GFP_NOFS);
+	mle = kmem_cache_alloc(dlm_mle_cache, GFP_NOFS);
 	if (!mle) {
 		mlog_errno(ret);
 		goto leave;
@@ -3039,8 +3034,7 @@ int dlm_migrate_request_handler(struct o2net_msg *msg, u32 len, void *data,
 	hash = dlm_lockid_hash(name, namelen);
 
 	/* preallocate.. if this fails, abort */
-	mle = (struct dlm_master_list_entry *) kmem_cache_alloc(dlm_mle_cache,
-							 GFP_NOFS);
+	mle = kmem_cache_alloc(dlm_mle_cache, GFP_NOFS);
 
 	if (!mle) {
 		ret = -ENOMEM;
