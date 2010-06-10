From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Thu, 10 Jun 2010 17:21:36 -0500
Subject: [Ocfs2-devel] Reorganize data elements to reduce struct sizes
Message-ID: <AANLkTinl-EuRPsbKhFnEiglxUJKYSInZ4ZGafzkidWtb@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Thanks for the comments. I have incorportated them all.

CONFIG_OCFS2_FS_STATS is enabled and CONFIG_DEBUG_LOCK_ALLOC is disabled.
Statistics now look like -
ocfs2_write_ctxt: 2144 - 2136 = 8
ocfs2_inode_info: 1960 - 1848 = 112
ocfs2_journal: 168 - 160 = 8
ocfs2_lock_res: 336 - 304 = 32
ocfs2_refcount_tree: 512 - 472 = 40

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>

---
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 3623ca2..1b5e284 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -910,8 +910,8 @@ struct ocfs2_write_ctxt {
 	 * out in so that future reads from that region will get
 	 * zero's.
 	 */
-	struct page			*w_pages[OCFS2_MAX_CTXT_PAGES];
 	unsigned int			w_num_pages;
+	struct page			*w_pages[OCFS2_MAX_CTXT_PAGES];
 	struct page			*w_target_page;

 	/*
diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index 9f5f5fc..a1d70bf 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -46,27 +46,24 @@ struct ocfs2_inode_info
 	/* These fields are protected by ip_lock */
 	spinlock_t			ip_lock;
 	u32				ip_open_count;
-	u32				ip_clusters;
 	struct list_head		ip_io_markers;
+	u32				ip_clusters;

+	u16				ip_dyn_features;
 	struct mutex			ip_io_mutex;
-
 	u32				ip_flags; /* see below */
 	u32				ip_attr; /* inode attributes */
-	u16				ip_dyn_features;

 	/* protected by recovery_lock. */
 	struct inode			*ip_next_orphan;

-	u32				ip_dir_start_lookup;
-
 	struct ocfs2_caching_info	ip_metadata_cache;
-
 	struct ocfs2_extent_map		ip_extent_map;
-
 	struct inode			vfs_inode;
 	struct jbd2_inode		ip_jinode;

+	u32				ip_dir_start_lookup;
+
 	/* Only valid if the inode is the dir. */
 	u32				ip_last_used_slot;
 	u64				ip_last_used_group;
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index b5baaa8..43e56b9 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -67,11 +67,12 @@ struct ocfs2_journal {
 	struct buffer_head        *j_bh;      /* Journal disk inode block */
 	atomic_t                  j_num_trans; /* Number of transactions
 					        * currently in the system. */
+	spinlock_t                j_lock;
 	unsigned long             j_trans_id;
 	struct rw_semaphore       j_trans_barrier;
 	wait_queue_head_t         j_checkpointed;

-	spinlock_t                j_lock;
+	/* both fields protected by j_lock*/
 	struct list_head          j_la_cleanups;
 	struct work_struct        j_recovery_work;
 };
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index c67003b..65739b3 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -150,26 +150,33 @@ typedef void (*ocfs2_lock_callback)(int status,
unsigned long data);
 struct ocfs2_lock_res {
 	void                    *l_priv;
 	struct ocfs2_lock_res_ops *l_ops;
-	spinlock_t               l_lock;
+

 	struct list_head         l_blocked_list;
 	struct list_head         l_mask_waiters;

-	enum ocfs2_lock_type     l_type;
 	unsigned long		 l_flags;
 	char                     l_name[OCFS2_LOCK_ID_MAX_LEN];
-	int                      l_level;
 	unsigned int             l_ro_holders;
 	unsigned int             l_ex_holders;
-	struct ocfs2_dlm_lksb    l_lksb;
+	unsigned char            l_level;
+
+	/* Data packed - type enum ocfs2_lock_type */
+	unsigned char            l_type;

 	/* used from AST/BAST funcs. */
-	enum ocfs2_ast_action    l_action;
-	enum ocfs2_unlock_action l_unlock_action;
-	int                      l_requested;
-	int                      l_blocking;
+	/* Data packed - enum type ocfs2_ast_action */
+	unsigned char            l_action;
+	/* Data packed - enum type ocfs2_unlock_action */
+	unsigned char            l_unlock_action;
+	unsigned char            l_requested;
+	unsigned char            l_blocking;
 	unsigned int             l_pending_gen;

+	spinlock_t               l_lock;
+
+	struct ocfs2_dlm_lksb    l_lksb;
+
 	wait_queue_head_t        l_event;

 	struct list_head         l_debug_list;
diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
index 9983ba1..f04892d 100644
--- a/fs/ocfs2/refcounttree.h
+++ b/fs/ocfs2/refcounttree.h
@@ -21,14 +21,14 @@ struct ocfs2_refcount_tree {
 	struct rb_node rf_node;
 	u64 rf_blkno;
 	u32 rf_generation;
+	struct kref rf_getcnt;
 	struct rw_semaphore rf_sem;
 	struct ocfs2_lock_res rf_lockres;
-	struct kref rf_getcnt;
 	int rf_removed;

 	/* the following 4 fields are used by caching_info. */
-	struct ocfs2_caching_info rf_ci;
 	spinlock_t rf_lock;
+	struct ocfs2_caching_info rf_ci;
 	struct mutex rf_io_mutex;
 	struct super_block *rf_sb;
 };

-- 
Goldwyn
