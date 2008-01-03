From: Joel Becker <joel.becker@oracle.com>
Date: Thu Jan  3 13:41:52 2008
Subject: [Ocfs2-devel] [PATCH 2/7] ocfs2: Make ocfs2_slot_info private.
In-Reply-To: <1199396425-7012-1-git-send-email-joel.becker@oracle.com>
References: <1199396425-7012-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1199396425-7012-3-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Just use osb_lock around the ocfs2_slot_info data.  This allows us to
take the ocfs2_slot_info structure private in slot_info.c.  All access
is now via accessors.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/journal.c  |   24 +++++++-------
 fs/ocfs2/ocfs2.h    |    1 +
 fs/ocfs2/slot_map.c |   81 ++++++++++++++++++++++++++++++++++++---------------
 fs/ocfs2/slot_map.h |   25 ++-------------
 4 files changed, 74 insertions(+), 57 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index da63375..322b981 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1065,7 +1065,6 @@ static int ocfs2_recover_node(struct ocfs2_super *osb,
 {
 	int status = 0;
 	int slot_num;
-	struct ocfs2_slot_info *si = osb->slot_info;
 	struct ocfs2_dinode *la_copy = NULL;
 	struct ocfs2_dinode *tl_copy = NULL;
 
@@ -1078,8 +1077,8 @@ static int ocfs2_recover_node(struct ocfs2_super *osb,
 	 * case we should've called ocfs2_journal_load instead. */
 	BUG_ON(osb->node_num == node_num);
 
-	slot_num = ocfs2_node_num_to_slot(si, node_num);
-	if (slot_num == OCFS2_INVALID_SLOT) {
+	slot_num = ocfs2_node_num_to_slot(osb, node_num);
+	if (slot_num == -ENOENT) {
 		status = 0;
 		mlog(0, "no slot for this node, so no recovery required.\n");
 		goto done;
@@ -1169,23 +1168,24 @@ bail:
  * slot info struct has been updated from disk. */
 int ocfs2_mark_dead_nodes(struct ocfs2_super *osb)
 {
-	int status, i, node_num;
-	struct ocfs2_slot_info *si = osb->slot_info;
+	unsigned int node_num;
+	int status, i;
 
 	/* This is called with the super block cluster lock, so we
 	 * know that the slot map can't change underneath us. */
 
-	spin_lock(&si->si_lock);
-	for(i = 0; i < si->si_num_slots; i++) {
+	spin_lock(&osb->osb_lock);
+	for(i = 0; i < osb->max_slots; i++) {
 		if (i == osb->slot_num)
 			continue;
-		if (ocfs2_is_empty_slot(si, i))
+
+		status = ocfs2_slot_to_node_num_locked(osb, i, &node_num);
+		if (status == -ENOENT)
 			continue;
 
-		node_num = si->si_global_node_nums[i];
 		if (ocfs2_node_map_test_bit(osb, &osb->recovery_map, node_num))
 			continue;
-		spin_unlock(&si->si_lock);
+		spin_unlock(&osb->osb_lock);
 
 		/* Ok, we have a slot occupied by another node which
 		 * is not in the recovery map. We trylock his journal
@@ -1201,9 +1201,9 @@ int ocfs2_mark_dead_nodes(struct ocfs2_super *osb)
 			goto bail;
 		}
 
-		spin_lock(&si->si_lock);
+		spin_lock(&osb->osb_lock);
 	}
-	spin_unlock(&si->si_lock);
+	spin_unlock(&osb->osb_lock);
 
 	status = 0;
 bail:
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index f8f8661..67867b4 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -178,6 +178,7 @@ enum ocfs2_mount_options
 #define OCFS2_DEFAULT_ATIME_QUANTUM	60
 
 struct ocfs2_journal;
+struct ocfs2_slot_info;
 struct ocfs2_super
 {
 	struct task_struct *commit_task;
diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index f5727b8..762360d 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -42,13 +42,25 @@
 
 #include "buffer_head_io.h"
 
+struct ocfs2_slot_info {
+	struct inode *si_inode;
+	struct buffer_head *si_bh;
+	unsigned int si_num_slots;
+	unsigned int si_size;
+	s16 si_global_node_nums[OCFS2_MAX_SLOTS];
+};
+
+
 static s16 __ocfs2_node_num_to_slot(struct ocfs2_slot_info *si,
 				    s16 global);
 static void __ocfs2_fill_slot(struct ocfs2_slot_info *si,
 			      s16 slot_num,
 			      s16 node_num);
 
-/* post the slot information on disk into our slot_info struct. */
+/*
+ * Post the slot information on disk into our slot_info struct.
+ * Must be protected by osb_lock.
+ */
 static void ocfs2_update_slot_info(struct ocfs2_slot_info *si)
 {
 	int i;
@@ -56,13 +68,10 @@ static void ocfs2_update_slot_info(struct ocfs2_slot_info *si)
 
 	/* we don't read the slot block here as ocfs2_super_lock
 	 * should've made sure we have the most recent copy. */
-	spin_lock(&si->si_lock);
 	disk_info = (__le16 *) si->si_bh->b_data;
 
 	for (i = 0; i < si->si_size; i++)
 		si->si_global_node_nums[i] = le16_to_cpu(disk_info[i]);
-
-	spin_unlock(&si->si_lock);
 }
 
 int ocfs2_refresh_slot_info(struct ocfs2_super *osb)
@@ -76,8 +85,11 @@ int ocfs2_refresh_slot_info(struct ocfs2_super *osb)
 
 	bh = si->si_bh;
 	ret = ocfs2_read_block(osb, bh->b_blocknr, &bh, 0, si->si_inode);
-	if (ret == 0)
+	if (ret == 0) {
+		spin_lock(&osb->osb_lock);
 		ocfs2_update_slot_info(si);
+		spin_unlock(&osb->osb_lock);
+	}
 
 	return ret;
 }
@@ -90,10 +102,10 @@ static int ocfs2_update_disk_slots(struct ocfs2_super *osb,
 	int status, i;
 	__le16 *disk_info = (__le16 *) si->si_bh->b_data;
 
-	spin_lock(&si->si_lock);
+	spin_lock(&osb->osb_lock);
 	for (i = 0; i < si->si_size; i++)
 		disk_info[i] = cpu_to_le16(si->si_global_node_nums[i]);
-	spin_unlock(&si->si_lock);
+	spin_unlock(&osb->osb_lock);
 
 	status = ocfs2_write_block(osb, si->si_bh, si->si_inode);
 	if (status < 0)
@@ -119,7 +131,8 @@ static s16 __ocfs2_node_num_to_slot(struct ocfs2_slot_info *si,
 	return ret;
 }
 
-static s16 __ocfs2_find_empty_slot(struct ocfs2_slot_info *si, s16 preferred)
+static s16 __ocfs2_find_empty_slot(struct ocfs2_slot_info *si,
+				   s16 preferred)
 {
 	int i;
 	s16 ret = OCFS2_INVALID_SLOT;
@@ -141,15 +154,36 @@ out:
 	return ret;
 }
 
-s16 ocfs2_node_num_to_slot(struct ocfs2_slot_info *si,
-			   s16 global)
+int ocfs2_node_num_to_slot(struct ocfs2_super *osb, unsigned int node_num)
 {
-	s16 ret;
+	s16 slot;
+	struct ocfs2_slot_info *si = osb->slot_info;
 
-	spin_lock(&si->si_lock);
-	ret = __ocfs2_node_num_to_slot(si, global);
-	spin_unlock(&si->si_lock);
-	return ret;
+	spin_lock(&osb->osb_lock);
+	slot = __ocfs2_node_num_to_slot(si, node_num);
+	spin_unlock(&osb->osb_lock);
+
+	if (slot == OCFS2_INVALID_SLOT)
+		return -ENOENT;
+
+	return slot;
+}
+
+int ocfs2_slot_to_node_num_locked(struct ocfs2_super *osb, int slot_num,
+				  unsigned int *node_num)
+{
+	struct ocfs2_slot_info *si = osb->slot_info;
+
+	assert_spin_locked(&osb->osb_lock);
+
+	BUG_ON(slot_num < 0);
+	BUG_ON(slot_num > osb->max_slots);
+
+	if (si->si_global_node_nums[slot_num] == OCFS2_INVALID_SLOT)
+		return -ENOENT;
+
+	*node_num = si->si_global_node_nums[slot_num];
+	return 0;
 }
 
 static void __ocfs2_free_slot_info(struct ocfs2_slot_info *si)
@@ -184,9 +218,9 @@ int ocfs2_clear_slot(struct ocfs2_super *osb, s16 slot_num)
 	if (si == NULL)
 		return 0;
 
-	spin_lock(&si->si_lock);
+	spin_lock(&osb->osb_lock);
 	__ocfs2_fill_slot(si, slot_num, OCFS2_INVALID_SLOT);
-	spin_unlock(&si->si_lock);
+	spin_unlock(&osb->osb_lock);
 
 	return ocfs2_update_disk_slots(osb, osb->slot_info);
 }
@@ -206,7 +240,6 @@ int ocfs2_init_slot_info(struct ocfs2_super *osb)
 		goto bail;
 	}
 
-	spin_lock_init(&si->si_lock);
 	si->si_num_slots = osb->max_slots;
 	si->si_size = OCFS2_MAX_SLOTS;
 
@@ -235,7 +268,7 @@ int ocfs2_init_slot_info(struct ocfs2_super *osb)
 
 	si->si_inode = inode;
 	si->si_bh = bh;
-	osb->slot_info = si;
+	osb->slot_info = (struct ocfs2_slot_info *)si;
 bail:
 	if (status < 0 && si)
 		__ocfs2_free_slot_info(si);
@@ -261,9 +294,9 @@ int ocfs2_find_slot(struct ocfs2_super *osb)
 
 	si = osb->slot_info;
 
+	spin_lock(&osb->osb_lock);
 	ocfs2_update_slot_info(si);
 
-	spin_lock(&si->si_lock);
 	/* search for ourselves first and take the slot if it already
 	 * exists. Perhaps we need to mark this in a variable for our
 	 * own journal recovery? Possibly not, though we certainly
@@ -274,7 +307,7 @@ int ocfs2_find_slot(struct ocfs2_super *osb)
 		 * one. */
 		slot = __ocfs2_find_empty_slot(si, osb->preferred_slot);
 		if (slot == OCFS2_INVALID_SLOT) {
-			spin_unlock(&si->si_lock);
+			spin_unlock(&osb->osb_lock);
 			mlog(ML_ERROR, "no free slots available!\n");
 			status = -EINVAL;
 			goto bail;
@@ -285,7 +318,7 @@ int ocfs2_find_slot(struct ocfs2_super *osb)
 
 	__ocfs2_fill_slot(si, slot, osb->node_num);
 	osb->slot_num = slot;
-	spin_unlock(&si->si_lock);
+	spin_unlock(&osb->osb_lock);
 
 	mlog(0, "taking node slot %d\n", osb->slot_num);
 
@@ -306,12 +339,12 @@ void ocfs2_put_slot(struct ocfs2_super *osb)
 	if (!si)
 		return;
 
+	spin_lock(&osb->osb_lock);
 	ocfs2_update_slot_info(si);
 
-	spin_lock(&si->si_lock);
 	__ocfs2_fill_slot(si, osb->slot_num, OCFS2_INVALID_SLOT);
 	osb->slot_num = OCFS2_INVALID_SLOT;
-	spin_unlock(&si->si_lock);
+	spin_unlock(&osb->osb_lock);
 
 	status = ocfs2_update_disk_slots(osb, si);
 	if (status < 0) {
diff --git a/fs/ocfs2/slot_map.h b/fs/ocfs2/slot_map.h
index b029ffd..5118e89 100644
--- a/fs/ocfs2/slot_map.h
+++ b/fs/ocfs2/slot_map.h
@@ -27,16 +27,6 @@
 #ifndef SLOTMAP_H
 #define SLOTMAP_H
 
-struct ocfs2_slot_info {
-	spinlock_t si_lock;
-
-	struct inode *si_inode;
-	struct buffer_head *si_bh;
-	unsigned int si_num_slots;
-	unsigned int si_size;
-	s16 si_global_node_nums[OCFS2_MAX_SLOTS];
-};
-
 int ocfs2_init_slot_info(struct ocfs2_super *osb);
 void ocfs2_free_slot_info(struct ocfs2_super *osb);
 
@@ -45,17 +35,10 @@ void ocfs2_put_slot(struct ocfs2_super *osb);
 
 int ocfs2_refresh_slot_info(struct ocfs2_super *osb);
 
-s16 ocfs2_node_num_to_slot(struct ocfs2_slot_info *si,
-			   s16 global);
-int ocfs2_clear_slot(struct ocfs2_super *osb, s16 slot_num);
+int ocfs2_node_num_to_slot(struct ocfs2_super *osb, unsigned int node_num);
+int ocfs2_slot_to_node_num_locked(struct ocfs2_super *osb, int slot_num,
+				  unsigned int *node_num);
 
-static inline int ocfs2_is_empty_slot(struct ocfs2_slot_info *si,
-				      int slot_num)
-{
-	BUG_ON(slot_num == OCFS2_INVALID_SLOT);
-	assert_spin_locked(&si->si_lock);
-
-	return si->si_global_node_nums[slot_num] == OCFS2_INVALID_SLOT;
-}
+int ocfs2_clear_slot(struct ocfs2_super *osb, s16 slot_num);
 
 #endif
-- 
1.5.2.2
