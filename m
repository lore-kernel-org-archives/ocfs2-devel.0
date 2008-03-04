From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue Mar  4 16:50:12 2008
Subject: [Ocfs2-devel] [PATCH 10/12] ocfs2/dlm: Dumps the workqueue into a
	debugfs file
In-Reply-To: <1204678200-26237-1-git-send-email-sunil.mushran@oracle.com>
References: <1204678200-26237-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1204678200-26237-11-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch dumps all the tasks on the workqueue it can fit in one page
into a debugfs file. Useful for debugging.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmcommon.h   |    3 +
 fs/ocfs2/dlm/dlmdebug.c    |   96 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/dlm/dlmdebug.h    |    1 +
 fs/ocfs2/dlm/dlmmaster.c   |    3 +-
 fs/ocfs2/dlm/dlmrecovery.c |    7 +--
 5 files changed, 103 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index 3a59fdc..08d8a7f 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -975,6 +975,9 @@ int dlm_finalize_reco_handler(struct o2net_msg *msg, u32 len, void *data,
 int dlm_do_master_requery(struct dlm_ctxt *dlm, struct dlm_lock_resource *res,
 			  u8 nodenum, u8 *real_master);
 
+void dlm_request_all_locks_worker(struct dlm_work_item *item, void *data);
+void dlm_mig_lockres_worker(struct dlm_work_item *item, void *data);
+void dlm_assert_master_worker(struct dlm_work_item *item, void *data);
 
 int dlm_dispatch_assert_master(struct dlm_ctxt *dlm,
 			       struct dlm_lock_resource *res,
diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index 0842e1b..b45eeb7 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -303,6 +303,7 @@ static int stringify_lockname(const char *lockname, int locklen,
 #define DLM_DEBUGFS_LOCKING_STATE		"locking_state"
 #define DLM_DEBUGFS_MLE_STATE			"mle_state"
 #define DLM_DEBUGFS_PURGE_LIST			"purge_list"
+#define DLM_DEBUGFS_WORK_QUEUE			"work_queue"
 
 #ifdef CONFIG_DEBUG_FS
 /* begin - utils funcs */
@@ -397,6 +398,88 @@ static int debug_buffer_release(struct inode *inode, struct file *file)
 }
 /* end - util funcs */
 
+/* begin - work queue funcs */
+static int debug_workqueue_print(struct dlm_ctxt *dlm, struct debug_buffer *db)
+{
+	struct dlm_work_item *wi;
+	int out = 0;
+	unsigned long total = 0;
+	struct qstr *lockname;
+
+	out += snprintf(db->buf + out, db->len - out,
+			"Dumping Workqueue for Domain: %s\n", dlm->name);
+
+	spin_lock(&dlm->work_lock);
+	list_for_each_entry(wi, &dlm->work_list, list) {
+		++total;
+		if (db->len - out < 100)
+			continue;
+		if (wi->func == dlm_request_all_locks_worker) {
+			out += snprintf(db->buf + out, db->len - out,
+					"RequestAllLocks, "
+					"recomaster=%d, deadnode=%d\n",
+					wi->u.ral.reco_master,
+					wi->u.ral.dead_node);
+		} else if (wi->func == dlm_mig_lockres_worker) {
+			out += snprintf(db->buf + out, db->len - out,
+					"MigrateLockres,  ");
+			lockname = &(wi->u.ml.lockres->lockname);
+			out += stringify_lockname(lockname->name,
+						  lockname->len,
+						  db->buf + out, db->len - out);
+			out += snprintf(db->buf + out, db->len - out,
+					"  master=%d\n", wi->u.ml.real_master);
+		} else if (wi->func == dlm_assert_master_worker) {
+			out += snprintf(db->buf + out, db->len - out,
+					"AssertMaster, ");
+			lockname = &(wi->u.am.lockres->lockname);
+			out += stringify_lockname(lockname->name,
+						  lockname->len,
+						  db->buf + out, db->len - out);
+			out += snprintf(db->buf + out, db->len - out,
+					" from=%d, flags=0x%X, ignore=%d\n",
+					wi->u.am.request_from,
+					wi->u.am.flags,
+					wi->u.am.ignore_higher);
+		} else {
+			out += snprintf(db->buf + out, db->len - out,
+					"Unknown, 0x%p\n", wi->func);
+		}
+	}
+	spin_unlock(&dlm->work_lock);
+
+	out += snprintf(db->buf + out, db->len - out,
+			"Total on list: %ld\n", total);
+
+	return out;
+}
+
+static int debug_workqueue_open(struct inode *inode, struct file *file)
+{
+	struct dlm_ctxt *dlm = inode->i_private;
+	struct debug_buffer *db;
+
+	db = debug_buffer_allocate();
+	if (!db)
+		goto bail;
+
+	db->len = debug_workqueue_print(dlm, db);
+
+	file->private_data = db;
+
+	return 0;
+bail:
+	return -ENOMEM;
+}
+
+static struct file_operations debug_workqueue_fops = {
+	.open =		debug_workqueue_open,
+	.release =	debug_buffer_release,
+	.read =		debug_buffer_read,
+	.llseek =	debug_buffer_llseek,
+};
+/* end - work queue funcs */
+
 /* begin - purge list funcs */
 static int debug_purgelist_print(struct dlm_ctxt *dlm, struct debug_buffer *db)
 {
@@ -978,6 +1061,17 @@ int dlm_debug_init(struct dlm_ctxt *dlm)
 		goto bail;
 	}
 
+	/* for dumping the dlm work queue */
+	dc->debug_workqueue_dentry =
+			debugfs_create_file(DLM_DEBUGFS_WORK_QUEUE,
+					    S_IFREG|S_IRUSR,
+					    dlm->dlm_debugfs_subroot,
+					    dlm, &debug_workqueue_fops);
+	if (!dc->debug_workqueue_dentry) {
+		mlog_errno(-ENOMEM);
+		goto bail;
+	}
+
 	dlm_debug_get(dc);
 	return 0;
 
@@ -994,6 +1088,8 @@ void dlm_debug_shutdown(struct dlm_ctxt *dlm)
 	struct dlm_debug_ctxt *dc = dlm->dlm_debug_ctxt;
 
 	if (dc) {
+		if (dc->debug_workqueue_dentry)
+			debugfs_remove(dc->debug_workqueue_dentry);
 		if (dc->debug_purgelist_dentry)
 			debugfs_remove(dc->debug_purgelist_dentry);
 		if (dc->debug_mle_dentry)
diff --git a/fs/ocfs2/dlm/dlmdebug.h b/fs/ocfs2/dlm/dlmdebug.h
index 974a6be..6c6ac72 100644
--- a/fs/ocfs2/dlm/dlmdebug.h
+++ b/fs/ocfs2/dlm/dlmdebug.h
@@ -31,6 +31,7 @@ struct dlm_debug_ctxt {
 	struct dentry *debug_lockres_dentry;
 	struct dentry *debug_mle_dentry;
 	struct dentry *debug_purgelist_dentry;
+	struct dentry *debug_workqueue_dentry;
 };
 
 struct debug_buffer {
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 94cadcb..74b5283 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -61,7 +61,6 @@ static void dlm_mle_node_up(struct dlm_ctxt *dlm,
 			    struct o2nm_node *node,
 			    int idx);
 
-static void dlm_assert_master_worker(struct dlm_work_item *item, void *data);
 static int dlm_do_assert_master(struct dlm_ctxt *dlm,
 				struct dlm_lock_resource *res,
 				void *nodemap, u32 flags);
@@ -2139,7 +2138,7 @@ int dlm_dispatch_assert_master(struct dlm_ctxt *dlm,
 	return 0;
 }
 
-static void dlm_assert_master_worker(struct dlm_work_item *item, void *data)
+void dlm_assert_master_worker(struct dlm_work_item *item, void *data)
 {
 	struct dlm_ctxt *dlm = data;
 	int ret = 0;
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index bcb9260..d0a17c6 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -92,9 +92,6 @@ static void dlm_finish_local_lockres_recovery(struct dlm_ctxt *dlm,
 static void dlm_reco_ast(void *astdata);
 static void dlm_reco_bast(void *astdata, int blocked_type);
 static void dlm_reco_unlock_ast(void *astdata, enum dlm_status st);
-static void dlm_request_all_locks_worker(struct dlm_work_item *item,
-					 void *data);
-static void dlm_mig_lockres_worker(struct dlm_work_item *item, void *data);
 static int dlm_lockres_master_requery(struct dlm_ctxt *dlm,
 				      struct dlm_lock_resource *res,
 				      u8 *real_master);
@@ -862,7 +859,7 @@ int dlm_request_all_locks_handler(struct o2net_msg *msg, u32 len, void *data,
 	return 0;
 }
 
-static void dlm_request_all_locks_worker(struct dlm_work_item *item, void *data)
+void dlm_request_all_locks_worker(struct dlm_work_item *item, void *data)
 {
 	struct dlm_migratable_lockres *mres;
 	struct dlm_lock_resource *res;
@@ -1480,7 +1477,7 @@ leave:
 }
 
 
-static void dlm_mig_lockres_worker(struct dlm_work_item *item, void *data)
+void dlm_mig_lockres_worker(struct dlm_work_item *item, void *data)
 {
 	struct dlm_ctxt *dlm;
 	struct dlm_migratable_lockres *mres;
-- 
1.5.3.6
