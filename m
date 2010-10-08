From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu,  7 Oct 2010 17:15:27 -0700
Subject: [Ocfs2-devel] [PATCH 13/22] ocfs2/cluster: Maintain live node
	bitmap per heartbeat region
In-Reply-To: <1286496936-17072-1-git-send-email-sunil.mushran@oracle.com>
References: <1286496936-17072-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1286496936-17072-14-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Currently we track a global livenode bitmap that keeps track of all nodes
that are heartbeating in all regions.

This patch adds the ability to track the livenode bitmap on a per region basis.
We will use this facility in a later patch to allow us to withstand the loss of
a minority number of regions.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 16e4976..188f502 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -174,6 +174,9 @@ struct o2hb_region {
 	struct block_device	*hr_bdev;
 	struct o2hb_disk_slot	*hr_slots;
 
+	/* live node map of this region */
+	unsigned long		hr_live_node_bitmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
+
 	/* let the person setting up hb wait for it to return until it
 	 * has reached a 'steady' state.  This will be fixed when we have
 	 * a more complete api that doesn't lead to this sort of fragility. */
@@ -688,6 +691,8 @@ fire_callbacks:
 		mlog(ML_HEARTBEAT, "Node %d (id 0x%llx) joined my region\n",
 		     slot->ds_node_num, (long long)slot->ds_last_generation);
 
+		set_bit(slot->ds_node_num, reg->hr_live_node_bitmap);
+
 		/* first on the list generates a callback */
 		if (list_empty(&o2hb_live_slots[slot->ds_node_num])) {
 			set_bit(slot->ds_node_num, o2hb_live_node_bitmap);
@@ -733,6 +738,8 @@ fire_callbacks:
 		mlog(ML_HEARTBEAT, "Node %d left my region\n",
 		     slot->ds_node_num);
 
+		clear_bit(slot->ds_node_num, reg->hr_live_node_bitmap);
+
 		/* last off the live_slot generates a callback */
 		list_del_init(&slot->ds_live_item);
 		if (list_empty(&o2hb_live_slots[slot->ds_node_num])) {
-- 
1.7.0.4
