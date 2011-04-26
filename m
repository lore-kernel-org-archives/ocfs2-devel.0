From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 26 Apr 2011 16:03:24 -0700
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2/dlm: Add new dlm message
	DLM_BEGIN_EXIT_DOMAIN_MSG
In-Reply-To: <1303859005-29529-1-git-send-email-sunil.mushran@oracle.com>
References: <1303859005-29529-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1303859005-29529-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch adds a new dlm message DLM_BEGIN_EXIT_DOMAIN_MSG and ups the dlm
protocol to 1.2.

o2dlm sends this new message in dlm_unregister_domain() to mark the beginning
of the exit domain. This message is sent to all nodes in the domain.

Currently o2dlm has no way of informing other nodes of its impending exit.
This information is useful as the other nodes could disregard the exiting
node in certain operations. For example, in resource migration. If two or
more nodes were umounting in parallel, it would be more efficient if o2dlm
were to choose a non-exiting node to be the new master node rather than an
exiting one.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmcommon.h   |    2 +
 fs/ocfs2/dlm/dlmdebug.c    |    6 +++
 fs/ocfs2/dlm/dlmdomain.c   |   84 ++++++++++++++++++++++++++++++++++++++------
 fs/ocfs2/dlm/dlmrecovery.c |    1 +
 4 files changed, 82 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index 1aac42a..d602abb 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -144,6 +144,7 @@ struct dlm_ctxt
 	wait_queue_head_t dlm_join_events;
 	unsigned long live_nodes_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
 	unsigned long domain_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
+	unsigned long exit_domain_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
 	unsigned long recovery_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
 	struct dlm_recovery_ctxt reco;
 	spinlock_t master_lock;
@@ -460,6 +461,7 @@ enum {
 	DLM_FINALIZE_RECO_MSG		= 518,
 	DLM_QUERY_REGION		= 519,
 	DLM_QUERY_NODEINFO		= 520,
+	DLM_BEGIN_EXIT_DOMAIN_MSG	= 521,
 };
 
 struct dlm_reco_node_data
diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index 04a32be..56f82cb 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -756,6 +756,12 @@ static int debug_state_print(struct dlm_ctxt *dlm, char *buf, int len)
 				 buf + out, len - out);
 	out += snprintf(buf + out, len - out, "\n");
 
+	/* Exit Domain Map: xx xx xx */
+	out += snprintf(buf + out, len - out, "Exit Domain Map: ");
+	out += stringify_nodemap(dlm->exit_domain_map, O2NM_MAX_NODES,
+				 buf + out, len - out);
+	out += snprintf(buf + out, len - out, "\n");
+
 	/* Live Map: xx xx xx */
 	out += snprintf(buf + out, len - out, "Live Map: ");
 	out += stringify_nodemap(dlm->live_nodes_map, O2NM_MAX_NODES,
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 3b179d6..3aff23f 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -132,10 +132,12 @@ static DECLARE_WAIT_QUEUE_HEAD(dlm_domain_events);
  * New in version 1.1:
  *	- Message DLM_QUERY_REGION added to support global heartbeat
  *	- Message DLM_QUERY_NODEINFO added to allow online node removes
+ * New in version 1.2:
+ * 	- Message DLM_BEGIN_EXIT_DOMAIN_MSG added to mark start of exit domain
  */
 static const struct dlm_protocol_version dlm_protocol = {
 	.pv_major = 1,
-	.pv_minor = 1,
+	.pv_minor = 2,
 };
 
 #define DLM_DOMAIN_BACKOFF_MS 200
@@ -486,6 +488,28 @@ static int dlm_no_joining_node(struct dlm_ctxt *dlm)
 	return ret;
 }
 
+static int dlm_begin_exit_domain_handler(struct o2net_msg *msg, u32 len,
+					 void *data, void **ret_data)
+{
+	struct dlm_ctxt *dlm = data;
+	unsigned int node;
+	struct dlm_exit_domain *exit_msg = (struct dlm_exit_domain *) msg->buf;
+
+	if (!dlm_grab(dlm))
+		return 0;
+
+	node = exit_msg->node_idx;
+	mlog(0, "%s: Node %u sent a begin exit domain message\n", dlm->name, node);
+
+	spin_lock(&dlm->spinlock);
+	set_bit(node, dlm->exit_domain_map);
+	spin_unlock(&dlm->spinlock);
+
+	dlm_put(dlm);
+
+	return 0;
+}
+
 static void dlm_mark_domain_leaving(struct dlm_ctxt *dlm)
 {
 	/* Yikes, a double spinlock! I need domain_lock for the dlm
@@ -542,6 +566,7 @@ static int dlm_exit_domain_handler(struct o2net_msg *msg, u32 len, void *data,
 
 	spin_lock(&dlm->spinlock);
 	clear_bit(node, dlm->domain_map);
+	clear_bit(node, dlm->exit_domain_map);
 	__dlm_print_nodes(dlm);
 
 	/* notify anything attached to the heartbeat events */
@@ -554,29 +579,56 @@ static int dlm_exit_domain_handler(struct o2net_msg *msg, u32 len, void *data,
 	return 0;
 }
 
-static int dlm_send_one_domain_exit(struct dlm_ctxt *dlm,
+static int dlm_send_one_domain_exit(struct dlm_ctxt *dlm, u32 msg_type,
 				    unsigned int node)
 {
 	int status;
 	struct dlm_exit_domain leave_msg;
 
-	mlog(0, "Asking node %u if we can leave the domain %s me = %u\n",
-		  node, dlm->name, dlm->node_num);
+	mlog(0, "%s: Sending domain exit message %u to node %u\n", dlm->name,
+	     msg_type, node);
 
 	memset(&leave_msg, 0, sizeof(leave_msg));
 	leave_msg.node_idx = dlm->node_num;
 
-	status = o2net_send_message(DLM_EXIT_DOMAIN_MSG, dlm->key,
-				    &leave_msg, sizeof(leave_msg), node,
-				    NULL);
+	status = o2net_send_message(msg_type, dlm->key, &leave_msg,
+				    sizeof(leave_msg), node, NULL);
 	if (status < 0)
-		mlog(ML_ERROR, "Error %d when sending message %u (key 0x%x) to "
-		     "node %u\n", status, DLM_EXIT_DOMAIN_MSG, dlm->key, node);
-	mlog(0, "status return %d from o2net_send_message\n", status);
+		mlog(ML_ERROR, "Error %d sending domain exit message %u "
+		     "to node %u on domain %s\n", status, msg_type, node,
+		     dlm->name);
 
 	return status;
 }
 
+static void dlm_begin_exit_domain(struct dlm_ctxt *dlm)
+{
+	int node = -1;
+
+	/* Support for begin exit domain was added in 1.2 */
+	if (dlm->dlm_locking_proto.pv_major == 1 &&
+	    dlm->dlm_locking_proto.pv_minor < 2)
+		return;
+
+	/*
+	 * Unlike DLM_EXIT_DOMAIN_MSG, DLM_BEGIN_EXIT_DOMAIN_MSG is purely
+	 * informational. Meaning if a node does not receive the message,
+	 * so be it.
+	 */
+	spin_lock(&dlm->spinlock);
+	while (1) {
+		node = find_next_bit(dlm->domain_map, O2NM_MAX_NODES, node + 1);
+		if (node >= O2NM_MAX_NODES)
+			break;
+		if (node == dlm->node_num)
+			continue;
+
+		spin_unlock(&dlm->spinlock);
+		dlm_send_one_domain_exit(dlm, DLM_BEGIN_EXIT_DOMAIN_MSG, node);
+		spin_lock(&dlm->spinlock);
+	}
+	spin_unlock(&dlm->spinlock);
+}
 
 static void dlm_leave_domain(struct dlm_ctxt *dlm)
 {
@@ -602,7 +654,8 @@ static void dlm_leave_domain(struct dlm_ctxt *dlm)
 
 		clear_node = 1;
 
-		status = dlm_send_one_domain_exit(dlm, node);
+		status = dlm_send_one_domain_exit(dlm, DLM_EXIT_DOMAIN_MSG,
+						  node);
 		if (status < 0 &&
 		    status != -ENOPROTOOPT &&
 		    status != -ENOTCONN) {
@@ -677,6 +730,7 @@ void dlm_unregister_domain(struct dlm_ctxt *dlm)
 
 	if (leave) {
 		mlog(0, "shutting down domain %s\n", dlm->name);
+		dlm_begin_exit_domain(dlm);
 
 		/* We changed dlm state, notify the thread */
 		dlm_kick_thread(dlm, NULL);
@@ -909,6 +963,7 @@ static int dlm_assert_joined_handler(struct o2net_msg *msg, u32 len, void *data,
 		 * leftover join state. */
 		BUG_ON(dlm->joining_node != assert->node_idx);
 		set_bit(assert->node_idx, dlm->domain_map);
+		clear_bit(assert->node_idx, dlm->exit_domain_map);
 		__dlm_set_joining_node(dlm, DLM_LOCK_RES_OWNER_UNKNOWN);
 
 		printk(KERN_NOTICE "o2dlm: Node %u joins domain %s\n",
@@ -1793,6 +1848,13 @@ static int dlm_register_domain_handlers(struct dlm_ctxt *dlm)
 	if (status)
 		goto bail;
 
+	status = o2net_register_handler(DLM_BEGIN_EXIT_DOMAIN_MSG, dlm->key,
+					sizeof(struct dlm_exit_domain),
+					dlm_begin_exit_domain_handler,
+					dlm, NULL, &dlm->dlm_domain_handlers);
+	if (status)
+		goto bail;
+
 bail:
 	if (status)
 		dlm_unregister_domain_handlers(dlm);
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index f1beb6f..7efab6d 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -2393,6 +2393,7 @@ static void __dlm_hb_node_down(struct dlm_ctxt *dlm, int idx)
 
 	mlog(0, "node %u being removed from domain map!\n", idx);
 	clear_bit(idx, dlm->domain_map);
+	clear_bit(idx, dlm->exit_domain_map);
 	/* wake up migration waiters if a node goes down.
 	 * perhaps later we can genericize this for other waiters. */
 	wake_up(&dlm->migration_wq);
-- 
1.7.1
