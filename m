From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Sep 19 13:12:20 2007
Subject: [Ocfs2-devel] [PATCH 03/15] ocfs2: Move directory manipulation code
	into dir.c
Message-ID: <200709192012.l8JKCGjS012156@agmgw2.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The code for adding, removing, deleting directory entries was splattered all
over namei.c. I'd rather have this all centralized, so that it's easier to
make changes for inline dir data, and eventually indexed directories.

None of the code in any of the functions was changed. I only removed the
static keyword from some prototypes so that they could be exported.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/dir.c     |  430 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ocfs2/dir.h     |   44 +++++-
 fs/ocfs2/journal.c |    2 +-
 fs/ocfs2/namei.c   |  433 ----------------------------------------------------
 fs/ocfs2/namei.h   |   19 ---
 5 files changed, 461 insertions(+), 467 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 0d5fdde..8e0ae02 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -55,10 +55,16 @@
 #include "journal.h"
 #include "namei.h"
 #include "suballoc.h"
+#include "super.h"
 #include "uptodate.h"
 
 #include "buffer_head_io.h"
 
+#define NAMEI_RA_CHUNKS  2
+#define NAMEI_RA_BLOCKS  4
+#define NAMEI_RA_SIZE        (NAMEI_RA_CHUNKS * NAMEI_RA_BLOCKS)
+#define NAMEI_RA_INDEX(c,b)  (((c) * NAMEI_RA_BLOCKS) + (b))
+
 static unsigned char ocfs2_filetype_table[] = {
 	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK
 };
@@ -67,6 +73,347 @@ static int ocfs2_extend_dir(struct ocfs2_super *osb,
 			    struct inode *dir,
 			    struct buffer_head *parent_fe_bh,
 			    struct buffer_head **new_de_bh);
+static int ocfs2_do_extend_dir(struct super_block *sb,
+			       handle_t *handle,
+			       struct inode *dir,
+			       struct buffer_head *parent_fe_bh,
+			       struct ocfs2_alloc_context *data_ac,
+			       struct ocfs2_alloc_context *meta_ac,
+			       struct buffer_head **new_bh);
+
+int ocfs2_check_dir_entry(struct inode * dir,
+			  struct ocfs2_dir_entry * de,
+			  struct buffer_head * bh,
+			  unsigned long offset)
+{
+	const char *error_msg = NULL;
+	const int rlen = le16_to_cpu(de->rec_len);
+
+	if (rlen < OCFS2_DIR_REC_LEN(1))
+		error_msg = "rec_len is smaller than minimal";
+	else if (rlen % 4 != 0)
+		error_msg = "rec_len % 4 != 0";
+	else if (rlen < OCFS2_DIR_REC_LEN(de->name_len))
+		error_msg = "rec_len is too small for name_len";
+	else if (((char *) de - bh->b_data) + rlen > dir->i_sb->s_blocksize)
+		error_msg = "directory entry across blocks";
+
+	if (error_msg != NULL)
+		mlog(ML_ERROR, "bad entry in directory #%llu: %s - "
+		     "offset=%lu, inode=%llu, rec_len=%d, name_len=%d\n",
+		     (unsigned long long)OCFS2_I(dir)->ip_blkno, error_msg,
+		     offset, (unsigned long long)le64_to_cpu(de->inode), rlen,
+		     de->name_len);
+	return error_msg == NULL ? 1 : 0;
+}
+
+static inline int ocfs2_match(int len,
+			      const char * const name,
+			      struct ocfs2_dir_entry *de)
+{
+	if (len != de->name_len)
+		return 0;
+	if (!de->inode)
+		return 0;
+	return !memcmp(name, de->name, len);
+}
+
+/*
+ * Returns 0 if not found, -1 on failure, and 1 on success
+ */
+static int inline ocfs2_search_dirblock(struct buffer_head *bh,
+					struct inode *dir,
+					const char *name, int namelen,
+					unsigned long offset,
+					struct ocfs2_dir_entry **res_dir)
+{
+	struct ocfs2_dir_entry *de;
+	char *dlimit, *de_buf;
+	int de_len;
+	int ret = 0;
+
+	mlog_entry_void();
+
+	de_buf = bh->b_data;
+	dlimit = de_buf + dir->i_sb->s_blocksize;
+
+	while (de_buf < dlimit) {
+		/* this code is executed quadratically often */
+		/* do minimal checking `by hand' */
+
+		de = (struct ocfs2_dir_entry *) de_buf;
+
+		if (de_buf + namelen <= dlimit &&
+		    ocfs2_match(namelen, name, de)) {
+			/* found a match - just to be sure, do a full check */
+			if (!ocfs2_check_dir_entry(dir, de, bh, offset)) {
+				ret = -1;
+				goto bail;
+			}
+			*res_dir = de;
+			ret = 1;
+			goto bail;
+		}
+
+		/* prevent looping on a bad block */
+		de_len = le16_to_cpu(de->rec_len);
+		if (de_len <= 0) {
+			ret = -1;
+			goto bail;
+		}
+
+		de_buf += de_len;
+		offset += de_len;
+	}
+
+bail:
+	mlog_exit(ret);
+	return ret;
+}
+
+struct buffer_head *ocfs2_find_entry(const char *name, int namelen,
+				     struct inode *dir,
+				     struct ocfs2_dir_entry **res_dir)
+{
+	struct super_block *sb;
+	struct buffer_head *bh_use[NAMEI_RA_SIZE];
+	struct buffer_head *bh, *ret = NULL;
+	unsigned long start, block, b;
+	int ra_max = 0;		/* Number of bh's in the readahead
+				   buffer, bh_use[] */
+	int ra_ptr = 0;		/* Current index into readahead
+				   buffer */
+	int num = 0;
+	int nblocks, i, err;
+
+	mlog_entry_void();
+
+	*res_dir = NULL;
+	sb = dir->i_sb;
+
+	nblocks = i_size_read(dir) >> sb->s_blocksize_bits;
+	start = OCFS2_I(dir)->ip_dir_start_lookup;
+	if (start >= nblocks)
+		start = 0;
+	block = start;
+
+restart:
+	do {
+		/*
+		 * We deal with the read-ahead logic here.
+		 */
+		if (ra_ptr >= ra_max) {
+			/* Refill the readahead buffer */
+			ra_ptr = 0;
+			b = block;
+			for (ra_max = 0; ra_max < NAMEI_RA_SIZE; ra_max++) {
+				/*
+				 * Terminate if we reach the end of the
+				 * directory and must wrap, or if our
+				 * search has finished@this block.
+				 */
+				if (b >= nblocks || (num && block == start)) {
+					bh_use[ra_max] = NULL;
+					break;
+				}
+				num++;
+
+				bh = ocfs2_bread(dir, b++, &err, 1);
+				bh_use[ra_max] = bh;
+			}
+		}
+		if ((bh = bh_use[ra_ptr++]) == NULL)
+			goto next;
+		wait_on_buffer(bh);
+		if (!buffer_uptodate(bh)) {
+			/* read error, skip block & hope for the best */
+			ocfs2_error(dir->i_sb, "reading directory %llu, "
+				    "offset %lu\n",
+				    (unsigned long long)OCFS2_I(dir)->ip_blkno,
+				    block);
+			brelse(bh);
+			goto next;
+		}
+		i = ocfs2_search_dirblock(bh, dir, name, namelen,
+					  block << sb->s_blocksize_bits,
+					  res_dir);
+		if (i == 1) {
+			OCFS2_I(dir)->ip_dir_start_lookup = block;
+			ret = bh;
+			goto cleanup_and_exit;
+		} else {
+			brelse(bh);
+			if (i < 0)
+				goto cleanup_and_exit;
+		}
+	next:
+		if (++block >= nblocks)
+			block = 0;
+	} while (block != start);
+
+	/*
+	 * If the directory has grown while we were searching, then
+	 * search the last part of the directory before giving up.
+	 */
+	block = nblocks;
+	nblocks = i_size_read(dir) >> sb->s_blocksize_bits;
+	if (block < nblocks) {
+		start = 0;
+		goto restart;
+	}
+
+cleanup_and_exit:
+	/* Clean up the read-ahead blocks */
+	for (; ra_ptr < ra_max; ra_ptr++)
+		brelse(bh_use[ra_ptr]);
+
+	mlog_exit_ptr(ret);
+	return ret;
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
+	struct ocfs2_dir_entry *de, *pde;
+	int i, status = -ENOENT;
+
+	mlog_entry("(0x%p, 0x%p, 0x%p, 0x%p)\n", handle, dir, de_del, bh);
+
+	i = 0;
+	pde = NULL;
+	de = (struct ocfs2_dir_entry *) bh->b_data;
+	while (i < bh->b_size) {
+		if (!ocfs2_check_dir_entry(dir, de, bh, i)) {
+			status = -EIO;
+			mlog_errno(status);
+			goto bail;
+		}
+		if (de == de_del)  {
+			status = ocfs2_journal_access(handle, dir, bh,
+						      OCFS2_JOURNAL_ACCESS_WRITE);
+			if (status < 0) {
+				status = -EIO;
+				mlog_errno(status);
+				goto bail;
+			}
+			if (pde)
+				pde->rec_len =
+					cpu_to_le16(le16_to_cpu(pde->rec_len) +
+						    le16_to_cpu(de->rec_len));
+			else
+				de->inode = 0;
+			dir->i_version++;
+			status = ocfs2_journal_dirty(handle, bh);
+			goto bail;
+		}
+		i += le16_to_cpu(de->rec_len);
+		pde = de;
+		de = (struct ocfs2_dir_entry *)((char *)de + le16_to_cpu(de->rec_len));
+	}
+bail:
+	mlog_exit(status);
+	return status;
+}
+
+/* we don't always have a dentry for what we want to add, so people
+ * like orphan dir can call this instead.
+ *
+ * If you pass me insert_bh, I'll skip the search of the other dir
+ * blocks and put the record in there.
+ */
+int __ocfs2_add_entry(handle_t *handle,
+		      struct inode *dir,
+		      const char *name, int namelen,
+		      struct inode *inode, u64 blkno,
+		      struct buffer_head *parent_fe_bh,
+		      struct buffer_head *insert_bh)
+{
+	unsigned long offset;
+	unsigned short rec_len;
+	struct ocfs2_dir_entry *de, *de1;
+	struct super_block *sb;
+	int retval, status;
+
+	mlog_entry_void();
+
+	sb = dir->i_sb;
+
+	if (!namelen)
+		return -EINVAL;
+
+	rec_len = OCFS2_DIR_REC_LEN(namelen);
+	offset = 0;
+	de = (struct ocfs2_dir_entry *) insert_bh->b_data;
+	while (1) {
+		BUG_ON((char *)de >= sb->s_blocksize + insert_bh->b_data);
+		/* These checks should've already been passed by the
+		 * prepare function, but I guess we can leave them
+		 * here anyway. */
+		if (!ocfs2_check_dir_entry(dir, de, insert_bh, offset)) {
+			retval = -ENOENT;
+			goto bail;
+		}
+		if (ocfs2_match(namelen, name, de)) {
+			retval = -EEXIST;
+			goto bail;
+		}
+		if (((le64_to_cpu(de->inode) == 0) &&
+		     (le16_to_cpu(de->rec_len) >= rec_len)) ||
+		    (le16_to_cpu(de->rec_len) >=
+		     (OCFS2_DIR_REC_LEN(de->name_len) + rec_len))) {
+			dir->i_mtime = dir->i_ctime = CURRENT_TIME;
+			retval = ocfs2_mark_inode_dirty(handle, dir, parent_fe_bh);
+			if (retval < 0) {
+				mlog_errno(retval);
+				goto bail;
+			}
+
+			status = ocfs2_journal_access(handle, dir, insert_bh,
+						      OCFS2_JOURNAL_ACCESS_WRITE);
+			/* By now the buffer is marked for journaling */
+			offset += le16_to_cpu(de->rec_len);
+			if (le64_to_cpu(de->inode)) {
+				de1 = (struct ocfs2_dir_entry *)((char *) de +
+					OCFS2_DIR_REC_LEN(de->name_len));
+				de1->rec_len =
+					cpu_to_le16(le16_to_cpu(de->rec_len) -
+					OCFS2_DIR_REC_LEN(de->name_len));
+				de->rec_len = cpu_to_le16(OCFS2_DIR_REC_LEN(de->name_len));
+				de = de1;
+			}
+			de->file_type = OCFS2_FT_UNKNOWN;
+			if (blkno) {
+				de->inode = cpu_to_le64(blkno);
+				ocfs2_set_de_type(de, inode->i_mode);
+			} else
+				de->inode = 0;
+			de->name_len = namelen;
+			memcpy(de->name, name, namelen);
+
+			dir->i_version++;
+			status = ocfs2_journal_dirty(handle, insert_bh);
+			retval = 0;
+			goto bail;
+		}
+		offset += le16_to_cpu(de->rec_len);
+		de = (struct ocfs2_dir_entry *) ((char *) de + le16_to_cpu(de->rec_len));
+	}
+
+	/* when you think about it, the assert above should prevent us
+	 * from ever getting here. */
+	retval = -ENOSPC;
+bail:
+
+	mlog_exit(retval);
+	return retval;
+}
+
 /*
  * ocfs2_readdir()
  *
@@ -347,14 +694,83 @@ int ocfs2_empty_dir(struct inode *inode)
 	return 1;
 }
 
+int ocfs2_fill_new_dir(struct ocfs2_super *osb,
+		       handle_t *handle,
+		       struct inode *parent,
+		       struct inode *inode,
+		       struct buffer_head *fe_bh,
+		       struct ocfs2_alloc_context *data_ac)
+{
+	int status;
+	struct buffer_head *new_bh = NULL;
+	struct ocfs2_dir_entry *de = NULL;
+
+	mlog_entry_void();
+
+	status = ocfs2_do_extend_dir(osb->sb, handle, inode, fe_bh,
+				     data_ac, NULL, &new_bh);
+	if (status < 0) {
+		mlog_errno(status);
+		goto bail;
+	}
+
+	ocfs2_set_new_buffer_uptodate(inode, new_bh);
+
+	status = ocfs2_journal_access(handle, inode, new_bh,
+				      OCFS2_JOURNAL_ACCESS_CREATE);
+	if (status < 0) {
+		mlog_errno(status);
+		goto bail;
+	}
+	memset(new_bh->b_data, 0, osb->sb->s_blocksize);
+
+	de = (struct ocfs2_dir_entry *) new_bh->b_data;
+	de->inode = cpu_to_le64(OCFS2_I(inode)->ip_blkno);
+	de->name_len = 1;
+	de->rec_len =
+		cpu_to_le16(OCFS2_DIR_REC_LEN(de->name_len));
+	strcpy(de->name, ".");
+	ocfs2_set_de_type(de, S_IFDIR);
+	de = (struct ocfs2_dir_entry *) ((char *)de + le16_to_cpu(de->rec_len));
+	de->inode = cpu_to_le64(OCFS2_I(parent)->ip_blkno);
+	de->rec_len = cpu_to_le16(inode->i_sb->s_blocksize -
+				  OCFS2_DIR_REC_LEN(1));
+	de->name_len = 2;
+	strcpy(de->name, "..");
+	ocfs2_set_de_type(de, S_IFDIR);
+
+	status = ocfs2_journal_dirty(handle, new_bh);
+	if (status < 0) {
+		mlog_errno(status);
+		goto bail;
+	}
+
+	i_size_write(inode, inode->i_sb->s_blocksize);
+	inode->i_nlink = 2;
+	inode->i_blocks = ocfs2_inode_sector_count(inode);
+	status = ocfs2_mark_inode_dirty(handle, inode, fe_bh);
+	if (status < 0) {
+		mlog_errno(status);
+		goto bail;
+	}
+
+	status = 0;
+bail:
+	if (new_bh)
+		brelse(new_bh);
+
+	mlog_exit(status);
+	return status;
+}
+
 /* returns a bh of the 1st new block in the allocation. */
-int ocfs2_do_extend_dir(struct super_block *sb,
-			handle_t *handle,
-			struct inode *dir,
-			struct buffer_head *parent_fe_bh,
-			struct ocfs2_alloc_context *data_ac,
-			struct ocfs2_alloc_context *meta_ac,
-			struct buffer_head **new_bh)
+static int ocfs2_do_extend_dir(struct super_block *sb,
+			       handle_t *handle,
+			       struct inode *dir,
+			       struct buffer_head *parent_fe_bh,
+			       struct ocfs2_alloc_context *data_ac,
+			       struct ocfs2_alloc_context *meta_ac,
+			       struct buffer_head **new_bh)
 {
 	int status;
 	int extend;
diff --git a/fs/ocfs2/dir.h b/fs/ocfs2/dir.h
index 3f67e14..7bf9c0a 100644
--- a/fs/ocfs2/dir.h
+++ b/fs/ocfs2/dir.h
@@ -26,6 +26,31 @@
 #ifndef OCFS2_DIR_H
 #define OCFS2_DIR_H
 
+struct buffer_head *ocfs2_find_entry(const char *name,
+				     int namelen,
+				     struct inode *dir,
+				     struct ocfs2_dir_entry **res_dir);
+int ocfs2_delete_entry(handle_t *handle,
+		       struct inode *dir,
+		       struct ocfs2_dir_entry *de_del,
+		       struct buffer_head *bh);
+int __ocfs2_add_entry(handle_t *handle,
+		      struct inode *dir,
+		      const char *name, int namelen,
+		      struct inode *inode, u64 blkno,
+		      struct buffer_head *parent_fe_bh,
+		      struct buffer_head *insert_bh);
+static inline int ocfs2_add_entry(handle_t *handle,
+				  struct dentry *dentry,
+				  struct inode *inode, u64 blkno,
+				  struct buffer_head *parent_fe_bh,
+				  struct buffer_head *insert_bh)
+{
+	return __ocfs2_add_entry(handle, dentry->d_parent->d_inode,
+				 dentry->d_name.name, dentry->d_name.len,
+				 inode, blkno, parent_fe_bh, insert_bh);
+}
+
 int ocfs2_check_dir_for_entry(struct inode *dir,
 			      const char *name,
 			      int namelen);
@@ -44,11 +69,16 @@ int ocfs2_prepare_dir_for_insert(struct ocfs2_super *osb,
 				 int namelen,
 				 struct buffer_head **ret_de_bh);
 struct ocfs2_alloc_context;
-int ocfs2_do_extend_dir(struct super_block *sb,
-			handle_t *handle,
-			struct inode *dir,
-			struct buffer_head *parent_fe_bh,
-			struct ocfs2_alloc_context *data_ac,
-			struct ocfs2_alloc_context *meta_ac,
-			struct buffer_head **new_bh);
+int ocfs2_fill_new_dir(struct ocfs2_super *osb,
+		       handle_t *handle,
+		       struct inode *parent,
+		       struct inode *inode,
+		       struct buffer_head *fe_bh,
+		       struct ocfs2_alloc_context *data_ac);
+
+int ocfs2_check_dir_entry(struct inode *dir,
+			  struct ocfs2_dir_entry *de,
+			  struct buffer_head *bh,
+			  unsigned long offset);
+
 #endif /* OCFS2_DIR_H */
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index dbfb20b..8bbfc80 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -35,13 +35,13 @@
 #include "ocfs2.h"
 
 #include "alloc.h"
+#include "dir.h"
 #include "dlmglue.h"
 #include "extent_map.h"
 #include "heartbeat.h"
 #include "inode.h"
 #include "journal.h"
 #include "localalloc.h"
-#include "namei.h"
 #include "slot_map.h"
 #include "super.h"
 #include "vote.h"
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 701e6d0..aae6c0b 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -64,29 +64,6 @@
 
 #include "buffer_head_io.h"
 
-#define NAMEI_RA_CHUNKS  2
-#define NAMEI_RA_BLOCKS  4
-#define NAMEI_RA_SIZE        (NAMEI_RA_CHUNKS * NAMEI_RA_BLOCKS)
-#define NAMEI_RA_INDEX(c,b)  (((c) * NAMEI_RA_BLOCKS) + (b))
-
-static int inline ocfs2_search_dirblock(struct buffer_head *bh,
-					struct inode *dir,
-					const char *name, int namelen,
-					unsigned long offset,
-					struct ocfs2_dir_entry **res_dir);
-
-static int ocfs2_delete_entry(handle_t *handle,
-			      struct inode *dir,
-			      struct ocfs2_dir_entry *de_del,
-			      struct buffer_head *bh);
-
-static int __ocfs2_add_entry(handle_t *handle,
-			     struct inode *dir,
-			     const char *name, int namelen,
-			     struct inode *inode, u64 blkno,
-			     struct buffer_head *parent_fe_bh,
-			     struct buffer_head *insert_bh);
-
 static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 			      struct inode *dir,
 			      struct dentry *dentry, int mode,
@@ -97,13 +74,6 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 			      struct inode **ret_inode,
 			      struct ocfs2_alloc_context *inode_ac);
 
-static int ocfs2_fill_new_dir(struct ocfs2_super *osb,
-			      handle_t *handle,
-			      struct inode *parent,
-			      struct inode *inode,
-			      struct buffer_head *fe_bh,
-			      struct ocfs2_alloc_context *data_ac);
-
 static int ocfs2_prepare_orphan_dir(struct ocfs2_super *osb,
 				    struct inode **ret_orphan_dir,
 				    struct inode *inode,
@@ -123,17 +93,6 @@ static int ocfs2_create_symlink_data(struct ocfs2_super *osb,
 				     struct inode *inode,
 				     const char *symname);
 
-static inline int ocfs2_add_entry(handle_t *handle,
-				  struct dentry *dentry,
-				  struct inode *inode, u64 blkno,
-				  struct buffer_head *parent_fe_bh,
-				  struct buffer_head *insert_bh)
-{
-	return __ocfs2_add_entry(handle, dentry->d_parent->d_inode,
-				 dentry->d_name.name, dentry->d_name.len,
-				 inode, blkno, parent_fe_bh, insert_bh);
-}
-
 /* An orphan dir name is an 8 byte value, printed as a hex string */
 #define OCFS2_ORPHAN_NAMELEN ((int)(2 * sizeof(u64)))
 
@@ -232,75 +191,6 @@ bail:
 	return ret;
 }
 
-static int ocfs2_fill_new_dir(struct ocfs2_super *osb,
-			      handle_t *handle,
-			      struct inode *parent,
-			      struct inode *inode,
-			      struct buffer_head *fe_bh,
-			      struct ocfs2_alloc_context *data_ac)
-{
-	int status;
-	struct buffer_head *new_bh = NULL;
-	struct ocfs2_dir_entry *de = NULL;
-
-	mlog_entry_void();
-
-	status = ocfs2_do_extend_dir(osb->sb, handle, inode, fe_bh,
-				     data_ac, NULL, &new_bh);
-	if (status < 0) {
-		mlog_errno(status);
-		goto bail;
-	}
-
-	ocfs2_set_new_buffer_uptodate(inode, new_bh);
-
-	status = ocfs2_journal_access(handle, inode, new_bh,
-				      OCFS2_JOURNAL_ACCESS_CREATE);
-	if (status < 0) {
-		mlog_errno(status);
-		goto bail;
-	}
-	memset(new_bh->b_data, 0, osb->sb->s_blocksize);
-
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
-
-	status = ocfs2_journal_dirty(handle, new_bh);
-	if (status < 0) {
-		mlog_errno(status);
-		goto bail;
-	}
-
-	i_size_write(inode, inode->i_sb->s_blocksize);
-	inode->i_nlink = 2;
-	inode->i_blocks = ocfs2_inode_sector_count(inode);
-	status = ocfs2_mark_inode_dirty(handle, inode, fe_bh);
-	if (status < 0) {
-		mlog_errno(status);
-		goto bail;
-	}
-
-	status = 0;
-bail:
-	if (new_bh)
-		brelse(new_bh);
-
-	mlog_exit(status);
-	return status;
-}
-
 static int ocfs2_mknod(struct inode *dir,
 		       struct dentry *dentry,
 		       int mode,
@@ -1767,329 +1657,6 @@ bail:
 	return status;
 }
 
-int ocfs2_check_dir_entry(struct inode * dir,
-			  struct ocfs2_dir_entry * de,
-			  struct buffer_head * bh,
-			  unsigned long offset)
-{
-	const char *error_msg = NULL;
-	const int rlen = le16_to_cpu(de->rec_len);
-
-	if (rlen < OCFS2_DIR_REC_LEN(1))
-		error_msg = "rec_len is smaller than minimal";
-	else if (rlen % 4 != 0)
-		error_msg = "rec_len % 4 != 0";
-	else if (rlen < OCFS2_DIR_REC_LEN(de->name_len))
-		error_msg = "rec_len is too small for name_len";
-	else if (((char *) de - bh->b_data) + rlen > dir->i_sb->s_blocksize)
-		error_msg = "directory entry across blocks";
-
-	if (error_msg != NULL)
-		mlog(ML_ERROR, "bad entry in directory #%llu: %s - "
-		     "offset=%lu, inode=%llu, rec_len=%d, name_len=%d\n",
-		     (unsigned long long)OCFS2_I(dir)->ip_blkno, error_msg,
-		     offset, (unsigned long long)le64_to_cpu(de->inode), rlen,
-		     de->name_len);
-	return error_msg == NULL ? 1 : 0;
-}
-
-/* we don't always have a dentry for what we want to add, so people
- * like orphan dir can call this instead.
- *
- * If you pass me insert_bh, I'll skip the search of the other dir
- * blocks and put the record in there.
- */
-static int __ocfs2_add_entry(handle_t *handle,
-			     struct inode *dir,
-			     const char *name, int namelen,
-			     struct inode *inode, u64 blkno,
-			     struct buffer_head *parent_fe_bh,
-			     struct buffer_head *insert_bh)
-{
-	unsigned long offset;
-	unsigned short rec_len;
-	struct ocfs2_dir_entry *de, *de1;
-	struct super_block *sb;
-	int retval, status;
-
-	mlog_entry_void();
-
-	sb = dir->i_sb;
-
-	if (!namelen)
-		return -EINVAL;
-
-	rec_len = OCFS2_DIR_REC_LEN(namelen);
-	offset = 0;
-	de = (struct ocfs2_dir_entry *) insert_bh->b_data;
-	while (1) {
-		BUG_ON((char *)de >= sb->s_blocksize + insert_bh->b_data);
-		/* These checks should've already been passed by the
-		 * prepare function, but I guess we can leave them
-		 * here anyway. */
-		if (!ocfs2_check_dir_entry(dir, de, insert_bh, offset)) {
-			retval = -ENOENT;
-			goto bail;
-		}
-		if (ocfs2_match(namelen, name, de)) {
-			retval = -EEXIST;
-			goto bail;
-		}
-		if (((le64_to_cpu(de->inode) == 0) &&
-		     (le16_to_cpu(de->rec_len) >= rec_len)) ||
-		    (le16_to_cpu(de->rec_len) >=
-		     (OCFS2_DIR_REC_LEN(de->name_len) + rec_len))) {
-			dir->i_mtime = dir->i_ctime = CURRENT_TIME;
-			retval = ocfs2_mark_inode_dirty(handle, dir, parent_fe_bh);
-			if (retval < 0) {
-				mlog_errno(retval);
-				goto bail;
-			}
-
-			status = ocfs2_journal_access(handle, dir, insert_bh,
-						      OCFS2_JOURNAL_ACCESS_WRITE);
-			/* By now the buffer is marked for journaling */
-			offset += le16_to_cpu(de->rec_len);
-			if (le64_to_cpu(de->inode)) {
-				de1 = (struct ocfs2_dir_entry *)((char *) de +
-					OCFS2_DIR_REC_LEN(de->name_len));
-				de1->rec_len =
-					cpu_to_le16(le16_to_cpu(de->rec_len) -
-					OCFS2_DIR_REC_LEN(de->name_len));
-				de->rec_len = cpu_to_le16(OCFS2_DIR_REC_LEN(de->name_len));
-				de = de1;
-			}
-			de->file_type = OCFS2_FT_UNKNOWN;
-			if (blkno) {
-				de->inode = cpu_to_le64(blkno);
-				ocfs2_set_de_type(de, inode->i_mode);
-			} else
-				de->inode = 0;
-			de->name_len = namelen;
-			memcpy(de->name, name, namelen);
-
-			dir->i_version++;
-			status = ocfs2_journal_dirty(handle, insert_bh);
-			retval = 0;
-			goto bail;
-		}
-		offset += le16_to_cpu(de->rec_len);
-		de = (struct ocfs2_dir_entry *) ((char *) de + le16_to_cpu(de->rec_len));
-	}
-
-	/* when you think about it, the assert above should prevent us
-	 * from ever getting here. */
-	retval = -ENOSPC;
-bail:
-
-	mlog_exit(retval);
-	return retval;
-}
-
-
-/*
- * ocfs2_delete_entry deletes a directory entry by merging it with the
- * previous entry
- */
-static int ocfs2_delete_entry(handle_t *handle,
-			      struct inode *dir,
-			      struct ocfs2_dir_entry *de_del,
-			      struct buffer_head *bh)
-{
-	struct ocfs2_dir_entry *de, *pde;
-	int i, status = -ENOENT;
-
-	mlog_entry("(0x%p, 0x%p, 0x%p, 0x%p)\n", handle, dir, de_del, bh);
-
-	i = 0;
-	pde = NULL;
-	de = (struct ocfs2_dir_entry *) bh->b_data;
-	while (i < bh->b_size) {
-		if (!ocfs2_check_dir_entry(dir, de, bh, i)) {
-			status = -EIO;
-			mlog_errno(status);
-			goto bail;
-		}
-		if (de == de_del)  {
-			status = ocfs2_journal_access(handle, dir, bh,
-						      OCFS2_JOURNAL_ACCESS_WRITE);
-			if (status < 0) {
-				status = -EIO;
-				mlog_errno(status);
-				goto bail;
-			}
-			if (pde)
-				pde->rec_len =
-					cpu_to_le16(le16_to_cpu(pde->rec_len) +
-						    le16_to_cpu(de->rec_len));
-			else
-				de->inode = 0;
-			dir->i_version++;
-			status = ocfs2_journal_dirty(handle, bh);
-			goto bail;
-		}
-		i += le16_to_cpu(de->rec_len);
-		pde = de;
-		de = (struct ocfs2_dir_entry *)((char *)de + le16_to_cpu(de->rec_len));
-	}
-bail:
-	mlog_exit(status);
-	return status;
-}
-
-/*
- * Returns 0 if not found, -1 on failure, and 1 on success
- */
-static int inline ocfs2_search_dirblock(struct buffer_head *bh,
-					struct inode *dir,
-					const char *name, int namelen,
-					unsigned long offset,
-					struct ocfs2_dir_entry **res_dir)
-{
-	struct ocfs2_dir_entry *de;
-	char *dlimit, *de_buf;
-	int de_len;
-	int ret = 0;
-
-	mlog_entry_void();
-
-	de_buf = bh->b_data;
-	dlimit = de_buf + dir->i_sb->s_blocksize;
-
-	while (de_buf < dlimit) {
-		/* this code is executed quadratically often */
-		/* do minimal checking `by hand' */
-
-		de = (struct ocfs2_dir_entry *) de_buf;
-
-		if (de_buf + namelen <= dlimit &&
-		    ocfs2_match(namelen, name, de)) {
-			/* found a match - just to be sure, do a full check */
-			if (!ocfs2_check_dir_entry(dir, de, bh, offset)) {
-				ret = -1;
-				goto bail;
-			}
-			*res_dir = de;
-			ret = 1;
-			goto bail;
-		}
-
-		/* prevent looping on a bad block */
-		de_len = le16_to_cpu(de->rec_len);
-		if (de_len <= 0) {
-			ret = -1;
-			goto bail;
-		}
-
-		de_buf += de_len;
-		offset += de_len;
-	}
-
-bail:
-	mlog_exit(ret);
-	return ret;
-}
-
-struct buffer_head *ocfs2_find_entry(const char *name, int namelen,
-				     struct inode *dir,
-				     struct ocfs2_dir_entry **res_dir)
-{
-	struct super_block *sb;
-	struct buffer_head *bh_use[NAMEI_RA_SIZE];
-	struct buffer_head *bh, *ret = NULL;
-	unsigned long start, block, b;
-	int ra_max = 0;		/* Number of bh's in the readahead
-				   buffer, bh_use[] */
-	int ra_ptr = 0;		/* Current index into readahead
-				   buffer */
-	int num = 0;
-	int nblocks, i, err;
-
-	mlog_entry_void();
-
-	*res_dir = NULL;
-	sb = dir->i_sb;
-
-	nblocks = i_size_read(dir) >> sb->s_blocksize_bits;
-	start = OCFS2_I(dir)->ip_dir_start_lookup;
-	if (start >= nblocks)
-		start = 0;
-	block = start;
-
-restart:
-	do {
-		/*
-		 * We deal with the read-ahead logic here.
-		 */
-		if (ra_ptr >= ra_max) {
-			/* Refill the readahead buffer */
-			ra_ptr = 0;
-			b = block;
-			for (ra_max = 0; ra_max < NAMEI_RA_SIZE; ra_max++) {
-				/*
-				 * Terminate if we reach the end of the
-				 * directory and must wrap, or if our
-				 * search has finished@this block.
-				 */
-				if (b >= nblocks || (num && block == start)) {
-					bh_use[ra_max] = NULL;
-					break;
-				}
-				num++;
-
-				bh = ocfs2_bread(dir, b++, &err, 1);
-				bh_use[ra_max] = bh;
-			}
-		}
-		if ((bh = bh_use[ra_ptr++]) == NULL)
-			goto next;
-		wait_on_buffer(bh);
-		if (!buffer_uptodate(bh)) {
-			/* read error, skip block & hope for the best */
-			ocfs2_error(dir->i_sb, "reading directory %llu, "
-				    "offset %lu\n",
-				    (unsigned long long)OCFS2_I(dir)->ip_blkno,
-				    block);
-			brelse(bh);
-			goto next;
-		}
-		i = ocfs2_search_dirblock(bh, dir, name, namelen,
-					  block << sb->s_blocksize_bits,
-					  res_dir);
-		if (i == 1) {
-			OCFS2_I(dir)->ip_dir_start_lookup = block;
-			ret = bh;
-			goto cleanup_and_exit;
-		} else {
-			brelse(bh);
-			if (i < 0)
-				goto cleanup_and_exit;
-		}
-	next:
-		if (++block >= nblocks)
-			block = 0;
-	} while (block != start);
-
-	/*
-	 * If the directory has grown while we were searching, then
-	 * search the last part of the directory before giving up.
-	 */
-	block = nblocks;
-	nblocks = i_size_read(dir) >> sb->s_blocksize_bits;
-	if (block < nblocks) {
-		start = 0;
-		goto restart;
-	}
-
-cleanup_and_exit:
-	/* Clean up the read-ahead blocks */
-	for (; ra_ptr < ra_max; ra_ptr++)
-		brelse(bh_use[ra_ptr]);
-
-	mlog_exit_ptr(ret);
-	return ret;
-}
-
 static int ocfs2_blkno_stringify(u64 blkno, char *name)
 {
 	int status, namelen;
diff --git a/fs/ocfs2/namei.h b/fs/ocfs2/namei.h
index 0975c7b..688aef6 100644
--- a/fs/ocfs2/namei.h
+++ b/fs/ocfs2/namei.h
@@ -30,29 +30,10 @@ extern const struct inode_operations ocfs2_dir_iops;
 
 struct dentry *ocfs2_get_parent(struct dentry *child);
 
-int ocfs2_check_dir_entry (struct inode *dir,
-			   struct ocfs2_dir_entry *de,
-			   struct buffer_head *bh,
-			   unsigned long offset);
-struct buffer_head *ocfs2_find_entry(const char *name,
-				     int namelen,
-				     struct inode *dir,
-				     struct ocfs2_dir_entry **res_dir);
 int ocfs2_orphan_del(struct ocfs2_super *osb,
 		     handle_t *handle,
 		     struct inode *orphan_dir_inode,
 		     struct inode *inode,
 		     struct buffer_head *orphan_dir_bh);
 
-static inline int ocfs2_match(int len,
-			      const char * const name,
-			      struct ocfs2_dir_entry *de)
-{
-	if (len != de->name_len)
-		return 0;
-	if (!de->inode)
-		return 0;
-	return !memcmp(name, de->name, len);
-}
-
 #endif /* OCFS2_NAMEI_H */
-- 
1.5.0.6
