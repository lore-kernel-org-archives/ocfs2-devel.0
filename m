From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 24 Jun 2009 13:42:37 -0700
Subject: [Ocfs2-devel] [STABLE, 2.6.30.x] ocfs2: Fix ocfs2_osb_dump()
Message-ID: <20090624204237.GA1631@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Stable folks,
	When a user creates a local (non-clustered) ocfs2 filesystem,
accessing the /sys/kernel/debug/<uuid>/fs_state file will crash the
system.  This patch fixes the crash by correctly handling local
filesystems.  The problem was introduced with 2.6.30 and does not affect
2.6.29.  It is mainline commit c3d38840abaa45c1c5a5fabbb8ffc9a0d1a764d1.

Joel

From: Sunil Mushran <sunil.mushran@oracle.com>

Skip printing information that is not valid for local mounts.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
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
1.6.3.1


-- 

A good programming language should have features that make the
kind of people who use the phrase "software engineering" shake
their heads disapprovingly.
	- Paul Graham

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
