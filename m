From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Wed, 21 Aug 2013 08:10:30 -0500
Subject: [Ocfs2-devel] [PATCH 4/5] ocfs2_connection_private for holding DLM
 this_node information
Message-ID: <20130821131026.GA4011@shrek.cartoons>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_connection_private holds this nodes information, such as the DLM
allocated slot number and the node number assigned to the node.


Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/ocfs2/dlmglue.c    |  2 +-
 fs/ocfs2/stack_o2cb.c |  3 ++-
 fs/ocfs2/stack_user.c | 51 +++++++++++++++++++++++++++++++++++++++++++++------
 fs/ocfs2/stackglue.c  |  4 ++--
 fs/ocfs2/stackglue.h  |  4 ++--
 5 files changed, 52 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 7c57de3..f2d48c8 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3007,7 +3007,7 @@ int ocfs2_dlm_init(struct ocfs2_super *osb)
 		goto bail;
 	}
 
-	status = ocfs2_cluster_this_node(&osb->node_num);
+	status = ocfs2_cluster_this_node(conn, &osb->node_num);
 	if (status < 0) {
 		mlog_errno(status);
 		mlog(ML_ERROR,
diff --git a/fs/ocfs2/stack_o2cb.c b/fs/ocfs2/stack_o2cb.c
index bf1f893..1724d43 100644
--- a/fs/ocfs2/stack_o2cb.c
+++ b/fs/ocfs2/stack_o2cb.c
@@ -398,7 +398,8 @@ static int o2cb_cluster_disconnect(struct ocfs2_cluster_connection *conn)
 	return 0;
 }
 
-static int o2cb_cluster_this_node(unsigned int *node)
+static int o2cb_cluster_this_node(struct ocfs2_cluster_connection *conn,
+				  unsigned int *node)
 {
 	int node_num;
 
diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index d604a36..b869d4d6 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -23,6 +23,7 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/reboot.h>
+#include <linux/sched.h>
 #include <asm/uaccess.h>
 
 #include "stackglue.h"
@@ -112,6 +113,12 @@ struct ocfs2_live_connection {
 	struct ocfs2_cluster_connection	*oc_conn;
 };
 
+struct ocfs2_connection_private {
+	atomic_t cp_this_node;
+	int cp_our_slot;
+	wait_queue_head_t cp_wait;
+};
+
 struct ocfs2_control_private {
 	struct list_head op_list;
 	int op_state;
@@ -805,12 +812,30 @@ static void user_recover_prep(void *arg)
 
 static void user_recover_slot(void *arg, struct dlm_slot *slot)
 {
+	struct ocfs2_cluster_connection *conn =
+		(struct ocfs2_cluster_connection  *) arg;
+	printk(KERN_INFO "ocfs2: Node %d/%d down. Initiating recovery.\n",
+			 slot->nodeid, slot->slot);
+	conn->cc_recovery_handler(slot->nodeid, conn->cc_recovery_data);
 }
 
 static void user_recover_done(void *arg, struct dlm_slot *slots,
 			      int num_slots, int our_slot,
 			      uint32_t generation)
 {
+	struct ocfs2_cluster_connection *conn =
+		(struct ocfs2_cluster_connection *)arg;
+	struct ocfs2_connection_private *priv = conn->cc_private;
+	int i;
+
+	for (i = 0; i < num_slots; i++)
+		if (slots[i].slot == our_slot) {
+			atomic_set(&priv->cp_this_node, slots[i].nodeid);
+			break;
+		}
+
+	priv->cp_our_slot = our_slot;
+	wake_up(&priv->cp_wait);
 }
 
 const struct dlm_lockspace_ops ocfs2_ls_ops = {
@@ -823,9 +848,20 @@ static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
 {
 	dlm_lockspace_t *fsdlm;
 	int rc = 0, ops_rv;
+	struct ocfs2_connection_private *priv;
 
 	BUG_ON(conn == NULL);
 
+	priv = kzalloc(sizeof(struct ocfs2_connection_private), GFP_KERNEL);
+	if (!priv) {
+		rc = -ENOMEM;
+		goto out;
+	}
+	init_waitqueue_head(&priv->cp_wait);
+	atomic_set(&priv->cp_this_node, 0);
+
+	conn->cc_private = priv;
+
 	rc = dlm_new_lockspace(conn->cc_name, conn->cc_cluster_name,
 			       DLM_LSFL_FS, DLM_LVB_LEN,
 			       &ocfs2_ls_ops, conn, &ops_rv, &fsdlm);
@@ -839,6 +875,7 @@ static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
 		goto out;
 	}
 
+	wait_event(priv->cp_wait, (atomic_read(&priv->cp_this_node) > 0));
 	conn->cc_lockspace = fsdlm;
 out:
 	return rc;
@@ -848,19 +885,21 @@ static int user_cluster_disconnect(struct ocfs2_cluster_connection *conn)
 {
 	dlm_release_lockspace(conn->cc_lockspace, 2);
 	conn->cc_lockspace = NULL;
+	kfree(conn->cc_private);
 	conn->cc_private = NULL;
 	return 0;
 }
 
-static int user_cluster_this_node(unsigned int *this_node)
+static int user_cluster_this_node(struct ocfs2_cluster_connection *conn,
+				  unsigned int *this_node)
 {
-	int rc;
+	struct ocfs2_connection_private *priv =
+		(struct ocfs2_connection_private *)conn->cc_private;
 
-	rc = ocfs2_control_get_this_node();
-	if (rc < 0)
-		return rc;
+	if (!priv)
+		return -EINVAL;
+	*this_node = atomic_read(&priv->cp_this_node);
 
-	*this_node = rc;
 	return 0;
 }
 
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 9acee13..4dd732b 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -465,9 +465,9 @@ void ocfs2_cluster_hangup(const char *group, int grouplen)
 }
 EXPORT_SYMBOL_GPL(ocfs2_cluster_hangup);
 
-int ocfs2_cluster_this_node(unsigned int *node)
+int ocfs2_cluster_this_node(struct ocfs2_cluster_connection *conn, unsigned int *node)
 {
-	return active_stack->sp_ops->this_node(node);
+	return active_stack->sp_ops->this_node(conn, node);
 }
 EXPORT_SYMBOL_GPL(ocfs2_cluster_this_node);
 
diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
index b46fd51..c953290 100644
--- a/fs/ocfs2/stackglue.h
+++ b/fs/ocfs2/stackglue.h
@@ -157,7 +157,7 @@ struct ocfs2_stack_operations {
 	 * ->this_node() returns the cluster's unique identifier for the
 	 * local node.
 	 */
-	int (*this_node)(unsigned int *node);
+	int (*this_node)(struct ocfs2_cluster_connection *conn, unsigned int *node);
 
 	/*
 	 * Call the underlying dlm lock function.  The ->dlm_lock()
@@ -267,7 +267,7 @@ int ocfs2_cluster_connect_agnostic(const char *group,
 int ocfs2_cluster_disconnect(struct ocfs2_cluster_connection *conn,
 			     int hangup_pending);
 void ocfs2_cluster_hangup(const char *group, int grouplen);
-int ocfs2_cluster_this_node(unsigned int *node);
+int ocfs2_cluster_this_node(struct ocfs2_cluster_connection *, unsigned int *node);
 
 struct ocfs2_lock_res;
 int ocfs2_dlm_lock(struct ocfs2_cluster_connection *conn,
-- 
1.8.1.4


-- 
Goldwyn
