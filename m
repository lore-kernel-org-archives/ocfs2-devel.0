From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 17 Mar 2009 13:00:58 -0700
Subject: [Ocfs2-devel] [PATCH 08/32] ocfs2: Introduce dir free space list
In-Reply-To: <1237320082-12921-1-git-send-email-mfasheh@suse.com>
References: <1237320082-12921-1-git-send-email-mfasheh@suse.com>
Message-ID: <1237320082-12921-9-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>

The only operation which doesn't get faster with directory indexing is
insert, which still has to walk the entire unindexed directory portion to
find a free block. This patch provides an improvement in directory insert
performance by maintaining a singly linked list of directory leaf blocks
which have space for additional dirents.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
Acked-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/dir.c      |  558 +++++++++++++++++++++++++++++++++++++++++++--------
 fs/ocfs2/dir.h      |    8 +
 fs/ocfs2/journal.h  |   12 +-
 fs/ocfs2/ocfs2_fs.h |    5 +-
 4 files changed, 490 insertions(+), 93 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 47de649..52df912 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -80,22 +80,36 @@ static int ocfs2_do_extend_dir(struct super_block *sb,
 			       struct ocfs2_alloc_context *data_ac,
 			       struct ocfs2_alloc_context *meta_ac,
 			       struct buffer_head **new_bh);
+static int ocfs2_dir_indexed(struct inode *inode);
 
 /*
  * These are distinct checks because future versions of the file system will
  * want to have a trailing dirent structure independent of indexing.
  */
-static int ocfs2_dir_has_trailer(struct inode *dir)
+static int ocfs2_supports_dir_trailer(struct inode *dir)
 {
+	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
+
 	if (OCFS2_I(dir)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
 		return 0;
 
-	return ocfs2_meta_ecc(OCFS2_SB(dir->i_sb));
+	return ocfs2_meta_ecc(osb) || ocfs2_dir_indexed(dir);
 }
 
-static int ocfs2_supports_dir_trailer(struct ocfs2_super *osb)
+/*
+ * "new' here refers to the point at which we're creating a new
+ * directory via "mkdir()", but also when we're expanding an inline
+ * directory. In either case, we don't yet have the indexing bit set
+ * on the directory, so the standard checks will fail in when metaecc
+ * is turned off. Only directory-initialization type functions should
+ * use this then. Everything else wants ocfs2_supports_dir_trailer()
+ */
+static int ocfs2_new_dir_wants_trailer(struct inode *dir)
 {
-	return ocfs2_meta_ecc(osb);
+	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
+
+	return ocfs2_meta_ecc(osb) ||
+		ocfs2_supports_indexed_dirs(osb);
 }
 
 static inline unsigned int ocfs2_dir_trailer_blk_off(struct super_block *sb)
@@ -127,7 +141,7 @@ static int ocfs2_skip_dir_trailer(struct inode *dir,
 {
 	unsigned long toff = blklen - sizeof(struct ocfs2_dir_block_trailer);
 
-	if (!ocfs2_dir_has_trailer(dir))
+	if (!ocfs2_supports_dir_trailer(dir))
 		return 0;
 
 	if (offset != toff)
@@ -137,7 +151,7 @@ static int ocfs2_skip_dir_trailer(struct inode *dir,
 }
 
 static void ocfs2_init_dir_trailer(struct inode *inode,
-				   struct buffer_head *bh)
+				   struct buffer_head *bh, u16 rec_len)
 {
 	struct ocfs2_dir_block_trailer *trailer;
 
@@ -147,6 +161,42 @@ static void ocfs2_init_dir_trailer(struct inode *inode,
 			cpu_to_le16(sizeof(struct ocfs2_dir_block_trailer));
 	trailer->db_parent_dinode = cpu_to_le64(OCFS2_I(inode)->ip_blkno);
 	trailer->db_blkno = cpu_to_le64(bh->b_blocknr);
+	trailer->db_free_rec_len = cpu_to_le16(rec_len);
+}
+/*
+ * Link an unindexed block with a dir trailer structure into the index free
+ * list. This function will modify dirdata_bh, but assumes you've already
+ * passed it to the journal.
+ */
+static int ocfs2_dx_dir_link_trailer(struct inode *dir, handle_t *handle,
+				     struct buffer_head *dx_root_bh,
+				     struct buffer_head *dirdata_bh)
+{
+	int ret;
+	struct ocfs2_dx_root_block *dx_root;
+	struct ocfs2_dir_block_trailer *trailer;
+
+	ret = ocfs2_journal_access_dr(handle, dir, dx_root_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+	trailer = ocfs2_trailer_from_bh(dirdata_bh, dir->i_sb);
+	dx_root = (struct ocfs2_dx_root_block *)dx_root_bh->b_data;
+
+	trailer->db_free_next = dx_root->dr_free_blk;
+	dx_root->dr_free_blk = cpu_to_le64(dirdata_bh->b_blocknr);
+
+	ocfs2_journal_dirty(handle, dx_root_bh);
+
+out:
+	return ret;
+}
+
+static int ocfs2_free_list_at_root(struct ocfs2_dir_lookup_result *res)
+{
+	return res->dl_prev_leaf_bh == NULL;
 }
 
 void ocfs2_free_dir_lookup_result(struct ocfs2_dir_lookup_result *res)
@@ -154,6 +204,7 @@ void ocfs2_free_dir_lookup_result(struct ocfs2_dir_lookup_result *res)
 	brelse(res->dl_dx_root_bh);
 	brelse(res->dl_leaf_bh);
 	brelse(res->dl_dx_leaf_bh);
+	brelse(res->dl_prev_leaf_bh);
 }
 
 static int ocfs2_dir_indexed(struct inode *inode)
@@ -484,7 +535,7 @@ static int ocfs2_read_dir_block(struct inode *inode, u64 v_block,
 	}
 
 	if (!(flags & OCFS2_BH_READAHEAD) &&
-	    ocfs2_dir_has_trailer(inode)) {
+	    ocfs2_supports_dir_trailer(inode)) {
 		rc = ocfs2_check_dir_trailer(inode, tmp);
 		if (rc) {
 			if (!*bh)
@@ -1150,6 +1201,47 @@ bail:
 	return status;
 }
 
+static unsigned int ocfs2_figure_dirent_hole(struct ocfs2_dir_entry *de)
+{
+	unsigned int hole;
+
+	if (le64_to_cpu(de->inode) == 0)
+		hole = le16_to_cpu(de->rec_len);
+	else
+		hole = le16_to_cpu(de->rec_len) -
+			OCFS2_DIR_REC_LEN(de->name_len);
+
+	return hole;
+}
+
+static int ocfs2_find_max_rec_len(struct super_block *sb,
+				  struct buffer_head *dirblock_bh)
+{
+	int size, this_hole, largest_hole = 0;
+	char *trailer, *de_buf, *limit, *start = dirblock_bh->b_data;
+	struct ocfs2_dir_entry *de;
+
+	trailer = (char *)ocfs2_trailer_from_bh(dirblock_bh, sb);
+	size = ocfs2_dir_trailer_blk_off(sb);
+	limit = start + size;
+	de_buf = start;
+	de = (struct ocfs2_dir_entry *)de_buf;
+	do {
+		if (de_buf != trailer) {
+			this_hole = ocfs2_figure_dirent_hole(de);
+			if (this_hole > largest_hole)
+				largest_hole = this_hole;
+		}
+
+		de_buf += le16_to_cpu(de->rec_len);
+		de = (struct ocfs2_dir_entry *)de_buf;
+	} while (de_buf < limit);
+
+	if (largest_hole >= OCFS2_DIR_MIN_REC_LEN)
+		return largest_hole;
+	return 0;
+}
+
 static void ocfs2_dx_list_remove_entry(struct ocfs2_dx_entry_list *entry_list,
 				       int index)
 {
@@ -1171,14 +1263,26 @@ clear:
 static int ocfs2_delete_entry_dx(handle_t *handle, struct inode *dir,
 				 struct ocfs2_dir_lookup_result *lookup)
 {
-	int ret, index;
+	int ret, index, max_rec_len, add_to_free_list = 0;
 	struct buffer_head *dx_root_bh = lookup->dl_dx_root_bh;
 	struct buffer_head *leaf_bh = lookup->dl_leaf_bh;
 	struct ocfs2_dx_leaf *dx_leaf;
 	struct ocfs2_dx_entry *dx_entry = lookup->dl_dx_entry;
+	struct ocfs2_dir_block_trailer *trailer;
 	struct ocfs2_dx_root_block *dx_root;
 	struct ocfs2_dx_entry_list *entry_list;
 
+	/*
+	 * This function gets a bit messy because we might have to
+	 * modify the root block, regardless of whether the indexed
+	 * entries are stored inline.
+	 */
+
+	/*
+	 * *Only* set 'entry_list' here, based on where we're looking
+	 * for the indexed entries. Later, we might still want to
+	 * journal both blocks, based on free list state.
+	 */
 	dx_root = (struct ocfs2_dx_root_block *)dx_root_bh->b_data;
 	if (ocfs2_dx_root_inline(dx_root)) {
 		entry_list = &dx_root->dr_entries;
@@ -1203,6 +1307,15 @@ static int ocfs2_delete_entry_dx(handle_t *handle, struct inode *dir,
 	}
 
 	/*
+	 * We know that removal of this dirent will leave enough room
+	 * for a new one, so add this block to the free list if it
+	 * isn't already there.
+	 */
+	trailer = ocfs2_trailer_from_bh(leaf_bh, dir->i_sb);
+	if (trailer->db_free_rec_len == 0)
+		add_to_free_list = 1;
+
+	/*
 	 * Add the block holding our index into the journal before
 	 * removing the unindexed entry. If we get an error return
 	 * from __ocfs2_delete_entry(), then it hasn't removed the
@@ -1212,14 +1325,16 @@ static int ocfs2_delete_entry_dx(handle_t *handle, struct inode *dir,
 	 * We're also careful to journal the root tree block here if
 	 * we're going to be adding to the start of the free list.
 	 */
-	if (ocfs2_dx_root_inline(dx_root)) {
+	if (add_to_free_list || ocfs2_dx_root_inline(dx_root)) {
 		ret = ocfs2_journal_access_dr(handle, dir, dx_root_bh,
 					      OCFS2_JOURNAL_ACCESS_WRITE);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
 		}
-	} else {
+	}
+
+	if (!ocfs2_dx_root_inline(dx_root)) {
 		ret = ocfs2_journal_access_dl(handle, dir,
 					      lookup->dl_dx_leaf_bh,
 					      OCFS2_JOURNAL_ACCESS_WRITE);
@@ -1239,6 +1354,17 @@ static int ocfs2_delete_entry_dx(handle_t *handle, struct inode *dir,
 		goto out;
 	}
 
+	max_rec_len = ocfs2_find_max_rec_len(dir->i_sb, leaf_bh);
+	trailer->db_free_rec_len = cpu_to_le16(max_rec_len);
+	if (add_to_free_list) {
+		trailer->db_free_next = dx_root->dr_free_blk;
+		dx_root->dr_free_blk = cpu_to_le64(leaf_bh->b_blocknr);
+		ocfs2_journal_dirty(handle, dx_root_bh);
+	}
+
+	/* leaf_bh was journal_accessed for us in __ocfs2_delete_entry */
+	ocfs2_journal_dirty(handle, leaf_bh);
+
 	ocfs2_dx_list_remove_entry(entry_list, index);
 
 	if (ocfs2_dx_root_inline(dx_root))
@@ -1422,6 +1548,59 @@ static int ocfs2_dx_dir_insert(struct inode *dir, handle_t *handle,
 					  lookup->dl_dx_leaf_bh);
 }
 
+static void ocfs2_remove_block_from_free_list(struct inode *dir,
+				       handle_t *handle,
+				       struct ocfs2_dir_lookup_result *lookup)
+{
+	struct ocfs2_dir_block_trailer *trailer, *prev;
+	struct ocfs2_dx_root_block *dx_root;
+	struct buffer_head *bh;
+
+	trailer = ocfs2_trailer_from_bh(lookup->dl_leaf_bh, dir->i_sb);
+
+	if (ocfs2_free_list_at_root(lookup)) {
+		bh = lookup->dl_dx_root_bh;
+		dx_root = (struct ocfs2_dx_root_block *)bh->b_data;
+		dx_root->dr_free_blk = trailer->db_free_next;
+	} else {
+		bh = lookup->dl_prev_leaf_bh;
+		prev = ocfs2_trailer_from_bh(bh, dir->i_sb);
+		prev->db_free_next = trailer->db_free_next;
+	}
+
+	trailer->db_free_rec_len = cpu_to_le16(0);
+	trailer->db_free_next = cpu_to_le64(0);
+
+	ocfs2_journal_dirty(handle, bh);
+	ocfs2_journal_dirty(handle, lookup->dl_leaf_bh);
+}
+
+/*
+ * This expects that a journal write has been reserved on
+ * lookup->dl_prev_leaf_bh or lookup->dl_dx_root_bh
+ */
+static void ocfs2_recalc_free_list(struct inode *dir, handle_t *handle,
+				   struct ocfs2_dir_lookup_result *lookup)
+{
+	int max_rec_len;
+	struct ocfs2_dir_block_trailer *trailer;
+
+	/* Walk dl_leaf_bh to figure out what the new free rec_len is. */
+	max_rec_len = ocfs2_find_max_rec_len(dir->i_sb, lookup->dl_leaf_bh);
+	if (max_rec_len) {
+		/*
+		 * There's still room in this block, so no need to remove it
+		 * from the free list. In this case, we just want to update
+		 * the rec len accounting.
+		 */
+		trailer = ocfs2_trailer_from_bh(lookup->dl_leaf_bh, dir->i_sb);
+		trailer->db_free_rec_len = cpu_to_le16(max_rec_len);
+		ocfs2_journal_dirty(handle, lookup->dl_leaf_bh);
+	} else {
+		ocfs2_remove_block_from_free_list(dir, handle, lookup);
+	}
+}
+
 /* we don't always have a dentry for what we want to add, so people
  * like orphan dir can call this instead.
  *
@@ -1450,7 +1629,31 @@ int __ocfs2_add_entry(handle_t *handle,
 	if (!namelen)
 		return -EINVAL;
 
-	if (OCFS2_I(dir)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
+	if (ocfs2_dir_indexed(dir)) {
+		struct buffer_head *bh;
+
+		/*
+		 * An indexed dir may require that we update the free space
+		 * list. Reserve a write to the previous node in the list so
+		 * that we don't fail later.
+		 *
+		 * XXX: This can be either a dx_root_block, or an unindexed
+		 * directory tree leaf block.
+		 */
+		if (ocfs2_free_list_at_root(lookup)) {
+			bh = lookup->dl_dx_root_bh;
+			retval = ocfs2_journal_access_dr(handle, dir, bh,
+						 OCFS2_JOURNAL_ACCESS_WRITE);
+		} else {
+			bh = lookup->dl_prev_leaf_bh;
+			retval = ocfs2_journal_access_db(handle, dir, bh,
+						 OCFS2_JOURNAL_ACCESS_WRITE);
+		}
+		if (retval) {
+			mlog_errno(retval);
+			return retval;
+		}
+	} else if (OCFS2_I(dir)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
 		data_start = di->id2.i_data.id_data;
 		size = i_size_read(dir);
 
@@ -1533,6 +1736,9 @@ int __ocfs2_add_entry(handle_t *handle,
 			de->name_len = namelen;
 			memcpy(de->name, name, namelen);
 
+			if (ocfs2_dir_indexed(dir))
+				ocfs2_recalc_free_list(dir, handle, lookup);
+
 			dir->i_version++;
 			status = ocfs2_journal_dirty(handle, insert_bh);
 			retval = 0;
@@ -2056,7 +2262,7 @@ static int ocfs2_fill_new_dir_el(struct ocfs2_super *osb,
 
 	mlog_entry_void();
 
-	if (ocfs2_supports_dir_trailer(osb))
+	if (ocfs2_new_dir_wants_trailer(inode))
 		size = ocfs2_dir_trailer_blk_off(parent->i_sb);
 
 	status = ocfs2_do_extend_dir(osb->sb, handle, inode, fe_bh,
@@ -2077,8 +2283,19 @@ static int ocfs2_fill_new_dir_el(struct ocfs2_super *osb,
 	memset(new_bh->b_data, 0, osb->sb->s_blocksize);
 
 	de = ocfs2_fill_initial_dirents(inode, parent, new_bh->b_data, size);
-	if (ocfs2_supports_dir_trailer(osb))
-		ocfs2_init_dir_trailer(inode, new_bh);
+	if (ocfs2_new_dir_wants_trailer(inode)) {
+		int size = le16_to_cpu(de->rec_len);
+
+		/*
+		 * Figure out the size of the hole left over after
+		 * insertion of '.' and '..'. The trailer wants this
+		 * information.
+		 */
+		size -= OCFS2_DIR_REC_LEN(2);
+		size -= sizeof(struct ocfs2_dir_block_trailer);
+
+		ocfs2_init_dir_trailer(inode, new_bh, size);
+	}
 
 	status = ocfs2_journal_dirty(handle, new_bh);
 	if (status < 0) {
@@ -2110,6 +2327,7 @@ bail:
 static int ocfs2_dx_dir_attach_index(struct ocfs2_super *osb,
 				     handle_t *handle, struct inode *dir,
 				     struct buffer_head *di_bh,
+				     struct buffer_head *dirdata_bh,
 				     struct ocfs2_alloc_context *meta_ac,
 				     int dx_inline,
 				     struct buffer_head **ret_dx_root_bh)
@@ -2121,6 +2339,8 @@ static int ocfs2_dx_dir_attach_index(struct ocfs2_super *osb,
 	unsigned int num_bits;
 	struct buffer_head *dx_root_bh = NULL;
 	struct ocfs2_dx_root_block *dx_root;
+	struct ocfs2_dir_block_trailer *trailer =
+		ocfs2_trailer_from_bh(dirdata_bh, dir->i_sb);
 
 	ret = ocfs2_claim_metadata(osb, handle, meta_ac, 1, &dr_suballoc_bit,
 				   &num_bits, &dr_blkno);
@@ -2155,6 +2375,10 @@ static int ocfs2_dx_dir_attach_index(struct ocfs2_super *osb,
 	dx_root->dr_fs_generation = cpu_to_le32(osb->fs_generation);
 	dx_root->dr_blkno = cpu_to_le64(dr_blkno);
 	dx_root->dr_dir_blkno = cpu_to_le64(OCFS2_I(dir)->ip_blkno);
+	if (le16_to_cpu(trailer->db_free_rec_len))
+		dx_root->dr_free_blk = cpu_to_le64(dirdata_bh->b_blocknr);
+	else
+		dx_root->dr_free_blk = cpu_to_le64(0);
 
 	if (dx_inline) {
 		dx_root->dr_flags |= OCFS2_DX_FLAG_INLINE;
@@ -2361,7 +2585,7 @@ static int ocfs2_fill_new_dir_dx(struct ocfs2_super *osb,
 		goto out;
 	}
 
-	ret = ocfs2_dx_dir_attach_index(osb, handle, inode, di_bh,
+	ret = ocfs2_dx_dir_attach_index(osb, handle, inode, di_bh, leaf_bh,
 					meta_ac, 1, &dx_root_bh);
 	if (ret) {
 		mlog_errno(ret);
@@ -2371,6 +2595,7 @@ static int ocfs2_fill_new_dir_dx(struct ocfs2_super *osb,
 	entry_list = &dx_root->dr_entries;
 
 	/* Buffer has been journaled for us by ocfs2_dx_dir_attach_index */
+	ocfs2_dx_dir_name_hash(inode, ".", 1, &hinfo);
 	ocfs2_dx_entry_list_insert(entry_list, &hinfo, leaf_bh->b_blocknr);
 
 	ocfs2_dx_dir_name_hash(inode, "..", 2, &hinfo);
@@ -2446,7 +2671,8 @@ inc:
 out:
 	return ret;
 }
- /*
+
+/*
  * XXX: This expects dx_root_bh to already be part of the transaction.
  */
 static void ocfs2_dx_dir_index_root_block(struct inode *dir,
@@ -2521,18 +2747,26 @@ static int ocfs2_new_dx_should_be_inline(struct inode *dir,
  * expansion from an inline directory to one with extents. The first dir block
  * in that case is taken from the inline data portion of the inode block.
  *
+ * This will also return the largest amount of contiguous space for a dirent
+ * in the block. That value is *not* necessarily the last dirent, even after
+ * expansion. The directory indexing code wants this value for free space
+ * accounting. We do this here since we're already walking the entire dir
+ * block.
+ *
  * We add the dir trailer if this filesystem wants it.
  */
-static void ocfs2_expand_last_dirent(char *start, unsigned int old_size,
-				     struct super_block *sb)
+static unsigned int ocfs2_expand_last_dirent(char *start, unsigned int old_size,
+					     struct inode *dir)
 {
+	struct super_block *sb = dir->i_sb;
 	struct ocfs2_dir_entry *de;
 	struct ocfs2_dir_entry *prev_de;
 	char *de_buf, *limit;
 	unsigned int new_size = sb->s_blocksize;
-	unsigned int bytes;
+	unsigned int bytes, this_hole;
+	unsigned int largest_hole = 0;
 
-	if (ocfs2_supports_dir_trailer(OCFS2_SB(sb)))
+	if (ocfs2_new_dir_wants_trailer(dir))
 		new_size = ocfs2_dir_trailer_blk_off(sb);
 
 	bytes = new_size - old_size;
@@ -2541,12 +2775,26 @@ static void ocfs2_expand_last_dirent(char *start, unsigned int old_size,
 	de_buf = start;
 	de = (struct ocfs2_dir_entry *)de_buf;
 	do {
+		this_hole = ocfs2_figure_dirent_hole(de);
+		if (this_hole > largest_hole)
+			largest_hole = this_hole;
+
 		prev_de = de;
 		de_buf += le16_to_cpu(de->rec_len);
 		de = (struct ocfs2_dir_entry *)de_buf;
 	} while (de_buf < limit);
 
 	le16_add_cpu(&prev_de->rec_len, bytes);
+
+	/* We need to double check this after modification of the final
+	 * dirent. */
+	this_hole = ocfs2_figure_dirent_hole(prev_de);
+	if (this_hole > largest_hole)
+		largest_hole = this_hole;
+
+	if (largest_hole >= OCFS2_DIR_MIN_REC_LEN)
+		return largest_hole;
+	return 0;
 }
 
 /*
@@ -2703,9 +2951,16 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 	memcpy(dirdata_bh->b_data, di->id2.i_data.id_data, i_size_read(dir));
 	memset(dirdata_bh->b_data + i_size_read(dir), 0,
 	       sb->s_blocksize - i_size_read(dir));
-	ocfs2_expand_last_dirent(dirdata_bh->b_data, i_size_read(dir), sb);
-	if (ocfs2_supports_dir_trailer(osb))
-		ocfs2_init_dir_trailer(dir, dirdata_bh);
+	i = ocfs2_expand_last_dirent(dirdata_bh->b_data, i_size_read(dir), dir);
+	if (ocfs2_new_dir_wants_trailer(dir)) {
+		/*
+		 * Prepare the dir trailer up front. It will otherwise look
+		 * like a valid dirent. Even if inserting the index fails
+		 * (unlikely), then all we'll have done is given first dir
+		 * block a small amount of fragmentation.
+		 */
+		ocfs2_init_dir_trailer(dir, dirdata_bh, i);
+	}
 
 	ret = ocfs2_journal_dirty(handle, dirdata_bh);
 	if (ret) {
@@ -2781,7 +3036,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 
 	if (ocfs2_supports_indexed_dirs(osb)) {
 		ret = ocfs2_dx_dir_attach_index(osb, handle, dir, di_bh,
-						meta_ac, dx_inline,
+						dirdata_bh, meta_ac, dx_inline,
 						&dx_root_bh);
 		if (ret) {
 			mlog_errno(ret);
@@ -2933,6 +3188,8 @@ bail:
  * is to be turned into an extent based one. The size of the dirent to
  * insert might be larger than the space gained by growing to just one
  * block, so we may have to grow the inode by two blocks in that case.
+ *
+ * If the directory is already indexed, dx_root_bh must be provided.
  */
 static int ocfs2_extend_dir(struct ocfs2_super *osb,
 			    struct inode *dir,
@@ -2953,10 +3210,17 @@ static int ocfs2_extend_dir(struct ocfs2_super *osb,
 	struct ocfs2_dir_entry * de;
 	struct super_block *sb = osb->sb;
 	struct ocfs2_extent_tree et;
+	struct buffer_head *dx_root_bh = lookup->dl_dx_root_bh;
 
 	mlog_entry_void();
 
 	if (OCFS2_I(dir)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
+		/*
+		 * This would be a code error as an inline directory should
+		 * never have an index root.
+		 */
+		BUG_ON(dx_root_bh);
+
 		status = ocfs2_expand_inline_dir(dir, parent_fe_bh,
 						 blocks_wanted, lookup,
 						 &new_bh);
@@ -2965,6 +3229,10 @@ static int ocfs2_extend_dir(struct ocfs2_super *osb,
 			goto bail;
 		}
 
+		/* Expansion from inline to an indexed directory will
+		 * have given us this. */
+		dx_root_bh = lookup->dl_dx_root_bh;
+
 		if (blocks_wanted == 1) {
 			/*
 			 * If the new dirent will fit inside the space
@@ -3028,6 +3296,10 @@ static int ocfs2_extend_dir(struct ocfs2_super *osb,
 	}
 
 do_extend:
+	if (ocfs2_dir_indexed(dir))
+		credits++; /* For attaching the new dirent block to the
+			    * dx_root */
+
 	down_write(&OCFS2_I(dir)->ip_alloc_sem);
 	drop_alloc_sem = 1;
 
@@ -3058,9 +3330,19 @@ do_extend:
 
 	de = (struct ocfs2_dir_entry *) new_bh->b_data;
 	de->inode = 0;
-	if (ocfs2_dir_has_trailer(dir)) {
+	if (ocfs2_supports_dir_trailer(dir)) {
 		de->rec_len = cpu_to_le16(ocfs2_dir_trailer_blk_off(sb));
-		ocfs2_init_dir_trailer(dir, new_bh);
+
+		ocfs2_init_dir_trailer(dir, new_bh, le16_to_cpu(de->rec_len));
+
+		if (ocfs2_dir_indexed(dir)) {
+			status = ocfs2_dx_dir_link_trailer(dir, handle,
+							   dx_root_bh, new_bh);
+			if (status) {
+				mlog_errno(status);
+				goto bail;
+			}
+		}
 	} else {
 		de->rec_len = cpu_to_le16(sb->s_blocksize);
 	}
@@ -3116,7 +3398,7 @@ static int ocfs2_find_dir_space_id(struct inode *dir, struct buffer_head *di_bh,
 	 * This calculates how many free bytes we'd have in block zero, should
 	 * this function force expansion to an extent tree.
 	 */
-	if (ocfs2_supports_dir_trailer(OCFS2_SB(sb)))
+	if (ocfs2_new_dir_wants_trailer(dir))
 		free_space = ocfs2_dir_trailer_blk_off(sb) - i_size_read(dir);
 	else
 		free_space = dir->i_sb->s_blocksize - i_size_read(dir);
@@ -3647,6 +3929,127 @@ out:
 	return ret;
 }
 
+static int ocfs2_find_dir_space_dx(struct ocfs2_super *osb, struct inode *dir,
+				   struct buffer_head *di_bh,
+				   struct buffer_head *dx_root_bh,
+				   const char *name, int namelen,
+				   struct ocfs2_dir_lookup_result *lookup)
+{
+	int ret, rebalanced = 0;
+	struct ocfs2_dx_root_block *dx_root;
+	struct buffer_head *dx_leaf_bh = NULL;
+	struct ocfs2_dx_leaf *dx_leaf;
+	u64 blkno;
+	u32 leaf_cpos;
+
+	dx_root = (struct ocfs2_dx_root_block *)dx_root_bh->b_data;
+
+restart_search:
+	ret = ocfs2_dx_dir_lookup(dir, &dx_root->dr_list, &lookup->dl_hinfo,
+				  &leaf_cpos, &blkno);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_read_dx_leaf(dir, blkno, &dx_leaf_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	dx_leaf = (struct ocfs2_dx_leaf *)dx_leaf_bh->b_data;
+
+	if (le16_to_cpu(dx_leaf->dl_list.de_num_used) >=
+	    le16_to_cpu(dx_leaf->dl_list.de_count)) {
+		if (rebalanced) {
+			/*
+			 * Rebalancing should have provided us with
+			 * space in an appropriate leaf.
+			 *
+			 * XXX: Is this an abnormal condition then?
+			 * Should we print a message here?
+			 */
+			ret = -ENOSPC;
+			goto out;
+		}
+
+		ret = ocfs2_dx_dir_rebalance(osb, dir, dx_root_bh, dx_leaf_bh,
+					     &lookup->dl_hinfo, leaf_cpos,
+					     blkno);
+		if (ret) {
+			if (ret != -ENOSPC)
+				mlog_errno(ret);
+			goto out;
+		}
+
+		/*
+		 * Restart the lookup. The rebalance might have
+		 * changed which block our item fits into. Mark our
+		 * progress, so we only execute this once.
+		 */
+		brelse(dx_leaf_bh);
+		dx_leaf_bh = NULL;
+		rebalanced = 1;
+		goto restart_search;
+	}
+
+	lookup->dl_dx_leaf_bh = dx_leaf_bh;
+	dx_leaf_bh = NULL;
+
+out:
+	brelse(dx_leaf_bh);
+	return ret;
+}
+
+static int ocfs2_search_dx_free_list(struct inode *dir,
+				     struct buffer_head *dx_root_bh,
+				     int namelen,
+				     struct ocfs2_dir_lookup_result *lookup)
+{
+	int ret = -ENOSPC;
+	struct buffer_head *leaf_bh = NULL, *prev_leaf_bh = NULL;
+	struct ocfs2_dir_block_trailer *db;
+	u64 next_block;
+	int rec_len = OCFS2_DIR_REC_LEN(namelen);
+	struct ocfs2_dx_root_block *dx_root;
+
+	dx_root = (struct ocfs2_dx_root_block *)dx_root_bh->b_data;
+	next_block = le64_to_cpu(dx_root->dr_free_blk);
+
+	while (next_block) {
+		brelse(prev_leaf_bh);
+		prev_leaf_bh = leaf_bh;
+		leaf_bh = NULL;
+
+		ret = ocfs2_read_dir_block_direct(dir, next_block, &leaf_bh);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		db = ocfs2_trailer_from_bh(leaf_bh, dir->i_sb);
+		if (rec_len <= le16_to_cpu(db->db_free_rec_len)) {
+			lookup->dl_leaf_bh = leaf_bh;
+			lookup->dl_prev_leaf_bh = prev_leaf_bh;
+			leaf_bh = NULL;
+			prev_leaf_bh = NULL;
+			break;
+		}
+
+		next_block = le64_to_cpu(db->db_free_next);
+	}
+
+	if (!next_block)
+		ret = -ENOSPC;
+
+out:
+
+	brelse(leaf_bh);
+	brelse(prev_leaf_bh);
+	return ret;
+}
+
 static int ocfs2_expand_inline_dx_root(struct inode *dir,
 				       struct buffer_head *dx_root_bh)
 {
@@ -3779,19 +4182,18 @@ static int ocfs2_inline_dx_has_space(struct buffer_head *dx_root_bh)
 	return 0;
 }
 
-static int ocfs2_find_dir_space_dx(struct ocfs2_super *osb, struct inode *dir,
-				   struct buffer_head *di_bh, const char *name,
-				   int namelen,
-				   struct ocfs2_dir_lookup_result *lookup)
+static int ocfs2_prepare_dx_dir_for_insert(struct inode *dir,
+					   struct buffer_head *di_bh,
+					   const char *name,
+					   int namelen,
+					   struct ocfs2_dir_lookup_result *lookup)
 {
-	int ret, rebalanced = 0;
+	int ret, free_dx_root = 1;
+	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
 	struct buffer_head *dx_root_bh = NULL;
-	struct ocfs2_dx_root_block *dx_root;
-	struct buffer_head *dx_leaf_bh = NULL;
-	struct ocfs2_dx_leaf *dx_leaf;
+	struct buffer_head *leaf_bh = NULL;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
-	u64 blkno;
-	u32 leaf_cpos;
+	struct ocfs2_dx_root_block *dx_root;
 
 	ret = ocfs2_read_dx_root(dir, di, &dx_root_bh);
 	if (ret) {
@@ -3818,65 +4220,55 @@ static int ocfs2_find_dir_space_dx(struct ocfs2_super *osb, struct inode *dir,
 		}
 	}
 
-restart_search:
-	ret = ocfs2_dx_dir_lookup(dir, &dx_root->dr_list, &lookup->dl_hinfo,
-				  &leaf_cpos, &blkno);
+	/*
+	 * Insert preparation for an indexed directory is split into two
+	 * steps. The call to find_dir_space_dx reserves room in the index for
+	 * an additional item. If we run out of space there, it's a real error
+	 * we can't continue on.
+	 */
+	ret = ocfs2_find_dir_space_dx(osb, dir, di_bh, dx_root_bh, name,
+				      namelen, lookup);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
 	}
 
-	ret = ocfs2_read_dx_leaf(dir, blkno, &dx_leaf_bh);
-	if (ret) {
+search_el:
+	/*
+	 * Next, we need to find space in the unindexed tree. This call
+	 * searches using the free space linked list. If the unindexed tree
+	 * lacks sufficient space, we'll expand it below. The expansion code
+	 * is smart enough to add any new blocks to the free space list.
+	 */
+	ret = ocfs2_search_dx_free_list(dir, dx_root_bh, namelen, lookup);
+	if (ret && ret != -ENOSPC) {
 		mlog_errno(ret);
 		goto out;
 	}
 
-	dx_leaf = (struct ocfs2_dx_leaf *)dx_leaf_bh->b_data;
+	/* Do this up here - ocfs2_extend_dir might need the dx_root */
+	lookup->dl_dx_root_bh = dx_root_bh;
+	free_dx_root = 0;
 
-	if (le16_to_cpu(dx_leaf->dl_list.de_num_used) >=
-	    le16_to_cpu(dx_leaf->dl_list.de_count)) {
-		if (rebalanced) {
-			/*
-			 * Rebalancing should have provided us with
-			 * space in an appropriate leaf.
-			 *
-			 * XXX: Is this an abnormal condition then?
-			 * Should we print a message here?
-			 */
-			ret = -ENOSPC;
-			goto out;
-		}
+	if (ret == -ENOSPC) {
+		ret = ocfs2_extend_dir(osb, dir, di_bh, 1, lookup, &leaf_bh);
 
-		ret = ocfs2_dx_dir_rebalance(osb, dir, dx_root_bh, dx_leaf_bh,
-					     &lookup->dl_hinfo, leaf_cpos,
-					     blkno);
 		if (ret) {
-			if (ret != -ENOSPC)
-				mlog_errno(ret);
+			mlog_errno(ret);
 			goto out;
 		}
 
 		/*
-		 * Restart the lookup. The rebalance might have
-		 * changed which block our item fits into. Mark our
-		 * progress, so we only execute this once.
+		 * We make the assumption here that new leaf blocks are added
+		 * to the front of our free list.
 		 */
-		brelse(dx_leaf_bh);
-		dx_leaf_bh = NULL;
-		rebalanced = 1;
-		goto restart_search;
+		lookup->dl_prev_leaf_bh = NULL;
+		lookup->dl_leaf_bh = leaf_bh;
 	}
 
-search_el:
-	lookup->dl_dx_leaf_bh = dx_leaf_bh;
-	dx_leaf_bh = NULL;
-	lookup->dl_dx_root_bh = dx_root_bh;
-	dx_root_bh = NULL;
-
 out:
-	brelse(dx_leaf_bh);
-	brelse(dx_root_bh);
+	if (free_dx_root)
+		brelse(dx_root_bh);
 	return ret;
 }
 
@@ -3921,17 +4313,11 @@ int ocfs2_prepare_dir_for_insert(struct ocfs2_super *osb,
 		ocfs2_dx_dir_name_hash(dir, name, namelen, &lookup->dl_hinfo);
 
 	if (ocfs2_dir_indexed(dir)) {
-		ret = ocfs2_find_dir_space_dx(osb, dir, parent_fe_bh, name,
-					      namelen, lookup);
-		if (ret) {
+		ret = ocfs2_prepare_dx_dir_for_insert(dir, parent_fe_bh,
+						      name, namelen, lookup);
+		if (ret)
 			mlog_errno(ret);
-			goto out;
-		}
-
-		/*
-		 * We intentionally fall through so that the unindexed
-		 * tree can also be prepared.
-		 */
+		goto out;
 	}
 
 	if (OCFS2_I(dir)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
diff --git a/fs/ocfs2/dir.h b/fs/ocfs2/dir.h
index 07b0416..e683f3d 100644
--- a/fs/ocfs2/dir.h
+++ b/fs/ocfs2/dir.h
@@ -39,11 +39,19 @@ struct ocfs2_dir_lookup_result {
 
 	struct buffer_head		*dl_dx_root_bh;	/* Root of indexed
 							 * tree */
+
 	struct buffer_head		*dl_dx_leaf_bh;	/* Indexed leaf block */
 	struct ocfs2_dx_entry		*dl_dx_entry;	/* Target dx_entry in
 							 * indexed leaf */
 	struct ocfs2_dx_hinfo		dl_hinfo;	/* Name hash results */
+
+	struct buffer_head		*dl_prev_leaf_bh;/* Previous entry in
+							  * dir free space
+							  * list. NULL if
+							  * previous entry is
+							  * dx root block. */
 };
+
 void ocfs2_free_dir_lookup_result(struct ocfs2_dir_lookup_result *res);
 
 int ocfs2_find_entry(const char *name, int namelen,
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 5585dde..582e27e 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -385,8 +385,8 @@ static inline int ocfs2_remove_extent_credits(struct super_block *sb)
 }
 
 /* data block for new dir/symlink, 2 for bitmap updates (bitmap fe +
- * bitmap block for the new bit) */
-#define OCFS2_DIR_LINK_ADDITIONAL_CREDITS (1 + 2)
+ * bitmap block for the new bit) dx_root update for free list */
+#define OCFS2_DIR_LINK_ADDITIONAL_CREDITS (1 + 2 + 1)
 
 static inline int ocfs2_add_dir_index_credits(struct super_block *sb)
 {
@@ -420,19 +420,19 @@ static inline int ocfs2_mknod_credits(struct super_block *sb, int is_dir,
 #define OCFS2_SIMPLE_DIR_EXTEND_CREDITS (2)
 
 /* file update (nlink, etc) + directory mtime/ctime + dir entry block + quota
- * update on dir + index leaf */
+ * update on dir + index leaf + dx root update for free list */
 static inline int ocfs2_link_credits(struct super_block *sb)
 {
-	return 2*OCFS2_INODE_UPDATE_CREDITS + 2 +
+	return 2*OCFS2_INODE_UPDATE_CREDITS + 3 +
 	       ocfs2_quota_trans_credits(sb);
 }
 
 /* inode + dir inode (if we unlink a dir), + dir entry block + orphan
- * dir inode link + dir inode index leaf */
+ * dir inode link + dir inode index leaf + dir index root */
 static inline int ocfs2_unlink_credits(struct super_block *sb)
 {
 	/* The quota update from ocfs2_link_credits is unused here... */
-	return 2 * OCFS2_INODE_UPDATE_CREDITS + 2 + ocfs2_link_credits(sb);
+	return 2 * OCFS2_INODE_UPDATE_CREDITS + 3 + ocfs2_link_credits(sb);
 }
 
 /* dinode + orphan dir dinode + inode alloc dinode + orphan dir entry +
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 1d1c54e..d549b17 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -416,6 +416,7 @@ static struct ocfs2_system_inode_info ocfs2_system_inodes[NUM_SYSTEM_INODES] = {
 #define OCFS2_DIR_REC_LEN(name_len)	(((name_len) + OCFS2_DIR_MEMBER_LEN + \
                                           OCFS2_DIR_ROUND) & \
 					 ~OCFS2_DIR_ROUND)
+#define OCFS2_DIR_MIN_REC_LEN	OCFS2_DIR_REC_LEN(1)
 
 #define OCFS2_LINK_MAX		32000
 
@@ -842,7 +843,9 @@ struct ocfs2_dx_root_block {
 	__le16		dr_reserved1;
 	__le64		dr_dir_blkno;		/* Pointer to parent inode */
 	__le64		dr_reserved2;
-	__le64		dr_reserved3[16];
+	__le64		dr_free_blk;		/* Pointer to head of free
+						 * unindexed block list. */
+	__le64		dr_reserved3[15];
 	union {
 		struct ocfs2_extent_list dr_list; /* Keep this aligned to 128
 						   * bits for maximum space
-- 
1.5.6
