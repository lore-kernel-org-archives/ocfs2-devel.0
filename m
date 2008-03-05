From: Joel Becker <joel.becker@oracle.com>
Date: Wed Mar  5 16:28:23 2008
Subject: [Ocfs2-devel] [PATCH 14/18] ocfs2: Create ocfs2_stack_operations
	and split out the o2cb stack.
In-Reply-To: <1204763261-28025-1-git-send-email-joel.becker@oracle.com>
References: <1204763261-28025-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1204763261-28025-15-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, mark.fasheh@oracle.com

Define the ocfs2_stack_operations structure.  Build o2cb_stack_ops from
all of the o2cb-specific stack functions.  Change the generic stack glue
functions to call the stack_ops instead of the o2cb functions directly.

The o2cb functions are moved to stack_o2cb.c.  The headers are cleaned up
to where only needed headers are included.

In this code, stackglue.c and stack_o2cb.c refer to some shared
extern variables.  When they become modules, that will change.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/Makefile     |    1 +
 fs/ocfs2/stack_o2cb.c |  395 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/stackglue.c  |  385 ++---------------------------------------------
 fs/ocfs2/stackglue.h  |  123 +++++++++++++++-
 4 files changed, 532 insertions(+), 372 deletions(-)
 create mode 100644 fs/ocfs2/stack_o2cb.c

diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 3ba64af..8e86195 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -25,6 +25,7 @@ ocfs2-objs := \
 	resize.o		\
 	slot_map.o 		\
 	stackglue.o		\
+	stack_o2cb.o		\
 	suballoc.o 		\
 	super.o 		\
 	symlink.o 		\
diff --git a/fs/ocfs2/stack_o2cb.c b/fs/ocfs2/stack_o2cb.c
new file mode 100644
index 0000000..c9bc354
--- /dev/null
+++ b/fs/ocfs2/stack_o2cb.c
@@ -0,0 +1,395 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * stack_o2cb.c
+ *
+ * Code which interfaces ocfs2 with the o2cb stack.
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
+#include <linux/crc32.h>
+#include <linux/kmod.h>
+
+/* Needed for AOP_TRUNCATED_PAGE in mlog_errno() */
+#include <linux/fs.h>
+
+#include "cluster/masklog.h"
+#include "cluster/nodemanager.h"
+#include "cluster/heartbeat.h"
+
+#include "stackglue.h"
+
+struct o2dlm_private {
+	struct dlm_eviction_cb op_eviction_cb;
+};
+
+/* These should be identical */
+#if (DLM_LOCK_IV != LKM_IVMODE)
+# error Lock modes do not match
+#endif
+#if (DLM_LOCK_NL != LKM_NLMODE)
+# error Lock modes do not match
+#endif
+#if (DLM_LOCK_CR != LKM_CRMODE)
+# error Lock modes do not match
+#endif
+#if (DLM_LOCK_CW != LKM_CWMODE)
+# error Lock modes do not match
+#endif
+#if (DLM_LOCK_PR != LKM_PRMODE)
+# error Lock modes do not match
+#endif
+#if (DLM_LOCK_PW != LKM_PWMODE)
+# error Lock modes do not match
+#endif
+#if (DLM_LOCK_EX != LKM_EXMODE)
+# error Lock modes do not match
+#endif
+static inline int mode_to_o2dlm(int mode)
+{
+	BUG_ON(mode > LKM_MAXMODE);
+
+	return mode;
+}
+
+#define map_flag(_generic, _o2dlm)		\
+	if (flags & (_generic)) {		\
+		flags &= ~(_generic);		\
+		o2dlm_flags |= (_o2dlm);	\
+	}
+static int flags_to_o2dlm(u32 flags)
+{
+	int o2dlm_flags = 0;
+
+	map_flag(DLM_LKF_NOQUEUE, LKM_NOQUEUE);
+	map_flag(DLM_LKF_CANCEL, LKM_CANCEL);
+	map_flag(DLM_LKF_CONVERT, LKM_CONVERT);
+	map_flag(DLM_LKF_VALBLK, LKM_VALBLK);
+	map_flag(DLM_LKF_IVVALBLK, LKM_INVVALBLK);
+	map_flag(DLM_LKF_ORPHAN, LKM_ORPHAN);
+	map_flag(DLM_LKF_FORCEUNLOCK, LKM_FORCE);
+	map_flag(DLM_LKF_TIMEOUT, LKM_TIMEOUT);
+	map_flag(DLM_LKF_LOCAL, LKM_LOCAL);
+
+	/* map_flag() should have cleared every flag passed in */
+	BUG_ON(flags != 0);
+
+	return o2dlm_flags;
+}
+#undef map_flag
+
+/*
+ * Map an o2dlm status to standard errno values.
+ *
+ * o2dlm only uses a handful of these, and returns even fewer to the
+ * caller. Still, we try to assign sane values to each error.
+ *
+ * The following value pairs have special meanings to dlmglue, thus
+ * the right hand side needs to stay unique - never duplicate the
+ * mapping elsewhere in the table!
+ *
+ * DLM_NORMAL:		0
+ * DLM_NOTQUEUED:	-EAGAIN
+ * DLM_CANCELGRANT:	-EBUSY
+ * DLM_CANCEL:		-DLM_ECANCEL
+ */
+/* Keep in sync with dlmapi.h */
+static int status_map[] = {
+	[DLM_NORMAL]			= 0,		/* Success */
+	[DLM_GRANTED]			= -EINVAL,
+	[DLM_DENIED]			= -EACCES,
+	[DLM_DENIED_NOLOCKS]		= -EACCES,
+	[DLM_WORKING]			= -EACCES,
+	[DLM_BLOCKED]			= -EINVAL,
+	[DLM_BLOCKED_ORPHAN]		= -EINVAL,
+	[DLM_DENIED_GRACE_PERIOD]	= -EACCES,
+	[DLM_SYSERR]			= -ENOMEM,	/* It is what it is */
+	[DLM_NOSUPPORT]			= -EPROTO,
+	[DLM_CANCELGRANT]		= -EBUSY,	/* Cancel after grant */
+	[DLM_IVLOCKID]			= -EINVAL,
+	[DLM_SYNC]			= -EINVAL,
+	[DLM_BADTYPE]			= -EINVAL,
+	[DLM_BADRESOURCE]		= -EINVAL,
+	[DLM_MAXHANDLES]		= -ENOMEM,
+	[DLM_NOCLINFO]			= -EINVAL,
+	[DLM_NOLOCKMGR]			= -EINVAL,
+	[DLM_NOPURGED]			= -EINVAL,
+	[DLM_BADARGS]			= -EINVAL,
+	[DLM_VOID]			= -EINVAL,
+	[DLM_NOTQUEUED]			= -EAGAIN,	/* Trylock failed */
+	[DLM_IVBUFLEN]			= -EINVAL,
+	[DLM_CVTUNGRANT]		= -EPERM,
+	[DLM_BADPARAM]			= -EINVAL,
+	[DLM_VALNOTVALID]		= -EINVAL,
+	[DLM_REJECTED]			= -EPERM,
+	[DLM_ABORT]			= -EINVAL,
+	[DLM_CANCEL]			= -DLM_ECANCEL,	/* Successful cancel */
+	[DLM_IVRESHANDLE]		= -EINVAL,
+	[DLM_DEADLOCK]			= -EDEADLK,
+	[DLM_DENIED_NOASTS]		= -EINVAL,
+	[DLM_FORWARD]			= -EINVAL,
+	[DLM_TIMEOUT]			= -ETIMEDOUT,
+	[DLM_IVGROUPID]			= -EINVAL,
+	[DLM_VERS_CONFLICT]		= -EOPNOTSUPP,
+	[DLM_BAD_DEVICE_PATH]		= -ENOENT,
+	[DLM_NO_DEVICE_PERMISSION]	= -EPERM,
+	[DLM_NO_CONTROL_DEVICE]		= -ENOENT,
+	[DLM_RECOVERING]		= -ENOTCONN,
+	[DLM_MIGRATING]			= -ERESTART,
+	[DLM_MAXSTATS]			= -EINVAL,
+};
+
+static int dlm_status_to_errno(enum dlm_status status)
+{
+	BUG_ON(status > (sizeof(status_map) / sizeof(status_map[0])));
+
+	return status_map[status];
+}
+
+static void o2dlm_lock_ast_wrapper(void *astarg)
+{
+	BUG_ON(stack_glue_lproto == NULL);
+
+	stack_glue_lproto->lp_lock_ast(astarg);
+}
+
+static void o2dlm_blocking_ast_wrapper(void *astarg, int level)
+{
+	BUG_ON(stack_glue_lproto == NULL);
+
+	stack_glue_lproto->lp_blocking_ast(astarg, level);
+}
+
+static void o2dlm_unlock_ast_wrapper(void *astarg, enum dlm_status status)
+{
+	int error = dlm_status_to_errno(status);
+
+	BUG_ON(stack_glue_lproto == NULL);
+
+	/*
+	 * In o2dlm, you can get both the lock_ast() for the lock being
+	 * granted and the unlock_ast() for the CANCEL failing.  A
+	 * successful cancel sends DLM_NORMAL here.  If the
+	 * lock grant happened before the cancel arrived, you get
+	 * DLM_CANCELGRANT.
+	 *
+	 * There's no need for the double-ast.  If we see DLM_CANCELGRANT,
+	 * we just ignore it.  We expect the lock_ast() to handle the
+	 * granted lock.
+	 */
+	if (status == DLM_CANCELGRANT)
+		return;
+
+	stack_glue_lproto->lp_unlock_ast(astarg, error);
+}
+
+static int o2cb_dlm_lock(struct ocfs2_cluster_connection *conn,
+			 int mode,
+			 union ocfs2_dlm_lksb *lksb,
+			 u32 flags,
+			 void *name,
+			 unsigned int namelen,
+			 void *astarg)
+{
+	enum dlm_status status;
+	int o2dlm_mode = mode_to_o2dlm(mode);
+	int o2dlm_flags = flags_to_o2dlm(flags);
+	int ret;
+
+	status = dlmlock(conn->cc_lockspace, o2dlm_mode, &lksb->lksb_o2dlm,
+			 o2dlm_flags, name, namelen,
+			 o2dlm_lock_ast_wrapper, astarg,
+			 o2dlm_blocking_ast_wrapper);
+	ret = dlm_status_to_errno(status);
+	return ret;
+}
+
+static int o2cb_dlm_unlock(struct ocfs2_cluster_connection *conn,
+			   union ocfs2_dlm_lksb *lksb,
+			   u32 flags,
+			   void *astarg)
+{
+	enum dlm_status status;
+	int o2dlm_flags = flags_to_o2dlm(flags);
+	int ret;
+
+	status = dlmunlock(conn->cc_lockspace, &lksb->lksb_o2dlm,
+			   o2dlm_flags, o2dlm_unlock_ast_wrapper, astarg);
+	ret = dlm_status_to_errno(status);
+	return ret;
+}
+
+static int o2cb_dlm_lock_status(union ocfs2_dlm_lksb *lksb)
+{
+	return dlm_status_to_errno(lksb->lksb_o2dlm.status);
+}
+
+static void *o2cb_dlm_lvb(union ocfs2_dlm_lksb *lksb)
+{
+	return (void *)(lksb->lksb_o2dlm.lvb);
+}
+
+static void o2cb_dump_lksb(union ocfs2_dlm_lksb *lksb)
+{
+	dlm_print_one_lock(lksb->lksb_o2dlm.lockid);
+}
+
+/*
+ * Called from the dlm when it's about to evict a node. This is how the
+ * classic stack signals node death.
+ */
+static void o2dlm_eviction_cb(int node_num, void *data)
+{
+	struct ocfs2_cluster_connection *conn = data;
+
+	mlog(ML_NOTICE, "o2dlm has evicted node %d from group %.*s\n",
+	     node_num, conn->cc_namelen, conn->cc_name);
+
+	conn->cc_recovery_handler(node_num, conn->cc_recovery_data);
+}
+
+static int o2cb_cluster_connect(struct ocfs2_cluster_connection *conn)
+{
+	int rc = 0;
+	u32 dlm_key;
+	struct dlm_ctxt *dlm;
+	struct o2dlm_private *priv;
+	struct dlm_protocol_version dlm_version;
+
+	BUG_ON(conn == NULL);
+
+	/* for now we only have one cluster/node, make sure we see it
+	 * in the heartbeat universe */
+	if (!o2hb_check_local_node_heartbeating()) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	priv = kzalloc(sizeof(struct o2dlm_private), GFP_KERNEL);
+	if (!priv) {
+		rc = -ENOMEM;
+		goto out_free;
+	}
+
+	/* This just fills the structure in.  It is safe to pass conn. */
+	dlm_setup_eviction_cb(&priv->op_eviction_cb, o2dlm_eviction_cb,
+			      conn);
+
+	conn->cc_private = priv;
+
+	/* used by the dlm code to make message headers unique, each
+	 * node in this domain must agree on this. */
+	dlm_key = crc32_le(0, conn->cc_name, conn->cc_namelen);
+	dlm_version.pv_major = conn->cc_version.pv_major;
+	dlm_version.pv_minor = conn->cc_version.pv_minor;
+
+	dlm = dlm_register_domain(conn->cc_name, dlm_key, &dlm_version);
+	if (IS_ERR(dlm)) {
+		rc = PTR_ERR(dlm);
+		mlog_errno(rc);
+		goto out_free;
+	}
+
+	conn->cc_version.pv_major = dlm_version.pv_major;
+	conn->cc_version.pv_minor = dlm_version.pv_minor;
+	conn->cc_lockspace = dlm;
+
+	dlm_register_eviction_cb(dlm, &priv->op_eviction_cb);
+
+out_free:
+	if (rc && conn->cc_private)
+		kfree(conn->cc_private);
+
+out:
+	return rc;
+}
+
+static int o2cb_cluster_disconnect(struct ocfs2_cluster_connection *conn)
+{
+	struct dlm_ctxt *dlm = conn->cc_lockspace;
+	struct o2dlm_private *priv = conn->cc_private;
+
+	dlm_unregister_eviction_cb(&priv->op_eviction_cb);
+	conn->cc_private = NULL;
+	kfree(priv);
+
+	dlm_unregister_domain(dlm);
+	conn->cc_lockspace = NULL;
+
+	return 0;
+}
+
+static void o2hb_stop(const char *group)
+{
+	int ret;
+	char *argv[5], *envp[3];
+
+	argv[0] = (char *)o2nm_get_hb_ctl_path();
+	argv[1] = "-K";
+	argv[2] = "-u";
+	argv[3] = (char *)group;
+	argv[4] = NULL;
+
+	mlog(0, "Run: %s %s %s %s\n", argv[0], argv[1], argv[2], argv[3]);
+
+	/* minimal command environment taken from cpu_run_sbin_hotplug */
+	envp[0] = "HOME=/";
+	envp[1] = "PATH=/sbin:/bin:/usr/sbin:/usr/bin";
+	envp[2] = NULL;
+
+	ret = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_PROC);
+	if (ret < 0)
+		mlog_errno(ret);
+}
+
+/*
+ * Hangup is a hack for tools compatibility.  Older ocfs2-tools software
+ * expects the filesystem to call "ocfs2_hb_ctl" during unmount.  This
+ * happens regardless of whether the DLM got started, so we can't do it
+ * in ocfs2_cluster_disconnect().  We bring the o2hb_stop() function into
+ * the glue and provide a "hangup" API for super.c to call.
+ *
+ * Other stacks will eventually provide a NULL ->hangup() pointer.
+ */
+static void o2cb_cluster_hangup(const char *group, int grouplen)
+{
+	o2hb_stop(group);
+}
+
+static int o2cb_cluster_this_node(unsigned int *node)
+{
+	int node_num;
+
+	node_num = o2nm_this_node();
+	if (node_num == O2NM_INVALID_NODE_NUM)
+		return -ENOENT;
+
+	if (node_num >= O2NM_MAX_NODES)
+		return -EOVERFLOW;
+
+	*node = node_num;
+	return 0;
+}
+
+struct ocfs2_stack_operations o2cb_stack_ops = {
+	.connect	= o2cb_cluster_connect,
+	.disconnect	= o2cb_cluster_disconnect,
+	.hangup		= o2cb_cluster_hangup,
+	.this_node	= o2cb_cluster_this_node,
+	.dlm_lock	= o2cb_dlm_lock,
+	.dlm_unlock	= o2cb_dlm_unlock,
+	.lock_status	= o2cb_dlm_lock_status,
+	.lock_lvb	= o2cb_dlm_lvb,
+	.dump_lksb	= o2cb_dump_lksb,
+};
+
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index e35dde6..e197367 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -19,204 +19,17 @@
  */
 
 #include <linux/slab.h>
-#include <linux/crc32.h>
 #include <linux/kmod.h>
 
 /* Needed for AOP_TRUNCATED_PAGE in mlog_errno() */
 #include <linux/fs.h>
 
 #include "cluster/masklog.h"
-#include "cluster/nodemanager.h"
-#include "cluster/heartbeat.h"
 
 #include "stackglue.h"
 
-static struct ocfs2_locking_protocol *lproto;
-
-struct o2dlm_private {
-	struct dlm_eviction_cb op_eviction_cb;
-};
-
-/* These should be identical */
-#if (DLM_LOCK_IV != LKM_IVMODE)
-# error Lock modes do not match
-#endif
-#if (DLM_LOCK_NL != LKM_NLMODE)
-# error Lock modes do not match
-#endif
-#if (DLM_LOCK_CR != LKM_CRMODE)
-# error Lock modes do not match
-#endif
-#if (DLM_LOCK_CW != LKM_CWMODE)
-# error Lock modes do not match
-#endif
-#if (DLM_LOCK_PR != LKM_PRMODE)
-# error Lock modes do not match
-#endif
-#if (DLM_LOCK_PW != LKM_PWMODE)
-# error Lock modes do not match
-#endif
-#if (DLM_LOCK_EX != LKM_EXMODE)
-# error Lock modes do not match
-#endif
-static inline int mode_to_o2dlm(int mode)
-{
-	BUG_ON(mode > LKM_MAXMODE);
-
-	return mode;
-}
-
-#define map_flag(_generic, _o2dlm)		\
-	if (flags & (_generic)) {		\
-		flags &= ~(_generic);		\
-		o2dlm_flags |= (_o2dlm);	\
-	}
-static int flags_to_o2dlm(u32 flags)
-{
-	int o2dlm_flags = 0;
-
-	map_flag(DLM_LKF_NOQUEUE, LKM_NOQUEUE);
-	map_flag(DLM_LKF_CANCEL, LKM_CANCEL);
-	map_flag(DLM_LKF_CONVERT, LKM_CONVERT);
-	map_flag(DLM_LKF_VALBLK, LKM_VALBLK);
-	map_flag(DLM_LKF_IVVALBLK, LKM_INVVALBLK);
-	map_flag(DLM_LKF_ORPHAN, LKM_ORPHAN);
-	map_flag(DLM_LKF_FORCEUNLOCK, LKM_FORCE);
-	map_flag(DLM_LKF_TIMEOUT, LKM_TIMEOUT);
-	map_flag(DLM_LKF_LOCAL, LKM_LOCAL);
-
-	/* map_flag() should have cleared every flag passed in */
-	BUG_ON(flags != 0);
-
-	return o2dlm_flags;
-}
-#undef map_flag
-
-/*
- * Map an o2dlm status to standard errno values.
- *
- * o2dlm only uses a handful of these, and returns even fewer to the
- * caller. Still, we try to assign sane values to each error.
- *
- * The following value pairs have special meanings to dlmglue, thus
- * the right hand side needs to stay unique - never duplicate the
- * mapping elsewhere in the table!
- *
- * DLM_NORMAL:		0
- * DLM_NOTQUEUED:	-EAGAIN
- * DLM_CANCELGRANT:	-EBUSY
- * DLM_CANCEL:		-DLM_ECANCEL
- */
-/* Keep in sync with dlmapi.h */
-static int status_map[] = {
-	[DLM_NORMAL]			= 0,		/* Success */
-	[DLM_GRANTED]			= -EINVAL,
-	[DLM_DENIED]			= -EACCES,
-	[DLM_DENIED_NOLOCKS]		= -EACCES,
-	[DLM_WORKING]			= -EACCES,
-	[DLM_BLOCKED]			= -EINVAL,
-	[DLM_BLOCKED_ORPHAN]		= -EINVAL,
-	[DLM_DENIED_GRACE_PERIOD]	= -EACCES,
-	[DLM_SYSERR]			= -ENOMEM,	/* It is what it is */
-	[DLM_NOSUPPORT]			= -EPROTO,
-	[DLM_CANCELGRANT]		= -EBUSY,	/* Cancel after grant */
-	[DLM_IVLOCKID]			= -EINVAL,
-	[DLM_SYNC]			= -EINVAL,
-	[DLM_BADTYPE]			= -EINVAL,
-	[DLM_BADRESOURCE]		= -EINVAL,
-	[DLM_MAXHANDLES]		= -ENOMEM,
-	[DLM_NOCLINFO]			= -EINVAL,
-	[DLM_NOLOCKMGR]			= -EINVAL,
-	[DLM_NOPURGED]			= -EINVAL,
-	[DLM_BADARGS]			= -EINVAL,
-	[DLM_VOID]			= -EINVAL,
-	[DLM_NOTQUEUED]			= -EAGAIN,	/* Trylock failed */
-	[DLM_IVBUFLEN]			= -EINVAL,
-	[DLM_CVTUNGRANT]		= -EPERM,
-	[DLM_BADPARAM]			= -EINVAL,
-	[DLM_VALNOTVALID]		= -EINVAL,
-	[DLM_REJECTED]			= -EPERM,
-	[DLM_ABORT]			= -EINVAL,
-	[DLM_CANCEL]			= -DLM_ECANCEL,	/* Successful cancel */
-	[DLM_IVRESHANDLE]		= -EINVAL,
-	[DLM_DEADLOCK]			= -EDEADLK,
-	[DLM_DENIED_NOASTS]		= -EINVAL,
-	[DLM_FORWARD]			= -EINVAL,
-	[DLM_TIMEOUT]			= -ETIMEDOUT,
-	[DLM_IVGROUPID]			= -EINVAL,
-	[DLM_VERS_CONFLICT]		= -EOPNOTSUPP,
-	[DLM_BAD_DEVICE_PATH]		= -ENOENT,
-	[DLM_NO_DEVICE_PERMISSION]	= -EPERM,
-	[DLM_NO_CONTROL_DEVICE]		= -ENOENT,
-	[DLM_RECOVERING]		= -ENOTCONN,
-	[DLM_MIGRATING]			= -ERESTART,
-	[DLM_MAXSTATS]			= -EINVAL,
-};
-
-static int dlm_status_to_errno(enum dlm_status status)
-{
-	BUG_ON(status > (sizeof(status_map) / sizeof(status_map[0])));
+struct ocfs2_locking_protocol *stack_glue_lproto;
 
-	return status_map[status];
-}
-
-static void o2dlm_lock_ast_wrapper(void *astarg)
-{
-	BUG_ON(lproto == NULL);
-
-	lproto->lp_lock_ast(astarg);
-}
-
-static void o2dlm_blocking_ast_wrapper(void *astarg, int level)
-{
-	BUG_ON(lproto == NULL);
-
-	lproto->lp_blocking_ast(astarg, level);
-}
-
-static void o2dlm_unlock_ast_wrapper(void *astarg, enum dlm_status status)
-{
-	int error = dlm_status_to_errno(status);
-
-	BUG_ON(lproto == NULL);
-
-	/*
-	 * In o2dlm, you can get both the lock_ast() for the lock being
-	 * granted and the unlock_ast() for the CANCEL failing.  A
-	 * successful cancel sends DLM_NORMAL here.  If the
-	 * lock grant happened before the cancel arrived, you get
-	 * DLM_CANCELGRANT.
-	 *
-	 * There's no need for the double-ast.  If we see DLM_CANCELGRANT,
-	 * we just ignore it.  We expect the lock_ast() to handle the
-	 * granted lock.
-	 */
-	if (status == DLM_CANCELGRANT)
-		return;
-
-	lproto->lp_unlock_ast(astarg, error);
-}
-
-static int o2cb_dlm_lock(struct ocfs2_cluster_connection *conn,
-			 int mode,
-			 union ocfs2_dlm_lksb *lksb,
-			 u32 flags,
-			 void *name,
-			 unsigned int namelen,
-			 void *astarg)
-{
-	enum dlm_status status;
-	int o2dlm_mode = mode_to_o2dlm(mode);
-	int o2dlm_flags = flags_to_o2dlm(flags);
-	int ret;
-
-	status = dlmlock(conn->cc_lockspace, o2dlm_mode, &lksb->lksb_o2dlm,
-			 o2dlm_flags, name, namelen,
-			 o2dlm_lock_ast_wrapper, astarg,
-			 o2dlm_blocking_ast_wrapper);
-	ret = dlm_status_to_errno(status);
-	return ret;
-}
 
 int ocfs2_dlm_lock(struct ocfs2_cluster_connection *conn,
 		   int mode,
@@ -226,25 +39,10 @@ int ocfs2_dlm_lock(struct ocfs2_cluster_connection *conn,
 		   unsigned int namelen,
 		   void *astarg)
 {
-	BUG_ON(lproto == NULL);
-
-	return o2cb_dlm_lock(conn, mode, lksb, flags,
-			     name, namelen, astarg);
-}
-
-static int o2cb_dlm_unlock(struct ocfs2_cluster_connection *conn,
-			   union ocfs2_dlm_lksb *lksb,
-			   u32 flags,
-			   void *astarg)
-{
-	enum dlm_status status;
-	int o2dlm_flags = flags_to_o2dlm(flags);
-	int ret;
+	BUG_ON(stack_glue_lproto == NULL);
 
-	status = dlmunlock(conn->cc_lockspace, &lksb->lksb_o2dlm,
-			   o2dlm_flags, o2dlm_unlock_ast_wrapper, astarg);
-	ret = dlm_status_to_errno(status);
-	return ret;
+	return o2cb_stack_ops.dlm_lock(conn, mode, lksb, flags,
+				       name, namelen, astarg);
 }
 
 int ocfs2_dlm_unlock(struct ocfs2_cluster_connection *conn,
@@ -252,19 +50,14 @@ int ocfs2_dlm_unlock(struct ocfs2_cluster_connection *conn,
 		     u32 flags,
 		     void *astarg)
 {
-	BUG_ON(lproto == NULL);
+	BUG_ON(stack_glue_lproto == NULL);
 
-	return o2cb_dlm_unlock(conn, lksb, flags, astarg);
-}
-
-static int o2cb_dlm_lock_status(union ocfs2_dlm_lksb *lksb)
-{
-	return dlm_status_to_errno(lksb->lksb_o2dlm.status);
+	return o2cb_stack_ops.dlm_unlock(conn, lksb, flags, astarg);
 }
 
 int ocfs2_dlm_lock_status(union ocfs2_dlm_lksb *lksb)
 {
-	return o2cb_dlm_lock_status(lksb);
+	return o2cb_stack_ops.lock_status(lksb);
 }
 
 /*
@@ -272,94 +65,14 @@ int ocfs2_dlm_lock_status(union ocfs2_dlm_lksb *lksb)
  * don't cast at the glue level.  The real answer is that the header
  * ordering is nigh impossible.
  */
-static void *o2cb_dlm_lvb(union ocfs2_dlm_lksb *lksb)
-{
-	return (void *)(lksb->lksb_o2dlm.lvb);
-}
-
 void *ocfs2_dlm_lvb(union ocfs2_dlm_lksb *lksb)
 {
-	return o2cb_dlm_lvb(lksb);
-}
-
-static void o2cb_dlm_dump_lksb(union ocfs2_dlm_lksb *lksb)
-{
-	dlm_print_one_lock(lksb->lksb_o2dlm.lockid);
+	return o2cb_stack_ops.lock_lvb(lksb);
 }
 
 void ocfs2_dlm_dump_lksb(union ocfs2_dlm_lksb *lksb)
 {
-	o2cb_dlm_dump_lksb(lksb);
-}
-
-/*
- * Called from the dlm when it's about to evict a node. This is how the
- * classic stack signals node death.
- */
-static void o2dlm_eviction_cb(int node_num, void *data)
-{
-	struct ocfs2_cluster_connection *conn = data;
-
-	mlog(ML_NOTICE, "o2dlm has evicted node %d from group %.*s\n",
-	     node_num, conn->cc_namelen, conn->cc_name);
-
-	conn->cc_recovery_handler(node_num, conn->cc_recovery_data);
-}
-
-static int o2cb_cluster_connect(struct ocfs2_cluster_connection *conn)
-{
-	int rc = 0;
-	u32 dlm_key;
-	struct dlm_ctxt *dlm;
-	struct o2dlm_private *priv;
-	struct dlm_protocol_version dlm_version;
-
-	BUG_ON(conn == NULL);
-
-	/* for now we only have one cluster/node, make sure we see it
-	 * in the heartbeat universe */
-	if (!o2hb_check_local_node_heartbeating()) {
-		rc = -EINVAL;
-		goto out;
-	}
-
-	priv = kzalloc(sizeof(struct o2dlm_private), GFP_KERNEL);
-	if (!priv) {
-		rc = -ENOMEM;
-		goto out_free;
-	}
-
-	/* This just fills the structure in.  It is safe to pass conn. */
-	dlm_setup_eviction_cb(&priv->op_eviction_cb, o2dlm_eviction_cb,
-			      conn);
-
-	conn->cc_private = priv;
-
-	/* used by the dlm code to make message headers unique, each
-	 * node in this domain must agree on this. */
-	dlm_key = crc32_le(0, conn->cc_name, conn->cc_namelen);
-	dlm_version.pv_major = conn->cc_version.pv_major;
-	dlm_version.pv_minor = conn->cc_version.pv_minor;
-
-	dlm = dlm_register_domain(conn->cc_name, dlm_key, &dlm_version);
-	if (IS_ERR(dlm)) {
-		rc = PTR_ERR(dlm);
-		mlog_errno(rc);
-		goto out_free;
-	}
-
-	conn->cc_version.pv_major = dlm_version.pv_major;
-	conn->cc_version.pv_minor = dlm_version.pv_minor;
-	conn->cc_lockspace = dlm;
-
-	dlm_register_eviction_cb(dlm, &priv->op_eviction_cb);
-
-out_free:
-	if (rc && conn->cc_private)
-		kfree(conn->cc_private);
-
-out:
-	return rc;
+	o2cb_stack_ops.dump_lksb(lksb);
 }
 
 int ocfs2_cluster_connect(const char *group,
@@ -394,9 +107,9 @@ int ocfs2_cluster_connect(const char *group,
 	new_conn->cc_recovery_data = recovery_data;
 
 	/* Start the new connection at our maximum compatibility level */
-	new_conn->cc_version = lproto->lp_max_version;
+	new_conn->cc_version = stack_glue_lproto->lp_max_version;
 
-	rc = o2cb_cluster_connect(new_conn);
+	rc = o2cb_stack_ops.connect(new_conn);
 	if (rc) {
 		mlog_errno(rc);
 		goto out_free;
@@ -412,29 +125,13 @@ out:
 	return rc;
 }
 
-
-static int o2cb_cluster_disconnect(struct ocfs2_cluster_connection *conn)
-{
-	struct dlm_ctxt *dlm = conn->cc_lockspace;
-	struct o2dlm_private *priv = conn->cc_private;
-
-	dlm_unregister_eviction_cb(&priv->op_eviction_cb);
-	conn->cc_private = NULL;
-	kfree(priv);
-
-	dlm_unregister_domain(dlm);
-	conn->cc_lockspace = NULL;
-
-	return 0;
-}
-
 int ocfs2_cluster_disconnect(struct ocfs2_cluster_connection *conn)
 {
 	int ret;
 
 	BUG_ON(conn == NULL);
 
-	ret = o2cb_cluster_disconnect(conn);
+	ret = o2cb_stack_ops.disconnect(conn);
 
 	/* XXX Should we free it anyway? */
 	if (!ret)
@@ -443,75 +140,23 @@ int ocfs2_cluster_disconnect(struct ocfs2_cluster_connection *conn)
 	return ret;
 }
 
-static void o2hb_stop(const char *group)
-{
-	int ret;
-	char *argv[5], *envp[3];
-
-	argv[0] = (char *)o2nm_get_hb_ctl_path();
-	argv[1] = "-K";
-	argv[2] = "-u";
-	argv[3] = (char *)group;
-	argv[4] = NULL;
-
-	mlog(0, "Run: %s %s %s %s\n", argv[0], argv[1], argv[2], argv[3]);
-
-	/* minimal command environment taken from cpu_run_sbin_hotplug */
-	envp[0] = "HOME=/";
-	envp[1] = "PATH=/sbin:/bin:/usr/sbin:/usr/bin";
-	envp[2] = NULL;
-
-	ret = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_PROC);
-	if (ret < 0)
-		mlog_errno(ret);
-}
-
-/*
- * Hangup is a hack for tools compatibility.  Older ocfs2-tools software
- * expects the filesystem to call "ocfs2_hb_ctl" during unmount.  This
- * happens regardless of whether the DLM got started, so we can't do it
- * in ocfs2_cluster_disconnect().  We bring the o2hb_stop() function into
- * the glue and provide a "hangup" API for super.c to call.
- *
- * Other stacks will eventually provide a NULL ->hangup() pointer.
- */
-static void o2cb_cluster_hangup(const char *group, int grouplen)
-{
-	o2hb_stop(group);
-}
-
 void ocfs2_cluster_hangup(const char *group, int grouplen)
 {
 	BUG_ON(group == NULL);
 	BUG_ON(group[grouplen] != '\0');
 
-	o2cb_cluster_hangup(group, grouplen);
-}
-
-static int o2cb_cluster_this_node(unsigned int *node)
-{
-	int node_num;
-
-	node_num = o2nm_this_node();
-	if (node_num == O2NM_INVALID_NODE_NUM)
-		return -ENOENT;
-
-	if (node_num >= O2NM_MAX_NODES)
-		return -EOVERFLOW;
-
-	*node = node_num;
-	return 0;
+	o2cb_stack_ops.hangup(group, grouplen);
 }
 
 int ocfs2_cluster_this_node(unsigned int *node)
 {
-	return o2cb_cluster_this_node(node);
+	return o2cb_stack_ops.this_node(node);
 }
 
 void ocfs2_stack_glue_set_locking_protocol(struct ocfs2_locking_protocol *proto)
 {
 	BUG_ON(proto != NULL);
 
-	lproto = proto;
+	stack_glue_lproto = proto;
 }
 
diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
index decb147..0836322 100644
--- a/fs/ocfs2/stackglue.h
+++ b/fs/ocfs2/stackglue.h
@@ -25,6 +25,8 @@
 #include <linux/list.h>
 #include <linux/dlmconstants.h>
 
+#include "dlm/dlmapi.h"
+
 /*
  * dlmconstants.h does not have a LOCAL flag.  We hope to remove it
  * some day, but right now we need it.  Let's fake it.  This value is larger
@@ -39,13 +41,18 @@
 #define GROUP_NAME_MAX		64
 
 
-#include "dlm/dlmapi.h"
-
+/*
+ * ocfs2_protocol_version changes when ocfs2 does something different in
+ * its inter-node behavior.  See dlmglue.c for more information.
+ */
 struct ocfs2_protocol_version {
 	u8 pv_major;
 	u8 pv_minor;
 };
 
+/*
+ * The ocfs2_locking_protocol defines the handlers called on ocfs2's behalf.
+ */
 struct ocfs2_locking_protocol {
 	struct ocfs2_protocol_version lp_max_version;
 	void (*lp_lock_ast)(void *astarg);
@@ -53,10 +60,20 @@ struct ocfs2_locking_protocol {
 	void (*lp_unlock_ast)(void *astarg, int error);
 };
 
+/*
+ * A union of all lock status structures.  We define it here so that the
+ * size of the union is known.  Lock status structures are embedded in
+ * ocfs2 inodes.
+ */
 union ocfs2_dlm_lksb {
 	struct dlm_lockstatus lksb_o2dlm;
 };
 
+/*
+ * A cluster connection.  Mostly opaque to ocfs2, the connection holds
+ * state for the underlying stack.  ocfs2 does use cc_version to determine
+ * locking compatibility.
+ */
 struct ocfs2_cluster_connection {
 	char cc_name[GROUP_NAME_MAX];
 	int cc_namelen;
@@ -67,6 +84,106 @@ struct ocfs2_cluster_connection {
 	void *cc_private;
 };
 
+/*
+ * Each cluster stack implements the stack operations structure.  Not used
+ * in the ocfs2 code, the stackglue code translates generic cluster calls
+ * into stack operations.
+ */
+struct ocfs2_stack_operations {
+	/*
+	 * The fs code calls ocfs2_cluster_connect() to attach a new
+	 * filesystem to the cluster stack.  The ->connect() op is passed
+	 * an ocfs2_cluster_connection with the name and recovery field
+	 * filled in.
+	 *
+	 * The stack must set up any notification mechanisms and create
+	 * the filesystem lockspace in the DLM.  The lockspace should be
+	 * stored on cc_lockspace.  Any other information can be stored on
+	 * cc_private.
+	 *
+	 * ->connect() must not return until it is guaranteed that
+	 *
+	 *  - Node down notifications for the filesystem will be recieved
+	 *    and passed to conn->cc_recovery_handler().
+	 *  - Locking requests for the filesystem will be processed.
+	 */
+	int (*connect)(struct ocfs2_cluster_connection *conn);
+
+	/*
+	 * The fs code calls ocfs2_cluster_disconnect() when a filesystem
+	 * no longer needs cluster services.  All DLM locks have been
+	 * dropped, and recovery notification is being ignored by the
+	 * fs code.  The stack must disengage from the DLM and discontinue
+	 * recovery notification.
+	 *
+	 * Once ->disconnect() has returned, the connection structure will
+	 * be freed.  Thus, a stack must not return from ->disconnect()
+	 * until it will no longer reference the conn pointer.
+	 */
+	int (*disconnect)(struct ocfs2_cluster_connection *conn);
+
+	/*
+	 * ocfs2_cluster_hangup() exists for compatibility with older
+	 * ocfs2 tools.  Only the classic stack really needs it.  As such
+	 * ->hangup() is not required of all stacks.  See the comment by
+	 * ocfs2_cluster_hangup() for more details.
+	 */
+	void (*hangup)(const char *group, int grouplen);
+
+	/*
+	 * ->this_node() returns the cluster's unique identifier for the
+	 * local node.
+	 */
+	int (*this_node)(unsigned int *node);
+
+	/*
+	 * Call the underlying dlm lock function.  The ->dlm_lock()
+	 * callback should convert the flags and mode as appropriate.
+	 *
+	 * ast and bast functions are not part of the call because the
+	 * stack will likely want to wrap ast and bast calls before passing
+	 * them to stack->sp_proto.
+	 */
+	int (*dlm_lock)(struct ocfs2_cluster_connection *conn,
+			int mode,
+			union ocfs2_dlm_lksb *lksb,
+			u32 flags,
+			void *name,
+			unsigned int namelen,
+			void *astarg);
+
+	/*
+	 * Call the underlying dlm unlock function.  The ->dlm_unlock()
+	 * function should convert the flags as appropriate.
+	 *
+	 * The unlock ast is not passed, as the stack will want to wrap
+	 * it before calling stack->sp_proto->lp_unlock_ast().
+	 */
+	int (*dlm_unlock)(struct ocfs2_cluster_connection *conn,
+			  union ocfs2_dlm_lksb *lksb,
+			  u32 flags,
+			  void *astarg);
+
+	/*
+	 * Return the status of the current lock status block.  The fs
+	 * code should never dereference the union.  The ->lock_status()
+	 * callback pulls out the stack-specific lksb, converts the status
+	 * to a proper errno, and returns it.
+	 */
+	int (*lock_status)(union ocfs2_dlm_lksb *lksb);
+
+	/*
+	 * Pull the lvb pointer off of the stack-specific lksb.
+	 */
+	void *(*lock_lvb)(union ocfs2_dlm_lksb *lksb);
+
+	/*
+	 * This is an optoinal debugging hook.  If provided, the
+	 * stack can dump debugging information about this lock.
+	 */
+	void (*dump_lksb)(union ocfs2_dlm_lksb *lksb);
+};
+
 int ocfs2_cluster_connect(const char *group,
 			  int grouplen,
 			  void (*recovery_handler)(int node_num,
@@ -95,4 +212,6 @@ void ocfs2_dlm_dump_lksb(union ocfs2_dlm_lksb *lksb);
 
 void ocfs2_stack_glue_set_locking_protocol(struct ocfs2_locking_protocol *proto);
 
+extern struct ocfs2_locking_protocol *stack_glue_lproto;
+extern struct ocfs2_stack_operations o2cb_stack_ops;
 #endif  /* STACKGLUE_H */
-- 
1.5.3.8
