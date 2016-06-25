From: Deepa Dinamani <deepa.kernel@gmail.com>
Date: Sat, 25 Jun 2016 14:37:40 -0700
Subject: [Ocfs2-devel] [PATCH v3 16/24] fs: ocfs2: Use time64_t to represent
	orphan scan times
In-Reply-To: <1466890668-23400-1-git-send-email-deepa.kernel@gmail.com>
References: <1466890668-23400-1-git-send-email-deepa.kernel@gmail.com>
Message-ID: <1466890668-23400-17-git-send-email-deepa.kernel@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, tglx@linutronix.de, torvalds@linux-foundation.org, tytso@mit.edu, viro@zeniv.linux.org.uk, y2038@lists.linaro.org, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com

struct timespec is not y2038 safe.
Use time64_t which is y2038 safe to represent orphan
scan times.
time64_t is sufficient here as only the seconds delta
times are relevant.

Also use appropriate time functions that return time in
time64_t format. Time functions now return monotonic
time instead of real time as only delta scan times are
relevant and these values are not persistent across
reboots.

The format string for the debug print is still using long
as this is only the time elapsed since the last scan and
long is sufficient to represent this value.

Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel at oss.oracle.com
---
 fs/ocfs2/journal.c | 4 ++--
 fs/ocfs2/ocfs2.h   | 2 +-
 fs/ocfs2/super.c   | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index bc0e21e..ab68933 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1949,7 +1949,7 @@ static void ocfs2_queue_orphan_scan(struct ocfs2_super *osb)
 	 */
 	seqno++;
 	os->os_count++;
-	os->os_scantime = CURRENT_TIME;
+	os->os_scantime = ktime_get_seconds();
 unlock:
 	ocfs2_orphan_scan_unlock(osb, seqno);
 out:
@@ -2006,7 +2006,7 @@ void ocfs2_orphan_scan_start(struct ocfs2_super *osb)
 	struct ocfs2_orphan_scan *os;
 
 	os = &osb->osb_orphan_scan;
-	os->os_scantime = CURRENT_TIME;
+	os->os_scantime = ktime_get_seconds();
 	if (ocfs2_is_hard_readonly(osb) || ocfs2_mount_local(osb))
 		atomic_set(&os->os_state, ORPHAN_SCAN_INACTIVE);
 	else {
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index e63af7d..7e5958b 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -224,7 +224,7 @@ struct ocfs2_orphan_scan {
 	struct ocfs2_super 	*os_osb;
 	struct ocfs2_lock_res 	os_lockres;     /* lock to synchronize scans */
 	struct delayed_work 	os_orphan_scan_work;
-	struct timespec		os_scantime;  /* time this node ran the scan */
+	time64_t		os_scantime;  /* time this node ran the scan */
 	u32			os_count;      /* tracks node specific scans */
 	u32  			os_seqno;       /* tracks cluster wide scans */
 	atomic_t		os_state;              /* ACTIVE or INACTIVE */
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 3971146..6992c00 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -337,7 +337,7 @@ static int ocfs2_osb_dump(struct ocfs2_super *osb, char *buf, int len)
 		out += snprintf(buf + out, len - out, "Disabled\n");
 	else
 		out += snprintf(buf + out, len - out, "%lu seconds ago\n",
-				(get_seconds() - os->os_scantime.tv_sec));
+				(unsigned long)(ktime_get_seconds() - os->os_scantime));
 
 	out += snprintf(buf + out, len - out, "%10s => %3s  %10s\n",
 			"Slots", "Num", "RecoGen");
-- 
1.9.1
