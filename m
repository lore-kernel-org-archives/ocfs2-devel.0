From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Fri, 27 Sep 2013 12:08:25 -0500
Subject: [Ocfs2-devel] [PATCH 4/7] Shift allocation of ocfs2_live_connection
 to ocfs2_cluster_connect
Message-ID: <20130927170820.GA11723@shrek.lan>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This is required because we need the live_connection structure ready
when we perform the dlm_new_lockspace().
---
 fs/ocfs2/stack_user.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index 38c69c8..ffefbb5 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -205,16 +205,10 @@ static struct ocfs2_live_connection *ocfs2_connection_find(const char *name)
  * fill_super(), we can't get dupes here.
  */
 static int ocfs2_live_connection_new(struct ocfs2_cluster_connection *conn,
-				     struct ocfs2_live_connection **c_ret,
+				     struct ocfs2_live_connection *c,
 				     enum ocfs2_connection_type type)
 {
 	int rc = 0;
-	struct ocfs2_live_connection *c;
-
-	c = kzalloc(sizeof(struct ocfs2_live_connection), GFP_KERNEL);
-	if (!c)
-		return -ENOMEM;
-
 	mutex_lock(&ocfs2_control_lock);
 	c->oc_conn = conn;
 	c->oc_type = type;
@@ -229,11 +223,6 @@ static int ocfs2_live_connection_new(struct ocfs2_cluster_connection *conn,
 
 	mutex_unlock(&ocfs2_control_lock);
 
-	if (!rc)
-		*c_ret = c;
-	else
-		kfree(c);
-
 	return rc;
 }
 
@@ -839,12 +828,18 @@ static int user_cluster_disconnect(struct ocfs2_cluster_connection *conn)
 static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
 {
 	dlm_lockspace_t *fsdlm;
-	struct ocfs2_live_connection *uninitialized_var(control);
+	struct ocfs2_live_connection *lc = NULL;
 	int rc = 0, ops_rv;
 	enum ocfs2_connection_type type = NO_CONTROLD;
 
 	BUG_ON(conn == NULL);
 
+	lc = kzalloc(sizeof(struct ocfs2_live_connection), GFP_KERNEL);
+	if (!lc) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
 	rc = dlm_new_lockspace(conn->cc_name, conn->cc_cluster_name,
 			       DLM_LSFL_FS, DLM_LVB_LEN,
 				&ocfs2_ls_ops, conn, &ops_rv, &fsdlm);
@@ -863,7 +858,7 @@ static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
 	}
 	conn->cc_lockspace = fsdlm;
 
-	rc = ocfs2_live_connection_new(conn, &control, type);
+	rc = ocfs2_live_connection_new(conn, lc, type);
 	if (rc)
 		goto out;
 
@@ -883,6 +878,7 @@ static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
 			       running_proto.pv_minor);
 			rc = -EPROTO;
 			user_cluster_disconnect(conn);
+			lc = NULL;
 			goto out;
 		}
 
@@ -890,13 +886,16 @@ static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
 				DLM_LSFL_FS, DLM_LVB_LEN,
 				NULL, NULL, NULL, &fsdlm);
 		if (rc) {
-			ocfs2_live_connection_drop(control);
+			ocfs2_live_connection_drop(lc);
+			lc = NULL;
 			goto out;
 		}
 	}
 
-	conn->cc_private = control;
+	conn->cc_private = lc;
 out:
+	if (rc && lc)
+		kfree(lc);
 	return rc;
 }
 
-- 
1.8.1.4


-- 
Goldwyn
