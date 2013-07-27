From: Dong Fang <yp.fangdong@gmail.com>
Date: Sat, 27 Jul 2013 01:26:55 -0400
Subject: [Ocfs2-devel] [PATCH] fs/ocfs2: use list_for_each_entry() instead
	of list_for_each()
Message-ID: <1374902815-13349-1-git-send-email-yp.fangdong@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@suse.com, jlbec@evilplan.org, akpm@linux-foundation.org, jeff.liu@oracle.com, viro@zeniv.linux.org.uk, sunil.mushran@gmail.com, tim.gardner@canonical.com, xuejiufei@huawei.com, shencanquan@huawei.com, dan.carpenter@oracle.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, Dong Fang <yp.fangdong@gmail.com>


Signed-off-by: Dong Fang <yp.fangdong@gmail.com>
---
 fs/ocfs2/cluster/heartbeat.c |   14 +++++---------
 fs/ocfs2/dlm/dlmast.c        |    8 +++-----
 fs/ocfs2/dlm/dlmcommon.h     |    4 +---
 fs/ocfs2/dlm/dlmconvert.c    |   11 +++--------
 fs/ocfs2/dlm/dlmdebug.c      |   15 ++++-----------
 fs/ocfs2/dlm/dlmdomain.c     |   20 +++++---------------
 fs/ocfs2/dlm/dlmlock.c       |    9 ++-------
 fs/ocfs2/dlm/dlmmaster.c     |   17 ++++-------------
 fs/ocfs2/dlm/dlmthread.c     |   19 +++++--------------
 fs/ocfs2/dlm/dlmunlock.c     |    4 +---
 10 files changed, 33 insertions(+), 88 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 5c1c864..25b72e8 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -628,11 +628,9 @@ static void o2hb_fire_callbacks(struct o2hb_callback *hbcall,
 				struct o2nm_node *node,
 				int idx)
 {
-	struct list_head *iter;
 	struct o2hb_callback_func *f;
 
-	list_for_each(iter, &hbcall->list) {
-		f = list_entry(iter, struct o2hb_callback_func, hc_item);
+	list_for_each_entry(f, &hbcall->list, hc_item) {
 		mlog(ML_HEARTBEAT, "calling funcs %p\n", f);
 		(f->hc_func)(node, idx, f->hc_data);
 	}
@@ -2516,8 +2514,7 @@ unlock:
 int o2hb_register_callback(const char *region_uuid,
 			   struct o2hb_callback_func *hc)
 {
-	struct o2hb_callback_func *tmp;
-	struct list_head *iter;
+	struct o2hb_callback_func *f;
 	struct o2hb_callback *hbcall;
 	int ret;
 
@@ -2540,10 +2537,9 @@ int o2hb_register_callback(const char *region_uuid,
 
 	down_write(&o2hb_callback_sem);
 
-	list_for_each(iter, &hbcall->list) {
-		tmp = list_entry(iter, struct o2hb_callback_func, hc_item);
-		if (hc->hc_priority < tmp->hc_priority) {
-			list_add_tail(&hc->hc_item, iter);
+	list_for_each_entry(f, &hbcall->list, hc_item) {
+		if (hc->hc_priority < f->hc_priority) {
+			list_add_tail(&hc->hc_item, &f->hc_item);
 			break;
 		}
 	}
diff --git a/fs/ocfs2/dlm/dlmast.c b/fs/ocfs2/dlm/dlmast.c
index fbec0be..b46278f 100644
--- a/fs/ocfs2/dlm/dlmast.c
+++ b/fs/ocfs2/dlm/dlmast.c
@@ -292,7 +292,7 @@ int dlm_proxy_ast_handler(struct o2net_msg *msg, u32 len, void *data,
 	struct dlm_lock *lock = NULL;
 	struct dlm_proxy_ast *past = (struct dlm_proxy_ast *) msg->buf;
 	char *name;
-	struct list_head *iter, *head=NULL;
+	struct list_head *head = NULL;
 	__be64 cookie;
 	u32 flags;
 	u8 node;
@@ -373,8 +373,7 @@ int dlm_proxy_ast_handler(struct o2net_msg *msg, u32 len, void *data,
 	/* try convert queue for both ast/bast */
 	head = &res->converting;
 	lock = NULL;
-	list_for_each(iter, head) {
-		lock = list_entry (iter, struct dlm_lock, list);
+	list_for_each_entry(lock, head, list) {
 		if (lock->ml.cookie == cookie)
 			goto do_ast;
 	}
@@ -385,8 +384,7 @@ int dlm_proxy_ast_handler(struct o2net_msg *msg, u32 len, void *data,
 	else
 		head = &res->granted;
 
-	list_for_each(iter, head) {
-		lock = list_entry (iter, struct dlm_lock, list);
+	list_for_each_entry(lock, head, list) {
 		if (lock->ml.cookie == cookie)
 			goto do_ast;
 	}
diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index de854cc..e051776 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -1079,11 +1079,9 @@ static inline int dlm_lock_compatible(int existing, int request)
 static inline int dlm_lock_on_list(struct list_head *head,
 				   struct dlm_lock *lock)
 {
-	struct list_head *iter;
 	struct dlm_lock *tmplock;
 
-	list_for_each(iter, head) {
-		tmplock = list_entry(iter, struct dlm_lock, list);
+	list_for_each_entry(tmplock, head, list) {
 		if (tmplock == lock)
 			return 1;
 	}
diff --git a/fs/ocfs2/dlm/dlmconvert.c b/fs/ocfs2/dlm/dlmconvert.c
index 29a886d..a2bda15 100644
--- a/fs/ocfs2/dlm/dlmconvert.c
+++ b/fs/ocfs2/dlm/dlmconvert.c
@@ -123,7 +123,6 @@ static enum dlm_status __dlmconvert_master(struct dlm_ctxt *dlm,
 					   int *kick_thread)
 {
 	enum dlm_status status = DLM_NORMAL;
-	struct list_head *iter;
 	struct dlm_lock *tmplock=NULL;
 
 	assert_spin_locked(&res->spinlock);
@@ -185,16 +184,14 @@ static enum dlm_status __dlmconvert_master(struct dlm_ctxt *dlm,
 
 	/* upconvert from here on */
 	status = DLM_NORMAL;
-	list_for_each(iter, &res->granted) {
-		tmplock = list_entry(iter, struct dlm_lock, list);
+	list_for_each_entry(tmplock, &res->granted, list) {
 		if (tmplock == lock)
 			continue;
 		if (!dlm_lock_compatible(tmplock->ml.type, type))
 			goto switch_queues;
 	}
 
-	list_for_each(iter, &res->converting) {
-		tmplock = list_entry(iter, struct dlm_lock, list);
+	list_for_each_entry(tmplock, &res->converting, list) {
 		if (!dlm_lock_compatible(tmplock->ml.type, type))
 			goto switch_queues;
 		/* existing conversion requests take precedence */
@@ -424,7 +421,6 @@ int dlm_convert_lock_handler(struct o2net_msg *msg, u32 len, void *data,
 	struct dlm_ctxt *dlm = data;
 	struct dlm_convert_lock *cnv = (struct dlm_convert_lock *)msg->buf;
 	struct dlm_lock_resource *res = NULL;
-	struct list_head *iter;
 	struct dlm_lock *lock = NULL;
 	struct dlm_lockstatus *lksb;
 	enum dlm_status status = DLM_NORMAL;
@@ -471,8 +467,7 @@ int dlm_convert_lock_handler(struct o2net_msg *msg, u32 len, void *data,
 		dlm_error(status);
 		goto leave;
 	}
-	list_for_each(iter, &res->granted) {
-		lock = list_entry(iter, struct dlm_lock, list);
+	list_for_each_entry(lock, &res->granted, list) {
 		if (lock->ml.cookie == cnv->cookie &&
 		    lock->ml.node == cnv->node_idx) {
 			dlm_lock_get(lock);
diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index 0e28e24..e33cd7a 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -96,7 +96,6 @@ static void __dlm_print_lock(struct dlm_lock *lock)
 
 void __dlm_print_one_lock_resource(struct dlm_lock_resource *res)
 {
-	struct list_head *iter2;
 	struct dlm_lock *lock;
 	char buf[DLM_LOCKID_NAME_MAX];
 
@@ -118,18 +117,15 @@ void __dlm_print_one_lock_resource(struct dlm_lock_resource *res)
 	       res->inflight_locks, atomic_read(&res->asts_reserved));
 	dlm_print_lockres_refmap(res);
 	printk("  granted queue:\n");
-	list_for_each(iter2, &res->granted) {
-		lock = list_entry(iter2, struct dlm_lock, list);
+	list_for_each_entry(lock, &res->granted, list) {
 		__dlm_print_lock(lock);
 	}
 	printk("  converting queue:\n");
-	list_for_each(iter2, &res->converting) {
-		lock = list_entry(iter2, struct dlm_lock, list);
+	list_for_each_entry(lock, &res->converting, list) {
 		__dlm_print_lock(lock);
 	}
 	printk("  blocked queue:\n");
-	list_for_each(iter2, &res->blocked) {
-		lock = list_entry(iter2, struct dlm_lock, list);
+	list_for_each_entry(lock, &res->blocked, list) {
 		__dlm_print_lock(lock);
 	}
 }
@@ -446,7 +442,6 @@ static int debug_mle_print(struct dlm_ctxt *dlm, char *buf, int len)
 {
 	struct dlm_master_list_entry *mle;
 	struct hlist_head *bucket;
-	struct hlist_node *list;
 	int i, out = 0;
 	unsigned long total = 0, longest = 0, bucket_count = 0;
 
@@ -456,9 +451,7 @@ static int debug_mle_print(struct dlm_ctxt *dlm, char *buf, int len)
 	spin_lock(&dlm->master_lock);
 	for (i = 0; i < DLM_HASH_BUCKETS; i++) {
 		bucket = dlm_master_hash(dlm, i);
-		hlist_for_each(list, bucket) {
-			mle = hlist_entry(list, struct dlm_master_list_entry,
-					  master_hash_node);
+		hlist_for_each_entry(mle, bucket, master_hash_node) {
 			++total;
 			++bucket_count;
 			if (len - out < 200)
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index dbb17c0..b9b175c 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -193,7 +193,7 @@ struct dlm_lock_resource * __dlm_lookup_lockres_full(struct dlm_ctxt *dlm,
 						     unsigned int hash)
 {
 	struct hlist_head *bucket;
-	struct hlist_node *list;
+	struct dlm_lock_resource *res;
 
 	mlog(0, "%.*s\n", len, name);
 
@@ -201,9 +201,7 @@ struct dlm_lock_resource * __dlm_lookup_lockres_full(struct dlm_ctxt *dlm,
 
 	bucket = dlm_lockres_hash(dlm, hash);
 
-	hlist_for_each(list, bucket) {
-		struct dlm_lock_resource *res = hlist_entry(list,
-			struct dlm_lock_resource, hash_node);
+	hlist_for_each_entry(res, bucket, hash_node) {
 		if (res->lockname.name[0] != name[0])
 			continue;
 		if (unlikely(res->lockname.len != len))
@@ -263,14 +261,12 @@ struct dlm_lock_resource * dlm_lookup_lockres(struct dlm_ctxt *dlm,
 static struct dlm_ctxt * __dlm_lookup_domain_full(const char *domain, int len)
 {
 	struct dlm_ctxt *tmp = NULL;
-	struct list_head *iter;
 
 	assert_spin_locked(&dlm_domain_lock);
 
 	/* tmp->name here is always NULL terminated,
 	 * but domain may not be! */
-	list_for_each(iter, &dlm_domains) {
-		tmp = list_entry (iter, struct dlm_ctxt, list);
+	list_for_each_entry(tmp, &dlm_domains, list) {
 		if (strlen(tmp->name) == len &&
 		    memcmp(tmp->name, domain, len)==0)
 			break;
@@ -366,14 +362,11 @@ static void __dlm_get(struct dlm_ctxt *dlm)
  * you shouldn't trust your pointer. */
 struct dlm_ctxt *dlm_grab(struct dlm_ctxt *dlm)
 {
-	struct list_head *iter;
 	struct dlm_ctxt *target = NULL;
 
 	spin_lock(&dlm_domain_lock);
 
-	list_for_each(iter, &dlm_domains) {
-		target = list_entry (iter, struct dlm_ctxt, list);
-
+	list_for_each_entry(target, &dlm_domains, list) {
 		if (target == dlm) {
 			__dlm_get(target);
 			break;
@@ -2296,13 +2289,10 @@ static DECLARE_RWSEM(dlm_callback_sem);
 void dlm_fire_domain_eviction_callbacks(struct dlm_ctxt *dlm,
 					int node_num)
 {
-	struct list_head *iter;
 	struct dlm_eviction_cb *cb;
 
 	down_read(&dlm_callback_sem);
-	list_for_each(iter, &dlm->dlm_eviction_callbacks) {
-		cb = list_entry(iter, struct dlm_eviction_cb, ec_item);
-
+	list_for_each_entry(cb, &dlm->dlm_eviction_callbacks, ec_item) {
 		cb->ec_func(node_num, cb->ec_data);
 	}
 	up_read(&dlm_callback_sem);
diff --git a/fs/ocfs2/dlm/dlmlock.c b/fs/ocfs2/dlm/dlmlock.c
index 47e67c2..5d32f75 100644
--- a/fs/ocfs2/dlm/dlmlock.c
+++ b/fs/ocfs2/dlm/dlmlock.c
@@ -91,19 +91,14 @@ void dlm_destroy_lock_cache(void)
 static int dlm_can_grant_new_lock(struct dlm_lock_resource *res,
 				  struct dlm_lock *lock)
 {
-	struct list_head *iter;
 	struct dlm_lock *tmplock;
 
-	list_for_each(iter, &res->granted) {
-		tmplock = list_entry(iter, struct dlm_lock, list);
-
+	list_for_each_entry(tmplock, &res->granted, list) {
 		if (!dlm_lock_compatible(tmplock->ml.type, lock->ml.type))
 			return 0;
 	}
 
-	list_for_each(iter, &res->converting) {
-		tmplock = list_entry(iter, struct dlm_lock, list);
-
+	list_for_each_entry(tmplock, &res->converting, list) {
 		if (!dlm_lock_compatible(tmplock->ml.type, lock->ml.type))
 			return 0;
 		if (!dlm_lock_compatible(tmplock->ml.convert_type,
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 33ecbe0..24758f3 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -342,16 +342,13 @@ static int dlm_find_mle(struct dlm_ctxt *dlm,
 {
 	struct dlm_master_list_entry *tmpmle;
 	struct hlist_head *bucket;
-	struct hlist_node *list;
 	unsigned int hash;
 
 	assert_spin_locked(&dlm->master_lock);
 
 	hash = dlm_lockid_hash(name, namelen);
 	bucket = dlm_master_hash(dlm, hash);
-	hlist_for_each(list, bucket) {
-		tmpmle = hlist_entry(list, struct dlm_master_list_entry,
-				     master_hash_node);
+	hlist_for_each_entry(tmpmle, bucket, master_hash_node) {
 		if (!dlm_mle_equal(dlm, tmpmle, name, namelen))
 			continue;
 		dlm_get_mle(tmpmle);
@@ -3183,7 +3180,6 @@ void dlm_clean_master_list(struct dlm_ctxt *dlm, u8 dead_node)
 	struct dlm_master_list_entry *mle;
 	struct dlm_lock_resource *res;
 	struct hlist_head *bucket;
-	struct hlist_node *list;
 	unsigned int i;
 
 	mlog(0, "dlm=%s, dead node=%u\n", dlm->name, dead_node);
@@ -3194,10 +3190,7 @@ top:
 	spin_lock(&dlm->master_lock);
 	for (i = 0; i < DLM_HASH_BUCKETS; i++) {
 		bucket = dlm_master_hash(dlm, i);
-		hlist_for_each(list, bucket) {
-			mle = hlist_entry(list, struct dlm_master_list_entry,
-					  master_hash_node);
-
+		hlist_for_each_entry(mle, bucket, master_hash_node) {
 			BUG_ON(mle->type != DLM_MLE_BLOCK &&
 			       mle->type != DLM_MLE_MASTER &&
 			       mle->type != DLM_MLE_MIGRATION);
@@ -3378,7 +3371,7 @@ void dlm_force_free_mles(struct dlm_ctxt *dlm)
 	int i;
 	struct hlist_head *bucket;
 	struct dlm_master_list_entry *mle;
-	struct hlist_node *tmp, *list;
+	struct hlist_node *tmp;
 
 	/*
 	 * We notified all other nodes that we are exiting the domain and
@@ -3394,9 +3387,7 @@ void dlm_force_free_mles(struct dlm_ctxt *dlm)
 
 	for (i = 0; i < DLM_HASH_BUCKETS; i++) {
 		bucket = dlm_master_hash(dlm, i);
-		hlist_for_each_safe(list, tmp, bucket) {
-			mle = hlist_entry(list, struct dlm_master_list_entry,
-					  master_hash_node);
+		hlist_for_each_entry_safe(mle, tmp, bucket, master_hash_node) {
 			if (mle->type != DLM_MLE_BLOCK) {
 				mlog(ML_ERROR, "bad mle: %p\n", mle);
 				dlm_print_one_mle(mle);
diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
index e73c833..9db869d 100644
--- a/fs/ocfs2/dlm/dlmthread.c
+++ b/fs/ocfs2/dlm/dlmthread.c
@@ -286,8 +286,6 @@ static void dlm_shuffle_lists(struct dlm_ctxt *dlm,
 			      struct dlm_lock_resource *res)
 {
 	struct dlm_lock *lock, *target;
-	struct list_head *iter;
-	struct list_head *head;
 	int can_grant = 1;
 
 	/*
@@ -314,9 +312,7 @@ converting:
 		     dlm->name, res->lockname.len, res->lockname.name);
 		BUG();
 	}
-	head = &res->granted;
-	list_for_each(iter, head) {
-		lock = list_entry(iter, struct dlm_lock, list);
+	list_for_each_entry(lock, &res->granted, list) {
 		if (lock==target)
 			continue;
 		if (!dlm_lock_compatible(lock->ml.type,
@@ -333,9 +329,8 @@ converting:
 					target->ml.convert_type;
 		}
 	}
-	head = &res->converting;
-	list_for_each(iter, head) {
-		lock = list_entry(iter, struct dlm_lock, list);
+
+	list_for_each_entry(lock, &res->converting, list) {
 		if (lock==target)
 			continue;
 		if (!dlm_lock_compatible(lock->ml.type,
@@ -384,9 +379,7 @@ blocked:
 		goto leave;
 	target = list_entry(res->blocked.next, struct dlm_lock, list);
 
-	head = &res->granted;
-	list_for_each(iter, head) {
-		lock = list_entry(iter, struct dlm_lock, list);
+	list_for_each_entry(lock, &res->granted, list) {
 		if (lock==target)
 			continue;
 		if (!dlm_lock_compatible(lock->ml.type, target->ml.type)) {
@@ -400,9 +393,7 @@ blocked:
 		}
 	}
 
-	head = &res->converting;
-	list_for_each(iter, head) {
-		lock = list_entry(iter, struct dlm_lock, list);
+	list_for_each_entry(lock, &res->converting, list) {
 		if (lock==target)
 			continue;
 		if (!dlm_lock_compatible(lock->ml.type, target->ml.type)) {
diff --git a/fs/ocfs2/dlm/dlmunlock.c b/fs/ocfs2/dlm/dlmunlock.c
index 850aa7e..5698b52 100644
--- a/fs/ocfs2/dlm/dlmunlock.c
+++ b/fs/ocfs2/dlm/dlmunlock.c
@@ -388,7 +388,6 @@ int dlm_unlock_lock_handler(struct o2net_msg *msg, u32 len, void *data,
 	struct dlm_ctxt *dlm = data;
 	struct dlm_unlock_lock *unlock = (struct dlm_unlock_lock *)msg->buf;
 	struct dlm_lock_resource *res = NULL;
-	struct list_head *iter;
 	struct dlm_lock *lock = NULL;
 	enum dlm_status status = DLM_NORMAL;
 	int found = 0, i;
@@ -458,8 +457,7 @@ int dlm_unlock_lock_handler(struct o2net_msg *msg, u32 len, void *data,
 	}
 
 	for (i=0; i<3; i++) {
-		list_for_each(iter, queue) {
-			lock = list_entry(iter, struct dlm_lock, list);
+		list_for_each_entry(lock, queue, list) {
 			if (lock->ml.cookie == unlock->cookie &&
 		    	    lock->ml.node == unlock->node_idx) {
 				dlm_lock_get(lock);
-- 
1.7.1
