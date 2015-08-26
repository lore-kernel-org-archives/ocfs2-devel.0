From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Wed, 26 Aug 2015 15:12:03 -0700
Subject: [Ocfs2-devel] [patch 16/28] ocfs2: use 64bit variables to track
	heartbeat time
Message-ID: <55de39b3.bvLYc7Hlsn6Fm6Py%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tina Ruchandani <ruchandani.tina@gmail.com>
Subject: ocfs2: use 64bit variables to track heartbeat time

o2hb_elapsed_msecs computes the time taken for a disk heartbeat.  'struct
timeval' variables are used to store start and end times.  On 32-bit
systems, the 'tv_sec' component of 'struct timeval' will overflow in year
2038 and beyond.

This patch solves the overflow with the following:

1. Replace o2hb_elapsed_msecs using 'ktime_t' values to measure start
   and end time, and built-in function 'ktime_ms_delta' to compute the
   elapsed time.  ktime_get_real() is used since the code prints out the
   wallclock time.

2. Changes format string to print time as a single 64-bit nanoseconds
   value ("%lld") instead of seconds and microseconds.  This simplifies
   the code since converting ktime_t to that format would need expensive
   computation.  However, the debug log string is less readable than the
   previous format.

Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
Suggested by: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |   49 ++++++---------------------------
 1 file changed, 9 insertions(+), 40 deletions(-)

diff -puN fs/ocfs2/cluster/heartbeat.c~ocfs2-use-64bit-variables-to-track-heartbeat-time fs/ocfs2/cluster/heartbeat.c
--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-use-64bit-variables-to-track-heartbeat-time
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -36,7 +36,7 @@
 #include <linux/debugfs.h>
 #include <linux/slab.h>
 #include <linux/bitmap.h>
-
+#include <linux/ktime.h>
 #include "heartbeat.h"
 #include "tcp.h"
 #include "nodemanager.h"
@@ -1061,37 +1061,6 @@ bail:
 	return ret;
 }
 
-/* Subtract b from a, storing the result in a. a *must* have a larger
- * value than b. */
-static void o2hb_tv_subtract(struct timeval *a,
-			     struct timeval *b)
-{
-	/* just return 0 when a is after b */
-	if (a->tv_sec < b->tv_sec ||
-	    (a->tv_sec == b->tv_sec && a->tv_usec < b->tv_usec)) {
-		a->tv_sec = 0;
-		a->tv_usec = 0;
-		return;
-	}
-
-	a->tv_sec -= b->tv_sec;
-	a->tv_usec -= b->tv_usec;
-	while ( a->tv_usec < 0 ) {
-		a->tv_sec--;
-		a->tv_usec += 1000000;
-	}
-}
-
-static unsigned int o2hb_elapsed_msecs(struct timeval *start,
-				       struct timeval *end)
-{
-	struct timeval res = *end;
-
-	o2hb_tv_subtract(&res, start);
-
-	return res.tv_sec * 1000 + res.tv_usec / 1000;
-}
-
 /*
  * we ride the region ref that the region dir holds.  before the region
  * dir is removed and drops it ref it will wait to tear down this
@@ -1102,7 +1071,7 @@ static int o2hb_thread(void *data)
 	int i, ret;
 	struct o2hb_region *reg = data;
 	struct o2hb_bio_wait_ctxt write_wc;
-	struct timeval before_hb, after_hb;
+	ktime_t before_hb, after_hb;
 	unsigned int elapsed_msec;
 
 	mlog(ML_HEARTBEAT|ML_KTHREAD, "hb thread running\n");
@@ -1119,18 +1088,18 @@ static int o2hb_thread(void *data)
 		 * hr_timeout_ms between disk writes. On busy systems
 		 * this should result in a heartbeat which is less
 		 * likely to time itself out. */
-		do_gettimeofday(&before_hb);
+		before_hb = ktime_get_real();
 
 		ret = o2hb_do_disk_heartbeat(reg);
 
-		do_gettimeofday(&after_hb);
-		elapsed_msec = o2hb_elapsed_msecs(&before_hb, &after_hb);
+		after_hb = ktime_get_real();
+
+		elapsed_msec = (unsigned int)
+				ktime_ms_delta(after_hb, before_hb);
 
 		mlog(ML_HEARTBEAT,
-		     "start = %lu.%lu, end = %lu.%lu, msec = %u, ret = %d\n",
-		     before_hb.tv_sec, (unsigned long) before_hb.tv_usec,
-		     after_hb.tv_sec, (unsigned long) after_hb.tv_usec,
-		     elapsed_msec, ret);
+		     "start = %lld, end = %lld, msec = %u, ret = %d\n",
+		     before_hb.tv64, after_hb.tv64, elapsed_msec, ret);
 
 		if (!kthread_should_stop() &&
 		    elapsed_msec < reg->hr_timeout_ms) {
_
