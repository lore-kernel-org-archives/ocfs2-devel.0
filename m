From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Wed, 21 Aug 2013 08:10:06 -0500
Subject: [Ocfs2-devel] [PATCH 3/5] Remove control handling from
	cluster_connect
Message-ID: <20130821131002.GA4005@shrek.cartoons>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/ocfs2/stack_user.c | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index 2ef6ad5..d604a36 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -822,36 +822,14 @@ const struct dlm_lockspace_ops ocfs2_ls_ops = {
 static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
 {
 	dlm_lockspace_t *fsdlm;
-	struct ocfs2_live_connection *uninitialized_var(control);
 	int rc = 0, ops_rv;
 
 	BUG_ON(conn == NULL);
 
-	rc = ocfs2_live_connection_new(conn, &control);
-	if (rc)
-		goto out;
-
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
-		ocfs2_live_connection_drop(control);
-		goto out;
-	}
-
 	rc = dlm_new_lockspace(conn->cc_name, conn->cc_cluster_name,
 			       DLM_LSFL_FS, DLM_LVB_LEN,
 			       &ocfs2_ls_ops, conn, &ops_rv, &fsdlm);
 	if (rc) {
-		ocfs2_live_connection_drop(control);
 		goto out;
 	}
 
@@ -861,7 +839,6 @@ static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
 		goto out;
 	}
 
-	conn->cc_private = control;
 	conn->cc_lockspace = fsdlm;
 out:
 	return rc;
@@ -871,7 +848,6 @@ static int user_cluster_disconnect(struct ocfs2_cluster_connection *conn)
 {
 	dlm_release_lockspace(conn->cc_lockspace, 2);
 	conn->cc_lockspace = NULL;
-	ocfs2_live_connection_drop(conn->cc_private);
 	conn->cc_private = NULL;
 	return 0;
 }
-- 
1.8.1.4


-- 
Goldwyn
