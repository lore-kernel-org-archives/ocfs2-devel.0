From: alex chen <alex.chen@huawei.com>
Date: Tue, 23 Sep 2014 11:57:49 +0800
Subject: [Ocfs2-devel] [PATCH V2] ocfs2/dlm: should put mle when goto kill
 in dlm_assert_master_handler
Message-ID: <5420EFBD.1060502@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In dlm_assert_master_handler, the mle is get in dlm_find_mle, should be
put when goto kill, otherwise, this mle will never be released.

Signed-off-by: Alex Chen <alex.chen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: joyce.xue <xuejiufei@huawei.com>
---
 fs/ocfs2/dlm/dlmmaster.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 3ec906e..0a2de18 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -2037,6 +2037,10 @@ kill:
 	     "and killing the other node now!  This node is OK and can continue.\n");
 	__dlm_print_one_lock_resource(res);
 	spin_unlock(&res->spinlock);
+	spin_lock(&dlm->master_lock);
+	if (mle)
+		__dlm_put_mle(mle);
+	spin_unlock(&dlm->master_lock);
 	spin_unlock(&dlm->spinlock);
 	*ret_data = (void *)res;
 	dlm_put(dlm);
-- 
1.8.4.3
