From: Mark Fasheh <mfasheh@suse.com>
Date: Sun, 1 Jun 2008 09:16:23 -0700
Subject: [Ocfs2-devel] [git patches] Ocfs2 fixes
Message-ID: <20080601161623.GC28100@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Andrew Morton <akpm@linux-foundation.org>

Here's a few Ocfs2 fixes that are ready for upstream. The 'user_stack'
rename in particular fixes some compile errors which folks have hit, due to
clashing symbols.
	--Mark

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/ocfs2/cluster/tcp.c          |   28 +++++++++-------------------
 fs/ocfs2/cluster/tcp.h          |   12 ++++++------
 fs/ocfs2/cluster/tcp_internal.h |   32 ++++++++++++++++++++++++++++++++
 fs/ocfs2/dlm/dlmdebug.h         |   12 ++++++------
 fs/ocfs2/stack_user.c           |   34 +++++++++++++++++-----------------
 5 files changed, 70 insertions(+), 48 deletions(-)

Joel Becker (1):
      ocfs2: Rename 'user_stack' plugin structure to 'ocfs2_user_plugin'

Sunil Mushran (3):
      ocfs2/net: Silence build warnings
      ocfs2/dlm: Silence build warnings
      ocfs2/net: Silence build warnings

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 1e44ad1..a27d615 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -142,53 +142,43 @@ static void o2net_idle_timer(unsigned long data);
 static void o2net_sc_postpone_idle(struct o2net_sock_container *sc);
 static void o2net_sc_reset_idle_timer(struct o2net_sock_container *sc);
 
-static void o2net_init_nst(struct o2net_send_tracking *nst, u32 msgtype,
-			   u32 msgkey, struct task_struct *task, u8 node)
-{
 #ifdef CONFIG_DEBUG_FS
+void o2net_init_nst(struct o2net_send_tracking *nst, u32 msgtype,
+		    u32 msgkey, struct task_struct *task, u8 node)
+{
 	INIT_LIST_HEAD(&nst->st_net_debug_item);
 	nst->st_task = task;
 	nst->st_msg_type = msgtype;
 	nst->st_msg_key = msgkey;
 	nst->st_node = node;
-#endif
 }
 
-static void o2net_set_nst_sock_time(struct o2net_send_tracking *nst)
+void o2net_set_nst_sock_time(struct o2net_send_tracking *nst)
 {
-#ifdef CONFIG_DEBUG_FS
 	do_gettimeofday(&nst->st_sock_time);
-#endif
 }
 
-static void o2net_set_nst_send_time(struct o2net_send_tracking *nst)
+void o2net_set_nst_send_time(struct o2net_send_tracking *nst)
 {
-#ifdef CONFIG_DEBUG_FS
 	do_gettimeofday(&nst->st_send_time);
-#endif
 }
 
-static void o2net_set_nst_status_time(struct o2net_send_tracking *nst)
+void o2net_set_nst_status_time(struct o2net_send_tracking *nst)
 {
-#ifdef CONFIG_DEBUG_FS
 	do_gettimeofday(&nst->st_status_time);
-#endif
 }
 
-static void o2net_set_nst_sock_container(struct o2net_send_tracking *nst,
+void o2net_set_nst_sock_container(struct o2net_send_tracking *nst,
 					 struct o2net_sock_container *sc)
 {
-#ifdef CONFIG_DEBUG_FS
 	nst->st_sc = sc;
-#endif
 }
 
-static void o2net_set_nst_msg_id(struct o2net_send_tracking *nst, u32 msg_id)
+void o2net_set_nst_msg_id(struct o2net_send_tracking *nst, u32 msg_id)
 {
-#ifdef CONFIG_DEBUG_FS
 	nst->st_id = msg_id;
-#endif
 }
+#endif /* CONFIG_DEBUG_FS */
 
 static inline int o2net_reconnect_delay(void)
 {
diff --git a/fs/ocfs2/cluster/tcp.h b/fs/ocfs2/cluster/tcp.h
index a705d5d..fd6179e 100644
--- a/fs/ocfs2/cluster/tcp.h
+++ b/fs/ocfs2/cluster/tcp.h
@@ -128,23 +128,23 @@ void o2net_debug_del_nst(struct o2net_send_tracking *nst);
 void o2net_debug_add_sc(struct o2net_sock_container *sc);
 void o2net_debug_del_sc(struct o2net_sock_container *sc);
 #else
-static int o2net_debugfs_init(void)
+static inline int o2net_debugfs_init(void)
 {
 	return 0;
 }
-static void o2net_debugfs_exit(void)
+static inline void o2net_debugfs_exit(void)
 {
 }
-static void o2net_debug_add_nst(struct o2net_send_tracking *nst)
+static inline void o2net_debug_add_nst(struct o2net_send_tracking *nst)
 {
 }
-static void o2net_debug_del_nst(struct o2net_send_tracking *nst)
+static inline void o2net_debug_del_nst(struct o2net_send_tracking *nst)
 {
 }
-static void o2net_debug_add_sc(struct o2net_sock_container *sc)
+static inline void o2net_debug_add_sc(struct o2net_sock_container *sc)
 {
 }
-static void o2net_debug_del_sc(struct o2net_sock_container *sc)
+static inline void o2net_debug_del_sc(struct o2net_sock_container *sc)
 {
 }
 #endif	/* CONFIG_DEBUG_FS */
diff --git a/fs/ocfs2/cluster/tcp_internal.h b/fs/ocfs2/cluster/tcp_internal.h
index 8d58cfe..18307ff 100644
--- a/fs/ocfs2/cluster/tcp_internal.h
+++ b/fs/ocfs2/cluster/tcp_internal.h
@@ -224,10 +224,42 @@ struct o2net_send_tracking {
 	struct timeval			st_send_time;
 	struct timeval			st_status_time;
 };
+
+void o2net_init_nst(struct o2net_send_tracking *nst, u32 msgtype,
+		    u32 msgkey, struct task_struct *task, u8 node);
+void o2net_set_nst_sock_time(struct o2net_send_tracking *nst);
+void o2net_set_nst_send_time(struct o2net_send_tracking *nst);
+void o2net_set_nst_status_time(struct o2net_send_tracking *nst);
+void o2net_set_nst_sock_container(struct o2net_send_tracking *nst,
+				  struct o2net_sock_container *sc);
+void o2net_set_nst_msg_id(struct o2net_send_tracking *nst, u32 msg_id);
+
 #else
 struct o2net_send_tracking {
 	u32	dummy;
 };
+
+static inline void o2net_init_nst(struct o2net_send_tracking *nst, u32 msgtype,
+				  u32 msgkey, struct task_struct *task, u8 node)
+{
+}
+static inline void o2net_set_nst_sock_time(struct o2net_send_tracking *nst)
+{
+}
+static inline void o2net_set_nst_send_time(struct o2net_send_tracking *nst)
+{
+}
+static inline void o2net_set_nst_status_time(struct o2net_send_tracking *nst)
+{
+}
+static inline void o2net_set_nst_sock_container(struct o2net_send_tracking *nst,
+						struct o2net_sock_container *sc)
+{
+}
+static inline void o2net_set_nst_msg_id(struct o2net_send_tracking *nst,
+					u32 msg_id)
+{
+}
 #endif	/* CONFIG_DEBUG_FS */
 
 #endif /* O2CLUSTER_TCP_INTERNAL_H */
diff --git a/fs/ocfs2/dlm/dlmdebug.h b/fs/ocfs2/dlm/dlmdebug.h
index d34a62a..8c686d2 100644
--- a/fs/ocfs2/dlm/dlmdebug.h
+++ b/fs/ocfs2/dlm/dlmdebug.h
@@ -60,25 +60,25 @@ void dlm_destroy_debugfs_root(void);
 
 #else
 
-static int dlm_debug_init(struct dlm_ctxt *dlm)
+static inline int dlm_debug_init(struct dlm_ctxt *dlm)
 {
 	return 0;
 }
-static void dlm_debug_shutdown(struct dlm_ctxt *dlm)
+static inline void dlm_debug_shutdown(struct dlm_ctxt *dlm)
 {
 }
-static int dlm_create_debugfs_subroot(struct dlm_ctxt *dlm)
+static inline int dlm_create_debugfs_subroot(struct dlm_ctxt *dlm)
 {
 	return 0;
 }
-static void dlm_destroy_debugfs_subroot(struct dlm_ctxt *dlm)
+static inline void dlm_destroy_debugfs_subroot(struct dlm_ctxt *dlm)
 {
 }
-static int dlm_create_debugfs_root(void)
+static inline int dlm_create_debugfs_root(void)
 {
 	return 0;
 }
-static void dlm_destroy_debugfs_root(void)
+static inline void dlm_destroy_debugfs_root(void)
 {
 }
 
diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index b503772..6b97d11 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -61,7 +61,7 @@
  * negotiated by the client.  The client negotiates based on the maximum
  * version advertised in /sys/fs/ocfs2/max_locking_protocol.  The major
  * number from the "SETV" message must match
- * user_stack.sp_proto->lp_max_version.pv_major, and the minor number
+ * ocfs2_user_plugin.sp_proto->lp_max_version.pv_major, and the minor number
  * must be less than or equal to ...->lp_max_version.pv_minor.
  *
  * Once this information has been set, mounts will be allowed.  From this
@@ -153,7 +153,7 @@ union ocfs2_control_message {
 	struct ocfs2_control_message_down	u_down;
 };
 
-static struct ocfs2_stack_plugin user_stack;
+static struct ocfs2_stack_plugin ocfs2_user_plugin;
 
 static atomic_t ocfs2_control_opened;
 static int ocfs2_control_this_node = -1;
@@ -399,7 +399,7 @@ static int ocfs2_control_do_setversion_msg(struct file *file,
 	char *ptr = NULL;
 	struct ocfs2_control_private *p = file->private_data;
 	struct ocfs2_protocol_version *max =
-		&user_stack.sp_proto->lp_max_version;
+		&ocfs2_user_plugin.sp_proto->lp_max_version;
 
 	if (ocfs2_control_get_handshake_state(file) !=
 	    OCFS2_CONTROL_HANDSHAKE_PROTOCOL)
@@ -680,7 +680,7 @@ static void fsdlm_lock_ast_wrapper(void *astarg)
 	struct dlm_lksb *lksb = fsdlm_astarg_to_lksb(astarg);
 	int status = lksb->sb_status;
 
-	BUG_ON(user_stack.sp_proto == NULL);
+	BUG_ON(ocfs2_user_plugin.sp_proto == NULL);
 
 	/*
 	 * For now we're punting on the issue of other non-standard errors
@@ -693,16 +693,16 @@ static void fsdlm_lock_ast_wrapper(void *astarg)
 	 */
 
 	if (status == -DLM_EUNLOCK || status == -DLM_ECANCEL)
-		user_stack.sp_proto->lp_unlock_ast(astarg, 0);
+		ocfs2_user_plugin.sp_proto->lp_unlock_ast(astarg, 0);
 	else
-		user_stack.sp_proto->lp_lock_ast(astarg);
+		ocfs2_user_plugin.sp_proto->lp_lock_ast(astarg);
 }
 
 static void fsdlm_blocking_ast_wrapper(void *astarg, int level)
 {
-	BUG_ON(user_stack.sp_proto == NULL);
+	BUG_ON(ocfs2_user_plugin.sp_proto == NULL);
 
-	user_stack.sp_proto->lp_blocking_ast(astarg, level);
+	ocfs2_user_plugin.sp_proto->lp_blocking_ast(astarg, level);
 }
 
 static int user_dlm_lock(struct ocfs2_cluster_connection *conn,
@@ -838,7 +838,7 @@ static int user_cluster_this_node(unsigned int *this_node)
 	return 0;
 }
 
-static struct ocfs2_stack_operations user_stack_ops = {
+static struct ocfs2_stack_operations ocfs2_user_plugin_ops = {
 	.connect	= user_cluster_connect,
 	.disconnect	= user_cluster_disconnect,
 	.this_node	= user_cluster_this_node,
@@ -849,20 +849,20 @@ static struct ocfs2_stack_operations user_stack_ops = {
 	.dump_lksb	= user_dlm_dump_lksb,
 };
 
-static struct ocfs2_stack_plugin user_stack = {
+static struct ocfs2_stack_plugin ocfs2_user_plugin = {
 	.sp_name	= "user",
-	.sp_ops		= &user_stack_ops,
+	.sp_ops		= &ocfs2_user_plugin_ops,
 	.sp_owner	= THIS_MODULE,
 };
 
 
-static int __init user_stack_init(void)
+static int __init ocfs2_user_plugin_init(void)
 {
 	int rc;
 
 	rc = ocfs2_control_init();
 	if (!rc) {
-		rc = ocfs2_stack_glue_register(&user_stack);
+		rc = ocfs2_stack_glue_register(&ocfs2_user_plugin);
 		if (rc)
 			ocfs2_control_exit();
 	}
@@ -870,14 +870,14 @@ static int __init user_stack_init(void)
 	return rc;
 }
 
-static void __exit user_stack_exit(void)
+static void __exit ocfs2_user_plugin_exit(void)
 {
-	ocfs2_stack_glue_unregister(&user_stack);
+	ocfs2_stack_glue_unregister(&ocfs2_user_plugin);
 	ocfs2_control_exit();
 }
 
 MODULE_AUTHOR("Oracle");
 MODULE_DESCRIPTION("ocfs2 driver for userspace cluster stacks");
 MODULE_LICENSE("GPL");
-module_init(user_stack_init);
-module_exit(user_stack_exit);
+module_init(ocfs2_user_plugin_init);
+module_exit(ocfs2_user_plugin_exit);
