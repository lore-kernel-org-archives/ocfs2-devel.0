From: Jan Kara <jack@suse.cz>
Date: Tue, 21 Oct 2014 16:50:50 +0200
Subject: [Ocfs2-devel] [PATCH] ocfs2: Report error from
	o2hb_do_disk_heartbeat() to user
Message-ID: <1413903050-18490-1-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Report return value of o2hb_do_disk_heartbeat() as a part of ML_HEARTBEAT
message so that we know whether a heartbeat actually happened or not.
This also makes assigned but otherwise unused 'ret' variable used.

Coverity-id: 1227053
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/cluster/heartbeat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index eb9d48746ab4..16eff45727ee 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1127,10 +1127,10 @@ static int o2hb_thread(void *data)
 		elapsed_msec = o2hb_elapsed_msecs(&before_hb, &after_hb);
 
 		mlog(ML_HEARTBEAT,
-		     "start = %lu.%lu, end = %lu.%lu, msec = %u\n",
+		     "start = %lu.%lu, end = %lu.%lu, msec = %u, ret = %d\n",
 		     before_hb.tv_sec, (unsigned long) before_hb.tv_usec,
 		     after_hb.tv_sec, (unsigned long) after_hb.tv_usec,
-		     elapsed_msec);
+		     elapsed_msec, ret);
 
 		if (!kthread_should_stop() &&
 		    elapsed_msec < reg->hr_timeout_ms) {
-- 
1.8.1.4
