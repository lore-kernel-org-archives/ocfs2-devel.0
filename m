From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 28 Dec 2010 23:26:03 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Use hrtimer to track ocfs2 fs lock
	stats
Message-ID: <1293607563-29283-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Patch makes use of the hrtimer to track times in ocfs2 lock stats.

The patch is a bit involved to ensure no additional impact on the memory
footprint. The size of ocfs2_inode_cache remains 1280 bytes on 32-bit systems.

A related change was to modify the unit of the max wait time from nanosec to
microsec allowing us to track max time larger than 4 secs. This change
necessitated the bumping of the output version in the debugfs file,
locking_state, from 2 to 3.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlmglue.c |   97 +++++++++++++++++++++++++++-------------------------
 fs/ocfs2/ocfs2.h   |   23 +++++++-----
 2 files changed, 64 insertions(+), 56 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index e8d94d7..7484bb9 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -64,7 +64,7 @@ struct ocfs2_mask_waiter {
 	unsigned long		mw_mask;
 	unsigned long		mw_goal;
 #ifdef CONFIG_OCFS2_FS_STATS
-	unsigned long long 	mw_lock_start;
+	ktime_t			mw_lock_start;
 #endif
 };
 
@@ -435,44 +435,41 @@ static void ocfs2_remove_lockres_tracking(struct ocfs2_lock_res *res)
 #ifdef CONFIG_OCFS2_FS_STATS
 static void ocfs2_init_lock_stats(struct ocfs2_lock_res *res)
 {
-	res->l_lock_num_prmode = 0;
-	res->l_lock_num_prmode_failed = 0;
-	res->l_lock_total_prmode = 0;
-	res->l_lock_max_prmode = 0;
-	res->l_lock_num_exmode = 0;
-	res->l_lock_num_exmode_failed = 0;
-	res->l_lock_total_exmode = 0;
-	res->l_lock_max_exmode = 0;
 	res->l_lock_refresh = 0;
+	memset(&res->l_lock_prmode, 0, sizeof(struct ocfs2_lock_stats));
+	memset(&res->l_lock_exmode, 0, sizeof(struct ocfs2_lock_stats));
 }
 
 static void ocfs2_update_lock_stats(struct ocfs2_lock_res *res, int level,
 				    struct ocfs2_mask_waiter *mw, int ret)
 {
-	unsigned long long *num, *sum;
-	unsigned int *max, *failed;
-	struct timespec ts = current_kernel_time();
-	unsigned long long time = timespec_to_ns(&ts) - mw->mw_lock_start;
-
-	if (level == LKM_PRMODE) {
-		num = &res->l_lock_num_prmode;
-		sum = &res->l_lock_total_prmode;
-		max = &res->l_lock_max_prmode;
-		failed = &res->l_lock_num_prmode_failed;
-	} else if (level == LKM_EXMODE) {
-		num = &res->l_lock_num_exmode;
-		sum = &res->l_lock_total_exmode;
-		max = &res->l_lock_max_exmode;
-		failed = &res->l_lock_num_exmode_failed;
-	} else
+	u32 usec;
+	ktime_t kt;
+	struct ocfs2_lock_stats *stats;
+
+	if (level == LKM_PRMODE)
+		stats = &res->l_lock_prmode;
+	else if (level == LKM_EXMODE)
+		stats = &res->l_lock_exmode;
+	else
 		return;
 
-	(*num)++;
-	(*sum) += time;
-	if (time > *max)
-		*max = time;
+	kt = ktime_sub(ktime_get(), mw->mw_lock_start);
+	usec = ktime_to_us(kt);
+
+	stats->ls_gets++;
+	stats->ls_total += ktime_to_ns(kt);
+	/* overflow */
+	if (unlikely(stats->ls_gets) == 0) {
+		stats->ls_gets++;
+		stats->ls_total = ktime_to_ns(kt);
+	}
+
+	if (stats->ls_max < usec)
+		stats->ls_max = usec;
+
 	if (ret)
-		(*failed)++;
+		stats->ls_fail++;
 }
 
 static inline void ocfs2_track_lock_refresh(struct ocfs2_lock_res *lockres)
@@ -482,8 +479,7 @@ static inline void ocfs2_track_lock_refresh(struct ocfs2_lock_res *lockres)
 
 static inline void ocfs2_init_start_time(struct ocfs2_mask_waiter *mw)
 {
-	struct timespec ts = current_kernel_time();
-	mw->mw_lock_start = timespec_to_ns(&ts);
+	mw->mw_lock_start = ktime_get();
 }
 #else
 static inline void ocfs2_init_lock_stats(struct ocfs2_lock_res *res)
@@ -2869,8 +2865,15 @@ static void *ocfs2_dlm_seq_next(struct seq_file *m, void *v, loff_t *pos)
 	return iter;
 }
 
-/* So that debugfs.ocfs2 can determine which format is being used */
-#define OCFS2_DLM_DEBUG_STR_VERSION 2
+/*
+ * Version is used by debugfs.ocfs2 to determine the format being used
+ *
+ * New in version 2
+ *	- Lock stats printed
+ * New in version 3
+ *	- Max time in lock stats is in usecs (instead of nsecs)
+ */
+#define OCFS2_DLM_DEBUG_STR_VERSION 3
 static int ocfs2_dlm_seq_show(struct seq_file *m, void *v)
 {
 	int i;
@@ -2912,18 +2915,18 @@ static int ocfs2_dlm_seq_show(struct seq_file *m, void *v)
 		seq_printf(m, "0x%x\t", lvb[i]);
 
 #ifdef CONFIG_OCFS2_FS_STATS
-# define lock_num_prmode(_l)		(_l)->l_lock_num_prmode
-# define lock_num_exmode(_l)		(_l)->l_lock_num_exmode
-# define lock_num_prmode_failed(_l)	(_l)->l_lock_num_prmode_failed
-# define lock_num_exmode_failed(_l)	(_l)->l_lock_num_exmode_failed
-# define lock_total_prmode(_l)		(_l)->l_lock_total_prmode
-# define lock_total_exmode(_l)		(_l)->l_lock_total_exmode
-# define lock_max_prmode(_l)		(_l)->l_lock_max_prmode
-# define lock_max_exmode(_l)		(_l)->l_lock_max_exmode
-# define lock_refresh(_l)		(_l)->l_lock_refresh
+# define lock_num_prmode(_l)		((_l)->l_lock_prmode.ls_gets)
+# define lock_num_exmode(_l)		((_l)->l_lock_exmode.ls_gets)
+# define lock_num_prmode_failed(_l)	((_l)->l_lock_prmode.ls_fail)
+# define lock_num_exmode_failed(_l)	((_l)->l_lock_exmode.ls_fail)
+# define lock_total_prmode(_l)		((_l)->l_lock_prmode.ls_total)
+# define lock_total_exmode(_l)		((_l)->l_lock_exmode.ls_total)
+# define lock_max_prmode(_l)		((_l)->l_lock_prmode.ls_max)
+# define lock_max_exmode(_l)		((_l)->l_lock_exmode.ls_max)
+# define lock_refresh(_l)		((_l)->l_lock_refresh)
 #else
-# define lock_num_prmode(_l)		(0ULL)
-# define lock_num_exmode(_l)		(0ULL)
+# define lock_num_prmode(_l)		(0)
+# define lock_num_exmode(_l)		(0)
 # define lock_num_prmode_failed(_l)	(0)
 # define lock_num_exmode_failed(_l)	(0)
 # define lock_total_prmode(_l)		(0ULL)
@@ -2933,8 +2936,8 @@ static int ocfs2_dlm_seq_show(struct seq_file *m, void *v)
 # define lock_refresh(_l)		(0)
 #endif
 	/* The following seq_print was added in version 2 of this output */
-	seq_printf(m, "%llu\t"
-		   "%llu\t"
+	seq_printf(m, "%u\t"
+		   "%u\t"
 		   "%u\t"
 		   "%u\t"
 		   "%llu\t"
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 70dd3b1..0b04cfd 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -147,6 +147,17 @@ struct ocfs2_lock_res_ops;
 
 typedef void (*ocfs2_lock_callback)(int status, unsigned long data);
 
+#ifdef CONFIG_OCFS2_FS_STATS
+struct ocfs2_lock_stats {
+	u64		ls_total;	/* Total wait in NSEC */
+	u32		ls_gets;	/* Num acquires */
+	u32		ls_fail;	/* Num failed acquires */
+
+	/* Storing max wait in usecs saves 24 bytes per inode */
+	u32		ls_max;		/* Max wait in USEC */
+};
+#endif
+
 struct ocfs2_lock_res {
 	void                    *l_priv;
 	struct ocfs2_lock_res_ops *l_ops;
@@ -182,15 +193,9 @@ struct ocfs2_lock_res {
 	struct list_head         l_debug_list;
 
 #ifdef CONFIG_OCFS2_FS_STATS
-	unsigned long long	 l_lock_num_prmode; 	   /* PR acquires */
-	unsigned long long 	 l_lock_num_exmode; 	   /* EX acquires */
-	unsigned int		 l_lock_num_prmode_failed; /* Failed PR gets */
-	unsigned int		 l_lock_num_exmode_failed; /* Failed EX gets */
-	unsigned long long	 l_lock_total_prmode; 	   /* Tot wait for PR */
-	unsigned long long	 l_lock_total_exmode; 	   /* Tot wait for EX */
-	unsigned int		 l_lock_max_prmode; 	   /* Max wait for PR */
-	unsigned int		 l_lock_max_exmode; 	   /* Max wait for EX */
-	unsigned int		 l_lock_refresh;	   /* Disk refreshes */
+	struct ocfs2_lock_stats  l_lock_prmode;		/* PR mode stats */
+	u32                      l_lock_refresh;	/* Disk refreshes */
+	struct ocfs2_lock_stats  l_lock_exmode;		/* EX mode stats */
 #endif
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	 l_lockdep_map;
-- 
1.7.1
