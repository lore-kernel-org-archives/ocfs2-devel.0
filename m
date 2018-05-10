From: Gang He <ghe@suse.com>
Date: Thu, 10 May 2018 01:49:29 -0600
Subject: [Ocfs2-devel] [PATCH] ocfs2: ocfs2_inode_lock_tracker does not
 distinguish lock level
In-Reply-To: <20180510053230.17217-1-lchen@suse.com>
References: <20180510053230.17217-1-lchen@suse.com>
Message-ID: <5AF3F989020000F90001A482@prv1-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jlbec@evilplan.org, jiangqi903@gmail.com, piaojun@huawei.com, ge changwei <gechangwei@live.cn>, Lei Chen <lchen@suse.com>, mfasheh@versity.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Hello Joseph, Changwei and Jun/Alex,

Please help to take a look at this patch, 
since the previous patch really has vulnerability in logic, although our test cases did not hit it.

Thanks
Gang
 


>>> Larry Chen <lchen@suse.com> 2018/5/10 13:32 >>>
ocfs2_inode_lock_tracker as a variant of ocfs2_inode_lock,
is used to prevent deadlock due to recursive lock acquisition.

But this function does not distinguish
whether the requested level is EX or PR.

If a RP lock has been attained, this function
will immediately return success afterwards even
an EX lock is requested.

But actually the return value does not mean that
the process got a EX lock, because ocfs2_inode_lock
has not been called.

When taking lock levels into account, we face some different situations.
1. no lock is held
   In this case, just lock the inode and return 0

2. We are holding a lock
   For this situation, things diverges into several cases

   wanted     holding	     what to do
   ex		ex	    see 2.1 below
   ex		pr	    see 2.2 below
   pr		ex	    see 2.1 below
   pr		pr	    see 2.1 below

   2.1 lock level that is been held is compatible
   with the wanted level, so no lock action will be tacken.

   2.2 Otherwise, an upgrade is needed, but it is forbidden.

Reason why upgrade within a process is forbidden is that
lock upgrade may cause dead lock. The following illustrate
how it happens.

        process 1                             process 2
ocfs2_inode_lock_tracker(ex=0)
                               <======   ocfs2_inode_lock_tracker(ex=1)

ocfs2_inode_lock_tracker(ex=1)

Signed-off-by: Larry Chen <lchen@suse.com>
Reviewed-by: Gang He <ghe@suse.com>
---
 fs/ocfs2/dlmglue.c | 119 +++++++++++++++++++++++++++++++++++++++--------------
 fs/ocfs2/dlmglue.h |   1 +
 2 files changed, 90 insertions(+), 30 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 97a972efab83..68728de12864 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -788,35 +788,34 @@ static inline void ocfs2_add_holder(struct ocfs2_lock_res *lockres,
 	spin_unlock(&lockres->l_lock);
 }
 
-static inline void ocfs2_remove_holder(struct ocfs2_lock_res *lockres,
-				       struct ocfs2_lock_holder *oh)
-{
-	spin_lock(&lockres->l_lock);
-	list_del(&oh->oh_list);
-	spin_unlock(&lockres->l_lock);
-
-	put_pid(oh->oh_owner_pid);
-}
-
-static inline int ocfs2_is_locked_by_me(struct ocfs2_lock_res *lockres)
+static struct ocfs2_lock_holder *
+ocfs2_pid_holder(struct ocfs2_lock_res *lockres,
+		struct pid *pid)
 {
 	struct ocfs2_lock_holder *oh;
-	struct pid *pid;
 
-	/* look in the list of holders for one with the current task as owner */
 	spin_lock(&lockres->l_lock);
-	pid = task_pid(current);
 	list_for_each_entry(oh, &lockres->l_holders, oh_list) {
 		if (oh->oh_owner_pid == pid) {
 			spin_unlock(&lockres->l_lock);
-			return 1;
+			return oh;
 		}
 	}
 	spin_unlock(&lockres->l_lock);
+	return NULL;
+}
 
-	return 0;
+static inline void ocfs2_remove_holder(struct ocfs2_lock_res *lockres,
+				       struct ocfs2_lock_holder *oh)
+{
+	spin_lock(&lockres->l_lock);
+	list_del(&oh->oh_list);
+	spin_unlock(&lockres->l_lock);
+
+	put_pid(oh->oh_owner_pid);
 }
 
+
 static inline void ocfs2_inc_holders(struct ocfs2_lock_res *lockres,
 				     int level)
 {
@@ -2610,34 +2609,93 @@ void ocfs2_inode_unlock(struct inode *inode,
  *
  * return < 0 on error, return == 0 if there's no lock holder on the stack
  * before this call, return == 1 if this call would be a recursive locking.
+ * return == -1 if this lock attempt will cause an upgrade which is forbidden.
+ *
+ * When taking lock levels into account,we face some different situations.
+ *
+ * 1. no lock is held
+ *    In this case, just lock the inode as requested and return 0
+ *
+ * 2. We are holding a lock
+ *    For this situation, things diverges into several cases
+ *
+ *    wanted     holding	     what to do
+ *    ex		ex	    see 2.1 below
+ *    ex		pr	    see 2.2 below
+ *    pr		ex	    see 2.1 below
+ *    pr		pr	    see 2.1 below
+ *
+ *    2.1 lock level that is been held is compatible
+ *    with the wanted level, so no lock action will be tacken.
+ *
+ *    2.2 Otherwise, an upgrade is needed, but it is forbidden.
+ *
+ * Reason why upgrade within a process is forbidden is that
+ * lock upgrade may cause dead lock. The following illustrates
+ * how it happens.
+ *
+ *         thread on node1                             thread on node2
+ * ocfs2_inode_lock_tracker(ex=0)
+ *
+ *                                <======   ocfs2_inode_lock_tracker(ex=1)
+ *
+ * ocfs2_inode_lock_tracker(ex=1)
  */
 int ocfs2_inode_lock_tracker(struct inode *inode,
 			     struct buffer_head **ret_bh,
 			     int ex,
 			     struct ocfs2_lock_holder *oh)
 {
-	int status;
-	int arg_flags = 0, has_locked;
+	int status = 0;
 	struct ocfs2_lock_res *lockres;
+	struct ocfs2_lock_holder *tmp_oh;
+	struct pid *pid = task_pid(current);
+
 
 	lockres = &OCFS2_I(inode)->ip_inode_lockres;
-	has_locked = ocfs2_is_locked_by_me(lockres);
-	/* Just get buffer head if the cluster lock has been taken */
-	if (has_locked)
-		arg_flags = OCFS2_META_LOCK_GETBH;
+	tmp_oh = ocfs2_pid_holder(lockres, pid);
 
-	if (likely(!has_locked || ret_bh)) {
-		status = ocfs2_inode_lock_full(inode, ret_bh, ex, arg_flags);
+	if (!tmp_oh) {
+		/*
+		 * This corresponds to the case 1.
+		 * We haven't got any lock before.
+		 */
+		status = ocfs2_inode_lock_full(inode, ret_bh, ex, 0);
 		if (status < 0) {
 			if (status != -ENOENT)
 				mlog_errno(status);
 			return status;
 		}
-	}
-	if (!has_locked)
+
+		oh->oh_ex = ex;
 		ocfs2_add_holder(lockres, oh);
+		return 0;
+	}
 
-	return has_locked;
+	if (unlikely(ex && !tmp_oh->oh_ex)) {
+		/*
+		 * case 2.2 upgrade may cause dead lock, forbid it.
+		 */
+		mlog(ML_ERROR, "Recursive locking is not permitted to "
+		     "upgrade to EX level from PR level.\n");
+		dump_stack();
+		return -EINVAL;
+	}
+
+	/*
+	 *  case 2.1 OCFS2_META_LOCK_GETBH flag make ocfs2_inode_lock_full.
+	 *  ignore the lock level and just update it.
+	 */
+	if (ret_bh) {
+		status = ocfs2_inode_lock_full(inode, ret_bh, ex,
+					       OCFS2_META_LOCK_GETBH);
+		if (status < 0) {
+			if (status != -ENOENT)
+				mlog_errno(status);
+			return status;
+		}
+	}
+	return tmp_oh ? 1 : 0;
 }
 
 void ocfs2_inode_unlock_tracker(struct inode *inode,
@@ -2649,12 +2707,13 @@ void ocfs2_inode_unlock_tracker(struct inode *inode,
 
 	lockres = &OCFS2_I(inode)->ip_inode_lockres;
 	/* had_lock means that the currect process already takes the cluster
-	 * lock previously. If had_lock is 1, we have nothing to do here, and
-	 * it will get unlocked where we got the lock.
+	 * lock previously.
+	 * If had_lock is 1, we have nothing to do here.
+	 * If had_lock is 0, we will release the lock.
 	 */
 	if (!had_lock) {
+		ocfs2_inode_unlock(inode, oh->oh_ex);
 		ocfs2_remove_holder(lockres, oh);
-		ocfs2_inode_unlock(inode, ex);
 	}
 }
 
diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
index 256e0a9067b8..4ec1c828f6e0 100644
--- a/fs/ocfs2/dlmglue.h
+++ b/fs/ocfs2/dlmglue.h
@@ -96,6 +96,7 @@ struct ocfs2_trim_fs_info {
 struct ocfs2_lock_holder {
 	struct list_head oh_list;
 	struct pid *oh_owner_pid;
+	int oh_ex;
 };
 
 /* ocfs2_inode_lock_full() 'arg_flags' flags */
-- 
2.13.6


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel at oss.oracle.com 
https://oss.oracle.com/mailman/listinfo/ocfs2-devel 
