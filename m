From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Wed, 19 Feb 2014 16:30:31 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: dlm: fix recovery hung
Message-ID: <1392798631-16510-1-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

There is a race window in dlm_do_recovery() between dlm_remaster_locks()
and dlm_reset_recovery() when the recovery master nearly finish the recovery
process for a dead node. After the master sends FINALIZE_RECO message in
dlm_remaster_locks(), another node may become the recovery master for another
dead node, and then send the BEGIN_RECO message to all the nodes included the
old master, in the handler of this message dlm_begin_reco_handler() of old master,
dlm->reco.dead_node and dlm->reco.new_master will be set to the second dead
node and the new master, then in dlm_reset_recovery(), these two variables
will be reset to default value. This will cause new recovery master can not finish
the recovery process and hung, at last the whole cluster will hung for recovery.

old recovery master:                                 new recovery master:
dlm_remaster_locks()
                                                  become recovery master for
                                                  another dead node.
                                                  dlm_send_begin_reco_message()
dlm_begin_reco_handler()
{
 if (dlm->reco.state & DLM_RECO_STATE_FINALIZE) {
  return -EAGAIN;
 }
 dlm_set_reco_master(dlm, br->node_idx);
 dlm_set_reco_dead_node(dlm, br->dead_node);
}
dlm_reset_recovery()
{
 dlm_set_reco_dead_node(dlm, O2NM_INVALID_NODE_NUM);
 dlm_set_reco_master(dlm, O2NM_INVALID_NODE_NUM);
}
                                                  will hung in dlm_remaster_locks() for
                                                  request dlm locks info

Before send FINALIZE_RECO message, recovery master should set DLM_RECO_STATE_FINALIZE
for itself and clear it after the recovery done, this can break the race windows as
the BEGIN_RECO messages will not be handled before DLM_RECO_STATE_FINALIZE flag is
cleared.

A similar race may happen between new recovery master and normal node which is in
dlm_finalize_reco_handler(), also fix it.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 fs/ocfs2/dlm/dlmrecovery.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 7035af0..fe58e8b 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -537,7 +537,10 @@ master_here:
 		/* success!  see if any other nodes need recovery */
 		mlog(0, "DONE mastering recovery of %s:%u here(this=%u)!\n",
 		     dlm->name, dlm->reco.dead_node, dlm->node_num);
-		dlm_reset_recovery(dlm);
+		spin_lock(&dlm->spinlock);
+		__dlm_reset_recovery(dlm);
+		dlm->reco.state &= ~DLM_RECO_STATE_FINALIZE;
+		spin_unlock(&dlm->spinlock);
 	}
 	dlm_end_recovery(dlm);
 
@@ -695,6 +698,10 @@ static int dlm_remaster_locks(struct dlm_ctxt *dlm, u8 dead_node)
 		if (all_nodes_done) {
 			int ret;
 
+			spin_lock(&dlm->spinlock);
+			dlm->reco.state |= DLM_RECO_STATE_FINALIZE;
+			spin_unlock(&dlm->spinlock);
+
 			/* all nodes are now in DLM_RECO_NODE_DATA_DONE state
 	 		 * just send a finalize message to everyone and
 	 		 * clean up */
@@ -2882,8 +2889,8 @@ int dlm_finalize_reco_handler(struct o2net_msg *msg, u32 len, void *data,
 				BUG();
 			}
 			dlm->reco.state &= ~DLM_RECO_STATE_FINALIZE;
+			__dlm_reset_recovery(dlm);
 			spin_unlock(&dlm->spinlock);
-			dlm_reset_recovery(dlm);
 			dlm_kick_recovery_thread(dlm);
 			break;
 		default:
-- 
1.7.9.5
