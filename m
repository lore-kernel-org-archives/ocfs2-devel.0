From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Wed, 20 Jan 2016 11:13:39 +0800
Subject: [Ocfs2-devel] [PATCH 6/6] ocfs2: o2hb: fix hb hung time
In-Reply-To: <1453259619-5347-1-git-send-email-junxiao.bi@oracle.com>
References: <1453259619-5347-1-git-send-email-junxiao.bi@oracle.com>
Message-ID: <1453259619-5347-7-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

hr_last_timeout_start should be set as the last time where hb is still OK.
When hb write timeout, hung time will be (jiffies - hr_last_timeout_start).

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Ryan Ding <ryan.ding@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index cb931381f474..a3ce5a734b7b 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -357,7 +357,6 @@ static void o2hb_arm_timeout(struct o2hb_region *reg)
 		spin_unlock(&o2hb_live_lock);
 	}
 	cancel_delayed_work(&reg->hr_write_timeout_work);
-	reg->hr_last_timeout_start = jiffies;
 	schedule_delayed_work(&reg->hr_write_timeout_work,
 			      msecs_to_jiffies(O2HB_MAX_WRITE_TIMEOUT_MS));
 
@@ -1176,6 +1175,7 @@ static int o2hb_do_disk_heartbeat(struct o2hb_region *reg)
 	if (own_slot_ok) {
 		o2hb_set_quorum_device(reg);
 		o2hb_arm_timeout(reg);
+		reg->hr_last_timeout_start = jiffies;
 	}
 
 bail:
-- 
1.7.9.5
