From: Chengyu Song <csong84@gatech.edu>
Date: Tue, 24 Mar 2015 01:28:03 -0400
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: incorrect check for debugfs returns
Message-ID: <1427174883-12513-1-git-send-email-csong84@gatech.edu>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@suse.com, jlbec@evilplan.org, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Cc: taesoo@gatech.edu, changwoo@gatech.edu, sanidhya@gatech.edu, blee@gatech.edu, csong84@gatech.edu

debugfs_create_dir and debugfs_create_file may return -ENODEV when debugfs
is not configured, so the return value should be checked against ERROR_VALUE
as well, otherwise the later dereference of the dentry pointer would crash
the kernel.

This patch tries to solve this problem by fixing certain checks. However,
I have that found other call sites are protected by #ifdef CONFIG_DEBUG_FS.
In current implementation, if CONFIG_DEBUG_FS is defined, then the above
two functions will never return any ERROR_VALUE. So another possibility
to fix this is to surround all the buggy checks/functions with the same
#ifdef CONFIG_DEBUG_FS. But I'm not sure if this would break any functionality,
as only OCFS2_FS_STATS declares dependency on DEBUG_FS.

Signed-off-by: Chengyu Song <csong84@gatech.edu>
---
 fs/ocfs2/cluster/heartbeat.c | 42 +++++++++++++++++++++++++++++++-----------
 fs/ocfs2/dlmglue.c           |  2 +-
 fs/ocfs2/super.c             |  9 +++++----
 3 files changed, 37 insertions(+), 16 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 16eff45..8e19b9d 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1312,7 +1312,9 @@ static int o2hb_debug_init(void)
 	int ret = -ENOMEM;
 
 	o2hb_debug_dir = debugfs_create_dir(O2HB_DEBUG_DIR, NULL);
-	if (!o2hb_debug_dir) {
+	if (IS_ERR_OR_NULL(o2hb_debug_dir)) {
+		ret = o2hb_debug_dir ?
+			PTR_ERR(o2hb_debug_dir) : -ENOMEM;
 		mlog_errno(ret);
 		goto bail;
 	}
@@ -1325,7 +1327,9 @@ static int o2hb_debug_init(void)
 						 sizeof(o2hb_live_node_bitmap),
 						 O2NM_MAX_NODES,
 						 o2hb_live_node_bitmap);
-	if (!o2hb_debug_livenodes) {
+	if (IS_ERR_OR_NULL(o2hb_debug_livenodes)) {
+		ret = o2hb_debug_livenodes ?
+			PTR_ERR(o2hb_debug_livenodes) : -ENOMEM;
 		mlog_errno(ret);
 		goto bail;
 	}
@@ -1338,7 +1342,9 @@ static int o2hb_debug_init(void)
 						   sizeof(o2hb_live_region_bitmap),
 						   O2NM_MAX_REGIONS,
 						   o2hb_live_region_bitmap);
-	if (!o2hb_debug_liveregions) {
+	if (IS_ERR_OR_NULL(o2hb_debug_liveregions)) {
+		ret = o2hb_debug_liveregions ?
+			PTR_ERR(o2hb_debug_liveregions) : -ENOMEM;
 		mlog_errno(ret);
 		goto bail;
 	}
@@ -1352,7 +1358,9 @@ static int o2hb_debug_init(void)
 					  sizeof(o2hb_quorum_region_bitmap),
 					  O2NM_MAX_REGIONS,
 					  o2hb_quorum_region_bitmap);
-	if (!o2hb_debug_quorumregions) {
+	if (IS_ERR_OR_NULL(o2hb_debug_quorumregions)) {
+		ret = o2hb_debug_quorumregions ?
+			PTR_ERR(o2hb_debug_quorumregions) : -ENOMEM;
 		mlog_errno(ret);
 		goto bail;
 	}
@@ -1366,7 +1374,9 @@ static int o2hb_debug_init(void)
 					  sizeof(o2hb_failed_region_bitmap),
 					  O2NM_MAX_REGIONS,
 					  o2hb_failed_region_bitmap);
-	if (!o2hb_debug_failedregions) {
+	if (IS_ERR_OR_NULL(o2hb_debug_failedregions)) {
+		ret = o2hb_debug_failedregions ?
+			PTR_ERR(o2hb_debug_failedregions) : -ENOMEM;
 		mlog_errno(ret);
 		goto bail;
 	}
@@ -2000,7 +2010,8 @@ static int o2hb_debug_region_init(struct o2hb_region *reg, struct dentry *dir)
 
 	reg->hr_debug_dir =
 		debugfs_create_dir(config_item_name(&reg->hr_item), dir);
-	if (!reg->hr_debug_dir) {
+	if (IS_ERR_OR_NULL(reg->hr_debug_dir)) {
+		ret = reg->hr_debug_dir ? PTR_ERR(reg->hr_debug_dir) : -ENOMEM;
 		mlog_errno(ret);
 		goto bail;
 	}
@@ -2013,7 +2024,9 @@ static int o2hb_debug_region_init(struct o2hb_region *reg, struct dentry *dir)
 					  O2HB_DB_TYPE_REGION_LIVENODES,
 					  sizeof(reg->hr_live_node_bitmap),
 					  O2NM_MAX_NODES, reg);
-	if (!reg->hr_debug_livenodes) {
+	if (IS_ERR_OR_NULL(reg->hr_debug_livenodes)) {
+		ret = reg->hr_debug_livenodes ?
+			PTR_ERR(reg->hr_debug_livenodes) : -ENOMEM;
 		mlog_errno(ret);
 		goto bail;
 	}
@@ -2025,7 +2038,9 @@ static int o2hb_debug_region_init(struct o2hb_region *reg, struct dentry *dir)
 					  sizeof(*(reg->hr_db_regnum)),
 					  O2HB_DB_TYPE_REGION_NUMBER,
 					  0, O2NM_MAX_NODES, reg);
-	if (!reg->hr_debug_regnum) {
+	if (IS_ERR_OR_NULL(reg->hr_debug_regnum)) {
+		ret = reg->hr_debug_regnum ?
+			PTR_ERR(reg->hr_debug_regnum) : -ENOMEM;
 		mlog_errno(ret);
 		goto bail;
 	}
@@ -2037,7 +2052,9 @@ static int o2hb_debug_region_init(struct o2hb_region *reg, struct dentry *dir)
 					  sizeof(*(reg->hr_db_elapsed_time)),
 					  O2HB_DB_TYPE_REGION_ELAPSED_TIME,
 					  0, 0, reg);
-	if (!reg->hr_debug_elapsed_time) {
+	if (IS_ERR_OR_NULL(reg->hr_debug_elapsed_time)) {
+		ret = reg->hr_debug_elapsed_time ?
+			PTR_ERR(reg->hr_debug_elapsed_time) : -ENOMEM;
 		mlog_errno(ret);
 		goto bail;
 	}
@@ -2049,13 +2066,16 @@ static int o2hb_debug_region_init(struct o2hb_region *reg, struct dentry *dir)
 					  sizeof(*(reg->hr_db_pinned)),
 					  O2HB_DB_TYPE_REGION_PINNED,
 					  0, 0, reg);
-	if (!reg->hr_debug_pinned) {
+	if (IS_ERR_OR_NULL(reg->hr_debug_pinned)) {
+		ret = reg->hr_debug_pinned ?
+			PTR_ERR(reg->hr_debug_pinned) : -ENOMEM;
 		mlog_errno(ret);
 		goto bail;
 	}
 
-	ret = 0;
+	return 0;
 bail:
+	debugfs_remove_recursive(reg->hr_debug_dir);
 	return ret;
 }
 
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 11849a4..23adcbf 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2954,7 +2954,7 @@ static int ocfs2_dlm_init_debug(struct ocfs2_super *osb)
 							 osb->osb_debug_root,
 							 osb,
 							 &ocfs2_dlm_debug_fops);
-	if (!dlm_debug->d_locking_state) {
+	if (IS_ERR_OR_NULL(dlm_debug->d_locking_state)) {
 		ret = -EINVAL;
 		mlog(ML_ERROR,
 		     "Unable to create locking state debugfs file.\n");
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 2667518..fb43de5 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1112,7 +1112,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
 	osb->osb_debug_root = debugfs_create_dir(osb->uuid_str,
 						 ocfs2_debugfs_root);
-	if (!osb->osb_debug_root) {
+	if (IS_ERR_OR_NULL(osb->osb_debug_root)) {
 		status = -EINVAL;
 		mlog(ML_ERROR, "Unable to create per-mount debugfs root.\n");
 		goto read_super_error;
@@ -1122,7 +1122,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 					    osb->osb_debug_root,
 					    osb,
 					    &ocfs2_osb_debug_fops);
-	if (!osb->osb_ctxt) {
+	if (IS_ERR_OR_NULL(osb->osb_ctxt)) {
 		status = -EINVAL;
 		mlog_errno(status);
 		goto read_super_error;
@@ -1606,8 +1606,9 @@ static int __init ocfs2_init(void)
 	}
 
 	ocfs2_debugfs_root = debugfs_create_dir("ocfs2", NULL);
-	if (!ocfs2_debugfs_root) {
-		status = -ENOMEM;
+	if (IS_ERR_OR_NULL(ocfs2_debugfs_root)) {
+		status = ocfs2_debugfs_root ?
+			PTR_ERR(ocfs2_debugfs_root) : -ENOMEM;
 		mlog(ML_ERROR, "Unable to create ocfs2 debugfs root.\n");
 		goto out4;
 	}
-- 
2.1.0
