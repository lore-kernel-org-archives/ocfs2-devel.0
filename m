From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu,  7 Oct 2010 17:15:34 -0700
Subject: [Ocfs2-devel] [PATCH 20/22] ocfs2/cluster: Add mlogs for heartbeat
	up/down events
In-Reply-To: <1286496936-17072-1-git-send-email-sunil.mushran@oracle.com>
References: <1286496936-17072-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1286496936-17072-21-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch adds mlogs for o2hb up and down events.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index f28de4b..e8676ac 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -797,6 +797,8 @@ fire_callbacks:
 
 		/* first on the list generates a callback */
 		if (list_empty(&o2hb_live_slots[slot->ds_node_num])) {
+			mlog(ML_HEARTBEAT, "o2hb: Add node %d to live nodes "
+			     "bitmap\n", slot->ds_node_num);
 			set_bit(slot->ds_node_num, o2hb_live_node_bitmap);
 
 			o2hb_queue_node_event(&event, O2HB_NODE_UP_CB, node,
@@ -845,6 +847,8 @@ fire_callbacks:
 		/* last off the live_slot generates a callback */
 		list_del_init(&slot->ds_live_item);
 		if (list_empty(&o2hb_live_slots[slot->ds_node_num])) {
+			mlog(ML_HEARTBEAT, "o2hb: Remove node %d from live "
+			     "nodes bitmap\n", slot->ds_node_num);
 			clear_bit(slot->ds_node_num, o2hb_live_node_bitmap);
 
 			/* node can be null */
-- 
1.7.0.4
