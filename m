From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 17 Jun 2009 18:52:22 -0700
Subject: [Ocfs2-devel] [PATCH 4/8] ocfs2: Timer to queue scan of all orphan
In-Reply-To: <1245289946-17136-1-git-send-email-sunil.mushran@oracle.com>
References: <1245289946-17136-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1245289946-17136-5-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Srinivas Eeda <srinivas.eeda@oracle.com>

Mainline commit bd1fda0725338a1a831cf763c2cacccd83d2776e

When a dentry is unlinked, the unlinking node takes an EX on the dentry lock
before moving the dentry to the orphan directory. Other nodes that have
this dentry in cache have a PR on the same dentry lock.  When the EX is
requested, the other nodes flag the corresponding inode as MAYBE_ORPHANED
during downconvert.  The inode is finally deleted when the last node to iput
the inode sees that i_nlink==0 and the MAYBE_ORPHANED flag is set.

A problem arises if a node is forced to free dentry locks because of memory
pressure. If this happens, the node will no longer get downconvert
notifications for the dentries that have been unlinked on another node.
If it also happens that node is actively using the corresponding inode and
happens to be the one performing the last iput on that inode, it will fail
to delete the inode as it will not have the MAYBE_ORPHANED flag set.

This patch fixes this shortcoming by introducing a periodic scan of the
orphan directories to delete such inodes. Care has been taken to distribute
the workload across the cluster so that no one node has to perform the task
all the time.

Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlmglue.c      |   51 ++++++++++++++++++++++
 fs/ocfs2/dlmglue.h      |   10 ++++
 fs/ocfs2/journal.c      |  107 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/journal.h      |    4 ++
 fs/ocfs2/ocfs2.h        |    9 ++++
 fs/ocfs2/ocfs2_lockid.h |    5 ++
 fs/ocfs2/super.c        |    9 ++++
 7 files changed, 195 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index bacb092..72463d8 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -246,6 +246,10 @@ static struct ocfs2_lock_res_ops ocfs2_rename_lops = {
 	.flags		= 0,
 };
 
+static struct ocfs2_lock_res_ops ocfs2_orphan_scan_lops = {
+	.flags		= LOCK_TYPE_REQUIRES_REFRESH|LOCK_TYPE_USES_LVB,
+};
+
 static struct ocfs2_lock_res_ops ocfs2_dentry_lops = {
 	.get_osb	= ocfs2_get_dentry_osb,
 	.post_unlock	= ocfs2_dentry_post_unlock,
@@ -632,6 +636,19 @@ static void ocfs2_rename_lock_res_init(struct ocfs2_lock_res *res,
 				   &ocfs2_rename_lops, osb);
 }
 
+static void ocfs2_orphan_scan_lock_res_init(struct ocfs2_lock_res *res,
+					    struct ocfs2_super *osb)
+{
+	struct ocfs2_orphan_scan_lvb *lvb;
+
+	ocfs2_lock_res_init_once(res);
+	ocfs2_build_lock_name(OCFS2_LOCK_TYPE_ORPHAN_SCAN, 0, 0, res->l_name);
+	ocfs2_lock_res_init_common(osb, res, OCFS2_LOCK_TYPE_ORPHAN_SCAN,
+				   &ocfs2_orphan_scan_lops, osb);
+	lvb = (struct ocfs2_orphan_scan_lvb *)res->l_lksb.lvb;
+	lvb->lvb_version = OCFS2_ORPHAN_LVB_VERSION;
+}
+
 void ocfs2_file_lock_res_init(struct ocfs2_lock_res *lockres,
 			      struct ocfs2_file_private *fp)
 {
@@ -2212,6 +2229,37 @@ void ocfs2_inode_unlock(struct inode *inode,
 	mlog_exit_void();
 }
 
+int ocfs2_orphan_scan_lock(struct ocfs2_super *osb, u32 *seqno, int ex)
+{
+	struct ocfs2_lock_res *lockres;
+	struct ocfs2_orphan_scan_lvb *lvb;
+	int level = ex ? LKM_EXMODE : LKM_PRMODE;
+	int status = 0;
+
+	lockres = &osb->osb_orphan_scan.os_lockres;
+	status = ocfs2_cluster_lock(osb, lockres, level, 0, 0);
+	if (status < 0)
+		return status;
+
+	lvb = (struct ocfs2_orphan_scan_lvb *)lockres->l_lksb.lvb;
+	if (lvb->lvb_version == OCFS2_ORPHAN_LVB_VERSION)
+		*seqno = be32_to_cpu(lvb->lvb_os_seqno);
+	return status;
+}
+
+void ocfs2_orphan_scan_unlock(struct ocfs2_super *osb, u32 seqno, int ex)
+{
+	struct ocfs2_lock_res *lockres;
+	struct ocfs2_orphan_scan_lvb *lvb;
+	int level = ex ? LKM_EXMODE : LKM_PRMODE;
+
+	lockres = &osb->osb_orphan_scan.os_lockres;
+	lvb = (struct ocfs2_orphan_scan_lvb *)lockres->l_lksb.lvb;
+	lvb->lvb_version = OCFS2_ORPHAN_LVB_VERSION;
+	lvb->lvb_os_seqno = cpu_to_be32(seqno);
+	ocfs2_cluster_unlock(osb, lockres, level);
+}
+
 int ocfs2_super_lock(struct ocfs2_super *osb,
 		     int ex)
 {
@@ -2676,6 +2724,7 @@ int ocfs2_dlm_init(struct ocfs2_super *osb)
 local:
 	ocfs2_super_lock_res_init(&osb->osb_super_lockres, osb);
 	ocfs2_rename_lock_res_init(&osb->osb_rename_lockres, osb);
+	ocfs2_orphan_scan_lock_res_init(&osb->osb_orphan_scan.os_lockres, osb);
 
 	osb->dlm = dlm;
 
@@ -2706,6 +2755,7 @@ void ocfs2_dlm_shutdown(struct ocfs2_super *osb)
 
 	ocfs2_lock_res_free(&osb->osb_super_lockres);
 	ocfs2_lock_res_free(&osb->osb_rename_lockres);
+	ocfs2_lock_res_free(&osb->osb_orphan_scan.os_lockres);
 
 	dlm_unregister_domain(osb->dlm);
 	osb->dlm = NULL;
@@ -2904,6 +2954,7 @@ static void ocfs2_drop_osb_locks(struct ocfs2_super *osb)
 {
 	ocfs2_simple_drop_lockres(osb, &osb->osb_super_lockres);
 	ocfs2_simple_drop_lockres(osb, &osb->osb_rename_lockres);
+	ocfs2_simple_drop_lockres(osb, &osb->osb_orphan_scan.os_lockres);
 }
 
 int ocfs2_drop_inode_locks(struct inode *inode)
diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
index e3cf902..a197c09 100644
--- a/fs/ocfs2/dlmglue.h
+++ b/fs/ocfs2/dlmglue.h
@@ -49,6 +49,14 @@ struct ocfs2_meta_lvb {
 	__be32       lvb_reserved2;
 };
 
+#define OCFS2_ORPHAN_LVB_VERSION 1
+
+struct ocfs2_orphan_scan_lvb {
+	__u8	lvb_version;
+	__u8	lvb_reserved[3];
+	__be32	lvb_os_seqno;
+};
+
 /* ocfs2_inode_lock_full() 'arg_flags' flags */
 /* don't wait on recovery. */
 #define OCFS2_META_LOCK_RECOVERY	(0x01)
@@ -97,6 +105,8 @@ int ocfs2_super_lock(struct ocfs2_super *osb,
 		     int ex);
 void ocfs2_super_unlock(struct ocfs2_super *osb,
 			int ex);
+int ocfs2_orphan_scan_lock(struct ocfs2_super *osb, u32 *seqno, int ex);
+void ocfs2_orphan_scan_unlock(struct ocfs2_super *osb, u32 seqno, int ex);
 int ocfs2_rename_lock(struct ocfs2_super *osb);
 void ocfs2_rename_unlock(struct ocfs2_super *osb);
 int ocfs2_dentry_lock(struct dentry *dentry, int ex);
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 484ccb5..144d492 100644
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
@@ -50,6 +52,8 @@
 
 DEFINE_SPINLOCK(trans_inc_lock);
 
+#define ORPHAN_SCAN_SCHEDULE_TIMEOUT 300000
+
 static int ocfs2_force_read_journal(struct inode *inode);
 static int ocfs2_recover_node(struct ocfs2_super *osb,
 			      int node_num);
@@ -1440,6 +1444,109 @@ bail:
 	return status;
 }
 
+/*
+ * Scan timer should get fired every ORPHAN_SCAN_SCHEDULE_TIMEOUT. Add some
+ * randomness to the timeout to minimize multple nodes firing the timer at the
+ * same time.
+ */
+static inline unsigned long ocfs2_orphan_scan_timeout(void)
+{
+	unsigned long time;
+
+	get_random_bytes(&time, sizeof(time));
+	time = ORPHAN_SCAN_SCHEDULE_TIMEOUT + (time % 5000);
+	return msecs_to_jiffies(time);
+}
+
+/*
+ * ocfs2_queue_orphan_scan calls ocfs2_queue_recovery_completion for
+ * every slot, queuing a recovery of the slot on the ocfs2_wq thread. This
+ * is done to catch any orphans that are left over in orphan directories.
+ *
+ * ocfs2_queue_orphan_scan gets called every ORPHAN_SCAN_SCHEDULE_TIMEOUT
+ * seconds.  It gets an EX lock on os_lockres and checks sequence number
+ * stored in LVB. If the sequence number has changed, it means some other
+ * node has done the scan.  This node skips the scan and tracks the
+ * sequence number.  If the sequence number didn't change, it means a scan
+ * hasn't happened.  The node queues a scan and increments the
+ * sequence number in the LVB.
+ */
+void ocfs2_queue_orphan_scan(struct ocfs2_super *osb)
+{
+	struct ocfs2_orphan_scan *os;
+	int status, i;
+	u32 seqno = 0;
+
+	os = &osb->osb_orphan_scan;
+
+	status = ocfs2_orphan_scan_lock(osb, &seqno, LKM_EXMODE);
+	if (status < 0) {
+		if (status != -EAGAIN)
+			mlog_errno(status);
+		goto out;
+	}
+
+	if (os->os_seqno != seqno) {
+		os->os_seqno = seqno;
+		goto unlock;
+	}
+
+	for (i = 0; i < osb->max_slots; i++)
+		ocfs2_queue_recovery_completion(osb->journal, i, NULL, NULL);
+
+	/*
+	 * We queued a recovery on orphan slots, increment the sequence
+	 * number and update LVB so other node will skip the scan for a while
+	 */
+	seqno++;
+unlock:
+	ocfs2_orphan_scan_unlock(osb, seqno, LKM_EXMODE);
+out:
+	return;
+}
+
+/* Worker task that gets fired every ORPHAN_SCAN_SCHEDULE_TIMEOUT millsec */
+void ocfs2_orphan_scan_work(kapi_work_struct_t *work)
+{
+	struct ocfs2_orphan_scan *os;
+	struct ocfs2_super *osb;
+
+	os = work_to_object(work, struct ocfs2_orphan_scan,
+			  os_orphan_scan_work.work);
+	osb = os->os_osb;
+
+	mutex_lock(&os->os_lock);
+	ocfs2_queue_orphan_scan(osb);
+	schedule_delayed_work(&os->os_orphan_scan_work,
+			      ocfs2_orphan_scan_timeout());
+	mutex_unlock(&os->os_lock);
+}
+
+void ocfs2_orphan_scan_stop(struct ocfs2_super *osb)
+{
+	struct ocfs2_orphan_scan *os;
+
+	os = &osb->osb_orphan_scan;
+	mutex_lock(&os->os_lock);
+	cancel_delayed_work(&os->os_orphan_scan_work);
+	mutex_unlock(&os->os_lock);
+}
+
+int ocfs2_orphan_scan_init(struct ocfs2_super *osb)
+{
+	struct ocfs2_orphan_scan *os;
+
+	os = &osb->osb_orphan_scan;
+	os->os_osb = osb;
+	mutex_init(&os->os_lock);
+
+	KAPI_INIT_DELAYED_WORK(&os->os_orphan_scan_work,
+			  ocfs2_orphan_scan_work, os);
+	schedule_delayed_work(&os->os_orphan_scan_work,
+			      ocfs2_orphan_scan_timeout());
+	return 0;
+}
+
 struct ocfs2_orphan_filldir_priv {
 	struct inode		*head;
 	struct ocfs2_super	*osb;
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index df8e9de..fa18a84 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -133,6 +133,10 @@ static inline void ocfs2_inode_set_new(struct ocfs2_super *osb,
 }
 
 /* Exported only for the journal struct init code in super.c. Do not call. */
+int ocfs2_orphan_scan_init(struct ocfs2_super *osb);
+void ocfs2_orphan_scan_stop(struct ocfs2_super *osb);
+void ocfs2_orphan_scan_exit(struct ocfs2_super *osb);
+
 void ocfs2_complete_recovery(kapi_work_struct_t *work);
 
 int ocfs2_compute_replay_slots(struct ocfs2_super *osb);
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index e84185d..7989966 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -145,6 +145,14 @@ struct ocfs2_lock_res {
 #endif
 };
 
+struct ocfs2_orphan_scan {
+	struct mutex 		os_lock;
+	struct ocfs2_super 	*os_osb;
+	struct ocfs2_lock_res 	os_lockres;     /* lock to synchronize scans */
+	struct delayed_work 	os_orphan_scan_work;
+	u32                     os_seqno;       /* incremented on every scan */
+};
+
 struct ocfs2_dlm_debug {
 	struct kref d_refcnt;
 	struct dentry *d_locking_state;
@@ -319,6 +327,7 @@ struct ocfs2_super
 	struct ocfs2_node_map		osb_recovering_orphan_dirs;
 	unsigned int			*osb_orphan_wipes;
 	wait_queue_head_t		osb_wipe_event;
+	struct ocfs2_orphan_scan 	osb_orphan_scan;
 
 	/* the group we used to allocate inodes. */
 	u64				osb_inode_alloc_group;
diff --git a/fs/ocfs2/ocfs2_lockid.h b/fs/ocfs2/ocfs2_lockid.h
index 86f3e37..89e2645 100644
--- a/fs/ocfs2/ocfs2_lockid.h
+++ b/fs/ocfs2/ocfs2_lockid.h
@@ -46,6 +46,7 @@ enum ocfs2_lock_type {
 	OCFS2_LOCK_TYPE_DENTRY,
 	OCFS2_LOCK_TYPE_OPEN,
 	OCFS2_LOCK_TYPE_FLOCK,
+	OCFS2_LOCK_TYPE_ORPHAN_SCAN,
 	OCFS2_NUM_LOCK_TYPES
 };
 
@@ -77,6 +78,9 @@ static inline char ocfs2_lock_type_char(enum ocfs2_lock_type type)
 		case OCFS2_LOCK_TYPE_FLOCK:
 			c = 'F';
 			break;
+		case OCFS2_LOCK_TYPE_ORPHAN_SCAN:
+			c = 'P';
+			break;
 		default:
 			c = '\0';
 	}
@@ -95,6 +99,7 @@ static char *ocfs2_lock_type_strings[] = {
 	[OCFS2_LOCK_TYPE_DENTRY] = "Dentry",
 	[OCFS2_LOCK_TYPE_OPEN] = "Open",
 	[OCFS2_LOCK_TYPE_FLOCK] = "Flock",
+	[OCFS2_LOCK_TYPE_ORPHAN_SCAN] = "OrphanScan",
 };
 
 static inline const char *ocfs2_lock_type_string(enum ocfs2_lock_type type)
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index a421e7d..cd66b4d 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1495,6 +1495,8 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 
 	ocfs2_truncate_log_shutdown(osb);
 
+	ocfs2_orphan_scan_stop(osb);
+
 	/* disable any new recovery threads and wait for any currently
 	 * running ones to exit. Do this before setting the vol_state. */
 	mutex_lock(&osb->recovery_lock);
@@ -1640,6 +1642,13 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	osb->disable_recovery = 0;
 	osb->recovery_thread_task = NULL;
 
+	status = ocfs2_orphan_scan_init(osb);
+	if (status) {
+		mlog(ML_ERROR, "Unable to initialize delayed orphan scan\n");
+		mlog_errno(status);
+		goto bail;
+	}
+
 	init_waitqueue_head(&osb->checkpoint_event);
 	atomic_set(&osb->needs_checkpoint, 0);
 
-- 
1.6.0.4
