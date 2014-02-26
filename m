From: Jan Kara <jack@suse.cz>
Date: Wed, 26 Feb 2014 17:49:32 +0100
Subject: [Ocfs2-devel] [PATCH 5/6] ocfs2: Avoid blocking in
	ocfs2_mark_lockres_freeing() in downconvert thread
In-Reply-To: <1393433373-28767-1-git-send-email-jack@suse.cz>
References: <1393433373-28767-1-git-send-email-jack@suse.cz>
Message-ID: <1393433373-28767-6-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

If we are dropping last inode reference from downconvert thread, we will
end up calling ocfs2_mark_lockres_freeing() which can block if the lock
we are freeing is queued thus creating an A-A deadlock. Luckily, since
we are the downconvert thread, we can immediately dequeue the lock and
thus avoid waiting in this case.

Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/dlmglue.c | 44 +++++++++++++++++++++++++++++++++++++++++---
 fs/ocfs2/dlmglue.h |  3 ++-
 fs/ocfs2/inode.c   |  7 ++++---
 3 files changed, 47 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 19986959d149..6bd690b5a061 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3144,22 +3144,60 @@ out:
 	return 0;
 }
 
+static void ocfs2_process_blocked_lock(struct ocfs2_super *osb,
+				       struct ocfs2_lock_res *lockres);
+
 /* Mark the lockres as being dropped. It will no longer be
  * queued if blocking, but we still may have to wait on it
  * being dequeued from the downconvert thread before we can consider
  * it safe to drop.
  *
  * You can *not* attempt to call cluster_lock on this lockres anymore. */
-void ocfs2_mark_lockres_freeing(struct ocfs2_lock_res *lockres)
+void ocfs2_mark_lockres_freeing(struct ocfs2_super *osb,
+				struct ocfs2_lock_res *lockres)
 {
 	int status;
 	struct ocfs2_mask_waiter mw;
-	unsigned long flags;
+	unsigned long flags, flags2;
 
 	ocfs2_init_mask_waiter(&mw);
 
 	spin_lock_irqsave(&lockres->l_lock, flags);
 	lockres->l_flags |= OCFS2_LOCK_FREEING;
+	if (lockres->l_flags & OCFS2_LOCK_QUEUED && current == osb->dc_task) {
+		/*
+		 * We know the downconvert is queued but not in progress
+		 * because we are the downconvert thread and processing
+		 * different lock. So we can just remove the lock from the
+		 * queue. This is not only an optimization but also a way
+		 * to avoid the following deadlock:
+		 *   ocfs2_dentry_post_unlock()
+		 *     ocfs2_dentry_lock_put()
+		 *       ocfs2_drop_dentry_lock()
+		 *         iput()
+		 *           ocfs2_evict_inode()
+		 *             ocfs2_clear_inode()
+		 *               ocfs2_mark_lockres_freeing()
+		 *                 ... blocks waiting for OCFS2_LOCK_QUEUED
+		 *                 since we are the downconvert thread which
+		 *                 should clear the flag.
+		 */
+		spin_unlock_irqrestore(&lockres->l_lock, flags);
+		spin_lock_irqsave(&osb->dc_task_lock, flags2);
+		list_del_init(&lockres->l_blocked_list);
+		osb->blocked_lock_count--;
+		spin_unlock_irqrestore(&osb->dc_task_lock, flags2);
+		/*
+		 * Warn if we recurse into another post_unlock call.  Strictly
+		 * speaking it isn't a problem but we need to be careful if
+		 * that happens (stack overflow, deadlocks, ...) so warn if
+		 * ocfs2 grows a path for which this can happen.
+		 */
+		WARN_ON_ONCE(lockres->l_ops->post_unlock);
+		/* Since the lock is freeing we don't do much in the fn below */
+		ocfs2_process_blocked_lock(osb, lockres);
+		return;
+	}
 	while (lockres->l_flags & OCFS2_LOCK_QUEUED) {
 		lockres_add_mask_waiter(lockres, &mw, OCFS2_LOCK_QUEUED, 0);
 		spin_unlock_irqrestore(&lockres->l_lock, flags);
@@ -3180,7 +3218,7 @@ void ocfs2_simple_drop_lockres(struct ocfs2_super *osb,
 {
 	int ret;
 
-	ocfs2_mark_lockres_freeing(lockres);
+	ocfs2_mark_lockres_freeing(osb, lockres);
 	ret = ocfs2_drop_lock(osb, lockres);
 	if (ret)
 		mlog_errno(ret);
diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
index 1d596d8c4a4a..d293a22c32c5 100644
--- a/fs/ocfs2/dlmglue.h
+++ b/fs/ocfs2/dlmglue.h
@@ -157,7 +157,8 @@ int ocfs2_refcount_lock(struct ocfs2_refcount_tree *ref_tree, int ex);
 void ocfs2_refcount_unlock(struct ocfs2_refcount_tree *ref_tree, int ex);
 
 
-void ocfs2_mark_lockres_freeing(struct ocfs2_lock_res *lockres);
+void ocfs2_mark_lockres_freeing(struct ocfs2_super *osb,
+				struct ocfs2_lock_res *lockres);
 void ocfs2_simple_drop_lockres(struct ocfs2_super *osb,
 			       struct ocfs2_lock_res *lockres);
 
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 3b0d722de35e..9661f8db21dc 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1053,6 +1053,7 @@ static void ocfs2_clear_inode(struct inode *inode)
 {
 	int status;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
 	clear_inode(inode);
 	trace_ocfs2_clear_inode((unsigned long long)oi->ip_blkno,
@@ -1069,9 +1070,9 @@ static void ocfs2_clear_inode(struct inode *inode)
 
 	/* Do these before all the other work so that we don't bounce
 	 * the downconvert thread while waiting to destroy the locks. */
-	ocfs2_mark_lockres_freeing(&oi->ip_rw_lockres);
-	ocfs2_mark_lockres_freeing(&oi->ip_inode_lockres);
-	ocfs2_mark_lockres_freeing(&oi->ip_open_lockres);
+	ocfs2_mark_lockres_freeing(osb, &oi->ip_rw_lockres);
+	ocfs2_mark_lockres_freeing(osb, &oi->ip_inode_lockres);
+	ocfs2_mark_lockres_freeing(osb, &oi->ip_open_lockres);
 
 	ocfs2_resv_discard(&OCFS2_SB(inode->i_sb)->osb_la_resmap,
 			   &oi->ip_la_data_resv);
-- 
1.8.1.4
