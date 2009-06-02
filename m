From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Mon,  1 Jun 2009 23:11:45 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2 patch to track delayed orphan scan
	timer statistics
In-Reply-To: <1243923105-3339-1-git-send-email-srinivas.eeda@oracle.com>
References: <1243923105-3339-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <1243923105-3339-3-git-send-email-srinivas.eeda@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Patch to track delayed orphan scan timer statistics.

Modifies ocfs2_osb_dump to print the following:
  Orphan Scan=> Local: 10  Global: 21  Last Scan: 67 seconds ago

Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
---
 fs/ocfs2/journal.c |    2 ++
 fs/ocfs2/ocfs2.h   |    4 +++-
 fs/ocfs2/super.c   |    7 +++++++
 3 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index cee42ed..81b5885 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1907,6 +1907,8 @@ void ocfs2_queue_delayed_orphan_scan(struct ocfs2_super *osb)
 	 * number and update LVB so other node will skip the scan for a while
 	 */
 	seqno++;
+	ds->ds_count++;
+	ds->ds_scantime = CURRENT_TIME;
 unlock:
 	ocfs2_orphan_scan_unlock(osb, seqno, level);
 out:
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 7dc23de..4eea45e 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -156,7 +156,9 @@ struct ocfs2_delayed_orphan_scan {
 	struct ocfs2_super 	*ds_osb;
 	struct ocfs2_lock_res 	ds_lockres;     /* lock to synchronize scans */
 	struct delayed_work 	ds_delayed_orphan_scan_work;
-	u64  			ds_seqno;       /* incremented on every scan */
+	struct timespec		ds_scantime;  /* time this node ran the scan */
+	u64 			ds_count;      /* tracks node specific scans */
+	u64  			ds_seqno;       /* tracks cluster wide scans */
 };
 
 struct ocfs2_dlm_debug {
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 06e139e..d2320a0 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -208,6 +208,7 @@ static int ocfs2_osb_dump(struct ocfs2_super *osb, char *buf, int len)
 	int i;
 	struct ocfs2_cluster_connection *cconn = osb->cconn;
 	struct ocfs2_recovery_map *rm = osb->recovery_map;
+	struct ocfs2_delayed_orphan_scan *ds;
 
 	out += snprintf(buf + out, len - out,
 			"%10s => Id: %-s  Uuid: %-s  Gen: 0x%X  Label: %-s\n",
@@ -309,6 +310,12 @@ static int ocfs2_osb_dump(struct ocfs2_super *osb, char *buf, int len)
 				i, osb->slot_recovery_generations[i]);
 	}
 
+	ds = &osb->osb_delayed_scan;
+	out += snprintf(buf + out, len - out, "Orphan Scan=> ");
+	out += snprintf(buf + out, len - out, "Local: %llu  Global: %llu ",
+		       ds->ds_count, ds->ds_seqno);
+	out += snprintf(buf + out, len - out, " Last Scan: %lu seconds ago\n",
+			(get_seconds() - ds->ds_scantime.tv_sec));
 	return out;
 }
 
-- 
1.5.6.5
