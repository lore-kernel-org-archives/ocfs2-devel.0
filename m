From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed Jan 16 11:33:03 2008
Subject: [Ocfs2-devel] [PATCH 02/20] ocfs2: Create locks at initially
	requested level
In-Reply-To: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
References: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1200511977-19513-3-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 019d1b2247c6898589560c6f3b3e7ec280b0010a
Author: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri, 5 Oct 2007 12:09:05 -0700

If we have not yet created a cluster lock, ocfs2_cluster_lock() will
first create it at NLMODE, and then convert the lock to either PRMODE or
EXMODE (whichever is requested).

Change ocfs2_cluster_lock() to just create the lock at the initially
requested level. ocfs2_locking_ast() handles this case fine, so the only
update required was in setup of locking state. This should reduce the number
of network messages required for a new lock by one, providing an incremental
performance enhancement.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/dlmglue.c |   23 +++++++++--------------
 1 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index ef09fd2..4e97dcc 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -980,18 +980,6 @@ again:
 		goto unlock;
 	}
 
-	if (!(lockres->l_flags & OCFS2_LOCK_ATTACHED)) {
-		/* lock has not been created yet. */
-		spin_unlock_irqrestore(&lockres->l_lock, flags);
-
-		ret = ocfs2_lock_create(osb, lockres, LKM_NLMODE, 0);
-		if (ret < 0) {
-			mlog_errno(ret);
-			goto out;
-		}
-		goto again;
-	}
-
 	if (lockres->l_flags & OCFS2_LOCK_BLOCKED &&
 	    !ocfs2_may_continue_on_blocked_lock(lockres, level)) {
 		/* is the lock is currently blocked on behalf of
@@ -1006,7 +994,14 @@ again:
 			mlog(ML_ERROR, "lockres %s has action %u pending\n",
 			     lockres->l_name, lockres->l_action);
 
-		lockres->l_action = OCFS2_AST_CONVERT;
+		if (!(lockres->l_flags & OCFS2_LOCK_ATTACHED)) {
+			lockres->l_action = OCFS2_AST_ATTACH;
+			lkm_flags &= ~LKM_CONVERT;
+		} else {
+			lockres->l_action = OCFS2_AST_CONVERT;
+			lkm_flags |= LKM_CONVERT;
+		}
+
 		lockres->l_requested = level;
 		lockres_or_flags(lockres, OCFS2_LOCK_BUSY);
 		spin_unlock_irqrestore(&lockres->l_lock, flags);
@@ -1021,7 +1016,7 @@ again:
 		status = dlmlock(osb->dlm,
 				 level,
 				 &lockres->l_lksb,
-				 lkm_flags|LKM_CONVERT,
+				 lkm_flags,
 				 lockres->l_name,
 				 OCFS2_LOCK_ID_MAX_LEN - 1,
 				 ocfs2_locking_ast,
-- 
1.5.3.4
