From: Mark Fasheh <mfasheh@suse.com>
Date: Wed,  2 Apr 2008 13:14:32 -0700
Subject: [Ocfs2-devel] [PATCH 22/62] ocfs2: Break out stackglue into modules.
In-Reply-To: <12071673613757-git-send-email-mfasheh@suse.com>
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
	<12071673591158-git-send-email-mfasheh@suse.com>
	<12071673613757-git-send-email-mfasheh@suse.com>
Message-ID: <1207167363119-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>

From: Joel Becker <joel.becker@oracle.com>

We define the ocfs2_stack_plugin structure to represent a stack driver.
The o2cb stack code is split into stack_o2cb.c.  This becomes the
ocfs2_stack_o2cb.ko module.

The stackglue generic functions are similarly split into the
ocfs2_stackglue.ko module.  This module now provides an interface to
register drivers.  The ocfs2_stack_o2cb driver registers itself.  As
part of this interface, ocfs2_stackglue can load drivers on demand.
This is accomplished in ocfs2_cluster_connect().

ocfs2_cluster_disconnect() is now notified when a _hangup() is pending.
If a hangup is pending, it will not release the driver module and will
let _hangup() do that.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/Makefile     |    7 +-
 fs/ocfs2/dlmglue.c    |    7 +-
 fs/ocfs2/dlmglue.h    |    2 +-
 fs/ocfs2/stack_o2cb.c |   41 +++++++--
 fs/ocfs2/stackglue.c  |  238 ++++++++++++++++++++++++++++++++++++++++++++-----
 fs/ocfs2/stackglue.h  |   36 +++++++-
 fs/ocfs2/super.c      |   16 ++--
 7 files changed, 297 insertions(+), 50 deletions(-)

diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 8e86195..b734254 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -2,7 +2,7 @@ EXTRA_CFLAGS += -Ifs/ocfs2
 
 EXTRA_CFLAGS += -DCATCH_BH_JBD_RACES
 
-obj-$(CONFIG_OCFS2_FS) += ocfs2.o
+obj-$(CONFIG_OCFS2_FS) += ocfs2.o ocfs2_stackglue.o ocfs2_stack_o2cb.o
 
 ocfs2-objs := \
 	alloc.o 		\
@@ -24,8 +24,6 @@ ocfs2-objs := \
 	namei.o 		\
 	resize.o		\
 	slot_map.o 		\
-	stackglue.o		\
-	stack_o2cb.o		\
 	suballoc.o 		\
 	super.o 		\
 	symlink.o 		\
@@ -33,5 +31,8 @@ ocfs2-objs := \
 	uptodate.o		\
 	ver.o
 
+ocfs2_stackglue-objs := stackglue.o
+ocfs2_stack_o2cb-objs := stack_o2cb.o
+
 obj-$(CONFIG_OCFS2_FS) += cluster/
 obj-$(CONFIG_OCFS2_FS) += dlm/
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 8a9c849..f62a9e4 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2641,7 +2641,7 @@ int ocfs2_dlm_init(struct ocfs2_super *osb)
 		mlog_errno(status);
 		mlog(ML_ERROR,
 		     "could not find this host's node number\n");
-		ocfs2_cluster_disconnect(conn);
+		ocfs2_cluster_disconnect(conn, 0);
 		goto bail;
 	}
 
@@ -2663,7 +2663,8 @@ bail:
 	return status;
 }
 
-void ocfs2_dlm_shutdown(struct ocfs2_super *osb)
+void ocfs2_dlm_shutdown(struct ocfs2_super *osb,
+			int hangup_pending)
 {
 	mlog_entry_void();
 
@@ -2683,7 +2684,7 @@ void ocfs2_dlm_shutdown(struct ocfs2_super *osb)
 	ocfs2_lock_res_free(&osb->osb_super_lockres);
 	ocfs2_lock_res_free(&osb->osb_rename_lockres);
 
-	ocfs2_cluster_disconnect(osb->cconn);
+	ocfs2_cluster_disconnect(osb->cconn, hangup_pending);
 	osb->cconn = NULL;
 
 	ocfs2_dlm_shutdown_debug(osb);
diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
index 34b7598..2bb01f0 100644
--- a/fs/ocfs2/dlmglue.h
+++ b/fs/ocfs2/dlmglue.h
@@ -58,7 +58,7 @@ struct ocfs2_meta_lvb {
 #define OCFS2_LOCK_NONBLOCK		(0x04)
 
 int ocfs2_dlm_init(struct ocfs2_super *osb);
-void ocfs2_dlm_shutdown(struct ocfs2_super *osb);
+void ocfs2_dlm_shutdown(struct ocfs2_super *osb, int hangup_pending);
 void ocfs2_lock_res_init_once(struct ocfs2_lock_res *res);
 void ocfs2_inode_lock_res_init(struct ocfs2_lock_res *res,
 			       enum ocfs2_lock_type type,
diff --git a/fs/ocfs2/stack_o2cb.c b/fs/ocfs2/stack_o2cb.c
index c9bc354..ac1d74c 100644
--- a/fs/ocfs2/stack_o2cb.c
+++ b/fs/ocfs2/stack_o2cb.c
@@ -18,7 +18,7 @@
  */
 
 #include <linux/crc32.h>
-#include <linux/kmod.h>
+#include <linux/module.h>
 
 /* Needed for AOP_TRUNCATED_PAGE in mlog_errno() */
 #include <linux/fs.h>
@@ -33,6 +33,8 @@ struct o2dlm_private {
 	struct dlm_eviction_cb op_eviction_cb;
 };
 
+static struct ocfs2_stack_plugin o2cb_stack;
+
 /* These should be identical */
 #if (DLM_LOCK_IV != LKM_IVMODE)
 # error Lock modes do not match
@@ -158,23 +160,23 @@ static int dlm_status_to_errno(enum dlm_status status)
 
 static void o2dlm_lock_ast_wrapper(void *astarg)
 {
-	BUG_ON(stack_glue_lproto == NULL);
+	BUG_ON(o2cb_stack.sp_proto == NULL);
 
-	stack_glue_lproto->lp_lock_ast(astarg);
+	o2cb_stack.sp_proto->lp_lock_ast(astarg);
 }
 
 static void o2dlm_blocking_ast_wrapper(void *astarg, int level)
 {
-	BUG_ON(stack_glue_lproto == NULL);
+	BUG_ON(o2cb_stack.sp_proto == NULL);
 
-	stack_glue_lproto->lp_blocking_ast(astarg, level);
+	o2cb_stack.sp_proto->lp_blocking_ast(astarg, level);
 }
 
 static void o2dlm_unlock_ast_wrapper(void *astarg, enum dlm_status status)
 {
 	int error = dlm_status_to_errno(status);
 
-	BUG_ON(stack_glue_lproto == NULL);
+	BUG_ON(o2cb_stack.sp_proto == NULL);
 
 	/*
 	 * In o2dlm, you can get both the lock_ast() for the lock being
@@ -190,7 +192,7 @@ static void o2dlm_unlock_ast_wrapper(void *astarg, enum dlm_status status)
 	if (status == DLM_CANCELGRANT)
 		return;
 
-	stack_glue_lproto->lp_unlock_ast(astarg, error);
+	o2cb_stack.sp_proto->lp_unlock_ast(astarg, error);
 }
 
 static int o2cb_dlm_lock(struct ocfs2_cluster_connection *conn,
@@ -267,6 +269,7 @@ static int o2cb_cluster_connect(struct ocfs2_cluster_connection *conn)
 	struct dlm_protocol_version dlm_version;
 
 	BUG_ON(conn == NULL);
+	BUG_ON(o2cb_stack.sp_proto == NULL);
 
 	/* for now we only have one cluster/node, make sure we see it
 	 * in the heartbeat universe */
@@ -314,7 +317,8 @@ out:
 	return rc;
 }
 
-static int o2cb_cluster_disconnect(struct ocfs2_cluster_connection *conn)
+static int o2cb_cluster_disconnect(struct ocfs2_cluster_connection *conn,
+				   int hangup_pending)
 {
 	struct dlm_ctxt *dlm = conn->cc_lockspace;
 	struct o2dlm_private *priv = conn->cc_private;
@@ -393,3 +397,24 @@ struct ocfs2_stack_operations o2cb_stack_ops = {
 	.dump_lksb	= o2cb_dump_lksb,
 };
 
+static struct ocfs2_stack_plugin o2cb_stack = {
+	.sp_name	= "o2cb",
+	.sp_ops		= &o2cb_stack_ops,
+	.sp_owner	= THIS_MODULE,
+};
+
+static int __init o2cb_stack_init(void)
+{
+	return ocfs2_stack_glue_register(&o2cb_stack);
+}
+
+static void __exit o2cb_stack_exit(void)
+{
+	ocfs2_stack_glue_unregister(&o2cb_stack);
+}
+
+MODULE_AUTHOR("Oracle");
+MODULE_DESCRIPTION("ocfs2 driver for the classic o2cb stack");
+MODULE_LICENSE("GPL");
+module_init(o2cb_stack_init);
+module_exit(o2cb_stack_exit);
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index e197367..1978c9c 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -18,17 +18,176 @@
  * General Public License for more details.
  */
 
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/kmod.h>
 
-/* Needed for AOP_TRUNCATED_PAGE in mlog_errno() */
-#include <linux/fs.h>
+#include "stackglue.h"
 
-#include "cluster/masklog.h"
+static struct ocfs2_locking_protocol *lproto;
+static DEFINE_SPINLOCK(ocfs2_stack_lock);
+static LIST_HEAD(ocfs2_stack_list);
 
-#include "stackglue.h"
+/*
+ * The stack currently in use.  If not null, active_stack->sp_count > 0,
+ * the module is pinned, and the locking protocol cannot be changed.
+ */
+static struct ocfs2_stack_plugin *active_stack;
+
+static struct ocfs2_stack_plugin *ocfs2_stack_lookup(const char *name)
+{
+	struct ocfs2_stack_plugin *p;
+
+	assert_spin_locked(&ocfs2_stack_lock);
+
+	list_for_each_entry(p, &ocfs2_stack_list, sp_list) {
+		if (!strcmp(p->sp_name, name))
+			return p;
+	}
+
+	return NULL;
+}
+
+static int ocfs2_stack_driver_request(const char *name)
+{
+	int rc;
+	struct ocfs2_stack_plugin *p;
+
+	spin_lock(&ocfs2_stack_lock);
+
+	if (active_stack) {
+		/*
+		 * If the active stack isn't the one we want, it cannot
+		 * be selected right now.
+		 */
+		if (!strcmp(active_stack->sp_name, name))
+			rc = 0;
+		else
+			rc = -EBUSY;
+		goto out;
+	}
+
+	p = ocfs2_stack_lookup(name);
+	if (!p || !try_module_get(p->sp_owner)) {
+		rc = -ENOENT;
+		goto out;
+	}
+
+	/* Ok, the stack is pinned */
+	p->sp_count++;
+	active_stack = p;
+
+	rc = 0;
+
+out:
+	spin_unlock(&ocfs2_stack_lock);
+	return rc;
+}
+
+/*
+ * This function looks up the appropriate stack and makes it active.  If
+ * there is no stack, it tries to load it.  It will fail if the stack still
+ * cannot be found.  It will also fail if a different stack is in use.
+ */
+static int ocfs2_stack_driver_get(const char *name)
+{
+	int rc;
+
+	rc = ocfs2_stack_driver_request(name);
+	if (rc == -ENOENT) {
+		request_module("ocfs2_stack_%s", name);
+		rc = ocfs2_stack_driver_request(name);
+	}
+
+	if (rc == -ENOENT) {
+		printk(KERN_ERR
+		       "ocfs2: Cluster stack driver \"%s\" cannot be found\n",
+		       name);
+	} else if (rc == -EBUSY) {
+		printk(KERN_ERR
+		       "ocfs2: A different cluster stack driver is in use\n");
+	}
+
+	return rc;
+}
 
-struct ocfs2_locking_protocol *stack_glue_lproto;
+static void ocfs2_stack_driver_put(void)
+{
+	spin_lock(&ocfs2_stack_lock);
+	BUG_ON(active_stack == NULL);
+	BUG_ON(active_stack->sp_count == 0);
+
+	active_stack->sp_count--;
+	if (!active_stack->sp_count) {
+		module_put(active_stack->sp_owner);
+		active_stack = NULL;
+	}
+	spin_unlock(&ocfs2_stack_lock);
+}
+
+int ocfs2_stack_glue_register(struct ocfs2_stack_plugin *plugin)
+{
+	int rc;
+
+	spin_lock(&ocfs2_stack_lock);
+	if (!ocfs2_stack_lookup(plugin->sp_name)) {
+		plugin->sp_count = 0;
+		plugin->sp_proto = lproto;
+		list_add(&plugin->sp_list, &ocfs2_stack_list);
+		printk(KERN_INFO "ocfs2: Registered cluster interface %s\n",
+		       plugin->sp_name);
+		rc = 0;
+	} else {
+		printk(KERN_ERR "ocfs2: Stack \"%s\" already registered\n",
+		       plugin->sp_name);
+		rc = -EEXIST;
+	}
+	spin_unlock(&ocfs2_stack_lock);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(ocfs2_stack_glue_register);
+
+void ocfs2_stack_glue_unregister(struct ocfs2_stack_plugin *plugin)
+{
+	struct ocfs2_stack_plugin *p;
+
+	spin_lock(&ocfs2_stack_lock);
+	p = ocfs2_stack_lookup(plugin->sp_name);
+	if (p) {
+		BUG_ON(p != plugin);
+		BUG_ON(plugin == active_stack);
+		BUG_ON(plugin->sp_count != 0);
+		list_del_init(&plugin->sp_list);
+		printk(KERN_INFO "ocfs2: Unregistered cluster interface %s\n",
+		       plugin->sp_name);
+	} else {
+		printk(KERN_ERR "Stack \"%s\" is not registered\n",
+		       plugin->sp_name);
+	}
+	spin_unlock(&ocfs2_stack_lock);
+}
+EXPORT_SYMBOL_GPL(ocfs2_stack_glue_unregister);
+
+void ocfs2_stack_glue_set_locking_protocol(struct ocfs2_locking_protocol *proto)
+{
+	struct ocfs2_stack_plugin *p;
+
+	BUG_ON(proto == NULL);
+
+	spin_lock(&ocfs2_stack_lock);
+	BUG_ON(active_stack != NULL);
+
+	lproto = proto;
+	list_for_each_entry(p, &ocfs2_stack_list, sp_list) {
+		p->sp_proto = lproto;
+	}
+
+	spin_unlock(&ocfs2_stack_lock);
+}
+EXPORT_SYMBOL_GPL(ocfs2_stack_glue_set_locking_protocol);
 
 
 int ocfs2_dlm_lock(struct ocfs2_cluster_connection *conn,
@@ -39,26 +198,29 @@ int ocfs2_dlm_lock(struct ocfs2_cluster_connection *conn,
 		   unsigned int namelen,
 		   void *astarg)
 {
-	BUG_ON(stack_glue_lproto == NULL);
+	BUG_ON(lproto == NULL);
 
-	return o2cb_stack_ops.dlm_lock(conn, mode, lksb, flags,
-				       name, namelen, astarg);
+	return active_stack->sp_ops->dlm_lock(conn, mode, lksb, flags,
+					      name, namelen, astarg);
 }
+EXPORT_SYMBOL_GPL(ocfs2_dlm_lock);
 
 int ocfs2_dlm_unlock(struct ocfs2_cluster_connection *conn,
 		     union ocfs2_dlm_lksb *lksb,
 		     u32 flags,
 		     void *astarg)
 {
-	BUG_ON(stack_glue_lproto == NULL);
+	BUG_ON(lproto == NULL);
 
-	return o2cb_stack_ops.dlm_unlock(conn, lksb, flags, astarg);
+	return active_stack->sp_ops->dlm_unlock(conn, lksb, flags, astarg);
 }
+EXPORT_SYMBOL_GPL(ocfs2_dlm_unlock);
 
 int ocfs2_dlm_lock_status(union ocfs2_dlm_lksb *lksb)
 {
-	return o2cb_stack_ops.lock_status(lksb);
+	return active_stack->sp_ops->lock_status(lksb);
 }
+EXPORT_SYMBOL_GPL(ocfs2_dlm_lock_status);
 
 /*
  * Why don't we cast to ocfs2_meta_lvb?  The "clean" answer is that we
@@ -67,13 +229,15 @@ int ocfs2_dlm_lock_status(union ocfs2_dlm_lksb *lksb)
  */
 void *ocfs2_dlm_lvb(union ocfs2_dlm_lksb *lksb)
 {
-	return o2cb_stack_ops.lock_lvb(lksb);
+	return active_stack->sp_ops->lock_lvb(lksb);
 }
+EXPORT_SYMBOL_GPL(ocfs2_dlm_lvb);
 
 void ocfs2_dlm_dump_lksb(union ocfs2_dlm_lksb *lksb)
 {
-	o2cb_stack_ops.dump_lksb(lksb);
+	active_stack->sp_ops->dump_lksb(lksb);
 }
+EXPORT_SYMBOL_GPL(ocfs2_dlm_dump_lksb);
 
 int ocfs2_cluster_connect(const char *group,
 			  int grouplen,
@@ -107,11 +271,16 @@ int ocfs2_cluster_connect(const char *group,
 	new_conn->cc_recovery_data = recovery_data;
 
 	/* Start the new connection at our maximum compatibility level */
-	new_conn->cc_version = stack_glue_lproto->lp_max_version;
+	new_conn->cc_version = lproto->lp_max_version;
+
+	/* This will pin the stack driver if successful */
+	rc = ocfs2_stack_driver_get("o2cb");
+	if (rc)
+		goto out_free;
 
-	rc = o2cb_stack_ops.connect(new_conn);
+	rc = active_stack->sp_ops->connect(new_conn);
 	if (rc) {
-		mlog_errno(rc);
+		ocfs2_stack_driver_put();
 		goto out_free;
 	}
 
@@ -124,39 +293,60 @@ out_free:
 out:
 	return rc;
 }
+EXPORT_SYMBOL_GPL(ocfs2_cluster_connect);
 
-int ocfs2_cluster_disconnect(struct ocfs2_cluster_connection *conn)
+/* If hangup_pending is 0, the stack driver will be dropped */
+int ocfs2_cluster_disconnect(struct ocfs2_cluster_connection *conn,
+			     int hangup_pending)
 {
 	int ret;
 
 	BUG_ON(conn == NULL);
 
-	ret = o2cb_stack_ops.disconnect(conn);
+	ret = active_stack->sp_ops->disconnect(conn, hangup_pending);
 
 	/* XXX Should we free it anyway? */
-	if (!ret)
+	if (!ret) {
 		kfree(conn);
+		if (!hangup_pending)
+			ocfs2_stack_driver_put();
+	}
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(ocfs2_cluster_disconnect);
 
 void ocfs2_cluster_hangup(const char *group, int grouplen)
 {
 	BUG_ON(group == NULL);
 	BUG_ON(group[grouplen] != '\0');
 
-	o2cb_stack_ops.hangup(group, grouplen);
+	active_stack->sp_ops->hangup(group, grouplen);
+
+	/* cluster_disconnect() was called with hangup_pending==1 */
+	ocfs2_stack_driver_put();
 }
+EXPORT_SYMBOL_GPL(ocfs2_cluster_hangup);
 
 int ocfs2_cluster_this_node(unsigned int *node)
 {
-	return o2cb_stack_ops.this_node(node);
+	return active_stack->sp_ops->this_node(node);
 }
+EXPORT_SYMBOL_GPL(ocfs2_cluster_this_node);
 
-void ocfs2_stack_glue_set_locking_protocol(struct ocfs2_locking_protocol *proto)
+
+static int __init ocfs2_stack_glue_init(void)
 {
-	BUG_ON(proto != NULL);
+	return 0;
+}
 
-	stack_glue_lproto = proto;
+static void __exit ocfs2_stack_glue_exit(void)
+{
+	lproto = NULL;
 }
 
+MODULE_AUTHOR("Oracle");
+MODULE_DESCRIPTION("ocfs2 cluter stack glue layer");
+MODULE_LICENSE("GPL");
+module_init(ocfs2_stack_glue_init);
+module_exit(ocfs2_stack_glue_exit);
diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
index 0836322..c96c8bb 100644
--- a/fs/ocfs2/stackglue.h
+++ b/fs/ocfs2/stackglue.h
@@ -119,14 +119,21 @@ struct ocfs2_stack_operations {
 	 * Once ->disconnect() has returned, the connection structure will
 	 * be freed.  Thus, a stack must not return from ->disconnect()
 	 * until it will no longer reference the conn pointer.
+	 *
+	 * If hangup_pending is zero, ocfs2_cluster_disconnect() will also
+	 * be dropping the reference on the module.
 	 */
-	int (*disconnect)(struct ocfs2_cluster_connection *conn);
+	int (*disconnect)(struct ocfs2_cluster_connection *conn,
+			  int hangup_pending);
 
 	/*
 	 * ocfs2_cluster_hangup() exists for compatibility with older
 	 * ocfs2 tools.  Only the classic stack really needs it.  As such
 	 * ->hangup() is not required of all stacks.  See the comment by
 	 * ocfs2_cluster_hangup() for more details.
+	 *
+	 * Note that ocfs2_cluster_hangup() can only be called if
+	 * hangup_pending was passed to ocfs2_cluster_disconnect().
 	 */
 	void (*hangup)(const char *group, int grouplen);
 
@@ -184,13 +191,32 @@ struct ocfs2_stack_operations {
 	void (*dump_lksb)(union ocfs2_dlm_lksb *lksb);
 };
 
+/*
+ * Each stack plugin must describe itself by registering a
+ * ocfs2_stack_plugin structure.  This is only seen by stackglue and the
+ * stack driver.
+ */
+struct ocfs2_stack_plugin {
+	char *sp_name;
+	struct ocfs2_stack_operations *sp_ops;
+	struct module *sp_owner;
+
+	/* These are managed by the stackglue code. */
+	struct list_head sp_list;
+	unsigned int sp_count;
+	struct ocfs2_locking_protocol *sp_proto;
+};
+
+
+/* Used by the filesystem */
 int ocfs2_cluster_connect(const char *group,
 			  int grouplen,
 			  void (*recovery_handler)(int node_num,
 						   void *recovery_data),
 			  void *recovery_data,
 			  struct ocfs2_cluster_connection **conn);
-int ocfs2_cluster_disconnect(struct ocfs2_cluster_connection *conn);
+int ocfs2_cluster_disconnect(struct ocfs2_cluster_connection *conn,
+			     int hangup_pending);
 void ocfs2_cluster_hangup(const char *group, int grouplen);
 int ocfs2_cluster_this_node(unsigned int *node);
 
@@ -212,6 +238,8 @@ void ocfs2_dlm_dump_lksb(union ocfs2_dlm_lksb *lksb);
 
 void ocfs2_stack_glue_set_locking_protocol(struct ocfs2_locking_protocol *proto);
 
-extern struct ocfs2_locking_protocol *stack_glue_lproto;
-extern struct ocfs2_stack_operations o2cb_stack_ops;
+
+/* Used by stack plugins */
+int ocfs2_stack_glue_register(struct ocfs2_stack_plugin *plugin);
+void ocfs2_stack_glue_unregister(struct ocfs2_stack_plugin *plugin);
 #endif  /* STACKGLUE_H */
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index b4a02a0..e27a0d4 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1186,7 +1186,7 @@ leave:
 
 static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 {
-	int tmp;
+	int tmp, hangup_needed = 0;
 	struct ocfs2_super *osb = NULL;
 	char nodestr[8];
 
@@ -1225,19 +1225,21 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 
 	ocfs2_release_system_inodes(osb);
 
-	if (osb->cconn)
-		ocfs2_dlm_shutdown(osb);
-
-	debugfs_remove(osb->osb_debug_root);
-
 	/*
-	 * This is a small hack to move ocfs2_hb_ctl into stackglue.
 	 * If we're dismounting due to mount error, mount.ocfs2 will clean
 	 * up heartbeat.  If we're a local mount, there is no heartbeat.
 	 * If we failed before we got a uuid_str yet, we can't stop
 	 * heartbeat.  Otherwise, do it.
 	 */
 	if (!mnt_err && !ocfs2_mount_local(osb) && osb->uuid_str)
+		hangup_needed = 1;
+
+	if (osb->cconn)
+		ocfs2_dlm_shutdown(osb, hangup_needed);
+
+	debugfs_remove(osb->osb_debug_root);
+
+	if (hangup_needed)
 		ocfs2_cluster_hangup(osb->uuid_str, strlen(osb->uuid_str));
 
 	atomic_set(&osb->vol_state, VOLUME_DISMOUNTED);
-- 
1.5.4.1
