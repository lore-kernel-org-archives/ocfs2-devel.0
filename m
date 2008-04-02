From: Mark Fasheh <mfasheh@suse.com>
Date: Wed,  2 Apr 2008 13:14:21 -0700
Subject: [Ocfs2-devel] [PATCH 11/62] ocfs2: Create the lock status block
	union.
In-Reply-To: <12071673391031-git-send-email-mfasheh@suse.com>
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
Message-ID: <12071673413492-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>

From: Joel Becker <joel.becker@oracle.com>

Wrap the lock status block (lksb) in a union.  Later we will add a union
element for the fs/dlm lksb.  Create accessors for the status and lvb
fields.

Other than a debugging function, dlmglue.c does not directly reference
the o2dlm locking path anymore.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dlmglue.c   |   23 +++++++++++++----------
 fs/ocfs2/ocfs2.h     |    5 +++--
 fs/ocfs2/stackglue.c |   29 ++++++++++++++++++++++-------
 fs/ocfs2/stackglue.h |   11 +++++++++--
 4 files changed, 47 insertions(+), 21 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 6a222a5..4590376 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -112,7 +112,8 @@ static void ocfs2_dump_meta_lvb_info(u64 level,
 				     unsigned int line,
 				     struct ocfs2_lock_res *lockres)
 {
-	struct ocfs2_meta_lvb *lvb = (struct ocfs2_meta_lvb *) lockres->l_lksb.lvb;
+	struct ocfs2_meta_lvb *lvb =
+		(struct ocfs2_meta_lvb *)ocfs2_dlm_lvb(&lockres->l_lksb);
 
 	mlog(level, "LVB information for %s (called from %s:%u):\n",
 	     lockres->l_name, function, line);
@@ -799,14 +800,14 @@ static void ocfs2_blocking_ast(void *opaque, int level)
 static void ocfs2_locking_ast(void *opaque)
 {
 	struct ocfs2_lock_res *lockres = opaque;
-	struct dlm_lockstatus *lksb = &lockres->l_lksb;
 	unsigned long flags;
 
 	spin_lock_irqsave(&lockres->l_lock, flags);
 
-	if (lksb->status != DLM_NORMAL) {
-		mlog(ML_ERROR, "lockres %s: lksb status value of %u!\n",
-		     lockres->l_name, lksb->status);
+	if (ocfs2_dlm_lock_status(&lockres->l_lksb)) {
+		mlog(ML_ERROR, "lockres %s: lksb status value of %d!\n",
+		     lockres->l_name,
+		     ocfs2_dlm_lock_status(&lockres->l_lksb));
 		spin_unlock_irqrestore(&lockres->l_lock, flags);
 		return;
 	}
@@ -1634,7 +1635,7 @@ static void __ocfs2_stuff_meta_lvb(struct inode *inode)
 
 	mlog_entry_void();
 
-	lvb = (struct ocfs2_meta_lvb *) lockres->l_lksb.lvb;
+	lvb = (struct ocfs2_meta_lvb *)ocfs2_dlm_lvb(&lockres->l_lksb);
 
 	/*
 	 * Invalidate the LVB of a deleted inode - this way other
@@ -1686,7 +1687,7 @@ static void ocfs2_refresh_inode_from_lvb(struct inode *inode)
 
 	mlog_meta_lvb(0, lockres);
 
-	lvb = (struct ocfs2_meta_lvb *) lockres->l_lksb.lvb;
+	lvb = (struct ocfs2_meta_lvb *)ocfs2_dlm_lvb(&lockres->l_lksb);
 
 	/* We're safe here without the lockres lock... */
 	spin_lock(&oi->ip_lock);
@@ -1721,7 +1722,8 @@ static void ocfs2_refresh_inode_from_lvb(struct inode *inode)
 static inline int ocfs2_meta_lvb_is_trustable(struct inode *inode,
 					      struct ocfs2_lock_res *lockres)
 {
-	struct ocfs2_meta_lvb *lvb = (struct ocfs2_meta_lvb *) lockres->l_lksb.lvb;
+	struct ocfs2_meta_lvb *lvb =
+		(struct ocfs2_meta_lvb *)ocfs2_dlm_lvb(&lockres->l_lksb);
 
 	if (lvb->lvb_version == OCFS2_LVB_VERSION
 	    && be32_to_cpu(lvb->lvb_igeneration) == inode->i_generation)
@@ -2379,7 +2381,7 @@ static int ocfs2_dlm_seq_show(struct seq_file *m, void *v)
 		   lockres->l_blocking);
 
 	/* Dump the raw LVB */
-	lvb = lockres->l_lksb.lvb;
+	lvb = ocfs2_dlm_lvb(&lockres->l_lksb);
 	for(i = 0; i < DLM_LVB_LEN; i++)
 		seq_printf(m, "0x%x\t", lvb[i]);
 
@@ -2692,7 +2694,8 @@ static int ocfs2_drop_lock(struct ocfs2_super *osb,
 	if (ret) {
 		ocfs2_log_dlm_error("ocfs2_dlm_unlock", ret, lockres);
 		mlog(ML_ERROR, "lockres flags: %lu\n", lockres->l_flags);
-		dlm_print_one_lock(lockres->l_lksb.lockid);
+		/* XXX Need to abstract this */
+		dlm_print_one_lock(lockres->l_lksb.lksb_o2dlm.lockid);
 		BUG();
 	}
 	mlog(0, "lock %s, successfull return from ocfs2_dlm_unlock\n",
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index f78e9ed..6d7c6d2 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -40,7 +40,8 @@
 #include "cluster/heartbeat.h"
 #include "cluster/tcp.h"
 
-#include "dlm/dlmapi.h"
+/* For union ocfs2_dlm_lksb */
+#include "stackglue.h"
 
 #include "ocfs2_fs.h"
 #include "ocfs2_lockid.h"
@@ -120,7 +121,7 @@ struct ocfs2_lock_res {
 	int                      l_level;
 	unsigned int             l_ro_holders;
 	unsigned int             l_ex_holders;
-	struct dlm_lockstatus    l_lksb;
+	union ocfs2_dlm_lksb     l_lksb;
 
 	/* used from AST/BAST funcs. */
 	enum ocfs2_ast_action    l_action;
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 0aec2fc..eb88854 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -199,7 +199,7 @@ static void o2dlm_unlock_ast_wrapper(void *astarg, enum dlm_status status)
 
 int ocfs2_dlm_lock(struct dlm_ctxt *dlm,
 		   int mode,
-		   struct dlm_lockstatus *lksb,
+		   union ocfs2_dlm_lksb *lksb,
 		   u32 flags,
 		   void *name,
 		   unsigned int namelen,
@@ -212,15 +212,16 @@ int ocfs2_dlm_lock(struct dlm_ctxt *dlm,
 
 	BUG_ON(lproto == NULL);
 
-	status = dlmlock(dlm, o2dlm_mode, lksb, o2dlm_flags, name, namelen,
-		       o2dlm_lock_ast_wrapper, astarg,
-		       o2dlm_blocking_ast_wrapper);
+	status = dlmlock(dlm, o2dlm_mode, &lksb->lksb_o2dlm, o2dlm_flags,
+			 name, namelen,
+			 o2dlm_lock_ast_wrapper, astarg,
+			 o2dlm_blocking_ast_wrapper);
 	ret = dlm_status_to_errno(status);
 	return ret;
 }
 
 int ocfs2_dlm_unlock(struct dlm_ctxt *dlm,
-		     struct dlm_lockstatus *lksb,
+		     union ocfs2_dlm_lksb *lksb,
 		     u32 flags,
 		     void *astarg)
 {
@@ -230,12 +231,26 @@ int ocfs2_dlm_unlock(struct dlm_ctxt *dlm,
 
 	BUG_ON(lproto == NULL);
 
-	status = dlmunlock(dlm, lksb, o2dlm_flags,
-			 o2dlm_unlock_ast_wrapper, astarg);
+	status = dlmunlock(dlm, &lksb->lksb_o2dlm, o2dlm_flags,
+			   o2dlm_unlock_ast_wrapper, astarg);
 	ret = dlm_status_to_errno(status);
 	return ret;
 }
 
+int ocfs2_dlm_lock_status(union ocfs2_dlm_lksb *lksb)
+{
+	return dlm_status_to_errno(lksb->lksb_o2dlm.status);
+}
+
+/*
+ * Why don't we cast to ocfs2_meta_lvb?  The "clean" answer is that we
+ * don't cast at the glue level.  The real answer is that the header
+ * ordering is nigh impossible.
+ */
+void *ocfs2_dlm_lvb(union ocfs2_dlm_lksb *lksb)
+{
+	return (void *)(lksb->lksb_o2dlm.lvb);
+}
 
 void o2cb_get_stack(struct ocfs2_locking_protocol *proto)
 {
diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
index 8ebcfba..3c91e24 100644
--- a/fs/ocfs2/stackglue.h
+++ b/fs/ocfs2/stackglue.h
@@ -40,18 +40,25 @@ struct ocfs2_locking_protocol {
 	void (*lp_unlock_ast)(void *astarg, int error);
 };
 
+union ocfs2_dlm_lksb {
+	struct dlm_lockstatus lksb_o2dlm;
+};
+
 int ocfs2_dlm_lock(struct dlm_ctxt *dlm,
 		   int mode,
-		   struct dlm_lockstatus *lksb,
+		   union ocfs2_dlm_lksb *lksb,
 		   u32 flags,
 		   void *name,
 		   unsigned int namelen,
 		   void *astarg);
 int ocfs2_dlm_unlock(struct dlm_ctxt *dlm,
-		     struct dlm_lockstatus *lksb,
+		     union ocfs2_dlm_lksb *lksb,
 		     u32 flags,
 		     void *astarg);
 
+int ocfs2_dlm_lock_status(union ocfs2_dlm_lksb *lksb);
+void *ocfs2_dlm_lvb(union ocfs2_dlm_lksb *lksb);
+
 void o2cb_get_stack(struct ocfs2_locking_protocol *proto);
 void o2cb_put_stack(void);
 
-- 
1.5.4.1
