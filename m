From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Wed, 02 Feb 2011 09:26:57 -0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: avoid unaligned access to dqc_bitmap
Message-ID: <1296639119-7755-1-git-send-email-akinobu.mita@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The dqc_bitmap field of struct ocfs2_local_disk_chunk is 32-bit aligned,
but not 64-bit aligned. The dqc_bitmap is accessed by ocfs2_set_bit(),
ocfs2_clear_bit(), ocfs2_test_bit(), or ocfs2_find_next_zero_bit().
These are wrapper macros for ext2_*_bit() which need to take an unsigned
long aligned address (though some architectures are able to handle
unaligned address correctly)

So some 64bit architectures may not be able to access the dqc_bitmap
correctly.

This avoids such unaligned access by using another wrapper functions for
ext2_*_bit().  The code is taken from fs/ext4/mballoc.c which also need
to handle unaligned bitmap access.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel at oss.oracle.com
---

I'm not sure if any 64bit architectures hit this problem.  It was found
by code inspection while I was working on the little-endian bitops
patch series.

 fs/ocfs2/ocfs2.h       |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/quota_local.c |   10 +++++-----
 2 files changed, 52 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 51cd689..4e4581e 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -844,5 +844,52 @@ static inline void _ocfs2_clear_bit(unsigned int bit, unsigned long *bitmap)
 #define ocfs2_test_bit ext2_test_bit
 #define ocfs2_find_next_zero_bit ext2_find_next_zero_bit
 #define ocfs2_find_next_bit ext2_find_next_bit
+
+static inline void *correct_addr_and_bit_unaligned(int *bit, void *addr)
+{
+#if BITS_PER_LONG == 64
+	*bit += ((unsigned long) addr & 7UL) << 3;
+	addr = (void *) ((unsigned long) addr & ~7UL);
+#elif BITS_PER_LONG == 32
+	*bit += ((unsigned long) addr & 3UL) << 3;
+	addr = (void *) ((unsigned long) addr & ~3UL);
+#else
+#error "how many bits you are?!"
+#endif
+	return addr;
+}
+
+static inline void ocfs2_set_bit_unaligned(int bit, void *bitmap)
+{
+	bitmap = correct_addr_and_bit_unaligned(&bit, bitmap);
+	ocfs2_set_bit(bit, bitmap);
+}
+
+static inline void ocfs2_clear_bit_unaligned(int bit, void *bitmap)
+{
+	bitmap = correct_addr_and_bit_unaligned(&bit, bitmap);
+	ocfs2_clear_bit(bit, bitmap);
+}
+
+static inline int ocfs2_test_bit_unaligned(int bit, void *bitmap)
+{
+	bitmap = correct_addr_and_bit_unaligned(&bit, bitmap);
+	return ocfs2_test_bit(bit, bitmap);
+}
+
+static inline int ocfs2_find_next_zero_bit_unaligned(void *bitmap, int max,
+							int start)
+{
+	int fix = 0, ret, tmpmax;
+	bitmap = correct_addr_and_bit_unaligned(&fix, bitmap);
+	tmpmax = max + fix;
+	start += fix;
+
+	ret = ocfs2_find_next_zero_bit(bitmap, tmpmax, start) - fix;
+	if (ret > max)
+		return max;
+	return ret;
+}
+
 #endif  /* OCFS2_H */
 
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index dc78764..1290423 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -549,8 +549,8 @@ static int ocfs2_recover_local_quota_file(struct inode *lqinode,
 				goto out_commit;
 			}
 			lock_buffer(qbh);
-			WARN_ON(!ocfs2_test_bit(bit, dchunk->dqc_bitmap));
-			ocfs2_clear_bit(bit, dchunk->dqc_bitmap);
+			WARN_ON(!ocfs2_test_bit_unaligned(bit, dchunk->dqc_bitmap));
+			ocfs2_clear_bit_unaligned(bit, dchunk->dqc_bitmap);
 			le32_add_cpu(&dchunk->dqc_free, 1);
 			unlock_buffer(qbh);
 			ocfs2_journal_dirty(handle, qbh);
@@ -942,7 +942,7 @@ static struct ocfs2_quota_chunk *ocfs2_find_free_entry(struct super_block *sb,
 		      * ol_quota_entries_per_block(sb);
 	}
 
-	found = ocfs2_find_next_zero_bit(dchunk->dqc_bitmap, len, 0);
+	found = ocfs2_find_next_zero_bit_unaligned(dchunk->dqc_bitmap, len, 0);
 	/* We failed? */
 	if (found == len) {
 		mlog(ML_ERROR, "Did not find empty entry in chunk %d with %u"
@@ -1206,7 +1206,7 @@ static void olq_alloc_dquot(struct buffer_head *bh, void *private)
 	struct ocfs2_local_disk_chunk *dchunk;
 
 	dchunk = (struct ocfs2_local_disk_chunk *)bh->b_data;
-	ocfs2_set_bit(*offset, dchunk->dqc_bitmap);
+	ocfs2_set_bit_unaligned(*offset, dchunk->dqc_bitmap);
 	le32_add_cpu(&dchunk->dqc_free, -1);
 }
 
@@ -1287,7 +1287,7 @@ int ocfs2_local_release_dquot(handle_t *handle, struct dquot *dquot)
 			(od->dq_chunk->qc_headerbh->b_data);
 	/* Mark structure as freed */
 	lock_buffer(od->dq_chunk->qc_headerbh);
-	ocfs2_clear_bit(offset, dchunk->dqc_bitmap);
+	ocfs2_clear_bit_unaligned(offset, dchunk->dqc_bitmap);
 	le32_add_cpu(&dchunk->dqc_free, 1);
 	unlock_buffer(od->dq_chunk->qc_headerbh);
 	ocfs2_journal_dirty(handle, od->dq_chunk->qc_headerbh);
-- 
1.7.3.3
