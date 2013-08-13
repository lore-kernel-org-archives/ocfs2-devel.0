From: Xue jiufei <xuejiufei@huawei.com>
Date: Tue, 13 Aug 2013 16:33:16 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: fix possible convertion deadlock
Message-ID: <5209EF4C.4040403@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We found there is a convertion deadlock when the owner of lockres
happened to crash before send DLM_PROXY_AST_MSG for a downconverting
lock. The situation is as follows:

Node1                            Node2                  Node3
                           the owner of lockresA
lock_1 granted at EX mode
and call ocfs2_cluster_unlock
to decrease ex_holders.
                                                 converting lock_3 from
                                                 NL to EX
                           send DLM_PROXY_AST_MSG
                           to Node1, asking Node 1
                           to downconvert.
receiving DLM_PROXY_AST_MSG,
thread ocfs2dc send
DLM_CONVERT_LOCK_MSG
to Node2 to downconvert
lock_1(EX->NL).
                           lock_1 can be granted and
                           put it into pending_asts
                           list, return DLM_NORMAL.
                           then something happened
                           and Node2 crashed.
received DLM_NORMAL, waiting
for DLM_PROXY_AST_MSG.
                                               selected as the recovery
                                               master, receving migrate
                                               lock from Node1, queue
                                               lock_1 to the tail of
                                               converting list.

After dlm recovery, converting list in the master of lockresA(Node3)
will be: converting list head <-> lock_3(NL->EX) <->lock_1(EX<->NL).
Requested mode of lock_3 is not compatible with the granted mode of
lock_1, so it can not be granted. and lock_1 can not downconvert
because covnerting queue is strictly FIFO. So a deadlock is created.
We think function dlm_process_recovery_data() should queue_ast for
lock_1 or alter the order of lock_1 and lock_3, so dlm_thread can
process lock_1 first. And if there are multiple downconverting locks,
they must convert form PR to NL, so no need to sort them.

Signed-off-by: joyce <xuejiufei@huawei.com>
---
 fs/ocfs2/dlm/dlmrecovery.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 773bd32..6cdbbe7 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1963,7 +1963,17 @@ skip_lvb:
 		}
 		if (!bad) {
 			dlm_lock_get(newlock);
-			list_add_tail(&newlock->list, queue);
+				if (mres->flags & DLM_MRES_RECOVERY &&
+						ml->list == DLM_CONVERTING_LIST &&
+						newlock->ml.type > newlock->ml.convert_type) {
+				mlog(0, "%s:%.*s: newlock %u:%llu is doing downconvert, "
+						"add it to the head of converting list\n",
+						dlm->name, res->lockname.len, res->lockname.name,
+						dlm_get_lock_cookie_node(be64_to_cpu(ml->cookie)),
+						dlm_get_lock_cookie_seq(be64_to_cpu(ml->cookie)));
+				list_add(&newlock->list, queue);
+			} else
+				list_add_tail(&newlock->list, queue);
 			mlog(0, "%s:%.*s: added lock for node %u, "
 			     "setting refmap bit\n", dlm->name,
 			     res->lockname.len, res->lockname.name, ml->node);
-- 
1.7.9.7
