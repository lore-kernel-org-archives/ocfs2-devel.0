From: Mark Fasheh <mfasheh@suse.com>
Date: Wed,  2 Apr 2008 13:14:42 -0700
Subject: [Ocfs2-devel] [PATCH 32/62] ocfs2: add fsdlm to stackglue
In-Reply-To: <12071673821008-git-send-email-mfasheh@suse.com>
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
	<12071673772233-git-send-email-mfasheh@suse.com>
	<1207167379283-git-send-email-mfasheh@suse.com>
	<12071673821008-git-send-email-mfasheh@suse.com>
Message-ID: <12071673843208-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, David Teigland <teigland@redhat.com>

From: David Teigland <teigland@redhat.com>

Add code to use fs/dlm.

[ Modified to be part of the stack_user module -- Joel ]

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/stack_user.c |  216 ++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ocfs2/stackglue.c  |   14 +++-
 fs/ocfs2/stackglue.h  |   19 ++++-
 3 files changed, 243 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index de982c1..7428663 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -24,6 +24,7 @@
 #include <linux/reboot.h>
 #include <asm/uaccess.h>
 
+#include "ocfs2.h"  /* For struct ocfs2_lock_res */
 #include "stackglue.h"
 
 
@@ -152,6 +153,8 @@ union ocfs2_control_message {
 	struct ocfs2_control_message_down	u_down;
 };
 
+static struct ocfs2_stack_plugin user_stack;
+
 static atomic_t ocfs2_control_opened;
 static int ocfs2_control_this_node = -1;
 static struct ocfs2_protocol_version running_proto;
@@ -344,6 +347,20 @@ out_unlock:
 	return rc;
 }
 
+static int ocfs2_control_get_this_node(void)
+{
+	int rc;
+
+	mutex_lock(&ocfs2_control_lock);
+	if (ocfs2_control_this_node < 0)
+		rc = -EINVAL;
+	else
+		rc = ocfs2_control_this_node;
+	mutex_unlock(&ocfs2_control_lock);
+
+	return rc;
+}
+
 static int ocfs2_control_do_setnode_msg(struct file *file,
 					struct ocfs2_control_message_setn *msg)
 {
@@ -652,13 +669,210 @@ static void ocfs2_control_exit(void)
 		       -rc);
 }
 
+static struct dlm_lksb *fsdlm_astarg_to_lksb(void *astarg)
+{
+	struct ocfs2_lock_res *res = astarg;
+	return &res->l_lksb.lksb_fsdlm;
+}
+
+static void fsdlm_lock_ast_wrapper(void *astarg)
+{
+	struct dlm_lksb *lksb = fsdlm_astarg_to_lksb(astarg);
+	int status = lksb->sb_status;
+
+	BUG_ON(user_stack.sp_proto == NULL);
+
+	/*
+	 * For now we're punting on the issue of other non-standard errors
+	 * where we can't tell if the unlock_ast or lock_ast should be called.
+	 * The main "other error" that's possible is EINVAL which means the
+	 * function was called with invalid args, which shouldn't be possible
+	 * since the caller here is under our control.  Other non-standard
+	 * errors probably fall into the same category, or otherwise are fatal
+	 * which means we can't carry on anyway.
+	 */
+
+	if (status == -DLM_EUNLOCK || status == -DLM_ECANCEL)
+		user_stack.sp_proto->lp_unlock_ast(astarg, 0);
+	else
+		user_stack.sp_proto->lp_lock_ast(astarg);
+}
+
+static void fsdlm_blocking_ast_wrapper(void *astarg, int level)
+{
+	BUG_ON(user_stack.sp_proto == NULL);
+
+	user_stack.sp_proto->lp_blocking_ast(astarg, level);
+}
+
+static int user_dlm_lock(struct ocfs2_cluster_connection *conn,
+			 int mode,
+			 union ocfs2_dlm_lksb *lksb,
+			 u32 flags,
+			 void *name,
+			 unsigned int namelen,
+			 void *astarg)
+{
+	int ret;
+
+	if (!lksb->lksb_fsdlm.sb_lvbptr)
+		lksb->lksb_fsdlm.sb_lvbptr = (char *)lksb +
+					     sizeof(struct dlm_lksb);
+
+	ret = dlm_lock(conn->cc_lockspace, mode, &lksb->lksb_fsdlm,
+		       flags|DLM_LKF_NODLCKWT, name, namelen, 0,
+		       fsdlm_lock_ast_wrapper, astarg,
+		       fsdlm_blocking_ast_wrapper);
+	return ret;
+}
+
+static int user_dlm_unlock(struct ocfs2_cluster_connection *conn,
+			   union ocfs2_dlm_lksb *lksb,
+			   u32 flags,
+			   void *astarg)
+{
+	int ret;
+
+	ret = dlm_unlock(conn->cc_lockspace, lksb->lksb_fsdlm.sb_lkid,
+			 flags, &lksb->lksb_fsdlm, astarg);
+	return ret;
+}
+
+static int user_dlm_lock_status(union ocfs2_dlm_lksb *lksb)
+{
+	return lksb->lksb_fsdlm.sb_status;
+}
+
+static void *user_dlm_lvb(union ocfs2_dlm_lksb *lksb)
+{
+	return (void *)(lksb->lksb_fsdlm.sb_lvbptr);
+}
+
+static void user_dlm_dump_lksb(union ocfs2_dlm_lksb *lksb)
+{
+}
+
+/*
+ * Compare a requested locking protocol version against the current one.
+ *
+ * If the major numbers are different, they are incompatible.
+ * If the current minor is greater than the request, they are incompatible.
+ * If the current minor is less than or equal to the request, they are
+ * compatible, and the requester should run at the current minor version.
+ */
+static int fs_protocol_compare(struct ocfs2_protocol_version *existing,
+			       struct ocfs2_protocol_version *request)
+{
+	if (existing->pv_major != request->pv_major)
+		return 1;
+
+	if (existing->pv_minor > request->pv_minor)
+		return 1;
+
+	if (existing->pv_minor < request->pv_minor)
+		request->pv_minor = existing->pv_minor;
+
+	return 0;
+}
+
+static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
+{
+	dlm_lockspace_t *fsdlm;
+	struct ocfs2_live_connection *control;
+	int rc = 0;
+
+	BUG_ON(conn == NULL);
+
+	rc = ocfs2_live_connection_new(conn, &control);
+	if (rc)
+		goto out;
+
+	/*
+	 * running_proto must have been set before we allowed any mounts
+	 * to proceed.
+	 */
+	if (fs_protocol_compare(&running_proto, &conn->cc_version)) {
+		printk(KERN_ERR
+		       "Unable to mount with fs locking protocol version "
+		       "%u.%u because the userspace control daemon has "
+		       "negotiated %u.%u\n",
+		       conn->cc_version.pv_major, conn->cc_version.pv_minor,
+		       running_proto.pv_major, running_proto.pv_minor);
+		rc = -EPROTO;
+		ocfs2_live_connection_drop(control);
+		goto out;
+	}
+
+	rc = dlm_new_lockspace(conn->cc_name, strlen(conn->cc_name),
+			       &fsdlm, DLM_LSFL_FS, DLM_LVB_LEN);
+	if (rc) {
+		ocfs2_live_connection_drop(control);
+		goto out;
+	}
+
+	conn->cc_private = control;
+	conn->cc_lockspace = fsdlm;
+out:
+	return rc;
+}
+
+static int user_cluster_disconnect(struct ocfs2_cluster_connection *conn,
+				   int hangup_pending)
+{
+	dlm_release_lockspace(conn->cc_lockspace, 2);
+	conn->cc_lockspace = NULL;
+	ocfs2_live_connection_drop(conn->cc_private);
+	conn->cc_private = NULL;
+	return 0;
+}
+
+static int user_cluster_this_node(unsigned int *this_node)
+{
+	int rc;
+
+	rc = ocfs2_control_get_this_node();
+	if (rc < 0)
+		return rc;
+
+	*this_node = rc;
+	return 0;
+}
+
+static struct ocfs2_stack_operations user_stack_ops = {
+	.connect	= user_cluster_connect,
+	.disconnect	= user_cluster_disconnect,
+	.this_node	= user_cluster_this_node,
+	.dlm_lock	= user_dlm_lock,
+	.dlm_unlock	= user_dlm_unlock,
+	.lock_status	= user_dlm_lock_status,
+	.lock_lvb	= user_dlm_lvb,
+	.dump_lksb	= user_dlm_dump_lksb,
+};
+
+static struct ocfs2_stack_plugin user_stack = {
+	.sp_name	= "user",
+	.sp_ops		= &user_stack_ops,
+	.sp_owner	= THIS_MODULE,
+};
+
+
 static int __init user_stack_init(void)
 {
-	return ocfs2_control_init();
+	int rc;
+
+	rc = ocfs2_control_init();
+	if (!rc) {
+		rc = ocfs2_stack_glue_register(&user_stack);
+		if (rc)
+			ocfs2_control_exit();
+	}
+
+	return rc;
 }
 
 static void __exit user_stack_exit(void)
 {
+	ocfs2_stack_glue_unregister(&user_stack);
 	ocfs2_control_exit();
 }
 
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index bf45d9b..119f60c 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -228,13 +228,20 @@ void ocfs2_stack_glue_set_locking_protocol(struct ocfs2_locking_protocol *proto)
 EXPORT_SYMBOL_GPL(ocfs2_stack_glue_set_locking_protocol);
 
 
+/*
+ * The ocfs2_dlm_lock() and ocfs2_dlm_unlock() functions take
+ * "struct ocfs2_lock_res *astarg" instead of "void *astarg" because the
+ * underlying stack plugins need to pilfer the lksb off of the lock_res.
+ * If some other structure needs to be passed as an astarg, the plugins
+ * will need to be given a different avenue to the lksb.
+ */
 int ocfs2_dlm_lock(struct ocfs2_cluster_connection *conn,
 		   int mode,
 		   union ocfs2_dlm_lksb *lksb,
 		   u32 flags,
 		   void *name,
 		   unsigned int namelen,
-		   void *astarg)
+		   struct ocfs2_lock_res *astarg)
 {
 	BUG_ON(lproto == NULL);
 
@@ -246,7 +253,7 @@ EXPORT_SYMBOL_GPL(ocfs2_dlm_lock);
 int ocfs2_dlm_unlock(struct ocfs2_cluster_connection *conn,
 		     union ocfs2_dlm_lksb *lksb,
 		     u32 flags,
-		     void *astarg)
+		     struct ocfs2_lock_res *astarg)
 {
 	BUG_ON(lproto == NULL);
 
@@ -360,7 +367,8 @@ void ocfs2_cluster_hangup(const char *group, int grouplen)
 	BUG_ON(group == NULL);
 	BUG_ON(group[grouplen] != '\0');
 
-	active_stack->sp_ops->hangup(group, grouplen);
+	if (active_stack->sp_ops->hangup)
+		active_stack->sp_ops->hangup(group, grouplen);
 
 	/* cluster_disconnect() was called with hangup_pending==1 */
 	ocfs2_stack_driver_put();
diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
index d88bc65..005e4f1 100644
--- a/fs/ocfs2/stackglue.h
+++ b/fs/ocfs2/stackglue.h
@@ -26,6 +26,7 @@
 #include <linux/dlmconstants.h>
 
 #include "dlm/dlmapi.h"
+#include <linux/dlm.h>
 
 /*
  * dlmconstants.h does not have a LOCAL flag.  We hope to remove it
@@ -60,6 +61,17 @@ struct ocfs2_locking_protocol {
 	void (*lp_unlock_ast)(void *astarg, int error);
 };
 
+
+/*
+ * The dlm_lockstatus struct includes lvb space, but the dlm_lksb struct only
+ * has a pointer to separately allocated lvb space.  This struct exists only to
+ * include in the lksb union to make space for a combined dlm_lksb and lvb.
+ */
+struct fsdlm_lksb_plus_lvb {
+	struct dlm_lksb lksb;
+	char lvb[DLM_LVB_LEN];
+};
+
 /*
  * A union of all lock status structures.  We define it here so that the
  * size of the union is known.  Lock status structures are embedded in
@@ -67,6 +79,8 @@ struct ocfs2_locking_protocol {
  */
 union ocfs2_dlm_lksb {
 	struct dlm_lockstatus lksb_o2dlm;
+	struct dlm_lksb lksb_fsdlm;
+	struct fsdlm_lksb_plus_lvb padding;
 };
 
 /*
@@ -221,17 +235,18 @@ int ocfs2_cluster_disconnect(struct ocfs2_cluster_connection *conn,
 void ocfs2_cluster_hangup(const char *group, int grouplen);
 int ocfs2_cluster_this_node(unsigned int *node);
 
+struct ocfs2_lock_res;
 int ocfs2_dlm_lock(struct ocfs2_cluster_connection *conn,
 		   int mode,
 		   union ocfs2_dlm_lksb *lksb,
 		   u32 flags,
 		   void *name,
 		   unsigned int namelen,
-		   void *astarg);
+		   struct ocfs2_lock_res *astarg);
 int ocfs2_dlm_unlock(struct ocfs2_cluster_connection *conn,
 		     union ocfs2_dlm_lksb *lksb,
 		     u32 flags,
-		     void *astarg);
+		     struct ocfs2_lock_res *astarg);
 
 int ocfs2_dlm_lock_status(union ocfs2_dlm_lksb *lksb);
 void *ocfs2_dlm_lvb(union ocfs2_dlm_lksb *lksb);
-- 
1.5.4.1
