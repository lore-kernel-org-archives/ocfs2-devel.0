From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Fri, 27 Feb 2009 18:00:54 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] Patch to move ocfs2_slot_info to
	slot_map.h
In-Reply-To: <1235786454-17019-1-git-send-email-srinivas.eeda@oracle.com>
References: <1235786454-17019-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <1235786454-17019-2-git-send-email-srinivas.eeda@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch is required to access slot_info struct for a patch that recovers
orphans from offline slots.

Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
---
 fs/ocfs2/slot_map.c |   17 -----------------
 fs/ocfs2/slot_map.h |   15 +++++++++++++++
 2 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index 40661e7..9f82a5f 100644
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
 
diff --git a/fs/ocfs2/slot_map.h b/fs/ocfs2/slot_map.h
index 601c95f..12afe24 100644
--- a/fs/ocfs2/slot_map.h
+++ b/fs/ocfs2/slot_map.h
@@ -27,6 +27,21 @@
 #ifndef SLOTMAP_H
 #define SLOTMAP_H
 
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
 int ocfs2_init_slot_info(struct ocfs2_super *osb);
 void ocfs2_free_slot_info(struct ocfs2_super *osb);
 
-- 
1.5.6.5
