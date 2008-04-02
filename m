From: Mark Fasheh <mfasheh@suse.com>
Date: Wed,  2 Apr 2008 13:14:16 -0700
Subject: [Ocfs2-devel] [PATCH 06/62] ocfs2: Define the contents of the
	slot_map file.
In-Reply-To: <12071673282579-git-send-email-mfasheh@suse.com>
References: <12071673121124-git-send-email-mfasheh@suse.com>
	<1207167318479-git-send-email-mfasheh@suse.com>
	<12071673203909-git-send-email-mfasheh@suse.com>
	<12071673232465-git-send-email-mfasheh@suse.com>
	<12071673263948-git-send-email-mfasheh@suse.com>
	<12071673282579-git-send-email-mfasheh@suse.com>
Message-ID: <1207167330482-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>

From: Joel Becker <joel.becker@oracle.com>

The slot map file is merely an array of __le16.  Wrap it in a structure for
cleaner reference.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/ocfs2_fs.h |   12 ++++++++++++
 fs/ocfs2/slot_map.c |   15 ++++++++-------
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 3633edd..3299116 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -475,6 +475,18 @@ struct ocfs2_extent_block
 };
 
 /*
+ * On disk slot map for OCFS2.  This defines the contents of the "slot_map"
+ * system file.
+ */
+struct ocfs2_slot_map {
+/*00*/	__le16 sm_slots[0];
+/*
+ * Actual on-disk size is one block.  OCFS2_MAX_SLOTS is 255,
+ * 255 * sizeof(__le16) == 512B, within the 512B block minimum blocksize.
+ */
+};
+
+/*
  * On disk superblock for OCFS2
  * Note that it is contained inside an ocfs2_dinode, so all offsets
  * are relative to the start of ocfs2_dinode.id2.
diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index 65a61bf..e7e7a74 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -85,17 +85,17 @@ static void ocfs2_set_slot(struct ocfs2_slot_info *si,
 static void ocfs2_update_slot_info(struct ocfs2_slot_info *si)
 {
 	int i;
-	__le16 *disk_info;
+	struct ocfs2_slot_map *sm;
 
 	/* we don't read the slot block here as ocfs2_super_lock
 	 * should've made sure we have the most recent copy. */
-	disk_info = (__le16 *) si->si_bh[0]->b_data;
+	sm = (struct ocfs2_slot_map *)si->si_bh[0]->b_data;
 
 	for (i = 0; i < si->si_num_slots; i++) {
-		if (le16_to_cpu(disk_info[i]) == (u16)OCFS2_INVALID_SLOT)
+		if (le16_to_cpu(sm->sm_slots[i]) == (u16)OCFS2_INVALID_SLOT)
 			ocfs2_invalidate_slot(si, i);
 		else
-			ocfs2_set_slot(si, i, le16_to_cpu(disk_info[i]));
+			ocfs2_set_slot(si, i, le16_to_cpu(sm->sm_slots[i]));
 	}
 }
 
@@ -135,15 +135,16 @@ static int ocfs2_update_disk_slots(struct ocfs2_super *osb,
 				   struct ocfs2_slot_info *si)
 {
 	int status, i;
-	__le16 *disk_info = (__le16 *) si->si_bh[0]->b_data;
+	struct ocfs2_slot_map *sm;
 
 	spin_lock(&osb->osb_lock);
+	sm = (struct ocfs2_slot_map *)si->si_bh[0]->b_data;
 	for (i = 0; i < si->si_num_slots; i++) {
 		if (si->si_slots[i].sl_valid)
-			disk_info[i] =
+			sm->sm_slots[i] =
 				cpu_to_le16(si->si_slots[i].sl_node_num);
 		else
-			disk_info[i] = cpu_to_le16(OCFS2_INVALID_SLOT);
+			sm->sm_slots[i] = cpu_to_le16(OCFS2_INVALID_SLOT);
 	}
 	spin_unlock(&osb->osb_lock);
 
-- 
1.5.4.1
