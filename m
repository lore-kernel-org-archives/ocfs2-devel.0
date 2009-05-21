From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Thu, 21 May 2009 16:01:05 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: timer to queue scan of all orphan
	slots
Message-ID: <1242946865-26995-1-git-send-email-srinivas.eeda@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In the current implementation, unlink is a two step process.
1) The deleting node requests an EX on dentry lock and place the file in the
   orphan directory. The lock request causes other nodes to downcovert to NULL,
   and flag the inode as orphaned.

2) Each node that has inode cached will see the ORPHANED flag during iput and
   initiates a trylock on OPENLOCK. The node that does the final iput gets the
   OPENLOCK, and it wipes the file.

But when there is memory pressure, a dentry could get flushed. During dput, it
removes the lock. So this node will not get a downconvert message on dentry lock
and hence will not flag the inode as ORPHANED.

If this node does the final iput it is not aware that the file got ORPHANED and
hence will not try to wipe the file. This causes orpahns to be around.

The following fix runs a periodic scan on the orphan slots. The scan is done by
one node at a time. It is done once every X seconds, where X is a value between
ORPHAN_SCAN_SCHEDULE_TIMEOUT/2 and ORPHAN_SCAN_SCHEDULE_TIMEOUT milliseconds.
Each time the scan is done by different node so eventually the node that has the
inode cached will get to wipe the file.

Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
---
 fs/ocfs2/dlmglue.c      |   43 ++++++++++++++++++
 fs/ocfs2/dlmglue.h      |    3 +
 fs/ocfs2/journal.c      |  114 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/journal.h      |    4 ++
 fs/ocfs2/ocfs2.h        |   10 ++++
 fs/ocfs2/ocfs2_lockid.h |    5 ++
 fs/ocfs2/super.c        |    9 ++++
 7 files changed, 188 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index e15fc7d..663d779 100644
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
@@ -2352,6 +2365,33 @@ void ocfs2_inode_unlock(struct inode *inode,
 	mlog_exit_void();
 }
 
+/* lvb_imtime_packed is used to track a sequence number instead of mtime */
+int ocfs2_orphan_scan_lock(struct ocfs2_super *osb, u64 *seqno, int ex)
+{
+	struct ocfs2_lock_res *lockres;
+	struct ocfs2_meta_lvb *lvb;
+	int level = ex ? DLM_LOCK_EX : DLM_LOCK_PR;
+	int status = 0;
+
+	lockres = &osb->osb_delayed_scan.ds_lockres;
+	status = ocfs2_cluster_lock(osb, lockres, level, 0, 0); 
+	lvb = ocfs2_dlm_lvb(&lockres->l_lksb);
+	*seqno = be64_to_cpu(lvb->lvb_imtime_packed); 
+	return status;
+}
+
+void ocfs2_orphan_scan_unlock(struct ocfs2_super *osb, u64 seqno, int ex)
+{
+	struct ocfs2_lock_res *lockres;
+	struct ocfs2_meta_lvb *lvb;
+	int level = ex ? DLM_LOCK_EX : DLM_LOCK_PR;
+
+	lockres = &osb->osb_delayed_scan.ds_lockres;
+	lvb = ocfs2_dlm_lvb(&lockres->l_lksb);
+	lvb->lvb_imtime_packed = cpu_to_be64(seqno);
+	ocfs2_cluster_unlock(osb, lockres, level); 
+}
+
 int ocfs2_super_lock(struct ocfs2_super *osb,
 		     int ex)
 {
@@ -2842,6 +2882,7 @@ local:
 	ocfs2_super_lock_res_init(&osb->osb_super_lockres, osb);
 	ocfs2_rename_lock_res_init(&osb->osb_rename_lockres, osb);
 	ocfs2_nfs_sync_lock_res_init(&osb->osb_nfs_sync_lockres, osb);
+	ocfs2_orphan_scan_lock_res_init(&osb->osb_delayed_scan.ds_lockres, osb);
 
 	osb->cconn = conn;
 
@@ -2878,6 +2919,7 @@ void ocfs2_dlm_shutdown(struct ocfs2_super *osb,
 	ocfs2_lock_res_free(&osb->osb_super_lockres);
 	ocfs2_lock_res_free(&osb->osb_rename_lockres);
 	ocfs2_lock_res_free(&osb->osb_nfs_sync_lockres);
+	ocfs2_lock_res_free(&osb->osb_delayed_scan.ds_lockres);
 
 	ocfs2_cluster_disconnect(osb->cconn, hangup_pending);
 	osb->cconn = NULL;
@@ -3061,6 +3103,7 @@ static void ocfs2_drop_osb_locks(struct ocfs2_super *osb)
 	ocfs2_simple_drop_lockres(osb, &osb->osb_super_lockres);
 	ocfs2_simple_drop_lockres(osb, &osb->osb_rename_lockres);
 	ocfs2_simple_drop_lockres(osb, &osb->osb_nfs_sync_lockres);
+	ocfs2_simple_drop_lockres(osb, &osb->osb_delayed_scan.ds_lockres);
 }
 
 int ocfs2_drop_inode_locks(struct inode *inode)
diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
index e1fd572..7f26847 100644
--- a/fs/ocfs2/dlmglue.h
+++ b/fs/ocfs2/dlmglue.h
@@ -113,6 +113,9 @@ int ocfs2_super_lock(struct ocfs2_super *osb,
 		     int ex);
 void ocfs2_super_unlock(struct ocfs2_super *osb,
 			int ex);
+int ocfs2_orphan_scan_lock(struct ocfs2_super *osb, u64 *seqno, int ex);
+void ocfs2_orphan_scan_unlock(struct ocfs2_super *osb, u64 seqno, int ex);
+
 int ocfs2_rename_lock(struct ocfs2_super *osb);
 void ocfs2_rename_unlock(struct ocfs2_super *osb);
 int ocfs2_nfs_sync_lock(struct ocfs2_super *osb, int ex);
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index a20a0f1..cee42ed 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -28,6 +28,8 @@
 #include <linux/slab.h>
 #include <linux/highmem.h>
 #include <linux/kthread.h>
+#include <linux/time.h>
+#include <linux/random.h>
 
 #define MLOG_MASK_PREFIX ML_JOURNAL
 #include <cluster/masklog.h>
@@ -52,6 +54,8 @@
 
 DEFINE_SPINLOCK(trans_inc_lock);
 
+#define ORPHAN_SCAN_SCHEDULE_TIMEOUT 600000
+
 static int ocfs2_force_read_journal(struct inode *inode);
 static int ocfs2_recover_node(struct ocfs2_super *osb,
 			      int node_num, int slot_num);
@@ -1841,6 +1845,116 @@ bail:
 	return status;
 }
 
+/*
+ * Scan timer should get fired twice within ORPHAN_SCAN_SCHEDULE_TIMEOUT, so
+ * return half of ORPHAN_SCAN_SCHEDULE_TIMEOUT. Add some randomness to the
+ * timeout to minimize multple nodes firing the timer at the same time.
+ */
+static inline unsigned long ocfs2_orphan_scan_timeout(void)
+{
+	unsigned long time;
+
+	get_random_bytes(&time, sizeof(time));
+	time = (time % 5000) + (ORPHAN_SCAN_SCHEDULE_TIMEOUT / 2);
+	return msecs_to_jiffies(time);
+}
+
+/*
+ * ocfs2_queue_delayed_orphan_scan calls ocfs2_queue_recovery_completion for
+ * every slot which queues a recovery of slot on ocfs2_wq thread. This is done
+ * to cleanup any orphans that are left over in orphan slots.
+ *
+ * ocfs2_queue_delayed_orphan_scan gets called twice within a timeout value
+ * defined by ORPHAN_SCAN_SCHEDULE_TIMEOUT. It gets an EX lock on ds_lockres and
+ * checks sequence number stored in LVB. If the sequence number is changed it
+ * means some node has done the scan. So, it skips the scan and tracks the
+ * sequence number. If the sequence number didn't change, means a scan didn't
+ * happen, so the node queues a scan and increments the sequence number in LVB.
+ */ 
+void ocfs2_queue_delayed_orphan_scan(struct ocfs2_super *osb)
+{
+	struct ocfs2_delayed_orphan_scan *ds;
+	int level = DLM_LOCK_EX;
+	int status, i;
+	u64 seqno;
+
+	ds = &osb->osb_delayed_scan;
+
+	/* get an EX on orphan scan lock and sequence number in LVB */
+	status = ocfs2_orphan_scan_lock(osb, &seqno, level);
+	if (status < 0) {
+		if (status != -EAGAIN)
+			mlog_errno(status);
+		goto out;
+	}
+
+	/*
+	 * Check the sequence number in LVB. If it's different than what we knew
+	 * it means some node did the scan, so just track the seq# and skip
+	 * the scan. If the seq# didn't change, a scan didn't happen, so
+	 * continue and queue the scans.
+	 */
+	if (ds->ds_seqno != seqno) {
+		ds->ds_seqno = seqno;
+		goto unlock;
+	}
+
+	for (i = 0; i < osb->max_slots; i++)
+		ocfs2_queue_recovery_completion(osb->journal, i, NULL, NULL,
+						NULL);
+	/*
+	 * We queued a recovery on orphan slots, so increment the sequence
+	 * number and update LVB so other node will skip the scan for a while
+	 */
+	seqno++;
+unlock:
+	ocfs2_orphan_scan_unlock(osb, seqno, level);
+out:
+	return;
+}
+
+/* Worker task that gets fired every ORPHAN_SCAN_SCHEDULE_TIMEOUT/2 millsec */
+void ocfs2_delayed_orphan_scan_work(struct work_struct *work)
+{
+	struct ocfs2_delayed_orphan_scan *ds;
+	struct ocfs2_super *osb;
+
+	ds = container_of(work, struct ocfs2_delayed_orphan_scan,
+			  ds_delayed_orphan_scan_work.work);
+	osb = ds->ds_osb;
+
+	mutex_lock(&ds->ds_lock);
+	ocfs2_queue_delayed_orphan_scan(osb);
+	schedule_delayed_work(&ds->ds_delayed_orphan_scan_work,
+			      ocfs2_orphan_scan_timeout());
+	mutex_unlock(&ds->ds_lock);
+}
+
+void ocfs2_delayed_orphan_scan_stop(struct ocfs2_super *osb)
+{
+	struct ocfs2_delayed_orphan_scan *ds;
+
+	ds = &osb->osb_delayed_scan;
+	mutex_lock(&ds->ds_lock);
+	cancel_delayed_work(&ds->ds_delayed_orphan_scan_work);
+	mutex_unlock(&ds->ds_lock);
+}
+
+int ocfs2_delayed_orphan_scan_init(struct ocfs2_super *osb)
+{
+	struct ocfs2_delayed_orphan_scan *ds;
+
+	ds = &osb->osb_delayed_scan;
+	ds->ds_osb = osb;
+	mutex_init(&ds->ds_lock);
+
+	INIT_DELAYED_WORK(&ds->ds_delayed_orphan_scan_work,
+			  ocfs2_delayed_orphan_scan_work);
+	schedule_delayed_work(&ds->ds_delayed_orphan_scan_work,
+			      ocfs2_orphan_scan_timeout());
+	return 0;
+}
+
 struct ocfs2_orphan_filldir_priv {
 	struct inode		*head;
 	struct ocfs2_super	*osb;
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 619dd7f..8b62b97 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -144,6 +144,10 @@ static inline void ocfs2_inode_set_new(struct ocfs2_super *osb,
 }
 
 /* Exported only for the journal struct init code in super.c. Do not call. */
+int ocfs2_delayed_orphan_scan_init(struct ocfs2_super *osb);
+void ocfs2_delayed_orphan_scan_stop(struct ocfs2_super *osb);
+void ocfs2_delayed_orphan_scan_exit(struct ocfs2_super *osb);
+
 void ocfs2_complete_recovery(struct work_struct *work);
 void ocfs2_wait_for_recovery(struct ocfs2_super *osb);
 
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 1386281..7dc23de 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -151,6 +151,14 @@ struct ocfs2_lock_res {
 #endif
 };
 
+struct ocfs2_delayed_orphan_scan {
+	struct mutex 		ds_lock;
+	struct ocfs2_super 	*ds_osb;
+	struct ocfs2_lock_res 	ds_lockres;     /* lock to synchronize scans */
+	struct delayed_work 	ds_delayed_orphan_scan_work;
+	u64  			ds_seqno;       /* incremented on every scan */
+};
+
 struct ocfs2_dlm_debug {
 	struct kref d_refcnt;
 	struct dentry *d_locking_state;
@@ -341,6 +349,8 @@ struct ocfs2_super
 	unsigned int			*osb_orphan_wipes;
 	wait_queue_head_t		osb_wipe_event;
 
+	struct ocfs2_delayed_orphan_scan osb_delayed_scan; 
+
 	/* used to protect metaecc calculation check of xattr. */
 	spinlock_t osb_xattr_lock;
 
diff --git a/fs/ocfs2/ocfs2_lockid.h b/fs/ocfs2/ocfs2_lockid.h
index a53ce87..fcdba09 100644
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
+	[OCFS2_LOCK_TYPE_ORPHAN_SCAN] = "OrphanScan",
 };
 
 static inline const char *ocfs2_lock_type_string(enum ocfs2_lock_type type)
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 79ff8d9..06e139e 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1802,6 +1802,8 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 
 	ocfs2_truncate_log_shutdown(osb);
 
+	ocfs2_delayed_orphan_scan_stop(osb);
+
 	/* This will disable recovery and flush any recovery work. */
 	ocfs2_recovery_exit(osb);
 
@@ -1957,6 +1959,13 @@ static int ocfs2_initialize_super(struct super_block *sb,
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
