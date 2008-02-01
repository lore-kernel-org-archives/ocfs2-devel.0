From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri Feb  1 16:50:04 2008
Subject: [Ocfs2-devel] [PATCH 07/12] ocfs2_dlm: Dumps the lockres' into a
	debugfs file
In-Reply-To: <1201913371-1522-1-git-send-email-sunil.mushran@oracle.com>
References: <1201913371-1522-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1201913371-1522-8-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch dumps all the lockres' alongwith all the locks into
a debugfs file. Useful for debugging.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmdebug.c |  225 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/dlm/dlmdebug.h |    9 ++
 2 files changed, 234 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index 124856b..a89bfe7 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -794,6 +794,219 @@ static int debug_buffer_release(struct inode *inode, struct file *file)
 
 /* end - util funcs */
 
+/* begin - debug lockres funcs */
+static int dump_lock(char *buf, int len, int list_type, struct dlm_lock *lock)
+{
+	int out;
+
+#define DEBUG_LOCK_VERSION	1
+	spin_lock(&lock->spinlock);
+	out = snprintf(buf, len, "LOCK:%d,%d,%d,%d,%d,%d:%lld,%d,%d,%d,%d\n",
+		       DEBUG_LOCK_VERSION,
+		       list_type, lock->ml.type, lock->ml.convert_type,
+		       lock->ml.node,
+		       dlm_get_lock_cookie_node(be64_to_cpu(lock->ml.cookie)),
+		       dlm_get_lock_cookie_seq(be64_to_cpu(lock->ml.cookie)),
+		       !list_empty(&lock->ast_list), lock->ast_pending,
+		       !list_empty(&lock->bast_list), lock->bast_pending);
+	spin_unlock(&lock->spinlock);
+
+	return out;
+}
+
+static int dump_lockres(struct debug_lockres *dl)
+{
+	struct dlm_ctxt *dlm;
+	struct dlm_lock_resource *res;
+	struct dlm_lock *lock;
+	int i;
+	int out = 0;
+
+	if (!dl)
+		return 0;
+
+	dlm = dl->dl_ctxt;
+	res = dl->dl_res;
+
+	assert_spin_locked(&dlm->spinlock);
+	spin_lock(&res->spinlock);
+
+	out += snprintf(dl->dl_buf + out, dl->dl_len - out,
+			"%.*s\n",
+			res->lockname.len, res->lockname.name);
+
+#define DEBUG_LRES_VERSION	1
+	out += snprintf(dl->dl_buf + out, dl->dl_len - out,
+			"LRES:%d,%d,%d,%ld,%d,%d,%d,%d,%d\n",
+			DEBUG_LRES_VERSION,
+			res->owner, res->state, res->last_used,
+			!list_empty(&res->purge), res->inflight_locks,
+			atomic_read(&res->refs.refcount),
+			res->migration_pending,
+			atomic_read(&res->asts_reserved));
+
+	/* refmap */
+	out += snprintf(dl->dl_buf + out, dl->dl_len - out, "REFMAP:");
+	out += stringify_nodemap(res->refmap, O2NM_MAX_NODES,
+				 dl->dl_buf + out, dl->dl_len - out);
+	out += snprintf(dl->dl_buf + out, dl->dl_len - out, "\n");
+
+	/* lvb */
+	out += snprintf(dl->dl_buf + out, dl->dl_len - out, "LVB:");
+	for (i = 0; i < DLM_LVB_LEN; i++)
+		out += snprintf(dl->dl_buf + out, dl->dl_len - out,
+					"%02X", (unsigned char)res->lvb[i]);
+	out += snprintf(dl->dl_buf + out, dl->dl_len - out, "\n");
+
+	/* granted */
+	list_for_each_entry(lock, &res->granted, list)
+		out += dump_lock(dl->dl_buf + out, dl->dl_len - out, 0, lock);
+
+	/* converting */
+	list_for_each_entry(lock, &res->converting, list)
+		out += dump_lock(dl->dl_buf + out, dl->dl_len - out, 1, lock);
+
+	/* blocked */
+	list_for_each_entry(lock, &res->blocked, list)
+		out += dump_lock(dl->dl_buf + out, dl->dl_len - out, 2, lock);
+
+	out += snprintf(dl->dl_buf + out, dl->dl_len - out, "\n");
+
+	spin_unlock(&res->spinlock);
+
+	return out;
+}
+
+static void *lockres_seq_start(struct seq_file *m, loff_t *pos)
+{
+	struct debug_lockres *dl = m->private;
+	struct dlm_ctxt *dlm = dl->dl_ctxt;
+	struct dlm_lock_resource *res = NULL;
+
+	spin_lock(&dlm->spinlock);
+
+	if (dl->dl_res) {
+		list_for_each_entry(res, &dl->dl_res->tracking, tracking) {
+			if (dl->dl_res) {
+				dlm_lockres_put(dl->dl_res);
+				dl->dl_res = NULL;
+			}
+			if (&res->tracking == &dlm->tracking_list) {
+				mlog(0, "End of list found, %p\n", res);
+				dl = NULL;
+				break;
+			}
+			mlog(0, "res=%p, name=%.*s\n", res,
+			     res->lockname.len, res->lockname.name);
+			dlm_lockres_get(res);
+			dl->dl_res = res;
+			break;
+		}
+	} else {
+		if (!list_empty(&dlm->tracking_list)) {
+			list_for_each_entry(res, &dlm->tracking_list, tracking)
+				break;
+			mlog(0, "res=%p, name=%.*s\n", res,
+			     res->lockname.len, res->lockname.name);
+			dlm_lockres_get(res);
+			dl->dl_res = res;
+		} else
+			dl = NULL;
+	}
+
+	dump_lockres(dl);
+
+	spin_unlock(&dlm->spinlock);
+
+	return dl;
+}
+
+static void lockres_seq_stop(struct seq_file *m, void *v)
+{
+}
+
+static void *lockres_seq_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	return NULL;
+}
+
+static int lockres_seq_show(struct seq_file *s, void *v)
+{
+	struct debug_lockres *dl = (struct debug_lockres *)v;
+
+	seq_printf(s, "%s", dl->dl_buf);
+
+	return 0;
+}
+
+static struct seq_operations debug_lockres_ops = {
+	.start =	lockres_seq_start,
+	.stop =		lockres_seq_stop,
+	.next =		lockres_seq_next,
+	.show =		lockres_seq_show,
+};
+
+static int debug_lockres_open(struct inode *inode, struct file *file)
+{
+	struct dlm_ctxt *dlm = inode->i_private;
+	int ret = -ENOMEM;
+	struct seq_file *seq;
+	struct debug_lockres *dl = NULL;
+
+	dl = kzalloc(sizeof(struct debug_lockres), GFP_KERNEL);
+	if (!dl) {
+		mlog_errno(ret);
+		goto bail;
+	}
+
+	dl->dl_len = PAGE_SIZE;
+	dl->dl_buf = kmalloc(dl->dl_len, GFP_KERNEL);
+	if (!dl->dl_buf) {
+		mlog_errno(ret);
+		goto bail;
+	}
+
+	ret = seq_open(file, &debug_lockres_ops);
+	if (ret) {
+		mlog_errno(ret);
+		goto bail;
+	}
+
+	seq = (struct seq_file *) file->private_data;
+	seq->private = dl;
+
+	dlm_grab(dlm);
+	dl->dl_ctxt = dlm;
+
+	return 0;
+bail:
+	if (dl && dl->dl_buf)
+		kfree(dl->dl_buf);
+	if (dl)
+		kfree(dl);
+	return ret;
+}
+
+static int debug_lockres_release(struct inode *inode, struct file *file)
+{
+	struct seq_file *seq = (struct seq_file *)file->private_data;
+	struct debug_lockres *dl = (struct debug_lockres *)seq->private;
+
+	if (dl->dl_res)
+		dlm_lockres_put(dl->dl_res);
+	dlm_put(dl->dl_ctxt);
+	kfree(dl->dl_buf);
+	return seq_release_private(inode, file);
+}
+
+static struct file_operations debug_lockres_fops = {
+	.open =		debug_lockres_open,
+	.release =	debug_lockres_release,
+	.read =		seq_read,
+	.llseek =	seq_lseek,
+};
+/* end - debug lockres funcs */
+
 /* begin - debug state funcs */
 static int debug_state_print(struct dlm_ctxt *dlm, struct debug_buffer *db)
 {
@@ -951,6 +1164,16 @@ int dlm_debug_init(struct dlm_ctxt *dlm)
 		goto bail;
 	}
 
+	/* for dumping lockres */
+	dc->debug_lockres_dentry =
+			debugfs_create_file("lockres", S_IFREG|S_IRUSR,
+					    dlm->dlm_debugfs_subroot,
+					    dlm, &debug_lockres_fops);
+	if (!dc->debug_lockres_dentry) {
+		mlog_errno(-ENOMEM);
+		goto bail;
+	}
+
 	dlm_debug_get(dc);
 	return 0;
 
@@ -964,6 +1187,8 @@ void dlm_debug_shutdown(struct dlm_ctxt *dlm)
 	struct dlm_debug_ctxt *dc = dlm->dlm_debug_ctxt;
 
 	if (dc) {
+		if (dc->debug_lockres_dentry)
+			debugfs_remove(dc->debug_lockres_dentry);
 		if (dc->debug_state_dentry)
 			debugfs_remove(dc->debug_state_dentry);
 		dlm_debug_put(dc);
diff --git a/fs/ocfs2/dlm/dlmdebug.h b/fs/ocfs2/dlm/dlmdebug.h
index 50cb10f..86d02f4 100644
--- a/fs/ocfs2/dlm/dlmdebug.h
+++ b/fs/ocfs2/dlm/dlmdebug.h
@@ -28,6 +28,7 @@
 struct dlm_debug_ctxt {
 	struct kref debug_refcnt;
 	struct dentry *debug_state_dentry;
+	struct dentry *debug_lockres_dentry;
 };
 
 struct debug_buffer
@@ -36,6 +37,14 @@ struct debug_buffer
 	char *buf;
 };
 
+struct debug_lockres
+{
+	int dl_len;
+	char *dl_buf;
+	struct dlm_ctxt *dl_ctxt;
+	struct dlm_lock_resource *dl_res;
+};
+
 void dlm_remove_proc(void);
 void dlm_init_proc(void);
 void dlm_dump_lock_resources(struct dlm_ctxt *dlm);
-- 
1.5.2.5
