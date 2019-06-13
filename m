From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Thu, 13 Jun 2019 07:54:55 +0200
Subject: [Ocfs2-devel] [PATCH v2] ocfs: no need to check return value of
 debugfs_create functions
In-Reply-To: <23e08cff-6a97-b583-5dfb-652a51f92d8d@linux.alibaba.com>
References: <20190612152912.GA19151@kroah.com>
	<23e08cff-6a97-b583-5dfb-652a51f92d8d@linux.alibaba.com>
Message-ID: <20190613055455.GE19717@kroah.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

Also, because there is no need to save the file dentry, remove all of
the variables that were being saved, and just recursively delete the
whole directory when shutting down, saving a lot of logic and local
variables.

Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jia Guo <guojia12@huawei.com>
Cc: ocfs2-devel at oss.oracle.com
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
v2: fix up some build warnings pointed out by Joseph.

 fs/ocfs2/blockcheck.c          |  56 +++++-------------
 fs/ocfs2/blockcheck.h          |   7 +--
 fs/ocfs2/cluster/heartbeat.c   | 100 +++++++++------------------------
 fs/ocfs2/cluster/heartbeat.h   |   2 +-
 fs/ocfs2/cluster/netdebug.c    |  39 ++++---------
 fs/ocfs2/cluster/nodemanager.c |   4 +-
 fs/ocfs2/cluster/tcp.c         |   3 +-
 fs/ocfs2/cluster/tcp.h         |   5 +-
 fs/ocfs2/dlm/dlmdebug.c        |  44 ++-------------
 fs/ocfs2/dlm/dlmdebug.h        |  10 ++--
 fs/ocfs2/dlm/dlmdomain.c       |  10 +---
 fs/ocfs2/dlmglue.c             |  18 +-----
 fs/ocfs2/super.c               |  29 +---------
 13 files changed, 73 insertions(+), 254 deletions(-)

diff --git a/fs/ocfs2/blockcheck.c b/fs/ocfs2/blockcheck.c
index 005b813a56b6..429e6a8359a5 100644
--- a/fs/ocfs2/blockcheck.c
+++ b/fs/ocfs2/blockcheck.c
@@ -242,57 +242,29 @@ static struct dentry *blockcheck_debugfs_create(const char *name,
 static void ocfs2_blockcheck_debug_remove(struct ocfs2_blockcheck_stats *stats)
 {
 	if (stats) {
-		debugfs_remove(stats->b_debug_check);
-		stats->b_debug_check = NULL;
-		debugfs_remove(stats->b_debug_failure);
-		stats->b_debug_failure = NULL;
-		debugfs_remove(stats->b_debug_recover);
-		stats->b_debug_recover = NULL;
-		debugfs_remove(stats->b_debug_dir);
+		debugfs_remove_recursive(stats->b_debug_dir);
 		stats->b_debug_dir = NULL;
 	}
 }
 
-static int ocfs2_blockcheck_debug_install(struct ocfs2_blockcheck_stats *stats,
-					  struct dentry *parent)
+static void ocfs2_blockcheck_debug_install(struct ocfs2_blockcheck_stats *stats,
+					   struct dentry *parent)
 {
-	int rc = -EINVAL;
-
-	if (!stats)
-		goto out;
-
 	stats->b_debug_dir = debugfs_create_dir("blockcheck", parent);
-	if (!stats->b_debug_dir)
-		goto out;
 
-	stats->b_debug_check =
-		blockcheck_debugfs_create("blocks_checked",
-					  stats->b_debug_dir,
-					  &stats->b_check_count);
+	blockcheck_debugfs_create("blocks_checked", stats->b_debug_dir,
+				  &stats->b_check_count);
 
-	stats->b_debug_failure =
-		blockcheck_debugfs_create("checksums_failed",
-					  stats->b_debug_dir,
-					  &stats->b_failure_count);
+	blockcheck_debugfs_create("checksums_failed", stats->b_debug_dir,
+				  &stats->b_failure_count);
 
-	stats->b_debug_recover =
-		blockcheck_debugfs_create("ecc_recoveries",
-					  stats->b_debug_dir,
-					  &stats->b_recover_count);
-	if (stats->b_debug_check && stats->b_debug_failure &&
-	    stats->b_debug_recover)
-		rc = 0;
-
-out:
-	if (rc)
-		ocfs2_blockcheck_debug_remove(stats);
-	return rc;
+	blockcheck_debugfs_create("ecc_recoveries", stats->b_debug_dir,
+				  &stats->b_recover_count);
 }
 #else
-static inline int ocfs2_blockcheck_debug_install(struct ocfs2_blockcheck_stats *stats,
-						 struct dentry *parent)
+static inline void ocfs2_blockcheck_debug_install(struct ocfs2_blockcheck_stats *stats,
+						  struct dentry *parent)
 {
-	return 0;
 }
 
 static inline void ocfs2_blockcheck_debug_remove(struct ocfs2_blockcheck_stats *stats)
@@ -301,10 +273,10 @@ static inline void ocfs2_blockcheck_debug_remove(struct ocfs2_blockcheck_stats *
 #endif  /* CONFIG_DEBUG_FS */
 
 /* Always-called wrappers for starting and stopping the debugfs files */
-int ocfs2_blockcheck_stats_debugfs_install(struct ocfs2_blockcheck_stats *stats,
-					   struct dentry *parent)
+void ocfs2_blockcheck_stats_debugfs_install(struct ocfs2_blockcheck_stats *stats,
+					    struct dentry *parent)
 {
-	return ocfs2_blockcheck_debug_install(stats, parent);
+	ocfs2_blockcheck_debug_install(stats, parent);
 }
 
 void ocfs2_blockcheck_stats_debugfs_remove(struct ocfs2_blockcheck_stats *stats)
diff --git a/fs/ocfs2/blockcheck.h b/fs/ocfs2/blockcheck.h
index f2d2689407fa..8f17d2c85f40 100644
--- a/fs/ocfs2/blockcheck.h
+++ b/fs/ocfs2/blockcheck.h
@@ -25,9 +25,6 @@ struct ocfs2_blockcheck_stats {
 	 * ocfs2_blockcheck_stats_debugfs_install()
 	 */
 	struct dentry *b_debug_dir;	/* Parent of the debugfs  files */
-	struct dentry *b_debug_check;	/* Exposes b_check_count */
-	struct dentry *b_debug_failure;	/* Exposes b_failure_count */
-	struct dentry *b_debug_recover;	/* Exposes b_recover_count */
 };
 
 
@@ -56,8 +53,8 @@ int ocfs2_block_check_validate_bhs(struct buffer_head **bhs, int nr,
 				   struct ocfs2_blockcheck_stats *stats);
 
 /* Debug Initialization */
-int ocfs2_blockcheck_stats_debugfs_install(struct ocfs2_blockcheck_stats *stats,
-					   struct dentry *parent);
+void ocfs2_blockcheck_stats_debugfs_install(struct ocfs2_blockcheck_stats *stats,
+					    struct dentry *parent);
 void ocfs2_blockcheck_stats_debugfs_remove(struct ocfs2_blockcheck_stats *stats);
 
 /*
diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 7a3a096856a8..9d2fcb476f2b 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -92,10 +92,6 @@ static struct o2hb_debug_buf *o2hb_db_failedregions;
 #define O2HB_DEBUG_REGION_PINNED	"pinned"
 
 static struct dentry *o2hb_debug_dir;
-static struct dentry *o2hb_debug_livenodes;
-static struct dentry *o2hb_debug_liveregions;
-static struct dentry *o2hb_debug_quorumregions;
-static struct dentry *o2hb_debug_failedregions;
 
 static LIST_HEAD(o2hb_all_regions);
 
@@ -1391,11 +1387,7 @@ static const struct file_operations o2hb_debug_fops = {
 
 void o2hb_exit(void)
 {
-	debugfs_remove(o2hb_debug_failedregions);
-	debugfs_remove(o2hb_debug_quorumregions);
-	debugfs_remove(o2hb_debug_liveregions);
-	debugfs_remove(o2hb_debug_livenodes);
-	debugfs_remove(o2hb_debug_dir);
+	debugfs_remove_recursive(o2hb_debug_dir);
 	kfree(o2hb_db_livenodes);
 	kfree(o2hb_db_liveregions);
 	kfree(o2hb_db_quorumregions);
@@ -1419,79 +1411,37 @@ static struct dentry *o2hb_debug_create(const char *name, struct dentry *dir,
 				   &o2hb_debug_fops);
 }
 
-static int o2hb_debug_init(void)
+static void o2hb_debug_init(void)
 {
-	int ret = -ENOMEM;
-
 	o2hb_debug_dir = debugfs_create_dir(O2HB_DEBUG_DIR, NULL);
-	if (!o2hb_debug_dir) {
-		mlog_errno(ret);
-		goto bail;
-	}
 
-	o2hb_debug_livenodes = o2hb_debug_create(O2HB_DEBUG_LIVENODES,
-						 o2hb_debug_dir,
-						 &o2hb_db_livenodes,
-						 sizeof(*o2hb_db_livenodes),
-						 O2HB_DB_TYPE_LIVENODES,
-						 sizeof(o2hb_live_node_bitmap),
-						 O2NM_MAX_NODES,
-						 o2hb_live_node_bitmap);
-	if (!o2hb_debug_livenodes) {
-		mlog_errno(ret);
-		goto bail;
-	}
+	o2hb_debug_create(O2HB_DEBUG_LIVENODES, o2hb_debug_dir,
+			  &o2hb_db_livenodes, sizeof(*o2hb_db_livenodes),
+			  O2HB_DB_TYPE_LIVENODES, sizeof(o2hb_live_node_bitmap),
+			  O2NM_MAX_NODES, o2hb_live_node_bitmap);
 
-	o2hb_debug_liveregions = o2hb_debug_create(O2HB_DEBUG_LIVEREGIONS,
-						   o2hb_debug_dir,
-						   &o2hb_db_liveregions,
-						   sizeof(*o2hb_db_liveregions),
-						   O2HB_DB_TYPE_LIVEREGIONS,
-						   sizeof(o2hb_live_region_bitmap),
-						   O2NM_MAX_REGIONS,
-						   o2hb_live_region_bitmap);
-	if (!o2hb_debug_liveregions) {
-		mlog_errno(ret);
-		goto bail;
-	}
+	o2hb_debug_create(O2HB_DEBUG_LIVEREGIONS, o2hb_debug_dir,
+			  &o2hb_db_liveregions, sizeof(*o2hb_db_liveregions),
+			  O2HB_DB_TYPE_LIVEREGIONS,
+			  sizeof(o2hb_live_region_bitmap), O2NM_MAX_REGIONS,
+			  o2hb_live_region_bitmap);
 
-	o2hb_debug_quorumregions =
-			o2hb_debug_create(O2HB_DEBUG_QUORUMREGIONS,
-					  o2hb_debug_dir,
-					  &o2hb_db_quorumregions,
-					  sizeof(*o2hb_db_quorumregions),
-					  O2HB_DB_TYPE_QUORUMREGIONS,
-					  sizeof(o2hb_quorum_region_bitmap),
-					  O2NM_MAX_REGIONS,
-					  o2hb_quorum_region_bitmap);
-	if (!o2hb_debug_quorumregions) {
-		mlog_errno(ret);
-		goto bail;
-	}
-
-	o2hb_debug_failedregions =
-			o2hb_debug_create(O2HB_DEBUG_FAILEDREGIONS,
-					  o2hb_debug_dir,
-					  &o2hb_db_failedregions,
-					  sizeof(*o2hb_db_failedregions),
-					  O2HB_DB_TYPE_FAILEDREGIONS,
-					  sizeof(o2hb_failed_region_bitmap),
-					  O2NM_MAX_REGIONS,
-					  o2hb_failed_region_bitmap);
-	if (!o2hb_debug_failedregions) {
-		mlog_errno(ret);
-		goto bail;
-	}
+	o2hb_debug_create(O2HB_DEBUG_QUORUMREGIONS, o2hb_debug_dir,
+			  &o2hb_db_quorumregions,
+			  sizeof(*o2hb_db_quorumregions),
+			  O2HB_DB_TYPE_QUORUMREGIONS,
+			  sizeof(o2hb_quorum_region_bitmap), O2NM_MAX_REGIONS,
+			  o2hb_quorum_region_bitmap);
 
-	ret = 0;
-bail:
-	if (ret)
-		o2hb_exit();
-
-	return ret;
+	o2hb_debug_create(O2HB_DEBUG_FAILEDREGIONS, o2hb_debug_dir,
+			  &o2hb_db_failedregions,
+			  sizeof(*o2hb_db_failedregions),
+			  O2HB_DB_TYPE_FAILEDREGIONS,
+			  sizeof(o2hb_failed_region_bitmap), O2NM_MAX_REGIONS,
+			  o2hb_failed_region_bitmap);
 }
 
-int o2hb_init(void)
+void o2hb_init(void)
 {
 	int i;
 
@@ -1511,7 +1461,7 @@ int o2hb_init(void)
 
 	o2hb_dependent_users = 0;
 
-	return o2hb_debug_init();
+	o2hb_debug_init();
 }
 
 /* if we're already in a callback then we're already serialized by the sem */
diff --git a/fs/ocfs2/cluster/heartbeat.h b/fs/ocfs2/cluster/heartbeat.h
index 7f37540ac4ab..beed31ea86cf 100644
--- a/fs/ocfs2/cluster/heartbeat.h
+++ b/fs/ocfs2/cluster/heartbeat.h
@@ -63,7 +63,7 @@ void o2hb_unregister_callback(const char *region_uuid,
 void o2hb_fill_node_map(unsigned long *map,
 			unsigned bytes);
 void o2hb_exit(void);
-int o2hb_init(void);
+void o2hb_init(void);
 int o2hb_check_node_heartbeating_no_sem(u8 node_num);
 int o2hb_check_node_heartbeating_from_callback(u8 node_num);
 void o2hb_stop_all_regions(void);
diff --git a/fs/ocfs2/cluster/netdebug.c b/fs/ocfs2/cluster/netdebug.c
index 0784575f4c2a..02bf4a1774cc 100644
--- a/fs/ocfs2/cluster/netdebug.c
+++ b/fs/ocfs2/cluster/netdebug.c
@@ -38,10 +38,6 @@
 #define SHOW_SOCK_STATS		1
 
 static struct dentry *o2net_dentry;
-static struct dentry *sc_dentry;
-static struct dentry *nst_dentry;
-static struct dentry *stats_dentry;
-static struct dentry *nodes_dentry;
 
 static DEFINE_SPINLOCK(o2net_debug_lock);
 
@@ -490,36 +486,23 @@ static const struct file_operations nodes_fops = {
 
 void o2net_debugfs_exit(void)
 {
-	debugfs_remove(nodes_dentry);
-	debugfs_remove(stats_dentry);
-	debugfs_remove(sc_dentry);
-	debugfs_remove(nst_dentry);
-	debugfs_remove(o2net_dentry);
+	debugfs_remove_recursive(o2net_dentry);
 }
 
-int o2net_debugfs_init(void)
+void o2net_debugfs_init(void)
 {
 	umode_t mode = S_IFREG|S_IRUSR;
 
 	o2net_dentry = debugfs_create_dir(O2NET_DEBUG_DIR, NULL);
-	if (o2net_dentry)
-		nst_dentry = debugfs_create_file(NST_DEBUG_NAME, mode,
-					o2net_dentry, NULL, &nst_seq_fops);
-	if (nst_dentry)
-		sc_dentry = debugfs_create_file(SC_DEBUG_NAME, mode,
-					o2net_dentry, NULL, &sc_seq_fops);
-	if (sc_dentry)
-		stats_dentry = debugfs_create_file(STATS_DEBUG_NAME, mode,
-					o2net_dentry, NULL, &stats_seq_fops);
-	if (stats_dentry)
-		nodes_dentry = debugfs_create_file(NODES_DEBUG_NAME, mode,
-					o2net_dentry, NULL, &nodes_fops);
-	if (nodes_dentry)
-		return 0;
-
-	o2net_debugfs_exit();
-	mlog_errno(-ENOMEM);
-	return -ENOMEM;
+
+	debugfs_create_file(NST_DEBUG_NAME, mode, o2net_dentry, NULL,
+			    &nst_seq_fops);
+	debugfs_create_file(SC_DEBUG_NAME, mode, o2net_dentry, NULL,
+			    &sc_seq_fops);
+	debugfs_create_file(STATS_DEBUG_NAME, mode, o2net_dentry, NULL,
+			    &stats_seq_fops);
+	debugfs_create_file(NODES_DEBUG_NAME, mode, o2net_dentry, NULL,
+			    &nodes_fops);
 }
 
 #endif	/* CONFIG_DEBUG_FS */
diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
index 2234f7fd1f7c..7a7640c59f3c 100644
--- a/fs/ocfs2/cluster/nodemanager.c
+++ b/fs/ocfs2/cluster/nodemanager.c
@@ -828,9 +828,7 @@ static int __init init_o2nm(void)
 {
 	int ret = -1;
 
-	ret = o2hb_init();
-	if (ret)
-		goto out;
+	o2hb_init();
 
 	ret = o2net_init();
 	if (ret)
diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index c599463d0694..80df75227c97 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -2129,8 +2129,7 @@ int o2net_init(void)
 
 	o2quo_init();
 
-	if (o2net_debugfs_init())
-		goto out;
+	o2net_debugfs_init();
 
 	o2net_hand = kzalloc(sizeof(struct o2net_handshake), GFP_KERNEL);
 	o2net_keep_req = kzalloc(sizeof(struct o2net_msg), GFP_KERNEL);
diff --git a/fs/ocfs2/cluster/tcp.h b/fs/ocfs2/cluster/tcp.h
index dd4242be3f1f..de87cbffd175 100644
--- a/fs/ocfs2/cluster/tcp.h
+++ b/fs/ocfs2/cluster/tcp.h
@@ -109,16 +109,15 @@ struct o2net_send_tracking;
 struct o2net_sock_container;
 
 #ifdef CONFIG_DEBUG_FS
-int o2net_debugfs_init(void);
+void o2net_debugfs_init(void);
 void o2net_debugfs_exit(void);
 void o2net_debug_add_nst(struct o2net_send_tracking *nst);
 void o2net_debug_del_nst(struct o2net_send_tracking *nst);
 void o2net_debug_add_sc(struct o2net_sock_container *sc);
 void o2net_debug_del_sc(struct o2net_sock_container *sc);
 #else
-static inline int o2net_debugfs_init(void)
+static inline void o2net_debugfs_init(void)
 {
-	return 0;
 }
 static inline void o2net_debugfs_exit(void)
 {
diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index c8af5bc9e980..a4b58ba99927 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -851,7 +851,7 @@ static const struct file_operations debug_state_fops = {
 /* end  - debug state funcs */
 
 /* files in subroot */
-int dlm_debug_init(struct dlm_ctxt *dlm)
+void dlm_debug_init(struct dlm_ctxt *dlm)
 {
 	struct dlm_debug_ctxt *dc = dlm->dlm_debug_ctxt;
 
@@ -860,10 +860,6 @@ int dlm_debug_init(struct dlm_ctxt *dlm)
 						     S_IFREG|S_IRUSR,
 						     dlm->dlm_debugfs_subroot,
 						     dlm, &debug_state_fops);
-	if (!dc->debug_state_dentry) {
-		mlog_errno(-ENOMEM);
-		goto bail;
-	}
 
 	/* for dumping lockres */
 	dc->debug_lockres_dentry =
@@ -871,20 +867,12 @@ int dlm_debug_init(struct dlm_ctxt *dlm)
 					    S_IFREG|S_IRUSR,
 					    dlm->dlm_debugfs_subroot,
 					    dlm, &debug_lockres_fops);
-	if (!dc->debug_lockres_dentry) {
-		mlog_errno(-ENOMEM);
-		goto bail;
-	}
 
 	/* for dumping mles */
 	dc->debug_mle_dentry = debugfs_create_file(DLM_DEBUGFS_MLE_STATE,
 						   S_IFREG|S_IRUSR,
 						   dlm->dlm_debugfs_subroot,
 						   dlm, &debug_mle_fops);
-	if (!dc->debug_mle_dentry) {
-		mlog_errno(-ENOMEM);
-		goto bail;
-	}
 
 	/* for dumping lockres on the purge list */
 	dc->debug_purgelist_dentry =
@@ -892,15 +880,6 @@ int dlm_debug_init(struct dlm_ctxt *dlm)
 					    S_IFREG|S_IRUSR,
 					    dlm->dlm_debugfs_subroot,
 					    dlm, &debug_purgelist_fops);
-	if (!dc->debug_purgelist_dentry) {
-		mlog_errno(-ENOMEM);
-		goto bail;
-	}
-
-	return 0;
-
-bail:
-	return -ENOMEM;
 }
 
 void dlm_debug_shutdown(struct dlm_ctxt *dlm)
@@ -920,24 +899,16 @@ void dlm_debug_shutdown(struct dlm_ctxt *dlm)
 /* subroot - domain dir */
 int dlm_create_debugfs_subroot(struct dlm_ctxt *dlm)
 {
-	dlm->dlm_debugfs_subroot = debugfs_create_dir(dlm->name,
-						      dlm_debugfs_root);
-	if (!dlm->dlm_debugfs_subroot) {
-		mlog_errno(-ENOMEM);
-		goto bail;
-	}
-
 	dlm->dlm_debug_ctxt = kzalloc(sizeof(struct dlm_debug_ctxt),
 				      GFP_KERNEL);
 	if (!dlm->dlm_debug_ctxt) {
 		mlog_errno(-ENOMEM);
-		goto bail;
+		return -ENOMEM;
 	}
 
+	dlm->dlm_debugfs_subroot = debugfs_create_dir(dlm->name,
+						      dlm_debugfs_root);
 	return 0;
-bail:
-	dlm_destroy_debugfs_subroot(dlm);
-	return -ENOMEM;
 }
 
 void dlm_destroy_debugfs_subroot(struct dlm_ctxt *dlm)
@@ -946,14 +917,9 @@ void dlm_destroy_debugfs_subroot(struct dlm_ctxt *dlm)
 }
 
 /* debugfs root */
-int dlm_create_debugfs_root(void)
+void dlm_create_debugfs_root(void)
 {
 	dlm_debugfs_root = debugfs_create_dir(DLM_DEBUGFS_DIR, NULL);
-	if (!dlm_debugfs_root) {
-		mlog_errno(-ENOMEM);
-		return -ENOMEM;
-	}
-	return 0;
 }
 
 void dlm_destroy_debugfs_root(void)
diff --git a/fs/ocfs2/dlm/dlmdebug.h b/fs/ocfs2/dlm/dlmdebug.h
index 74d019694c7e..7d0c7c9013ce 100644
--- a/fs/ocfs2/dlm/dlmdebug.h
+++ b/fs/ocfs2/dlm/dlmdebug.h
@@ -28,20 +28,19 @@ struct debug_lockres {
 	struct dlm_lock_resource *dl_res;
 };
 
-int dlm_debug_init(struct dlm_ctxt *dlm);
+void dlm_debug_init(struct dlm_ctxt *dlm);
 void dlm_debug_shutdown(struct dlm_ctxt *dlm);
 
 int dlm_create_debugfs_subroot(struct dlm_ctxt *dlm);
 void dlm_destroy_debugfs_subroot(struct dlm_ctxt *dlm);
 
-int dlm_create_debugfs_root(void);
+void dlm_create_debugfs_root(void);
 void dlm_destroy_debugfs_root(void);
 
 #else
 
-static inline int dlm_debug_init(struct dlm_ctxt *dlm)
+static inline void dlm_debug_init(struct dlm_ctxt *dlm)
 {
-	return 0;
 }
 static inline void dlm_debug_shutdown(struct dlm_ctxt *dlm)
 {
@@ -53,9 +52,8 @@ static inline int dlm_create_debugfs_subroot(struct dlm_ctxt *dlm)
 static inline void dlm_destroy_debugfs_subroot(struct dlm_ctxt *dlm)
 {
 }
-static inline int dlm_create_debugfs_root(void)
+static inline void dlm_create_debugfs_root(void)
 {
-	return 0;
 }
 static inline void dlm_destroy_debugfs_root(void)
 {
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 9021e72e1f98..7338b5d4647c 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -1881,11 +1881,7 @@ static int dlm_join_domain(struct dlm_ctxt *dlm)
 		goto bail;
 	}
 
-	status = dlm_debug_init(dlm);
-	if (status < 0) {
-		mlog_errno(status);
-		goto bail;
-	}
+	dlm_debug_init(dlm);
 
 	snprintf(wq_name, O2NM_MAX_NAME_LEN, "dlm_wq-%s", dlm->name);
 	dlm->dlm_worker = alloc_workqueue(wq_name, WQ_MEM_RECLAIM, 0);
@@ -2346,9 +2342,7 @@ static int __init dlm_init(void)
 		goto error;
 	}
 
-	status = dlm_create_debugfs_root();
-	if (status)
-		goto error;
+	dlm_create_debugfs_root();
 
 	return 0;
 error:
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index b5fc5d3c7525..fbae3488a8e9 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3214,9 +3214,8 @@ static const struct file_operations ocfs2_dlm_debug_fops = {
 	.llseek =	seq_lseek,
 };
 
-static int ocfs2_dlm_init_debug(struct ocfs2_super *osb)
+static void ocfs2_dlm_init_debug(struct ocfs2_super *osb)
 {
-	int ret = 0;
 	struct ocfs2_dlm_debug *dlm_debug = osb->osb_dlm_debug;
 
 	dlm_debug->d_locking_state = debugfs_create_file("locking_state",
@@ -3224,16 +3223,7 @@ static int ocfs2_dlm_init_debug(struct ocfs2_super *osb)
 							 osb->osb_debug_root,
 							 osb,
 							 &ocfs2_dlm_debug_fops);
-	if (!dlm_debug->d_locking_state) {
-		ret = -EINVAL;
-		mlog(ML_ERROR,
-		     "Unable to create locking state debugfs file.\n");
-		goto out;
-	}
-
 	ocfs2_get_dlm_debug(dlm_debug);
-out:
-	return ret;
 }
 
 static void ocfs2_dlm_shutdown_debug(struct ocfs2_super *osb)
@@ -3256,11 +3246,7 @@ int ocfs2_dlm_init(struct ocfs2_super *osb)
 		goto local;
 	}
 
-	status = ocfs2_dlm_init_debug(osb);
-	if (status < 0) {
-		mlog_errno(status);
-		goto bail;
-	}
+	ocfs2_dlm_init_debug(osb);
 
 	/* launch downconvert thread */
 	osb->dc_task = kthread_run(ocfs2_downconvert_thread, osb, "ocfs2dc-%s",
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index a201f9780b35..8b2f39506648 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1079,33 +1079,15 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
 	osb->osb_debug_root = debugfs_create_dir(osb->uuid_str,
 						 ocfs2_debugfs_root);
-	if (!osb->osb_debug_root) {
-		status = -EINVAL;
-		mlog(ML_ERROR, "Unable to create per-mount debugfs root.\n");
-		goto read_super_error;
-	}
 
 	osb->osb_ctxt = debugfs_create_file("fs_state", S_IFREG|S_IRUSR,
 					    osb->osb_debug_root,
 					    osb,
 					    &ocfs2_osb_debug_fops);
-	if (!osb->osb_ctxt) {
-		status = -EINVAL;
-		mlog_errno(status);
-		goto read_super_error;
-	}
 
-	if (ocfs2_meta_ecc(osb)) {
-		status = ocfs2_blockcheck_stats_debugfs_install(
-						&osb->osb_ecc_stats,
-						osb->osb_debug_root);
-		if (status) {
-			mlog(ML_ERROR,
-			     "Unable to create blockcheck statistics "
-			     "files\n");
-			goto read_super_error;
-		}
-	}
+	if (ocfs2_meta_ecc(osb))
+		ocfs2_blockcheck_stats_debugfs_install( &osb->osb_ecc_stats,
+							osb->osb_debug_root);
 
 	status = ocfs2_mount_volume(sb);
 	if (status < 0)
@@ -1592,11 +1574,6 @@ static int __init ocfs2_init(void)
 		goto out2;
 
 	ocfs2_debugfs_root = debugfs_create_dir("ocfs2", NULL);
-	if (!ocfs2_debugfs_root) {
-		status = -ENOMEM;
-		mlog(ML_ERROR, "Unable to create ocfs2 debugfs root.\n");
-		goto out3;
-	}
 
 	ocfs2_set_locking_protocol();
 
-- 
2.22.0
