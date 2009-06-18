From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 17 Jun 2009 18:52:23 -0700
Subject: [Ocfs2-devel] [PATCH 5/8] ocfs2: Track delayed orphan scan
In-Reply-To: <1245289946-17136-1-git-send-email-sunil.mushran@oracle.com>
References: <1245289946-17136-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1245289946-17136-6-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Srinivas Eeda <srinivas.eeda@oracle.com>

Mainline commit f6080a698251629e8152554f5d1e33ec3ffe2a3d

Patch to track delayed orphan scan timer statistics.

Modifies ocfs2_osb_dump to print the following:
  Orphan Scan=> Local: 10  Global: 21  Last Scan: 67 seconds ago

Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/journal.c |    4 ++++
 fs/ocfs2/ocfs2.h   |    4 +++-
 fs/ocfs2/super.c   |    7 +++++++
 3 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 144d492..c0acffa 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1499,6 +1499,8 @@ void ocfs2_queue_orphan_scan(struct ocfs2_super *osb)
 	 * number and update LVB so other node will skip the scan for a while
 	 */
 	seqno++;
+	os->os_count++;
+	os->os_scantime = CURRENT_TIME;
 unlock:
 	ocfs2_orphan_scan_unlock(osb, seqno, LKM_EXMODE);
 out:
@@ -1538,6 +1540,8 @@ int ocfs2_orphan_scan_init(struct ocfs2_super *osb)
 
 	os = &osb->osb_orphan_scan;
 	os->os_osb = osb;
+	os->os_count = 0;
+	os->os_scantime = CURRENT_TIME;
 	mutex_init(&os->os_lock);
 
 	KAPI_INIT_DELAYED_WORK(&os->os_orphan_scan_work,
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 7989966..9ee656d 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -150,7 +150,9 @@ struct ocfs2_orphan_scan {
 	struct ocfs2_super 	*os_osb;
 	struct ocfs2_lock_res 	os_lockres;     /* lock to synchronize scans */
 	struct delayed_work 	os_orphan_scan_work;
-	u32                     os_seqno;       /* incremented on every scan */
+	struct timespec         os_scantime;  /* time this node ran the scan */
+	u32                     os_count;      /* tracks node specific scans */
+	u32                     os_seqno;       /* tracks cluster wide scans */
 };
 
 struct ocfs2_dlm_debug {
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index cd66b4d..374063a 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -198,6 +198,7 @@ static int ocfs2_osb_dump(struct ocfs2_super *osb, char *buf, int len)
 {
 	int out = 0;
 	int i;
+	struct ocfs2_orphan_scan *os;
 
 	out += snprintf(buf + out, len - out,
 			"%10s => Id: %-s  Uuid: %-s  Gen: 0x%X  Label: %-s\n",
@@ -290,6 +291,12 @@ static int ocfs2_osb_dump(struct ocfs2_super *osb, char *buf, int len)
 				i, osb->slot_recovery_generations[i]);
 	}
 
+	os = &osb->osb_orphan_scan;
+	out += snprintf(buf + out, len - out, "Orphan Scan=> ");
+	out += snprintf(buf + out, len - out, "Local: %u  Global: %u ",
+			os->os_count, os->os_seqno);
+	out += snprintf(buf + out, len - out, " Last Scan: %lu seconds ago\n",
+			(get_seconds() - os->os_scantime.tv_sec));
 	return out;
 }
 
-- 
1.6.0.4
