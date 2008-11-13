From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 12 Nov 2008 18:24:08 -0800
Subject: [Ocfs2-devel] [PATCH 4/4] ocfs2: Introduce dir free space list
In-Reply-To: <1226543048-911-1-git-send-email-mfasheh@suse.com>
References: <1226543048-911-1-git-send-email-mfasheh@suse.com>
Message-ID: <1226543048-911-5-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The only operation which doesn't get faster with directory indexing is
insert, which still has to walk the entire unindexed directory portion to
find a free block. This patch provides an improvement in directory insert
performance by maintaining a singly linked list of directory leaf blocks
which have space for additional dirents.

As the disk format is now finalized, we also turn on directory indexing support.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dir.c      |  536 +++++++++++++++++++++++++++++++++++++++++++++++----
 fs/ocfs2/dir.h      |    4 +
 fs/ocfs2/journal.h  |   12 +-
 fs/ocfs2/namei.c    |    8 +-
 fs/ocfs2/ocfs2_fs.h |   32 +++-
 5 files changed, 539 insertions(+), 53 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index f113704..479d2b7 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -130,6 +130,89 @@ static int ocfs2_dir_indexed(struct inode *inode)
 }
 
 /*
+ * These are distinct checks because future versions of the file system will
+ * want to have a trailing dirent structure independent of indexing.
+ */
+static int ocfs2_dir_has_trailer(struct inode *dir)
+{
+	return ocfs2_dir_indexed(dir);
+}
+static int ocfs2_supports_dir_trailer(struct ocfs2_super *osb)
+{
+	return ocfs2_supports_indexed_dirs(osb);
+}
+
+static inline unsigned int ocfs2_dir_trailer_blk_off(struct super_block *sb)
+{
+	return sb->s_blocksize - sizeof(struct ocfs2_dir_block_trailer);
+}
+
+#define ocfs2_trailer_from_bh(_bh, _sb) ((struct ocfs2_dir_block_trailer *) ((_bh)->b_data + ocfs2_dir_trailer_blk_off((_sb))))
+
+/*
+ * XXX: This is executed once on every dirent. We should consider optimizing
+ * it.
+ */
+static int ocfs2_skip_dir_trailer(struct inode *dir,
+				  struct ocfs2_dir_entry *de,
+				  unsigned long offset,
+				  unsigned long blklen)
+{
+	unsigned long toff = blklen - sizeof(struct ocfs2_dir_block_trailer);
+
+	if (!ocfs2_dir_has_trailer(dir))
+		return 0;
+
+	if (offset != toff)
+		return 0;
+
+	return 1;
+}
+
+static void ocfs2_init_dir_trailer(struct super_block *sb,
+				   struct buffer_head *bh, u16 rec_len)
+{
+	struct ocfs2_dir_block_trailer *trailer;
+
+	trailer = ocfs2_trailer_from_bh(bh, sb);
+	strcpy(trailer->db_signature, OCFS2_DIR_TRAILER_SIGNATURE);
+	trailer->db_compat_rec_len =
+			le16_to_cpu(sizeof(struct ocfs2_dir_block_trailer));
+	trailer->db_free_rec_len = cpu_to_le16(rec_len);
+}
+
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
+	ret = ocfs2_journal_access(handle, dir, dx_root_bh,
+				   OCFS2_JOURNAL_ACCESS_WRITE);
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
+/*
  * Hashing code adapted from ext3
  */
 #define DELTA 0x9E3779B9
@@ -874,6 +957,45 @@ bail:
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
+	return largest_hole;
+}
+
 static void ocfs2_dx_leaf_remove_entry(struct ocfs2_dx_leaf *dx_leaf, int index)
 {
 	int num_used = le16_to_cpu(dx_leaf->dl_num_used);
@@ -891,12 +1013,17 @@ clear:
 }
 
 static int ocfs2_delete_entry_dx(handle_t *handle, struct inode *dir,
+				 struct buffer_head *dir_di_bh,
 				 struct ocfs2_dir_lookup_result *lookup)
 {
-	int ret, index;
+	int ret, index, max_rec_len;
 	struct buffer_head *leaf_bh = lookup->dl_leaf_bh;
+	struct buffer_head *dx_root_bh = NULL;
 	struct ocfs2_dx_leaf *dx_leaf;
 	struct ocfs2_dx_entry *dx_entry = lookup->dl_dx_entry;
+	struct ocfs2_dir_block_trailer *trailer;
+	struct ocfs2_dx_root_block *uninitialized_var(dx_root);
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)dir_di_bh->b_data;
 
 	dx_leaf = (struct ocfs2_dx_leaf *) lookup->dl_dx_leaf_bh->b_data;
 	/* Neither of these are a disk corruption - that should have
@@ -914,6 +1041,25 @@ static int ocfs2_delete_entry_dx(handle_t *handle, struct inode *dir,
 		return -EIO;
 	}
 
+	trailer = ocfs2_trailer_from_bh(leaf_bh, dir->i_sb);
+	if (trailer->db_free_rec_len == 0) {
+		/* We'll have to put this block on the free list. */
+		ret = ocfs2_dx_dir_read_root(dir, di, &dx_root_bh);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		ret = ocfs2_journal_access(handle, dir, dx_root_bh,
+					   OCFS2_JOURNAL_ACCESS_WRITE);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		dx_root = (struct ocfs2_dx_root_block *)dx_root_bh->b_data;
+	}
+
 	mlog(0, "Dir %llu: delete entry at index: %d\n",
 	     (unsigned long long)OCFS2_I(dir)->ip_blkno, index);
 
@@ -938,11 +1084,22 @@ static int ocfs2_delete_entry_dx(handle_t *handle, struct inode *dir,
 		goto out;
 	}
 
+	max_rec_len = ocfs2_find_max_rec_len(dir->i_sb, leaf_bh);
+	trailer->db_free_rec_len = cpu_to_le16(max_rec_len);
+	if (dx_root_bh) {
+		trailer->db_free_next = dx_root->dr_free_blk;
+		dx_root->dr_free_blk = cpu_to_le64(leaf_bh->b_blocknr);
+		ocfs2_journal_dirty(handle, dx_root_bh);
+	}
+	/* leaf_bh was journal_accessed for us in __ocfs2_delete_entry */
+	ocfs2_journal_dirty(handle, leaf_bh);
+
 	ocfs2_dx_leaf_remove_entry(dx_leaf, index);
 
 	ocfs2_journal_dirty(handle, lookup->dl_dx_leaf_bh);
 
 out:
+	brelse(dx_root_bh);
 	return ret;
 }
 
@@ -988,10 +1145,11 @@ static inline int ocfs2_delete_entry_el(handle_t *handle,
  */
 int ocfs2_delete_entry(handle_t *handle,
 		       struct inode *dir,
+		       struct buffer_head *dir_di_bh,
 		       struct ocfs2_dir_lookup_result *lookup)
 {
 	if (ocfs2_dir_indexed(dir))
-		return ocfs2_delete_entry_dx(handle, dir, lookup);
+		return ocfs2_delete_entry_dx(handle, dir, dir_di_bh, lookup);
 
 	if (OCFS2_I(dir)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
 		return ocfs2_delete_entry_id(handle, dir, lookup->dl_entry,
@@ -1078,6 +1236,57 @@ static int ocfs2_dx_dir_leaf_insert(struct inode *dir, handle_t *handle,
 					  lookup->dl_dx_leaf_bh);
 }
 
+static void ocfs2_remove_block_from_free_list(struct inode *dir,
+				       handle_t *handle,
+				       struct ocfs2_dir_lookup_result *lookup)
+{
+	struct ocfs2_dir_block_trailer *trailer, *prev;
+	struct ocfs2_dx_root_block *dx_root;
+	struct buffer_head *prev_bh = lookup->dl_prev_leaf_bh;
+
+	trailer = ocfs2_trailer_from_bh(lookup->dl_leaf_bh, dir->i_sb);
+
+	if (lookup->dl_prev_is_dx_root) {
+		dx_root = (struct ocfs2_dx_root_block *)prev_bh->b_data;
+		dx_root->dr_free_blk = trailer->db_free_next;
+	} else {
+		prev = ocfs2_trailer_from_bh(prev_bh, dir->i_sb);
+		prev->db_free_next = trailer->db_free_next;
+	}
+
+	trailer->db_free_rec_len = cpu_to_le16(0);
+	trailer->db_free_next = cpu_to_le64(0);
+
+	ocfs2_journal_dirty(handle, prev_bh);
+	ocfs2_journal_dirty(handle, lookup->dl_leaf_bh);
+}
+
+/*
+ * This expects that a journal write has been reserved on
+ * lookup->dl_prev_leaf_bh
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
@@ -1106,7 +1315,23 @@ int __ocfs2_add_entry(handle_t *handle,
 	if (!namelen)
 		return -EINVAL;
 
-	if (OCFS2_I(dir)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
+	if (ocfs2_dir_indexed(dir)) {
+		/*
+		 * An indexed dir may require that we update the free space
+		 * list. Reserve a write to the previous node in the list so
+		 * that we don't fail later.
+		 *
+		 * XXX: This can be either a dx_root_block, or an unindexed
+		 * directory tree leaf block.
+		 */
+		retval = ocfs2_journal_access(handle, dir,
+					      lookup->dl_prev_leaf_bh,
+					      OCFS2_JOURNAL_ACCESS_WRITE);
+		if (retval) {
+			mlog_errno(retval);
+			return retval;
+		}
+	} else if (OCFS2_I(dir)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
 		data_start = di->id2.i_data.id_data;
 		size = i_size_read(dir);
 
@@ -1131,6 +1356,9 @@ int __ocfs2_add_entry(handle_t *handle,
 			goto bail;
 		}
 
+		if (ocfs2_skip_dir_trailer(dir, de, offset, size))
+			goto next;
+
 		if (ocfs2_dirent_would_fit(de, rec_len)) {
 			dir->i_mtime = dir->i_ctime = CURRENT_TIME;
 			retval = ocfs2_mark_inode_dirty(handle, dir, parent_fe_bh);
@@ -1171,11 +1399,15 @@ int __ocfs2_add_entry(handle_t *handle,
 			de->name_len = namelen;
 			memcpy(de->name, name, namelen);
 
+			if (ocfs2_dir_indexed(dir))
+				ocfs2_recalc_free_list(dir, handle, lookup);
+
 			dir->i_version++;
 			status = ocfs2_journal_dirty(handle, insert_bh);
 			retval = 0;
 			goto bail;
 		}
+next:
 		offset += le16_to_cpu(de->rec_len);
 		de = (struct ocfs2_dir_entry *) ((char *) de + le16_to_cpu(de->rec_len));
 	}
@@ -1609,9 +1841,15 @@ int ocfs2_empty_dir(struct inode *inode)
 	return !priv.seen_other;
 }
 
-static void ocfs2_fill_initial_dirents(struct inode *inode,
-				       struct inode *parent,
-				       char *start, unsigned int size)
+/*
+ * Fills "." and ".." dirents in a new directory block. Returns dirent for
+ * "..", which might be used during creation of a directory with a trailing
+ * header. It is otherwise safe to ignore the return code.
+ */
+static struct ocfs2_dir_entry *ocfs2_fill_initial_dirents(struct inode *inode,
+							  struct inode *parent,
+							  char *start,
+							  unsigned int size)
 {
 	struct ocfs2_dir_entry *de = (struct ocfs2_dir_entry *)start;
 
@@ -1628,6 +1866,8 @@ static void ocfs2_fill_initial_dirents(struct inode *inode,
 	de->name_len = 2;
 	strcpy(de->name, "..");
 	ocfs2_set_de_type(de, S_IFDIR);
+
+	return de;
 }
 
 /*
@@ -1681,10 +1921,15 @@ static int ocfs2_fill_new_dir_el(struct ocfs2_super *osb,
 				 struct buffer_head **ret_new_bh)
 {
 	int status;
+	unsigned int size = osb->sb->s_blocksize;
 	struct buffer_head *new_bh = NULL;
+	struct ocfs2_dir_entry *de;
 
 	mlog_entry_void();
 
+	if (ocfs2_supports_dir_trailer(osb))
+		size = ocfs2_dir_trailer_blk_off(parent->i_sb);
+
 	status = ocfs2_do_extend_dir(osb->sb, handle, inode, fe_bh,
 				     data_ac, NULL, &new_bh);
 	if (status < 0) {
@@ -1702,8 +1947,11 @@ static int ocfs2_fill_new_dir_el(struct ocfs2_super *osb,
 	}
 	memset(new_bh->b_data, 0, osb->sb->s_blocksize);
 
-	ocfs2_fill_initial_dirents(inode, parent, new_bh->b_data,
-				   osb->sb->s_blocksize);
+	de = ocfs2_fill_initial_dirents(inode, parent, new_bh->b_data, size);
+
+	if (ocfs2_supports_dir_trailer(osb))
+		ocfs2_init_dir_trailer(parent->i_sb, new_bh,
+				       le16_to_cpu(de->rec_len));
 
 	status = ocfs2_journal_dirty(handle, new_bh);
 	if (status < 0) {
@@ -1735,6 +1983,7 @@ bail:
 static int ocfs2_dx_dir_attach_index(struct ocfs2_super *osb,
 				     handle_t *handle, struct inode *dir,
 				     struct buffer_head *di_bh,
+				     struct buffer_head *dirdata_bh,
 				     struct ocfs2_alloc_context *meta_ac,
 				     struct buffer_head **ret_dx_root_bh)
 {
@@ -1781,6 +2030,7 @@ static int ocfs2_dx_dir_attach_index(struct ocfs2_super *osb,
 	dx_root->dr_dir_blkno = cpu_to_le64(OCFS2_I(dir)->ip_blkno);
 	dx_root->dr_list.l_count =
 		cpu_to_le16(ocfs2_extent_recs_per_dx_root(osb->sb));
+	dx_root->dr_free_blk = cpu_to_le64(dirdata_bh->b_blocknr);
 
 	ret = ocfs2_journal_dirty(handle, dx_root_bh);
 	if (ret)
@@ -2017,8 +2267,8 @@ static int ocfs2_fill_new_dir_dx(struct ocfs2_super *osb,
 		goto out;
 	}
 
-	ret = ocfs2_dx_dir_attach_index(osb, handle, inode, di_bh, meta_ac,
-					&dx_root_bh);
+	ret = ocfs2_dx_dir_attach_index(osb, handle, inode, di_bh, leaf_bh,
+					meta_ac, &dx_root_bh);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -2104,24 +2354,55 @@ out:
 	return ret;
 }
 
-static void ocfs2_expand_last_dirent(char *start, unsigned int old_size,
-				     unsigned int new_size)
+/*
+ * Expand rec_len of the rightmost dirent in a directory block so that it
+ * contains the end of our valid space for dirents. We do this during
+ * expansion from an inline directory to one with extents. The first dir block
+ * in that case is taken from the inline data portion of the inode block.
+ *
+ * This will also return the largest amount of contiguous space for a dirent
+ * in the block. That value is *not* necessarily the last dirent, even after
+ * expansion. The directory indexing code wants this value for free space
+ * accounting. We do this here since we're already walking the entire dir
+ * block.
+ */
+static unsigned int ocfs2_expand_last_dirent(char *start, unsigned int old_size,
+					     struct super_block *sb)
 {
 	struct ocfs2_dir_entry *de;
 	struct ocfs2_dir_entry *prev_de;
 	char *de_buf, *limit;
-	unsigned int bytes = new_size - old_size;
+	unsigned int new_size = sb->s_blocksize;
+	unsigned int bytes, this_hole;
+	unsigned int largest_hole = 0;
+
+	if (ocfs2_supports_indexed_dirs(OCFS2_SB(sb)))
+		new_size = ocfs2_dir_trailer_blk_off(sb);
+
+	bytes = new_size - old_size;
 
 	limit = start + old_size;
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
+	return largest_hole;
 }
 
 /*
@@ -2135,6 +2416,7 @@ static void ocfs2_expand_last_dirent(char *start, unsigned int old_size,
 static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 				   unsigned int blocks_wanted,
 				   struct ocfs2_dir_lookup_result *lookup,
+				   struct buffer_head **ret_dx_root_bh,
 				   struct buffer_head **first_block_bh)
 {
 	int ret, i, num_dx_leaves = 0, credits = OCFS2_INLINE_TO_EXTENTS_CREDITS;
@@ -2262,8 +2544,16 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 	memcpy(dirdata_bh->b_data, di->id2.i_data.id_data, i_size_read(dir));
 	memset(dirdata_bh->b_data + i_size_read(dir), 0,
 	       sb->s_blocksize - i_size_read(dir));
-	ocfs2_expand_last_dirent(dirdata_bh->b_data, i_size_read(dir),
-				 sb->s_blocksize);
+	i = ocfs2_expand_last_dirent(dirdata_bh->b_data, i_size_read(dir), sb);
+	if (ocfs2_supports_dir_trailer(osb)) {
+		/*
+		 * Prepare the dir trailer up front. It will otherwise look
+		 * like a valid dirent. Even if inserting the index fails
+		 * (unlikely), then all we'll have done is given first dir
+		 * block a small amount of fragmentation.
+		 */
+		ocfs2_init_dir_trailer(sb, dirdata_bh, i);
+	}
 
 	ret = ocfs2_journal_dirty(handle, dirdata_bh);
 	if (ret) {
@@ -2334,7 +2624,8 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 
 	if (ocfs2_supports_indexed_dirs(osb)) {
 		ret = ocfs2_dx_dir_attach_index(osb, handle, dir, di_bh,
-						meta_ac, &dx_root_bh);
+						dirdata_bh, meta_ac,
+						&dx_root_bh);
 		if (ret) {
 			mlog_errno(ret);
 			goto out_commit;
@@ -2381,6 +2672,8 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 					    &lookup->dl_hinfo);
 		get_bh(dx_leaves[off]);
 		lookup->dl_dx_leaf_bh = dx_leaves[off];
+		*ret_dx_root_bh = dx_root_bh;
+		dx_root_bh = NULL;
 	}
 
 out_commit:
@@ -2463,12 +2756,15 @@ bail:
  * is to be turned into an extent based one. The size of the dirent to
  * insert might be larger than the space gained by growing to just one
  * block, so we may have to grow the inode by two blocks in that case.
+ *
+ * If the directory is already indexed, dx_root_bh must be provided.
  */
 static int ocfs2_extend_dir(struct ocfs2_super *osb,
 			    struct inode *dir,
 			    struct buffer_head *parent_fe_bh,
 			    unsigned int blocks_wanted,
 			    struct ocfs2_dir_lookup_result *lookup,
+			    struct buffer_head *dx_root_bh,
 			    struct buffer_head **new_de_bh)
 {
 	int status = 0;
@@ -2486,9 +2782,19 @@ static int ocfs2_extend_dir(struct ocfs2_super *osb,
 
 	mlog_entry_void();
 
+	if (dx_root_bh)
+		get_bh(dx_root_bh);
+
 	if (OCFS2_I(dir)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
+		/*
+		 * This would be a code error as an inline directory should
+		 * never have an index root.
+		 */
+		BUG_ON(dx_root_bh);
+
 		status = ocfs2_expand_inline_dir(dir, parent_fe_bh,
 						 blocks_wanted, lookup,
+						 &dx_root_bh,
 						 &new_bh);
 		if (status) {
 			mlog_errno(status);
@@ -2558,6 +2864,10 @@ static int ocfs2_extend_dir(struct ocfs2_super *osb,
 	}
 
 do_extend:
+	if (ocfs2_dir_indexed(dir))
+		credits++; /* For attaching the new dirent block to the
+			    * dx_root */
+
 	down_write(&OCFS2_I(dir)->ip_alloc_sem);
 	drop_alloc_sem = 1;
 
@@ -2585,9 +2895,25 @@ do_extend:
 		goto bail;
 	}
 	memset(new_bh->b_data, 0, sb->s_blocksize);
+
 	de = (struct ocfs2_dir_entry *) new_bh->b_data;
 	de->inode = 0;
-	de->rec_len = cpu_to_le16(sb->s_blocksize);
+	if (ocfs2_dir_has_trailer(dir)) {
+		de->rec_len = ocfs2_dir_trailer_blk_off(sb);
+
+		ocfs2_init_dir_trailer(sb, new_bh, le16_to_cpu(de->rec_len));
+
+		if (ocfs2_dir_indexed(dir)) {
+			status = ocfs2_dx_dir_link_trailer(dir, handle,
+							   dx_root_bh, new_bh);
+			if (status) {
+				mlog_errno(status);
+				goto bail;
+			}
+		}
+	} else {
+		de->rec_len = cpu_to_le16(sb->s_blocksize);
+	}
 	status = ocfs2_journal_dirty(handle, new_bh);
 	if (status < 0) {
 		mlog_errno(status);
@@ -2618,6 +2944,7 @@ bail:
 		ocfs2_free_alloc_context(meta_ac);
 
 	brelse(new_bh);
+	brelse(dx_root_bh);
 
 	mlog_exit(status);
 	return status;
@@ -2629,11 +2956,21 @@ static int ocfs2_find_dir_space_id(struct inode *dir, struct buffer_head *di_bh,
 				   unsigned int *blocks_wanted)
 {
 	int ret;
+	struct super_block *sb = dir->i_sb;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 	struct ocfs2_dir_entry *de, *last_de = NULL;
 	char *de_buf, *limit;
 	unsigned long offset = 0;
-	unsigned int rec_len, new_rec_len;
+	unsigned int rec_len, new_rec_len, free_space = dir->i_sb->s_blocksize;
+
+	/*
+	 * This calculates how many free bytes we'd have in block zero, should
+	 * this function force expansion to an extent tree.
+	 */
+	if (ocfs2_supports_indexed_dirs(OCFS2_SB(sb)))
+		free_space = ocfs2_dir_trailer_blk_off(sb) - i_size_read(dir);
+	else
+		free_space = dir->i_sb->s_blocksize - i_size_read(dir);
 
 	de_buf = di->id2.i_data.id_data;
 	limit = de_buf + i_size_read(dir);
@@ -2650,6 +2987,11 @@ static int ocfs2_find_dir_space_id(struct inode *dir, struct buffer_head *di_bh,
 			ret = -EEXIST;
 			goto out;
 		}
+		/*
+		 * No need to check for a trailing dirent record here as
+		 * they're not used for inline dirs.
+		 */
+
 		if (ocfs2_dirent_would_fit(de, rec_len)) {
 			/* Ok, we found a spot. Return this bh and let
 			 * the caller actually fill it in. */
@@ -2670,7 +3012,7 @@ static int ocfs2_find_dir_space_id(struct inode *dir, struct buffer_head *di_bh,
 	 * dirent can be found.
 	 */
 	*blocks_wanted = 1;
-	new_rec_len = le16_to_cpu(last_de->rec_len) + (dir->i_sb->s_blocksize - i_size_read(dir));
+	new_rec_len = le16_to_cpu(last_de->rec_len) + free_space;
 	if (new_rec_len < (rec_len + OCFS2_DIR_REC_LEN(last_de->name_len)))
 		*blocks_wanted = 2;
 
@@ -2730,6 +3072,11 @@ static int ocfs2_find_dir_space_el(struct inode *dir, const char *name,
 			status = -EEXIST;
 			goto bail;
 		}
+
+		if (ocfs2_skip_dir_trailer(dir, de, offset,
+					   dir->i_sb->s_blocksize))
+			goto next;
+
 		if (ocfs2_dirent_would_fit(de, rec_len)) {
 			/* Ok, we found a spot. Return this bh and let
 			 * the caller actually fill it in. */
@@ -2738,6 +3085,7 @@ static int ocfs2_find_dir_space_el(struct inode *dir, const char *name,
 			status = 0;
 			goto bail;
 		}
+next:
 		offset += le16_to_cpu(de->rec_len);
 		de = (struct ocfs2_dir_entry *)((char *) de + le16_to_cpu(de->rec_len));
 	}
@@ -3130,25 +3478,18 @@ out:
 }
 
 static int ocfs2_find_dir_space_dx(struct ocfs2_super *osb, struct inode *dir,
-				   struct buffer_head *di_bh, const char *name,
-				   int namelen,
+				   struct buffer_head *di_bh,
+				   struct buffer_head *dx_root_bh,
+				   const char *name, int namelen,
 				   struct ocfs2_dir_lookup_result *lookup)
 {
 	int ret, rebalanced = 0;
-	struct buffer_head *dx_root_bh = NULL;
 	struct ocfs2_dx_root_block *dx_root;
 	struct buffer_head *dx_leaf_bh = NULL;
 	struct ocfs2_dx_leaf *dx_leaf;
-	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 	u64 blkno;
 	u32 leaf_cpos;
 
-	ret = ocfs2_dx_dir_read_root(dir, di, &dx_root_bh);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
-
 	dx_root = (struct ocfs2_dx_root_block *)dx_root_bh->b_data;
 
 restart_search:
@@ -3211,6 +3552,125 @@ restart_search:
 
 out:
 	brelse(dx_leaf_bh);
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
+		ret = ocfs2_read_block(dir, next_block, &leaf_bh);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		db = ocfs2_trailer_from_bh(leaf_bh, dir->i_sb);
+		if (rec_len <= le16_to_cpu(db->db_free_rec_len)) {
+			lookup->dl_leaf_bh = leaf_bh;
+			if (prev_leaf_bh)
+				lookup->dl_prev_leaf_bh = prev_leaf_bh;
+			else {
+				lookup->dl_prev_leaf_bh = dx_root_bh;
+				lookup->dl_prev_is_dx_root = 1;
+			}
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
+static int ocfs2_prepare_dx_dir_for_insert(struct inode *dir, 
+					   struct buffer_head *di_bh,
+					   const char *name,
+					   int namelen,
+					   struct ocfs2_dir_lookup_result *lookup)
+{
+	int ret;
+	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
+	struct buffer_head *dx_root_bh = NULL;
+	struct buffer_head *leaf_bh = NULL;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+
+	ocfs2_dx_dir_name_hash(dir, name, namelen, &lookup->dl_hinfo);
+
+	ret = ocfs2_dx_dir_read_root(dir, di, &dx_root_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	/*
+	 * Insert preparation for an indexed directory is split into two
+	 * steps. The call to find_dir_space_dx reserves room in the index for
+	 * an additional item. If we run out of space there, it's a real error
+	 * we can't continue on.
+	 */
+	ret = ocfs2_find_dir_space_dx(osb, dir, di_bh, dx_root_bh, name,
+				      namelen, lookup);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	/*
+	 * Next, we need to find space in the unindexed tree. This call
+	 * searches using the free space linked list. If the unindexed tree
+	 * lacks sufficient space, we'll expand it below. The expansion code
+	 * is smart enough to add any new blocks to the free space list.
+	 */
+	ret = ocfs2_search_dx_free_list(dir, dx_root_bh, namelen, lookup);
+	if (ret && ret != -ENOSPC) {
+		mlog_errno(ret);
+		goto out;
+	}
+	if (ret == -ENOSPC) {
+		ret = ocfs2_extend_dir(osb, dir, di_bh, 1, lookup, dx_root_bh,
+				       &leaf_bh);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		/*
+		 * We make the assumption here that new leaf blocks are added
+		 * to the front of our free list.
+		 */
+		get_bh(dx_root_bh);
+		lookup->dl_prev_leaf_bh = dx_root_bh;
+		lookup->dl_prev_is_dx_root = 1;
+		lookup->dl_leaf_bh = leaf_bh;
+	}
+
+out:
 	brelse(dx_root_bh);
 	return ret;
 }
@@ -3241,20 +3701,12 @@ int ocfs2_prepare_dir_for_insert(struct ocfs2_super *osb,
 		goto out;
 	}
 
-	ocfs2_dx_dir_name_hash(dir, name, namelen, &lookup->dl_hinfo);
-
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
@@ -3275,7 +3727,7 @@ int ocfs2_prepare_dir_for_insert(struct ocfs2_super *osb,
 		BUG_ON(bh);
 
 		ret = ocfs2_extend_dir(osb, dir, parent_fe_bh, blocks_wanted,
-				       lookup, &bh);
+				       lookup, NULL, &bh);
 		if (ret) {
 			if (ret != -ENOSPC)
 				mlog_errno(ret);
diff --git a/fs/ocfs2/dir.h b/fs/ocfs2/dir.h
index d035b75..e35689b 100644
--- a/fs/ocfs2/dir.h
+++ b/fs/ocfs2/dir.h
@@ -38,6 +38,9 @@ struct ocfs2_dir_lookup_result {
 	struct buffer_head		*dl_dx_leaf_bh;
 	struct ocfs2_dx_entry		*dl_dx_entry;
 	struct ocfs2_dx_hinfo		dl_hinfo;
+
+	struct buffer_head		*dl_prev_leaf_bh;
+	int				dl_prev_is_dx_root;
 };
 void ocfs2_free_dir_lookup_result(struct ocfs2_dir_lookup_result *res);
 
@@ -46,6 +49,7 @@ int ocfs2_find_entry(const char *name, int namelen,
 		     struct ocfs2_dir_lookup_result *lookup);
 int ocfs2_delete_entry(handle_t *handle,
 		       struct inode *dir,
+		       struct buffer_head *dir_di_bh,
 		       struct ocfs2_dir_lookup_result *res);
 int __ocfs2_add_entry(handle_t *handle,
 		      struct inode *dir,
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 354fd24..ba8f9bf 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -316,8 +316,8 @@ int                  ocfs2_journal_dirty_data(handle_t *handle,
 #define OCFS2_REMOVE_EXTENT_CREDITS (OCFS2_TRUNCATE_LOG_UPDATE + OCFS2_INODE_UPDATE_CREDITS)
 
 /* data block for new dir/symlink, 2 for bitmap updates (bitmap fe +
- * bitmap block for the new bit) */
-#define OCFS2_DIR_LINK_ADDITIONAL_CREDITS (1 + 2)
+ * bitmap block for the new bit) + dx_root update for free list */
+#define OCFS2_DIR_LINK_ADDITIONAL_CREDITS (1 + 2 + 1)
 
 /* parent fe, parent block, new file entry, index leaf, inode
  * alloc fe, inode alloc group descriptor + mkdir/symlink blocks */
@@ -333,13 +333,13 @@ int                  ocfs2_journal_dirty_data(handle_t *handle,
 #define OCFS2_SIMPLE_DIR_EXTEND_CREDITS (2)
 
 /* file update (nlink, etc) + directory mtime/ctime + dir entry block
- * + index leaf */
-#define OCFS2_LINK_CREDITS  (2*OCFS2_INODE_UPDATE_CREDITS + 2)
+ * + index leaf + dx_root update for free list */
+#define OCFS2_LINK_CREDITS  (2*OCFS2_INODE_UPDATE_CREDITS + 3)
 
 /* inode + dir inode (if we unlink a dir), + dir entry block + orphan
- * dir inode link + dir inode index leaf */
+ * dir inode link + dir inode index leaf + dir index root */
 #define OCFS2_UNLINK_CREDITS  (2 * OCFS2_INODE_UPDATE_CREDITS + 1             \
-			      + OCFS2_LINK_CREDITS + 1)
+			      + OCFS2_LINK_CREDITS + 1 + 1)
 
 /* dinode + orphan dir dinode + inode alloc dinode + orphan dir entry +
  * inode alloc group descriptor + orphan dir index leaf */
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 862c576..f726e70 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -822,7 +822,7 @@ static int ocfs2_unlink(struct inode *dir,
 	}
 
 	/* delete the name from the parent dir */
-	status = ocfs2_delete_entry(handle, dir, &lookup);
+	status = ocfs2_delete_entry(handle, dir, parent_node_bh, &lookup);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
@@ -1295,7 +1295,8 @@ static int ocfs2_rename(struct inode *old_dir,
 	if (status)
 		goto bail;
 
-	status = ocfs2_delete_entry(handle, old_dir, &old_entry_lookup);
+	status = ocfs2_delete_entry(handle, old_dir, old_dir_bh,
+				    &old_entry_lookup);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -1868,7 +1869,8 @@ int ocfs2_orphan_del(struct ocfs2_super *osb,
 	}
 
 	/* remove it from the orphan directory */
-	status = ocfs2_delete_entry(handle, orphan_dir_inode, &lookup);
+	status = ocfs2_delete_entry(handle, orphan_dir_inode, orphan_dir_bh,
+				    &lookup);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index c723d5e..2e19869 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -67,6 +67,7 @@
 #define OCFS2_XATTR_BLOCK_SIGNATURE	"XATTR01"
 #define OCFS2_DX_ROOT_SIGNATURE		"DXDIR01"
 #define OCFS2_DX_LEAF_SIGNATURE		"DXLEAF1"
+#define OCFS2_DIR_TRAILER_SIGNATURE	"DIRTRL1"
 
 /* Compatibility flags */
 #define OCFS2_HAS_COMPAT_FEATURE(sb,mask)			\
@@ -94,7 +95,8 @@
 					 | OCFS2_FEATURE_INCOMPAT_INLINE_DATA \
 					 | OCFS2_FEATURE_INCOMPAT_EXTENDED_SLOT_MAP \
 					 | OCFS2_FEATURE_INCOMPAT_USERSPACE_STACK \
-					 | OCFS2_FEATURE_INCOMPAT_XATTR)
+					 | OCFS2_FEATURE_INCOMPAT_XATTR	\
+					 | OCFS2_FEATURE_INCOMPAT_INDEXED_DIRS)
 #define OCFS2_FEATURE_RO_COMPAT_SUPP	OCFS2_FEATURE_RO_COMPAT_UNWRITTEN
 
 /*
@@ -716,6 +718,30 @@ struct ocfs2_dir_entry {
 } __attribute__ ((packed));
 
 /*
+ * Per-block record for the unindexed directory btree. This is carefully
+ * crafted so that the rec_len and name_len records of an ocfs2_dir_entry are
+ * mirrored. That way, the directory manipulation code needs a minimal amount
+ * of update.
+ *
+ * NOTE: Keep this structure aligned to a multiple of 4 bytes.
+ */
+struct ocfs2_dir_block_trailer {
+/*00*/	__le64		db_compat_inode;	/* Always zero. Was inode */
+
+	__le16		db_compat_rec_len;	/* Backwards compatible with
+						 * ocfs2_dir_entry. */
+	__u8		db_compat_name_len;	/* Always zero. Was name_len */
+	__u8		db_reserved0;
+	__le16		db_reserved1;
+	__le16		db_free_rec_len;	/* Size of largest empty hole
+						 * in this block. */
+	__u8		db_signature[8];	/* Signature for verification */
+	__le64		db_reserved2;
+	__le64		db_free_next;		/* Next block in list */
+	__le64		db_csum;		/* Checksum (unused) */
+};
+
+/*
  * A directory indexing block. Each indexed directory has one of these,
  * pointed to by ocfs2_dinode.
  *
@@ -738,7 +764,9 @@ struct ocfs2_dx_root_block {
 	__le32		dr_reserved1;
 	__le64		dr_dir_blkno;		/* Pointer to parent inode */
 	__le64		dr_reserved2;
-	__le64		dr_reserved3[16];
+	__le64		dr_free_blk;		/* Pointer to head of free
+						 * unindexed block list. */
+	__le64		dr_reserved3[15];
 	struct ocfs2_extent_list	dr_list; /* Keep this aligned to 128
 						  * bits for maximum space
 						  * efficiency. */
-- 
1.5.4.1
