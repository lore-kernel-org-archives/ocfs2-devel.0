From: Tariq Saeed <tariq.x.saeed@oracle.com>
Date: Tue, 20 May 2014 14:53:36 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] deadlock when two nodes are converting
	same lock from PR to EX and idletimeout closes conn
Message-ID: <1400622816-10372-1-git-send-email-tariq.x.saeed@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Orabug: 18639535

Two node cluster and both nodes hold a lock at PR level and both want
to convert to EX at the same time. Master node 1 has sent BAST and then
closes the connection due to idletime out. Node 0  receives BAST, sends
unlock req with cancel flag but gets error  -ENOTCONN. The problem is this
error is ignored in dlm_send_remote_unlock_request() on the **incorrect**
assumption that the master is dead.  See NOTE in comment why it returns
DLM_NORMAL.  Upon getting DLM_NORMAL, node 0 proceeds to sends convert
(without cancel flg) which fails with -ENOTCONN. waits 5 sec and resends.
This time gets DLM_IVLOCKID from the master since lock not found in grant
, it had been moved to converting queue in response to conv PR->EX req.
No way out.

Node 1 (master)				Node 0
==============				======

lock mode PR				PR

convert PR -> EX
mv grant -> convert and que BAST
...
                     <-------- convert PR -> EX
convert que looks like this: ((node 1, PR -> EX) (node 0, PR -> EX))
...
			BAST (want PR -> NL)
                     ------------------>
...
idle timout, conn closed
                                ...
				In response to BAST,
				sends unlock with cancel convert flag
				gets -ENOTCONN. Ignores and
                                sends remote convert request
                                gets -ENOTCONN, waits 5 Sec, retries
...
reconnects
                   <----------------- convert req goes through on next try
does not find lock on grant que
                   status DLM_IVLOCKID
                   ------------------>
...

No way out. Fix is to keep retrying unlock with cancel flag untill it succeeds
or the master dies.

Signed-off-by: Tariq Saeed <tariq.x.saeed@oracle.com>
---
 fs/ocfs2/dlm/dlmunlock.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmunlock.c b/fs/ocfs2/dlm/dlmunlock.c
index 5698b52..2e3c9db 100644
--- a/fs/ocfs2/dlm/dlmunlock.c
+++ b/fs/ocfs2/dlm/dlmunlock.c
@@ -191,7 +191,9 @@ static enum dlm_status dlmunlock_common(struct dlm_ctxt *dlm,
 				     DLM_UNLOCK_CLEAR_CONVERT_TYPE);
 		} else if (status == DLM_RECOVERING ||
 			   status == DLM_MIGRATING ||
-			   status == DLM_FORWARD) {
+			   status == DLM_FORWARD ||
+			   status == DLM_NOLOCKMGR
+			   ) {
 			/* must clear the actions because this unlock
 			 * is about to be retried.  cannot free or do
 			 * any list manipulation. */
@@ -200,7 +202,8 @@ static enum dlm_status dlmunlock_common(struct dlm_ctxt *dlm,
 			     res->lockname.name,
 			     status==DLM_RECOVERING?"recovering":
 			     (status==DLM_MIGRATING?"migrating":
-			      "forward"));
+				(status == DLM_FORWARD ? "forward" :
+						"nolockmanager")));
 			actions = 0;
 		}
 		if (flags & LKM_CANCEL)
@@ -364,7 +367,10 @@ static enum dlm_status dlm_send_remote_unlock_request(struct dlm_ctxt *dlm,
 			 * updated state to the recovery master.  this thread
 			 * just needs to finish out the operation and call
 			 * the unlockast. */
-			ret = DLM_NORMAL;
+			if (dlm_is_node_dead(dlm, owner))
+				ret = DLM_NORMAL;
+			else
+				ret = DLM_NOLOCKMGR;
 		} else {
 			/* something bad.  this will BUG in ocfs2 */
 			ret = dlm_err_to_dlm_status(tmpret);
@@ -638,7 +644,9 @@ retry:
 
 	if (status == DLM_RECOVERING ||
 	    status == DLM_MIGRATING ||
-	    status == DLM_FORWARD) {
+	    status == DLM_FORWARD ||
+	    status == DLM_NOLOCKMGR) {
+
 		/* We want to go away for a tiny bit to allow recovery
 		 * / migration to complete on this resource. I don't
 		 * know of any wait queue we could sleep on as this
@@ -650,7 +658,7 @@ retry:
 		msleep(50);
 
 		mlog(0, "retrying unlock due to pending recovery/"
-		     "migration/in-progress\n");
+		     "migration/in-progress/reconnect\n");
 		goto retry;
 	}
 
-- 
1.7.1
