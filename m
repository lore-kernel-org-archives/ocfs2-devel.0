From: Eric Ren <zren@suse.com>
Date: Wed, 19 Oct 2016 13:19:41 +0800
Subject: [Ocfs2-devel] [DRAFT 1/2] ocfs2/dlmglue: keep track of the
	processes who take/put a cluster lock
In-Reply-To: <1476854382-28101-1-git-send-email-zren@suse.com>
References: <1476854382-28101-1-git-send-email-zren@suse.com>
Message-ID: <1476854382-28101-2-git-send-email-zren@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We are in the situation that we have to avoid recursive cluster locking,
but there is no way to check if a cluster lock has been taken by a
precess already.

Mostly, we can avoid recursive locking by writing code carefully.
However, we found that it's very hard to handle the routines that
are invoked directly by vfs. For instance:

const struct inode_operations ocfs2_file_iops = {
        .permission     = ocfs2_permission,
        .get_acl        = ocfs2_iop_get_acl,
        .set_acl        = ocfs2_iop_set_acl,
};

ocfs2_permission() and ocfs2_iop_get/set_acl() both call ocfs2_inode_lock().
The problem is that the call chain of ocfs2_permission() includes *_acl().

Possibly, there are two solutions I can think of. One way is to
implement the inode permission routine for ocfs2 itself, replacing the
existing generic_permission(); this will bring lots of changes and
involve too many trivial vfs functions into ocfs2 code.

Another way is to keep track of the processes who lock/unlock a cluster
lock. This patch provides ocfs2_is_locked_by_me() for process to check
if the cluster lock has been requested before. This is now only used for
avoiding recursive locking, though it also can help debug cluster locking
issue. Unfortunately, this may incur some performance lost.

Signed-off-by: Eric Ren <zren@suse.com>
---
 fs/ocfs2/dlmglue.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/dlmglue.h | 13 ++++++++++++
 fs/ocfs2/ocfs2.h   |  1 +
 3 files changed, 74 insertions(+)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 83d576f..9f91884 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -532,6 +532,7 @@ void ocfs2_lock_res_init_once(struct ocfs2_lock_res *res)
 	init_waitqueue_head(&res->l_event);
 	INIT_LIST_HEAD(&res->l_blocked_list);
 	INIT_LIST_HEAD(&res->l_mask_waiters);
+	INIT_LIST_HEAD(&res->l_holders);
 }
 
 void ocfs2_inode_lock_res_init(struct ocfs2_lock_res *res,
@@ -749,6 +750,48 @@ void ocfs2_lock_res_free(struct ocfs2_lock_res *res)
 	res->l_flags = 0UL;
 }
 
+static inline void ocfs2_add_holder(struct ocfs2_lock_res *lockres)
+{
+	struct ocfs2_holder *oh = kmalloc(sizeof(struct ocfs2_holder), GFP_KERNEL);
+
+	INIT_LIST_HEAD(&oh->oh_list);
+	oh->oh_lockres = lockres;
+	oh->oh_owner_pid =  get_pid(task_pid(current));
+
+	spin_lock(&lockres->l_lock);
+	list_add_tail(&oh->oh_list, &lockres->l_holders);
+	spin_unlock(&lockres->l_lock);
+}
+
+static inline void ocfs2_remove_holder(struct ocfs2_lock_res *lockres,
+				       struct ocfs2_holder *oh)
+{
+	spin_lock(&lockres->l_lock);
+	list_del(&oh->oh_list);
+	spin_unlock(&lockres->l_lock);
+
+	put_pid(oh->oh_owner_pid);
+	kfree(oh);
+}
+
+struct ocfs2_holder *ocfs2_is_locked_by_me(struct ocfs2_lock_res *lockres)
+{
+	struct ocfs2_holder *oh;
+	struct pid *pid;
+
+	spin_lock(&lockres->l_lock);
+	pid = task_pid(current);
+	list_for_each_entry(oh, &lockres->l_holders, oh_list) {
+		if (oh->oh_owner_pid == pid)
+			goto out;
+	}
+	oh = NULL;
+out:
+	spin_unlock(&lockres->l_lock);
+
+	return oh;
+}
+
 static inline void ocfs2_inc_holders(struct ocfs2_lock_res *lockres,
 				     int level)
 {
@@ -1392,6 +1435,7 @@ static int __ocfs2_cluster_lock(struct ocfs2_super *osb,
 	int noqueue_attempted = 0;
 	int dlm_locked = 0;
 	int kick_dc = 0;
+	struct ocfs2_holder *oh;
 
 	if (!(lockres->l_flags & OCFS2_LOCK_INITIALIZED)) {
 		mlog_errno(-EINVAL);
@@ -1403,6 +1447,14 @@ static int __ocfs2_cluster_lock(struct ocfs2_super *osb,
 	if (lockres->l_ops->flags & LOCK_TYPE_USES_LVB)
 		lkm_flags |= DLM_LKF_VALBLK;
 
+	/* This block is just used to check recursive locking now */
+	oh = ocfs2_is_locked_by_me(lockres);
+	if (unlikely(oh))
+		mlog_bug_on_msg(1, "PID(%d) locks on lockres(%s) recursively\n",
+				pid_nr(oh->oh_owner_pid), lockres->l_name);
+	else
+		ocfs2_add_holder(lockres);
+
 again:
 	wait = 0;
 
@@ -1596,6 +1648,14 @@ static void __ocfs2_cluster_unlock(struct ocfs2_super *osb,
 				   unsigned long caller_ip)
 {
 	unsigned long flags;
+	struct ocfs2_holder *oh = ocfs2_is_locked_by_me(lockres);
+
+	/* This block is just used to check recursive locking now */
+	if (unlikely(!oh))
+		mlog_bug_on_msg(1, "PID(%d) unlock lockres(%s) unnecessarily\n",
+				pid_nr(task_pid(current)), lockres->l_name);
+	else
+		ocfs2_remove_holder(lockres, oh);
 
 	spin_lock_irqsave(&lockres->l_lock, flags);
 	ocfs2_dec_holders(lockres, level);
diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
index d293a22..3b1d4e7 100644
--- a/fs/ocfs2/dlmglue.h
+++ b/fs/ocfs2/dlmglue.h
@@ -70,6 +70,13 @@ struct ocfs2_orphan_scan_lvb {
 	__be32	lvb_os_seqno;
 };
 
+struct ocfs2_holder {
+	struct list_head oh_list;
+
+	struct ocfs2_lock_res *oh_lockres;
+	struct pid *oh_owner_pid;
+};
+
 /* ocfs2_inode_lock_full() 'arg_flags' flags */
 /* don't wait on recovery. */
 #define OCFS2_META_LOCK_RECOVERY	(0x01)
@@ -170,4 +177,10 @@ void ocfs2_put_dlm_debug(struct ocfs2_dlm_debug *dlm_debug);
 
 /* To set the locking protocol on module initialization */
 void ocfs2_set_locking_protocol(void);
+
+/*
+ * Keep a list of processes that have interest in a lockres.
+ * Note: this is now only uesed for check recursive cluster lock.
+ */
+struct ocfs2_holder *ocfs2_is_locked_by_me(struct ocfs2_lock_res *lockres);
 #endif	/* DLMGLUE_H */
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index e63af7d..12933b8 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -172,6 +172,7 @@ struct ocfs2_lock_res {
 
 	struct list_head         l_blocked_list;
 	struct list_head         l_mask_waiters;
+	struct list_head 	 l_holders;
 
 	unsigned long		 l_flags;
 	char                     l_name[OCFS2_LOCK_ID_MAX_LEN];
-- 
2.6.6
