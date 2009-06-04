From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Wed,  3 Jun 2009 17:02:56 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2 patch to track delayed orphan scan
	timer statistics
In-Reply-To: <1244073776-18748-1-git-send-email-srinivas.eeda@oracle.com>
References: <1244073776-18748-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <1244073776-18748-3-git-send-email-srinivas.eeda@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Patch to track delayed orphan scan timer statistics.

Modifies ocfs2_osb_dump to print the following:
  Orphan Scan=> Local: 10  Global: 21  Last Scan: 67 seconds ago

Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/journal.c |    4 ++++
 fs/ocfs2/ocfs2.h   |    4 +++-
 fs/ocfs2/super.c   |    8 ++++++++
 3 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index dc7cea3..4d2e28c 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1899,6 +1899,8 @@ void ocfs2_queue_orphan_scan(struct ocfs2_super *osb)
 	 * number and update LVB so other node will skip the scan for a while
 	 */
 	seqno++;
+	os->os_count++;
+	os->os_scantime = CURRENT_TIME;
 unlock:
 	ocfs2_orphan_scan_unlock(osb, seqno, DLM_LOCK_EX);
 out:
@@ -1938,6 +1940,8 @@ int ocfs2_orphan_scan_init(struct ocfs2_super *osb)
 
 	os = &osb->osb_orphan_scan;
 	os->os_osb = osb;
+	os->os_count = 0;
+	os->os_scantime = CURRENT_TIME;
 	mutex_init(&os->os_lock);
 
 	INIT_DELAYED_WORK(&os->os_orphan_scan_work,
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 373fb1c..3355b1a 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -156,7 +156,9 @@ struct ocfs2_orphan_scan {
 	struct ocfs2_super 	*os_osb;
 	struct ocfs2_lock_res 	os_lockres;     /* lock to synchronize scans */
 	struct delayed_work 	os_orphan_scan_work;
-	u32  			os_seqno;       /* incremented on every scan */
+	struct timespec		os_scantime;  /* time this node ran the scan */
+	u32			os_count;      /* tracks node specific scans */
+	u32  			os_seqno;       /* tracks cluster wide scans */
 };
 
 struct ocfs2_dlm_debug {
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 44ac27e..d05f3ca 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -208,6 +208,7 @@ static int ocfs2_osb_dump(struct ocfs2_super *osb, char *buf, int len)
 	int i;
 	struct ocfs2_cluster_connection *cconn = osb->cconn;
 	struct ocfs2_recovery_map *rm = osb->recovery_map;
+	struct ocfs2_orphan_scan *os;
 
 	out += snprintf(buf + out, len - out,
 			"%10s => Id: %-s  Uuid: %-s  Gen: 0x%X  Label: %-s\n",
@@ -309,6 +310,13 @@ static int ocfs2_osb_dump(struct ocfs2_super *osb, char *buf, int len)
 				i, osb->slot_recovery_generations[i]);
 	}
 
+	os = &osb->osb_orphan_scan;
+	out += snprintf(buf + out, len - out, "Orphan Scan=> ");
+	out += snprintf(buf + out, len - out, "Local: %u  Global: %u ",
+			os->os_count, os->os_seqno);
+	out += snprintf(buf + out, len - out, " Last Scan: %lu seconds ago\n",
+			(get_seconds() - os->os_scantime.tv_sec));
+
 	return out;
 }
 
-- 
1.5.6.5
