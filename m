From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 17 Mar 2009 13:01:00 -0700
Subject: [Ocfs2-devel] [PATCH 10/32] ocfs2: Add total entry count to
	dx_root_block
In-Reply-To: <1237320082-12921-1-git-send-email-mfasheh@suse.com>
References: <1237320082-12921-1-git-send-email-mfasheh@suse.com>
Message-ID: <1237320082-12921-11-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>

This little bit of extra accounting speeds up ocfs2_empty_dir()
dramatically by allowing us to short-circuit the full directory scan.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dir.c      |  162 +++++++++++++++++++++++++++++++++++++--------------
 fs/ocfs2/ocfs2_fs.h |    6 ++-
 2 files changed, 124 insertions(+), 44 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 52df912..5e6aeb0 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -1322,16 +1322,15 @@ static int ocfs2_delete_entry_dx(handle_t *handle, struct inode *dir,
 	 * entry yet. Likewise, successful return means we *must*
 	 * remove the indexed entry.
 	 *
-	 * We're also careful to journal the root tree block here if
-	 * we're going to be adding to the start of the free list.
+	 * We're also careful to journal the root tree block here as
+	 * the entry count needs to be updated. Also, we might be
+	 * adding to the start of the free list.
 	 */
-	if (add_to_free_list || ocfs2_dx_root_inline(dx_root)) {
-		ret = ocfs2_journal_access_dr(handle, dir, dx_root_bh,
-					      OCFS2_JOURNAL_ACCESS_WRITE);
-		if (ret) {
-			mlog_errno(ret);
-			goto out;
-		}
+	ret = ocfs2_journal_access_dr(handle, dir, dx_root_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
 	}
 
 	if (!ocfs2_dx_root_inline(dx_root)) {
@@ -1365,11 +1364,12 @@ static int ocfs2_delete_entry_dx(handle_t *handle, struct inode *dir,
 	/* leaf_bh was journal_accessed for us in __ocfs2_delete_entry */
 	ocfs2_journal_dirty(handle, leaf_bh);
 
+	le32_add_cpu(&dx_root->dr_num_entries, -1);
+	ocfs2_journal_dirty(handle, dx_root_bh);
+
 	ocfs2_dx_list_remove_entry(entry_list, index);
 
-	if (ocfs2_dx_root_inline(dx_root))
-		ocfs2_journal_dirty(handle, dx_root_bh);
-	else
+	if (!ocfs2_dx_root_inline(dx_root))
 		ocfs2_journal_dirty(handle, lookup->dl_dx_leaf_bh);
 
 out:
@@ -1508,13 +1508,20 @@ out:
 	return ret;
 }
 
-static int ocfs2_dx_inline_root_insert(struct inode *dir, handle_t *handle,
-				       struct ocfs2_dx_hinfo *hinfo,
-				       u64 dirent_blk,
-				       struct buffer_head *dx_root_bh)
+static void ocfs2_dx_inline_root_insert(struct inode *dir, handle_t *handle,
+					struct ocfs2_dx_hinfo *hinfo,
+					u64 dirent_blk,
+					struct ocfs2_dx_root_block *dx_root)
 {
-	int ret;
+	ocfs2_dx_entry_list_insert(&dx_root->dr_entries, hinfo, dirent_blk);
+}
+
+static int ocfs2_dx_dir_insert(struct inode *dir, handle_t *handle,
+			       struct ocfs2_dir_lookup_result *lookup)
+{
+	int ret = 0;
 	struct ocfs2_dx_root_block *dx_root;
+	struct buffer_head *dx_root_bh = lookup->dl_dx_root_bh;
 
 	ret = ocfs2_journal_access_dr(handle, dir, dx_root_bh,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
@@ -1523,31 +1530,27 @@ static int ocfs2_dx_inline_root_insert(struct inode *dir, handle_t *handle,
 		goto out;
 	}
 
-	dx_root = (struct ocfs2_dx_root_block *)dx_root_bh->b_data;
-	ocfs2_dx_entry_list_insert(&dx_root->dr_entries, hinfo, dirent_blk);
+	dx_root = (struct ocfs2_dx_root_block *)lookup->dl_dx_root_bh->b_data;
+	if (ocfs2_dx_root_inline(dx_root)) {
+		ocfs2_dx_inline_root_insert(dir, handle,
+					    &lookup->dl_hinfo,
+					    lookup->dl_leaf_bh->b_blocknr,
+					    dx_root);
+	} else {
+		ret = __ocfs2_dx_dir_leaf_insert(dir, handle, &lookup->dl_hinfo,
+						 lookup->dl_leaf_bh->b_blocknr,
+						 lookup->dl_dx_leaf_bh);
+		if (ret)
+			goto out;
+	}
+
+	le32_add_cpu(&dx_root->dr_num_entries, 1);
 	ocfs2_journal_dirty(handle, dx_root_bh);
 
 out:
 	return ret;
 }
 
-static int ocfs2_dx_dir_insert(struct inode *dir, handle_t *handle,
-			       struct ocfs2_dir_lookup_result *lookup)
-{
-	struct ocfs2_dx_root_block *dx_root;
-
-	dx_root = (struct ocfs2_dx_root_block *)lookup->dl_dx_root_bh->b_data;
-	if (ocfs2_dx_root_inline(dx_root))
-		return ocfs2_dx_inline_root_insert(dir, handle,
-						   &lookup->dl_hinfo,
-						   lookup->dl_leaf_bh->b_blocknr,
-						   lookup->dl_dx_root_bh);
-
-	return __ocfs2_dx_dir_leaf_insert(dir, handle, &lookup->dl_hinfo,
-					  lookup->dl_leaf_bh->b_blocknr,
-					  lookup->dl_dx_leaf_bh);
-}
-
 static void ocfs2_remove_block_from_free_list(struct inode *dir,
 				       handle_t *handle,
 				       struct ocfs2_dir_lookup_result *lookup)
@@ -2121,6 +2124,7 @@ struct ocfs2_empty_dir_priv {
 	unsigned seen_dot;
 	unsigned seen_dot_dot;
 	unsigned seen_other;
+	unsigned dx_dir;
 };
 static int ocfs2_empty_dir_filldir(void *priv, const char *name, int name_len,
 				   loff_t pos, u64 ino, unsigned type)
@@ -2130,6 +2134,13 @@ static int ocfs2_empty_dir_filldir(void *priv, const char *name, int name_len,
 	/*
 	 * Check the positions of "." and ".." records to be sure
 	 * they're in the correct place.
+	 *
+	 * Indexed directories don't need to proceed past the first
+	 * two entries, so we end the scan after seeing '..'. Despite
+	 * that, we allow the scan to proceed In the event that we
+	 * have a corrupted indexed directory (no dot or dot dot
+	 * entries). This allows us to double check for existing
+	 * entries which might not have been found in the index.
 	 */
 	if (name_len == 1 && !strncmp(".", name, 1) && pos == 0) {
 		p->seen_dot = 1;
@@ -2139,18 +2150,57 @@ static int ocfs2_empty_dir_filldir(void *priv, const char *name, int name_len,
 	if (name_len == 2 && !strncmp("..", name, 2) &&
 	    pos == OCFS2_DIR_REC_LEN(1)) {
 		p->seen_dot_dot = 1;
+
+		if (p->dx_dir && p->seen_dot)
+			return 1;
+
 		return 0;
 	}
 
 	p->seen_other = 1;
 	return 1;
 }
+
+static int ocfs2_empty_dir_dx(struct inode *inode,
+			      struct ocfs2_empty_dir_priv *priv)
+{
+	int ret;
+	struct buffer_head *di_bh = NULL;
+	struct buffer_head *dx_root_bh = NULL;
+	struct ocfs2_dinode *di;
+	struct ocfs2_dx_root_block *dx_root;
+
+	priv->dx_dir = 1;
+
+	ret = ocfs2_read_inode_block(inode, &di_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+	di = (struct ocfs2_dinode *)di_bh->b_data;
+
+	ret = ocfs2_read_dx_root(inode, di, &dx_root_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+	dx_root = (struct ocfs2_dx_root_block *)dx_root_bh->b_data;
+
+	if (le32_to_cpu(dx_root->dr_num_entries) != 2)
+		priv->seen_other = 1;
+
+out:
+	brelse(di_bh);
+	brelse(dx_root_bh);
+	return ret;
+}
+
 /*
  * routine to check that the specified directory is empty (for rmdir)
  *
  * Returns 1 if dir is empty, zero otherwise.
  *
- * XXX: This is a performance problem
+ * XXX: This is a performance problem for unindexed directories.
  */
 int ocfs2_empty_dir(struct inode *inode)
 {
@@ -2160,6 +2210,16 @@ int ocfs2_empty_dir(struct inode *inode)
 
 	memset(&priv, 0, sizeof(priv));
 
+	if (ocfs2_dir_indexed(inode)) {
+		ret = ocfs2_empty_dir_dx(inode, &priv);
+		if (ret)
+			mlog_errno(ret);
+		/*
+		 * We still run ocfs2_dir_foreach to get the checks
+		 * for "." and "..".
+		 */
+	}
+
 	ret = ocfs2_dir_foreach(inode, &start, &priv, ocfs2_empty_dir_filldir);
 	if (ret)
 		mlog_errno(ret);
@@ -2329,7 +2389,7 @@ static int ocfs2_dx_dir_attach_index(struct ocfs2_super *osb,
 				     struct buffer_head *di_bh,
 				     struct buffer_head *dirdata_bh,
 				     struct ocfs2_alloc_context *meta_ac,
-				     int dx_inline,
+				     int dx_inline, u32 num_entries,
 				     struct buffer_head **ret_dx_root_bh)
 {
 	int ret;
@@ -2375,6 +2435,7 @@ static int ocfs2_dx_dir_attach_index(struct ocfs2_super *osb,
 	dx_root->dr_fs_generation = cpu_to_le32(osb->fs_generation);
 	dx_root->dr_blkno = cpu_to_le64(dr_blkno);
 	dx_root->dr_dir_blkno = cpu_to_le64(OCFS2_I(dir)->ip_blkno);
+	dx_root->dr_num_entries = cpu_to_le32(num_entries);
 	if (le16_to_cpu(trailer->db_free_rec_len))
 		dx_root->dr_free_blk = cpu_to_le64(dirdata_bh->b_blocknr);
 	else
@@ -2586,7 +2647,7 @@ static int ocfs2_fill_new_dir_dx(struct ocfs2_super *osb,
 	}
 
 	ret = ocfs2_dx_dir_attach_index(osb, handle, inode, di_bh, leaf_bh,
-					meta_ac, 1, &dx_root_bh);
+					meta_ac, 1, 2, &dx_root_bh);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -2633,6 +2694,7 @@ static int ocfs2_dx_dir_index_block(struct inode *dir,
 				    handle_t *handle,
 				    struct buffer_head **dx_leaves,
 				    int num_dx_leaves,
+				    u32 *num_dx_entries,
 				    struct buffer_head *dirent_bh)
 {
 	int ret, namelen, i;
@@ -2664,6 +2726,8 @@ static int ocfs2_dx_dir_index_block(struct inode *dir,
 			goto out;
 		}
 
+		*num_dx_entries = *num_dx_entries + 1;
+
 inc:
 		de_buf += le16_to_cpu(de->rec_len);
 	}
@@ -2707,6 +2771,8 @@ static void ocfs2_dx_dir_index_root_block(struct inode *dir,
 
 		ocfs2_dx_entry_list_insert(&dx_root->dr_entries, &hinfo,
 					   dirent_blk);
+
+		le32_add_cpu(&dx_root->dr_num_entries, 1);
 inc:
 		de_buf += le16_to_cpu(de->rec_len);
 	}
@@ -2810,7 +2876,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 				   struct ocfs2_dir_lookup_result *lookup,
 				   struct buffer_head **first_block_bh)
 {
-	u32 alloc, dx_alloc, bit_off, len;
+	u32 alloc, dx_alloc, bit_off, len, num_dx_entries = 0;
 	struct super_block *sb = dir->i_sb;
 	int ret, i, num_dx_leaves = 0, dx_inline = 0,
 		credits = ocfs2_inline_to_extents_credits(sb);
@@ -2972,10 +3038,14 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 		/*
 		 * Dx dirs with an external cluster need to do this up
 		 * front. Inline dx root's get handled later, after
-		 * we've allocated our root block.
+		 * we've allocated our root block. We get passed back
+		 * a total number of items so that dr_num_entries can
+		 * be correctly set once the dx_root has been
+		 * allocated.
 		 */
 		ret = ocfs2_dx_dir_index_block(dir, handle, dx_leaves,
-					       num_dx_leaves, dirdata_bh);
+					       num_dx_leaves, &num_dx_entries,
+					       dirdata_bh);
 		if (ret) {
 			mlog_errno(ret);
 			goto out_commit;
@@ -3037,7 +3107,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 	if (ocfs2_supports_indexed_dirs(osb)) {
 		ret = ocfs2_dx_dir_attach_index(osb, handle, dir, di_bh,
 						dirdata_bh, meta_ac, dx_inline,
-						&dx_root_bh);
+						num_dx_entries, &dx_root_bh);
 		if (ret) {
 			mlog_errno(ret);
 			goto out_commit;
@@ -4202,6 +4272,12 @@ static int ocfs2_prepare_dx_dir_for_insert(struct inode *dir,
 	}
 
 	dx_root = (struct ocfs2_dx_root_block *)dx_root_bh->b_data;
+	if (le32_to_cpu(dx_root->dr_num_entries) == OCFS2_DX_ENTRIES_MAX) {
+		ret = -ENOSPC;
+		mlog_errno(ret);
+		goto out;
+	}
+
 	if (ocfs2_dx_root_inline(dx_root)) {
 		ret = ocfs2_inline_dx_has_space(dx_root_bh);
 
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 43da76e..f7a5201 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -421,6 +421,7 @@ static struct ocfs2_system_inode_info ocfs2_system_inodes[NUM_SYSTEM_INODES] = {
 #define OCFS2_LINK_MAX		32000
 #define	OCFS2_DX_LINK_MAX	((1U << 31) - 1U)
 #define	OCFS2_LINKS_HI_SHIFT	16
+#define	OCFS2_DX_ENTRIES_MAX	(0xffffffffU)
 
 #define S_SHIFT			12
 static unsigned char ocfs2_type_by_mode[S_IFMT >> S_SHIFT] = {
@@ -844,7 +845,10 @@ struct ocfs2_dx_root_block {
 	__u8		dr_reserved0;
 	__le16		dr_reserved1;
 	__le64		dr_dir_blkno;		/* Pointer to parent inode */
-	__le64		dr_reserved2;
+	__le32		dr_num_entries;		/* Total number of
+						 * names stored in
+						 * this directory.*/
+	__le32		dr_reserved2;
 	__le64		dr_free_blk;		/* Pointer to head of free
 						 * unindexed block list. */
 	__le64		dr_reserved3[15];
-- 
1.5.6
