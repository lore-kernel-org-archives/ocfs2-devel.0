From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Sep 19 13:12:24 2007
Subject: [Ocfs2-devel] [PATCH 15/15] ocfs2: Write support for directories
	with inline data
Message-ID: <200709192012.l8JKCHnX012247@agmgw2.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Create all new directories with OCFS2_INLINE_DATA_FL and the inline data
bytes formatted as an empty directory. Inode size field reflects the actual
amount of inline data available, which makes searching for dirent space
very similar to the regular directory search.

Inline-data directories are automatically pushed out to extents on any
insert request which is too large for the available space.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/alloc.c |   16 +-
 fs/ocfs2/alloc.h |    1 +
 fs/ocfs2/dir.c   |  618 +++++++++++++++++++++++++++++++++++++++++++++++-------
 fs/ocfs2/namei.c |   57 ++++--
 4 files changed, 594 insertions(+), 98 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 130624a..e728538 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -5866,6 +5866,15 @@ static void ocfs2_zero_dinode_id2(struct inode *inode, struct ocfs2_dinode *di)
 	memset(&di->id2, 0, blocksize - offsetof(struct ocfs2_dinode, id2));
 }
 
+void ocfs2_dinode_new_extent_list(struct inode *inode,
+				  struct ocfs2_dinode *di)
+{
+	ocfs2_zero_dinode_id2(inode, di);
+	di->id2.i_list.l_tree_depth = 0;
+	di->id2.i_list.l_next_free_rec = 0;
+	di->id2.i_list.l_count = cpu_to_le16(ocfs2_extent_recs_per_inode(inode->i_sb));
+}
+
 void ocfs2_set_inode_data_inline(struct inode *inode, struct ocfs2_dinode *di)
 {
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
@@ -5894,7 +5903,6 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
-	struct ocfs2_extent_list *el = &di->id2.i_list;
 	struct ocfs2_alloc_context *data_ac = NULL;
 	struct page **pages = NULL;
 	loff_t end = osb->s_clustersize;
@@ -5987,11 +5995,7 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 	di->i_dyn_features = cpu_to_le16(oi->ip_dyn_features);
 	spin_unlock(&oi->ip_lock);
 
-	ocfs2_zero_dinode_id2(inode, di);
-
-	el->l_tree_depth = 0;
-	el->l_next_free_rec = 0;
-	el->l_count = cpu_to_le16(ocfs2_extent_recs_per_inode(inode->i_sb));
+	ocfs2_dinode_new_extent_list(inode, di);
 
 	ocfs2_journal_dirty(handle, di_bh);
 
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index 826e0a6..42ff94b 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -62,6 +62,7 @@ static inline int ocfs2_extend_meta_needed(struct ocfs2_dinode *fe)
 	return le16_to_cpu(fe->id2.i_list.l_tree_depth) + 2;
 }
 
+void ocfs2_dinode_new_extent_list(struct inode *inode, struct ocfs2_dinode *di);
 void ocfs2_set_inode_data_inline(struct inode *inode, struct ocfs2_dinode *di);
 int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 					 struct buffer_head *di_bh);
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index f7aaf4e..b38a93d 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -72,6 +72,7 @@ static unsigned char ocfs2_filetype_table[] = {
 static int ocfs2_extend_dir(struct ocfs2_super *osb,
 			    struct inode *dir,
 			    struct buffer_head *parent_fe_bh,
+			    unsigned int blocks_wanted,
 			    struct buffer_head **new_de_bh);
 static int ocfs2_do_extend_dir(struct super_block *sb,
 			       handle_t *handle,
@@ -331,12 +332,20 @@ struct buffer_head *ocfs2_find_entry(const char *name, int namelen,
 	return ocfs2_find_entry_el(name, namelen, dir, res_dir);
 }
 
+/*
+ * Update inode number and type of a previously found directory entry.
+ */
 int ocfs2_update_entry(struct inode *dir, handle_t *handle,
 		       struct buffer_head *de_bh, struct ocfs2_dir_entry *de,
 		       struct inode *new_entry_inode)
 {
 	int ret;
 
+	/*
+	 * The same code works fine for both inline-data and extent
+	 * based directories, so no need to split this up.
+	 */
+
 	ret = ocfs2_journal_access(handle, dir, de_bh,
 				   OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
@@ -353,14 +362,10 @@ out:
 	return ret;
 }
 
-/*
- * ocfs2_delete_entry deletes a directory entry by merging it with the
- * previous entry
- */
-int ocfs2_delete_entry(handle_t *handle,
-		       struct inode *dir,
-		       struct ocfs2_dir_entry *de_del,
-		       struct buffer_head *bh)
+static int __ocfs2_delete_entry(handle_t *handle, struct inode *dir,
+				struct ocfs2_dir_entry *de_del,
+				struct buffer_head *bh, char *first_de,
+				unsigned int bytes)
 {
 	struct ocfs2_dir_entry *de, *pde;
 	int i, status = -ENOENT;
@@ -369,8 +374,8 @@ int ocfs2_delete_entry(handle_t *handle,
 
 	i = 0;
 	pde = NULL;
-	de = (struct ocfs2_dir_entry *) bh->b_data;
-	while (i < bh->b_size) {
+	de = (struct ocfs2_dir_entry *) first_de;
+	while (i < bytes) {
 		if (!ocfs2_check_dir_entry(dir, de, bh, i)) {
 			status = -EIO;
 			mlog_errno(status);
@@ -403,6 +408,58 @@ bail:
 	return status;
 }
 
+static inline int ocfs2_delete_entry_id(handle_t *handle,
+					struct inode *dir,
+					struct ocfs2_dir_entry *de_del,
+					struct buffer_head *bh)
+{
+	int ret;
+	struct buffer_head *di_bh = NULL;
+	struct ocfs2_dinode *di;
+	struct ocfs2_inline_data *data;
+
+	ret = ocfs2_read_block(OCFS2_SB(dir->i_sb), OCFS2_I(dir)->ip_blkno,
+			       &di_bh, OCFS2_BH_CACHED, dir);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	di = (struct ocfs2_dinode *)di_bh->b_data;
+	data = &di->id2.i_data;
+
+	ret = __ocfs2_delete_entry(handle, dir, de_del, bh, data->id_data,
+				   i_size_read(dir));
+
+	brelse(di_bh);
+out:
+	return ret;
+}
+
+static inline int ocfs2_delete_entry_el(handle_t *handle,
+					struct inode *dir,
+					struct ocfs2_dir_entry *de_del,
+					struct buffer_head *bh)
+{
+	return __ocfs2_delete_entry(handle, dir, de_del, bh, bh->b_data,
+				    bh->b_size);
+}
+
+/*
+ * ocfs2_delete_entry deletes a directory entry by merging it with the
+ * previous entry
+ */
+int ocfs2_delete_entry(handle_t *handle,
+		       struct inode *dir,
+		       struct ocfs2_dir_entry *de_del,
+		       struct buffer_head *bh)
+{
+	if (OCFS2_I(dir)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
+		return ocfs2_delete_entry_id(handle, dir, de_del, bh);
+
+	return ocfs2_delete_entry_el(handle, dir, de_del, bh);
+}
+
 /*
  * Check whether 'de' has enough room to hold an entry of
  * 'new_rec_len' bytes.
@@ -444,21 +501,30 @@ int __ocfs2_add_entry(handle_t *handle,
 	unsigned long offset;
 	unsigned short rec_len;
 	struct ocfs2_dir_entry *de, *de1;
-	struct super_block *sb;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)parent_fe_bh->b_data;
+	struct super_block *sb = dir->i_sb;
 	int retval, status;
+	unsigned int size = sb->s_blocksize;
+	char *data_start = insert_bh->b_data;
 
 	mlog_entry_void();
 
-	sb = dir->i_sb;
-
 	if (!namelen)
 		return -EINVAL;
 
+	if (OCFS2_I(dir)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
+		data_start = di->id2.i_data.id_data;
+		size = i_size_read(dir);
+
+		BUG_ON(insert_bh != parent_fe_bh);
+	}
+
 	rec_len = OCFS2_DIR_REC_LEN(namelen);
 	offset = 0;
-	de = (struct ocfs2_dir_entry *) insert_bh->b_data;
+	de = (struct ocfs2_dir_entry *) data_start;
 	while (1) {
-		BUG_ON((char *)de >= sb->s_blocksize + insert_bh->b_data);
+		BUG_ON((char *)de >= (size + data_start));
+
 		/* These checks should've already been passed by the
 		 * prepare function, but I guess we can leave them
 		 * here anyway. */
@@ -939,16 +1005,78 @@ int ocfs2_empty_dir(struct inode *inode)
 	return !priv.seen_other;
 }
 
-int ocfs2_fill_new_dir(struct ocfs2_super *osb,
-		       handle_t *handle,
-		       struct inode *parent,
-		       struct inode *inode,
-		       struct buffer_head *fe_bh,
-		       struct ocfs2_alloc_context *data_ac)
+static void ocfs2_fill_initial_dirents(struct inode *inode,
+				       struct inode *parent,
+				       char *start, unsigned int size)
+{
+	struct ocfs2_dir_entry *de = (struct ocfs2_dir_entry *)start;
+
+	de->inode = cpu_to_le64(OCFS2_I(inode)->ip_blkno);
+	de->name_len = 1;
+	de->rec_len =
+		cpu_to_le16(OCFS2_DIR_REC_LEN(de->name_len));
+	strcpy(de->name, ".");
+	ocfs2_set_de_type(de, S_IFDIR);
+
+	de = (struct ocfs2_dir_entry *) ((char *)de + le16_to_cpu(de->rec_len));
+	de->inode = cpu_to_le64(OCFS2_I(parent)->ip_blkno);
+	de->rec_len = cpu_to_le16(size - OCFS2_DIR_REC_LEN(1));
+	de->name_len = 2;
+	strcpy(de->name, "..");
+	ocfs2_set_de_type(de, S_IFDIR);
+}
+
+/*
+ * This works together with code in ocfs2_mknod_locked() which sets
+ * the inline-data flag and initializes the inline-data section.
+ */
+static int ocfs2_fill_new_dir_id(struct ocfs2_super *osb,
+				 handle_t *handle,
+				 struct inode *parent,
+				 struct inode *inode,
+				 struct buffer_head *di_bh)
+{
+	int ret;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+	struct ocfs2_inline_data *data = &di->id2.i_data;
+	unsigned int size = le16_to_cpu(data->id_count);
+
+	ret = ocfs2_journal_access(handle, inode, di_bh,
+				   OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ocfs2_fill_initial_dirents(inode, parent, data->id_data, size);
+
+	ocfs2_journal_dirty(handle, di_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	i_size_write(inode, size);
+	inode->i_nlink = 2;
+	inode->i_blocks = ocfs2_inode_sector_count(inode);
+
+	ret = ocfs2_mark_inode_dirty(handle, inode, di_bh);
+	if (ret < 0)
+		mlog_errno(ret);
+
+out:
+	return ret;
+}
+
+static int ocfs2_fill_new_dir_el(struct ocfs2_super *osb,
+				 handle_t *handle,
+				 struct inode *parent,
+				 struct inode *inode,
+				 struct buffer_head *fe_bh,
+				 struct ocfs2_alloc_context *data_ac)
 {
 	int status;
 	struct buffer_head *new_bh = NULL;
-	struct ocfs2_dir_entry *de = NULL;
 
 	mlog_entry_void();
 
@@ -969,20 +1097,8 @@ int ocfs2_fill_new_dir(struct ocfs2_super *osb,
 	}
 	memset(new_bh->b_data, 0, osb->sb->s_blocksize);
 
-	de = (struct ocfs2_dir_entry *) new_bh->b_data;
-	de->inode = cpu_to_le64(OCFS2_I(inode)->ip_blkno);
-	de->name_len = 1;
-	de->rec_len =
-		cpu_to_le16(OCFS2_DIR_REC_LEN(de->name_len));
-	strcpy(de->name, ".");
-	ocfs2_set_de_type(de, S_IFDIR);
-	de = (struct ocfs2_dir_entry *) ((char *)de + le16_to_cpu(de->rec_len));
-	de->inode = cpu_to_le64(OCFS2_I(parent)->ip_blkno);
-	de->rec_len = cpu_to_le16(inode->i_sb->s_blocksize -
-				  OCFS2_DIR_REC_LEN(1));
-	de->name_len = 2;
-	strcpy(de->name, "..");
-	ocfs2_set_de_type(de, S_IFDIR);
+	ocfs2_fill_initial_dirents(inode, parent, new_bh->b_data,
+				   osb->sb->s_blocksize);
 
 	status = ocfs2_journal_dirty(handle, new_bh);
 	if (status < 0) {
@@ -1008,6 +1124,230 @@ bail:
 	return status;
 }
 
+int ocfs2_fill_new_dir(struct ocfs2_super *osb,
+		       handle_t *handle,
+		       struct inode *parent,
+		       struct inode *inode,
+		       struct buffer_head *fe_bh,
+		       struct ocfs2_alloc_context *data_ac)
+{
+	BUG_ON(!ocfs2_supports_inline_data(osb) && data_ac == NULL);
+
+	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
+		return ocfs2_fill_new_dir_id(osb, handle, parent, inode, fe_bh);
+
+	return ocfs2_fill_new_dir_el(osb, handle, parent, inode, fe_bh,
+				     data_ac);
+}
+
+static void ocfs2_expand_last_dirent(char *start, unsigned int old_size,
+				     unsigned int new_size)
+{
+	struct ocfs2_dir_entry *de;
+	struct ocfs2_dir_entry *prev_de;
+	char *de_buf, *limit;
+	unsigned int bytes = new_size - old_size;
+
+	limit = start + old_size;
+	de_buf = start;
+	de = (struct ocfs2_dir_entry *)de_buf;
+	do {
+		prev_de = de;
+		de_buf += le16_to_cpu(de->rec_len);
+		de = (struct ocfs2_dir_entry *)de_buf;
+	} while (de_buf < limit);
+
+	le16_add_cpu(&prev_de->rec_len, bytes);
+}
+
+/*
+ * We allocate enough clusters to fulfill "blocks_wanted", but set
+ * i_size to exactly one block. Ocfs2_extend_dir() will handle the
+ * rest automatically for us.
+ *
+ * *first_block_bh is a pointer to the 1st data block allocated to the
+ *  directory.
+ */
+static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
+				   unsigned int blocks_wanted,
+				   struct buffer_head **first_block_bh)
+{
+	int ret, credits = OCFS2_INLINE_TO_EXTENTS_CREDITS;
+	u32 alloc, bit_off, len;
+	struct super_block *sb = dir->i_sb;
+	u64 blkno, bytes = blocks_wanted << sb->s_blocksize_bits;
+	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
+	struct ocfs2_inode_info *oi = OCFS2_I(dir);
+	struct ocfs2_alloc_context *data_ac;
+	struct buffer_head *dirdata_bh = NULL;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+	handle_t *handle;
+
+	alloc = ocfs2_clusters_for_bytes(sb, bytes);
+
+	/*
+	 * We should never need more than 2 clusters for this -
+	 * maximum dirent size is far less than one block. In fact,
+	 * the only time we'd need more than one cluster is if
+	 * blocksize == clustersize and the dirent won't fit in the
+	 * extra space that the expansion to a single block gives. As
+	 * of today, that only happens on 4k/4k file systems.
+	 */
+	BUG_ON(alloc > 2);
+
+	ret = ocfs2_reserve_clusters(osb, alloc, &data_ac);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	down_write(&oi->ip_alloc_sem);
+
+	/*
+	 * Prepare for worst case allocation scenario of two seperate
+	 * extents.
+	 */
+	if (alloc == 2)
+		credits += OCFS2_SUBALLOC_ALLOC;
+
+	handle = ocfs2_start_trans(osb, credits);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		mlog_errno(ret);
+		goto out_sem;
+	}
+
+	/*
+	 * Try to claim as many clusters as the bitmap can give though
+	 * if we only get one now, that's enough to continue. The rest
+	 * will be claimed after the conversion to extents.
+	 */
+	ret = ocfs2_claim_clusters(osb, handle, data_ac, 1, &bit_off, &len);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	/*
+	 * Operations are carefully ordered so that we set up the new
+	 * data block first. The conversion from inline data to
+	 * extents follows.
+	 */
+	blkno = ocfs2_clusters_to_blocks(dir->i_sb, bit_off);
+	dirdata_bh = sb_getblk(sb, blkno);
+	if (!dirdata_bh) {
+		ret = -EIO;
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	ocfs2_set_new_buffer_uptodate(dir, dirdata_bh);
+
+	ret = ocfs2_journal_access(handle, dir, dirdata_bh,
+				   OCFS2_JOURNAL_ACCESS_CREATE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	memcpy(dirdata_bh->b_data, di->id2.i_data.id_data, i_size_read(dir));
+	memset(dirdata_bh->b_data + i_size_read(dir), 0,
+	       sb->s_blocksize - i_size_read(dir));
+	ocfs2_expand_last_dirent(dirdata_bh->b_data, i_size_read(dir),
+				 sb->s_blocksize);
+
+	ret = ocfs2_journal_dirty(handle, dirdata_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	/*
+	 * Set extent, i_size, etc on the directory. After this, the
+	 * inode should contain the same exact dirents as before and
+	 * be fully accessible from system calls.
+	 *
+	 * We let the later dirent insert modify c/mtime - to the user
+	 * the data hasn't changed.
+	 */
+	ret = ocfs2_journal_access(handle, dir, di_bh,
+				   OCFS2_JOURNAL_ACCESS_CREATE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	spin_lock(&oi->ip_lock);
+	oi->ip_dyn_features &= ~OCFS2_INLINE_DATA_FL;
+	di->i_dyn_features = cpu_to_le16(oi->ip_dyn_features);
+	spin_unlock(&oi->ip_lock);
+
+	ocfs2_dinode_new_extent_list(dir, di);
+
+	i_size_write(dir, sb->s_blocksize);
+	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
+
+	di->i_size = cpu_to_le64(sb->s_blocksize);
+	di->i_ctime = di->i_mtime = cpu_to_le64(dir->i_ctime.tv_sec);
+	di->i_ctime_nsec = di->i_mtime_nsec = cpu_to_le32(dir->i_ctime.tv_nsec);
+	dir->i_blocks = ocfs2_inode_sector_count(dir);
+
+	/*
+	 * This should never fail as our extent list is empty and all
+	 * related blocks have been journaled already.
+	 */
+	ret = ocfs2_insert_extent(osb, handle, dir, di_bh, 0, blkno, len, 0,
+				  NULL);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_journal_dirty(handle, di_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	/*
+	 * We asked for two clusters, but only got one in the 1st
+	 * pass. Claim the 2nd cluster as a separate extent.
+	 */
+	if (alloc > len) {
+		ret = ocfs2_claim_clusters(osb, handle, data_ac, 1, &bit_off,
+					   &len);
+		if (ret) {
+			mlog_errno(ret);
+			goto out_commit;
+		}
+		blkno = ocfs2_clusters_to_blocks(dir->i_sb, bit_off);
+
+		ret = ocfs2_insert_extent(osb, handle, dir, di_bh, 1, blkno,
+					  len, 0, NULL);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+	}
+
+	*first_block_bh = dirdata_bh;
+	dirdata_bh = NULL;
+
+out_commit:
+	ocfs2_commit_trans(osb, handle);
+
+out_sem:
+	up_write(&oi->ip_alloc_sem);
+
+out:
+	if (data_ac)
+		ocfs2_free_alloc_context(data_ac);
+
+	brelse(dirdata_bh);
+
+	return ret;
+}
+
 /* returns a bh of the 1st new block in the allocation. */
 static int ocfs2_do_extend_dir(struct super_block *sb,
 			       handle_t *handle,
@@ -1057,10 +1397,18 @@ bail:
 	return status;
 }
 
-/* assumes you already have a cluster lock on the directory. */
+/*
+ * Assumes you already have a cluster lock on the directory.
+ *
+ * 'blocks_wanted' is only used if we have an inline directory which
+ * is to be turned into an extent based one. The size of the dirent to
+ * insert might be larger than the space gained by growing to just one
+ * block, so we may have to grow the inode by two blocks in that case.
+ */
 static int ocfs2_extend_dir(struct ocfs2_super *osb,
 			    struct inode *dir,
 			    struct buffer_head *parent_fe_bh,
+			    unsigned int blocks_wanted,
 			    struct buffer_head **new_de_bh)
 {
 	int status = 0;
@@ -1076,6 +1424,38 @@ static int ocfs2_extend_dir(struct ocfs2_super *osb,
 
 	mlog_entry_void();
 
+	if (OCFS2_I(dir)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
+		status = ocfs2_expand_inline_dir(dir, parent_fe_bh,
+						 blocks_wanted, &new_bh);
+		if (status) {
+			mlog_errno(status);
+			goto bail;
+		}
+
+		if (blocks_wanted == 1) {
+			/*
+			 * If the new dirent will fit inside the space
+			 * created by pushing out to one block, then
+			 * we can complete the operation
+			 * here. Otherwise we have to expand i_size
+			 * and format the 2nd block below.
+			 */
+			BUG_ON(new_bh == NULL);
+			goto bail_bh;
+		}
+
+		/*
+		 * Get rid of 'new_bh' - we want to format the 2nd
+		 * data block and return that instead.
+		 */
+		brelse(new_bh);
+		new_bh = NULL;
+
+		dir_i_size = i_size_read(dir);
+		credits = OCFS2_SIMPLE_DIR_EXTEND_CREDITS;
+		goto do_extend;
+	}
+
 	dir_i_size = i_size_read(dir);
 	mlog(0, "extending dir %llu (i_size = %lld)\n",
 	     (unsigned long long)OCFS2_I(dir)->ip_blkno, dir_i_size);
@@ -1113,6 +1493,7 @@ static int ocfs2_extend_dir(struct ocfs2_super *osb,
 		credits = OCFS2_SIMPLE_DIR_EXTEND_CREDITS;
 	}
 
+do_extend:
 	down_write(&OCFS2_I(dir)->ip_alloc_sem);
 	drop_alloc_sem = 1;
 
@@ -1158,6 +1539,7 @@ static int ocfs2_extend_dir(struct ocfs2_super *osb,
 		goto bail;
 	}
 
+bail_bh:
 	*new_de_bh = new_bh;
 	get_bh(*new_de_bh);
 bail:
@@ -1178,41 +1560,71 @@ bail:
 	return status;
 }
 
-/*
- * Search the dir for a good spot, extending it if necessary. The
- * block containing an appropriate record is returned in ret_de_bh.
- */
-int ocfs2_prepare_dir_for_insert(struct ocfs2_super *osb,
-				 struct inode *dir,
-				 struct buffer_head *parent_fe_bh,
-				 const char *name,
-				 int namelen,
-				 struct buffer_head **ret_de_bh)
+static int ocfs2_find_dir_space_id(struct inode *dir, struct buffer_head *di_bh,
+				   const char *name, int namelen,
+				   struct buffer_head **ret_de_bh,
+				   unsigned int *blocks_wanted)
 {
-	unsigned long offset;
-	struct buffer_head * bh = NULL;
-	unsigned short rec_len;
-	struct ocfs2_dinode *fe;
-	struct ocfs2_dir_entry *de;
-	struct super_block *sb;
-	int status;
+	int ret;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+	struct ocfs2_dir_entry *de, *last_de = NULL;
+	char *de_buf, *limit;
+	unsigned long offset = 0;
+	unsigned int rec_len, new_rec_len;
+
+	de_buf = di->id2.i_data.id_data;
+	limit = de_buf + i_size_read(dir);
+	rec_len = OCFS2_DIR_REC_LEN(namelen);
 
-	mlog_entry_void();
+	while (de_buf < limit) {
+		de = (struct ocfs2_dir_entry *)de_buf;
 
-	mlog(0, "getting ready to insert namelen %d into dir %llu\n",
-	     namelen, (unsigned long long)OCFS2_I(dir)->ip_blkno);
+		if (!ocfs2_check_dir_entry(dir, de, di_bh, offset)) {
+			ret = -ENOENT;
+			goto out;
+		}
+		if (ocfs2_match(namelen, name, de)) {
+			ret = -EEXIST;
+			goto out;
+		}
+		if (ocfs2_dirent_would_fit(de, rec_len)) {
+			/* Ok, we found a spot. Return this bh and let
+			 * the caller actually fill it in. */
+			*ret_de_bh = di_bh;
+			get_bh(*ret_de_bh);
+			ret = 0;
+			goto out;
+		}
 
-	BUG_ON(!S_ISDIR(dir->i_mode));
-	fe = (struct ocfs2_dinode *) parent_fe_bh->b_data;
-	BUG_ON(le64_to_cpu(fe->i_size) != i_size_read(dir));
+		last_de = de;
+		de_buf += le16_to_cpu(de->rec_len);
+		offset += le16_to_cpu(de->rec_len);
+	}
 
-	sb = dir->i_sb;
+	/*
+	 * We're going to require expansion of the directory - figure
+	 * out how many blocks we'll need so that a place for the
+	 * dirent can be found.
+	 */
+	*blocks_wanted = 1;
+	new_rec_len = le16_to_cpu(last_de->rec_len) + (dir->i_sb->s_blocksize - i_size_read(dir));
+	if (new_rec_len < rec_len)
+		*blocks_wanted = 2;
 
-	if (!namelen) {
-		status = -EINVAL;
-		mlog_errno(status);
-		goto bail;
-	}
+	ret = -ENOSPC;
+out:
+	return ret;
+}
+
+static int ocfs2_find_dir_space_el(struct inode *dir, const char *name,
+				   int namelen, struct buffer_head **ret_de_bh)
+{
+	unsigned long offset;
+	struct buffer_head *bh = NULL;
+	unsigned short rec_len;
+	struct ocfs2_dir_entry *de;
+	struct super_block *sb = dir->i_sb;
+	int status;
 
 	bh = ocfs2_bread(dir, 0, &status, 0);
 	if (!bh) {
@@ -1229,17 +1641,11 @@ int ocfs2_prepare_dir_for_insert(struct ocfs2_super *osb,
 			bh = NULL;
 
 			if (i_size_read(dir) <= offset) {
-				status = ocfs2_extend_dir(osb,
-							  dir,
-							  parent_fe_bh,
-							  &bh);
-				if (status < 0) {
-					mlog_errno(status);
-					goto bail;
-				}
-				BUG_ON(!bh);
-				*ret_de_bh = bh;
-				get_bh(*ret_de_bh);
+				/*
+				 * Caller will have to expand this
+				 * directory.
+				 */
+				status = -ENOSPC;
 				goto bail;
 			}
 			bh = ocfs2_bread(dir,
@@ -1281,3 +1687,61 @@ bail:
 	mlog_exit(status);
 	return status;
 }
+
+int ocfs2_prepare_dir_for_insert(struct ocfs2_super *osb,
+				 struct inode *dir,
+				 struct buffer_head *parent_fe_bh,
+				 const char *name,
+				 int namelen,
+				 struct buffer_head **ret_de_bh)
+{
+	int ret;
+	unsigned int blocks_wanted = 1;
+	struct buffer_head *bh = NULL;
+
+	mlog(0, "getting ready to insert namelen %d into dir %llu\n",
+	     namelen, (unsigned long long)OCFS2_I(dir)->ip_blkno);
+
+	*ret_de_bh = NULL;
+
+	if (!namelen) {
+		ret = -EINVAL;
+		mlog_errno(ret);
+		goto out;
+	}
+
+	if (OCFS2_I(dir)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
+		ret = ocfs2_find_dir_space_id(dir, parent_fe_bh, name,
+					      namelen, &bh, &blocks_wanted);
+	} else
+		ret = ocfs2_find_dir_space_el(dir, name, namelen, &bh);
+
+	if (ret && ret != -ENOSPC) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	if (ret == -ENOSPC) {
+		/*
+		 * We have to expand the directory to add this name.
+		 */
+		BUG_ON(bh);
+
+		ret = ocfs2_extend_dir(osb, dir, parent_fe_bh, blocks_wanted,
+				       &bh);
+		if (ret) {
+			if (ret != -ENOSPC)
+				mlog_errno(ret);
+			goto out;
+		}
+
+		BUG_ON(!bh);
+	}
+
+	*ret_de_bh = bh;
+	bh = NULL;
+out:
+	if (bh)
+		brelse(bh);
+	return ret;
+}
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index d2f0335..7292590 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -250,9 +250,8 @@ static int ocfs2_mknod(struct inode *dir,
 		goto leave;
 	}
 
-	/* are we making a directory? If so, reserve a cluster for his
-	 * 1st extent. */
-	if (S_ISDIR(mode)) {
+	/* Reserve a cluster if creating an extent based directory. */
+	if (S_ISDIR(mode) && !ocfs2_supports_inline_data(osb)) {
 		status = ocfs2_reserve_clusters(osb, 1, &data_ac);
 		if (status < 0) {
 			if (status != -ENOSPC)
@@ -449,10 +448,21 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 		cpu_to_le32(CURRENT_TIME.tv_nsec);
 	fe->i_dtime = 0;
 
-	fel = &fe->id2.i_list;
-	fel->l_tree_depth = 0;
-	fel->l_next_free_rec = 0;
-	fel->l_count = cpu_to_le16(ocfs2_extent_recs_per_inode(osb->sb));
+	/*
+	 * If supported, directories start with inline data.
+	 */
+	if (S_ISDIR(mode) && ocfs2_supports_inline_data(osb)) {
+		u16 feat = le16_to_cpu(fe->i_dyn_features);
+
+		fe->i_dyn_features = cpu_to_le16(feat | OCFS2_INLINE_DATA_FL);
+
+		fe->id2.i_data.id_count = cpu_to_le16(ocfs2_max_inline_data(osb->sb));
+	} else {
+		fel = &fe->id2.i_list;
+		fel->l_tree_depth = 0;
+		fel->l_next_free_rec = 0;
+		fel->l_count = cpu_to_le16(ocfs2_extent_recs_per_inode(osb->sb));
+	}
 
 	status = ocfs2_journal_dirty(handle, *new_fe_bh);
 	if (status < 0) {
@@ -950,7 +960,7 @@ static int ocfs2_rename(struct inode *old_dir,
 	struct buffer_head *old_inode_bh = NULL;
 	struct buffer_head *insert_entry_bh = NULL;
 	struct ocfs2_super *osb = NULL;
-	u64 newfe_blkno;
+	u64 newfe_blkno, old_de_ino;
 	handle_t *handle = NULL;
 	struct buffer_head *old_dir_bh = NULL;
 	struct buffer_head *new_dir_bh = NULL;
@@ -1061,12 +1071,13 @@ static int ocfs2_rename(struct inode *old_dir,
 		}
 	}
 
-	status = -ENOENT;
-	old_de_bh = ocfs2_find_entry(old_dentry->d_name.name,
-				     old_dentry->d_name.len,
-				     old_dir, &old_de);
-	if (!old_de_bh)
+	status = ocfs2_lookup_ino_from_name(old_dir, old_dentry->d_name.name,
+					    old_dentry->d_name.len,
+					    &old_de_ino);
+	if (status) {
+		status = -ENOENT;
 		goto bail;
+	}
 
 	/*
 	 *  Check for inode number is _not_ due to possible IO errors.
@@ -1074,8 +1085,10 @@ static int ocfs2_rename(struct inode *old_dir,
 	 *  and merrily kill the link to whatever was created under the
 	 *  same name. Goodbye sticky bit ;-<
 	 */
-	if (le64_to_cpu(old_de->inode) != OCFS2_I(old_inode)->ip_blkno)
+	if (old_de_ino != OCFS2_I(old_inode)->ip_blkno) {
+		status = -ENOENT;
 		goto bail;
+	}
 
 	/* check if the target already exists (in which case we need
 	 * to delete it */
@@ -1250,7 +1263,21 @@ static int ocfs2_rename(struct inode *old_dir,
 	} else
 		mlog_errno(status);
 
-	/* now that the name has been added to new_dir, remove the old name */
+	/*
+	 * Now that the name has been added to new_dir, remove the old name.
+	 *
+	 * We don't keep any directory entry context around until now
+	 * because the insert might have changed the type of directory
+	 * we're dealing with.
+	 */
+	old_de_bh = ocfs2_find_entry(old_dentry->d_name.name,
+				     old_dentry->d_name.len,
+				     old_dir, &old_de);
+	if (!old_de_bh) {
+		status = -EIO;
+		goto bail;
+	}
+
 	status = ocfs2_delete_entry(handle, old_dir, old_de, old_de_bh);
 	if (status < 0) {
 		mlog_errno(status);
-- 
1.5.0.6
