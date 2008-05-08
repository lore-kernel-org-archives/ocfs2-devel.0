From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu,  8 May 2008 10:57:01 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Add cluster lock stats at the fs
	level
In-Reply-To: <1210269421-10192-1-git-send-email-sunil.mushran@oracle.com>
References: <1210269421-10192-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1210269421-10192-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch adds code to track the number of times the fs takes
various cluster locks as well as the times associated with it.

Authored-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlmglue.c |   96 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/ocfs2.h   |   12 ++++++
 2 files changed, 108 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 394d25a..9175c89 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -31,6 +31,7 @@
 #include <linux/pagemap.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
+#include <linux/time.h>
 
 #define MLOG_MASK_PREFIX ML_DLM_GLUE
 #include <cluster/masklog.h>
@@ -59,6 +60,9 @@ struct ocfs2_mask_waiter {
 	struct completion	mw_complete;
 	unsigned long		mw_mask;
 	unsigned long		mw_goal;
+#ifdef CONFIG_OCFS2_FS_STATS
+	unsigned long long 	mw_lock_start;
+#endif
 };
 
 static struct ocfs2_super *ocfs2_get_dentry_osb(struct ocfs2_lock_res *lockres);
@@ -366,6 +370,66 @@ static void ocfs2_remove_lockres_tracking(struct ocfs2_lock_res *res)
 	spin_unlock(&ocfs2_dlm_tracking_lock);
 }
 
+#ifdef CONFIG_OCFS2_FS_STATS
+static void ocfs2_init_lock_stats(struct ocfs2_lock_res *res)
+{
+	res->l_lock_num_prmode = 0;
+	res->l_lock_num_prmode_failed = 0;
+	res->l_lock_total_prmode = 0;
+	res->l_lock_max_prmode = 0;
+	res->l_lock_num_exmode = 0;
+	res->l_lock_num_exmode_failed = 0;
+	res->l_lock_total_exmode = 0;
+	res->l_lock_max_exmode = 0;
+	res->l_lock_refresh = 0;
+}
+
+static void ocfs2_update_lock_stats(struct ocfs2_lock_res *res, int level,
+				    struct ocfs2_mask_waiter *mw, int ret)
+{
+	unsigned long long *num, *sum;
+	unsigned int *max, *failed;
+	struct timespec ts = current_kernel_time();
+	unsigned long long time = timespec_to_ns(&ts) - mw->mw_lock_start;
+
+	if (level == LKM_PRMODE) {
+		num = &res->l_lock_num_prmode;
+		sum = &res->l_lock_total_prmode;
+		max = &res->l_lock_max_prmode;
+		failed = &res->l_lock_num_prmode_failed;
+	} else if (level == LKM_EXMODE) {
+		num = &res->l_lock_num_exmode;
+		sum = &res->l_lock_total_exmode;
+		max = &res->l_lock_max_exmode;
+		failed = &res->l_lock_num_exmode_failed;
+	} else
+		return;
+
+	(*num)++;
+	(*sum) += time;
+	if (time > *max)
+		*max = time;
+	if (ret)
+		(*failed)++;
+}
+
+static inline void ocfs2_track_lock_refresh(struct ocfs2_lock_res *lockres)
+{
+	lockres->l_lock_refresh++;
+}
+
+static inline void ocfs2_init_start_time(struct ocfs2_mask_waiter *mw)
+{
+	struct timespec ts = current_kernel_time();
+	mw->mw_lock_start = timespec_to_ns(&ts);
+}
+#else
+# define ocfs2_init_lock_stats(a)
+# define ocfs2_update_lock_stats(a,b,c,d)
+# define ocfs2_track_lock_refresh(a)
+# define ocfs2_init_start_time(a)
+#endif
+
 static void ocfs2_lock_res_init_common(struct ocfs2_super *osb,
 				       struct ocfs2_lock_res *res,
 				       enum ocfs2_lock_type type,
@@ -385,6 +449,8 @@ static void ocfs2_lock_res_init_common(struct ocfs2_super *osb,
 	res->l_flags         = OCFS2_LOCK_INITIALIZED;
 
 	ocfs2_add_lockres_tracking(res, osb->osb_dlm_debug);
+
+	ocfs2_init_lock_stats(res);
 }
 
 void ocfs2_lock_res_init_once(struct ocfs2_lock_res *res)
@@ -1048,6 +1114,7 @@ static void ocfs2_init_mask_waiter(struct ocfs2_mask_waiter *mw)
 {
 	INIT_LIST_HEAD(&mw->mw_item);
 	init_completion(&mw->mw_complete);
+	ocfs2_init_start_time(mw);
 }
 
 static int ocfs2_wait_for_mask(struct ocfs2_mask_waiter *mw)
@@ -1254,6 +1321,7 @@ out:
 			goto again;
 		mlog_errno(ret);
 	}
+	ocfs2_update_lock_stats(lockres, level, &mw, ret);
 
 	mlog_exit(ret);
 	return ret;
@@ -1983,6 +2051,7 @@ static int ocfs2_inode_lock_update(struct inode *inode,
 				le32_to_cpu(fe->i_flags));
 
 		ocfs2_refresh_inode(inode, fe);
+		ocfs2_track_lock_refresh(lockres);
 	}
 
 	status = 0;
@@ -2267,6 +2336,7 @@ int ocfs2_super_lock(struct ocfs2_super *osb,
 
 		if (status < 0)
 			mlog_errno(status);
+		ocfs2_track_lock_refresh(lockres);
 	}
 bail:
 	mlog_exit(status);
@@ -2461,7 +2531,11 @@ static void *ocfs2_dlm_seq_next(struct seq_file *m, void *v, loff_t *pos)
 }
 
 /* So that debugfs.ocfs2 can determine which format is being used */
+#ifdef CONFIG_OCFS2_FS_STATS
+#define OCFS2_DLM_DEBUG_STR_VERSION 2
+#else
 #define OCFS2_DLM_DEBUG_STR_VERSION 1
+#endif
 static int ocfs2_dlm_seq_show(struct seq_file *m, void *v)
 {
 	int i;
@@ -2502,6 +2576,28 @@ static int ocfs2_dlm_seq_show(struct seq_file *m, void *v)
 	for(i = 0; i < DLM_LVB_LEN; i++)
 		seq_printf(m, "0x%x\t", lvb[i]);
 
+#ifdef CONFIG_OCFS2_FS_STATS
+	/* The following seq_print was added in version 2 of this output */
+	seq_printf(m, "%llu\t"
+		   "%llu\t"
+		   "%u\t"
+		   "%u\t"
+		   "%llu\t"
+		   "%llu\t"
+		   "%u\t"
+		   "%u\t"
+		   "%u\t",
+		   lockres->l_lock_num_prmode,
+		   lockres->l_lock_num_exmode,
+		   lockres->l_lock_num_prmode_failed,
+		   lockres->l_lock_num_exmode_failed,
+		   lockres->l_lock_total_prmode,
+		   lockres->l_lock_total_exmode,
+		   lockres->l_lock_max_prmode,
+		   lockres->l_lock_max_exmode,
+		   lockres->l_lock_refresh);
+#endif
+
 	/* End the line */
 	seq_printf(m, "\n");
 	return 0;
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 3169237..1cb814b 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -132,6 +132,18 @@ struct ocfs2_lock_res {
 	wait_queue_head_t        l_event;
 
 	struct list_head         l_debug_list;
+
+#ifdef CONFIG_OCFS2_FS_STATS
+	unsigned long long	 l_lock_num_prmode; 	   /* PR acquires */
+	unsigned long long 	 l_lock_num_exmode; 	   /* EX acquires */
+	unsigned int		 l_lock_num_prmode_failed; /* Failed PR gets */
+	unsigned int		 l_lock_num_exmode_failed; /* Failed EX gets */
+	unsigned long long	 l_lock_total_prmode; 	   /* Tot wait for PR */
+	unsigned long long	 l_lock_total_exmode; 	   /* Tot wait for EX */
+	unsigned int		 l_lock_max_prmode; 	   /* Max wait for PR */
+	unsigned int		 l_lock_max_exmode; 	   /* Max wait for EX */
+	unsigned int		 l_lock_refresh;	   /* Disk refreshes */
+#endif
 };
 
 struct ocfs2_dlm_debug {
-- 
1.5.3.6
