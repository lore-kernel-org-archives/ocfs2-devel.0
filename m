From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Sat Mar  1 14:04:53 2008
Subject: [Ocfs2-devel] [PATCH 5/6] ocfs2/dlm: Print message showing the
	recovery master
In-Reply-To: <1204409065-10953-1-git-send-email-sunil.mushran@oracle.com>
References: <1204409065-10953-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1204409065-10953-6-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Knowing the dlm recovery master helps in debugging recovery
issues. This patch prints a message on the recovery master node.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/dlm/dlmrecovery.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 23e7b49..283ac0f 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -519,9 +519,9 @@ static int dlm_do_recovery(struct dlm_ctxt *dlm)
 	return 0;
 
 master_here:
-	mlog(0, "(%d) mastering recovery of %s:%u here(this=%u)!\n",
-	     task_pid_nr(dlm->dlm_reco_thread_task),
-	     dlm->name, dlm->reco.dead_node, dlm->node_num);
+	mlog(ML_NOTICE, "(%d) Node %u is the Recovery Master for the Dead Node "
+	     "%u for Domain %s\n", task_pid_nr(dlm->dlm_reco_thread_task),
+	     dlm->node_num, dlm->reco.dead_node, dlm->name);
 
 	status = dlm_remaster_locks(dlm, dlm->reco.dead_node);
 	if (status < 0) {
-- 
1.5.3.6
