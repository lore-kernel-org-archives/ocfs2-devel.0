From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue,  5 Apr 2011 15:21:09 -0700
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2/cluster: Heartbeat mismatch message
	improved
In-Reply-To: <1302042069-25565-1-git-send-email-sunil.mushran@oracle.com>
References: <1302042069-25565-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1302042069-25565-4-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

If o2hb finds unexpected values in the heartbeat slot, it prints a message
"ERROR: Device "dm-6": another node is heartbeating in our slot!"

This message could be misleading. This patch adds two more messages to
help users better diagnose the problem.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c |   48 +++++++++++++++++++++++++++--------------
 1 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index ec50121..1dd2716 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -539,25 +539,41 @@ static int o2hb_verify_crc(struct o2hb_region *reg,
 
 /* We want to make sure that nobody is heartbeating on top of us --
  * this will help detect an invalid configuration. */
-static int o2hb_check_last_timestamp(struct o2hb_region *reg)
+static void o2hb_check_last_timestamp(struct o2hb_region *reg)
 {
-	int node_num, ret;
 	struct o2hb_disk_slot *slot;
 	struct o2hb_disk_heartbeat_block *hb_block;
+	char *errstr;
 
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
+	if (le64_to_cpu(hb_block->hb_seq) == slot->ds_last_time &&
+	    le64_to_cpu(hb_block->hb_generation) == slot->ds_last_generation &&
+	    hb_block->hb_node == slot->ds_node_num)
+		return;
 
-	return ret;
+#define ERRSTR1		"Another node is heartbeating on device"
+#define ERRSTR2		"Heartbeat generation mismatch on device"
+#define ERRSTR3		"Heartbeat sequence mismatch on device"
+
+	if (hb_block->hb_node != slot->ds_node_num)
+		errstr = ERRSTR1;
+	else if (le64_to_cpu(hb_block->hb_generation) !=
+		 slot->ds_last_generation)
+		errstr = ERRSTR2;
+	else
+		errstr = ERRSTR3;
+
+	mlog(ML_ERROR, "%s (%s): expected(%u:0x%llx, 0x%llx), "
+	     "ondisk(%u:0x%llx, 0x%llx)\n", errstr, reg->hr_dev_name,
+	     slot->ds_node_num, (unsigned long long)slot->ds_last_generation,
+	     (unsigned long long)slot->ds_last_time, hb_block->hb_node,
+	     (unsigned long long)le64_to_cpu(hb_block->hb_generation),
+	     (unsigned long long)le64_to_cpu(hb_block->hb_seq));
 }
 
 static inline void o2hb_prepare_block(struct o2hb_region *reg,
@@ -983,9 +999,7 @@ static int o2hb_do_disk_heartbeat(struct o2hb_region *reg)
 	/* With an up to date view of the slots, we can check that no
 	 * other node has been improperly configured to heartbeat in
 	 * our slot. */
-	if (!o2hb_check_last_timestamp(reg))
-		mlog(ML_ERROR, "Device \"%s\": another node is heartbeating "
-		     "in our slot!\n", reg->hr_dev_name);
+	o2hb_check_last_timestamp(reg);
 
 	/* fill in the proper info for our next heartbeat */
 	o2hb_prepare_block(reg, reg->hr_generation);
@@ -999,8 +1013,8 @@ static int o2hb_do_disk_heartbeat(struct o2hb_region *reg)
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
