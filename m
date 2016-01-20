From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Wed, 20 Jan 2016 11:13:36 +0800
Subject: [Ocfs2-devel] [PATCH 3/6] ocfs2: o2hb: add NEGOTIATE_APPROVE message
In-Reply-To: <1453259619-5347-1-git-send-email-junxiao.bi@oracle.com>
References: <1453259619-5347-1-git-send-email-junxiao.bi@oracle.com>
Message-ID: <1453259619-5347-4-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This message is used to re-queue write timeout timer and negotiate timer
when all nodes suffer a write hung to storage, this makes node not fence
self if storage down.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Ryan Ding <ryan.ding@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index ecf8a5e21c38..d5ef8dce08da 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -294,6 +294,7 @@ struct o2hb_bio_wait_ctxt {
 
 enum {
 	O2HB_NEGO_TIMEOUT_MSG = 1,
+	O2HB_NEGO_APPROVE_MSG = 2,
 };
 
 struct o2hb_nego_msg {
@@ -392,7 +393,7 @@ static void o2hb_nego_timeout(struct work_struct *work)
 		container_of(work, struct o2hb_region,
 			     hr_nego_timeout_work.work);
 	unsigned long live_node_bitmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
-	int master_node;
+	int master_node, i;
 
 	o2hb_fill_node_map(live_node_bitmap, sizeof(live_node_bitmap));
 	/* lowest node as master node to make negotiate decision. */
@@ -412,6 +413,17 @@ static void o2hb_nego_timeout(struct work_struct *work)
 		}
 
 		/* approve negotiate timeout request. */
+		o2hb_arm_timeout(reg);
+
+		i = -1;
+		while ((i = find_next_bit(live_node_bitmap,
+				O2NM_MAX_NODES, i + 1)) < O2NM_MAX_NODES) {
+			if (i == master_node)
+				continue;
+
+			o2hb_send_nego_msg(reg->hr_key,
+					O2HB_NEGO_APPROVE_MSG, i);
+		}
 	} else {
 		/* negotiate timeout with master node. */
 		o2hb_send_nego_msg(reg->hr_key, O2HB_NEGO_TIMEOUT_MSG,
@@ -434,6 +446,13 @@ static int o2hb_nego_timeout_handler(struct o2net_msg *msg, u32 len, void *data,
 	return 0;
 }
 
+static int o2hb_nego_approve_handler(struct o2net_msg *msg, u32 len, void *data,
+				void **ret_data)
+{
+	o2hb_arm_timeout((struct o2hb_region *)data);
+	return 0;
+}
+
 static inline void o2hb_bio_wait_init(struct o2hb_bio_wait_ctxt *wc)
 {
 	atomic_set(&wc->wc_num_reqs, 1);
@@ -2100,6 +2119,13 @@ static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *g
 	if (ret)
 		goto free;
 
+	ret = o2net_register_handler(O2HB_NEGO_APPROVE_MSG, reg->hr_key,
+			sizeof(struct o2hb_nego_msg),
+			o2hb_nego_approve_handler,
+			reg, NULL, &reg->hr_handler_list);
+	if (ret)
+		goto free_handler;
+
 	ret = o2hb_debug_region_init(reg, o2hb_debug_dir);
 	if (ret) {
 		config_item_put(&reg->hr_item);
-- 
1.7.9.5
