From: Joel Becker <joel.becker@oracle.com>
Date: Thu,  4 Feb 2010 16:54:58 -0800
Subject: [Ocfs2-devel] [PATCH 05/10] ocfs2: Attach the connection to the lksb
In-Reply-To: <1265331303-19881-1-git-send-email-joel.becker@oracle.com>
References: <1265331303-19881-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1265331303-19881-6-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org, mfasheh@suse.com

We're going to want it in the ast functions, so we convert union
ocfs2_dlm_lksb to struct ocfs2_dlm_lksb and let it carry the connection.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/dlmglue.c    |    8 ++++----
 fs/ocfs2/ocfs2.h      |    2 +-
 fs/ocfs2/stack_o2cb.c |   18 +++++++++---------
 fs/ocfs2/stack_user.c |   16 ++++++++--------
 fs/ocfs2/stackglue.c  |   17 +++++++++++------
 fs/ocfs2/stackglue.h  |   42 +++++++++++++++++++++++-------------------
 6 files changed, 56 insertions(+), 47 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 28df5f7..4cb3ac2 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -297,7 +297,7 @@ static inline int ocfs2_is_inode_lock(struct ocfs2_lock_res *lockres)
 		lockres->l_type == OCFS2_LOCK_TYPE_OPEN;
 }
 
-static inline struct ocfs2_lock_res *ocfs2_lksb_to_lock_res(union ocfs2_dlm_lksb *lksb)
+static inline struct ocfs2_lock_res *ocfs2_lksb_to_lock_res(struct ocfs2_dlm_lksb *lksb)
 {
 	return container_of(lksb, struct ocfs2_lock_res, l_lksb);
 }
@@ -1037,7 +1037,7 @@ static unsigned int lockres_set_pending(struct ocfs2_lock_res *lockres)
 }
 
 
-static void ocfs2_blocking_ast(union ocfs2_dlm_lksb *lksb, int level)
+static void ocfs2_blocking_ast(struct ocfs2_dlm_lksb *lksb, int level)
 {
 	struct ocfs2_lock_res *lockres = ocfs2_lksb_to_lock_res(lksb);
 	struct ocfs2_super *osb = ocfs2_get_lockres_osb(lockres);
@@ -1068,7 +1068,7 @@ static void ocfs2_blocking_ast(union ocfs2_dlm_lksb *lksb, int level)
 	ocfs2_wake_downconvert_thread(osb);
 }
 
-static void ocfs2_locking_ast(union ocfs2_dlm_lksb *lksb)
+static void ocfs2_locking_ast(struct ocfs2_dlm_lksb *lksb)
 {
 	struct ocfs2_lock_res *lockres = ocfs2_lksb_to_lock_res(lksb);
 	struct ocfs2_super *osb = ocfs2_get_lockres_osb(lockres);
@@ -3026,7 +3026,7 @@ void ocfs2_dlm_shutdown(struct ocfs2_super *osb,
 	mlog_exit_void();
 }
 
-static void ocfs2_unlock_ast(union ocfs2_dlm_lksb *lksb, int error)
+static void ocfs2_unlock_ast(struct ocfs2_dlm_lksb *lksb, int error)
 {
 	struct ocfs2_lock_res *lockres = ocfs2_lksb_to_lock_res(lksb);
 	unsigned long flags;
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 9362eea..5413f6c 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -155,7 +155,7 @@ struct ocfs2_lock_res {
 	int                      l_level;
 	unsigned int             l_ro_holders;
 	unsigned int             l_ex_holders;
-	union ocfs2_dlm_lksb     l_lksb;
+	struct ocfs2_dlm_lksb    l_lksb;
 
 	/* used from AST/BAST funcs. */
 	enum ocfs2_ast_action    l_action;
diff --git a/fs/ocfs2/stack_o2cb.c b/fs/ocfs2/stack_o2cb.c
index e26a789..41e6bad 100644
--- a/fs/ocfs2/stack_o2cb.c
+++ b/fs/ocfs2/stack_o2cb.c
@@ -161,7 +161,7 @@ static int dlm_status_to_errno(enum dlm_status status)
 
 static void o2dlm_lock_ast_wrapper(void *astarg)
 {
-	union ocfs2_dlm_lksb *lksb = astarg;
+	struct ocfs2_dlm_lksb *lksb = astarg;
 
 	BUG_ON(o2cb_stack.sp_proto == NULL);
 
@@ -170,7 +170,7 @@ static void o2dlm_lock_ast_wrapper(void *astarg)
 
 static void o2dlm_blocking_ast_wrapper(void *astarg, int level)
 {
-	union ocfs2_dlm_lksb *lksb = astarg;
+	struct ocfs2_dlm_lksb *lksb = astarg;
 
 	BUG_ON(o2cb_stack.sp_proto == NULL);
 
@@ -179,7 +179,7 @@ static void o2dlm_blocking_ast_wrapper(void *astarg, int level)
 
 static void o2dlm_unlock_ast_wrapper(void *astarg, enum dlm_status status)
 {
-	union ocfs2_dlm_lksb *lksb = astarg;
+	struct ocfs2_dlm_lksb *lksb = astarg;
 
 	int error = dlm_status_to_errno(status);
 
@@ -204,7 +204,7 @@ static void o2dlm_unlock_ast_wrapper(void *astarg, enum dlm_status status)
 
 static int o2cb_dlm_lock(struct ocfs2_cluster_connection *conn,
 			 int mode,
-			 union ocfs2_dlm_lksb *lksb,
+			 struct ocfs2_dlm_lksb *lksb,
 			 u32 flags,
 			 void *name,
 			 unsigned int namelen)
@@ -223,7 +223,7 @@ static int o2cb_dlm_lock(struct ocfs2_cluster_connection *conn,
 }
 
 static int o2cb_dlm_unlock(struct ocfs2_cluster_connection *conn,
-			   union ocfs2_dlm_lksb *lksb,
+			   struct ocfs2_dlm_lksb *lksb,
 			   u32 flags)
 {
 	enum dlm_status status;
@@ -236,7 +236,7 @@ static int o2cb_dlm_unlock(struct ocfs2_cluster_connection *conn,
 	return ret;
 }
 
-static int o2cb_dlm_lock_status(union ocfs2_dlm_lksb *lksb)
+static int o2cb_dlm_lock_status(struct ocfs2_dlm_lksb *lksb)
 {
 	return dlm_status_to_errno(lksb->lksb_o2dlm.status);
 }
@@ -246,17 +246,17 @@ static int o2cb_dlm_lock_status(union ocfs2_dlm_lksb *lksb)
  * contents, it will zero out the LVB.  Thus the caller can always trust
  * the contents.
  */
-static int o2cb_dlm_lvb_valid(union ocfs2_dlm_lksb *lksb)
+static int o2cb_dlm_lvb_valid(struct ocfs2_dlm_lksb *lksb)
 {
 	return 1;
 }
 
-static void *o2cb_dlm_lvb(union ocfs2_dlm_lksb *lksb)
+static void *o2cb_dlm_lvb(struct ocfs2_dlm_lksb *lksb)
 {
 	return (void *)(lksb->lksb_o2dlm.lvb);
 }
 
-static void o2cb_dump_lksb(union ocfs2_dlm_lksb *lksb)
+static void o2cb_dump_lksb(struct ocfs2_dlm_lksb *lksb)
 {
 	dlm_print_one_lock(lksb->lksb_o2dlm.lockid);
 }
diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index 129b931..31276ba 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -665,7 +665,7 @@ static void ocfs2_control_exit(void)
 
 static void fsdlm_lock_ast_wrapper(void *astarg)
 {
-	union ocfs2_dlm_lksb *lksb = astarg;
+	struct ocfs2_dlm_lksb *lksb = astarg;
 	int status = lksb->lksb_fsdlm.sb_status;
 
 	BUG_ON(ocfs2_user_plugin.sp_proto == NULL);
@@ -688,7 +688,7 @@ static void fsdlm_lock_ast_wrapper(void *astarg)
 
 static void fsdlm_blocking_ast_wrapper(void *astarg, int level)
 {
-	union ocfs2_dlm_lksb *lksb = astarg;
+	struct ocfs2_dlm_lksb *lksb = astarg;
 
 	BUG_ON(ocfs2_user_plugin.sp_proto == NULL);
 
@@ -697,7 +697,7 @@ static void fsdlm_blocking_ast_wrapper(void *astarg, int level)
 
 static int user_dlm_lock(struct ocfs2_cluster_connection *conn,
 			 int mode,
-			 union ocfs2_dlm_lksb *lksb,
+			 struct ocfs2_dlm_lksb *lksb,
 			 u32 flags,
 			 void *name,
 			 unsigned int namelen)
@@ -716,7 +716,7 @@ static int user_dlm_lock(struct ocfs2_cluster_connection *conn,
 }
 
 static int user_dlm_unlock(struct ocfs2_cluster_connection *conn,
-			   union ocfs2_dlm_lksb *lksb,
+			   struct ocfs2_dlm_lksb *lksb,
 			   u32 flags)
 {
 	int ret;
@@ -726,19 +726,19 @@ static int user_dlm_unlock(struct ocfs2_cluster_connection *conn,
 	return ret;
 }
 
-static int user_dlm_lock_status(union ocfs2_dlm_lksb *lksb)
+static int user_dlm_lock_status(struct ocfs2_dlm_lksb *lksb)
 {
 	return lksb->lksb_fsdlm.sb_status;
 }
 
-static int user_dlm_lvb_valid(union ocfs2_dlm_lksb *lksb)
+static int user_dlm_lvb_valid(struct ocfs2_dlm_lksb *lksb)
 {
 	int invalid = lksb->lksb_fsdlm.sb_flags & DLM_SBF_VALNOTVALID;
 
 	return !invalid;
 }
 
-static void *user_dlm_lvb(union ocfs2_dlm_lksb *lksb)
+static void *user_dlm_lvb(struct ocfs2_dlm_lksb *lksb)
 {
 	if (!lksb->lksb_fsdlm.sb_lvbptr)
 		lksb->lksb_fsdlm.sb_lvbptr = (char *)lksb +
@@ -746,7 +746,7 @@ static void *user_dlm_lvb(union ocfs2_dlm_lksb *lksb)
 	return (void *)(lksb->lksb_fsdlm.sb_lvbptr);
 }
 
-static void user_dlm_dump_lksb(union ocfs2_dlm_lksb *lksb)
+static void user_dlm_dump_lksb(struct ocfs2_dlm_lksb *lksb)
 {
 }
 
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 3500d98..8ef9a57 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -240,47 +240,52 @@ EXPORT_SYMBOL_GPL(ocfs2_stack_glue_set_locking_protocol);
  */
 int ocfs2_dlm_lock(struct ocfs2_cluster_connection *conn,
 		   int mode,
-		   union ocfs2_dlm_lksb *lksb,
+		   struct ocfs2_dlm_lksb *lksb,
 		   u32 flags,
 		   void *name,
 		   unsigned int namelen)
 {
 	BUG_ON(lproto == NULL);
 
+	if (!lksb->lksb_conn)
+		lksb->lksb_conn = conn;
+	else
+		BUG_ON(lksb->lksb_conn != conn);
 	return active_stack->sp_ops->dlm_lock(conn, mode, lksb, flags,
 					      name, namelen);
 }
 EXPORT_SYMBOL_GPL(ocfs2_dlm_lock);
 
 int ocfs2_dlm_unlock(struct ocfs2_cluster_connection *conn,
-		     union ocfs2_dlm_lksb *lksb,
+		     struct ocfs2_dlm_lksb *lksb,
 		     u32 flags)
 {
 	BUG_ON(lproto == NULL);
+	BUG_ON(lksb->lksb_conn == NULL);
 
 	return active_stack->sp_ops->dlm_unlock(conn, lksb, flags);
 }
 EXPORT_SYMBOL_GPL(ocfs2_dlm_unlock);
 
-int ocfs2_dlm_lock_status(union ocfs2_dlm_lksb *lksb)
+int ocfs2_dlm_lock_status(struct ocfs2_dlm_lksb *lksb)
 {
 	return active_stack->sp_ops->lock_status(lksb);
 }
 EXPORT_SYMBOL_GPL(ocfs2_dlm_lock_status);
 
-int ocfs2_dlm_lvb_valid(union ocfs2_dlm_lksb *lksb)
+int ocfs2_dlm_lvb_valid(struct ocfs2_dlm_lksb *lksb)
 {
 	return active_stack->sp_ops->lvb_valid(lksb);
 }
 EXPORT_SYMBOL_GPL(ocfs2_dlm_lvb_valid);
 
-void *ocfs2_dlm_lvb(union ocfs2_dlm_lksb *lksb)
+void *ocfs2_dlm_lvb(struct ocfs2_dlm_lksb *lksb)
 {
 	return active_stack->sp_ops->lock_lvb(lksb);
 }
 EXPORT_SYMBOL_GPL(ocfs2_dlm_lvb);
 
-void ocfs2_dlm_dump_lksb(union ocfs2_dlm_lksb *lksb)
+void ocfs2_dlm_dump_lksb(struct ocfs2_dlm_lksb *lksb)
 {
 	active_stack->sp_ops->dump_lksb(lksb);
 }
diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
index d699117..bb32926 100644
--- a/fs/ocfs2/stackglue.h
+++ b/fs/ocfs2/stackglue.h
@@ -70,10 +70,14 @@ struct fsdlm_lksb_plus_lvb {
  * size of the union is known.  Lock status structures are embedded in
  * ocfs2 inodes.
  */
-union ocfs2_dlm_lksb {
-	struct dlm_lockstatus lksb_o2dlm;
-	struct dlm_lksb lksb_fsdlm;
-	struct fsdlm_lksb_plus_lvb padding;
+struct ocfs2_cluster_connection;
+struct ocfs2_dlm_lksb {
+	 union {
+		 struct dlm_lockstatus lksb_o2dlm;
+		 struct dlm_lksb lksb_fsdlm;
+		 struct fsdlm_lksb_plus_lvb padding;
+	 };
+	 struct ocfs2_cluster_connection *lksb_conn;
 };
 
 /*
@@ -81,9 +85,9 @@ union ocfs2_dlm_lksb {
  */
 struct ocfs2_locking_protocol {
 	struct ocfs2_protocol_version lp_max_version;
-	void (*lp_lock_ast)(union ocfs2_dlm_lksb *lksb);
-	void (*lp_blocking_ast)(union ocfs2_dlm_lksb *lksb, int level);
-	void (*lp_unlock_ast)(union ocfs2_dlm_lksb *lksb, int error);
+	void (*lp_lock_ast)(struct ocfs2_dlm_lksb *lksb);
+	void (*lp_blocking_ast)(struct ocfs2_dlm_lksb *lksb, int level);
+	void (*lp_unlock_ast)(struct ocfs2_dlm_lksb *lksb, int error);
 };
 
 
@@ -161,7 +165,7 @@ struct ocfs2_stack_operations {
 	 */
 	int (*dlm_lock)(struct ocfs2_cluster_connection *conn,
 			int mode,
-			union ocfs2_dlm_lksb *lksb,
+			struct ocfs2_dlm_lksb *lksb,
 			u32 flags,
 			void *name,
 			unsigned int namelen);
@@ -176,7 +180,7 @@ struct ocfs2_stack_operations {
 	 * function.  The caller can use this to find their object.
 	 */
 	int (*dlm_unlock)(struct ocfs2_cluster_connection *conn,
-			  union ocfs2_dlm_lksb *lksb,
+			  struct ocfs2_dlm_lksb *lksb,
 			  u32 flags);
 
 	/*
@@ -185,17 +189,17 @@ struct ocfs2_stack_operations {
 	 * callback pulls out the stack-specific lksb, converts the status
 	 * to a proper errno, and returns it.
 	 */
-	int (*lock_status)(union ocfs2_dlm_lksb *lksb);
+	int (*lock_status)(struct ocfs2_dlm_lksb *lksb);
 
 	/*
 	 * Return non-zero if the LVB is valid.
 	 */
-	int (*lvb_valid)(union ocfs2_dlm_lksb *lksb);
+	int (*lvb_valid)(struct ocfs2_dlm_lksb *lksb);
 
 	/*
 	 * Pull the lvb pointer off of the stack-specific lksb.
 	 */
-	void *(*lock_lvb)(union ocfs2_dlm_lksb *lksb);
+	void *(*lock_lvb)(struct ocfs2_dlm_lksb *lksb);
 
 	/*
 	 * Cluster-aware posix locks
@@ -212,7 +216,7 @@ struct ocfs2_stack_operations {
 	 * This is an optoinal debugging hook.  If provided, the
 	 * stack can dump debugging information about this lock.
 	 */
-	void (*dump_lksb)(union ocfs2_dlm_lksb *lksb);
+	void (*dump_lksb)(struct ocfs2_dlm_lksb *lksb);
 };
 
 /*
@@ -248,18 +252,18 @@ int ocfs2_cluster_this_node(unsigned int *node);
 struct ocfs2_lock_res;
 int ocfs2_dlm_lock(struct ocfs2_cluster_connection *conn,
 		   int mode,
-		   union ocfs2_dlm_lksb *lksb,
+		   struct ocfs2_dlm_lksb *lksb,
 		   u32 flags,
 		   void *name,
 		   unsigned int namelen);
 int ocfs2_dlm_unlock(struct ocfs2_cluster_connection *conn,
-		     union ocfs2_dlm_lksb *lksb,
+		     struct ocfs2_dlm_lksb *lksb,
 		     u32 flags);
 
-int ocfs2_dlm_lock_status(union ocfs2_dlm_lksb *lksb);
-int ocfs2_dlm_lvb_valid(union ocfs2_dlm_lksb *lksb);
-void *ocfs2_dlm_lvb(union ocfs2_dlm_lksb *lksb);
-void ocfs2_dlm_dump_lksb(union ocfs2_dlm_lksb *lksb);
+int ocfs2_dlm_lock_status(struct ocfs2_dlm_lksb *lksb);
+int ocfs2_dlm_lvb_valid(struct ocfs2_dlm_lksb *lksb);
+void *ocfs2_dlm_lvb(struct ocfs2_dlm_lksb *lksb);
+void ocfs2_dlm_dump_lksb(struct ocfs2_dlm_lksb *lksb);
 
 int ocfs2_stack_supports_plocks(void);
 int ocfs2_plock(struct ocfs2_cluster_connection *conn, u64 ino,
-- 
1.6.6.1
