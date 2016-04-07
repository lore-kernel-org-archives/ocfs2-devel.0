From: xuejiufei <xuejiufei@huawei.com>
Date: Thu, 7 Apr 2016 16:39:56 +0800
Subject: [Ocfs2-devel] [PATCH V2] ocfs2/dlm: return zero if deref_done
 message is successfully handled
Message-ID: <57061CDC.6000600@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Function dlm_deref_lockres_done_handler() should return zero
if the message is successfully handled.

Signed-off-by: xuejiufei <xuejiufei@huawei.com>
---
 fs/ocfs2/dlm/dlmmaster.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 9aed6e2..13719d3 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -2455,6 +2455,8 @@ int dlm_deref_lockres_done_handler(struct o2net_msg *msg, u32 len, void *data,

 	spin_unlock(&dlm->spinlock);

+	ret = 0;
+
 done:
 	dlm_put(dlm);
 	return ret;
-- 
1.8.4.3
