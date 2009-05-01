From: wengang wang <wen.gang.wang@oracle.com>
Date: Fri,  1 May 2009 12:55:44 +0800
Subject: [Ocfs2-devel] [PATCH 1/3] OCFS2: speed up dlm_lockr_resouce
	hash_table lookups
Message-ID: <200905010456.n414ulIF029349@rgminet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

use multiple pages for the hash table.

mainline git commit: 03d864c02c3ea803b1718940ac6953a257182d7a
Authored-by: Daniel Phillips <phillips@google.com>
Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
--
Index: ocfs2-1.2/fs/ocfs2/dlm/dlmdomain.c
===================================================================
--- ocfs2-1.2/fs/ocfs2/dlm/dlmdomain.c	(revision 1)
+++ ocfs2-1.2/fs/ocfs2/dlm/dlmdomain.c	(revision 2)
@@ -79,6 +79,33 @@ static inline void byte_copymap(u8 dmap[
 			byte_set_bit(nn, dmap);
 }
 
+static void dlm_free_pagevec(void **vec, int pages)
+{
+	while (pages--)
+		free_page((unsigned long)vec[pages]);
+	kfree(vec);
+}
+
+static void **dlm_alloc_pagevec(int pages)
+{
+	void **vec = kmalloc(pages * sizeof(void *), GFP_KERNEL);
+	int i;
+
+	if (!vec)
+		return NULL;
+
+	for (i = 0; i < pages; i++) {
+		vec[i] = (void *)__get_free_page(GFP_KERNEL);
+		if (!vec[i])
+			goto out_free;
+	}
+	return vec;
+out_free:
+	dlm_free_pagevec(vec, i);
+	return NULL;
+
+}
+
 /*
  *
  * spinlock lock ordering: if multiple locks are needed, obey this ordering:
@@ -127,7 +154,7 @@ void __dlm_insert_lockres(struct dlm_ctx
 
 	q = &res->lockname;
 	q->hash = full_name_hash(q->name, q->len);
-	bucket = &(dlm->lockres_hash[q->hash % DLM_HASH_BUCKETS]);
+	bucket = dlm_lockres_hash(dlm, q->hash);
 
 	/* get a reference for our hashtable */
 	dlm_lockres_get(res);
@@ -151,7 +178,7 @@ struct dlm_lock_resource * __dlm_lookup_
 
 	hash = full_name_hash(name, len);
 
-	bucket = &(dlm->lockres_hash[hash % DLM_HASH_BUCKETS]);
+	bucket = dlm_lockres_hash(dlm, hash);
 
 	/* check for pre-existing lock */
 	hlist_for_each(iter, bucket) {
@@ -262,7 +289,7 @@ static void dlm_free_ctxt_mem(struct dlm
 	dlm_proc_del_domain(dlm);
 
 	if (dlm->lockres_hash)
-		free_page((unsigned long) dlm->lockres_hash);
+		dlm_free_pagevec((void **)dlm->lockres_hash, DLM_HASH_PAGES);
 
 	if (dlm->name)
 		kfree(dlm->name);
@@ -394,7 +421,8 @@ static int dlm_migrate_all_locks(struct 
 	for (i = 0; i < DLM_HASH_BUCKETS; i++) {
 redo_bucket:
 		n = 0;
-		bucket = &dlm->lockres_hash[i];
+		bucket = dlm_lockres_hash(dlm, i);
+		dlm_lockres_hash(dlm, i);
 		iter = bucket->first;
 		while (iter) {
 			n++;
@@ -1356,7 +1384,8 @@ static struct dlm_ctxt *dlm_alloc_ctxt(c
 		goto leave;
 	}
 
-	dlm->lockres_hash = (struct hlist_head *) __get_free_page(GFP_KERNEL);
+	dlm->lockres_hash = (struct hlist_head **)
+					dlm_alloc_pagevec(DLM_HASH_PAGES);
 	if (!dlm->lockres_hash) {
 		mlog_errno(-ENOMEM);
 		kfree(dlm->name);
@@ -1365,8 +1394,8 @@ static struct dlm_ctxt *dlm_alloc_ctxt(c
 		goto leave;
 	}
 
-	for (i=0; i<DLM_HASH_BUCKETS; i++)
-		INIT_HLIST_HEAD(&dlm->lockres_hash[i]);
+	for (i = 0; i < DLM_HASH_BUCKETS; i++)
+		INIT_HLIST_HEAD(dlm_lockres_hash(dlm, i));
 
 	strcpy(dlm->name, domain);
 	dlm->key = key;
Index: ocfs2-1.2/fs/ocfs2/dlm/dlmdebug.c
===================================================================
--- ocfs2-1.2/fs/ocfs2/dlm/dlmdebug.c	(revision 1)
+++ ocfs2-1.2/fs/ocfs2/dlm/dlmdebug.c	(revision 2)
@@ -547,7 +547,7 @@ void dlm_dump_lock_resources(struct dlm_
 
 	spin_lock(&dlm->spinlock);
 	for (i=0; i<DLM_HASH_BUCKETS; i++) {
-		bucket = &(dlm->lockres_hash[i]);
+		bucket = dlm_lockres_hash(dlm, i);
 		hlist_for_each_entry(res, iter, bucket, hash_node)
 			dlm_print_one_lock_resource(res);
 	}
Index: ocfs2-1.2/fs/ocfs2/dlm/dlmcommon.h
===================================================================
--- ocfs2-1.2/fs/ocfs2/dlm/dlmcommon.h	(revision 1)
+++ ocfs2-1.2/fs/ocfs2/dlm/dlmcommon.h	(revision 2)
@@ -37,7 +37,10 @@
 #define DLM_THREAD_SHUFFLE_INTERVAL    5     // flush everything every 5 passes
 #define DLM_THREAD_MS                  200   // flush at least every 200 ms
 
-#define DLM_HASH_BUCKETS     (PAGE_SIZE / sizeof(struct hlist_head))
+#define DLM_HASH_SIZE		(1 << 14)
+#define DLM_HASH_PAGES		(DLM_HASH_SIZE / PAGE_SIZE)
+#define DLM_BUCKETS_PER_PAGE	(PAGE_SIZE / sizeof(struct hlist_head))
+#define DLM_HASH_BUCKETS	(DLM_HASH_PAGES * DLM_BUCKETS_PER_PAGE)
 
 enum dlm_ast_type {
 	DLM_AST = 0,
@@ -86,7 +89,7 @@ enum dlm_ctxt_state {
 struct dlm_ctxt
 {
 	struct list_head list;
-	struct hlist_head *lockres_hash;
+	struct hlist_head **lockres_hash;
 	struct list_head dirty_list;
 	struct list_head purge_list;
 	struct list_head pending_asts;
@@ -136,6 +139,13 @@ struct dlm_ctxt
 	struct list_head	dlm_eviction_callbacks;
 };
 
+static inline
+struct hlist_head *dlm_lockres_hash(struct dlm_ctxt *dlm, unsigned i)
+{
+	return dlm->lockres_hash[(i / DLM_BUCKETS_PER_PAGE) % DLM_HASH_PAGES]
+						+ (i % DLM_BUCKETS_PER_PAGE);
+}
+
 /* these keventd work queue items are for less-frequently
  * called functions that cannot be directly called from the
  * net message handlers for some reason, usually because
Index: ocfs2-1.2/fs/ocfs2/dlm/dlmrecovery.c
===================================================================
--- ocfs2-1.2/fs/ocfs2/dlm/dlmrecovery.c	(revision 1)
+++ ocfs2-1.2/fs/ocfs2/dlm/dlmrecovery.c	(revision 2)
@@ -2064,7 +2064,7 @@ static void dlm_finish_local_lockres_rec
 	 * the RECOVERING state and set the owner
 	 * if necessary */
 	for (i = 0; i < DLM_HASH_BUCKETS; i++) {
-		bucket = &(dlm->lockres_hash[i]);
+		bucket = dlm_lockres_hash(dlm, i);
 		hlist_for_each_entry(res, hash_iter, bucket, hash_node) {
 			if (res->state & DLM_LOCK_RES_RECOVERING) {
 				if (res->owner == dead_node) {
@@ -2259,7 +2259,7 @@ static void dlm_do_local_recovery_cleanu
 	 *    need to be fired as a result.
 	 */
  	for (i = 0; i < DLM_HASH_BUCKETS; i++) {
- 		bucket = &(dlm->lockres_hash[i]);
+		bucket = dlm_lockres_hash(dlm, i);
  		hlist_for_each_entry(res, iter, bucket, hash_node) {
 			/* always prune any $RECOVERY entries for dead nodes,
 			 * otherwise hangs can occur during later recovery */
