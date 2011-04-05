From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue,  5 Apr 2011 15:21:08 -0700
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2/cluster: Increase the live threshold
In-Reply-To: <1302042069-25565-1-git-send-email-sunil.mushran@oracle.com>
References: <1302042069-25565-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1302042069-25565-3-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Double the live threshold for the first region in the global heartbeat
mode. The default, 2, is bare minimum. Increasing it will affect all
mounts in the local heartbeat mode. Instead we increase it only for
the global heartbeat mode and that too only the first region. This is
only to increase the margin of safety.

Addresses internal Oracle bug#10635585.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 2461eb3..ec50121 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1690,6 +1690,7 @@ static ssize_t o2hb_region_dev_write(struct o2hb_region *reg,
 	struct file *filp = NULL;
 	struct inode *inode = NULL;
 	ssize_t ret = -EINVAL;
+	int live_threshold;
 
 	if (reg->hr_bdev)
 		goto out;
@@ -1766,8 +1767,18 @@ static ssize_t o2hb_region_dev_write(struct o2hb_region *reg,
 	 * A node is considered live after it has beat LIVE_THRESHOLD
 	 * times.  We're not steady until we've given them a chance
 	 * _after_ our first read.
+	 * The default threshold is bare minimum so as to limit the delay
+	 * during mounts. For global heartbeat, the threshold doubled for the
+	 * first region.
 	 */
-	atomic_set(&reg->hr_steady_iterations, O2HB_LIVE_THRESHOLD + 1);
+	live_threshold = O2HB_LIVE_THRESHOLD;
+	if (o2hb_global_heartbeat_active()) {
+		spin_lock(&o2hb_live_lock);
+		if (o2hb_pop_count(&o2hb_region_bitmap, O2NM_MAX_REGIONS) == 1)
+			live_threshold <<= 1;
+		spin_unlock(&o2hb_live_lock);
+	}
+	atomic_set(&reg->hr_steady_iterations, live_threshold + 1);
 
 	hb_task = kthread_run(o2hb_thread, reg, "o2hb-%s",
 			      reg->hr_item.ci_name);
-- 
1.7.1
