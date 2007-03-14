From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Mar 14 14:50:15 2007
Subject: [Ocfs2-devel] [git patches] ocfs2 and configfs fixes
Message-ID: <20070314215011.GA21942@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, joel.becker@oracle.com

Hi Linus,
	All of these fixes are straight forward and well tested, here in our
lab. There's actually more ocfs2 fixes but the rest are for extremely rare
conditions, so they can wait (post 2.6.21) until we get some more testing on
them.
	--Mark

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/configfs/dir.c            |   27 ++++++++++-------------
 fs/ocfs2/aops.c              |   26 +++++++++++++++++++++-
 fs/ocfs2/cluster/heartbeat.c |   50 +++++++++++++++++++++++++++++--------------
 fs/ocfs2/cluster/heartbeat.h |    2 -
 fs/ocfs2/cluster/tcp.c       |   13 +----------
 fs/ocfs2/dlm/dlmmaster.c     |    3 ++
 fs/ocfs2/dlm/dlmthread.c     |    2 +
 fs/ocfs2/heartbeat.c         |   15 ++++--------
 8 files changed, 84 insertions(+), 54 deletions(-)

Joel Becker:
      ocfs2: Proper cleanup in case of error in ocfs2_register_hb_callbacks()
      ocfs2: Concurrent access of o2hb_region->hr_task was not locked
      ocfs2: add some missing address space callbacks
      configfs: add missing mutex_unlock()

Sunil Mushran:
      ocfs2_dlm: Missing get/put lockres in dlm_run_purge_lockres
      ocfs2_dlm: Add missing locks in dlm_empty_lockres

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 34750d5..5e6e37e 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -1141,25 +1141,22 @@ int configfs_register_subsystem(struct c
 
 	err = -ENOMEM;
 	dentry = d_alloc(configfs_sb->s_root, &name);
-	if (!dentry)
-		goto out_release;
-
-	d_add(dentry, NULL);
+	if (dentry) {
+		d_add(dentry, NULL);
 
-	err = configfs_attach_group(sd->s_element, &group->cg_item,
-				    dentry);
-	if (!err)
-		dentry = NULL;
-	else
-		d_delete(dentry);
+		err = configfs_attach_group(sd->s_element, &group->cg_item,
+					    dentry);
+		if (err) {
+			d_delete(dentry);
+			dput(dentry);
+		}
+	}
 
 	mutex_unlock(&configfs_sb->s_root->d_inode->i_mutex);
 
-	if (dentry) {
-	    dput(dentry);
-out_release:
-	    unlink_group(group);
-	    configfs_release_fs();
+	if (err) {
+		unlink_group(group);
+		configfs_release_fs();
 	}
 
 	return err;
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 93628b0..875c114 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -614,6 +614,27 @@ static void ocfs2_dio_end_io(struct kioc
 	ocfs2_rw_unlock(inode, 0);
 }
 
+/*
+ * ocfs2_invalidatepage() and ocfs2_releasepage() are shamelessly stolen
+ * from ext3.  PageChecked() bits have been removed as OCFS2 does not
+ * do journalled data.
+ */
+static void ocfs2_invalidatepage(struct page *page, unsigned long offset)
+{
+	journal_t *journal = OCFS2_SB(page->mapping->host->i_sb)->journal->j_journal;
+
+	journal_invalidatepage(journal, page, offset);
+}
+
+static int ocfs2_releasepage(struct page *page, gfp_t wait)
+{
+	journal_t *journal = OCFS2_SB(page->mapping->host->i_sb)->journal->j_journal;
+
+	if (!page_has_buffers(page))
+		return 0;
+	return journal_try_to_free_buffers(journal, page, wait);
+}
+
 static ssize_t ocfs2_direct_IO(int rw,
 			       struct kiocb *iocb,
 			       const struct iovec *iov,
@@ -661,5 +682,8 @@ const struct address_space_operations oc
 	.commit_write	= ocfs2_commit_write,
 	.bmap		= ocfs2_bmap,
 	.sync_page	= block_sync_page,
-	.direct_IO	= ocfs2_direct_IO
+	.direct_IO	= ocfs2_direct_IO,
+	.invalidatepage	= ocfs2_invalidatepage,
+	.releasepage	= ocfs2_releasepage,
+	.migratepage	= buffer_migrate_page,
 };
diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 5a9779b..eba282d 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1234,6 +1234,7 @@ static ssize_t o2hb_region_dev_write(str
 				     const char *page,
 				     size_t count)
 {
+	struct task_struct *hb_task;
 	long fd;
 	int sectsize;
 	char *p = (char *)page;
@@ -1319,20 +1320,28 @@ static ssize_t o2hb_region_dev_write(str
 	 */
 	atomic_set(&reg->hr_steady_iterations, O2HB_LIVE_THRESHOLD + 1);
 
-	reg->hr_task = kthread_run(o2hb_thread, reg, "o2hb-%s",
-				   reg->hr_item.ci_name);
-	if (IS_ERR(reg->hr_task)) {
-		ret = PTR_ERR(reg->hr_task);
+	hb_task = kthread_run(o2hb_thread, reg, "o2hb-%s",
+			      reg->hr_item.ci_name);
+	if (IS_ERR(hb_task)) {
+		ret = PTR_ERR(hb_task);
 		mlog_errno(ret);
-		reg->hr_task = NULL;
 		goto out;
 	}
 
+	spin_lock(&o2hb_live_lock);
+	reg->hr_task = hb_task;
+	spin_unlock(&o2hb_live_lock);
+
 	ret = wait_event_interruptible(o2hb_steady_queue,
 				atomic_read(&reg->hr_steady_iterations) == 0);
 	if (ret) {
-		kthread_stop(reg->hr_task);
+		spin_lock(&o2hb_live_lock);
+		hb_task = reg->hr_task;
 		reg->hr_task = NULL;
+		spin_unlock(&o2hb_live_lock);
+
+		if (hb_task)
+			kthread_stop(hb_task);
 		goto out;
 	}
 
@@ -1354,10 +1363,17 @@ out:
 static ssize_t o2hb_region_pid_read(struct o2hb_region *reg,
                                       char *page)
 {
-	if (!reg->hr_task)
+	pid_t pid = 0;
+
+	spin_lock(&o2hb_live_lock);
+	if (reg->hr_task)
+		pid = reg->hr_task->pid;
+	spin_unlock(&o2hb_live_lock);
+
+	if (!pid)
 		return 0;
 
-	return sprintf(page, "%u\n", reg->hr_task->pid);
+	return sprintf(page, "%u\n", pid);
 }
 
 struct o2hb_region_attribute {
@@ -1495,13 +1511,17 @@ out:
 static void o2hb_heartbeat_group_drop_item(struct config_group *group,
 					   struct config_item *item)
 {
+	struct task_struct *hb_task;
 	struct o2hb_region *reg = to_o2hb_region(item);
 
 	/* stop the thread when the user removes the region dir */
-	if (reg->hr_task) {
-		kthread_stop(reg->hr_task);
-		reg->hr_task = NULL;
-	}
+	spin_lock(&o2hb_live_lock);
+	hb_task = reg->hr_task;
+	reg->hr_task = NULL;
+	spin_unlock(&o2hb_live_lock);
+
+	if (hb_task)
+		kthread_stop(hb_task);
 
 	config_item_put(item);
 }
@@ -1682,7 +1702,7 @@ out:
 }
 EXPORT_SYMBOL_GPL(o2hb_register_callback);
 
-int o2hb_unregister_callback(struct o2hb_callback_func *hc)
+void o2hb_unregister_callback(struct o2hb_callback_func *hc)
 {
 	BUG_ON(hc->hc_magic != O2HB_CB_MAGIC);
 
@@ -1690,15 +1710,13 @@ int o2hb_unregister_callback(struct o2hb
 	     __builtin_return_address(0), hc);
 
 	if (list_empty(&hc->hc_item))
-		return 0;
+		return;
 
 	down_write(&o2hb_callback_sem);
 
 	list_del_init(&hc->hc_item);
 
 	up_write(&o2hb_callback_sem);
-
-	return 0;
 }
 EXPORT_SYMBOL_GPL(o2hb_unregister_callback);
 
diff --git a/fs/ocfs2/cluster/heartbeat.h b/fs/ocfs2/cluster/heartbeat.h
index cac6223..cc6d40b 100644
--- a/fs/ocfs2/cluster/heartbeat.h
+++ b/fs/ocfs2/cluster/heartbeat.h
@@ -70,7 +70,7 @@ void o2hb_setup_callback(struct o2hb_cal
 			 void *data,
 			 int priority);
 int o2hb_register_callback(struct o2hb_callback_func *hc);
-int o2hb_unregister_callback(struct o2hb_callback_func *hc);
+void o2hb_unregister_callback(struct o2hb_callback_func *hc);
 void o2hb_fill_node_map(unsigned long *map,
 			unsigned bytes);
 void o2hb_init(void);
diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 1718215..69caf3e 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -1638,17 +1638,8 @@ static void o2net_hb_node_up_cb(struct o
 
 void o2net_unregister_hb_callbacks(void)
 {
-	int ret;
-
-	ret = o2hb_unregister_callback(&o2net_hb_up);
-	if (ret < 0)
-		mlog(ML_ERROR, "Status return %d unregistering heartbeat up "
-		     "callback!\n", ret);
-
-	ret = o2hb_unregister_callback(&o2net_hb_down);
-	if (ret < 0)
-		mlog(ML_ERROR, "Status return %d unregistering heartbeat down "
-		     "callback!\n", ret);
+	o2hb_unregister_callback(&o2net_hb_up);
+	o2hb_unregister_callback(&o2net_hb_down);
 }
 
 int o2net_register_hb_callbacks(void)
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 77e4e61..9229e04 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -2730,14 +2730,17 @@ int dlm_empty_lockres(struct dlm_ctxt *d
 	int ret;
 	int lock_dropped = 0;
 
+	spin_lock(&res->spinlock);
 	if (res->owner != dlm->node_num) {
 		if (!__dlm_lockres_unused(res)) {
 			mlog(ML_ERROR, "%s:%.*s: this node is not master, "
 			     "trying to free this but locks remain\n",
 			     dlm->name, res->lockname.len, res->lockname.name);
 		}
+		spin_unlock(&res->spinlock);
 		goto leave;
 	}
+	spin_unlock(&res->spinlock);
 
 	/* Wheee! Migrate lockres here! Will sleep so drop spinlock. */
 	spin_unlock(&dlm->spinlock);
diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
index 8ffa091..6421a8f 100644
--- a/fs/ocfs2/dlm/dlmthread.c
+++ b/fs/ocfs2/dlm/dlmthread.c
@@ -265,8 +265,10 @@ static void dlm_run_purge_list(struct dl
 		/* This may drop and reacquire the dlm spinlock if it
 		 * has to do migration. */
 		mlog(0, "calling dlm_purge_lockres!\n");
+		dlm_lockres_get(lockres);
 		if (dlm_purge_lockres(dlm, lockres))
 			BUG();
+		dlm_lockres_put(lockres);
 		mlog(0, "DONE calling dlm_purge_lockres!\n");
 
 		/* Avoid adding any scheduling latencies */
diff --git a/fs/ocfs2/heartbeat.c b/fs/ocfs2/heartbeat.c
index 8fc52d6..b25ef63 100644
--- a/fs/ocfs2/heartbeat.c
+++ b/fs/ocfs2/heartbeat.c
@@ -164,8 +164,10 @@ int ocfs2_register_hb_callbacks(struct o
 	}
 
 	status = o2hb_register_callback(&osb->osb_hb_up);
-	if (status < 0)
+	if (status < 0) {
 		mlog_errno(status);
+		o2hb_unregister_callback(&osb->osb_hb_down);
+	}
 
 bail:
 	return status;
@@ -173,18 +175,11 @@ bail:
 
 void ocfs2_clear_hb_callbacks(struct ocfs2_super *osb)
 {
-	int status;
-
 	if (ocfs2_mount_local(osb))
 		return;
 
-	status = o2hb_unregister_callback(&osb->osb_hb_down);
-	if (status < 0)
-		mlog_errno(status);
-
-	status = o2hb_unregister_callback(&osb->osb_hb_up);
-	if (status < 0)
-		mlog_errno(status);
+	o2hb_unregister_callback(&osb->osb_hb_down);
+	o2hb_unregister_callback(&osb->osb_hb_up);
 }
 
 void ocfs2_stop_heartbeat(struct ocfs2_super *osb)
