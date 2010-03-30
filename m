From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Tue, 30 Mar 2010 12:29:19 +0800
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2:freeze-thaw: freeze lock init and
	cleanup -v4
Message-ID: <201003300430.o2TLm6Im022722@acsinet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch does initialization and cleanup for freeze/thaw.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/dlmglue.c |   25 +++++++++++++++++++++++++
 fs/ocfs2/super.c   |   25 +++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 16bb540..d7a9330 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -115,6 +115,8 @@ static int ocfs2_check_refcount_downconvert(struct ocfs2_lock_res *lockres,
 					    int new_level);
 static int ocfs2_refcount_convert_worker(struct ocfs2_lock_res *lockres,
 					 int blocking);
+static int ocfs2_check_freeze_downconvert(struct ocfs2_lock_res *lockres,
+					  int new_level);
 
 #define mlog_meta_lvb(__level, __lockres) ocfs2_dump_meta_lvb_info(__level, __PRETTY_FUNCTION__, __LINE__, __lockres)
 
@@ -290,6 +292,11 @@ static struct ocfs2_lock_res_ops ocfs2_refcount_block_lops = {
 	.flags		= 0,
 };
 
+static struct ocfs2_lock_res_ops ocfs2_freeze_lops = {
+	.check_downconvert = ocfs2_check_freeze_downconvert,
+	.flags		= 0,
+};
+
 static inline int ocfs2_is_inode_lock(struct ocfs2_lock_res *lockres)
 {
 	return lockres->l_type == OCFS2_LOCK_TYPE_META ||
@@ -727,6 +734,15 @@ void ocfs2_refcount_lock_res_init(struct ocfs2_lock_res *lockres,
 				   &ocfs2_refcount_block_lops, osb);
 }
 
+static void ocfs2_freeze_lock_res_init(struct ocfs2_lock_res *res,
+				       struct ocfs2_super *osb)
+{
+	ocfs2_lock_res_init_once(res);
+	ocfs2_build_lock_name(OCFS2_LOCK_TYPE_FREEZEFS, 0, 0, res->l_name);
+	ocfs2_lock_res_init_common(osb, res, OCFS2_LOCK_TYPE_FREEZEFS,
+				   &ocfs2_freeze_lops, osb);
+}
+
 void ocfs2_lock_res_free(struct ocfs2_lock_res *res)
 {
 	mlog_entry_void();
@@ -3129,6 +3145,7 @@ local:
 	ocfs2_rename_lock_res_init(&osb->osb_rename_lockres, osb);
 	ocfs2_nfs_sync_lock_res_init(&osb->osb_nfs_sync_lockres, osb);
 	ocfs2_orphan_scan_lock_res_init(&osb->osb_orphan_scan.os_lockres, osb);
+	ocfs2_freeze_lock_res_init(&osb->osb_freeze_lockres, osb);
 
 	osb->cconn = conn;
 
@@ -3166,6 +3183,7 @@ void ocfs2_dlm_shutdown(struct ocfs2_super *osb,
 	ocfs2_lock_res_free(&osb->osb_rename_lockres);
 	ocfs2_lock_res_free(&osb->osb_nfs_sync_lockres);
 	ocfs2_lock_res_free(&osb->osb_orphan_scan.os_lockres);
+	ocfs2_lock_res_free(&osb->osb_freeze_lockres);
 
 	ocfs2_cluster_disconnect(osb->cconn, hangup_pending);
 	osb->cconn = NULL;
@@ -3306,6 +3324,7 @@ static void ocfs2_drop_osb_locks(struct ocfs2_super *osb)
 	ocfs2_simple_drop_lockres(osb, &osb->osb_rename_lockres);
 	ocfs2_simple_drop_lockres(osb, &osb->osb_nfs_sync_lockres);
 	ocfs2_simple_drop_lockres(osb, &osb->osb_orphan_scan.os_lockres);
+	ocfs2_simple_drop_lockres(osb, &osb->osb_freeze_lockres);
 }
 
 int ocfs2_drop_inode_locks(struct inode *inode)
@@ -3742,6 +3761,12 @@ static void ocfs2_dentry_post_unlock(struct ocfs2_super *osb,
 	ocfs2_dentry_lock_put(osb, dl);
 }
 
+static int ocfs2_check_freeze_downconvert(struct ocfs2_lock_res *lockres,
+					  int new_level)
+{
+	return 1; /* change me */
+}
+
 /*
  * d_delete() matching dentries before the lock downconvert.
  *
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index dee0319..9464080 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -137,6 +137,7 @@ static void ocfs2_destroy_inode(struct inode *inode);
 static int ocfs2_susp_quotas(struct ocfs2_super *osb, int unsuspend);
 static int ocfs2_enable_quotas(struct ocfs2_super *osb);
 static void ocfs2_disable_quotas(struct ocfs2_super *osb);
+static int ocfs2_freeze_lock_supported(struct ocfs2_super *osb);
 
 static const struct super_operations ocfs2_sops = {
 	.statfs		= ocfs2_statfs,
@@ -1777,6 +1778,17 @@ static int ocfs2_get_sector(struct super_block *sb,
 	return 0;
 }
 
+static int ocfs2_freeze_lock_supported(struct ocfs2_super *osb)
+{
+	if (!osb->cconn)
+		return 0;
+	if (osb->cconn->cc_version.pv_major == 1)
+		return (osb->cconn->cc_version.pv_minor >= 1);
+	if (osb->cconn->cc_version.pv_major > 1)
+		return 1;
+	return 0;
+}
+
 static int ocfs2_mount_volume(struct super_block *sb)
 {
 	int status = 0;
@@ -1794,6 +1806,19 @@ static int ocfs2_mount_volume(struct super_block *sb)
 		goto leave;
 	}
 
+	if (ocfs2_freeze_lock_supported(osb)) {
+		/* we fail the mount if freeze lock timeout. the timeout can be
+		 * a normal case that the cluster is frozen when this node
+		 * attempts to join.
+		 */
+		status = ocfs2_freeze_lock(osb, 0);
+		if (status < 0) {
+			mlog_errno(status);
+			goto leave;
+		}
+		ocfs2_freeze_unlock(osb, 0);
+	}
+
 	status = ocfs2_super_lock(osb, 1);
 	if (status < 0) {
 		mlog_errno(status);
-- 
1.6.6.1
