From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed,  2 Apr 2008 16:16:28 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Add cluster lock stats at the fs
	level
Message-ID: <1207178188-30130-1-git-send-email-sunil.mushran@oracle.com>
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
 fs/ocfs2/dlmglue.c |   69 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ocfs2/ocfs2.h   |   10 +++++++
 2 files changed, 78 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 1f1873b..cede25f 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -32,6 +32,7 @@
 #include <linux/pagemap.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
+#include <linux/time.h>
 
 #include <cluster/heartbeat.h>
 #include <cluster/nodemanager.h>
@@ -65,6 +66,7 @@ struct ocfs2_mask_waiter {
 	struct completion	mw_complete;
 	unsigned long		mw_mask;
 	unsigned long		mw_goal;
+	unsigned long long 	mw_lock_start;
 };
 
 static struct ocfs2_super *ocfs2_get_dentry_osb(struct ocfs2_lock_res *lockres);
@@ -415,6 +417,16 @@ static void ocfs2_lock_res_init_common(struct ocfs2_super *osb,
 	res->l_flags         = OCFS2_LOCK_INITIALIZED;
 
 	ocfs2_add_lockres_tracking(res, osb->osb_dlm_debug);
+
+	res->l_lock_num_prmode = 0;
+	res->l_lock_num_prmode_failed = 0;
+	res->l_lock_total_prmode = 0;
+	res->l_lock_max_prmode = 0;
+	res->l_lock_num_exmode = 0;
+	res->l_lock_num_exmode_failed = 0;
+	res->l_lock_total_exmode = 0;
+	res->l_lock_max_exmode = 0;
+	res->l_lock_refresh = 0;
 }
 
 void ocfs2_lock_res_init_once(struct ocfs2_lock_res *res)
@@ -950,8 +962,11 @@ static inline int ocfs2_may_continue_on_blocked_lock(struct ocfs2_lock_res *lock
 
 static void ocfs2_init_mask_waiter(struct ocfs2_mask_waiter *mw)
 {
+	struct timespec ts = current_kernel_time();
+
 	INIT_LIST_HEAD(&mw->mw_item);
 	init_completion(&mw->mw_complete);
+	mw->mw_lock_start = timespec_to_ns(&ts);
 }
 
 static int ocfs2_wait_for_mask(struct ocfs2_mask_waiter *mw)
@@ -1013,6 +1028,35 @@ static int ocfs2_wait_for_mask_interruptible(struct ocfs2_mask_waiter *mw,
 	return ret;
 }
 
+static void add_lock_stats(struct ocfs2_lock_res *lockres, int level,
+			   struct ocfs2_mask_waiter *mw, int ret)
+{
+	unsigned long long *num, *sum;
+	unsigned int *max, *failed;
+	struct timespec ts = current_kernel_time();
+	unsigned long long time = timespec_to_ns(&ts) - mw->mw_lock_start;
+
+	if (level == LKM_PRMODE) {
+		num = &lockres->l_lock_num_prmode;
+		sum = &lockres->l_lock_total_prmode;
+		max = &lockres->l_lock_max_prmode;
+		failed = &lockres->l_lock_num_prmode_failed;
+	} else if (level == LKM_EXMODE) {
+		num = &lockres->l_lock_num_exmode;
+		sum = &lockres->l_lock_total_exmode;
+		max = &lockres->l_lock_max_exmode;
+		failed = &lockres->l_lock_num_exmode_failed;
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
 static int ocfs2_cluster_lock(struct ocfs2_super *osb,
 			      struct ocfs2_lock_res *lockres,
 			      int level,
@@ -1153,6 +1197,7 @@ out:
 			goto again;
 		mlog_errno(ret);
 	}
+	add_lock_stats(lockres, level, &mw, ret);
 
 	mlog_exit(ret);
 	return ret;
@@ -1878,6 +1923,7 @@ static int ocfs2_inode_lock_update(struct inode *inode,
 				le32_to_cpu(fe->i_flags));
 
 		ocfs2_refresh_inode(inode, fe);
+		lockres->l_lock_refresh++;
 	}
 
 	status = 0;
@@ -2169,6 +2215,7 @@ int ocfs2_super_lock(struct ocfs2_super *osb,
 
 		if (status < 0)
 			mlog_errno(status);
+		lockres->l_lock_refresh++;
 	}
 bail:
 	mlog_exit(status);
@@ -2363,7 +2410,7 @@ static void *ocfs2_dlm_seq_next(struct seq_file *m, void *v, loff_t *pos)
 }
 
 /* So that debugfs.ocfs2 can determine which format is being used */
-#define OCFS2_DLM_DEBUG_STR_VERSION 1
+#define OCFS2_DLM_DEBUG_STR_VERSION 2
 static int ocfs2_dlm_seq_show(struct seq_file *m, void *v)
 {
 	int i;
@@ -2404,6 +2451,26 @@ static int ocfs2_dlm_seq_show(struct seq_file *m, void *v)
 	for(i = 0; i < DLM_LVB_LEN; i++)
 		seq_printf(m, "0x%x\t", lvb[i]);
 
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
+
 	/* End the line */
 	seq_printf(m, "\n");
 	return 0;
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 6546cef..771fd81 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -131,6 +131,16 @@ struct ocfs2_lock_res {
 	wait_queue_head_t        l_event;
 
 	struct list_head         l_debug_list;
+
+	unsigned long long	 l_lock_num_prmode; 	   /* PR acquires */
+	unsigned long long 	 l_lock_num_exmode; 	   /* EX acquires */
+	unsigned int		 l_lock_num_prmode_failed; /* Failed PR gets */
+	unsigned int		 l_lock_num_exmode_failed; /* Failed EX gets */
+	unsigned long long	 l_lock_total_prmode; 	   /* Tot wait for PR */
+	unsigned long long	 l_lock_total_exmode; 	   /* Tot wait for EX */
+	unsigned int		 l_lock_max_prmode; 	   /* Max wait for PR */
+	unsigned int		 l_lock_max_exmode; 	   /* Max wait for EX */
+	unsigned int		 l_lock_refresh;	   /* Disk refreshes */
 };
 
 struct ocfs2_dlm_debug {
-- 
1.5.3.4
