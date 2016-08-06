From: Gechangwei <ge.changwei@h3c.com>
Date: Sat, 6 Aug 2016 05:58:57 +0000
Subject: [Ocfs2-devel] [PATCH] A bug in the end of DLM recovery
Message-ID: <63ADC13FD55D6546B7DECE290D39E373220B2B3D@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

I found an issue in the end of DLM recovery.
When DLM recovery comes to the end of recovery procedure, it will remaster all locks in other nodes.
Right after a request message is sent to a node A (say), the new master node will wait for node A?s response forever.
But node A may die just after receiving the remaster request, not responses to new master node yet.
That causes new master node waiting forever.
I think below patch can solve this problem. Please have a review!


Subject: [PATCH] interrupt waiting for node's response if node dies

Signed-off-by: gechangwei <ge.changwei@h3c.com>
---
dlm/dlmrecovery.c | 4 ++++
1 file changed, 4 insertions(+)

diff --git a/dlm/dlmrecovery.c b/dlm/dlmrecovery.c
index 3d90ad7..5e455cb 100644
--- a/dlm/dlmrecovery.c
+++ b/dlm/dlmrecovery.c
@@ -679,6 +679,10 @@ static int dlm_remaster_locks(struct dlm_ctxt *dlm, u8 dead_node)
                                                 dlm->name, ndata->node_num,
                                                 ndata->state==DLM_RECO_NODE_DATA_RECEIVING ?
                                                 "receiving" : "requested");
+                                            if (dlm_is_node_dead(dlm, ndata->node_num)) {
+                                                      mlog(0, "%s: node %u died after requesting all locks.\n");
+                                                      ndata->state = DLM_RECO_NODE_DATA_DONE;
+                                            }
                                            all_nodes_done = 0;
                                            break;
                                   case DLM_RECO_NODE_DATA_DONE:
--

BR.

Chauncey


-------------------------------------------------------------------------------------------------------------------------------------
????????????????????????????????????????
????????????????????????????????????????
????????????????????????????????????????
???
This e-mail and its attachments contain confidential information from H3C, which is
intended only for the person or entity whose address is listed above. Any use of the
information contained herein in any way (including, but not limited to, total or partial
disclosure, reproduction, or dissemination) by persons other than the intended
recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
by phone or email immediately and delete it!
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20160806/2fd57399/attachment.html 
