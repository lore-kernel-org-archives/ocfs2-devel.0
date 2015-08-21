From: Joseph Qi <joseph.qi@huawei.com>
Date: Fri, 21 Aug 2015 08:54:41 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: fix BUG when
	o2hb_register_callback fails
Message-ID: <55D676D1.4050504@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In dlm_register_domain_handlers, if o2hb_register_callback fails, it
will call dlm_unregister_domain_handlers to unregister. This will
trigger the BUG_ON in o2hb_unregister_callback because hc_magic is 0.
So we should call o2hb_setup_callback to initialize hc first.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/dlm/dlmdomain.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 7df88a6..4f75070 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -1725,12 +1725,13 @@ static int dlm_register_domain_handlers(struct dlm_ctxt *dlm)

 	o2hb_setup_callback(&dlm->dlm_hb_down, O2HB_NODE_DOWN_CB,
 			    dlm_hb_node_down_cb, dlm, DLM_HB_NODE_DOWN_PRI);
+	o2hb_setup_callback(&dlm->dlm_hb_up, O2HB_NODE_UP_CB,
+			    dlm_hb_node_up_cb, dlm, DLM_HB_NODE_UP_PRI);
+
 	status = o2hb_register_callback(dlm->name, &dlm->dlm_hb_down);
 	if (status)
 		goto bail;

-	o2hb_setup_callback(&dlm->dlm_hb_up, O2HB_NODE_UP_CB,
-			    dlm_hb_node_up_cb, dlm, DLM_HB_NODE_UP_PRI);
 	status = o2hb_register_callback(dlm->name, &dlm->dlm_hb_up);
 	if (status)
 		goto bail;
-- 
1.8.4.3
