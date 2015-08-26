From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Wed, 26 Aug 2015 15:12:36 -0700
Subject: [Ocfs2-devel] [patch 28/28] ocfs2: add file extent block check
Message-ID: <55de39d4.hW5RHoJSnnEelK16%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Gang He <ghe@suse.com>
Subject: ocfs2: add file extent block check

Add file extent block online check, besides inode block online check,
we will add more kinds of meta block online check/repair.

Signed-off-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/filecheck.c |  247 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 239 insertions(+), 8 deletions(-)

diff -puN fs/ocfs2/filecheck.c~ocfs2-add-file-extent-block-check fs/ocfs2/filecheck.c
--- a/fs/ocfs2/filecheck.c~ocfs2-add-file-extent-block-check
+++ a/fs/ocfs2/filecheck.c
@@ -462,38 +462,269 @@ ocfs2_filecheck_done_entry(struct ocfs2_
 	spin_unlock(&ent->fs_fcheck->fc_lock);
 }
 
+static int
+ocfs2_filecheck_inode_block(struct super_block *sb, unsigned long ino,
+				unsigned int flags, struct inode **ret)
+{
+	int rc = 0;
+	struct inode *inode;
+
+	if (flags == OCFS2_FILECHECK_TYPE_CHK)
+		flags = OCFS2_FI_FLAG_FILECHECK_CHK;
+	else
+		flags = OCFS2_FI_FLAG_FILECHECK_FIX;
+
+	inode = ocfs2_iget(OCFS2_SB(sb), ino, flags, 0);
+	if (IS_ERR(inode))
+		rc = (int)(long)inode;
+	else
+		*ret = inode;
+
+	return rc;
+}
+
+static int
+ocfs2_filecheck_extent_list(handle_t *handle, struct inode *inode,
+			unsigned int flags, struct ocfs2_extent_list *el)
+{
+	int i, rc = 0;
+	u64 blkno;
+	struct buffer_head *bh = NULL;
+	struct ocfs2_extent_block *eb;
+	struct ocfs2_extent_list *ell;
+
+	if (!el || !el->l_tree_depth)
+		return 0;
+
+	mlog(ML_NOTICE, "ocfs2_filecheck_extent_list: inode %llu tree_depth "
+		"%u count %u next_free_rec %u\n",
+		(unsigned long long)OCFS2_I(inode)->ip_blkno,
+		le16_to_cpu(el->l_tree_depth),
+		le16_to_cpu(el->l_count),
+		le16_to_cpu(el->l_next_free_rec));
+
+	if (le16_to_cpu(el->l_next_free_rec) == 0) {
+		mlog(ML_ERROR,
+		"Inode %llu has empty extent list at depth %u\n",
+		(unsigned long long)OCFS2_I(inode)->ip_blkno,
+		le16_to_cpu(el->l_tree_depth));
+		rc = -EROFS;
+		goto out;
+	}
+
+	if (le16_to_cpu(el->l_next_free_rec) > le16_to_cpu(el->l_count)) {
+		mlog(ML_ERROR,
+		"Inode %llu has bad count in extent list "
+		"at depth %u (next free=%u, count=%u)\n",
+		(unsigned long long)OCFS2_I(inode)->ip_blkno,
+		le16_to_cpu(el->l_tree_depth),
+		le16_to_cpu(el->l_next_free_rec),
+		le16_to_cpu(el->l_count));
+		rc = -EROFS;
+		goto out;
+	}
+
+	for (i = 0; i < le16_to_cpu(el->l_next_free_rec); i++) {
+		blkno = le64_to_cpu(el->l_recs[i].e_blkno);
+		if (blkno == 0) {
+			mlog(ML_ERROR,
+			"Inode %llu has bad blkno in extent list "
+			"at depth %u (index %d)\n",
+			(unsigned long long)OCFS2_I(inode)->ip_blkno,
+			le16_to_cpu(el->l_tree_depth), i);
+			rc = -EROFS;
+			goto out;
+		}
+
+		mlog(ML_NOTICE, "ocfs2_filecheck_extent_list: inode %llu "
+		"rec[%d]: cpos %u clusters %u blkno %llu\n ",
+		(unsigned long long)OCFS2_I(inode)->ip_blkno,
+		i,
+		le32_to_cpu(el->l_recs[i].e_cpos),
+		le32_to_cpu(el->l_recs[i].e_int_clusters),
+		le64_to_cpu(el->l_recs[i].e_blkno));
+
+		brelse(bh);
+		bh = NULL;
+
+		rc = ocfs2_filecheck_read_extent_block(INODE_CACHE(inode),
+						blkno, &bh, flags);
+		if (rc) {
+			mlog_errno(rc);
+			goto out;
+		}
+
+		if (flags && buffer_dirty(bh)) {
+			/* Dirty buffer means that filecheck just repaired
+			 * this buffer during reading it from disk.
+			 */
+			clear_buffer_dirty(bh);
+
+			rc = ocfs2_extend_trans(handle,
+					OCFS2_EXTENT_BLOCK_UPDATE_CREDITS);
+			if (rc) {
+				mlog_errno(rc);
+				goto out;
+			}
+
+			rc = ocfs2_journal_access_eb(handle,
+				INODE_CACHE(inode), bh,
+				OCFS2_JOURNAL_ACCESS_WRITE);
+			if (rc < 0) {
+				mlog_errno(rc);
+				goto out;
+			}
+
+			ocfs2_journal_dirty(handle, bh);
+		}
+
+		eb = (struct ocfs2_extent_block *)bh->b_data;
+		ell = &eb->h_list;
+		rc = ocfs2_filecheck_extent_list(handle, inode, flags, ell);
+		if (rc)
+			goto out;
+	}
+
+out:
+	brelse(bh);
+	return rc;
+}
+
+static int
+ocfs2_filecheck_extent_block(struct inode *inode, struct buffer_head *di_bh,
+				unsigned int flags)
+{
+	int rc = 0;
+	handle_t *handle = NULL;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_dinode *di;
+	struct ocfs2_extent_list *el;
+
+	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
+		return 0;
+
+	if (flags) {
+		handle = ocfs2_start_trans(osb,
+					OCFS2_EXTENT_BLOCK_UPDATE_CREDITS);
+		if (IS_ERR(handle)) {
+			rc = PTR_ERR(handle);
+			mlog_errno(rc);
+			goto out;
+		}
+	}
+
+	di = (struct ocfs2_dinode *)di_bh->b_data;
+	el = &di->id2.i_list;
+	rc = ocfs2_filecheck_extent_list(handle, inode, flags, el);
+
+	if (flags)
+		ocfs2_commit_trans(osb, handle);
+
+out:
+	return rc;
+}
+
+static int
+ocfs2_filecheck_file_block(struct inode *inode, unsigned int flags)
+{
+	int rc;
+	struct buffer_head *di_bh = NULL;
+
+	mutex_lock(&inode->i_mutex);
+
+	rc = ocfs2_rw_lock(inode, 1);
+	if (rc) {
+		mlog_errno(rc);
+		goto out;
+	}
+
+	rc = ocfs2_inode_lock(inode, &di_bh, 1);
+	if (rc) {
+		mlog_errno(rc);
+		goto out_rw_unlock;
+	}
+
+	do {
+		down_write(&OCFS2_I(inode)->ip_alloc_sem);
+		rc = ocfs2_filecheck_extent_block(inode, di_bh, flags);
+		up_write(&OCFS2_I(inode)->ip_alloc_sem);
+		if (rc)
+			break;
+
+		/* TODO: Add check/fix for xattr/refcount blocks */
+
+	} while (0);
+
+	brelse(di_bh);
+	ocfs2_inode_unlock(inode, 1);
+out_rw_unlock:
+	ocfs2_rw_unlock(inode, 1);
+out:
+	mutex_unlock(&inode->i_mutex);
+
+	return rc;
+}
+
+static int
+ocfs2_filecheck_other_block(struct inode *inode, unsigned int flags)
+{
+	int rc = 0;
+
+	switch (inode->i_mode & S_IFMT) {
+	case S_IFREG:
+		rc = ocfs2_filecheck_file_block(inode, flags);
+		break;
+	case S_IFDIR:
+		/* TODO: Add check/fix for directory blocks */
+		break;
+	default:
+		break;
+	}
+
+	return rc;
+}
+
 static unsigned short
 ocfs2_filecheck_handle(struct super_block *sb,
 				unsigned long ino, unsigned int flags)
 {
+	int rc;
 	unsigned short ret = OCFS2_FILECHECK_ERR_SUCCESS;
 	struct inode *inode = NULL;
-	int rc;
 
-	inode = ocfs2_iget(OCFS2_SB(sb), ino, flags, 0);
-	if (IS_ERR(inode)) {
-		rc = (int)(-(long)inode);
+	do {
+		rc = ocfs2_filecheck_inode_block(sb, ino, flags, &inode);
+		if (rc)
+			break;
+
+		rc = ocfs2_filecheck_other_block(inode, flags);
+	} while (0);
+
+	if (rc) {
+		rc = (-rc);
 		if (rc >= OCFS2_FILECHECK_ERR_START &&
 			rc < OCFS2_FILECHECK_ERR_END)
 			ret = rc;
 		else
 			ret = OCFS2_FILECHECK_ERR_FAILED;
-	} else
+	}
+
+	if (inode)
 		iput(inode);
 
 	return ret;
 }
 
-static void
+static inline void
 ocfs2_filecheck_handle_entry(struct ocfs2_filecheck_sysfs_entry *ent,
 				struct ocfs2_filecheck_entry *entry)
 {
 	if (entry->fe_type == OCFS2_FILECHECK_TYPE_CHK)
 		entry->fe_status = ocfs2_filecheck_handle(ent->fs_sb,
-				entry->fe_ino, OCFS2_FI_FLAG_FILECHECK_CHK);
+				entry->fe_ino, OCFS2_FILECHECK_TYPE_CHK);
 	else if (entry->fe_type == OCFS2_FILECHECK_TYPE_FIX)
 		entry->fe_status = ocfs2_filecheck_handle(ent->fs_sb,
-				entry->fe_ino, OCFS2_FI_FLAG_FILECHECK_FIX);
+				entry->fe_ino, OCFS2_FILECHECK_TYPE_FIX);
 	else
 		entry->fe_status = OCFS2_FILECHECK_ERR_UNSUPPORTED;
 
_
