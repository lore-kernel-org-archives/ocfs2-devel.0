From: piaojun <piaojun@huawei.com>
Date: Fri, 9 Feb 2018 11:06:28 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: clean up some unused function
	declaration
Message-ID: <5A7D1034.7050807@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Clean up some unused function declaration in dlmcommon.h

Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
---
 fs/ocfs2/dlm/dlmcommon.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index e9f3705..953c200 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -960,13 +960,10 @@ static inline int dlm_send_proxy_ast(struct dlm_ctxt *dlm,
 void dlm_print_one_lock_resource(struct dlm_lock_resource *res);
 void __dlm_print_one_lock_resource(struct dlm_lock_resource *res);

-u8 dlm_nm_this_node(struct dlm_ctxt *dlm);
 void dlm_kick_thread(struct dlm_ctxt *dlm, struct dlm_lock_resource *res);
 void __dlm_dirty_lockres(struct dlm_ctxt *dlm, struct dlm_lock_resource *res);


-int dlm_nm_init(struct dlm_ctxt *dlm);
-int dlm_heartbeat_init(struct dlm_ctxt *dlm);
 void dlm_hb_node_down_cb(struct o2nm_node *node, int idx, void *data);
 void dlm_hb_node_up_cb(struct o2nm_node *node, int idx, void *data);

-- 
