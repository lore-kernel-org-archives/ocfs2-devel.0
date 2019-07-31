From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Wed, 31 Jul 2019 15:21:19 +0200
Subject: [Ocfs2-devel] [PATCH] ocfs: further debugfs cleanups
Message-ID: <20190731132119.GA12603@kroah.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Jia Guo <guojia12@huawei.com>, linux-kernel@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>

There is no need to check return value of debugfs_create functions, but
the last sweep through ocfs missed a number of places where this was
happening.  There is also no need to save the individual dentries for
the debugfs files, as everything is can just be removed at once when the
directory is removed.

By getting rid of the file dentries for the debugfs entries, a bit of
local memory can be saved as well.

Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jia Guo <guojia12@huawei.com>
Cc: ocfs2-devel at oss.oracle.com
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/blockcheck.c        |  26 ++++-----
 fs/ocfs2/cluster/heartbeat.c | 103 +++++++++--------------------------
 fs/ocfs2/dlm/dlmcommon.h     |   1 -
 fs/ocfs2/dlm/dlmdebug.c      |  55 ++++---------------
 fs/ocfs2/dlm/dlmdebug.h      |  16 +-----
 fs/ocfs2/dlm/dlmdomain.c     |   6 +-
 fs/ocfs2/dlmglue.c           |  20 ++-----
 fs/ocfs2/ocfs2.h             |   3 -
 fs/ocfs2/super.c             |  10 +---
 9 files changed, 60 insertions(+), 180 deletions(-)

diff --git a/fs/ocfs2/blockcheck.c b/fs/ocfs2/blockcheck.c
index 429e6a8359a5..eaf042feaf5e 100644
--- a/fs/ocfs2/blockcheck.c
+++ b/fs/ocfs2/blockcheck.c
@@ -231,14 +231,6 @@ static int blockcheck_u64_get(void *data, u64 *val)
 }
 DEFINE_SIMPLE_ATTRIBUTE(blockcheck_fops, blockcheck_u64_get, NULL, "%llu\n");
 
-static struct dentry *blockcheck_debugfs_create(const char *name,
-						struct dentry *parent,
-						u64 *value)
-{
-	return debugfs_create_file(name, S_IFREG | S_IRUSR, parent, value,
-				   &blockcheck_fops);
-}
-
 static void ocfs2_blockcheck_debug_remove(struct ocfs2_blockcheck_stats *stats)
 {
 	if (stats) {
@@ -250,16 +242,20 @@ static void ocfs2_blockcheck_debug_remove(struct ocfs2_blockcheck_stats *stats)
 static void ocfs2_blockcheck_debug_install(struct ocfs2_blockcheck_stats *stats,
 					   struct dentry *parent)
 {
-	stats->b_debug_dir = debugfs_create_dir("blockcheck", parent);
+	struct dentry *dir;
+
+	dir = debugfs_create_dir("blockcheck", parent);
+	stats->b_debug_dir = dir;
+
+	debugfs_create_file("blocks_checked", S_IFREG | S_IRUSR, dir,
+			    &stats->b_check_count, &blockcheck_fops);
 
-	blockcheck_debugfs_create("blocks_checked", stats->b_debug_dir,
-				  &stats->b_check_count);
+	debugfs_create_file("checksums_failed", S_IFREG | S_IRUSR, dir,
+			    &stats->b_failure_count, &blockcheck_fops);
 
-	blockcheck_debugfs_create("checksums_failed", stats->b_debug_dir,
-				  &stats->b_failure_count);
+	debugfs_create_file("ecc_recoveries", S_IFREG | S_IRUSR, dir,
+			    &stats->b_recover_count, &blockcheck_fops);
 
-	blockcheck_debugfs_create("ecc_recoveries", stats->b_debug_dir,
-				  &stats->b_recover_count);
 }
 #else
 static inline void ocfs2_blockcheck_debug_install(struct ocfs2_blockcheck_stats *stats,
diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index f1b613327ac8..a368350d4c27 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -225,10 +225,6 @@ struct o2hb_region {
 	unsigned int		hr_region_num;
 
 	struct dentry		*hr_debug_dir;
-	struct dentry		*hr_debug_livenodes;
-	struct dentry		*hr_debug_regnum;
-	struct dentry		*hr_debug_elapsed_time;
-	struct dentry		*hr_debug_pinned;
 	struct o2hb_debug_buf	*hr_db_livenodes;
 	struct o2hb_debug_buf	*hr_db_regnum;
 	struct o2hb_debug_buf	*hr_db_elapsed_time;
@@ -1394,21 +1390,20 @@ void o2hb_exit(void)
 	kfree(o2hb_db_failedregions);
 }
 
-static struct dentry *o2hb_debug_create(const char *name, struct dentry *dir,
-					struct o2hb_debug_buf **db, int db_len,
-					int type, int size, int len, void *data)
+static void o2hb_debug_create(const char *name, struct dentry *dir,
+			      struct o2hb_debug_buf **db, int db_len, int type,
+			      int size, int len, void *data)
 {
 	*db = kmalloc(db_len, GFP_KERNEL);
 	if (!*db)
-		return NULL;
+		return;
 
 	(*db)->db_type = type;
 	(*db)->db_size = size;
 	(*db)->db_len = len;
 	(*db)->db_data = data;
 
-	return debugfs_create_file(name, S_IFREG|S_IRUSR, dir, *db,
-				   &o2hb_debug_fops);
+	debugfs_create_file(name, S_IFREG|S_IRUSR, dir, *db, &o2hb_debug_fops);
 }
 
 static void o2hb_debug_init(void)
@@ -1525,11 +1520,7 @@ static void o2hb_region_release(struct config_item *item)
 
 	kfree(reg->hr_slots);
 
-	debugfs_remove(reg->hr_debug_livenodes);
-	debugfs_remove(reg->hr_debug_regnum);
-	debugfs_remove(reg->hr_debug_elapsed_time);
-	debugfs_remove(reg->hr_debug_pinned);
-	debugfs_remove(reg->hr_debug_dir);
+	debugfs_remove_recursive(reg->hr_debug_dir);
 	kfree(reg->hr_db_livenodes);
 	kfree(reg->hr_db_regnum);
 	kfree(reg->hr_db_elapsed_time);
@@ -1988,69 +1979,33 @@ static struct o2hb_heartbeat_group *to_o2hb_heartbeat_group(struct config_group
 		: NULL;
 }
 
-static int o2hb_debug_region_init(struct o2hb_region *reg, struct dentry *dir)
+static void o2hb_debug_region_init(struct o2hb_region *reg,
+				   struct dentry *parent)
 {
-	int ret = -ENOMEM;
+	struct dentry *dir;
 
-	reg->hr_debug_dir =
-		debugfs_create_dir(config_item_name(&reg->hr_item), dir);
-	if (!reg->hr_debug_dir) {
-		mlog_errno(ret);
-		goto bail;
-	}
+	dir = debugfs_create_dir(config_item_name(&reg->hr_item), parent);
+	reg->hr_debug_dir = dir;
 
-	reg->hr_debug_livenodes =
-			o2hb_debug_create(O2HB_DEBUG_LIVENODES,
-					  reg->hr_debug_dir,
-					  &(reg->hr_db_livenodes),
-					  sizeof(*(reg->hr_db_livenodes)),
-					  O2HB_DB_TYPE_REGION_LIVENODES,
-					  sizeof(reg->hr_live_node_bitmap),
-					  O2NM_MAX_NODES, reg);
-	if (!reg->hr_debug_livenodes) {
-		mlog_errno(ret);
-		goto bail;
-	}
+	o2hb_debug_create(O2HB_DEBUG_LIVENODES, dir, &(reg->hr_db_livenodes),
+			  sizeof(*(reg->hr_db_livenodes)),
+			  O2HB_DB_TYPE_REGION_LIVENODES,
+			  sizeof(reg->hr_live_node_bitmap), O2NM_MAX_NODES,
+			  reg);
 
-	reg->hr_debug_regnum =
-			o2hb_debug_create(O2HB_DEBUG_REGION_NUMBER,
-					  reg->hr_debug_dir,
-					  &(reg->hr_db_regnum),
-					  sizeof(*(reg->hr_db_regnum)),
-					  O2HB_DB_TYPE_REGION_NUMBER,
-					  0, O2NM_MAX_NODES, reg);
-	if (!reg->hr_debug_regnum) {
-		mlog_errno(ret);
-		goto bail;
-	}
+	o2hb_debug_create(O2HB_DEBUG_REGION_NUMBER, dir, &(reg->hr_db_regnum),
+			  sizeof(*(reg->hr_db_regnum)),
+			  O2HB_DB_TYPE_REGION_NUMBER, 0, O2NM_MAX_NODES, reg);
 
-	reg->hr_debug_elapsed_time =
-			o2hb_debug_create(O2HB_DEBUG_REGION_ELAPSED_TIME,
-					  reg->hr_debug_dir,
-					  &(reg->hr_db_elapsed_time),
-					  sizeof(*(reg->hr_db_elapsed_time)),
-					  O2HB_DB_TYPE_REGION_ELAPSED_TIME,
-					  0, 0, reg);
-	if (!reg->hr_debug_elapsed_time) {
-		mlog_errno(ret);
-		goto bail;
-	}
+	o2hb_debug_create(O2HB_DEBUG_REGION_ELAPSED_TIME, dir,
+			  &(reg->hr_db_elapsed_time),
+			  sizeof(*(reg->hr_db_elapsed_time)),
+			  O2HB_DB_TYPE_REGION_ELAPSED_TIME, 0, 0, reg);
 
-	reg->hr_debug_pinned =
-			o2hb_debug_create(O2HB_DEBUG_REGION_PINNED,
-					  reg->hr_debug_dir,
-					  &(reg->hr_db_pinned),
-					  sizeof(*(reg->hr_db_pinned)),
-					  O2HB_DB_TYPE_REGION_PINNED,
-					  0, 0, reg);
-	if (!reg->hr_debug_pinned) {
-		mlog_errno(ret);
-		goto bail;
-	}
+	o2hb_debug_create(O2HB_DEBUG_REGION_PINNED, dir, &(reg->hr_db_pinned),
+			  sizeof(*(reg->hr_db_pinned)),
+			  O2HB_DB_TYPE_REGION_PINNED, 0, 0, reg);
 
-	ret = 0;
-bail:
-	return ret;
 }
 
 static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *group,
@@ -2106,11 +2061,7 @@ static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *g
 	if (ret)
 		goto unregister_handler;
 
-	ret = o2hb_debug_region_init(reg, o2hb_debug_dir);
-	if (ret) {
-		config_item_put(&reg->hr_item);
-		goto unregister_handler;
-	}
+	o2hb_debug_region_init(reg, o2hb_debug_dir);
 
 	return &reg->hr_item;
 
diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index 69a429b625cc..aaf24548b02a 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -142,7 +142,6 @@ struct dlm_ctxt
 	atomic_t res_tot_count;
 	atomic_t res_cur_count;
 
-	struct dlm_debug_ctxt *dlm_debug_ctxt;
 	struct dentry *dlm_debugfs_subroot;
 
 	/* NOTE: Next three are protected by dlm_domain_lock */
diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index a4b58ba99927..4d0b452012b2 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -853,67 +853,34 @@ static const struct file_operations debug_state_fops = {
 /* files in subroot */
 void dlm_debug_init(struct dlm_ctxt *dlm)
 {
-	struct dlm_debug_ctxt *dc = dlm->dlm_debug_ctxt;
-
 	/* for dumping dlm_ctxt */
-	dc->debug_state_dentry = debugfs_create_file(DLM_DEBUGFS_DLM_STATE,
-						     S_IFREG|S_IRUSR,
-						     dlm->dlm_debugfs_subroot,
-						     dlm, &debug_state_fops);
+	debugfs_create_file(DLM_DEBUGFS_DLM_STATE, S_IFREG|S_IRUSR,
+			    dlm->dlm_debugfs_subroot, dlm, &debug_state_fops);
 
 	/* for dumping lockres */
-	dc->debug_lockres_dentry =
-			debugfs_create_file(DLM_DEBUGFS_LOCKING_STATE,
-					    S_IFREG|S_IRUSR,
-					    dlm->dlm_debugfs_subroot,
-					    dlm, &debug_lockres_fops);
+	debugfs_create_file(DLM_DEBUGFS_LOCKING_STATE, S_IFREG|S_IRUSR,
+			    dlm->dlm_debugfs_subroot, dlm, &debug_lockres_fops);
 
 	/* for dumping mles */
-	dc->debug_mle_dentry = debugfs_create_file(DLM_DEBUGFS_MLE_STATE,
-						   S_IFREG|S_IRUSR,
-						   dlm->dlm_debugfs_subroot,
-						   dlm, &debug_mle_fops);
+	debugfs_create_file(DLM_DEBUGFS_MLE_STATE, S_IFREG|S_IRUSR,
+			    dlm->dlm_debugfs_subroot, dlm, &debug_mle_fops);
 
 	/* for dumping lockres on the purge list */
-	dc->debug_purgelist_dentry =
-			debugfs_create_file(DLM_DEBUGFS_PURGE_LIST,
-					    S_IFREG|S_IRUSR,
-					    dlm->dlm_debugfs_subroot,
-					    dlm, &debug_purgelist_fops);
-}
-
-void dlm_debug_shutdown(struct dlm_ctxt *dlm)
-{
-	struct dlm_debug_ctxt *dc = dlm->dlm_debug_ctxt;
-
-	if (dc) {
-		debugfs_remove(dc->debug_purgelist_dentry);
-		debugfs_remove(dc->debug_mle_dentry);
-		debugfs_remove(dc->debug_lockres_dentry);
-		debugfs_remove(dc->debug_state_dentry);
-		kfree(dc);
-		dc = NULL;
-	}
+	debugfs_create_file(DLM_DEBUGFS_PURGE_LIST, S_IFREG|S_IRUSR,
+			    dlm->dlm_debugfs_subroot, dlm,
+			    &debug_purgelist_fops);
 }
 
 /* subroot - domain dir */
-int dlm_create_debugfs_subroot(struct dlm_ctxt *dlm)
+void dlm_create_debugfs_subroot(struct dlm_ctxt *dlm)
 {
-	dlm->dlm_debug_ctxt = kzalloc(sizeof(struct dlm_debug_ctxt),
-				      GFP_KERNEL);
-	if (!dlm->dlm_debug_ctxt) {
-		mlog_errno(-ENOMEM);
-		return -ENOMEM;
-	}
-
 	dlm->dlm_debugfs_subroot = debugfs_create_dir(dlm->name,
 						      dlm_debugfs_root);
-	return 0;
 }
 
 void dlm_destroy_debugfs_subroot(struct dlm_ctxt *dlm)
 {
-	debugfs_remove(dlm->dlm_debugfs_subroot);
+	debugfs_remove_recursive(dlm->dlm_debugfs_subroot);
 }
 
 /* debugfs root */
diff --git a/fs/ocfs2/dlm/dlmdebug.h b/fs/ocfs2/dlm/dlmdebug.h
index 7d0c7c9013ce..f8fd8680a4b6 100644
--- a/fs/ocfs2/dlm/dlmdebug.h
+++ b/fs/ocfs2/dlm/dlmdebug.h
@@ -14,13 +14,6 @@ void dlm_print_one_mle(struct dlm_master_list_entry *mle);
 
 #ifdef CONFIG_DEBUG_FS
 
-struct dlm_debug_ctxt {
-	struct dentry *debug_state_dentry;
-	struct dentry *debug_lockres_dentry;
-	struct dentry *debug_mle_dentry;
-	struct dentry *debug_purgelist_dentry;
-};
-
 struct debug_lockres {
 	int dl_len;
 	char *dl_buf;
@@ -29,9 +22,8 @@ struct debug_lockres {
 };
 
 void dlm_debug_init(struct dlm_ctxt *dlm);
-void dlm_debug_shutdown(struct dlm_ctxt *dlm);
 
-int dlm_create_debugfs_subroot(struct dlm_ctxt *dlm);
+void dlm_create_debugfs_subroot(struct dlm_ctxt *dlm);
 void dlm_destroy_debugfs_subroot(struct dlm_ctxt *dlm);
 
 void dlm_create_debugfs_root(void);
@@ -42,12 +34,8 @@ void dlm_destroy_debugfs_root(void);
 static inline void dlm_debug_init(struct dlm_ctxt *dlm)
 {
 }
-static inline void dlm_debug_shutdown(struct dlm_ctxt *dlm)
-{
-}
-static inline int dlm_create_debugfs_subroot(struct dlm_ctxt *dlm)
+static inline void dlm_create_debugfs_subroot(struct dlm_ctxt *dlm)
 {
-	return 0;
 }
 static inline void dlm_destroy_debugfs_subroot(struct dlm_ctxt *dlm)
 {
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 7338b5d4647c..5c4218d66dd2 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -387,7 +387,6 @@ static void dlm_destroy_dlm_worker(struct dlm_ctxt *dlm)
 static void dlm_complete_dlm_shutdown(struct dlm_ctxt *dlm)
 {
 	dlm_unregister_domain_handlers(dlm);
-	dlm_debug_shutdown(dlm);
 	dlm_complete_thread(dlm);
 	dlm_complete_recovery_thread(dlm);
 	dlm_destroy_dlm_worker(dlm);
@@ -1938,7 +1937,6 @@ static int dlm_join_domain(struct dlm_ctxt *dlm)
 
 	if (status) {
 		dlm_unregister_domain_handlers(dlm);
-		dlm_debug_shutdown(dlm);
 		dlm_complete_thread(dlm);
 		dlm_complete_recovery_thread(dlm);
 		dlm_destroy_dlm_worker(dlm);
@@ -1992,9 +1990,7 @@ static struct dlm_ctxt *dlm_alloc_ctxt(const char *domain,
 	dlm->key = key;
 	dlm->node_num = o2nm_this_node();
 
-	ret = dlm_create_debugfs_subroot(dlm);
-	if (ret < 0)
-		goto leave;
+	dlm_create_debugfs_subroot(dlm);
 
 	spin_lock_init(&dlm->spinlock);
 	spin_lock_init(&dlm->master_lock);
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 14207234fa3d..ad594fef2ab0 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3012,8 +3012,6 @@ struct ocfs2_dlm_debug *ocfs2_new_dlm_debug(void)
 
 	kref_init(&dlm_debug->d_refcnt);
 	INIT_LIST_HEAD(&dlm_debug->d_lockres_tracking);
-	dlm_debug->d_locking_state = NULL;
-	dlm_debug->d_locking_filter = NULL;
 	dlm_debug->d_filter_secs = 0;
 out:
 	return dlm_debug;
@@ -3282,27 +3280,19 @@ static void ocfs2_dlm_init_debug(struct ocfs2_super *osb)
 {
 	struct ocfs2_dlm_debug *dlm_debug = osb->osb_dlm_debug;
 
-	dlm_debug->d_locking_state = debugfs_create_file("locking_state",
-							 S_IFREG|S_IRUSR,
-							 osb->osb_debug_root,
-							 osb,
-							 &ocfs2_dlm_debug_fops);
+	debugfs_create_file("locking_state", S_IFREG|S_IRUSR,
+			    osb->osb_debug_root, osb, &ocfs2_dlm_debug_fops);
 
-	dlm_debug->d_locking_filter = debugfs_create_u32("locking_filter",
-						0600,
-						osb->osb_debug_root,
-						&dlm_debug->d_filter_secs);
+	debugfs_create_u32("locking_filter", 0600, osb->osb_debug_root,
+			   &dlm_debug->d_filter_secs);
 }
 
 static void ocfs2_dlm_shutdown_debug(struct ocfs2_super *osb)
 {
 	struct ocfs2_dlm_debug *dlm_debug = osb->osb_dlm_debug;
 
-	if (dlm_debug) {
-		debugfs_remove(dlm_debug->d_locking_state);
-		debugfs_remove(dlm_debug->d_locking_filter);
+	if (dlm_debug)
 		ocfs2_put_dlm_debug(dlm_debug);
-	}
 }
 
 int ocfs2_dlm_init(struct ocfs2_super *osb)
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index fddbbd60f434..9150cfa4df7d 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -223,8 +223,6 @@ struct ocfs2_orphan_scan {
 
 struct ocfs2_dlm_debug {
 	struct kref d_refcnt;
-	struct dentry *d_locking_state;
-	struct dentry *d_locking_filter;
 	u32 d_filter_secs;
 	struct list_head d_lockres_tracking;
 };
@@ -401,7 +399,6 @@ struct ocfs2_super
 	struct ocfs2_dlm_debug *osb_dlm_debug;
 
 	struct dentry *osb_debug_root;
-	struct dentry *osb_ctxt;
 
 	wait_queue_head_t recovery_event;
 
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 8b2f39506648..c81e86c62380 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1080,10 +1080,8 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	osb->osb_debug_root = debugfs_create_dir(osb->uuid_str,
 						 ocfs2_debugfs_root);
 
-	osb->osb_ctxt = debugfs_create_file("fs_state", S_IFREG|S_IRUSR,
-					    osb->osb_debug_root,
-					    osb,
-					    &ocfs2_osb_debug_fops);
+	debugfs_create_file("fs_state", S_IFREG|S_IRUSR, osb->osb_debug_root,
+			    osb, &ocfs2_osb_debug_fops);
 
 	if (ocfs2_meta_ecc(osb))
 		ocfs2_blockcheck_stats_debugfs_install( &osb->osb_ecc_stats,
@@ -1861,8 +1859,6 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 
 	kset_unregister(osb->osb_dev_kset);
 
-	debugfs_remove(osb->osb_ctxt);
-
 	/* Orphan scan should be stopped as early as possible */
 	ocfs2_orphan_scan_stop(osb);
 
@@ -1918,7 +1914,7 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 		ocfs2_dlm_shutdown(osb, hangup_needed);
 
 	ocfs2_blockcheck_stats_debugfs_remove(&osb->osb_ecc_stats);
-	debugfs_remove(osb->osb_debug_root);
+	debugfs_remove_recursive(osb->osb_debug_root);
 
 	if (hangup_needed)
 		ocfs2_cluster_hangup(osb->uuid_str, strlen(osb->uuid_str));
-- 
2.22.0
