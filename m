From: Joel Becker <joel.becker@oracle.com>
Date: Thu,  4 Feb 2010 16:55:00 -0800
Subject: [Ocfs2-devel] [PATCH 07/10] ocfs2: Remove the ast pointers from
	ocfs2_stack_plugins
In-Reply-To: <1265331303-19881-1-git-send-email-joel.becker@oracle.com>
References: <1265331303-19881-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1265331303-19881-8-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org, mfasheh@suse.com

With the full ocfs2_locking_protocol hanging off of the
ocfs2_cluster_connection, ast wrappers can get the ast/bast pointers
there.  They don't need to get them from their plugin structure.

The user plugin still needs the maximum locking protocol version,
though.  This changes the plugin structure so that it only holds the max
version, not the entire ocfs2_locking_protocol pointer.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/stack_user.c |    6 +++---
 fs/ocfs2/stackglue.c  |    4 ++--
 fs/ocfs2/stackglue.h  |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index b4cf616..5ae8812 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -62,8 +62,8 @@
  * negotiated by the client.  The client negotiates based on the maximum
  * version advertised in /sys/fs/ocfs2/max_locking_protocol.  The major
  * number from the "SETV" message must match
- * ocfs2_user_plugin.sp_proto->lp_max_version.pv_major, and the minor number
- * must be less than or equal to ...->lp_max_version.pv_minor.
+ * ocfs2_user_plugin.sp_max_proto.pv_major, and the minor number
+ * must be less than or equal to ...sp_max_version.pv_minor.
  *
  * Once this information has been set, mounts will be allowed.  From this
  * point on, the "DOWN" message can be sent for node down notification.
@@ -400,7 +400,7 @@ static int ocfs2_control_do_setversion_msg(struct file *file,
 	char *ptr = NULL;
 	struct ocfs2_control_private *p = file->private_data;
 	struct ocfs2_protocol_version *max =
-		&ocfs2_user_plugin.sp_proto->lp_max_version;
+		&ocfs2_user_plugin.sp_max_proto;
 
 	if (ocfs2_control_get_handshake_state(file) !=
 	    OCFS2_CONTROL_HANDSHAKE_PROTOCOL)
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 010ecab..fc184c7 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -176,7 +176,7 @@ int ocfs2_stack_glue_register(struct ocfs2_stack_plugin *plugin)
 	spin_lock(&ocfs2_stack_lock);
 	if (!ocfs2_stack_lookup(plugin->sp_name)) {
 		plugin->sp_count = 0;
-		plugin->sp_proto = lproto;
+		plugin->sp_max_proto = lproto->lp_max_version;
 		list_add(&plugin->sp_list, &ocfs2_stack_list);
 		printk(KERN_INFO "ocfs2: Registered cluster interface %s\n",
 		       plugin->sp_name);
@@ -224,7 +224,7 @@ void ocfs2_stack_glue_set_locking_protocol(struct ocfs2_locking_protocol *proto)
 
 	lproto = proto;
 	list_for_each_entry(p, &ocfs2_stack_list, sp_list) {
-		p->sp_proto = lproto;
+		p->sp_max_proto = lproto->lp_max_version;
 	}
 
 	spin_unlock(&ocfs2_stack_lock);
diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
index cf8bac2..77a7a9a 100644
--- a/fs/ocfs2/stackglue.h
+++ b/fs/ocfs2/stackglue.h
@@ -233,7 +233,7 @@ struct ocfs2_stack_plugin {
 	/* These are managed by the stackglue code. */
 	struct list_head sp_list;
 	unsigned int sp_count;
-	struct ocfs2_locking_protocol *sp_proto;
+	struct ocfs2_protocol_version sp_max_proto;
 };
 
 
-- 
1.6.6.1
