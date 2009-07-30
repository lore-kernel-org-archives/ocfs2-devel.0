From: Jan Kara <jack@suse.cz>
Date: Thu, 30 Jul 2009 19:14:16 +0200
Subject: [Ocfs2-devel] [PATCH 1/9] Update ocfs2_fs.h to contain all
	necessary quota structures and constants, create quota_tree.h
In-Reply-To: <1248974064-29462-1-git-send-email-jack@suse.cz>
References: <1248974064-29462-1-git-send-email-jack@suse.cz>
Message-ID: <1248974064-29462-2-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/ocfs2-kernel/ocfs2_fs.h   |   10 +++++++++-
 include/ocfs2-kernel/quota_tree.h |   15 +++++++++++++++
 2 files changed, 24 insertions(+), 1 deletions(-)
 create mode 100644 include/ocfs2-kernel/quota_tree.h

diff --git a/include/ocfs2-kernel/ocfs2_fs.h b/include/ocfs2-kernel/ocfs2_fs.h
index 2140bb3..f3c9b53 100644
--- a/include/ocfs2-kernel/ocfs2_fs.h
+++ b/include/ocfs2-kernel/ocfs2_fs.h
@@ -344,13 +344,17 @@ enum {
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
diff --git a/include/ocfs2-kernel/quota_tree.h b/include/ocfs2-kernel/quota_tree.h
new file mode 100644
index 0000000..9dbe835
--- /dev/null
+++ b/include/ocfs2-kernel/quota_tree.h
@@ -0,0 +1,15 @@
+#ifndef _QUOTA_TREE_H
+#define _QUOTA_TREE_H
+
+#define QT_TREEOFF 1
+
+/* Header of leaf tree block */
+struct qt_disk_dqdbheader {
+	__le32 dqdh_next_free;	/* Number of next block with free entry */
+	__le32 dqdh_prev_free;	/* Number of previous block with free entry */
+	__le16 dqdh_entries;	/* Number of valid entries in block */
+	__le16 dqdh_pad1;
+	__le32 dqdh_pad2;
+};
+
+#endif
-- 
1.6.0.2
