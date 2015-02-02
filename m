From: Joseph Qi <joseph.qi@huawei.com>
Date: Mon, 2 Feb 2015 10:57:43 +0800
Subject: [Ocfs2-devel] [PATCH 1/3] mkfs.ocfs2: support append direct io ro
	compat feature
Message-ID: <54CEE7A7.8020204@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Turn on append direct io ro compat feature when fromatting a new volume
by default.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 include/ocfs2-kernel/ocfs2_fs.h | 14 ++++++++++++--
 include/ocfs2/ocfs2.h           |  7 +++++++
 libocfs2/feature_string.c       | 27 +++++++++++++++++++++------
 3 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/include/ocfs2-kernel/ocfs2_fs.h b/include/ocfs2-kernel/ocfs2_fs.h
index 79e4f2f..b80f046 100644
--- a/include/ocfs2-kernel/ocfs2_fs.h
+++ b/include/ocfs2-kernel/ocfs2_fs.h
@@ -105,7 +105,8 @@
 					 | OCFS2_FEATURE_INCOMPAT_CLUSTERINFO)
 #define OCFS2_FEATURE_RO_COMPAT_SUPP	(OCFS2_FEATURE_RO_COMPAT_UNWRITTEN \
 					 | OCFS2_FEATURE_RO_COMPAT_USRQUOTA \
-					 | OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)
+					 | OCFS2_FEATURE_RO_COMPAT_GRPQUOTA \
+					 | OCFS2_FEATURE_RO_COMPAT_APPEND_DIO)

 /*
  * Heartbeat-only devices are missing journals and other files.  The
@@ -199,6 +200,11 @@
 #define OCFS2_FEATURE_RO_COMPAT_USRQUOTA	0x0002
 #define OCFS2_FEATURE_RO_COMPAT_GRPQUOTA	0x0004

+/*
+ * Append Direct IO support
+ */
+#define OCFS2_FEATURE_RO_COMPAT_APPEND_DIO	0x0008
+
 /* The byte offset of the first backup block will be 1G.
  * The following will be 4G, 16G, 64G, 256G and 1T.
  */
@@ -232,6 +238,8 @@
 #define OCFS2_CHAIN_FL		(0x00000400)	/* Chain allocator */
 #define OCFS2_DEALLOC_FL	(0x00000800)	/* Truncate log */
 #define OCFS2_QUOTA_FL		(0x00001000)	/* Quota file */
+#define OCFS2_DIO_ORPHANED_FL	(0X00002000)	/* On the orphan list especially
+						 * for dio */

 /*
  * Flags on ocfs2_dinode.i_dyn_features
@@ -737,7 +745,9 @@ struct ocfs2_dinode {
 					   inode belongs to.  Only valid
 					   if allocated from a
 					   discontiguous block group */
-/*A0*/	__le64 i_reserved2[3];
+/*A0*/	__le16 i_dio_orphaned_slot;	/* only used for append dio write */
+	__le16 i_reserved1[3];
+	__le64 i_reserved2[2];
 /*B8*/	union {
 		__le64 i_pad1;		/* Generic way to refer to this
 					   64bit union */
diff --git a/include/ocfs2/ocfs2.h b/include/ocfs2/ocfs2.h
index 3b54880..f4300e3 100644
--- a/include/ocfs2/ocfs2.h
+++ b/include/ocfs2/ocfs2.h
@@ -1346,6 +1346,13 @@ static inline int ocfs2_writes_unwritten_extents(struct ocfs2_super_block *osb)
 	return 0;
 }

+static inline int ocfs2_supports_append_dio(struct ocfs2_super_block *osb)
+{
+	if (osb->s_feature_ro_compat & OCFS2_FEATURE_RO_COMPAT_APPEND_DIO)
+		return 1;
+	return 0;
+}
+
 static inline int ocfs2_uses_extended_slot_map(struct ocfs2_super_block *osb)
 {
 	if (osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_EXTENDED_SLOT_MAP)
diff --git a/libocfs2/feature_string.c b/libocfs2/feature_string.c
index 544cc6e..97a4454 100644
--- a/libocfs2/feature_string.c
+++ b/libocfs2/feature_string.c
@@ -69,7 +69,8 @@ static ocfs2_fs_options feature_level_defaults[] = {
 	 OCFS2_FEATURE_INCOMPAT_REFCOUNT_TREE |
 	 OCFS2_FEATURE_INCOMPAT_INDEXED_DIRS |
 	 OCFS2_FEATURE_INCOMPAT_DISCONTIG_BG,
-	 OCFS2_FEATURE_RO_COMPAT_UNWRITTEN},  /* OCFS2_FEATURE_LEVEL_DEFAULT */
+	 OCFS2_FEATURE_RO_COMPAT_UNWRITTEN |
+	 OCFS2_FEATURE_RO_COMPAT_APPEND_DIO},  /* OCFS2_FEATURE_LEVEL_DEFAULT */

 	{OCFS2_FEATURE_COMPAT_BACKUP_SB | OCFS2_FEATURE_COMPAT_JBD2_SB,
 	 0,
@@ -86,7 +87,8 @@ static ocfs2_fs_options feature_level_defaults[] = {
 	 OCFS2_FEATURE_INCOMPAT_DISCONTIG_BG,
 	 OCFS2_FEATURE_RO_COMPAT_UNWRITTEN |
 	 OCFS2_FEATURE_RO_COMPAT_USRQUOTA |
-	 OCFS2_FEATURE_RO_COMPAT_GRPQUOTA }, /* OCFS2_FEATURE_LEVEL_MAX_FEATURES */
+	 OCFS2_FEATURE_RO_COMPAT_GRPQUOTA |
+	 OCFS2_FEATURE_RO_COMPAT_APPEND_DIO}, /* OCFS2_FEATURE_LEVEL_MAX_FEATURES */
 };

 static ocfs2_fs_options mkfstypes_features_defaults[] = {
@@ -98,7 +100,8 @@ static ocfs2_fs_options mkfstypes_features_defaults[] = {
 	 OCFS2_FEATURE_INCOMPAT_REFCOUNT_TREE |
 	 OCFS2_FEATURE_INCOMPAT_INDEXED_DIRS |
 	 OCFS2_FEATURE_INCOMPAT_DISCONTIG_BG,
-	 OCFS2_FEATURE_RO_COMPAT_UNWRITTEN},  /* OCFS2_MKFSTYPE_DEFAULT */
+	 OCFS2_FEATURE_RO_COMPAT_UNWRITTEN |
+	 OCFS2_FEATURE_RO_COMPAT_APPEND_DIO},  /* OCFS2_MKFSTYPE_DEFAULT */

 	{OCFS2_FEATURE_COMPAT_BACKUP_SB | OCFS2_FEATURE_COMPAT_JBD2_SB,
 	 OCFS2_FEATURE_INCOMPAT_SPARSE_ALLOC |
@@ -108,7 +111,8 @@ static ocfs2_fs_options mkfstypes_features_defaults[] = {
 	 OCFS2_FEATURE_INCOMPAT_REFCOUNT_TREE |
 	 OCFS2_FEATURE_INCOMPAT_INDEXED_DIRS |
 	 OCFS2_FEATURE_INCOMPAT_DISCONTIG_BG,
-	 OCFS2_FEATURE_RO_COMPAT_UNWRITTEN},  /* OCFS2_MKFSTYPE_DATAFILES */
+	 OCFS2_FEATURE_RO_COMPAT_UNWRITTEN |
+	 OCFS2_FEATURE_RO_COMPAT_APPEND_DIO},  /* OCFS2_MKFSTYPE_DATAFILES */

 	{OCFS2_FEATURE_COMPAT_BACKUP_SB | OCFS2_FEATURE_COMPAT_JBD2_SB,
 	 OCFS2_FEATURE_INCOMPAT_SPARSE_ALLOC |
@@ -118,7 +122,8 @@ static ocfs2_fs_options mkfstypes_features_defaults[] = {
 	 OCFS2_FEATURE_INCOMPAT_REFCOUNT_TREE |
 	 OCFS2_FEATURE_INCOMPAT_INDEXED_DIRS |
 	 OCFS2_FEATURE_INCOMPAT_DISCONTIG_BG,
-	 OCFS2_FEATURE_RO_COMPAT_UNWRITTEN},  /* OCFS2_MKFSTYPE_MAIL */
+	 OCFS2_FEATURE_RO_COMPAT_UNWRITTEN |
+	 OCFS2_FEATURE_RO_COMPAT_APPEND_DIO},  /* OCFS2_MKFSTYPE_MAIL */

 	{OCFS2_FEATURE_COMPAT_BACKUP_SB | OCFS2_FEATURE_COMPAT_JBD2_SB,
 	 OCFS2_FEATURE_INCOMPAT_SPARSE_ALLOC |
@@ -128,7 +133,8 @@ static ocfs2_fs_options mkfstypes_features_defaults[] = {
 	 OCFS2_FEATURE_INCOMPAT_REFCOUNT_TREE |
 	 OCFS2_FEATURE_INCOMPAT_INDEXED_DIRS |
 	 OCFS2_FEATURE_INCOMPAT_DISCONTIG_BG,
-	 OCFS2_FEATURE_RO_COMPAT_UNWRITTEN},  /* OCFS2_MKFSTYPE_VMSTORE */
+	 OCFS2_FEATURE_RO_COMPAT_UNWRITTEN |
+	 OCFS2_FEATURE_RO_COMPAT_APPEND_DIO},  /* OCFS2_MKFSTYPE_VMSTORE */
 };

 /* These are the features we support in mkfs/tunefs via --fs-features */
@@ -205,6 +211,11 @@ static struct fs_feature_flags ocfs2_supported_features[] = {
 		{0, OCFS2_FEATURE_INCOMPAT_CLUSTERINFO, 0},
 	},
 	{
+		"append-dio",
+		{0, 0, OCFS2_FEATURE_RO_COMPAT_APPEND_DIO},
+		{0, 0, OCFS2_FEATURE_RO_COMPAT_APPEND_DIO},
+	},
+	{
 		NULL,
 		{0, 0, 0},
 		{0, 0, 0}
@@ -296,6 +307,10 @@ static struct feature_name ocfs2_feature_names[] = {
 		.fn_flag = {0, OCFS2_FEATURE_INCOMPAT_CLUSTERINFO, 0},
 	},
 	{
+		.fn_name = "append-dio",
+		.fn_flag = {0, 0, OCFS2_FEATURE_RO_COMPAT_APPEND_DIO},
+	},
+	{
 		.fn_name = NULL,
 	},
 };
-- 
1.8.4.3
