From: Xue jiufei <xuejiufei@huawei.com>
Date: Tue, 14 Aug 2012 10:06:37 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: delay migration when the lockres is in
	migration state
Message-ID: <5029B2AD.2020705@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  We trigger a bug in __dlm_lockres_reserve_ast() when we parallel umount 4 nodes. The situation is as follows:
  1) Node A migrate all lockres it owned(eg. lockres A) to other nodes say node B when it umounts.  
  2) Receiving MIG_LOCKRES message from A, Node B masters the lockres A with DLM_LOCK_RES_MIGRATING state set. 
  3) Then we umount ocfs2 on node B. It also should migrate lockres A to another node, say node C. But now, DLM_LOCK_RES_MIGRATING state 
of lockers A is not cleared. Node B triggered the BUG on lockres with state DLM_LOCK_RES_MIGRATING.

Signed-off-by: Xuejiufei <xuejiufei@huawei.com>
---
 fs/ocfs2/dlm/dlmmaster.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 005261c..6c35406 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -2357,6 +2357,10 @@ static int dlm_is_lockres_migrateable(struct dlm_ctxt *dlm,
 
 	assert_spin_locked(&res->spinlock);
 
+	/* delay migration when the lockres is in MIGRATING state */
+	if (res->state & DLM_LOCK_RES_MIGRATING)
+		return 0;
+
 	if (res->owner != dlm->node_num)
 		return 0;
 
-- 1.7.9.7 
