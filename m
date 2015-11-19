From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Thu, 19 Nov 2015 16:08:10 +0800
Subject: [Ocfs2-devel] [PATCH] o2hb: increase unsteady iterations
In-Reply-To: <1447920490-22359-1-git-send-email-junxiao.bi@oracle.com>
References: <1447920490-22359-1-git-send-email-junxiao.bi@oracle.com>
Message-ID: <1447920490-22359-2-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When run multiple xattr test of ocfs2-test on a three-nodes cluster,
mount failed sometimes with the following message.

o2hb: Unable to stabilize heartbeart on region D18B775E758D4D80837E8CF3D086AD4A (xvdb)

Stabilize heartbeat depends on the timing order to mount ocfs2 from cluster nodes
and how fast the tcp connections are established. So increase unsteady interations
to leave more time for it.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 709fbbd..a3cc6d2 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1780,8 +1780,8 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 	}
 	++live_threshold;
 	atomic_set(&reg->hr_steady_iterations, live_threshold);
-	/* unsteady_iterations is double the steady_iterations */
-	atomic_set(&reg->hr_unsteady_iterations, (live_threshold << 1));
+	/* unsteady_iterations is triple the steady_iterations */
+	atomic_set(&reg->hr_unsteady_iterations, (live_threshold * 3));
 
 	hb_task = kthread_run(o2hb_thread, reg, "o2hb-%s",
 			      reg->hr_item.ci_name);
-- 
1.7.9.5
