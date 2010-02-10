From: Joel Becker <joel.becker@ORACLE.COM>
Date: Wed, 10 Feb 2010 01:27:47 -0800
Subject: [Ocfs2-devel] [PATCH 04/11] ocfs2: Pass lksbs back from stackglue
	ast/bast functions.
In-Reply-To: <1265794074-19539-1-git-send-email-joel.becker@oracle.com>
References: <1265794074-19539-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1265794074-19539-5-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org, mfasheh@suse.com

The stackglue ast and bast functions tried to maintain the fiction that
their arguments were void pointers.  In reality, stack_user.c had to
know that the argument was an ocfs2_lock_res in order to get the status
off of the lksb.  That's ugly.

This changes stackglue to always pass the lksb as the argument to ast
and bast functions.  The caller can always use container_of() to get the
ocfs2_lock_res or user_dlm_lock_res.  The net effect to the caller is
zero.  They still get back the lockres in their ast.  stackglue gets
cleaner, and now can use the lksb itself.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/dlmglue.c    |   34 +++++++++++++++++-----------------
 fs/ocfs2/stack_o2cb.c |   22 +++++++++++++---------
 fs/ocfs2/stack_user.c |   29 +++++++++++------------------
 fs/ocfs2/stackglue.c  |   19 ++++++++-----------
 fs/ocfs2/stackglue.h  |   42 +++++++++++++++++++++---------------------
 5 files changed, 70 insertions(+), 76 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index c5e4a49..28df5f7 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -297,6 +297,11 @@ static inline int ocfs2_is_inode_lock(struct ocfs2_lock_res *lockres)
 		lockres->l_type == OCFS2_LOCK_TYPE_OPEN;
 }
 
+static inline struct ocfs2_lock_res *ocfs2_lksb_to_lock_res(union ocfs2_dlm_lksb *lksb)
+{
+	return container_of(lksb, struct ocfs2_lock_res, l_lksb);
+}
+
 static inline struct inode *ocfs2_lock_res_inode(struct ocfs2_lock_res *lockres)
 {
 	BUG_ON(!ocfs2_is_inode_lock(lockres));
@@ -1032,9 +1037,9 @@ static unsigned int lockres_set_pending(struct ocfs2_lock_res *lockres)
 }
 
 
-static void ocfs2_blocking_ast(void *opaque, int level)
+static void ocfs2_blocking_ast(union ocfs2_dlm_lksb *lksb, int level)
 {
-	struct ocfs2_lock_res *lockres = opaque;
+	struct ocfs2_lock_res *lockres = ocfs2_lksb_to_lock_res(lksb);
 	struct ocfs2_super *osb = ocfs2_get_lockres_osb(lockres);
 	int needs_downconvert;
 	unsigned long flags;
@@ -1063,9 +1068,9 @@ static void ocfs2_blocking_ast(void *opaque, int level)
 	ocfs2_wake_downconvert_thread(osb);
 }
 
-static void ocfs2_locking_ast(void *opaque)
+static void ocfs2_locking_ast(union ocfs2_dlm_lksb *lksb)
 {
-	struct ocfs2_lock_res *lockres = opaque;
+	struct ocfs2_lock_res *lockres = ocfs2_lksb_to_lock_res(lksb);
 	struct ocfs2_super *osb = ocfs2_get_lockres_osb(lockres);
 	unsigned long flags;
 	int status;
@@ -1179,8 +1184,7 @@ static int ocfs2_lock_create(struct ocfs2_super *osb,
 			     &lockres->l_lksb,
 			     dlm_flags,
 			     lockres->l_name,
-			     OCFS2_LOCK_ID_MAX_LEN - 1,
-			     lockres);
+			     OCFS2_LOCK_ID_MAX_LEN - 1);
 	lockres_clear_pending(lockres, gen, osb);
 	if (ret) {
 		ocfs2_log_dlm_error("ocfs2_dlm_lock", ret, lockres);
@@ -1392,8 +1396,7 @@ again:
 				     &lockres->l_lksb,
 				     lkm_flags,
 				     lockres->l_name,
-				     OCFS2_LOCK_ID_MAX_LEN - 1,
-				     lockres);
+				     OCFS2_LOCK_ID_MAX_LEN - 1);
 		lockres_clear_pending(lockres, gen, osb);
 		if (ret) {
 			if (!(lkm_flags & DLM_LKF_NOQUEUE) ||
@@ -1827,8 +1830,7 @@ int ocfs2_file_lock(struct file *file, int ex, int trylock)
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
 
 	ret = ocfs2_dlm_lock(osb->cconn, level, &lockres->l_lksb, lkm_flags,
-			     lockres->l_name, OCFS2_LOCK_ID_MAX_LEN - 1,
-			     lockres);
+			     lockres->l_name, OCFS2_LOCK_ID_MAX_LEN - 1);
 	if (ret) {
 		if (!trylock || (ret != -EAGAIN)) {
 			ocfs2_log_dlm_error("ocfs2_dlm_lock", ret, lockres);
@@ -3024,9 +3026,9 @@ void ocfs2_dlm_shutdown(struct ocfs2_super *osb,
 	mlog_exit_void();
 }
 
-static void ocfs2_unlock_ast(void *opaque, int error)
+static void ocfs2_unlock_ast(union ocfs2_dlm_lksb *lksb, int error)
 {
-	struct ocfs2_lock_res *lockres = opaque;
+	struct ocfs2_lock_res *lockres = ocfs2_lksb_to_lock_res(lksb);
 	unsigned long flags;
 
 	mlog_entry_void();
@@ -3135,8 +3137,7 @@ static int ocfs2_drop_lock(struct ocfs2_super *osb,
 
 	mlog(0, "lock %s\n", lockres->l_name);
 
-	ret = ocfs2_dlm_unlock(osb->cconn, &lockres->l_lksb, lkm_flags,
-			       lockres);
+	ret = ocfs2_dlm_unlock(osb->cconn, &lockres->l_lksb, lkm_flags);
 	if (ret) {
 		ocfs2_log_dlm_error("ocfs2_dlm_unlock", ret, lockres);
 		mlog(ML_ERROR, "lockres flags: %lu\n", lockres->l_flags);
@@ -3277,8 +3278,7 @@ static int ocfs2_downconvert_lock(struct ocfs2_super *osb,
 			     &lockres->l_lksb,
 			     dlm_flags,
 			     lockres->l_name,
-			     OCFS2_LOCK_ID_MAX_LEN - 1,
-			     lockres);
+			     OCFS2_LOCK_ID_MAX_LEN - 1);
 	lockres_clear_pending(lockres, generation, osb);
 	if (ret) {
 		ocfs2_log_dlm_error("ocfs2_dlm_lock", ret, lockres);
@@ -3333,7 +3333,7 @@ static int ocfs2_cancel_convert(struct ocfs2_super *osb,
 	mlog(0, "lock %s\n", lockres->l_name);
 
 	ret = ocfs2_dlm_unlock(osb->cconn, &lockres->l_lksb,
-			       DLM_LKF_CANCEL, lockres);
+			       DLM_LKF_CANCEL);
 	if (ret) {
 		ocfs2_log_dlm_error("ocfs2_dlm_unlock", ret, lockres);
 		ocfs2_recover_from_dlm_error(lockres, 0);
diff --git a/fs/ocfs2/stack_o2cb.c b/fs/ocfs2/stack_o2cb.c
index e49c410..e26a789 100644
--- a/fs/ocfs2/stack_o2cb.c
+++ b/fs/ocfs2/stack_o2cb.c
@@ -161,20 +161,26 @@ static int dlm_status_to_errno(enum dlm_status status)
 
 static void o2dlm_lock_ast_wrapper(void *astarg)
 {
+	union ocfs2_dlm_lksb *lksb = astarg;
+
 	BUG_ON(o2cb_stack.sp_proto == NULL);
 
-	o2cb_stack.sp_proto->lp_lock_ast(astarg);
+	o2cb_stack.sp_proto->lp_lock_ast(lksb);
 }
 
 static void o2dlm_blocking_ast_wrapper(void *astarg, int level)
 {
+	union ocfs2_dlm_lksb *lksb = astarg;
+
 	BUG_ON(o2cb_stack.sp_proto == NULL);
 
-	o2cb_stack.sp_proto->lp_blocking_ast(astarg, level);
+	o2cb_stack.sp_proto->lp_blocking_ast(lksb, level);
 }
 
 static void o2dlm_unlock_ast_wrapper(void *astarg, enum dlm_status status)
 {
+	union ocfs2_dlm_lksb *lksb = astarg;
+
 	int error = dlm_status_to_errno(status);
 
 	BUG_ON(o2cb_stack.sp_proto == NULL);
@@ -193,7 +199,7 @@ static void o2dlm_unlock_ast_wrapper(void *astarg, enum dlm_status status)
 	if (status == DLM_CANCELGRANT)
 		return;
 
-	o2cb_stack.sp_proto->lp_unlock_ast(astarg, error);
+	o2cb_stack.sp_proto->lp_unlock_ast(lksb, error);
 }
 
 static int o2cb_dlm_lock(struct ocfs2_cluster_connection *conn,
@@ -201,8 +207,7 @@ static int o2cb_dlm_lock(struct ocfs2_cluster_connection *conn,
 			 union ocfs2_dlm_lksb *lksb,
 			 u32 flags,
 			 void *name,
-			 unsigned int namelen,
-			 void *astarg)
+			 unsigned int namelen)
 {
 	enum dlm_status status;
 	int o2dlm_mode = mode_to_o2dlm(mode);
@@ -211,7 +216,7 @@ static int o2cb_dlm_lock(struct ocfs2_cluster_connection *conn,
 
 	status = dlmlock(conn->cc_lockspace, o2dlm_mode, &lksb->lksb_o2dlm,
 			 o2dlm_flags, name, namelen,
-			 o2dlm_lock_ast_wrapper, astarg,
+			 o2dlm_lock_ast_wrapper, lksb,
 			 o2dlm_blocking_ast_wrapper);
 	ret = dlm_status_to_errno(status);
 	return ret;
@@ -219,15 +224,14 @@ static int o2cb_dlm_lock(struct ocfs2_cluster_connection *conn,
 
 static int o2cb_dlm_unlock(struct ocfs2_cluster_connection *conn,
 			   union ocfs2_dlm_lksb *lksb,
-			   u32 flags,
-			   void *astarg)
+			   u32 flags)
 {
 	enum dlm_status status;
 	int o2dlm_flags = flags_to_o2dlm(flags);
 	int ret;
 
 	status = dlmunlock(conn->cc_lockspace, &lksb->lksb_o2dlm,
-			   o2dlm_flags, o2dlm_unlock_ast_wrapper, astarg);
+			   o2dlm_flags, o2dlm_unlock_ast_wrapper, lksb);
 	ret = dlm_status_to_errno(status);
 	return ret;
 }
diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index da78a2a..129b931 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -25,7 +25,6 @@
 #include <linux/reboot.h>
 #include <asm/uaccess.h>
 
-#include "ocfs2.h"  /* For struct ocfs2_lock_res */
 #include "stackglue.h"
 
 #include <linux/dlm_plock.h>
@@ -664,16 +663,10 @@ static void ocfs2_control_exit(void)
 		       -rc);
 }
 
-static struct dlm_lksb *fsdlm_astarg_to_lksb(void *astarg)
-{
-	struct ocfs2_lock_res *res = astarg;
-	return &res->l_lksb.lksb_fsdlm;
-}
-
 static void fsdlm_lock_ast_wrapper(void *astarg)
 {
-	struct dlm_lksb *lksb = fsdlm_astarg_to_lksb(astarg);
-	int status = lksb->sb_status;
+	union ocfs2_dlm_lksb *lksb = astarg;
+	int status = lksb->lksb_fsdlm.sb_status;
 
 	BUG_ON(ocfs2_user_plugin.sp_proto == NULL);
 
@@ -688,16 +681,18 @@ static void fsdlm_lock_ast_wrapper(void *astarg)
 	 */
 
 	if (status == -DLM_EUNLOCK || status == -DLM_ECANCEL)
-		ocfs2_user_plugin.sp_proto->lp_unlock_ast(astarg, 0);
+		ocfs2_user_plugin.sp_proto->lp_unlock_ast(lksb, 0);
 	else
-		ocfs2_user_plugin.sp_proto->lp_lock_ast(astarg);
+		ocfs2_user_plugin.sp_proto->lp_lock_ast(lksb);
 }
 
 static void fsdlm_blocking_ast_wrapper(void *astarg, int level)
 {
+	union ocfs2_dlm_lksb *lksb = astarg;
+
 	BUG_ON(ocfs2_user_plugin.sp_proto == NULL);
 
-	ocfs2_user_plugin.sp_proto->lp_blocking_ast(astarg, level);
+	ocfs2_user_plugin.sp_proto->lp_blocking_ast(lksb, level);
 }
 
 static int user_dlm_lock(struct ocfs2_cluster_connection *conn,
@@ -705,8 +700,7 @@ static int user_dlm_lock(struct ocfs2_cluster_connection *conn,
 			 union ocfs2_dlm_lksb *lksb,
 			 u32 flags,
 			 void *name,
-			 unsigned int namelen,
-			 void *astarg)
+			 unsigned int namelen)
 {
 	int ret;
 
@@ -716,20 +710,19 @@ static int user_dlm_lock(struct ocfs2_cluster_connection *conn,
 
 	ret = dlm_lock(conn->cc_lockspace, mode, &lksb->lksb_fsdlm,
 		       flags|DLM_LKF_NODLCKWT, name, namelen, 0,
-		       fsdlm_lock_ast_wrapper, astarg,
+		       fsdlm_lock_ast_wrapper, lksb,
 		       fsdlm_blocking_ast_wrapper);
 	return ret;
 }
 
 static int user_dlm_unlock(struct ocfs2_cluster_connection *conn,
 			   union ocfs2_dlm_lksb *lksb,
-			   u32 flags,
-			   void *astarg)
+			   u32 flags)
 {
 	int ret;
 
 	ret = dlm_unlock(conn->cc_lockspace, lksb->lksb_fsdlm.sb_lkid,
-			 flags, &lksb->lksb_fsdlm, astarg);
+			 flags, &lksb->lksb_fsdlm, lksb);
 	return ret;
 }
 
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index f3df0ba..3500d98 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -233,35 +233,32 @@ EXPORT_SYMBOL_GPL(ocfs2_stack_glue_set_locking_protocol);
 
 
 /*
- * The ocfs2_dlm_lock() and ocfs2_dlm_unlock() functions take
- * "struct ocfs2_lock_res *astarg" instead of "void *astarg" because the
- * underlying stack plugins need to pilfer the lksb off of the lock_res.
- * If some other structure needs to be passed as an astarg, the plugins
- * will need to be given a different avenue to the lksb.
+ * The ocfs2_dlm_lock() and ocfs2_dlm_unlock() functions take no argument
+ * for the ast and bast functions.  They will pass the lksb to the ast
+ * and bast.  The caller can wrap the lksb with their own structure to
+ * get more information.
  */
 int ocfs2_dlm_lock(struct ocfs2_cluster_connection *conn,
 		   int mode,
 		   union ocfs2_dlm_lksb *lksb,
 		   u32 flags,
 		   void *name,
-		   unsigned int namelen,
-		   struct ocfs2_lock_res *astarg)
+		   unsigned int namelen)
 {
 	BUG_ON(lproto == NULL);
 
 	return active_stack->sp_ops->dlm_lock(conn, mode, lksb, flags,
-					      name, namelen, astarg);
+					      name, namelen);
 }
 EXPORT_SYMBOL_GPL(ocfs2_dlm_lock);
 
 int ocfs2_dlm_unlock(struct ocfs2_cluster_connection *conn,
 		     union ocfs2_dlm_lksb *lksb,
-		     u32 flags,
-		     struct ocfs2_lock_res *astarg)
+		     u32 flags)
 {
 	BUG_ON(lproto == NULL);
 
-	return active_stack->sp_ops->dlm_unlock(conn, lksb, flags, astarg);
+	return active_stack->sp_ops->dlm_unlock(conn, lksb, flags);
 }
 EXPORT_SYMBOL_GPL(ocfs2_dlm_unlock);
 
diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
index 03a44d6..d699117 100644
--- a/fs/ocfs2/stackglue.h
+++ b/fs/ocfs2/stackglue.h
@@ -56,17 +56,6 @@ struct ocfs2_protocol_version {
 };
 
 /*
- * The ocfs2_locking_protocol defines the handlers called on ocfs2's behalf.
- */
-struct ocfs2_locking_protocol {
-	struct ocfs2_protocol_version lp_max_version;
-	void (*lp_lock_ast)(void *astarg);
-	void (*lp_blocking_ast)(void *astarg, int level);
-	void (*lp_unlock_ast)(void *astarg, int error);
-};
-
-
-/*
  * The dlm_lockstatus struct includes lvb space, but the dlm_lksb struct only
  * has a pointer to separately allocated lvb space.  This struct exists only to
  * include in the lksb union to make space for a combined dlm_lksb and lvb.
@@ -88,6 +77,17 @@ union ocfs2_dlm_lksb {
 };
 
 /*
+ * The ocfs2_locking_protocol defines the handlers called on ocfs2's behalf.
+ */
+struct ocfs2_locking_protocol {
+	struct ocfs2_protocol_version lp_max_version;
+	void (*lp_lock_ast)(union ocfs2_dlm_lksb *lksb);
+	void (*lp_blocking_ast)(union ocfs2_dlm_lksb *lksb, int level);
+	void (*lp_unlock_ast)(union ocfs2_dlm_lksb *lksb, int error);
+};
+
+
+/*
  * A cluster connection.  Mostly opaque to ocfs2, the connection holds
  * state for the underlying stack.  ocfs2 does use cc_version to determine
  * locking compatibility.
@@ -155,27 +155,29 @@ struct ocfs2_stack_operations {
 	 *
 	 * ast and bast functions are not part of the call because the
 	 * stack will likely want to wrap ast and bast calls before passing
-	 * them to stack->sp_proto.
+	 * them to stack->sp_proto.  There is no astarg.  The lksb will
+	 * be passed back to the ast and bast functions.  The caller can
+	 * use this to find their object.
 	 */
 	int (*dlm_lock)(struct ocfs2_cluster_connection *conn,
 			int mode,
 			union ocfs2_dlm_lksb *lksb,
 			u32 flags,
 			void *name,
-			unsigned int namelen,
-			void *astarg);
+			unsigned int namelen);
 
 	/*
 	 * Call the underlying dlm unlock function.  The ->dlm_unlock()
 	 * function should convert the flags as appropriate.
 	 *
 	 * The unlock ast is not passed, as the stack will want to wrap
-	 * it before calling stack->sp_proto->lp_unlock_ast().
+	 * it before calling stack->sp_proto->lp_unlock_ast().  There is
+	 * no astarg.  The lksb will be passed back to the unlock ast
+	 * function.  The caller can use this to find their object.
 	 */
 	int (*dlm_unlock)(struct ocfs2_cluster_connection *conn,
 			  union ocfs2_dlm_lksb *lksb,
-			  u32 flags,
-			  void *astarg);
+			  u32 flags);
 
 	/*
 	 * Return the status of the current lock status block.  The fs
@@ -249,12 +251,10 @@ int ocfs2_dlm_lock(struct ocfs2_cluster_connection *conn,
 		   union ocfs2_dlm_lksb *lksb,
 		   u32 flags,
 		   void *name,
-		   unsigned int namelen,
-		   struct ocfs2_lock_res *astarg);
+		   unsigned int namelen);
 int ocfs2_dlm_unlock(struct ocfs2_cluster_connection *conn,
 		     union ocfs2_dlm_lksb *lksb,
-		     u32 flags,
-		     struct ocfs2_lock_res *astarg);
+		     u32 flags);
 
 int ocfs2_dlm_lock_status(union ocfs2_dlm_lksb *lksb);
 int ocfs2_dlm_lvb_valid(union ocfs2_dlm_lksb *lksb);
-- 
1.6.6.1
