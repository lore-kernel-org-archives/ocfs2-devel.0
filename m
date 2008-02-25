From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon Feb 25 12:21:17 2008
Subject: [Ocfs2-devel] [PATCH 18/18] ocfs2_dlm: Print message showing the
	recomaster
In-Reply-To: <1203970862-8790-1-git-send-email-sunil.mushran@oracle.com>
References: <1203970862-8790-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1203970862-8790-19-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Knowing the dlm recovery master helps in debugging recovery
issues. This patch printks the message on the recomaster node.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmrecovery.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 487c50e..fae0543 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -517,9 +517,9 @@ static int dlm_do_recovery(struct dlm_ctxt *dlm)
 	return 0;
 
 master_here:
-	mlog(0, "(%d) mastering recovery of %s:%u here(this=%u)!\n",
-	     dlm->dlm_reco_thread_task->pid,
-	     dlm->name, dlm->reco.dead_node, dlm->node_num);
+	mlog(ML_NOTICE, "(%d) Node %u is the Recovery Master for the Dead Node "
+	     "%u for Domain %s\n", dlm->dlm_reco_thread_task->pid,
+	     dlm->node_num, dlm->reco.dead_node, dlm->name);
 
 	status = dlm_remaster_locks(dlm, dlm->reco.dead_node);
 	if (status < 0) {
-- 
1.5.2.5
