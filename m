From: Mark Fasheh <mfasheh@suse.com>
Date: Wed,  2 Apr 2008 13:14:54 -0700
Subject: [Ocfs2-devel] [PATCH 44/62] ocfs2/dlm: Dumps the mles into a
	debugfs file
In-Reply-To: <12071674083120-git-send-email-mfasheh@suse.com>
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
	<12071674013954-git-send-email-mfasheh@suse.com>
	<12071674033903-git-send-email-mfasheh@suse.com>
	<12071674061934-git-send-email-mfasheh@suse.com>
	<12071674083120-git-send-email-mfasheh@suse.com>
Message-ID: <12071674103432-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Sunil Mushran <sunil.mushran@oracle.com>

From: Sunil Mushran <sunil.mushran@oracle.com>

This patch dumps all mles it can fit in one page into a debugfs file.
Useful for debugging.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dlm/dlmdebug.c |  119 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/dlm/dlmdebug.h |    1 +
 2 files changed, 120 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index cccb1ce..6de326b 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -302,6 +302,7 @@ static int stringify_lockname(const char *lockname, int locklen,
 #define DLM_DEBUGFS_DIR				"o2dlm"
 #define DLM_DEBUGFS_DLM_STATE			"dlm_state"
 #define DLM_DEBUGFS_LOCKING_STATE		"locking_state"
+#define DLM_DEBUGFS_MLE_STATE			"mle_state"
 
 /* begin - utils funcs */
 static void dlm_debug_free(struct kref *kref)
@@ -395,6 +396,112 @@ static int debug_buffer_release(struct inode *inode, struct file *file)
 }
 /* end - util funcs */
 
+/* begin - debug mle funcs */
+static int dump_mle(struct dlm_master_list_entry *mle, char *buf, int len)
+{
+	int out = 0;
+	unsigned int namelen;
+	const char *name;
+	char *mle_type;
+
+	if (mle->type != DLM_MLE_MASTER) {
+		namelen = mle->u.name.len;
+		name = mle->u.name.name;
+	} else {
+		namelen = mle->u.res->lockname.len;
+		name = mle->u.res->lockname.name;
+	}
+
+	if (mle->type == DLM_MLE_BLOCK)
+		mle_type = "BLK";
+	else if (mle->type == DLM_MLE_MASTER)
+		mle_type = "MAS";
+	else
+		mle_type = "MIG";
+
+	out += stringify_lockname(name, namelen, buf + out, len - out);
+	out += snprintf(buf + out, len - out,
+			"\t%3s\tmas=%3u\tnew=%3u\tevt=%1d\tuse=%1d\tref=%3d\n",
+			mle_type, mle->master, mle->new_master,
+			!list_empty(&mle->hb_events),
+			!!mle->inuse,
+			atomic_read(&mle->mle_refs.refcount));
+
+	out += snprintf(buf + out, len - out, "Maybe=");
+	out += stringify_nodemap(mle->maybe_map, O2NM_MAX_NODES,
+				 buf + out, len - out);
+	out += snprintf(buf + out, len - out, "\n");
+
+	out += snprintf(buf + out, len - out, "Vote=");
+	out += stringify_nodemap(mle->vote_map, O2NM_MAX_NODES,
+				 buf + out, len - out);
+	out += snprintf(buf + out, len - out, "\n");
+
+	out += snprintf(buf + out, len - out, "Response=");
+	out += stringify_nodemap(mle->response_map, O2NM_MAX_NODES,
+				 buf + out, len - out);
+	out += snprintf(buf + out, len - out, "\n");
+
+	out += snprintf(buf + out, len - out, "Node=");
+	out += stringify_nodemap(mle->node_map, O2NM_MAX_NODES,
+				 buf + out, len - out);
+	out += snprintf(buf + out, len - out, "\n");
+
+	out += snprintf(buf + out, len - out, "\n");
+
+	return out;
+}
+
+static int debug_mle_print(struct dlm_ctxt *dlm, struct debug_buffer *db)
+{
+	struct dlm_master_list_entry *mle;
+	int out = 0;
+	unsigned long total = 0;
+
+	out += snprintf(db->buf + out, db->len - out,
+			"Dumping MLEs for Domain: %s\n", dlm->name);
+
+	spin_lock(&dlm->master_lock);
+	list_for_each_entry(mle, &dlm->master_list, list) {
+		++total;
+		if (db->len - out < 200)
+			continue;
+		out += dump_mle(mle, db->buf + out, db->len - out);
+	}
+	spin_unlock(&dlm->master_lock);
+
+	out += snprintf(db->buf + out, db->len - out,
+			"Total on list: %ld\n", total);
+	return out;
+}
+
+static int debug_mle_open(struct inode *inode, struct file *file)
+{
+	struct dlm_ctxt *dlm = inode->i_private;
+	struct debug_buffer *db;
+
+	db = debug_buffer_allocate();
+	if (!db)
+		goto bail;
+
+	db->len = debug_mle_print(dlm, db);
+
+	file->private_data = db;
+
+	return 0;
+bail:
+	return -ENOMEM;
+}
+
+static struct file_operations debug_mle_fops = {
+	.open =		debug_mle_open,
+	.release =	debug_buffer_release,
+	.read =		debug_buffer_read,
+	.llseek =	debug_buffer_llseek,
+};
+
+/* end - debug mle funcs */
+
 /* begin - debug lockres funcs */
 static int dump_lock(struct dlm_lock *lock, int list_type, char *buf, int len)
 {
@@ -789,6 +896,16 @@ int dlm_debug_init(struct dlm_ctxt *dlm)
 		goto bail;
 	}
 
+	/* for dumping mles */
+	dc->debug_mle_dentry = debugfs_create_file(DLM_DEBUGFS_MLE_STATE,
+						   S_IFREG|S_IRUSR,
+						   dlm->dlm_debugfs_subroot,
+						   dlm, &debug_mle_fops);
+	if (!dc->debug_mle_dentry) {
+		mlog_errno(-ENOMEM);
+		goto bail;
+	}
+
 	dlm_debug_get(dc);
 	return 0;
 
@@ -802,6 +919,8 @@ void dlm_debug_shutdown(struct dlm_ctxt *dlm)
 	struct dlm_debug_ctxt *dc = dlm->dlm_debug_ctxt;
 
 	if (dc) {
+		if (dc->debug_mle_dentry)
+			debugfs_remove(dc->debug_mle_dentry);
 		if (dc->debug_lockres_dentry)
 			debugfs_remove(dc->debug_lockres_dentry);
 		if (dc->debug_state_dentry)
diff --git a/fs/ocfs2/dlm/dlmdebug.h b/fs/ocfs2/dlm/dlmdebug.h
index 7c5b2b0..cbc69f2 100644
--- a/fs/ocfs2/dlm/dlmdebug.h
+++ b/fs/ocfs2/dlm/dlmdebug.h
@@ -31,6 +31,7 @@ struct dlm_debug_ctxt {
 	struct kref debug_refcnt;
 	struct dentry *debug_state_dentry;
 	struct dentry *debug_lockres_dentry;
+	struct dentry *debug_mle_dentry;
 };
 
 struct debug_buffer {
-- 
1.5.4.1
