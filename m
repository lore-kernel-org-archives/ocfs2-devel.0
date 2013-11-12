From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Tue, 12 Nov 2013 08:07:14 -0600
Subject: [Ocfs2-devel] [PATCH 3/6] Shift allocation ocfs2_live_connection to
	user_connect()
Message-ID: <20131112140710.GA3940@shrek.lan>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We perform this because the DLM recovery callbacks will require
the ocfs2_live_connection structure to record the node information
when dlm_new_lockspace() is updated (in the last patch of the series).

Before calling dlm_new_lockspace(), we need the structure ready for
the .recover_done() callback, which would set oc_this_node. This is
the reason we allocate ocfs2_live_connection beforehand in user_connect().

[AKPM] rc initialization is not required because it assigned in case of
errors. It will be cleared by compiler anyways.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/ocfs2/stack_user.c | 37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index 4111855..0afb86d 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -200,15 +200,10 @@ static struct ocfs2_live_connection *ocfs2_connection_find(const char *name)
  * mount path.  Since the VFS prevents multiple calls to
  * fill_super(), we can't get dupes here.
  */
-static int ocfs2_live_connection_new(struct ocfs2_cluster_connection *conn,
-				     struct ocfs2_live_connection **c_ret)
+static int ocfs2_live_connection_attach(struct ocfs2_cluster_connection *conn,
+				     struct ocfs2_live_connection *c)
 {
 	int rc = 0;
-	struct ocfs2_live_connection *c;
-
-	c = kzalloc(sizeof(struct ocfs2_live_connection), GFP_KERNEL);
-	if (!c)
-		return -ENOMEM;
 
 	mutex_lock(&ocfs2_control_lock);
 	c->oc_conn = conn;
@@ -222,12 +217,6 @@ static int ocfs2_live_connection_new(struct ocfs2_cluster_connection *conn,
 	}
 
 	mutex_unlock(&ocfs2_control_lock);
-
-	if (!rc)
-		*c_ret = c;
-	else
-		kfree(c);
-
 	return rc;
 }
 
@@ -840,12 +829,18 @@ const struct dlm_lockspace_ops ocfs2_ls_ops = {
 static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
 {
 	dlm_lockspace_t *fsdlm;
-	struct ocfs2_live_connection *uninitialized_var(control);
-	int rc = 0;
+	struct ocfs2_live_connection *lc;
+	int rc;
 
 	BUG_ON(conn == NULL);
 
-	rc = ocfs2_live_connection_new(conn, &control);
+	lc = kzalloc(sizeof(struct ocfs2_live_connection), GFP_KERNEL);
+	if (!lc) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	rc = ocfs2_live_connection_attach(conn, lc);
 	if (rc)
 		goto out;
 
@@ -861,20 +856,24 @@ static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
 		       conn->cc_version.pv_major, conn->cc_version.pv_minor,
 		       running_proto.pv_major, running_proto.pv_minor);
 		rc = -EPROTO;
-		ocfs2_live_connection_drop(control);
+		ocfs2_live_connection_drop(lc);
+		lc = NULL;
 		goto out;
 	}
 
 	rc = dlm_new_lockspace(conn->cc_name, NULL, DLM_LSFL_FS, DLM_LVB_LEN,
 			       NULL, NULL, NULL, &fsdlm);
 	if (rc) {
-		ocfs2_live_connection_drop(control);
+		ocfs2_live_connection_drop(lc);
+		lc = NULL;
 		goto out;
 	}
 
-	conn->cc_private = control;
+	conn->cc_private = lc;
 	conn->cc_lockspace = fsdlm;
 out:
+	if (rc && lc)
+		kfree(lc);
 	return rc;
 }
 
-- 
1.8.1.4


-- 
Goldwyn
