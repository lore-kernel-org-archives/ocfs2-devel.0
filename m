From: Joseph Qi <joseph.qi@huawei.com>
Date: Fri, 18 Sep 2015 19:25:46 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2/dlm: fix race between convert and
	recovery
Message-ID: <55FBF4BA.30000@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

There is a race window between dlmconvert_remote and
dlm_move_lockres_to_recovery_list, which will cause a lock with
OCFS2_LOCK_BUSY in grant list, thus system hangs.

dlmconvert_remote
{
        spin_lock(&res->spinlock);
        list_move_tail(&lock->list, &res->converting);
        lock->convert_pending = 1;
        spin_unlock(&res->spinlock);

        status = dlm_send_remote_convert_request();
        >>>>>> race window, master has queued ast and return DLM_NORMAL,
               and then down before sending ast.
               this node detects master down and calls
               dlm_move_lockres_to_recovery_list, which will revert the
               lock to grant list.
               Then OCFS2_LOCK_BUSY won't be cleared as new master won't
               send ast any more because it thinks already be authorized.

        spin_lock(&res->spinlock);
        lock->convert_pending = 0;
        if (status != DLM_NORMAL)
                dlm_revert_pending_convert(res, lock);
        spin_unlock(&res->spinlock);
}

In this case, just leave it in convert list and new master will take care
of it after recovery.  And if convert request returns other than
DLM_NORMAL, convert thread will do the revert itself. So remove the
revert logic in dlm_move_lockres_to_recovery_list.

changelog since v1:
Clean up convert_pending since it is now useless.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reported-by: Yiwen Jiang <jiangyiwen@huawei.com>
Cc: <stable@vger.kernel.org>
---
 fs/ocfs2/dlm/dlmcommon.h   |  1 -
 fs/ocfs2/dlm/dlmconvert.c  |  2 --
 fs/ocfs2/dlm/dlmdebug.c    |  7 +++----
 fs/ocfs2/dlm/dlmlock.c     |  1 -
 fs/ocfs2/dlm/dlmrecovery.c | 10 +---------
 5 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index e88ccf8..25853d7 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -369,7 +369,6 @@ struct dlm_lock
 	struct dlm_lockstatus *lksb;
 	unsigned ast_pending:1,
 		 bast_pending:1,
-		 convert_pending:1,
 		 lock_pending:1,
 		 cancel_pending:1,
 		 unlock_pending:1,
diff --git a/fs/ocfs2/dlm/dlmconvert.c b/fs/ocfs2/dlm/dlmconvert.c
index e36d63f..82ba8d5 100644
--- a/fs/ocfs2/dlm/dlmconvert.c
+++ b/fs/ocfs2/dlm/dlmconvert.c
@@ -291,7 +291,6 @@ enum dlm_status dlmconvert_remote(struct dlm_ctxt *dlm,
 	/* move lock to local convert queue */
 	/* do not alter lock refcount.  switching lists. */
 	list_move_tail(&lock->list, &res->converting);
-	lock->convert_pending = 1;
 	lock->ml.convert_type = type;

 	if (flags & LKM_VALBLK) {
@@ -315,7 +314,6 @@ enum dlm_status dlmconvert_remote(struct dlm_ctxt *dlm,

 	spin_lock(&res->spinlock);
 	res->state &= ~DLM_LOCK_RES_IN_PROGRESS;
-	lock->convert_pending = 0;
 	/* if it failed, move it back to granted queue */
 	if (status != DLM_NORMAL) {
 		if (status != DLM_NOTQUEUED)
diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index 8251360..710e94c 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -77,7 +77,7 @@ static void __dlm_print_lock(struct dlm_lock *lock)

 	printk("    type=%d, conv=%d, node=%u, cookie=%u:%llu, "
 	       "ref=%u, ast=(empty=%c,pend=%c), bast=(empty=%c,pend=%c), "
-	       "pending=(conv=%c,lock=%c,cancel=%c,unlock=%c)\n",
+	       "pending=(lock=%c,cancel=%c,unlock=%c)\n",
 	       lock->ml.type, lock->ml.convert_type, lock->ml.node,
 	       dlm_get_lock_cookie_node(be64_to_cpu(lock->ml.cookie)),
 	       dlm_get_lock_cookie_seq(be64_to_cpu(lock->ml.cookie)),
@@ -86,7 +86,6 @@ static void __dlm_print_lock(struct dlm_lock *lock)
 	       (lock->ast_pending ? 'y' : 'n'),
 	       (list_empty(&lock->bast_list) ? 'y' : 'n'),
 	       (lock->bast_pending ? 'y' : 'n'),
-	       (lock->convert_pending ? 'y' : 'n'),
 	       (lock->lock_pending ? 'y' : 'n'),
 	       (lock->cancel_pending ? 'y' : 'n'),
 	       (lock->unlock_pending ? 'y' : 'n'));
@@ -502,7 +501,7 @@ static int dump_lock(struct dlm_lock *lock, int list_type, char *buf, int len)

 #define DEBUG_LOCK_VERSION	1
 	spin_lock(&lock->spinlock);
-	out = snprintf(buf, len, "LOCK:%d,%d,%d,%d,%d,%d:%lld,%d,%d,%d,%d,%d,"
+	out = snprintf(buf, len, "LOCK:%d,%d,%d,%d,%d,%d:%lld,%d,%d,%d,%d,"
 		       "%d,%d,%d,%d\n",
 		       DEBUG_LOCK_VERSION,
 		       list_type, lock->ml.type, lock->ml.convert_type,
@@ -512,7 +511,7 @@ static int dump_lock(struct dlm_lock *lock, int list_type, char *buf, int len)
 		       !list_empty(&lock->ast_list),
 		       !list_empty(&lock->bast_list),
 		       lock->ast_pending, lock->bast_pending,
-		       lock->convert_pending, lock->lock_pending,
+		       lock->lock_pending,
 		       lock->cancel_pending, lock->unlock_pending,
 		       atomic_read(&lock->lock_refs.refcount));
 	spin_unlock(&lock->spinlock);
diff --git a/fs/ocfs2/dlm/dlmlock.c b/fs/ocfs2/dlm/dlmlock.c
index 66c2a49..857dd15 100644
--- a/fs/ocfs2/dlm/dlmlock.c
+++ b/fs/ocfs2/dlm/dlmlock.c
@@ -411,7 +411,6 @@ static void dlm_init_lock(struct dlm_lock *newlock, int type,
 	newlock->ml.cookie = cpu_to_be64(cookie);
 	newlock->ast_pending = 0;
 	newlock->bast_pending = 0;
-	newlock->convert_pending = 0;
 	newlock->lock_pending = 0;
 	newlock->unlock_pending = 0;
 	newlock->cancel_pending = 0;
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 3d90ad7..2402ef7 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -2062,15 +2062,7 @@ void dlm_move_lockres_to_recovery_list(struct dlm_ctxt *dlm,
 		queue = dlm_list_idx_to_ptr(res, i);
 		list_for_each_entry_safe(lock, next, queue, list) {
 			dlm_lock_get(lock);
-			if (lock->convert_pending) {
-				/* move converting lock back to granted */
-				BUG_ON(i != DLM_CONVERTING_LIST);
-				mlog(0, "node died with convert pending "
-				     "on %.*s. move back to granted list.\n",
-				     res->lockname.len, res->lockname.name);
-				dlm_revert_pending_convert(res, lock);
-				lock->convert_pending = 0;
-			} else if (lock->lock_pending) {
+			if (lock->lock_pending) {
 				/* remove pending lock requests completely */
 				BUG_ON(i != DLM_BLOCKED_LIST);
 				mlog(0, "node died with lock pending "
-- 
1.8.4.3
