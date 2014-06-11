From: Xue jiufei <xuejiufei@huawei.com>
Date: Wed, 11 Jun 2014 15:27:47 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: remove convertion of total_backoff in
	dlm_join_domain()
Message-ID: <539804F3.2070609@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The unit of total_backoff is msecs not jiffies, so no need to do the
convertion, otherwise, the join timeout is not 90 sec.

Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
Signed-off-by: joyce.xue <xuejiufei@huawei.com>
---
 fs/ocfs2/dlm/dlmdomain.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 8d46907..1ac0133 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -1923,12 +1923,11 @@ static int dlm_join_domain(struct dlm_ctxt *dlm)
 				goto bail;
 			}
 
-			if (total_backoff >
-			    msecs_to_jiffies(DLM_JOIN_TIMEOUT_MSECS)) {
+			if (total_backoff > DLM_JOIN_TIMEOUT_MSECS) {
 				status = -ERESTARTSYS;
 				mlog(ML_NOTICE, "Timed out joining dlm domain "
 				     "%s after %u msecs\n", dlm->name,
-				     jiffies_to_msecs(total_backoff));
+				     total_backoff);
 				goto bail;
 			}
 
-- 
1.8.3.4
