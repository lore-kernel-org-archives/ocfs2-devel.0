From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 23 Jun 2011 15:31:02 -0700
Subject: [Ocfs2-devel] [PATCH 08/13] ocfs2/dlm: Cleanup
	dlm_wait_for_node_death() and dlm_wait_for_node_recovery()
In-Reply-To: <1308868267-5981-1-git-send-email-sunil.mushran@oracle.com>
References: <1308868267-5981-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1308868267-5981-9-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

dlm_wait_for_node_death() and dlm_wait_for_node_recovery() needed a facelift.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmcommon.h   |    4 +-
 fs/ocfs2/dlm/dlmrecovery.c |   46 +++++++++++++++++++++----------------------
 2 files changed, 24 insertions(+), 26 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index b1748ac..a5952ce 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -859,8 +859,8 @@ void dlm_complete_recovery_thread(struct dlm_ctxt *dlm);
 void dlm_wait_for_recovery(struct dlm_ctxt *dlm);
 void dlm_kick_recovery_thread(struct dlm_ctxt *dlm);
 int dlm_is_node_dead(struct dlm_ctxt *dlm, u8 node);
-int dlm_wait_for_node_death(struct dlm_ctxt *dlm, u8 node, int timeout);
-int dlm_wait_for_node_recovery(struct dlm_ctxt *dlm, u8 node, int timeout);
+void dlm_wait_for_node_death(struct dlm_ctxt *dlm, u8 node, int timeout);
+void dlm_wait_for_node_recovery(struct dlm_ctxt *dlm, u8 node, int timeout);
 
 void dlm_put(struct dlm_ctxt *dlm);
 struct dlm_ctxt *dlm_grab(struct dlm_ctxt *dlm);
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index f1a3aa8..01ebfd0 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -362,40 +362,38 @@ static int dlm_is_node_recovered(struct dlm_ctxt *dlm, u8 node)
 }
 
 
-int dlm_wait_for_node_death(struct dlm_ctxt *dlm, u8 node, int timeout)
+void dlm_wait_for_node_death(struct dlm_ctxt *dlm, u8 node, int timeout)
 {
-	if (timeout) {
-		mlog(ML_NOTICE, "%s: waiting %dms for notification of "
-		     "death of node %u\n", dlm->name, timeout, node);
+	if (dlm_is_node_dead(dlm, node))
+		return;
+
+	printk(KERN_NOTICE "o2dlm: Waiting on the death of node %u in "
+	       "domain %s\n", node, dlm->name);
+
+	if (timeout)
 		wait_event_timeout(dlm->dlm_reco_thread_wq,
-			   dlm_is_node_dead(dlm, node),
-			   msecs_to_jiffies(timeout));
-	} else {
-		mlog(ML_NOTICE, "%s: waiting indefinitely for notification "
-		     "of death of node %u\n", dlm->name, node);
+				   dlm_is_node_dead(dlm, node),
+				   msecs_to_jiffies(timeout));
+	else
 		wait_event(dlm->dlm_reco_thread_wq,
 			   dlm_is_node_dead(dlm, node));
-	}
-	/* for now, return 0 */
-	return 0;
 }
 
-int dlm_wait_for_node_recovery(struct dlm_ctxt *dlm, u8 node, int timeout)
+void dlm_wait_for_node_recovery(struct dlm_ctxt *dlm, u8 node, int timeout)
 {
-	if (timeout) {
-		mlog(0, "%s: waiting %dms for notification of "
-		     "recovery of node %u\n", dlm->name, timeout, node);
+	if (dlm_is_node_recovered(dlm, node))
+		return;
+
+	printk(KERN_NOTICE "o2dlm: Waiting on the recovery of node %u in "
+	       "domain %s\n", node, dlm->name);
+
+	if (timeout)
 		wait_event_timeout(dlm->dlm_reco_thread_wq,
-			   dlm_is_node_recovered(dlm, node),
-			   msecs_to_jiffies(timeout));
-	} else {
-		mlog(0, "%s: waiting indefinitely for notification "
-		     "of recovery of node %u\n", dlm->name, node);
+				   dlm_is_node_recovered(dlm, node),
+				   msecs_to_jiffies(timeout));
+	else
 		wait_event(dlm->dlm_reco_thread_wq,
 			   dlm_is_node_recovered(dlm, node));
-	}
-	/* for now, return 0 */
-	return 0;
 }
 
 /* callers of the top-level api calls (dlmlock/dlmunlock) should
-- 
1.7.4.1
