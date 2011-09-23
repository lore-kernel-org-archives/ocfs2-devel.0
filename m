From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 23 Sep 2011 08:49:53 +0800
Subject: [Ocfs2-devel] [PATCH] Wakeup down-convert thread just after
	clearing OCFS2_LOCK_UPCONVERT_FINISHING -v3
Message-ID: <201109230049.p8N0nkT6025292@acsmt358.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When the lockres state UPCONVERT_FINISHING is cleared,
we should wake up the downconvert thread incase that lockres
is in the blocked queue. Currently we are not doing so and thus
are at the mercy of another event waking up the dc thread.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/dlmglue.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 7642d7c..524bd88 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -1195,6 +1195,7 @@ static inline void ocfs2_recover_from_dlm_error(struct ocfs2_lock_res *lockres,
 						int convert)
 {
 	unsigned long flags;
+	int kick_dc;
 
 	spin_lock_irqsave(&lockres->l_lock, flags);
 	lockres_clear_flags(lockres, OCFS2_LOCK_BUSY);
@@ -1203,9 +1204,12 @@ static inline void ocfs2_recover_from_dlm_error(struct ocfs2_lock_res *lockres,
 		lockres->l_action = OCFS2_AST_INVALID;
 	else
 		lockres->l_unlock_action = OCFS2_UNLOCK_INVALID;
+	kick_dc = (lockres->l_flags & OCFS2_LOCK_QUEUED);
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
 
 	wake_up(&lockres->l_event);
+	if (kick_dc)
+		ocfs2_wake_downconvert_thread(ocfs2_get_lockres_osb(lockres));
 }
 
 /* Note: If we detect another process working on the lock (i.e.,
@@ -1373,6 +1377,7 @@ static int __ocfs2_cluster_lock(struct ocfs2_super *osb,
 	unsigned long flags;
 	unsigned int gen;
 	int noqueue_attempted = 0;
+	int kick_dc;
 
 	ocfs2_init_mask_waiter(&mw);
 
@@ -1500,8 +1505,10 @@ update_holders:
 	ret = 0;
 unlock:
 	lockres_clear_flags(lockres, OCFS2_LOCK_UPCONVERT_FINISHING);
-
+	kick_dc = (lockres->l_flags & OCFS2_LOCK_QUEUED);
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
+	if (kick_dc)
+		ocfs2_wake_downconvert_thread(osb);
 out:
 	/*
 	 * This is helping work around a lock inversion between the page lock
-- 
1.7.5.2
