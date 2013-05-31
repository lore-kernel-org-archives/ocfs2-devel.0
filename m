From: Xue jiufei <xuejiufei@huawei.com>
Date: Fri, 31 May 2013 13:44:59 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Add missing dlm_put() in
	dlm_begin_reco_handler
Message-ID: <51A838DB.8030208@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Function dlm_begin_reco_handler returns without putting dlm 
when dlm recovery state is DLM_RECO_STATE_FINALIZE.

Signed-off-by: joyce <xuejiufei@huawei.com>
---
 fs/ocfs2/dlm/dlmrecovery.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index eeac97b..a145cf8 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -2697,6 +2697,7 @@ int dlm_begin_reco_handler(struct o2net_msg *msg, u32 len, void *data,
 		     dlm->name, br->node_idx, br->dead_node,
 		     dlm->reco.dead_node, dlm->reco.new_master);
 		spin_unlock(&dlm->spinlock);
+		dlm_put(dlm);
 		return -EAGAIN;
 	}
 	spin_unlock(&dlm->spinlock);
-- 1.7.9.7
