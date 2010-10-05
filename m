From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Tue,  5 Oct 2010 15:53:06 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: validate bg_free_bits_count after
	update
Message-ID: <1286319186-16697-1-git-send-email-srinivas.eeda@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch adds a safe check to ensure bg_free_bits_count doesn't exceed
bg_bits in a group descriptor. This is to avoid on disk corruption that was
seen recently.

debugfs: group <52803072>
       Group Chain: 179   Parent Inode: 11  Generation: 2959379682
       CRC32: 00000000   ECC: 0000
       ##   Block#            Total    Used     Free     Contig   Size
       0    52803072          32256    4294965350   34202    18207    4032
       ......

Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
---
 fs/ocfs2/suballoc.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 849c2f0..5fed60d 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1380,6 +1380,14 @@ static inline int ocfs2_block_group_set_bits(handle_t *handle,
 	}
 
 	le16_add_cpu(&bg->bg_free_bits_count, -num_bits);
+	if (le16_to_cpu(bg->bg_free_bits_count) > le16_to_cpu(bg->bg_bits)) {
+		ocfs2_error(alloc_inode->i_sb, "Group descriptor # %llu has bit"
+			    " count %u but claims %u are freed. num_bits %d",
+			    (unsigned long long)le64_to_cpu(bg->bg_blkno),
+			    le16_to_cpu(bg->bg_bits),
+			    le16_to_cpu(bg->bg_free_bits_count), num_bits);
+		return -EROFS;
+	}
 	while(num_bits--)
 		ocfs2_set_bit(bit_off++, bitmap);
 
@@ -2419,6 +2427,14 @@ static int ocfs2_block_group_clear_bits(handle_t *handle,
 				(unsigned long *) undo_bg->bg_bitmap);
 	}
 	le16_add_cpu(&bg->bg_free_bits_count, num_bits);
+	if (le16_to_cpu(bg->bg_free_bits_count) > le16_to_cpu(bg->bg_bits)) {
+		ocfs2_error(alloc_inode->i_sb, "Group descriptor # %llu has bit"
+			    " count %u but claims %u are freed. num_bits %d",
+			    (unsigned long long)le64_to_cpu(bg->bg_blkno),
+			    le16_to_cpu(bg->bg_bits),
+			    le16_to_cpu(bg->bg_free_bits_count), num_bits);
+		return -EROFS;
+	}
 
 	if (undo_fn)
 		jbd_unlock_bh_state(group_bh);
-- 
1.5.6.5
