From: Christoph Hellwig <hch@lst.de>
Date: Fri Jul 16 16:32:08 2004
Subject: [Ocfs2-devel] [PATCH] kill dead code and add some statics
Message-ID: <20040716213034.GA10617@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I ran Tridge's findstatic.pl and fixed everything it complained about.


Index: src/super.c
===================================================================
--- src/super.c	(revision 1280)
+++ src/super.c	(working copy)
@@ -168,6 +168,7 @@
 static int ocfs_read_params(void);
 static int ocfs_initialize_mem_lists (void);
 static void ocfs_free_mem_lists (void);
+static void ocfs_delete_osb (ocfs_super * osb);
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 static int ocfs_statfs (struct super_block *sb, struct kstatfs *buf);
@@ -1900,7 +1901,7 @@
  * It will remove the osb from the global list and also free up all the
  * initialized resources and fileobject.
  */
-void ocfs_delete_osb (ocfs_super * osb)
+static void ocfs_delete_osb (ocfs_super * osb)
 {
 	int i;
 	LOG_ENTRY ();
Index: src/super.h
===================================================================
--- src/super.h	(revision 1280)
+++ src/super.h	(working copy)
@@ -29,7 +29,6 @@
 #ifndef OCFS2_SUPER_H
 #define OCFS2_SUPER_H
 
-void ocfs_delete_osb(ocfs_super *osb);
 int ocfs_dismount_volume(struct super_block *sb);
 int ocfs_publish_get_mount_state(ocfs_super *osb, int node_num);
 
Index: src/dlm.c
===================================================================
--- src/dlm.c	(revision 1280)
+++ src/dlm.c	(working copy)
@@ -61,14 +61,8 @@
 static int ocfs_wait_for_vote (ocfs_super * osb, __u64 lock_id, __u32 lock_type, __u32 flags, ocfs_node_map *vote_map, __u32 time_to_wait, __u64 lock_seq_num, ocfs_node_map *open_map);
 static int ocfs_reset_voting (ocfs_super * osb);
 static int ocfs_get_vote_on_disk (ocfs_super * osb, __u64 lock_id, __u32 lock_type, __u32 flags, ocfs_node_map * got_vote_map, ocfs_node_map * vote_map, __u64 lock_seq_num, ocfs_node_map * oin_open_map);
-int ocfs_disk_release_lock (ocfs_super * osb, __u64 lock_id, __u32 lock_type, __u32 flags, struct buffer_head *bh, struct inode *inode);
 
 
-void ocfs_set_publish_vote_map(ocfs_super *osb, ocfs_publish *publish, ocfs_node_map *vote_map)
-{
-	ocfs_node_map_set_to_disk(publish->vote_map, vote_map);
-}
-
 void ocfs_get_publish_vote_map(ocfs_super *osb, ocfs_publish *publish, ocfs_node_map *vote_map)
 {
 	ocfs_node_map_init(osb, vote_map);
@@ -168,7 +162,7 @@
 	pubsect->publ_seq_num = largestseqno;
 	pubsect->dirty = 1;
 	pubsect->vote = FLAG_VOTE_NODE;
-	ocfs_set_publish_vote_map(osb, pubsect, vote_map);
+	ocfs_node_map_set_to_disk(pubsect->vote_map, vote_map);
 	pubsect->vote_type = flags;
 	pubsect->lock_id = lock_id;
 
@@ -535,7 +529,7 @@
 	pubsect->lock_id = 0;
 	/* clear vote map */
 	ocfs_node_map_init(osb, &vote_map);
-	ocfs_set_publish_vote_map(osb, pubsect, &vote_map);
+	ocfs_node_map_set_to_disk(pubsect->vote_map, &vote_map);
 
 	/* Write it back */
 	status = ocfs_write_bh (osb, bh, 0, NULL);
@@ -786,8 +780,10 @@
 	num_paths
 };
 
-const char *lock_path_strs[] = {"invalid_path", "fast_path", "become_master",
-				"get_x", "wait_for_release", "master_request" };
+static const char *lock_path_strs[] = {
+	"invalid_path", "fast_path", "become_master",
+	"get_x", "wait_for_release", "master_request"
+};
 
 static inline const char * lock_path_str(int lock_path);
 static inline const char * lock_path_str(int lock_path)
@@ -1027,7 +1023,9 @@
  * ocfs_disk_release_lock()
  * inode is definitely non NULL
  */
-int ocfs_disk_release_lock (ocfs_super * osb, __u64 lock_id, __u32 lock_type, __u32 flags, struct buffer_head *bh, struct inode *inode)
+static int ocfs_disk_release_lock(ocfs_super * osb, __u64 lock_id,
+		__u32 lock_type, __u32 flags, struct buffer_head *bh,
+		struct inode *inode)
 {
 	ocfs_node_map votemap;
 	int status = 0, vote_status = 0;
Index: src/util.c
===================================================================
--- src/util.c	(revision 1280)
+++ src/util.c	(working copy)
@@ -175,26 +175,6 @@
 
 #endif				/* !USERSPACE_TOOL */
 
-/*
- * ocfs_compare_qstr()
- *
- */
-int ocfs_compare_qstr (struct qstr * s1, struct qstr * s2)
-{
-	int s = strncmp ((const char *) s1->name, (const char *) s2->name,
-			s1->len < s2->len ? s1->len : s2->len);
-
-	if (s != 0)
-		return s;
-	if (s1->len > s2->len)
-		return 1;
-	else if (s1->len < s2->len)
-		return -1;
-	else
-		return s;
-}				/* ocfs_compare_qstr */
-
-
 void ocfs_truncate_inode_pages(struct inode *inode, loff_t off)
 {
 	LOG_TRACE_ARGS("truncating pages for inode %llu (%p) from offset %llu\n", 
@@ -203,43 +183,6 @@
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
@@ -266,47 +209,3 @@
 
 
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
--- src/vote.c	(revision 1280)
+++ src/vote.c	(working copy)
@@ -62,6 +62,7 @@
 static void ocfs_init_dlm_msg (ocfs_super * osb, ocfs_dlm_msg * dlm_msg, __u32 msg_len, __u32 type);
 
 static int ocfs_send_bcast (ocfs_super * osb, ocfs_node_map *votemap, ocfs_dlm_msg * dlm_msg);
+static int ocfs_node_map_stringify(ocfs_node_map *map, char **str);
 
 static spinlock_t vote_obj_lock = SPIN_LOCK_UNLOCKED;
 
@@ -74,7 +75,7 @@
 	spin_unlock(&vote_obj_lock);
 }
 
-void ocfs_get_vote_obj (ocfs_vote_obj *obj)
+static void ocfs_get_vote_obj(ocfs_vote_obj *obj)
 {
 	spin_lock(&vote_obj_lock);
 	atomic_inc(&obj->refcount);
@@ -1019,19 +1020,6 @@
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
@@ -1041,7 +1029,7 @@
 	return test_bit(bit, map->map);
 }
 
-int ocfs_node_map_stringify(ocfs_node_map *map, char **str)
+static int ocfs_node_map_stringify(ocfs_node_map *map, char **str)
 {
 	int i, n;
 	char *s;
Index: src/dlm.h
===================================================================
--- src/dlm.h	(revision 1280)
+++ src/dlm.h	(working copy)
@@ -49,8 +49,6 @@
 int ocfs_wait_for_lock_release(ocfs_super *osb, __u64 offset,
 			       __u32 time_to_wait, __u32 lock_type,
 			       struct inode *inode);
-void ocfs_set_publish_vote_map(ocfs_super *osb, ocfs_publish *publish,
-			       ocfs_node_map *vote_map);
 void ocfs_get_publish_vote_map(ocfs_super *osb, ocfs_publish *publish,
 			       ocfs_node_map *vote_map);
 void ocfs_set_disk_lock_open_map(ocfs_super *osb, ocfs2_disk_lock *lock,
Index: src/vote.h
===================================================================
--- src/vote.h	(revision 1280)
+++ src/vote.h	(working copy)
@@ -29,7 +29,6 @@
 #ifndef OCFS2_VOTE_H
 #define OCFS2_VOTE_H
 
-void ocfs_get_vote_obj(ocfs_vote_obj *obj);
 int ocfs_init_udp_sock(struct socket **send_sock,
 		       struct socket **recv_sock);
 int ocfs_lookup_obj_for_proc(ocfs_vote_obj *obj,
@@ -58,9 +57,7 @@
 // clear all the bits in "target" which are set in "mask"
 void ocfs_node_map_clear_bits(ocfs_node_map *target, ocfs_node_map *mask);
 // set all the bits in "target" which are set in "mask"
-void ocfs_node_map_set_bits(ocfs_node_map *target, ocfs_node_map *mask);
 int ocfs_node_map_test_bit(ocfs_node_map *map, int bit);
-int ocfs_node_map_stringify(ocfs_node_map *map, char **str);
 int ocfs_node_map_is_empty(ocfs_node_map *map);
 int ocfs_node_map_is_equal(ocfs_node_map *map1, ocfs_node_map *map2);
 void ocfs_node_map_and(ocfs_node_map *target, ocfs_node_map *mask);
Index: src/util.h
===================================================================
--- src/util.h	(revision 1280)
+++ src/util.h	(working copy)
@@ -29,25 +29,12 @@
 #ifndef OCFS2_UTIL_H
 #define OCFS2_UTIL_H
 
-int ocfs_compare_qstr(struct qstr *s1, struct qstr *s2);
 void ocfs_clear_timeout(ocfs_timeout *to);
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
Index: src/inode.c
===================================================================
--- src/inode.c	(revision 1280)
+++ src/inode.c	(working copy)
@@ -1300,7 +1300,9 @@
  * called like this: dio->get_blocks(dio->inode, fs_startblk,
  * 					fs_count, map_bh, dio->rw == WRITE);
  */
-int ocfs_direct_IO_get_blocks(struct inode *inode, sector_t iblock, unsigned long max_blocks, struct buffer_head *bh_result, int create)
+static int ocfs_direct_IO_get_blocks(struct inode *inode, sector_t iblock,
+		unsigned long max_blocks, struct buffer_head *bh_result,
+		int create)
 {
 	int ret = -1;
 	int status;
Index: src/nm.c
===================================================================
--- src/nm.c	(revision 1280)
+++ src/nm.c	(working copy)
@@ -79,8 +79,6 @@
 static void ocfs_clear_inode_for_extend(ocfs_super *osb, struct inode *inode,
 					__u32 node_num);
 
-void ocfs_process_vote_worker(void *val);
-
 #ifdef VERBOSE_PROCESS_VOTE
 static const char *process_vote_strings[] = {
 	"INVALID_REQUEST",      // reply with a NO vote
@@ -170,7 +168,7 @@
 	struct work_struct ipc_wq;
 };
 
-void ocfs_process_vote_worker(void *val)
+static void ocfs_process_vote_worker(void *val)
 {
 	struct ocfs_sched_vote *sv = val;
 	ocfs_super *osb = NULL;
 			if (is_locked || vote_type == CHANGE_MASTER) {
