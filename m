From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Wed, 23 Mar 2016 13:12:48 -0700
Subject: [Ocfs2-devel] [patch 23/25] ocfs2: o2hb: don't negotiate if last hb
	fail
Message-ID: <56f2f8c0.5J6YNjHzh3EEp3tN%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: o2hb: don't negotiate if last hb fail

Sometimes io error is returned when storage is down for a while.  Like for
iscsi device, stroage is made offline when session timeout, and this will
make all io return -EIO.  For this case, nodes shouldn't do negotiate
timeout but should fence self.  So let nodes fence self when
o2hb_do_disk_heartbeat return an error, this is the same behavior with
o2hb without negotiate timer.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Ryan Ding <ryan.ding@oracle.com>
Cc: Gang He <ghe@suse.com>
Cc: rwxybh <rwxybh@126.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN fs/ocfs2/cluster/heartbeat.c~ocfs2-o2hb-dont-negotiate-if-last-hb-fail fs/ocfs2/cluster/heartbeat.c
--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-o2hb-dont-negotiate-if-last-hb-fail
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -284,6 +284,9 @@ struct o2hb_region {
 	/* Message key for negotiate timeout message. */
 	unsigned int		hr_key;
 	struct list_head	hr_handler_list;
+
+	/* last hb status, 0 for success, other value for error. */
+	int			hr_last_hb_status;
 };
 
 struct o2hb_bio_wait_ctxt {
@@ -396,6 +399,12 @@ static void o2hb_nego_timeout(struct wor
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
@@ -1229,6 +1238,7 @@ static int o2hb_thread(void *data)
 		before_hb = ktime_get_real();
 
 		ret = o2hb_do_disk_heartbeat(reg);
+		reg->hr_last_hb_status = ret;
 
 		after_hb = ktime_get_real();
 
_
