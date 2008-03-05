From: Joel Becker <joel.becker@oracle.com>
Date: Wed Mar  5 16:28:22 2008
Subject: [Ocfs2-devel] [PATCH 18/18] ocfs2: Add the 'cluster_stack' sysfs
	file.
In-Reply-To: <1204763261-28025-1-git-send-email-joel.becker@oracle.com>
References: <1204763261-28025-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1204763261-28025-19-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, mark.fasheh@oracle.com

Userspace can now query and specify the cluster stack in use via the
/sys/fs/ocfs2/cluster_stack file.  By default, it is 'o2cb', which is
the classic stack.  Thus, old tools that do not know how to modify this
file will work just fine.  The stack cannot be modified if there is a
live filesystem.

ocfs2_cluster_connect() now takes the expected cluster stack as an
argument.  This way, the filesystem and the stack glue ensure they are
speaking to the same backend.

If the stack is 'o2cb', the o2cb stack plugin is used.  For any other
value, the fsdlm stack plugin is selected.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/dlmglue.c   |    3 +-
 fs/ocfs2/stackglue.c |  111 +++++++++++++++++++++++++++++++++++++++++++++-----
 fs/ocfs2/stackglue.h |    3 +-
 3 files changed, 104 insertions(+), 13 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 71af7d6..737f0b2 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2627,7 +2627,8 @@ int ocfs2_dlm_init(struct ocfs2_super *osb)
 	}
 
 	/* for now, uuid == domain */
-	status = ocfs2_cluster_connect(osb->uuid_str,
+	status = ocfs2_cluster_connect(osb->osb_cluster_stack,
+				       osb->uuid_str,
 				       strlen(osb->uuid_str),
 				       ocfs2_do_node_down, osb,
 				       &conn);
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 76ae4fc..bf45d9b 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -27,11 +27,17 @@
 #include <linux/kobject.h>
 #include <linux/sysfs.h>
 
+#include "ocfs2_fs.h"
+
 #include "stackglue.h"
 
+#define OCFS2_STACK_PLUGIN_O2CB		"o2cb"
+#define OCFS2_STACK_PLUGIN_USER		"user"
+
 static struct ocfs2_locking_protocol *lproto;
 static DEFINE_SPINLOCK(ocfs2_stack_lock);
 static LIST_HEAD(ocfs2_stack_list);
+static char cluster_stack_name[OCFS2_STACK_LABEL_LEN + 1];
 
 /*
  * The stack currently in use.  If not null, active_stack->sp_count > 0,
@@ -53,26 +59,36 @@ static struct ocfs2_stack_plugin *ocfs2_stack_lookup(const char *name)
 	return NULL;
 }
 
-static int ocfs2_stack_driver_request(const char *name)
+static int ocfs2_stack_driver_request(const char *stack_name,
+				      const char *plugin_name)
 {
 	int rc;
 	struct ocfs2_stack_plugin *p;
 
 	spin_lock(&ocfs2_stack_lock);
 
+	/*
+	 * If the stack passed by the filesystem isn't the selected one,
+	 * we can't continue.
+	 */
+	if (strcmp(stack_name, cluster_stack_name)) {
+		rc = -EBUSY;
+		goto out;
+	}
+
 	if (active_stack) {
 		/*
 		 * If the active stack isn't the one we want, it cannot
 		 * be selected right now.
 		 */
-		if (!strcmp(active_stack->sp_name, name))
+		if (!strcmp(active_stack->sp_name, plugin_name))
 			rc = 0;
 		else
 			rc = -EBUSY;
 		goto out;
 	}
 
-	p = ocfs2_stack_lookup(name);
+	p = ocfs2_stack_lookup(plugin_name);
 	if (!p || !try_module_get(p->sp_owner)) {
 		rc = -ENOENT;
 		goto out;
@@ -94,23 +110,42 @@ out:
  * there is no stack, it tries to load it.  It will fail if the stack still
  * cannot be found.  It will also fail if a different stack is in use.
  */
-static int ocfs2_stack_driver_get(const char *name)
+static int ocfs2_stack_driver_get(const char *stack_name)
 {
 	int rc;
+	char *plugin_name = OCFS2_STACK_PLUGIN_O2CB;
+
+	/*
+	 * Classic stack does not pass in a stack name.  This is
+	 * compatible with older tools as well.
+	 */
+	if (!stack_name || !*stack_name)
+		stack_name = OCFS2_STACK_PLUGIN_O2CB;
+
+	if (strlen(stack_name) != OCFS2_STACK_LABEL_LEN) {
+		printk(KERN_ERR
+		       "ocfs2 passed an invalid cluster stack label: \"%s\"\n",
+		       stack_name);
+		return -EINVAL;
+	}
 
-	rc = ocfs2_stack_driver_request(name);
+	/* Anything that isn't the classic stack is a user stack */
+	if (strcmp(stack_name, OCFS2_STACK_PLUGIN_O2CB))
+		plugin_name = OCFS2_STACK_PLUGIN_USER;
+
+	rc = ocfs2_stack_driver_request(stack_name, plugin_name);
 	if (rc == -ENOENT) {
-		request_module("ocfs2_stack_%s", name);
-		rc = ocfs2_stack_driver_request(name);
+		request_module("ocfs2_stack_%s", plugin_name);
+		rc = ocfs2_stack_driver_request(stack_name, plugin_name);
 	}
 
 	if (rc == -ENOENT) {
 		printk(KERN_ERR
 		       "ocfs2: Cluster stack driver \"%s\" cannot be found\n",
-		       name);
+		       plugin_name);
 	} else if (rc == -EBUSY) {
 		printk(KERN_ERR
-		       "ocfs2: A different cluster stack driver is in use\n");
+		       "ocfs2: A different cluster stack is in use\n");
 	}
 
 	return rc;
@@ -242,7 +277,8 @@ void ocfs2_dlm_dump_lksb(union ocfs2_dlm_lksb *lksb)
 }
 EXPORT_SYMBOL_GPL(ocfs2_dlm_dump_lksb);
 
-int ocfs2_cluster_connect(const char *group,
+int ocfs2_cluster_connect(const char *stack_name,
+			  const char *group,
 			  int grouplen,
 			  void (*recovery_handler)(int node_num,
 						   void *recovery_data),
@@ -277,7 +313,7 @@ int ocfs2_cluster_connect(const char *group,
 	new_conn->cc_version = lproto->lp_max_version;
 
 	/* This will pin the stack driver if successful */
-	rc = ocfs2_stack_driver_get("o2cb");
+	rc = ocfs2_stack_driver_get(stack_name);
 	if (rc)
 		goto out_free;
 
@@ -416,10 +452,61 @@ static struct kobj_attribute ocfs2_attr_active_cluster_plugin =
 	__ATTR(active_cluster_plugin, S_IFREG | S_IRUGO,
 	       ocfs2_active_cluster_plugin_show, NULL);
 
+static ssize_t ocfs2_cluster_stack_show(struct kobject *kobj,
+					struct kobj_attribute *attr,
+					char *buf)
+{
+	ssize_t ret;
+	spin_lock(&ocfs2_stack_lock);
+	ret = snprintf(buf, PAGE_SIZE, "%s\n", cluster_stack_name);
+	spin_unlock(&ocfs2_stack_lock);
+
+	return ret;
+}
+
+static ssize_t ocfs2_cluster_stack_store(struct kobject *kobj,
+					 struct kobj_attribute *attr,
+					 const char *buf, size_t count)
+{
+	size_t len = count;
+	ssize_t ret;
+
+	if (len == 0)
+		return len;
+
+	if (buf[len - 1] == '\n')
+		len--;
+
+	if ((len != OCFS2_STACK_LABEL_LEN) ||
+	    (strnlen(buf, len) != len))
+		return -EINVAL;
+
+	spin_lock(&ocfs2_stack_lock);
+	if (active_stack) {
+		if (!strncmp(buf, cluster_stack_name, len))
+			ret = count;
+		else
+			ret = -EBUSY;
+	} else {
+		memcpy(cluster_stack_name, buf, len);
+		ret = count;
+	}
+	spin_unlock(&ocfs2_stack_lock);
+
+	return ret;
+}
+
+
+static struct kobj_attribute ocfs2_attr_cluster_stack =
+	__ATTR(cluster_stack, S_IFREG | S_IRUGO | S_IWUSR,
+	       ocfs2_cluster_stack_show,
+	       ocfs2_cluster_stack_store);
+
 static struct attribute *ocfs2_attrs[] = {
 	&ocfs2_attr_max_locking_protocol.attr,
 	&ocfs2_attr_loaded_cluster_plugins.attr,
 	&ocfs2_attr_active_cluster_plugin.attr,
+	&ocfs2_attr_cluster_stack.attr,
 	NULL,
 };
 
@@ -455,6 +542,8 @@ error:
 
 static int __init ocfs2_stack_glue_init(void)
 {
+	strcpy(cluster_stack_name, OCFS2_STACK_PLUGIN_O2CB);
+
 	return ocfs2_sysfs_init();
 }
 
diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
index c96c8bb..d88bc65 100644
--- a/fs/ocfs2/stackglue.h
+++ b/fs/ocfs2/stackglue.h
@@ -209,7 +209,8 @@ struct ocfs2_stack_plugin {
 
 
 /* Used by the filesystem */
-int ocfs2_cluster_connect(const char *group,
+int ocfs2_cluster_connect(const char *stack_name,
+			  const char *group,
 			  int grouplen,
 			  void (*recovery_handler)(int node_num,
 						   void *recovery_data),
-- 
1.5.3.8
