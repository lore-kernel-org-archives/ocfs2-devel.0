From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Wed, 20 Jan 2016 11:13:38 +0800
Subject: [Ocfs2-devel] [PATCH 5/6] ocfs2: o2hb: don't negotiate if last hb
	fail
In-Reply-To: <1453259619-5347-1-git-send-email-junxiao.bi@oracle.com>
References: <1453259619-5347-1-git-send-email-junxiao.bi@oracle.com>
Message-ID: <1453259619-5347-6-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sometimes io error is returned when storage is down for a while.
Like for iscsi device, stroage is made offline when session timeout,
and this will make all io return -EIO. For this case, nodes shouldn't
do negotiate timeout but should fence self. So let nodes fence self
when o2hb_do_disk_heartbeat return an error, this is the same behavior
with o2hb without negotiate timer.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Ryan Ding <ryan.ding@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 6c57fd21e597..cb931381f474 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -284,6 +284,9 @@ struct o2hb_region {
 	/* Message key for negotiate timeout message. */
 	unsigned int		hr_key;
 	struct list_head	hr_handler_list;
+
+	/* last hb status, 0 for success, other value for error. */
+	int			hr_last_hb_status;
 };
 
 struct o2hb_bio_wait_ctxt {
@@ -397,6 +400,12 @@ static void o2hb_nego_timeout(struct work_struct *work)
 	unsigned long live_node_bitmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
 	int master_node, i, ret;
 
+	/* don't negotiate timeout if last hb failed since it is very
+	 * possible io failed. Should let write timeout fence self.
+	 */
+	if (reg->hr_last_hb_status)
+		return;
+
 	o2hb_fill_node_map(live_node_bitmap, sizeof(live_node_bitmap));
 	/* lowest node as master node to make negotiate decision. */
 	master_node = find_next_bit(live_node_bitmap, O2NM_MAX_NODES, 0);
@@ -1230,6 +1239,7 @@ static int o2hb_thread(void *data)
 		before_hb = ktime_get_real();
 
 		ret = o2hb_do_disk_heartbeat(reg);
+		reg->hr_last_hb_status = ret;
 
 		after_hb = ktime_get_real();
 
-- 
1.7.9.5
