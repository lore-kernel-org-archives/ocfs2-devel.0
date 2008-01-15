From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue Jan 15 10:43:00 2008
Subject: [Ocfs2-devel] [PATCH 2/2] dlm: Forward ported the dlm debugging
	from 1.2 to 1.4
In-Reply-To: <1200422553-21064-1-git-send-email-sunil.mushran@oracle.com>
References: <1200422553-21064-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1200422553-21064-3-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This is a temporary patch and will be replaced with the new
dlm debug infrastructure based on seqfiles and debugfs. We
are adding this inorder to be able to debug dlm issues during
1.4 testing.

Signed-off-by: Sunil Mushran sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/Makefile                    |    3 +-
 fs/ocfs2/dlm/dlmcommon.h                 |    9 +-
 fs/ocfs2/dlm/dlmdebug.c                  |  471 ++++++++++++++++++++++++++++--
 fs/ocfs2/dlm/{dlmdomain.h => dlmdebug.h} |   20 +-
 fs/ocfs2/dlm/dlmdomain.c                 |   11 +-
 fs/ocfs2/dlm/dlmdomain.h                 |    1 +
 fs/ocfs2/dlm/dlmmaster.c                 |    9 +-
 fs/ocfs2/dlm/dlmrecovery.c               |    8 +-
 8 files changed, 486 insertions(+), 46 deletions(-)
 copy fs/ocfs2/dlm/{dlmdomain.h => dlmdebug.h} (74%)

diff --git a/fs/ocfs2/dlm/Makefile b/fs/ocfs2/dlm/Makefile
index 0ecea70..47c3b53 100644
--- a/fs/ocfs2/dlm/Makefile
+++ b/fs/ocfs2/dlm/Makefile
@@ -70,7 +70,8 @@ HEADERS += 			\
 	dlmdomain.h		\
 	dlmfsver.h		\
 	dlmver.h		\
-	userdlm.h
+	userdlm.h		\
+	dlmdebug.h
 
 DLM_OBJECTS = $(subst .c,.o,$(DLM_SOURCES))
 DLMFS_OBJECTS = $(subst .c,.o,$(DLMFS_SOURCES))
diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index cddf85a..f3afb15 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -117,6 +117,8 @@ struct dlm_ctxt
 	struct list_head master_list;
 	struct list_head mle_hb_events;
 
+	struct proc_dir_entry *dlm_proc;
+
 	/* these give a really vague idea of the system load */
 	atomic_t local_resources;
 	atomic_t remote_resources;
@@ -878,6 +880,8 @@ int dlm_heartbeat_init(struct dlm_ctxt *dlm);
 void dlm_hb_node_down_cb(struct o2nm_node *node, int idx, void *data);
 void dlm_hb_node_up_cb(struct o2nm_node *node, int idx, void *data);
 
+int dlm_migrate_lockres(struct dlm_ctxt *dlm, struct dlm_lock_resource *res,
+			u8 target);
 int dlm_empty_lockres(struct dlm_ctxt *dlm, struct dlm_lock_resource *res);
 int dlm_finish_migration(struct dlm_ctxt *dlm,
 			 struct dlm_lock_resource *res,
@@ -916,7 +920,9 @@ int dlm_dispatch_assert_master(struct dlm_ctxt *dlm,
 			       int ignore_higher,
 			       u8 request_from,
 			       u32 flags);
-
+void dlm_assert_master_worker(struct dlm_work_item *item, void *data);
+void dlm_request_all_locks_worker(struct dlm_work_item *item, void *data);
+void dlm_mig_lockres_worker(struct dlm_work_item *item, void *data);
 
 int dlm_send_one_lockres(struct dlm_ctxt *dlm,
 			 struct dlm_lock_resource *res,
@@ -947,6 +953,7 @@ int dlm_drop_lockres_ref(struct dlm_ctxt *dlm,
 void dlm_clean_master_list(struct dlm_ctxt *dlm,
 			   u8 dead_node);
 int dlm_lock_basts_flushed(struct dlm_ctxt *dlm, struct dlm_lock *lock);
+int dlm_dump_all_mles(const char __user *data, unsigned int len);
 int __dlm_lockres_has_locks(struct dlm_lock_resource *res);
 int __dlm_lockres_unused(struct dlm_lock_resource *res);
 
diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index 64239b3..068dd98 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -30,6 +30,7 @@
 #include <linux/utsname.h>
 #include <linux/sysctl.h>
 #include <linux/spinlock.h>
+#include <linux/proc_fs.h>
 
 #include "cluster/heartbeat.h"
 #include "cluster/nodemanager.h"
@@ -37,20 +38,235 @@
 
 #include "dlmapi.h"
 #include "dlmcommon.h"
+#include "dlmdebug.h"
 
 #include "dlmdomain.h"
+#include "dlmdebug.h"
 
 #define MLOG_MASK_PREFIX ML_DLM
 #include "cluster/masklog.h"
 
-void dlm_print_one_lock_resource(struct dlm_lock_resource *res)
+static int dlm_dump_all_lock_resources(const char __user *data,
+					unsigned int len);
+static void dlm_dump_purge_list(struct dlm_ctxt *dlm);
+static int dlm_dump_all_purge_lists(const char __user *data, unsigned int len);
+static int dlm_trigger_migration(const char __user *data, unsigned int len);
+static int dlm_dump_one_lock_resource(const char __user *data,
+				       unsigned int len);
+static int dlm_dump_work_queues(const char __user *data, unsigned int len);
+
+static int dlm_parse_domain_and_lockres(char *buf, unsigned int len,
+					struct dlm_ctxt **dlm,
+					struct dlm_lock_resource **res);
+
+static int dlm_proc_stats(char *page, char **start, off_t off,
+			  int count, int *eof, void *data);
+
+typedef int (dlm_debug_func_t)(const char __user *data, unsigned int len);
+
+struct dlm_debug_funcs
 {
-	mlog(ML_NOTICE, "lockres: %.*s, owner=%u, state=%u\n",
-	       res->lockname.len, res->lockname.name,
-	       res->owner, res->state);
-	spin_lock(&res->spinlock);
-	__dlm_print_one_lock_resource(res);
-	spin_unlock(&res->spinlock);
+	char key;
+	dlm_debug_func_t *func;
+};
+
+static struct dlm_debug_funcs dlm_debug_map[] = {
+	{ 'r', dlm_dump_all_lock_resources },
+	{ 'R', dlm_dump_one_lock_resource },
+	{ 'm', dlm_dump_all_mles },
+	{ 'p', dlm_dump_all_purge_lists  },
+	{ 'M', dlm_trigger_migration },
+	{ 'w', dlm_dump_work_queues }
+};
+static int dlm_debug_map_sz = (sizeof(dlm_debug_map) /
+			       sizeof(struct dlm_debug_funcs));
+
+static ssize_t write_dlm_debug(struct file *file, const char __user *buf,
+			       size_t count, loff_t *ppos)
+{
+	int i;
+	char c;
+	dlm_debug_func_t *fn;
+	int ret;
+
+	mlog(0, "(%p, %p, %u, %lld)\n",
+		  file, buf, (unsigned int)count, (long long)*ppos);
+	ret = 0;
+	if (count<=0)
+		goto done;
+
+	ret = -EFAULT;
+	if (get_user(c, buf))
+		goto done;
+
+	ret = count;
+	for (i=0; i < dlm_debug_map_sz; i++) {
+		struct dlm_debug_funcs *d = &dlm_debug_map[i];
+		if (c == d->key) {
+			fn = d->func;
+			if (fn)
+				ret = (fn)(buf, count);
+			goto done;
+		}
+	}
+done:
+	return ret;
+}
+
+static struct file_operations dlm_debug_operations = {
+	.write          = write_dlm_debug,
+};
+
+#define OCFS2_DLM_PROC_PATH "fs/ocfs2_dlm"
+#define DLM_DEBUG_PROC_NAME "debug"
+#define DLM_STAT_PROC_NAME  "stat"
+
+static struct proc_dir_entry *ocfs2_dlm_proc;
+
+void dlm_remove_proc(void)
+{
+	if (ocfs2_dlm_proc) {
+		remove_proc_entry(DLM_DEBUG_PROC_NAME, ocfs2_dlm_proc);
+		remove_proc_entry(OCFS2_DLM_PROC_PATH, NULL);
+	}
+}
+
+void dlm_init_proc(void)
+{
+	struct proc_dir_entry *entry;
+
+	ocfs2_dlm_proc = proc_mkdir(OCFS2_DLM_PROC_PATH, NULL);
+	if (!ocfs2_dlm_proc) {
+		mlog_errno(-ENOMEM);
+		return;
+	}
+
+	entry = create_proc_entry(DLM_DEBUG_PROC_NAME, S_IWUSR,
+				  ocfs2_dlm_proc);
+	if (entry)
+		entry->proc_fops = &dlm_debug_operations;
+}
+
+static int dlm_proc_stats(char *page, char **start, off_t off,
+			  int count, int *eof, void *data)
+{
+	int len;
+	struct dlm_ctxt *dlm = data;
+
+	len = sprintf(page, "local=%d, remote=%d, unknown=%d, key=0x%08x\n",
+		      atomic_read(&dlm->local_resources),
+		      atomic_read(&dlm->remote_resources),
+		      atomic_read(&dlm->unknown_resources),
+		      dlm->key);
+
+	if (len <= off + count)
+		*eof = 1;
+
+	*start = page + off;
+	len -= off;
+	if (len > count)
+		len = count;
+	if (len < 0)
+		len = 0;
+
+	return len;
+}
+
+void dlm_proc_add_domain(struct dlm_ctxt *dlm)
+{
+	struct proc_dir_entry *entry;
+
+	dlm->dlm_proc = proc_mkdir(dlm->name, ocfs2_dlm_proc);
+	if (dlm->dlm_proc) {
+		entry = create_proc_read_entry(DLM_STAT_PROC_NAME,
+					       S_IFREG | S_IRUGO, dlm->dlm_proc,
+					       dlm_proc_stats, (char *)dlm);
+		if (entry)
+			entry->owner = THIS_MODULE;
+	}
+}
+
+void dlm_proc_del_domain(struct dlm_ctxt *dlm)
+{
+	if (dlm->dlm_proc) {
+		remove_proc_entry(DLM_STAT_PROC_NAME, dlm->dlm_proc);
+		remove_proc_entry(dlm->name, ocfs2_dlm_proc);
+	}
+}
+
+/* lock resource printing is usually very important (printed
+ * right before a BUG in some cases), but we'd like to be
+ * able to shut it off if needed, hence the KERN_NOTICE level */
+static int dlm_dump_all_lock_resources(const char __user *data,
+				       unsigned int len)
+{
+	struct dlm_ctxt *dlm;
+	struct list_head *iter;
+
+	mlog(ML_NOTICE, "dumping ALL dlm state for node %s\n",
+	     system_utsname.nodename);
+	spin_lock(&dlm_domain_lock);
+	list_for_each(iter, &dlm_domains) {
+		dlm = list_entry (iter, struct dlm_ctxt, list);
+		dlm_dump_lock_resources(dlm);
+	}
+	spin_unlock(&dlm_domain_lock);
+	return len;
+}
+
+static int dlm_dump_one_lock_resource(const char __user *data,
+				       unsigned int len)
+{
+	struct dlm_ctxt *dlm;
+	struct dlm_lock_resource *res;
+	char *buf = NULL;
+	int ret = -EINVAL;
+	int tmpret;
+
+	if (len >= PAGE_SIZE-1) {
+		mlog(ML_ERROR, "user passed too much data: %d bytes\n", len);
+		goto leave;
+	}
+	if (len < 5) {
+		mlog(ML_ERROR, "user passed too little data: %d bytes\n", len);
+		goto leave;
+	}
+	buf = kmalloc(len+1, GFP_NOFS);
+	if (!buf) {
+		mlog(ML_ERROR, "could not alloc %d bytes\n", len+1);
+		ret = -ENOMEM;
+		goto leave;
+	}
+	if (strncpy_from_user(buf, data, len) < len) {
+		mlog(ML_ERROR, "failed to get all user data.  done.\n");
+		goto leave;
+	}
+	buf[len]='\0';
+	mlog(0, "got this data from user: %s\n", buf);
+
+	if (*buf != 'R') {
+		mlog(0, "bad data\n");
+		goto leave;
+	}
+
+	tmpret = dlm_parse_domain_and_lockres(buf, len, &dlm, &res);
+	if (tmpret < 0) {
+		mlog(0, "bad data\n");
+		goto leave;
+	}
+
+	mlog(ML_NOTICE, "struct dlm_ctxt: %s, node=%u, key=%u\n",
+		dlm->name, dlm->node_num, dlm->key);
+
+	dlm_print_one_lock_resource(res);
+	dlm_lockres_put(res);
+	dlm_put(dlm);
+	ret = len;
+
+leave:
+	if (buf)
+		kfree(buf);
+	return ret;
 }
 
 static void dlm_print_lockres_refmap(struct dlm_lock_resource *res)
@@ -70,6 +286,16 @@ static void dlm_print_lockres_refmap(struct dlm_lock_resource *res)
 	printk("], inflight=%u\n", res->inflight_locks);
 }
 
+void dlm_print_one_lock_resource(struct dlm_lock_resource *res)
+{
+	mlog(ML_NOTICE, "lockres: %.*s, owner=%u, state=%u\n",
+	       res->lockname.len, res->lockname.name,
+	       res->owner, res->state);
+	spin_lock(&res->spinlock);
+	__dlm_print_one_lock_resource(res);
+	spin_unlock(&res->spinlock);
+}
+
 void __dlm_print_one_lock_resource(struct dlm_lock_resource *res)
 {
 	struct list_head *iter2;
@@ -88,10 +314,10 @@ void __dlm_print_one_lock_resource(struct dlm_lock_resource *res)
 		lock = list_entry(iter2, struct dlm_lock, list);
 		spin_lock(&lock->spinlock);
 		mlog(ML_NOTICE, "    type=%d, conv=%d, node=%u, "
-		       "cookie=%u:%llu, ast=(empty=%c,pend=%c), bast=(empty=%c,pend=%c)\n", 
-		       lock->ml.type, lock->ml.convert_type, lock->ml.node, 
-		     dlm_get_lock_cookie_node(be64_to_cpu(lock->ml.cookie)),
-		     dlm_get_lock_cookie_seq(be64_to_cpu(lock->ml.cookie)),
+		       "cookie=%u:%llu, ast=(empty=%c,pend=%c), bast=(empty=%c,pend=%c)\n",
+		       lock->ml.type, lock->ml.convert_type, lock->ml.node,
+		       dlm_get_lock_cookie_node(be64_to_cpu(lock->ml.cookie)),
+		       dlm_get_lock_cookie_seq(be64_to_cpu(lock->ml.cookie)),
 		       list_empty(&lock->ast_list) ? 'y' : 'n',
 		       lock->ast_pending ? 'y' : 'n',
 		       list_empty(&lock->bast_list) ? 'y' : 'n',
@@ -103,10 +329,10 @@ void __dlm_print_one_lock_resource(struct dlm_lock_resource *res)
 		lock = list_entry(iter2, struct dlm_lock, list);
 		spin_lock(&lock->spinlock);
 		mlog(ML_NOTICE, "    type=%d, conv=%d, node=%u, "
-		       "cookie=%u:%llu, ast=(empty=%c,pend=%c), bast=(empty=%c,pend=%c)\n", 
-		       lock->ml.type, lock->ml.convert_type, lock->ml.node, 
-		     dlm_get_lock_cookie_node(be64_to_cpu(lock->ml.cookie)),
-		     dlm_get_lock_cookie_seq(be64_to_cpu(lock->ml.cookie)),
+		       "cookie=%u:%llu, ast=(empty=%c,pend=%c), bast=(empty=%c,pend=%c)\n",
+		       lock->ml.type, lock->ml.convert_type, lock->ml.node,
+		       dlm_get_lock_cookie_node(be64_to_cpu(lock->ml.cookie)),
+		       dlm_get_lock_cookie_seq(be64_to_cpu(lock->ml.cookie)),
 		       list_empty(&lock->ast_list) ? 'y' : 'n',
 		       lock->ast_pending ? 'y' : 'n',
 		       list_empty(&lock->bast_list) ? 'y' : 'n',
@@ -118,10 +344,10 @@ void __dlm_print_one_lock_resource(struct dlm_lock_resource *res)
 		lock = list_entry(iter2, struct dlm_lock, list);
 		spin_lock(&lock->spinlock);
 		mlog(ML_NOTICE, "    type=%d, conv=%d, node=%u, "
-		       "cookie=%u:%llu, ast=(empty=%c,pend=%c), bast=(empty=%c,pend=%c)\n", 
-		       lock->ml.type, lock->ml.convert_type, lock->ml.node, 
-		     dlm_get_lock_cookie_node(be64_to_cpu(lock->ml.cookie)),
-		     dlm_get_lock_cookie_seq(be64_to_cpu(lock->ml.cookie)),
+		       "cookie=%u:%llu, ast=(empty=%c,pend=%c), bast=(empty=%c,pend=%c)\n",
+		       lock->ml.type, lock->ml.convert_type, lock->ml.node,
+		       dlm_get_lock_cookie_node(be64_to_cpu(lock->ml.cookie)),
+		       dlm_get_lock_cookie_seq(be64_to_cpu(lock->ml.cookie)),
 		       list_empty(&lock->ast_list) ? 'y' : 'n',
 		       lock->ast_pending ? 'y' : 'n',
 		       list_empty(&lock->bast_list) ? 'y' : 'n',
@@ -136,7 +362,6 @@ void dlm_print_one_lock(struct dlm_lock *lockid)
 }
 EXPORT_SYMBOL_GPL(dlm_print_one_lock);
 
-#if 0
 void dlm_dump_lock_resources(struct dlm_ctxt *dlm)
 {
 	struct dlm_lock_resource *res;
@@ -159,7 +384,211 @@ void dlm_dump_lock_resources(struct dlm_ctxt *dlm)
 	}
 	spin_unlock(&dlm->spinlock);
 }
-#endif  /*  0  */
+static void dlm_dump_purge_list(struct dlm_ctxt *dlm)
+{
+	struct list_head *iter;
+	struct dlm_lock_resource *lockres;
+
+	mlog(ML_NOTICE, "Purge list for DLM Domain \"%s\"\n", dlm->name);
+	mlog(ML_NOTICE, "Last_used\tName\n");
+
+	spin_lock(&dlm->spinlock);
+	list_for_each(iter, &dlm->purge_list) {
+		lockres = list_entry(iter, struct dlm_lock_resource, purge);
+
+		spin_lock(&lockres->spinlock);
+		mlog(ML_NOTICE, "%lu\t%.*s\n", lockres->last_used,
+		       lockres->lockname.len, lockres->lockname.name);
+		spin_unlock(&lockres->spinlock);
+	}
+	spin_unlock(&dlm->spinlock);
+}
+
+void dlm_dump_work_queue(struct dlm_ctxt *dlm)
+{
+	struct list_head *iter;
+	struct dlm_work_item *item;
+
+	spin_lock(&dlm->work_lock);
+	list_for_each(iter, &dlm->work_list) {
+		item = list_entry(iter, struct dlm_work_item, list);
+		if (item->func == dlm_request_all_locks_worker) {
+			printk("%s: found requestalllocks, mas=%u, dead=%u\n",
+			       dlm->name, item->u.ral.reco_master,
+			       item->u.ral.dead_node);
+		} else if (item->func == dlm_mig_lockres_worker) {
+			printk("%s:%.*s: found assert_master, realmaster=%u\n",
+			       dlm->name, item->u.ml.lockres->lockname.len,
+			       item->u.ml.lockres->lockname.name,
+			       item->u.ml.real_master);
+		} else if (item->func == dlm_assert_master_worker) {
+			printk("%s:%.*s: found assert_master, from=%u, "
+			       "flags=%u, ignore=%d\n",
+			       dlm->name, item->u.am.lockres->lockname.len,
+			       item->u.am.lockres->lockname.name,
+			       item->u.am.request_from, item->u.am.flags,
+			       item->u.am.ignore_higher);
+		} else {
+			printk("%s: found INVALID work item, func=%p\n",
+			       dlm->name, item->func);
+		}
+	}
+	spin_unlock(&dlm->work_lock);
+}
+
+static int dlm_dump_work_queues(const char __user *data, unsigned int len)
+{
+	struct dlm_ctxt *dlm;
+	struct list_head *iter;
+
+	spin_lock(&dlm_domain_lock);
+	list_for_each(iter, &dlm_domains) {
+		dlm = list_entry (iter, struct dlm_ctxt, list);
+		dlm_dump_work_queue(dlm);
+	}
+	spin_unlock(&dlm_domain_lock);
+	return len;
+
+}
+
+static int dlm_dump_all_purge_lists(const char __user *data, unsigned int len)
+{
+	struct dlm_ctxt *dlm;
+	struct list_head *iter;
+
+	spin_lock(&dlm_domain_lock);
+	list_for_each(iter, &dlm_domains) {
+		dlm = list_entry (iter, struct dlm_ctxt, list);
+		dlm_dump_purge_list(dlm);
+	}
+	spin_unlock(&dlm_domain_lock);
+	return len;
+}
+
+static int dlm_parse_domain_and_lockres(char *buf, unsigned int len,
+					struct dlm_ctxt **dlm,
+					struct dlm_lock_resource **res)
+{
+	char *resname;
+	char *domainname;
+	char *tmp;
+	int ret = -EINVAL;
+
+	*dlm = NULL;
+	*res = NULL;
+
+	tmp = buf;
+	tmp++;
+	if (*tmp != ' ') {
+		mlog(0, "bad data\n");
+		goto leave;
+	}
+	tmp++;
+	domainname = tmp;
+
+	while (*tmp) {
+		if (*tmp == ' ')
+			break;
+		tmp++;
+	}
+	if (!*tmp || !*(tmp+1)) {
+		mlog(0, "bad data\n");
+		goto leave;
+	}
+
+	*tmp = '\0';  // null term the domainname
+	tmp++;
+	resname = tmp;
+	while (*tmp) {
+		if (*tmp == '\n' ||
+		    *tmp == ' ' ||
+		    *tmp == '\r') {
+			*tmp = '\0';
+			break;
+		}
+		tmp++;
+	}
+
+	mlog(0, "now looking up domain %s, lockres %s\n",
+	       domainname, resname);
+	spin_lock(&dlm_domain_lock);
+	*dlm = __dlm_lookup_domain(domainname);
+	spin_unlock(&dlm_domain_lock);
+
+	if (!dlm_grab(*dlm)) {
+		mlog(ML_ERROR, "bad dlm!\n");
+		*dlm = NULL;
+		goto leave;
+	}
+
+	*res = dlm_lookup_lockres(*dlm, resname, strlen(resname));
+	if (!*res) {
+		mlog(ML_ERROR, "bad lockres!\n");
+		dlm_put(*dlm);
+		*dlm = NULL;
+		goto leave;
+	}
+
+	mlog(0, "found dlm=%p, lockres=%p\n", *dlm, *res);
+	ret = 0;
+
+leave:
+	return ret;
+}
+
+static int dlm_trigger_migration(const char __user *data, unsigned int len)
+{
+	struct dlm_lock_resource *res;
+	struct dlm_ctxt *dlm;
+	char *buf = NULL;
+	int ret = -EINVAL;
+	int tmpret;
+
+	if (len >= PAGE_SIZE-1) {
+		mlog(ML_ERROR, "user passed too much data: %d bytes\n", len);
+		goto leave;
+	}
+	if (len < 5) {
+		mlog(ML_ERROR, "user passed too little data: %d bytes\n", len);
+		goto leave;
+	}
+	buf = kmalloc(len+1, GFP_NOFS);
+	if (!buf) {
+		mlog(ML_ERROR, "could not alloc %d bytes\n", len+1);
+		ret = -ENOMEM;
+		goto leave;
+	}
+	if (strncpy_from_user(buf, data, len) < len) {
+		mlog(ML_ERROR, "failed to get all user data.  done.\n");
+		goto leave;
+	}
+	buf[len]='\0';
+	mlog(0, "got this data from user: %s\n", buf);
+
+	if (*buf != 'M') {
+		mlog(0, "bad data\n");
+		goto leave;
+	}
+
+	tmpret = dlm_parse_domain_and_lockres(buf, len, &dlm, &res);
+	if (tmpret < 0) {
+		mlog(0, "bad data\n");
+		goto leave;
+	}
+	tmpret = dlm_migrate_lockres(dlm, res, O2NM_MAX_NODES);
+	mlog(0, "dlm_migrate_lockres returned %d\n", tmpret);
+	if (tmpret < 0)
+		mlog(ML_ERROR, "failed to migrate %.*s: %d\n",
+		     res->lockname.len, res->lockname.name, tmpret);
+	dlm_lockres_put(res);
+	dlm_put(dlm);
+	ret = len;
+
+leave:
+	if (buf)
+		kfree(buf);
+	return ret;
+}
 
 static const char *dlm_errnames[] = {
 	[DLM_NORMAL] =			"DLM_NORMAL",
diff --git a/fs/ocfs2/dlm/dlmdomain.h b/fs/ocfs2/dlm/dlmdebug.h
similarity index 74%
copy from fs/ocfs2/dlm/dlmdomain.h
copy to fs/ocfs2/dlm/dlmdebug.h
index 2f7f60b..dbe3a3d 100644
--- a/fs/ocfs2/dlm/dlmdomain.h
+++ b/fs/ocfs2/dlm/dlmdebug.h
@@ -1,7 +1,7 @@
 /* -*- mode: c; c-basic-offset: 8; -*-
  * vim: noexpandtab sw=8 ts=8 sts=0:
  *
- * dlmdomain.h
+ * dlmdebug.h
  *
  * Copyright (C) 2004 Oracle.  All rights reserved.
  *
@@ -22,15 +22,13 @@
  *
  */
 
-#ifndef DLMDOMAIN_H
-#define DLMDOMAIN_H
-
-extern spinlock_t dlm_domain_lock;
-extern struct list_head dlm_domains;
-
-int dlm_joined(struct dlm_ctxt *dlm);
-int dlm_shutting_down(struct dlm_ctxt *dlm);
-void dlm_fire_domain_eviction_callbacks(struct dlm_ctxt *dlm,
-					int node_num);
+#ifndef DLMDEBUG_H
+#define DLMDEBUG_H
 
+void dlm_remove_proc(void);
+void dlm_init_proc(void);
+void dlm_dump_lock_resources(struct dlm_ctxt *dlm);
+void dlm_proc_add_domain(struct dlm_ctxt *dlm);
+void dlm_proc_del_domain(struct dlm_ctxt *dlm);
+void dlm_dump_work_queue(struct dlm_ctxt *dlm);
 #endif
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 10b3e60..1d854d5 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -41,6 +41,7 @@
 #include "dlmapi.h"
 #include "dlmcommon.h"
 
+#include "dlmdebug.h"
 #include "dlmdomain.h"
 
 #include "dlmver.h"
@@ -234,7 +235,7 @@ struct dlm_lock_resource * dlm_lookup_lockres(struct dlm_ctxt *dlm,
 	return res;
 }
 
-static struct dlm_ctxt * __dlm_lookup_domain_full(const char *domain, int len)
+struct dlm_ctxt * __dlm_lookup_domain_full(const char *domain, int len)
 {
 	struct dlm_ctxt *tmp = NULL;
 	struct list_head *iter;
@@ -255,7 +256,7 @@ static struct dlm_ctxt * __dlm_lookup_domain_full(const char *domain, int len)
 }
 
 /* For null terminated domain strings ONLY */
-static struct dlm_ctxt * __dlm_lookup_domain(const char *domain)
+struct dlm_ctxt * __dlm_lookup_domain(const char *domain)
 {
 	assert_spin_locked(&dlm_domain_lock);
 
@@ -285,6 +286,8 @@ static int dlm_wait_on_domain_helper(const char *domain)
 
 static void dlm_free_ctxt_mem(struct dlm_ctxt *dlm)
 {
+	dlm_proc_del_domain(dlm);
+
 	if (dlm->lockres_hash)
 		dlm_free_pagevec((void **)dlm->lockres_hash, DLM_HASH_PAGES);
 
@@ -1441,6 +1444,7 @@ static struct dlm_ctxt *dlm_alloc_ctxt(const char *domain,
 	dlm->dlm_state = DLM_CTXT_NEW;
 
 	INIT_LIST_HEAD(&dlm->dlm_eviction_callbacks);
+	dlm_proc_add_domain(dlm);
 
 	mlog(0, "context init: refcount %u\n",
 		  atomic_read(&dlm->dlm_refs.refcount));
@@ -1653,11 +1657,14 @@ static int __init dlm_init(void)
 		return -1;
 	}
 
+	dlm_init_proc();
+
 	return 0;
 }
 
 static void __exit dlm_exit (void)
 {
+	dlm_remove_proc();
 	dlm_unregister_net_handlers();
 	dlm_destroy_mle_cache();
 }
diff --git a/fs/ocfs2/dlm/dlmdomain.h b/fs/ocfs2/dlm/dlmdomain.h
index 2f7f60b..1cb2715 100644
--- a/fs/ocfs2/dlm/dlmdomain.h
+++ b/fs/ocfs2/dlm/dlmdomain.h
@@ -28,6 +28,7 @@
 extern spinlock_t dlm_domain_lock;
 extern struct list_head dlm_domains;
 
+struct dlm_ctxt * __dlm_lookup_domain(const char *domain);
 int dlm_joined(struct dlm_ctxt *dlm);
 int dlm_shutting_down(struct dlm_ctxt *dlm);
 void dlm_fire_domain_eviction_callbacks(struct dlm_ctxt *dlm,
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index a668840..c8e5d84 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -98,7 +98,6 @@ static void dlm_mle_node_up(struct dlm_ctxt *dlm,
 			    struct o2nm_node *node,
 			    int idx);
 
-static void dlm_assert_master_worker(struct dlm_work_item *item, void *data);
 static int dlm_do_assert_master(struct dlm_ctxt *dlm,
 				struct dlm_lock_resource *res,
 				void *nodemap, u32 flags);
@@ -186,7 +185,7 @@ static void dlm_print_one_mle(struct dlm_master_list_entry *mle)
 	printk("\n");
 }
 
-#if 0
+
 /* Code here is included but defined out as it aids debugging */
 
 static void dlm_dump_mles(struct dlm_ctxt *dlm)
@@ -214,7 +213,7 @@ int dlm_dump_all_mles(const char __user *data, unsigned int len)
 }
 EXPORT_SYMBOL_GPL(dlm_dump_all_mles);
 
-#endif  /*  0  */
+
 
 
 static struct kmem_cache *dlm_mle_cache = NULL;
@@ -2119,7 +2118,7 @@ int dlm_dispatch_assert_master(struct dlm_ctxt *dlm,
 	return 0;
 }
 
-static void dlm_assert_master_worker(struct dlm_work_item *item, void *data)
+void dlm_assert_master_worker(struct dlm_work_item *item, void *data)
 {
 	struct dlm_ctxt *dlm = data;
 	int ret = 0;
@@ -2470,7 +2469,7 @@ leave:
  */
 
 
-static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
+int dlm_migrate_lockres(struct dlm_ctxt *dlm,
 			       struct dlm_lock_resource *res,
 			       u8 target)
 {
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index d6a46c7..d2f01d4 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -49,6 +49,7 @@
 #include "dlmapi.h"
 #include "dlmcommon.h"
 #include "dlmdomain.h"
+#include "dlmdebug.h"
 
 #define MLOG_MASK_PREFIX (ML_DLM|ML_DLM_RECOVERY)
 #include "cluster/masklog.h"
@@ -92,9 +93,6 @@ static void dlm_finish_local_lockres_recovery(struct dlm_ctxt *dlm,
 static void dlm_reco_ast(void *astdata);
 static void dlm_reco_bast(void *astdata, int blocked_type);
 static void dlm_reco_unlock_ast(void *astdata, enum dlm_status st);
-static void dlm_request_all_locks_worker(struct dlm_work_item *item,
-					 void *data);
-static void dlm_mig_lockres_worker(struct dlm_work_item *item, void *data);
 static int dlm_lockres_master_requery(struct dlm_ctxt *dlm,
 				      struct dlm_lock_resource *res,
 				      u8 *real_master);
@@ -862,7 +860,7 @@ int dlm_request_all_locks_handler(struct o2net_msg *msg, u32 len, void *data,
 	return 0;
 }
 
-static void dlm_request_all_locks_worker(struct dlm_work_item *item, void *data)
+void dlm_request_all_locks_worker(struct dlm_work_item *item, void *data)
 {
 	struct dlm_migratable_lockres *mres;
 	struct dlm_lock_resource *res;
@@ -1462,7 +1460,7 @@ leave:
 }
 
 
-static void dlm_mig_lockres_worker(struct dlm_work_item *item, void *data)
+void dlm_mig_lockres_worker(struct dlm_work_item *item, void *data)
 {
 	struct dlm_ctxt *dlm = data;
 	struct dlm_migratable_lockres *mres;
-- 
1.5.2.5
