From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu,  7 Oct 2010 17:15:25 -0700
Subject: [Ocfs2-devel] [PATCH 11/22] ocfs2/cluster: Check slots for
	unconfigured live nodes
In-Reply-To: <1286496936-17072-1-git-send-email-sunil.mushran@oracle.com>
References: <1286496936-17072-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1286496936-17072-12-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

o2hb currently checks slots for configured nodes only. This patch makes
it check the slots for the live nodes too to take care of a race in which
a node is removed from the configuration but not from the live map.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c |   38 +++++++++++++++++++++++++++++++-------
 fs/ocfs2/cluster/tcp.c       |    5 +++++
 2 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 12bb12b..a8f1064 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -541,6 +541,8 @@ static void o2hb_queue_node_event(struct o2hb_node_event *event,
 {
 	assert_spin_locked(&o2hb_live_lock);
 
+	BUG_ON((!node) && (type != O2HB_NODE_DOWN_CB));
+
 	event->hn_event_type = type;
 	event->hn_node = node;
 	event->hn_node_num = node_num;
@@ -593,14 +595,22 @@ static int o2hb_check_slot(struct o2hb_region *reg,
 	u64 cputime;
 	unsigned int dead_ms = o2hb_dead_threshold * O2HB_REGION_TIMEOUT_MS;
 	unsigned int slot_dead_ms;
+	int tmp;
 
 	memcpy(hb_block, slot->ds_raw_block, reg->hr_block_bytes);
 
-	/* Is this correct? Do we assume that the node doesn't exist
-	 * if we're not configured for him? */
+	/*
+	 * If a node is no longer configured but is still in the livemap, we
+	 * may need to clear that bit from the livemap.
+	 */
 	node = o2nm_get_node_by_num(slot->ds_node_num);
-	if (!node)
-		return 0;
+	if (!node) {
+		spin_lock(&o2hb_live_lock);
+		tmp = test_bit(slot->ds_node_num, o2hb_live_node_bitmap);
+		spin_unlock(&o2hb_live_lock);
+		if (!tmp)
+			return 0;
+	}
 
 	if (!o2hb_verify_crc(reg, hb_block)) {
 		/* all paths from here will drop o2hb_live_lock for
@@ -717,8 +727,9 @@ fire_callbacks:
 		if (list_empty(&o2hb_live_slots[slot->ds_node_num])) {
 			clear_bit(slot->ds_node_num, o2hb_live_node_bitmap);
 
-			o2hb_queue_node_event(&event, O2HB_NODE_DOWN_CB, node,
-					      slot->ds_node_num);
+			/* node can be null */
+			o2hb_queue_node_event(&event, O2HB_NODE_DOWN_CB,
+					      node, slot->ds_node_num);
 
 			changed = 1;
 		}
@@ -738,7 +749,8 @@ out:
 
 	o2hb_run_event_list(&event);
 
-	o2nm_node_put(node);
+	if (node)
+		o2nm_node_put(node);
 	return changed;
 }
 
@@ -765,6 +777,7 @@ static int o2hb_do_disk_heartbeat(struct o2hb_region *reg)
 {
 	int i, ret, highest_node, change = 0;
 	unsigned long configured_nodes[BITS_TO_LONGS(O2NM_MAX_NODES)];
+	unsigned long live_node_bitmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
 	struct o2hb_bio_wait_ctxt write_wc;
 
 	ret = o2nm_configured_node_map(configured_nodes,
@@ -774,6 +787,17 @@ static int o2hb_do_disk_heartbeat(struct o2hb_region *reg)
 		return ret;
 	}
 
+	/*
+	 * If a node is not configured but is in the livemap, we still need
+	 * to read the slot so as to be able to remove it from the livemap.
+	 */
+	o2hb_fill_node_map(live_node_bitmap, sizeof(live_node_bitmap));
+	i = -1;
+	while ((i = find_next_bit(live_node_bitmap,
+				  O2NM_MAX_NODES, i + 1)) < O2NM_MAX_NODES) {
+		set_bit(i, configured_nodes);
+	}
+
 	highest_node = o2hb_highest_node(configured_nodes, O2NM_MAX_NODES);
 	if (highest_node >= O2NM_MAX_NODES) {
 		mlog(ML_NOTICE, "ocfs2_heartbeat: no configured nodes found!\n");
diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index cbe2f05..9aa426e 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -1696,6 +1696,9 @@ static void o2net_hb_node_down_cb(struct o2nm_node *node, int node_num,
 {
 	o2quo_hb_down(node_num);
 
+	if (!node)
+		return;
+
 	if (node_num != o2nm_this_node())
 		o2net_disconnect_node(node);
 
@@ -1709,6 +1712,8 @@ static void o2net_hb_node_up_cb(struct o2nm_node *node, int node_num,
 
 	o2quo_hb_up(node_num);
 
+	BUG_ON(!node);
+
 	/* ensure an immediate connect attempt */
 	nn->nn_last_connect_attempt = jiffies -
 		(msecs_to_jiffies(o2net_reconnect_delay()) + 1);
-- 
1.7.0.4
