From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 29 Jan 2010 22:24:14 +0800
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2:freeze-thaw: add freeze cluster
	lock -v2
Message-ID: <201001291425.o0TDjiAJ009373@rcsinet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch adds cluster lock for freeze/thaw. It changes fs version from 1.0 to
1.1

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/dlmglue.c          |   33 +++++++++++++++++++++++++++++++++
 fs/ocfs2/dlmglue.h          |    3 ++-
 fs/ocfs2/ocfs2.h            |    1 +
 fs/ocfs2/ocfs2_lockid.h     |    5 +++++
 fs/ocfs2/ocfs2_lockingver.h |    2 +-
 5 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index c5e4a49..cddaa62 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2894,6 +2894,35 @@ static const struct file_operations ocfs2_dlm_debug_fops = {
 	.llseek =	seq_lseek,
 };
 
+/* A timeout version of cluster lock for freeze. ms(in millisecond) is the max
+ * time to wait. 0 means wait for ever.
+ * WARN: Till now we don't support timeout in cluster lock. So ms has no meaning
+ * so far. Change me when timeout is supported.
+ */
+int ocfs2_freeze_lock_timeout(struct ocfs2_super *osb, int ex, int ms)
+{
+	int ret;
+	int level = ex ? LKM_EXMODE : LKM_PRMODE;
+	struct ocfs2_lock_res *lockres = &osb->osb_freeze_lockres;
+
+	if (ocfs2_is_hard_readonly(osb))
+		return -EROFS;
+	if (ocfs2_mount_local(osb))
+		return 0;
+
+	ret = ocfs2_cluster_lock(osb, lockres, level, 0, 0);
+	return ret;
+}
+
+void ocfs2_freeze_unlock(struct ocfs2_super *osb, int ex)
+{
+	int level = ex ? LKM_EXMODE : LKM_PRMODE;
+	struct ocfs2_lock_res *lockres = &osb->osb_freeze_lockres;
+
+	if (!ocfs2_mount_local(osb))
+		ocfs2_cluster_unlock(osb, lockres, level);
+}
+
 static int ocfs2_dlm_init_debug(struct ocfs2_super *osb)
 {
 	int ret = 0;
@@ -3865,6 +3894,10 @@ void ocfs2_refcount_unlock(struct ocfs2_refcount_tree *ref_tree, int ex)
  * change adds a fully backwards compatible change (eg, LVB changes that
  * are just ignored by older versions), the version does not need to be
  * updated.
+ *
+ * history:
+ * 1.0	base.
+ * 1.1	freeze lock added for freeze/thaw cluster.
  */
 static struct ocfs2_locking_protocol lproto = {
 	.lp_max_version = {
diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
index d1ce48e..ac06e3a 100644
--- a/fs/ocfs2/dlmglue.h
+++ b/fs/ocfs2/dlmglue.h
@@ -154,7 +154,8 @@ void ocfs2_qinfo_unlock(struct ocfs2_mem_dqinfo *oinfo, int ex);
 struct ocfs2_refcount_tree;
 int ocfs2_refcount_lock(struct ocfs2_refcount_tree *ref_tree, int ex);
 void ocfs2_refcount_unlock(struct ocfs2_refcount_tree *ref_tree, int ex);
-
+int ocfs2_freeze_lock_timeout(struct ocfs2_super *osb, int ex, int ms);
+void ocfs2_freeze_unlock(struct ocfs2_super *osb, int ex);
 
 void ocfs2_mark_lockres_freeing(struct ocfs2_lock_res *lockres);
 void ocfs2_simple_drop_lockres(struct ocfs2_super *osb,
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index d963d86..bf66978 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -355,6 +355,7 @@ struct ocfs2_super
 	struct ocfs2_lock_res osb_super_lockres;
 	struct ocfs2_lock_res osb_rename_lockres;
 	struct ocfs2_lock_res osb_nfs_sync_lockres;
+	struct ocfs2_lock_res osb_freeze_lockres;
 	struct ocfs2_dlm_debug *osb_dlm_debug;
 
 	struct dentry *osb_debug_root;
diff --git a/fs/ocfs2/ocfs2_lockid.h b/fs/ocfs2/ocfs2_lockid.h
index d277aab..3aa926e 100644
--- a/fs/ocfs2/ocfs2_lockid.h
+++ b/fs/ocfs2/ocfs2_lockid.h
@@ -50,6 +50,7 @@ enum ocfs2_lock_type {
 	OCFS2_LOCK_TYPE_NFS_SYNC,
 	OCFS2_LOCK_TYPE_ORPHAN_SCAN,
 	OCFS2_LOCK_TYPE_REFCOUNT,
+	OCFS2_LOCK_TYPE_FREEZEFS,
 	OCFS2_NUM_LOCK_TYPES
 };
 
@@ -93,6 +94,9 @@ static inline char ocfs2_lock_type_char(enum ocfs2_lock_type type)
 		case OCFS2_LOCK_TYPE_REFCOUNT:
 			c = 'T';
 			break;
+		case OCFS2_LOCK_TYPE_FREEZEFS:
+			c = 'Z';
+			break;
 		default:
 			c = '\0';
 	}
@@ -115,6 +119,7 @@ static char *ocfs2_lock_type_strings[] = {
 	[OCFS2_LOCK_TYPE_NFS_SYNC] = "NFSSync",
 	[OCFS2_LOCK_TYPE_ORPHAN_SCAN] = "OrphanScan",
 	[OCFS2_LOCK_TYPE_REFCOUNT] = "Refcount",
+	[OCFS2_LOCK_TYPE_FREEZEFS] = "Freeze",
 };
 
 static inline const char *ocfs2_lock_type_string(enum ocfs2_lock_type type)
diff --git a/fs/ocfs2/ocfs2_lockingver.h b/fs/ocfs2/ocfs2_lockingver.h
index 82d5eea..6d640cb 100644
--- a/fs/ocfs2/ocfs2_lockingver.h
+++ b/fs/ocfs2/ocfs2_lockingver.h
@@ -25,6 +25,6 @@
  * more details.
  */
 #define OCFS2_LOCKING_PROTOCOL_MAJOR 1
-#define OCFS2_LOCKING_PROTOCOL_MINOR 0
+#define OCFS2_LOCKING_PROTOCOL_MINOR 1
 
 #endif  /* OCFS2_LOCKINGVER_H */
-- 
1.6.6
