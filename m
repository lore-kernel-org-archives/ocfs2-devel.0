From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue Mar  4 16:50:10 2008
Subject: [Ocfs2-devel] [PATCH 05/12] ocfs2/dlm: Dump the dlm state in a
	debugfs file
In-Reply-To: <1204678200-26237-1-git-send-email-sunil.mushran@oracle.com>
References: <1204678200-26237-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1204678200-26237-6-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch dumps the dlm state (dlm_ctxt) into a debugfs file.
Useful for debugging.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmcommon.h |    1 +
 fs/ocfs2/dlm/dlmdebug.c  |  304 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/dlm/dlmdebug.h  |   13 ++
 fs/ocfs2/dlm/dlmdomain.c |    8 ++
 4 files changed, 326 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index a20d093..c772a7f 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -123,6 +123,7 @@ struct dlm_ctxt
 	atomic_t remote_resources;
 	atomic_t unknown_resources;
 
+	struct dlm_debug_ctxt *dlm_debug_ctxt;
 	struct dentry *dlm_debugfs_subroot;
 
 	/* NOTE: Next three are protected by dlm_domain_lock */
diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index be63024..540c4f8 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -273,6 +273,302 @@ const char *dlm_errname(enum dlm_status err)
 EXPORT_SYMBOL_GPL(dlm_errname);
 
 #define DLM_DEBUGFS_DIR				"o2dlm"
+#define DLM_DEBUGFS_DLM_STATE			"dlm_state"
+
+#ifdef CONFIG_DEBUG_FS
+/* begin - utils funcs */
+static void dlm_debug_free(struct kref *kref)
+{
+	struct dlm_debug_ctxt *dc;
+
+	dc = container_of(kref, struct dlm_debug_ctxt, debug_refcnt);
+
+	kfree(dc);
+}
+
+void dlm_debug_put(struct dlm_debug_ctxt *dc)
+{
+	if (dc)
+		kref_put(&dc->debug_refcnt, dlm_debug_free);
+}
+
+static void dlm_debug_get(struct dlm_debug_ctxt *dc)
+{
+	kref_get(&dc->debug_refcnt);
+}
+
+static int stringify_nodemap(unsigned long *nodemap, int maxnodes,
+			     char *buf, int len)
+{
+	int out = 0;
+	int i = -1;
+
+	while ((i = find_next_bit(nodemap, maxnodes, i + 1)) < maxnodes)
+		out += snprintf(buf + out, len - out, "%d ", i);
+
+	return out;
+}
+
+static struct debug_buffer *debug_buffer_allocate(void)
+{
+	struct debug_buffer *db = NULL;
+
+	db = kzalloc(sizeof(struct debug_buffer), GFP_KERNEL);
+	if (!db)
+		goto bail;
+
+	db->len = PAGE_SIZE;
+	db->buf = kmalloc(db->len, GFP_KERNEL);
+	if (!db->buf)
+		goto bail;
+
+	return db;
+bail:
+	kfree(db);
+	return NULL;
+}
+
+static ssize_t debug_buffer_read(struct file *file, char __user *buf,
+				 size_t nbytes, loff_t *ppos)
+{
+	struct debug_buffer *db = file->private_data;
+
+	return simple_read_from_buffer(buf, nbytes, ppos, db->buf, db->len);
+}
+
+static loff_t debug_buffer_llseek(struct file *file, loff_t off, int whence)
+{
+	struct debug_buffer *db = file->private_data;
+	loff_t new = -1;
+
+	switch (whence) {
+	case 0:
+		new = off;
+		break;
+	case 1:
+		new = file->f_pos + off;
+		break;
+	}
+
+	if (new < 0 || new > db->len)
+		return -EINVAL;
+
+	return (file->f_pos = new);
+}
+
+static int debug_buffer_release(struct inode *inode, struct file *file)
+{
+	struct debug_buffer *db = (struct debug_buffer *)file->private_data;
+
+	if (db)
+		kfree(db->buf);
+	kfree(db);
+
+	return 0;
+}
+/* end - util funcs */
+
+/* begin - debug state funcs */
+static int debug_state_print(struct dlm_ctxt *dlm, struct debug_buffer *db)
+{
+	int out = 0;
+	struct dlm_reco_node_data *node;
+	char *state;
+	int lres, rres, ures, tres;
+
+	lres = atomic_read(&dlm->local_resources);
+	rres = atomic_read(&dlm->remote_resources);
+	ures = atomic_read(&dlm->unknown_resources);
+	tres = lres + rres + ures;
+
+	spin_lock(&dlm->spinlock);
+
+	switch (dlm->dlm_state) {
+	case DLM_CTXT_NEW:
+		state = "NEW"; break;
+	case DLM_CTXT_JOINED:
+		state = "JOINED"; break;
+	case DLM_CTXT_IN_SHUTDOWN:
+		state = "SHUTDOWN"; break;
+	case DLM_CTXT_LEAVING:
+		state = "LEAVING"; break;
+	default:
+		state = "UNKNOWN"; break;
+	}
+
+	/* Domain: xxxxxxxxxx  Key: 0xdfbac769 */
+	out += snprintf(db->buf + out, db->len - out,
+			"Domain: %s  Key: 0x%08x\n", dlm->name, dlm->key);
+
+	/* Thread Pid: xxx  Node: xxx  State: xxxxx */
+	out += snprintf(db->buf + out, db->len - out,
+			"Thread Pid: %d  Node: %d  State: %s\n",
+			task_pid_nr(dlm->dlm_thread_task), dlm->node_num,
+			state);
+
+	/* Number of Joins: xxx  Joining Node: xxx */
+	out += snprintf(db->buf + out, db->len - out,
+			"Number of Joins: %d  Joining Node: %d\n",
+			dlm->num_joins, dlm->joining_node);
+
+	/* Domain Map: xx xx xx */
+	out += snprintf(db->buf + out, db->len - out, "Domain Map: ");
+	out += stringify_nodemap(dlm->domain_map, O2NM_MAX_NODES,
+				 db->buf + out, db->len - out);
+	out += snprintf(db->buf + out, db->len - out, "\n");
+
+	/* Live Map: xx xx xx */
+	out += snprintf(db->buf + out, db->len - out, "Live Map: ");
+	out += stringify_nodemap(dlm->live_nodes_map, O2NM_MAX_NODES,
+				 db->buf + out, db->len - out);
+	out += snprintf(db->buf + out, db->len - out, "\n");
+
+	/* Mastered Resources Total: xxx  Locally: xxx  Remotely: ... */
+	out += snprintf(db->buf + out, db->len - out,
+			"Mastered Resources Total: %d  Locally: %d  "
+			"Remotely: %d  Unknown: %d\n",
+			tres, lres, rres, ures);
+
+	/* Lists: Dirty=Empty  Purge=InUse  PendingASTs=Empty  ... */
+	out += snprintf(db->buf + out, db->len - out,
+			"Lists: Dirty=%s  Purge=%s  PendingASTs=%s  "
+			"PendingBASTs=%s  Master=%s\n",
+			(list_empty(&dlm->dirty_list) ? "Empty" : "InUse"),
+			(list_empty(&dlm->purge_list) ? "Empty" : "InUse"),
+			(list_empty(&dlm->pending_asts) ? "Empty" : "InUse"),
+			(list_empty(&dlm->pending_basts) ? "Empty" : "InUse"),
+			(list_empty(&dlm->master_list) ? "Empty" : "InUse"));
+
+	/* Purge Count: xxx  Refs: xxx */
+	out += snprintf(db->buf + out, db->len - out,
+			"Purge Count: %d  Refs: %d\n", dlm->purge_count,
+			atomic_read(&dlm->dlm_refs.refcount));
+
+	/* Dead Node: xxx */
+	out += snprintf(db->buf + out, db->len - out,
+			"Dead Node: %d\n", dlm->reco.dead_node);
+
+	/* What about DLM_RECO_STATE_FINALIZE? */
+	if (dlm->reco.state == DLM_RECO_STATE_ACTIVE)
+		state = "ACTIVE";
+	else
+		state = "INACTIVE";
+
+	/* Recovery Pid: xxxx  Master: xxx  State: xxxx */
+	out += snprintf(db->buf + out, db->len - out,
+			"Recovery Pid: %d  Master: %d  State: %s\n",
+			task_pid_nr(dlm->dlm_reco_thread_task),
+			dlm->reco.new_master, state);
+
+	/* Recovery Map: xx xx */
+	out += snprintf(db->buf + out, db->len - out, "Recovery Map: ");
+	out += stringify_nodemap(dlm->recovery_map, O2NM_MAX_NODES,
+				 db->buf + out, db->len - out);
+	out += snprintf(db->buf + out, db->len - out, "\n");
+
+	/* Recovery Node State: */
+	out += snprintf(db->buf + out, db->len - out, "Recovery Node State:\n");
+	list_for_each_entry(node, &dlm->reco.node_data, list) {
+		switch (node->state) {
+		case DLM_RECO_NODE_DATA_INIT:
+			state = "INIT";
+			break;
+		case DLM_RECO_NODE_DATA_REQUESTING:
+			state = "REQUESTING";
+			break;
+		case DLM_RECO_NODE_DATA_DEAD:
+			state = "DEAD";
+			break;
+		case DLM_RECO_NODE_DATA_RECEIVING:
+			state = "RECEIVING";
+			break;
+		case DLM_RECO_NODE_DATA_REQUESTED:
+			state = "REQUESTED";
+			break;
+		case DLM_RECO_NODE_DATA_DONE:
+			state = "DONE";
+			break;
+		case DLM_RECO_NODE_DATA_FINALIZE_SENT:
+			state = "FINALIZE-SENT";
+			break;
+		default:
+			state = "BAD";
+			break;
+		}
+		out += snprintf(db->buf + out, db->len - out, "\t%u - %s\n",
+				node->node_num, state);
+	}
+
+	spin_unlock(&dlm->spinlock);
+
+	return out;
+}
+
+static int debug_state_open(struct inode *inode, struct file *file)
+{
+	struct dlm_ctxt *dlm = inode->i_private;
+	struct debug_buffer *db = NULL;
+
+	db = debug_buffer_allocate();
+	if (!db)
+		goto bail;
+
+	db->len = debug_state_print(dlm, db);
+
+	file->private_data = db;
+
+	return 0;
+bail:
+	return -ENOMEM;
+}
+
+static struct file_operations debug_state_fops = {
+	.open =		debug_state_open,
+	.release =	debug_buffer_release,
+	.read =		debug_buffer_read,
+	.llseek =	debug_buffer_llseek,
+};
+/* end  - debug state funcs */
+#endif
+
+/* files in subroot */
+int dlm_debug_init(struct dlm_ctxt *dlm)
+{
+#ifdef CONFIG_DEBUG_FS
+	struct dlm_debug_ctxt *dc = dlm->dlm_debug_ctxt;
+
+	/* for dumping dlm_ctxt */
+	dc->debug_state_dentry = debugfs_create_file(DLM_DEBUGFS_DLM_STATE,
+						     S_IFREG|S_IRUSR,
+						     dlm->dlm_debugfs_subroot,
+						     dlm, &debug_state_fops);
+	if (!dc->debug_state_dentry) {
+		mlog_errno(-ENOMEM);
+		goto bail;
+	}
+
+	dlm_debug_get(dc);
+	return 0;
+
+bail:
+	dlm_debug_shutdown(dlm);
+	return -ENOMEM;
+#endif
+	return 0;
+}
+
+void dlm_debug_shutdown(struct dlm_ctxt *dlm)
+{
+#ifdef CONFIG_DEBUG_FS
+	struct dlm_debug_ctxt *dc = dlm->dlm_debug_ctxt;
+
+	if (dc) {
+		if (dc->debug_state_dentry)
+			debugfs_remove(dc->debug_state_dentry);
+		dlm_debug_put(dc);
+	}
+#endif
+}
 
 /* subroot - domain dir */
 int dlm_create_debugfs_subroot(struct dlm_ctxt *dlm)
@@ -285,6 +581,14 @@ int dlm_create_debugfs_subroot(struct dlm_ctxt *dlm)
 		goto bail;
 	}
 
+	dlm->dlm_debug_ctxt = kzalloc(sizeof(struct dlm_debug_ctxt),
+				      GFP_KERNEL);
+	if (!dlm->dlm_debug_ctxt) {
+		mlog_errno(-ENOMEM);
+		goto bail;
+	}
+	kref_init(&dlm->dlm_debug_ctxt->debug_refcnt);
+
 	return 0;
 bail:
 	dlm_destroy_debugfs_subroot(dlm);
diff --git a/fs/ocfs2/dlm/dlmdebug.h b/fs/ocfs2/dlm/dlmdebug.h
index eb397d5..e6e3cd0 100644
--- a/fs/ocfs2/dlm/dlmdebug.h
+++ b/fs/ocfs2/dlm/dlmdebug.h
@@ -25,6 +25,19 @@
 #ifndef DLMDEBUG_H
 #define DLMDEBUG_H
 
+struct dlm_debug_ctxt {
+	struct kref debug_refcnt;
+	struct dentry *debug_state_dentry;
+};
+
+struct debug_buffer {
+	int len;
+	char *buf;
+};
+
+int dlm_debug_init(struct dlm_ctxt *dlm);
+void dlm_debug_shutdown(struct dlm_ctxt *dlm);
+
 int dlm_create_debugfs_subroot(struct dlm_ctxt *dlm);
 void dlm_destroy_debugfs_subroot(struct dlm_ctxt *dlm);
 
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 2fd17a4..133617e 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -399,6 +399,7 @@ static void dlm_destroy_dlm_worker(struct dlm_ctxt *dlm)
 static void dlm_complete_dlm_shutdown(struct dlm_ctxt *dlm)
 {
 	dlm_unregister_domain_handlers(dlm);
+	dlm_debug_shutdown(dlm);
 	dlm_complete_thread(dlm);
 	dlm_complete_recovery_thread(dlm);
 	dlm_destroy_dlm_worker(dlm);
@@ -1390,6 +1391,12 @@ static int dlm_join_domain(struct dlm_ctxt *dlm)
 		goto bail;
 	}
 
+	status = dlm_debug_init(dlm);
+	if (status < 0) {
+		mlog_errno(status);
+		goto bail;
+	}
+
 	status = dlm_launch_thread(dlm);
 	if (status < 0) {
 		mlog_errno(status);
@@ -1457,6 +1464,7 @@ bail:
 
 	if (status) {
 		dlm_unregister_domain_handlers(dlm);
+		dlm_debug_shutdown(dlm);
 		dlm_complete_thread(dlm);
 		dlm_complete_recovery_thread(dlm);
 		dlm_destroy_dlm_worker(dlm);
-- 
1.5.3.6
