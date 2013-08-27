From: Joseph Qi <joseph.qi@huawei.com>
Date: Tue, 27 Aug 2013 14:17:17 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix a tiny race case when fire
	callbacks
Message-ID: <521C446D.8000500@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In o2hb_shutdown_slot() and o2hb_check_slot(), since event is defined
as local, it is only valid during the call stack. So the following tiny
race case may happen in a multi-volumes mounted environment:

o2hb-vol1                         o2hb-vol2
1) o2hb_shutdown_slot
allocate local event1
2) queue_node_event
add event1 to global o2hb_node_events
                                  3) o2hb_shutdown_slot
                                  allocate local event2
                                  4) queue_node_event
                                  add event2 to global o2hb_node_events
                                  5) o2hb_run_event_list
                                  delete event1 from o2hb_node_events
6) o2hb_run_event_list
event1 empty, return
7) o2hb_shutdown_slot
event1 lifecycle ends
                                  8) o2hb_fire_callbacks
                                  event1 is already *invalid*

This patch lets it wait o2hb_callback_sem when another thread is firing
callbacks. And for performance consideration, we only call
o2hb_run_event_list when there is an event queued.

Signed-off-by: Joyce <xuejiufei@huawei.com>
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/cluster/heartbeat.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 42252bf..af5cd3b 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -641,16 +641,9 @@ static void o2hb_fire_callbacks(struct o2hb_callback *hbcall,
 /* Will run the list in order until we process the passed event */
 static void o2hb_run_event_list(struct o2hb_node_event *queued_event)
 {
-	int empty;
 	struct o2hb_callback *hbcall;
 	struct o2hb_node_event *event;
 
-	spin_lock(&o2hb_live_lock);
-	empty = list_empty(&queued_event->hn_item);
-	spin_unlock(&o2hb_live_lock);
-	if (empty)
-		return;
-
 	/* Holding callback sem assures we don't alter the callback
 	 * lists when doing this, and serializes ourselves with other
 	 * processes wanting callbacks. */
@@ -709,6 +702,7 @@ static void o2hb_shutdown_slot(struct o2hb_disk_slot *slot)
 	struct o2hb_node_event event =
 		{ .hn_item = LIST_HEAD_INIT(event.hn_item), };
 	struct o2nm_node *node;
+	int queued = 0;
 
 	node = o2nm_get_node_by_num(slot->ds_node_num);
 	if (!node)
@@ -726,11 +720,13 @@ static void o2hb_shutdown_slot(struct o2hb_disk_slot *slot)
 
 			o2hb_queue_node_event(&event, O2HB_NODE_DOWN_CB, node,
 					      slot->ds_node_num);
+			queued = 1;
 		}
 	}
 	spin_unlock(&o2hb_live_lock);
 
-	o2hb_run_event_list(&event);
+	if (queued)
+		o2hb_run_event_list(&event);
 
 	o2nm_node_put(node);
 }
@@ -790,6 +786,7 @@ static int o2hb_check_slot(struct o2hb_region *reg,
 	unsigned int dead_ms = o2hb_dead_threshold * O2HB_REGION_TIMEOUT_MS;
 	unsigned int slot_dead_ms;
 	int tmp;
+	int queued = 0;
 
 	memcpy(hb_block, slot->ds_raw_block, reg->hr_block_bytes);
 
@@ -883,6 +880,7 @@ fire_callbacks:
 					      slot->ds_node_num);
 
 			changed = 1;
+			queued = 1;
 		}
 
 		list_add_tail(&slot->ds_live_item,
@@ -934,6 +932,7 @@ fire_callbacks:
 					      node, slot->ds_node_num);
 
 			changed = 1;
+			queued = 1;
 		}
 
 		/* We don't clear this because the node is still
@@ -949,7 +948,8 @@ fire_callbacks:
 out:
 	spin_unlock(&o2hb_live_lock);
 
-	o2hb_run_event_list(&event);
+	if (queued)
+		o2hb_run_event_list(&event);
 
 	if (node)
 		o2nm_node_put(node);
-- 1.7.9.7
