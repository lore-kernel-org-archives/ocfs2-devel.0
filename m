From: Tariq Saeed <tariq.x.saeed@oracle.com>
Date: Thu, 17 Jul 2014 14:00:40 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: race between umount and unfinished
	remastering during recovery
Message-ID: <1405630840-7071-1-git-send-email-tariq.x.saeed@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Orabug: 19074140

When umount is issued during recovery on the new master that
has not finished remastering locks, it triggers BUG() in
dlm_send_mig_lockres_msg().  Here is the situation:

1) node A has a lock on resource X mastered by node B.

2) node B dies ->  node A sets recovering flag for res X

3) Node C becomes the new master for resources owned by the
   dead node and is remastering locks of the dead node but
   has not finished the remastering process yet.

4) umount is issued on node C.

5) During processing of umount, ignoring unfished recovery,
   node C attempts to migrate resource X to node A.

6) node A finds res X in DLM_LOCK_RES_RECOVERING state, considers
   it a logic error and sends back -EFAULT.

7) node C asserts BUG() upon seeing EFAULT resp from node B.

Fix is to delay migrating res X  till remastering is finished
at which point recovering flag will be cleared on both A and C.

Signed-off-by: Tariq Saeed <tariq.x.saeed@oracle.com>
---
 fs/ocfs2/dlm/dlmmaster.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 82abf0c..3ec906e 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -2405,6 +2405,10 @@ static int dlm_is_lockres_migrateable(struct dlm_ctxt *dlm,
 	if (res->state & DLM_LOCK_RES_MIGRATING)
 		return 0;
 
+	/* delay migration when the lockres is in RECOCERING state */
+	if (res->state & DLM_LOCK_RES_RECOVERING)
+		return 0;
+
 	if (res->owner != dlm->node_num)
 		return 0;
 
-- 
1.7.1
