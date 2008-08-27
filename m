From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 27 Aug 2008 10:36:38 -0700
Subject: [Ocfs2-devel] [git patches] Ocfs2 and Configfs fixes
Message-ID: <20080827173638.GN4563@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Andrew Morton <akpm@linux-foundation.org>

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/configfs/dir.c               |   17 ++++++--------
 fs/ocfs2/cluster/netdebug.c     |   26 +++++++++++-----------
 fs/ocfs2/cluster/tcp.c          |   44 ++++++++++++++++++++++++++++++++------
 fs/ocfs2/cluster/tcp_internal.h |   32 ----------------------------
 fs/ocfs2/dir.c                  |   11 +++++++--
 fs/ocfs2/journal.c              |   23 ++++++++++++--------
 fs/ocfs2/stackglue.c            |    7 +++--
 7 files changed, 83 insertions(+), 77 deletions(-)

Adrian Bunk (1):
      ocfs2/cluster/tcp.c: make some functions static

Alexander Beregalov (1):
      ocfs2/cluster/netdebug.c: fix warning

Joel Becker (1):
      ocfs2: Increment the reference count of an already-active stack.

Louis Rilling (1):
      configfs: Consolidate locking around configfs_detach_prep() in configfs_rmdir()

Mark Fasheh (2):
      ocfs2: Fix sleep-with-spinlock recovery regression
      ocfs2: correctly set i_blocks after inline dir gets expanded

Tao Ma (1):
      ocfs2: Jump to correct label in ocfs2_expand_inline_dir()

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 7a8db78..8e93341 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -1311,16 +1311,18 @@ static int configfs_rmdir(struct inode *dir, struct dentry *dentry)
 	 * Ensure that no racing symlink() will make detach_prep() fail while
 	 * the new link is temporarily attached
 	 */
-	mutex_lock(&configfs_symlink_mutex);
-	spin_lock(&configfs_dirent_lock);
 	do {
 		struct mutex *wait_mutex;
 
+		mutex_lock(&configfs_symlink_mutex);
+		spin_lock(&configfs_dirent_lock);
 		ret = configfs_detach_prep(dentry, &wait_mutex);
-		if (ret) {
+		if (ret)
 			configfs_detach_rollback(dentry);
-			spin_unlock(&configfs_dirent_lock);
-			mutex_unlock(&configfs_symlink_mutex);
+		spin_unlock(&configfs_dirent_lock);
+		mutex_unlock(&configfs_symlink_mutex);
+
+		if (ret) {
 			if (ret != -EAGAIN) {
 				config_item_put(parent_item);
 				return ret;
@@ -1329,13 +1331,8 @@ static int configfs_rmdir(struct inode *dir, struct dentry *dentry)
 			/* Wait until the racing operation terminates */
 			mutex_lock(wait_mutex);
 			mutex_unlock(wait_mutex);
-
-			mutex_lock(&configfs_symlink_mutex);
-			spin_lock(&configfs_dirent_lock);
 		}
 	} while (ret == -EAGAIN);
-	spin_unlock(&configfs_dirent_lock);
-	mutex_unlock(&configfs_symlink_mutex);
 
 	/* Get a working ref for the duration of this function */
 	item = configfs_get_config_item(dentry);
diff --git a/fs/ocfs2/cluster/netdebug.c b/fs/ocfs2/cluster/netdebug.c
index d8bfa0e..52276c0 100644
--- a/fs/ocfs2/cluster/netdebug.c
+++ b/fs/ocfs2/cluster/netdebug.c
@@ -138,20 +138,20 @@ static int nst_seq_show(struct seq_file *seq, void *v)
 			   "  message id:   %d\n"
 			   "  message type: %u\n"
 			   "  message key:  0x%08x\n"
-			   "  sock acquiry: %lu.%lu\n"
-			   "  send start:   %lu.%lu\n"
-			   "  wait start:   %lu.%lu\n",
+			   "  sock acquiry: %lu.%ld\n"
+			   "  send start:   %lu.%ld\n"
+			   "  wait start:   %lu.%ld\n",
 			   nst, (unsigned long)nst->st_task->pid,
 			   (unsigned long)nst->st_task->tgid,
 			   nst->st_task->comm, nst->st_node,
 			   nst->st_sc, nst->st_id, nst->st_msg_type,
 			   nst->st_msg_key,
 			   nst->st_sock_time.tv_sec,
-			   (unsigned long)nst->st_sock_time.tv_usec,
+			   (long)nst->st_sock_time.tv_usec,
 			   nst->st_send_time.tv_sec,
-			   (unsigned long)nst->st_send_time.tv_usec,
+			   (long)nst->st_send_time.tv_usec,
 			   nst->st_status_time.tv_sec,
-			   nst->st_status_time.tv_usec);
+			   (long)nst->st_status_time.tv_usec);
 	}
 
 	spin_unlock(&o2net_debug_lock);
@@ -276,7 +276,7 @@ static void *sc_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 	return sc; /* unused, just needs to be null when done */
 }
 
-#define TV_SEC_USEC(TV) TV.tv_sec, (unsigned long)TV.tv_usec
+#define TV_SEC_USEC(TV) TV.tv_sec, (long)TV.tv_usec
 
 static int sc_seq_show(struct seq_file *seq, void *v)
 {
@@ -309,12 +309,12 @@ static int sc_seq_show(struct seq_file *seq, void *v)
 			   "  remote node:     %s\n"
 			   "  page off:        %zu\n"
 			   "  handshake ok:    %u\n"
-			   "  timer:           %lu.%lu\n"
-			   "  data ready:      %lu.%lu\n"
-			   "  advance start:   %lu.%lu\n"
-			   "  advance stop:    %lu.%lu\n"
-			   "  func start:      %lu.%lu\n"
-			   "  func stop:       %lu.%lu\n"
+			   "  timer:           %lu.%ld\n"
+			   "  data ready:      %lu.%ld\n"
+			   "  advance start:   %lu.%ld\n"
+			   "  advance stop:    %lu.%ld\n"
+			   "  func start:      %lu.%ld\n"
+			   "  func stop:       %lu.%ld\n"
 			   "  func key:        %u\n"
 			   "  func type:       %u\n",
 			   sc,
diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index a27d615..2bcf706 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -143,8 +143,8 @@ static void o2net_sc_postpone_idle(struct o2net_sock_container *sc);
 static void o2net_sc_reset_idle_timer(struct o2net_sock_container *sc);
 
 #ifdef CONFIG_DEBUG_FS
-void o2net_init_nst(struct o2net_send_tracking *nst, u32 msgtype,
-		    u32 msgkey, struct task_struct *task, u8 node)
+static void o2net_init_nst(struct o2net_send_tracking *nst, u32 msgtype,
+			   u32 msgkey, struct task_struct *task, u8 node)
 {
 	INIT_LIST_HEAD(&nst->st_net_debug_item);
 	nst->st_task = task;
@@ -153,31 +153,61 @@ void o2net_init_nst(struct o2net_send_tracking *nst, u32 msgtype,
 	nst->st_node = node;
 }
 
-void o2net_set_nst_sock_time(struct o2net_send_tracking *nst)
+static void o2net_set_nst_sock_time(struct o2net_send_tracking *nst)
 {
 	do_gettimeofday(&nst->st_sock_time);
 }
 
-void o2net_set_nst_send_time(struct o2net_send_tracking *nst)
+static void o2net_set_nst_send_time(struct o2net_send_tracking *nst)
 {
 	do_gettimeofday(&nst->st_send_time);
 }
 
-void o2net_set_nst_status_time(struct o2net_send_tracking *nst)
+static void o2net_set_nst_status_time(struct o2net_send_tracking *nst)
 {
 	do_gettimeofday(&nst->st_status_time);
 }
 
-void o2net_set_nst_sock_container(struct o2net_send_tracking *nst,
+static void o2net_set_nst_sock_container(struct o2net_send_tracking *nst,
 					 struct o2net_sock_container *sc)
 {
 	nst->st_sc = sc;
 }
 
-void o2net_set_nst_msg_id(struct o2net_send_tracking *nst, u32 msg_id)
+static void o2net_set_nst_msg_id(struct o2net_send_tracking *nst, u32 msg_id)
 {
 	nst->st_id = msg_id;
 }
+
+#else  /* CONFIG_DEBUG_FS */
+
+static inline void o2net_init_nst(struct o2net_send_tracking *nst, u32 msgtype,
+				  u32 msgkey, struct task_struct *task, u8 node)
+{
+}
+
+static inline void o2net_set_nst_sock_time(struct o2net_send_tracking *nst)
+{
+}
+
+static inline void o2net_set_nst_send_time(struct o2net_send_tracking *nst)
+{
+}
+
+static inline void o2net_set_nst_status_time(struct o2net_send_tracking *nst)
+{
+}
+
+static inline void o2net_set_nst_sock_container(struct o2net_send_tracking *nst,
+						struct o2net_sock_container *sc)
+{
+}
+
+static inline void o2net_set_nst_msg_id(struct o2net_send_tracking *nst,
+					u32 msg_id)
+{
+}
+
 #endif /* CONFIG_DEBUG_FS */
 
 static inline int o2net_reconnect_delay(void)
diff --git a/fs/ocfs2/cluster/tcp_internal.h b/fs/ocfs2/cluster/tcp_internal.h
index 18307ff..8d58cfe 100644
--- a/fs/ocfs2/cluster/tcp_internal.h
+++ b/fs/ocfs2/cluster/tcp_internal.h
@@ -224,42 +224,10 @@ struct o2net_send_tracking {
 	struct timeval			st_send_time;
 	struct timeval			st_status_time;
 };
-
-void o2net_init_nst(struct o2net_send_tracking *nst, u32 msgtype,
-		    u32 msgkey, struct task_struct *task, u8 node);
-void o2net_set_nst_sock_time(struct o2net_send_tracking *nst);
-void o2net_set_nst_send_time(struct o2net_send_tracking *nst);
-void o2net_set_nst_status_time(struct o2net_send_tracking *nst);
-void o2net_set_nst_sock_container(struct o2net_send_tracking *nst,
-				  struct o2net_sock_container *sc);
-void o2net_set_nst_msg_id(struct o2net_send_tracking *nst, u32 msg_id);
-
 #else
 struct o2net_send_tracking {
 	u32	dummy;
 };
-
-static inline void o2net_init_nst(struct o2net_send_tracking *nst, u32 msgtype,
-				  u32 msgkey, struct task_struct *task, u8 node)
-{
-}
-static inline void o2net_set_nst_sock_time(struct o2net_send_tracking *nst)
-{
-}
-static inline void o2net_set_nst_send_time(struct o2net_send_tracking *nst)
-{
-}
-static inline void o2net_set_nst_status_time(struct o2net_send_tracking *nst)
-{
-}
-static inline void o2net_set_nst_sock_container(struct o2net_send_tracking *nst,
-						struct o2net_sock_container *sc)
-{
-}
-static inline void o2net_set_nst_msg_id(struct o2net_send_tracking *nst,
-					u32 msg_id)
-{
-}
 #endif	/* CONFIG_DEBUG_FS */
 
 #endif /* O2CLUSTER_TCP_INTERNAL_H */
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 8a18758..9cce563 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -1300,7 +1300,6 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 	di->i_size = cpu_to_le64(sb->s_blocksize);
 	di->i_ctime = di->i_mtime = cpu_to_le64(dir->i_ctime.tv_sec);
 	di->i_ctime_nsec = di->i_mtime_nsec = cpu_to_le32(dir->i_ctime.tv_nsec);
-	dir->i_blocks = ocfs2_inode_sector_count(dir);
 
 	/*
 	 * This should never fail as our extent list is empty and all
@@ -1310,9 +1309,15 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 				  NULL);
 	if (ret) {
 		mlog_errno(ret);
-		goto out;
+		goto out_commit;
 	}
 
+	/*
+	 * Set i_blocks after the extent insert for the most up to
+	 * date ip_clusters value.
+	 */
+	dir->i_blocks = ocfs2_inode_sector_count(dir);
+
 	ret = ocfs2_journal_dirty(handle, di_bh);
 	if (ret) {
 		mlog_errno(ret);
@@ -1336,7 +1341,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 					  len, 0, NULL);
 		if (ret) {
 			mlog_errno(ret);
-			goto out;
+			goto out_commit;
 		}
 	}
 
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 7a37240..c47bc2a 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1418,13 +1418,13 @@ int ocfs2_mark_dead_nodes(struct ocfs2_super *osb)
 {
 	unsigned int node_num;
 	int status, i;
+	u32 gen;
 	struct buffer_head *bh = NULL;
 	struct ocfs2_dinode *di;
 
 	/* This is called with the super block cluster lock, so we
 	 * know that the slot map can't change underneath us. */
 
-	spin_lock(&osb->osb_lock);
 	for (i = 0; i < osb->max_slots; i++) {
 		/* Read journal inode to get the recovery generation */
 		status = ocfs2_read_journal_inode(osb, i, &bh, NULL);
@@ -1433,23 +1433,31 @@ int ocfs2_mark_dead_nodes(struct ocfs2_super *osb)
 			goto bail;
 		}
 		di = (struct ocfs2_dinode *)bh->b_data;
-		osb->slot_recovery_generations[i] =
-					ocfs2_get_recovery_generation(di);
+		gen = ocfs2_get_recovery_generation(di);
 		brelse(bh);
 		bh = NULL;
 
+		spin_lock(&osb->osb_lock);
+		osb->slot_recovery_generations[i] = gen;
+
 		mlog(0, "Slot %u recovery generation is %u\n", i,
 		     osb->slot_recovery_generations[i]);
 
-		if (i == osb->slot_num)
+		if (i == osb->slot_num) {
+			spin_unlock(&osb->osb_lock);
 			continue;
+		}
 
 		status = ocfs2_slot_to_node_num_locked(osb, i, &node_num);
-		if (status == -ENOENT)
+		if (status == -ENOENT) {
+			spin_unlock(&osb->osb_lock);
 			continue;
+		}
 
-		if (__ocfs2_recovery_map_test(osb, node_num))
+		if (__ocfs2_recovery_map_test(osb, node_num)) {
+			spin_unlock(&osb->osb_lock);
 			continue;
+		}
 		spin_unlock(&osb->osb_lock);
 
 		/* Ok, we have a slot occupied by another node which
@@ -1465,10 +1473,7 @@ int ocfs2_mark_dead_nodes(struct ocfs2_super *osb)
 			mlog_errno(status);
 			goto bail;
 		}
-
-		spin_lock(&osb->osb_lock);
 	}
-	spin_unlock(&osb->osb_lock);
 
 	status = 0;
 bail:
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 10e149a..07f348b 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -97,13 +97,14 @@ static int ocfs2_stack_driver_request(const char *stack_name,
 		goto out;
 	}
 
-	/* Ok, the stack is pinned */
-	p->sp_count++;
 	active_stack = p;
-
 	rc = 0;
 
 out:
+	/* If we found it, pin it */
+	if (!rc)
+		active_stack->sp_count++;
+
 	spin_unlock(&ocfs2_stack_lock);
 	return rc;
 }
