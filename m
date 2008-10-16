From: Joel Becker <joel.becker@oracle.com>
Date: Thu, 16 Oct 2008 02:38:49 -0700
Subject: [Ocfs2-devel] [PATCH 5/8] ocfs2: Morph the haphazard
	OCFS2_IS_VALID_GROUP_DESC() checks.
In-Reply-To: <1224149932-24381-1-git-send-email-joel.becker@oracle.com>
References: <1224149932-24381-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1224149932-24381-6-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Random places in the code would check a group descriptor bh to see if it
was valid. The previous commit unified descriptor block reads,
validating all block reads in the same place.  Thus, these checks are no
longer necessary.  Rather than eliminate them, however, we change them
to BUG_ON() checks.  This ensures the assumptions remain true.  All of
the code paths to these checks have been audited to ensure they come
from a validated descriptor read.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/ocfs2.h    |    7 -------
 fs/ocfs2/suballoc.c |   39 ++++++++++++++-------------------------
 2 files changed, 14 insertions(+), 32 deletions(-)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 7ea38ac..8fc78d8 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -457,13 +457,6 @@ static inline int ocfs2_uses_extended_slot_map(struct ocfs2_super *osb)
 #define OCFS2_IS_VALID_GROUP_DESC(ptr)					\
 	(!strcmp((ptr)->bg_signature, OCFS2_GROUP_DESC_SIGNATURE))
 
-#define OCFS2_RO_ON_INVALID_GROUP_DESC(__sb, __gd)	do {		\
-	typeof(__gd) ____gd = (__gd);					\
-		ocfs2_error((__sb),					\
-		"Group Descriptor # %llu has bad signature %.*s",	\
-		(unsigned long long)le64_to_cpu((____gd)->bg_blkno), 7, \
-		(____gd)->bg_signature);				\
-} while (0)
 
 static inline unsigned long ino_from_blkno(struct super_block *sb,
 					   u64 blkno)
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 797f509..766a00b 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -842,10 +842,9 @@ static int ocfs2_block_group_find_clear_bits(struct ocfs2_super *osb,
 	int offset, start, found, status = 0;
 	struct ocfs2_group_desc *bg = (struct ocfs2_group_desc *) bg_bh->b_data;
 
-	if (!OCFS2_IS_VALID_GROUP_DESC(bg)) {
-		OCFS2_RO_ON_INVALID_GROUP_DESC(osb->sb, bg);
-		return -EIO;
-	}
+	/* Callers got this descriptor from
+	 * ocfs2_read_group_descriptor().  Any corruption is a code bug. */
+	BUG_ON(!OCFS2_IS_VALID_GROUP_DESC(bg));
 
 	found = start = best_offset = best_size = 0;
 	bitmap = bg->bg_bitmap;
@@ -910,11 +909,9 @@ static inline int ocfs2_block_group_set_bits(handle_t *handle,
 
 	mlog_entry_void();
 
-	if (!OCFS2_IS_VALID_GROUP_DESC(bg)) {
-		OCFS2_RO_ON_INVALID_GROUP_DESC(alloc_inode->i_sb, bg);
-		status = -EIO;
-		goto bail;
-	}
+	/* All callers get the descriptor via
+	 * ocfs2_read_group_descriptor().  Any corruption is a code bug. */
+	BUG_ON(!OCFS2_IS_VALID_GROUP_DESC(bg));
 	BUG_ON(le16_to_cpu(bg->bg_free_bits_count) < num_bits);
 
 	mlog(0, "block_group_set_bits: off = %u, num = %u\n", bit_off,
@@ -983,16 +980,10 @@ static int ocfs2_relink_block_group(handle_t *handle,
 	struct ocfs2_group_desc *bg = (struct ocfs2_group_desc *) bg_bh->b_data;
 	struct ocfs2_group_desc *prev_bg = (struct ocfs2_group_desc *) prev_bg_bh->b_data;
 
-	if (!OCFS2_IS_VALID_GROUP_DESC(bg)) {
-		OCFS2_RO_ON_INVALID_GROUP_DESC(alloc_inode->i_sb, bg);
-		status = -EIO;
-		goto out;
-	}
-	if (!OCFS2_IS_VALID_GROUP_DESC(prev_bg)) {
-		OCFS2_RO_ON_INVALID_GROUP_DESC(alloc_inode->i_sb, prev_bg);
-		status = -EIO;
-		goto out;
-	}
+	/* The caller got these descriptors from
+	 * ocfs2_read_group_descriptor().  Any corruption is a code bug. */
+	BUG_ON(!OCFS2_IS_VALID_GROUP_DESC(bg));
+	BUG_ON(!OCFS2_IS_VALID_GROUP_DESC(prev_bg));
 
 	mlog(0, "Suballoc %llu, chain %u, move group %llu to top, prev = %llu\n",
 	     (unsigned long long)le64_to_cpu(fe->i_blkno), chain,
@@ -1055,7 +1046,7 @@ out_rollback:
 		bg->bg_next_group = cpu_to_le64(bg_ptr);
 		prev_bg->bg_next_group = cpu_to_le64(prev_bg_ptr);
 	}
-out:
+
 	mlog_exit(status);
 	return status;
 }
@@ -1758,11 +1749,9 @@ static inline int ocfs2_block_group_clear_bits(handle_t *handle,
 
 	mlog_entry_void();
 
-	if (!OCFS2_IS_VALID_GROUP_DESC(bg)) {
-		OCFS2_RO_ON_INVALID_GROUP_DESC(alloc_inode->i_sb, bg);
-		status = -EIO;
-		goto bail;
-	}
+	/* The caller got this descriptor from
+	 * ocfs2_read_group_descriptor().  Any corruption is a code bug. */
+	BUG_ON(!OCFS2_IS_VALID_GROUP_DESC(bg));
 
 	mlog(0, "off = %u, num = %u\n", bit_off, num_bits);
 
-- 
1.5.6.5
