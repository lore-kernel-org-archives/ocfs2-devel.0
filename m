From: Christoph Hellwig <hch@lst.de>
Date: Fri Aug 13 05:32:32 2004
Subject: [Ocfs2-devel] [PATCH] remove dead code and add missing statics
Message-ID: <20040813103221.GA5176@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Index: src/journal.c
===================================================================
--- src/journal.c	(revision 1352)
+++ src/journal.c	(working copy)
@@ -63,28 +63,10 @@
 static int __ocfs_recovery_thread(void *arg);
 static int ocfs_commit_cache (ocfs_super * osb);
 static int ocfs_wait_on_mount(ocfs_super *osb);
-static int ocfs_journal_flush(ocfs_journal *journal);
 static void ocfs_handle_move_locks(ocfs_journal *journal, 
 				   ocfs_journal_handle *handle);
 static void ocfs_journal_optimize_lock_list(ocfs_journal *journal);
 
-static int ocfs_journal_flush(ocfs_journal *journal) 
-{
-	int retval;
-
-	down_write(&journal->trans_barrier);
-	journal_lock_updates(journal->k_journal);
-
-	retval = journal_flush(journal->k_journal);
-
-	ocfs_inc_trans_id(journal);
-
-	journal_unlock_updates(journal->k_journal);
-	up_write(&journal->trans_barrier);
-
-	return(retval);
-}
-
 static void ocfs_journal_optimize_lock_list(ocfs_journal *journal)
 {
 	ocfs_journal_lock *lock = NULL;
@@ -375,21 +357,9 @@
 	return ret;
 }
 
-static inline int ocfs_journal_flush24(ocfs_journal *journal)
-{
-	int ret;
-
-	lock_kernel();
-	ret = ocfs_journal_flush(journal);
-	unlock_kernel();
-	return ret;
-}
-
 #undef ocfs_commit_cache
-#undef ocfs_journal_flush
 
 #define ocfs_commit_cache  ocfs_commit_cache24
-#define ocfs_journal_flush ocfs_journal_flush24
 
 #undef journal_get_write_access
 #undef journal_get_undo_access
Index: src/dlm.c
===================================================================
--- src/dlm.c	(revision 1352)
+++ src/dlm.c	(working copy)
@@ -389,7 +389,9 @@
  * ocfs_update_disk_lock()
  * inode is definitely non NULL
  */
-int ocfs_update_disk_lock (ocfs_super * osb, __u32 flags, struct buffer_head **bh, struct inode *inode, ocfs_journal_handle *handle)
+static int ocfs_update_disk_lock (ocfs_super * osb, __u32 flags,
+		struct buffer_head **bh, struct inode *inode,
+		ocfs_journal_handle *handle)
 {
 	int status = 0;
 	ocfs2_dinode *fe = NULL;
Index: src/util.c
===================================================================
--- src/util.c	(revision 1352)
+++ src/util.c	(working copy)
@@ -183,43 +183,6 @@
 }				/* ocfs_truncate_inode_pages */
 
 
-/*
-To print the ocfs call stack use: ocfs_show_stack( NULL);
-
-ocfs_show_trace prints alot of garbage because nothing usefull is exported
-by the kernel to determine which addresses are from the kernel/modules
-
-However the following greps will help you filter out most of the garbage
-from the syslog :
-
-alias ocfstrace='tail -200 /var/log/messages | grep -v modules | grep -v \\\[\<'
-*/
-
-
-
-void ocfs_show_stack(unsigned long * esp)
-{
-	unsigned long *stack;
-	int depth_to_print=16, i;
-
-	// debugging aid: "show_stack(NULL);" prints the
-	// back trace for this cpu.
-
-	if(esp==NULL)
-		esp=(unsigned long*)&esp;
-
-	stack = esp;
-	for(i=0; i < depth_to_print; i++) {
-		if (((long) stack & (THREAD_SIZE-1)) == 0)
-			break;
-		if (i && ((i % 8) == 0))
-			printk("\n       ");
-		printk("%08lx ", *stack++);
-	}
-	printk("\n");
-	ocfs_show_trace(esp);
-}
-
 static int ocfs_kernel_text_address(unsigned long addr)
 {
   return  (addr >= 0xc0000000 ) ; 
@@ -246,47 +209,3 @@
 
 
 }
-
-int __ocfs_wait_atomic_eq(wait_queue_head_t *wq, atomic_t *var, int val, int ms)
-{
-	int ret;
-	ocfs_timeout timeout;
-	DECLARE_WAITQUEUE(wait, current);
-	DECLARE_WAITQUEUE(to_wait, current);
-
-	ocfs_init_timeout(&timeout);
-
-	if (ms) {
-		ocfs_set_timeout(&timeout, ms);
-		if (timeout.timed_out) {
-			ocfs_clear_timeout(&timeout);
-		}
-	}
-	add_wait_queue(wq, &wait);
-	add_wait_queue(&timeout.wait, &to_wait);
-	do { 
-		ret = 0;
-		set_current_state(TASK_INTERRUPTIBLE);
-		if (atomic_read(var)==val)
-			break;
-		ret = -ETIMEDOUT;
-		if (timeout.timed_out)
-			break;
-		schedule();
-		if (signal_pending(current)) {
-			ret = -EINTR;
-			break;
-		}
-	} while (1);
-	
-	set_current_state(TASK_RUNNING);
-	remove_wait_queue(wq, &wait);
-	remove_wait_queue(&timeout.wait, &to_wait);
-
-	if (ms)
-		ocfs_clear_timeout(&timeout);
-
-	return ret;
-}
-
-
Index: src/vote.c
===================================================================
--- src/vote.c	(revision 1352)
+++ src/vote.c	(working copy)
@@ -63,6 +63,7 @@
 
 static int ocfs_send_bcast (ocfs_super * osb, ocfs_node_map *votemap, ocfs_dlm_msg * dlm_msg);
 static int ocfs_node_map_stringify(ocfs_node_map *map, char **str);
+static int ocfs_node_map_is_equal(ocfs_node_map *map1, ocfs_node_map *map2);
 
 static spinlock_t vote_obj_lock = SPIN_LOCK_UNLOCKED;
 
@@ -1016,19 +1017,6 @@
 	}
 }
 
-// set all the bits in "target" which are set in "mask"
-void ocfs_node_map_set_bits(ocfs_node_map *target, ocfs_node_map *mask)
-{
-	int bit, prev=0;
-	while (1) {
-		bit = find_next_bit (mask->map, mask->num_nodes, prev);
-		if (bit > mask->num_nodes)
-			break;
-		ocfs_node_map_set_bit(target, bit);
-		prev = bit+1;
-	}
-}
-
 int ocfs_node_map_test_bit(ocfs_node_map *map, int bit)
 {
 	if (bit >= map->num_nodes) {
@@ -1075,7 +1063,7 @@
 	return 1;
 }
 
-int ocfs_node_map_is_equal(ocfs_node_map *map1, ocfs_node_map *map2)
+static int ocfs_node_map_is_equal(ocfs_node_map *map1, ocfs_node_map *map2)
 {
 	int num_longs, i; 
 
Index: src/dlm.h
===================================================================
--- src/dlm.h	(revision 1352)
+++ src/dlm.h	(working copy)
@@ -41,9 +41,6 @@
 	ocfs_release_lock_full(osb, lock_type, flags, inode, 1)
 int ocfs_release_lock_full(ocfs_super *osb, __u32 lock_type,
 			   __u32 flags, struct inode *inode, __u32 num_ident);
-int ocfs_update_disk_lock(ocfs_super *osb, __u32 flags,
-			  struct buffer_head **bh, struct inode *inode,
-			  ocfs_journal_handle *handle);
 int ocfs_notify_on_open(ocfs_super *osb, struct inode *inode);
 void ocfs_get_publish_vote_map(ocfs_super *osb, ocfs_publish *publish,
 			       ocfs_node_map *vote_map);
Index: src/vote.h
===================================================================
--- src/vote.h	(revision 1352)
+++ src/vote.h	(working copy)
@@ -58,10 +58,8 @@
 // clear all the bits in "target" which are set in "mask"
 void ocfs_node_map_clear_bits(ocfs_node_map *target, ocfs_node_map *mask);
 // set all the bits in "target" which are set in "mask"
-void ocfs_node_map_set_bits(ocfs_node_map *target, ocfs_node_map *mask);
 int ocfs_node_map_test_bit(ocfs_node_map *map, int bit);
 int ocfs_node_map_is_empty(ocfs_node_map *map);
-int ocfs_node_map_is_equal(ocfs_node_map *map1, ocfs_node_map *map2);
 void ocfs_node_map_and(ocfs_node_map *target, ocfs_node_map *mask);
 void ocfs_node_map_set(ocfs_node_map *target, ocfs_node_map *from);
 void ocfs_node_map_dup(ocfs_super *osb, ocfs_node_map *target, ocfs_node_map *from);
Index: src/util.h
===================================================================
--- src/util.h	(revision 1352)
+++ src/util.h	(working copy)
@@ -33,20 +33,8 @@
 void ocfs_daemonize(char *name, int len);
 void ocfs_init_timeout(ocfs_timeout *to);
 void ocfs_set_timeout(ocfs_timeout *to, __u32 timeout);
-void ocfs_show_stack(unsigned long *esp);
 void ocfs_show_trace(unsigned long *stack);
 int ocfs_sleep(__u32 ms);
 void ocfs_truncate_inode_pages(struct inode *inode, loff_t off);
-int __ocfs_wait_atomic_eq(wait_queue_head_t *wq, atomic_t *var, int val, int ms);
 
-/* exits when var == val, or on timeout */
-static inline int ocfs_wait_atomic_eq(wait_queue_head_t *wq, atomic_t *var, int val, int timeout)
-{
-	int ret = 0;
-	if (atomic_read(var) != val)
-		ret = __ocfs_wait_atomic_eq(wq, var, val, timeout);
-	return ret;
-}
-
-
 #endif /* OCFS2_UTIL_H */
Index: src/nm.c
===================================================================
--- src/nm.c	(revision 1352)
+++ src/nm.c	(working copy)
@@ -57,7 +57,7 @@
 #define OCFS_DEBUG_CONTEXT      OCFS_DEBUG_CONTEXT_NM
 
 /* for lack of a better name... protects inode_private->ip_num_extends. */
-spinlock_t oin_num_ext_lock = SPIN_LOCK_UNLOCKED;
+static spinlock_t oin_num_ext_lock = SPIN_LOCK_UNLOCKED;
 struct semaphore recovery_list_sem;
 
 static inline int get_process_vote_action(ocfs_super * osb, ocfs_lock_res *lockres, __u32 node_num, __u32 flags, int status, int *master_alive, struct inode *inode);
Index: src/file.c
===================================================================
--- src/file.c	(revision 1352)
+++ src/file.c	(working copy)
@@ -59,6 +59,7 @@
 				   struct inode *inode);
 static int ocfs_truncate_file(ocfs_super *osb, __u64 file_size,
 			      struct inode *inode);
+static int ocfs2_zero_extend(struct inode *inode);
 
 static void ocfs_fe_set_attributes(ocfs2_dinode *fe, struct iattr *attr)
 {
@@ -964,7 +965,7 @@
 	return status;
 }  /* ocfs_truncate_file */
 
-int ocfs2_zero_extend(struct inode *inode)
+static int ocfs2_zero_extend(struct inode *inode)
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct page *page;
Index: src/file.h
===================================================================
--- src/file.h	(revision 1352)
+++ src/file.h	(working copy)
@@ -41,7 +41,6 @@
 			    struct inode *inode);
 int ocfs_setattr(struct dentry *dentry, struct iattr *attr);
 int ocfs_sync_inode(struct inode *inode);
-int ocfs2_zero_extend(struct inode *inode);
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 int ocfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
