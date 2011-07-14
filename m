From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 14 Jul 2011 15:50:21 -0700
Subject: [Ocfs2-devel] [PATCH 10/16] ocfs2/dlm: dlmlock_remote() needs to
	account for remastery
In-Reply-To: <1310683827-19157-1-git-send-email-sunil.mushran@oracle.com>
References: <1310683827-19157-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1310683827-19157-11-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In dlmlock_remote(), we wait for the resource to stop being active before
setting the inprogress flag. Active includes recovery, migration, etc.

The problem here is that if the resource was being recovered or migrated, the
new owner could very well be that node itself (and thus not a remote node).
This problem was observed in Oracle bug#12583620. The error messages observed
were as follows:

dlm_send_remote_lock_request:337 ERROR: Error -40 (ELOOP) when sending message 503 (key 0xd6d8c7) to node 2
dlmlock_remote:271 ERROR: dlm status = DLM_BADARGS
dlmlock:751 ERROR: dlm status = DLM_BADARGS

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmlock.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmlock.c b/fs/ocfs2/dlm/dlmlock.c
index 3ef2c1a..f32fcba 100644
--- a/fs/ocfs2/dlm/dlmlock.c
+++ b/fs/ocfs2/dlm/dlmlock.c
@@ -227,10 +227,16 @@ static enum dlm_status dlmlock_remote(struct dlm_ctxt *dlm,
 	     lock->ml.type, res->lockname.len,
 	     res->lockname.name, flags);
 
+	/*
+	 * Wait if resource is getting recovered, remastered, etc.
+	 * If the resource was remastered and new owner is self, then exit.
+	 */
 	spin_lock(&res->spinlock);
-
-	/* will exit this call with spinlock held */
 	__dlm_wait_on_lockres(res);
+	if (res->owner == dlm->node_num) {
+		spin_unlock(&res->spinlock);
+		return DLM_RECOVERING;
+	}
 	res->state |= DLM_LOCK_RES_IN_PROGRESS;
 
 	/* add lock to local (secondary) queue */
@@ -710,18 +716,10 @@ retry_lock:
 
 		if (status == DLM_RECOVERING || status == DLM_MIGRATING ||
 		    status == DLM_FORWARD) {
-			mlog(0, "retrying lock with migration/"
-			     "recovery/in progress\n");
 			msleep(100);
-			/* no waiting for dlm_reco_thread */
 			if (recovery) {
 				if (status != DLM_RECOVERING)
 					goto retry_lock;
-
-				mlog(0, "%s: got RECOVERING "
-				     "for $RECOVERY lock, master "
-				     "was %u\n", dlm->name,
-				     res->owner);
 				/* wait to see the node go down, then
 				 * drop down and allow the lockres to
 				 * get cleaned up.  need to remaster. */
-- 
1.7.4.1
