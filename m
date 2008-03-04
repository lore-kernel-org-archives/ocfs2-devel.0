From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue Mar  4 16:50:07 2008
Subject: [Ocfs2-devel] [PATCH 09/12] ocfs2/dlm: Dumps the purgelist into a
	debugfs file
In-Reply-To: <1204678200-26237-1-git-send-email-sunil.mushran@oracle.com>
References: <1204678200-26237-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1204678200-26237-10-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch dumps all the lockres' on the purgelist it can fit in one page
into a debugfs file. Useful for debugging.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmdebug.c |   71 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/dlm/dlmdebug.h |    1 +
 2 files changed, 72 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index f792af5..0842e1b 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -302,6 +302,7 @@ static int stringify_lockname(const char *lockname, int locklen,
 #define DLM_DEBUGFS_DLM_STATE			"dlm_state"
 #define DLM_DEBUGFS_LOCKING_STATE		"locking_state"
 #define DLM_DEBUGFS_MLE_STATE			"mle_state"
+#define DLM_DEBUGFS_PURGE_LIST			"purge_list"
 
 #ifdef CONFIG_DEBUG_FS
 /* begin - utils funcs */
@@ -396,6 +397,63 @@ static int debug_buffer_release(struct inode *inode, struct file *file)
 }
 /* end - util funcs */
 
+/* begin - purge list funcs */
+static int debug_purgelist_print(struct dlm_ctxt *dlm, struct debug_buffer *db)
+{
+	struct dlm_lock_resource *res;
+	int out = 0;
+	unsigned long total = 0;
+
+	out += snprintf(db->buf + out, db->len - out,
+			"Dumping Purgelist for Domain: %s\n", dlm->name);
+
+	spin_lock(&dlm->spinlock);
+	list_for_each_entry(res, &dlm->purge_list, purge) {
+		++total;
+		if (db->len - out < 100)
+			continue;
+		spin_lock(&res->spinlock);
+		out += stringify_lockname(res->lockname.name,
+					  res->lockname.len,
+					  db->buf + out, db->len - out);
+		out += snprintf(db->buf + out, db->len - out, "\t%ld\n",
+				(jiffies - res->last_used)/HZ);
+		spin_unlock(&res->spinlock);
+	}
+	spin_unlock(&dlm->spinlock);
+
+	out += snprintf(db->buf + out, db->len - out,
+			"Total on list: %ld\n", total);
+
+	return out;
+}
+
+static int debug_purgelist_open(struct inode *inode, struct file *file)
+{
+	struct dlm_ctxt *dlm = inode->i_private;
+	struct debug_buffer *db;
+
+	db = debug_buffer_allocate();
+	if (!db)
+		goto bail;
+
+	db->len = debug_purgelist_print(dlm, db);
+
+	file->private_data = db;
+
+	return 0;
+bail:
+	return -ENOMEM;
+}
+
+static struct file_operations debug_purgelist_fops = {
+	.open =		debug_purgelist_open,
+	.release =	debug_buffer_release,
+	.read =		debug_buffer_read,
+	.llseek =	debug_buffer_llseek,
+};
+/* end - purge list funcs */
+
 /* begin - debug mle funcs */
 static int dump_mle(struct dlm_master_list_entry *mle, char *buf, int len)
 {
@@ -909,6 +967,17 @@ int dlm_debug_init(struct dlm_ctxt *dlm)
 		goto bail;
 	}
 
+	/* for dumping lockres on the purge list */
+	dc->debug_purgelist_dentry =
+			debugfs_create_file(DLM_DEBUGFS_PURGE_LIST,
+					    S_IFREG|S_IRUSR,
+					    dlm->dlm_debugfs_subroot,
+					    dlm, &debug_purgelist_fops);
+	if (!dc->debug_purgelist_dentry) {
+		mlog_errno(-ENOMEM);
+		goto bail;
+	}
+
 	dlm_debug_get(dc);
 	return 0;
 
@@ -925,6 +994,8 @@ void dlm_debug_shutdown(struct dlm_ctxt *dlm)
 	struct dlm_debug_ctxt *dc = dlm->dlm_debug_ctxt;
 
 	if (dc) {
+		if (dc->debug_purgelist_dentry)
+			debugfs_remove(dc->debug_purgelist_dentry);
 		if (dc->debug_mle_dentry)
 			debugfs_remove(dc->debug_mle_dentry);
 		if (dc->debug_lockres_dentry)
diff --git a/fs/ocfs2/dlm/dlmdebug.h b/fs/ocfs2/dlm/dlmdebug.h
index 313af2a..974a6be 100644
--- a/fs/ocfs2/dlm/dlmdebug.h
+++ b/fs/ocfs2/dlm/dlmdebug.h
@@ -30,6 +30,7 @@ struct dlm_debug_ctxt {
 	struct dentry *debug_state_dentry;
 	struct dentry *debug_lockres_dentry;
 	struct dentry *debug_mle_dentry;
+	struct dentry *debug_purgelist_dentry;
 };
 
 struct debug_buffer {
-- 
1.5.3.6
