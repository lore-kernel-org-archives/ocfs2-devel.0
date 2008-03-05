From: Joel Becker <joel.becker@oracle.com>
Date: Wed Mar  5 17:14:28 2008
Subject: [Ocfs2-devel] [PATCH 03/10] ocfs2: Start the ocfs2_control
	handshake.
In-Reply-To: <1204766038-31721-1-git-send-email-joel.becker@oracle.com>
References: <1204766038-31721-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1204766038-31721-4-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

When a control daemon opens the ocfs2_control device, it must perform a
handshake to tell the filesystem it is something capable of monitoring
cluster status.  Only after the handshake is complete will the filesystem
allow mounts.

This is the first part of the handshake.  The daemon reads all supported
ocfs2_control protocols, then writes in the protocol it will use.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/stack_user.c |  144 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 139 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index fdca5d3..ff8d307 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -22,6 +22,7 @@
 #include <linux/miscdevice.h>
 #include <linux/mutex.h>
 #include <linux/reboot.h>
+#include <asm/uaccess.h>
 
 #include "stackglue.h"
 
@@ -40,6 +41,16 @@
  */
 
 /*
+ * Whether or not the client has done the handshake.
+ * For now, we have just one protocol version.
+ */
+#define OCFS2_CONTROL_PROTO			"T01\n"
+#define OCFS2_CONTROL_PROTO_LEN			4
+#define OCFS2_CONTROL_HANDSHAKE_INVALID		(0)
+#define OCFS2_CONTROL_HANDSHAKE_READ		(1)
+#define OCFS2_CONTROL_HANDSHAKE_VALID		(2)
+
+/*
  * ocfs2_live_connection is refcounted because the filesystem and
  * miscdevice sides can detach in different order.  Let's just be safe.
  */
@@ -48,11 +59,30 @@ struct ocfs2_live_connection {
 	struct ocfs2_cluster_connection	*oc_conn;
 };
 
+struct ocfs2_control_private {
+	struct list_head op_list;
+	int op_state;
+};
+
 static atomic_t ocfs2_control_opened;
 
 static LIST_HEAD(ocfs2_live_connection_list);
+static LIST_HEAD(ocfs2_control_private_list);
 static DEFINE_MUTEX(ocfs2_control_lock);
 
+static inline void ocfs2_control_set_handshake_state(struct file *file,
+						     int state)
+{
+	struct ocfs2_control_private *p = file->private_data;
+	p->op_state = state;
+}
+
+static inline int ocfs2_control_get_handshake_state(struct file *file)
+{
+	struct ocfs2_control_private *p = file->private_data;
+	return p->op_state;
+}
+
 static struct ocfs2_live_connection *ocfs2_connection_find(const char *name)
 {
 	size_t len = strlen(name);
@@ -119,27 +149,115 @@ static void ocfs2_live_connection_drop(struct ocfs2_live_connection *c)
 	kfree(c);
 }
 
+static ssize_t ocfs2_control_cfu(char *target, size_t target_len,
+				 const char __user *buf, size_t count)
+{
+	/* The T01 expects write(2) calls to have exactly one command */
+	if (count != target_len)
+		return -EINVAL;
+
+	if (copy_from_user(target, buf, target_len))
+		return -EFAULT;
+
+	return count;
+}
+
+static ssize_t ocfs2_control_validate_handshake(struct file *file,
+						const char __user *buf,
+						size_t count)
+{
+	ssize_t ret;
+	char kbuf[OCFS2_CONTROL_PROTO_LEN];
+
+	ret = ocfs2_control_cfu(kbuf, OCFS2_CONTROL_PROTO_LEN,
+				buf, count);
+	if (ret != count)
+		return ret;
+
+	if (strncmp(kbuf, OCFS2_CONTROL_PROTO, OCFS2_CONTROL_PROTO_LEN))
+		return -EINVAL;
+
+	atomic_inc(&ocfs2_control_opened);
+	ocfs2_control_set_handshake_state(file,
+					  OCFS2_CONTROL_HANDSHAKE_VALID);
+
+
+	return count;
+}
+
 
 static ssize_t ocfs2_control_write(struct file *file,
 				   const char __user *buf,
 				   size_t count,
 				   loff_t *ppos)
 {
-	return 0;
+	ssize_t ret;
+
+	switch (ocfs2_control_get_handshake_state(file)) {
+		case OCFS2_CONTROL_HANDSHAKE_INVALID:
+			ret = -EINVAL;
+			break;
+
+		case OCFS2_CONTROL_HANDSHAKE_READ:
+			ret = ocfs2_control_validate_handshake(file, buf,
+							       count);
+			break;
+
+		case OCFS2_CONTROL_HANDSHAKE_VALID:
+			ret = count;  /* XXX */
+			break;
+
+		default:
+			BUG();
+			ret = -EIO;
+			break;
+	}
+
+	return ret;
 }
 
+/*
+ * This is a naive version.  If we ever have a new protocol, we'll expand
+ * it.  Probably using seq_file.
+ */
 static ssize_t ocfs2_control_read(struct file *file,
 				  char __user *buf,
 				  size_t count,
 				  loff_t *ppos)
 {
-	return 0;
+	char *proto_string = OCFS2_CONTROL_PROTO;
+	size_t to_write = 0;
+
+	if (*ppos >= OCFS2_CONTROL_PROTO_LEN)
+		return 0;
+
+	to_write = OCFS2_CONTROL_PROTO_LEN - *ppos;
+	if (to_write > count)
+		to_write = count;
+	if (copy_to_user(buf, proto_string + *ppos, to_write))
+		return -EFAULT;
+
+	*ppos += to_write;
+
+	/* Have we read the whole protocol list? */
+	if (*ppos >= OCFS2_CONTROL_PROTO_LEN)
+		ocfs2_control_set_handshake_state(file,
+						  OCFS2_CONTROL_HANDSHAKE_READ);
+
+	return to_write;
 }
 
 static int ocfs2_control_release(struct inode *inode, struct file *file)
 {
+	struct ocfs2_control_private *p = file->private_data;
+
+	mutex_lock(&ocfs2_control_lock);
+
+	if (ocfs2_control_get_handshake_state(file) !=
+	    OCFS2_CONTROL_HANDSHAKE_VALID)
+		goto out;
+
 	if (atomic_dec_and_test(&ocfs2_control_opened)) {
-		mutex_lock(&ocfs2_control_lock);
 		if (!list_empty(&ocfs2_live_connection_list)) {
 			/* XXX: Do bad things! */
 			printk(KERN_ERR
@@ -148,15 +266,31 @@ static int ocfs2_control_release(struct inode *inode, struct file *file)
 			       "an emergency restart!\n");
 			emergency_restart();
 		}
-		mutex_unlock(&ocfs2_control_lock);
 	}
 
+out:
+	list_del_init(&p->op_list);
+	file->private_data = NULL;
+
+	mutex_unlock(&ocfs2_control_lock);
+
+	kfree(p);
+
 	return 0;
 }
 
 static int ocfs2_control_open(struct inode *inode, struct file *file)
 {
-	atomic_inc(&ocfs2_control_opened);
+	struct ocfs2_control_private *p;
+
+	p = kzalloc(sizeof(struct ocfs2_control_private), GFP_KERNEL);
+	if (!p)
+		return -ENOMEM;
+
+	mutex_lock(&ocfs2_control_lock);
+	file->private_data = p;
+	list_add(&p->op_list, &ocfs2_control_private_list);
+	mutex_unlock(&ocfs2_control_lock);
 
 	return 0;
 }
-- 
1.5.3.8
