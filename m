From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Thu, 01 Dec 2016 16:55:07 -0800
Subject: [Ocfs2-devel] [PATCH 7/8] ocfs2: implement the VFS clone_range,
 copy_range, and dedupe_range features
In-Reply-To: <148064006267.14039.3248903225701175868.stgit@birch.djwong.org>
References: <148064006267.14039.3248903225701175868.stgit@birch.djwong.org>
Message-ID: <148064010773.14039.9897211644462867091.stgit@birch.djwong.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@versity.com, akpm@linux-foundation.org, jlbec@evilplan.org, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, ocfs2-devel@oss.oracle.com

Connect the new VFS clone_range, copy_range, and dedupe_range features
to the existing reflink capability of ocfs2.  Compared to the existing
ocfs2 reflink ioctl We have to do things a little differently to support
the VFS semantics (we can clone subranges of a file but we don't clone
xattrs), but the VFS ioctls are more broadly supported.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: Convert inline data files to extents files before reflinking,
and fix i_blocks so that stat(2) output is correct.
v3: Make zero-length dedupe consistent with btrfs behavior.
v4: Use VFS double-inode lock routines and remove MAX_DEDUPE_LEN.
---
 fs/ocfs2/file.c         |   53 ++++
 fs/ocfs2/file.h         |    3 
 fs/ocfs2/refcounttree.c |  628 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/refcounttree.h |    7 +
 4 files changed, 688 insertions(+), 3 deletions(-)


diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index d261f3a..cac617a 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1667,9 +1667,9 @@ static void ocfs2_calc_trunc_pos(struct inode *inode,
 	*done = ret;
 }
 
-static int ocfs2_remove_inode_range(struct inode *inode,
-				    struct buffer_head *di_bh, u64 byte_start,
-				    u64 byte_len)
+int ocfs2_remove_inode_range(struct inode *inode,
+			     struct buffer_head *di_bh, u64 byte_start,
+			     u64 byte_len)
 {
 	int ret = 0, flags = 0, done = 0, i;
 	u32 trunc_start, trunc_len, trunc_end, trunc_cpos, phys_cpos;
@@ -2439,6 +2439,47 @@ static loff_t ocfs2_file_llseek(struct file *file, loff_t offset, int whence)
 	return offset;
 }
 
+static ssize_t ocfs2_file_copy_range(struct file *file_in,
+				     loff_t pos_in,
+				     struct file *file_out,
+				     loff_t pos_out,
+				     size_t len,
+				     unsigned int flags)
+{
+	int error;
+
+	error = ocfs2_reflink_remap_range(file_in, pos_in, file_out, pos_out,
+					  len, false);
+	if (error)
+		return error;
+	return len;
+}
+
+static int ocfs2_file_clone_range(struct file *file_in,
+				  loff_t pos_in,
+				  struct file *file_out,
+				  loff_t pos_out,
+				  u64 len)
+{
+	return ocfs2_reflink_remap_range(file_in, pos_in, file_out, pos_out,
+					 len, false);
+}
+
+static ssize_t ocfs2_file_dedupe_range(struct file *src_file,
+				       u64 loff,
+				       u64 len,
+				       struct file *dst_file,
+				       u64 dst_loff)
+{
+	int error;
+
+	error = ocfs2_reflink_remap_range(src_file, loff, dst_file, dst_loff,
+					  len, true);
+	if (error)
+		return error;
+	return len;
+}
+
 const struct inode_operations ocfs2_file_iops = {
 	.setattr	= ocfs2_setattr,
 	.getattr	= ocfs2_getattr,
@@ -2478,6 +2519,9 @@ const struct file_operations ocfs2_fops = {
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.fallocate	= ocfs2_fallocate,
+	.copy_file_range = ocfs2_file_copy_range,
+	.clone_file_range = ocfs2_file_clone_range,
+	.dedupe_file_range = ocfs2_file_dedupe_range,
 };
 
 const struct file_operations ocfs2_dops = {
@@ -2523,6 +2567,9 @@ const struct file_operations ocfs2_fops_no_plocks = {
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.fallocate	= ocfs2_fallocate,
+	.copy_file_range = ocfs2_file_copy_range,
+	.clone_file_range = ocfs2_file_clone_range,
+	.dedupe_file_range = ocfs2_file_dedupe_range,
 };
 
 const struct file_operations ocfs2_dops_no_plocks = {
diff --git a/fs/ocfs2/file.h b/fs/ocfs2/file.h
index e8c62f2..897fd9a 100644
--- a/fs/ocfs2/file.h
+++ b/fs/ocfs2/file.h
@@ -82,4 +82,7 @@ int ocfs2_change_file_space(struct file *file, unsigned int cmd,
 
 int ocfs2_check_range_for_refcount(struct inode *inode, loff_t pos,
 				   size_t count);
+int ocfs2_remove_inode_range(struct inode *inode,
+			     struct buffer_head *di_bh, u64 byte_start,
+			     u64 byte_len);
 #endif /* OCFS2_FILE_H */
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 6c98d56..57297ce 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -34,6 +34,7 @@
 #include "xattr.h"
 #include "namei.h"
 #include "ocfs2_trace.h"
+#include "file.h"
 
 #include <linux/bio.h>
 #include <linux/blkdev.h>
@@ -4441,3 +4442,630 @@ int ocfs2_reflink_ioctl(struct inode *inode,
 
 	return error;
 }
+
+/* Update destination inode size, if necessary. */
+static int ocfs2_reflink_update_dest(struct inode *dest,
+				     struct buffer_head *d_bh,
+				     loff_t newlen)
+{
+	handle_t *handle;
+	int ret;
+
+	dest->i_blocks = ocfs2_inode_sector_count(dest);
+
+	if (newlen <= i_size_read(dest))
+		return 0;
+
+	handle = ocfs2_start_trans(OCFS2_SB(dest->i_sb),
+				   OCFS2_INODE_UPDATE_CREDITS);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		mlog_errno(ret);
+		return ret;
+	}
+
+	/* Extend i_size if needed. */
+	spin_lock(&OCFS2_I(dest)->ip_lock);
+	if (newlen > i_size_read(dest))
+		i_size_write(dest, newlen);
+	spin_unlock(&OCFS2_I(dest)->ip_lock);
+	dest->i_ctime = dest->i_mtime = current_time(dest);
+
+	ret = ocfs2_mark_inode_dirty(handle, dest, d_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+out_commit:
+	ocfs2_commit_trans(OCFS2_SB(dest->i_sb), handle);
+	return ret;
+}
+
+/* Remap the range pos_in:len in s_inode to pos_out:len in t_inode. */
+static int ocfs2_reflink_remap_extent(struct inode *s_inode,
+				      struct buffer_head *s_bh,
+				      loff_t pos_in,
+				      struct inode *t_inode,
+				      struct buffer_head *t_bh,
+				      loff_t pos_out,
+				      loff_t len,
+				      struct ocfs2_cached_dealloc_ctxt *dealloc)
+{
+	struct ocfs2_extent_tree s_et;
+	struct ocfs2_extent_tree t_et;
+	struct ocfs2_dinode *dis;
+	struct buffer_head *ref_root_bh = NULL;
+	struct ocfs2_refcount_tree *ref_tree;
+	struct ocfs2_super *osb;
+	loff_t pstart, plen;
+	u32 p_cluster, num_clusters, slast, spos, tpos;
+	unsigned int ext_flags;
+	int ret = 0;
+
+	osb = OCFS2_SB(s_inode->i_sb);
+	dis = (struct ocfs2_dinode *)s_bh->b_data;
+	ocfs2_init_dinode_extent_tree(&s_et, INODE_CACHE(s_inode), s_bh);
+	ocfs2_init_dinode_extent_tree(&t_et, INODE_CACHE(t_inode), t_bh);
+
+	spos = ocfs2_bytes_to_clusters(s_inode->i_sb, pos_in);
+	tpos = ocfs2_bytes_to_clusters(t_inode->i_sb, pos_out);
+	slast = ocfs2_clusters_for_bytes(s_inode->i_sb, pos_in + len);
+
+	while (spos < slast) {
+		if (fatal_signal_pending(current)) {
+			ret = -EINTR;
+			goto out;
+		}
+
+		/* Look up the extent. */
+		ret = ocfs2_get_clusters(s_inode, spos, &p_cluster,
+					 &num_clusters, &ext_flags);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		num_clusters = min_t(u32, num_clusters, slast - spos);
+
+		/* Punch out the dest range. */
+		pstart = ocfs2_clusters_to_bytes(t_inode->i_sb, tpos);
+		plen = ocfs2_clusters_to_bytes(t_inode->i_sb, num_clusters);
+		ret = ocfs2_remove_inode_range(t_inode, t_bh, pstart, plen);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		if (p_cluster == 0)
+			goto next_loop;
+
+		/* Lock the refcount btree... */
+		ret = ocfs2_lock_refcount_tree(osb,
+					       le64_to_cpu(dis->i_refcount_loc),
+					       1, &ref_tree, &ref_root_bh);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		/* Mark s_inode's extent as refcounted. */
+		if (!(ext_flags & OCFS2_EXT_REFCOUNTED)) {
+			ret = ocfs2_add_refcount_flag(s_inode, &s_et,
+						      &ref_tree->rf_ci,
+						      ref_root_bh, spos,
+						      p_cluster, num_clusters,
+						      dealloc, NULL);
+			if (ret) {
+				mlog_errno(ret);
+				goto out_unlock_refcount;
+			}
+		}
+
+		/* Map in the new extent. */
+		ext_flags |= OCFS2_EXT_REFCOUNTED;
+		ret = ocfs2_add_refcounted_extent(t_inode, &t_et,
+						  &ref_tree->rf_ci,
+						  ref_root_bh,
+						  tpos, p_cluster,
+						  num_clusters,
+						  ext_flags,
+						  dealloc);
+		if (ret) {
+			mlog_errno(ret);
+			goto out_unlock_refcount;
+		}
+
+		ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
+		brelse(ref_root_bh);
+next_loop:
+		spos += num_clusters;
+		tpos += num_clusters;
+	}
+
+out:
+	return ret;
+out_unlock_refcount:
+	ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
+	brelse(ref_root_bh);
+	return ret;
+}
+
+/* Set up refcount tree and remap s_inode to t_inode. */
+static int ocfs2_reflink_remap_blocks(struct inode *s_inode,
+				      struct buffer_head *s_bh,
+				      loff_t pos_in,
+				      struct inode *t_inode,
+				      struct buffer_head *t_bh,
+				      loff_t pos_out,
+				      loff_t len)
+{
+	struct ocfs2_cached_dealloc_ctxt dealloc;
+	struct ocfs2_super *osb;
+	struct ocfs2_dinode *dis;
+	struct ocfs2_dinode *dit;
+	int ret;
+
+	osb = OCFS2_SB(s_inode->i_sb);
+	dis = (struct ocfs2_dinode *)s_bh->b_data;
+	dit = (struct ocfs2_dinode *)t_bh->b_data;
+	ocfs2_init_dealloc_ctxt(&dealloc);
+
+	/*
+	 * If we're reflinking the entire file and the source is inline
+	 * data, just copy the contents.
+	 */
+	if (pos_in == pos_out && pos_in == 0 && len == i_size_read(s_inode) &&
+	    i_size_read(t_inode) <= len &&
+	    (OCFS2_I(s_inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)) {
+		ret = ocfs2_duplicate_inline_data(s_inode, s_bh, t_inode, t_bh);
+		if (ret)
+			mlog_errno(ret);
+		goto out;
+	}
+
+	/*
+	 * If both inodes belong to two different refcount groups then
+	 * forget it because we don't know how (or want) to go merging
+	 * refcount trees.
+	 */
+	ret = -EOPNOTSUPP;
+	if (ocfs2_is_refcount_inode(s_inode) &&
+	    ocfs2_is_refcount_inode(t_inode) &&
+	    le64_to_cpu(dis->i_refcount_loc) !=
+	    le64_to_cpu(dit->i_refcount_loc))
+		goto out;
+
+	/* Neither inode has a refcount tree.  Add one to s_inode. */
+	if (!ocfs2_is_refcount_inode(s_inode) &&
+	    !ocfs2_is_refcount_inode(t_inode)) {
+		ret = ocfs2_create_refcount_tree(s_inode, s_bh);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+	}
+
+	/* Ensure that both inodes end up with the same refcount tree. */
+	if (!ocfs2_is_refcount_inode(s_inode)) {
+		ret = ocfs2_set_refcount_tree(s_inode, s_bh,
+					      le64_to_cpu(dit->i_refcount_loc));
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+	}
+	if (!ocfs2_is_refcount_inode(t_inode)) {
+		ret = ocfs2_set_refcount_tree(t_inode, t_bh,
+					      le64_to_cpu(dis->i_refcount_loc));
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+	}
+
+	/* Turn off inline data in the dest file. */
+	if (OCFS2_I(t_inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
+		ret = ocfs2_convert_inline_data_to_extents(t_inode, t_bh);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+	}
+
+	/* Actually remap extents now. */
+	ret = ocfs2_reflink_remap_extent(s_inode, s_bh, pos_in, t_inode, t_bh,
+					 pos_out, len, &dealloc);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+out:
+	if (ocfs2_dealloc_has_cluster(&dealloc)) {
+		ocfs2_schedule_truncate_log_flush(osb, 1);
+		ocfs2_run_deallocs(osb, &dealloc);
+	}
+
+	return ret;
+}
+
+/* Lock an inode and grab a bh pointing to the inode. */
+static int ocfs2_reflink_inodes_lock(struct inode *s_inode,
+				     struct buffer_head **bh1,
+				     struct inode *t_inode,
+				     struct buffer_head **bh2)
+{
+	struct inode *inode1;
+	struct inode *inode2;
+	struct ocfs2_inode_info *oi1;
+	struct ocfs2_inode_info *oi2;
+	bool same_inode = (s_inode == t_inode);
+	int status;
+
+	/* First grab the VFS and rw locks. */
+	lock_two_nondirectories(s_inode, t_inode);
+	inode1 = s_inode;
+	inode2 = t_inode;
+	if (inode1->i_ino > inode2->i_ino)
+		swap(inode1, inode2);
+
+	status = ocfs2_rw_lock(inode1, 1);
+	if (status) {
+		mlog_errno(status);
+		goto out_i1;
+	}
+	if (!same_inode) {
+		status = ocfs2_rw_lock(inode2, 1);
+		if (status) {
+			mlog_errno(status);
+			goto out_i2;
+		}
+	}
+
+	/* Now go for the cluster locks */
+	oi1 = OCFS2_I(inode1);
+	oi2 = OCFS2_I(inode2);
+
+	trace_ocfs2_double_lock((unsigned long long)oi1->ip_blkno,
+				(unsigned long long)oi2->ip_blkno);
+
+	if (*bh1)
+		*bh1 = NULL;
+	if (*bh2)
+		*bh2 = NULL;
+
+	/* We always want to lock the one with the lower lockid first. */
+	if (oi1->ip_blkno > oi2->ip_blkno)
+		mlog_errno(-ENOLCK);
+
+	/* lock id1 */
+	status = ocfs2_inode_lock_nested(inode1, bh1, 1, OI_LS_REFLINK_TARGET);
+	if (status < 0) {
+		if (status != -ENOENT)
+			mlog_errno(status);
+		goto out_rw2;
+	}
+
+	/* lock id2 */
+	if (!same_inode) {
+		status = ocfs2_inode_lock_nested(inode2, bh2, 1,
+						 OI_LS_REFLINK_TARGET);
+		if (status < 0) {
+			if (status != -ENOENT)
+				mlog_errno(status);
+			goto out_cl1;
+		}
+	} else
+		*bh2 = *bh1;
+
+	trace_ocfs2_double_lock_end(
+			(unsigned long long)OCFS2_I(inode1)->ip_blkno,
+			(unsigned long long)OCFS2_I(inode2)->ip_blkno);
+
+	return 0;
+
+out_cl1:
+	ocfs2_inode_unlock(inode1, 1);
+	brelse(*bh1);
+	*bh1 = NULL;
+out_rw2:
+	ocfs2_rw_unlock(inode2, 1);
+out_i2:
+	ocfs2_rw_unlock(inode1, 1);
+out_i1:
+	unlock_two_nondirectories(s_inode, t_inode);
+	return status;
+}
+
+/* Unlock both inodes and release buffers. */
+static void ocfs2_reflink_inodes_unlock(struct inode *s_inode,
+					struct buffer_head *s_bh,
+					struct inode *t_inode,
+					struct buffer_head *t_bh)
+{
+	ocfs2_inode_unlock(s_inode, 1);
+	ocfs2_rw_unlock(s_inode, 1);
+	brelse(s_bh);
+	if (s_inode == t_inode) {
+		ocfs2_inode_unlock(t_inode, 1);
+		ocfs2_rw_unlock(t_inode, 1);
+		brelse(t_bh);
+	}
+	unlock_two_nondirectories(s_inode, t_inode);
+}
+
+/*
+ * Read a page's worth of file data into the page cache.  Return the page
+ * locked.
+ */
+static struct page *ocfs2_reflink_get_page(struct inode *inode,
+					   loff_t offset)
+{
+	struct address_space *mapping;
+	struct page *page;
+	pgoff_t n;
+
+	n = offset >> PAGE_SHIFT;
+	mapping = inode->i_mapping;
+	page = read_mapping_page(mapping, n, NULL);
+	if (IS_ERR(page))
+		return page;
+	if (!PageUptodate(page)) {
+		put_page(page);
+		return ERR_PTR(-EIO);
+	}
+	lock_page(page);
+	return page;
+}
+
+/*
+ * Compare extents of two files to see if they are the same.
+ */
+static int ocfs2_reflink_compare_extents(struct inode *src,
+					 loff_t srcoff,
+					 struct inode *dest,
+					 loff_t destoff,
+					 loff_t len,
+					 bool *is_same)
+{
+	loff_t src_poff;
+	loff_t dest_poff;
+	void *src_addr;
+	void *dest_addr;
+	struct page *src_page;
+	struct page *dest_page;
+	loff_t cmp_len;
+	bool same;
+	int error;
+
+	error = -EINVAL;
+	same = true;
+	while (len) {
+		src_poff = srcoff & (PAGE_SIZE - 1);
+		dest_poff = destoff & (PAGE_SIZE - 1);
+		cmp_len = min(PAGE_SIZE - src_poff,
+			      PAGE_SIZE - dest_poff);
+		cmp_len = min(cmp_len, len);
+		if (cmp_len <= 0) {
+			mlog_errno(-EUCLEAN);
+			goto out_error;
+		}
+
+		src_page = ocfs2_reflink_get_page(src, srcoff);
+		if (IS_ERR(src_page)) {
+			error = PTR_ERR(src_page);
+			goto out_error;
+		}
+		dest_page = ocfs2_reflink_get_page(dest, destoff);
+		if (IS_ERR(dest_page)) {
+			error = PTR_ERR(dest_page);
+			unlock_page(src_page);
+			put_page(src_page);
+			goto out_error;
+		}
+		src_addr = kmap_atomic(src_page);
+		dest_addr = kmap_atomic(dest_page);
+
+		flush_dcache_page(src_page);
+		flush_dcache_page(dest_page);
+
+		if (memcmp(src_addr + src_poff, dest_addr + dest_poff, cmp_len))
+			same = false;
+
+		kunmap_atomic(dest_addr);
+		kunmap_atomic(src_addr);
+		unlock_page(dest_page);
+		unlock_page(src_page);
+		put_page(dest_page);
+		put_page(src_page);
+
+		if (!same)
+			break;
+
+		srcoff += cmp_len;
+		destoff += cmp_len;
+		len -= cmp_len;
+	}
+
+	*is_same = same;
+	return 0;
+
+out_error:
+	return error;
+}
+
+/* Link a range of blocks from one file to another. */
+int ocfs2_reflink_remap_range(struct file *file_in,
+			      loff_t pos_in,
+			      struct file *file_out,
+			      loff_t pos_out,
+			      u64 len,
+			      bool is_dedupe)
+{
+	struct inode *inode_in = file_inode(file_in);
+	struct inode *inode_out = file_inode(file_out);
+	struct ocfs2_super *osb = OCFS2_SB(inode_in->i_sb);
+	struct buffer_head *in_bh = NULL, *out_bh = NULL;
+	loff_t bs = 1 << OCFS2_SB(inode_in->i_sb)->s_clustersize_bits;
+	bool same_inode = (inode_in == inode_out);
+	bool is_same = false;
+	loff_t isize;
+	ssize_t ret;
+	loff_t blen;
+
+	if (!ocfs2_refcount_tree(osb))
+		return -EOPNOTSUPP;
+	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
+		return -EROFS;
+
+	/* Lock both files against IO */
+	ret = ocfs2_reflink_inodes_lock(inode_in, &in_bh, inode_out, &out_bh);
+	if (ret)
+		return ret;
+
+	ret = -EINVAL;
+	if ((OCFS2_I(inode_in)->ip_flags & OCFS2_INODE_SYSTEM_FILE) ||
+	    (OCFS2_I(inode_out)->ip_flags & OCFS2_INODE_SYSTEM_FILE))
+		goto out_unlock;
+
+	/* Don't touch certain kinds of inodes */
+	ret = -EPERM;
+	if (IS_IMMUTABLE(inode_out))
+		goto out_unlock;
+
+	ret = -ETXTBSY;
+	if (IS_SWAPFILE(inode_in) || IS_SWAPFILE(inode_out))
+		goto out_unlock;
+
+	/* Don't reflink dirs, pipes, sockets... */
+	ret = -EISDIR;
+	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
+		goto out_unlock;
+	ret = -EINVAL;
+	if (S_ISFIFO(inode_in->i_mode) || S_ISFIFO(inode_out->i_mode))
+		goto out_unlock;
+	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
+		goto out_unlock;
+
+	/* Are we going all the way to the end? */
+	isize = i_size_read(inode_in);
+	if (isize == 0) {
+		ret = 0;
+		goto out_unlock;
+	}
+
+	/* Zero length dedupe exits immediately; reflink goes to EOF. */
+	if (len == 0) {
+		if (is_dedupe) {
+			ret = 0;
+			goto out_unlock;
+		}
+		len = isize - pos_in;
+	}
+
+	/* Ensure offsets don't wrap and the input is inside i_size */
+	if (pos_in + len < pos_in || pos_out + len < pos_out ||
+	    pos_in + len > isize)
+		goto out_unlock;
+
+	/* Don't allow dedupe past EOF in the dest file */
+	if (is_dedupe) {
+		loff_t	disize;
+
+		disize = i_size_read(inode_out);
+		if (pos_out >= disize || pos_out + len > disize)
+			goto out_unlock;
+	}
+
+	/* If we're linking to EOF, continue to the block boundary. */
+	if (pos_in + len == isize)
+		blen = ALIGN(isize, bs) - pos_in;
+	else
+		blen = len;
+
+	/* Only reflink if we're aligned to block boundaries */
+	if (!IS_ALIGNED(pos_in, bs) || !IS_ALIGNED(pos_in + blen, bs) ||
+	    !IS_ALIGNED(pos_out, bs) || !IS_ALIGNED(pos_out + blen, bs))
+		goto out_unlock;
+
+	/* Don't allow overlapped reflink within the same file */
+	if (same_inode) {
+		if (pos_out + blen > pos_in && pos_out < pos_in + blen)
+			goto out_unlock;
+	}
+
+	/* Wait for the completion of any pending IOs on both files */
+	inode_dio_wait(inode_in);
+	if (!same_inode)
+		inode_dio_wait(inode_out);
+
+	ret = filemap_write_and_wait_range(inode_in->i_mapping,
+			pos_in, pos_in + len - 1);
+	if (ret)
+		goto out_unlock;
+
+	ret = filemap_write_and_wait_range(inode_out->i_mapping,
+			pos_out, pos_out + len - 1);
+	if (ret)
+		goto out_unlock;
+
+	/*
+	 * Check that the extents are the same.
+	 */
+	if (is_dedupe) {
+		ret = ocfs2_reflink_compare_extents(inode_in, pos_in,
+						    inode_out, pos_out,
+						    len, &is_same);
+		if (ret)
+			goto out_unlock;
+		if (!is_same) {
+			ret = -EBADE;
+			goto out_unlock;
+		}
+	}
+
+	/* Lock out changes to the allocation maps */
+	down_write(&OCFS2_I(inode_in)->ip_alloc_sem);
+	if (!same_inode)
+		down_write_nested(&OCFS2_I(inode_out)->ip_alloc_sem,
+				  SINGLE_DEPTH_NESTING);
+
+	/*
+	 * Invalidate the page cache so that we can clear any CoW mappings
+	 * in the destination file.
+	 */
+	truncate_inode_pages_range(&inode_out->i_data, pos_out,
+				   PAGE_ALIGN(pos_out + len) - 1);
+
+	ret = ocfs2_reflink_remap_blocks(inode_in, in_bh, pos_in, inode_out,
+					 out_bh, pos_out, len);
+
+	up_write(&OCFS2_I(inode_in)->ip_alloc_sem);
+	if (!same_inode)
+		up_write(&OCFS2_I(inode_out)->ip_alloc_sem);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_unlock;
+	}
+
+	/*
+	 * Empty the extent map so that we may get the right extent
+	 * record from the disk.
+	 */
+	ocfs2_extent_map_trunc(inode_in, 0);
+	ocfs2_extent_map_trunc(inode_out, 0);
+
+	ret = ocfs2_reflink_update_dest(inode_out, out_bh, pos_out + len);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_unlock;
+	}
+
+	ocfs2_reflink_inodes_unlock(inode_in, in_bh, inode_out, out_bh);
+	return 0;
+
+out_unlock:
+	ocfs2_reflink_inodes_unlock(inode_in, in_bh, inode_out, out_bh);
+	return ret;
+}
diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
index 6422bbc..4af55bf 100644
--- a/fs/ocfs2/refcounttree.h
+++ b/fs/ocfs2/refcounttree.h
@@ -115,4 +115,11 @@ int ocfs2_reflink_ioctl(struct inode *inode,
 			const char __user *oldname,
 			const char __user *newname,
 			bool preserve);
+int ocfs2_reflink_remap_range(struct file *file_in,
+			      loff_t pos_in,
+			      struct file *file_out,
+			      loff_t pos_out,
+			      u64 len,
+			      bool is_dedupe);
+
 #endif /* OCFS2_REFCOUNTTREE_H */
