From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 25 Dec 2008 10:04:33 -0800
Subject: [Ocfs2-devel] [PATCH 18/35] ocfs2: Add directory block trailers.
In-Reply-To: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
References: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
Message-ID: <1230228290-22803-19-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>

Future ocfs2 features metaecc and indexed directories need to store a
little bit of data in each dirblock.  For compatibility, we place this
in a trailer at the end of the dirblock.  The trailer plays itself as an
empty dirent, so that if the features are turned off, it can be reused
without requiring a tunefs scan.

This code adds the trailer and validates it when the block is read in.

[ Mark is the original author, but I reinserted this code before his
  dir index work.  -- Joel ]

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dir.c      |  197 +++++++++++++++++++++++++++++++++++++++++++++++----
 fs/ocfs2/ocfs2.h    |    3 +
 fs/ocfs2/ocfs2_fs.h |   29 ++++++++
 3 files changed, 215 insertions(+), 14 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 45e4e03..1efd0ab 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -84,6 +84,63 @@ static int ocfs2_do_extend_dir(struct super_block *sb,
 			       struct buffer_head **new_bh);
 
 /*
+ * These are distinct checks because future versions of the file system will
+ * want to have a trailing dirent structure independent of indexing.
+ */
+static int ocfs2_dir_has_trailer(struct inode *dir)
+{
+	if (OCFS2_I(dir)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
+		return 0;
+
+	return ocfs2_meta_ecc(OCFS2_SB(dir->i_sb));
+}
+
+static int ocfs2_supports_dir_trailer(struct ocfs2_super *osb)
+{
+	return ocfs2_meta_ecc(osb);
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
+static void ocfs2_init_dir_trailer(struct inode *inode,
+				   struct buffer_head *bh)
+{
+	struct ocfs2_dir_block_trailer *trailer;
+
+	trailer = ocfs2_trailer_from_bh(bh, inode->i_sb);
+	strcpy(trailer->db_signature, OCFS2_DIR_TRAILER_SIGNATURE);
+	trailer->db_compat_rec_len =
+			cpu_to_le16(sizeof(struct ocfs2_dir_block_trailer));
+	trailer->db_parent_dinode = cpu_to_le64(OCFS2_I(inode)->ip_blkno);
+	trailer->db_blkno = cpu_to_le64(bh->b_blocknr);
+}
+
+/*
  * bh passed here can be an inode block or a dir data block, depending
  * on the inode inline data flag.
  */
@@ -232,16 +289,60 @@ static int ocfs2_read_dir_block(struct inode *inode, u64 v_block,
 {
 	int rc = 0;
 	struct buffer_head *tmp = *bh;
+	struct ocfs2_dir_block_trailer *trailer;
 
 	rc = ocfs2_read_virt_blocks(inode, v_block, 1, &tmp, flags,
 				    ocfs2_validate_dir_block);
-	if (rc)
+	if (rc) {
 		mlog_errno(rc);
+		goto out;
+	}
+
+	/*
+	 * We check the trailer here rather than in
+	 * ocfs2_validate_dir_block() because that function doesn't have
+	 * the inode to test.
+	 */
+	if (!(flags & OCFS2_BH_READAHEAD) &&
+	    ocfs2_dir_has_trailer(inode)) {
+		trailer = ocfs2_trailer_from_bh(tmp, inode->i_sb);
+		if (!OCFS2_IS_VALID_DIR_TRAILER(trailer)) {
+			rc = -EINVAL;
+			ocfs2_error(inode->i_sb,
+				    "Invalid dirblock #%llu: "
+				    "signature = %.*s\n",
+				    (unsigned long long)tmp->b_blocknr, 7,
+				    trailer->db_signature);
+			goto out;
+		}
+		if (le64_to_cpu(trailer->db_blkno) != tmp->b_blocknr) {
+			rc = -EINVAL;
+			ocfs2_error(inode->i_sb,
+				    "Directory block #%llu has an invalid "
+				    "db_blkno of %llu",
+				    (unsigned long long)tmp->b_blocknr,
+				    (unsigned long long)le64_to_cpu(trailer->db_blkno));
+			goto out;
+		}
+		if (le64_to_cpu(trailer->db_parent_dinode) !=
+		    OCFS2_I(inode)->ip_blkno) {
+			rc = -EINVAL;
+			ocfs2_error(inode->i_sb,
+				    "Directory block #%llu on dinode "
+				    "#%llu has an invalid parent_dinode "
+				    "of %llu",
+				    (unsigned long long)tmp->b_blocknr,
+				    (unsigned long long)OCFS2_I(inode)->ip_blkno,
+				    (unsigned long long)le64_to_cpu(trailer->db_blkno));
+			goto out;
+		}
+	}
 
 	/* If ocfs2_read_virt_blocks() got us a new bh, pass it up. */
-	if (!rc && !*bh)
+	if (!*bh)
 		*bh = tmp;
 
+out:
 	return rc ? -EIO : 0;
 }
 
@@ -581,6 +682,16 @@ int __ocfs2_add_entry(handle_t *handle,
 			goto bail;
 		}
 
+		/* We're guaranteed that we should have space, so we
+		 * can't possibly have hit the trailer...right? */
+		mlog_bug_on_msg(ocfs2_skip_dir_trailer(dir, de, offset, size),
+				"Hit dir trailer trying to insert %.*s "
+			        "(namelen %d) into directory %llu.  "
+				"offset is %lu, trailer offset is %d\n",
+				namelen, name, namelen,
+				(unsigned long long)parent_fe_bh->b_blocknr,
+				offset, ocfs2_dir_trailer_blk_off(dir->i_sb));
+
 		if (ocfs2_dirent_would_fit(de, rec_len)) {
 			dir->i_mtime = dir->i_ctime = CURRENT_TIME;
 			retval = ocfs2_mark_inode_dirty(handle, dir, parent_fe_bh);
@@ -622,6 +733,7 @@ int __ocfs2_add_entry(handle_t *handle,
 			retval = 0;
 			goto bail;
 		}
+
 		offset += le16_to_cpu(de->rec_len);
 		de = (struct ocfs2_dir_entry *) ((char *) de + le16_to_cpu(de->rec_len));
 	}
@@ -1059,9 +1171,15 @@ int ocfs2_empty_dir(struct inode *inode)
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
 
@@ -1078,6 +1196,8 @@ static void ocfs2_fill_initial_dirents(struct inode *inode,
 	de->name_len = 2;
 	strcpy(de->name, "..");
 	ocfs2_set_de_type(de, S_IFDIR);
+
+	return de;
 }
 
 /*
@@ -1130,10 +1250,15 @@ static int ocfs2_fill_new_dir_el(struct ocfs2_super *osb,
 				 struct ocfs2_alloc_context *data_ac)
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
@@ -1151,8 +1276,9 @@ static int ocfs2_fill_new_dir_el(struct ocfs2_super *osb,
 	}
 	memset(new_bh->b_data, 0, osb->sb->s_blocksize);
 
-	ocfs2_fill_initial_dirents(inode, parent, new_bh->b_data,
-				   osb->sb->s_blocksize);
+	de = ocfs2_fill_initial_dirents(inode, parent, new_bh->b_data, size);
+	if (ocfs2_supports_dir_trailer(osb))
+		ocfs2_init_dir_trailer(inode, new_bh);
 
 	status = ocfs2_journal_dirty(handle, new_bh);
 	if (status < 0) {
@@ -1193,13 +1319,27 @@ int ocfs2_fill_new_dir(struct ocfs2_super *osb,
 				     data_ac);
 }
 
+/*
+ * Expand rec_len of the rightmost dirent in a directory block so that it
+ * contains the end of our valid space for dirents. We do this during
+ * expansion from an inline directory to one with extents. The first dir block
+ * in that case is taken from the inline data portion of the inode block.
+ *
+ * We add the dir trailer if this filesystem wants it.
+ */
 static void ocfs2_expand_last_dirent(char *start, unsigned int old_size,
-				     unsigned int new_size)
+				     struct super_block *sb)
 {
 	struct ocfs2_dir_entry *de;
 	struct ocfs2_dir_entry *prev_de;
 	char *de_buf, *limit;
-	unsigned int bytes = new_size - old_size;
+	unsigned int new_size = sb->s_blocksize;
+	unsigned int bytes;
+
+	if (ocfs2_supports_dir_trailer(OCFS2_SB(sb)))
+		new_size = ocfs2_dir_trailer_blk_off(sb);
+
+	bytes = new_size - old_size;
 
 	limit = start + old_size;
 	de_buf = start;
@@ -1316,8 +1456,9 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 	memcpy(dirdata_bh->b_data, di->id2.i_data.id_data, i_size_read(dir));
 	memset(dirdata_bh->b_data + i_size_read(dir), 0,
 	       sb->s_blocksize - i_size_read(dir));
-	ocfs2_expand_last_dirent(dirdata_bh->b_data, i_size_read(dir),
-				 sb->s_blocksize);
+	ocfs2_expand_last_dirent(dirdata_bh->b_data, i_size_read(dir), sb);
+	if (ocfs2_supports_dir_trailer(osb))
+		ocfs2_init_dir_trailer(dir, dirdata_bh);
 
 	ret = ocfs2_journal_dirty(handle, dirdata_bh);
 	if (ret) {
@@ -1604,9 +1745,15 @@ do_extend:
 		goto bail;
 	}
 	memset(new_bh->b_data, 0, sb->s_blocksize);
+
 	de = (struct ocfs2_dir_entry *) new_bh->b_data;
 	de->inode = 0;
-	de->rec_len = cpu_to_le16(sb->s_blocksize);
+	if (ocfs2_dir_has_trailer(dir)) {
+		de->rec_len = cpu_to_le16(ocfs2_dir_trailer_blk_off(sb));
+		ocfs2_init_dir_trailer(dir, new_bh);
+	} else {
+		de->rec_len = cpu_to_le16(sb->s_blocksize);
+	}
 	status = ocfs2_journal_dirty(handle, new_bh);
 	if (status < 0) {
 		mlog_errno(status);
@@ -1648,11 +1795,21 @@ static int ocfs2_find_dir_space_id(struct inode *dir, struct buffer_head *di_bh,
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
+	if (ocfs2_supports_dir_trailer(OCFS2_SB(sb)))
+		free_space = ocfs2_dir_trailer_blk_off(sb) - i_size_read(dir);
+	else
+		free_space = dir->i_sb->s_blocksize - i_size_read(dir);
 
 	de_buf = di->id2.i_data.id_data;
 	limit = de_buf + i_size_read(dir);
@@ -1669,6 +1826,11 @@ static int ocfs2_find_dir_space_id(struct inode *dir, struct buffer_head *di_bh,
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
@@ -1689,7 +1851,7 @@ static int ocfs2_find_dir_space_id(struct inode *dir, struct buffer_head *di_bh,
 	 * dirent can be found.
 	 */
 	*blocks_wanted = 1;
-	new_rec_len = le16_to_cpu(last_de->rec_len) + (dir->i_sb->s_blocksize - i_size_read(dir));
+	new_rec_len = le16_to_cpu(last_de->rec_len) + free_space;
 	if (new_rec_len < (rec_len + OCFS2_DIR_REC_LEN(last_de->name_len)))
 		*blocks_wanted = 2;
 
@@ -1707,6 +1869,7 @@ static int ocfs2_find_dir_space_el(struct inode *dir, const char *name,
 	struct ocfs2_dir_entry *de;
 	struct super_block *sb = dir->i_sb;
 	int status;
+	int blocksize = dir->i_sb->s_blocksize;
 
 	status = ocfs2_read_dir_block(dir, 0, &bh, 0);
 	if (status) {
@@ -1748,6 +1911,11 @@ static int ocfs2_find_dir_space_el(struct inode *dir, const char *name,
 			status = -EEXIST;
 			goto bail;
 		}
+
+		if (ocfs2_skip_dir_trailer(dir, de, offset % blocksize,
+					   blocksize))
+			goto next;
+
 		if (ocfs2_dirent_would_fit(de, rec_len)) {
 			/* Ok, we found a spot. Return this bh and let
 			 * the caller actually fill it in. */
@@ -1756,6 +1924,7 @@ static int ocfs2_find_dir_space_el(struct inode *dir, const char *name,
 			status = 0;
 			goto bail;
 		}
+next:
 		offset += le16_to_cpu(de->rec_len);
 		de = (struct ocfs2_dir_entry *)((char *) de + le16_to_cpu(de->rec_len));
 	}
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index bad87d0..ad5c24a 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -470,6 +470,9 @@ static inline int ocfs2_uses_extended_slot_map(struct ocfs2_super *osb)
 #define OCFS2_IS_VALID_XATTR_BLOCK(ptr)					\
 	(!strcmp((ptr)->xb_signature, OCFS2_XATTR_BLOCK_SIGNATURE))
 
+#define OCFS2_IS_VALID_DIR_TRAILER(ptr)					\
+	(!strcmp((ptr)->db_signature, OCFS2_DIR_TRAILER_SIGNATURE))
+
 static inline unsigned long ino_from_blkno(struct super_block *sb,
 					   u64 blkno)
 {
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 290fa26..af0013b 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -65,6 +65,7 @@
 #define OCFS2_EXTENT_BLOCK_SIGNATURE	"EXBLK01"
 #define OCFS2_GROUP_DESC_SIGNATURE      "GROUP01"
 #define OCFS2_XATTR_BLOCK_SIGNATURE	"XATTR01"
+#define OCFS2_DIR_TRAILER_SIGNATURE	"DIRTRL1"
 
 /* Compatibility flags */
 #define OCFS2_HAS_COMPAT_FEATURE(sb,mask)			\
@@ -752,6 +753,34 @@ struct ocfs2_dir_entry {
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
+						 * in this block. (unused) */
+/*10*/	__u8		db_signature[8];	/* Signature for verification */
+	__le64		db_reserved2;
+	__le64		db_free_next;		/* Next block in list (unused) */
+/*20*/	__le64		db_blkno;		/* Offset on disk, in blocks */
+	__le64		db_parent_dinode;	/* dinode which owns me, in
+						   blocks */
+/*30*/	__le64		db_check;		/* Error checking */
+/*40*/
+};
+
+/*
  * On disk allocator group structure for OCFS2
  */
 struct ocfs2_group_desc
-- 
1.5.6
