From: Adrian Bunk <bunk@kernel.org>
Date: Wed, 21 May 2008 01:55:09 +0300
Subject: [Ocfs2-devel] [2.6 patch] ocfs2: rename user_stack{,_ops}
Message-ID: <20080520225509.GD16264@cs181133002.pp.htv.fi>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On frv and ia64 asm/ptrace.h offers a different user_stack resulting in 
compile errors like the following:

<--  snip  -->

...
  CC [M]  fs/ocfs2/stack_user.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/ocfs2/stack_user.c:156: error: 'user_stack' redeclared as different kind of symbol
include2/asm/ptrace.h:77: error: previous declaration of 'user_stack' was here
make[3]: *** [fs/ocfs2/stack_user.o] Error 1

<--  snip  -->

This patch therefore prefixes the user_stack{,_ops} names with ocfs2_

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/ocfs2/stack_user.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

9f35919bf336d4861500c364ed567bd309543868 diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index b503772..4037126 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -61,7 +61,7 @@
  * negotiated by the client.  The client negotiates based on the maximum
  * version advertised in /sys/fs/ocfs2/max_locking_protocol.  The major
  * number from the "SETV" message must match
- * user_stack.sp_proto->lp_max_version.pv_major, and the minor number
+ * ocfs2_user_stack.sp_proto->lp_max_version.pv_major, and the minor number
  * must be less than or equal to ...->lp_max_version.pv_minor.
  *
  * Once this information has been set, mounts will be allowed.  From this
@@ -153,7 +153,7 @@ union ocfs2_control_message {
 	struct ocfs2_control_message_down	u_down;
 };
 
-static struct ocfs2_stack_plugin user_stack;
+static struct ocfs2_stack_plugin ocfs2_user_stack;
 
 static atomic_t ocfs2_control_opened;
 static int ocfs2_control_this_node = -1;
@@ -399,7 +399,7 @@ static int ocfs2_control_do_setversion_msg(struct file *file,
 	char *ptr = NULL;
 	struct ocfs2_control_private *p = file->private_data;
 	struct ocfs2_protocol_version *max =
-		&user_stack.sp_proto->lp_max_version;
+		&ocfs2_user_stack.sp_proto->lp_max_version;
 
 	if (ocfs2_control_get_handshake_state(file) !=
 	    OCFS2_CONTROL_HANDSHAKE_PROTOCOL)
@@ -680,7 +680,7 @@ static void fsdlm_lock_ast_wrapper(void *astarg)
 	struct dlm_lksb *lksb = fsdlm_astarg_to_lksb(astarg);
 	int status = lksb->sb_status;
 
-	BUG_ON(user_stack.sp_proto == NULL);
+	BUG_ON(ocfs2_user_stack.sp_proto == NULL);
 
 	/*
 	 * For now we're punting on the issue of other non-standard errors
@@ -693,16 +693,16 @@ static void fsdlm_lock_ast_wrapper(void *astarg)
 	 */
 
 	if (status == -DLM_EUNLOCK || status == -DLM_ECANCEL)
-		user_stack.sp_proto->lp_unlock_ast(astarg, 0);
+		ocfs2_user_stack.sp_proto->lp_unlock_ast(astarg, 0);
 	else
-		user_stack.sp_proto->lp_lock_ast(astarg);
+		ocfs2_user_stack.sp_proto->lp_lock_ast(astarg);
 }
 
 static void fsdlm_blocking_ast_wrapper(void *astarg, int level)
 {
-	BUG_ON(user_stack.sp_proto == NULL);
+	BUG_ON(ocfs2_user_stack.sp_proto == NULL);
 
-	user_stack.sp_proto->lp_blocking_ast(astarg, level);
+	ocfs2_user_stack.sp_proto->lp_blocking_ast(astarg, level);
 }
 
 static int user_dlm_lock(struct ocfs2_cluster_connection *conn,
@@ -838,7 +838,7 @@ static int user_cluster_this_node(unsigned int *this_node)
 	return 0;
 }
 
-static struct ocfs2_stack_operations user_stack_ops = {
+static struct ocfs2_stack_operations ocfs2_user_stack_ops = {
 	.connect	= user_cluster_connect,
 	.disconnect	= user_cluster_disconnect,
 	.this_node	= user_cluster_this_node,
@@ -849,9 +849,9 @@ static struct ocfs2_stack_operations user_stack_ops = {
 	.dump_lksb	= user_dlm_dump_lksb,
 };
 
-static struct ocfs2_stack_plugin user_stack = {
+static struct ocfs2_stack_plugin ocfs2_user_stack = {
 	.sp_name	= "user",
-	.sp_ops		= &user_stack_ops,
+	.sp_ops		= &ocfs2_user_stack_ops,
 	.sp_owner	= THIS_MODULE,
 };
 
@@ -862,7 +862,7 @@ static int __init user_stack_init(void)
 
 	rc = ocfs2_control_init();
 	if (!rc) {
-		rc = ocfs2_stack_glue_register(&user_stack);
+		rc = ocfs2_stack_glue_register(&ocfs2_user_stack);
 		if (rc)
 			ocfs2_control_exit();
 	}
@@ -872,7 +872,7 @@ static int __init user_stack_init(void)
 
 static void __exit user_stack_exit(void)
 {
-	ocfs2_stack_glue_unregister(&user_stack);
+	ocfs2_stack_glue_unregister(&ocfs2_user_stack);
 	ocfs2_control_exit();
 }
 
