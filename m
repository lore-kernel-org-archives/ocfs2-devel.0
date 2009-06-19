From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 19 Jun 2009 14:45:55 -0700
Subject: [Ocfs2-devel] [PATCH 2/5] ocfs2: Fix ocfs2_osb_dump()
In-Reply-To: <1245447958-12996-1-git-send-email-sunil.mushran@oracle.com>
References: <1245447958-12996-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1245447958-12996-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Skip printing information that is not valid for local mounts.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/super.c |   32 ++++++++++++++++++--------------
 1 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index d33767f..d64739b 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -234,20 +234,24 @@ static int ocfs2_osb_dump(struct ocfs2_super *osb, char *buf, int len)
 			"%10s => Opts: 0x%lX  AtimeQuanta: %u\n", "Mount",
 			osb->s_mount_opt, osb->s_atime_quantum);
 
-	out += snprintf(buf + out, len - out,
-			"%10s => Stack: %s  Name: %*s  Version: %d.%d\n",
-			"Cluster",
-			(*osb->osb_cluster_stack == '\0' ?
-			 "o2cb" : osb->osb_cluster_stack),
-			cconn->cc_namelen, cconn->cc_name,
-			cconn->cc_version.pv_major, cconn->cc_version.pv_minor);
+	if (cconn) {
+		out += snprintf(buf + out, len - out,
+				"%10s => Stack: %s  Name: %*s  "
+				"Version: %d.%d\n", "Cluster",
+				(*osb->osb_cluster_stack == '\0' ?
+				 "o2cb" : osb->osb_cluster_stack),
+				cconn->cc_namelen, cconn->cc_name,
+				cconn->cc_version.pv_major,
+				cconn->cc_version.pv_minor);
+	}
 
 	spin_lock(&osb->dc_task_lock);
 	out += snprintf(buf + out, len - out,
 			"%10s => Pid: %d  Count: %lu  WakeSeq: %lu  "
 			"WorkSeq: %lu\n", "DownCnvt",
-			task_pid_nr(osb->dc_task), osb->blocked_lock_count,
-			osb->dc_wake_sequence, osb->dc_work_sequence);
+			(osb->dc_task ?  task_pid_nr(osb->dc_task) : -1),
+			osb->blocked_lock_count, osb->dc_wake_sequence,
+			osb->dc_work_sequence);
 	spin_unlock(&osb->dc_task_lock);
 
 	spin_lock(&osb->osb_lock);
@@ -267,14 +271,15 @@ static int ocfs2_osb_dump(struct ocfs2_super *osb, char *buf, int len)
 
 	out += snprintf(buf + out, len - out,
 			"%10s => Pid: %d  Interval: %lu  Needs: %d\n", "Commit",
-			task_pid_nr(osb->commit_task), osb->osb_commit_interval,
+			(osb->commit_task ? task_pid_nr(osb->commit_task) : -1),
+			osb->osb_commit_interval,
 			atomic_read(&osb->needs_checkpoint));
 
 	out += snprintf(buf + out, len - out,
-			"%10s => State: %d  NumTxns: %d  TxnId: %lu\n",
+			"%10s => State: %d  TxnId: %lu  NumTxns: %d\n",
 			"Journal", osb->journal->j_state,
-			atomic_read(&osb->journal->j_num_trans),
-			osb->journal->j_trans_id);
+			osb->journal->j_trans_id,
+			atomic_read(&osb->journal->j_num_trans));
 
 	out += snprintf(buf + out, len - out,
 			"%10s => GlobalAllocs: %d  LocalAllocs: %d  "
@@ -302,7 +307,6 @@ static int ocfs2_osb_dump(struct ocfs2_super *osb, char *buf, int len)
 
 	out += snprintf(buf + out, len - out, "%10s => %3s  %10s\n",
 			"Slots", "Num", "RecoGen");
-
 	for (i = 0; i < osb->max_slots; ++i) {
 		out += snprintf(buf + out, len - out,
 				"%10s  %c %3d  %10d\n",
-- 
1.6.0.4
