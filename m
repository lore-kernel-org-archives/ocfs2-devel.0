From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 30 May 2008 17:36:44 -0700
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2: Remove ->hangup() from stack glue
	operations.
In-Reply-To: <1212194204-3906-1-git-send-email-joel.becker@oracle.com>
References: <1212194204-3906-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1212194204-3906-4-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The ->hangup() call was only used to execute ocfs2_hb_ctl.  Now that
the generic stack glue code handles this, the underlying stack drivers
don't need to know about it.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/stack_o2cb.c |    3 +--
 fs/ocfs2/stack_user.c |    3 +--
 fs/ocfs2/stackglue.c  |    5 +----
 fs/ocfs2/stackglue.h  |   18 +++---------------
 4 files changed, 6 insertions(+), 23 deletions(-)

diff --git a/fs/ocfs2/stack_o2cb.c b/fs/ocfs2/stack_o2cb.c
index 765ade5..fcd120f 100644
--- a/fs/ocfs2/stack_o2cb.c
+++ b/fs/ocfs2/stack_o2cb.c
@@ -317,8 +317,7 @@ out:
 	return rc;
 }
 
-static int o2cb_cluster_disconnect(struct ocfs2_cluster_connection *conn,
-				   int hangup_pending)
+static int o2cb_cluster_disconnect(struct ocfs2_cluster_connection *conn)
 {
 	struct dlm_ctxt *dlm = conn->cc_lockspace;
 	struct o2dlm_private *priv = conn->cc_private;
diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index b503772..56c5bf1 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -816,8 +816,7 @@ out:
 	return rc;
 }
 
-static int user_cluster_disconnect(struct ocfs2_cluster_connection *conn,
-				   int hangup_pending)
+static int user_cluster_disconnect(struct ocfs2_cluster_connection *conn)
 {
 	dlm_release_lockspace(conn->cc_lockspace, 2);
 	conn->cc_lockspace = NULL;
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 5f78ff4..10e149a 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -352,7 +352,7 @@ int ocfs2_cluster_disconnect(struct ocfs2_cluster_connection *conn,
 
 	BUG_ON(conn == NULL);
 
-	ret = active_stack->sp_ops->disconnect(conn, hangup_pending);
+	ret = active_stack->sp_ops->disconnect(conn);
 
 	/* XXX Should we free it anyway? */
 	if (!ret) {
@@ -406,9 +406,6 @@ void ocfs2_cluster_hangup(const char *group, int grouplen)
 	BUG_ON(group == NULL);
 	BUG_ON(group[grouplen] != '\0');
 
-	if (active_stack->sp_ops->hangup)
-		active_stack->sp_ops->hangup(group, grouplen);
-
 	ocfs2_leave_group(group);
 
 	/* cluster_disconnect() was called with hangup_pending==1 */
diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
index fe3fd2a..db56281 100644
--- a/fs/ocfs2/stackglue.h
+++ b/fs/ocfs2/stackglue.h
@@ -134,22 +134,10 @@ struct ocfs2_stack_operations {
 	 * be freed.  Thus, a stack must not return from ->disconnect()
 	 * until it will no longer reference the conn pointer.
 	 *
-	 * If hangup_pending is zero, ocfs2_cluster_disconnect() will also
-	 * be dropping the reference on the module.
+	 * Once this call returns, the stack glue will be dropping this
+	 * connection's reference on the module.
 	 */
-	int (*disconnect)(struct ocfs2_cluster_connection *conn,
-			  int hangup_pending);
-
-	/*
-	 * ocfs2_cluster_hangup() exists for compatibility with older
-	 * ocfs2 tools.  Only the classic stack really needs it.  As such
-	 * ->hangup() is not required of all stacks.  See the comment by
-	 * ocfs2_cluster_hangup() for more details.
-	 *
-	 * Note that ocfs2_cluster_hangup() can only be called if
-	 * hangup_pending was passed to ocfs2_cluster_disconnect().
-	 */
-	void (*hangup)(const char *group, int grouplen);
+	int (*disconnect)(struct ocfs2_cluster_connection *conn);
 
 	/*
 	 * ->this_node() returns the cluster's unique identifier for the
-- 
1.5.4.5
