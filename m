From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 22 Dec 2008 13:48:02 -0800
Subject: [Ocfs2-devel] [PATCH 21/56] ocfs2: Assign feature bits and system
	inodes to quota feature and quota files
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Message-ID: <1229982517-3455-22-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>

From: Jan Kara <jack@suse.cz>

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/Kconfig          |    2 ++
 fs/ocfs2/inode.c    |    2 ++
 fs/ocfs2/ocfs2_fs.h |   21 ++++++++++++++++++---
 fs/ocfs2/super.c    |   17 +++++++++++++++++
 4 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index d99bc0a..107f1cd 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -189,6 +189,8 @@ config OCFS2_FS
 	select CONFIGFS_FS
 	select JBD2
 	select CRC32
+	select QUOTA
+	select QUOTA_TREE
 	help
 	  OCFS2 is a general purpose extent based shared disk cluster file
 	  system with many similarities to ext3. It supports 64 bit inode
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index ec3497b..ec25d99 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -283,6 +283,8 @@ void ocfs2_populate_inode(struct inode *inode, struct ocfs2_dinode *fe,
 		mlog(0, "local alloc inode: i_ino=%lu\n", inode->i_ino);
 	} else if (fe->i_flags & cpu_to_le32(OCFS2_BITMAP_FL)) {
 		OCFS2_I(inode)->ip_flags |= OCFS2_INODE_BITMAP;
+	} else if (fe->i_flags & cpu_to_le32(OCFS2_QUOTA_FL)) {
+		inode->i_flags |= S_NOQUOTA;
 	} else if (fe->i_flags & cpu_to_le32(OCFS2_SUPER_BLOCK_FL)) {
 		mlog(0, "superblock inode: i_ino=%lu\n", inode->i_ino);
 		/* we can't actually hit this as read_inode can't
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 5e0c0d0..06e3bd6 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -94,7 +94,7 @@
 					 | OCFS2_FEATURE_INCOMPAT_EXTENDED_SLOT_MAP \
 					 | OCFS2_FEATURE_INCOMPAT_USERSPACE_STACK \
 					 | OCFS2_FEATURE_INCOMPAT_XATTR)
-#define OCFS2_FEATURE_RO_COMPAT_SUPP	OCFS2_FEATURE_RO_COMPAT_UNWRITTEN
+#define OCFS2_FEATURE_RO_COMPAT_SUPP	(OCFS2_FEATURE_RO_COMPAT_UNWRITTEN)
 
 /*
  * Heartbeat-only devices are missing journals and other files.  The
@@ -163,6 +163,12 @@
  */
 #define OCFS2_FEATURE_RO_COMPAT_UNWRITTEN	0x0001
 
+/*
+ * Maintain quota information for this filesystem
+ */
+#define OCFS2_FEATURE_RO_COMPAT_USRQUOTA	0x0002
+#define OCFS2_FEATURE_RO_COMPAT_GRPQUOTA	0x0004
+
 /* The byte offset of the first backup block will be 1G.
  * The following will be 4G, 16G, 64G, 256G and 1T.
  */
@@ -192,6 +198,7 @@
 #define OCFS2_HEARTBEAT_FL	(0x00000200)	/* Heartbeat area */
 #define OCFS2_CHAIN_FL		(0x00000400)	/* Chain allocator */
 #define OCFS2_DEALLOC_FL	(0x00000800)	/* Truncate log */
+#define OCFS2_QUOTA_FL		(0x00001000)	/* Quota file */
 
 /*
  * Flags on ocfs2_dinode.i_dyn_features
@@ -329,13 +336,17 @@ enum {
 #define OCFS2_FIRST_ONLINE_SYSTEM_INODE SLOT_MAP_SYSTEM_INODE
 	HEARTBEAT_SYSTEM_INODE,
 	GLOBAL_BITMAP_SYSTEM_INODE,
-#define OCFS2_LAST_GLOBAL_SYSTEM_INODE GLOBAL_BITMAP_SYSTEM_INODE
+	USER_QUOTA_SYSTEM_INODE,
+	GROUP_QUOTA_SYSTEM_INODE,
+#define OCFS2_LAST_GLOBAL_SYSTEM_INODE GROUP_QUOTA_SYSTEM_INODE
 	ORPHAN_DIR_SYSTEM_INODE,
 	EXTENT_ALLOC_SYSTEM_INODE,
 	INODE_ALLOC_SYSTEM_INODE,
 	JOURNAL_SYSTEM_INODE,
 	LOCAL_ALLOC_SYSTEM_INODE,
 	TRUNCATE_LOG_SYSTEM_INODE,
+	LOCAL_USER_QUOTA_SYSTEM_INODE,
+	LOCAL_GROUP_QUOTA_SYSTEM_INODE,
 	NUM_SYSTEM_INODES
 };
 
@@ -349,6 +360,8 @@ static struct ocfs2_system_inode_info ocfs2_system_inodes[NUM_SYSTEM_INODES] = {
 	[SLOT_MAP_SYSTEM_INODE]			= { "slot_map", 0, S_IFREG | 0644 },
 	[HEARTBEAT_SYSTEM_INODE]		= { "heartbeat", OCFS2_HEARTBEAT_FL, S_IFREG | 0644 },
 	[GLOBAL_BITMAP_SYSTEM_INODE]		= { "global_bitmap", 0, S_IFREG | 0644 },
+	[USER_QUOTA_SYSTEM_INODE]		= { "aquota.user", OCFS2_QUOTA_FL, S_IFREG | 0644 },
+	[GROUP_QUOTA_SYSTEM_INODE]		= { "aquota.group", OCFS2_QUOTA_FL, S_IFREG | 0644 },
 
 	/* Slot-specific system inodes (one copy per slot) */
 	[ORPHAN_DIR_SYSTEM_INODE]		= { "orphan_dir:%04d", 0, S_IFDIR | 0755 },
@@ -356,7 +369,9 @@ static struct ocfs2_system_inode_info ocfs2_system_inodes[NUM_SYSTEM_INODES] = {
 	[INODE_ALLOC_SYSTEM_INODE]		= { "inode_alloc:%04d", OCFS2_BITMAP_FL | OCFS2_CHAIN_FL, S_IFREG | 0644 },
 	[JOURNAL_SYSTEM_INODE]			= { "journal:%04d", OCFS2_JOURNAL_FL, S_IFREG | 0644 },
 	[LOCAL_ALLOC_SYSTEM_INODE]		= { "local_alloc:%04d", OCFS2_BITMAP_FL | OCFS2_LOCAL_ALLOC_FL, S_IFREG | 0644 },
-	[TRUNCATE_LOG_SYSTEM_INODE]		= { "truncate_log:%04d", OCFS2_DEALLOC_FL, S_IFREG | 0644 }
+	[TRUNCATE_LOG_SYSTEM_INODE]		= { "truncate_log:%04d", OCFS2_DEALLOC_FL, S_IFREG | 0644 },
+	[LOCAL_USER_QUOTA_SYSTEM_INODE]		= { "aquota.user:%04d", OCFS2_QUOTA_FL, S_IFREG | 0644 },
+	[LOCAL_GROUP_QUOTA_SYSTEM_INODE]	= { "aquota.group:%04d", OCFS2_QUOTA_FL, S_IFREG | 0644 },
 };
 
 /* Parameter passed from mount.ocfs2 to module */
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 9e7accc..41bb019 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -225,6 +225,19 @@ static int ocfs2_sync_fs(struct super_block *sb, int wait)
 	return 0;
 }
 
+static int ocfs2_need_system_inode(struct ocfs2_super *osb, int ino)
+{
+	if (!OCFS2_HAS_RO_COMPAT_FEATURE(osb->sb, OCFS2_FEATURE_RO_COMPAT_USRQUOTA)
+	    && (ino == USER_QUOTA_SYSTEM_INODE
+		|| ino == LOCAL_USER_QUOTA_SYSTEM_INODE))
+		return 0;
+	if (!OCFS2_HAS_RO_COMPAT_FEATURE(osb->sb, OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)
+	    && (ino == GROUP_QUOTA_SYSTEM_INODE
+		|| ino == LOCAL_GROUP_QUOTA_SYSTEM_INODE))
+		return 0;
+	return 1;
+}
+
 static int ocfs2_init_global_system_inodes(struct ocfs2_super *osb)
 {
 	struct inode *new = NULL;
@@ -251,6 +264,8 @@ static int ocfs2_init_global_system_inodes(struct ocfs2_super *osb)
 
 	for (i = OCFS2_FIRST_ONLINE_SYSTEM_INODE;
 	     i <= OCFS2_LAST_GLOBAL_SYSTEM_INODE; i++) {
+		if (!ocfs2_need_system_inode(osb, i))
+			continue;
 		new = ocfs2_get_system_file_inode(osb, i, osb->slot_num);
 		if (!new) {
 			ocfs2_release_system_inodes(osb);
@@ -281,6 +296,8 @@ static int ocfs2_init_local_system_inodes(struct ocfs2_super *osb)
 	for (i = OCFS2_LAST_GLOBAL_SYSTEM_INODE + 1;
 	     i < NUM_SYSTEM_INODES;
 	     i++) {
+		if (!ocfs2_need_system_inode(osb, i))
+			continue;
 		new = ocfs2_get_system_file_inode(osb, i, osb->slot_num);
 		if (!new) {
 			ocfs2_release_system_inodes(osb);
-- 
1.5.6
