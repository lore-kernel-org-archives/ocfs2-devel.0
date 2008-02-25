From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon Feb 25 12:21:17 2008
Subject: [Ocfs2-devel] [PATCH 15/18] ocfs2_dlm: Move dlm_print_one_mle()
	from dlmmaster.c to dlmdebug.c
In-Reply-To: <1203970862-8790-1-git-send-email-sunil.mushran@oracle.com>
References: <1203970862-8790-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1203970862-8790-16-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch helps in consolidating debugging related functions in dlmdebug.c.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmcommon.h |    1 -
 fs/ocfs2/dlm/dlmdebug.c  |   15 +++++++-
 fs/ocfs2/dlm/dlmdebug.h  |    2 +
 fs/ocfs2/dlm/dlmmaster.c |   87 +---------------------------------------------
 4 files changed, 17 insertions(+), 88 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index 1d05ebf..ba192c0 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -1006,7 +1006,6 @@ int dlm_drop_lockres_ref(struct dlm_ctxt *dlm,
 void dlm_clean_master_list(struct dlm_ctxt *dlm,
 			   u8 dead_node);
 int dlm_lock_basts_flushed(struct dlm_ctxt *dlm, struct dlm_lock *lock);
-int dlm_dump_all_mles(const char __user *data, unsigned int len);
 int __dlm_lockres_has_locks(struct dlm_lock_resource *res);
 int __dlm_lockres_unused(struct dlm_lock_resource *res);
 
diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index e8fa5a9..24d2f5c 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -46,6 +46,8 @@
 
 static struct dentry *dlm_debugfs_root = NULL;
 
+int dump_mle(struct dlm_master_list_entry *mle, char *buf, int len);
+
 static void dlm_print_lockres_refmap(struct dlm_lock_resource *res)
 {
 	int bit;
@@ -139,6 +141,17 @@ void dlm_print_one_lock(struct dlm_lock *lockid)
 }
 EXPORT_SYMBOL_GPL(dlm_print_one_lock);
 
+void dlm_print_one_mle(struct dlm_master_list_entry *mle)
+{
+	char *buf;
+
+	buf = (char *) get_zeroed_page(GFP_NOFS);
+	if (buf) {
+		dump_mle(mle, buf, PAGE_SIZE - 1);
+		free_page((unsigned long)buf);
+	}
+}
+
 static const char *dlm_errnames[] = {
 	[DLM_NORMAL] =			"DLM_NORMAL",
 	[DLM_GRANTED] =			"DLM_GRANTED",
@@ -509,7 +522,7 @@ static struct file_operations debug_purgelist_fops = {
 /* end - purge list funcs */
 
 /* begin - debug mle funcs */
-static int dump_mle(struct dlm_master_list_entry *mle, char *buf, int len)
+int dump_mle(struct dlm_master_list_entry *mle, char *buf, int len)
 {
 	int out = 0;
 	unsigned int namelen;
diff --git a/fs/ocfs2/dlm/dlmdebug.h b/fs/ocfs2/dlm/dlmdebug.h
index f6537ac..cf5ada9 100644
--- a/fs/ocfs2/dlm/dlmdebug.h
+++ b/fs/ocfs2/dlm/dlmdebug.h
@@ -57,4 +57,6 @@ void dlm_destroy_debugfs_subroot(struct dlm_ctxt *dlm);
 int dlm_create_debugfs_root(void);
 void dlm_destroy_debugfs_root(void);
 
+void dlm_print_one_mle(struct dlm_master_list_entry *mle);
+
 #endif
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index c491b9e..3d681fe 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -48,6 +48,7 @@
 #include "dlmapi.h"
 #include "dlmcommon.h"
 #include "dlmdomain.h"
+#include "dlmdebug.h"
 
 #define MLOG_MASK_PREFIX (ML_DLM|ML_DLM_MASTER)
 #include "cluster/masklog.h"
@@ -90,92 +91,6 @@ static inline int dlm_mle_equal(struct dlm_ctxt *dlm,
 	return 1;
 }
 
-#define dlm_print_nodemap(m)  _dlm_print_nodemap(m,#m)
-static void _dlm_print_nodemap(unsigned long *map, const char *mapname)
-{
-	int i;
-	printk("%s=[ ", mapname);
-	for (i=0; i<O2NM_MAX_NODES; i++)
-		if (test_bit(i, map))
-			printk("%d ", i);
-	printk("]");
-}
-
-static void dlm_print_one_mle(struct dlm_master_list_entry *mle)
-{
-	int refs;
-	char *type;
-	char attached;
-	u8 master;
-	unsigned int namelen;
-	const char *name;
-	struct kref *k;
-	unsigned long *maybe = mle->maybe_map,
-		      *vote = mle->vote_map,
-		      *resp = mle->response_map,
-		      *node = mle->node_map;
-
-	k = &mle->mle_refs;
-	if (mle->type == DLM_MLE_BLOCK)
-		type = "BLK";
-	else if (mle->type == DLM_MLE_MASTER)
-		type = "MAS";
-	else
-		type = "MIG";
-	refs = atomic_read(&k->refcount);
-	master = mle->master;
-	attached = (list_empty(&mle->hb_events) ? 'N' : 'Y');
-
-	if (mle->type != DLM_MLE_MASTER) {
-		namelen = mle->u.name.len;
-		name = mle->u.name.name;
-	} else {
-		namelen = mle->u.res->lockname.len;
-		name = mle->u.res->lockname.name;
-	}
-
-	mlog(ML_NOTICE, "%.*s: %3s refs=%3d mas=%3u new=%3u evt=%c inuse=%d ",
-		  namelen, name, type, refs, master, mle->new_master, attached,
-		  mle->inuse);
-	dlm_print_nodemap(maybe);
-	printk(", ");
-	dlm_print_nodemap(vote);
-	printk(", ");
-	dlm_print_nodemap(resp);
-	printk(", ");
-	dlm_print_nodemap(node);
-	printk(", ");
-	printk("\n");
-}
-
-
-/* Code here is included but defined out as it aids debugging */
-
-static void dlm_dump_mles(struct dlm_ctxt *dlm)
-{
-	struct dlm_master_list_entry *mle;
-	
-	mlog(ML_NOTICE, "dumping all mles for domain %s:\n", dlm->name);
-	spin_lock(&dlm->master_lock);
-	list_for_each_entry(mle, &dlm->master_list, list)
-		dlm_print_one_mle(mle);
-	spin_unlock(&dlm->master_lock);
-}
-
-int dlm_dump_all_mles(const char __user *data, unsigned int len)
-{
-	struct dlm_ctxt *dlm;
-
-	spin_lock(&dlm_domain_lock);
-	list_for_each_entry(dlm, &dlm_domains, list) {
-		mlog(ML_NOTICE, "found dlm: %p, name=%s\n", dlm, dlm->name);
-		dlm_dump_mles(dlm);
-	}
-	spin_unlock(&dlm_domain_lock);
-	return len;
-}
-EXPORT_SYMBOL_GPL(dlm_dump_all_mles);
-
 
 /* dlm slab caches */
 static struct kmem_cache *dlm_lockres_cache = NULL;
-- 
1.5.2.5
