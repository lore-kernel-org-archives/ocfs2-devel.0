From: Joel Becker <joel.becker@oracle.com>
Date: Wed Mar  5 17:14:27 2008
Subject: [Ocfs2-devel] [PATCH 05/10] ocfs2: Add the local node id to the
	handshake.
In-Reply-To: <1204766038-31721-1-git-send-email-joel.becker@oracle.com>
References: <1204766038-31721-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1204766038-31721-6-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, mark.fasheh@oracle.com, teigland@redhat.com

This is the second part of the ocfs2_control handshake.  After
negotiating the ocfs2_control protocol, the daemon tells the filesystem
what the local node id is via the SETN message.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/stack_user.c |  222 ++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 173 insertions(+), 49 deletions(-)

diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index a5e58e2..43e6105 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -40,8 +40,18 @@
  * unknown, -EINVAL is returned.  Once the negotiation is complete, the
  * client can start sending messages.
  *
- * The T01 protocol only has one message, "DOWN".  It has the following
- * syntax:
+ * The T01 protocol only has two messages.  First is the "SETN" message.
+ * It has the following syntax:
+ *
+ *  SETN<space><8-char-hex-nodenum><newline>
+ *
+ * This is 14 characters.
+ *
+ * The "SETN" message must be the first message following the protocol.
+ * It tells ocfs2_control the local node number.
+ *
+ * Once the local node number has been set, the "DOWN" message can be
+ * sent for node down notification.  It has the following syntax:
  *
  *  DOWN<space><32-char-cap-hex-uuid><space><8-char-hex-nodenum><newline>
  *
@@ -58,11 +68,18 @@
  */
 #define OCFS2_CONTROL_PROTO			"T01\n"
 #define OCFS2_CONTROL_PROTO_LEN			4
+
+/* Handshake states */
 #define OCFS2_CONTROL_HANDSHAKE_INVALID		(0)
 #define OCFS2_CONTROL_HANDSHAKE_READ		(1)
-#define OCFS2_CONTROL_HANDSHAKE_VALID		(2)
-#define OCFS2_CONTROL_MESSAGE_DOWN		"DOWN"
-#define OCFS2_CONTROL_MESSAGE_DOWN_LEN		4
+#define OCFS2_CONTROL_HANDSHAKE_PROTOCOL	(2)
+#define OCFS2_CONTROL_HANDSHAKE_VALID		(3)
+
+/* Messages */
+#define OCFS2_CONTROL_MESSAGE_OP_LEN		4
+#define OCFS2_CONTROL_MESSAGE_SETNODE_OP	"SETN"
+#define OCFS2_CONTROL_MESSAGE_SETNODE_TOTAL_LEN	14
+#define OCFS2_CONTROL_MESSAGE_DOWN_OP		"DOWN"
 #define OCFS2_CONTROL_MESSAGE_DOWN_TOTAL_LEN	47
 #define OCFS2_TEXT_UUID_LEN			32
 #define OCFS2_CONTROL_MESSAGE_NODENUM_LEN	8
@@ -79,9 +96,35 @@ struct ocfs2_live_connection {
 struct ocfs2_control_private {
 	struct list_head op_list;
 	int op_state;
+	int op_this_node;
+};
+
+/* SETN<space><8-char-hex-nodenum><newline> */
+struct ocfs2_control_message_setn {
+	char	tag[OCFS2_CONTROL_MESSAGE_OP_LEN];
+	char	space;
+	char	nodestr[OCFS2_CONTROL_MESSAGE_NODENUM_LEN];
+	char	newline;
+};
+
+/* DOWN<space><32-char-cap-hex-uuid><space><8-char-hex-nodenum><newline> */
+struct ocfs2_control_message_down {
+	char	tag[OCFS2_CONTROL_MESSAGE_OP_LEN];
+	char	space1;
+	char	uuid[OCFS2_TEXT_UUID_LEN];
+	char	space2;
+	char	nodestr[OCFS2_CONTROL_MESSAGE_NODENUM_LEN];
+	char	newline;
+};
+
+union ocfs2_control_message {
+	char					tag[OCFS2_CONTROL_MESSAGE_OP_LEN];
+	struct ocfs2_control_message_setn	u_setn;
+	struct ocfs2_control_message_down	u_down;
 };
 
 static atomic_t ocfs2_control_opened;
+static int ocfs2_control_this_node = -1;
 
 static LIST_HEAD(ocfs2_live_connection_list);
 static LIST_HEAD(ocfs2_control_private_list);
@@ -166,38 +209,37 @@ static void ocfs2_live_connection_drop(struct ocfs2_live_connection *c)
 	kfree(c);
 }
 
-static ssize_t ocfs2_control_cfu(void *target, size_t target_len,
-				 const char __user *buf, size_t count)
+static int ocfs2_control_cfu(void *target, size_t target_len,
+			     const char __user *buf, size_t count)
 {
 	/* The T01 expects write(2) calls to have exactly one command */
-	if (count != target_len)
+	if ((count != target_len) ||
+	    (count > sizeof(union ocfs2_control_message)))
 		return -EINVAL;
 
 	if (copy_from_user(target, buf, target_len))
 		return -EFAULT;
 
-	return count;
+	return 0;
 }
 
-static ssize_t ocfs2_control_validate_handshake(struct file *file,
-						const char __user *buf,
-						size_t count)
+static ssize_t ocfs2_control_validate_protocol(struct file *file,
+					       const char __user *buf,
+					       size_t count)
 {
 	ssize_t ret;
 	char kbuf[OCFS2_CONTROL_PROTO_LEN];
 
 	ret = ocfs2_control_cfu(kbuf, OCFS2_CONTROL_PROTO_LEN,
 				buf, count);
-	if (ret != count)
+	if (ret)
 		return ret;
 
 	if (strncmp(kbuf, OCFS2_CONTROL_PROTO, OCFS2_CONTROL_PROTO_LEN))
 		return -EINVAL;
 
-	atomic_inc(&ocfs2_control_opened);
 	ocfs2_control_set_handshake_state(file,
-					  OCFS2_CONTROL_HANDSHAKE_VALID);
-
+					  OCFS2_CONTROL_HANDSHAKE_PROTOCOL);
 
 	return count;
 }
@@ -219,45 +261,92 @@ static void ocfs2_control_send_down(const char *uuid,
 	mutex_unlock(&ocfs2_control_lock);
 }
 
-/* DOWN<space><32-char-cap-hex-uuid><space><8-char-hex-nodenum><newline> */
-struct ocfs2_control_message_down {
-	char	tag[OCFS2_CONTROL_MESSAGE_DOWN_LEN];
-	char	space1;
-	char	uuid[OCFS2_TEXT_UUID_LEN];
-	char	space2;
-	char	nodestr[OCFS2_CONTROL_MESSAGE_NODENUM_LEN];
-	char	newline;
-};
+/*
+ * Called whenever configuration elements are sent to /dev/ocfs2_control.
+ * If all configuration elements are present, try to set the global
+ * values.  If not, return -EAGAIN.  If there is a problem, return a
+ * different error.
+ */
+static int ocfs2_control_install_private(struct file *file)
+{
+	int rc = 0;
+	int set_p = 1;
+	struct ocfs2_control_private *p = file->private_data;
 
-static ssize_t ocfs2_control_message(struct file *file,
-				     const char __user *buf,
-				     size_t count)
+	BUG_ON(p->op_state != OCFS2_CONTROL_HANDSHAKE_PROTOCOL);
+
+	if (p->op_this_node < 0)
+		set_p = 0;
+
+	mutex_lock(&ocfs2_control_lock);
+	if (ocfs2_control_this_node < 0) {
+		if (set_p)
+			ocfs2_control_this_node = p->op_this_node;
+	} else if (ocfs2_control_this_node != p->op_this_node)
+		rc = -EINVAL;
+	mutex_unlock(&ocfs2_control_lock);
+
+	if (!rc && set_p) {
+		/* We set the global values successfully */
+		atomic_inc(&ocfs2_control_opened);
+		ocfs2_control_set_handshake_state(file,
+					OCFS2_CONTROL_HANDSHAKE_VALID);
+	}
+
+	return rc;
+}
+
+static int ocfs2_control_do_setnode_msg(struct file *file,
+					struct ocfs2_control_message_setn *msg)
 {
-	ssize_t ret;
-	char *p = NULL;
 	long nodenum;
-	struct ocfs2_control_message_down msg;
+	char *ptr = NULL;
+	struct ocfs2_control_private *p = file->private_data;
 
-	/* Try to catch padding issues */
-	WARN_ON(offsetof(struct ocfs2_control_message_down, uuid) !=
-		(sizeof(msg.tag) + sizeof(msg.space1)));
+	if (ocfs2_control_get_handshake_state(file) !=
+	    OCFS2_CONTROL_HANDSHAKE_PROTOCOL)
+		return -EINVAL;
 
-	memset(&msg, 0, sizeof(struct ocfs2_control_message_down));
-	ret = ocfs2_control_cfu(&msg, OCFS2_CONTROL_MESSAGE_DOWN_TOTAL_LEN,
-				buf, count);
-	if (ret != count)
-		return ret;
+	if (strncmp(msg->tag, OCFS2_CONTROL_MESSAGE_SETNODE_OP,
+		    OCFS2_CONTROL_MESSAGE_OP_LEN))
+		return -EINVAL;
+
+	if ((msg->space != ' ') || (msg->newline != '\n'))
+		return -EINVAL;
+	msg->space = msg->newline = '\0';
+
+	nodenum = simple_strtol(msg->nodestr, &ptr, 16);
+	if (!ptr || *ptr)
+		return -EINVAL;
+
+	if ((nodenum == LONG_MIN) || (nodenum == LONG_MAX) ||
+	    (nodenum > INT_MAX) || (nodenum < 0))
+		return -ERANGE;
+	p->op_this_node = nodenum;
+
+	return ocfs2_control_install_private(file);
+}
+
+static int ocfs2_control_do_down_msg(struct file *file,
+				     struct ocfs2_control_message_down *msg)
+{
+	long nodenum;
+	char *p = NULL;
+
+	if (ocfs2_control_get_handshake_state(file) !=
+	    OCFS2_CONTROL_HANDSHAKE_VALID)
+		return -EINVAL;
 
-	if (strncmp(msg.tag, OCFS2_CONTROL_MESSAGE_DOWN,
-		    strlen(OCFS2_CONTROL_MESSAGE_DOWN)))
+	if (strncmp(msg->tag, OCFS2_CONTROL_MESSAGE_DOWN_OP,
+		    OCFS2_CONTROL_MESSAGE_OP_LEN))
 		return -EINVAL;
 
-	if ((msg.space1 != ' ') || (msg.space2 != ' ') ||
-	    (msg.newline != '\n'))
+	if ((msg->space1 != ' ') || (msg->space2 != ' ') ||
+	    (msg->newline != '\n'))
 		return -EINVAL;
-	msg.space1 = msg.space2 = msg.newline = '\0';
+	msg->space1 = msg->space2 = msg->newline = '\0';
 
-	nodenum = simple_strtol(msg.nodestr, &p, 16);
+	nodenum = simple_strtol(msg->nodestr, &p, 16);
 	if (!p || *p)
 		return -EINVAL;
 
@@ -265,9 +354,40 @@ static ssize_t ocfs2_control_message(struct file *file,
 	    (nodenum > INT_MAX) || (nodenum < 0))
 		return -ERANGE;
 
-	ocfs2_control_send_down(msg.uuid, nodenum);
+	ocfs2_control_send_down(msg->uuid, nodenum);
 
-	return count;
+	return 0;
+}
+
+static ssize_t ocfs2_control_message(struct file *file,
+				     const char __user *buf,
+				     size_t count)
+{
+	ssize_t ret;
+	union ocfs2_control_message msg;
+
+	/* Try to catch padding issues */
+	WARN_ON(offsetof(struct ocfs2_control_message_down, uuid) !=
+		(sizeof(msg.u_down.tag) + sizeof(msg.u_down.space1)));
+
+	memset(&msg, 0, sizeof(union ocfs2_control_message));
+	ret = ocfs2_control_cfu(&msg, count, buf, count);
+	if (ret)
+		goto out;
+
+	if ((count == OCFS2_CONTROL_MESSAGE_SETNODE_TOTAL_LEN) &&
+	    !strncmp(msg.tag, OCFS2_CONTROL_MESSAGE_SETNODE_OP,
+		     OCFS2_CONTROL_MESSAGE_OP_LEN))
+		ret = ocfs2_control_do_setnode_msg(file, &msg.u_setn);
+	else if ((count == OCFS2_CONTROL_MESSAGE_DOWN_TOTAL_LEN) &&
+		 !strncmp(msg.tag, OCFS2_CONTROL_MESSAGE_DOWN_OP,
+			  OCFS2_CONTROL_MESSAGE_OP_LEN))
+		ret = ocfs2_control_do_down_msg(file, &msg.u_down);
+	else
+		ret = -EINVAL;
+
+out:
+	return ret ? ret : count;
 }
 
 static ssize_t ocfs2_control_write(struct file *file,
@@ -283,10 +403,11 @@ static ssize_t ocfs2_control_write(struct file *file,
 			break;
 
 		case OCFS2_CONTROL_HANDSHAKE_READ:
-			ret = ocfs2_control_validate_handshake(file, buf,
-							       count);
+			ret = ocfs2_control_validate_protocol(file, buf,
+							      count);
 			break;
 
+		case OCFS2_CONTROL_HANDSHAKE_PROTOCOL:
 		case OCFS2_CONTROL_HANDSHAKE_VALID:
 			ret = ocfs2_control_message(file, buf, count);
 			break;
@@ -350,6 +471,8 @@ static int ocfs2_control_release(struct inode *inode, struct file *file)
 			       "an emergency restart!\n");
 			emergency_restart();
 		}
+		/* Last valid close clears the node number */
+		ocfs2_control_this_node = -1;
 	}
 
 out:
@@ -370,6 +493,7 @@ static int ocfs2_control_open(struct inode *inode, struct file *file)
 	p = kzalloc(sizeof(struct ocfs2_control_private), GFP_KERNEL);
 	if (!p)
 		return -ENOMEM;
+	p->op_this_node = -1;
 
 	mutex_lock(&ocfs2_control_lock);
 	file->private_data = p;
-- 
1.5.3.8
