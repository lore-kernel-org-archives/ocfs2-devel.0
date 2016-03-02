From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Wed,  2 Mar 2016 15:56:12 +0800
Subject: [Ocfs2-devel] [PATCH V2 6/6] ocfs2: o2hb: fix hb hung time
In-Reply-To: <1456905372-22313-1-git-send-email-junxiao.bi@oracle.com>
References: <1456905372-22313-1-git-send-email-junxiao.bi@oracle.com>
Message-ID: <1456905372-22313-7-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

hr_last_timeout_start should be set as the last time where hb is still OK.
When hb write timeout, hung time will be (jiffies -
hr_last_timeout_start).

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Ryan Ding <ryan.ding@oracle.com>
Cc: Gang He <ghe@suse.com>
Cc: rwxybh <rwxybh@126.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 fs/ocfs2/cluster/heartbeat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index c040fc3dd605..8ec85cac894e 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -357,7 +357,6 @@ static void o2hb_arm_timeout(struct o2hb_region *reg)
 		spin_unlock(&o2hb_live_lock);
 	}
 	cancel_delayed_work(&reg->hr_write_timeout_work);
-	reg->hr_last_timeout_start = jiffies;
 	schedule_delayed_work(&reg->hr_write_timeout_work,
 			      msecs_to_jiffies(O2HB_MAX_WRITE_TIMEOUT_MS));
 
@@ -1175,6 +1174,7 @@ static int o2hb_do_disk_heartbeat(struct o2hb_region *reg)
 	if (own_slot_ok) {
 		o2hb_set_quorum_device(reg);
 		o2hb_arm_timeout(reg);
+		reg->hr_last_timeout_start = jiffies;
 	}
 
 bail:
-- 
1.7.9.5
