From: Ryan Ding <ryan.ding@oracle.com>
Date: Mon, 21 Dec 2015 13:39:46 +0800
Subject: [Ocfs2-devel] [PATCH V2] ocfs2: call ocfs2_abort when journal abort
Message-ID: <1450676386-27715-1-git-send-email-ryan.ding@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

orabug: 22293201

journal can not recover from abort state, so we should take following action to
prevent file system from corruption:

1. change to readonly filesystem when local mount. We can not afford further
   write, so change to RO state is reasonable.

2. panic when cluster mount. Because we can not release lock resource in this
   state, other node will hung when it require a lock owned by this node. So
   panic and remaster is a reasonable choise.

ocfs2_abort() will do all the above work.

Signed-off-by: Ryan Ding <ryan.ding@oracle.com>
---
 fs/ocfs2/journal.c |   27 +++++++++++++++------------
 1 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index ff53192..afa750c 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -30,7 +30,6 @@
 #include <linux/kthread.h>
 #include <linux/time.h>
 #include <linux/random.h>
-#include <linux/delay.h>
 
 #include <cluster/masklog.h>
 
@@ -2241,7 +2240,7 @@ static int __ocfs2_wait_on_mount(struct ocfs2_super *osb, int quota)
 
 static int ocfs2_commit_thread(void *arg)
 {
-	int status;
+	int status = 0;
 	struct ocfs2_super *osb = arg;
 	struct ocfs2_journal *journal = osb->journal;
 
@@ -2255,21 +2254,25 @@ static int ocfs2_commit_thread(void *arg)
 		wait_event_interruptible(osb->checkpoint_event,
 					 atomic_read(&journal->j_num_trans)
 					 || kthread_should_stop());
+		if (status < 0) {
+			/* As we can not terminate by ourself, just enter an
+			 * empty loop to wait for stop.
+			 */
+			continue;
+		}
 
 		status = ocfs2_commit_cache(osb);
 		if (status < 0) {
-			static unsigned long abort_warn_time;
-
-			/* Warn about this once per minute */
-			if (printk_timed_ratelimit(&abort_warn_time, 60*HZ))
-				mlog(ML_ERROR, "status = %d, journal is "
-						"already aborted.\n", status);
 			/*
-			 * After ocfs2_commit_cache() fails, j_num_trans has a
-			 * non-zero value.  Sleep here to avoid a busy-wait
-			 * loop.
+			 * journal can not recover from abort state, there is
+			 * no need to keep commit cache. So we should either
+			 * change to readonly(local mount) or just panic
+			 * (cluster mount).
+			 * We should also clear j_num_trans to prevent further
+			 * commit.
 			 */
-			msleep_interruptible(1000);
+			atomic_set(&journal->j_num_trans, 0);
+			ocfs2_abort(osb->sb, "Detected aborted journal");
 		}
 
 		if (kthread_should_stop() && atomic_read(&journal->j_num_trans)){
-- 
1.7.1
