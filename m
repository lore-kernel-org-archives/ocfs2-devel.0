From: Gang He <ghe@suse.com>
Date: Wed, 24 Jun 2015 13:24:21 +0800
Subject: [Ocfs2-devel] [PATCH 4/4] ocfs2: check/fix inode block for online
	file check
In-Reply-To: <1435123461-3525-1-git-send-email-ghe@suse.com>
References: <1435123461-3525-1-git-send-email-ghe@suse.com>
Message-ID: <1435123461-3525-5-git-send-email-ghe@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@suse.com, ghe@suse.com, rgoldwyn@suse.de
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org

Implement online check or fix inode block during
reading a inode block to memory.

Signed-off-by: Gang He <ghe@suse.com>
Reviewed-by: Goldwyn Rodrigues <rgoldwyn@suse.de>
---
 fs/ocfs2/inode.c       | 196 +++++++++++++++++++++++++++++++++++++++++++++++--
 fs/ocfs2/ocfs2_trace.h |   2 +
 2 files changed, 192 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index b254416..d811698 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -53,6 +53,7 @@
 #include "xattr.h"
 #include "refcounttree.h"
 #include "ocfs2_trace.h"
+#include "filecheck.h"
 
 #include "buffer_head_io.h"
 
@@ -74,6 +75,13 @@ static int ocfs2_truncate_for_delete(struct ocfs2_super *osb,
 				    struct inode *inode,
 				    struct buffer_head *fe_bh);
 
+static int ocfs2_filecheck_read_inode_block_full(struct inode *inode,
+			struct buffer_head **bh, int flags, int type);
+static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
+			struct buffer_head *bh);
+static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
+			struct buffer_head *bh);
+
 void ocfs2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = OCFS2_I(inode)->ip_attr;
@@ -127,6 +135,7 @@ struct inode *ocfs2_ilookup(struct super_block *sb, u64 blkno)
 struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
 			 int sysfile_type)
 {
+	int rc = 0;
 	struct inode *inode = NULL;
 	struct super_block *sb = osb->sb;
 	struct ocfs2_find_inode_args args;
@@ -161,12 +170,17 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
 	}
 	trace_ocfs2_iget5_locked(inode->i_state);
 	if (inode->i_state & I_NEW) {
-		ocfs2_read_locked_inode(inode, &args);
+		rc = ocfs2_read_locked_inode(inode, &args);
 		unlock_new_inode(inode);
 	}
 	if (is_bad_inode(inode)) {
 		iput(inode);
-		inode = ERR_PTR(-ESTALE);
+		if ((flags & OCFS2_FI_FLAG_FILECHECK_CHK) ||
+			(flags & OCFS2_FI_FLAG_FILECHECK_FIX))
+			/* Return OCFS2_FILECHECK_ERR_XXX related errno */
+			inode = ERR_PTR(rc);
+		else
+			inode = ERR_PTR(-ESTALE);
 		goto bail;
 	}
 
@@ -494,16 +508,32 @@ static int ocfs2_read_locked_inode(struct inode *inode,
 	}
 
 	if (can_lock) {
-		status = ocfs2_read_inode_block_full(inode, &bh,
-						     OCFS2_BH_IGNORE_CACHE);
+		if (args->fi_flags & OCFS2_FI_FLAG_FILECHECK_CHK)
+			status = ocfs2_filecheck_read_inode_block_full(inode,
+						&bh, OCFS2_BH_IGNORE_CACHE, 0);
+		else if (args->fi_flags & OCFS2_FI_FLAG_FILECHECK_FIX)
+			status = ocfs2_filecheck_read_inode_block_full(inode,
+						&bh, OCFS2_BH_IGNORE_CACHE, 1);
+		else
+			status = ocfs2_read_inode_block_full(inode,
+						&bh, OCFS2_BH_IGNORE_CACHE);
 	} else {
 		status = ocfs2_read_blocks_sync(osb, args->fi_blkno, 1, &bh);
 		/*
 		 * If buffer is in jbd, then its checksum may not have been
 		 * computed as yet.
 		 */
-		if (!status && !buffer_jbd(bh))
-			status = ocfs2_validate_inode_block(osb->sb, bh);
+		if (!status && !buffer_jbd(bh)) {
+			if (args->fi_flags & OCFS2_FI_FLAG_FILECHECK_CHK)
+				status = ocfs2_filecheck_validate_inode_block(
+								osb->sb, bh);
+			else if (args->fi_flags & OCFS2_FI_FLAG_FILECHECK_FIX)
+				status = ocfs2_filecheck_repair_inode_block(
+								osb->sb, bh);
+			else
+				status = ocfs2_validate_inode_block(
+								osb->sb, bh);
+		}
 	}
 	if (status < 0) {
 		mlog_errno(status);
@@ -531,6 +561,14 @@ static int ocfs2_read_locked_inode(struct inode *inode,
 
 	BUG_ON(args->fi_blkno != le64_to_cpu(fe->i_blkno));
 
+	if (buffer_dirty(bh)) {
+		status = ocfs2_write_block(osb, bh, INODE_CACHE(inode));
+		if (status < 0) {
+			mlog_errno(status);
+			goto bail;
+		}
+	}
+
 	status = 0;
 
 bail:
@@ -1385,6 +1423,152 @@ bail:
 	return rc;
 }
 
+static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
+			       struct buffer_head *bh)
+{
+	int rc = 0;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)bh->b_data;
+
+	trace_ocfs2_filecheck_validate_inode_block(
+		(unsigned long long)bh->b_blocknr);
+
+	BUG_ON(!buffer_uptodate(bh));
+
+	if (!OCFS2_IS_VALID_DINODE(di)) {
+		mlog(ML_ERROR,
+			"Filecheck: invalid dinode #%llu: signature = %.*s\n",
+			(unsigned long long)bh->b_blocknr, 7, di->i_signature);
+		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+		goto bail;
+	}
+
+	rc = ocfs2_validate_meta_ecc(sb, bh->b_data, &di->i_check);
+	if (rc) {
+		mlog(ML_ERROR,
+			"Filecheck: checksum failed for dinode %llu\n",
+			(unsigned long long)bh->b_blocknr);
+		rc = -OCFS2_FILECHECK_ERR_BLOCKECC;
+		goto bail;
+	}
+
+	if (le64_to_cpu(di->i_blkno) != bh->b_blocknr) {
+		mlog(ML_ERROR,
+			"Filecheck: invalid dinode #%llu: i_blkno is %llu\n",
+			(unsigned long long)bh->b_blocknr,
+			(unsigned long long)le64_to_cpu(di->i_blkno));
+		rc = -OCFS2_FILECHECK_ERR_BLOCKNO;
+		goto bail;
+	}
+
+	if (!(di->i_flags & cpu_to_le32(OCFS2_VALID_FL))) {
+		mlog(ML_ERROR,
+			"Filecheck: invalid dinode #%llu: OCFS2_VALID_FL not set\n",
+			(unsigned long long)bh->b_blocknr);
+		rc = -OCFS2_FILECHECK_ERR_VALIDFLAG;
+		goto bail;
+	}
+
+	if (le32_to_cpu(di->i_fs_generation) !=
+	    OCFS2_SB(sb)->fs_generation) {
+		mlog(ML_ERROR,
+			"Filecheck: invalid dinode #%llu: fs_generation is %u\n",
+			(unsigned long long)bh->b_blocknr,
+			le32_to_cpu(di->i_fs_generation));
+		rc = -OCFS2_FILECHECK_ERR_GENERATION;
+		goto bail;
+	}
+
+bail:
+	return rc;
+}
+
+static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
+			       struct buffer_head *bh)
+{
+	int rc;
+	int changed = 0;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)bh->b_data;
+
+	rc = ocfs2_filecheck_validate_inode_block(sb, bh);
+	/* Can't fix invalid inode block */
+	if (!rc || rc == -OCFS2_FILECHECK_ERR_INVALIDINO)
+		return rc;
+
+	trace_ocfs2_filecheck_repair_inode_block(
+		(unsigned long long)bh->b_blocknr);
+
+	if (ocfs2_is_hard_readonly(OCFS2_SB(sb)) ||
+		ocfs2_is_soft_readonly(OCFS2_SB(sb))) {
+		mlog(ML_ERROR,
+			"Filecheck: try to repair dinode #%llu on readonly filesystem\n",
+			(unsigned long long)bh->b_blocknr);
+		return -OCFS2_FILECHECK_ERR_READONLY;
+	}
+
+	if (le64_to_cpu(di->i_blkno) != bh->b_blocknr) {
+		di->i_blkno = cpu_to_le64(bh->b_blocknr);
+		changed = 1;
+		mlog(ML_ERROR,
+			"Filecheck: reset dinode #%llu: i_blkno to %llu\n",
+			(unsigned long long)bh->b_blocknr,
+			(unsigned long long)le64_to_cpu(di->i_blkno));
+	}
+
+	if (!(di->i_flags & cpu_to_le32(OCFS2_VALID_FL))) {
+		di->i_flags |= cpu_to_le32(OCFS2_VALID_FL);
+		changed = 1;
+		mlog(ML_ERROR,
+			"Filecheck: reset dinode #%llu: OCFS2_VALID_FL is set\n",
+			(unsigned long long)bh->b_blocknr);
+	}
+
+	if (le32_to_cpu(di->i_fs_generation) !=
+	    OCFS2_SB(sb)->fs_generation) {
+		di->i_fs_generation = cpu_to_le32(OCFS2_SB(sb)->fs_generation);
+		changed = 1;
+		mlog(ML_ERROR,
+			"Filecheck: reset dinode #%llu: fs_generation to %u\n",
+			(unsigned long long)bh->b_blocknr,
+			le32_to_cpu(di->i_fs_generation));
+	}
+
+	if (changed ||
+		ocfs2_validate_meta_ecc(sb, bh->b_data, &di->i_check)) {
+		ocfs2_compute_meta_ecc(sb, bh->b_data, &di->i_check);
+		mark_buffer_dirty(bh);
+		mlog(ML_ERROR,
+			"Filecheck: reset dinode #%llu: compute meta ecc\n",
+			(unsigned long long)bh->b_blocknr);
+	}
+
+	return 0;
+}
+
+static int
+ocfs2_filecheck_read_inode_block_full(struct inode *inode,
+		struct buffer_head **bh, int flags, int type)
+{
+	int rc;
+	struct buffer_head *tmp = *bh;
+
+	if (!type) /* Check inode block */
+		rc = ocfs2_read_blocks(INODE_CACHE(inode),
+				OCFS2_I(inode)->ip_blkno,
+				1, &tmp, flags,
+				ocfs2_filecheck_validate_inode_block);
+	else /* Repair inode block */
+		rc = ocfs2_read_blocks(INODE_CACHE(inode),
+				OCFS2_I(inode)->ip_blkno,
+				1, &tmp, flags,
+				ocfs2_filecheck_repair_inode_block);
+
+	/* If ocfs2_read_blocks() got us a new bh, pass it up. */
+	if (!rc && !*bh)
+		*bh = tmp;
+
+	return rc;
+}
+
 int ocfs2_read_inode_block_full(struct inode *inode, struct buffer_head **bh,
 				int flags)
 {
diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index 6cb019b..d9205e0 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -1540,6 +1540,8 @@ DEFINE_OCFS2_ULL_INT_EVENT(ocfs2_read_locked_inode);
 DEFINE_OCFS2_INT_INT_EVENT(ocfs2_check_orphan_recovery_state);
 
 DEFINE_OCFS2_ULL_EVENT(ocfs2_validate_inode_block);
+DEFINE_OCFS2_ULL_EVENT(ocfs2_filecheck_validate_inode_block);
+DEFINE_OCFS2_ULL_EVENT(ocfs2_filecheck_repair_inode_block);
 
 TRACE_EVENT(ocfs2_inode_is_valid_to_delete,
 	TP_PROTO(void *task, void *dc_task, unsigned long long ino,
-- 
2.1.2
