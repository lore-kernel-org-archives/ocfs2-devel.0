From: Xue jiufei <xuejiufei@huawei.com>
Date: Fri, 13 Jun 2014 15:41:59 +0800
Subject: [Ocfs2-devel] [PATCH V2] ocfs2/dlm: fix misuse of list_move_tail()
	in dlm_run_purge_list()
Message-ID: <539AAB47.8050705@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When a lockres in purge list but is still in use, it should be moved to
the tail of purge list. dlm_thread will continue to check next lockres
in purge list. However, code list_move_tail(&dlm->purge_list,
&lockres->purge) will do *no* movements, so dlm_thread will purge the
same lockres in this loop again and again. If it is in use for a long
time, other lockres will not be processed.

Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
Signed-off-by: joyce.xue <xuejiufei@huawei.com>
---
 fs/ocfs2/dlm/dlmthread.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
index 9db869d..cf53a82 100644
--- a/fs/ocfs2/dlm/dlmthread.c
+++ b/fs/ocfs2/dlm/dlmthread.c
@@ -264,7 +264,7 @@ static void dlm_run_purge_list(struct dlm_ctxt *dlm,
 			     "used %d, state %d\n", dlm->name,
 			     lockres->lockname.len, lockres->lockname.name,
 			     !unused, lockres->state);
-			list_move_tail(&dlm->purge_list, &lockres->purge);
+			list_move_tail(&lockres->purge, &dlm->purge_list);
 			spin_unlock(&lockres->spinlock);
 			continue;
 		}
-- 
1.8.3.4
