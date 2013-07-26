From: Xue jiufei <xuejiufei@huawei.com>
Date: Fri, 26 Jul 2013 12:09:38 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: dlm_request_all_locks() should deal
 with the status sent from target node
Message-ID: <51F1F682.4000009@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

dlm_request_all_locks() should deal with the status sent from target
node if DLM_LOCK_REQUEST_MSG is sent successfully, or recovery master
will fall into endless loop, waiting for other nodes to send locks and
DLM_RECO_DATA_DONE_MSG to me.

        NodeA                                  NodeB
                                     selected as recovery master
                                     dlm_remaster_locks()
                                     ->dlm_request_all_locks()
                                     send DLM_LOCK_REQUEST_MSG to nodeA

It happened that NodeA cannot alloc
memory when it processes this message.
dlm_request_all_locks_handler() do
not queue dlm_request_all_locks_worker
and returns -ENOMEM. It will never
send locks andDLM_RECO_DATA_DONE_MSG
to NodeB.

                                    NodeB do not deal with the status
                                    sent from nodeA, and will fall in
                                    endless loop waiting for the
                                    recovery state of NodeA to be
                                    changed.

Signed-off-by: joyce <xuejiufei@huawei.com>
---
 fs/ocfs2/dlm/dlmrecovery.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 773bd32..f945502 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -787,6 +787,7 @@ static int dlm_request_all_locks(struct dlm_ctxt *dlm, u8 request_from,
 {
 	struct dlm_lock_request lr;
 	int ret;
+	int status;
 
 	mlog(0, "\n");
 
@@ -800,13 +801,15 @@ static int dlm_request_all_locks(struct dlm_ctxt *dlm, u8 request_from,
 
 	// send message
 	ret = o2net_send_message(DLM_LOCK_REQUEST_MSG, dlm->key,
-				 &lr, sizeof(lr), request_from, NULL);
+				 &lr, sizeof(lr), request_from, &status);
 
 	/* negative status is handled by caller */
 	if (ret < 0)
 		mlog(ML_ERROR, "%s: Error %d send LOCK_REQUEST to node %u "
 		     "to recover dead node %u\n", dlm->name, ret,
 		     request_from, dead_node);
+	else
+		ret = status;
 	// return from here, then
 	// sleep until all received or error
 	return ret;
-- 
1.7.9.7
