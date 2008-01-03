From: Joel Becker <joel.becker@oracle.com>
Date: Thu Jan  3 13:41:59 2008
Subject: [Ocfs2-devel] [PATCH 5/7] ocfs2: De-magic the in-memory slot map.
In-Reply-To: <1199396425-7012-1-git-send-email-joel.becker@oracle.com>
References: <1199396425-7012-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1199396425-7012-6-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The in-memory slot map uses the same magic as the on-disk one.  There is
a special value to mark a slot as invalid.  It relies on the size of
certain types and so on.

Write a new in-memory map that keeps validity as a separate field.  Outside
of the I/O functions, OCFS2_INVALID_SLOT now means what it is supposed to.
It also is no longer tied to the type size.

This also means that only the I/O functions refer to 16bit quantities.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/journal.c  |    2 +-
 fs/ocfs2/ocfs2.h    |    6 +-
 fs/ocfs2/slot_map.c |  129 ++++++++++++++++++++++++++++-----------------------
 fs/ocfs2/slot_map.h |    2 +-
 4 files changed, 76 insertions(+), 63 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index d512a5c..f9fb395 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -71,7 +71,7 @@ static int ocfs2_commit_thread(void *arg);
  */
 
 struct ocfs2_recovery_map {
-	int rm_used;
+	unsigned int rm_used;
 	unsigned int *rm_entries;
 };
 
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 96674f7..abc846f 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -215,10 +215,10 @@ struct ocfs2_super
 	unsigned long s_mount_opt;
 	unsigned int s_atime_quantum;
 
-	u16 max_slots;
+	unsigned int max_slots;
 	s16 node_num;
-	s16 slot_num;
-	s16 preferred_slot;
+	int slot_num;
+	int preferred_slot;
 	int s_sectsize_bits;
 	int s_clustersize;
 	int s_clustersize_bits;
diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index 5bddee1..3af880f 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -42,21 +42,41 @@
 
 #include "buffer_head_io.h"
 
+
+struct ocfs2_slot {
+	int sl_valid;
+	unsigned int sl_node_num;
+};
+
 struct ocfs2_slot_info {
 	struct inode *si_inode;
 	unsigned int si_blocks;
 	struct buffer_head **si_bh;
 	unsigned int si_num_slots;
-	unsigned int si_size;
-	s16 si_global_node_nums[OCFS2_MAX_SLOTS];
+	struct ocfs2_slot *si_slots;
 };
 
 
-static s16 __ocfs2_node_num_to_slot(struct ocfs2_slot_info *si,
-				    s16 global);
-static void __ocfs2_fill_slot(struct ocfs2_slot_info *si,
-			      s16 slot_num,
-			      s16 node_num);
+static int __ocfs2_node_num_to_slot(struct ocfs2_slot_info *si,
+				    unsigned int node_num);
+
+static void ocfs2_invalidate_slot(struct ocfs2_slot_info *si,
+				  int slot_num)
+{
+	BUG_ON((slot_num < 0) || (slot_num >= si->si_num_slots));
+	si->si_slots[slot_num].sl_valid = 0;
+}
+
+static void ocfs2_set_slot(struct ocfs2_slot_info *si,
+			   int slot_num, unsigned int node_num)
+{
+	BUG_ON((slot_num < 0) || (slot_num >= si->si_num_slots));
+	BUG_ON((node_num == O2NM_INVALID_NODE_NUM) ||
+	       (node_num >= O2NM_MAX_NODES));
+
+	si->si_slots[slot_num].sl_valid = 1;
+	si->si_slots[slot_num].sl_node_num = node_num;
+}
 
 /*
  * Post the slot information on disk into our slot_info struct.
@@ -71,8 +91,12 @@ static void ocfs2_update_slot_info(struct ocfs2_slot_info *si)
 	 * should've made sure we have the most recent copy. */
 	disk_info = (__le16 *) si->si_bh[0]->b_data;
 
-	for (i = 0; i < si->si_size; i++)
-		si->si_global_node_nums[i] = le16_to_cpu(disk_info[i]);
+	for (i = 0; i < si->si_num_slots; i++) {
+		if (le16_to_cpu(disk_info[i]) == (u16)OCFS2_INVALID_SLOT)
+			ocfs2_invalidate_slot(si, i);
+		else
+			ocfs2_set_slot(si, i, le16_to_cpu(disk_info[i]));
+	}
 }
 
 int ocfs2_refresh_slot_info(struct ocfs2_super *osb)
@@ -114,8 +138,13 @@ static int ocfs2_update_disk_slots(struct ocfs2_super *osb,
 	__le16 *disk_info = (__le16 *) si->si_bh[0]->b_data;
 
 	spin_lock(&osb->osb_lock);
-	for (i = 0; i < si->si_size; i++)
-		disk_info[i] = cpu_to_le16(si->si_global_node_nums[i]);
+	for (i = 0; i < si->si_num_slots; i++) {
+		if (si->si_slots[i].sl_valid)
+			disk_info[i] =
+				cpu_to_le16(si->si_slots[i].sl_node_num);
+		else
+			disk_info[i] = cpu_to_le16(OCFS2_INVALID_SLOT);
+	}
 	spin_unlock(&osb->osb_lock);
 
 	status = ocfs2_write_block(osb, si->si_bh[0], si->si_inode);
@@ -147,39 +176,39 @@ static int ocfs2_slot_map_physical_size(struct ocfs2_super *osb,
 	return 0;
 }
 
-/* try to find global node in the slot info. Returns
- * OCFS2_INVALID_SLOT if nothing is found. */
-static s16 __ocfs2_node_num_to_slot(struct ocfs2_slot_info *si,
-				    s16 global)
+/* try to find global node in the slot info. Returns -ENOENT
+ * if nothing is found. */
+static int __ocfs2_node_num_to_slot(struct ocfs2_slot_info *si,
+				    unsigned int node_num)
 {
-	int i;
-	s16 ret = OCFS2_INVALID_SLOT;
+	int i, ret = -ENOENT;
 
 	for(i = 0; i < si->si_num_slots; i++) {
-		if (global == si->si_global_node_nums[i]) {
-			ret = (s16) i;
+		if (si->si_slots[i].sl_valid &&
+		    (node_num == si->si_slots[i].sl_node_num)) {
+			ret = i;
 			break;
 		}
 	}
+
 	return ret;
 }
 
-static s16 __ocfs2_find_empty_slot(struct ocfs2_slot_info *si,
-				   s16 preferred)
+static int __ocfs2_find_empty_slot(struct ocfs2_slot_info *si,
+				   int preferred)
 {
-	int i;
-	s16 ret = OCFS2_INVALID_SLOT;
+	int i, ret = -ENOSPC;
 
-	if (preferred >= 0 && preferred < si->si_num_slots) {
-		if (OCFS2_INVALID_SLOT == si->si_global_node_nums[preferred]) {
+	if ((preferred >= 0) && (preferred < si->si_num_slots)) {
+		if (!si->si_slots[preferred].sl_valid) {
 			ret = preferred;
 			goto out;
 		}
 	}
 
 	for(i = 0; i < si->si_num_slots; i++) {
-		if (OCFS2_INVALID_SLOT == si->si_global_node_nums[i]) {
-			ret = (s16) i;
+		if (!si->si_slots[i].sl_valid) {
+			ret = i;
 			break;
 		}
 	}
@@ -189,16 +218,13 @@ out:
 
 int ocfs2_node_num_to_slot(struct ocfs2_super *osb, unsigned int node_num)
 {
-	s16 slot;
+	int slot;
 	struct ocfs2_slot_info *si = osb->slot_info;
 
 	spin_lock(&osb->osb_lock);
 	slot = __ocfs2_node_num_to_slot(si, node_num);
 	spin_unlock(&osb->osb_lock);
 
-	if (slot == OCFS2_INVALID_SLOT)
-		return -ENOENT;
-
 	return slot;
 }
 
@@ -212,10 +238,10 @@ int ocfs2_slot_to_node_num_locked(struct ocfs2_super *osb, int slot_num,
 	BUG_ON(slot_num < 0);
 	BUG_ON(slot_num > osb->max_slots);
 
-	if (si->si_global_node_nums[slot_num] == OCFS2_INVALID_SLOT)
+	if (!si->si_slots[slot_num].sl_valid)
 		return -ENOENT;
 
-	*node_num = si->si_global_node_nums[slot_num];
+	*node_num = si->si_slots[slot_num].sl_node_num;
 	return 0;
 }
 
@@ -241,19 +267,7 @@ static void __ocfs2_free_slot_info(struct ocfs2_slot_info *si)
 	kfree(si);
 }
 
-static void __ocfs2_fill_slot(struct ocfs2_slot_info *si,
-			      s16 slot_num,
-			      s16 node_num)
-{
-	BUG_ON(slot_num == OCFS2_INVALID_SLOT);
-	BUG_ON(slot_num >= si->si_num_slots);
-	BUG_ON((node_num != O2NM_INVALID_NODE_NUM) &&
-	       (node_num >= O2NM_MAX_NODES));
-
-	si->si_global_node_nums[slot_num] = node_num;
-}
-
-int ocfs2_clear_slot(struct ocfs2_super *osb, s16 slot_num)
+int ocfs2_clear_slot(struct ocfs2_super *osb, int slot_num)
 {
 	struct ocfs2_slot_info *si = osb->slot_info;
 
@@ -261,7 +275,7 @@ int ocfs2_clear_slot(struct ocfs2_super *osb, s16 slot_num)
 		return 0;
 
 	spin_lock(&osb->osb_lock);
-	__ocfs2_fill_slot(si, slot_num, OCFS2_INVALID_SLOT);
+	ocfs2_invalidate_slot(si, slot_num);
 	spin_unlock(&osb->osb_lock);
 
 	return ocfs2_update_disk_slots(osb, osb->slot_info);
@@ -324,11 +338,13 @@ bail:
 
 int ocfs2_init_slot_info(struct ocfs2_super *osb)
 {
-	int status, i;
+	int status;
 	struct inode *inode = NULL;
 	struct ocfs2_slot_info *si;
 
-	si = kzalloc(sizeof(struct ocfs2_slot_info), GFP_KERNEL);
+	si = kzalloc(sizeof(struct ocfs2_slot_info) +
+		     (sizeof(struct ocfs2_slot) * osb->max_slots),
+		     GFP_KERNEL);
 	if (!si) {
 		status = -ENOMEM;
 		mlog_errno(status);
@@ -336,10 +352,7 @@ int ocfs2_init_slot_info(struct ocfs2_super *osb)
 	}
 
 	si->si_num_slots = osb->max_slots;
-	si->si_size = OCFS2_MAX_SLOTS;
-
-	for(i = 0; i < si->si_num_slots; i++)
-		si->si_global_node_nums[i] = OCFS2_INVALID_SLOT;
+	si->si_slots = (struct ocfs2_slot *)((char *)si + sizeof(struct ocfs2_slot_info));
 
 	inode = ocfs2_get_system_file_inode(osb, SLOT_MAP_SYSTEM_INODE,
 					    OCFS2_INVALID_SLOT);
@@ -375,7 +388,7 @@ void ocfs2_free_slot_info(struct ocfs2_super *osb)
 int ocfs2_find_slot(struct ocfs2_super *osb)
 {
 	int status;
-	s16 slot;
+	int slot;
 	struct ocfs2_slot_info *si;
 
 	mlog_entry_void();
@@ -390,11 +403,11 @@ int ocfs2_find_slot(struct ocfs2_super *osb)
 	 * own journal recovery? Possibly not, though we certainly
 	 * need to warn to the user */
 	slot = __ocfs2_node_num_to_slot(si, osb->node_num);
-	if (slot == OCFS2_INVALID_SLOT) {
+	if (slot < 0) {
 		/* if no slot yet, then just take 1st available
 		 * one. */
 		slot = __ocfs2_find_empty_slot(si, osb->preferred_slot);
-		if (slot == OCFS2_INVALID_SLOT) {
+		if (slot < 0) {
 			spin_unlock(&osb->osb_lock);
 			mlog(ML_ERROR, "no free slots available!\n");
 			status = -EINVAL;
@@ -404,7 +417,7 @@ int ocfs2_find_slot(struct ocfs2_super *osb)
 		mlog(ML_NOTICE, "slot %d is already allocated to this node!\n",
 		     slot);
 
-	__ocfs2_fill_slot(si, slot, osb->node_num);
+	ocfs2_set_slot(si, slot, osb->node_num);
 	osb->slot_num = slot;
 	spin_unlock(&osb->osb_lock);
 
@@ -430,7 +443,7 @@ void ocfs2_put_slot(struct ocfs2_super *osb)
 	spin_lock(&osb->osb_lock);
 	ocfs2_update_slot_info(si);
 
-	__ocfs2_fill_slot(si, osb->slot_num, OCFS2_INVALID_SLOT);
+	ocfs2_invalidate_slot(si, osb->slot_num);
 	osb->slot_num = OCFS2_INVALID_SLOT;
 	spin_unlock(&osb->osb_lock);
 
diff --git a/fs/ocfs2/slot_map.h b/fs/ocfs2/slot_map.h
index 5118e89..601c95f 100644
--- a/fs/ocfs2/slot_map.h
+++ b/fs/ocfs2/slot_map.h
@@ -39,6 +39,6 @@ int ocfs2_node_num_to_slot(struct ocfs2_super *osb, unsigned int node_num);
 int ocfs2_slot_to_node_num_locked(struct ocfs2_super *osb, int slot_num,
 				  unsigned int *node_num);
 
-int ocfs2_clear_slot(struct ocfs2_super *osb, s16 slot_num);
+int ocfs2_clear_slot(struct ocfs2_super *osb, int slot_num);
 
 #endif
-- 
1.5.2.2
