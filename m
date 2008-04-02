From: Mark Fasheh <mfasheh@suse.com>
Date: Wed,  2 Apr 2008 13:14:30 -0700
Subject: [Ocfs2-devel] [PATCH 20/62] ocfs2: Split o2cb code from generic
	stack functions.
In-Reply-To: <12071673571757-git-send-email-mfasheh@suse.com>
References: <12071673121124-git-send-email-mfasheh@suse.com>
	<1207167318479-git-send-email-mfasheh@suse.com>
	<12071673203909-git-send-email-mfasheh@suse.com>
	<12071673232465-git-send-email-mfasheh@suse.com>
	<12071673263948-git-send-email-mfasheh@suse.com>
	<12071673282579-git-send-email-mfasheh@suse.com>
	<1207167330482-git-send-email-mfasheh@suse.com>
	<12071673321172-git-send-email-mfasheh@suse.com>
	<12071673341888-git-send-email-mfasheh@suse.com>
	<12071673362069-git-send-email-mfasheh@suse.com>
	<12071673391031-git-send-email-mfasheh@suse.com>
	<12071673413492-git-send-email-mfasheh@suse.com>
	<1207167343926-git-send-email-mfasheh@suse.com>
	<12071673461268-git-send-email-mfasheh@suse.com>
	<12071673481928-git-send-email-mfasheh@suse.com>
	<12071673492775-git-send-email-mfasheh@suse.com>
	<12071673511262-git-send-email-mfasheh@suse.com>
	<12071673543752-git-send-email-mfasheh@suse.com>
	<1207167355295-git-send-email-mfasheh@suse.com>
	<12071673571757-git-send-email-mfasheh@suse.com>
Message-ID: <12071673591158-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>

From: Joel Becker <joel.becker@oracle.com>

Split off the o2cb-specific funtionality from the generic stack glue
calls.  This is a precurser to wrapping the o2cb functionality in an
operations vector.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/stackglue.c |  209 ++++++++++++++++++++++++++++++++++----------------
 1 files changed, 144 insertions(+), 65 deletions(-)

diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 51c2546..e35dde6 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -197,21 +197,19 @@ static void o2dlm_unlock_ast_wrapper(void *astarg, enum dlm_status status)
 	lproto->lp_unlock_ast(astarg, error);
 }
 
-int ocfs2_dlm_lock(struct ocfs2_cluster_connection *conn,
-		   int mode,
-		   union ocfs2_dlm_lksb *lksb,
-		   u32 flags,
-		   void *name,
-		   unsigned int namelen,
-		   void *astarg)
+static int o2cb_dlm_lock(struct ocfs2_cluster_connection *conn,
+			 int mode,
+			 union ocfs2_dlm_lksb *lksb,
+			 u32 flags,
+			 void *name,
+			 unsigned int namelen,
+			 void *astarg)
 {
 	enum dlm_status status;
 	int o2dlm_mode = mode_to_o2dlm(mode);
 	int o2dlm_flags = flags_to_o2dlm(flags);
 	int ret;
 
-	BUG_ON(lproto == NULL);
-
 	status = dlmlock(conn->cc_lockspace, o2dlm_mode, &lksb->lksb_o2dlm,
 			 o2dlm_flags, name, namelen,
 			 o2dlm_lock_ast_wrapper, astarg,
@@ -220,43 +218,80 @@ int ocfs2_dlm_lock(struct ocfs2_cluster_connection *conn,
 	return ret;
 }
 
-int ocfs2_dlm_unlock(struct ocfs2_cluster_connection *conn,
-		     union ocfs2_dlm_lksb *lksb,
-		     u32 flags,
-		     void *astarg)
+int ocfs2_dlm_lock(struct ocfs2_cluster_connection *conn,
+		   int mode,
+		   union ocfs2_dlm_lksb *lksb,
+		   u32 flags,
+		   void *name,
+		   unsigned int namelen,
+		   void *astarg)
+{
+	BUG_ON(lproto == NULL);
+
+	return o2cb_dlm_lock(conn, mode, lksb, flags,
+			     name, namelen, astarg);
+}
+
+static int o2cb_dlm_unlock(struct ocfs2_cluster_connection *conn,
+			   union ocfs2_dlm_lksb *lksb,
+			   u32 flags,
+			   void *astarg)
 {
 	enum dlm_status status;
 	int o2dlm_flags = flags_to_o2dlm(flags);
 	int ret;
 
-	BUG_ON(lproto == NULL);
-
 	status = dlmunlock(conn->cc_lockspace, &lksb->lksb_o2dlm,
 			   o2dlm_flags, o2dlm_unlock_ast_wrapper, astarg);
 	ret = dlm_status_to_errno(status);
 	return ret;
 }
 
-int ocfs2_dlm_lock_status(union ocfs2_dlm_lksb *lksb)
+int ocfs2_dlm_unlock(struct ocfs2_cluster_connection *conn,
+		     union ocfs2_dlm_lksb *lksb,
+		     u32 flags,
+		     void *astarg)
+{
+	BUG_ON(lproto == NULL);
+
+	return o2cb_dlm_unlock(conn, lksb, flags, astarg);
+}
+
+static int o2cb_dlm_lock_status(union ocfs2_dlm_lksb *lksb)
 {
 	return dlm_status_to_errno(lksb->lksb_o2dlm.status);
 }
 
+int ocfs2_dlm_lock_status(union ocfs2_dlm_lksb *lksb)
+{
+	return o2cb_dlm_lock_status(lksb);
+}
+
 /*
  * Why don't we cast to ocfs2_meta_lvb?  The "clean" answer is that we
  * don't cast at the glue level.  The real answer is that the header
  * ordering is nigh impossible.
  */
-void *ocfs2_dlm_lvb(union ocfs2_dlm_lksb *lksb)
+static void *o2cb_dlm_lvb(union ocfs2_dlm_lksb *lksb)
 {
 	return (void *)(lksb->lksb_o2dlm.lvb);
 }
 
-void ocfs2_dlm_dump_lksb(union ocfs2_dlm_lksb *lksb)
+void *ocfs2_dlm_lvb(union ocfs2_dlm_lksb *lksb)
+{
+	return o2cb_dlm_lvb(lksb);
+}
+
+static void o2cb_dlm_dump_lksb(union ocfs2_dlm_lksb *lksb)
 {
 	dlm_print_one_lock(lksb->lksb_o2dlm.lockid);
 }
 
+void ocfs2_dlm_dump_lksb(union ocfs2_dlm_lksb *lksb)
+{
+	o2cb_dlm_dump_lksb(lksb);
+}
+
 /*
  * Called from the dlm when it's about to evict a node. This is how the
  * classic stack signals node death.
@@ -271,6 +306,62 @@ static void o2dlm_eviction_cb(int node_num, void *data)
 	conn->cc_recovery_handler(node_num, conn->cc_recovery_data);
 }
 
+static int o2cb_cluster_connect(struct ocfs2_cluster_connection *conn)
+{
+	int rc = 0;
+	u32 dlm_key;
+	struct dlm_ctxt *dlm;
+	struct o2dlm_private *priv;
+	struct dlm_protocol_version dlm_version;
+
+	BUG_ON(conn == NULL);
+
+	/* for now we only have one cluster/node, make sure we see it
+	 * in the heartbeat universe */
+	if (!o2hb_check_local_node_heartbeating()) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	priv = kzalloc(sizeof(struct o2dlm_private), GFP_KERNEL);
+	if (!priv) {
+		rc = -ENOMEM;
+		goto out_free;
+	}
+
+	/* This just fills the structure in.  It is safe to pass conn. */
+	dlm_setup_eviction_cb(&priv->op_eviction_cb, o2dlm_eviction_cb,
+			      conn);
+
+	conn->cc_private = priv;
+
+	/* used by the dlm code to make message headers unique, each
+	 * node in this domain must agree on this. */
+	dlm_key = crc32_le(0, conn->cc_name, conn->cc_namelen);
+	dlm_version.pv_major = conn->cc_version.pv_major;
+	dlm_version.pv_minor = conn->cc_version.pv_minor;
+
+	dlm = dlm_register_domain(conn->cc_name, dlm_key, &dlm_version);
+	if (IS_ERR(dlm)) {
+		rc = PTR_ERR(dlm);
+		mlog_errno(rc);
+		goto out_free;
+	}
+
+	conn->cc_version.pv_major = dlm_version.pv_major;
+	conn->cc_version.pv_minor = dlm_version.pv_minor;
+	conn->cc_lockspace = dlm;
+
+	dlm_register_eviction_cb(dlm, &priv->op_eviction_cb);
+
+out_free:
+	if (rc && conn->cc_private)
+		kfree(conn->cc_private);
+
+out:
+	return rc;
+}
+
 int ocfs2_cluster_connect(const char *group,
 			  int grouplen,
 			  void (*recovery_handler)(int node_num,
@@ -280,10 +371,6 @@ int ocfs2_cluster_connect(const char *group,
 {
 	int rc = 0;
 	struct ocfs2_cluster_connection *new_conn;
-	u32 dlm_key;
-	struct dlm_ctxt *dlm;
-	struct o2dlm_private *priv;
-	struct dlm_protocol_version dlm_version;
 
 	BUG_ON(group == NULL);
 	BUG_ON(conn == NULL);
@@ -294,13 +381,6 @@ int ocfs2_cluster_connect(const char *group,
 		goto out;
 	}
 
-	/* for now we only have one cluster/node, make sure we see it
-	 * in the heartbeat universe */
-	if (!o2hb_check_local_node_heartbeating()) {
-		rc = -EINVAL;
-		goto out;
-	}
-
 	new_conn = kzalloc(sizeof(struct ocfs2_cluster_connection),
 			   GFP_KERNEL);
 	if (!new_conn) {
@@ -316,64 +396,53 @@ int ocfs2_cluster_connect(const char *group,
 	/* Start the new connection at our maximum compatibility level */
 	new_conn->cc_version = lproto->lp_max_version;
 
-	priv = kzalloc(sizeof(struct o2dlm_private), GFP_KERNEL);
-	if (!priv) {
-		rc = -ENOMEM;
-		goto out_free;
-	}
-
-	/* This just fills the structure in.  It is safe to use new_conn. */
-	dlm_setup_eviction_cb(&priv->op_eviction_cb, o2dlm_eviction_cb,
-			      new_conn);
-
-	new_conn->cc_private = priv;
-
-	/* used by the dlm code to make message headers unique, each
-	 * node in this domain must agree on this. */
-	dlm_key = crc32_le(0, group, grouplen);
-	dlm_version.pv_major = new_conn->cc_version.pv_major;
-	dlm_version.pv_minor = new_conn->cc_version.pv_minor;
-
-	dlm = dlm_register_domain(group, dlm_key, &dlm_version);
-	if (IS_ERR(dlm)) {
-		rc = PTR_ERR(dlm);
+	rc = o2cb_cluster_connect(new_conn);
+	if (rc) {
 		mlog_errno(rc);
 		goto out_free;
 	}
 
-	new_conn->cc_version.pv_major = dlm_version.pv_major;
-	new_conn->cc_version.pv_minor = dlm_version.pv_minor;
-	new_conn->cc_lockspace = dlm;
-
-	dlm_register_eviction_cb(dlm, &priv->op_eviction_cb);
-
 	*conn = new_conn;
 
 out_free:
-	if (rc) {
-		kfree(new_conn->cc_private);
+	if (rc)
 		kfree(new_conn);
-	}
 
 out:
 	return rc;
 }
 
 
-int ocfs2_cluster_disconnect(struct ocfs2_cluster_connection *conn)
+static int o2cb_cluster_disconnect(struct ocfs2_cluster_connection *conn)
 {
 	struct dlm_ctxt *dlm = conn->cc_lockspace;
 	struct o2dlm_private *priv = conn->cc_private;
 
 	dlm_unregister_eviction_cb(&priv->op_eviction_cb);
-	dlm_unregister_domain(dlm);
-
+	conn->cc_private = NULL;
 	kfree(priv);
-	kfree(conn);
+
+	dlm_unregister_domain(dlm);
+	conn->cc_lockspace = NULL;
 
 	return 0;
 }
 
+int ocfs2_cluster_disconnect(struct ocfs2_cluster_connection *conn)
+{
+	int ret;
+
+	BUG_ON(conn == NULL);
+
+	ret = o2cb_cluster_disconnect(conn);
+
+	/* XXX Should we free it anyway? */
+	if (!ret)
+		kfree(conn);
+
+	return ret;
+}
+
 static void o2hb_stop(const char *group)
 {
 	int ret;
@@ -406,15 +475,20 @@ static void o2hb_stop(const char *group)
  *
  * Other stacks will eventually provide a NULL ->hangup() pointer.
  */
+static void o2cb_cluster_hangup(const char *group, int grouplen)
+{
+	o2hb_stop(group);
+}
+
 void ocfs2_cluster_hangup(const char *group, int grouplen)
 {
 	BUG_ON(group == NULL);
 	BUG_ON(group[grouplen] != '\0');
 
-	o2hb_stop(group);
+	o2cb_cluster_hangup(group, grouplen);
 }
 
-int ocfs2_cluster_this_node(unsigned int *node)
+static int o2cb_cluster_this_node(unsigned int *node)
 {
 	int node_num;
 
@@ -429,6 +503,11 @@ int ocfs2_cluster_this_node(unsigned int *node)
 	return 0;
 }
 
+int ocfs2_cluster_this_node(unsigned int *node)
+{
+	return o2cb_cluster_this_node(node);
+}
+
 void ocfs2_stack_glue_set_locking_protocol(struct ocfs2_locking_protocol *proto)
 {
 	BUG_ON(proto != NULL);
-- 
1.5.4.1
