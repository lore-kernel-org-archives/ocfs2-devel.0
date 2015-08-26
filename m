From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Wed, 26 Aug 2015 15:12:33 -0700
Subject: [Ocfs2-devel] [patch 27/28] ocfs2: filecheck validate_extent_block
	function
Message-ID: <55de39d1.sgyQzdpyPstnVjyQ%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Gang He <ghe@suse.com>
Subject: ocfs2: filecheck validate_extent_block function

Add validate_extent_block/repair_extent_block functions
for online filecheck.

Signed-off-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c       |  116 +++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/alloc.h       |    4 +
 fs/ocfs2/ocfs2_trace.h |   24 ++++++++
 3 files changed, 144 insertions(+)

diff -puN fs/ocfs2/alloc.c~ocfs2-filecheck-validate_extent_block-function fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-filecheck-validate_extent_block-function
+++ a/fs/ocfs2/alloc.c
@@ -51,6 +51,7 @@
 #include "xattr.h"
 #include "refcounttree.h"
 #include "ocfs2_trace.h"
+#include "filecheck.h"
 
 #include "buffer_head_io.h"
 
@@ -934,6 +935,121 @@ bail:
 	return rc;
 }
 
+static int ocfs2_filecheck_validate_extent_block(struct super_block *sb,
+					struct buffer_head *bh)
+{
+	int rc;
+	struct ocfs2_extent_block *eb =
+		(struct ocfs2_extent_block *)bh->b_data;
+
+	trace_ocfs2_filecheck_validate_extent_block(
+					(unsigned long long)bh->b_blocknr);
+
+	BUG_ON(!buffer_uptodate(bh));
+
+	if (!OCFS2_IS_VALID_EXTENT_BLOCK(eb)) {
+		mlog(ML_ERROR,
+		"Filecheck: extent block #%llu has bad signature %.*s\n",
+		(unsigned long long)bh->b_blocknr,
+		7, eb->h_signature);
+		return -OCFS2_FILECHECK_ERR_INVALIDEXT;
+	}
+
+	rc = ocfs2_validate_meta_ecc(sb, bh->b_data, &eb->h_check);
+	if (rc) {
+		mlog(ML_ERROR, "Filecheck: checksum failed for extent "
+		"block %llu\n",
+		(unsigned long long)bh->b_blocknr);
+		return -OCFS2_FILECHECK_ERR_BLOCKECC;
+	}
+
+	if (le64_to_cpu(eb->h_blkno) != bh->b_blocknr) {
+		mlog(ML_ERROR,
+		"Filecheck: extent block #%llu has an invalid h_blkno "
+		"of %llu\n",
+		(unsigned long long)bh->b_blocknr,
+		(unsigned long long)le64_to_cpu(eb->h_blkno));
+		return -OCFS2_FILECHECK_ERR_BLOCKNO;
+	}
+
+	if (le32_to_cpu(eb->h_fs_generation) != OCFS2_SB(sb)->fs_generation) {
+		mlog(ML_ERROR,
+		"Filecheck: extent block #%llu has an invalid "
+		"h_fs_generation of #%u\n",
+		(unsigned long long)bh->b_blocknr,
+		le32_to_cpu(eb->h_fs_generation));
+		return -OCFS2_FILECHECK_ERR_GENERATION;
+	}
+
+	return 0;
+}
+
+static int ocfs2_filecheck_repair_extent_block(struct super_block *sb,
+					struct buffer_head *bh)
+{
+	int rc;
+	int changed = 0;
+	struct ocfs2_extent_block *eb =
+		(struct ocfs2_extent_block *)bh->b_data;
+
+	rc = ocfs2_filecheck_validate_extent_block(sb, bh);
+	/* Can't fix invalid extent block */
+	if (!rc || rc == -OCFS2_FILECHECK_ERR_INVALIDEXT)
+		return rc;
+
+	trace_ocfs2_filecheck_repair_extent_block(
+					(unsigned long long)bh->b_blocknr);
+
+	if (le64_to_cpu(eb->h_blkno) != bh->b_blocknr) {
+		eb->h_blkno = cpu_to_le64(bh->b_blocknr);
+		changed = 1;
+		mlog(ML_ERROR,
+		"Filecheck: reset extent block #%llu: h_blkno to %llu\n",
+		(unsigned long long)bh->b_blocknr,
+		(unsigned long long)le64_to_cpu(eb->h_blkno));
+	}
+
+	if (le32_to_cpu(eb->h_fs_generation) != OCFS2_SB(sb)->fs_generation) {
+		eb->h_fs_generation = cpu_to_le32(OCFS2_SB(sb)->fs_generation);
+		changed = 1;
+		mlog(ML_ERROR,
+		"Filecheck: reset extent block #%llu: "
+		"h_fs_generation to %u\n",
+		(unsigned long long)bh->b_blocknr,
+		le32_to_cpu(eb->h_fs_generation));
+	}
+
+	if (changed || ocfs2_validate_meta_ecc(sb, bh->b_data, &eb->h_check)) {
+		ocfs2_compute_meta_ecc(sb, bh->b_data, &eb->h_check);
+		mark_buffer_dirty(bh);
+		mlog(ML_ERROR,
+		"Filecheck: reset extent block #%llu: compute meta ecc\n",
+		(unsigned long long)bh->b_blocknr);
+	}
+
+	return 0;
+}
+
+int
+ocfs2_filecheck_read_extent_block(struct ocfs2_caching_info *ci, u64 eb_blkno,
+				struct buffer_head **bh, unsigned int flags)
+{
+	int rc;
+	struct buffer_head *tmp = *bh;
+
+	if (!flags) /* check extent block */
+		rc = ocfs2_read_block(ci, eb_blkno, &tmp,
+				ocfs2_filecheck_validate_extent_block);
+	else /* repair extent block */
+		rc = ocfs2_read_block(ci, eb_blkno, &tmp,
+				ocfs2_filecheck_repair_extent_block);
+
+	if (!rc && !*bh)
+		*bh = tmp;
+
+	return rc;
+}
+
 int ocfs2_read_extent_block(struct ocfs2_caching_info *ci, u64 eb_blkno,
 			    struct buffer_head **bh)
 {
diff -puN fs/ocfs2/alloc.h~ocfs2-filecheck-validate_extent_block-function fs/ocfs2/alloc.h
--- a/fs/ocfs2/alloc.h~ocfs2-filecheck-validate_extent_block-function
+++ a/fs/ocfs2/alloc.h
@@ -92,6 +92,10 @@ void ocfs2_init_refcount_extent_tree(str
 int ocfs2_read_extent_block(struct ocfs2_caching_info *ci, u64 eb_blkno,
 			    struct buffer_head **bh);
 
+int
+ocfs2_filecheck_read_extent_block(struct ocfs2_caching_info *ci, u64 eb_blkno,
+				struct buffer_head **bh, unsigned int flags);
+
 struct ocfs2_alloc_context;
 int ocfs2_insert_extent(handle_t *handle,
 			struct ocfs2_extent_tree *et,
diff -puN fs/ocfs2/ocfs2_trace.h~ocfs2-filecheck-validate_extent_block-function fs/ocfs2/ocfs2_trace.h
--- a/fs/ocfs2/ocfs2_trace.h~ocfs2-filecheck-validate_extent_block-function
+++ a/fs/ocfs2/ocfs2_trace.h
@@ -557,6 +557,30 @@ TRACE_EVENT(ocfs2_validate_extent_block,
 	TP_printk("%llu ", __entry->blkno)
 );
 
+TRACE_EVENT(ocfs2_filecheck_validate_extent_block,
+	TP_PROTO(unsigned long long blkno),
+	TP_ARGS(blkno),
+	TP_STRUCT__entry(
+		__field(unsigned long long, blkno)
+	),
+	TP_fast_assign(
+		__entry->blkno = blkno;
+	),
+	TP_printk("%llu ", __entry->blkno)
+);
+
+TRACE_EVENT(ocfs2_filecheck_repair_extent_block,
+	TP_PROTO(unsigned long long blkno),
+	TP_ARGS(blkno),
+	TP_STRUCT__entry(
+		__field(unsigned long long, blkno)
+	),
+	TP_fast_assign(
+		__entry->blkno = blkno;
+	),
+	TP_printk("%llu ", __entry->blkno)
+);
+
 TRACE_EVENT(ocfs2_rotate_leaf,
 	TP_PROTO(unsigned int insert_cpos, int insert_index,
 		 int has_empty, int next_free,
_
