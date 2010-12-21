From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 20 Dec 2010 16:35:00 -0800
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2/dlm: Minor cleanup
In-Reply-To: <1292891701-5111-1-git-send-email-sunil.mushran@oracle.com>
References: <1292891701-5111-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1292891701-5111-3-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Patch makes use of task_pid_nr(). Also removes the null check before calling
debugfs_remove().

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/netdebug.c |   20 +++++++-------------
 fs/ocfs2/dlm/dlmdebug.c     |   22 ++++++++--------------
 2 files changed, 15 insertions(+), 27 deletions(-)

diff --git a/fs/ocfs2/cluster/netdebug.c b/fs/ocfs2/cluster/netdebug.c
index a3f150e..0edf836 100644
--- a/fs/ocfs2/cluster/netdebug.c
+++ b/fs/ocfs2/cluster/netdebug.c
@@ -141,7 +141,7 @@ static int nst_seq_show(struct seq_file *seq, void *v)
 			   "  sock acquiry: %lu.%ld\n"
 			   "  send start:   %lu.%ld\n"
 			   "  wait start:   %lu.%ld\n",
-			   nst, (unsigned long)nst->st_task->pid,
+			   nst, (unsigned long)task_pid_nr(nst->st_task),
 			   (unsigned long)nst->st_task->tgid,
 			   nst->st_task->comm, nst->st_node,
 			   nst->st_sc, nst->st_id, nst->st_msg_type,
@@ -421,23 +421,17 @@ int o2net_debugfs_init(void)
 
 	return 0;
 bail:
-	if (sc_dentry)
-		debugfs_remove(sc_dentry);
-	if (nst_dentry)
-		debugfs_remove(nst_dentry);
-	if (o2net_dentry)
-		debugfs_remove(o2net_dentry);
+	debugfs_remove(sc_dentry);
+	debugfs_remove(nst_dentry);
+	debugfs_remove(o2net_dentry);
 	return -ENOMEM;
 }
 
 void o2net_debugfs_exit(void)
 {
-	if (sc_dentry)
-		debugfs_remove(sc_dentry);
-	if (nst_dentry)
-		debugfs_remove(nst_dentry);
-	if (o2net_dentry)
-		debugfs_remove(o2net_dentry);
+	debugfs_remove(sc_dentry);
+	debugfs_remove(nst_dentry);
+	debugfs_remove(o2net_dentry);
 }
 
 #endif	/* CONFIG_DEBUG_FS */
diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index 77199ca..04a32be 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -743,7 +743,7 @@ static int debug_state_print(struct dlm_ctxt *dlm, char *buf, int len)
 	/* Thread Pid: xxx  Node: xxx  State: xxxxx */
 	out += snprintf(buf + out, len - out,
 			"Thread Pid: %d  Node: %d  State: %s\n",
-			dlm->dlm_thread_task->pid, dlm->node_num, state);
+			task_pid_nr(dlm->dlm_thread_task), dlm->node_num, state);
 
 	/* Number of Joins: xxx  Joining Node: xxx */
 	out += snprintf(buf + out, len - out,
@@ -823,7 +823,7 @@ static int debug_state_print(struct dlm_ctxt *dlm, char *buf, int len)
 	/* Recovery Pid: xxxx  Master: xxx  State: xxxx */
 	out += snprintf(buf + out, len - out,
 			"Recovery Pid: %d  Master: %d  State: %s\n",
-			dlm->dlm_reco_thread_task->pid,
+			task_pid_nr(dlm->dlm_reco_thread_task),
 			dlm->reco.new_master, state);
 
 	/* Recovery Map: xx xx */
@@ -956,14 +956,10 @@ void dlm_debug_shutdown(struct dlm_ctxt *dlm)
 	struct dlm_debug_ctxt *dc = dlm->dlm_debug_ctxt;
 
 	if (dc) {
-		if (dc->debug_purgelist_dentry)
-			debugfs_remove(dc->debug_purgelist_dentry);
-		if (dc->debug_mle_dentry)
-			debugfs_remove(dc->debug_mle_dentry);
-		if (dc->debug_lockres_dentry)
-			debugfs_remove(dc->debug_lockres_dentry);
-		if (dc->debug_state_dentry)
-			debugfs_remove(dc->debug_state_dentry);
+		debugfs_remove(dc->debug_purgelist_dentry);
+		debugfs_remove(dc->debug_mle_dentry);
+		debugfs_remove(dc->debug_lockres_dentry);
+		debugfs_remove(dc->debug_state_dentry);
 		dlm_debug_put(dc);
 	}
 }
@@ -994,8 +990,7 @@ bail:
 
 void dlm_destroy_debugfs_subroot(struct dlm_ctxt *dlm)
 {
-	if (dlm->dlm_debugfs_subroot)
-		debugfs_remove(dlm->dlm_debugfs_subroot);
+	debugfs_remove(dlm->dlm_debugfs_subroot);
 }
 
 /* debugfs root */
@@ -1011,7 +1006,6 @@ int dlm_create_debugfs_root(void)
 
 void dlm_destroy_debugfs_root(void)
 {
-	if (dlm_debugfs_root)
-		debugfs_remove(dlm_debugfs_root);
+	debugfs_remove(dlm_debugfs_root);
 }
 #endif	/* CONFIG_DEBUG_FS */
-- 
1.7.1
