From: jiangyiwen <jiangyiwen@huawei.com>
Date: Mon, 25 Jan 2016 10:54:11 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/cluster: replace the interrupt safe
 spinlocks with common ones
Message-ID: <56A58E53.6050003@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

There actually no hardware or software interrupts in the context
which using o2hb_live_lock, so we don't need to worry about race
conditions caused by irq/softirq with spinlock held. Turning off
irq is not good for system performance after all. Just replace
them with a non interrupt safe function.

Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/cluster/heartbeat.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 428683b..32d09b0 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -287,7 +287,6 @@ struct o2hb_bio_wait_ctxt {
 static void o2hb_write_timeout(struct work_struct *work)
 {
 	int failed, quorum;
-	unsigned long flags;
 	struct o2hb_region *reg =
 		container_of(work, struct o2hb_region,
 			     hr_write_timeout_work.work);
@@ -297,14 +296,14 @@ static void o2hb_write_timeout(struct work_struct *work)
 	     jiffies_to_msecs(jiffies - reg->hr_last_timeout_start));

 	if (o2hb_global_heartbeat_active()) {
-		spin_lock_irqsave(&o2hb_live_lock, flags);
+		spin_lock(&o2hb_live_lock);
 		if (test_bit(reg->hr_region_num, o2hb_quorum_region_bitmap))
 			set_bit(reg->hr_region_num, o2hb_failed_region_bitmap);
 		failed = bitmap_weight(o2hb_failed_region_bitmap,
 					O2NM_MAX_REGIONS);
 		quorum = bitmap_weight(o2hb_quorum_region_bitmap,
 					O2NM_MAX_REGIONS);
-		spin_unlock_irqrestore(&o2hb_live_lock, flags);
+		spin_unlock(&o2hb_live_lock);

 		mlog(ML_HEARTBEAT, "Number of regions %d, failed regions %d\n",
 		     quorum, failed);
@@ -2425,11 +2424,10 @@ EXPORT_SYMBOL_GPL(o2hb_check_node_heartbeating);
 int o2hb_check_node_heartbeating_no_sem(u8 node_num)
 {
 	unsigned long testing_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
-	unsigned long flags;

-	spin_lock_irqsave(&o2hb_live_lock, flags);
+	spin_lock(&o2hb_live_lock);
 	o2hb_fill_node_map_from_callback(testing_map, sizeof(testing_map));
-	spin_unlock_irqrestore(&o2hb_live_lock, flags);
+	spin_unlock(&o2hb_live_lock);
 	if (!test_bit(node_num, testing_map)) {
 		mlog(ML_HEARTBEAT,
 		     "node (%u) does not have heartbeating enabled.\n",
-- 
1.8.4.3
