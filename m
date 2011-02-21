From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 21 Feb 2011 14:25:24 -0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2/cluster: Heartbeat mismatch message
	improved
Message-ID: <1298327125-4045-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

If o2hb finds unexpected values in the heartbeat slot, it prints a message
"ERROR: Device "dm-6": another node is heartbeating in our slot!"

This patch adds more information allowing us to see the actual mismatch.
The new message reads "ERROR: Heartbeat mismatch on "dm-6": expected(92:0x234543,
0x76567) ondisk(92:0x234543, 0x76565)"

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index b108e86..d633df0 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -543,25 +543,27 @@ static int o2hb_verify_crc(struct o2hb_region *reg,
 
 /* We want to make sure that nobody is heartbeating on top of us --
  * this will help detect an invalid configuration. */
-static int o2hb_check_last_timestamp(struct o2hb_region *reg)
+static void o2hb_check_last_timestamp(struct o2hb_region *reg)
 {
-	int node_num, ret;
 	struct o2hb_disk_slot *slot;
 	struct o2hb_disk_heartbeat_block *hb_block;
 
-	node_num = o2nm_this_node();
-
-	ret = 1;
-	slot = &reg->hr_slots[node_num];
+	slot = &reg->hr_slots[o2nm_this_node()];
 	/* Don't check on our 1st timestamp */
-	if (slot->ds_last_time) {
-		hb_block = slot->ds_raw_block;
+	if (!slot->ds_last_time)
+		return;
 
-		if (le64_to_cpu(hb_block->hb_seq) != slot->ds_last_time)
-			ret = 0;
-	}
+	hb_block = slot->ds_raw_block;
+	if (le64_to_cpu(hb_block->hb_seq) == slot->ds_last_time)
+		return;
 
-	return ret;
+	mlog(ML_ERROR, "Heartbeat mismatch on \"%s\": "
+	     "expected(%u:0x%llx, 0x%llx), ondisk(%u:0x%llx, 0x%llx)\n",
+	     reg->hr_dev_name, slot->ds_node_num,
+	     (unsigned long long)slot->ds_last_generation,
+	     (unsigned long long)slot->ds_last_time, hb_block->hb_node,
+	     (unsigned long long)le64_to_cpu(hb_block->hb_generation),
+	     (unsigned long long)le64_to_cpu(hb_block->hb_seq));
 }
 
 static inline void o2hb_prepare_block(struct o2hb_region *reg,
@@ -987,9 +989,7 @@ static int o2hb_do_disk_heartbeat(struct o2hb_region *reg)
 	/* With an up to date view of the slots, we can check that no
 	 * other node has been improperly configured to heartbeat in
 	 * our slot. */
-	if (!o2hb_check_last_timestamp(reg))
-		mlog(ML_ERROR, "Device \"%s\": another node is heartbeating "
-		     "in our slot!\n", reg->hr_dev_name);
+	o2hb_check_last_timestamp(reg);
 
 	/* fill in the proper info for our next heartbeat */
 	o2hb_prepare_block(reg, reg->hr_generation);
@@ -1003,8 +1003,8 @@ static int o2hb_do_disk_heartbeat(struct o2hb_region *reg)
 	}
 
 	i = -1;
-	while((i = find_next_bit(configured_nodes, O2NM_MAX_NODES, i + 1)) < O2NM_MAX_NODES) {
-
+	while((i = find_next_bit(configured_nodes,
+				 O2NM_MAX_NODES, i + 1)) < O2NM_MAX_NODES) {
 		change |= o2hb_check_slot(reg, &reg->hr_slots[i]);
 	}
 
-- 
1.7.1
