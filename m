From: Joel Becker <joel.becker@oracle.com>
Date: Thu Dec  6 21:21:37 2007
Subject: [Ocfs2-devel] [PATCH 4/7] ocfs2: slot_map I/O based on i_size.
In-Reply-To: <1197004787-15344-1-git-send-email-joel.becker@oracle.com>
References: <1197004787-15344-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1197004787-15344-5-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The slot map code assumed a slot_map file has one block allocated.
This changes the code to I/O as many blocks as will cover i_size.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/slot_map.c |  128 +++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 108 insertions(+), 20 deletions(-)

diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index a4f2c02..fd08592 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -46,7 +46,8 @@ struct ocfs2_slot_info_real {
 	spinlock_t si_lock;
 
 	struct inode *si_inode;
-	struct buffer_head *si_bh;
+	unsigned int si_blocks;
+	struct buffer_head **si_bh;
 	unsigned int si_num_slots;
 	unsigned int si_size;
 	s16 si_global_node_nums[OCFS2_MAX_SLOTS];
@@ -73,7 +74,7 @@ static void ocfs2_update_slot_info(struct ocfs2_slot_info_real *si)
 	/* we don't read the slot block here as ocfs2_super_lock
 	 * should've made sure we have the most recent copy. */
 	spin_lock(&si->si_lock);
-	disk_info = (__le16 *) si->si_bh->b_data;
+	disk_info = (__le16 *) si->si_bh[0]->b_data;
 
 	for (i = 0; i < si->si_size; i++)
 		si->si_global_node_nums[i] = le16_to_cpu(disk_info[i]);
@@ -85,13 +86,23 @@ int ocfs2_refresh_slot_info(struct ocfs2_super *osb)
 {
 	int ret;
 	struct ocfs2_slot_info_real *si = to_slot_info(osb);
-	struct buffer_head *bh;
 
 	if (si == NULL)
 		return 0;
 
-	bh = si->si_bh;
-	ret = ocfs2_read_block(osb, bh->b_blocknr, &bh, 0, si->si_inode);
+	BUG_ON(si->si_blocks == 0);
+	BUG_ON(si->si_bh == NULL);
+
+	mlog(0, "Refreshing slot map, reading %u block(s)\n",
+	     si->si_blocks);
+
+	/*
+	 * We pass -1 as blocknr because we expect all of si->si_bh to
+	 * be !NULL.  Thus, ocfs2_read_blocks() will ignore blocknr.  If
+	 * this is not true, the read of -1 (UINT64_MAX) will fail.
+	 */
+	ret = ocfs2_read_blocks(osb, -1, si->si_blocks, si->si_bh, 0,
+				si->si_inode);
 	if (ret == 0)
 		ocfs2_update_slot_info(si);
 
@@ -104,20 +115,42 @@ static int ocfs2_update_disk_slots(struct ocfs2_super *osb,
 				   struct ocfs2_slot_info_real *si)
 {
 	int status, i;
-	__le16 *disk_info = (__le16 *) si->si_bh->b_data;
+	__le16 *disk_info = (__le16 *) si->si_bh[0]->b_data;
 
 	spin_lock(&si->si_lock);
 	for (i = 0; i < si->si_size; i++)
 		disk_info[i] = cpu_to_le16(si->si_global_node_nums[i]);
 	spin_unlock(&si->si_lock);
 
-	status = ocfs2_write_block(osb, si->si_bh, si->si_inode);
+	status = ocfs2_write_block(osb, si->si_bh[0], si->si_inode);
 	if (status < 0)
 		mlog_errno(status);
 
 	return status;
 }
 
+/*
+ * Calculate how many bytes are needed by the slot map.  Returns
+ * an error if the slot map file is too small.
+ */
+static int ocfs2_slot_map_physical_size(struct ocfs2_super *osb,
+					struct inode *inode,
+					unsigned long long *bytes)
+{
+	unsigned long long bytes_needed;
+
+	bytes_needed = osb->max_slots * sizeof(__le16);
+	if (bytes_needed < i_size_read(inode)) {
+		mlog(ML_ERROR,
+		     "Slot map file is too small!  (size %llu, needed %llu)\n",
+		     i_size_read(inode), bytes_needed);
+		return -ENOSPC;
+	}
+
+	*bytes = bytes_needed;
+	return 0;
+}
+
 /* try to find global node in the slot info. Returns
  * OCFS2_INVALID_SLOT if nothing is found. */
 static s16 __ocfs2_node_num_to_slot(struct ocfs2_slot_info_real *si,
@@ -192,13 +225,22 @@ int ocfs2_slot_to_node_num_locked(struct ocfs2_super *osb, int slot_num,
 
 static void __ocfs2_free_slot_info(struct ocfs2_slot_info_real *si)
 {
+	unsigned int i;
+
 	if (si == NULL)
 		return;
 
 	if (si->si_inode)
 		iput(si->si_inode);
-	if (si->si_bh)
-		brelse(si->si_bh);
+	if (si->si_bh) {
+		for (i = 0; i < si->si_blocks; i++) {
+			if (si->si_bh[i]) {
+				brelse(si->si_bh[i]);
+				si->si_bh[i] = NULL;
+			}
+		}
+		kfree(si->si_bh);
+	}
 
 	kfree(si);
 }
@@ -229,12 +271,65 @@ int ocfs2_clear_slot(struct ocfs2_super *osb, s16 slot_num)
 	return ocfs2_update_disk_slots(osb, to_slot_info(osb));
 }
 
+static int ocfs2_map_slot_buffers(struct ocfs2_super *osb,
+				  struct ocfs2_slot_info_real *si)
+{
+	int status = 0;
+	u64 blkno;
+	unsigned long long blocks, bytes;
+	unsigned int i;
+	struct buffer_head *bh;
+
+	status = ocfs2_slot_map_physical_size(osb, si->si_inode, &bytes);
+	if (status)
+		goto bail;
+
+	blocks = ocfs2_blocks_for_bytes(si->si_inode->i_sb, bytes);
+	BUG_ON(blocks > UINT_MAX);
+	si->si_blocks = blocks;
+	if (!si->si_blocks)
+		goto bail;
+
+	mlog(0, "Slot map needs %u buffers for %llu bytes\n",
+	     si->si_blocks, bytes);
+
+	si->si_bh = kzalloc(sizeof(struct buffer_head *) * si->si_blocks,
+			    GFP_KERNEL);
+	if (!si->si_bh) {
+		status = -ENOMEM;
+		mlog_errno(status);
+		goto bail;
+	}
+
+	for (i = 0; i < si->si_blocks; i++) {
+		status = ocfs2_extent_map_get_blocks(si->si_inode, i,
+						     &blkno, NULL, NULL);
+		if (status < 0) {
+			mlog_errno(status);
+			goto bail;
+		}
+
+		mlog(0, "Reading slot map block %u@%llu\n", i,
+		     (unsigned long long)blkno);
+
+		bh = NULL;  /* Acquire a fresh bh */
+		status = ocfs2_read_block(osb, blkno, &bh, 0, si->si_inode);
+		if (status < 0) {
+			mlog_errno(status);
+			goto bail;
+		}
+
+		si->si_bh[i] = bh;
+	}
+
+bail:
+	return status;
+}
+
 int ocfs2_init_slot_info(struct ocfs2_super *osb)
 {
 	int status, i;
-	u64 blkno;
 	struct inode *inode = NULL;
-	struct buffer_head *bh = NULL;
 	struct ocfs2_slot_info_real *si;
 
 	si = kzalloc(sizeof(struct ocfs2_slot_info_real), GFP_KERNEL);
@@ -259,20 +354,13 @@ int ocfs2_init_slot_info(struct ocfs2_super *osb)
 		goto bail;
 	}
 
-	status = ocfs2_extent_map_get_blocks(inode, 0ULL, &blkno, NULL, NULL);
-	if (status < 0) {
-		mlog_errno(status);
-		goto bail;
-	}
-
-	status = ocfs2_read_block(osb, blkno, &bh, 0, inode);
+	si->si_inode = inode;
+	status = ocfs2_map_slot_buffers(osb, si);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
 	}
 
-	si->si_inode = inode;
-	si->si_bh = bh;
 	osb->slot_info = (struct ocfs2_slot_info *)si;
 bail:
 	if (status < 0 && si)
-- 
1.5.2.2
