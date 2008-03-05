From: Joel Becker <joel.becker@oracle.com>
Date: Wed Mar  5 17:14:28 2008
Subject: [Ocfs2-devel] [PATCH 06/10] ocfs2: Add the 'set version' message to
	the ocfs2_control device.
In-Reply-To: <1204766038-31721-1-git-send-email-joel.becker@oracle.com>
References: <1204766038-31721-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1204766038-31721-7-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

The "SETV" message sets the filesystem locking protocol version as
negotiated by the client.  The client negotiates based on the maximum
version advertised in /sys/fs/ocfs2/max_locking_protocol.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/stack_user.c |  131 ++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 119 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index 43e6105..9faa678 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -40,7 +40,7 @@
  * unknown, -EINVAL is returned.  Once the negotiation is complete, the
  * client can start sending messages.
  *
- * The T01 protocol only has two messages.  First is the "SETN" message.
+ * The T01 protocol has three messages.  First is the "SETN" message.
  * It has the following syntax:
  *
  *  SETN<space><8-char-hex-nodenum><newline>
@@ -50,8 +50,22 @@
  * The "SETN" message must be the first message following the protocol.
  * It tells ocfs2_control the local node number.
  *
- * Once the local node number has been set, the "DOWN" message can be
- * sent for node down notification.  It has the following syntax:
+ * Next comes the "SETV" message.  It has the following syntax:
+ *
+ *  SETV<space><2-char-hex-major><space><2-char-hex-minor><newline>
+ *
+ * This is 11 characters.
+ *
+ * The "SETV" message sets the filesystem locking protocol version as
+ * negotiated by the client.  The client negotiates based on the maximum
+ * version advertised in /sys/fs/ocfs2/max_locking_protocol.  The major
+ * number from the "SETV" message must match
+ * user_stack.sp_proto->lp_max_version.pv_major, and the minor number
+ * must be less than or equal to ...->lp_max_version.pv_minor.
+ *
+ * Once this information has been set, mounts will be allowed.  From this
+ * point on, the "DOWN" message can be * sent for node down notification.
+ * It has the following syntax:
  *
  *  DOWN<space><32-char-cap-hex-uuid><space><8-char-hex-nodenum><newline>
  *
@@ -79,9 +93,12 @@
 #define OCFS2_CONTROL_MESSAGE_OP_LEN		4
 #define OCFS2_CONTROL_MESSAGE_SETNODE_OP	"SETN"
 #define OCFS2_CONTROL_MESSAGE_SETNODE_TOTAL_LEN	14
+#define OCFS2_CONTROL_MESSAGE_SETVERSION_OP	"SETV"
+#define OCFS2_CONTROL_MESSAGE_SETVERSION_TOTAL_LEN	11
 #define OCFS2_CONTROL_MESSAGE_DOWN_OP		"DOWN"
 #define OCFS2_CONTROL_MESSAGE_DOWN_TOTAL_LEN	47
 #define OCFS2_TEXT_UUID_LEN			32
+#define OCFS2_CONTROL_MESSAGE_VERNUM_LEN	2
 #define OCFS2_CONTROL_MESSAGE_NODENUM_LEN	8
 
 /*
@@ -97,6 +114,7 @@ struct ocfs2_control_private {
 	struct list_head op_list;
 	int op_state;
 	int op_this_node;
+	struct ocfs2_protocol_version op_proto;
 };
 
 /* SETN<space><8-char-hex-nodenum><newline> */
@@ -107,6 +125,16 @@ struct ocfs2_control_message_setn {
 	char	newline;
 };
 
+/* SETV<space><2-char-hex-major><space><2-char-hex-minor><newline> */
+struct ocfs2_control_message_setv {
+	char	tag[OCFS2_CONTROL_MESSAGE_OP_LEN];
+	char	space1;
+	char	major[OCFS2_CONTROL_MESSAGE_VERNUM_LEN];
+	char	space2;
+	char	minor[OCFS2_CONTROL_MESSAGE_VERNUM_LEN];
+	char	newline;
+};
+
 /* DOWN<space><32-char-cap-hex-uuid><space><8-char-hex-nodenum><newline> */
 struct ocfs2_control_message_down {
 	char	tag[OCFS2_CONTROL_MESSAGE_OP_LEN];
@@ -120,11 +148,13 @@ struct ocfs2_control_message_down {
 union ocfs2_control_message {
 	char					tag[OCFS2_CONTROL_MESSAGE_OP_LEN];
 	struct ocfs2_control_message_setn	u_setn;
+	struct ocfs2_control_message_setv	u_setv;
 	struct ocfs2_control_message_down	u_down;
 };
 
 static atomic_t ocfs2_control_opened;
 static int ocfs2_control_this_node = -1;
+static struct ocfs2_protocol_version running_proto;
 
 static LIST_HEAD(ocfs2_live_connection_list);
 static LIST_HEAD(ocfs2_control_private_list);
@@ -264,8 +294,9 @@ static void ocfs2_control_send_down(const char *uuid,
 /*
  * Called whenever configuration elements are sent to /dev/ocfs2_control.
  * If all configuration elements are present, try to set the global
- * values.  If not, return -EAGAIN.  If there is a problem, return a
- * different error.
+ * values.  If there is a problem, return an error.  Skip any missing
+ * elements, and only bump ocfs2_control_opened when we have all elements
+ * and are successful.
  */
 static int ocfs2_control_install_private(struct file *file)
 {
@@ -275,15 +306,32 @@ static int ocfs2_control_install_private(struct file *file)
 
 	BUG_ON(p->op_state != OCFS2_CONTROL_HANDSHAKE_PROTOCOL);
 
-	if (p->op_this_node < 0)
+	mutex_lock(&ocfs2_control_lock);
+
+	if (p->op_this_node < 0) {
 		set_p = 0;
+	} else if ((ocfs2_control_this_node >= 0) &&
+		   (ocfs2_control_this_node != p->op_this_node)) {
+		rc = -EINVAL;
+		goto out_unlock;
+	}
 
-	mutex_lock(&ocfs2_control_lock);
-	if (ocfs2_control_this_node < 0) {
-		if (set_p)
-			ocfs2_control_this_node = p->op_this_node;
-	} else if (ocfs2_control_this_node != p->op_this_node)
+	if (!p->op_proto.pv_major) {
+		set_p = 0;
+	} else if (!list_empty(&ocfs2_live_connection_list) &&
+		   ((running_proto.pv_major != p->op_proto.pv_major) ||
+		    (running_proto.pv_minor != p->op_proto.pv_minor))) {
 		rc = -EINVAL;
+		goto out_unlock;
+	}
+
+	if (set_p) {
+		ocfs2_control_this_node = p->op_this_node;
+		running_proto.pv_major = p->op_proto.pv_major;
+		running_proto.pv_minor = p->op_proto.pv_minor;
+	}
+
+out_unlock:
 	mutex_unlock(&ocfs2_control_lock);
 
 	if (!rc && set_p) {
@@ -327,6 +375,56 @@ static int ocfs2_control_do_setnode_msg(struct file *file,
 	return ocfs2_control_install_private(file);
 }
 
+static int ocfs2_control_do_setversion_msg(struct file *file,
+					   struct ocfs2_control_message_setv *msg)
+ {
+	long major, minor;
+	char *ptr = NULL;
+	struct ocfs2_control_private *p = file->private_data;
+	struct ocfs2_protocol_version *max =
+		&user_stack.sp_proto->lp_max_version;
+
+	if (ocfs2_control_get_handshake_state(file) !=
+	    OCFS2_CONTROL_HANDSHAKE_PROTOCOL)
+		return -EINVAL;
+
+	if (strncmp(msg->tag, OCFS2_CONTROL_MESSAGE_SETVERSION_OP,
+		    OCFS2_CONTROL_MESSAGE_OP_LEN))
+		return -EINVAL;
+
+	if ((msg->space1 != ' ') || (msg->space2 != ' ') ||
+	    (msg->newline != '\n'))
+		return -EINVAL;
+	msg->space1 = msg->space2 = msg->newline = '\0';
+
+	major = simple_strtol(msg->major, &ptr, 16);
+	if (!ptr || *ptr)
+		return -EINVAL;
+	minor = simple_strtol(msg->minor, &ptr, 16);
+	if (!ptr || *ptr)
+		return -EINVAL;
+
+	/*
+	 * The major must be between 1 and 255, inclusive.  The minor
+	 * must be between 0 and 255, inclusive.  The version passed in
+	 * must be within the maximum version supported by the filesystem.
+	 */
+	if ((major == LONG_MIN) || (major == LONG_MAX) ||
+	    (major > (u8)-1) || (major < 1))
+		return -ERANGE;
+	if ((minor == LONG_MIN) || (minor == LONG_MAX) ||
+	    (minor > (u8)-1) || (minor < 0))
+		return -ERANGE;
+	if ((major != max->pv_major) ||
+	    (minor > max->pv_minor))
+		return -EINVAL;
+
+	p->op_proto.pv_major = major;
+	p->op_proto.pv_minor = minor;
+
+	return ocfs2_control_install_private(file);
+}
+
 static int ocfs2_control_do_down_msg(struct file *file,
 				     struct ocfs2_control_message_down *msg)
 {
@@ -379,6 +477,10 @@ static ssize_t ocfs2_control_message(struct file *file,
 	    !strncmp(msg.tag, OCFS2_CONTROL_MESSAGE_SETNODE_OP,
 		     OCFS2_CONTROL_MESSAGE_OP_LEN))
 		ret = ocfs2_control_do_setnode_msg(file, &msg.u_setn);
+	else if ((count == OCFS2_CONTROL_MESSAGE_SETVERSION_TOTAL_LEN) &&
+		 !strncmp(msg.tag, OCFS2_CONTROL_MESSAGE_SETVERSION_OP,
+			  OCFS2_CONTROL_MESSAGE_OP_LEN))
+		ret = ocfs2_control_do_setversion_msg(file, &msg.u_setv);
 	else if ((count == OCFS2_CONTROL_MESSAGE_DOWN_TOTAL_LEN) &&
 		 !strncmp(msg.tag, OCFS2_CONTROL_MESSAGE_DOWN_OP,
 			  OCFS2_CONTROL_MESSAGE_OP_LEN))
@@ -471,8 +573,13 @@ static int ocfs2_control_release(struct inode *inode, struct file *file)
 			       "an emergency restart!\n");
 			emergency_restart();
 		}
-		/* Last valid close clears the node number */
+		/*
+		 * Last valid close clears the node number and resets
+		 * the locking protocol version
+		 */
 		ocfs2_control_this_node = -1;
+		running_proto.pv_major = 0;
+		running_proto.pv_major = 0;
 	}
 
 out:
-- 
1.5.3.8
