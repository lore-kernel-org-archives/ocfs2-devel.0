From: George Spelvin <lkml@sdf.org>
Date: Sat, 28 Mar 2020 16:43:58 -0000
Subject: [Ocfs2-devel] [RFC PATCH v1 29/50] fs/ocfs2/journal: Use
 prandom_u32() and not /dev/random for timeout
Message-ID: <202003281643.02SGhIOY022599@sdf.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

get_random_bytes() is expensive crypto-quality random numbers.
If we're just doing random backoff, prandom_u32() is plenty.

(Not to mention fetching 8 bytes of seed material only to
reduce it modulo 5000 is a huge waste.)

Also, convert timeouts to jiffies at compile time; convert
milliseconds to jiffies before picking a random number in the
range to take advantage of compile-time constant folding.

Signed-off-by: George Spelvin <lkml@sdf.org>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel at oss.oracle.com
---
 fs/ocfs2/journal.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 68ba354cf3610..939a12e57fa8b 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1884,11 +1884,8 @@ int ocfs2_mark_dead_nodes(struct ocfs2_super *osb)
  */
 static inline unsigned long ocfs2_orphan_scan_timeout(void)
 {
-	unsigned long time;
-
-	get_random_bytes(&time, sizeof(time));
-	time = ORPHAN_SCAN_SCHEDULE_TIMEOUT + (time % 5000);
-	return msecs_to_jiffies(time);
+	return msecs_to_jiffies(ORPHAN_SCAN_SCHEDULE_TIMEOUT) +
+		prandom_u32_max(5 * HZ);
 }
 
 /*
-- 
2.26.0
