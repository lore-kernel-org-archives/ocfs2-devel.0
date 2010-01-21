From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 21 Jan 2010 10:50:03 -0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Prevent a livelock in dlmglue
In-Reply-To: <1264099803-16680-1-git-send-email-sunil.mushran@oracle.com>
References: <1264099803-16680-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1264099803-16680-3-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

There is possibility of a livelock in __ocfs2_cluster_lock(). If a node were
to get an ast for an upconvert request, followed immediately by a bast, there
is a small probability the fs may downconvert the lock before the process, that
requested the upconvert, is able to take the lock.

This patch adds a new flag to indicate that the upconvert is still in progress
and that the dc thread should not downconvert it right now.

Wengang Wang <wen.gang.wang@oracle.com> and Joel Becker <joel.becker@oracle.com>
contributed heavily to this patch.

Reported-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlmglue.c |   49 ++++++++++++++++++++++++++++++++++++++++++++++---
 fs/ocfs2/ocfs2.h   |    4 ++++
 2 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 0190f31..f7b9f8f 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -875,6 +875,14 @@ static inline void ocfs2_generic_handle_convert_action(struct ocfs2_lock_res *lo
 		lockres_or_flags(lockres, OCFS2_LOCK_NEEDS_REFRESH);
 
 	lockres->l_level = lockres->l_requested;
+
+	/*
+	 * We set the OCFS2_LOCK_UPCONVERT_FINISHING flag before clearing
+	 * the OCFS2_LOCK_BUSY flag to prevent the dc thread from
+	 * downconverting the lock before the upconvert has fully completed.
+	 */
+	lockres_or_flags(lockres, OCFS2_LOCK_UPCONVERT_FINISHING);
+
 	lockres_clear_flags(lockres, OCFS2_LOCK_BUSY);
 
 	mlog_exit_void();
@@ -1134,6 +1142,7 @@ static inline void ocfs2_recover_from_dlm_error(struct ocfs2_lock_res *lockres,
 	mlog_entry_void();
 	spin_lock_irqsave(&lockres->l_lock, flags);
 	lockres_clear_flags(lockres, OCFS2_LOCK_BUSY);
+	lockres_clear_flags(lockres, OCFS2_LOCK_UPCONVERT_FINISHING);
 	if (convert)
 		lockres->l_action = OCFS2_AST_INVALID;
 	else
@@ -1324,13 +1333,13 @@ static int __ocfs2_cluster_lock(struct ocfs2_super *osb,
 again:
 	wait = 0;
 
+	spin_lock_irqsave(&lockres->l_lock, flags);
+
 	if (catch_signals && signal_pending(current)) {
 		ret = -ERESTARTSYS;
-		goto out;
+		goto unlock;
 	}
 
-	spin_lock_irqsave(&lockres->l_lock, flags);
-
 	mlog_bug_on_msg(lockres->l_flags & OCFS2_LOCK_FREEING,
 			"Cluster lock called on freeing lockres %s! flags "
 			"0x%lx\n", lockres->l_name, lockres->l_flags);
@@ -1347,6 +1356,25 @@ again:
 		goto unlock;
 	}
 
+	if (lockres->l_flags & OCFS2_LOCK_UPCONVERT_FINISHING) {
+		/*
+		 * We've upconverted. If the lock now has a level we can
+		 * work with, we take it. If, however, the lock is not at the
+		 * required level, we go thru the full cycle. One way this could
+		 * happen is if a process requesting an upconvert to PR is
+		 * closely followed by another requesting upconvert to an EX.
+		 * If the process requesting EX lands here, we want it to
+		 * continue attempting to upconvert and let the process
+		 * requesting PR take the lock.
+		 * If multiple processes request upconvert to PR, the first one
+		 * here will take the lock. The others will have to go thru the
+		 * OCFS2_LOCK_BLOCKED check to ensure that there is no pending
+		 * downconvert request.
+		 */
+		if (level <= lockres->l_level)
+			goto update_holders;
+	}
+
 	if (lockres->l_flags & OCFS2_LOCK_BLOCKED &&
 	    !ocfs2_may_continue_on_blocked_lock(lockres, level)) {
 		/* is the lock is currently blocked on behalf of
@@ -1417,11 +1445,14 @@ again:
 		goto again;
 	}
 
+update_holders:
 	/* Ok, if we get here then we're good to go. */
 	ocfs2_inc_holders(lockres, level);
 
 	ret = 0;
 unlock:
+	lockres_clear_flags(lockres, OCFS2_LOCK_UPCONVERT_FINISHING);
+
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
 out:
 	/*
@@ -3402,6 +3433,18 @@ recheck:
 		goto leave;
 	}
 
+	/*
+	 * This prevents livelocks. OCFS2_LOCK_UPCONVERT_FINISHING flag is
+	 * set when the ast is received for an upconvert just before the
+	 * OCFS2_LOCK_BUSY flag is cleared. Now if the fs received a bast
+	 * on the heels of the ast, we want to delay the downconvert just
+	 * enough to allow the up requestor to do its task. Because this
+	 * lock is in the blocked queue, the lock will be downconverted
+	 * as soon as the requestor is done with the lock.
+	 */
+	if (lockres->l_flags & OCFS2_LOCK_UPCONVERT_FINISHING)
+		goto leave_requeue;
+
 	/* if we're blocking an exclusive and we have *any* holders,
 	 * then requeue. */
 	if ((lockres->l_blocking == DLM_LOCK_EX)
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index d963d86..782e77d 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -136,6 +136,10 @@ enum ocfs2_unlock_action {
 #define OCFS2_LOCK_PENDING       (0x00000400) /* This lockres is pending a
 						 call to dlm_lock.  Only
 						 exists with BUSY set. */
+#define OCFS2_LOCK_UPCONVERT_FINISHING (0x00000800) /* blocks the dc thread
+						     * from downconverting
+						     * before the upconvert
+						     * has completed */
 
 struct ocfs2_lock_res_ops;
 
-- 
1.6.3.3
