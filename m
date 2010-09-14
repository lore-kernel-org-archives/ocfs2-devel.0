From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 14 Sep 2010 15:50:55 -0700
Subject: [Ocfs2-devel] [PATCH 19/20] ocfs2/cluster: Add printks to show
	heartbeat up/down events
In-Reply-To: <1284504656-2434-1-git-send-email-sunil.mushran@oracle.com>
References: <1284504656-2434-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1284504656-2434-20-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch adds printks to show o2hb up and down events. This information
will be useful in debugging cluster issues.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index ad5fe57..ce6b166 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -601,7 +601,7 @@ static void o2hb_run_event_list(struct o2hb_node_event *queued_event)
 		list_del_init(&event->hn_item);
 		spin_unlock(&o2hb_live_lock);
 
-		mlog(ML_HEARTBEAT, "Node %s event for %d\n",
+		printk(KERN_NOTICE "o2hb: Node %s event for %d\n",
 		     event->hn_event_type == O2HB_NODE_UP_CB ? "UP" : "DOWN",
 		     event->hn_node_num);
 
@@ -797,6 +797,8 @@ fire_callbacks:
 
 		/* first on the list generates a callback */
 		if (list_empty(&o2hb_live_slots[slot->ds_node_num])) {
+			printk(KERN_NOTICE "o2hb: Add node %d to live nodes "
+			       "bitmap\n", slot->ds_node_num);
 			set_bit(slot->ds_node_num, o2hb_live_node_bitmap);
 
 			o2hb_queue_node_event(&event, O2HB_NODE_UP_CB, node,
@@ -845,6 +847,8 @@ fire_callbacks:
 		/* last off the live_slot generates a callback */
 		list_del_init(&slot->ds_live_item);
 		if (list_empty(&o2hb_live_slots[slot->ds_node_num])) {
+			printk(KERN_NOTICE "o2hb: Remove node %d from live "
+			       "nodes bitmap\n", slot->ds_node_num);
 			clear_bit(slot->ds_node_num, o2hb_live_node_bitmap);
 
 			if (node)
-- 
1.7.0.4
