From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu,  4 Mar 2010 19:58:56 +0800
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2:freeze-thaw: freeze lock init and
	cleanup -v3
Message-ID: <201003041200.o24C0VvU027580@rcsinet13.oracle.com>
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
index 7876328..d673949 100644
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
@@ -722,6 +729,15 @@ void ocfs2_refcount_lock_res_init(struct ocfs2_lock_res *lockres,
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
@@ -3034,6 +3050,7 @@ local:
 	ocfs2_rename_lock_res_init(&osb->osb_rename_lockres, osb);
 	ocfs2_nfs_sync_lock_res_init(&osb->osb_nfs_sync_lockres, osb);
 	ocfs2_orphan_scan_lock_res_init(&osb->osb_orphan_scan.os_lockres, osb);
+	ocfs2_freeze_lock_res_init(&osb->osb_freeze_lockres, osb);
 
 	osb->cconn = conn;
 
@@ -3071,6 +3088,7 @@ void ocfs2_dlm_shutdown(struct ocfs2_super *osb,
 	ocfs2_lock_res_free(&osb->osb_rename_lockres);
 	ocfs2_lock_res_free(&osb->osb_nfs_sync_lockres);
 	ocfs2_lock_res_free(&osb->osb_orphan_scan.os_lockres);
+	ocfs2_lock_res_free(&osb->osb_freeze_lockres);
 
 	ocfs2_cluster_disconnect(osb->cconn, hangup_pending);
 	osb->cconn = NULL;
@@ -3256,6 +3274,7 @@ static void ocfs2_drop_osb_locks(struct ocfs2_super *osb)
 	ocfs2_simple_drop_lockres(osb, &osb->osb_rename_lockres);
 	ocfs2_simple_drop_lockres(osb, &osb->osb_nfs_sync_lockres);
 	ocfs2_simple_drop_lockres(osb, &osb->osb_orphan_scan.os_lockres);
+	ocfs2_simple_drop_lockres(osb, &osb->osb_freeze_lockres);
 }
 
 int ocfs2_drop_inode_locks(struct inode *inode)
@@ -3934,6 +3953,12 @@ void ocfs2_refcount_unlock(struct ocfs2_refcount_tree *ref_tree, int ex)
 		ocfs2_cluster_unlock(osb, lockres, level);
 }
 
+static int ocfs2_check_freeze_downconvert(struct ocfs2_lock_res *lockres,
+					  int new_level)
+{
+	return 1; /* change me */
+}
+
 /*
  * This is the filesystem locking protocol.  It provides the lock handling
  * hooks for the underlying DLM.  It has a maximum version number.
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 755cd49..7bdd87e 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -136,6 +136,7 @@ static void ocfs2_destroy_inode(struct inode *inode);
 static int ocfs2_susp_quotas(struct ocfs2_super *osb, int unsuspend);
 static int ocfs2_enable_quotas(struct ocfs2_super *osb);
 static void ocfs2_disable_quotas(struct ocfs2_super *osb);
+static int ocfs2_freeze_lock_supported(struct ocfs2_super *osb);
 
 static const struct super_operations ocfs2_sops = {
 	.statfs		= ocfs2_statfs,
@@ -1773,6 +1774,17 @@ static int ocfs2_get_sector(struct super_block *sb,
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
@@ -1790,6 +1802,19 @@ static int ocfs2_mount_volume(struct super_block *sb)
 		goto leave;
 	}
 
+	if (ocfs2_freeze_lock_supported(osb)) {
+		/* we fail the mount if freeze lock timeout. the timeout can be
+		 * a normal case that the cluster is frozen when this node attempts
+		 * to join.
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
