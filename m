From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 19 Jun 2009 16:53:17 -0700
Subject: [Ocfs2-devel] [PATCH 3/5] ocfs2: Stop orphan scan as early as
	possible during umount
In-Reply-To: <1245455599-23348-1-git-send-email-sunil.mushran@oracle.com>
References: <1245455599-23348-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1245455599-23348-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Currently if the orphan scan fires a tick before the user issues the umount,
the umount will wait for the queued orphan scan tasks to complete.

This patch makes the umount stop the orphan scan as early as possible so as
to reduce the probability of the queued tasks slowing down the umount.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/journal.c |   14 ++++++++++++--
 fs/ocfs2/ocfs2.h   |    6 ++++++
 fs/ocfs2/super.c   |    5 +++--
 3 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 4a3b9e6..70215a2 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1880,6 +1880,9 @@ void ocfs2_queue_orphan_scan(struct ocfs2_super *osb)
 
 	os = &osb->osb_orphan_scan;
 
+	if (atomic_read(&os->os_state) == ORPHAN_SCAN_INACTIVE)
+		goto out;
+
 	status = ocfs2_orphan_scan_lock(osb, &seqno, DLM_LOCK_EX);
 	if (status < 0) {
 		if (status != -EAGAIN)
@@ -1887,6 +1890,10 @@ void ocfs2_queue_orphan_scan(struct ocfs2_super *osb)
 		goto out;
 	}
 
+	/* Do no queue the tasks if the volume is being umounted */
+	if (atomic_read(&os->os_state) == ORPHAN_SCAN_INACTIVE)
+		goto unlock;
+
 	if (os->os_seqno != seqno) {
 		os->os_seqno = seqno;
 		goto unlock;
@@ -1920,8 +1927,9 @@ void ocfs2_orphan_scan_work(struct work_struct *work)
 
 	mutex_lock(&os->os_lock);
 	ocfs2_queue_orphan_scan(osb);
-	schedule_delayed_work(&os->os_orphan_scan_work,
-			      ocfs2_orphan_scan_timeout());
+	if (atomic_read(&os->os_state) == ORPHAN_SCAN_ACTIVE)
+		schedule_delayed_work(&os->os_orphan_scan_work,
+				      ocfs2_orphan_scan_timeout());
 	mutex_unlock(&os->os_lock);
 }
 
@@ -1930,6 +1938,7 @@ void ocfs2_orphan_scan_stop(struct ocfs2_super *osb)
 	struct ocfs2_orphan_scan *os;
 
 	os = &osb->osb_orphan_scan;
+	atomic_set(&os->os_state, ORPHAN_SCAN_INACTIVE);
 	mutex_lock(&os->os_lock);
 	cancel_delayed_work(&os->os_orphan_scan_work);
 	mutex_unlock(&os->os_lock);
@@ -1940,6 +1949,7 @@ int ocfs2_orphan_scan_init(struct ocfs2_super *osb)
 	struct ocfs2_orphan_scan *os;
 
 	os = &osb->osb_orphan_scan;
+	atomic_set(&os->os_state, ORPHAN_SCAN_ACTIVE);
 	os->os_osb = osb;
 	os->os_count = 0;
 	os->os_scantime = CURRENT_TIME;
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 18c1d9e..60e8950 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -154,6 +154,11 @@ struct ocfs2_lock_res {
 #endif
 };
 
+enum ocfs2_orphan_scan_state {
+	ORPHAN_SCAN_ACTIVE,
+	ORPHAN_SCAN_INACTIVE
+};
+
 struct ocfs2_orphan_scan {
 	struct mutex 		os_lock;
 	struct ocfs2_super 	*os_osb;
@@ -162,6 +167,7 @@ struct ocfs2_orphan_scan {
 	struct timespec		os_scantime;  /* time this node ran the scan */
 	u32			os_count;      /* tracks node specific scans */
 	u32  			os_seqno;       /* tracks cluster wide scans */
+	atomic_t		os_state;              /* ACTIVE or INACTIVE */
 };
 
 struct ocfs2_dlm_debug {
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index d64739b..3e8a68b 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1814,14 +1814,15 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 
 	debugfs_remove(osb->osb_ctxt);
 
+	/* Orphan scan should be stopped as early as possible */
+	ocfs2_orphan_scan_stop(osb);
+
 	ocfs2_disable_quotas(osb);
 
 	ocfs2_shutdown_local_alloc(osb);
 
 	ocfs2_truncate_log_shutdown(osb);
 
-	ocfs2_orphan_scan_stop(osb);
-
 	/* This will disable recovery and flush any recovery work. */
 	ocfs2_recovery_exit(osb);
 
-- 
1.6.0.4
