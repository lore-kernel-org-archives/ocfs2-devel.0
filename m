From: Xue jiufei <xuejiufei@huawei.com>
Date: Fri, 2 Aug 2013 13:10:56 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2/dlm: force clean refmap when doing
	local cleanup
Message-ID: <51FB3F60.7070603@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Function dlm_do_local_recovery_cleanup() should force clean refmap if
the owner of lockres is UNKNOWN. Otherwise node may hang when umounting
filesystems. 
Here's the situation:

	Node1                                    Node2
dlmlock()
  -> dlm_get_lock_resource()       
send DLM_MASTER_REQUEST_MSG to
other nodes.
                                    
                                       trying to master this lockres,
                                       return MAYBE.
							
selected as the master of lockresA,
set mle->master to Node1,
and do assert_master,
send DLM_ASSERT_MASTER_MSG to Node2.
                                       Node 2 has interest on lockresA
                                       and return
                                       DLM_ASSERT_RESPONSE_MASTERY_REF
                                       then something happened and
                                       Node2 crashed.
							           
receiving DLM_ASSERT_RESPONSE_MASTERY_REF,
set Node2 into refmap, and keep sending
DLM_ASSERT_MASTER_MSG to other nodes

o2hb found node2 down, calling
dlm_hb_node_down()
--> dlm_do_local_recovery_cleanup()
the master of lockresA is still UNKNOWN,
no need to call dlm_free_dead_locks().

set the master of lockresA to Node1, but
Node2 stills remains in refmap.

when Node1 umount, it found that the refmap of lockresA is not empty
and attempted to migrate it to Node2, But Node2 is already down,
so umount hang, trying to migrate lockresA again and again.

Signed-off-by: joyce <xuejiufei@huawei.com>
---
 fs/ocfs2/dlm/dlmrecovery.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 773bd32..0ee058f 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -2328,6 +2328,14 @@ static void dlm_do_local_recovery_cleanup(struct dlm_ctxt *dlm, u8 dead_node)
 			} else if (res->owner == dlm->node_num) {
 				dlm_free_dead_locks(dlm, res, dead_node);
 				__dlm_lockres_calc_usage(dlm, res);
+			} else if (res->owner == DLM_LOCK_RES_OWNER_UNKNOWN) {
+				if (test_bit(dead_node, res->refmap)) {
+					mlog(0, "%s:%.*s: dead node %u had a ref, but had "
+						"no locks and had not purged before dying\n",
+						dlm->name, res->lockname.len,
+						res->lockname.name, dead_node);
+					dlm_lockres_clear_refmap_bit(dlm, res, dead_node);
+				}
 			}
 			spin_unlock(&res->spinlock);
 		}
-- 
1.7.9.7
