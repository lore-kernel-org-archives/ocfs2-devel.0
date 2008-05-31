From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 30 May 2008 17:36:42 -0700
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2: Move the hb_ctl_path sysctl into
	the stack glue.
In-Reply-To: <1212194204-3906-1-git-send-email-joel.becker@oracle.com>
References: <1212194204-3906-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1212194204-3906-2-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2 needs to call out to the hb_ctl program at unmount for all cluster
stacks.  The first step is to move the hb_ctl_path sysctl out of the
o2cb code and into the generic stack glue.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/cluster/nodemanager.c |   74 +----------------------------------
 fs/ocfs2/cluster/nodemanager.h |    4 --
 fs/ocfs2/stack_o2cb.c          |    2 +-
 fs/ocfs2/stackglue.c           |   85 ++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/stackglue.h           |    2 +
 5 files changed, 89 insertions(+), 78 deletions(-)

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
index bbd1667..fb26a7c 100644
--- a/fs/ocfs2/stack_o2cb.c
+++ b/fs/ocfs2/stack_o2cb.c
@@ -338,7 +338,7 @@ static void o2hb_stop(const char *group)
 	int ret;
 	char *argv[5], *envp[3];
 
-	argv[0] = (char *)o2nm_get_hb_ctl_path();
+	argv[0] = (char *)ocfs2_get_hb_ctl_path();
 	argv[1] = "-K";
 	argv[2] = "-u";
 	argv[3] = (char *)group;
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 119f60c..fb9b8e0 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -26,6 +26,7 @@
 #include <linux/fs.h>
 #include <linux/kobject.h>
 #include <linux/sysfs.h>
+#include <linux/sysctl.h>
 
 #include "ocfs2_fs.h"
 
@@ -548,10 +549,92 @@ error:
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
+#define OCFS2_MAX_HB_CTL_PATH 256
+static char ocfs2_hb_ctl_path[OCFS2_MAX_HB_CTL_PATH] = "/sbin/ocfs2_hb_ctl";
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
+const char *ocfs2_get_hb_ctl_path(void)
+{
+	return ocfs2_hb_ctl_path;
+}
+EXPORT_SYMBOL_GPL(ocfs2_get_hb_ctl_path);
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
 
@@ -559,6 +642,8 @@ static void __exit ocfs2_stack_glue_exit(void)
 {
 	lproto = NULL;
 	ocfs2_sysfs_exit();
+	if (ocfs2_table_header)
+		unregister_sysctl_table(ocfs2_table_header);
 }
 
 MODULE_AUTHOR("Oracle");
diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
index 005e4f1..c9fb01a 100644
--- a/fs/ocfs2/stackglue.h
+++ b/fs/ocfs2/stackglue.h
@@ -258,4 +258,6 @@ void ocfs2_stack_glue_set_locking_protocol(struct ocfs2_locking_protocol *proto)
 /* Used by stack plugins */
 int ocfs2_stack_glue_register(struct ocfs2_stack_plugin *plugin);
 void ocfs2_stack_glue_unregister(struct ocfs2_stack_plugin *plugin);
+const char *ocfs2_get_hb_ctl_path(void);
+
 #endif  /* STACKGLUE_H */
-- 
1.5.4.5
