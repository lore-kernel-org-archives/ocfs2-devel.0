From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 14 May 2010 22:50:54 +0800
Subject: [Ocfs2-devel] Deadlock in DLM code still there
In-Reply-To: <20100513194320.GA28367@quack.suse.cz>
References: <20100513194320.GA28367@quack.suse.cz>
Message-ID: <20100514145054.GA3431@laptop.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

On 10-05-13 21:43, Jan Kara wrote:
>   Hi,
> 
>   in http://www.mail-archive.com/ocfs2-devel at oss.oracle.com/msg03188.html
> (more than an year ago) I've reported a lock inversion between dlm->ast_lock
> and res->spinlock. The deadlock seems to be still there in 2.6.34-rc7:
> 
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.34-rc7-xen #4
> -------------------------------------------------------
> dlm_thread/2001 is trying to acquire lock:
>  (&(&dlm->ast_lock)->rlock){+.+...}, at: [<ffffffffa0119785>] dlm_queue_bast+0x55/0x1e0 [ocfs2_dlm]
> 
> but task is already holding lock:
>  (&(&res->spinlock)->rlock){+.+...}, at: [<ffffffffa010452d>] dlm_thread+0x7cd/0x17f0 [ocfs2_dlm]
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (&(&res->spinlock)->rlock){+.+...}:
>        [<ffffffff810746bf>] __lock_acquire+0x109f/0x1720
>        [<ffffffff81074da9>] lock_acquire+0x69/0x90
>        [<ffffffff81328c6c>] _raw_spin_lock+0x2c/0x40
>        [<ffffffff8117e158>] _atomic_dec_and_lock+0x78/0xa0
>        [<ffffffffa010ebb9>] dlm_lockres_release_ast+0x29/0xb0 [ocfs2_dlm]
>        [<ffffffffa0104e41>] dlm_thread+0x10e1/0x17f0 [ocfs2_dlm]
>        [<ffffffff81060e1e>] kthread+0x8e/0xa0
>        [<ffffffff8100bda4>] kernel_thread_helper+0x4/0x10
> 
> -> #0 (&(&dlm->ast_lock)->rlock){+.+...}:
>        [<ffffffff81074b18>] __lock_acquire+0x14f8/0x1720
>        [<ffffffff81074da9>] lock_acquire+0x69/0x90
>        [<ffffffff81328c6c>] _raw_spin_lock+0x2c/0x40
>        [<ffffffffa0119785>] dlm_queue_bast+0x55/0x1e0 [ocfs2_dlm]
>        [<ffffffffa010494f>] dlm_thread+0xbef/0x17f0 [ocfs2_dlm]
>        [<ffffffff81060e1e>] kthread+0x8e/0xa0
>        [<ffffffff8100bda4>] kernel_thread_helper+0x4/0x10

The code path is simple:
in dlm_thread()
677                         spin_lock(&res->spinlock);
			    .......
714                         /* called while holding lockres lock */
715                         dlm_shuffle_lists(dlm, res);	
716                         res->state &= ~DLM_LOCK_RES_DIRTY;
717                         spin_unlock(&res->spinlock);

In dlm_shuffle_lists(), dlm_queue_bast()/dlm_queue_ast() are called.
In the later two functions, dlm->ast_lock is required.
Since we can't release res->spinlock, we have to take dlm->ast_lock
just before taking the res->spinlock(line 677) and release it after
res->spinlock is released. And use __dlm_queue_bast()/__dlm_queue_ast(),
the nolock version, in dlm_shuffle_lists().
There are no too many locks on a lockres, I think there is no performance
harm.
Comments?

Attached the patch(not well tested yet, will be tested if this approach is good).
At least with this patch Jan can continue with his test :P

Regards,
wengang.
-------------- next part --------------
diff --git a/fs/ocfs2/dlm/dlmast.c b/fs/ocfs2/dlm/dlmast.c
index 12d5eb7..992b0ae 100644
--- a/fs/ocfs2/dlm/dlmast.c
+++ b/fs/ocfs2/dlm/dlmast.c
@@ -88,7 +88,7 @@ static int dlm_should_cancel_bast(struct dlm_ctxt *dlm, struct dlm_lock *lock)
 	return 0;
 }
 
-static void __dlm_queue_ast(struct dlm_ctxt *dlm, struct dlm_lock *lock)
+void __dlm_queue_ast(struct dlm_ctxt *dlm, struct dlm_lock *lock)
 {
 	mlog_entry_void();
 
@@ -145,7 +145,7 @@ void dlm_queue_ast(struct dlm_ctxt *dlm, struct dlm_lock *lock)
 }
 
 
-static void __dlm_queue_bast(struct dlm_ctxt *dlm, struct dlm_lock *lock)
+void __dlm_queue_bast(struct dlm_ctxt *dlm, struct dlm_lock *lock)
 {
 	mlog_entry_void();
 
diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index 0102be3..453d955 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -904,6 +904,8 @@ void __dlm_lockres_grab_inflight_ref(struct dlm_ctxt *dlm,
 
 void dlm_queue_ast(struct dlm_ctxt *dlm, struct dlm_lock *lock);
 void dlm_queue_bast(struct dlm_ctxt *dlm, struct dlm_lock *lock);
+void __dlm_queue_ast(struct dlm_ctxt *dlm, struct dlm_lock *lock);
+void __dlm_queue_bast(struct dlm_ctxt *dlm, struct dlm_lock *lock);
 void dlm_do_local_ast(struct dlm_ctxt *dlm,
 		      struct dlm_lock_resource *res,
 		      struct dlm_lock *lock);
diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
index 11a6d1f..d4f73ca 100644
--- a/fs/ocfs2/dlm/dlmthread.c
+++ b/fs/ocfs2/dlm/dlmthread.c
@@ -309,6 +309,7 @@ static void dlm_shuffle_lists(struct dlm_ctxt *dlm,
 	 * spinlock, and because we know that it is not migrating/
 	 * recovering/in-progress, it is fine to reserve asts and
 	 * basts right before queueing them all throughout */
+	assert_spin_locked(&dlm->ast_lock);
 	assert_spin_locked(&res->spinlock);
 	BUG_ON((res->state & (DLM_LOCK_RES_MIGRATING|
 			      DLM_LOCK_RES_RECOVERING|
@@ -337,7 +338,7 @@ converting:
 			/* queue the BAST if not already */
 			if (lock->ml.highest_blocked == LKM_IVMODE) {
 				__dlm_lockres_reserve_ast(res);
-				dlm_queue_bast(dlm, lock);
+				__dlm_queue_bast(dlm, lock);
 			}
 			/* update the highest_blocked if needed */
 			if (lock->ml.highest_blocked < target->ml.convert_type)
@@ -355,7 +356,7 @@ converting:
 			can_grant = 0;
 			if (lock->ml.highest_blocked == LKM_IVMODE) {
 				__dlm_lockres_reserve_ast(res);
-				dlm_queue_bast(dlm, lock);
+				__dlm_queue_bast(dlm, lock);
 			}
 			if (lock->ml.highest_blocked < target->ml.convert_type)
 				lock->ml.highest_blocked =
@@ -383,7 +384,7 @@ converting:
 		spin_unlock(&target->spinlock);
 
 		__dlm_lockres_reserve_ast(res);
-		dlm_queue_ast(dlm, target);
+		__dlm_queue_ast(dlm, target);
 		/* go back and check for more */
 		goto converting;
 	}
@@ -402,7 +403,7 @@ blocked:
 			can_grant = 0;
 			if (lock->ml.highest_blocked == LKM_IVMODE) {
 				__dlm_lockres_reserve_ast(res);
-				dlm_queue_bast(dlm, lock);
+				__dlm_queue_bast(dlm, lock);
 			}
 			if (lock->ml.highest_blocked < target->ml.type)
 				lock->ml.highest_blocked = target->ml.type;
@@ -418,7 +419,7 @@ blocked:
 			can_grant = 0;
 			if (lock->ml.highest_blocked == LKM_IVMODE) {
 				__dlm_lockres_reserve_ast(res);
-				dlm_queue_bast(dlm, lock);
+				__dlm_queue_bast(dlm, lock);
 			}
 			if (lock->ml.highest_blocked < target->ml.type)
 				lock->ml.highest_blocked = target->ml.type;
@@ -444,7 +445,7 @@ blocked:
 		spin_unlock(&target->spinlock);
 
 		__dlm_lockres_reserve_ast(res);
-		dlm_queue_ast(dlm, target);
+		__dlm_queue_ast(dlm, target);
 		/* go back and check for more */
 		goto converting;
 	}
@@ -674,6 +675,7 @@ static int dlm_thread(void *data)
 		 	/* lockres can be re-dirtied/re-added to the
 			 * dirty_list in this gap, but that is ok */
 
+			spin_lock(&dlm->ast_lock);
 			spin_lock(&res->spinlock);
 			if (res->owner != dlm->node_num) {
 				__dlm_print_one_lock_resource(res);
@@ -694,6 +696,7 @@ static int dlm_thread(void *data)
 				/* move it to the tail and keep going */
 				res->state &= ~DLM_LOCK_RES_DIRTY;
 				spin_unlock(&res->spinlock);
+				spin_unlock(&dlm->ast_lock);
 				mlog(0, "delaying list shuffling for in-"
 				     "progress lockres %.*s, state=%d\n",
 				     res->lockname.len, res->lockname.name,
@@ -715,6 +718,7 @@ static int dlm_thread(void *data)
 			dlm_shuffle_lists(dlm, res);
 			res->state &= ~DLM_LOCK_RES_DIRTY;
 			spin_unlock(&res->spinlock);
+			spin_unlock(&dlm->ast_lock);
 
 			dlm_lockres_calc_usage(dlm, res);
 
