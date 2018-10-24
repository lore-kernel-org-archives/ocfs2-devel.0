From: Jia Guo <guojia12@huawei.com>
Date: Wed, 24 Oct 2018 11:47:24 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: Optimize the reading of heartbeat
	data
Message-ID: <99fe4988-69ac-3615-a218-3042fe6fbe72@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Reading heartbeat data from lowest node rather than from zero, in
cases where the node is not defined from zero, can reduce the number
of sectors read.

Here is a simple test data obtained with 'iostat -dmx dm-5 2', with
two nodes in the cluster, node number 10, 20, respectively.
Before optimization:
Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
dm-5              0.00     0.00    0.50    0.50     0.01     0.00    11.00     0.00    1.00    1.00    1.00   1.50   0.15
After the optimization:
Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
dm-5              0.00     0.00    0.50    0.50     0.00     0.00     6.00     0.00    0.50    1.00    0.00   0.50   0.05

Signed-off-by: Jia Guo <guojia12@huawei.com>
Reviewed-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
---
 fs/ocfs2/cluster/heartbeat.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 9b2ed62..f3c20b2 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -582,9 +582,10 @@ static struct bio *o2hb_setup_one_bio(struct o2hb_region *reg,
 }

 static int o2hb_read_slots(struct o2hb_region *reg,
+			   unsigned int begin_slot,
 			   unsigned int max_slots)
 {
-	unsigned int current_slot=0;
+	unsigned int current_slot = begin_slot;
 	int status;
 	struct o2hb_bio_wait_ctxt wc;
 	struct bio *bio;
@@ -1093,9 +1094,14 @@ static int o2hb_highest_node(unsigned long *nodes, int numbits)
 	return find_last_bit(nodes, numbits);
 }

+static int o2hb_lowest_node(unsigned long *nodes, int numbits)
+{
+	return find_first_bit(nodes, numbits);
+}
+
 static int o2hb_do_disk_heartbeat(struct o2hb_region *reg)
 {
-	int i, ret, highest_node;
+	int i, ret, highest_node, lowest_node;
 	int membership_change = 0, own_slot_ok = 0;
 	unsigned long configured_nodes[BITS_TO_LONGS(O2NM_MAX_NODES)];
 	unsigned long live_node_bitmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
@@ -1120,7 +1126,8 @@ static int o2hb_do_disk_heartbeat(struct o2hb_region *reg)
 	}

 	highest_node = o2hb_highest_node(configured_nodes, O2NM_MAX_NODES);
-	if (highest_node >= O2NM_MAX_NODES) {
+	lowest_node = o2hb_lowest_node(configured_nodes, O2NM_MAX_NODES);
+	if (highest_node >= O2NM_MAX_NODES || lowest_node >= O2NM_MAX_NODES) {
 		mlog(ML_NOTICE, "o2hb: No configured nodes found!\n");
 		ret = -EINVAL;
 		goto bail;
@@ -1130,7 +1137,7 @@ static int o2hb_do_disk_heartbeat(struct o2hb_region *reg)
 	 * yet. Of course, if the node definitions have holes in them
 	 * then we're reading an empty slot anyway... Consider this
 	 * best-effort. */
-	ret = o2hb_read_slots(reg, highest_node + 1);
+	ret = o2hb_read_slots(reg, lowest_node, highest_node + 1);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto bail;
@@ -1801,7 +1808,7 @@ static int o2hb_populate_slot_data(struct o2hb_region *reg)
 	struct o2hb_disk_slot *slot;
 	struct o2hb_disk_heartbeat_block *hb_block;

-	ret = o2hb_read_slots(reg, reg->hr_blocks);
+	ret = o2hb_read_slots(reg, 0, reg->hr_blocks);
 	if (ret)
 		goto out;

-- 
