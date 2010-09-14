From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 14 Sep 2010 15:50:38 -0700
Subject: [Ocfs2-devel] [PATCH 02/20] ocfs2: Add an incompat feature flag
	OCFS2_FEATURE_INCOMPAT_CLUSTERINFO
In-Reply-To: <1284504656-2434-1-git-send-email-sunil.mushran@oracle.com>
References: <1284504656-2434-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1284504656-2434-3-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

OCFS2_FEATURE_INCOMPAT_CLUSTERINFO allows us to use sb->s_cluster_info for
both userspace and o2cb cluster stacks. It also allows us to extend cluster
info to include stack flags.

This patch also adds stackflags to sb->s_clusterinfo. It also introduces a
clusterinfo flag OCFS2_CLUSTER_O2CB_GLOBAL_HEARTBEAT to denote the enabled
global heartbeat mode.

This incompat flag can be set/cleared using tunefs.ocfs2 --fs-features. The
clusterinfo flag is set/cleared using tunefs.ocfs2 --update-cluster-stack.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/ocfs2.h    |   31 +++++++++++++++++++++++++++++--
 fs/ocfs2/ocfs2_fs.h |   40 ++++++++++++++++++++++++++++++++++------
 fs/ocfs2/super.c    |    4 +++-
 3 files changed, 66 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index c67003b..d5496a7 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -368,6 +368,8 @@ struct ocfs2_super
 	struct ocfs2_alloc_stats alloc_stats;
 	char dev_str[20];		/* "major,minor" of the device */
 
+	u8 osb_stackflags;
+
 	char osb_cluster_stack[OCFS2_STACK_LABEL_LEN + 1];
 	struct ocfs2_cluster_connection *cconn;
 	struct ocfs2_lock_res osb_super_lockres;
@@ -601,10 +603,35 @@ static inline int ocfs2_is_soft_readonly(struct ocfs2_super *osb)
 	return ret;
 }
 
-static inline int ocfs2_userspace_stack(struct ocfs2_super *osb)
+static inline int ocfs2_clusterinfo_valid(struct ocfs2_super *osb)
 {
 	return (osb->s_feature_incompat &
-		OCFS2_FEATURE_INCOMPAT_USERSPACE_STACK);
+		(OCFS2_FEATURE_INCOMPAT_USERSPACE_STACK |
+		 OCFS2_FEATURE_INCOMPAT_CLUSTERINFO));
+}
+
+static inline int ocfs2_userspace_stack(struct ocfs2_super *osb)
+{
+	if (ocfs2_clusterinfo_valid(osb) &&
+	    memcmp(osb->osb_cluster_stack, OCFS2_CLASSIC_CLUSTER_STACK,
+		   OCFS2_STACK_LABEL_LEN))
+		return 1;
+	return 0;
+}
+
+static inline int ocfs2_o2cb_stack(struct ocfs2_super *osb)
+{
+	if (ocfs2_clusterinfo_valid(osb) &&
+	    !memcmp(osb->osb_cluster_stack, OCFS2_CLASSIC_CLUSTER_STACK,
+		   OCFS2_STACK_LABEL_LEN))
+		return 1;
+	return 0;
+}
+
+static inline int ocfs2_cluster_o2cb_global_heartbeat(struct ocfs2_super *osb)
+{
+	return ocfs2_o2cb_stack(osb) &&
+		(osb->osb_stackflags & OCFS2_CLUSTER_O2CB_GLOBAL_HEARTBEAT);
 }
 
 static inline int ocfs2_mount_local(struct ocfs2_super *osb)
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 33f1c9a..abe048e 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -101,7 +101,8 @@
 					 | OCFS2_FEATURE_INCOMPAT_META_ECC \
 					 | OCFS2_FEATURE_INCOMPAT_INDEXED_DIRS \
 					 | OCFS2_FEATURE_INCOMPAT_REFCOUNT_TREE \
-					 | OCFS2_FEATURE_INCOMPAT_DISCONTIG_BG)
+					 | OCFS2_FEATURE_INCOMPAT_DISCONTIG_BG	\
+					 | OCFS2_FEATURE_INCOMPAT_CLUSTERINFO)
 #define OCFS2_FEATURE_RO_COMPAT_SUPP	(OCFS2_FEATURE_RO_COMPAT_UNWRITTEN \
 					 | OCFS2_FEATURE_RO_COMPAT_USRQUOTA \
 					 | OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)
@@ -170,6 +171,13 @@
 #define OCFS2_FEATURE_INCOMPAT_DISCONTIG_BG	0x2000
 
 /*
+ * Incompat bit to indicate useable clusterinfo with stackflags for all
+ * cluster stacks (userspace adnd o2cb). If this bit is set,
+ * INCOMPAT_USERSPACE_STACK becomes superfluous and thus should not be set.
+ */
+#define OCFS2_FEATURE_INCOMPAT_CLUSTERINFO	0x4000
+
+/*
  * backup superblock flag is used to indicate that this volume
  * has backup superblocks.
  */
@@ -279,10 +287,13 @@
 #define OCFS2_VOL_UUID_LEN		16
 #define OCFS2_MAX_VOL_LABEL_LEN		64
 
-/* The alternate, userspace stack fields */
+/* The cluster stack fields */
 #define OCFS2_STACK_LABEL_LEN		4
 #define OCFS2_CLUSTER_NAME_LEN		16
 
+/* Classic (historically speaking) cluster stack */
+#define OCFS2_CLASSIC_CLUSTER_STACK	"o2cb"
+
 /* Journal limits (in bytes) */
 #define OCFS2_MIN_JOURNAL_SIZE		(4 * 1024 * 1024)
 
@@ -292,6 +303,11 @@
  */
 #define OCFS2_MIN_XATTR_INLINE_SIZE     256
 
+/*
+ * Cluster info flags (ocfs2_cluster_info.ci_stackflags)
+ */
+#define OCFS2_CLUSTER_O2CB_GLOBAL_HEARTBEAT	(0x01)
+
 struct ocfs2_system_inode_info {
 	char	*si_name;
 	int	si_iflags;
@@ -553,9 +569,21 @@ struct ocfs2_slot_map_extended {
  */
 };
 
+/*
+ * ci_stackflags is only valid if the incompat bit
+ * OCFS2_FEATURE_INCOMPAT_CLUSTERINFO is set.
+ */
 struct ocfs2_cluster_info {
 /*00*/	__u8   ci_stack[OCFS2_STACK_LABEL_LEN];
-	__le32 ci_reserved;
+	union {
+		__le32 ci_reserved;
+		struct {
+			__u8 ci_reserved1;
+			__u8 ci_reserved2;
+			__u8 ci_reserved3;
+			__u8 ci_stackflags;
+		};
+	};
 /*08*/	__u8   ci_cluster[OCFS2_CLUSTER_NAME_LEN];
 /*18*/
 };
@@ -592,9 +620,9 @@ struct ocfs2_super_block {
 					 * group header */
 /*50*/	__u8  s_label[OCFS2_MAX_VOL_LABEL_LEN];	/* Label for mounting, etc. */
 /*90*/	__u8  s_uuid[OCFS2_VOL_UUID_LEN];	/* 128-bit uuid */
-/*A0*/  struct ocfs2_cluster_info s_cluster_info; /* Selected userspace
-						     stack.  Only valid
-						     with INCOMPAT flag. */
+/*A0*/  struct ocfs2_cluster_info s_cluster_info; /* Only valid if either
+						     userspace or clusterinfo
+						     INCOMPAT flag set. */
 /*B8*/	__le16 s_xattr_inline_size;	/* extended attribute inline size
 					   for this fs*/
 	__le16 s_reserved0;
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index fa1be1b..7554317 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2149,7 +2149,9 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		goto bail;
 	}
 
-	if (ocfs2_userspace_stack(osb)) {
+	if (ocfs2_clusterinfo_valid(osb)) {
+		osb->osb_stackflags =
+			OCFS2_RAW_SB(di)->s_cluster_info.ci_stackflags;
 		memcpy(osb->osb_cluster_stack,
 		       OCFS2_RAW_SB(di)->s_cluster_info.ci_stack,
 		       OCFS2_STACK_LABEL_LEN);
-- 
1.7.0.4
