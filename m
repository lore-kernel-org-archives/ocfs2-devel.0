From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 17 Nov 2011 16:33:02 -0800
Subject: [Ocfs2-devel] [PATCH 6/6] ocfs2: Tighten free bit calculation in
	the global bitmap
In-Reply-To: <1321576382-18521-1-git-send-email-sunil.mushran@oracle.com>
References: <1321576382-18521-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1321576382-18521-6-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When clearing bits in the global bitmap, we do not test the current bit value.
This patch tightens the code by considering the possiblity that the bit being
cleared was already cleared.

Now this should not happen. But we are seeing stray instances in which free
bit count in the global bitmap exceeds the total bit count. In each instance
the bitmap is correct. Only the free bit count is incorrect.

This patch checks the current bit value and increments the free bit count
only if the bit was previously set. It also prints information to allow
us to debug further.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/suballoc.c |   26 +++++++++++++++++++++++---
 1 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index ba5d97e..972f0b1 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -2386,6 +2386,7 @@ static int ocfs2_block_group_clear_bits(handle_t *handle,
 	int status;
 	unsigned int tmp;
 	struct ocfs2_group_desc *undo_bg = NULL;
+	unsigned int bits_cleared = 0;
 
 	/* The caller got this descriptor from
 	 * ocfs2_read_group_descriptor().  Any corruption is a code bug. */
@@ -2413,13 +2414,32 @@ static int ocfs2_block_group_clear_bits(handle_t *handle,
 
 	tmp = num_bits;
 	while(tmp--) {
-		ocfs2_clear_bit((bit_off + tmp),
-				(unsigned long *) bg->bg_bitmap);
+		if (ocfs2_test_bit((bit_off + tmp),
+				   (unsigned long *) bg->bg_bitmap)) {
+			ocfs2_clear_bit((bit_off + tmp),
+					(unsigned long *) bg->bg_bitmap);
+			bits_cleared++;
+		}
 		if (undo_fn)
 			undo_fn(bit_off + tmp,
 				(unsigned long *) undo_bg->bg_bitmap);
 	}
-	le16_add_cpu(&bg->bg_free_bits_count, num_bits);
+
+	le16_add_cpu(&bg->bg_free_bits_count, bits_cleared);
+
+	/*
+	 * If encountered, it means we are clearing bits multiple times. While
+	 * we are handling the case, we still need to be alerted to its
+	 * occurrence. Hence, marking it as an ERROR and not NOTICE.
+	 */
+	if (num_bits != bits_cleared) {
+		mlog(ML_ERROR, "Trying to clear %u bits at offset %u in group "
+		     "descriptor # %llu (device %s), needed to clear %u bits\n",
+		     num_bits, bit_off,
+		     (unsigned long long)le64_to_cpu(bg->bg_blkno),
+		     alloc_inode->i_sb->s_id, bits_cleared);
+	}
+
 	if (le16_to_cpu(bg->bg_free_bits_count) > le16_to_cpu(bg->bg_bits)) {
 		ocfs2_error(alloc_inode->i_sb, "Group descriptor # %llu has bit"
 			    " count %u but claims %u are freed. num_bits %d",
-- 
1.7.5.4
