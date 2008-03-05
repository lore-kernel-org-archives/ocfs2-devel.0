From: Joel Becker <joel.becker@oracle.com>
Date: Wed Mar  5 16:28:30 2008
Subject: [Ocfs2-devel] [PATCH 01/18] ocfs2: Separate out dlm lock functions.
In-Reply-To: <1204763261-28025-1-git-send-email-joel.becker@oracle.com>
References: <1204763261-28025-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1204763261-28025-2-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, mark.fasheh@oracle.com

This is the first in a series of patches to isolate ocfs2 from the
underlying cluster stack. Here we wrap the dlm locking functions with
ocfs2-specific calls. Because ocfs2 always uses the same dlm lock status
callbacks, we can eliminate the callbacks from the filesystem visible
functions.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/Makefile    |    1 +
 fs/ocfs2/dlmglue.c   |  110 +++++++++++++++++++++++++++----------------------
 fs/ocfs2/dlmglue.h   |    3 +
 fs/ocfs2/stackglue.c |   65 +++++++++++++++++++++++++++++
 fs/ocfs2/stackglue.h |   45 ++++++++++++++++++++
 fs/ocfs2/super.c     |    4 ++
 6 files changed, 179 insertions(+), 49 deletions(-)
 create mode 100644 fs/ocfs2/stackglue.c
 create mode 100644 fs/ocfs2/stackglue.h

diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 4d4ce48..3ba64af 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -24,6 +24,7 @@ ocfs2-objs := \
 	namei.o 		\
 	resize.o		\
 	slot_map.o 		\
+	stackglue.o		\
 	suballoc.o 		\
 	super.o 		\
 	symlink.o 		\
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index b4108fe..1320410 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -53,6 +53,7 @@
 #include "heartbeat.h"
 #include "inode.h"
 #include "journal.h"
+#include "stackglue.h"
 #include "slot_map.h"
 #include "super.h"
 #include "uptodate.h"
@@ -888,22 +889,21 @@ static int ocfs2_lock_create(struct ocfs2_super *osb,
 	lockres_or_flags(lockres, OCFS2_LOCK_BUSY);
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
 
-	status = dlmlock(osb->dlm,
-			 level,
-			 &lockres->l_lksb,
-			 dlm_flags,
-			 lockres->l_name,
-			 OCFS2_LOCK_ID_MAX_LEN - 1,
-			 ocfs2_locking_ast,
-			 lockres,
-			 ocfs2_blocking_ast);
+	status = ocfs2_dlm_lock(osb->dlm,
+				level,
+				&lockres->l_lksb,
+				dlm_flags,
+				lockres->l_name,
+				OCFS2_LOCK_ID_MAX_LEN - 1,
+				lockres);
 	if (status != DLM_NORMAL) {
-		ocfs2_log_dlm_error("dlmlock", status, lockres);
+		ocfs2_log_dlm_error("ocfs2_dlm_lock", status, lockres);
 		ret = -EINVAL;
 		ocfs2_recover_from_dlm_error(lockres, 1);
 	}
 
-	mlog(0, "lock %s, successfull return from dlmlock\n", lockres->l_name);
+	mlog(0, "lock %s, successfull return from ocfs2_dlm_lock\n",
+	     lockres->l_name);
 
 bail:
 	mlog_exit(ret);
@@ -1091,29 +1091,27 @@ again:
 		     lockres->l_name, lockres->l_level, level);
 
 		/* call dlm_lock to upgrade lock now */
-		status = dlmlock(osb->dlm,
-				 level,
-				 &lockres->l_lksb,
-				 lkm_flags,
-				 lockres->l_name,
-				 OCFS2_LOCK_ID_MAX_LEN - 1,
-				 ocfs2_locking_ast,
-				 lockres,
-				 ocfs2_blocking_ast);
+		status = ocfs2_dlm_lock(osb->dlm,
+					level,
+					&lockres->l_lksb,
+					lkm_flags,
+					lockres->l_name,
+					OCFS2_LOCK_ID_MAX_LEN - 1,
+					lockres);
 		if (status != DLM_NORMAL) {
 			if ((lkm_flags & LKM_NOQUEUE) &&
 			    (status == DLM_NOTQUEUED))
 				ret = -EAGAIN;
 			else {
-				ocfs2_log_dlm_error("dlmlock", status,
-						    lockres);
+				ocfs2_log_dlm_error("ocfs2_dlm_lock",
+						    status, lockres);
 				ret = -EINVAL;
 			}
 			ocfs2_recover_from_dlm_error(lockres, 1);
 			goto out;
 		}
 
-		mlog(0, "lock %s, successfull return from dlmlock\n",
+		mlog(0, "lock %s, successfull return from ocfs2_dlm_lock\n",
 		     lockres->l_name);
 
 		/* At this point we've gone inside the dlm and need to
@@ -1503,14 +1501,14 @@ int ocfs2_file_lock(struct file *file, int ex, int trylock)
 	lockres_add_mask_waiter(lockres, &mw, OCFS2_LOCK_BUSY, 0);
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
 
-	ret = dlmlock(osb->dlm, level, &lockres->l_lksb, lkm_flags,
-		      lockres->l_name, OCFS2_LOCK_ID_MAX_LEN - 1,
-		      ocfs2_locking_ast, lockres, ocfs2_blocking_ast);
+	ret = ocfs2_dlm_lock(osb->dlm, level, &lockres->l_lksb, lkm_flags,
+			     lockres->l_name, OCFS2_LOCK_ID_MAX_LEN - 1,
+			     lockres);
 	if (ret != DLM_NORMAL) {
 		if (trylock && ret == DLM_NOTQUEUED)
 			ret = -EAGAIN;
 		else {
-			ocfs2_log_dlm_error("dlmlock", ret, lockres);
+			ocfs2_log_dlm_error("ocfs2_dlm_lock", ret, lockres);
 			ret = -EINVAL;
 		}
 
@@ -2699,15 +2697,15 @@ static int ocfs2_drop_lock(struct ocfs2_super *osb,
 
 	mlog(0, "lock %s\n", lockres->l_name);
 
-	status = dlmunlock(osb->dlm, &lockres->l_lksb, lkm_flags,
-			   ocfs2_unlock_ast, lockres);
+	status = ocfs2_dlm_unlock(osb->dlm, &lockres->l_lksb, lkm_flags,
+				  lockres);
 	if (status != DLM_NORMAL) {
-		ocfs2_log_dlm_error("dlmunlock", status, lockres);
+		ocfs2_log_dlm_error("ocfs2_dlm_unlock", status, lockres);
 		mlog(ML_ERROR, "lockres flags: %lu\n", lockres->l_flags);
 		dlm_print_one_lock(lockres->l_lksb.lockid);
 		BUG();
 	}
-	mlog(0, "lock %s, successfull return from dlmunlock\n",
+	mlog(0, "lock %s, successfull return from ocfs2_dlm_unlock\n",
 	     lockres->l_name);
 
 	ocfs2_wait_on_busy_lock(lockres);
@@ -2832,17 +2830,15 @@ static int ocfs2_downconvert_lock(struct ocfs2_super *osb,
 	if (lvb)
 		dlm_flags |= LKM_VALBLK;
 
-	status = dlmlock(osb->dlm,
-			 new_level,
-			 &lockres->l_lksb,
-			 dlm_flags,
-			 lockres->l_name,
-			 OCFS2_LOCK_ID_MAX_LEN - 1,
-			 ocfs2_locking_ast,
-			 lockres,
-			 ocfs2_blocking_ast);
+	status = ocfs2_dlm_lock(osb->dlm,
+				new_level,
+				&lockres->l_lksb,
+				dlm_flags,
+				lockres->l_name,
+				OCFS2_LOCK_ID_MAX_LEN - 1,
+				lockres);
 	if (status != DLM_NORMAL) {
-		ocfs2_log_dlm_error("dlmlock", status, lockres);
+		ocfs2_log_dlm_error("ocfs2_dlm_lock", status, lockres);
 		ret = -EINVAL;
 		ocfs2_recover_from_dlm_error(lockres, 1);
 		goto bail;
@@ -2854,7 +2850,7 @@ bail:
 	return ret;
 }
 
-/* returns 1 when the caller should unlock and call dlmunlock */
+/* returns 1 when the caller should unlock and call ocfs2_dlm_unlock */
 static int ocfs2_prepare_cancel_convert(struct ocfs2_super *osb,
 				        struct ocfs2_lock_res *lockres)
 {
@@ -2896,18 +2892,17 @@ static int ocfs2_cancel_convert(struct ocfs2_super *osb,
 	mlog(0, "lock %s\n", lockres->l_name);
 
 	ret = 0;
-	status = dlmunlock(osb->dlm,
-			   &lockres->l_lksb,
-			   LKM_CANCEL,
-			   ocfs2_unlock_ast,
-			   lockres);
+	status = ocfs2_dlm_unlock(osb->dlm,
+				  &lockres->l_lksb,
+				  LKM_CANCEL,
+				  lockres);
 	if (status != DLM_NORMAL) {
-		ocfs2_log_dlm_error("dlmunlock", status, lockres);
+		ocfs2_log_dlm_error("ocfs2_dlm_unlock", status, lockres);
 		ret = -EINVAL;
 		ocfs2_recover_from_dlm_error(lockres, 0);
 	}
 
-	mlog(0, "lock %s return from dlmunlock\n", lockres->l_name);
+	mlog(0, "lock %s return from ocfs2_dlm_unlock\n", lockres->l_name);
 
 	mlog_exit(ret);
 	return ret;
@@ -3211,6 +3206,23 @@ static int ocfs2_dentry_convert_worker(struct ocfs2_lock_res *lockres,
 	return UNBLOCK_CONTINUE_POST;
 }
 
+static struct ocfs2_locking_protocol lproto = {
+	.lp_lock_ast		= ocfs2_locking_ast,
+	.lp_blocking_ast	= ocfs2_blocking_ast,
+	.lp_unlock_ast		= ocfs2_unlock_ast,
+};
+
+/* This interface isn't the final one, hence the less-than-perfect names */
+void dlmglue_init_stack(void)
+{
+	o2cb_get_stack(&lproto);
+}
+
+void dlmglue_exit_stack(void)
+{
+	o2cb_put_stack();
+}
+
 static void ocfs2_process_blocked_lock(struct ocfs2_super *osb,
 				       struct ocfs2_lock_res *lockres)
 {
diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
index e3cf902..3238043 100644
--- a/fs/ocfs2/dlmglue.h
+++ b/fs/ocfs2/dlmglue.h
@@ -114,5 +114,8 @@ void ocfs2_wake_downconvert_thread(struct ocfs2_super *osb);
 struct ocfs2_dlm_debug *ocfs2_new_dlm_debug(void);
 void ocfs2_put_dlm_debug(struct ocfs2_dlm_debug *dlm_debug);
 
+void dlmglue_init_stack(void);
+void dlmglue_exit_stack(void);
+
 extern const struct dlm_protocol_version ocfs2_locking_protocol;
 #endif	/* DLMGLUE_H */
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
new file mode 100644
index 0000000..4f44f23
--- /dev/null
+++ b/fs/ocfs2/stackglue.c
@@ -0,0 +1,65 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * stackglue.c
+ *
+ * Code which implements an OCFS2 specific interface to underlying
+ * cluster stacks.
+ *
+ * Copyright (C) 2007 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation, version 2.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <linux/types.h>
+#include <linux/list.h>
+
+#include "dlm/dlmapi.h"
+
+#include "stackglue.h"
+
+static struct ocfs2_locking_protocol *lproto;
+
+enum dlm_status ocfs2_dlm_lock(struct dlm_ctxt *dlm,
+		   int mode,
+		   struct dlm_lockstatus *lksb,
+		   u32 flags,
+		   void *name,
+		   unsigned int namelen,
+		   void *astarg)
+{
+	BUG_ON(lproto == NULL);
+	return dlmlock(dlm, mode, lksb, flags, name, namelen,
+		       lproto->lp_lock_ast, astarg,
+		       lproto->lp_blocking_ast);
+}
+
+enum dlm_status ocfs2_dlm_unlock(struct dlm_ctxt *dlm,
+		     struct dlm_lockstatus *lksb,
+		     u32 flags,
+		     void *astarg)
+{
+	BUG_ON(lproto == NULL);
+
+	return dlmunlock(dlm, lksb, flags, lproto->lp_unlock_ast, astarg);
+}
+
+
+void o2cb_get_stack(struct ocfs2_locking_protocol *proto)
+{
+	BUG_ON(proto == NULL);
+
+	lproto = proto;
+}
+
+void o2cb_put_stack(void)
+{
+	lproto = NULL;
+}
diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
new file mode 100644
index 0000000..40a0024
--- /dev/null
+++ b/fs/ocfs2/stackglue.h
@@ -0,0 +1,45 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * stackglue.h
+ *
+ * Glue to the underlying cluster stack.
+ *
+ * Copyright (C) 2007 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation, version 2.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+
+#ifndef STACKGLUE_H
+#define STACKGLUE_H
+
+struct ocfs2_locking_protocol {
+	void (*lp_lock_ast)(void *astarg);
+	void (*lp_blocking_ast)(void *astarg, int level);
+	void (*lp_unlock_ast)(void *astarg, enum dlm_status status);
+};
+
+enum dlm_status ocfs2_dlm_lock(struct dlm_ctxt *dlm,
+		   int mode,
+		   struct dlm_lockstatus *lksb,
+		   u32 flags,
+		   void *name,
+		   unsigned int namelen,
+		   void *astarg);
+enum dlm_status ocfs2_dlm_unlock(struct dlm_ctxt *dlm,
+		     struct dlm_lockstatus *lksb,
+		     u32 flags,
+		     void *astarg);
+
+void o2cb_get_stack(struct ocfs2_locking_protocol *proto);
+void o2cb_put_stack(void);
+
+#endif  /* STACKGLUE_H */
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 1a4c7c7..c867546 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -933,6 +933,8 @@ static int __init ocfs2_init(void)
 
 	ocfs2_print_version();
 
+	dlmglue_init_stack();
+
 	status = init_ocfs2_uptodate_cache();
 	if (status < 0) {
 		mlog_errno(status);
@@ -988,6 +990,8 @@ static void __exit ocfs2_exit(void)
 
 	exit_ocfs2_uptodate_cache();
 
+	dlmglue_exit_stack();
+
 	mlog_exit_void();
 }
 
-- 
1.5.3.8
