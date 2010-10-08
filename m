From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu,  7 Oct 2010 17:15:30 -0700
Subject: [Ocfs2-devel] [PATCH 16/22] ocfs2/cluster: Maintain bitmap of
	quorum regions
In-Reply-To: <1286496936-17072-1-git-send-email-sunil.mushran@oracle.com>
References: <1286496936-17072-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1286496936-17072-17-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

o2hb allows online adding of regions. However, a newly added region is not
used in quorum calculations unless it has been added on all nodes. This patch
tracks a bitmap of such quorum regions.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 2a7cd17..62a8af2 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -66,9 +66,12 @@ static DECLARE_WAIT_QUEUE_HEAD(o2hb_steady_queue);
  * In global heartbeat, we maintain a series of region bitmaps.
  * 	- o2hb_region_bitmap allows us to limit the region number to max region.
  * 	- o2hb_live_region_bitmap tracks live regions (seen steady iterations).
+ * 	- o2hb_quorum_region_bitmap tracks live regions that have seen all nodes
+ * 		heartbeat on it.
  */
 static unsigned long o2hb_region_bitmap[BITS_TO_LONGS(O2NM_MAX_REGIONS)];
 static unsigned long o2hb_live_region_bitmap[BITS_TO_LONGS(O2NM_MAX_REGIONS)];
+static unsigned long o2hb_quorum_region_bitmap[BITS_TO_LONGS(O2NM_MAX_REGIONS)];
 
 #define O2HB_DB_TYPE_LIVENODES		0
 struct o2hb_debug_buf {
@@ -607,6 +610,35 @@ static void o2hb_shutdown_slot(struct o2hb_disk_slot *slot)
 	o2nm_node_put(node);
 }
 
+static void o2hb_set_quorum_device(struct o2hb_region *reg,
+				   struct o2hb_disk_slot *slot)
+{
+	assert_spin_locked(&o2hb_live_lock);
+
+	if (!o2hb_global_heartbeat_active())
+		return;
+
+	if (test_bit(reg->hr_region_num, o2hb_quorum_region_bitmap))
+		return;
+
+	/*
+	 * A region can be added to the quorum only when it sees all
+	 * live nodes heartbeat on it. In other words, the region has been
+	 * added to all nodes.
+	 */
+	if (memcmp(reg->hr_live_node_bitmap, o2hb_live_node_bitmap,
+		   sizeof(o2hb_live_node_bitmap)))
+		return;
+
+	if (slot->ds_changed_samples < O2HB_LIVE_THRESHOLD)
+		return;
+
+	printk(KERN_NOTICE "o2hb: Region %s is now a quorum device\n",
+	       config_item_name(&reg->hr_item));
+
+	set_bit(reg->hr_region_num, o2hb_quorum_region_bitmap);
+}
+
 static int o2hb_check_slot(struct o2hb_region *reg,
 			   struct o2hb_disk_slot *slot)
 {
@@ -772,6 +804,8 @@ fire_callbacks:
 		slot->ds_equal_samples = 0;
 	}
 out:
+	o2hb_set_quorum_device(reg, slot);
+
 	spin_unlock(&o2hb_live_lock);
 
 	o2hb_run_event_list(&event);
@@ -1138,6 +1172,7 @@ int o2hb_init(void)
 	memset(o2hb_live_node_bitmap, 0, sizeof(o2hb_live_node_bitmap));
 	memset(o2hb_region_bitmap, 0, sizeof(o2hb_region_bitmap));
 	memset(o2hb_live_region_bitmap, 0, sizeof(o2hb_live_region_bitmap));
+	memset(o2hb_quorum_region_bitmap, 0, sizeof(o2hb_quorum_region_bitmap));
 
 	return o2hb_debug_init();
 }
-- 
1.7.0.4
