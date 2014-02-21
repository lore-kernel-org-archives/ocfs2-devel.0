From: Jan Kara <jack@suse.cz>
Date: Fri, 21 Feb 2014 10:35:22 +0100
Subject: [Ocfs2-devel] [PATCH 5/6] ocfs2: Avoid blocking in
 ocfs2_mark_lockres_freeing() in downconvert thread
In-Reply-To: <20140221091415.GB12506@quack.suse.cz>
References: <1392909511-2933-1-git-send-email-jack@suse.cz>
	<1392909511-2933-6-git-send-email-jack@suse.cz>
	<5306E24A.2070506@oracle.com>
	<20140221091415.GB12506@quack.suse.cz>
Message-ID: <20140221093522.GC12506@quack.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri 21-02-14 10:14:15, Jan Kara wrote:
> On Thu 20-02-14 21:21:14, Srinivas Eeda wrote:
> > I like the idea of dc_task handling queued basts in
> > ocfs2_mark_lockres_freeing.
> > 
> > I am wondering if we should call lockres->l_ops->post_unlock(osb,
> > lockres) ? Would there be another node waiting for a bast response ?
>   Ah, right. Somehow I missed that. I'll send fixed version in a moment.
  Actually it doesn't matter in practice because the locks for which we can
hit this path don't have ->post_unlock() method. But still I agree we
should be consistent.

 								Honza
> > 
> > On 02/20/2014 07:18 AM, Jan Kara wrote:
> > >If we are dropping last inode reference from downconvert thread, we will
> > >end up calling ocfs2_mark_lockres_freeing() which can block if the lock
> > >we are freeing is queued thus creating an A-A deadlock. Luckily, since
> > >we are the downconvert thread, we can immediately dequeue the lock and
> > >thus avoid waiting in this case.
> > >
> > >Signed-off-by: Jan Kara <jack@suse.cz>
> > >---
> > >  fs/ocfs2/dlmglue.c | 33 +++++++++++++++++++++++++++++++--
> > >  fs/ocfs2/dlmglue.h |  3 ++-
> > >  fs/ocfs2/inode.c   |  7 ++++---
> > >  3 files changed, 37 insertions(+), 6 deletions(-)
> > >
> > >diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> > >index 19986959d149..b7580157ef01 100644
> > >--- a/fs/ocfs2/dlmglue.c
> > >+++ b/fs/ocfs2/dlmglue.c
> > >@@ -3150,7 +3150,8 @@ out:
> > >   * it safe to drop.
> > >   *
> > >   * You can *not* attempt to call cluster_lock on this lockres anymore. */
> > >-void ocfs2_mark_lockres_freeing(struct ocfs2_lock_res *lockres)
> > >+void ocfs2_mark_lockres_freeing(struct ocfs2_super *osb,
> > >+				struct ocfs2_lock_res *lockres)
> > >  {
> > >  	int status;
> > >  	struct ocfs2_mask_waiter mw;
> > >@@ -3160,6 +3161,33 @@ void ocfs2_mark_lockres_freeing(struct ocfs2_lock_res *lockres)
> > >  	spin_lock_irqsave(&lockres->l_lock, flags);
> > >  	lockres->l_flags |= OCFS2_LOCK_FREEING;
> > >+	if (lockres->l_flags & OCFS2_LOCK_QUEUED && current == osb->dc_task) {
> > >+		unsigned long flags;
> > >+
> > >+		/*
> > >+		 * We know the downconvert is queued but not in progress
> > >+		 * because we are the downconvert thread and processing
> > >+		 * different lock. So we can just remove the lock from the
> > >+		 * queue. This is not only an optimization but also a way
> > >+		 * to avoid the following deadlock:
> > >+		 *   ocfs2_dentry_post_unlock()
> > >+		 *     ocfs2_dentry_lock_put()
> > >+		 *       ocfs2_drop_dentry_lock()
> > >+		 *         iput()
> > >+		 *           ocfs2_evict_inode()
> > >+		 *             ocfs2_clear_inode()
> > >+		 *               ocfs2_mark_lockres_freeing()
> > >+		 *                 ... blocks waiting for OCFS2_LOCK_QUEUED
> > >+		 *                 since we are the downconvert thread which
> > >+		 *                 should clear the flag.
> > >+		 */
> > >+		spin_lock_irqsave(&osb->dc_task_lock, flags);
> > >+		list_del_init(&lockres->l_blocked_list);
> > >+		osb->blocked_lock_count--;
> > >+		spin_unlock_irqrestore(&osb->dc_task_lock, flags);
> > >+		lockres_clear_flags(lockres, OCFS2_LOCK_QUEUED);
> > >+		goto out_unlock;
> > >+	}
> > >  	while (lockres->l_flags & OCFS2_LOCK_QUEUED) {
> > >  		lockres_add_mask_waiter(lockres, &mw, OCFS2_LOCK_QUEUED, 0);
> > >  		spin_unlock_irqrestore(&lockres->l_lock, flags);
> > >@@ -3172,6 +3200,7 @@ void ocfs2_mark_lockres_freeing(struct ocfs2_lock_res *lockres)
> > >  		spin_lock_irqsave(&lockres->l_lock, flags);
> > >  	}
> > >+out_unlock:
> > >  	spin_unlock_irqrestore(&lockres->l_lock, flags);
> > >  }
> > >@@ -3180,7 +3209,7 @@ void ocfs2_simple_drop_lockres(struct ocfs2_super *osb,
> > >  {
> > >  	int ret;
> > >-	ocfs2_mark_lockres_freeing(lockres);
> > >+	ocfs2_mark_lockres_freeing(osb, lockres);
> > >  	ret = ocfs2_drop_lock(osb, lockres);
> > >  	if (ret)
> > >  		mlog_errno(ret);
> > >diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
> > >index 1d596d8c4a4a..d293a22c32c5 100644
> > >--- a/fs/ocfs2/dlmglue.h
> > >+++ b/fs/ocfs2/dlmglue.h
> > >@@ -157,7 +157,8 @@ int ocfs2_refcount_lock(struct ocfs2_refcount_tree *ref_tree, int ex);
> > >  void ocfs2_refcount_unlock(struct ocfs2_refcount_tree *ref_tree, int ex);
> > >-void ocfs2_mark_lockres_freeing(struct ocfs2_lock_res *lockres);
> > >+void ocfs2_mark_lockres_freeing(struct ocfs2_super *osb,
> > >+				struct ocfs2_lock_res *lockres);
> > >  void ocfs2_simple_drop_lockres(struct ocfs2_super *osb,
> > >  			       struct ocfs2_lock_res *lockres);
> > >diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> > >index 3b0d722de35e..9661f8db21dc 100644
> > >--- a/fs/ocfs2/inode.c
> > >+++ b/fs/ocfs2/inode.c
> > >@@ -1053,6 +1053,7 @@ static void ocfs2_clear_inode(struct inode *inode)
> > >  {
> > >  	int status;
> > >  	struct ocfs2_inode_info *oi = OCFS2_I(inode);
> > >+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> > >  	clear_inode(inode);
> > >  	trace_ocfs2_clear_inode((unsigned long long)oi->ip_blkno,
> > >@@ -1069,9 +1070,9 @@ static void ocfs2_clear_inode(struct inode *inode)
> > >  	/* Do these before all the other work so that we don't bounce
> > >  	 * the downconvert thread while waiting to destroy the locks. */
> > >-	ocfs2_mark_lockres_freeing(&oi->ip_rw_lockres);
> > >-	ocfs2_mark_lockres_freeing(&oi->ip_inode_lockres);
> > >-	ocfs2_mark_lockres_freeing(&oi->ip_open_lockres);
> > >+	ocfs2_mark_lockres_freeing(osb, &oi->ip_rw_lockres);
> > >+	ocfs2_mark_lockres_freeing(osb, &oi->ip_inode_lockres);
> > >+	ocfs2_mark_lockres_freeing(osb, &oi->ip_open_lockres);
> > >  	ocfs2_resv_discard(&OCFS2_SB(inode->i_sb)->osb_la_resmap,
> > >  			   &oi->ip_la_data_resv);
> > 
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
