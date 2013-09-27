From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Fri, 27 Sep 2013 12:09:42 -0500
Subject: [Ocfs2-devel] [PATCH 6/7] Get this_node according to type
Message-ID: <20130927170937.GA11739@shrek.lan>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

---
 fs/ocfs2/dlmglue.c    |  2 +-
 fs/ocfs2/stack_o2cb.c |  3 ++-
 fs/ocfs2/stack_user.c | 10 ++++++++--
 fs/ocfs2/stackglue.c  |  4 ++--
 fs/ocfs2/stackglue.h  |  6 ++++--
 5 files changed, 17 insertions(+), 8 deletions(-)

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
index cccc1e1..2ca8162 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -923,11 +923,17 @@ out:
 	return rc;
 }
 
-static int user_cluster_this_node(unsigned int *this_node)
+static int user_cluster_this_node(struct ocfs2_cluster_connection *conn,
+				  unsigned int *this_node)
 {
 	int rc;
+	struct ocfs2_live_connection *lc = conn->cc_private;
+
+	if (lc->oc_type == NO_CONTROLD)
+		rc = atomic_read(&lc->oc_this_node);
+	else
+		rc = ocfs2_control_get_this_node();
 
-	rc = ocfs2_control_get_this_node();
 	if (rc < 0)
 		return rc;
 
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
index b46fd51..d3a54df 100644
--- a/fs/ocfs2/stackglue.h
+++ b/fs/ocfs2/stackglue.h
@@ -157,7 +157,8 @@ struct ocfs2_stack_operations {
 	 * ->this_node() returns the cluster's unique identifier for the
 	 * local node.
 	 */
-	int (*this_node)(unsigned int *node);
+	int (*this_node)(struct ocfs2_cluster_connection *conn,
+			 unsigned int *node);
 
 	/*
 	 * Call the underlying dlm lock function.  The ->dlm_lock()
@@ -267,7 +268,8 @@ int ocfs2_cluster_connect_agnostic(const char *group,
 int ocfs2_cluster_disconnect(struct ocfs2_cluster_connection *conn,
 			     int hangup_pending);
 void ocfs2_cluster_hangup(const char *group, int grouplen);
-int ocfs2_cluster_this_node(unsigned int *node);
+int ocfs2_cluster_this_node(struct ocfs2_cluster_connection *,
+			    unsigned int *node);
 
 struct ocfs2_lock_res;
 int ocfs2_dlm_lock(struct ocfs2_cluster_connection *conn,
-- 
1.8.1.4


-- 
Goldwyn
