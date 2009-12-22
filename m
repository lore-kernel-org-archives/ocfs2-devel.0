From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 22 Dec 2009 10:32:15 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/trivial: Use proper mask for 2 places
	in hearbeat.c
Message-ID: <1261449135-13065-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I just noticed today that there are 2 places of "mlog(0,...)"
in  fs/ocfs2/cluster/heartbeat.c, but actually have no default
mask prefix in that file.
So change them to mlog(ML_HEARTBEAT,...).

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index c452d11..eda5b8b 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -176,7 +176,8 @@ static void o2hb_write_timeout(struct work_struct *work)
 
 static void o2hb_arm_write_timeout(struct o2hb_region *reg)
 {
-	mlog(0, "Queue write timeout for %u ms\n", O2HB_MAX_WRITE_TIMEOUT_MS);
+	mlog(ML_HEARTBEAT, "Queue write timeout for %u ms\n",
+	     O2HB_MAX_WRITE_TIMEOUT_MS);
 
 	cancel_delayed_work(&reg->hr_write_timeout_work);
 	reg->hr_last_timeout_start = jiffies;
@@ -874,7 +875,8 @@ static int o2hb_thread(void *data)
 		do_gettimeofday(&after_hb);
 		elapsed_msec = o2hb_elapsed_msecs(&before_hb, &after_hb);
 
-		mlog(0, "start = %lu.%lu, end = %lu.%lu, msec = %u\n",
+		mlog(ML_HEARTBEAT,
+		     "start = %lu.%lu, end = %lu.%lu, msec = %u\n",
 		     before_hb.tv_sec, (unsigned long) before_hb.tv_usec,
 		     after_hb.tv_sec, (unsigned long) after_hb.tv_usec,
 		     elapsed_msec);
-- 
1.5.5
