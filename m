From: Joel Becker <joel.becker@oracle.com>
Date: Wed Mar  5 16:28:19 2008
Subject: [Ocfs2-devel] [PATCH 16/18] ocfs2: Create stack glue sysfs files.
In-Reply-To: <1204763261-28025-1-git-send-email-joel.becker@oracle.com>
References: <1204763261-28025-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1204763261-28025-17-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, mark.fasheh@oracle.com

Introduce a set of sysfs files that describe the current stack glue
state.  The files live under /sys/fs/ocfs2.  The locking_protocol file
displays the version of ocfs2's locking code.  The
loaded_cluster_plugins file displays all of the currently loaded stack
plugins.  When filesystems are mounted, the active_cluster_plugin file
will display the plugin in use.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/stackglue.c |  121 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 120 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 1978c9c..76ae4fc 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -23,6 +23,9 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/kmod.h>
+#include <linux/fs.h>
+#include <linux/kobject.h>
+#include <linux/sysfs.h>
 
 #include "stackglue.h"
 
@@ -335,14 +338,130 @@ int ocfs2_cluster_this_node(unsigned int *node)
 EXPORT_SYMBOL_GPL(ocfs2_cluster_this_node);
 
 
-static int __init ocfs2_stack_glue_init(void)
+/*
+ * Sysfs bits
+ */
+
+static ssize_t ocfs2_max_locking_protocol_show(struct kobject *kobj,
+					       struct kobj_attribute *attr,
+					       char *buf)
+{
+	ssize_t ret = 0;
+
+	spin_lock(&ocfs2_stack_lock);
+	if (lproto)
+		ret = snprintf(buf, PAGE_SIZE, "%u.%u\n",
+			       lproto->lp_max_version.pv_major,
+			       lproto->lp_max_version.pv_minor);
+	spin_unlock(&ocfs2_stack_lock);
+
+	return ret;
+}
+
+static struct kobj_attribute ocfs2_attr_max_locking_protocol =
+	__ATTR(max_locking_protocol, S_IFREG | S_IRUGO,
+	       ocfs2_max_locking_protocol_show, NULL);
+
+static ssize_t ocfs2_loaded_cluster_plugins_show(struct kobject *kobj,
+						 struct kobj_attribute *attr,
+						 char *buf)
 {
+	ssize_t ret = 0, total = 0, remain = PAGE_SIZE;
+	struct ocfs2_stack_plugin *p;
+
+	spin_lock(&ocfs2_stack_lock);
+	list_for_each_entry(p, &ocfs2_stack_list, sp_list) {
+		ret = snprintf(buf, remain, "%s\n",
+			       p->sp_name);
+		if (ret < 0) {
+			total = ret;
+			break;
+		}
+		if (ret == remain) {
+			/* snprintf() didn't fit */
+			total = -E2BIG;
+			break;
+		}
+		total += ret;
+		remain -= ret;
+	}
+	spin_unlock(&ocfs2_stack_lock);
+
+	return total;
+}
+
+static struct kobj_attribute ocfs2_attr_loaded_cluster_plugins =
+	__ATTR(loaded_cluster_plugins, S_IFREG | S_IRUGO,
+	       ocfs2_loaded_cluster_plugins_show, NULL);
+
+static ssize_t ocfs2_active_cluster_plugin_show(struct kobject *kobj,
+						struct kobj_attribute *attr,
+						char *buf)
+{
+	ssize_t ret = 0;
+
+	spin_lock(&ocfs2_stack_lock);
+	if (active_stack) {
+		ret = snprintf(buf, PAGE_SIZE, "%s\n",
+			       active_stack->sp_name);
+		if (ret == PAGE_SIZE)
+			ret = -E2BIG;
+	}
+	spin_unlock(&ocfs2_stack_lock);
+
+	return ret;
+}
+
+static struct kobj_attribute ocfs2_attr_active_cluster_plugin =
+	__ATTR(active_cluster_plugin, S_IFREG | S_IRUGO,
+	       ocfs2_active_cluster_plugin_show, NULL);
+
+static struct attribute *ocfs2_attrs[] = {
+	&ocfs2_attr_max_locking_protocol.attr,
+	&ocfs2_attr_loaded_cluster_plugins.attr,
+	&ocfs2_attr_active_cluster_plugin.attr,
+	NULL,
+};
+
+static struct attribute_group ocfs2_attr_group = {
+	.attrs = ocfs2_attrs,
+};
+
+static struct kset *ocfs2_kset;
+
+static void ocfs2_sysfs_exit(void)
+{
+	kset_unregister(ocfs2_kset);
+}
+
+static int ocfs2_sysfs_init(void)
+{
+	int ret;
+
+	ocfs2_kset = kset_create_and_add("ocfs2", NULL, fs_kobj);
+	if (!ocfs2_kset)
+		return -ENOMEM;
+
+	ret = sysfs_create_group(&ocfs2_kset->kobj, &ocfs2_attr_group);
+	if (ret)
+		goto error;
+
 	return 0;
+
+error:
+	kset_unregister(ocfs2_kset);
+	return ret;
+}
+
+static int __init ocfs2_stack_glue_init(void)
+{
+	return ocfs2_sysfs_init();
 }
 
 static void __exit ocfs2_stack_glue_exit(void)
 {
 	lproto = NULL;
+	ocfs2_sysfs_exit();
 }
 
 MODULE_AUTHOR("Oracle");
-- 
1.5.3.8
