From: xuejiufei <xuejiufei@huawei.com>
Date: Tue, 2 Feb 2016 09:18:26 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: clear refmap bit of recovery lock
 while doing local recovery cleanup
Message-ID: <56B003E2.5080104@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When recovery master down, dlm_do_local_recovery_cleanup() only
remove the $RECOVERY lock owned by dead node, but do not clear
the refmap bit. Which will make umount thread falling in dead loop
migrating $RECOVERY to the dead node.

Signed-off-by: xuejiufei <xuejiufei@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/dlm/dlmrecovery.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 4c7b548..213279d 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -2379,6 +2379,8 @@ static void dlm_do_local_recovery_cleanup(struct dlm_ctxt *dlm, u8 dead_node)
 						break;
 					}
 				}
+				dlm_lockres_clear_refmap_bit(dlm, res,
+						dead_node);
 				spin_unlock(&res->spinlock);
 				continue;
 			}
-- 
1.8.4.3
