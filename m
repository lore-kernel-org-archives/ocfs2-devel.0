From: Abhilash Jindal <klock.android@gmail.com>
Date: Sat, 8 Aug 2015 21:25:35 -0400
Subject: [Ocfs2-devel] ocfs2: use boot time instead of wall clock time
Message-ID: <CALiE4M20EvgEBL1vJwMPTkOzfz6vfkHmERVjYBRVVzWiDB4S4Q@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Wall time obtained from do_gettimeofday is susceptible to sudden jumps due
to user setting the time or due to NTP.

Boot time is constantly increasing time better suited for comparing two
timestamps.
---
 fs/ocfs2/cluster/heartbeat.c |   45
+++++++++++-------------------------------
 1 file changed, 11 insertions(+), 34 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 363f0dc..a1f6ba2 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -291,6 +291,7 @@ static int o2hb_pop_count(void *map, int count)
  return pop;
 }

+
 static void o2hb_write_timeout(struct work_struct *work)
 {
  int failed, quorum;
@@ -1083,35 +1084,11 @@ bail:
  return ret;
 }

-/* Subtract b from a, storing the result in a. a *must* have a larger
- * value than b. */
-static void o2hb_tv_subtract(struct timeval *a,
-     struct timeval *b)
-{
- /* just return 0 when a is after b */
- if (a->tv_sec < b->tv_sec ||
-    (a->tv_sec == b->tv_sec && a->tv_usec < b->tv_usec)) {
- a->tv_sec = 0;
- a->tv_usec = 0;
- return;
- }
-
- a->tv_sec -= b->tv_sec;
- a->tv_usec -= b->tv_usec;
- while ( a->tv_usec < 0 ) {
- a->tv_sec--;
- a->tv_usec += 1000000;
- }
-}
-
-static unsigned int o2hb_elapsed_msecs(struct timeval *start,
-       struct timeval *end)
-{
- struct timeval res = *end;
-
- o2hb_tv_subtract(&res, start);
-
- return res.tv_sec * 1000 + res.tv_usec / 1000;
+static unsigned int o2hb_elapsed_msecs(struct timespec *start,
+ struct timespec *end) {
+ struct timespec res;
+ res = timespec_sub(*end, *start);
+ return res.tv_sec* MSEC_PER_SEC + res.tv_nsec/NSEC_PER_MSEC;
 }

 /*
@@ -1124,7 +1101,7 @@ static int o2hb_thread(void *data)
  int i, ret;
  struct o2hb_region *reg = data;
  struct o2hb_bio_wait_ctxt write_wc;
- struct timeval before_hb, after_hb;
+ struct timespec before_hb, after_hb;
  unsigned int elapsed_msec;

  mlog(ML_HEARTBEAT|ML_KTHREAD, "hb thread running\n");
@@ -1141,17 +1118,17 @@ static int o2hb_thread(void *data)
  * hr_timeout_ms between disk writes. On busy systems
  * this should result in a heartbeat which is less
  * likely to time itself out. */
- do_gettimeofday(&before_hb);
+ getboottime(&before_hb);

  ret = o2hb_do_disk_heartbeat(reg);

- do_gettimeofday(&after_hb);
+ getboottime(&after_hb);
  elapsed_msec = o2hb_elapsed_msecs(&before_hb, &after_hb);

  mlog(ML_HEARTBEAT,
      "start = %lu.%lu, end = %lu.%lu, msec = %u\n",
-     before_hb.tv_sec, (unsigned long) before_hb.tv_usec,
-     after_hb.tv_sec, (unsigned long) after_hb.tv_usec,
+     before_hb.tv_sec, (unsigned long) before_hb.tv_nsec/NSEC_PER_USEC,
+     after_hb.tv_sec, (unsigned long) after_hb.tv_nsec/NSEC_PER_USEC,
      elapsed_msec);

  if (!kthread_should_stop() &&
-- 
1.7.9.5
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20150808/57385b10/attachment.html 
