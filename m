From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Sep 19 13:12:27 2007
Subject: [Ocfs2-devel] [PATCH 14/15] ocfs2: Read support for directories
	with inline data
Message-ID: <200709192012.l8JKCHo9029366@rgmgw2.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This splits out extent based directory read support and implements
inline-data versions of those functions. All knowledge of inline-data versus
extent based directories is internalized. For lookups the code uses
ocfs2_find_entry_id(), full dir iterations make use of
ocfs2_dir_foreach_blk_id().

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/dir.c |  176 +++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 168 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 4c36eae..f7aaf4e 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -81,6 +81,10 @@ static int ocfs2_do_extend_dir(struct super_block *sb,
 			       struct ocfs2_alloc_context *meta_ac,
 			       struct buffer_head **new_bh);
 
+/*
+ * bh passed here can be an inode block or a dir data block, depending
+ * on the inode inline data flag.
+ */
 static int ocfs2_check_dir_entry(struct inode * dir,
 				 struct ocfs2_dir_entry * de,
 				 struct buffer_head * bh,
@@ -125,6 +129,8 @@ static int inline ocfs2_search_dirblock(struct buffer_head *bh,
 					struct inode *dir,
 					const char *name, int namelen,
 					unsigned long offset,
+					char *first_de,
+					unsigned int bytes,
 					struct ocfs2_dir_entry **res_dir)
 {
 	struct ocfs2_dir_entry *de;
@@ -134,8 +140,8 @@ static int inline ocfs2_search_dirblock(struct buffer_head *bh,
 
 	mlog_entry_void();
 
-	de_buf = bh->b_data;
-	dlimit = de_buf + dir->i_sb->s_blocksize;
+	de_buf = first_de;
+	dlimit = de_buf + bytes;
 
 	while (de_buf < dlimit) {
 		/* this code is executed quadratically often */
@@ -171,9 +177,39 @@ bail:
 	return ret;
 }
 
-struct buffer_head *ocfs2_find_entry(const char *name, int namelen,
-				     struct inode *dir,
-				     struct ocfs2_dir_entry **res_dir)
+static struct buffer_head *ocfs2_find_entry_id(const char *name,
+					       int namelen,
+					       struct inode *dir,
+					       struct ocfs2_dir_entry **res_dir)
+{
+	int ret, found;
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
+	found = ocfs2_search_dirblock(di_bh, dir, name, namelen, 0,
+				      data->id_data, i_size_read(dir), res_dir);
+	if (found == 1)
+		return di_bh;
+
+	brelse(di_bh);
+out:
+	return NULL;
+}
+
+struct buffer_head *ocfs2_find_entry_el(const char *name, int namelen,
+					struct inode *dir,
+					struct ocfs2_dir_entry **res_dir)
 {
 	struct super_block *sb;
 	struct buffer_head *bh_use[NAMEI_RA_SIZE];
@@ -188,7 +224,6 @@ struct buffer_head *ocfs2_find_entry(const char *name, int namelen,
 
 	mlog_entry_void();
 
-	*res_dir = NULL;
 	sb = dir->i_sb;
 
 	nblocks = i_size_read(dir) >> sb->s_blocksize_bits;
@@ -236,6 +271,7 @@ restart:
 		}
 		i = ocfs2_search_dirblock(bh, dir, name, namelen,
 					  block << sb->s_blocksize_bits,
+					  bh->b_data, sb->s_blocksize,
 					  res_dir);
 		if (i == 1) {
 			OCFS2_I(dir)->ip_dir_start_lookup = block;
@@ -271,6 +307,30 @@ cleanup_and_exit:
 	return ret;
 }
 
+/*
+ * Try to find an entry of the provided name within 'dir'.
+ *
+ * If nothing was found, NULL is returned. Otherwise, a buffer_head
+ * and pointer to the dir entry are passed back.
+ *
+ * Caller can NOT assume anything about the contents of the
+ * buffer_head - it is passed back only so that it can be passed into
+ * any one of the manipulation functions (add entry, delete entry,
+ * etc). As an example, bh in the extent directory case is a data
+ * block, in the inline-data case it actually points to an inode.
+ */
+struct buffer_head *ocfs2_find_entry(const char *name, int namelen,
+				     struct inode *dir,
+				     struct ocfs2_dir_entry **res_dir)
+{
+	*res_dir = NULL;
+
+	if (OCFS2_I(dir)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
+		return ocfs2_find_entry_id(name, namelen, dir, res_dir);
+
+	return ocfs2_find_entry_el(name, namelen, dir, res_dir);
+}
+
 int ocfs2_update_entry(struct inode *dir, handle_t *handle,
 		       struct buffer_head *de_bh, struct ocfs2_dir_entry *de,
 		       struct inode *new_entry_inode)
@@ -459,8 +519,98 @@ bail:
 	return retval;
 }
 
-static int ocfs2_dir_foreach_blk(struct inode *inode, unsigned long *f_version,
-				 loff_t *f_pos, void *priv, filldir_t filldir)
+static int ocfs2_dir_foreach_blk_id(struct inode *inode,
+				    unsigned long *f_version,
+				    loff_t *f_pos, void *priv,
+				    filldir_t filldir)
+{
+	int ret, i, filldir_ret;
+	unsigned long offset = *f_pos;
+	struct buffer_head *di_bh = NULL;
+	struct ocfs2_dinode *di;
+	struct ocfs2_inline_data *data;
+	struct ocfs2_dir_entry *de;
+
+	ret = ocfs2_read_block(OCFS2_SB(inode->i_sb), OCFS2_I(inode)->ip_blkno,
+			       &di_bh, OCFS2_BH_CACHED, inode);
+	if (ret) {
+		mlog(ML_ERROR, "Unable to read inode block for dir %llu\n",
+		     (unsigned long long)OCFS2_I(inode)->ip_blkno);
+		goto out;
+	}
+
+	di = (struct ocfs2_dinode *)di_bh->b_data;
+	data = &di->id2.i_data;
+
+	while (*f_pos < i_size_read(inode)) {
+revalidate:
+		/* If the dir block has changed since the last call to
+		 * readdir(2), then we might be pointing to an invalid
+		 * dirent right now.  Scan from the start of the block
+		 * to make sure. */
+		if (*f_version != inode->i_version) {
+			for (i = 0; i < i_size_read(inode) && i < offset; ) {
+				de = (struct ocfs2_dir_entry *)
+					(data->id_data + i);
+				/* It's too expensive to do a full
+				 * dirent test each time round this
+				 * loop, but we do have to test at
+				 * least that it is non-zero.  A
+				 * failure will be detected in the
+				 * dirent test below. */
+				if (le16_to_cpu(de->rec_len) <
+				    OCFS2_DIR_REC_LEN(1))
+					break;
+				i += le16_to_cpu(de->rec_len);
+			}
+			*f_pos = offset = i;
+			*f_version = inode->i_version;
+		}
+
+		de = (struct ocfs2_dir_entry *) (data->id_data + *f_pos);
+		if (!ocfs2_check_dir_entry(inode, de, di_bh, *f_pos)) {
+			/* On error, skip the f_pos to the end. */
+			*f_pos = i_size_read(inode);
+			goto out;
+		}
+		offset += le16_to_cpu(de->rec_len);
+		if (le64_to_cpu(de->inode)) {
+			/* We might block in the next section
+			 * if the data destination is
+			 * currently swapped out.  So, use a
+			 * version stamp to detect whether or
+			 * not the directory has been modified
+			 * during the copy operation.
+			 */
+			unsigned long version = *f_version;
+			unsigned char d_type = DT_UNKNOWN;
+
+			if (de->file_type < OCFS2_FT_MAX)
+				d_type = ocfs2_filetype_table[de->file_type];
+
+			filldir_ret = filldir(priv, de->name,
+					      de->name_len,
+					      *f_pos,
+					      le64_to_cpu(de->inode),
+					      d_type);
+			if (filldir_ret)
+				break;
+			if (version != *f_version)
+				goto revalidate;
+		}
+		*f_pos += le16_to_cpu(de->rec_len);
+	}
+
+out:
+	brelse(di_bh);
+
+	return 0;
+}
+
+static int ocfs2_dir_foreach_blk_el(struct inode *inode,
+				    unsigned long *f_version,
+				    loff_t *f_pos, void *priv,
+				    filldir_t filldir)
 {
 	int error = 0;
 	unsigned long offset, blk, last_ra_blk = 0;
@@ -576,6 +726,16 @@ out:
 	return stored;
 }
 
+static int ocfs2_dir_foreach_blk(struct inode *inode, unsigned long *f_version,
+				 loff_t *f_pos, void *priv, filldir_t filldir)
+{
+	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
+		return ocfs2_dir_foreach_blk_id(inode, f_version, f_pos, priv,
+						filldir);
+
+	return ocfs2_dir_foreach_blk_el(inode, f_version, f_pos, priv, filldir);
+}
+
 /*
  * This is intended to be called from inside other kernel functions,
  * so we fake some arguments.
-- 
1.5.0.6
