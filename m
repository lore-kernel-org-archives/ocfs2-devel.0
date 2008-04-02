From: Mark Fasheh <mfasheh@suse.com>
Date: Wed,  2 Apr 2008 13:14:22 -0700
Subject: [Ocfs2-devel] [PATCH 12/62] ocfs2: Introduce the new
	ocfs2_cluster_connect/disconnect() API.
In-Reply-To: <12071673413492-git-send-email-mfasheh@suse.com>
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
Message-ID: <1207167343926-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>

From: Joel Becker <joel.becker@oracle.com>

This step introduces a cluster stack agnostic API for initializing and
exiting.  fs/ocfs2/dlmglue.c no longer uses o2cb/o2dlm knowledge to
connect to the stack.  It is all handled in stackglue.c.

heartbeat.c no longer needs to know how it gets called.
ocfs2_do_node_down() is now a clean recovery trigger.

The big gotcha is the ordering of initializations and de-initializations done
underneath ocfs2_cluster_connect().  ocfs2_dlm_init() used to do all
o2dlm initialization in one block.  Thus, the o2dlm functionality of
ocfs2_cluster_connect() is very straightforward.  ocfs2_dlm_shutdown(),
however, did a few things between de-registration of the eviction
callback and actually shutting down the domain.  Now de-registration and
shutdown of the domain are wrapped within the single
ocfs2_cluster_disconnect() call.  I've checked the code paths to make
sure we can safely tear down things in ocfs2_dlm_shutdown() before
calling ocfs2_cluster_disconnect().  The filesystem has already set
itself to ignore the callback.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dlmglue.c   |   97 ++++++++++++++++++-------------------
 fs/ocfs2/dlmglue.h   |    1 -
 fs/ocfs2/heartbeat.c |   40 +++------------
 fs/ocfs2/heartbeat.h |    2 +-
 fs/ocfs2/ocfs2.h     |    4 +-
 fs/ocfs2/stackglue.c |  131 +++++++++++++++++++++++++++++++++++++++++++++++--
 fs/ocfs2/stackglue.h |   35 +++++++++++++-
 fs/ocfs2/super.c     |   13 ++---
 8 files changed, 221 insertions(+), 102 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 4590376..6652a48 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -27,7 +27,6 @@
 #include <linux/slab.h>
 #include <linux/highmem.h>
 #include <linux/mm.h>
-#include <linux/crc32.h>
 #include <linux/kthread.h>
 #include <linux/pagemap.h>
 #include <linux/debugfs.h>
@@ -259,31 +258,6 @@ static struct ocfs2_lock_res_ops ocfs2_flock_lops = {
 	.flags		= 0,
 };
 
-/*
- * This is the filesystem locking protocol version.
- *
- * Whenever the filesystem does new things with locks (adds or removes a
- * lock, orders them differently, does different things underneath a lock),
- * the version must be changed.  The protocol is negotiated when joining
- * the dlm domain.  A node may join the domain if its major version is
- * identical to all other nodes and its minor version is greater than
- * or equal to all other nodes.  When its minor version is greater than
- * the other nodes, it will run at the minor version specified by the
- * other nodes.
- *
- * If a locking change is made that will not be compatible with older
- * versions, the major number must be increased and the minor version set
- * to zero.  If a change merely adds a behavior that can be disabled when
- * speaking to older versions, the minor version must be increased.  If a
- * change adds a fully backwards compatible change (eg, LVB changes that
- * are just ignored by older versions), the version does not need to be
- * updated.
- */
-const struct dlm_protocol_version ocfs2_locking_protocol = {
-	.pv_major = OCFS2_LOCKING_PROTOCOL_MAJOR,
-	.pv_minor = OCFS2_LOCKING_PROTOCOL_MINOR,
-};
-
 static inline int ocfs2_is_inode_lock(struct ocfs2_lock_res *lockres)
 {
 	return lockres->l_type == OCFS2_LOCK_TYPE_META ||
@@ -886,7 +860,7 @@ static int ocfs2_lock_create(struct ocfs2_super *osb,
 	lockres_or_flags(lockres, OCFS2_LOCK_BUSY);
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
 
-	ret = ocfs2_dlm_lock(osb->dlm,
+	ret = ocfs2_dlm_lock(osb->cconn,
 			     level,
 			     &lockres->l_lksb,
 			     dlm_flags,
@@ -1085,7 +1059,7 @@ again:
 		     lockres->l_name, lockres->l_level, level);
 
 		/* call dlm_lock to upgrade lock now */
-		ret = ocfs2_dlm_lock(osb->dlm,
+		ret = ocfs2_dlm_lock(osb->cconn,
 				     level,
 				     &lockres->l_lksb,
 				     lkm_flags,
@@ -1492,7 +1466,7 @@ int ocfs2_file_lock(struct file *file, int ex, int trylock)
 	lockres_add_mask_waiter(lockres, &mw, OCFS2_LOCK_BUSY, 0);
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
 
-	ret = ocfs2_dlm_lock(osb->dlm, level, &lockres->l_lksb, lkm_flags,
+	ret = ocfs2_dlm_lock(osb->cconn, level, &lockres->l_lksb, lkm_flags,
 			     lockres->l_name, OCFS2_LOCK_ID_MAX_LEN - 1,
 			     lockres);
 	if (ret) {
@@ -2485,8 +2459,7 @@ static void ocfs2_dlm_shutdown_debug(struct ocfs2_super *osb)
 int ocfs2_dlm_init(struct ocfs2_super *osb)
 {
 	int status = 0;
-	u32 dlm_key;
-	struct dlm_ctxt *dlm = NULL;
+	struct ocfs2_cluster_connection *conn = NULL;
 
 	mlog_entry_void();
 
@@ -2508,26 +2481,21 @@ int ocfs2_dlm_init(struct ocfs2_super *osb)
 		goto bail;
 	}
 
-	/* used by the dlm code to make message headers unique, each
-	 * node in this domain must agree on this. */
-	dlm_key = crc32_le(0, osb->uuid_str, strlen(osb->uuid_str));
-
 	/* for now, uuid == domain */
-	dlm = dlm_register_domain(osb->uuid_str, dlm_key,
-				  &osb->osb_locking_proto);
-	if (IS_ERR(dlm)) {
-		status = PTR_ERR(dlm);
+	status = ocfs2_cluster_connect(osb->uuid_str,
+				       strlen(osb->uuid_str),
+				       ocfs2_do_node_down, osb,
+				       &conn);
+	if (status) {
 		mlog_errno(status);
 		goto bail;
 	}
 
-	dlm_register_eviction_cb(dlm, &osb->osb_eviction_cb);
-
 local:
 	ocfs2_super_lock_res_init(&osb->osb_super_lockres, osb);
 	ocfs2_rename_lock_res_init(&osb->osb_rename_lockres, osb);
 
-	osb->dlm = dlm;
+	osb->cconn = conn;
 
 	status = 0;
 bail:
@@ -2545,10 +2513,14 @@ void ocfs2_dlm_shutdown(struct ocfs2_super *osb)
 {
 	mlog_entry_void();
 
-	dlm_unregister_eviction_cb(&osb->osb_eviction_cb);
-
 	ocfs2_drop_osb_locks(osb);
 
+	/*
+	 * Now that we have dropped all locks and ocfs2_dismount_volume()
+	 * has disabled recovery, the DLM won't be talking to us.  It's
+	 * safe to tear things down before disconnecting the cluster.
+	 */
+
 	if (osb->dc_task) {
 		kthread_stop(osb->dc_task);
 		osb->dc_task = NULL;
@@ -2557,8 +2529,8 @@ void ocfs2_dlm_shutdown(struct ocfs2_super *osb)
 	ocfs2_lock_res_free(&osb->osb_super_lockres);
 	ocfs2_lock_res_free(&osb->osb_rename_lockres);
 
-	dlm_unregister_domain(osb->dlm);
-	osb->dlm = NULL;
+	ocfs2_cluster_disconnect(osb->cconn);
+	osb->cconn = NULL;
 
 	ocfs2_dlm_shutdown_debug(osb);
 
@@ -2689,7 +2661,7 @@ static int ocfs2_drop_lock(struct ocfs2_super *osb,
 
 	mlog(0, "lock %s\n", lockres->l_name);
 
-	ret = ocfs2_dlm_unlock(osb->dlm, &lockres->l_lksb, lkm_flags,
+	ret = ocfs2_dlm_unlock(osb->cconn, &lockres->l_lksb, lkm_flags,
 			       lockres);
 	if (ret) {
 		ocfs2_log_dlm_error("ocfs2_dlm_unlock", ret, lockres);
@@ -2823,7 +2795,7 @@ static int ocfs2_downconvert_lock(struct ocfs2_super *osb,
 	if (lvb)
 		dlm_flags |= DLM_LKF_VALBLK;
 
-	ret = ocfs2_dlm_lock(osb->dlm,
+	ret = ocfs2_dlm_lock(osb->cconn,
 			     new_level,
 			     &lockres->l_lksb,
 			     dlm_flags,
@@ -2882,7 +2854,7 @@ static int ocfs2_cancel_convert(struct ocfs2_super *osb,
 	mlog_entry_void();
 	mlog(0, "lock %s\n", lockres->l_name);
 
-	ret = ocfs2_dlm_unlock(osb->dlm, &lockres->l_lksb,
+	ret = ocfs2_dlm_unlock(osb->cconn, &lockres->l_lksb,
 			       DLM_LKF_CANCEL, lockres);
 	if (ret) {
 		ocfs2_log_dlm_error("ocfs2_dlm_unlock", ret, lockres);
@@ -3193,7 +3165,34 @@ static int ocfs2_dentry_convert_worker(struct ocfs2_lock_res *lockres,
 	return UNBLOCK_CONTINUE_POST;
 }
 
+/*
+ * This is the filesystem locking protocol.  It provides the lock handling
+ * hooks for the underlying DLM.  It has a maximum version number.
+ * The version number allows interoperability with systems running at
+ * the same major number and an equal or smaller minor number.
+ *
+ * Whenever the filesystem does new things with locks (adds or removes a
+ * lock, orders them differently, does different things underneath a lock),
+ * the version must be changed.  The protocol is negotiated when joining
+ * the dlm domain.  A node may join the domain if its major version is
+ * identical to all other nodes and its minor version is greater than
+ * or equal to all other nodes.  When its minor version is greater than
+ * the other nodes, it will run at the minor version specified by the
+ * other nodes.
+ *
+ * If a locking change is made that will not be compatible with older
+ * versions, the major number must be increased and the minor version set
+ * to zero.  If a change merely adds a behavior that can be disabled when
+ * speaking to older versions, the minor version must be increased.  If a
+ * change adds a fully backwards compatible change (eg, LVB changes that
+ * are just ignored by older versions), the version does not need to be
+ * updated.
+ */
 static struct ocfs2_locking_protocol lproto = {
+	.lp_max_version = {
+		.pv_major = OCFS2_LOCKING_PROTOCOL_MAJOR,
+		.pv_minor = OCFS2_LOCKING_PROTOCOL_MINOR,
+	},
 	.lp_lock_ast		= ocfs2_locking_ast,
 	.lp_blocking_ast	= ocfs2_blocking_ast,
 	.lp_unlock_ast		= ocfs2_unlock_ast,
diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
index 3238043..2d0a8a0 100644
--- a/fs/ocfs2/dlmglue.h
+++ b/fs/ocfs2/dlmglue.h
@@ -117,5 +117,4 @@ void ocfs2_put_dlm_debug(struct ocfs2_dlm_debug *dlm_debug);
 void dlmglue_init_stack(void);
 void dlmglue_exit_stack(void);
 
-extern const struct dlm_protocol_version ocfs2_locking_protocol;
 #endif	/* DLMGLUE_H */
diff --git a/fs/ocfs2/heartbeat.c b/fs/ocfs2/heartbeat.c
index 80de239..dcac1a4 100644
--- a/fs/ocfs2/heartbeat.c
+++ b/fs/ocfs2/heartbeat.c
@@ -30,8 +30,6 @@
 #include <linux/highmem.h>
 #include <linux/kmod.h>
 
-#include <dlm/dlmapi.h>
-
 #define MLOG_MASK_PREFIX ML_SUPER
 #include <cluster/masklog.h>
 
@@ -64,19 +62,20 @@ void ocfs2_init_node_maps(struct ocfs2_super *osb)
 	ocfs2_node_map_init(&osb->osb_recovering_orphan_dirs);
 }
 
-static void ocfs2_do_node_down(int node_num,
-			       struct ocfs2_super *osb)
+void ocfs2_do_node_down(int node_num, void *data)
 {
+	struct ocfs2_super *osb = data;
+
 	BUG_ON(osb->node_num == node_num);
 
 	mlog(0, "ocfs2: node down event for %d\n", node_num);
 
-	if (!osb->dlm) {
+	if (!osb->cconn) {
 		/*
-		 * No DLM means we're not even ready to participate yet.
-		 * We check the slots after the DLM comes up, so we will
-		 * notice the node death then.  We can safely ignore it
-		 * here.
+		 * No cluster connection means we're not even ready to
+		 * participate yet.  We check the slots after the cluster
+		 * comes up, so we will notice the node death then.  We
+		 * can safely ignore it here.
 		 */
 		return;
 	}
@@ -84,29 +83,6 @@ static void ocfs2_do_node_down(int node_num,
 	ocfs2_recovery_thread(osb, node_num);
 }
 
-/* Called from the dlm when it's about to evict a node. We may also
- * get a heartbeat callback later. */
-static void ocfs2_dlm_eviction_cb(int node_num,
-				  void *data)
-{
-	struct ocfs2_super *osb = (struct ocfs2_super *) data;
-	struct super_block *sb = osb->sb;
-
-	mlog(ML_NOTICE, "device (%u,%u): dlm has evicted node %d\n",
-	     MAJOR(sb->s_dev), MINOR(sb->s_dev), node_num);
-
-	ocfs2_do_node_down(node_num, osb);
-}
-
-void ocfs2_setup_hb_callbacks(struct ocfs2_super *osb)
-{
-	/* Not exactly a heartbeat callback, but leads to essentially
-	 * the same path so we set it up here. */
-	dlm_setup_eviction_cb(&osb->osb_eviction_cb,
-			      ocfs2_dlm_eviction_cb,
-			      osb);
-}
-
 void ocfs2_stop_heartbeat(struct ocfs2_super *osb)
 {
 	int ret;
diff --git a/fs/ocfs2/heartbeat.h b/fs/ocfs2/heartbeat.h
index 98d8ffc..38e2450 100644
--- a/fs/ocfs2/heartbeat.h
+++ b/fs/ocfs2/heartbeat.h
@@ -28,7 +28,7 @@
 
 void ocfs2_init_node_maps(struct ocfs2_super *osb);
 
-void ocfs2_setup_hb_callbacks(struct ocfs2_super *osb);
+void ocfs2_do_node_down(int node_num, void *data);
 void ocfs2_stop_heartbeat(struct ocfs2_super *osb);
 
 /* node map functions - used to keep track of mounted and in-recovery
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 6d7c6d2..664e4fe 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -248,12 +248,10 @@ struct ocfs2_super
 	struct ocfs2_alloc_stats alloc_stats;
 	char dev_str[20];		/* "major,minor" of the device */
 
-	struct dlm_ctxt *dlm;
+	struct ocfs2_cluster_connection *cconn;
 	struct ocfs2_lock_res osb_super_lockres;
 	struct ocfs2_lock_res osb_rename_lockres;
-	struct dlm_eviction_cb osb_eviction_cb;
 	struct ocfs2_dlm_debug *osb_dlm_debug;
-	struct dlm_protocol_version osb_locking_proto;
 
 	struct dentry *osb_debug_root;
 
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index eb88854..f6f309a 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -18,11 +18,21 @@
  * General Public License for more details.
  */
 
+#include <linux/slab.h>
+#include <linux/crc32.h>
+
+/* Needed for AOP_TRUNCATED_PAGE in mlog_errno() */
+#include <linux/fs.h>
+
 #include "cluster/masklog.h"
 #include "stackglue.h"
 
 static struct ocfs2_locking_protocol *lproto;
 
+struct o2dlm_private {
+	struct dlm_eviction_cb op_eviction_cb;
+};
+
 /* These should be identical */
 #if (DLM_LOCK_IV != LKM_IVMODE)
 # error Lock modes do not match
@@ -197,7 +207,7 @@ static void o2dlm_unlock_ast_wrapper(void *astarg, enum dlm_status status)
 	lproto->lp_unlock_ast(astarg, error);
 }
 
-int ocfs2_dlm_lock(struct dlm_ctxt *dlm,
+int ocfs2_dlm_lock(struct ocfs2_cluster_connection *conn,
 		   int mode,
 		   union ocfs2_dlm_lksb *lksb,
 		   u32 flags,
@@ -212,15 +222,15 @@ int ocfs2_dlm_lock(struct dlm_ctxt *dlm,
 
 	BUG_ON(lproto == NULL);
 
-	status = dlmlock(dlm, o2dlm_mode, &lksb->lksb_o2dlm, o2dlm_flags,
-			 name, namelen,
+	status = dlmlock(conn->cc_lockspace, o2dlm_mode, &lksb->lksb_o2dlm,
+			 o2dlm_flags, name, namelen,
 			 o2dlm_lock_ast_wrapper, astarg,
 			 o2dlm_blocking_ast_wrapper);
 	ret = dlm_status_to_errno(status);
 	return ret;
 }
 
-int ocfs2_dlm_unlock(struct dlm_ctxt *dlm,
+int ocfs2_dlm_unlock(struct ocfs2_cluster_connection *conn,
 		     union ocfs2_dlm_lksb *lksb,
 		     u32 flags,
 		     void *astarg)
@@ -231,8 +241,8 @@ int ocfs2_dlm_unlock(struct dlm_ctxt *dlm,
 
 	BUG_ON(lproto == NULL);
 
-	status = dlmunlock(dlm, &lksb->lksb_o2dlm, o2dlm_flags,
-			   o2dlm_unlock_ast_wrapper, astarg);
+	status = dlmunlock(conn->cc_lockspace, &lksb->lksb_o2dlm,
+			   o2dlm_flags, o2dlm_unlock_ast_wrapper, astarg);
 	ret = dlm_status_to_errno(status);
 	return ret;
 }
@@ -252,6 +262,115 @@ void *ocfs2_dlm_lvb(union ocfs2_dlm_lksb *lksb)
 	return (void *)(lksb->lksb_o2dlm.lvb);
 }
 
+/*
+ * Called from the dlm when it's about to evict a node. This is how the
+ * classic stack signals node death.
+ */
+static void o2dlm_eviction_cb(int node_num, void *data)
+{
+	struct ocfs2_cluster_connection *conn = data;
+
+	mlog(ML_NOTICE, "o2dlm has evicted node %d from group %.*s\n",
+	     node_num, conn->cc_namelen, conn->cc_name);
+
+	conn->cc_recovery_handler(node_num, conn->cc_recovery_data);
+}
+
+int ocfs2_cluster_connect(const char *group,
+			  int grouplen,
+			  void (*recovery_handler)(int node_num,
+						   void *recovery_data),
+			  void *recovery_data,
+			  struct ocfs2_cluster_connection **conn)
+{
+	int rc = 0;
+	struct ocfs2_cluster_connection *new_conn;
+	u32 dlm_key;
+	struct dlm_ctxt *dlm;
+	struct o2dlm_private *priv;
+	struct dlm_protocol_version dlm_version;
+
+	BUG_ON(group == NULL);
+	BUG_ON(conn == NULL);
+	BUG_ON(recovery_handler == NULL);
+
+	if (grouplen > GROUP_NAME_MAX) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	new_conn = kzalloc(sizeof(struct ocfs2_cluster_connection),
+			   GFP_KERNEL);
+	if (!new_conn) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	memcpy(new_conn->cc_name, group, grouplen);
+	new_conn->cc_namelen = grouplen;
+	new_conn->cc_recovery_handler = recovery_handler;
+	new_conn->cc_recovery_data = recovery_data;
+
+	/* Start the new connection at our maximum compatibility level */
+	new_conn->cc_version = lproto->lp_max_version;
+
+	priv = kzalloc(sizeof(struct o2dlm_private), GFP_KERNEL);
+	if (!priv) {
+		rc = -ENOMEM;
+		goto out_free;
+	}
+
+	/* This just fills the structure in.  It is safe to use new_conn. */
+	dlm_setup_eviction_cb(&priv->op_eviction_cb, o2dlm_eviction_cb,
+			      new_conn);
+
+	new_conn->cc_private = priv;
+
+	/* used by the dlm code to make message headers unique, each
+	 * node in this domain must agree on this. */
+	dlm_key = crc32_le(0, group, grouplen);
+	dlm_version.pv_major = new_conn->cc_version.pv_major;
+	dlm_version.pv_minor = new_conn->cc_version.pv_minor;
+
+	dlm = dlm_register_domain(group, dlm_key, &dlm_version);
+	if (IS_ERR(dlm)) {
+		rc = PTR_ERR(dlm);
+		mlog_errno(rc);
+		goto out_free;
+	}
+
+	new_conn->cc_version.pv_major = dlm_version.pv_major;
+	new_conn->cc_version.pv_minor = dlm_version.pv_minor;
+	new_conn->cc_lockspace = dlm;
+
+	dlm_register_eviction_cb(dlm, &priv->op_eviction_cb);
+
+	*conn = new_conn;
+
+out_free:
+	if (rc) {
+		kfree(new_conn->cc_private);
+		kfree(new_conn);
+	}
+
+out:
+	return rc;
+}
+
+int ocfs2_cluster_disconnect(struct ocfs2_cluster_connection *conn)
+{
+	struct dlm_ctxt *dlm = conn->cc_lockspace;
+	struct o2dlm_private *priv = conn->cc_private;
+
+	dlm_unregister_eviction_cb(&priv->op_eviction_cb);
+	dlm_unregister_domain(dlm);
+
+	kfree(priv);
+	kfree(conn);
+
+	return 0;
+}
+
 void o2cb_get_stack(struct ocfs2_locking_protocol *proto)
 {
 	BUG_ON(proto == NULL);
diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
index 3c91e24..3900b5c 100644
--- a/fs/ocfs2/stackglue.h
+++ b/fs/ocfs2/stackglue.h
@@ -32,9 +32,22 @@
  */
 #define DLM_LKF_LOCAL		0x00100000
 
+/*
+ * This shadows DLM_LOCKSPACE_LEN in fs/dlm/dlm_internal.h.  That probably
+ * wants to be in a public header.
+ */
+#define GROUP_NAME_MAX		64
+
+
 #include "dlm/dlmapi.h"
 
+struct ocfs2_protocol_version {
+	u8 pv_major;
+	u8 pv_minor;
+};
+
 struct ocfs2_locking_protocol {
+	struct ocfs2_protocol_version lp_max_version;
 	void (*lp_lock_ast)(void *astarg);
 	void (*lp_blocking_ast)(void *astarg, int level);
 	void (*lp_unlock_ast)(void *astarg, int error);
@@ -44,14 +57,32 @@ union ocfs2_dlm_lksb {
 	struct dlm_lockstatus lksb_o2dlm;
 };
 
-int ocfs2_dlm_lock(struct dlm_ctxt *dlm,
+struct ocfs2_cluster_connection {
+	char cc_name[GROUP_NAME_MAX];
+	int cc_namelen;
+	struct ocfs2_protocol_version cc_version;
+	void (*cc_recovery_handler)(int node_num, void *recovery_data);
+	void *cc_recovery_data;
+	void *cc_lockspace;
+	void *cc_private;
+};
+
+int ocfs2_cluster_connect(const char *group,
+			  int grouplen,
+			  void (*recovery_handler)(int node_num,
+						   void *recovery_data),
+			  void *recovery_data,
+			  struct ocfs2_cluster_connection **conn);
+int ocfs2_cluster_disconnect(struct ocfs2_cluster_connection *conn);
+
+int ocfs2_dlm_lock(struct ocfs2_cluster_connection *conn,
 		   int mode,
 		   union ocfs2_dlm_lksb *lksb,
 		   u32 flags,
 		   void *name,
 		   unsigned int namelen,
 		   void *astarg);
-int ocfs2_dlm_unlock(struct dlm_ctxt *dlm,
+int ocfs2_dlm_unlock(struct ocfs2_cluster_connection *conn,
 		     union ocfs2_dlm_lksb *lksb,
 		     u32 flags,
 		     void *astarg);
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index c867546..0ee4975 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1251,9 +1251,9 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 
 	ocfs2_sync_blockdev(sb);
 
-	/* No dlm means we've failed during mount, so skip all the
-	 * steps which depended on that to complete. */
-	if (osb->dlm) {
+	/* No cluster connection means we've failed during mount, so skip
+	 * all the steps which depended on that to complete. */
+	if (osb->cconn) {
 		tmp = ocfs2_super_lock(osb, 1);
 		if (tmp < 0) {
 			mlog_errno(tmp);
@@ -1264,12 +1264,12 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 	if (osb->slot_num != OCFS2_INVALID_SLOT)
 		ocfs2_put_slot(osb);
 
-	if (osb->dlm)
+	if (osb->cconn)
 		ocfs2_super_unlock(osb, 1);
 
 	ocfs2_release_system_inodes(osb);
 
-	if (osb->dlm)
+	if (osb->cconn)
 		ocfs2_dlm_shutdown(osb);
 
 	debugfs_remove(osb->osb_debug_root);
@@ -1341,7 +1341,6 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	sb->s_fs_info = osb;
 	sb->s_op = &ocfs2_sops;
 	sb->s_export_op = &ocfs2_export_ops;
-	osb->osb_locking_proto = ocfs2_locking_protocol;
 	sb->s_time_gran = 1;
 	sb->s_flags |= MS_NOATIME;
 	/* this is needed to support O_LARGEFILE */
@@ -1391,8 +1390,6 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	osb->local_alloc_state = OCFS2_LA_UNUSED;
 	osb->local_alloc_bh = NULL;
 
-	ocfs2_setup_hb_callbacks(osb);
-
 	init_waitqueue_head(&osb->osb_mount_event);
 
 	osb->vol_label = kmalloc(OCFS2_MAX_VOL_LABEL_LEN, GFP_KERNEL);
-- 
1.5.4.1
