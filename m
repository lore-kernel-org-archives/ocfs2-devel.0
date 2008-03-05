From: Joel Becker <joel.becker@oracle.com>
Date: Wed Mar  5 17:14:27 2008
Subject: [Ocfs2-devel] [PATCH 02/10] ocfs2: Add the ocfs2_control misc
	device.
In-Reply-To: <1204766038-31721-1-git-send-email-joel.becker@oracle.com>
References: <1204766038-31721-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1204766038-31721-3-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

The ocfs2_control misc device is how a userspace control daemon (controld)
talks to the filesystem.  Introduce the bare-bones filesystem ops.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/stack_user.c |  184 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 183 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index 920eb11..fdca5d3 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -18,17 +18,199 @@
  */
 
 #include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/mutex.h>
+#include <linux/reboot.h>
 
 #include "stackglue.h"
 
 
-static int __init user_stack_init(void)
+/*
+ * The control protocol starts with a handshake.  Until the handshake
+ * is complete, the control device will fail all write(2)s.
+ *
+ * The handshake is simple.  First, the client reads until EOF.  Each line
+ * of output is a supported protocol tag.  All protocol tags are a single
+ * character followed by a two hex digit version number.  Currently the
+ * only things supported is T01, for "Text-base version 0x01".  Next, the
+ * client writes the version they would like to use.  If the version tag
+ * written is unknown, -EINVAL is returned.  Once the negotiation is
+ * complete, the client can start sending messages.
+ */
+
+/*
+ * ocfs2_live_connection is refcounted because the filesystem and
+ * miscdevice sides can detach in different order.  Let's just be safe.
+ */
+struct ocfs2_live_connection {
+	struct list_head		oc_list;
+	struct ocfs2_cluster_connection	*oc_conn;
+};
+
+static atomic_t ocfs2_control_opened;
+
+static LIST_HEAD(ocfs2_live_connection_list);
+static DEFINE_MUTEX(ocfs2_control_lock);
+
+static struct ocfs2_live_connection *ocfs2_connection_find(const char *name)
+{
+	size_t len = strlen(name);
+	struct ocfs2_live_connection *c;
+
+	BUG_ON(!mutex_is_locked(&ocfs2_control_lock));
+
+	list_for_each_entry(c, &ocfs2_live_connection_list, oc_list) {
+		if ((c->oc_conn->cc_namelen == len) &&
+		    !strncmp(c->oc_conn->cc_name, name, len))
+			return c;
+	}
+
+	return c;
+}
+
+/*
+ * ocfs2_live_connection structures are created underneath the ocfs2
+ * mount path.  Since the VFS prevents multiple calls to
+ * fill_super(), we can't get dupes here.
+ */
+static int ocfs2_live_connection_new(struct ocfs2_cluster_connection *conn,
+				     struct ocfs2_live_connection **c_ret)
+{
+	int rc = 0;
+	struct ocfs2_live_connection *c;
+
+	c = kzalloc(sizeof(struct ocfs2_live_connection), GFP_KERNEL);
+	if (!c)
+		return -ENOMEM;
+
+	mutex_lock(&ocfs2_control_lock);
+	c->oc_conn = conn;
+
+	if (atomic_read(&ocfs2_control_opened))
+		list_add(&c->oc_list, &ocfs2_live_connection_list);
+	else {
+		printk(KERN_ERR
+		       "ocfs2: Userspace control daemon is not present\n");
+		rc = -ESRCH;
+	}
+
+	mutex_unlock(&ocfs2_control_lock);
+
+	if (!rc)
+		*c_ret = c;
+	else
+		kfree(c);
+
+	return rc;
+}
+
+/*
+ * This function disconnects the cluster connection from ocfs2_control.
+ * Afterwards, userspace can't affect the cluster connection.
+ */
+static void ocfs2_live_connection_drop(struct ocfs2_live_connection *c)
+{
+	mutex_lock(&ocfs2_control_lock);
+	list_del_init(&c->oc_list);
+	c->oc_conn = NULL;
+	mutex_unlock(&ocfs2_control_lock);
+
+	kfree(c);
+}
+
+
+static ssize_t ocfs2_control_write(struct file *file,
+				   const char __user *buf,
+				   size_t count,
+				   loff_t *ppos)
 {
 	return 0;
 }
 
+static ssize_t ocfs2_control_read(struct file *file,
+				  char __user *buf,
+				  size_t count,
+				  loff_t *ppos)
+{
+	return 0;
+}
+
+static int ocfs2_control_release(struct inode *inode, struct file *file)
+{
+	if (atomic_dec_and_test(&ocfs2_control_opened)) {
+		mutex_lock(&ocfs2_control_lock);
+		if (!list_empty(&ocfs2_live_connection_list)) {
+			/* XXX: Do bad things! */
+			printk(KERN_ERR
+			       "ocfs2: Unexpected release of ocfs2_control!\n"
+			       "       Loss of cluster connection requires "
+			       "an emergency restart!\n");
+			emergency_restart();
+		}
+		mutex_unlock(&ocfs2_control_lock);
+	}
+
+	return 0;
+}
+
+static int ocfs2_control_open(struct inode *inode, struct file *file)
+{
+	atomic_inc(&ocfs2_control_opened);
+
+	return 0;
+}
+
+static const struct file_operations ocfs2_control_fops = {
+	.open    = ocfs2_control_open,
+	.release = ocfs2_control_release,
+	.read    = ocfs2_control_read,
+	.write   = ocfs2_control_write,
+	.owner   = THIS_MODULE,
+};
+
+struct miscdevice ocfs2_control_device = {
+	.minor		= MISC_DYNAMIC_MINOR,
+	.name		= "ocfs2_control",
+	.fops		= &ocfs2_control_fops,
+};
+
+static int ocfs2_control_init(void)
+{
+	int rc;
+
+	atomic_set(&ocfs2_control_opened, 0);
+
+	rc = misc_register(&ocfs2_control_device);
+	if (rc)
+		printk(KERN_ERR
+		       "ocfs2: Unable to register ocfs2_control device "
+		       "(errno %d)\n",
+		       -rc);
+
+	return rc;
+}
+
+static void ocfs2_control_exit(void)
+{
+	int rc;
+
+	rc = misc_deregister(&ocfs2_control_device);
+	if (rc)
+		printk(KERN_ERR
+		       "ocfs2: Unable to deregister ocfs2_control device "
+		       "(errno %d)\n",
+		       -rc);
+}
+
+static int __init user_stack_init(void)
+{
+	return ocfs2_control_init();
+}
+
 static void __exit user_stack_exit(void)
 {
+	ocfs2_control_exit();
 }
 
 MODULE_AUTHOR("Oracle");
-- 
1.5.3.8
