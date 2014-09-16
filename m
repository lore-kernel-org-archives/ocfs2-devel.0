From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Tue, 16 Sep 2014 13:15:19 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: don't fire quorum before connection
	established
Message-ID: <1410844519-23662-1-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Firing quorum before connection established can cause unexpected node to reboot.
Assume there are 3 nodes in the cluster, Node 1, 2, 3. Node 2 and 3 have
wrong ip address of Node 1 in cluster.conf and global heartbeat is enabled
in the cluster. After the heatbeat are started on these three nodes, Node 1
will reboot due to quorum fencing. It is similar case if Node 1's networking
is not ready when starting the global heatbeat.
The reboot is not friendly as customer is not fully ready for ocfs2 to work.
Fix it by not allow firing quorum before connection established. In this
case, ocfs2 will wait until wrong configure fixed or networking up to continue.
Also update the log to guide user where to check when connection is not built
for a long time.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
---
 fs/ocfs2/cluster/tcp.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index ea34952..b2cc010 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -536,7 +536,7 @@ static void o2net_set_nn_state(struct o2net_node *nn,
 	if (nn->nn_persistent_error || nn->nn_sc_valid)
 		wake_up(&nn->nn_sc_wq);
 
-	if (!was_err && nn->nn_persistent_error) {
+	if (was_valid && !was_err && nn->nn_persistent_error) {
 		o2quo_conn_err(o2net_num_from_nn(nn));
 		queue_delayed_work(o2net_wq, &nn->nn_still_up,
 				   msecs_to_jiffies(O2NET_QUORUM_DELAY_MS));
@@ -1721,7 +1721,8 @@ static void o2net_connect_expired(struct work_struct *work)
 	spin_lock(&nn->nn_lock);
 	if (!nn->nn_sc_valid) {
 		printk(KERN_NOTICE "o2net: No connection established with "
-		       "node %u after %u.%u seconds, giving up.\n",
+		       "node %u after %u.%u seconds, check network and"
+		       " cluster configuration.\n",
 		     o2net_num_from_nn(nn),
 		     o2net_idle_timeout() / 1000,
 		     o2net_idle_timeout() % 1000);
-- 
1.7.9.5
