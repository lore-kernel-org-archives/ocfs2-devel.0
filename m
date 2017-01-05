From: Eric Ren <zren@suse.com>
Date: Thu,  5 Jan 2017 23:31:01 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2/dlmglue: prepare tracking logic to
	avoid recursive cluster lock
In-Reply-To: <1483630262-22227-1-git-send-email-zren@suse.com>
References: <1483630262-22227-1-git-send-email-zren@suse.com>
Message-ID: <1483630262-22227-2-git-send-email-zren@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com
Cc: akpm@linux-foundation.org, mfasheh@versity.com, jlbec@evilplan.org, ghe@suse.com, junxiao.bi@oracle.com, jiangqi903@gmail.com, zren@suse.com, linux-kernel@vger.kernel.org

We are in the situation that we have to avoid recursive cluster locking,
but there is no way to check if a cluster lock has been taken by a
precess already.

Mostly, we can avoid recursive locking by writing code carefully.
However, we found that it's very hard to handle the routines that
are invoked directly by vfs code. For instance:

const struct inode_operations ocfs2_file_iops = {
    .permission     = ocfs2_permission,
    .get_acl        = ocfs2_iop_get_acl,
    .set_acl        = ocfs2_iop_set_acl,
};

Both ocfs2_permission() and ocfs2_iop_get_acl() call ocfs2_inode_lock(PR):
do_sys_open
 may_open
  inode_permission
   ocfs2_permission
    ocfs2_inode_lock() <=== first time
     generic_permission
      get_acl
       ocfs2_iop_get_acl
	ocfs2_inode_lock() <=== recursive one

A deadlock will occur if a remote EX request comes in between two
of ocfs2_inode_lock(). Briefly describe how the deadlock is formed:

On one hand, OCFS2_LOCK_BLOCKED flag of this lockres is set in
BAST(ocfs2_generic_handle_bast) when downconvert is started
on behalf of the remote EX lock request. Another hand, the recursive
cluster lock (the second one) will be blocked in in __ocfs2_cluster_lock()
because of OCFS2_LOCK_BLOCKED. But, the downconvert never complete, why?
because there is no chance for the first cluster lock on this node to be
unlocked - we block ourselves in the code path.

The idea to fix this issue is mostly taken from gfs2 code.
1. introduce a new field: struct ocfs2_lock_res.l_holders, to
keep track of the processes' pid  who has taken the cluster lock
of this lock resource;
2. introduce a new flag for ocfs2_inode_lock_full: OCFS2_META_LOCK_GETBH;
it means just getting back disk inode bh for us if we've got cluster lock.
3. export a helper: ocfs2_is_locked_by_me() is used to check if we
have got the cluster lock in the upper code path.

The tracking logic should be used by some of the ocfs2 vfs's callbacks,
to solve the recursive locking issue cuased by the fact that vfs routines
can call into each other.

The performance penalty of processing the holder list should only be seen
at a few cases where the tracking logic is used, such as get/set acl.

You may ask what if the first time we got a PR lock, and the second time
we want a EX lock? fortunately, this case never happens in the real world,
as far as I can see, including permission check, (get|set)_(acl|attr), and
the gfs2 code also do so.

Signed-off-by: Eric Ren <zren@suse.com>
---
 fs/ocfs2/dlmglue.c | 47 ++++++++++++++++++++++++++++++++++++++++++++---
 fs/ocfs2/dlmglue.h | 18 ++++++++++++++++++
 fs/ocfs2/ocfs2.h   |  1 +
 3 files changed, 63 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 83d576f..500bda4 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -532,6 +532,7 @@ void ocfs2_lock_res_init_once(struct ocfs2_lock_res *res)
 	init_waitqueue_head(&res->l_event);
 	INIT_LIST_HEAD(&res->l_blocked_list);
 	INIT_LIST_HEAD(&res->l_mask_waiters);
+	INIT_LIST_HEAD(&res->l_holders);
 }
 
 void ocfs2_inode_lock_res_init(struct ocfs2_lock_res *res,
@@ -749,6 +750,45 @@ void ocfs2_lock_res_free(struct ocfs2_lock_res *res)
 	res->l_flags = 0UL;
 }
 
+inline void ocfs2_add_holder(struct ocfs2_lock_res *lockres,
+				   struct ocfs2_holder *oh)
+{
+	INIT_LIST_HEAD(&oh->oh_list);
+	oh->oh_owner_pid =  get_pid(task_pid(current));
+
+	spin_lock(&lockres->l_lock);
+	list_add_tail(&oh->oh_list, &lockres->l_holders);
+	spin_unlock(&lockres->l_lock);
+}
+
+inline void ocfs2_remove_holder(struct ocfs2_lock_res *lockres,
+				       struct ocfs2_holder *oh)
+{
+	spin_lock(&lockres->l_lock);
+	list_del(&oh->oh_list);
+	spin_unlock(&lockres->l_lock);
+
+	put_pid(oh->oh_owner_pid);
+}
+
+inline struct ocfs2_holder *ocfs2_is_locked_by_me(struct ocfs2_lock_res *lockres)
+{
+	struct ocfs2_holder *oh;
+	struct pid *pid;
+
+	/* look in the list of holders for one with the current task as owner */
+	spin_lock(&lockres->l_lock);
+	pid = task_pid(current);
+	list_for_each_entry(oh, &lockres->l_holders, oh_list) {
+		if (oh->oh_owner_pid == pid)
+			goto out;
+	}
+	oh = NULL;
+out:
+	spin_unlock(&lockres->l_lock);
+	return oh;
+}
+
 static inline void ocfs2_inc_holders(struct ocfs2_lock_res *lockres,
 				     int level)
 {
@@ -2333,8 +2373,9 @@ int ocfs2_inode_lock_full_nested(struct inode *inode,
 		goto getbh;
 	}
 
-	if (ocfs2_mount_local(osb))
-		goto local;
+	if ((arg_flags & OCFS2_META_LOCK_GETBH) ||
+	    ocfs2_mount_local(osb))
+		goto update;
 
 	if (!(arg_flags & OCFS2_META_LOCK_RECOVERY))
 		ocfs2_wait_for_recovery(osb);
@@ -2363,7 +2404,7 @@ int ocfs2_inode_lock_full_nested(struct inode *inode,
 	if (!(arg_flags & OCFS2_META_LOCK_RECOVERY))
 		ocfs2_wait_for_recovery(osb);
 
-local:
+update:
 	/*
 	 * We only see this flag if we're being called from
 	 * ocfs2_read_locked_inode(). It means we're locking an inode
diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
index d293a22..d65ff1e 100644
--- a/fs/ocfs2/dlmglue.h
+++ b/fs/ocfs2/dlmglue.h
@@ -70,6 +70,11 @@ struct ocfs2_orphan_scan_lvb {
 	__be32	lvb_os_seqno;
 };
 
+struct ocfs2_holder {
+	struct list_head oh_list;
+	struct pid *oh_owner_pid;
+};
+
 /* ocfs2_inode_lock_full() 'arg_flags' flags */
 /* don't wait on recovery. */
 #define OCFS2_META_LOCK_RECOVERY	(0x01)
@@ -77,6 +82,8 @@ struct ocfs2_orphan_scan_lvb {
 #define OCFS2_META_LOCK_NOQUEUE		(0x02)
 /* don't block waiting for the downconvert thread, instead return -EAGAIN */
 #define OCFS2_LOCK_NONBLOCK		(0x04)
+/* just get back disk inode bh if we've got cluster lock. */
+#define OCFS2_META_LOCK_GETBH		(0x08)
 
 /* Locking subclasses of inode cluster lock */
 enum {
@@ -170,4 +177,15 @@ void ocfs2_put_dlm_debug(struct ocfs2_dlm_debug *dlm_debug);
 
 /* To set the locking protocol on module initialization */
 void ocfs2_set_locking_protocol(void);
+
+/*
+ * Keep a list of processes who have interest in a lockres.
+ * Note: this is now only uesed for check recursive cluster lock.
+ */
+inline void ocfs2_add_holder(struct ocfs2_lock_res *lockres,
+			     struct ocfs2_holder *oh);
+inline void ocfs2_remove_holder(struct ocfs2_lock_res *lockres,
+			     struct ocfs2_holder *oh);
+inline struct ocfs2_holder *ocfs2_is_locked_by_me(struct ocfs2_lock_res *lockres);
+
 #endif	/* DLMGLUE_H */
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 7e5958b..0c39d71 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -172,6 +172,7 @@ struct ocfs2_lock_res {
 
 	struct list_head         l_blocked_list;
 	struct list_head         l_mask_waiters;
+	struct list_head	 l_holders;
 
 	unsigned long		 l_flags;
 	char                     l_name[OCFS2_LOCK_ID_MAX_LEN];
-- 
2.6.6
