From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 22 Jun 2009 11:40:07 -0700
Subject: [Ocfs2-devel] [PATCH 5/5] ocfs2: Disable orphan scanning for local
	and hard-ro mounts
In-Reply-To: <1245696007-29494-1-git-send-email-sunil.mushran@oracle.com>
References: <1245696007-29494-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1245696007-29494-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Local and Hard-RO mounts do not need orphan scanning.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlmglue.c |   26 ++++++++++++++++----------
 fs/ocfs2/dlmglue.h |    4 ++--
 fs/ocfs2/journal.c |   30 +++++++++++++++++-------------
 fs/ocfs2/journal.h |    2 +-
 fs/ocfs2/super.c   |   32 +++++++++++++++-----------------
 5 files changed, 51 insertions(+), 43 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 667701e..8036800 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2365,15 +2365,20 @@ void ocfs2_inode_unlock(struct inode *inode,
 	mlog_exit_void();
 }
 
-int ocfs2_orphan_scan_lock(struct ocfs2_super *osb, u32 *seqno, int ex)
+int ocfs2_orphan_scan_lock(struct ocfs2_super *osb, u32 *seqno)
 {
 	struct ocfs2_lock_res *lockres;
 	struct ocfs2_orphan_scan_lvb *lvb;
-	int level = ex ? DLM_LOCK_EX : DLM_LOCK_PR;
 	int status = 0;
 
+	if (ocfs2_is_hard_readonly(osb))
+		return -EROFS;
+
+	if (ocfs2_mount_local(osb))
+		return 0;
+
 	lockres = &osb->osb_orphan_scan.os_lockres;
-	status = ocfs2_cluster_lock(osb, lockres, level, 0, 0);
+	status = ocfs2_cluster_lock(osb, lockres, DLM_LOCK_EX, 0, 0);
 	if (status < 0)
 		return status;
 
@@ -2386,17 +2391,18 @@ int ocfs2_orphan_scan_lock(struct ocfs2_super *osb, u32 *seqno, int ex)
 	return status;
 }
 
-void ocfs2_orphan_scan_unlock(struct ocfs2_super *osb, u32 seqno, int ex)
+void ocfs2_orphan_scan_unlock(struct ocfs2_super *osb, u32 seqno)
 {
 	struct ocfs2_lock_res *lockres;
 	struct ocfs2_orphan_scan_lvb *lvb;
-	int level = ex ? DLM_LOCK_EX : DLM_LOCK_PR;
 
-	lockres = &osb->osb_orphan_scan.os_lockres;
-	lvb = ocfs2_dlm_lvb(&lockres->l_lksb);
-	lvb->lvb_version = OCFS2_ORPHAN_LVB_VERSION;
-	lvb->lvb_os_seqno = cpu_to_be32(seqno);
-	ocfs2_cluster_unlock(osb, lockres, level);
+	if (!ocfs2_is_hard_readonly(osb) && !ocfs2_mount_local(osb)) {
+		lockres = &osb->osb_orphan_scan.os_lockres;
+		lvb = ocfs2_dlm_lvb(&lockres->l_lksb);
+		lvb->lvb_version = OCFS2_ORPHAN_LVB_VERSION;
+		lvb->lvb_os_seqno = cpu_to_be32(seqno);
+		ocfs2_cluster_unlock(osb, lockres, DLM_LOCK_EX);
+	}
 }
 
 int ocfs2_super_lock(struct ocfs2_super *osb,
diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
index 31b90d7..30f6831 100644
--- a/fs/ocfs2/dlmglue.h
+++ b/fs/ocfs2/dlmglue.h
@@ -121,8 +121,8 @@ int ocfs2_super_lock(struct ocfs2_super *osb,
 		     int ex);
 void ocfs2_super_unlock(struct ocfs2_super *osb,
 			int ex);
-int ocfs2_orphan_scan_lock(struct ocfs2_super *osb, u32 *seqno, int ex);
-void ocfs2_orphan_scan_unlock(struct ocfs2_super *osb, u32 seqno, int ex);
+int ocfs2_orphan_scan_lock(struct ocfs2_super *osb, u32 *seqno);
+void ocfs2_orphan_scan_unlock(struct ocfs2_super *osb, u32 seqno);
 
 int ocfs2_rename_lock(struct ocfs2_super *osb);
 void ocfs2_rename_unlock(struct ocfs2_super *osb);
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 0b2c27a..f033760 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1883,7 +1883,7 @@ void ocfs2_queue_orphan_scan(struct ocfs2_super *osb)
 	if (atomic_read(&os->os_state) == ORPHAN_SCAN_INACTIVE)
 		goto out;
 
-	status = ocfs2_orphan_scan_lock(osb, &seqno, DLM_LOCK_EX);
+	status = ocfs2_orphan_scan_lock(osb, &seqno);
 	if (status < 0) {
 		if (status != -EAGAIN)
 			mlog_errno(status);
@@ -1910,7 +1910,7 @@ void ocfs2_queue_orphan_scan(struct ocfs2_super *osb)
 	os->os_count++;
 	os->os_scantime = CURRENT_TIME;
 unlock:
-	ocfs2_orphan_scan_unlock(osb, seqno, DLM_LOCK_EX);
+	ocfs2_orphan_scan_unlock(osb, seqno);
 out:
 	return;
 }
@@ -1938,29 +1938,33 @@ void ocfs2_orphan_scan_stop(struct ocfs2_super *osb)
 	struct ocfs2_orphan_scan *os;
 
 	os = &osb->osb_orphan_scan;
-	atomic_set(&os->os_state, ORPHAN_SCAN_INACTIVE);
-	mutex_lock(&os->os_lock);
-	cancel_delayed_work(&os->os_orphan_scan_work);
-	mutex_unlock(&os->os_lock);
+	if (atomic_read(&os->os_state) == ORPHAN_SCAN_ACTIVE) {
+		atomic_set(&os->os_state, ORPHAN_SCAN_INACTIVE);
+		mutex_lock(&os->os_lock);
+		cancel_delayed_work(&os->os_orphan_scan_work);
+		mutex_unlock(&os->os_lock);
+	}
 }
 
-int ocfs2_orphan_scan_init(struct ocfs2_super *osb)
+void ocfs2_orphan_scan_init(struct ocfs2_super *osb)
 {
 	struct ocfs2_orphan_scan *os;
 
 	os = &osb->osb_orphan_scan;
-	atomic_set(&os->os_state, ORPHAN_SCAN_ACTIVE);
 	os->os_osb = osb;
 	os->os_count = 0;
 	os->os_seqno = 0;
 	os->os_scantime = CURRENT_TIME;
 	mutex_init(&os->os_lock);
+	INIT_DELAYED_WORK(&os->os_orphan_scan_work, ocfs2_orphan_scan_work);
 
-	INIT_DELAYED_WORK(&os->os_orphan_scan_work,
-			  ocfs2_orphan_scan_work);
-	schedule_delayed_work(&os->os_orphan_scan_work,
-			      ocfs2_orphan_scan_timeout());
-	return 0;
+	if (ocfs2_is_hard_readonly(osb) || ocfs2_mount_local(osb))
+		atomic_set(&os->os_state, ORPHAN_SCAN_INACTIVE);
+	else {
+		atomic_set(&os->os_state, ORPHAN_SCAN_ACTIVE);
+		schedule_delayed_work(&os->os_orphan_scan_work,
+				      ocfs2_orphan_scan_timeout());
+	}
 }
 
 struct ocfs2_orphan_filldir_priv {
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 61045ee..5432c7f 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -144,7 +144,7 @@ static inline void ocfs2_inode_set_new(struct ocfs2_super *osb,
 }
 
 /* Exported only for the journal struct init code in super.c. Do not call. */
-int ocfs2_orphan_scan_init(struct ocfs2_super *osb);
+void ocfs2_orphan_scan_init(struct ocfs2_super *osb);
 void ocfs2_orphan_scan_stop(struct ocfs2_super *osb);
 void ocfs2_orphan_scan_exit(struct ocfs2_super *osb);
 
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 3e8a68b..0746e1a 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -205,11 +205,10 @@ static const match_table_t tokens = {
 #ifdef CONFIG_DEBUG_FS
 static int ocfs2_osb_dump(struct ocfs2_super *osb, char *buf, int len)
 {
-	int out = 0;
-	int i;
 	struct ocfs2_cluster_connection *cconn = osb->cconn;
 	struct ocfs2_recovery_map *rm = osb->recovery_map;
-	struct ocfs2_orphan_scan *os;
+	struct ocfs2_orphan_scan *os = &osb->osb_orphan_scan;
+	int i, out = 0;
 
 	out += snprintf(buf + out, len - out,
 			"%10s => Id: %-s  Uuid: %-s  Gen: 0x%X  Label: %-s\n",
@@ -305,6 +304,16 @@ static int ocfs2_osb_dump(struct ocfs2_super *osb, char *buf, int len)
 			atomic_read(&osb->s_num_inodes_stolen));
 	spin_unlock(&osb->osb_lock);
 
+	out += snprintf(buf + out, len - out, "OrphanScan => ");
+	out += snprintf(buf + out, len - out, "Local: %u  Global: %u ",
+			os->os_count, os->os_seqno);
+	out += snprintf(buf + out, len - out, " Last Scan: ");
+	if (atomic_read(&os->os_state) == ORPHAN_SCAN_INACTIVE)
+		out += snprintf(buf + out, len - out, "Disabled\n");
+	else
+		out += snprintf(buf + out, len - out, "%lu seconds ago\n",
+				(get_seconds() - os->os_scantime.tv_sec));
+
 	out += snprintf(buf + out, len - out, "%10s => %3s  %10s\n",
 			"Slots", "Num", "RecoGen");
 	for (i = 0; i < osb->max_slots; ++i) {
@@ -315,13 +324,6 @@ static int ocfs2_osb_dump(struct ocfs2_super *osb, char *buf, int len)
 				i, osb->slot_recovery_generations[i]);
 	}
 
-	os = &osb->osb_orphan_scan;
-	out += snprintf(buf + out, len - out, "Orphan Scan=> ");
-	out += snprintf(buf + out, len - out, "Local: %u  Global: %u ",
-			os->os_count, os->os_seqno);
-	out += snprintf(buf + out, len - out, " Last Scan: %lu seconds ago\n",
-			(get_seconds() - os->os_scantime.tv_sec));
-
 	return out;
 }
 
@@ -1179,6 +1181,9 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	atomic_set(&osb->vol_state, VOLUME_MOUNTED_QUOTAS);
 	wake_up(&osb->osb_mount_event);
 
+	/* Start this when the mount is almost sure of being successful */
+	ocfs2_orphan_scan_init(osb);
+
 	mlog_exit(status);
 	return status;
 
@@ -1983,13 +1988,6 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		goto bail;
 	}
 
-	status = ocfs2_orphan_scan_init(osb);
-	if (status) {
-		mlog(ML_ERROR, "Unable to initialize delayed orphan scan\n");
-		mlog_errno(status);
-		goto bail;
-	}
-
 	init_waitqueue_head(&osb->checkpoint_event);
 	atomic_set(&osb->needs_checkpoint, 0);
 
-- 
1.6.0.4
