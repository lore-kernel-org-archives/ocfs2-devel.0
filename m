From: Mark Fasheh <mfasheh@suse.com>
Date: Wed,  2 Apr 2008 13:14:39 -0700
Subject: [Ocfs2-devel] [PATCH 29/62] ocfs2: Introduce the DOWN message to
	ocfs2_control
In-Reply-To: <12071673753788-git-send-email-mfasheh@suse.com>
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
	<1207167363119-git-send-email-mfasheh@suse.com>
	<12071673661674-git-send-email-mfasheh@suse.com>
	<12071673681650-git-send-email-mfasheh@suse.com>
	<12071673701937-git-send-email-mfasheh@suse.com>
	<12071673722691-git-send-email-mfasheh@suse.com>
	<12071673731276-git-send-email-mfasheh@suse.com>
	<12071673753788-git-send-email-mfasheh@suse.com>
Message-ID: <12071673772233-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>

From: Joel Becker <joel.becker@oracle.com>

When the control daemon sees a node go down, it sends a DOWN message
through the ocfs2_control device.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/stack_user.c |   94 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 89 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index ff8d307..a5e58e2 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -35,9 +35,21 @@
  * of output is a supported protocol tag.  All protocol tags are a single
  * character followed by a two hex digit version number.  Currently the
  * only things supported is T01, for "Text-base version 0x01".  Next, the
- * client writes the version they would like to use.  If the version tag
- * written is unknown, -EINVAL is returned.  Once the negotiation is
- * complete, the client can start sending messages.
+ * client writes the version they would like to use, including the newline.
+ * Thus, the protocol tag is 'T01\n'.  If the version tag written is
+ * unknown, -EINVAL is returned.  Once the negotiation is complete, the
+ * client can start sending messages.
+ *
+ * The T01 protocol only has one message, "DOWN".  It has the following
+ * syntax:
+ *
+ *  DOWN<space><32-char-cap-hex-uuid><space><8-char-hex-nodenum><newline>
+ *
+ * eg:
+ *
+ *  DOWN 632A924FDD844190BDA93C0DF6B94899 00000001\n
+ *
+ * This is 47 characters.
  */
 
 /*
@@ -49,6 +61,11 @@
 #define OCFS2_CONTROL_HANDSHAKE_INVALID		(0)
 #define OCFS2_CONTROL_HANDSHAKE_READ		(1)
 #define OCFS2_CONTROL_HANDSHAKE_VALID		(2)
+#define OCFS2_CONTROL_MESSAGE_DOWN		"DOWN"
+#define OCFS2_CONTROL_MESSAGE_DOWN_LEN		4
+#define OCFS2_CONTROL_MESSAGE_DOWN_TOTAL_LEN	47
+#define OCFS2_TEXT_UUID_LEN			32
+#define OCFS2_CONTROL_MESSAGE_NODENUM_LEN	8
 
 /*
  * ocfs2_live_connection is refcounted because the filesystem and
@@ -149,7 +166,7 @@ static void ocfs2_live_connection_drop(struct ocfs2_live_connection *c)
 	kfree(c);
 }
 
-static ssize_t ocfs2_control_cfu(char *target, size_t target_len,
+static ssize_t ocfs2_control_cfu(void *target, size_t target_len,
 				 const char __user *buf, size_t count)
 {
 	/* The T01 expects write(2) calls to have exactly one command */
@@ -185,6 +202,73 @@ static ssize_t ocfs2_control_validate_handshake(struct file *file,
 	return count;
 }
 
+static void ocfs2_control_send_down(const char *uuid,
+				    int nodenum)
+{
+	struct ocfs2_live_connection *c;
+
+	mutex_lock(&ocfs2_control_lock);
+
+	c = ocfs2_connection_find(uuid);
+	if (c) {
+		BUG_ON(c->oc_conn == NULL);
+		c->oc_conn->cc_recovery_handler(nodenum,
+						c->oc_conn->cc_recovery_data);
+	}
+
+	mutex_unlock(&ocfs2_control_lock);
+}
+
+/* DOWN<space><32-char-cap-hex-uuid><space><8-char-hex-nodenum><newline> */
+struct ocfs2_control_message_down {
+	char	tag[OCFS2_CONTROL_MESSAGE_DOWN_LEN];
+	char	space1;
+	char	uuid[OCFS2_TEXT_UUID_LEN];
+	char	space2;
+	char	nodestr[OCFS2_CONTROL_MESSAGE_NODENUM_LEN];
+	char	newline;
+};
+
+static ssize_t ocfs2_control_message(struct file *file,
+				     const char __user *buf,
+				     size_t count)
+{
+	ssize_t ret;
+	char *p = NULL;
+	long nodenum;
+	struct ocfs2_control_message_down msg;
+
+	/* Try to catch padding issues */
+	WARN_ON(offsetof(struct ocfs2_control_message_down, uuid) !=
+		(sizeof(msg.tag) + sizeof(msg.space1)));
+
+	memset(&msg, 0, sizeof(struct ocfs2_control_message_down));
+	ret = ocfs2_control_cfu(&msg, OCFS2_CONTROL_MESSAGE_DOWN_TOTAL_LEN,
+				buf, count);
+	if (ret != count)
+		return ret;
+
+	if (strncmp(msg.tag, OCFS2_CONTROL_MESSAGE_DOWN,
+		    strlen(OCFS2_CONTROL_MESSAGE_DOWN)))
+		return -EINVAL;
+
+	if ((msg.space1 != ' ') || (msg.space2 != ' ') ||
+	    (msg.newline != '\n'))
+		return -EINVAL;
+	msg.space1 = msg.space2 = msg.newline = '\0';
+
+	nodenum = simple_strtol(msg.nodestr, &p, 16);
+	if (!p || *p)
+		return -EINVAL;
+
+	if ((nodenum == LONG_MIN) || (nodenum == LONG_MAX) ||
+	    (nodenum > INT_MAX) || (nodenum < 0))
+		return -ERANGE;
+
+	ocfs2_control_send_down(msg.uuid, nodenum);
+
+	return count;
+}
 
 static ssize_t ocfs2_control_write(struct file *file,
 				   const char __user *buf,
@@ -204,7 +288,7 @@ static ssize_t ocfs2_control_write(struct file *file,
 			break;
 
 		case OCFS2_CONTROL_HANDSHAKE_VALID:
-			ret = count;  /* XXX */
+			ret = ocfs2_control_message(file, buf, count);
 			break;
 
 		default:
-- 
1.5.4.1
