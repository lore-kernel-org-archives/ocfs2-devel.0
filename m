From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 23 Jun 2011 15:30:57 -0700
Subject: [Ocfs2-devel] [PATCH 03/13] ocfs2/dlm: Clean up messages in o2dlm
In-Reply-To: <1308868267-5981-1-git-send-email-sunil.mushran@oracle.com>
References: <1308868267-5981-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1308868267-5981-4-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

o2dlm messages needed a facelift.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmdomain.c   |   18 ++++++++------
 fs/ocfs2/dlm/dlmlock.c     |   22 +++++++----------
 fs/ocfs2/dlm/dlmmaster.c   |   46 +++++++++++++++++--------------------
 fs/ocfs2/dlm/dlmrecovery.c |   53 +++++++++++++++++++++++++------------------
 fs/ocfs2/dlm/dlmthread.c   |    2 -
 5 files changed, 71 insertions(+), 70 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 6ed6b95..ce225fb 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -539,17 +539,17 @@ again:
 
 static void __dlm_print_nodes(struct dlm_ctxt *dlm)
 {
-	int node = -1;
+	int node = -1, num = 0;
 
 	assert_spin_locked(&dlm->spinlock);
 
-	printk(KERN_NOTICE "o2dlm: Nodes in domain %s: ", dlm->name);
-
+	printk("( ");
 	while ((node = find_next_bit(dlm->domain_map, O2NM_MAX_NODES,
 				     node + 1)) < O2NM_MAX_NODES) {
 		printk("%d ", node);
+		++num;
 	}
-	printk("\n");
+	printk(") %u nodes\n", num);
 }
 
 static int dlm_exit_domain_handler(struct o2net_msg *msg, u32 len, void *data,
@@ -566,11 +566,10 @@ static int dlm_exit_domain_handler(struct o2net_msg *msg, u32 len, void *data,
 
 	node = exit_msg->node_idx;
 
-	printk(KERN_NOTICE "o2dlm: Node %u leaves domain %s\n", node, dlm->name);
-
 	spin_lock(&dlm->spinlock);
 	clear_bit(node, dlm->domain_map);
 	clear_bit(node, dlm->exit_domain_map);
+	printk(KERN_NOTICE "o2dlm: Node %u leaves domain %s ", node, dlm->name);
 	__dlm_print_nodes(dlm);
 
 	/* notify anything attached to the heartbeat events */
@@ -755,6 +754,7 @@ void dlm_unregister_domain(struct dlm_ctxt *dlm)
 
 		dlm_mark_domain_leaving(dlm);
 		dlm_leave_domain(dlm);
+		printk(KERN_NOTICE "o2dlm: Leaving domain %s\n", dlm->name);
 		dlm_force_free_mles(dlm);
 		dlm_complete_dlm_shutdown(dlm);
 	}
@@ -970,7 +970,7 @@ static int dlm_assert_joined_handler(struct o2net_msg *msg, u32 len, void *data,
 		clear_bit(assert->node_idx, dlm->exit_domain_map);
 		__dlm_set_joining_node(dlm, DLM_LOCK_RES_OWNER_UNKNOWN);
 
-		printk(KERN_NOTICE "o2dlm: Node %u joins domain %s\n",
+		printk(KERN_NOTICE "o2dlm: Node %u joins domain %s ",
 		       assert->node_idx, dlm->name);
 		__dlm_print_nodes(dlm);
 
@@ -1701,8 +1701,10 @@ static int dlm_try_to_join_domain(struct dlm_ctxt *dlm)
 bail:
 	spin_lock(&dlm->spinlock);
 	__dlm_set_joining_node(dlm, DLM_LOCK_RES_OWNER_UNKNOWN);
-	if (!status)
+	if (!status) {
+		printk(KERN_NOTICE "o2dlm: Joining domain %s ", dlm->name);
 		__dlm_print_nodes(dlm);
+	}
 	spin_unlock(&dlm->spinlock);
 
 	if (ctxt) {
diff --git a/fs/ocfs2/dlm/dlmlock.c b/fs/ocfs2/dlm/dlmlock.c
index 8d39e0f..c7f3e22 100644
--- a/fs/ocfs2/dlm/dlmlock.c
+++ b/fs/ocfs2/dlm/dlmlock.c
@@ -319,27 +319,23 @@ static enum dlm_status dlm_send_remote_lock_request(struct dlm_ctxt *dlm,
 	tmpret = o2net_send_message(DLM_CREATE_LOCK_MSG, dlm->key, &create,
 				    sizeof(create), res->owner, &status);
 	if (tmpret >= 0) {
-		// successfully sent and received
-		ret = status;  // this is already a dlm_status
+		ret = status;
 		if (ret == DLM_REJECTED) {
-			mlog(ML_ERROR, "%s:%.*s: BUG.  this is a stale lockres "
-			     "no longer owned by %u.  that node is coming back "
-			     "up currently.\n", dlm->name, create.namelen,
+			mlog(ML_ERROR, "%s: res %.*s, Stale lockres no longer "
+			     "owned by node %u. That node is coming back up "
+			     "currently.\n", dlm->name, create.namelen,
 			     create.name, res->owner);
 			dlm_print_one_lock_resource(res);
 			BUG();
 		}
 	} else {
-		mlog(ML_ERROR, "Error %d when sending message %u (key 0x%x) to "
-		     "node %u\n", tmpret, DLM_CREATE_LOCK_MSG, dlm->key,
-		     res->owner);
-		if (dlm_is_host_down(tmpret)) {
+		mlog(ML_ERROR, "%s: res %.*s, Error %d send CREATE LOCK to "
+		     "node %u\n", dlm->name, create.namelen, create.name,
+		     tmpret, res->owner);
+		if (dlm_is_host_down(tmpret))
 			ret = DLM_RECOVERING;
-			mlog(0, "node %u died so returning DLM_RECOVERING "
-			     "from lock message!\n", res->owner);
-		} else {
+		else
 			ret = dlm_err_to_dlm_status(tmpret);
-		}
 	}
 
 	return ret;
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 11eefb8..9f3b093 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -829,8 +829,8 @@ lookup:
 		 * but they might own this lockres.  wait on them. */
 		bit = find_next_bit(dlm->recovery_map, O2NM_MAX_NODES, 0);
 		if (bit < O2NM_MAX_NODES) {
-			mlog(ML_NOTICE, "%s:%.*s:@least one node (%d) to "
-			     "recover before lock mastery can begin\n",
+			mlog(0, "%s: res %.*s, At least one node (%d) "
+			     "to recover before lock mastery can begin\n",
 			     dlm->name, namelen, (char *)lockid, bit);
 			wait_on_recovery = 1;
 		}
@@ -864,8 +864,8 @@ redo_request:
 		 * dlm spinlock would be detectable be a change on the mle,
 		 * so we only need to clear out the recovery map once. */
 		if (dlm_is_recovery_lock(lockid, namelen)) {
-			mlog(ML_NOTICE, "%s: recovery map is not empty, but "
-			     "must master $RECOVERY lock now\n", dlm->name);
+			mlog(0, "%s: Recovery map is not empty, but must "
+			     "master $RECOVERY lock now\n", dlm->name);
 			if (!dlm_pre_master_reco_lockres(dlm, res))
 				wait_on_recovery = 0;
 			else {
@@ -883,8 +883,8 @@ redo_request:
 		spin_lock(&dlm->spinlock);
 		bit = find_next_bit(dlm->recovery_map, O2NM_MAX_NODES, 0);
 		if (bit < O2NM_MAX_NODES) {
-			mlog(ML_NOTICE, "%s:%.*s:@least one node (%d) to "
-			     "recover before lock mastery can begin\n",
+			mlog(0, "%s: res %.*s, At least one node (%d) "
+			     "to recover before lock mastery can begin\n",
 			     dlm->name, namelen, (char *)lockid, bit);
 			wait_on_recovery = 1;
 		} else
@@ -913,8 +913,8 @@ redo_request:
 			 * yet, keep going until it does.  this is how the
 			 * master will know that asserts are needed back to
 			 * the lower nodes. */
-			mlog(0, "%s:%.*s: requests only up to %u but master "
-			     "is %u, keep going\n", dlm->name, namelen,
+			mlog(0, "%s: res %.*s, Requests only up to %u but "
+			     "master is %u, keep going\n", dlm->name, namelen,
 			     lockid, nodenum, mle->master);
 		}
 	}
@@ -924,13 +924,12 @@ wait:
 	ret = dlm_wait_for_lock_mastery(dlm, res, mle, &blocked);
 	if (ret < 0) {
 		wait_on_recovery = 1;
-		mlog(0, "%s:%.*s: node map changed, redo the "
-		     "master request now, blocked=%d\n",
-		     dlm->name, res->lockname.len,
+		mlog(0, "%s: res %.*s, Node map changed, redo the master "
+		     "request now, blocked=%d\n", dlm->name, res->lockname.len,
 		     res->lockname.name, blocked);
 		if (++tries > 20) {
-			mlog(ML_ERROR, "%s:%.*s: spinning on "
-			     "dlm_wait_for_lock_mastery, blocked=%d\n",
+			mlog(ML_ERROR, "%s: res %.*s, Spinning on "
+			     "dlm_wait_for_lock_mastery, blocked = %d\n",
 			     dlm->name, res->lockname.len,
 			     res->lockname.name, blocked);
 			dlm_print_one_lock_resource(res);
@@ -940,7 +939,8 @@ wait:
 		goto redo_request;
 	}
 
-	mlog(0, "lockres mastered by %u\n", res->owner);
+	mlog(0, "%s: res %.*s, Mastered by %u\n", dlm->name, res->lockname.len,
+	     res->lockname.name, res->owner);
 	/* make sure we never continue without this */
 	BUG_ON(res->owner == O2NM_MAX_NODES);
 
@@ -2187,8 +2187,6 @@ int dlm_drop_lockres_ref(struct dlm_ctxt *dlm, struct dlm_lock_resource *res)
 	namelen = res->lockname.len;
 	BUG_ON(namelen > O2NM_MAX_NAME_LEN);
 
-	mlog(0, "%s:%.*s: sending deref to %d\n",
-	     dlm->name, namelen, lockname, res->owner);
 	memset(&deref, 0, sizeof(deref));
 	deref.node_idx = dlm->node_num;
 	deref.namelen = namelen;
@@ -2197,14 +2195,12 @@ int dlm_drop_lockres_ref(struct dlm_ctxt *dlm, struct dlm_lock_resource *res)
 	ret = o2net_send_message(DLM_DEREF_LOCKRES_MSG, dlm->key,
 				 &deref, sizeof(deref), res->owner, &r);
 	if (ret < 0)
-		mlog(ML_ERROR, "Error %d when sending message %u (key 0x%x) to "
-		     "node %u\n", ret, DLM_DEREF_LOCKRES_MSG, dlm->key,
-		     res->owner);
+		mlog(ML_ERROR, "%s: res %.*s, error %d send DEREF to node %u\n",
+		     dlm->name, namelen, lockname, ret, res->owner);
 	else if (r < 0) {
 		/* BAD.  other node says I did not have a ref. */
-		mlog(ML_ERROR,"while dropping ref on %s:%.*s "
-		    "(master=%u) got %d.\n", dlm->name, namelen,
-		    lockname, res->owner, r);
+		mlog(ML_ERROR, "%s: res %.*s, DEREF to node %u got %d\n",
+		     dlm->name, namelen, lockname, res->owner, r);
 		dlm_print_one_lock_resource(res);
 		BUG();
 	}
@@ -2916,9 +2912,9 @@ static int dlm_do_migrate_request(struct dlm_ctxt *dlm,
 					 &migrate, sizeof(migrate), nodenum,
 					 &status);
 		if (ret < 0) {
-			mlog(ML_ERROR, "Error %d when sending message %u (key "
-			     "0x%x) to node %u\n", ret, DLM_MIGRATE_REQUEST_MSG,
-			     dlm->key, nodenum);
+			mlog(ML_ERROR, "%s: res %.*s, Error %d send "
+			     "MIGRATE_REQUEST to node %u\n", dlm->name,
+			     migrate.namelen, migrate.name, ret, nodenum);
 			if (!dlm_is_host_down(ret)) {
 				mlog(ML_ERROR, "unhandled error=%d!\n", ret);
 				BUG();
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 7efab6d..a3c312c 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -430,6 +430,8 @@ static void dlm_begin_recovery(struct dlm_ctxt *dlm)
 {
 	spin_lock(&dlm->spinlock);
 	BUG_ON(dlm->reco.state & DLM_RECO_STATE_ACTIVE);
+	printk(KERN_NOTICE "o2dlm: Begin recovery on domain %s for node %u\n",
+	       dlm->name, dlm->reco.dead_node);
 	dlm->reco.state |= DLM_RECO_STATE_ACTIVE;
 	spin_unlock(&dlm->spinlock);
 }
@@ -440,9 +442,18 @@ static void dlm_end_recovery(struct dlm_ctxt *dlm)
 	BUG_ON(!(dlm->reco.state & DLM_RECO_STATE_ACTIVE));
 	dlm->reco.state &= ~DLM_RECO_STATE_ACTIVE;
 	spin_unlock(&dlm->spinlock);
+	printk(KERN_NOTICE "o2dlm: End recovery on domain %s\n", dlm->name);
 	wake_up(&dlm->reco.event);
 }
 
+static void dlm_print_recovery_master(struct dlm_ctxt *dlm)
+{
+	printk(KERN_NOTICE "o2dlm: Node %u (%s) is the Recovery Master for the "
+	       "dead node %u in domain %s\n", dlm->reco.new_master,
+	       (dlm->node_num == dlm->reco.new_master ? "me" : "he"),
+	       dlm->reco.dead_node, dlm->name);
+}
+
 static int dlm_do_recovery(struct dlm_ctxt *dlm)
 {
 	int status = 0;
@@ -505,9 +516,8 @@ static int dlm_do_recovery(struct dlm_ctxt *dlm)
 		}
 		mlog(0, "another node will master this recovery session.\n");
 	}
-	mlog(0, "dlm=%s (%d), new_master=%u, this node=%u, dead_node=%u\n",
-	     dlm->name, task_pid_nr(dlm->dlm_reco_thread_task), dlm->reco.new_master,
-	     dlm->node_num, dlm->reco.dead_node);
+
+	dlm_print_recovery_master(dlm);
 
 	/* it is safe to start everything back up here
 	 * because all of the dead node's lock resources
@@ -518,15 +528,13 @@ static int dlm_do_recovery(struct dlm_ctxt *dlm)
 	return 0;
 
 master_here:
-	mlog(ML_NOTICE, "(%d) Node %u is the Recovery Master for the Dead Node "
-	     "%u for Domain %s\n", task_pid_nr(dlm->dlm_reco_thread_task),
-	     dlm->node_num, dlm->reco.dead_node, dlm->name);
+	dlm_print_recovery_master(dlm);
 
 	status = dlm_remaster_locks(dlm, dlm->reco.dead_node);
 	if (status < 0) {
 		/* we should never hit this anymore */
-		mlog(ML_ERROR, "error %d remastering locks for node %u, "
-		     "retrying.\n", status, dlm->reco.dead_node);
+		mlog(ML_ERROR, "%s: Error %d remastering locks for node %u, "
+		     "retrying.\n", dlm->name, status, dlm->reco.dead_node);
 		/* yield a bit to allow any final network messages
 		 * to get handled on remaining nodes */
 		msleep(100);
@@ -567,7 +575,7 @@ static int dlm_remaster_locks(struct dlm_ctxt *dlm, u8 dead_node)
 		BUG_ON(ndata->state != DLM_RECO_NODE_DATA_INIT);
 		ndata->state = DLM_RECO_NODE_DATA_REQUESTING;
 
-		mlog(0, "requesting lock info from node %u\n",
+		mlog(0, "%s: Requesting lock info from node %u\n", dlm->name,
 		     ndata->node_num);
 
 		if (ndata->node_num == dlm->node_num) {
@@ -640,7 +648,7 @@ static int dlm_remaster_locks(struct dlm_ctxt *dlm, u8 dead_node)
 		spin_unlock(&dlm_reco_state_lock);
 	}
 
-	mlog(0, "done requesting all lock info\n");
+	mlog(0, "%s: Done requesting all lock info\n", dlm->name);
 
 	/* nodes should be sending reco data now
 	 * just need to wait */
@@ -802,10 +810,9 @@ static int dlm_request_all_locks(struct dlm_ctxt *dlm, u8 request_from,
 
 	/* negative status is handled by caller */
 	if (ret < 0)
-		mlog(ML_ERROR, "Error %d when sending message %u (key "
-		     "0x%x) to node %u\n", ret, DLM_LOCK_REQUEST_MSG,
-		     dlm->key, request_from);
-
+		mlog(ML_ERROR, "%s: Error %d send LOCK_REQUEST to node %u "
+		     "to recover dead node %u\n", dlm->name, ret,
+		     request_from, dead_node);
 	// return from here, then
 	// sleep until all received or error
 	return ret;
@@ -956,9 +963,9 @@ static int dlm_send_all_done_msg(struct dlm_ctxt *dlm, u8 dead_node, u8 send_to)
 	ret = o2net_send_message(DLM_RECO_DATA_DONE_MSG, dlm->key, &done_msg,
 				 sizeof(done_msg), send_to, &tmpret);
 	if (ret < 0) {
-		mlog(ML_ERROR, "Error %d when sending message %u (key "
-		     "0x%x) to node %u\n", ret, DLM_RECO_DATA_DONE_MSG,
-		     dlm->key, send_to);
+		mlog(ML_ERROR, "%s: Error %d send RECO_DATA_DONE to node %u "
+		     "to recover dead node %u\n", dlm->name, ret, send_to,
+		     dead_node);
 		if (!dlm_is_host_down(ret)) {
 			BUG();
 		}
@@ -1127,9 +1134,11 @@ static int dlm_send_mig_lockres_msg(struct dlm_ctxt *dlm,
 	if (ret < 0) {
 		/* XXX: negative status is not handled.
 		 * this will end up killing this node. */
-		mlog(ML_ERROR, "Error %d when sending message %u (key "
-		     "0x%x) to node %u\n", ret, DLM_MIG_LOCKRES_MSG,
-		     dlm->key, send_to);
+		mlog(ML_ERROR, "%s: res %.*s, Error %d send MIG_LOCKRES to "
+		     "node %u (%s)\n", dlm->name, mres->lockname_len,
+		     mres->lockname, ret, send_to,
+		     (orig_flags & DLM_MRES_MIGRATION ?
+		      "migration" : "recovery"));
 	} else {
 		/* might get an -ENOMEM back here */
 		ret = status;
@@ -2324,9 +2333,9 @@ static void dlm_do_local_recovery_cleanup(struct dlm_ctxt *dlm, u8 dead_node)
 			dlm_revalidate_lvb(dlm, res, dead_node);
 			if (res->owner == dead_node) {
 				if (res->state & DLM_LOCK_RES_DROPPING_REF) {
-					mlog(ML_NOTICE, "Ignore %.*s for "
+					mlog(ML_NOTICE, "%s: res %.*s, Skip "
 					     "recovery as it is being freed\n",
-					     res->lockname.len,
+					     dlm->name, res->lockname.len,
 					     res->lockname.name);
 				} else
 					dlm_move_lockres_to_recovery_list(dlm,
diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
index 1d6d1d2..46faac2 100644
--- a/fs/ocfs2/dlm/dlmthread.c
+++ b/fs/ocfs2/dlm/dlmthread.c
@@ -185,8 +185,6 @@ static void dlm_purge_lockres(struct dlm_ctxt *dlm,
 		/* clear our bit from the master's refmap, ignore errors */
 		ret = dlm_drop_lockres_ref(dlm, res);
 		if (ret < 0) {
-			mlog(ML_ERROR, "%s: deref %.*s failed %d\n", dlm->name,
-			     res->lockname.len, res->lockname.name, ret);
 			if (!dlm_is_host_down(ret))
 				BUG();
 		}
-- 
1.7.4.1
