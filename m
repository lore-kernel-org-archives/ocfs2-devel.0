From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Thu, 3 Oct 2013 00:50:38 -0500
Subject: [Ocfs2-devel] [PATCH 5/5] Use the new DLM operation callbacks for
 recovery and membership
Message-ID: <20131003055034.GA12904@shrek.lan>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/ocfs2/stack_user.c | 89 ++++++++++++++++++++++++++++++++-------------------
 1 file changed, 56 insertions(+), 33 deletions(-)

diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index 6a9038f..5c64671 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -23,6 +23,7 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/reboot.h>
+#include <linux/sched.h>
 #include <asm/uaccess.h>
 
 #include "stackglue.h"
@@ -118,6 +119,7 @@ struct ocfs2_live_connection {
 	enum ocfs2_connection_type	oc_type;
 	atomic_t                        oc_this_node;
 	int                             oc_our_slot;
+	wait_queue_head_t		oc_wait;
 };
 
 struct ocfs2_control_private {
@@ -214,7 +216,7 @@ static int ocfs2_live_connection_new(struct ocfs2_cluster_connection *conn,
 	mutex_lock(&ocfs2_control_lock);
 	c->oc_conn = conn;
 
-	if (atomic_read(&ocfs2_control_opened))
+	if ((c->oc_type == NO_CONTROLD) || atomic_read(&ocfs2_control_opened))
 		list_add(&c->oc_list, &ocfs2_live_connection_list);
 	else {
 		printk(KERN_ERR
@@ -826,6 +828,7 @@ static void user_recover_done(void *arg, struct dlm_slot *slots,
 		}
 
 	lc->oc_our_slot = our_slot;
+	wake_up(&lc->oc_wait);
 }
 
 const struct dlm_lockspace_ops ocfs2_ls_ops = {
@@ -834,11 +837,20 @@ const struct dlm_lockspace_ops ocfs2_ls_ops = {
 	.recover_done = user_recover_done,
 };
 
+static int user_cluster_disconnect(struct ocfs2_cluster_connection *conn)
+{
+	dlm_release_lockspace(conn->cc_lockspace, 2);
+	conn->cc_lockspace = NULL;
+	ocfs2_live_connection_drop(conn->cc_private);
+	conn->cc_private = NULL;
+	return 0;
+}
+
 static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
 {
 	dlm_lockspace_t *fsdlm;
 	struct ocfs2_live_connection *lc = NULL;
-	int rc = 0;
+	int rc = 0, ops_rv;
 
 	BUG_ON(conn == NULL);
 
@@ -848,53 +860,61 @@ static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
 		goto out;
 	}
 
-	lc->oc_type = WITH_CONTROLD;
+	init_waitqueue_head(&lc->oc_wait);
+	atomic_set(&lc->oc_this_node, 0);
+	conn->cc_private = lc;
+	lc->oc_type = NO_CONTROLD;
 
-	rc = ocfs2_live_connection_new(conn, lc);
+	rc = dlm_new_lockspace(conn->cc_name, conn->cc_cluster_name,
+			       DLM_LSFL_FS, DLM_LVB_LEN,
+			       &ocfs2_ls_ops, conn, &ops_rv, &fsdlm);
 	if (rc)
 		goto out;
 
-	/*
-	 * running_proto must have been set before we allowed any mounts
-	 * to proceed.
-	 */
-	if (fs_protocol_compare(&running_proto, &conn->cc_version)) {
-		printk(KERN_ERR
-		       "Unable to mount with fs locking protocol version "
-		       "%u.%u because the userspace control daemon has "
-		       "negotiated %u.%u\n",
-		       conn->cc_version.pv_major, conn->cc_version.pv_minor,
-		       running_proto.pv_major, running_proto.pv_minor);
-		rc = -EPROTO;
-		ocfs2_live_connection_drop(lc);
-		lc = NULL;
+	if (ops_rv == -EOPNOTSUPP) {
+		lc->oc_type = WITH_CONTROLD;
+		printk(KERN_NOTICE "ocfs2: You seem to be using an older "
+				"version of dlm_controld and/or ocfs2-tools."
+				" Please consider upgrading.\n");
+	} else if (ops_rv) {
+		rc = ops_rv;
 		goto out;
 	}
+	conn->cc_lockspace = fsdlm;
 
-	rc = dlm_new_lockspace(conn->cc_name, NULL, DLM_LSFL_FS, DLM_LVB_LEN,
-			       NULL, NULL, NULL, &fsdlm);
-	if (rc) {
-		ocfs2_live_connection_drop(lc);
-		lc = NULL;
+	rc = ocfs2_live_connection_new(conn, lc);
+	if (rc)
 		goto out;
+
+	if (lc->oc_type == WITH_CONTROLD) {
+		/*
+		 * running_proto must have been set before we allowed any mounts
+		 * to proceed.
+		 */
+		if (fs_protocol_compare(&running_proto, &conn->cc_version)) {
+			printk(KERN_ERR
+			       "Unable to mount with fs locking protocol "
+			       "version %u.%u because the userspace control"
+			       " daemon has negotiated %u.%u\n",
+				conn->cc_version.pv_major,
+				conn->cc_version.pv_minor,
+				running_proto.pv_major,
+				running_proto.pv_minor);
+			rc = -EPROTO;
+			user_cluster_disconnect(conn);
+			lc = NULL;
+			goto out;
+		}
 	}
+	else if (lc->oc_type == NO_CONTROLD)
+		wait_event(lc->oc_wait, (atomic_read(&lc->oc_this_node) > 0));
 
-	conn->cc_private = lc;
-	conn->cc_lockspace = fsdlm;
 out:
 	if (rc && lc)
 		kfree(lc);
 	return rc;
 }
 
-static int user_cluster_disconnect(struct ocfs2_cluster_connection *conn)
-{
-	dlm_release_lockspace(conn->cc_lockspace, 2);
-	conn->cc_lockspace = NULL;
-	ocfs2_live_connection_drop(conn->cc_private);
-	conn->cc_private = NULL;
-	return 0;
-}
 
 static int user_cluster_this_node(struct ocfs2_cluster_connection *conn,
 				  unsigned int *this_node)
@@ -904,8 +924,11 @@ static int user_cluster_this_node(struct ocfs2_cluster_connection *conn,
 
 	if (lc->oc_type == WITH_CONTROLD)
 		rc = ocfs2_control_get_this_node();
+	else if (lc->oc_type == NO_CONTROLD)
+		rc = atomic_read(&lc->oc_this_node);
 	else
 		rc = -EINVAL;
+
 	if (rc < 0)
 		return rc;
 
-- 
1.8.1.4


-- 
Goldwyn
