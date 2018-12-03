From: wangjian <wangjian161@huawei.com>
Date: Mon, 3 Dec 2018 20:06:05 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: Clean DLM_LKSB_GET_LVB and
 DLM_LKSB_PUT_LVB when the cancel_pending is set
Message-ID: <bffbe5a5-acb6-652d-eb8a-99fb051e6631@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Function dlm_move_lockres_to_recovery_list should clean
DLM_LKSB_GET_LVB and DLM_LKSB_PUT_LVB when the cancel_pending
is set. Otherwise node may panic in dlm_proxy_ast_handler.

Here is the situation: At the beginning, Node1 is the master
of the lock resource and has NL lock, Node2 has PR lock,
Node3 has PR lock, Node4 has NL lock.

Node1        Node2            Node3            Node4
              convert lock_2 from
              PR to EX.

the mode of lock_3 is
PR, which blocks the
conversion request of
Node2. move lock_2 to
conversion list.

                           convert lock_3 from
                           PR to EX.

move lock_3 to conversion
list. send BAST to Node3.

                           receive BAST from Node1.
                           downconvert thread execute
                           canceling convert operation.

Node2 dies because
the host is powered down.

                           in dlmunlock_common function,
                           the downconvert thread set
                           cancel_pending. at the same
                           time, Node 3 realized that
                           Node 1 is dead, so move lock_3
                           back to granted list in
                           dlm_move_lockres_to_recovery_list
                           function and remove Node 1 from
                           the domain_map in
                           __dlm_hb_node_down function.
                           then downconvert thread failed
                           to send the lock cancellation
                           request to Node1 and return
                           DLM_NORMAL from
                           dlm_send_remote_unlock_request
                           function.

                                                 become recovery master.

              during the recovery
              process, send
              lock_2 that is
              converting form
              PR to EX to Node4.

                           during the recovery process,
                           send lock_3 in the granted list and
                           cantain the DLM_LKSB_GET_LVB
                           flag to Node4. Then downconvert thread
                           delete DLM_LKSB_GET_LVB flag in
                           dlmunlock_common function.

                                                 Node4 finish recovery.
                                                 the mode of lock_3 is
                                                 PR, which blocks the
                                                 conversion request of
                                                 Node2, so send BAST
                                                 to Node3.

                           receive BAST from Node4.
                           convert lock_3 from PR to NL.

                                                 change the mode of lock_3
                                                 from PR to NL and send
                                                 message to Node3.

                           receive message from
                           Node4. The message contain
                           LKM_GET_LVB flag, but the
                           lock->lksb->flags does not
                           contain DLM_LKSB_GET_LVB,
                           BUG_ON in dlm_proxy_ast_handler
                           function.

Signed-off-by: Jian Wang <wangjian161@huawei.com>
Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
---
  fs/ocfs2/dlm/dlmunlock.c | 1 +
  1 file changed, 1 insertion(+)

diff --git a/fs/ocfs2/dlm/dlmunlock.c b/fs/ocfs2/dlm/dlmunlock.c
index 63d701c..6e04fc7 100644
--- a/fs/ocfs2/dlm/dlmunlock.c
+++ b/fs/ocfs2/dlm/dlmunlock.c
@@ -277,6 +277,7 @@ void dlm_commit_pending_cancel(struct dlm_lock_resource *res,
  {
  	list_move_tail(&lock->list, &res->granted);
  	lock->ml.convert_type = LKM_IVMODE;
+	lock->lksb->flags &= ~(DLM_LKSB_GET_LVB|DLM_LKSB_PUT_LVB);
  }
  
  
-- 
1.8.3.1

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20181203/8f927337/attachment.html 
