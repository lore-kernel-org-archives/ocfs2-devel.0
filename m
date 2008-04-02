From: Mark Fasheh <mfasheh@suse.com>
Date: Wed,  2 Apr 2008 13:14:50 -0700
Subject: [Ocfs2-devel] [PATCH 40/62] ocfs2/dlm: Create debugfs dirs
In-Reply-To: <1207167398684-git-send-email-mfasheh@suse.com>
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
	<12071673843208-git-send-email-mfasheh@suse.com>
	<12071673872568-git-send-email-mfasheh@suse.com>
	<12071673882492-git-send-email-mfasheh@suse.com>
	<1207167390414-git-send-email-mfasheh@suse.com>
	<1207167392537-git-send-email-mfasheh@suse.com>
	<12071673941659-git-send-email-mfasheh@suse.com>
	<12071673964014-git-send-email-mfasheh@suse.com>
	<1207167398684-git-send-email-mfasheh@suse.com>
Message-ID: <12071674013954-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Sunil Mushran <sunil.mushran@oracle.com>

From: Sunil Mushran <sunil.mushran@oracle.com>

This patch creates the debugfs directories that will hold the
files to be used to dump the dlm state.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dlm/dlmcommon.h |    2 +
 fs/ocfs2/dlm/dlmdebug.c  |   50 +++++++++++++++++++++++++++++++++++++++++-
 fs/ocfs2/dlm/dlmdebug.h  |   54 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/dlm/dlmdomain.c |   21 +++++++++++++++++-
 4 files changed, 125 insertions(+), 2 deletions(-)
 create mode 100644 fs/ocfs2/dlm/dlmdebug.h

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index cc31abe..6a49140 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -123,6 +123,8 @@ struct dlm_ctxt
 	atomic_t remote_resources;
 	atomic_t unknown_resources;
 
+	struct dentry *dlm_debugfs_subroot;
+
 	/* NOTE: Next three are protected by dlm_domain_lock */
 	struct kref dlm_refs;
 	enum dlm_ctxt_state dlm_state;
diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index 64239b3..62e2a4c 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -30,6 +30,7 @@
 #include <linux/utsname.h>
 #include <linux/sysctl.h>
 #include <linux/spinlock.h>
+#include <linux/debugfs.h>
 
 #include "cluster/heartbeat.h"
 #include "cluster/nodemanager.h"
@@ -37,8 +38,8 @@
 
 #include "dlmapi.h"
 #include "dlmcommon.h"
-
 #include "dlmdomain.h"
+#include "dlmdebug.h"
 
 #define MLOG_MASK_PREFIX ML_DLM
 #include "cluster/masklog.h"
@@ -266,3 +267,50 @@ const char *dlm_errname(enum dlm_status err)
 	return dlm_errnames[err];
 }
 EXPORT_SYMBOL_GPL(dlm_errname);
+
+
+#ifdef CONFIG_DEBUG_FS
+
+static struct dentry *dlm_debugfs_root = NULL;
+
+#define DLM_DEBUGFS_DIR				"o2dlm"
+
+/* subroot - domain dir */
+int dlm_create_debugfs_subroot(struct dlm_ctxt *dlm)
+{
+	dlm->dlm_debugfs_subroot = debugfs_create_dir(dlm->name,
+						      dlm_debugfs_root);
+	if (!dlm->dlm_debugfs_subroot) {
+		mlog_errno(-ENOMEM);
+		goto bail;
+	}
+
+	return 0;
+bail:
+	dlm_destroy_debugfs_subroot(dlm);
+	return -ENOMEM;
+}
+
+void dlm_destroy_debugfs_subroot(struct dlm_ctxt *dlm)
+{
+	if (dlm->dlm_debugfs_subroot)
+		debugfs_remove(dlm->dlm_debugfs_subroot);
+}
+
+/* debugfs root */
+int dlm_create_debugfs_root(void)
+{
+	dlm_debugfs_root = debugfs_create_dir(DLM_DEBUGFS_DIR, NULL);
+	if (!dlm_debugfs_root) {
+		mlog_errno(-ENOMEM);
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+void dlm_destroy_debugfs_root(void)
+{
+	if (dlm_debugfs_root)
+		debugfs_remove(dlm_debugfs_root);
+}
+#endif	/* CONFIG_DEBUG_FS */
diff --git a/fs/ocfs2/dlm/dlmdebug.h b/fs/ocfs2/dlm/dlmdebug.h
new file mode 100644
index 0000000..b969595
--- /dev/null
+++ b/fs/ocfs2/dlm/dlmdebug.h
@@ -0,0 +1,54 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * dlmdebug.h
+ *
+ * Copyright (C) 2008 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation; either
+ * version 2 of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ *
+ */
+
+#ifndef DLMDEBUG_H
+#define DLMDEBUG_H
+
+#ifdef CONFIG_DEBUG_FS
+
+int dlm_create_debugfs_subroot(struct dlm_ctxt *dlm);
+void dlm_destroy_debugfs_subroot(struct dlm_ctxt *dlm);
+
+int dlm_create_debugfs_root(void);
+void dlm_destroy_debugfs_root(void);
+
+#else
+
+static int dlm_create_debugfs_subroot(struct dlm_ctxt *dlm)
+{
+	return 0;
+}
+static void dlm_destroy_debugfs_subroot(struct dlm_ctxt *dlm)
+{
+}
+static int dlm_create_debugfs_root(void)
+{
+	return 0;
+}
+static void dlm_destroy_debugfs_root(void)
+{
+}
+
+#endif	/* CONFIG_DEBUG_FS */
+#endif	/* DLMDEBUG_H */
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 4f7695c..c137d69 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -33,6 +33,7 @@
 #include <linux/spinlock.h>
 #include <linux/delay.h>
 #include <linux/err.h>
+#include <linux/debugfs.h>
 
 #include "cluster/heartbeat.h"
 #include "cluster/nodemanager.h"
@@ -40,8 +41,8 @@
 
 #include "dlmapi.h"
 #include "dlmcommon.h"
-
 #include "dlmdomain.h"
+#include "dlmdebug.h"
 
 #include "dlmver.h"
 
@@ -298,6 +299,8 @@ static int dlm_wait_on_domain_helper(const char *domain)
 
 static void dlm_free_ctxt_mem(struct dlm_ctxt *dlm)
 {
+	dlm_destroy_debugfs_subroot(dlm);
+
 	if (dlm->lockres_hash)
 		dlm_free_pagevec((void **)dlm->lockres_hash, DLM_HASH_PAGES);
 
@@ -1494,6 +1497,7 @@ static struct dlm_ctxt *dlm_alloc_ctxt(const char *domain,
 				u32 key)
 {
 	int i;
+	int ret;
 	struct dlm_ctxt *dlm = NULL;
 
 	dlm = kzalloc(sizeof(*dlm), GFP_KERNEL);
@@ -1526,6 +1530,15 @@ static struct dlm_ctxt *dlm_alloc_ctxt(const char *domain,
 	dlm->key = key;
 	dlm->node_num = o2nm_this_node();
 
+	ret = dlm_create_debugfs_subroot(dlm);
+	if (ret < 0) {
+		dlm_free_pagevec((void **)dlm->lockres_hash, DLM_HASH_PAGES);
+		kfree(dlm->name);
+		kfree(dlm);
+		dlm = NULL;
+		goto leave;
+	}
+
 	spin_lock_init(&dlm->spinlock);
 	spin_lock_init(&dlm->master_lock);
 	spin_lock_init(&dlm->ast_lock);
@@ -1851,8 +1864,13 @@ static int __init dlm_init(void)
 		goto error;
 	}
 
+	status = dlm_create_debugfs_root();
+	if (status)
+		goto error;
+
 	return 0;
 error:
+	dlm_unregister_net_handlers();
 	dlm_destroy_lock_cache();
 	dlm_destroy_master_caches();
 	dlm_destroy_mle_cache();
@@ -1861,6 +1879,7 @@ error:
 
 static void __exit dlm_exit (void)
 {
+	dlm_destroy_debugfs_root();
 	dlm_unregister_net_handlers();
 	dlm_destroy_lock_cache();
 	dlm_destroy_master_caches();
-- 
1.5.4.1
