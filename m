From: Jan Kara <jack@suse.cz>
Date: Mon, 27 Jul 2009 19:53:29 +0200
Subject: [Ocfs2-devel] [PATCH 1/8] Update ocfs2_fs.h to contain all
	necessary quota structures and constants
In-Reply-To: <1248717216-26617-1-git-send-email-jack@suse.cz>
References: <1248717216-26617-1-git-send-email-jack@suse.cz>
Message-ID: <1248717216-26617-2-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/ocfs2-kernel/ocfs2_fs.h |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/include/ocfs2-kernel/ocfs2_fs.h b/include/ocfs2-kernel/ocfs2_fs.h
index 2140bb3..ad655dc 100644
--- a/include/ocfs2-kernel/ocfs2_fs.h
+++ b/include/ocfs2-kernel/ocfs2_fs.h
@@ -344,6 +344,8 @@ enum {
 #define OCFS2_FIRST_ONLINE_SYSTEM_INODE SLOT_MAP_SYSTEM_INODE
 	HEARTBEAT_SYSTEM_INODE,
 	GLOBAL_BITMAP_SYSTEM_INODE,
+	USER_QUOTA_SYSTEM_INODE,
+	GROUP_QUOTA_SYSTEM_INODE,
 #define OCFS2_LAST_GLOBAL_SYSTEM_INODE GLOBAL_BITMAP_SYSTEM_INODE
 	ORPHAN_DIR_SYSTEM_INODE,
 	EXTENT_ALLOC_SYSTEM_INODE,
@@ -351,6 +353,8 @@ enum {
 	JOURNAL_SYSTEM_INODE,
 	LOCAL_ALLOC_SYSTEM_INODE,
 	TRUNCATE_LOG_SYSTEM_INODE,
+	LOCAL_USER_QUOTA_SYSTEM_INODE,
+	LOCAL_GROUP_QUOTA_SYSTEM_INODE,
 	NUM_SYSTEM_INODES
 };
 
@@ -364,6 +368,8 @@ static struct ocfs2_system_inode_info ocfs2_system_inodes[NUM_SYSTEM_INODES] = {
 	[SLOT_MAP_SYSTEM_INODE]			= { "slot_map", 0, S_IFREG | 0644 },
 	[HEARTBEAT_SYSTEM_INODE]		= { "heartbeat", OCFS2_HEARTBEAT_FL, S_IFREG | 0644 },
 	[GLOBAL_BITMAP_SYSTEM_INODE]		= { "global_bitmap", 0, S_IFREG | 0644 },
+	[USER_QUOTA_SYSTEM_INODE]		= { "aquota.user", OCFS2_QUOTA_FL, S_IFREG | 0644 },
+	[GROUP_QUOTA_SYSTEM_INODE]		= { "aquota.group", OCFS2_QUOTA_FL, S_IFREG | 0644 },
 
 	/* Slot-specific system inodes (one copy per slot) */
 	[ORPHAN_DIR_SYSTEM_INODE]		= { "orphan_dir:%04d", 0, S_IFDIR | 0755 },
@@ -372,6 +378,8 @@ static struct ocfs2_system_inode_info ocfs2_system_inodes[NUM_SYSTEM_INODES] = {
 	[JOURNAL_SYSTEM_INODE]			= { "journal:%04d", OCFS2_JOURNAL_FL, S_IFREG | 0644 },
 	[LOCAL_ALLOC_SYSTEM_INODE]		= { "local_alloc:%04d", OCFS2_BITMAP_FL | OCFS2_LOCAL_ALLOC_FL, S_IFREG | 0644 },
 	[TRUNCATE_LOG_SYSTEM_INODE]		= { "truncate_log:%04d", OCFS2_DEALLOC_FL, S_IFREG | 0644 },
+	[LOCAL_USER_QUOTA_SYSTEM_INODE]		= { "aquota.user:%04d", OCFS2_QUOTA_FL, S_IFREG | 0644 },
+	[LOCAL_GROUP_QUOTA_SYSTEM_INODE]	= { "aquota.group:%04d", OCFS2_QUOTA_FL, S_IFREG | 0644 },
 };
 
 /* Parameter passed from mount.ocfs2 to module */
@@ -963,6 +971,7 @@ struct ocfs2_disk_dqheader {
 };
 
 #define OCFS2_GLOBAL_INFO_OFF (sizeof(struct ocfs2_disk_dqheader))
+#define OCFS2_GLOBAL_TREE_BLK 1
 
 /* Information header of global quota file (immediately follows the generic
  * header) */
@@ -977,6 +986,16 @@ struct ocfs2_global_disk_dqinfo {
 				 * file */
 };
 
+/* Header of leaf tree block */
+struct ocfs2_global_disk_dqdbheader {
+	__le32 dqdh_next_free;	/* Number of next block with free entry */
+	__le32 dqdh_prev_free;	/* Number of previous block with free entry */
+	__le16 dqdh_entries;	/* Number of valid entries in block */
+	__le16 dqdh_pad1;
+	__le32 dqdh_pad2;
+};
+
+
 /* Structure with global user / group information. We reserve some space
  * for future use. */
 struct ocfs2_global_disk_dqblk {
@@ -1187,6 +1206,13 @@ static inline u16 ocfs2_xattr_recs_per_xb(struct super_block *sb)
 	return size / sizeof(struct ocfs2_extent_rec);
 }
 #else
+static inline int ocfs2_global_dqstr_in_blk(int blocksize)
+{
+	return (blocksize - OCFS2_QBLK_RESERVED_SPACE -
+		sizeof(struct ocfs2_global_disk_dqdbheader)) /
+		sizeof(struct ocfs2_global_disk_dqblk);
+}
+
 static inline int ocfs2_fast_symlink_chars(int blocksize)
 {
 	return blocksize - offsetof(struct ocfs2_dinode, id2.i_symlink);
-- 
1.6.0.2
