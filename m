From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Mon, 14 Dec 2015 09:57:38 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: dlm: fix recursive locking deadlock
Message-ID: <1450058259-30682-1-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following locking order can cause a deadlock.
Process A on Node X:                 Process B on Node Y:
lock_XYZ(PR)
                                     lock_XYZ(EX)
lock_XYZ(PR) >>> blocked forever by OCFS2_LOCK_BLOCKED.

Use ocfs2-test multiple reflink test can reproduce this on v4.3 kernel,
the whole cluster hung, and get the following call trace.

 INFO: task multi_reflink_t:10118 blocked for more than 120 seconds.
       Tainted: G           OE   4.3.0 #1
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 multi_reflink_t D ffff88003e816980     0 10118  10117 0x00000080
  ffff880005b735f8 0000000000000082 ffffffff81a25500 ffff88003e750000
  ffff880005b735c8 ffffffff8117992f ffffea0000929f80 ffff88003e816980
  7fffffffffffffff 0000000000000000 0000000000000001 ffffea0000929f80
 Call Trace:
  [<ffffffff8117992f>] ? find_get_entry+0x2f/0xc0
  [<ffffffff816a68fe>] schedule+0x3e/0x80
  [<ffffffff816a9358>] schedule_timeout+0x1c8/0x220
  [<ffffffffa067eee4>] ? ocfs2_inode_cache_unlock+0x14/0x20 [ocfs2]
  [<ffffffffa06bb1e9>] ? ocfs2_metadata_cache_unlock+0x19/0x30 [ocfs2]
  [<ffffffffa06bb399>] ? ocfs2_buffer_cached+0x99/0x170 [ocfs2]
  [<ffffffffa067eee4>] ? ocfs2_inode_cache_unlock+0x14/0x20 [ocfs2]
  [<ffffffffa06bb1e9>] ? ocfs2_metadata_cache_unlock+0x19/0x30 [ocfs2]
  [<ffffffff810c5f41>] ? __raw_callee_save___pv_queued_spin_unlock+0x11/0x20
  [<ffffffff816a78ae>] wait_for_completion+0xde/0x110
  [<ffffffff810a81b0>] ? try_to_wake_up+0x240/0x240
  [<ffffffffa066f65d>] __ocfs2_cluster_lock+0x20d/0x720 [ocfs2]
  [<ffffffff810c5f41>] ? __raw_callee_save___pv_queued_spin_unlock+0x11/0x20
  [<ffffffffa0674841>] ocfs2_inode_lock_full_nested+0x181/0x400 [ocfs2]
  [<ffffffffa06d0db3>] ? ocfs2_iop_get_acl+0x53/0x113 [ocfs2]
  [<ffffffff81210cd2>] ? igrab+0x42/0x70
  [<ffffffffa06d0db3>] ocfs2_iop_get_acl+0x53/0x113 [ocfs2]
  [<ffffffff81254583>] get_acl+0x53/0x70
  [<ffffffff81254923>] posix_acl_create+0x73/0x130
  [<ffffffffa068f0bf>] ocfs2_mknod+0x7cf/0x1140 [ocfs2]
  [<ffffffffa068fba2>] ocfs2_create+0x62/0x110 [ocfs2]
  [<ffffffff8120be25>] ? __d_alloc+0x65/0x190
  [<ffffffff81201b3e>] ? __inode_permission+0x4e/0xd0
  [<ffffffff81202cf5>] vfs_create+0xd5/0x100
  [<ffffffff812009ed>] ? lookup_real+0x1d/0x60
  [<ffffffff81203a03>] lookup_open+0x173/0x1a0
  [<ffffffff810c59c6>] ? percpu_down_read+0x16/0x70
  [<ffffffff81205fea>] do_last+0x31a/0x830
  [<ffffffff81201b3e>] ? __inode_permission+0x4e/0xd0
  [<ffffffff81201bd8>] ? inode_permission+0x18/0x50
  [<ffffffff812046b0>] ? link_path_walk+0x290/0x550
  [<ffffffff8120657c>] path_openat+0x7c/0x140
  [<ffffffff812066c5>] do_filp_open+0x85/0xe0
  [<ffffffff8120190f>] ? getname_flags+0x7f/0x1f0
  [<ffffffff811f613a>] do_sys_open+0x11a/0x220
  [<ffffffff8100374b>] ? syscall_trace_enter_phase1+0x15b/0x170
  [<ffffffff811f627e>] SyS_open+0x1e/0x20
  [<ffffffff816aa2ae>] entry_SYSCALL_64_fastpath+0x12/0x71

commit 743b5f1434f5 ("ocfs2: take inode lock in ocfs2_iop_set/get_acl()")
add a recursive locking to ocfs2_mknod() which exports this deadlock, but
indeed this is a common issue, it can be triggered in other place.

Record processes who owned the cluster lock, allow recursive lock to go
can fix PR+PR, EX+EX, EX+PR deadlock. But it can't fix the PR+EX deadlock,
to avoid this, the second EX locking must use non-block way.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 fs/ocfs2/dlmglue.c |  209 ++++++++++++++++++++++++++++++++++++++++++++++++----
 fs/ocfs2/ocfs2.h   |   15 ++++
 2 files changed, 211 insertions(+), 13 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 1c91103..e46be46 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -33,6 +33,7 @@
 #include <linux/seq_file.h>
 #include <linux/time.h>
 #include <linux/quotaops.h>
+#include <linux/delay.h>
 
 #define MLOG_MASK_PREFIX ML_DLM_GLUE
 #include <cluster/masklog.h>
@@ -115,6 +116,7 @@ static int ocfs2_check_refcount_downconvert(struct ocfs2_lock_res *lockres,
 					    int new_level);
 static int ocfs2_refcount_convert_worker(struct ocfs2_lock_res *lockres,
 					 int blocking);
+static int ocfs2_is_recursive_lock(struct ocfs2_lock_res *lockres);
 
 #define mlog_meta_lvb(__level, __lockres) ocfs2_dump_meta_lvb_info(__level, __PRETTY_FUNCTION__, __LINE__, __lockres)
 
@@ -341,8 +343,9 @@ static int ocfs2_lock_create(struct ocfs2_super *osb,
 			     struct ocfs2_lock_res *lockres,
 			     int level,
 			     u32 dlm_flags);
-static inline int ocfs2_may_continue_on_blocked_lock(struct ocfs2_lock_res *lockres,
-						     int wanted);
+static inline int
+ocfs2_may_continue_on_blocked_lock(struct ocfs2_lock_res *lockres,
+				   int wanted, int nonblock, int *canwait);
 static void __ocfs2_cluster_unlock(struct ocfs2_super *osb,
 				   struct ocfs2_lock_res *lockres,
 				   int level, unsigned long caller_ip);
@@ -531,6 +534,7 @@ void ocfs2_lock_res_init_once(struct ocfs2_lock_res *res)
 	init_waitqueue_head(&res->l_event);
 	INIT_LIST_HEAD(&res->l_blocked_list);
 	INIT_LIST_HEAD(&res->l_mask_waiters);
+	INIT_LIST_HEAD(&res->l_owner_list);
 }
 
 void ocfs2_inode_lock_res_init(struct ocfs2_lock_res *res,
@@ -782,6 +786,10 @@ static inline void ocfs2_dec_holders(struct ocfs2_lock_res *lockres,
 	default:
 		BUG();
 	}
+
+	/* l_owner_list should be empty if no holders. */
+	BUG_ON(!lockres->l_ex_holders && !lockres->l_ro_holders \
+		&& !list_empty(&lockres->l_owner_list));
 }
 
 /* WARNING: This function lives in a world where the only three lock
@@ -1287,15 +1295,37 @@ static inline void ocfs2_wait_on_refreshing_lock(struct ocfs2_lock_res *lockres)
 		   !ocfs2_check_wait_flag(lockres, OCFS2_LOCK_REFRESHING));
 }
 
-/* predict what lock level we'll be dropping down to on behalf
- * of another node, and return true if the currently wanted
- * level will be compatible with it. */
-static inline int ocfs2_may_continue_on_blocked_lock(struct ocfs2_lock_res *lockres,
-						     int wanted)
+/* If wanted level is compatible with blocked one, then allow it go.
+ * To avoid deadlock, recursive locking should be let go. An exception
+ * is block asking for PR+EX recursive lock, it is not supported, the
+ * second EX locking should use nonblock way, or will cause deadlock.
+ */
+static inline int
+ocfs2_may_continue_on_blocked_lock(struct ocfs2_lock_res *lockres,
+				   int wanted, int nonblock, int *canwait)
 {
 	BUG_ON(!(lockres->l_flags & OCFS2_LOCK_BLOCKED));
 
-	return wanted <= ocfs2_highest_compat_lock_level(lockres->l_blocking);
+	*canwait = 1;
+	if (wanted <= ocfs2_highest_compat_lock_level(lockres->l_blocking))
+		return 1;
+
+	/* non-recursive lock not allowed to go to avoid possible
+	 * starvation of blocked node.
+	 */
+	if (!ocfs2_is_recursive_lock(lockres))
+		return 0;
+
+	/* block asking for PR+EX recursive lock not allowed. */
+	if (lockres->l_level == DLM_LOCK_PR && wanted == DLM_LOCK_EX
+		&& !nonblock) {
+		*canwait = 0;
+		mlog(ML_ERROR, "block asking for PR+EX recursive lock not allowed.\n");
+		return 0;
+
+	}
+
+	return 1;
 }
 
 static void ocfs2_init_mask_waiter(struct ocfs2_mask_waiter *mw)
@@ -1375,6 +1405,131 @@ static int ocfs2_wait_for_mask_interruptible(struct ocfs2_mask_waiter *mw,
 	return ret;
 }
 
+static struct ocfs2_pid_locking *ocfs2_alloc_pid_locking(void)
+{
+	struct ocfs2_pid_locking *pid_locking;
+
+retry:
+	pid_locking = kmalloc(sizeof(struct ocfs2_pid_locking), GFP_NOFS);
+	if (!pid_locking) {
+		msleep(100);
+		goto retry;
+	}
+
+	INIT_LIST_HEAD(&pid_locking->next);
+	pid_locking->ro_holders = 0;
+	pid_locking->ex_holders = 0;
+	pid_locking->pid = current->pid;
+
+	return pid_locking;
+}
+
+static void ocfs2_free_pid_locking(struct ocfs2_pid_locking *pid_locking)
+{
+	list_del(&pid_locking->next);
+	kfree(pid_locking);
+}
+
+static struct ocfs2_pid_locking *
+ocfs2_find_pid_locking(struct ocfs2_lock_res *lockres)
+{
+	struct ocfs2_pid_locking *pid_locking;
+
+	list_for_each_entry(pid_locking, &lockres->l_owner_list, next) {
+		if (pid_locking->pid == current->pid)
+			return pid_locking;
+	}
+
+	return NULL;
+}
+
+static void
+ocfs2_pid_locking_update_holder(struct ocfs2_pid_locking *pid_locking,
+				int level, int lock)
+{
+	if (level == DLM_LOCK_EX) {
+		if (lock)
+			pid_locking->ex_holders++;
+		else
+			pid_locking->ex_holders--;
+	} else if (level == DLM_LOCK_PR) {
+		if (lock)
+			pid_locking->ro_holders++;
+		else
+			pid_locking->ro_holders--;
+	} else
+		BUG();
+}
+
+static void ocfs2_pid_locking_update(struct ocfs2_lock_res *lockres,
+		struct ocfs2_pid_locking *pid_locking, int level, int lock)
+{
+	/* new alloced pid_locking linked to l_owner_list. */
+	if (!pid_locking->ro_holders && !pid_locking->ex_holders)
+		list_add_tail(&pid_locking->next, &lockres->l_owner_list);
+
+	ocfs2_pid_locking_update_holder(pid_locking, level, lock);
+}
+
+static void ocfs2_get_pid_locking(struct ocfs2_lock_res *lockres,
+			struct ocfs2_pid_locking *pid_locking, int level)
+{
+	ocfs2_pid_locking_update(lockres, pid_locking, level, 1);
+}
+
+static void ocfs2_put_pid_locking(struct ocfs2_lock_res *lockres,
+			struct ocfs2_pid_locking *pid_locking, int level)
+{
+	struct ocfs2_pid_locking *plocking, *next;
+	struct list_head *head = &lockres->l_owner_list;
+	int total_ro_holders = 0, total_ex_holders = 0;
+
+	ocfs2_pid_locking_update(lockres, pid_locking, level, 0);
+
+	/* free unused pid locking. */
+	if (!pid_locking->ro_holders && !pid_locking->ex_holders) {
+		ocfs2_free_pid_locking(pid_locking);
+		return;
+	}
+
+	/* If get here, it means lock/unlock happened in different processes,
+	 * or a bug where unlock happened without lock first. Let check.
+	 */
+	list_for_each_entry(plocking, head, next) {
+		total_ro_holders += plocking->ro_holders;
+		total_ex_holders += plocking->ex_holders;
+	}
+
+	/* locked and unlocked in different processs, the lock is not hold now,
+	 * free all pid_locking entries.
+	 */
+	if (!total_ro_holders && !total_ex_holders) {
+		list_for_each_entry_safe(plocking, next, head, next) {
+			ocfs2_free_pid_locking(plocking);
+		}
+	} else if (total_ro_holders < 0 || total_ex_holders < 0) {
+		mlog(ML_ERROR, "lockres %s unlocked but not locked first.\n",
+			lockres->l_name);
+		BUG();
+	}
+}
+
+/* lock at least twice before unlock in one process is recursive locking. */
+static int ocfs2_is_recursive_lock(struct ocfs2_lock_res *lockres)
+{
+	struct ocfs2_pid_locking *pid_locking;
+
+	list_for_each_entry(pid_locking, &lockres->l_owner_list, next) {
+		if (pid_locking->pid != current->pid)
+			continue;
+
+		return (pid_locking->ro_holders > 0 ||
+			pid_locking->ex_holders > 0);
+	}
+
+	return 0;
+}
+
 static int __ocfs2_cluster_lock(struct ocfs2_super *osb,
 				struct ocfs2_lock_res *lockres,
 				int level,
@@ -1390,6 +1545,9 @@ static int __ocfs2_cluster_lock(struct ocfs2_super *osb,
 	unsigned int gen;
 	int noqueue_attempted = 0;
 	int dlm_locked = 0;
+	struct ocfs2_pid_locking *pid_locking = NULL;
+	int canwait = 1;
+	int nonblock = arg_flags & OCFS2_LOCK_NONBLOCK;
 
 	if (!(lockres->l_flags & OCFS2_LOCK_INITIALIZED)) {
 		mlog_errno(-EINVAL);
@@ -1405,6 +1563,14 @@ again:
 	wait = 0;
 
 	spin_lock_irqsave(&lockres->l_lock, flags);
+	if (!pid_locking) {
+		pid_locking = ocfs2_find_pid_locking(lockres);
+		if (!pid_locking) {
+			spin_unlock_irqrestore(&lockres->l_lock, flags);
+			pid_locking = ocfs2_alloc_pid_locking();
+			spin_lock_irqsave(&lockres->l_lock, flags);
+		}
+	}
 
 	if (catch_signals && signal_pending(current)) {
 		ret = -ERESTARTSYS;
@@ -1447,7 +1613,8 @@ again:
 	}
 
 	if (lockres->l_flags & OCFS2_LOCK_BLOCKED &&
-	    !ocfs2_may_continue_on_blocked_lock(lockres, level)) {
+	    !ocfs2_may_continue_on_blocked_lock(lockres, level,
+						nonblock, &canwait)) {
 		/* is the lock is currently blocked on behalf of
 		 * another node */
 		lockres_add_mask_waiter(lockres, &mw, OCFS2_LOCK_BLOCKED, 0);
@@ -1519,6 +1686,7 @@ again:
 update_holders:
 	/* Ok, if we get here then we're good to go. */
 	ocfs2_inc_holders(lockres, level);
+	ocfs2_get_pid_locking(lockres, pid_locking, level);
 
 	ret = 0;
 unlock:
@@ -1534,7 +1702,7 @@ out:
 	 * This block is helping an aop path notice the inversion and back
 	 * off to unlock its page lock before trying the dlm lock again.
 	 */
-	if (wait && arg_flags & OCFS2_LOCK_NONBLOCK &&
+	if (wait && nonblock &&
 	    mw.mw_mask & (OCFS2_LOCK_BUSY|OCFS2_LOCK_BLOCKED)) {
 		wait = 0;
 		spin_lock_irqsave(&lockres->l_lock, flags);
@@ -1550,9 +1718,12 @@ out:
 		}
 	}
 	if (wait) {
-		ret = ocfs2_wait_for_mask(&mw);
-		if (ret == 0)
-			goto again;
+		if (canwait) {
+			ret = ocfs2_wait_for_mask(&mw);
+			if (ret == 0)
+				goto again;
+		} else
+			ret = -EPERM;
 		mlog_errno(ret);
 	}
 	ocfs2_update_lock_stats(lockres, level, &mw, ret);
@@ -1569,6 +1740,10 @@ out:
 				caller_ip);
 	}
 #endif
+	/* free unused pid_locking if error. */
+	if (ret && !pid_locking->ro_holders && !pid_locking->ex_holders)
+		ocfs2_free_pid_locking(pid_locking);
+
 	return ret;
 }
 
@@ -1589,8 +1764,16 @@ static void __ocfs2_cluster_unlock(struct ocfs2_super *osb,
 				   unsigned long caller_ip)
 {
 	unsigned long flags;
+	struct ocfs2_pid_locking *pid_locking;
 
 	spin_lock_irqsave(&lockres->l_lock, flags);
+	pid_locking = ocfs2_find_pid_locking(lockres);
+	if (!pid_locking) {
+		spin_unlock_irqrestore(&lockres->l_lock, flags);
+		pid_locking = ocfs2_alloc_pid_locking();
+		spin_lock_irqsave(&lockres->l_lock, flags);
+	}
+	ocfs2_put_pid_locking(lockres, pid_locking, level);
 	ocfs2_dec_holders(lockres, level);
 	ocfs2_downconvert_on_unlock(osb, lockres);
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 7a01262..bf80fb7 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -165,6 +165,19 @@ struct ocfs2_lock_stats {
 };
 #endif
 
+/* locking stat of processes. */
+struct ocfs2_pid_locking {
+	/* used to link into lockres->l_owner_list. */
+	struct list_head next;
+	/* inc by 1 when lock PR and dec by 1 when unlock PR. It could be
+	 * negative number if lock/unlock happened in different processes.
+	 */
+	int ro_holders;
+	int ex_holders;
+	/* the process who is using this lock. */
+	pid_t pid;
+};
+
 struct ocfs2_lock_res {
 	void                    *l_priv;
 	struct ocfs2_lock_res_ops *l_ops;
@@ -207,6 +220,8 @@ struct ocfs2_lock_res {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	 l_lockdep_map;
 #endif
+	/* save all processes who owned this lock. */
+	struct list_head	 l_owner_list;
 };
 
 enum ocfs2_orphan_reco_type {
-- 
1.7.9.5
