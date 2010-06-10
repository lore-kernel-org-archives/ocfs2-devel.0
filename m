From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 10 Jun 2010 20:33:40 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: remove lockres from purge when
 a lock is added
In-Reply-To: <4C10B3DE.2000009@oracle.com>
References: <201006081440.o58DK84i023006@rcsinet13.oracle.com>
	<4C10B3DE.2000009@oracle.com>
Message-ID: <20100610123340.GA4658@laptop.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Srini, thanks for review!

On 10-06-10 02:43, Srinivas Eeda wrote:
> Wengang, thanks for the patch. My comments are inline :)
> 
> On 6/8/2010 7:38 AM, Wengang Wang wrote:
> >dlm_thread(when purges a lockres) races with another thread that is running on
> >dlmlock_remote(). dlmlock_remote() can add a lock to the blocked list of the
> >lockres without taking dlm->spinlock. This can lead a BUG() in dlm_thread because
> >of the added lock.
> >
> >Fix
> >We take dlm->spinlock when adding a lock to the blocked list and make sure the
> >lockres is not in purge list. If we removed the lockres from purge list, try to
> >add it back.
> >
> >Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> >---
> > fs/ocfs2/dlm/dlmcommon.h |   15 +++++++++++++++
> > fs/ocfs2/dlm/dlmlock.c   |   18 +++++++++++++++---
> > fs/ocfs2/dlm/dlmthread.c |   28 ++++++++++++++++++++++++++++
> > 3 files changed, 58 insertions(+), 3 deletions(-)
> >
> >diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
> >index 4b6ae2c..134973a 100644
> >--- a/fs/ocfs2/dlm/dlmcommon.h
> >+++ b/fs/ocfs2/dlm/dlmcommon.h
> >@@ -1002,6 +1002,9 @@ void dlm_move_lockres_to_recovery_list(struct dlm_ctxt *dlm,
> > /* will exit holding res->spinlock, but may drop in function */
> > void __dlm_wait_on_lockres_flags(struct dlm_lock_resource *res, int flags);
> >+void __dlm_wait_on_lockres_flags_lock_dlm(struct dlm_ctxt *dlm,
> >+					  struct dlm_lock_resource *res,
> >+					  int flags);
> > void __dlm_wait_on_lockres_flags_set(struct dlm_lock_resource *res, int flags);
> > /* will exit holding res->spinlock, but may drop in function */
> >@@ -1012,6 +1015,18 @@ static inline void __dlm_wait_on_lockres(struct dlm_lock_resource *res)
> > 					  DLM_LOCK_RES_MIGRATING));
> > }
> >+/*
> >+ * will exit holding dlm->spinlock and res->spinlock, but may drop in
> >+ * function
> >+ */
> >+static inline void __dlm_wait_on_lockres_lock_dlm(struct dlm_ctxt *dlm,
> >+						  struct dlm_lock_resource *res)
> >+{
> >+	__dlm_wait_on_lockres_flags_lock_dlm(dlm, res,
> >+					     (DLM_LOCK_RES_IN_PROGRESS|
> >+					      DLM_LOCK_RES_RECOVERING|
> >+					      DLM_LOCK_RES_MIGRATING));
> >+}
> > void __dlm_unlink_mle(struct dlm_ctxt *dlm, struct dlm_master_list_entry *mle);
> > void __dlm_insert_mle(struct dlm_ctxt *dlm, struct dlm_master_list_entry *mle);
> >diff --git a/fs/ocfs2/dlm/dlmlock.c b/fs/ocfs2/dlm/dlmlock.c
> >index 69cf369..fb3c178 100644
> >--- a/fs/ocfs2/dlm/dlmlock.c
> >+++ b/fs/ocfs2/dlm/dlmlock.c
> >@@ -222,23 +222,35 @@ static enum dlm_status dlmlock_remote(struct dlm_ctxt *dlm,
> > 				      struct dlm_lock *lock, int flags)
> > {
> > 	enum dlm_status status = DLM_DENIED;
> >-	int lockres_changed = 1;
> >+	int lockres_changed = 1, recalc;
> > 	mlog_entry("type=%d\n", lock->ml.type);
> > 	mlog(0, "lockres %.*s, flags = 0x%x\n", res->lockname.len,
> > 	     res->lockname.name, flags);
> >+	spin_lock(&dlm->spinlock);
> > 	spin_lock(&res->spinlock);
> > 	/* will exit this call with spinlock held */
> >-	__dlm_wait_on_lockres(res);
> >+	__dlm_wait_on_lockres_lock_dlm(dlm, res);
> > 	res->state |= DLM_LOCK_RES_IN_PROGRESS;
> > 	/* add lock to local (secondary) queue */
> > 	dlm_lock_get(lock);
> > 	list_add_tail(&lock->list, &res->blocked);
> > 	lock->lock_pending = 1;
> >+	/*
> >+	 * make sure this lockres is not in purge list if we remove the
> >+	 * lockres from purge list, we try to add it back if locking failed.
> >+	 *
> >+	 * there is a race with dlm_thread purging this lockres.
> >+	 * in this case, it can trigger a BUG() because we added a lock to the
> >+	 * blocked list.
> >+	 */
> >+	recalc = !list_empty(&res->purge);
> >+	__dlm_lockres_calc_usage(dlm, res);
> Thanks for this patch, looks good. A few comments on another
> approach, let me know your thoughts.
> 
> The patch I sent for review marks the lockres to be in use (before
> dlmlock_remote is called) in dlm_get_lockresource. I have to do that
> to protect the lockres from unhashing once it's being used. But
> since lockres is still in purgelist the BUG you mentioned can still
> trigger in dlm_thread.

Yes.

> once a lockres is on purge list there are quite a few cases(case
> this patch is addressing, case the patch I just sent for review is
> addresing, and the case of the recovery) that can trigger the
> lockres to be reused, before or while it is getting purged.
> dlm_thread(dlm_run_purge_list) already expects that a lockres on
> purge list could just getting started to be reused. However it
> doesn't handle the above cases. I think it's better to enhance
> dlm_run_purge_list/dlm_purge_lockres code to handle these cases.
> I'am working on this change.

My thought may be incorrect, just for discuss.
I think we'd better keep the dlm_thread as simple as possible and take care
in the problematic cases. That is remove the lockres from purge list
it's "re-used" and put it back later if needed.
Putting all things to dlm_run_purge_list() will make it complex for
understanding. Say, for the three cases you mentioned above, they involves
AST/"remote lock"/recovery. If we simply remove the BUG()(retry to purge instead),
we can't see such three problems are involved from the code any longer.
And doing well in different threads is "clean" way :)

> There also seems to be a case thats not handled. Assume dlm_thread
> sent deref message and waiting for response, now dlmlock_remote
> removed it from purge list. dlm_thread got response from master and
> continues and unhashes the lockres.

Yes, that's a problem. Avoid unhashing the lockres is not hard. The
problem is what will happen we dropped reference on the master node, but
the lockres on this node is still "in use". The lockres on master node
can disappear and we send request against this lockres. --that's bad.

Also, if the lockres is still in use, in your patch, you leave it in the
purgelist. This can lead to secondary sendings of deref request to the
master. Though this won't cause a BUG() on master or on this node,
it's an incorrect behaviour.
So I think sending deref and unhashing the lockres should be in same "atomic"
action?

regards,
wengang.
> > 	spin_unlock(&res->spinlock);
> >+	spin_unlock(&dlm->spinlock);
> > 	/* spec seems to say that you will get DLM_NORMAL when the lock
> > 	 * has been queued, meaning we need to wait for a reply here. */
> >@@ -282,7 +294,7 @@ static enum dlm_status dlmlock_remote(struct dlm_ctxt *dlm,
> > 	}
> > 	spin_unlock(&res->spinlock);
> >-	if (lockres_changed)
> >+	if (recalc || lockres_changed)
> > 		dlm_lockres_calc_usage(dlm, res);
> > 	wake_up(&res->wq);
> >diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
> >index d4f73ca..8961767 100644
> >--- a/fs/ocfs2/dlm/dlmthread.c
> >+++ b/fs/ocfs2/dlm/dlmthread.c
> >@@ -77,6 +77,34 @@ repeat:
> > 	__set_current_state(TASK_RUNNING);
> > }
> >+/*
> >+ * same as __dlm_wait_on_lockres_flags, but also hold dlm->spinlock on exit and
> >+ * may drop it in function
> >+ */
> >+void __dlm_wait_on_lockres_flags_lock_dlm(struct dlm_ctxt *dlm,
> >+					  struct dlm_lock_resource *res,
> >+					  int flags)
> >+{
> >+	DECLARE_WAITQUEUE(wait, current);
> >+
> >+	assert_spin_locked(&dlm->spinlock);
> >+	assert_spin_locked(&res->spinlock);
> >+
> >+	add_wait_queue(&res->wq, &wait);
> >+repeat:
> >+	set_current_state(TASK_UNINTERRUPTIBLE);
> >+	if (res->state & flags) {
> >+		spin_unlock(&res->spinlock);
> >+		spin_unlock(&dlm->spinlock);
> >+		schedule();
> >+		spin_lock(&dlm->spinlock);
> >+		spin_lock(&res->spinlock);
> >+		goto repeat;
> >+	}
> >+	remove_wait_queue(&res->wq, &wait);
> >+	__set_current_state(TASK_RUNNING);
> >+}
> >+
> > int __dlm_lockres_has_locks(struct dlm_lock_resource *res)
> > {
> > 	if (list_empty(&res->granted) &&
