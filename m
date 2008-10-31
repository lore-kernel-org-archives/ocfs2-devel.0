From: Jan Kara <jack@suse.cz>
Date: Fri, 31 Oct 2008 07:39:11 +0100
Subject: [Ocfs2-devel] [PATCH 21/27] ocfs2: Assign feature bits and system
	inodes to quota feature and quota files
In-Reply-To: <12254351592495-git-send-email-jack@suse.cz>
References: y <12254351572189-git-send-email-jack@suse.cz>
	<12254351571914-git-send-email-jack@suse.cz>
	<1225435157625-git-send-email-jack@suse.cz>
	<1225435157218-git-send-email-jack@suse.cz>
	<12254351571677-git-send-email-jack@suse.cz>
	<1225435157894-git-send-email-jack@suse.cz>
	<12254351582004-git-send-email-jack@suse.cz>
	<12254351581363-git-send-email-jack@suse.cz>
	<12254351582759-git-send-email-jack@suse.cz>
	<12254351582523-git-send-email-jack@suse.cz>
	<12254351583984-git-send-email-jack@suse.cz>
	<12254351582475-git-send-email-jack@suse.cz>
	<12254351583997-git-send-email-jack@suse.cz>
	<122543515838-git-send-email-jack@suse.cz>
	<1225435158192-git-send-email-jack@suse.cz>
	<1225435158807-git-send-email-jack@suse.cz>
	<1225435159130-git-send-email-jack@suse.cz>
	<12254351592930-git-send-email-jack@suse.cz>
	<12254351592095-git-send-email-jack@suse.cz>
	<12254351592812-git-send-email-jack@suse.cz>
	<12254351592495-git-send-email-jack@suse.cz>
Message-ID: <12254351591416-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/inode.c    |    2 ++
 fs/ocfs2/ocfs2_fs.h |   21 ++++++++++++++++++---
 fs/ocfs2/super.c    |   17 +++++++++++++++++
 3 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 7aa00d5..c80489d 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -292,6 +292,8 @@ int ocfs2_populate_inode(struct inode *inode, struct ocfs2_dinode *fe,
 		mlog(0, "local alloc inode: i_ino=%lu\n", inode->i_ino);
 	} else if (fe->i_flags & cpu_to_le32(OCFS2_BITMAP_FL)) {
 		OCFS2_I(inode)->ip_flags |= OCFS2_INODE_BITMAP;
+	} else if (fe->i_flags & cpu_to_le32(OCFS2_QUOTA_FL)) {
+		inode->i_flags |= S_NOQUOTA;
 	} else if (fe->i_flags & cpu_to_le32(OCFS2_SUPER_BLOCK_FL)) {
 		mlog(0, "superblock inode: i_ino=%lu\n", inode->i_ino);
 		/* we can't actually hit this as read_inode can't
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 5f180cf..2e1e771 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -93,7 +93,7 @@
 					 | OCFS2_FEATURE_INCOMPAT_EXTENDED_SLOT_MAP \
 					 | OCFS2_FEATURE_INCOMPAT_USERSPACE_STACK \
 					 | OCFS2_FEATURE_INCOMPAT_XATTR)
-#define OCFS2_FEATURE_RO_COMPAT_SUPP	OCFS2_FEATURE_RO_COMPAT_UNWRITTEN
+#define OCFS2_FEATURE_RO_COMPAT_SUPP	(OCFS2_FEATURE_RO_COMPAT_UNWRITTEN)
 
 /*
  * Heartbeat-only devices are missing journals and other files.  The
@@ -157,6 +157,12 @@
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
@@ -186,6 +192,7 @@
 #define OCFS2_HEARTBEAT_FL	(0x00000200)	/* Heartbeat area */
 #define OCFS2_CHAIN_FL		(0x00000400)	/* Chain allocator */
 #define OCFS2_DEALLOC_FL	(0x00000800)	/* Truncate log */
+#define OCFS2_QUOTA_FL		(0x00001000)	/* Quota file */
 
 /*
  * Flags on ocfs2_dinode.i_dyn_features
@@ -323,13 +330,17 @@ enum {
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
 
@@ -343,6 +354,8 @@ static struct ocfs2_system_inode_info ocfs2_system_inodes[NUM_SYSTEM_INODES] = {
 	[SLOT_MAP_SYSTEM_INODE]			= { "slot_map", 0, S_IFREG | 0644 },
 	[HEARTBEAT_SYSTEM_INODE]		= { "heartbeat", OCFS2_HEARTBEAT_FL, S_IFREG | 0644 },
 	[GLOBAL_BITMAP_SYSTEM_INODE]		= { "global_bitmap", 0, S_IFREG | 0644 },
+	[USER_QUOTA_SYSTEM_INODE]		= { "aquota.user", OCFS2_QUOTA_FL, S_IFREG | 0644 },
+	[GROUP_QUOTA_SYSTEM_INODE]		= { "aquota.group", OCFS2_QUOTA_FL, S_IFREG | 0644 },
 
 	/* Slot-specific system inodes (one copy per slot) */
 	[ORPHAN_DIR_SYSTEM_INODE]		= { "orphan_dir:%04d", 0, S_IFDIR | 0755 },
@@ -350,7 +363,9 @@ static struct ocfs2_system_inode_info ocfs2_system_inodes[NUM_SYSTEM_INODES] = {
 	[INODE_ALLOC_SYSTEM_INODE]		= { "inode_alloc:%04d", OCFS2_BITMAP_FL | OCFS2_CHAIN_FL, S_IFREG | 0644 },
 	[JOURNAL_SYSTEM_INODE]			= { "journal:%04d", OCFS2_JOURNAL_FL, S_IFREG | 0644 },
 	[LOCAL_ALLOC_SYSTEM_INODE]		= { "local_alloc:%04d", OCFS2_BITMAP_FL | OCFS2_LOCAL_ALLOC_FL, S_IFREG | 0644 },
-	[TRUNCATE_LOG_SYSTEM_INODE]		= { "truncate_log:%04d", OCFS2_DEALLOC_FL, S_IFREG | 0644 }
+	[TRUNCATE_LOG_SYSTEM_INODE]		= { "truncate_log:%04d", OCFS2_DEALLOC_FL, S_IFREG | 0644 },
+	[LOCAL_USER_QUOTA_SYSTEM_INODE]		= { "aquota%04d.user", OCFS2_QUOTA_FL, S_IFREG | 0644 },
+	[LOCAL_GROUP_QUOTA_SYSTEM_INODE]	= { "aquota%04d.group", OCFS2_QUOTA_FL, S_IFREG | 0644 },
 };
 
 /* Parameter passed from mount.ocfs2 to module */
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 304b63a..4712bc7 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -221,6 +221,19 @@ static int ocfs2_sync_fs(struct super_block *sb, int wait)
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
@@ -247,6 +260,8 @@ static int ocfs2_init_global_system_inodes(struct ocfs2_super *osb)
 
 	for (i = OCFS2_FIRST_ONLINE_SYSTEM_INODE;
 	     i <= OCFS2_LAST_GLOBAL_SYSTEM_INODE; i++) {
+		if (!ocfs2_need_system_inode(osb, i))
+			continue;
 		new = ocfs2_get_system_file_inode(osb, i, osb->slot_num);
 		if (!new) {
 			ocfs2_release_system_inodes(osb);
@@ -277,6 +292,8 @@ static int ocfs2_init_local_system_inodes(struct ocfs2_super *osb)
 	for (i = OCFS2_LAST_GLOBAL_SYSTEM_INODE + 1;
 	     i < NUM_SYSTEM_INODES;
 	     i++) {
+		if (!ocfs2_need_system_inode(osb, i))
+			continue;
 		new = ocfs2_get_system_file_inode(osb, i, osb->slot_num);
 		if (!new) {
 			ocfs2_release_system_inodes(osb);
-- 
1.5.2.4
