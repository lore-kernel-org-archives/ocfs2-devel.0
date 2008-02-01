From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri Feb  1 16:49:57 2008
Subject: [Ocfs2-devel] [PATCH 10/12] ocfs2_dlm: Dumps the purgelist into a
	debugfs file
In-Reply-To: <1201913371-1522-1-git-send-email-sunil.mushran@oracle.com>
References: <1201913371-1522-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1201913371-1522-11-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch dumps all the lockres' on the purgelist it can fit in one page
into a debugfs file. Useful for debugging.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmdebug.c |   65 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/dlm/dlmdebug.h |    1 +
 2 files changed, 66 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index aad35cc..25334a4 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -794,6 +794,59 @@ static int debug_buffer_release(struct inode *inode, struct file *file)
 
 /* end - util funcs */
 
+/* begin - purge list funcs */
+static int debug_purgelist_print(struct dlm_ctxt *dlm, struct debug_buffer *db)
+{
+	struct dlm_lock_resource *res;
+	int out = 0;
+	unsigned long total = 0;
+
+	spin_lock(&dlm->spinlock);
+	list_for_each_entry(res, &dlm->purge_list, purge) {
+		++total;
+		if (db->len - out < 100)
+			continue;
+		spin_lock(&res->spinlock);
+		out += snprintf(db->buf + out, db->len - out,
+				"%.*s\t%ld\n",
+				res->lockname.len, res->lockname.name,
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
@@ -1286,6 +1339,16 @@ int dlm_debug_init(struct dlm_ctxt *dlm)
 		goto bail;
 	}
 
+	/* for dumping lockres on the purge list */
+	dc->debug_purgelist_dentry =
+			debugfs_create_file("purgelist", S_IFREG|S_IRUSR,
+					    dlm->dlm_debugfs_subroot,
+					    dlm, &debug_purgelist_fops);
+	if (!dc->debug_purgelist_dentry) {
+		mlog_errno(-ENOMEM);
+		goto bail;
+	}
+
 	dlm_debug_get(dc);
 	return 0;
 
@@ -1299,6 +1362,8 @@ void dlm_debug_shutdown(struct dlm_ctxt *dlm)
 	struct dlm_debug_ctxt *dc = dlm->dlm_debug_ctxt;
 
 	if (dc) {
+		if (dc->debug_purgelist_dentry)
+			debugfs_remove(dc->debug_purgelist_dentry);
 		if (dc->debug_mle_dentry)
 			debugfs_remove(dc->debug_mle_dentry);
 		if (dc->debug_lockres_dentry)
diff --git a/fs/ocfs2/dlm/dlmdebug.h b/fs/ocfs2/dlm/dlmdebug.h
index c6b240f..ca7bc32 100644
--- a/fs/ocfs2/dlm/dlmdebug.h
+++ b/fs/ocfs2/dlm/dlmdebug.h
@@ -30,6 +30,7 @@ struct dlm_debug_ctxt {
 	struct dentry *debug_state_dentry;
 	struct dentry *debug_lockres_dentry;
 	struct dentry *debug_mle_dentry;
+	struct dentry *debug_purgelist_dentry;
 };
 
 struct debug_buffer
-- 
1.5.2.5
