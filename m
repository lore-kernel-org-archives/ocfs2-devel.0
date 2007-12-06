From: Joel Becker <joel.becker@oracle.com>
Date: Thu Dec  6 21:21:40 2007
Subject: [Ocfs2-devel] [PATCH 7/7] ocfs2: New slot map format
In-Reply-To: <1197004787-15344-1-git-send-email-joel.becker@oracle.com>
References: <1197004787-15344-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1197004787-15344-8-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The old slot map had a few limitations:

- It was limited to one block, so the maximum slot count was 255.
- Each slot was signed 16bits, limiting node numbers to INT16_MAX.
- An empty slot was marked by the magic 0xFFFF (-1).

The new slot map format provides 32bit node numbers (UINT32_MAX), a
separate space to mark a slot in use, and extra room to grow.  The slot
map is now bounded by i_size, not a block.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/ocfs2.h    |    6 +++
 fs/ocfs2/ocfs2_fs.h |   31 ++++++++++++++-
 fs/ocfs2/slot_map.c |  107 ++++++++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 128 insertions(+), 16 deletions(-)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 5bb5b07..36a9e09 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -363,6 +363,12 @@ static inline int ocfs2_mount_local(struct ocfs2_super *osb)
 	return (osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_LOCAL_MOUNT);
 }
 
+static inline int ocfs2_uses_extended_slot_map(struct ocfs2_super *osb)
+{
+	return (osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_EXTENDED_SLOT_MAP);
+}
+
+
 #define OCFS2_IS_VALID_DINODE(ptr)					\
 	(!strcmp((ptr)->i_signature, OCFS2_INODE_SIGNATURE))
 
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 26a5565..85a2b21 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -88,7 +88,8 @@
 #define OCFS2_FEATURE_COMPAT_SUPP	OCFS2_FEATURE_COMPAT_BACKUP_SB
 #define OCFS2_FEATURE_INCOMPAT_SUPP	(OCFS2_FEATURE_INCOMPAT_LOCAL_MOUNT \
 					 | OCFS2_FEATURE_INCOMPAT_SPARSE_ALLOC \
-					 | OCFS2_FEATURE_INCOMPAT_INLINE_DATA)
+					 | OCFS2_FEATURE_INCOMPAT_INLINE_DATA \
+					 | OCFS2_FEATURE_INCOMPAT_EXTENDED_SLOT_MAP)
 #define OCFS2_FEATURE_RO_COMPAT_SUPP	OCFS2_FEATURE_RO_COMPAT_UNWRITTEN
 
 /*
@@ -125,6 +126,10 @@
 /* Support for data packed into inode blocks */
 #define OCFS2_FEATURE_INCOMPAT_INLINE_DATA	0x0040
 
+/* Support for the extended slot map */
+#define OCFS2_FEATURE_INCOMPAT_EXTENDED_SLOT_MAP 0x100
+
+
 /*
  * backup superblock flag is used to indicate that this volume
  * has backup superblocks.
@@ -454,7 +459,8 @@ struct ocfs2_extent_block
 
 /*
  * On disk slot map for OCFS2.  This defines the contents of the "slot_map"
- * system file.
+ * system file.  A slot is valid if it contains a node number >= 0.  The
+ * value -1 (0xFFFF) is OCFS2_INVALID_SLOT.  This marks a slot empty.
  */
 struct ocfs2_slot_map {
 /*00*/	__le16 sm_slots[0];
@@ -464,6 +470,27 @@ struct ocfs2_slot_map {
  */
 };
 
+struct ocfs2_extended_slot {
+/*00*/	__u8	es_valid;
+	__u8	es_reserved1[3];
+	__le32	es_node_num;
+/*10*/
+};
+
+/*
+ * The extended slot map, used when OCFS2_FEATURE_INCOMPAT_EXTENDED_SLOT_MAP
+ * is set.  It separates out the valid marker from the node number, and
+ * has room to grow.  Unlike the old slot map, this format is defined by
+ * i_size.
+ */
+struct ocfs2_slot_map_extended {
+/*00*/	struct ocfs2_extended_slot se_slots[0];
+/*
+ * Actual size is i_size of the slot_map system file.  It should
+ * match s_max_slots * sizeof(struct ocfs2_extended_slot)
+ */
+};
+
 /*
  * On disk superblock for OCFS2
  * Note that it is contained inside an ocfs2_dinode, so all offsets
diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index a458d08..005a7dc 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -51,6 +51,8 @@ struct ocfs2_slot {
 struct ocfs2_slot_info_real {
 	spinlock_t si_lock;
 
+	int si_extended;
+	int si_slots_per_block;
 	struct inode *si_inode;
 	unsigned int si_blocks;
 	struct buffer_head **si_bh;
@@ -85,15 +87,33 @@ static void ocfs2_set_slot(struct ocfs2_slot_info_real *si,
 	si->si_slots[slot_num].sl_node_num = node_num;
 }
 
+/* This version is for the extended slot map */
+static void ocfs2_update_slot_info_extended(struct ocfs2_slot_info_real *si)
+{
+	int b, i, slotno;
+	struct ocfs2_slot_map_extended *se;
+
+	slotno = 0;
+	for (b = 0; b < si->si_blocks; b++) {
+		se = (struct ocfs2_slot_map_extended *)si->si_bh[b]->b_data;
+		for (i = 0;
+		     (i < si->si_slots_per_block) && (slotno < si->si_num_slots);
+		     i++, slotno++) {
+			if (se->se_slots[i].es_valid)
+				ocfs2_set_slot(si, slotno,
+					       le32_to_cpu(se->se_slots[i].es_node_num));
+			else
+				ocfs2_invalidate_slot(si, slotno);
+		}
+	}
+}
+
 /* post the slot information on disk into our slot_info struct. */
-static void ocfs2_update_slot_info(struct ocfs2_slot_info_real *si)
+static void ocfs2_update_slot_info_old(struct ocfs2_slot_info_real *si)
 {
 	int i;
 	struct ocfs2_slot_map *sm;
 
-	/* we don't read the slot block here as ocfs2_super_lock
-	 * should've made sure we have the most recent copy. */
-	spin_lock(&si->si_lock);
 	sm = (struct ocfs2_slot_map *)si->si_bh[0]->b_data;
 
 	for (i = 0; i < si->si_num_slots; i++) {
@@ -102,7 +122,17 @@ static void ocfs2_update_slot_info(struct ocfs2_slot_info_real *si)
 		else
 			ocfs2_set_slot(si, i, le16_to_cpu(sm->sm_slots[i]));
 	}
+}
 
+static void ocfs2_update_slot_info(struct ocfs2_slot_info_real *si)
+{
+	/* we don't read the slot block here as ocfs2_super_lock
+	 * should've made sure we have the most recent copy. */
+	spin_lock(&si->si_lock);
+	if (si->si_extended)
+		ocfs2_update_slot_info_extended(si);
+	else
+		ocfs2_update_slot_info_old(si);
 	spin_unlock(&si->si_lock);
 }
 
@@ -135,13 +165,31 @@ int ocfs2_refresh_slot_info(struct ocfs2_super *osb)
 
 /* post the our slot info stuff into it's destination bh and write it
  * out. */
-static int ocfs2_update_disk_slots(struct ocfs2_super *osb,
-				   struct ocfs2_slot_info_real *si)
+static void ocfs2_update_disk_slot_extended(struct ocfs2_slot_info_real *si,
+					    int slot_num,
+					    struct buffer_head **bh)
+{
+	int blkind = slot_num / si->si_slots_per_block;
+	int slotno = slot_num % si->si_slots_per_block;
+	struct ocfs2_slot_map_extended *se;
+
+	BUG_ON(blkind >= si->si_blocks);
+
+	se = (struct ocfs2_slot_map_extended *)si->si_bh[blkind]->b_data;
+	se->se_slots[slotno].es_valid = si->si_slots[slot_num].sl_valid;
+	if (si->si_slots[slot_num].sl_valid)
+		se->se_slots[slotno].es_node_num =
+			cpu_to_le32(si->si_slots[slot_num].sl_node_num);
+	*bh = si->si_bh[blkind];
+}
+
+static void ocfs2_update_disk_slot_old(struct ocfs2_slot_info_real *si,
+				       int slot_num,
+				       struct buffer_head **bh)
 {
-	int status, i;
+	int i;
 	struct ocfs2_slot_map *sm;
 
-	spin_lock(&si->si_lock);
 	sm = (struct ocfs2_slot_map *)si->si_bh[0]->b_data;
 	for (i = 0; i < si->si_num_slots; i++) {
 		if (si->si_slots[i].sl_valid)
@@ -150,9 +198,24 @@ static int ocfs2_update_disk_slots(struct ocfs2_super *osb,
 		else
 			sm->sm_slots[i] = cpu_to_le16(OCFS2_INVALID_SLOT);
 	}
+	*bh = si->si_bh[0];
+}
+
+static int ocfs2_update_disk_slot(struct ocfs2_super *osb,
+				  struct ocfs2_slot_info_real *si,
+				  int slot_num)
+{
+	int status;
+	struct buffer_head *bh;
+
+	spin_lock(&si->si_lock);
+	if (si->si_extended)
+		ocfs2_update_disk_slot_extended(si, slot_num, &bh);
+	else
+		ocfs2_update_disk_slot_old(si, slot_num, &bh);
 	spin_unlock(&si->si_lock);
 
-	status = ocfs2_write_block(osb, si->si_bh[0], si->si_inode);
+	status = ocfs2_write_block(osb, bh, si->si_inode);
 	if (status < 0)
 		mlog_errno(status);
 
@@ -169,7 +232,12 @@ static int ocfs2_slot_map_physical_size(struct ocfs2_super *osb,
 {
 	unsigned long long bytes_needed;
 
-	bytes_needed = osb->max_slots * sizeof(__le16);
+	if (ocfs2_uses_extended_slot_map(osb)) {
+		bytes_needed = osb->max_slots *
+			sizeof(struct ocfs2_extended_slot);
+	} else {
+		bytes_needed = osb->max_slots * sizeof(__le16);
+	}
 	if (bytes_needed > i_size_read(inode)) {
 		mlog(ML_ERROR,
 		     "Slot map file is too small!  (size %llu, needed %llu)\n",
@@ -283,7 +351,7 @@ int ocfs2_clear_slot(struct ocfs2_super *osb, int slot_num)
 	ocfs2_invalidate_slot(si, slot_num);
 	spin_unlock(&si->si_lock);
 
-	return ocfs2_update_disk_slots(osb, to_slot_info(osb));
+	return ocfs2_update_disk_slot(osb, to_slot_info(osb), slot_num);
 }
 
 static int ocfs2_map_slot_buffers(struct ocfs2_super *osb,
@@ -305,6 +373,15 @@ static int ocfs2_map_slot_buffers(struct ocfs2_super *osb,
 	if (!si->si_blocks)
 		goto bail;
 
+	if (si->si_extended)
+		si->si_slots_per_block =
+			osb->sb->s_blocksize / sizeof(struct ocfs2_extended_slot);
+	else
+		si->si_slots_per_block = osb->sb->s_blocksize / sizeof(__le16);
+
+	/* The size checks above should ensure this */
+	BUG_ON((osb->max_slots / si->si_slots_per_block) > blocks);
+
 	mlog(0, "Slot map needs %u buffers for %llu bytes\n",
 	     si->si_blocks, bytes);
 
@@ -357,6 +434,7 @@ int ocfs2_init_slot_info(struct ocfs2_super *osb)
 	}
 
 	spin_lock_init(&si->si_lock);
+	si->si_extended = ocfs2_uses_extended_slot_map(osb);
 	si->si_num_slots = osb->max_slots;
 	si->si_slots = (struct ocfs2_slot *)((char *)si + sizeof(struct ocfs2_slot_info_real));
 
@@ -429,7 +507,7 @@ int ocfs2_find_slot(struct ocfs2_super *osb)
 
 	mlog(0, "taking node slot %d\n", osb->slot_num);
 
-	status = ocfs2_update_disk_slots(osb, si);
+	status = ocfs2_update_disk_slot(osb, si, osb->slot_num);
 	if (status < 0)
 		mlog_errno(status);
 
@@ -440,7 +518,7 @@ bail:
 
 void ocfs2_put_slot(struct ocfs2_super *osb)
 {
-	int status;
+	int status, slot_num;
 	struct ocfs2_slot_info_real *si = to_slot_info(osb);
 
 	if (!si)
@@ -449,11 +527,12 @@ void ocfs2_put_slot(struct ocfs2_super *osb)
 	ocfs2_update_slot_info(si);
 
 	spin_lock(&si->si_lock);
+	slot_num = osb->slot_num;
 	ocfs2_invalidate_slot(si, osb->slot_num);
 	osb->slot_num = OCFS2_INVALID_SLOT;
 	spin_unlock(&si->si_lock);
 
-	status = ocfs2_update_disk_slots(osb, si);
+	status = ocfs2_update_disk_slot(osb, si, slot_num);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
-- 
1.5.2.2
