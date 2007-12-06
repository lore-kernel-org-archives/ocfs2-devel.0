From: Joel Becker <joel.becker@oracle.com>
Date: Thu Dec  6 21:21:41 2007
Subject: [Ocfs2-devel] [PATCH 2/7] ocfs2: Wrap all other access to
	ocfs2_slot_info.
In-Reply-To: <1197004787-15344-1-git-send-email-joel.becker@oracle.com>
References: <1197004787-15344-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1197004787-15344-3-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The last place to reference naked slot_info fields is
ocfs2_mark_nodes_dirty().  It's part of the mount path, and it races
node down events, so the locking must be honored.  We basically wrap the
check for what node is in each slot, thus allowing us to change the
mechanism on the backend.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/journal.c  |   15 +++++----
 fs/ocfs2/slot_map.c |   84 +++++++++++++++++++++++++++++++++++++--------------
 fs/ocfs2/slot_map.h |   21 ++----------
 3 files changed, 73 insertions(+), 47 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index da63375..c1d692b 100644
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
@@ -1169,20 +1168,22 @@ bail:
  * slot info struct has been updated from disk. */
 int ocfs2_mark_dead_nodes(struct ocfs2_super *osb)
 {
-	int status, i, node_num;
+	unsigned int node_num;
+	int status, i;
 	struct ocfs2_slot_info *si = osb->slot_info;
 
 	/* This is called with the super block cluster lock, so we
 	 * know that the slot map can't change underneath us. */
 
 	spin_lock(&si->si_lock);
-	for(i = 0; i < si->si_num_slots; i++) {
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
 		spin_unlock(&si->si_lock);
diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index f5727b8..a4f2c02 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -42,14 +42,30 @@
 
 #include "buffer_head_io.h"
 
-static s16 __ocfs2_node_num_to_slot(struct ocfs2_slot_info *si,
+struct ocfs2_slot_info_real {
+	spinlock_t si_lock;
+
+	struct inode *si_inode;
+	struct buffer_head *si_bh;
+	unsigned int si_num_slots;
+	unsigned int si_size;
+	s16 si_global_node_nums[OCFS2_MAX_SLOTS];
+};
+
+static inline struct ocfs2_slot_info_real *to_slot_info(struct ocfs2_super *osb)
+{
+	return (struct ocfs2_slot_info_real *)osb->slot_info;
+}
+
+
+static s16 __ocfs2_node_num_to_slot(struct ocfs2_slot_info_real *si,
 				    s16 global);
-static void __ocfs2_fill_slot(struct ocfs2_slot_info *si,
+static void __ocfs2_fill_slot(struct ocfs2_slot_info_real *si,
 			      s16 slot_num,
 			      s16 node_num);
 
 /* post the slot information on disk into our slot_info struct. */
-static void ocfs2_update_slot_info(struct ocfs2_slot_info *si)
+static void ocfs2_update_slot_info(struct ocfs2_slot_info_real *si)
 {
 	int i;
 	__le16 *disk_info;
@@ -68,7 +84,7 @@ static void ocfs2_update_slot_info(struct ocfs2_slot_info *si)
 int ocfs2_refresh_slot_info(struct ocfs2_super *osb)
 {
 	int ret;
-	struct ocfs2_slot_info *si = osb->slot_info;
+	struct ocfs2_slot_info_real *si = to_slot_info(osb);
 	struct buffer_head *bh;
 
 	if (si == NULL)
@@ -85,7 +101,7 @@ int ocfs2_refresh_slot_info(struct ocfs2_super *osb)
 /* post the our slot info stuff into it's destination bh and write it
  * out. */
 static int ocfs2_update_disk_slots(struct ocfs2_super *osb,
-				   struct ocfs2_slot_info *si)
+				   struct ocfs2_slot_info_real *si)
 {
 	int status, i;
 	__le16 *disk_info = (__le16 *) si->si_bh->b_data;
@@ -104,7 +120,7 @@ static int ocfs2_update_disk_slots(struct ocfs2_super *osb,
 
 /* try to find global node in the slot info. Returns
  * OCFS2_INVALID_SLOT if nothing is found. */
-static s16 __ocfs2_node_num_to_slot(struct ocfs2_slot_info *si,
+static s16 __ocfs2_node_num_to_slot(struct ocfs2_slot_info_real *si,
 				    s16 global)
 {
 	int i;
@@ -119,7 +135,8 @@ static s16 __ocfs2_node_num_to_slot(struct ocfs2_slot_info *si,
 	return ret;
 }
 
-static s16 __ocfs2_find_empty_slot(struct ocfs2_slot_info *si, s16 preferred)
+static s16 __ocfs2_find_empty_slot(struct ocfs2_slot_info_real *si,
+				   s16 preferred)
 {
 	int i;
 	s16 ret = OCFS2_INVALID_SLOT;
@@ -141,18 +158,39 @@ out:
 	return ret;
 }
 
-s16 ocfs2_node_num_to_slot(struct ocfs2_slot_info *si,
-			   s16 global)
+int ocfs2_node_num_to_slot(struct ocfs2_super *osb, unsigned int node_num)
 {
-	s16 ret;
+	s16 slot;
+	struct ocfs2_slot_info_real *si = to_slot_info(osb);
 
 	spin_lock(&si->si_lock);
-	ret = __ocfs2_node_num_to_slot(si, global);
+	slot = __ocfs2_node_num_to_slot(si, node_num);
 	spin_unlock(&si->si_lock);
-	return ret;
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
+	struct ocfs2_slot_info_real *si = to_slot_info(osb);
+
+	assert_spin_locked(&si->si_lock);
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
 
-static void __ocfs2_free_slot_info(struct ocfs2_slot_info *si)
+static void __ocfs2_free_slot_info(struct ocfs2_slot_info_real *si)
 {
 	if (si == NULL)
 		return;
@@ -165,7 +203,7 @@ static void __ocfs2_free_slot_info(struct ocfs2_slot_info *si)
 	kfree(si);
 }
 
-static void __ocfs2_fill_slot(struct ocfs2_slot_info *si,
+static void __ocfs2_fill_slot(struct ocfs2_slot_info_real *si,
 			      s16 slot_num,
 			      s16 node_num)
 {
@@ -179,7 +217,7 @@ static void __ocfs2_fill_slot(struct ocfs2_slot_info *si,
 
 int ocfs2_clear_slot(struct ocfs2_super *osb, s16 slot_num)
 {
-	struct ocfs2_slot_info *si = osb->slot_info;
+	struct ocfs2_slot_info_real *si = to_slot_info(osb);
 
 	if (si == NULL)
 		return 0;
@@ -188,7 +226,7 @@ int ocfs2_clear_slot(struct ocfs2_super *osb, s16 slot_num)
 	__ocfs2_fill_slot(si, slot_num, OCFS2_INVALID_SLOT);
 	spin_unlock(&si->si_lock);
 
-	return ocfs2_update_disk_slots(osb, osb->slot_info);
+	return ocfs2_update_disk_slots(osb, to_slot_info(osb));
 }
 
 int ocfs2_init_slot_info(struct ocfs2_super *osb)
@@ -197,9 +235,9 @@ int ocfs2_init_slot_info(struct ocfs2_super *osb)
 	u64 blkno;
 	struct inode *inode = NULL;
 	struct buffer_head *bh = NULL;
-	struct ocfs2_slot_info *si;
+	struct ocfs2_slot_info_real *si;
 
-	si = kzalloc(sizeof(struct ocfs2_slot_info), GFP_KERNEL);
+	si = kzalloc(sizeof(struct ocfs2_slot_info_real), GFP_KERNEL);
 	if (!si) {
 		status = -ENOMEM;
 		mlog_errno(status);
@@ -235,7 +273,7 @@ int ocfs2_init_slot_info(struct ocfs2_super *osb)
 
 	si->si_inode = inode;
 	si->si_bh = bh;
-	osb->slot_info = si;
+	osb->slot_info = (struct ocfs2_slot_info *)si;
 bail:
 	if (status < 0 && si)
 		__ocfs2_free_slot_info(si);
@@ -245,7 +283,7 @@ bail:
 
 void ocfs2_free_slot_info(struct ocfs2_super *osb)
 {
-	struct ocfs2_slot_info *si = osb->slot_info;
+	struct ocfs2_slot_info_real *si = to_slot_info(osb);
 
 	osb->slot_info = NULL;
 	__ocfs2_free_slot_info(si);
@@ -255,11 +293,11 @@ int ocfs2_find_slot(struct ocfs2_super *osb)
 {
 	int status;
 	s16 slot;
-	struct ocfs2_slot_info *si;
+	struct ocfs2_slot_info_real *si;
 
 	mlog_entry_void();
 
-	si = osb->slot_info;
+	si = to_slot_info(osb);
 
 	ocfs2_update_slot_info(si);
 
@@ -301,7 +339,7 @@ bail:
 void ocfs2_put_slot(struct ocfs2_super *osb)
 {
 	int status;
-	struct ocfs2_slot_info *si = osb->slot_info;
+	struct ocfs2_slot_info_real *si = to_slot_info(osb);
 
 	if (!si)
 		return;
diff --git a/fs/ocfs2/slot_map.h b/fs/ocfs2/slot_map.h
index b029ffd..14b065b 100644
--- a/fs/ocfs2/slot_map.h
+++ b/fs/ocfs2/slot_map.h
@@ -29,12 +29,6 @@
 
 struct ocfs2_slot_info {
 	spinlock_t si_lock;
-
-	struct inode *si_inode;
-	struct buffer_head *si_bh;
-	unsigned int si_num_slots;
-	unsigned int si_size;
-	s16 si_global_node_nums[OCFS2_MAX_SLOTS];
 };
 
 int ocfs2_init_slot_info(struct ocfs2_super *osb);
@@ -45,17 +39,10 @@ void ocfs2_put_slot(struct ocfs2_super *osb);
 
 int ocfs2_refresh_slot_info(struct ocfs2_super *osb);
 
-s16 ocfs2_node_num_to_slot(struct ocfs2_slot_info *si,
-			   s16 global);
-int ocfs2_clear_slot(struct ocfs2_super *osb, s16 slot_num);
-
-static inline int ocfs2_is_empty_slot(struct ocfs2_slot_info *si,
-				      int slot_num)
-{
-	BUG_ON(slot_num == OCFS2_INVALID_SLOT);
-	assert_spin_locked(&si->si_lock);
+int ocfs2_node_num_to_slot(struct ocfs2_super *osb, unsigned int node_num);
+int ocfs2_slot_to_node_num_locked(struct ocfs2_super *osb, int slot_num,
+				  unsigned int *node_num);
 
-	return si->si_global_node_nums[slot_num] == OCFS2_INVALID_SLOT;
-}
+int ocfs2_clear_slot(struct ocfs2_super *osb, s16 slot_num);
 
 #endif
-- 
1.5.2.2
