From: Xue jiufei <xuejiufei@huawei.com>
Date: Mon, 26 May 2014 15:13:26 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: Disallow node joining when
	recovery is on going
Message-ID: <5382E996.6090109@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We found a race situation when dlm recovery and node joining
occurs simultaneously if the network state is bad.

N1                                      N4
start joining dlm and send
query join to all live nodes
                            set joining node to N1, return OK
send query join to other
live nodes and it may take
a while

call dlm_send_join_assert()
to send assert join message
when N2 is down, so keep
trying to send message to N2
until find N2 is down

send assert join message to
N3, but connection is down
with N3, so it may take a
while
                            become the recovery master for N2
                            and send begin reco message to other
                            nodes in domain map but no N1
connection with N3 is rebuild,
then send assert join to N4
                            call dlm_assert_joined_handler(),
                            add N1 to domain_map

                            dlm recovery done, send finalize message
                            to nodes in domain map, including N1
receiving finalize message,
trigger the BUG() because
recovery master mismatch.

Signed-off-by: joyce.xue <xuejiufei@huawei.com>
---
 fs/ocfs2/dlm/dlmdomain.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index c973690..8d46907 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -959,6 +959,14 @@ static int dlm_assert_joined_handler(struct o2net_msg *msg, u32 len, void *data,
 		 * domain. Set him in the map and clean up our
 		 * leftover join state. */
 		BUG_ON(dlm->joining_node != assert->node_idx);
+
+		if (dlm->reco.state & DLM_RECO_STATE_ACTIVE) {
+			mlog(0, "dlm recovery is ongoing, disallow join\n");
+			spin_unlock(&dlm->spinlock);
+			spin_unlock(&dlm_domain_lock);
+			return -EAGAIN;
+		}
+
 		set_bit(assert->node_idx, dlm->domain_map);
 		clear_bit(assert->node_idx, dlm->exit_domain_map);
 		__dlm_set_joining_node(dlm, DLM_LOCK_RES_OWNER_UNKNOWN);
@@ -1517,6 +1525,7 @@ static int dlm_send_one_join_assert(struct dlm_ctxt *dlm,
 				    unsigned int node)
 {
 	int status;
+	int ret;
 	struct dlm_assert_joined assert_msg;
 
 	mlog(0, "Sending join assert to node %u\n", node);
@@ -1528,11 +1537,13 @@ static int dlm_send_one_join_assert(struct dlm_ctxt *dlm,
 
 	status = o2net_send_message(DLM_ASSERT_JOINED_MSG, DLM_MOD_KEY,
 				    &assert_msg, sizeof(assert_msg), node,
-				    NULL);
+				    &ret);
 	if (status < 0)
 		mlog(ML_ERROR, "Error %d when sending message %u (key 0x%x) to "
 		     "node %u\n", status, DLM_ASSERT_JOINED_MSG, DLM_MOD_KEY,
 		     node);
+	else
+		status = ret;
 
 	return status;
 }
-- 
1.8.3.4
