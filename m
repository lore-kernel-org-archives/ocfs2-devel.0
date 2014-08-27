From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 27 Aug 2014 18:57:11 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix deadlock between o2hb thread and
	o2net_wq
Message-ID: <53FDB987.2010001@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following case may lead to o2net_wq and o2hb thread deadlock on
o2hb_callback_sem.
Currently there are 2 nodes say N1, N2 in the cluster. And N2 down, at
the same time, N3 tries to join the cluster. So N1 will handle node
down (N2) and join (N3) simultaneously.
    o2hb                               o2net_wq
    ->o2hb_do_disk_heartbeat
    ->o2hb_check_slot
    ->o2hb_run_event_list
    ->o2hb_fire_callbacks
    ->down_write(&o2hb_callback_sem)
    ->o2net_hb_node_down_cb
    ->flush_workqueue(o2net_wq)
                                       ->o2net_process_message
                                       ->dlm_query_join_handler
                                       ->o2hb_check_node_heartbeating
                                       ->o2hb_fill_node_map
                                       ->down_read(&o2hb_callback_sem)

No need to take o2hb_callback_sem in dlm_query_join_handler,
o2hb_live_lock is enough to protect live node map.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/cluster/heartbeat.c | 19 +++++++++++++++++++
 fs/ocfs2/cluster/heartbeat.h |  1 +
 fs/ocfs2/dlm/dlmdomain.c     |  2 +-
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 7303929..d133854 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -2572,6 +2572,25 @@ int o2hb_check_node_heartbeating(u8 node_num)
 }
 EXPORT_SYMBOL_GPL(o2hb_check_node_heartbeating);

+int o2hb_check_node_heartbeating_no_sem(u8 node_num)
+{
+	unsigned long testing_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
+	unsigned long flags;
+
+	spin_lock_irqsave(&o2hb_live_lock, flags);
+	o2hb_fill_node_map_from_callback(testing_map, sizeof(testing_map));
+	spin_unlock_irqrestore(&o2hb_live_lock, flags);
+	if (!test_bit(node_num, testing_map)) {
+		mlog(ML_HEARTBEAT,
+		     "node (%u) does not have heartbeating enabled.\n",
+		     node_num);
+		return 0;
+	}
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(o2hb_check_node_heartbeating_no_sem);
+
 int o2hb_check_node_heartbeating_from_callback(u8 node_num)
 {
 	unsigned long testing_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
diff --git a/fs/ocfs2/cluster/heartbeat.h b/fs/ocfs2/cluster/heartbeat.h
index 00ad8e8..3ef5137 100644
--- a/fs/ocfs2/cluster/heartbeat.h
+++ b/fs/ocfs2/cluster/heartbeat.h
@@ -80,6 +80,7 @@ void o2hb_fill_node_map(unsigned long *map,
 void o2hb_exit(void);
 int o2hb_init(void);
 int o2hb_check_node_heartbeating(u8 node_num);
+int o2hb_check_node_heartbeating_no_sem(u8 node_num);
 int o2hb_check_node_heartbeating_from_callback(u8 node_num);
 int o2hb_check_local_node_heartbeating(void);
 void o2hb_stop_all_regions(void);
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 39efc50..bf86ed4 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -839,7 +839,7 @@ static int dlm_query_join_handler(struct o2net_msg *msg, u32 len, void *data,
 	 * to back off and try again.  This gives heartbeat a chance
 	 * to catch up.
 	 */
-	if (!o2hb_check_node_heartbeating(query->node_idx)) {
+	if (!o2hb_check_node_heartbeating_no_sem(query->node_idx)) {
 		mlog(0, "node %u is not in our live map yet\n",
 		     query->node_idx);

-- 
1.8.4.3
