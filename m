From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Tue, 19 May 2009 16:26:18 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: timer to queue scan of all orphan
	slots
Message-ID: <1242775578-16885-1-git-send-email-srinivas.eeda@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On unlink, all nodes check for the dentry in dcache and if present they mark
the node as unlinked. The last node that purges the inode will clean it from
orphan directory. When there is a memory pressure, a dentry may not be around
and hence the inode is not marked as deleted and this will lead the file to be
in the orphan directory till the slot is re-used during next mount.

This patch initiates periodic recovery on all nodes and makes sure one node
runs through all orphan slots every 10(ORPHAN_SCAN_SCHEDULE_TIMEOUT) minutes.
This still may not clean the orphan immediately if the inode is still around,
but eventually the orphan gets cleaned when the inode is purged.

When the timer is fired, the node acquires OCFS2_LOCK_TYPE_ORPHAN_SCAN lock in
EX mode and verifies the recent scan time. It skips if any node did a scan
within the last timeout. This is to avoid frequent scans.

Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
---
 fs/ocfs2/dlmglue.c      |   58 +++++++++++++++++++++++++
 fs/ocfs2/dlmglue.h      |    8 +++
 fs/ocfs2/journal.c      |  109 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/journal.h      |   12 +++++
 fs/ocfs2/ocfs2.h        |    2 +
 fs/ocfs2/ocfs2_lockid.h |    5 ++
 fs/ocfs2/super.c        |   11 +++++
 7 files changed, 205 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index e15fc7d..ed234c8 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -248,6 +248,10 @@ static struct ocfs2_lock_res_ops ocfs2_nfs_sync_lops = {
 	.flags		= 0,
 };
 
+static struct ocfs2_lock_res_ops ocfs2_orphan_scan_lops = {
+	.flags		= LOCK_TYPE_REQUIRES_REFRESH|LOCK_TYPE_USES_LVB,
+};
+
 static struct ocfs2_lock_res_ops ocfs2_dentry_lops = {
 	.get_osb	= ocfs2_get_dentry_osb,
 	.post_unlock	= ocfs2_dentry_post_unlock,
@@ -637,6 +641,15 @@ static void ocfs2_nfs_sync_lock_res_init(struct ocfs2_lock_res *res,
 				   &ocfs2_nfs_sync_lops, osb);
 }
 
+static void ocfs2_orphan_scan_lock_res_init(struct ocfs2_lock_res *res,
+					    struct ocfs2_super *osb)
+{
+	ocfs2_lock_res_init_once(res);
+	ocfs2_build_lock_name(OCFS2_LOCK_TYPE_ORPHAN_SCAN, 0, 0, res->l_name);
+	ocfs2_lock_res_init_common(osb, res, OCFS2_LOCK_TYPE_ORPHAN_SCAN,
+				   &ocfs2_orphan_scan_lops, osb);
+}
+
 void ocfs2_file_lock_res_init(struct ocfs2_lock_res *lockres,
 			      struct ocfs2_file_private *fp)
 {
@@ -1978,6 +1991,24 @@ static inline int ocfs2_meta_lvb_is_trustable(struct inode *inode,
 	return 0;
 }
 
+void ocfs2_stuff_meta_lvb_mtime(struct timespec *spec,
+				struct ocfs2_lock_res *lockres)
+{
+	struct ocfs2_meta_lvb *lvb;
+	lvb = ocfs2_dlm_lvb(&lockres->l_lksb);
+	lvb->lvb_imtime_packed =
+		cpu_to_be64(ocfs2_pack_timespec(spec));
+}
+
+void ocfs2_get_meta_lvb_mtime(struct timespec *spec,
+			      struct ocfs2_lock_res *lockres)
+{
+	struct ocfs2_meta_lvb *lvb;
+ 
+	lvb = ocfs2_dlm_lvb(&lockres->l_lksb);
+	ocfs2_unpack_timespec(spec, be64_to_cpu(lvb->lvb_imtime_packed));
+}
+
 /* Determine whether a lock resource needs to be refreshed, and
  * arbitrate who gets to refresh it.
  *
@@ -2352,6 +2383,26 @@ void ocfs2_inode_unlock(struct inode *inode,
 	mlog_exit_void();
 }
 
+int ocfs2_orphan_scan_lock(struct ocfs2_super *osb, int ex)
+{
+	int status = 0;
+	int level = ex ? DLM_LOCK_EX : DLM_LOCK_PR;
+	struct ocfs2_lock_res *lockres;
+
+	lockres = &osb->osb_delayed_orphan_scan->ds_lockres;
+	status = ocfs2_cluster_lock(osb, lockres, level, 0, 0); 
+	return status;
+}
+
+void ocfs2_orphan_scan_unlock(struct ocfs2_super *osb, int ex)
+{
+	int level = ex ? DLM_LOCK_EX : DLM_LOCK_PR;
+	struct ocfs2_lock_res *lockres;
+
+	lockres = &osb->osb_delayed_orphan_scan->ds_lockres;
+	ocfs2_cluster_unlock(osb, lockres, level); 
+}
+
 int ocfs2_super_lock(struct ocfs2_super *osb,
 		     int ex)
 {
@@ -2795,6 +2846,7 @@ int ocfs2_dlm_init(struct ocfs2_super *osb)
 {
 	int status = 0;
 	struct ocfs2_cluster_connection *conn = NULL;
+	struct ocfs2_lock_res *res;
 
 	mlog_entry_void();
 
@@ -2843,6 +2895,9 @@ local:
 	ocfs2_rename_lock_res_init(&osb->osb_rename_lockres, osb);
 	ocfs2_nfs_sync_lock_res_init(&osb->osb_nfs_sync_lockres, osb);
 
+	res = &osb->osb_delayed_orphan_scan->ds_lockres;
+	ocfs2_orphan_scan_lock_res_init(res, osb);
+
 	osb->cconn = conn;
 
 	status = 0;
@@ -2878,6 +2933,7 @@ void ocfs2_dlm_shutdown(struct ocfs2_super *osb,
 	ocfs2_lock_res_free(&osb->osb_super_lockres);
 	ocfs2_lock_res_free(&osb->osb_rename_lockres);
 	ocfs2_lock_res_free(&osb->osb_nfs_sync_lockres);
+	ocfs2_lock_res_free(&osb->osb_delayed_orphan_scan->ds_lockres);
 
 	ocfs2_cluster_disconnect(osb->cconn, hangup_pending);
 	osb->cconn = NULL;
@@ -3061,6 +3117,8 @@ static void ocfs2_drop_osb_locks(struct ocfs2_super *osb)
 	ocfs2_simple_drop_lockres(osb, &osb->osb_super_lockres);
 	ocfs2_simple_drop_lockres(osb, &osb->osb_rename_lockres);
 	ocfs2_simple_drop_lockres(osb, &osb->osb_nfs_sync_lockres);
+	ocfs2_simple_drop_lockres(osb,
+				  &osb->osb_delayed_orphan_scan->ds_lockres);
 }
 
 int ocfs2_drop_inode_locks(struct inode *inode)
diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
index e1fd572..1ae8842 100644
--- a/fs/ocfs2/dlmglue.h
+++ b/fs/ocfs2/dlmglue.h
@@ -62,6 +62,11 @@ struct ocfs2_qinfo_lvb {
 	__be32	lvb_free_entry;
 };
 
+void ocfs2_stuff_meta_lvb_mtime(struct timespec *spec,
+				struct ocfs2_lock_res *lockres);
+void ocfs2_get_meta_lvb_mtime(struct timespec *spec,
+			      struct ocfs2_lock_res *lockres);
+
 /* ocfs2_inode_lock_full() 'arg_flags' flags */
 /* don't wait on recovery. */
 #define OCFS2_META_LOCK_RECOVERY	(0x01)
@@ -113,6 +118,9 @@ int ocfs2_super_lock(struct ocfs2_super *osb,
 		     int ex);
 void ocfs2_super_unlock(struct ocfs2_super *osb,
 			int ex);
+int ocfs2_orphan_scan_lock(struct ocfs2_super *osb, int ex);
+void ocfs2_orphan_scan_unlock(struct ocfs2_super *osb, int ex);
+
 int ocfs2_rename_lock(struct ocfs2_super *osb);
 void ocfs2_rename_unlock(struct ocfs2_super *osb);
 int ocfs2_nfs_sync_lock(struct ocfs2_super *osb, int ex);
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index a20a0f1..1a4a57f 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -28,6 +28,7 @@
 #include <linux/slab.h>
 #include <linux/highmem.h>
 #include <linux/kthread.h>
+#include <linux/time.h>
 
 #define MLOG_MASK_PREFIX ML_JOURNAL
 #include <cluster/masklog.h>
@@ -52,6 +53,8 @@
 
 DEFINE_SPINLOCK(trans_inc_lock);
 
+#define ORPHAN_SCAN_SCHEDULE_TIMEOUT 600000
+
 static int ocfs2_force_read_journal(struct inode *inode);
 static int ocfs2_recover_node(struct ocfs2_super *osb,
 			      int node_num, int slot_num);
@@ -1841,6 +1844,112 @@ bail:
 	return status;
 }
 
+static inline int ocfs2_orphan_scan_timeout(void)
+{
+	return ORPHAN_SCAN_SCHEDULE_TIMEOUT;
+}
+
+/*
+ * ocfs2_queue_delayed_orphan_scan, gets an EX lock on ds_lockres and checks
+ * LVB for recent scan time. If scanned recently than timeout, new scans are
+ * not queued, otherwise it queues recovery of all orphan slots and updates
+ * LVB with CURRENT_TIME
+ * What if the times are not in sync between nodes???
+ */ 
+void ocfs2_queue_delayed_orphan_scan(struct ocfs2_super *osb)
+{
+	struct ocfs2_delayed_orphan_scan *ds;
+	int level = DLM_LOCK_EX;
+	struct timespec scan_time, now;
+	int status, i;
+
+	ds = osb->osb_delayed_orphan_scan;
+	if (!ds)
+		return;
+
+	status = ocfs2_orphan_scan_lock(osb, level);
+	if (status < 0) {
+		if (status != -EAGAIN)
+			mlog_errno(status);
+		goto out;
+	}
+
+	ocfs2_get_meta_lvb_mtime(&scan_time, &ds->ds_lockres);
+	if (ds->ds_time.tv_sec != scan_time.tv_sec) {
+		ds->ds_time = scan_time;
+		goto unlock;
+	}
+
+	for (i = 0; i < osb->max_slots; i++)
+		ocfs2_queue_recovery_completion(osb->journal, i, NULL, NULL,
+						NULL);
+
+	now = CURRENT_TIME;
+	ocfs2_stuff_meta_lvb_mtime(&now, &ds->ds_lockres);
+unlock:
+	ocfs2_orphan_scan_unlock(osb, level);
+out:
+	return;
+}
+
+/* Queue timer to recover orphans after ORPHAN_SCAN_SCHEDULE_TIMEOUT */
+void ocfs2_delayed_orphan_scan_work(struct work_struct *work)
+{
+	struct ocfs2_delayed_orphan_scan *ds;
+	struct ocfs2_super *osb;
+	ds = container_of(work, struct ocfs2_delayed_orphan_scan,
+			  ds_delayed_orphan_scan_work.work);
+	osb = ds->ds_osb;
+
+	mutex_lock(&ds->ds_lock);
+	ocfs2_queue_delayed_orphan_scan(osb);
+	schedule_delayed_work(&ds->ds_delayed_orphan_scan_work,
+		      msecs_to_jiffies(ocfs2_orphan_scan_timeout()) >> 2);
+	mutex_unlock(&ds->ds_lock);
+}
+
+void ocfs2_delayed_orphan_scan_stop(struct ocfs2_super *osb)
+{
+	struct ocfs2_delayed_orphan_scan *ds;
+	ds = osb->osb_delayed_orphan_scan;
+	if (!ds)
+		return;
+
+	mutex_lock(&ds->ds_lock);
+	cancel_delayed_work(&ds->ds_delayed_orphan_scan_work);
+	mutex_unlock(&ds->ds_lock);
+}
+
+void ocfs2_delayed_orphan_scan_exit(struct ocfs2_super *osb)
+{
+	struct ocfs2_delayed_orphan_scan *ds;
+	ds = osb->osb_delayed_orphan_scan;
+	if (!ds)
+		return;
+
+	kfree(ds);
+}
+
+int ocfs2_delayed_orphan_scan_init(struct ocfs2_super *osb)
+{
+	struct ocfs2_delayed_orphan_scan *ds;
+	ds = kzalloc(sizeof(struct ocfs2_delayed_orphan_scan), GFP_KERNEL);
+	if (!ds) {
+		mlog_errno(-ENOMEM);
+		return -ENOMEM;
+	}
+	
+	osb->osb_delayed_orphan_scan = ds;
+	ds->ds_osb = osb;
+	mutex_init(&ds->ds_lock);
+
+	INIT_DELAYED_WORK(&ds->ds_delayed_orphan_scan_work,
+			  ocfs2_delayed_orphan_scan_work);
+	schedule_delayed_work(&ds->ds_delayed_orphan_scan_work,
+			      msecs_to_jiffies(ocfs2_orphan_scan_timeout()));
+	return 0;
+}
+
 struct ocfs2_orphan_filldir_priv {
 	struct inode		*head;
 	struct ocfs2_super	*osb;
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 619dd7f..121df85 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -29,6 +29,14 @@
 #include <linux/fs.h>
 #include <linux/jbd2.h>
 
+struct ocfs2_delayed_orphan_scan {
+	struct timespec ds_time;        /* tracks last scan time by any node */
+	struct mutex ds_lock;
+	struct ocfs2_super *ds_osb;
+	struct ocfs2_lock_res ds_lockres;       /* lock to synchronize scans */
+	struct delayed_work ds_delayed_orphan_scan_work;
+};
+
 enum ocfs2_journal_state {
 	OCFS2_JOURNAL_FREE = 0,
 	OCFS2_JOURNAL_LOADED,
@@ -144,6 +152,10 @@ static inline void ocfs2_inode_set_new(struct ocfs2_super *osb,
 }
 
 /* Exported only for the journal struct init code in super.c. Do not call. */
+int ocfs2_delayed_orphan_scan_init(struct ocfs2_super *osb);
+void ocfs2_delayed_orphan_scan_stop(struct ocfs2_super *osb);
+void ocfs2_delayed_orphan_scan_exit(struct ocfs2_super *osb);
+
 void ocfs2_complete_recovery(struct work_struct *work);
 void ocfs2_wait_for_recovery(struct ocfs2_super *osb);
 
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 1386281..236e80d 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -212,6 +212,7 @@ struct ocfs2_recovery_map;
 struct ocfs2_replay_map;
 struct ocfs2_quota_recovery;
 struct ocfs2_dentry_lock;
+struct ocfs2_delayed_orphan_scan;
 struct ocfs2_super
 {
 	struct task_struct *commit_task;
@@ -340,6 +341,7 @@ struct ocfs2_super
 	struct ocfs2_node_map		osb_recovering_orphan_dirs;
 	unsigned int			*osb_orphan_wipes;
 	wait_queue_head_t		osb_wipe_event;
+	struct ocfs2_delayed_orphan_scan *osb_delayed_orphan_scan;
 
 	/* used to protect metaecc calculation check of xattr. */
 	spinlock_t osb_xattr_lock;
diff --git a/fs/ocfs2/ocfs2_lockid.h b/fs/ocfs2/ocfs2_lockid.h
index a53ce87..978c286 100644
--- a/fs/ocfs2/ocfs2_lockid.h
+++ b/fs/ocfs2/ocfs2_lockid.h
@@ -48,6 +48,7 @@ enum ocfs2_lock_type {
 	OCFS2_LOCK_TYPE_FLOCK,
 	OCFS2_LOCK_TYPE_QINFO,
 	OCFS2_LOCK_TYPE_NFS_SYNC,
+	OCFS2_LOCK_TYPE_ORPHAN_SCAN,
 	OCFS2_NUM_LOCK_TYPES
 };
 
@@ -85,6 +86,9 @@ static inline char ocfs2_lock_type_char(enum ocfs2_lock_type type)
 		case OCFS2_LOCK_TYPE_NFS_SYNC:
 			c = 'Y';
 			break;
+		case OCFS2_LOCK_TYPE_ORPHAN_SCAN:
+			c = 'P';
+			break;
 		default:
 			c = '\0';
 	}
@@ -104,6 +108,7 @@ static char *ocfs2_lock_type_strings[] = {
 	[OCFS2_LOCK_TYPE_OPEN] = "Open",
 	[OCFS2_LOCK_TYPE_FLOCK] = "Flock",
 	[OCFS2_LOCK_TYPE_QINFO] = "Quota",
+	[OCFS2_LOCK_TYPE_ORPHAN_SCAN] = "Orphan",
 };
 
 static inline const char *ocfs2_lock_type_string(enum ocfs2_lock_type type)
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 79ff8d9..f1fbb25 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1802,6 +1802,8 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 
 	ocfs2_truncate_log_shutdown(osb);
 
+	ocfs2_delayed_orphan_scan_stop(osb);
+
 	/* This will disable recovery and flush any recovery work. */
 	ocfs2_recovery_exit(osb);
 
@@ -1839,6 +1841,8 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 	if (osb->cconn)
 		ocfs2_dlm_shutdown(osb, hangup_needed);
 
+	ocfs2_delayed_orphan_scan_exit(osb);
+
 	debugfs_remove(osb->osb_debug_root);
 
 	if (hangup_needed)
@@ -1957,6 +1961,13 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		goto bail;
 	}
 
+	status = ocfs2_delayed_orphan_scan_init(osb);
+	if (status) {
+		mlog(ML_ERROR, "Unable to initialize delayed orphan scan\n");
+		mlog_errno(status);
+		goto bail;
+	}
+
 	init_waitqueue_head(&osb->checkpoint_event);
 	atomic_set(&osb->needs_checkpoint, 0);
 
-- 
1.5.6.5
