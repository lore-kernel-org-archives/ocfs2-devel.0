From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 16 Jun 2008 13:12:46 -0700
Subject: [Ocfs2-devel] [git patches] Ocfs2 fixes
Message-ID: <20080616201246.GB28100@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Andrew Morton <akpm@linux-foundation.org>

This reverts a portion of the 'user-stack' unmount behavior back to how we
have traditionally handled unmount notification - via usermode callout to a
small helper application. Well, 'revert' is probably the wrong term. The
user-stack code explicitly never called the helper because we incorrectly
thought that an umount.ocfs2 might be able to do the work of tracking
final-unmount. As it turns out, that's not really possible (bind-mounts in
particular made this difficult) so we're going to go with the tried-and-true
umount handling for all Ocfs2 cluster stacks.


Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/ocfs2/cluster/nodemanager.c |   74 +------------------------
 fs/ocfs2/cluster/nodemanager.h |    4 -
 fs/ocfs2/stack_o2cb.c          |   41 +-------------
 fs/ocfs2/stack_user.c          |    3 +-
 fs/ocfs2/stackglue.c           |  119 +++++++++++++++++++++++++++++++++++++++-
 fs/ocfs2/stackglue.h           |   19 +-----
 6 files changed, 123 insertions(+), 137 deletions(-)

Joel Becker (3):
      ocfs2: Move the hb_ctl_path sysctl into the stack glue.
      ocfs2: Move the call of ocfs2_hb_ctl into the stack glue.
      ocfs2: Remove ->hangup() from stack glue operations.

diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
index cf9401e..cfdb08b 100644
--- a/fs/ocfs2/cluster/nodemanager.c
+++ b/fs/ocfs2/cluster/nodemanager.c
@@ -21,7 +21,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/sysctl.h>
 #include <linux/configfs.h>
 
 #include "tcp.h"
@@ -36,65 +35,6 @@
  * cluster references throughout where nodes are looked up */
 struct o2nm_cluster *o2nm_single_cluster = NULL;
 
-#define OCFS2_MAX_HB_CTL_PATH 256
-static char ocfs2_hb_ctl_path[OCFS2_MAX_HB_CTL_PATH] = "/sbin/ocfs2_hb_ctl";
-
-static ctl_table ocfs2_nm_table[] = {
-	{
-		.ctl_name	= 1,
-		.procname	= "hb_ctl_path",
-		.data		= ocfs2_hb_ctl_path,
-		.maxlen		= OCFS2_MAX_HB_CTL_PATH,
-		.mode		= 0644,
-		.proc_handler	= &proc_dostring,
-		.strategy	= &sysctl_string,
-	},
-	{ .ctl_name = 0 }
-};
-
-static ctl_table ocfs2_mod_table[] = {
-	{
-		.ctl_name	= FS_OCFS2_NM,
-		.procname	= "nm",
-		.data		= NULL,
-		.maxlen		= 0,
-		.mode		= 0555,
-		.child		= ocfs2_nm_table
-	},
-	{ .ctl_name = 0}
-};
-
-static ctl_table ocfs2_kern_table[] = {
-	{
-		.ctl_name	= FS_OCFS2,
-		.procname	= "ocfs2",
-		.data		= NULL,
-		.maxlen		= 0,
-		.mode		= 0555,
-		.child		= ocfs2_mod_table
-	},
-	{ .ctl_name = 0}
-};
-
-static ctl_table ocfs2_root_table[] = {
-	{
-		.ctl_name	= CTL_FS,
-		.procname	= "fs",
-		.data		= NULL,
-		.maxlen		= 0,
-		.mode		= 0555,
-		.child		= ocfs2_kern_table
-	},
-	{ .ctl_name = 0 }
-};
-
-static struct ctl_table_header *ocfs2_table_header = NULL;
-
-const char *o2nm_get_hb_ctl_path(void)
-{
-	return ocfs2_hb_ctl_path;
-}
-EXPORT_SYMBOL_GPL(o2nm_get_hb_ctl_path);
 
 struct o2nm_node *o2nm_get_node_by_num(u8 node_num)
 {
@@ -941,9 +881,6 @@ void o2nm_undepend_this_node(void)
 
 static void __exit exit_o2nm(void)
 {
-	if (ocfs2_table_header)
-		unregister_sysctl_table(ocfs2_table_header);
-
 	/* XXX sync with hb callbacks and shut down hb? */
 	o2net_unregister_hb_callbacks();
 	configfs_unregister_subsystem(&o2nm_cluster_group.cs_subsys);
@@ -964,16 +901,9 @@ static int __init init_o2nm(void)
 	if (ret)
 		goto out;
 
-	ocfs2_table_header = register_sysctl_table(ocfs2_root_table);
-	if (!ocfs2_table_header) {
-		printk(KERN_ERR "nodemanager: unable to register sysctl\n");
-		ret = -ENOMEM; /* or something. */
-		goto out_o2net;
-	}
-
 	ret = o2net_register_hb_callbacks();
 	if (ret)
-		goto out_sysctl;
+		goto out_o2net;
 
 	config_group_init(&o2nm_cluster_group.cs_subsys.su_group);
 	mutex_init(&o2nm_cluster_group.cs_subsys.su_mutex);
@@ -990,8 +920,6 @@ static int __init init_o2nm(void)
 	configfs_unregister_subsystem(&o2nm_cluster_group.cs_subsys);
 out_callbacks:
 	o2net_unregister_hb_callbacks();
-out_sysctl:
-	unregister_sysctl_table(ocfs2_table_header);
 out_o2net:
 	o2net_exit();
 out:
diff --git a/fs/ocfs2/cluster/nodemanager.h b/fs/ocfs2/cluster/nodemanager.h
index 7c86036..c992ea0 100644
--- a/fs/ocfs2/cluster/nodemanager.h
+++ b/fs/ocfs2/cluster/nodemanager.h
@@ -33,10 +33,6 @@
 #include <linux/configfs.h>
 #include <linux/rbtree.h>
 
-#define FS_OCFS2_NM		1
-
-const char *o2nm_get_hb_ctl_path(void);
-
 struct o2nm_node {
 	spinlock_t		nd_lock;
 	struct config_item	nd_item;
diff --git a/fs/ocfs2/stack_o2cb.c b/fs/ocfs2/stack_o2cb.c
index bbd1667..fcd120f 100644
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
@@ -333,43 +332,6 @@ static int o2cb_cluster_disconnect(struct ocfs2_cluster_connection *conn,
 	return 0;
 }
 
-static void o2hb_stop(const char *group)
-{
-	int ret;
-	char *argv[5], *envp[3];
-
-	argv[0] = (char *)o2nm_get_hb_ctl_path();
-	argv[1] = "-K";
-	argv[2] = "-u";
-	argv[3] = (char *)group;
-	argv[4] = NULL;
-
-	mlog(0, "Run: %s %s %s %s\n", argv[0], argv[1], argv[2], argv[3]);
-
-	/* minimal command environment taken from cpu_run_sbin_hotplug */
-	envp[0] = "HOME=/";
-	envp[1] = "PATH=/sbin:/bin:/usr/sbin:/usr/bin";
-	envp[2] = NULL;
-
-	ret = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_PROC);
-	if (ret < 0)
-		mlog_errno(ret);
-}
-
-/*
- * Hangup is a hack for tools compatibility.  Older ocfs2-tools software
- * expects the filesystem to call "ocfs2_hb_ctl" during unmount.  This
- * happens regardless of whether the DLM got started, so we can't do it
- * in ocfs2_cluster_disconnect().  We bring the o2hb_stop() function into
- * the glue and provide a "hangup" API for super.c to call.
- *
- * Other stacks will eventually provide a NULL ->hangup() pointer.
- */
-static void o2cb_cluster_hangup(const char *group, int grouplen)
-{
-	o2hb_stop(group);
-}
-
 static int o2cb_cluster_this_node(unsigned int *node)
 {
 	int node_num;
@@ -388,7 +350,6 @@ static int o2cb_cluster_this_node(unsigned int *node)
 static struct ocfs2_stack_operations o2cb_stack_ops = {
 	.connect	= o2cb_cluster_connect,
 	.disconnect	= o2cb_cluster_disconnect,
-	.hangup		= o2cb_cluster_hangup,
 	.this_node	= o2cb_cluster_this_node,
 	.dlm_lock	= o2cb_dlm_lock,
 	.dlm_unlock	= o2cb_dlm_unlock,
diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index 6b97d11..c021280 100644
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
index 119f60c..10e149a 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -26,6 +26,7 @@
 #include <linux/fs.h>
 #include <linux/kobject.h>
 #include <linux/sysfs.h>
+#include <linux/sysctl.h>
 
 #include "ocfs2_fs.h"
 
@@ -33,11 +34,13 @@
 
 #define OCFS2_STACK_PLUGIN_O2CB		"o2cb"
 #define OCFS2_STACK_PLUGIN_USER		"user"
+#define OCFS2_MAX_HB_CTL_PATH		256
 
 static struct ocfs2_locking_protocol *lproto;
 static DEFINE_SPINLOCK(ocfs2_stack_lock);
 static LIST_HEAD(ocfs2_stack_list);
 static char cluster_stack_name[OCFS2_STACK_LABEL_LEN + 1];
+static char ocfs2_hb_ctl_path[OCFS2_MAX_HB_CTL_PATH] = "/sbin/ocfs2_hb_ctl";
 
 /*
  * The stack currently in use.  If not null, active_stack->sp_count > 0,
@@ -349,7 +352,7 @@ int ocfs2_cluster_disconnect(struct ocfs2_cluster_connection *conn,
 
 	BUG_ON(conn == NULL);
 
-	ret = active_stack->sp_ops->disconnect(conn, hangup_pending);
+	ret = active_stack->sp_ops->disconnect(conn);
 
 	/* XXX Should we free it anyway? */
 	if (!ret) {
@@ -362,13 +365,48 @@ int ocfs2_cluster_disconnect(struct ocfs2_cluster_connection *conn,
 }
 EXPORT_SYMBOL_GPL(ocfs2_cluster_disconnect);
 
+/*
+ * Leave the group for this filesystem.  This is executed by a userspace
+ * program (stored in ocfs2_hb_ctl_path).
+ */
+static void ocfs2_leave_group(const char *group)
+{
+	int ret;
+	char *argv[5], *envp[3];
+
+	argv[0] = ocfs2_hb_ctl_path;
+	argv[1] = "-K";
+	argv[2] = "-u";
+	argv[3] = (char *)group;
+	argv[4] = NULL;
+
+	/* minimal command environment taken from cpu_run_sbin_hotplug */
+	envp[0] = "HOME=/";
+	envp[1] = "PATH=/sbin:/bin:/usr/sbin:/usr/bin";
+	envp[2] = NULL;
+
+	ret = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_PROC);
+	if (ret < 0) {
+		printk(KERN_ERR
+		       "ocfs2: Error %d running user helper "
+		       "\"%s %s %s %s\"\n",
+		       ret, argv[0], argv[1], argv[2], argv[3]);
+	}
+}
+
+/*
+ * Hangup is a required post-umount.  ocfs2-tools software expects the
+ * filesystem to call "ocfs2_hb_ctl" during unmount.  This happens
+ * regardless of whether the DLM got started, so we can't do it
+ * in ocfs2_cluster_disconnect().  The ocfs2_leave_group() function does
+ * the actual work.
+ */
 void ocfs2_cluster_hangup(const char *group, int grouplen)
 {
 	BUG_ON(group == NULL);
 	BUG_ON(group[grouplen] != '\0');
 
-	if (active_stack->sp_ops->hangup)
-		active_stack->sp_ops->hangup(group, grouplen);
+	ocfs2_leave_group(group);
 
 	/* cluster_disconnect() was called with hangup_pending==1 */
 	ocfs2_stack_driver_put();
@@ -548,10 +586,83 @@ error:
 	return ret;
 }
 
+/*
+ * Sysctl bits
+ *
+ * The sysctl lives at /proc/sys/fs/ocfs2/nm/hb_ctl_path.  The 'nm' doesn't
+ * make as much sense in a multiple cluster stack world, but it's safer
+ * and easier to preserve the name.
+ */
+
+#define FS_OCFS2_NM		1
+
+static ctl_table ocfs2_nm_table[] = {
+	{
+		.ctl_name	= 1,
+		.procname	= "hb_ctl_path",
+		.data		= ocfs2_hb_ctl_path,
+		.maxlen		= OCFS2_MAX_HB_CTL_PATH,
+		.mode		= 0644,
+		.proc_handler	= &proc_dostring,
+		.strategy	= &sysctl_string,
+	},
+	{ .ctl_name = 0 }
+};
+
+static ctl_table ocfs2_mod_table[] = {
+	{
+		.ctl_name	= FS_OCFS2_NM,
+		.procname	= "nm",
+		.data		= NULL,
+		.maxlen		= 0,
+		.mode		= 0555,
+		.child		= ocfs2_nm_table
+	},
+	{ .ctl_name = 0}
+};
+
+static ctl_table ocfs2_kern_table[] = {
+	{
+		.ctl_name	= FS_OCFS2,
+		.procname	= "ocfs2",
+		.data		= NULL,
+		.maxlen		= 0,
+		.mode		= 0555,
+		.child		= ocfs2_mod_table
+	},
+	{ .ctl_name = 0}
+};
+
+static ctl_table ocfs2_root_table[] = {
+	{
+		.ctl_name	= CTL_FS,
+		.procname	= "fs",
+		.data		= NULL,
+		.maxlen		= 0,
+		.mode		= 0555,
+		.child		= ocfs2_kern_table
+	},
+	{ .ctl_name = 0 }
+};
+
+static struct ctl_table_header *ocfs2_table_header = NULL;
+
+
+/*
+ * Initialization
+ */
+
 static int __init ocfs2_stack_glue_init(void)
 {
 	strcpy(cluster_stack_name, OCFS2_STACK_PLUGIN_O2CB);
 
+	ocfs2_table_header = register_sysctl_table(ocfs2_root_table);
+	if (!ocfs2_table_header) {
+		printk(KERN_ERR
+		       "ocfs2 stack glue: unable to register sysctl\n");
+		return -ENOMEM; /* or something. */
+	}
+
 	return ocfs2_sysfs_init();
 }
 
@@ -559,6 +670,8 @@ static void __exit ocfs2_stack_glue_exit(void)
 {
 	lproto = NULL;
 	ocfs2_sysfs_exit();
+	if (ocfs2_table_header)
+		unregister_sysctl_table(ocfs2_table_header);
 }
 
 MODULE_AUTHOR("Oracle");
diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
index 005e4f1..db56281 100644
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
@@ -258,4 +246,5 @@ void ocfs2_stack_glue_set_locking_protocol(struct ocfs2_locking_protocol *proto)
 /* Used by stack plugins */
 int ocfs2_stack_glue_register(struct ocfs2_stack_plugin *plugin);
 void ocfs2_stack_glue_unregister(struct ocfs2_stack_plugin *plugin);
+
 #endif  /* STACKGLUE_H */
