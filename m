From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 10 Nov 2008 09:55:32 -0800
Subject: [Ocfs2-devel] [resend][git patches] Ocfs2 fixes
Message-ID: <20081110175532.GP15154@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Andrew Morton <akpm@linux-foundation.org>

Hey Linus,

	I sent this last week, but nothing was pulled... Original message
follows. The only change is that I rebased the patches onto 2.6.28-rc4 to
ease merging.
	--Mark


More fixes than usual - that's my fault for missing an update that should
have happened last week. These are all fixes or trivial cleanups though. The
xattr ones are a bit large-ish, but it's a new feature which is getting
banged on a ton so that's to be expected.

Thanks,
	--Mark

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/ocfs2/file.c     |   27 +++--
 fs/ocfs2/inode.c    |    6 +
 fs/ocfs2/journal.c  |    1 +
 fs/ocfs2/mmap.c     |    6 +-
 fs/ocfs2/namei.c    |    8 +-
 fs/ocfs2/ocfs2.h    |    3 +
 fs/ocfs2/ocfs2_fs.h |   17 ++-
 fs/ocfs2/xattr.c    |  372 ++++++++++++++++++++++++++++-----------------------
 fs/ocfs2/xattr.h    |   38 +-----
 9 files changed, 256 insertions(+), 222 deletions(-)

Dmitri Monakhov (1):
      ocfs2: truncate outstanding block after direct io failure

Jan Kara (3):
      ocfs2: Fix check of return value of ocfs2_start_trans()
      ocfs2: Fix checking of return value of new_inode()
      ocfs2: Let inode be really deleted when ocfs2_mknod_locked() fails

Joel Becker (5):
      ocfs2: Check xattr block signatures properly.
      ocfs2: Don't return -EFAULT from a corrupt xattr entry.
      ocfs2: Check errors from ocfs2_xattr_update_xattr_search()
      ocfs2: Specify appropriate journal access for new xattr buckets.
      ocfs2: Don't repeat ocfs2_xattr_block_find()

Mark Fasheh (1):
      ocfs2: fix printk related build warnings in xattr.c

Sunil Mushran (1):
      ocfs2: Set journal descriptor to NULL after journal shutdown

Tao Ma (5):
      ocfs2: Remove unused ocfs2_restore_xattr_block().
      ocfs2: Fix some typos in xattr annotations.
      ocfs2: Fix check of return value of ocfs2_start_trans() in xattr.c.
      ocfs2: return 0 in page_mkwrite to let VFS retry.
      ocfs2/xattr: Proper hash collision handle in bucket division

Tiger Yang (5):
      ocfs2: fix license in xattr
      ocfs2: fix function declaration and definition in xattr
      ocfs2: remove duplicate definition in xattr
      ocfs2: add handler_map array bounds checking
      ocfs2: Check search result in ocfs2_xattr_block_get()

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 7efe937..e2570a3 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -247,8 +247,8 @@ int ocfs2_update_inode_atime(struct inode *inode,
 	mlog_entry_void();
 
 	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
-	if (handle == NULL) {
-		ret = -ENOMEM;
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
 		mlog_errno(ret);
 		goto out;
 	}
@@ -312,8 +312,8 @@ static int ocfs2_simple_size_update(struct inode *inode,
 	handle_t *handle = NULL;
 
 	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
-	if (handle == NULL) {
-		ret = -ENOMEM;
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
 		mlog_errno(ret);
 		goto out;
 	}
@@ -1055,8 +1055,8 @@ static int __ocfs2_write_remove_suid(struct inode *inode,
 		   (unsigned long long)OCFS2_I(inode)->ip_blkno, inode->i_mode);
 
 	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
-	if (handle == NULL) {
-		ret = -ENOMEM;
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
 		mlog_errno(ret);
 		goto out;
 	}
@@ -1259,8 +1259,8 @@ static int __ocfs2_remove_inode_range(struct inode *inode,
 	}
 
 	handle = ocfs2_start_trans(osb, OCFS2_REMOVE_EXTENT_CREDITS);
-	if (handle == NULL) {
-		ret = -ENOMEM;
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
 		mlog_errno(ret);
 		goto out;
 	}
@@ -1352,8 +1352,8 @@ static int ocfs2_zero_partial_clusters(struct inode *inode,
 		goto out;
 
 	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
-	if (handle == NULL) {
-		ret = -ENOMEM;
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
 		mlog_errno(ret);
 		goto out;
 	}
@@ -1866,6 +1866,13 @@ relock:
 		written = generic_file_direct_write(iocb, iov, &nr_segs, *ppos,
 						    ppos, count, ocount);
 		if (written < 0) {
+			/*
+			 * direct write may have instantiated a few
+			 * blocks outside i_size. Trim these off again.
+			 * Don't need i_size_read because we hold i_mutex.
+			 */
+			if (*ppos + count > inode->i_size)
+				vmtruncate(inode, inode->i_size);
 			ret = written;
 			goto out_dio;
 		}
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 4903688..7aa00d5 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1106,6 +1106,12 @@ void ocfs2_clear_inode(struct inode *inode)
 	oi->ip_last_trans = 0;
 	oi->ip_dir_start_lookup = 0;
 	oi->ip_blkno = 0ULL;
+
+	/*
+	 * ip_jinode is used to track txns against this inode. We ensure that
+	 * the journal is flushed before journal shutdown. Thus it is safe to
+	 * have inodes get cleaned up after journal shutdown.
+	 */
 	jbd2_journal_release_jbd_inode(OCFS2_SB(inode->i_sb)->journal->j_journal,
 				       &oi->ip_jinode);
 
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 81e4067..99fe9d5 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -690,6 +690,7 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
 
 	/* Shutdown the kernel journal system */
 	jbd2_journal_destroy(journal->j_journal);
+	journal->j_journal = NULL;
 
 	OCFS2_I(inode)->ip_open_count--;
 
diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
index 3dc18d6..eea1d24 100644
--- a/fs/ocfs2/mmap.c
+++ b/fs/ocfs2/mmap.c
@@ -113,7 +113,11 @@ static int __ocfs2_page_mkwrite(struct inode *inode, struct buffer_head *di_bh,
 	 * ocfs2_write_begin_nolock().
 	 */
 	if (!PageUptodate(page) || page->mapping != inode->i_mapping) {
-		ret = -EINVAL;
+		/*
+		 * the page has been umapped in ocfs2_data_downconvert_worker.
+		 * So return 0 here and let VFS retry.
+		 */
+		ret = 0;
 		goto out;
 	}
 
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 485a6aa..f4967e6 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -378,8 +378,8 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 	}
 
 	inode = new_inode(dir->i_sb);
-	if (IS_ERR(inode)) {
-		status = PTR_ERR(inode);
+	if (!inode) {
+		status = -ENOMEM;
 		mlog(ML_ERROR, "new_inode failed!\n");
 		goto leave;
 	}
@@ -491,8 +491,10 @@ leave:
 			brelse(*new_fe_bh);
 			*new_fe_bh = NULL;
 		}
-		if (inode)
+		if (inode) {
+			clear_nlink(inode);
 			iput(inode);
+		}
 	}
 
 	mlog_exit(status);
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index a21a465..fef7ece 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -473,6 +473,9 @@ static inline int ocfs2_uses_extended_slot_map(struct ocfs2_super *osb)
 		(____gd)->bg_signature);				\
 } while (0)
 
+#define OCFS2_IS_VALID_XATTR_BLOCK(ptr)					\
+	(!strcmp((ptr)->xb_signature, OCFS2_XATTR_BLOCK_SIGNATURE))
+
 static inline unsigned long ino_from_blkno(struct super_block *sb,
 					   u64 blkno)
 {
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index f24ce3d..5f180cf 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -742,12 +742,12 @@ struct ocfs2_group_desc
  */
 struct ocfs2_xattr_entry {
 	__le32	xe_name_hash;    /* hash value of xattr prefix+suffix. */
-	__le16	xe_name_offset;  /* byte offset from the 1st etnry in the local
+	__le16	xe_name_offset;  /* byte offset from the 1st entry in the
 				    local xattr storage(inode, xattr block or
 				    xattr bucket). */
 	__u8	xe_name_len;	 /* xattr name len, does't include prefix. */
-	__u8	xe_type;         /* the low 7 bits indicates the name prefix's
-				  * type and the highest 1 bits indicate whether
+	__u8	xe_type;         /* the low 7 bits indicate the name prefix
+				  * type and the highest bit indicates whether
 				  * the EA is stored in the local storage. */
 	__le64	xe_value_size;	 /* real xattr value length. */
 };
@@ -766,9 +766,10 @@ struct ocfs2_xattr_header {
 						   xattr. */
 	__le16	xh_name_value_len;              /* total length of name/value
 						   length in this bucket. */
-	__le16	xh_num_buckets;                 /* bucket nums in one extent
-						   record, only valid in the
-						   first bucket. */
+	__le16	xh_num_buckets;                 /* Number of xattr buckets
+						   in this extent record,
+						   only valid in the first
+						   bucket. */
 	__le64  xh_csum;
 	struct ocfs2_xattr_entry xh_entries[0]; /* xattr entry list. */
 };
@@ -776,8 +777,8 @@ struct ocfs2_xattr_header {
 /*
  * On disk structure for xattr value root.
  *
- * It is used when one extended attribute's size is larger, and we will save it
- * in an outside cluster. It will stored in a b-tree like file content.
+ * When an xattr's value is large enough, it is stored in an external
+ * b-tree like file data.  The xattr value root points to this structure.
  */
 struct ocfs2_xattr_value_root {
 /*00*/	__le32	xr_clusters;              /* clusters covered by xattr value. */
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 802c414..054e2ef 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -3,25 +3,20 @@
  *
  * xattr.c
  *
- * Copyright (C) 2008 Oracle.  All rights reserved.
+ * Copyright (C) 2004, 2008 Oracle.  All rights reserved.
  *
  * CREDITS:
- * Lots of code in this file is taken from ext3.
+ * Lots of code in this file is copy from linux/fs/ext3/xattr.c.
+ * Copyright (C) 2001-2003 Andreas Gruenbacher, <agruen@suse.de>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public
- * License as published by the Free Software Foundation; either
- * version 2 of the License, or (at your option) any later version.
+ * License version 2 as published by the Free Software Foundation.
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
  */
 
 #include <linux/capability.h>
@@ -83,7 +78,7 @@ struct xattr_handler *ocfs2_xattr_handlers[] = {
 	NULL
 };
 
-static struct xattr_handler *ocfs2_xattr_handler_map[] = {
+static struct xattr_handler *ocfs2_xattr_handler_map[OCFS2_XATTR_MAX] = {
 	[OCFS2_XATTR_INDEX_USER]	= &ocfs2_xattr_user_handler,
 	[OCFS2_XATTR_INDEX_TRUSTED]	= &ocfs2_xattr_trusted_handler,
 };
@@ -116,6 +111,10 @@ static int ocfs2_xattr_bucket_get_name_value(struct inode *inode,
 					     int *block_off,
 					     int *new_offset);
 
+static int ocfs2_xattr_block_find(struct inode *inode,
+				  int name_index,
+				  const char *name,
+				  struct ocfs2_xattr_search *xs);
 static int ocfs2_xattr_index_block_find(struct inode *inode,
 					struct buffer_head *root_bh,
 					int name_index,
@@ -137,6 +136,24 @@ static int ocfs2_xattr_set_entry_index_block(struct inode *inode,
 static int ocfs2_delete_xattr_index_block(struct inode *inode,
 					  struct buffer_head *xb_bh);
 
+static inline u16 ocfs2_xattr_buckets_per_cluster(struct ocfs2_super *osb)
+{
+	return (1 << osb->s_clustersize_bits) / OCFS2_XATTR_BUCKET_SIZE;
+}
+
+static inline u16 ocfs2_blocks_per_xattr_bucket(struct super_block *sb)
+{
+	return OCFS2_XATTR_BUCKET_SIZE / (1 << sb->s_blocksize_bits);
+}
+
+static inline u16 ocfs2_xattr_max_xe_in_bucket(struct super_block *sb)
+{
+	u16 len = sb->s_blocksize -
+		 offsetof(struct ocfs2_xattr_header, xh_entries);
+
+	return len / sizeof(struct ocfs2_xattr_entry);
+}
+
 static inline const char *ocfs2_xattr_prefix(int name_index)
 {
 	struct xattr_handler *handler = NULL;
@@ -542,14 +559,12 @@ static int ocfs2_xattr_block_list(struct inode *inode,
 		mlog_errno(ret);
 		return ret;
 	}
-	/*Verify the signature of xattr block*/
-	if (memcmp((void *)blk_bh->b_data, OCFS2_XATTR_BLOCK_SIGNATURE,
-		   strlen(OCFS2_XATTR_BLOCK_SIGNATURE))) {
-		ret = -EFAULT;
-		goto cleanup;
-	}
 
 	xb = (struct ocfs2_xattr_block *)blk_bh->b_data;
+	if (!OCFS2_IS_VALID_XATTR_BLOCK(xb)) {
+		ret = -EIO;
+		goto cleanup;
+	}
 
 	if (!(le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED)) {
 		struct ocfs2_xattr_header *header = &xb->xb_attrs.xb_header;
@@ -749,47 +764,25 @@ static int ocfs2_xattr_block_get(struct inode *inode,
 				 size_t buffer_size,
 				 struct ocfs2_xattr_search *xs)
 {
-	struct ocfs2_dinode *di = (struct ocfs2_dinode *)xs->inode_bh->b_data;
-	struct buffer_head *blk_bh = NULL;
 	struct ocfs2_xattr_block *xb;
 	struct ocfs2_xattr_value_root *xv;
 	size_t size;
 	int ret = -ENODATA, name_offset, name_len, block_off, i;
 
-	if (!di->i_xattr_loc)
-		return ret;
-
 	memset(&xs->bucket, 0, sizeof(xs->bucket));
 
-	ret = ocfs2_read_block(inode, le64_to_cpu(di->i_xattr_loc), &blk_bh);
-	if (ret < 0) {
+	ret = ocfs2_xattr_block_find(inode, name_index, name, xs);
+	if (ret) {
 		mlog_errno(ret);
-		return ret;
-	}
-	/*Verify the signature of xattr block*/
-	if (memcmp((void *)blk_bh->b_data, OCFS2_XATTR_BLOCK_SIGNATURE,
-		   strlen(OCFS2_XATTR_BLOCK_SIGNATURE))) {
-		ret = -EFAULT;
 		goto cleanup;
 	}
 
-	xs->xattr_bh = blk_bh;
-	xb = (struct ocfs2_xattr_block *)blk_bh->b_data;
-
-	if (!(le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED)) {
-		xs->header = &xb->xb_attrs.xb_header;
-		xs->base = (void *)xs->header;
-		xs->end = (void *)(blk_bh->b_data) + blk_bh->b_size;
-		xs->here = xs->header->xh_entries;
-
-		ret = ocfs2_xattr_find_entry(name_index, name, xs);
-	} else
-		ret = ocfs2_xattr_index_block_find(inode, blk_bh,
-						   name_index,
-						   name, xs);
-
-	if (ret)
+	if (xs->not_found) {
+		ret = -ENODATA;
 		goto cleanup;
+	}
+
+	xb = (struct ocfs2_xattr_block *)xs->xattr_bh->b_data;
 	size = le64_to_cpu(xs->here->xe_value_size);
 	if (buffer) {
 		ret = -ERANGE;
@@ -828,7 +821,8 @@ cleanup:
 		brelse(xs->bucket.bhs[i]);
 	memset(&xs->bucket, 0, sizeof(xs->bucket));
 
-	brelse(blk_bh);
+	brelse(xs->xattr_bh);
+	xs->xattr_bh = NULL;
 	return ret;
 }
 
@@ -837,11 +831,11 @@ cleanup:
  * Copy an extended attribute into the buffer provided.
  * Buffer is NULL to compute the size of buffer required.
  */
-int ocfs2_xattr_get(struct inode *inode,
-		    int name_index,
-		    const char *name,
-		    void *buffer,
-		    size_t buffer_size)
+static int ocfs2_xattr_get(struct inode *inode,
+			   int name_index,
+			   const char *name,
+			   void *buffer,
+			   size_t buffer_size)
 {
 	int ret;
 	struct ocfs2_dinode *di = NULL;
@@ -871,7 +865,7 @@ int ocfs2_xattr_get(struct inode *inode,
 	down_read(&oi->ip_xattr_sem);
 	ret = ocfs2_xattr_ibody_get(inode, name_index, name, buffer,
 				    buffer_size, &xis);
-	if (ret == -ENODATA)
+	if (ret == -ENODATA && di->i_xattr_loc)
 		ret = ocfs2_xattr_block_get(inode, name_index, name, buffer,
 					    buffer_size, &xbs);
 	up_read(&oi->ip_xattr_sem);
@@ -1229,7 +1223,7 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 
 	free = min_offs - ((void *)last - xs->base) - sizeof(__u32);
 	if (free < 0)
-		return -EFAULT;
+		return -EIO;
 
 	if (!xs->not_found) {
 		size_t size = 0;
@@ -1514,10 +1508,9 @@ static int ocfs2_xattr_free_block(struct inode *inode,
 		goto out;
 	}
 
-	/*Verify the signature of xattr block*/
-	if (memcmp((void *)blk_bh->b_data, OCFS2_XATTR_BLOCK_SIGNATURE,
-		   strlen(OCFS2_XATTR_BLOCK_SIGNATURE))) {
-		ret = -EFAULT;
+	xb = (struct ocfs2_xattr_block *)blk_bh->b_data;
+	if (!OCFS2_IS_VALID_XATTR_BLOCK(xb)) {
+		ret = -EIO;
 		goto out;
 	}
 
@@ -1527,7 +1520,6 @@ static int ocfs2_xattr_free_block(struct inode *inode,
 		goto out;
 	}
 
-	xb = (struct ocfs2_xattr_block *)blk_bh->b_data;
 	blk = le64_to_cpu(xb->xb_blkno);
 	bit = le16_to_cpu(xb->xb_suballoc_bit);
 	bg_blkno = ocfs2_which_suballoc_group(blk, bit);
@@ -1771,15 +1763,14 @@ static int ocfs2_xattr_block_find(struct inode *inode,
 		mlog_errno(ret);
 		return ret;
 	}
-	/*Verify the signature of xattr block*/
-	if (memcmp((void *)blk_bh->b_data, OCFS2_XATTR_BLOCK_SIGNATURE,
-		   strlen(OCFS2_XATTR_BLOCK_SIGNATURE))) {
-			ret = -EFAULT;
-			goto cleanup;
+
+	xb = (struct ocfs2_xattr_block *)blk_bh->b_data;
+	if (!OCFS2_IS_VALID_XATTR_BLOCK(xb)) {
+		ret = -EIO;
+		goto cleanup;
 	}
 
 	xs->xattr_bh = blk_bh;
-	xb = (struct ocfs2_xattr_block *)blk_bh->b_data;
 
 	if (!(le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED)) {
 		xs->header = &xb->xb_attrs.xb_header;
@@ -1806,52 +1797,6 @@ cleanup:
 }
 
 /*
- * When all the xattrs are deleted from index btree, the ocfs2_xattr_tree
- * will be erased and ocfs2_xattr_block will have its ocfs2_xattr_header
- * re-initialized.
- */
-static int ocfs2_restore_xattr_block(struct inode *inode,
-				     struct ocfs2_xattr_search *xs)
-{
-	int ret;
-	handle_t *handle;
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	struct ocfs2_xattr_block *xb =
-		(struct ocfs2_xattr_block *)xs->xattr_bh->b_data;
-	struct ocfs2_extent_list *el = &xb->xb_attrs.xb_root.xt_list;
-	u16 xb_flags = le16_to_cpu(xb->xb_flags);
-
-	BUG_ON(!(xb_flags & OCFS2_XATTR_INDEXED) ||
-		le16_to_cpu(el->l_next_free_rec) != 0);
-
-	handle = ocfs2_start_trans(osb, OCFS2_XATTR_BLOCK_UPDATE_CREDITS);
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		handle = NULL;
-		goto out;
-	}
-
-	ret = ocfs2_journal_access(handle, inode, xs->xattr_bh,
-				   OCFS2_JOURNAL_ACCESS_WRITE);
-	if (ret < 0) {
-		mlog_errno(ret);
-		goto out_commit;
-	}
-
-	memset(&xb->xb_attrs, 0, inode->i_sb->s_blocksize -
-	       offsetof(struct ocfs2_xattr_block, xb_attrs));
-
-	xb->xb_flags = cpu_to_le16(xb_flags & ~OCFS2_XATTR_INDEXED);
-
-	ocfs2_journal_dirty(handle, xs->xattr_bh);
-
-out_commit:
-	ocfs2_commit_trans(osb, handle);
-out:
-	return ret;
-}
-
-/*
  * ocfs2_xattr_block_set()
  *
  * Set, replace or remove an extended attribute into external block.
@@ -1961,8 +1906,6 @@ out:
 	}
 
 	ret = ocfs2_xattr_set_entry_index_block(inode, xi, xs);
-	if (!ret && xblk->xb_attrs.xb_root.xt_list.l_next_free_rec == 0)
-		ret = ocfs2_restore_xattr_block(inode, xs);
 
 end:
 
@@ -2398,7 +2341,8 @@ static int ocfs2_xattr_index_block_find(struct inode *inode,
 	BUG_ON(p_blkno == 0 || num_clusters == 0 || first_hash > name_hash);
 
 	mlog(0, "find xattr extent rec %u clusters from %llu, the first hash "
-	     "in the rec is %u\n", num_clusters, p_blkno, first_hash);
+	     "in the rec is %u\n", num_clusters, (unsigned long long)p_blkno,
+	     first_hash);
 
 	ret = ocfs2_xattr_bucket_find(inode, name_index, name, name_hash,
 				      p_blkno, first_hash, num_clusters, xs);
@@ -2422,7 +2366,7 @@ static int ocfs2_iterate_xattr_buckets(struct inode *inode,
 	memset(&bucket, 0, sizeof(bucket));
 
 	mlog(0, "iterating xattr buckets in %u clusters starting from %llu\n",
-	     clusters, blkno);
+	     clusters, (unsigned long long)blkno);
 
 	for (i = 0; i < num_buckets; i++, blkno += blk_per_bucket) {
 		ret = ocfs2_read_blocks(inode, blkno, blk_per_bucket,
@@ -2440,7 +2384,8 @@ static int ocfs2_iterate_xattr_buckets(struct inode *inode,
 		if (i == 0)
 			num_buckets = le16_to_cpu(bucket.xh->xh_num_buckets);
 
-		mlog(0, "iterating xattr bucket %llu, first hash %u\n", blkno,
+		mlog(0, "iterating xattr bucket %llu, first hash %u\n",
+		     (unsigned long long)blkno,
 		     le32_to_cpu(bucket.xh->xh_entries[0].xe_name_hash));
 		if (func) {
 			ret = func(inode, &bucket, para);
@@ -2776,7 +2721,8 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
 	 */
 	blkno = ocfs2_clusters_to_blocks(inode->i_sb, bit_off);
 
-	mlog(0, "allocate 1 cluster from %llu to xattr block\n", blkno);
+	mlog(0, "allocate 1 cluster from %llu to xattr block\n",
+	     (unsigned long long)blkno);
 
 	xh_bh = sb_getblk(inode->i_sb, blkno);
 	if (!xh_bh) {
@@ -2818,7 +2764,11 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
 	if (data_bh)
 		ocfs2_journal_dirty(handle, data_bh);
 
-	ocfs2_xattr_update_xattr_search(inode, xs, xb_bh, xh_bh);
+	ret = ocfs2_xattr_update_xattr_search(inode, xs, xb_bh, xh_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
 
 	/* Change from ocfs2_xattr_header to ocfs2_xattr_tree_root */
 	memset(&xb->xb_attrs, 0, inode->i_sb->s_blocksize -
@@ -2941,8 +2891,8 @@ static int ocfs2_defrag_xattr_bucket(struct inode *inode,
 
 	mlog(0, "adjust xattr bucket in %llu, count = %u, "
 	     "xh_free_start = %u, xh_name_value_len = %u.\n",
-	     blkno, le16_to_cpu(xh->xh_count), xh_free_start,
-	     le16_to_cpu(xh->xh_name_value_len));
+	     (unsigned long long)blkno, le16_to_cpu(xh->xh_count),
+	     xh_free_start, le16_to_cpu(xh->xh_name_value_len));
 
 	/*
 	 * sort all the entries by their offset.
@@ -3058,7 +3008,7 @@ static int ocfs2_mv_xattr_bucket_cross_cluster(struct inode *inode,
 	prev_blkno += (num_clusters - 1) * bpc + bpc / 2;
 
 	mlog(0, "move half of xattrs in cluster %llu to %llu\n",
-	     prev_blkno, new_blkno);
+	     (unsigned long long)prev_blkno, (unsigned long long)new_blkno);
 
 	/*
 	 * We need to update the 1st half of the new cluster and
@@ -3168,26 +3118,74 @@ static int ocfs2_read_xattr_bucket(struct inode *inode,
 }
 
 /*
- * Move half num of the xattrs in old bucket(blk) to new bucket(new_blk).
+ * Find the suitable pos when we divide a bucket into 2.
+ * We have to make sure the xattrs with the same hash value exist
+ * in the same bucket.
+ *
+ * If this ocfs2_xattr_header covers more than one hash value, find a
+ * place where the hash value changes.  Try to find the most even split.
+ * The most common case is that all entries have different hash values,
+ * and the first check we make will find a place to split.
+ */
+static int ocfs2_xattr_find_divide_pos(struct ocfs2_xattr_header *xh)
+{
+	struct ocfs2_xattr_entry *entries = xh->xh_entries;
+	int count = le16_to_cpu(xh->xh_count);
+	int delta, middle = count / 2;
+
+	/*
+	 * We start at the middle.  Each step gets farther away in both
+	 * directions.  We therefore hit the change in hash value
+	 * nearest to the middle.  Note that this loop does not execute for
+	 * count < 2.
+	 */
+	for (delta = 0; delta < middle; delta++) {
+		/* Let's check delta earlier than middle */
+		if (cmp_xe(&entries[middle - delta - 1],
+			   &entries[middle - delta]))
+			return middle - delta;
+
+		/* For even counts, don't walk off the end */
+		if ((middle + delta + 1) == count)
+			continue;
+
+		/* Now try delta past middle */
+		if (cmp_xe(&entries[middle + delta],
+			   &entries[middle + delta + 1]))
+			return middle + delta + 1;
+	}
+
+	/* Every entry had the same hash */
+	return count;
+}
+
+/*
+ * Move some xattrs in old bucket(blk) to new bucket(new_blk).
  * first_hash will record the 1st hash of the new bucket.
+ *
+ * Normally half of the xattrs will be moved.  But we have to make
+ * sure that the xattrs with the same hash value are stored in the
+ * same bucket. If all the xattrs in this bucket have the same hash
+ * value, the new bucket will be initialized as an empty one and the
+ * first_hash will be initialized as (hash_value+1).
  */
-static int ocfs2_half_xattr_bucket(struct inode *inode,
-				   handle_t *handle,
-				   u64 blk,
-				   u64 new_blk,
-				   u32 *first_hash,
-				   int new_bucket_head)
+static int ocfs2_divide_xattr_bucket(struct inode *inode,
+				    handle_t *handle,
+				    u64 blk,
+				    u64 new_blk,
+				    u32 *first_hash,
+				    int new_bucket_head)
 {
 	int ret, i;
-	u16 count, start, len, name_value_len, xe_len, name_offset;
+	int count, start, len, name_value_len = 0, xe_len, name_offset = 0;
 	u16 blk_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
 	struct buffer_head **s_bhs, **t_bhs = NULL;
 	struct ocfs2_xattr_header *xh;
 	struct ocfs2_xattr_entry *xe;
 	int blocksize = inode->i_sb->s_blocksize;
 
-	mlog(0, "move half of xattrs from bucket %llu to %llu\n",
-	     blk, new_blk);
+	mlog(0, "move some of xattrs from bucket %llu to %llu\n",
+	     (unsigned long long)blk, (unsigned long long)new_blk);
 
 	s_bhs = kcalloc(blk_per_bucket, sizeof(struct buffer_head *), GFP_NOFS);
 	if (!s_bhs)
@@ -3220,21 +3218,44 @@ static int ocfs2_half_xattr_bucket(struct inode *inode,
 
 	for (i = 0; i < blk_per_bucket; i++) {
 		ret = ocfs2_journal_access(handle, inode, t_bhs[i],
-					   OCFS2_JOURNAL_ACCESS_CREATE);
+					   new_bucket_head ?
+					   OCFS2_JOURNAL_ACCESS_CREATE :
+					   OCFS2_JOURNAL_ACCESS_WRITE);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
 		}
 	}
 
+	xh = (struct ocfs2_xattr_header *)s_bhs[0]->b_data;
+	count = le16_to_cpu(xh->xh_count);
+	start = ocfs2_xattr_find_divide_pos(xh);
+
+	if (start == count) {
+		xe = &xh->xh_entries[start-1];
+
+		/*
+		 * initialized a new empty bucket here.
+		 * The hash value is set as one larger than
+		 * that of the last entry in the previous bucket.
+		 */
+		for (i = 0; i < blk_per_bucket; i++)
+			memset(t_bhs[i]->b_data, 0, blocksize);
+
+		xh = (struct ocfs2_xattr_header *)t_bhs[0]->b_data;
+		xh->xh_free_start = cpu_to_le16(blocksize);
+		xh->xh_entries[0].xe_name_hash = xe->xe_name_hash;
+		le32_add_cpu(&xh->xh_entries[0].xe_name_hash, 1);
+
+		goto set_num_buckets;
+	}
+
 	/* copy the whole bucket to the new first. */
 	for (i = 0; i < blk_per_bucket; i++)
 		memcpy(t_bhs[i]->b_data, s_bhs[i]->b_data, blocksize);
 
 	/* update the new bucket. */
 	xh = (struct ocfs2_xattr_header *)t_bhs[0]->b_data;
-	count = le16_to_cpu(xh->xh_count);
-	start = count / 2;
 
 	/*
 	 * Calculate the total name/value len and xh_free_start for
@@ -3291,6 +3312,7 @@ static int ocfs2_half_xattr_bucket(struct inode *inode,
 			xh->xh_free_start = xe->xe_name_offset;
 	}
 
+set_num_buckets:
 	/* set xh->xh_num_buckets for the new xh. */
 	if (new_bucket_head)
 		xh->xh_num_buckets = cpu_to_le16(1);
@@ -3308,9 +3330,13 @@ static int ocfs2_half_xattr_bucket(struct inode *inode,
 		*first_hash = le32_to_cpu(xh->xh_entries[0].xe_name_hash);
 
 	/*
-	 * Now only update the 1st block of the old bucket.
-	 * Please note that the entry has been sorted already above.
+	 * Now only update the 1st block of the old bucket.  If we
+	 * just added a new empty bucket, there is no need to modify
+	 * it.
 	 */
+	if (start == count)
+		goto out;
+
 	xh = (struct ocfs2_xattr_header *)s_bhs[0]->b_data;
 	memset(&xh->xh_entries[start], 0,
 	       sizeof(struct ocfs2_xattr_entry) * (count - start));
@@ -3358,7 +3384,8 @@ static int ocfs2_cp_xattr_bucket(struct inode *inode,
 	BUG_ON(s_blkno == t_blkno);
 
 	mlog(0, "cp bucket %llu to %llu, target is %d\n",
-	     s_blkno, t_blkno, t_is_new);
+	     (unsigned long long)s_blkno, (unsigned long long)t_blkno,
+	     t_is_new);
 
 	s_bhs = kzalloc(sizeof(struct buffer_head *) * blk_per_bucket,
 			GFP_NOFS);
@@ -3382,6 +3409,8 @@ static int ocfs2_cp_xattr_bucket(struct inode *inode,
 
 	for (i = 0; i < blk_per_bucket; i++) {
 		ret = ocfs2_journal_access(handle, inode, t_bhs[i],
+					   t_is_new ?
+					   OCFS2_JOURNAL_ACCESS_CREATE :
 					   OCFS2_JOURNAL_ACCESS_WRITE);
 		if (ret)
 			goto out;
@@ -3428,7 +3457,8 @@ static int ocfs2_cp_xattr_cluster(struct inode *inode,
 	struct ocfs2_xattr_header *xh;
 	u64 to_blk_start = to_blk;
 
-	mlog(0, "cp xattrs from cluster %llu to %llu\n", src_blk, to_blk);
+	mlog(0, "cp xattrs from cluster %llu to %llu\n",
+	     (unsigned long long)src_blk, (unsigned long long)to_blk);
 
 	/*
 	 * We need to update the new cluster and 1 more for the update of
@@ -3493,15 +3523,15 @@ out:
 }
 
 /*
- * Move half of the xattrs in this cluster to the new cluster.
+ * Move some xattrs in this cluster to the new cluster.
  * This function should only be called when bucket size == cluster size.
  * Otherwise ocfs2_mv_xattr_bucket_cross_cluster should be used instead.
  */
-static int ocfs2_half_xattr_cluster(struct inode *inode,
-				    handle_t *handle,
-				    u64 prev_blk,
-				    u64 new_blk,
-				    u32 *first_hash)
+static int ocfs2_divide_xattr_cluster(struct inode *inode,
+				      handle_t *handle,
+				      u64 prev_blk,
+				      u64 new_blk,
+				      u32 *first_hash)
 {
 	u16 blk_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
 	int ret, credits = 2 * blk_per_bucket;
@@ -3515,8 +3545,8 @@ static int ocfs2_half_xattr_cluster(struct inode *inode,
 	}
 
 	/* Move half of the xattr in start_blk to the next bucket. */
-	return  ocfs2_half_xattr_bucket(inode, handle, prev_blk,
-					new_blk, first_hash, 1);
+	return  ocfs2_divide_xattr_bucket(inode, handle, prev_blk,
+					  new_blk, first_hash, 1);
 }
 
 /*
@@ -3559,7 +3589,8 @@ static int ocfs2_adjust_xattr_cross_cluster(struct inode *inode,
 	int bpc = ocfs2_clusters_to_blocks(inode->i_sb, 1);
 
 	mlog(0, "adjust xattrs from cluster %llu len %u to %llu\n",
-	     prev_blk, prev_clusters, new_blk);
+	     (unsigned long long)prev_blk, prev_clusters,
+	     (unsigned long long)new_blk);
 
 	if (ocfs2_xattr_buckets_per_cluster(OCFS2_SB(inode->i_sb)) > 1)
 		ret = ocfs2_mv_xattr_bucket_cross_cluster(inode,
@@ -3578,9 +3609,9 @@ static int ocfs2_adjust_xattr_cross_cluster(struct inode *inode,
 						     last_blk, new_blk,
 						     v_start);
 		else {
-			ret = ocfs2_half_xattr_cluster(inode, handle,
-						       last_blk, new_blk,
-						       v_start);
+			ret = ocfs2_divide_xattr_cluster(inode, handle,
+							 last_blk, new_blk,
+							 v_start);
 
 			if ((*header_bh)->b_blocknr == last_blk && extend)
 				*extend = 0;
@@ -3629,7 +3660,7 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 	mlog(0, "Add new xattr cluster for %llu, previous xattr hash = %u, "
 	     "previous xattr blkno = %llu\n",
 	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
-	     prev_cpos, prev_blkno);
+	     prev_cpos, (unsigned long long)prev_blkno);
 
 	ocfs2_init_xattr_tree_extent_tree(&et, inode, root_bh);
 
@@ -3716,7 +3747,7 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 		}
 	}
 	mlog(0, "Insert %u clusters at block %llu for xattr at %u\n",
-	     num_bits, block, v_start);
+	     num_bits, (unsigned long long)block, v_start);
 	ret = ocfs2_insert_extent(osb, handle, inode, &et, v_start, block,
 				  num_bits, 0, meta_ac);
 	if (ret < 0) {
@@ -3761,7 +3792,7 @@ static int ocfs2_extend_xattr_bucket(struct inode *inode,
 	u16 bucket = le16_to_cpu(first_xh->xh_num_buckets);
 
 	mlog(0, "extend xattr bucket in %llu, xattr extend rec starting "
-	     "from %llu, len = %u\n", start_blk,
+	     "from %llu, len = %u\n", (unsigned long long)start_blk,
 	     (unsigned long long)first_bh->b_blocknr, num_clusters);
 
 	BUG_ON(bucket >= num_buckets);
@@ -3797,8 +3828,8 @@ static int ocfs2_extend_xattr_bucket(struct inode *inode,
 	}
 
 	/* Move half of the xattr in start_blk to the next bucket. */
-	ret = ocfs2_half_xattr_bucket(inode, handle, start_blk,
-				      start_blk + blk_per_bucket, NULL, 0);
+	ret = ocfs2_divide_xattr_bucket(inode, handle, start_blk,
+					start_blk + blk_per_bucket, NULL, 0);
 
 	le16_add_cpu(&first_xh->xh_num_buckets, 1);
 	ocfs2_journal_dirty(handle, first_bh);
@@ -4146,7 +4177,7 @@ static int ocfs2_xattr_value_update_size(struct inode *inode,
 	handle_t *handle = NULL;
 
 	handle = ocfs2_start_trans(osb, 1);
-	if (handle == NULL) {
+	if (IS_ERR(handle)) {
 		ret = -ENOMEM;
 		mlog_errno(ret);
 		goto out;
@@ -4313,7 +4344,7 @@ static int ocfs2_rm_xattr_cluster(struct inode *inode,
 	}
 
 	handle = ocfs2_start_trans(osb, OCFS2_REMOVE_EXTENT_CREDITS);
-	if (handle == NULL) {
+	if (IS_ERR(handle)) {
 		ret = -ENOMEM;
 		mlog_errno(ret);
 		goto out;
@@ -4489,11 +4520,21 @@ out:
 	return ret;
 }
 
-/* check whether the xattr bucket is filled up with the same hash value. */
+/*
+ * check whether the xattr bucket is filled up with the same hash value.
+ * If we want to insert the xattr with the same hash, return -ENOSPC.
+ * If we want to insert a xattr with different hash value, go ahead
+ * and ocfs2_divide_xattr_bucket will handle this.
+ */
 static int ocfs2_check_xattr_bucket_collision(struct inode *inode,
-					      struct ocfs2_xattr_bucket *bucket)
+					      struct ocfs2_xattr_bucket *bucket,
+					      const char *name)
 {
 	struct ocfs2_xattr_header *xh = bucket->xh;
+	u32 name_hash = ocfs2_xattr_name_hash(inode, name, strlen(name));
+
+	if (name_hash != le32_to_cpu(xh->xh_entries[0].xe_name_hash))
+		return 0;
 
 	if (xh->xh_entries[le16_to_cpu(xh->xh_count) - 1].xe_name_hash ==
 	    xh->xh_entries[0].xe_name_hash) {
@@ -4616,7 +4657,9 @@ try_again:
 		 * one bucket's worth, so check it here whether we need to
 		 * add a new bucket for the insert.
 		 */
-		ret = ocfs2_check_xattr_bucket_collision(inode, &xs->bucket);
+		ret = ocfs2_check_xattr_bucket_collision(inode,
+							 &xs->bucket,
+							 xi->name);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -4727,14 +4770,11 @@ out:
 /*
  * 'trusted' attributes support
  */
-
-#define XATTR_TRUSTED_PREFIX "trusted."
-
 static size_t ocfs2_xattr_trusted_list(struct inode *inode, char *list,
 				       size_t list_size, const char *name,
 				       size_t name_len)
 {
-	const size_t prefix_len = sizeof(XATTR_TRUSTED_PREFIX) - 1;
+	const size_t prefix_len = XATTR_TRUSTED_PREFIX_LEN;
 	const size_t total_len = prefix_len + name_len + 1;
 
 	if (list && total_len <= list_size) {
@@ -4771,18 +4811,14 @@ struct xattr_handler ocfs2_xattr_trusted_handler = {
 	.set	= ocfs2_xattr_trusted_set,
 };
 
-
 /*
  * 'user' attributes support
  */
-
-#define XATTR_USER_PREFIX "user."
-
 static size_t ocfs2_xattr_user_list(struct inode *inode, char *list,
 				    size_t list_size, const char *name,
 				    size_t name_len)
 {
-	const size_t prefix_len = sizeof(XATTR_USER_PREFIX) - 1;
+	const size_t prefix_len = XATTR_USER_PREFIX_LEN;
 	const size_t total_len = prefix_len + name_len + 1;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
index c25c7c6..1d8314c 100644
--- a/fs/ocfs2/xattr.h
+++ b/fs/ocfs2/xattr.h
@@ -3,24 +3,16 @@
  *
  * xattr.h
  *
- * Function prototypes
- *
- * Copyright (C) 2008 Oracle.  All rights reserved.
+ * Copyright (C) 2004, 2008 Oracle.  All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public
- * License as published by the Free Software Foundation; either
- * version 2 of the License, or (at your option) any later version.
+ * License version 2 as published by the Free Software Foundation.
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
  */
 
 #ifndef OCFS2_XATTR_H
@@ -40,29 +32,11 @@ enum ocfs2_xattr_type {
 
 extern struct xattr_handler ocfs2_xattr_user_handler;
 extern struct xattr_handler ocfs2_xattr_trusted_handler;
-
-extern ssize_t ocfs2_listxattr(struct dentry *, char *, size_t);
-extern int ocfs2_xattr_get(struct inode *, int, const char *, void *, size_t);
-extern int ocfs2_xattr_set(struct inode *, int, const char *, const void *,
-			   size_t, int);
-extern int ocfs2_xattr_remove(struct inode *inode, struct buffer_head *di_bh);
 extern struct xattr_handler *ocfs2_xattr_handlers[];
 
-static inline u16 ocfs2_xattr_buckets_per_cluster(struct ocfs2_super *osb)
-{
-	return (1 << osb->s_clustersize_bits) / OCFS2_XATTR_BUCKET_SIZE;
-}
-
-static inline u16 ocfs2_blocks_per_xattr_bucket(struct super_block *sb)
-{
-	return OCFS2_XATTR_BUCKET_SIZE / (1 << sb->s_blocksize_bits);
-}
-
-static inline u16 ocfs2_xattr_max_xe_in_bucket(struct super_block *sb)
-{
-	u16 len = sb->s_blocksize -
-		 offsetof(struct ocfs2_xattr_header, xh_entries);
+ssize_t ocfs2_listxattr(struct dentry *, char *, size_t);
+int ocfs2_xattr_set(struct inode *, int, const char *, const void *,
+		    size_t, int);
+int ocfs2_xattr_remove(struct inode *, struct buffer_head *);
 
-	return len / sizeof(struct ocfs2_xattr_entry);
-}
 #endif /* OCFS2_XATTR_H */

--
Mark Fasheh
