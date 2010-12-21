From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 20 Dec 2010 16:34:59 -0800
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2/dlm: Cleanup dlmdebug.c
In-Reply-To: <1292891701-5111-1-git-send-email-sunil.mushran@oracle.com>
References: <1292891701-5111-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1292891701-5111-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Remove struct debug_buffer in dlmdebug.c/h.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmdebug.c |  178 +++++++++++++++++-----------------------------
 fs/ocfs2/dlm/dlmdebug.h |    5 --
 2 files changed, 66 insertions(+), 117 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index 272ec86..77199ca 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -370,92 +370,46 @@ static void dlm_debug_get(struct dlm_debug_ctxt *dc)
 	kref_get(&dc->debug_refcnt);
 }
 
-static struct debug_buffer *debug_buffer_allocate(void)
+static int debug_release(struct inode *inode, struct file *file)
 {
-	struct debug_buffer *db = NULL;
-
-	db = kzalloc(sizeof(struct debug_buffer), GFP_KERNEL);
-	if (!db)
-		goto bail;
-
-	db->len = PAGE_SIZE;
-	db->buf = kmalloc(db->len, GFP_KERNEL);
-	if (!db->buf)
-		goto bail;
-
-	return db;
-bail:
-	kfree(db);
-	return NULL;
-}
-
-static ssize_t debug_buffer_read(struct file *file, char __user *buf,
-				 size_t nbytes, loff_t *ppos)
-{
-	struct debug_buffer *db = file->private_data;
-
-	return simple_read_from_buffer(buf, nbytes, ppos, db->buf, db->len);
-}
-
-static loff_t debug_buffer_llseek(struct file *file, loff_t off, int whence)
-{
-	struct debug_buffer *db = file->private_data;
-	loff_t new = -1;
-
-	switch (whence) {
-	case 0:
-		new = off;
-		break;
-	case 1:
-		new = file->f_pos + off;
-		break;
-	}
-
-	if (new < 0 || new > db->len)
-		return -EINVAL;
-
-	return (file->f_pos = new);
+	free_page((unsigned long)file->private_data);
+	return 0;
 }
 
-static int debug_buffer_release(struct inode *inode, struct file *file)
+static ssize_t debug_read(struct file *file, char __user *buf,
+			  size_t nbytes, loff_t *ppos)
 {
-	struct debug_buffer *db = file->private_data;
-
-	if (db)
-		kfree(db->buf);
-	kfree(db);
-
-	return 0;
+	return simple_read_from_buffer(buf, nbytes, ppos, file->private_data,
+				       i_size_read(file->f_mapping->host));
 }
 /* end - util funcs */
 
 /* begin - purge list funcs */
-static int debug_purgelist_print(struct dlm_ctxt *dlm, struct debug_buffer *db)
+static int debug_purgelist_print(struct dlm_ctxt *dlm, char *buf, int len)
 {
 	struct dlm_lock_resource *res;
 	int out = 0;
 	unsigned long total = 0;
 
-	out += snprintf(db->buf + out, db->len - out,
+	out += snprintf(buf + out, len - out,
 			"Dumping Purgelist for Domain: %s\n", dlm->name);
 
 	spin_lock(&dlm->spinlock);
 	list_for_each_entry(res, &dlm->purge_list, purge) {
 		++total;
-		if (db->len - out < 100)
+		if (len - out < 100)
 			continue;
 		spin_lock(&res->spinlock);
 		out += stringify_lockname(res->lockname.name,
 					  res->lockname.len,
-					  db->buf + out, db->len - out);
-		out += snprintf(db->buf + out, db->len - out, "\t%ld\n",
+					  buf + out, len - out);
+		out += snprintf(buf + out, len - out, "\t%ld\n",
 				(jiffies - res->last_used)/HZ);
 		spin_unlock(&res->spinlock);
 	}
 	spin_unlock(&dlm->spinlock);
 
-	out += snprintf(db->buf + out, db->len - out,
-			"Total on list: %ld\n", total);
+	out += snprintf(buf + out, len - out, "Total on list: %ld\n", total);
 
 	return out;
 }
@@ -463,15 +417,15 @@ static int debug_purgelist_print(struct dlm_ctxt *dlm, struct debug_buffer *db)
 static int debug_purgelist_open(struct inode *inode, struct file *file)
 {
 	struct dlm_ctxt *dlm = inode->i_private;
-	struct debug_buffer *db;
+	char *buf = NULL;
 
-	db = debug_buffer_allocate();
-	if (!db)
+	buf = (char *) get_zeroed_page(GFP_NOFS);
+	if (!buf)
 		goto bail;
 
-	db->len = debug_purgelist_print(dlm, db);
+	i_size_write(inode, debug_purgelist_print(dlm, buf, PAGE_SIZE - 1));
 
-	file->private_data = db;
+	file->private_data = buf;
 
 	return 0;
 bail:
@@ -480,14 +434,14 @@ bail:
 
 static const struct file_operations debug_purgelist_fops = {
 	.open =		debug_purgelist_open,
-	.release =	debug_buffer_release,
-	.read =		debug_buffer_read,
-	.llseek =	debug_buffer_llseek,
+	.release =	debug_release,
+	.read =		debug_read,
+	.llseek =	generic_file_llseek,
 };
 /* end - purge list funcs */
 
 /* begin - debug mle funcs */
-static int debug_mle_print(struct dlm_ctxt *dlm, struct debug_buffer *db)
+static int debug_mle_print(struct dlm_ctxt *dlm, char *buf, int len)
 {
 	struct dlm_master_list_entry *mle;
 	struct hlist_head *bucket;
@@ -495,7 +449,7 @@ static int debug_mle_print(struct dlm_ctxt *dlm, struct debug_buffer *db)
 	int i, out = 0;
 	unsigned long total = 0, longest = 0, bucket_count = 0;
 
-	out += snprintf(db->buf + out, db->len - out,
+	out += snprintf(buf + out, len - out,
 			"Dumping MLEs for Domain: %s\n", dlm->name);
 
 	spin_lock(&dlm->master_lock);
@@ -506,16 +460,16 @@ static int debug_mle_print(struct dlm_ctxt *dlm, struct debug_buffer *db)
 					  master_hash_node);
 			++total;
 			++bucket_count;
-			if (db->len - out < 200)
+			if (len - out < 200)
 				continue;
-			out += dump_mle(mle, db->buf + out, db->len - out);
+			out += dump_mle(mle, buf + out, len - out);
 		}
 		longest = max(longest, bucket_count);
 		bucket_count = 0;
 	}
 	spin_unlock(&dlm->master_lock);
 
-	out += snprintf(db->buf + out, db->len - out,
+	out += snprintf(buf + out, len - out,
 			"Total: %ld, Longest: %ld\n", total, longest);
 	return out;
 }
@@ -523,15 +477,15 @@ static int debug_mle_print(struct dlm_ctxt *dlm, struct debug_buffer *db)
 static int debug_mle_open(struct inode *inode, struct file *file)
 {
 	struct dlm_ctxt *dlm = inode->i_private;
-	struct debug_buffer *db;
+	char *buf = NULL;
 
-	db = debug_buffer_allocate();
-	if (!db)
+	buf = (char *) get_zeroed_page(GFP_NOFS);
+	if (!buf)
 		goto bail;
 
-	db->len = debug_mle_print(dlm, db);
+	i_size_write(inode, debug_mle_print(dlm, buf, PAGE_SIZE - 1));
 
-	file->private_data = db;
+	file->private_data = buf;
 
 	return 0;
 bail:
@@ -540,9 +494,9 @@ bail:
 
 static const struct file_operations debug_mle_fops = {
 	.open =		debug_mle_open,
-	.release =	debug_buffer_release,
-	.read =		debug_buffer_read,
-	.llseek =	debug_buffer_llseek,
+	.release =	debug_release,
+	.read =		debug_read,
+	.llseek =	generic_file_llseek,
 };
 
 /* end - debug mle funcs */
@@ -757,7 +711,7 @@ static const struct file_operations debug_lockres_fops = {
 /* end - debug lockres funcs */
 
 /* begin - debug state funcs */
-static int debug_state_print(struct dlm_ctxt *dlm, struct debug_buffer *db)
+static int debug_state_print(struct dlm_ctxt *dlm, char *buf, int len)
 {
 	int out = 0;
 	struct dlm_reco_node_data *node;
@@ -781,35 +735,35 @@ static int debug_state_print(struct dlm_ctxt *dlm, struct debug_buffer *db)
 	}
 
 	/* Domain: xxxxxxxxxx  Key: 0xdfbac769 */
-	out += snprintf(db->buf + out, db->len - out,
+	out += snprintf(buf + out, len - out,
 			"Domain: %s  Key: 0x%08x  Protocol: %d.%d\n",
 			dlm->name, dlm->key, dlm->dlm_locking_proto.pv_major,
 			dlm->dlm_locking_proto.pv_minor);
 
 	/* Thread Pid: xxx  Node: xxx  State: xxxxx */
-	out += snprintf(db->buf + out, db->len - out,
+	out += snprintf(buf + out, len - out,
 			"Thread Pid: %d  Node: %d  State: %s\n",
 			dlm->dlm_thread_task->pid, dlm->node_num, state);
 
 	/* Number of Joins: xxx  Joining Node: xxx */
-	out += snprintf(db->buf + out, db->len - out,
+	out += snprintf(buf + out, len - out,
 			"Number of Joins: %d  Joining Node: %d\n",
 			dlm->num_joins, dlm->joining_node);
 
 	/* Domain Map: xx xx xx */
-	out += snprintf(db->buf + out, db->len - out, "Domain Map: ");
+	out += snprintf(buf + out, len - out, "Domain Map: ");
 	out += stringify_nodemap(dlm->domain_map, O2NM_MAX_NODES,
-				 db->buf + out, db->len - out);
-	out += snprintf(db->buf + out, db->len - out, "\n");
+				 buf + out, len - out);
+	out += snprintf(buf + out, len - out, "\n");
 
 	/* Live Map: xx xx xx */
-	out += snprintf(db->buf + out, db->len - out, "Live Map: ");
+	out += snprintf(buf + out, len - out, "Live Map: ");
 	out += stringify_nodemap(dlm->live_nodes_map, O2NM_MAX_NODES,
-				 db->buf + out, db->len - out);
-	out += snprintf(db->buf + out, db->len - out, "\n");
+				 buf + out, len - out);
+	out += snprintf(buf + out, len - out, "\n");
 
 	/* Lock Resources: xxx (xxx) */
-	out += snprintf(db->buf + out, db->len - out,
+	out += snprintf(buf + out, len - out,
 			"Lock Resources: %d (%d)\n",
 			atomic_read(&dlm->res_cur_count),
 			atomic_read(&dlm->res_tot_count));
@@ -821,29 +775,29 @@ static int debug_state_print(struct dlm_ctxt *dlm, struct debug_buffer *db)
 		cur_mles += atomic_read(&dlm->mle_cur_count[i]);
 
 	/* MLEs: xxx (xxx) */
-	out += snprintf(db->buf + out, db->len - out,
+	out += snprintf(buf + out, len - out,
 			"MLEs: %d (%d)\n", cur_mles, tot_mles);
 
 	/*  Blocking: xxx (xxx) */
-	out += snprintf(db->buf + out, db->len - out,
+	out += snprintf(buf + out, len - out,
 			"  Blocking: %d (%d)\n",
 			atomic_read(&dlm->mle_cur_count[DLM_MLE_BLOCK]),
 			atomic_read(&dlm->mle_tot_count[DLM_MLE_BLOCK]));
 
 	/*  Mastery: xxx (xxx) */
-	out += snprintf(db->buf + out, db->len - out,
+	out += snprintf(buf + out, len - out,
 			"  Mastery: %d (%d)\n",
 			atomic_read(&dlm->mle_cur_count[DLM_MLE_MASTER]),
 			atomic_read(&dlm->mle_tot_count[DLM_MLE_MASTER]));
 
 	/*  Migration: xxx (xxx) */
-	out += snprintf(db->buf + out, db->len - out,
+	out += snprintf(buf + out, len - out,
 			"  Migration: %d (%d)\n",
 			atomic_read(&dlm->mle_cur_count[DLM_MLE_MIGRATION]),
 			atomic_read(&dlm->mle_tot_count[DLM_MLE_MIGRATION]));
 
 	/* Lists: Dirty=Empty  Purge=InUse  PendingASTs=Empty  ... */
-	out += snprintf(db->buf + out, db->len - out,
+	out += snprintf(buf + out, len - out,
 			"Lists: Dirty=%s  Purge=%s  PendingASTs=%s  "
 			"PendingBASTs=%s\n",
 			(list_empty(&dlm->dirty_list) ? "Empty" : "InUse"),
@@ -852,12 +806,12 @@ static int debug_state_print(struct dlm_ctxt *dlm, struct debug_buffer *db)
 			(list_empty(&dlm->pending_basts) ? "Empty" : "InUse"));
 
 	/* Purge Count: xxx  Refs: xxx */
-	out += snprintf(db->buf + out, db->len - out,
+	out += snprintf(buf + out, len - out,
 			"Purge Count: %d  Refs: %d\n", dlm->purge_count,
 			atomic_read(&dlm->dlm_refs.refcount));
 
 	/* Dead Node: xxx */
-	out += snprintf(db->buf + out, db->len - out,
+	out += snprintf(buf + out, len - out,
 			"Dead Node: %d\n", dlm->reco.dead_node);
 
 	/* What about DLM_RECO_STATE_FINALIZE? */
@@ -867,19 +821,19 @@ static int debug_state_print(struct dlm_ctxt *dlm, struct debug_buffer *db)
 		state = "INACTIVE";
 
 	/* Recovery Pid: xxxx  Master: xxx  State: xxxx */
-	out += snprintf(db->buf + out, db->len - out,
+	out += snprintf(buf + out, len - out,
 			"Recovery Pid: %d  Master: %d  State: %s\n",
 			dlm->dlm_reco_thread_task->pid,
 			dlm->reco.new_master, state);
 
 	/* Recovery Map: xx xx */
-	out += snprintf(db->buf + out, db->len - out, "Recovery Map: ");
+	out += snprintf(buf + out, len - out, "Recovery Map: ");
 	out += stringify_nodemap(dlm->recovery_map, O2NM_MAX_NODES,
-				 db->buf + out, db->len - out);
-	out += snprintf(db->buf + out, db->len - out, "\n");
+				 buf + out, len - out);
+	out += snprintf(buf + out, len - out, "\n");
 
 	/* Recovery Node State: */
-	out += snprintf(db->buf + out, db->len - out, "Recovery Node State:\n");
+	out += snprintf(buf + out, len - out, "Recovery Node State:\n");
 	list_for_each_entry(node, &dlm->reco.node_data, list) {
 		switch (node->state) {
 		case DLM_RECO_NODE_DATA_INIT:
@@ -907,7 +861,7 @@ static int debug_state_print(struct dlm_ctxt *dlm, struct debug_buffer *db)
 			state = "BAD";
 			break;
 		}
-		out += snprintf(db->buf + out, db->len - out, "\t%u - %s\n",
+		out += snprintf(buf + out, len - out, "\t%u - %s\n",
 				node->node_num, state);
 	}
 
@@ -919,15 +873,15 @@ static int debug_state_print(struct dlm_ctxt *dlm, struct debug_buffer *db)
 static int debug_state_open(struct inode *inode, struct file *file)
 {
 	struct dlm_ctxt *dlm = inode->i_private;
-	struct debug_buffer *db = NULL;
+	char *buf = NULL;
 
-	db = debug_buffer_allocate();
-	if (!db)
+	buf = (char *) get_zeroed_page(GFP_NOFS);
+	if (!buf)
 		goto bail;
 
-	db->len = debug_state_print(dlm, db);
+	i_size_write(inode, debug_state_print(dlm, buf, PAGE_SIZE - 1));
 
-	file->private_data = db;
+	file->private_data = buf;
 
 	return 0;
 bail:
@@ -936,9 +890,9 @@ bail:
 
 static const struct file_operations debug_state_fops = {
 	.open =		debug_state_open,
-	.release =	debug_buffer_release,
-	.read =		debug_buffer_read,
-	.llseek =	debug_buffer_llseek,
+	.release =	debug_release,
+	.read =		debug_read,
+	.llseek =	generic_file_llseek,
 };
 /* end  - debug state funcs */
 
diff --git a/fs/ocfs2/dlm/dlmdebug.h b/fs/ocfs2/dlm/dlmdebug.h
index 8c686d2..1f27c48 100644
--- a/fs/ocfs2/dlm/dlmdebug.h
+++ b/fs/ocfs2/dlm/dlmdebug.h
@@ -37,11 +37,6 @@ struct dlm_debug_ctxt {
 	struct dentry *debug_purgelist_dentry;
 };
 
-struct debug_buffer {
-	int len;
-	char *buf;
-};
-
 struct debug_lockres {
 	int dl_len;
 	char *dl_buf;
-- 
1.7.1
