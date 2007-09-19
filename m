From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Sep 19 13:12:23 2007
Subject: [Ocfs2-devel] [PATCH 13/15] ocfs2: Write support for inline data
Message-ID: <200709192012.l8JKCHat012235@agmgw2.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This fixes up write, truncate, mmap, and RESVSP/UNRESVP to understand inline
inode data.

For the most part, the changes to the core write code can be relied on to do
the heavy lifting. Any code calling ocfs2_write_begin (including shared
writeable mmap) can count on it doing the right thing with respect to
growing inline data to an extent tree.

Size reducing truncates, including UNRESVP can simply zero that portion of
the inode block being removed. Size increasing truncatesm, including RESVP
have to be a little bit smarter and grow the inode to an extent tree if
necessary.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/alloc.c   |  245 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/alloc.h   |    6 ++
 fs/ocfs2/aops.c    |  173 ++++++++++++++++++++++++++++++++++++-
 fs/ocfs2/aops.h    |    4 +
 fs/ocfs2/file.c    |   99 ++++++++++++++++++++--
 fs/ocfs2/inode.c   |    4 +
 fs/ocfs2/journal.h |    3 +
 7 files changed, 526 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 46a0bc5..130624a 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -3734,6 +3734,8 @@ int ocfs2_insert_extent(struct ocfs2_super *osb,
 	struct ocfs2_insert_type insert = {0, };
 	struct ocfs2_extent_rec rec;
 
+	BUG_ON(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL);
+
 	mlog(0, "add %u clusters at position %u to inode %llu\n",
 	     new_clusters, cpos, (unsigned long long)OCFS2_I(inode)->ip_blkno);
 
@@ -5857,6 +5859,174 @@ out:
 	return ret;
 }
 
+static void ocfs2_zero_dinode_id2(struct inode *inode, struct ocfs2_dinode *di)
+{
+	unsigned int blocksize = 1 << inode->i_sb->s_blocksize_bits;
+
+	memset(&di->id2, 0, blocksize - offsetof(struct ocfs2_dinode, id2));
+}
+
+void ocfs2_set_inode_data_inline(struct inode *inode, struct ocfs2_dinode *di)
+{
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct ocfs2_inline_data *idata = &di->id2.i_data;
+
+	spin_lock(&oi->ip_lock);
+	oi->ip_dyn_features |= OCFS2_INLINE_DATA_FL;
+	di->i_dyn_features = cpu_to_le16(oi->ip_dyn_features);
+	spin_unlock(&oi->ip_lock);
+
+	/*
+	 * We clear the entire i_data structure here so that all
+	 * fields can be properly initialized.
+	 */
+	ocfs2_zero_dinode_id2(inode, di);
+
+	idata->id_count = cpu_to_le16(ocfs2_max_inline_data(inode->i_sb));
+}
+
+int ocfs2_convert_inline_data_to_extents(struct inode *inode,
+					 struct buffer_head *di_bh)
+{
+	int ret, i, has_data, num_pages = 0;
+	handle_t *handle;
+	u64 uninitialized_var(block);
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+	struct ocfs2_extent_list *el = &di->id2.i_list;
+	struct ocfs2_alloc_context *data_ac = NULL;
+	struct page **pages = NULL;
+	loff_t end = osb->s_clustersize;
+
+	has_data = i_size_read(inode) ? 1 : 0;
+
+	if (has_data) {
+		pages = kcalloc(ocfs2_pages_per_cluster(osb->sb),
+				sizeof(struct page *), GFP_NOFS);
+		if (pages == NULL) {
+			ret = -ENOMEM;
+			mlog_errno(ret);
+			goto out;
+		}
+
+		ret = ocfs2_reserve_clusters(osb, 1, &data_ac);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+	}
+
+	handle = ocfs2_start_trans(osb, OCFS2_INLINE_TO_EXTENTS_CREDITS);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		mlog_errno(ret);
+		goto out_unlock;
+	}
+
+	ret = ocfs2_journal_access(handle, inode, di_bh,
+				   OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	if (has_data) {
+		u32 bit_off, num;
+		unsigned int page_end;
+		u64 phys;
+
+		ret = ocfs2_claim_clusters(osb, handle, data_ac, 1, &bit_off,
+					   &num);
+		if (ret) {
+			mlog_errno(ret);
+			goto out_commit;
+		}
+
+		/*
+		 * Save two copies, one for insert, and one that can
+		 * be changed by ocfs2_map_and_dirty_page() below.
+		 */
+		block = phys = ocfs2_clusters_to_blocks(inode->i_sb, bit_off);
+
+		/*
+		 * Non sparse file systems zero on extend, so no need
+		 * to do that now.
+		 */
+		if (!ocfs2_sparse_alloc(osb) &&
+		    PAGE_CACHE_SIZE < osb->s_clustersize)
+			end = PAGE_CACHE_SIZE;
+
+		ret = ocfs2_grab_eof_pages(inode, 0, end, pages, &num_pages);
+		if (ret) {
+			mlog_errno(ret);
+			goto out_commit;
+		}
+
+		/*
+		 * This should populate the 1st page for us and mark
+		 * it up to date.
+		 */
+		ret = ocfs2_read_inline_data(inode, pages[0], di_bh);
+		if (ret) {
+			mlog_errno(ret);
+			goto out_commit;
+		}
+
+		page_end = PAGE_CACHE_SIZE;
+		if (PAGE_CACHE_SIZE > osb->s_clustersize)
+			page_end = osb->s_clustersize;
+
+		for (i = 0; i < num_pages; i++)
+			ocfs2_map_and_dirty_page(inode, handle, 0, page_end,
+						 pages[i], i > 0, &phys);
+	}
+
+	spin_lock(&oi->ip_lock);
+	oi->ip_dyn_features &= ~OCFS2_INLINE_DATA_FL;
+	di->i_dyn_features = cpu_to_le16(oi->ip_dyn_features);
+	spin_unlock(&oi->ip_lock);
+
+	ocfs2_zero_dinode_id2(inode, di);
+
+	el->l_tree_depth = 0;
+	el->l_next_free_rec = 0;
+	el->l_count = cpu_to_le16(ocfs2_extent_recs_per_inode(inode->i_sb));
+
+	ocfs2_journal_dirty(handle, di_bh);
+
+	if (has_data) {
+		/*
+		 * An error at this point should be extremely rare. If
+		 * this proves to be false, we could always re-build
+		 * the in-inode data from our pages.
+		 */
+		ret = ocfs2_insert_extent(osb, handle, inode, di_bh,
+					  0, block, 1, 0, NULL);
+		if (ret) {
+			mlog_errno(ret);
+			goto out_commit;
+		}
+
+		inode->i_blocks = ocfs2_inode_sector_count(inode);
+	}
+
+out_commit:
+	ocfs2_commit_trans(osb, handle);
+
+out_unlock:
+	if (data_ac)
+		ocfs2_free_alloc_context(data_ac);
+
+out:
+	if (pages) {
+		ocfs2_unlock_and_free_pages(pages, num_pages);
+		kfree(pages);
+	}
+
+	return ret;
+}
+
 /*
  * It is expected, that by the time you call this function,
  * inode->i_size and fe->i_size have been adjusted.
@@ -6082,6 +6252,81 @@ bail:
 	return status;
 }
 
+/*
+ * 'start' is inclusive, 'end' is not.
+ */
+int ocfs2_truncate_inline(struct inode *inode, struct buffer_head *di_bh,
+			  unsigned int start, unsigned int end, int trunc)
+{
+	int ret;
+	unsigned int numbytes;
+	handle_t *handle;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+	struct ocfs2_inline_data *idata = &di->id2.i_data;
+
+	if (end > i_size_read(inode))
+		end = i_size_read(inode);
+
+	BUG_ON(start >= end);
+
+	if (!(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) ||
+	    !(le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) ||
+	    !ocfs2_supports_inline_data(osb)) {
+		ocfs2_error(inode->i_sb,
+			    "Inline data flags for inode %llu don't agree! "
+			    "Disk: 0x%x, Memory: 0x%x, Superblock: 0x%x\n",
+			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
+			    le16_to_cpu(di->i_dyn_features),
+			    OCFS2_I(inode)->ip_dyn_features,
+			    osb->s_feature_incompat);
+		ret = -EROFS;
+		goto out;
+	}
+
+	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_journal_access(handle, inode, di_bh,
+				   OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	numbytes = end - start;
+	memset(idata->id_data + start, 0, numbytes);
+
+	/*
+	 * No need to worry about the data page here - it's been
+	 * truncated already and inline data doesn't need it for
+	 * pushing zero's to disk, so we'll let readpage pick it up
+	 * later.
+	 */
+	if (trunc) {
+		i_size_write(inode, start);
+		di->i_size = cpu_to_le64(start);
+	}
+
+	inode->i_blocks = ocfs2_inode_sector_count(inode);
+	inode->i_ctime = inode->i_mtime = CURRENT_TIME;
+
+	di->i_ctime = di->i_mtime = cpu_to_le64(inode->i_ctime.tv_sec);
+	di->i_ctime_nsec = di->i_mtime_nsec = cpu_to_le32(inode->i_ctime.tv_nsec);
+
+	ocfs2_journal_dirty(handle, di_bh);
+
+out_commit:
+	ocfs2_commit_trans(osb, handle);
+
+out:
+	return ret;
+}
+
 static void ocfs2_free_truncate_context(struct ocfs2_truncate_context *tc)
 {
 	/*
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index 990df48..826e0a6 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -62,6 +62,10 @@ static inline int ocfs2_extend_meta_needed(struct ocfs2_dinode *fe)
 	return le16_to_cpu(fe->id2.i_list.l_tree_depth) + 2;
 }
 
+void ocfs2_set_inode_data_inline(struct inode *inode, struct ocfs2_dinode *di);
+int ocfs2_convert_inline_data_to_extents(struct inode *inode,
+					 struct buffer_head *di_bh);
+
 int ocfs2_truncate_log_init(struct ocfs2_super *osb);
 void ocfs2_truncate_log_shutdown(struct ocfs2_super *osb);
 void ocfs2_schedule_truncate_log_flush(struct ocfs2_super *osb,
@@ -115,6 +119,8 @@ int ocfs2_commit_truncate(struct ocfs2_super *osb,
 			  struct inode *inode,
 			  struct buffer_head *fe_bh,
 			  struct ocfs2_truncate_context *tc);
+int ocfs2_truncate_inline(struct inode *inode, struct buffer_head *di_bh,
+			  unsigned int start, unsigned int end, int trunc);
 
 int ocfs2_find_leaf(struct inode *inode, struct ocfs2_extent_list *root_el,
 		    u32 cpos, struct buffer_head **leaf_bh);
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 4234d78..d4ee783 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -206,8 +206,8 @@ bail:
 	return err;
 }
 
-static int ocfs2_read_inline_data(struct inode *inode, struct page *page,
-				  struct buffer_head *di_bh)
+int ocfs2_read_inline_data(struct inode *inode, struct page *page,
+			   struct buffer_head *di_bh)
 {
 	void *kaddr;
 	unsigned int size;
@@ -1425,6 +1425,130 @@ out:
 	return ret;
 }
 
+static int ocfs2_write_begin_inline(struct address_space *mapping,
+				    struct inode *inode,
+				    struct ocfs2_write_ctxt *wc)
+{
+	int ret;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct page *page;
+	handle_t *handle;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)wc->w_di_bh->b_data;
+
+	page = find_or_create_page(mapping, 0, GFP_NOFS);
+	if (!page) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto out;
+	}
+	/*
+	 * If we don't set w_num_pages then this page won't get unlocked
+	 * and freed on cleanup of the write context.
+	 */
+	wc->w_pages[0] = wc->w_target_page = page;
+	wc->w_num_pages = 1;
+
+	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_journal_access(handle, inode, wc->w_di_bh,
+				   OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		ocfs2_commit_trans(osb, handle);
+
+		mlog_errno(ret);
+		goto out;
+	}
+
+	if (!(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL))
+		ocfs2_set_inode_data_inline(inode, di);
+
+	if (!PageUptodate(page)) {
+		ret = ocfs2_read_inline_data(inode, page, wc->w_di_bh);
+		if (ret) {
+			ocfs2_commit_trans(osb, handle);
+
+			goto out;
+		}
+	}
+
+	wc->w_handle = handle;
+out:
+	return ret;
+}
+
+int ocfs2_size_fits_inline_data(struct buffer_head *di_bh, u64 new_size)
+{
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+
+	if (new_size < le16_to_cpu(di->id2.i_data.id_count))
+		return 1;
+	return 0;
+}
+
+static int ocfs2_try_to_write_inline_data(struct address_space *mapping,
+					  struct inode *inode, loff_t pos,
+					  unsigned len, struct page *mmap_page,
+					  struct ocfs2_write_ctxt *wc)
+{
+	int ret, written = 0;
+	loff_t end = pos + len;
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+
+	mlog(0, "Inode %llu, write of %u bytes at off %llu. features: 0x%x\n",
+	     (unsigned long long)oi->ip_blkno, len, (unsigned long long)pos,
+	     oi->ip_dyn_features);
+
+	/*
+	 * Handle inodes which already have inline data 1st.
+	 */
+	if (oi->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
+		if (mmap_page == NULL &&
+		    ocfs2_size_fits_inline_data(wc->w_di_bh, end))
+			goto do_inline_write;
+
+		/*
+		 * The write won't fit - we have to give this inode an
+		 * inline extent list now.
+		 */
+		ret = ocfs2_convert_inline_data_to_extents(inode, wc->w_di_bh);
+		if (ret)
+			mlog_errno(ret);
+		goto out;
+	}
+
+	/*
+	 * Check whether the inode can accept inline data.
+	 */
+	if (oi->ip_clusters != 0 || i_size_read(inode) != 0)
+		return 0;
+
+	/*
+	 * Check whether the write can fit.
+	 */
+	if (mmap_page || end > ocfs2_max_inline_data(inode->i_sb))
+		return 0;
+
+do_inline_write:
+	ret = ocfs2_write_begin_inline(mapping, inode, wc);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	/*
+	 * This signals to the caller that the data can be written
+	 * inline.
+	 */
+	written = 1;
+out:
+	return written ? written : ret;
+}
+
 /*
  * This function only does anything for file systems which can't
  * handle sparse files.
@@ -1476,6 +1600,19 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 		return ret;
 	}
 
+	if (ocfs2_supports_inline_data(osb)) {
+		ret = ocfs2_try_to_write_inline_data(mapping, inode, pos, len,
+						     mmap_page, wc);
+		if (ret == 1) {
+			ret = 0;
+			goto success;
+		}
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto out;
+		}
+	}
+
 	ret = ocfs2_expand_nonsparse_inode(inode, pos, len, wc);
 	if (ret) {
 		mlog_errno(ret);
@@ -1563,6 +1700,7 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 	if (meta_ac)
 		ocfs2_free_alloc_context(meta_ac);
 
+success:
 	*pagep = wc->w_target_page;
 	*fsdata = wc;
 	return 0;
@@ -1630,6 +1768,31 @@ out_fail:
 	return ret;
 }
 
+static void ocfs2_write_end_inline(struct inode *inode, loff_t pos,
+				   unsigned len, unsigned *copied,
+				   struct ocfs2_dinode *di,
+				   struct ocfs2_write_ctxt *wc)
+{
+	void *kaddr;
+
+	if (unlikely(*copied < len)) {
+		if (!PageUptodate(wc->w_target_page)) {
+			*copied = 0;
+			return;
+		}
+	}
+
+	kaddr = kmap_atomic(wc->w_target_page, KM_USER0);
+	memcpy(di->id2.i_data.id_data + pos, kaddr + pos, *copied);
+	kunmap_atomic(kaddr, KM_USER0);
+
+	mlog(0, "Data written to inode at offset %llu. "
+	     "id_count = %u, copied = %u, i_dyn_features = 0x%x\n",
+	     (unsigned long long)pos, *copied,
+	     le16_to_cpu(di->id2.i_data.id_count),
+	     le16_to_cpu(di->i_dyn_features));
+}
+
 int ocfs2_write_end_nolock(struct address_space *mapping,
 			   loff_t pos, unsigned len, unsigned copied,
 			   struct page *page, void *fsdata)
@@ -1643,6 +1806,11 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
 	handle_t *handle = wc->w_handle;
 	struct page *tmppage;
 
+	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
+		ocfs2_write_end_inline(inode, pos, len, &copied, di, wc);
+		goto out_write_size;
+	}
+
 	if (unlikely(copied < len)) {
 		if (!PageUptodate(wc->w_target_page))
 			copied = 0;
@@ -1680,6 +1848,7 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
 		block_commit_write(tmppage, from, to);
 	}
 
+out_write_size:
 	pos += copied;
 	if (pos > inode->i_size) {
 		i_size_write(inode, pos);
diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
index b4fa37d..1135608 100644
--- a/fs/ocfs2/aops.h
+++ b/fs/ocfs2/aops.h
@@ -61,6 +61,10 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 			     struct page **pagep, void **fsdata,
 			     struct buffer_head *di_bh, struct page *mmap_page);
 
+int ocfs2_read_inline_data(struct inode *inode, struct page *page,
+			   struct buffer_head *di_bh);
+int ocfs2_size_fits_inline_data(struct buffer_head *di_bh, u64 new_size);
+
 /* all ocfs2_dio_end_io()'s fault */
 #define ocfs2_iocb_is_rw_locked(iocb) \
 	test_bit(0, (unsigned long *)&iocb->private)
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 429ebcb..9787306 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -398,6 +398,15 @@ static int ocfs2_truncate_file(struct inode *inode,
 	unmap_mapping_range(inode->i_mapping, new_i_size + PAGE_SIZE - 1, 0, 1);
 	truncate_inode_pages(inode->i_mapping, new_i_size);
 
+	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
+		status = ocfs2_truncate_inline(inode, di_bh, new_i_size,
+					       i_size_read(inode), 0);
+		if (status)
+			mlog_errno(status);
+
+		goto bail_unlock_data;
+	}
+
 	/* alright, we're going to need to do a full blown alloc size
 	 * change. Orphan the inode so that recovery can complete the
 	 * truncate if necessary. This does the task of marking
@@ -909,7 +918,8 @@ static int ocfs2_extend_file(struct inode *inode,
 			     struct buffer_head *di_bh,
 			     u64 new_i_size)
 {
-	int ret = 0;
+	int ret = 0, data_locked = 0;
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 
 	BUG_ON(!di_bh);
 
@@ -921,7 +931,17 @@ static int ocfs2_extend_file(struct inode *inode,
   		goto out;
 	BUG_ON(new_i_size < i_size_read(inode));
 
-	if (ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)))
+	/*
+	 * Fall through for converting inline data, even if the fs
+	 * supports sparse files.
+	 *
+	 * The check for inline data here is legal - nobody can add
+	 * the feature since we have i_mutex. We must check it again
+	 * after acquiring ip_alloc_sem though, as paths like mmap
+	 * might have raced us to converting the inode to extents.
+	 */
+	if (!(oi->ip_dyn_features & OCFS2_INLINE_DATA_FL)
+	    && ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)))
 		goto out_update_size;
 
 	/* 
@@ -936,6 +956,7 @@ static int ocfs2_extend_file(struct inode *inode,
 		mlog_errno(ret);
 		goto out;
 	}
+	data_locked = 1;
 
 	/*
 	 * The alloc sem blocks people in read/write from reading our
@@ -943,9 +964,31 @@ static int ocfs2_extend_file(struct inode *inode,
 	 * i_mutex to block other extend/truncate calls while we're
 	 * here.
 	 */
-	down_write(&OCFS2_I(inode)->ip_alloc_sem);
-	ret = ocfs2_extend_no_holes(inode, new_i_size, new_i_size);
-	up_write(&OCFS2_I(inode)->ip_alloc_sem);
+	down_write(&oi->ip_alloc_sem);
+
+	if (oi->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
+		/*
+		 * We can optimize small extends by keeping the inodes
+		 * inline data.
+		 */
+		if (ocfs2_size_fits_inline_data(di_bh, new_i_size)) {
+			up_write(&oi->ip_alloc_sem);
+			goto out_update_size;
+		}
+
+		ret = ocfs2_convert_inline_data_to_extents(inode, di_bh);
+		if (ret) {
+			up_write(&oi->ip_alloc_sem);
+
+			mlog_errno(ret);
+			goto out_unlock;
+		}
+	}
+
+	if (!ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)))
+		ret = ocfs2_extend_no_holes(inode, new_i_size, new_i_size);
+
+	up_write(&oi->ip_alloc_sem);
 
 	if (ret < 0) {
 		mlog_errno(ret);
@@ -958,7 +1001,7 @@ out_update_size:
 		mlog_errno(ret);
 
 out_unlock:
-	if (!ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)))
+	if (data_locked)
 		ocfs2_data_unlock(inode, 1);
 
 out:
@@ -1232,6 +1275,31 @@ static int ocfs2_allocate_unwritten_extents(struct inode *inode,
 {
 	int ret;
 	u32 cpos, phys_cpos, clusters, alloc_size;
+	u64 end = start + len;
+	struct buffer_head *di_bh = NULL;
+
+	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
+		ret = ocfs2_read_block(OCFS2_SB(inode->i_sb),
+				       OCFS2_I(inode)->ip_blkno, &di_bh,
+				       OCFS2_BH_CACHED, inode);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		/*
+		 * Nothing to do if the requested reservation range
+		 * fits within the inode.
+		 */
+		if (ocfs2_size_fits_inline_data(di_bh, end))
+			goto out;
+
+		ret = ocfs2_convert_inline_data_to_extents(inode, di_bh);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+	}
 
 	/*
 	 * We consider both start and len to be inclusive.
@@ -1277,6 +1345,8 @@ next:
 
 	ret = 0;
 out:
+
+	brelse(di_bh);
 	return ret;
 }
 
@@ -1458,6 +1528,14 @@ static int ocfs2_remove_inode_range(struct inode *inode,
 	if (byte_len == 0)
 		return 0;
 
+	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
+		ret = ocfs2_truncate_inline(inode, di_bh, byte_start,
+					    byte_start + byte_len, 1);
+		if (ret)
+			mlog_errno(ret);
+		return ret;
+	}
+
 	trunc_start = ocfs2_clusters_for_bytes(osb->sb, byte_start);
 	trunc_len = (byte_start + byte_len) >> osb->s_clustersize_bits;
 	if (trunc_len >= trunc_start)
@@ -1760,6 +1838,15 @@ static int ocfs2_prepare_inode_for_write(struct dentry *dentry,
 			break;
 
 		/*
+		 * There's no sane way to do direct writes to an inode
+		 * with inline data.
+		 */
+		if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
+			*direct_io = 0;
+			break;
+		}
+
+		/*
 		 * Allowing concurrent direct writes means
 		 * i_size changes wouldn't be synchronized, so
 		 * one node could wind up truncating another
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index c8923ba..1d5e0cb 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -514,6 +514,10 @@ static int ocfs2_truncate_for_delete(struct ocfs2_super *osb,
 
 	fe = (struct ocfs2_dinode *) fe_bh->b_data;
 
+	/*
+	 * This check will also skip truncate of inodes with inline
+	 * data and fast symlinks.
+	 */
 	if (fe->i_clusters) {
 		handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
 		if (IS_ERR(handle)) {
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index ce60aab..4b32e09 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -282,6 +282,9 @@ int                  ocfs2_journal_dirty_data(handle_t *handle,
  * prev. group desc. if we relink. */
 #define OCFS2_SUBALLOC_ALLOC (3)
 
+#define OCFS2_INLINE_TO_EXTENTS_CREDITS (OCFS2_SUBALLOC_ALLOC		\
+					 + OCFS2_INODE_UPDATE_CREDITS)
+
 /* dinode + group descriptor update. We don't relink on free yet. */
 #define OCFS2_SUBALLOC_FREE  (2)
 
-- 
1.5.0.6
