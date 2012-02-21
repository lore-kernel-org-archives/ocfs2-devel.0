From: xiaowei.hu at oracle.com <xiaowei.hu@oracle.com>
Date: Tue, 21 Feb 2012 14:12:08 +0800
Subject: [Ocfs2-devel] [PATCH] fixing dlmglue race condition
In-Reply-To: <1329804728-6146-1-git-send-email-xiaowei.hu@oracle.com>
References: <xiaowei.hu@oracle.com>
	<1329804728-6146-1-git-send-email-xiaowei.hu@oracle.com>
Message-ID: <1329804728-6146-2-git-send-email-xiaowei.hu@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Xiaowei.Hu <xiaowei.hu@oracle.com>

NodeA							NodeB
ocfs2_cluster_lock on a new lockres M
spin_lock_irqsave(&lockres->l_lock, flags);
gen = lockres_set_pending(lockres);
lockres->l_action = OCFS2_AST_ATTACH;
lockres_or_flags(lockres, OCFS2_LOCK_BUSY);
spin_unlock_irqrestore(&lockres->l_lock, flags);

ocfs2_dlm_lock() finished and returned.
**and lockres_clear_pending(lockres, gen, osb);
							request a lock
							on the same
							lockres M
							It's blocked by
							nodeA, and a
							ast proxy was
							send to A

bast queued and flushed,before the ast was queued
then the ocfs2dc was scheduled
there is a chance to execute this code path,since
pending flag was cleared already:
ocfs2_downconvert_thread()
ocfs2_downconvert_thread_do_work()
ocfs2_blocking_ast()
ocfs2_process_blocked_lock()
ocfs2_unblock_lock()
	spin_lock_irqsave(&lockres->l_lock, flags);
	if (lockres->l_flags & OCFS2_LOCK_BUSY)
	    ret = ocfs2_prepare_cancel_convert(osb, lockres);
		BUG_ON(lockres->l_action != OCFS2_AST_CONVERT &&
               	       lockres->l_action != OCFS2_AST_DOWNCONVERT);
		here trigger the BUG()
---
 fs/ocfs2/dlmglue.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 81a4cd2..6f5e516 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -1471,7 +1471,6 @@ again:
 				     lkm_flags,
 				     lockres->l_name,
 				     OCFS2_LOCK_ID_MAX_LEN - 1);
-		lockres_clear_pending(lockres, gen, osb);
 		if (ret) {
 			if (!(lkm_flags & DLM_LKF_NOQUEUE) ||
 			    (ret != -EAGAIN)) {
-- 
1.7.4.4
