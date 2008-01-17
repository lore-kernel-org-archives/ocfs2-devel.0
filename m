From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Jan 17 14:36:50 2008
Subject: [Ocfs2-devel] [PATCH 03/30] ocfs2: Remove mount/unmount votes
In-Reply-To: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
Message-ID: <1200609356-17788-4-git-send-email-mark.fasheh@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Mark Fasheh <mark.fasheh@oracle.com>

The node maps that are set/unset by these votes are no longer relevant, thus
we can remove the mount and umount votes. Since those are the last two
remaining votes, we can also remove the entire vote infrastructure.

The vote thread has been renamed to the downconvert thread, and the small
amount of functionality related to managing it has been moved into
fs/ocfs2/dlmglue.c. All references to votes have been removed or updated.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/Makefile               |    3 +-
 fs/ocfs2/cluster/tcp_internal.h |    5 +-
 fs/ocfs2/dcache.c               |    8 +-
 fs/ocfs2/dlmglue.c              |  164 +++++++--
 fs/ocfs2/dlmglue.h              |    5 +-
 fs/ocfs2/heartbeat.c            |    7 -
 fs/ocfs2/inode.c                |   36 +-
 fs/ocfs2/journal.c              |   15 +-
 fs/ocfs2/namei.c                |   10 +-
 fs/ocfs2/ocfs2.h                |   25 +-
 fs/ocfs2/slot_map.c             |   19 -
 fs/ocfs2/slot_map.h             |    2 -
 fs/ocfs2/super.c                |   43 +--
 fs/ocfs2/vote.c                 |  756 ---------------------------------------
 fs/ocfs2/vote.h                 |   48 ---
 15 files changed, 179 insertions(+), 967 deletions(-)
 delete mode 100644 fs/ocfs2/vote.c
 delete mode 100644 fs/ocfs2/vote.h

diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 9fb8132..d2057e7 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -27,8 +27,7 @@ ocfs2-objs := \
 	symlink.o 		\
 	sysfile.o 		\
 	uptodate.o		\
-	ver.o 			\
-	vote.o
+	ver.o
 
 obj-$(CONFIG_OCFS2_FS) += cluster/
 obj-$(CONFIG_OCFS2_FS) += dlm/
diff --git a/fs/ocfs2/cluster/tcp_internal.h b/fs/ocfs2/cluster/tcp_internal.h
index 9606111..79bd666 100644
--- a/fs/ocfs2/cluster/tcp_internal.h
+++ b/fs/ocfs2/cluster/tcp_internal.h
@@ -38,6 +38,9 @@
  * locking semantics of the file system using the protocol.  It should 
  * be somewhere else, I'm sure, but right now it isn't.
  *
+ * New in version 9:
+ * 	- All votes removed
+ *
  * New in version 8:
  * 	- Replace delete inode votes with a cluster lock
  *
@@ -60,7 +63,7 @@
  * 	- full 64 bit i_size in the metadata lock lvbs
  * 	- introduction of "rw" lock and pushing meta/data locking down
  */
-#define O2NET_PROTOCOL_VERSION 8ULL
+#define O2NET_PROTOCOL_VERSION 9ULL
 struct o2net_handshake {
 	__be64	protocol_version;
 	__be64	connector_id;
diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
index 9923278..b1cc7c3 100644
--- a/fs/ocfs2/dcache.c
+++ b/fs/ocfs2/dcache.c
@@ -128,9 +128,9 @@ static int ocfs2_match_dentry(struct dentry *dentry,
 /*
  * Walk the inode alias list, and find a dentry which has a given
  * parent. ocfs2_dentry_attach_lock() wants to find _any_ alias as it
- * is looking for a dentry_lock reference. The vote thread is looking
- * to unhash aliases, so we allow it to skip any that already have
- * that property.
+ * is looking for a dentry_lock reference. The downconvert thread is
+ * looking to unhash aliases, so we allow it to skip any that already
+ * have that property.
  */
 struct dentry *ocfs2_find_local_alias(struct inode *inode,
 				      u64 parent_blkno,
@@ -266,7 +266,7 @@ int ocfs2_dentry_attach_lock(struct dentry *dentry,
 	dl->dl_count = 0;
 	/*
 	 * Does this have to happen below, for all attaches, in case
-	 * the struct inode gets blown away by votes?
+	 * the struct inode gets blown away by the downconvert thread?
 	 */
 	dl->dl_inode = igrab(inode);
 	dl->dl_parent_blkno = parent_blkno;
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 4e97dcc..64d6ff4 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -55,7 +55,6 @@
 #include "slot_map.h"
 #include "super.h"
 #include "uptodate.h"
-#include "vote.h"
 
 #include "buffer_head_io.h"
 
@@ -153,10 +152,10 @@ struct ocfs2_lock_res_ops {
 	struct ocfs2_super * (*get_osb)(struct ocfs2_lock_res *);
 
 	/*
-	 * Optionally called in the downconvert (or "vote") thread
-	 * after a successful downconvert. The lockres will not be
-	 * referenced after this callback is called, so it is safe to
-	 * free memory, etc.
+	 * Optionally called in the downconvert thread after a
+	 * successful downconvert. The lockres will not be referenced
+	 * after this callback is called, so it is safe to free
+	 * memory, etc.
 	 *
 	 * The exact semantics of when this is called are controlled
 	 * by ->downconvert_worker()
@@ -310,8 +309,9 @@ static inline void ocfs2_recover_from_dlm_error(struct ocfs2_lock_res *lockres,
 		"resource %s: %s\n", dlm_errname(_stat), _func,	\
 		_lockres->l_name, dlm_errmsg(_stat));		\
 } while (0)
-static void ocfs2_vote_on_unlock(struct ocfs2_super *osb,
-				 struct ocfs2_lock_res *lockres);
+static int ocfs2_downconvert_thread(void *arg);
+static void ocfs2_downconvert_on_unlock(struct ocfs2_super *osb,
+					struct ocfs2_lock_res *lockres);
 static int ocfs2_meta_lock_update(struct inode *inode,
 				  struct buffer_head **bh);
 static void ocfs2_drop_osb_locks(struct ocfs2_super *osb);
@@ -732,7 +732,7 @@ static void ocfs2_blocking_ast(void *opaque, int level)
 
 	wake_up(&lockres->l_event);
 
-	ocfs2_kick_vote_thread(osb);
+	ocfs2_wake_downconvert_thread(osb);
 }
 
 static void ocfs2_locking_ast(void *opaque)
@@ -1089,7 +1089,7 @@ static void ocfs2_cluster_unlock(struct ocfs2_super *osb,
 	mlog_entry_void();
 	spin_lock_irqsave(&lockres->l_lock, flags);
 	ocfs2_dec_holders(lockres, level);
-	ocfs2_vote_on_unlock(osb, lockres);
+	ocfs2_downconvert_on_unlock(osb, lockres);
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
 	mlog_exit_void();
 }
@@ -1372,15 +1372,15 @@ int ocfs2_data_lock_with_page(struct inode *inode,
 	return ret;
 }
 
-static void ocfs2_vote_on_unlock(struct ocfs2_super *osb,
-				 struct ocfs2_lock_res *lockres)
+static void ocfs2_downconvert_on_unlock(struct ocfs2_super *osb,
+					struct ocfs2_lock_res *lockres)
 {
 	int kick = 0;
 
 	mlog_entry_void();
 
 	/* If we know that another node is waiting on our lock, kick
-	 * the vote thread * pre-emptively when we reach a release
+	 * the downconvert thread * pre-emptively when we reach a release
 	 * condition. */
 	if (lockres->l_flags & OCFS2_LOCK_BLOCKED) {
 		switch(lockres->l_blocking) {
@@ -1398,7 +1398,7 @@ static void ocfs2_vote_on_unlock(struct ocfs2_super *osb,
 	}
 
 	if (kick)
-		ocfs2_kick_vote_thread(osb);
+		ocfs2_wake_downconvert_thread(osb);
 
 	mlog_exit_void();
 }
@@ -1832,19 +1832,20 @@ bail:
 }
 
 /*
- * This is working around a lock inversion between tasks acquiring DLM locks
- * while holding a page lock and the vote thread which blocks dlm lock acquiry
- * while acquiring page locks.
+ * This is working around a lock inversion between tasks acquiring DLM
+ * locks while holding a page lock and the downconvert thread which
+ * blocks dlm lock acquiry while acquiring page locks.
  *
  * ** These _with_page variantes are only intended to be called from aop
  * methods that hold page locks and return a very specific *positive* error
  * code that aop methods pass up to the VFS -- test for errors with != 0. **
  *
- * The DLM is called such that it returns -EAGAIN if it would have blocked
- * waiting for the vote thread.  In that case we unlock our page so the vote
- * thread can make progress.  Once we've done this we have to return
- * AOP_TRUNCATED_PAGE so the aop method that called us can bubble that back up
- * into the VFS who will then immediately retry the aop call.
+ * The DLM is called such that it returns -EAGAIN if it would have
+ * blocked waiting for the downconvert thread.  In that case we unlock
+ * our page so the downconvert thread can make progress.  Once we've
+ * done this we have to return AOP_TRUNCATED_PAGE so the aop method
+ * that called us can bubble that back up into the VFS who will then
+ * immediately retry the aop call.
  *
  * We do a blocking lock and immediate unlock before returning, though, so that
  * the lock has a great chance of being cached on this node by the time the VFS
@@ -2320,11 +2321,11 @@ int ocfs2_dlm_init(struct ocfs2_super *osb)
 		goto bail;
 	}
 
-	/* launch vote thread */
-	osb->vote_task = kthread_run(ocfs2_vote_thread, osb, "ocfs2vote");
-	if (IS_ERR(osb->vote_task)) {
-		status = PTR_ERR(osb->vote_task);
-		osb->vote_task = NULL;
+	/* launch downconvert thread */
+	osb->dc_task = kthread_run(ocfs2_downconvert_thread, osb, "ocfs2dc");
+	if (IS_ERR(osb->dc_task)) {
+		status = PTR_ERR(osb->dc_task);
+		osb->dc_task = NULL;
 		mlog_errno(status);
 		goto bail;
 	}
@@ -2353,8 +2354,8 @@ local:
 bail:
 	if (status < 0) {
 		ocfs2_dlm_shutdown_debug(osb);
-		if (osb->vote_task)
-			kthread_stop(osb->vote_task);
+		if (osb->dc_task)
+			kthread_stop(osb->dc_task);
 	}
 
 	mlog_exit(status);
@@ -2369,9 +2370,9 @@ void ocfs2_dlm_shutdown(struct ocfs2_super *osb)
 
 	ocfs2_drop_osb_locks(osb);
 
-	if (osb->vote_task) {
-		kthread_stop(osb->vote_task);
-		osb->vote_task = NULL;
+	if (osb->dc_task) {
+		kthread_stop(osb->dc_task);
+		osb->dc_task = NULL;
 	}
 
 	ocfs2_lock_res_free(&osb->osb_super_lockres);
@@ -2527,7 +2528,7 @@ out:
 
 /* Mark the lockres as being dropped. It will no longer be
  * queued if blocking, but we still may have to wait on it
- * being dequeued from the vote thread before we can consider
+ * being dequeued from the downconvert thread before we can consider
  * it safe to drop. 
  *
  * You can *not* attempt to call cluster_lock on this lockres anymore. */
@@ -2903,7 +2904,7 @@ static void ocfs2_set_meta_lvb(struct ocfs2_lock_res *lockres)
 
 /*
  * Does the final reference drop on our dentry lock. Right now this
- * happens in the vote thread, but we could choose to simplify the
+ * happens in the downconvert thread, but we could choose to simplify the
  * dlmglue API and push these off to the ocfs2_wq in the future.
  */
 static void ocfs2_dentry_post_unlock(struct ocfs2_super *osb,
@@ -3042,7 +3043,7 @@ void ocfs2_process_blocked_lock(struct ocfs2_super *osb,
 	mlog(0, "lockres %s blocked.\n", lockres->l_name);
 
 	/* Detect whether a lock has been marked as going away while
-	 * the vote thread was processing other things. A lock can
+	 * the downconvert thread was processing other things. A lock can
 	 * still be marked with OCFS2_LOCK_FREEING after this check,
 	 * but short circuiting here will still save us some
 	 * performance. */
@@ -3091,13 +3092,104 @@ static void ocfs2_schedule_blocked_lock(struct ocfs2_super *osb,
 
 	lockres_or_flags(lockres, OCFS2_LOCK_QUEUED);
 
-	spin_lock(&osb->vote_task_lock);
+	spin_lock(&osb->dc_task_lock);
 	if (list_empty(&lockres->l_blocked_list)) {
 		list_add_tail(&lockres->l_blocked_list,
 			      &osb->blocked_lock_list);
 		osb->blocked_lock_count++;
 	}
-	spin_unlock(&osb->vote_task_lock);
+	spin_unlock(&osb->dc_task_lock);
 
 	mlog_exit_void();
 }
+
+static void ocfs2_downconvert_thread_do_work(struct ocfs2_super *osb)
+{
+	unsigned long processed;
+	struct ocfs2_lock_res *lockres;
+
+	mlog_entry_void();
+
+	spin_lock(&osb->dc_task_lock);
+	/* grab this early so we know to try again if a state change and
+	 * wake happens part-way through our work  */
+	osb->dc_work_sequence = osb->dc_wake_sequence;
+
+	processed = osb->blocked_lock_count;
+	while (processed) {
+		BUG_ON(list_empty(&osb->blocked_lock_list));
+
+		lockres = list_entry(osb->blocked_lock_list.next,
+				     struct ocfs2_lock_res, l_blocked_list);
+		list_del_init(&lockres->l_blocked_list);
+		osb->blocked_lock_count--;
+		spin_unlock(&osb->dc_task_lock);
+
+		BUG_ON(!processed);
+		processed--;
+
+		ocfs2_process_blocked_lock(osb, lockres);
+
+		spin_lock(&osb->dc_task_lock);
+	}
+	spin_unlock(&osb->dc_task_lock);
+
+	mlog_exit_void();
+}
+
+static int ocfs2_downconvert_thread_lists_empty(struct ocfs2_super *osb)
+{
+	int empty = 0;
+
+	spin_lock(&osb->dc_task_lock);
+	if (list_empty(&osb->blocked_lock_list))
+		empty = 1;
+
+	spin_unlock(&osb->dc_task_lock);
+	return empty;
+}
+
+static int ocfs2_downconvert_thread_should_wake(struct ocfs2_super *osb)
+{
+	int should_wake = 0;
+
+	spin_lock(&osb->dc_task_lock);
+	if (osb->dc_work_sequence != osb->dc_wake_sequence)
+		should_wake = 1;
+	spin_unlock(&osb->dc_task_lock);
+
+	return should_wake;
+}
+
+int ocfs2_downconvert_thread(void *arg)
+{
+	int status = 0;
+	struct ocfs2_super *osb = arg;
+
+	/* only quit once we've been asked to stop and there is no more
+	 * work available */
+	while (!(kthread_should_stop() &&
+		 ocfs2_downconvert_thread_lists_empty(osb))) {
+
+		wait_event_interruptible(osb->dc_event,
+					 ocfs2_downconvert_thread_should_wake(osb) ||
+					 kthread_should_stop());
+
+		mlog(0, "downconvert_thread: awoken\n");
+
+		ocfs2_downconvert_thread_do_work(osb);
+	}
+
+	osb->dc_task = NULL;
+	return status;
+}
+
+void ocfs2_wake_downconvert_thread(struct ocfs2_super *osb)
+{
+	spin_lock(&osb->dc_task_lock);
+	/* make sure the voting thread gets a swipe at whatever changes
+	 * the caller may have made to the voting state */
+	osb->dc_wake_sequence++;
+	spin_unlock(&osb->dc_task_lock);
+	wake_up(&osb->dc_event);
+}
diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
index 87a785e..931f6ee 100644
--- a/fs/ocfs2/dlmglue.h
+++ b/fs/ocfs2/dlmglue.h
@@ -54,7 +54,7 @@ struct ocfs2_meta_lvb {
 #define OCFS2_META_LOCK_RECOVERY	(0x01)
 /* Instruct the dlm not to queue ourselves on the other node. */
 #define OCFS2_META_LOCK_NOQUEUE		(0x02)
-/* don't block waiting for the vote thread, instead return -EAGAIN */
+/* don't block waiting for the downconvert thread, instead return -EAGAIN */
 #define OCFS2_LOCK_NONBLOCK		(0x04)
 
 int ocfs2_dlm_init(struct ocfs2_super *osb);
@@ -112,9 +112,10 @@ void ocfs2_mark_lockres_freeing(struct ocfs2_lock_res *lockres);
 void ocfs2_simple_drop_lockres(struct ocfs2_super *osb,
 			       struct ocfs2_lock_res *lockres);
 
-/* for the vote thread */
+/* for the downconvert thread */
 void ocfs2_process_blocked_lock(struct ocfs2_super *osb,
 				struct ocfs2_lock_res *lockres);
+void ocfs2_wake_downconvert_thread(struct ocfs2_super *osb);
 
 struct ocfs2_dlm_debug *ocfs2_new_dlm_debug(void);
 void ocfs2_put_dlm_debug(struct ocfs2_dlm_debug *dlm_debug);
diff --git a/fs/ocfs2/heartbeat.c b/fs/ocfs2/heartbeat.c
index 6239fc5..c0efd94 100644
--- a/fs/ocfs2/heartbeat.c
+++ b/fs/ocfs2/heartbeat.c
@@ -41,7 +41,6 @@
 #include "heartbeat.h"
 #include "inode.h"
 #include "journal.h"
-#include "vote.h"
 
 #include "buffer_head_io.h"
 
@@ -58,9 +57,7 @@ static void __ocfs2_node_map_set(struct ocfs2_node_map *target,
 void ocfs2_init_node_maps(struct ocfs2_super *osb)
 {
 	spin_lock_init(&osb->node_map_lock);
-	ocfs2_node_map_init(&osb->mounted_map);
 	ocfs2_node_map_init(&osb->recovery_map);
-	ocfs2_node_map_init(&osb->umount_map);
 	ocfs2_node_map_init(&osb->osb_recovering_orphan_dirs);
 }
 
@@ -82,8 +79,6 @@ static void ocfs2_do_node_down(int node_num,
 	}
 
 	ocfs2_recovery_thread(osb, node_num);
-
-	ocfs2_remove_node_from_vote_queues(osb, node_num);
 }
 
 /* Called from the dlm when it's about to evict a node. We may also
@@ -268,8 +263,6 @@ int ocfs2_recovery_map_set(struct ocfs2_super *osb,
 
 	spin_lock(&osb->node_map_lock);
 
-	__ocfs2_node_map_clear_bit(&osb->mounted_map, num);
-
 	if (!test_bit(num, osb->recovery_map.map)) {
 	    __ocfs2_node_map_set_bit(&osb->recovery_map, num);
 	    set = 1;
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index ebb2bbe..86cf073 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -49,7 +49,6 @@
 #include "symlink.h"
 #include "sysfile.h"
 #include "uptodate.h"
-#include "vote.h"
 
 #include "buffer_head_io.h"
 
@@ -718,8 +717,8 @@ static int ocfs2_wipe_inode(struct inode *inode,
 	}
 
 	/* we do this while holding the orphan dir lock because we
-	 * don't want recovery being run from another node to vote for
-	 * an inode delete on us -- this will result in two nodes
+	 * don't want recovery being run from another node to try an
+	 * inode delete underneath us -- this will result in two nodes
 	 * truncating the same file! */
 	status = ocfs2_truncate_for_delete(osb, inode, di_bh);
 	if (status < 0) {
@@ -744,7 +743,7 @@ bail:
 }
 
 /* There is a series of simple checks that should be done before a
- * vote is even considered. Encapsulate those in this function. */
+ * trylock is even considered. Encapsulate those in this function. */
 static int ocfs2_inode_is_valid_to_delete(struct inode *inode)
 {
 	int ret = 0;
@@ -758,14 +757,14 @@ static int ocfs2_inode_is_valid_to_delete(struct inode *inode)
 		goto bail;
 	}
 
-	/* If we're coming from process_vote we can't go into our own
+	/* If we're coming from downconvert_thread we can't go into our own
 	 * voting [hello, deadlock city!], so unforuntately we just
 	 * have to skip deleting this guy. That's OK though because
 	 * the node who's doing the actual deleting should handle it
 	 * anyway. */
-	if (current == osb->vote_task) {
+	if (current == osb->dc_task) {
 		mlog(0, "Skipping delete of %lu because we're currently "
-		     "in process_vote\n", inode->i_ino);
+		     "in downconvert\n", inode->i_ino);
 		goto bail;
 	}
 
@@ -779,10 +778,9 @@ static int ocfs2_inode_is_valid_to_delete(struct inode *inode)
 		goto bail_unlock;
 	}
 
-	/* If we have voted "yes" on the wipe of this inode for
-	 * another node, it will be marked here so we can safely skip
-	 * it. Recovery will cleanup any inodes we might inadvertantly
-	 * skip here. */
+	/* If we have allowd wipe of this inode for another node, it
+	 * will be marked here so we can safely skip it. Recovery will
+	 * cleanup any inodes we might inadvertantly skip here. */
 	if (oi->ip_flags & OCFS2_INODE_SKIP_DELETE) {
 		mlog(0, "Skipping delete of %lu because another node "
 		     "has done this for us.\n", inode->i_ino);
@@ -929,7 +927,7 @@ void ocfs2_delete_inode(struct inode *inode)
 
 	/* Lock down the inode. This gives us an up to date view of
 	 * it's metadata (for verification), and allows us to
-	 * serialize delete_inode votes. 
+	 * serialize delete_inode on multiple nodes.
 	 *
 	 * Even though we might be doing a truncate, we don't take the
 	 * allocation lock here as it won't be needed - nobody will
@@ -947,15 +945,15 @@ void ocfs2_delete_inode(struct inode *inode)
 	 * before we go ahead and wipe the inode. */
 	status = ocfs2_query_inode_wipe(inode, di_bh, &wipe);
 	if (!wipe || status < 0) {
-		/* Error and inode busy vote both mean we won't be
+		/* Error and remote inode busy both mean we won't be
 		 * removing the inode, so they take almost the same
 		 * path. */
 		if (status < 0)
 			mlog_errno(status);
 
-		/* Someone in the cluster has voted to not wipe this
-		 * inode, or it was never completely orphaned. Write
-		 * out the pages and exit now. */
+		/* Someone in the cluster has disallowed a wipe of
+		 * this inode, or it was never completely
+		 * orphaned. Write out the pages and exit now. */
 		ocfs2_cleanup_delete_inode(inode, 1);
 		goto bail_unlock_inode;
 	}
@@ -1008,12 +1006,12 @@ void ocfs2_clear_inode(struct inode *inode)
 	mlog_bug_on_msg(OCFS2_SB(inode->i_sb) == NULL,
 			"Inode=%lu\n", inode->i_ino);
 
-	/* For remove delete_inode vote, we hold open lock before,
-	 * now it is time to unlock PR and EX open locks. */
+	/* To preven remote deletes we hold open lock before, now it
+	 * is time to unlock PR and EX open locks. */
 	ocfs2_open_unlock(inode);
 
 	/* Do these before all the other work so that we don't bounce
-	 * the vote thread while waiting to destroy the locks. */
+	 * the downconvert thread while waiting to destroy the locks. */
 	ocfs2_mark_lockres_freeing(&oi->ip_rw_lockres);
 	ocfs2_mark_lockres_freeing(&oi->ip_meta_lockres);
 	ocfs2_mark_lockres_freeing(&oi->ip_data_lockres);
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 8d81f6c..f2ebe2e 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -44,7 +44,6 @@
 #include "localalloc.h"
 #include "slot_map.h"
 #include "super.h"
-#include "vote.h"
 #include "sysfile.h"
 
 #include "buffer_head_io.h"
@@ -103,7 +102,7 @@ static int ocfs2_commit_cache(struct ocfs2_super *osb)
 	mlog(0, "commit_thread: flushed transaction %lu (%u handles)\n",
 	     journal->j_trans_id, flushed);
 
-	ocfs2_kick_vote_thread(osb);
+	ocfs2_wake_downconvert_thread(osb);
 	wake_up(&journal->j_checkpointed);
 finally:
 	mlog_exit(status);
@@ -883,8 +882,8 @@ restart:
 	ocfs2_super_unlock(osb, 1);
 
 	/* We always run recovery on our own orphan dir - the dead
-	 * node(s) may have voted "no" on an inode delete earlier. A
-	 * revote is therefore required. */
+	 * node(s) may have disallowd a previos inode delete. Re-processing
+	 * is therefore required. */
 	ocfs2_queue_recovery_completion(osb->journal, osb->slot_num, NULL,
 					NULL);
 
@@ -1380,10 +1379,10 @@ static int ocfs2_recover_orphans(struct ocfs2_super *osb,
 		iter = oi->ip_next_orphan;
 
 		spin_lock(&oi->ip_lock);
-		/* Delete voting may have set these on the assumption
-		 * that the other node would wipe them successfully.
-		 * If they are still in the node's orphan dir, we need
-		 * to reset that state. */
+		/* The remote delete code may have set these on the
+		 * assumption that the other node would wipe them
+		 * successfully.  If they are still in the node's
+		 * orphan dir, we need to reset that state. */
 		oi->ip_flags &= ~(OCFS2_INODE_DELETED|OCFS2_INODE_SKIP_DELETE);
 
 		/* Set the proper information to get us going into
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 989ac27..6295fd6 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -60,7 +60,6 @@
 #include "symlink.h"
 #include "sysfile.h"
 #include "uptodate.h"
-#include "vote.h"
 
 #include "buffer_head_io.h"
 
@@ -176,7 +175,7 @@ bail_unlock:
 	/* Don't drop the cluster lock until *after* the d_add --
 	 * unlink on another node will message us to remove that
 	 * dentry under this lock so otherwise we can race this with
-	 * the vote thread and have a stale dentry. */
+	 * the downconvert thread and have a stale dentry. */
 	ocfs2_meta_unlock(dir, 0);
 
 bail:
@@ -765,7 +764,7 @@ static int ocfs2_unlink(struct inode *dir,
 
 	status = ocfs2_remote_dentry_delete(dentry);
 	if (status < 0) {
-		/* This vote should succeed under all normal
+		/* This remote delete should succeed under all normal
 		 * circumstances. */
 		mlog_errno(status);
 		goto leave;
@@ -1031,8 +1030,9 @@ static int ocfs2_rename(struct inode *old_dir,
 
 	/*
 	 * Aside from allowing a meta data update, the locking here
-	 * also ensures that the vote thread on other nodes won't have
-	 * to concurrently downconvert the inode and the dentry locks.
+	 * also ensures that the downconvert thread on other nodes
+	 * won't have to concurrently downconvert the inode and the
+	 * dentry locks.
 	 */
 	status = ocfs2_meta_lock(old_inode, &old_inode_bh, 1);
 	if (status < 0) {
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 60a23e1..f8f8661 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -189,9 +189,7 @@ struct ocfs2_super
 	struct ocfs2_slot_info *slot_info;
 
 	spinlock_t node_map_lock;
-	struct ocfs2_node_map mounted_map;
 	struct ocfs2_node_map recovery_map;
-	struct ocfs2_node_map umount_map;
 
 	u64 root_blkno;
 	u64 system_dir_blkno;
@@ -254,28 +252,15 @@ struct ocfs2_super
 
 	wait_queue_head_t recovery_event;
 
-	spinlock_t vote_task_lock;
-	struct task_struct *vote_task;
-	wait_queue_head_t vote_event;
-	unsigned long vote_wake_sequence;
-	unsigned long vote_work_sequence;
+	spinlock_t dc_task_lock;
+	struct task_struct *dc_task;
+	wait_queue_head_t dc_event;
+	unsigned long dc_wake_sequence;
+	unsigned long dc_work_sequence;
 
 	struct list_head blocked_lock_list;
 	unsigned long blocked_lock_count;
 
-	struct list_head vote_list;
-	int vote_count;
-
-	u32 net_key;
-	spinlock_t net_response_lock;
-	unsigned int net_response_ids;
-	struct list_head net_response_list;
-
-	struct o2hb_callback_func osb_hb_up;
-	struct o2hb_callback_func osb_hb_down;
-
-	struct list_head	osb_net_handlers;
-
 	wait_queue_head_t		osb_mount_event;
 
 	/* Truncate log info */
diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index af4882b..3a50ce5 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -48,25 +48,6 @@ static void __ocfs2_fill_slot(struct ocfs2_slot_info *si,
 			      s16 slot_num,
 			      s16 node_num);
 
-/* Use the slot information we've collected to create a map of mounted
- * nodes. Should be holding an EX on super block. assumes slot info is
- * up to date. Note that we call this *after* we find a slot, so our
- * own node should be set in the map too... */
-void ocfs2_populate_mounted_map(struct ocfs2_super *osb)
-{
-	int i;
-	struct ocfs2_slot_info *si = osb->slot_info;
-
-	spin_lock(&si->si_lock);
-
-	for (i = 0; i < si->si_size; i++)
-		if (si->si_global_node_nums[i] != OCFS2_INVALID_SLOT)
-			ocfs2_node_map_set_bit(osb, &osb->mounted_map,
-					      si->si_global_node_nums[i]);
-
-	spin_unlock(&si->si_lock);
-}
-
 /* post the slot information on disk into our slot_info struct. */
 void ocfs2_update_slot_info(struct ocfs2_slot_info *si)
 {
diff --git a/fs/ocfs2/slot_map.h b/fs/ocfs2/slot_map.h
index d8c8cee..1025872 100644
--- a/fs/ocfs2/slot_map.h
+++ b/fs/ocfs2/slot_map.h
@@ -52,8 +52,6 @@ s16 ocfs2_node_num_to_slot(struct ocfs2_slot_info *si,
 void ocfs2_clear_slot(struct ocfs2_slot_info *si,
 		      s16 slot_num);
 
-void ocfs2_populate_mounted_map(struct ocfs2_super *osb);
-
 static inline int ocfs2_is_empty_slot(struct ocfs2_slot_info *si,
 				      int slot_num)
 {
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 64b81b3..1996820 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -65,7 +65,6 @@
 #include "sysfile.h"
 #include "uptodate.h"
 #include "ver.h"
-#include "vote.h"
 
 #include "buffer_head_io.h"
 
@@ -1123,13 +1122,6 @@ static int ocfs2_mount_volume(struct super_block *sb)
 		goto leave;
 	}
 
-	/* requires vote_thread to be running. */
-	status = ocfs2_register_net_handlers(osb);
-	if (status < 0) {
-		mlog_errno(status);
-		goto leave;
-	}
-
 	status = ocfs2_super_lock(osb, 1);
 	if (status < 0) {
 		mlog_errno(status);
@@ -1144,8 +1136,6 @@ static int ocfs2_mount_volume(struct super_block *sb)
 		goto leave;
 	}
 
-	ocfs2_populate_mounted_map(osb);
-
 	/* load all node-local system inodes */
 	status = ocfs2_init_local_system_inodes(osb);
 	if (status < 0) {
@@ -1168,15 +1158,6 @@ static int ocfs2_mount_volume(struct super_block *sb)
 	if (ocfs2_mount_local(osb))
 		goto leave;
 
-	/* This should be sent *after* we recovered our journal as it
-	 * will cause other nodes to unmark us as needing
-	 * recovery. However, we need to send it *before* dropping the
-	 * super block lock as otherwise their recovery threads might
-	 * try to clean us up while we're live! */
-	status = ocfs2_request_mount_vote(osb);
-	if (status < 0)
-		mlog_errno(status);
-
 leave:
 	if (unlock_super)
 		ocfs2_super_unlock(osb, 1);
@@ -1234,10 +1215,6 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 			mlog_errno(tmp);
 			return;
 		}
-
-		tmp = ocfs2_request_umount_vote(osb);
-		if (tmp < 0)
-			mlog_errno(tmp);
 	}
 
 	if (osb->slot_num != OCFS2_INVALID_SLOT)
@@ -1248,11 +1225,8 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 
 	ocfs2_release_system_inodes(osb);
 
-	if (osb->dlm) {
-		ocfs2_unregister_net_handlers(osb);
-
+	if (osb->dlm)
 		ocfs2_dlm_shutdown(osb);
-	}
 
 	debugfs_remove(osb->osb_debug_root);
 
@@ -1336,19 +1310,13 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	osb->s_sectsize_bits = blksize_bits(sector_size);
 	BUG_ON(!osb->s_sectsize_bits);
 
-	osb->net_response_ids = 0;
-	spin_lock_init(&osb->net_response_lock);
-	INIT_LIST_HEAD(&osb->net_response_list);
-
-	INIT_LIST_HEAD(&osb->osb_net_handlers);
 	init_waitqueue_head(&osb->recovery_event);
-	spin_lock_init(&osb->vote_task_lock);
-	init_waitqueue_head(&osb->vote_event);
-	osb->vote_work_sequence = 0;
-	osb->vote_wake_sequence = 0;
+	spin_lock_init(&osb->dc_task_lock);
+	init_waitqueue_head(&osb->dc_event);
+	osb->dc_work_sequence = 0;
+	osb->dc_wake_sequence = 0;
 	INIT_LIST_HEAD(&osb->blocked_lock_list);
 	osb->blocked_lock_count = 0;
-	INIT_LIST_HEAD(&osb->vote_list);
 	spin_lock_init(&osb->osb_lock);
 
 	atomic_set(&osb->alloc_stats.moves, 0);
@@ -1488,7 +1456,6 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	}
 
 	memcpy(&uuid_net_key, di->id2.i_super.s_uuid, sizeof(uuid_net_key));
-	osb->net_key = le32_to_cpu(uuid_net_key);
 
 	strncpy(osb->vol_label, di->id2.i_super.s_label, 63);
 	osb->vol_label[63] = '\0';
diff --git a/fs/ocfs2/vote.c b/fs/ocfs2/vote.c
deleted file mode 100644
index c053585..0000000
--- a/fs/ocfs2/vote.c
+++ /dev/null
@@ -1,756 +0,0 @@
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
- * vote.c
- *
- * description here
- *
- * Copyright (C) 2003, 2004 Oracle.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License as published by the Free Software Foundation; either
- * version 2 of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
- */
-
-#include <linux/types.h>
-#include <linux/slab.h>
-#include <linux/highmem.h>
-#include <linux/kthread.h>
-
-#include <cluster/heartbeat.h>
-#include <cluster/nodemanager.h>
-#include <cluster/tcp.h>
-
-#include <dlm/dlmapi.h>
-
-#define MLOG_MASK_PREFIX ML_VOTE
-#include <cluster/masklog.h>
-
-#include "ocfs2.h"
-
-#include "alloc.h"
-#include "dlmglue.h"
-#include "extent_map.h"
-#include "heartbeat.h"
-#include "inode.h"
-#include "journal.h"
-#include "slot_map.h"
-#include "vote.h"
-
-#include "buffer_head_io.h"
-
-#define OCFS2_MESSAGE_TYPE_VOTE     (0x1)
-#define OCFS2_MESSAGE_TYPE_RESPONSE (0x2)
-struct ocfs2_msg_hdr
-{
-	__be32 h_response_id; /* used to lookup message handle on sending
-			    * node. */
-	__be32 h_request;
-	__be64 h_blkno;
-	__be32 h_generation;
-	__be32 h_node_num;    /* node sending this particular message. */
-};
-
-struct ocfs2_vote_msg
-{
-	struct ocfs2_msg_hdr v_hdr;
-	__be32 v_reserved1;
-} __attribute__ ((packed));
-
-/* Responses are given these values to maintain backwards
- * compatibility with older ocfs2 versions */
-#define OCFS2_RESPONSE_OK		(0)
-#define OCFS2_RESPONSE_BUSY		(-16)
-#define OCFS2_RESPONSE_BAD_MSG		(-22)
-
-struct ocfs2_response_msg
-{
-	struct ocfs2_msg_hdr r_hdr;
-	__be32 r_response;
-} __attribute__ ((packed));
-
-struct ocfs2_vote_work {
-	struct list_head   w_list;
-	struct ocfs2_vote_msg w_msg;
-};
-
-enum ocfs2_vote_request {
-	OCFS2_VOTE_REQ_INVALID = 0,
-	OCFS2_VOTE_REQ_MOUNT,
-	OCFS2_VOTE_REQ_UMOUNT,
-	OCFS2_VOTE_REQ_LAST
-};
-
-static inline int ocfs2_is_valid_vote_request(int request)
-{
-	return OCFS2_VOTE_REQ_INVALID < request &&
-		request < OCFS2_VOTE_REQ_LAST;
-}
-
-typedef void (*ocfs2_net_response_callback)(void *priv,
-					    struct ocfs2_response_msg *resp);
-struct ocfs2_net_response_cb {
-	ocfs2_net_response_callback	rc_cb;
-	void				*rc_priv;
-};
-
-struct ocfs2_net_wait_ctxt {
-	struct list_head        n_list;
-	u32                     n_response_id;
-	wait_queue_head_t       n_event;
-	struct ocfs2_node_map   n_node_map;
-	int                     n_response; /* an agreggate response. 0 if
-					     * all nodes are go, < 0 on any
-					     * negative response from any
-					     * node or network error. */
-	struct ocfs2_net_response_cb *n_callback;
-};
-
-static void ocfs2_process_mount_request(struct ocfs2_super *osb,
-					unsigned int node_num)
-{
-	mlog(0, "MOUNT vote from node %u\n", node_num);
-	/* The other node only sends us this message when he has an EX
-	 * on the superblock, so our recovery threads (if having been
-	 * launched) are waiting on it.*/
-	ocfs2_recovery_map_clear(osb, node_num);
-	ocfs2_node_map_set_bit(osb, &osb->mounted_map, node_num);
-
-	/* We clear the umount map here because a node may have been
-	 * previously mounted, safely unmounted but never stopped
-	 * heartbeating - in which case we'd have a stale entry. */
-	ocfs2_node_map_clear_bit(osb, &osb->umount_map, node_num);
-}
-
-static void ocfs2_process_umount_request(struct ocfs2_super *osb,
-					 unsigned int node_num)
-{
-	mlog(0, "UMOUNT vote from node %u\n", node_num);
-	ocfs2_node_map_clear_bit(osb, &osb->mounted_map, node_num);
-	ocfs2_node_map_set_bit(osb, &osb->umount_map, node_num);
-}
-
-static void ocfs2_process_vote(struct ocfs2_super *osb,
-			       struct ocfs2_vote_msg *msg)
-{
-	int net_status, vote_response;
-	unsigned int node_num;
-	u64 blkno;
-	enum ocfs2_vote_request request;
-	struct ocfs2_msg_hdr *hdr = &msg->v_hdr;
-	struct ocfs2_response_msg response;
-
-	/* decode the network mumbo jumbo into local variables. */
-	request = be32_to_cpu(hdr->h_request);
-	blkno = be64_to_cpu(hdr->h_blkno);
-	node_num = be32_to_cpu(hdr->h_node_num);
-
-	mlog(0, "processing vote: request = %u, blkno = %llu, node_num = %u\n",
-	     request, (unsigned long long)blkno, node_num);
-
-	if (!ocfs2_is_valid_vote_request(request)) {
-		mlog(ML_ERROR, "Invalid vote request %d from node %u\n",
-		     request, node_num);
-		vote_response = OCFS2_RESPONSE_BAD_MSG;
-		goto respond;
-	}
-
-	vote_response = OCFS2_RESPONSE_OK;
-
-	switch (request) {
-	case OCFS2_VOTE_REQ_UMOUNT:
-		ocfs2_process_umount_request(osb, node_num);
-		goto respond;
-	case OCFS2_VOTE_REQ_MOUNT:
-		ocfs2_process_mount_request(osb, node_num);
-		goto respond;
-	default:
-		/* avoids a gcc warning */
-		break;
-	}
-
-respond:
-	/* Response struture is small so we just put it on the stack
-	 * and stuff it inline. */
-	memset(&response, 0, sizeof(struct ocfs2_response_msg));
-	response.r_hdr.h_response_id = hdr->h_response_id;
-	response.r_hdr.h_blkno = hdr->h_blkno;
-	response.r_hdr.h_generation = hdr->h_generation;
-	response.r_hdr.h_node_num = cpu_to_be32(osb->node_num);
-	response.r_response = cpu_to_be32(vote_response);
-
-	net_status = o2net_send_message(OCFS2_MESSAGE_TYPE_RESPONSE,
-					osb->net_key,
-					&response,
-					sizeof(struct ocfs2_response_msg),
-					node_num,
-					NULL);
-	/* We still want to error print for ENOPROTOOPT here. The
-	 * sending node shouldn't have unregistered his net handler
-	 * without sending an unmount vote 1st */
-	if (net_status < 0
-	    && net_status != -ETIMEDOUT
-	    && net_status != -ENOTCONN)
-		mlog(ML_ERROR, "message to node %u fails with error %d!\n",
-		     node_num, net_status);
-}
-
-static void ocfs2_vote_thread_do_work(struct ocfs2_super *osb)
-{
-	unsigned long processed;
-	struct ocfs2_lock_res *lockres;
-	struct ocfs2_vote_work *work;
-
-	mlog_entry_void();
-
-	spin_lock(&osb->vote_task_lock);
-	/* grab this early so we know to try again if a state change and
-	 * wake happens part-way through our work  */
-	osb->vote_work_sequence = osb->vote_wake_sequence;
-
-	processed = osb->blocked_lock_count;
-	while (processed) {
-		BUG_ON(list_empty(&osb->blocked_lock_list));
-
-		lockres = list_entry(osb->blocked_lock_list.next,
-				     struct ocfs2_lock_res, l_blocked_list);
-		list_del_init(&lockres->l_blocked_list);
-		osb->blocked_lock_count--;
-		spin_unlock(&osb->vote_task_lock);
-
-		BUG_ON(!processed);
-		processed--;
-
-		ocfs2_process_blocked_lock(osb, lockres);
-
-		spin_lock(&osb->vote_task_lock);
-	}
-
-	while (osb->vote_count) {
-		BUG_ON(list_empty(&osb->vote_list));
-		work = list_entry(osb->vote_list.next,
-				  struct ocfs2_vote_work, w_list);
-		list_del(&work->w_list);
-		osb->vote_count--;
-		spin_unlock(&osb->vote_task_lock);
-
-		ocfs2_process_vote(osb, &work->w_msg);
-		kfree(work);
-
-		spin_lock(&osb->vote_task_lock);
-	}
-	spin_unlock(&osb->vote_task_lock);
-
-	mlog_exit_void();
-}
-
-static int ocfs2_vote_thread_lists_empty(struct ocfs2_super *osb)
-{
-	int empty = 0;
-
-	spin_lock(&osb->vote_task_lock);
-	if (list_empty(&osb->blocked_lock_list) &&
-	    list_empty(&osb->vote_list))
-		empty = 1;
-
-	spin_unlock(&osb->vote_task_lock);
-	return empty;
-}
-
-static int ocfs2_vote_thread_should_wake(struct ocfs2_super *osb)
-{
-	int should_wake = 0;
-
-	spin_lock(&osb->vote_task_lock);
-	if (osb->vote_work_sequence != osb->vote_wake_sequence)
-		should_wake = 1;
-	spin_unlock(&osb->vote_task_lock);
-
-	return should_wake;
-}
-
-int ocfs2_vote_thread(void *arg)
-{
-	int status = 0;
-	struct ocfs2_super *osb = arg;
-
-	/* only quit once we've been asked to stop and there is no more
-	 * work available */
-	while (!(kthread_should_stop() &&
-		 ocfs2_vote_thread_lists_empty(osb))) {
-
-		wait_event_interruptible(osb->vote_event,
-					 ocfs2_vote_thread_should_wake(osb) ||
-					 kthread_should_stop());
-
-		mlog(0, "vote_thread: awoken\n");
-
-		ocfs2_vote_thread_do_work(osb);
-	}
-
-	osb->vote_task = NULL;
-	return status;
-}
-
-static struct ocfs2_net_wait_ctxt *ocfs2_new_net_wait_ctxt(unsigned int response_id)
-{
-	struct ocfs2_net_wait_ctxt *w;
-
-	w = kzalloc(sizeof(*w), GFP_NOFS);
-	if (!w) {
-		mlog_errno(-ENOMEM);
-		goto bail;
-	}
-
-	INIT_LIST_HEAD(&w->n_list);
-	init_waitqueue_head(&w->n_event);
-	ocfs2_node_map_init(&w->n_node_map);
-	w->n_response_id = response_id;
-	w->n_callback = NULL;
-bail:
-	return w;
-}
-
-static unsigned int ocfs2_new_response_id(struct ocfs2_super *osb)
-{
-	unsigned int ret;
-
-	spin_lock(&osb->net_response_lock);
-	ret = ++osb->net_response_ids;
-	spin_unlock(&osb->net_response_lock);
-
-	return ret;
-}
-
-static void ocfs2_dequeue_net_wait_ctxt(struct ocfs2_super *osb,
-					struct ocfs2_net_wait_ctxt *w)
-{
-	spin_lock(&osb->net_response_lock);
-	list_del(&w->n_list);
-	spin_unlock(&osb->net_response_lock);
-}
-
-static void ocfs2_queue_net_wait_ctxt(struct ocfs2_super *osb,
-				      struct ocfs2_net_wait_ctxt *w)
-{
-	spin_lock(&osb->net_response_lock);
-	list_add_tail(&w->n_list,
-		      &osb->net_response_list);
-	spin_unlock(&osb->net_response_lock);
-}
-
-static void __ocfs2_mark_node_responded(struct ocfs2_super *osb,
-					struct ocfs2_net_wait_ctxt *w,
-					int node_num)
-{
-	assert_spin_locked(&osb->net_response_lock);
-
-	ocfs2_node_map_clear_bit(osb, &w->n_node_map, node_num);
-	if (ocfs2_node_map_is_empty(osb, &w->n_node_map))
-		wake_up(&w->n_event);
-}
-
-/* Intended to be called from the node down callback, we fake remove
- * the node from all our response contexts */
-void ocfs2_remove_node_from_vote_queues(struct ocfs2_super *osb,
-					int node_num)
-{
-	struct list_head *p;
-	struct ocfs2_net_wait_ctxt *w = NULL;
-
-	spin_lock(&osb->net_response_lock);
-
-	list_for_each(p, &osb->net_response_list) {
-		w = list_entry(p, struct ocfs2_net_wait_ctxt, n_list);
-
-		__ocfs2_mark_node_responded(osb, w, node_num);
-	}
-
-	spin_unlock(&osb->net_response_lock);
-}
-
-static int ocfs2_broadcast_vote(struct ocfs2_super *osb,
-				struct ocfs2_vote_msg *request,
-				unsigned int response_id,
-				int *response,
-				struct ocfs2_net_response_cb *callback)
-{
-	int status, i, remote_err;
-	struct ocfs2_net_wait_ctxt *w = NULL;
-	int dequeued = 0;
-
-	mlog_entry_void();
-
-	w = ocfs2_new_net_wait_ctxt(response_id);
-	if (!w) {
-		status = -ENOMEM;
-		mlog_errno(status);
-		goto bail;
-	}
-	w->n_callback = callback;
-
-	/* we're pretty much ready to go at this point, and this fills
-	 * in n_response which we need anyway... */
-	ocfs2_queue_net_wait_ctxt(osb, w);
-
-	i = ocfs2_node_map_iterate(osb, &osb->mounted_map, 0);
-
-	while (i != O2NM_INVALID_NODE_NUM) {
-		if (i != osb->node_num) {
-			mlog(0, "trying to send request to node %i\n", i);
-			ocfs2_node_map_set_bit(osb, &w->n_node_map, i);
-
-			remote_err = 0;
-			status = o2net_send_message(OCFS2_MESSAGE_TYPE_VOTE,
-						    osb->net_key,
-						    request,
-						    sizeof(*request),
-						    i,
-						    &remote_err);
-			if (status == -ETIMEDOUT) {
-				mlog(0, "remote node %d timed out!\n", i);
-				status = -EAGAIN;
-				goto bail;
-			}
-			if (remote_err < 0) {
-				status = remote_err;
-				mlog(0, "remote error %d on node %d!\n",
-				     remote_err, i);
-				mlog_errno(status);
-				goto bail;
-			}
-			if (status < 0) {
-				mlog_errno(status);
-				goto bail;
-			}
-		}
-		i++;
-		i = ocfs2_node_map_iterate(osb, &osb->mounted_map, i);
-		mlog(0, "next is %d, i am %d\n", i, osb->node_num);
-	}
-	mlog(0, "done sending, now waiting on responses...\n");
-
-	wait_event(w->n_event, ocfs2_node_map_is_empty(osb, &w->n_node_map));
-
-	ocfs2_dequeue_net_wait_ctxt(osb, w);
-	dequeued = 1;
-
-	*response = w->n_response;
-	status = 0;
-bail:
-	if (w) {
-		if (!dequeued)
-			ocfs2_dequeue_net_wait_ctxt(osb, w);
-		kfree(w);
-	}
-
-	mlog_exit(status);
-	return status;
-}
-
-static struct ocfs2_vote_msg * ocfs2_new_vote_request(struct ocfs2_super *osb,
-						      u64 blkno,
-						      unsigned int generation,
-						      enum ocfs2_vote_request type)
-{
-	struct ocfs2_vote_msg *request;
-	struct ocfs2_msg_hdr *hdr;
-
-	BUG_ON(!ocfs2_is_valid_vote_request(type));
-
-	request = kzalloc(sizeof(*request), GFP_NOFS);
-	if (!request) {
-		mlog_errno(-ENOMEM);
-	} else {
-		hdr = &request->v_hdr;
-		hdr->h_node_num = cpu_to_be32(osb->node_num);
-		hdr->h_request = cpu_to_be32(type);
-		hdr->h_blkno = cpu_to_be64(blkno);
-		hdr->h_generation = cpu_to_be32(generation);
-	}
-
-	return request;
-}
-
-/* Complete the buildup of a new vote request and process the
- * broadcast return value. */
-static int ocfs2_do_request_vote(struct ocfs2_super *osb,
-				 struct ocfs2_vote_msg *request,
-				 struct ocfs2_net_response_cb *callback)
-{
-	int status, response = -EBUSY;
-	unsigned int response_id;
-	struct ocfs2_msg_hdr *hdr;
-
-	response_id = ocfs2_new_response_id(osb);
-
-	hdr = &request->v_hdr;
-	hdr->h_response_id = cpu_to_be32(response_id);
-
-	status = ocfs2_broadcast_vote(osb, request, response_id, &response,
-				      callback);
-	if (status < 0) {
-		mlog_errno(status);
-		goto bail;
-	}
-
-	status = response;
-bail:
-
-	return status;
-}
-
-int ocfs2_request_mount_vote(struct ocfs2_super *osb)
-{
-	int status;
-	struct ocfs2_vote_msg *request = NULL;
-
-	request = ocfs2_new_vote_request(osb, 0ULL, 0, OCFS2_VOTE_REQ_MOUNT);
-	if (!request) {
-		status = -ENOMEM;
-		goto bail;
-	}
-
-	status = -EAGAIN;
-	while (status == -EAGAIN) {
-		if (!(osb->s_mount_opt & OCFS2_MOUNT_NOINTR) &&
-		    signal_pending(current)) {
-			status = -ERESTARTSYS;
-			goto bail;
-		}
-
-		if (ocfs2_node_map_is_only(osb, &osb->mounted_map,
-					   osb->node_num)) {
-			status = 0;
-			goto bail;
-		}
-
-		status = ocfs2_do_request_vote(osb, request, NULL);
-	}
-
-bail:
-	kfree(request);
-	return status;
-}
-
-int ocfs2_request_umount_vote(struct ocfs2_super *osb)
-{
-	int status;
-	struct ocfs2_vote_msg *request = NULL;
-
-	request = ocfs2_new_vote_request(osb, 0ULL, 0, OCFS2_VOTE_REQ_UMOUNT);
-	if (!request) {
-		status = -ENOMEM;
-		goto bail;
-	}
-
-	status = -EAGAIN;
-	while (status == -EAGAIN) {
-		/* Do not check signals on this vote... We really want
-		 * this one to go all the way through. */
-
-		if (ocfs2_node_map_is_only(osb, &osb->mounted_map,
-					   osb->node_num)) {
-			status = 0;
-			goto bail;
-		}
-
-		status = ocfs2_do_request_vote(osb, request, NULL);
-	}
-
-bail:
-	kfree(request);
-	return status;
-}
-
-/* TODO: This should eventually be a hash table! */
-static struct ocfs2_net_wait_ctxt * __ocfs2_find_net_wait_ctxt(struct ocfs2_super *osb,
-							       u32 response_id)
-{
-	struct list_head *p;
-	struct ocfs2_net_wait_ctxt *w = NULL;
-
-	list_for_each(p, &osb->net_response_list) {
-		w = list_entry(p, struct ocfs2_net_wait_ctxt, n_list);
-		if (response_id == w->n_response_id)
-			break;
-		w = NULL;
-	}
-
-	return w;
-}
-
-/* Translate response codes into local node errno values */
-static inline int ocfs2_translate_response(int response)
-{
-	int ret;
-
-	switch (response) {
-	case OCFS2_RESPONSE_OK:
-		ret = 0;
-		break;
-
-	case OCFS2_RESPONSE_BUSY:
-		ret = -EBUSY;
-		break;
-
-	default:
-		ret = -EINVAL;
-	}
-
-	return ret;
-}
-
-static int ocfs2_handle_response_message(struct o2net_msg *msg,
-					 u32 len,
-					 void *data, void **ret_data)
-{
-	unsigned int response_id, node_num;
-	int response_status;
-	struct ocfs2_super *osb = data;
-	struct ocfs2_response_msg *resp;
-	struct ocfs2_net_wait_ctxt * w;
-	struct ocfs2_net_response_cb *resp_cb;
-
-	resp = (struct ocfs2_response_msg *) msg->buf;
-
-	response_id = be32_to_cpu(resp->r_hdr.h_response_id);
-	node_num = be32_to_cpu(resp->r_hdr.h_node_num);
-	response_status = 
-		ocfs2_translate_response(be32_to_cpu(resp->r_response));
-
-	mlog(0, "received response message:\n");
-	mlog(0, "h_response_id = %u\n", response_id);
-	mlog(0, "h_request = %u\n", be32_to_cpu(resp->r_hdr.h_request));
-	mlog(0, "h_blkno = %llu\n",
-	     (unsigned long long)be64_to_cpu(resp->r_hdr.h_blkno));
-	mlog(0, "h_generation = %u\n", be32_to_cpu(resp->r_hdr.h_generation));
-	mlog(0, "h_node_num = %u\n", node_num);
-	mlog(0, "r_response = %d\n", response_status);
-
-	spin_lock(&osb->net_response_lock);
-	w = __ocfs2_find_net_wait_ctxt(osb, response_id);
-	if (!w) {
-		mlog(0, "request not found!\n");
-		goto bail;
-	}
-	resp_cb = w->n_callback;
-
-	if (response_status && (!w->n_response)) {
-		/* we only really need one negative response so don't
-		 * set it twice. */
-		w->n_response = response_status;
-	}
-
-	if (resp_cb) {
-		spin_unlock(&osb->net_response_lock);
-
-		resp_cb->rc_cb(resp_cb->rc_priv, resp);
-
-		spin_lock(&osb->net_response_lock);
-	}
-
-	__ocfs2_mark_node_responded(osb, w, node_num);
-bail:
-	spin_unlock(&osb->net_response_lock);
-
-	return 0;
-}
-
-static int ocfs2_handle_vote_message(struct o2net_msg *msg,
-				     u32 len,
-				     void *data, void **ret_data)
-{
-	int status;
-	struct ocfs2_super *osb = data;
-	struct ocfs2_vote_work *work;
-
-	work = kmalloc(sizeof(struct ocfs2_vote_work), GFP_NOFS);
-	if (!work) {
-		status = -ENOMEM;
-		mlog_errno(status);
-		goto bail;
-	}
-
-	INIT_LIST_HEAD(&work->w_list);
-	memcpy(&work->w_msg, msg->buf, sizeof(struct ocfs2_vote_msg));
-
-	mlog(0, "scheduling vote request:\n");
-	mlog(0, "h_response_id = %u\n",
-	     be32_to_cpu(work->w_msg.v_hdr.h_response_id));
-	mlog(0, "h_request = %u\n", be32_to_cpu(work->w_msg.v_hdr.h_request));
-	mlog(0, "h_blkno = %llu\n",
-	     (unsigned long long)be64_to_cpu(work->w_msg.v_hdr.h_blkno));
-	mlog(0, "h_generation = %u\n",
-	     be32_to_cpu(work->w_msg.v_hdr.h_generation));
-	mlog(0, "h_node_num = %u\n",
-	     be32_to_cpu(work->w_msg.v_hdr.h_node_num));
-
-	spin_lock(&osb->vote_task_lock);
-	list_add_tail(&work->w_list, &osb->vote_list);
-	osb->vote_count++;
-	spin_unlock(&osb->vote_task_lock);
-
-	ocfs2_kick_vote_thread(osb);
-
-	status = 0;
-bail:
-	return status;
-}
-
-void ocfs2_unregister_net_handlers(struct ocfs2_super *osb)
-{
-	if (!osb->net_key)
-		return;
-
-	o2net_unregister_handler_list(&osb->osb_net_handlers);
-
-	if (!list_empty(&osb->net_response_list))
-		mlog(ML_ERROR, "net response list not empty!\n");
-
-	osb->net_key = 0;
-}
-
-int ocfs2_register_net_handlers(struct ocfs2_super *osb)
-{
-	int status = 0;
-
-	if (ocfs2_mount_local(osb))
-		return 0;
-
-	status = o2net_register_handler(OCFS2_MESSAGE_TYPE_RESPONSE,
-					osb->net_key,
-					sizeof(struct ocfs2_response_msg),
-					ocfs2_handle_response_message,
-					osb, NULL, &osb->osb_net_handlers);
-	if (status) {
-		mlog_errno(status);
-		goto bail;
-	}
-
-	status = o2net_register_handler(OCFS2_MESSAGE_TYPE_VOTE,
-					osb->net_key,
-					sizeof(struct ocfs2_vote_msg),
-					ocfs2_handle_vote_message,
-					osb, NULL, &osb->osb_net_handlers);
-	if (status) {
-		mlog_errno(status);
-		goto bail;
-	}
-bail:
-	if (status < 0)
-		ocfs2_unregister_net_handlers(osb);
-
-	return status;
-}
diff --git a/fs/ocfs2/vote.h b/fs/ocfs2/vote.h
deleted file mode 100644
index 9ea46f6..0000000
--- a/fs/ocfs2/vote.h
+++ /dev/null
@@ -1,48 +0,0 @@
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
- * vote.h
- *
- * description here
- *
- * Copyright (C) 2002, 2004 Oracle.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License as published by the Free Software Foundation; either
- * version 2 of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
- */
-
-
-#ifndef VOTE_H
-#define VOTE_H
-
-int ocfs2_vote_thread(void *arg);
-static inline void ocfs2_kick_vote_thread(struct ocfs2_super *osb)
-{
-	spin_lock(&osb->vote_task_lock);
-	/* make sure the voting thread gets a swipe at whatever changes
-	 * the caller may have made to the voting state */
-	osb->vote_wake_sequence++;
-	spin_unlock(&osb->vote_task_lock);
-	wake_up(&osb->vote_event);
-}
-
-int ocfs2_request_mount_vote(struct ocfs2_super *osb);
-int ocfs2_request_umount_vote(struct ocfs2_super *osb);
-int ocfs2_register_net_handlers(struct ocfs2_super *osb);
-void ocfs2_unregister_net_handlers(struct ocfs2_super *osb);
-
-void ocfs2_remove_node_from_vote_queues(struct ocfs2_super *osb,
-					int node_num);
-#endif
-- 
1.5.3.6
