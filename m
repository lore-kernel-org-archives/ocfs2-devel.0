From: Joseph Qi <joseph.qi@huawei.com>
Date: Thu, 17 Apr 2014 19:08:42 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: limit printk when journal is aborted
Message-ID: <534FB63A.9090402@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Once JBD2_ABORT is set, ocfs2_commit_cache will fail in
ocfs2_commit_thread. Then it will get into a loop with mass logs. This
will meaninglessly consume a larger number of resource and may lead to
system hung at last.
So limit printk in this case.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/journal.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 44fc3e5..cfefbd1 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -30,6 +30,7 @@
 #include <linux/kthread.h>
 #include <linux/time.h>
 #include <linux/random.h>
+#include <linux/delay.h>
 
 #include <cluster/masklog.h>
 
@@ -2191,8 +2192,15 @@ static int ocfs2_commit_thread(void *arg)
 					 || kthread_should_stop());
 
 		status = ocfs2_commit_cache(osb);
-		if (status < 0)
-			mlog_errno(status);
+		if (status < 0) {
+			static unsigned long abort_warn_time;
+
+			/* Warn about this once per minute */
+			if (printk_timed_ratelimit(&abort_warn_time, 60*HZ))
+				mlog(ML_ERROR, "status = %d, journal is "
+						"already aborted.\n", status);
+			msleep_interruptible(1000);
+		}
 
 		if (kthread_should_stop() && atomic_read(&journal->j_num_trans)){
 			mlog(ML_KTHREAD,
-- 
1.8.4.3
