From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 10 Sep 2008 20:05:55 -0700
Subject: [Ocfs2-devel] [PATCH 2/4] ocfs2: Moves struct ocfs2_slot_info to a
	header file
In-Reply-To: <1221102357-869-1-git-send-email-sunil.mushran@oracle.com>
References: <1221102357-869-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1221102357-869-3-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Moves the definition of struct ocfs2_slot_info from slot_map.c to ocfs2.h.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/ocfs2.h    |   16 +++++++++++++++-
 fs/ocfs2/slot_map.c |   17 -----------------
 2 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 487487a..b4bf878 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -192,8 +192,22 @@ enum ocfs2_mount_options
 #define OCFS2_OSB_ERROR_FS	0x0004
 #define OCFS2_DEFAULT_ATIME_QUANTUM	60
 
+struct ocfs2_slot {
+	int sl_valid;
+	unsigned int sl_node_num;
+};
+
+struct ocfs2_slot_info {
+	int si_extended;
+	int si_slots_per_block;
+	struct inode *si_inode;
+	unsigned int si_blocks;
+	struct buffer_head **si_bh;
+	unsigned int si_num_slots;
+	struct ocfs2_slot *si_slots;
+};
+
 struct ocfs2_journal;
-struct ocfs2_slot_info;
 struct ocfs2_recovery_map;
 struct ocfs2_super
 {
diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index bb5ff89..bd95205 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -42,23 +42,6 @@
 
 #include "buffer_head_io.h"
 
-
-struct ocfs2_slot {
-	int sl_valid;
-	unsigned int sl_node_num;
-};
-
-struct ocfs2_slot_info {
-	int si_extended;
-	int si_slots_per_block;
-	struct inode *si_inode;
-	unsigned int si_blocks;
-	struct buffer_head **si_bh;
-	unsigned int si_num_slots;
-	struct ocfs2_slot *si_slots;
-};
-
-
 static int __ocfs2_node_num_to_slot(struct ocfs2_slot_info *si,
 				    unsigned int node_num);
 
-- 
1.5.4.3
