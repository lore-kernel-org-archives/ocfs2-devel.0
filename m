From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Tue, 25 May 2010 15:59:14 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: delay the migration when the
	lockres is in recovery
Message-ID: <201005250801.o4P6iFtZ005833@acsinet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We shouldn't migrate a lockres in recovery state.
Otherwise, it has the following problem:

1) Recovery happened as recovery master on a node(node A) which is in umount
migrating all lockres' it owned(master is node A) to other nodes, say a node B.
2) So node A wants to take over all the lockres' those are mastered by the
crashed node C. 
3) Receiving request_locks request from node A, node B send mig_lockres
requests(for recovery) to node A for all lockres' that was mastered by the
crashed node C. It can also send the request for a lockres(lockres A) which is
not in node A's hashtable.
4) Receiving the mig_lockres request for lockres A from node B, a new lockres
object lockres A', with INRECOVERING flag set, is created and inserted to hash
table.
5) The recovery for lockres A' is going on on node A, it finally mastered the
lockres A'. And now, RECOVERING flag is not cleared from lockres A' nor from
lockres A on node B.
6) The migration for lockres A' goes since now node A mastered lockres A' already.
the mig_lockres request(for migration) is sent to node B.
7) Node B responsed with -EFAULT because now lockres A is still in recovery state.
8) Node A BUG() on the -EFAULT.

fix:
The recovery state is cleared on node A(recovery master) after it's cleared on
node B. We wait until the in recovery state is cleared from node A and migrate
it to node B. 

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/dlm/dlmmaster.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 9289b43..de9c128 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -2371,6 +2371,9 @@ static int dlm_is_lockres_migrateable(struct dlm_ctxt *dlm,
 		goto leave;
 	}
 
+	if (unlikely(res->state & DLM_LOCK_RES_RECOVERING))
+		goto leave;
+
 	ret = 0;
 	queue = &res->granted;
 	for (i = 0; i < 3; i++) {
-- 
1.6.6.1
