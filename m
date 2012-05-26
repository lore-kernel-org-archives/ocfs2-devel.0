From: xiaowei.hu at oracle.com <xiaowei.hu@oracle.com>
Date: Sat, 26 May 2012 10:27:29 +0800
Subject: [Ocfs2-devel] [PATCH] Fix waiting status race condition in dlm
	recovery V2
Message-ID: <1337999249-15242-1-git-send-email-xiaowei.hu@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: "Xiaowei.Hu" <xiaowei.hu@oracle.com>

when the master requested locks ,but one/some of the live nodes died,
after it received the request msg and before send out the locks packages,
the recovery will fall into endless loop,waiting for the status changed to finalize

NodeA                                     NodeB
selected as recovery master
dlm_remaster_locks
  -> dlm_requeset_all_locks
  this send request locks msg to B
                                          received the msg from A,
                                          queue worker dlm_request_all_locks_worker
                                          return 0
go on set state to requested
wait for the state become done
                                          NodeB lost connection due to network
                                          before the worker begin, or it die.

NodeA still waiting for the change of reco state.
It won't end if it not get data done msg.
And at this time nodeB do not realize this (or it just died),
it won't send the msg for ever, nodeA left in the recovery process forever.

This patch let the recovery master check if the node still in live node
map when it stay in REQUESTED status.

Signed-off-by: Xiaowei.Hu <xiaowei.hu@oracle.com>
---
 fs/ocfs2/dlm/dlmrecovery.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 01ebfd0..546c5b5 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -339,6 +339,17 @@ static int dlm_reco_master_ready(struct dlm_ctxt *dlm)
 	return ready;
 }
 
+/* returns true if node is still in the live node map
+ * this map is cleared before domain map,could be checked in recovery*/
+int dlm_is_node_in_livemap(struct dlm_ctxt *dlm, u8 node)
+{
+	int live;
+	spin_lock(&dlm->spinlock);
+	live = !test_bit(node, dlm->live_nodes_map);
+	spin_unlock(&dlm->spinlock);
+	return live;
+}
+
 /* returns true if node is no longer in the domain
  * could be dead or just not joined */
 int dlm_is_node_dead(struct dlm_ctxt *dlm, u8 node)
@@ -679,7 +690,10 @@ static int dlm_remaster_locks(struct dlm_ctxt *dlm, u8 dead_node)
 					     dlm->name, ndata->node_num,
 					     ndata->state==DLM_RECO_NODE_DATA_RECEIVING ?
 					     "receiving" : "requested");
-					all_nodes_done = 0;
+					if (!dlm_is_node_in_livemap(dlm, ndata->node_num))
+						ndata->state = DLM_RECO_NODE_DATA_DEAD;
+					else
+						all_nodes_done = 0;
 					break;
 				case DLM_RECO_NODE_DATA_DONE:
 					mlog(0, "%s: node %u state is done\n",
-- 
1.7.7.6
