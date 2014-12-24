From: Xue jiufei <xuejiufei@huawei.com>
Date: Wed, 24 Dec 2014 17:14:26 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: add missing dlm_lock_put() when
 recovery master down
Message-ID: <549A83F2.80304@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When recovery master down, the owner of $RECOVERY calls
dlm_do_local_recovery_cleanup() to prune any $RECOVERY entries for dead
nodes. The lock is in granted list and refcount must be 2.
We should put twice to remove this lock. Otherwise, it will lead to
memory leak.

Reported-by: yangwenfang <vicky.yangwenfang@huawei.com>
Signed-off-by: joyce.xue <xuejiufei@huawei.com>
---
 fs/ocfs2/dlm/dlmrecovery.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 3365839..8576c1f 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1070,6 +1070,9 @@ static void dlm_move_reco_locks_to_list(struct dlm_ctxt *dlm,
 					     dead_node, dlm->name);
 					list_del_init(&lock->list);
 					dlm_lock_put(lock);
+					/* Can't schedule DLM_UNLOCK_FREE_LOCK
+					 * - do manually */
+					dlm_lock_put(lock);
 					break;
 				}
 			}
@@ -2341,6 +2344,10 @@ static void dlm_do_local_recovery_cleanup(struct dlm_ctxt *dlm, u8 dead_node)
 						     dead_node, dlm->name);
 						list_del_init(&lock->list);
 						dlm_lock_put(lock);
+						/* Can't schedule
+						 * DLM_UNLOCK_FREE_LOCK
+						 * - do manually */
+						dlm_lock_put(lock);
 						break;
 					}
 				}
-- 
1.8.4.3
