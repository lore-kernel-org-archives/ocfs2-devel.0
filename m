From: Christoph Hellwig <hch@lst.de>
Date: Thu May 17 07:03:47 2007
Subject: [Ocfs2-devel] [PATCH] ocfs: use list_for_each_entry where benefical
Message-ID: <20070517140313.GA28777@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/ocfs2/cluster/tcp.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/cluster/tcp.c	2007-05-06 13:51:17.000000000 +0200
+++ linux-2.6/fs/ocfs2/cluster/tcp.c	2007-05-17 15:00:14.000000000 +0200
@@ -261,14 +261,12 @@ out:
 
 static void o2net_complete_nodes_nsw(struct o2net_node *nn)
 {
-	struct list_head *iter, *tmp;
+	struct o2net_status_wait *nsw, *tmp;
 	unsigned int num_kills = 0;
-	struct o2net_status_wait *nsw;
 
 	assert_spin_locked(&nn->nn_lock);
 
-	list_for_each_safe(iter, tmp, &nn->nn_status_list) {
-		nsw = list_entry(iter, struct o2net_status_wait, ns_node_item);
+	list_for_each_entry_safe(nsw, tmp, &nn->nn_status_list, ns_node_item) {
 		o2net_complete_nsw_locked(nn, nsw, O2NET_ERR_DIED, 0);
 		num_kills++;
 	}
@@ -764,13 +762,10 @@ EXPORT_SYMBOL_GPL(o2net_register_handler
 
 void o2net_unregister_handler_list(struct list_head *list)
 {
-	struct list_head *pos, *n;
-	struct o2net_msg_handler *nmh;
+	struct o2net_msg_handler *nmh, *n;
 
 	write_lock(&o2net_handler_lock);
-	list_for_each_safe(pos, n, list) {
-		nmh = list_entry(pos, struct o2net_msg_handler,
-				 nh_unregister_item);
+	list_for_each_entry_safe(nmh, n, list, nh_unregister_item) {
 		mlog(ML_TCP, "unregistering handler func %p type %u key %08x\n",
 		     nmh->nh_func, nmh->nh_msg_type, nmh->nh_key);
 		rb_erase(&nmh->nh_node, &o2net_handler_tree);
Index: linux-2.6/fs/ocfs2/dlm/dlmmaster.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/dlm/dlmmaster.c	2007-04-30 11:33:04.000000000 +0200
+++ linux-2.6/fs/ocfs2/dlm/dlmmaster.c	2007-05-17 15:00:14.000000000 +0200
@@ -192,25 +192,20 @@ static void dlm_print_one_mle(struct dlm
 static void dlm_dump_mles(struct dlm_ctxt *dlm)
 {
 	struct dlm_master_list_entry *mle;
-	struct list_head *iter;
 	
 	mlog(ML_NOTICE, "dumping all mles for domain %s:\n", dlm->name);
 	spin_lock(&dlm->master_lock);
-	list_for_each(iter, &dlm->master_list) {
-		mle = list_entry(iter, struct dlm_master_list_entry, list);
+	list_for_each_entry(mle, &dlm->master_list, list)
 		dlm_print_one_mle(mle);
-	}
 	spin_unlock(&dlm->master_lock);
 }
 
 int dlm_dump_all_mles(const char __user *data, unsigned int len)
 {
-	struct list_head *iter;
 	struct dlm_ctxt *dlm;
 
 	spin_lock(&dlm_domain_lock);
-	list_for_each(iter, &dlm_domains) {
-		dlm = list_entry (iter, struct dlm_ctxt, list);
+	list_for_each_entry(dlm, &dlm_domains, list) {
 		mlog(ML_NOTICE, "found dlm: %p, name=%s\n", dlm, dlm->name);
 		dlm_dump_mles(dlm);
 	}
@@ -454,12 +449,10 @@ static int dlm_find_mle(struct dlm_ctxt 
 			char *name, unsigned int namelen)
 {
 	struct dlm_master_list_entry *tmpmle;
-	struct list_head *iter;
 
 	assert_spin_locked(&dlm->master_lock);
 
-	list_for_each(iter, &dlm->master_list) {
-		tmpmle = list_entry(iter, struct dlm_master_list_entry, list);
+	list_for_each_entry(tmpmle, &dlm->master_list, list) {
 		if (!dlm_mle_equal(dlm, tmpmle, name, namelen))
 			continue;
 		dlm_get_mle(tmpmle);
@@ -472,13 +465,10 @@ static int dlm_find_mle(struct dlm_ctxt 
 void dlm_hb_event_notify_attached(struct dlm_ctxt *dlm, int idx, int node_up)
 {
 	struct dlm_master_list_entry *mle;
-	struct list_head *iter;
 
 	assert_spin_locked(&dlm->spinlock);
 	
-	list_for_each(iter, &dlm->mle_hb_events) {
-		mle = list_entry(iter, struct dlm_master_list_entry, 
-				 hb_events);
+	list_for_each_entry(mle, &dlm->mle_hb_events, hb_events) {
 		if (node_up)
 			dlm_mle_node_up(dlm, mle, NULL, idx);
 		else
@@ -2434,7 +2424,7 @@ static int dlm_is_lockres_migrateable(st
 	int ret;
 	int i;
 	int count = 0;
-	struct list_head *queue, *iter;
+	struct list_head *queue;
 	struct dlm_lock *lock;
 
 	assert_spin_locked(&res->spinlock);
@@ -2453,8 +2443,7 @@ static int dlm_is_lockres_migrateable(st
 	ret = 0;
 	queue = &res->granted;
 	for (i = 0; i < 3; i++) {
-		list_for_each(iter, queue) {
-			lock = list_entry(iter, struct dlm_lock, list);
+		list_for_each_entry(lock, queue, list) {
 			++count;
 			if (lock->ml.node == dlm->node_num) {
 				mlog(0, "found a lock owned by this node still "
@@ -2923,18 +2912,16 @@ again:
 static void dlm_remove_nonlocal_locks(struct dlm_ctxt *dlm,
 				      struct dlm_lock_resource *res)
 {
-	struct list_head *iter, *iter2;
 	struct list_head *queue = &res->granted;
 	int i, bit;
-	struct dlm_lock *lock;
+	struct dlm_lock *lock, *next;
 
 	assert_spin_locked(&res->spinlock);
 
 	BUG_ON(res->owner == dlm->node_num);
 
 	for (i=0; i<3; i++) {
-		list_for_each_safe(iter, iter2, queue) {
-			lock = list_entry (iter, struct dlm_lock, list);
+		list_for_each_entry_safe(lock, next, queue, list) {
 			if (lock->ml.node != dlm->node_num) {
 				mlog(0, "putting lock for node %u\n",
 				     lock->ml.node);
@@ -2976,7 +2963,6 @@ static u8 dlm_pick_migration_target(stru
 {
 	int i;
 	struct list_head *queue = &res->granted;
-	struct list_head *iter;
 	struct dlm_lock *lock;
 	int nodenum;
 
@@ -2984,10 +2970,9 @@ static u8 dlm_pick_migration_target(stru
 
 	spin_lock(&res->spinlock);
 	for (i=0; i<3; i++) {
-		list_for_each(iter, queue) {
+		list_for_each_entry(lock, queue, list) {
 			/* up to the caller to make sure this node
 			 * is alive */
-			lock = list_entry (iter, struct dlm_lock, list);
 			if (lock->ml.node != dlm->node_num) {
 				spin_unlock(&res->spinlock);
 				return lock->ml.node;
@@ -3234,8 +3219,7 @@ static int dlm_add_migration_mle(struct 
 
 void dlm_clean_master_list(struct dlm_ctxt *dlm, u8 dead_node)
 {
-	struct list_head *iter, *iter2;
-	struct dlm_master_list_entry *mle;
+	struct dlm_master_list_entry *mle, *next;
 	struct dlm_lock_resource *res;
 	unsigned int hash;
 
@@ -3245,9 +3229,7 @@ top:
 
 	/* clean the master list */
 	spin_lock(&dlm->master_lock);
-	list_for_each_safe(iter, iter2, &dlm->master_list) {
-		mle = list_entry(iter, struct dlm_master_list_entry, list);
-
+	list_for_each_entry_safe(mle, next, &dlm->master_list, list) {
 		BUG_ON(mle->type != DLM_MLE_BLOCK &&
 		       mle->type != DLM_MLE_MASTER &&
 		       mle->type != DLM_MLE_MIGRATION);
Index: linux-2.6/fs/ocfs2/dlm/dlmrecovery.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/dlm/dlmrecovery.c	2007-05-06 13:51:17.000000000 +0200
+++ linux-2.6/fs/ocfs2/dlm/dlmrecovery.c	2007-05-17 15:00:14.000000000 +0200
@@ -158,8 +158,7 @@ void dlm_dispatch_work(struct work_struc
 	struct dlm_ctxt *dlm =
 		container_of(work, struct dlm_ctxt, dispatched_work);
 	LIST_HEAD(tmp_list);
-	struct list_head *iter, *iter2;
-	struct dlm_work_item *item;
+	struct dlm_work_item *item, *next;
 	dlm_workfunc_t *workfunc;
 	int tot=0;
 
@@ -167,13 +166,12 @@ void dlm_dispatch_work(struct work_struc
 	list_splice_init(&dlm->work_list, &tmp_list);
 	spin_unlock(&dlm->work_lock);
 
-	list_for_each_safe(iter, iter2, &tmp_list) {
+	list_for_each_entry(item, &tmp_list, list) {
 		tot++;
 	}
 	mlog(0, "%s: work thread has %d work items\n", dlm->name, tot);
 
-	list_for_each_safe(iter, iter2, &tmp_list) {
-		item = list_entry(iter, struct dlm_work_item, list);
+	list_for_each_entry_safe(item, next, &tmp_list, list) {
 		workfunc = item->func;
 		list_del_init(&item->list);
 
@@ -549,7 +547,6 @@ static int dlm_remaster_locks(struct dlm
 {
 	int status = 0;
 	struct dlm_reco_node_data *ndata;
-	struct list_head *iter;
 	int all_nodes_done;
 	int destroy = 0;
 	int pass = 0;
@@ -567,8 +564,7 @@ static int dlm_remaster_locks(struct dlm
 
 	/* safe to access the node data list without a lock, since this
 	 * process is the only one to change the list */
-	list_for_each(iter, &dlm->reco.node_data) {
-		ndata = list_entry (iter, struct dlm_reco_node_data, list);
+	list_for_each_entry(ndata, &dlm->reco.node_data, list) {
 		BUG_ON(ndata->state != DLM_RECO_NODE_DATA_INIT);
 		ndata->state = DLM_RECO_NODE_DATA_REQUESTING;
 
@@ -655,9 +651,7 @@ static int dlm_remaster_locks(struct dlm
 		 * done, or if anyone died */
 		all_nodes_done = 1;
 		spin_lock(&dlm_reco_state_lock);
-		list_for_each(iter, &dlm->reco.node_data) {
-			ndata = list_entry (iter, struct dlm_reco_node_data, list);
-
+		list_for_each_entry(ndata, &dlm->reco.node_data, list) {
 			mlog(0, "checking recovery state of node %u\n",
 			     ndata->node_num);
 			switch (ndata->state) {
@@ -774,16 +768,14 @@ static int dlm_init_recovery_area(struct
 
 static void dlm_destroy_recovery_area(struct dlm_ctxt *dlm, u8 dead_node)
 {
-	struct list_head *iter, *iter2;
-	struct dlm_reco_node_data *ndata;
+	struct dlm_reco_node_data *ndata, *next;
 	LIST_HEAD(tmplist);
 
 	spin_lock(&dlm_reco_state_lock);
 	list_splice_init(&dlm->reco.node_data, &tmplist);
 	spin_unlock(&dlm_reco_state_lock);
 
-	list_for_each_safe(iter, iter2, &tmplist) {
-		ndata = list_entry (iter, struct dlm_reco_node_data, list);
+	list_for_each_entry_safe(ndata, next, &tmplist, list) {
 		list_del_init(&ndata->list);
 		kfree(ndata);
 	}
@@ -876,7 +868,6 @@ static void dlm_request_all_locks_worker
 	struct dlm_lock_resource *res;
 	struct dlm_ctxt *dlm;
 	LIST_HEAD(resources);
-	struct list_head *iter;
 	int ret;
 	u8 dead_node, reco_master;
 	int skip_all_done = 0;
@@ -920,8 +911,7 @@ static void dlm_request_all_locks_worker
 
 	/* any errors returned will be due to the new_master dying,
 	 * the dlm_reco_thread should detect this */
-	list_for_each(iter, &resources) {
-		res = list_entry (iter, struct dlm_lock_resource, recovering);
+	list_for_each_entry(res, &resources, recovering) {
 		ret = dlm_send_one_lockres(dlm, res, mres, reco_master,
 				   	DLM_MRES_RECOVERY);
 		if (ret < 0) {
@@ -983,7 +973,6 @@ int dlm_reco_data_done_handler(struct o2
 {
 	struct dlm_ctxt *dlm = data;
 	struct dlm_reco_data_done *done = (struct dlm_reco_data_done *)msg->buf;
-	struct list_head *iter;
 	struct dlm_reco_node_data *ndata = NULL;
 	int ret = -EINVAL;
 
@@ -1000,8 +989,7 @@ int dlm_reco_data_done_handler(struct o2
 			dlm->reco.dead_node, done->node_idx, dlm->node_num);
 
 	spin_lock(&dlm_reco_state_lock);
-	list_for_each(iter, &dlm->reco.node_data) {
-		ndata = list_entry (iter, struct dlm_reco_node_data, list);
+	list_for_each_entry(ndata, &dlm->reco.node_data, list) {
 		if (ndata->node_num != done->node_idx)
 			continue;
 
@@ -1049,13 +1037,11 @@ static void dlm_move_reco_locks_to_list(
 					struct list_head *list,
 				       	u8 dead_node)
 {
-	struct dlm_lock_resource *res;
-	struct list_head *iter, *iter2;
+	struct dlm_lock_resource *res, *next;
 	struct dlm_lock *lock;
 
 	spin_lock(&dlm->spinlock);
-	list_for_each_safe(iter, iter2, &dlm->reco.resources) {
-		res = list_entry (iter, struct dlm_lock_resource, recovering);
+	list_for_each_entry_safe(res, next, &dlm->reco.resources, recovering) {
 		/* always prune any $RECOVERY entries for dead nodes,
 		 * otherwise hangs can occur during later recovery */
 		if (dlm_is_recovery_lock(res->lockname.name,
@@ -1252,7 +1238,7 @@ int dlm_send_one_lockres(struct dlm_ctxt
 			 struct dlm_migratable_lockres *mres,
 			 u8 send_to, u8 flags)
 {
-	struct list_head *queue, *iter;
+	struct list_head *queue;
 	int total_locks, i;
 	u64 mig_cookie = 0;
 	struct dlm_lock *lock;
@@ -1278,9 +1264,7 @@ int dlm_send_one_lockres(struct dlm_ctxt
 	total_locks = 0;
 	for (i=DLM_GRANTED_LIST; i<=DLM_BLOCKED_LIST; i++) {
 		queue = dlm_list_idx_to_ptr(res, i);
-		list_for_each(iter, queue) {
-			lock = list_entry (iter, struct dlm_lock, list);
-
+		list_for_each_entry(lock, queue, list) {
 			/* add another lock. */
 			total_locks++;
 			if (!dlm_add_lock_to_array(lock, mres, i))
@@ -1717,7 +1701,6 @@ static int dlm_process_recovery_data(str
 	struct dlm_lockstatus *lksb = NULL;
 	int ret = 0;
 	int i, j, bad;
-	struct list_head *iter;
 	struct dlm_lock *lock = NULL;
 	u8 from = O2NM_MAX_NODES;
 	unsigned int added = 0;
@@ -1755,8 +1738,7 @@ static int dlm_process_recovery_data(str
 			spin_lock(&res->spinlock);
 			for (j = DLM_GRANTED_LIST; j <= DLM_BLOCKED_LIST; j++) {
 				tmpq = dlm_list_idx_to_ptr(res, j);
-				list_for_each(iter, tmpq) {
-					lock = list_entry (iter, struct dlm_lock, list);
+				list_for_each_entry(lock, tmpq, list) {
 					if (lock->ml.cookie != ml->cookie)
 						lock = NULL;
 					else
@@ -1930,8 +1912,8 @@ void dlm_move_lockres_to_recovery_list(s
 				       struct dlm_lock_resource *res)
 {
 	int i;
-	struct list_head *queue, *iter, *iter2;
-	struct dlm_lock *lock;
+	struct list_head *queue;
+	struct dlm_lock *lock, *next;
 
 	res->state |= DLM_LOCK_RES_RECOVERING;
 	if (!list_empty(&res->recovering)) {
@@ -1947,8 +1929,7 @@ void dlm_move_lockres_to_recovery_list(s
 	/* find any pending locks and put them back on proper list */
 	for (i=DLM_BLOCKED_LIST; i>=DLM_GRANTED_LIST; i--) {
 		queue = dlm_list_idx_to_ptr(res, i);
-		list_for_each_safe(iter, iter2, queue) {
-			lock = list_entry (iter, struct dlm_lock, list);
+		list_for_each_entry_safe(lock, next, queue, list) {
 			dlm_lock_get(lock);
 			if (lock->convert_pending) {
 				/* move converting lock back to granted */
@@ -2013,18 +1994,15 @@ static void dlm_finish_local_lockres_rec
 					      u8 dead_node, u8 new_master)
 {
 	int i;
-	struct list_head *iter, *iter2;
 	struct hlist_node *hash_iter;
 	struct hlist_head *bucket;
-
-	struct dlm_lock_resource *res;
+	struct dlm_lock_resource *res, *next;
 
 	mlog_entry_void();
 
 	assert_spin_locked(&dlm->spinlock);
 
-	list_for_each_safe(iter, iter2, &dlm->reco.resources) {
-		res = list_entry (iter, struct dlm_lock_resource, recovering);
+	list_for_each_entry_safe(res, next, &dlm->reco.resources, recovering) {
 		if (res->owner == dead_node) {
 			list_del_init(&res->recovering);
 			spin_lock(&res->spinlock);
@@ -2099,7 +2077,7 @@ static inline int dlm_lvb_needs_invalida
 static void dlm_revalidate_lvb(struct dlm_ctxt *dlm,
 			       struct dlm_lock_resource *res, u8 dead_node)
 {
-	struct list_head *iter, *queue;
+	struct list_head *queue;
 	struct dlm_lock *lock;
 	int blank_lvb = 0, local = 0;
 	int i;
@@ -2121,8 +2099,7 @@ static void dlm_revalidate_lvb(struct dl
 
 	for (i=DLM_GRANTED_LIST; i<=DLM_CONVERTING_LIST; i++) {
 		queue = dlm_list_idx_to_ptr(res, i);
-		list_for_each(iter, queue) {
-			lock = list_entry (iter, struct dlm_lock, list);
+		list_for_each_entry(lock, queue, list) {
 			if (lock->ml.node == search_node) {
 				if (dlm_lvb_needs_invalidation(lock, local)) {
 					/* zero the lksb lvb and lockres lvb */
@@ -2143,8 +2120,7 @@ static void dlm_revalidate_lvb(struct dl
 static void dlm_free_dead_locks(struct dlm_ctxt *dlm,
 				struct dlm_lock_resource *res, u8 dead_node)
 {
-	struct list_head *iter, *tmpiter;
-	struct dlm_lock *lock;
+	struct dlm_lock *lock, *next;
 	unsigned int freed = 0;
 
 	/* this node is the lockres master:
@@ -2155,24 +2131,21 @@ static void dlm_free_dead_locks(struct d
 	assert_spin_locked(&res->spinlock);
 
 	/* TODO: check pending_asts, pending_basts here */
-	list_for_each_safe(iter, tmpiter, &res->granted) {
-		lock = list_entry (iter, struct dlm_lock, list);
+	list_for_each_entry_safe(lock, next, &res->granted, list) {
 		if (lock->ml.node == dead_node) {
 			list_del_init(&lock->list);
 			dlm_lock_put(lock);
 			freed++;
 		}
 	}
-	list_for_each_safe(iter, tmpiter, &res->converting) {
-		lock = list_entry (iter, struct dlm_lock, list);
+	list_for_each_entry_safe(lock, next, &res->converting, list) {
 		if (lock->ml.node == dead_node) {
 			list_del_init(&lock->list);
 			dlm_lock_put(lock);
 			freed++;
 		}
 	}
-	list_for_each_safe(iter, tmpiter, &res->blocked) {
-		lock = list_entry (iter, struct dlm_lock, list);
+	list_for_each_entry_safe(lock, next, &res->blocked, list) {
 		if (lock->ml.node == dead_node) {
 			list_del_init(&lock->list);
 			dlm_lock_put(lock);
Index: linux-2.6/fs/ocfs2/dlmglue.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/dlmglue.c	2007-05-10 10:53:15.000000000 +0200
+++ linux-2.6/fs/ocfs2/dlmglue.c	2007-05-17 15:00:14.000000000 +0200
@@ -600,15 +600,13 @@ static inline int ocfs2_highest_compat_l
 static void lockres_set_flags(struct ocfs2_lock_res *lockres,
 			      unsigned long newflags)
 {
-	struct list_head *pos, *tmp;
-	struct ocfs2_mask_waiter *mw;
+	struct ocfs2_mask_waiter *mw, *tmp;
 
  	assert_spin_locked(&lockres->l_lock);
 
 	lockres->l_flags = newflags;
 
-	list_for_each_safe(pos, tmp, &lockres->l_mask_waiters) {
-		mw = list_entry(pos, struct ocfs2_mask_waiter, mw_item);
+	list_for_each_entry_safe(mw, tmp, &lockres->l_mask_waiters, mw_item) {
 		if ((lockres->l_flags & mw->mw_mask) != mw->mw_goal)
 			continue;
 
Index: linux-2.6/fs/ocfs2/extent_map.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/extent_map.c	2007-04-30 11:33:04.000000000 +0200
+++ linux-2.6/fs/ocfs2/extent_map.c	2007-05-17 15:00:14.000000000 +0200
@@ -109,17 +109,14 @@ static int ocfs2_extent_map_lookup(struc
  */
 void ocfs2_extent_map_trunc(struct inode *inode, unsigned int cpos)
 {
-	struct list_head *p, *n;
-	struct ocfs2_extent_map_item *emi;
+	struct ocfs2_extent_map_item *emi, *n;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct ocfs2_extent_map *em = &oi->ip_extent_map;
 	LIST_HEAD(tmp_list);
 	unsigned int range;
 
 	spin_lock(&oi->ip_lock);
-	list_for_each_safe(p, n, &em->em_list) {
-		emi = list_entry(p, struct ocfs2_extent_map_item, ei_list);
-
+	list_for_each_entry_safe(emi, n, &em->em_list, ei_list) {
 		if (emi->ei_cpos >= cpos) {
 			/* Full truncate of this record. */
 			list_move(&emi->ei_list, &tmp_list);
@@ -136,8 +133,7 @@ void ocfs2_extent_map_trunc(struct inode
 	}
 	spin_unlock(&oi->ip_lock);
 
-	list_for_each_safe(p, n, &tmp_list) {
-		emi = list_entry(p, struct ocfs2_extent_map_item, ei_list);
+	list_for_each_entry_safe(emi, n, &tmp_list, ei_list) {
 		list_del(&emi->ei_list);
 		kfree(emi);
 	}
Index: linux-2.6/fs/ocfs2/journal.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/journal.c	2007-05-06 13:51:17.000000000 +0200
+++ linux-2.6/fs/ocfs2/journal.c	2007-05-17 15:00:14.000000000 +0200
@@ -722,8 +722,7 @@ void ocfs2_complete_recovery(struct work
 		container_of(work, struct ocfs2_journal, j_recovery_work);
 	struct ocfs2_super *osb = journal->j_osb;
 	struct ocfs2_dinode *la_dinode, *tl_dinode;
-	struct ocfs2_la_recovery_item *item;
-	struct list_head *p, *n;
+	struct ocfs2_la_recovery_item *item, *n;
 	LIST_HEAD(tmp_la_list);
 
 	mlog_entry_void();
@@ -734,8 +733,7 @@ void ocfs2_complete_recovery(struct work
 	list_splice_init(&journal->j_la_cleanups, &tmp_la_list);
 	spin_unlock(&journal->j_lock);
 
-	list_for_each_safe(p, n, &tmp_la_list) {
-		item = list_entry(p, struct ocfs2_la_recovery_item, lri_list);
+	list_for_each_entry_safe(item, n, &tmp_la_list, lri_list) {
 		list_del_init(&item->lri_list);
 
 		mlog(0, "Complete recovery for slot %d\n", item->lri_slot);
