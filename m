From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 30 May 2008 17:36:43 -0700
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: Move the call of ocfs2_hb_ctl into
	the stack glue.
In-Reply-To: <1212194204-3906-1-git-send-email-joel.becker@oracle.com>
References: <1212194204-3906-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1212194204-3906-3-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Take o2hb_stop() out of the o2cb code and make it part of the generic
stack glue as ocfs2_leave_group().  This also allows us to remove the
ocfs2_get_hb_ctl_path() function - everything to do with hb_ctl is now
part of stackglue.c.  o2cb no longer needs a ->hangup() function.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/stack_o2cb.c |   38 --------------------------------------
 fs/ocfs2/stackglue.c  |   49 ++++++++++++++++++++++++++++++++++++++++---------
 fs/ocfs2/stackglue.h  |    1 -
 3 files changed, 40 insertions(+), 48 deletions(-)

diff --git a/fs/ocfs2/stack_o2cb.c b/fs/ocfs2/stack_o2cb.c
index fb26a7c..765ade5 100644
--- a/fs/ocfs2/stack_o2cb.c
+++ b/fs/ocfs2/stack_o2cb.c
@@ -333,43 +333,6 @@ static int o2cb_cluster_disconnect(struct ocfs2_cluster_connection *conn,
 	return 0;
 }
 
-static void o2hb_stop(const char *group)
-{
-	int ret;
-	char *argv[5], *envp[3];
-
-	argv[0] = (char *)ocfs2_get_hb_ctl_path();
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
@@ -388,7 +351,6 @@ static int o2cb_cluster_this_node(unsigned int *node)
 static struct ocfs2_stack_operations o2cb_stack_ops = {
 	.connect	= o2cb_cluster_connect,
 	.disconnect	= o2cb_cluster_disconnect,
-	.hangup		= o2cb_cluster_hangup,
 	.this_node	= o2cb_cluster_this_node,
 	.dlm_lock	= o2cb_dlm_lock,
 	.dlm_unlock	= o2cb_dlm_unlock,
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index fb9b8e0..5f78ff4 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -34,11 +34,13 @@
 
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
@@ -363,6 +365,42 @@ int ocfs2_cluster_disconnect(struct ocfs2_cluster_connection *conn,
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
@@ -371,6 +409,8 @@ void ocfs2_cluster_hangup(const char *group, int grouplen)
 	if (active_stack->sp_ops->hangup)
 		active_stack->sp_ops->hangup(group, grouplen);
 
+	ocfs2_leave_group(group);
+
 	/* cluster_disconnect() was called with hangup_pending==1 */
 	ocfs2_stack_driver_put();
 }
@@ -559,9 +599,6 @@ error:
 
 #define FS_OCFS2_NM		1
 
-#define OCFS2_MAX_HB_CTL_PATH 256
-static char ocfs2_hb_ctl_path[OCFS2_MAX_HB_CTL_PATH] = "/sbin/ocfs2_hb_ctl";
-
 static ctl_table ocfs2_nm_table[] = {
 	{
 		.ctl_name	= 1,
@@ -613,12 +650,6 @@ static ctl_table ocfs2_root_table[] = {
 
 static struct ctl_table_header *ocfs2_table_header = NULL;
 
-const char *ocfs2_get_hb_ctl_path(void)
-{
-	return ocfs2_hb_ctl_path;
-}
-EXPORT_SYMBOL_GPL(ocfs2_get_hb_ctl_path);
-
 
 /*
  * Initialization
diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
index c9fb01a..fe3fd2a 100644
--- a/fs/ocfs2/stackglue.h
+++ b/fs/ocfs2/stackglue.h
@@ -258,6 +258,5 @@ void ocfs2_stack_glue_set_locking_protocol(struct ocfs2_locking_protocol *proto)
 /* Used by stack plugins */
 int ocfs2_stack_glue_register(struct ocfs2_stack_plugin *plugin);
 void ocfs2_stack_glue_unregister(struct ocfs2_stack_plugin *plugin);
-const char *ocfs2_get_hb_ctl_path(void);
 
 #endif  /* STACKGLUE_H */
-- 
1.5.4.5
