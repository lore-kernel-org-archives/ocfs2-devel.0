From: Joel Becker <joel.becker@oracle.com>
Date: Wed,  7 Jul 2010 04:16:06 -0700
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: Zero the tail cluster when
	extending past i_size.
In-Reply-To: <20100703213219.GB21262@mail.oracle.com>
References: <20100703213219.GB21262@mail.oracle.com>
Message-ID: <1278501367-7710-3-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Tao Ma <tao.ma@oracle.com>, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>

ocfs2's allocation unit is the cluster.  This can be larger than a block
or even a memory page.  This means that a file may have many blocks in
its last extent that are beyond the block containing i_size.  There also
may be more unwritten extents after that.

When ocfs2 grows a file, it zeros the entire cluster in order to ensure
future i_size growth will see cleared blocks.  Unfortunately,
block_write_full_page() drops the pages past i_size.  This means that
ocfs2 is actually leaking garbage data into the tail end of that last
cluster.  This is a bug.

We adjust ocfs2_write_begin_nolock() and ocfs2_extend_file() to detect
when a write or truncate is past i_size.  They will use
ocfs2_zero_extend() to ensure the data is properly zeroed.

Older versions of ocfs2_zero_extend() simply zeroed every block between
i_size and the zeroing position.  This presumes three things:

1) There is allocation for all of these blocks.
2) The extents are not unwritten.
3) The extents are not refcounted.

(1) and (2) hold true for non-sparse filesystems, which used to be the
only users of ocfs2_zero_extend().  (3) is another bug.

Since we're now using ocfs2_zero_extend() for sparse filesystems as
well, we teach ocfs2_zero_extend() to check every extent between
i_size and the zeroing position.  If the extent is unwritten, it is
ignored.  If it is refcounted, it is CoWed.  Then it is zeroed.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/aops.c         |   30 ++++----
 fs/ocfs2/file.c         |  198 ++++++++++++++++++++++++++++++++++++++--------
 fs/ocfs2/file.h         |    6 +-
 fs/ocfs2/quota_global.c |    2 +-
 fs/ocfs2/quota_local.c  |    4 +-
 fs/ocfs2/refcounttree.c |    6 ++
 6 files changed, 192 insertions(+), 54 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 9a5c931..8d6dc3f 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -196,15 +196,14 @@ int ocfs2_get_block(struct inode *inode, sector_t iblock,
 			dump_stack();
 			goto bail;
 		}
-
-		past_eof = ocfs2_blocks_for_bytes(inode->i_sb, i_size_read(inode));
-		mlog(0, "Inode %lu, past_eof = %llu\n", inode->i_ino,
-		     (unsigned long long)past_eof);
-
-		if (create && (iblock >= past_eof))
-			set_buffer_new(bh_result);
 	}
 
+	past_eof = ocfs2_blocks_for_bytes(inode->i_sb, i_size_read(inode));
+	mlog(0, "Inode %lu, past_eof = %llu\n", inode->i_ino,
+	     (unsigned long long)past_eof);
+	if (create && (iblock >= past_eof))
+		set_buffer_new(bh_result);
+
 bail:
 	if (err < 0)
 		err = -EIO;
@@ -1590,21 +1589,20 @@ out:
  * write path can treat it as an non-allocating write, which has no
  * special case code for sparse/nonsparse files.
  */
-static int ocfs2_expand_nonsparse_inode(struct inode *inode, loff_t pos,
-					unsigned len,
+static int ocfs2_expand_nonsparse_inode(struct inode *inode,
+					struct buffer_head *di_bh,
+					loff_t pos, unsigned len,
 					struct ocfs2_write_ctxt *wc)
 {
 	int ret;
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	loff_t newsize = pos + len;
 
-	if (ocfs2_sparse_alloc(osb))
-		return 0;
+	BUG_ON(ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)));
 
 	if (newsize <= i_size_read(inode))
 		return 0;
 
-	ret = ocfs2_extend_no_holes(inode, newsize, pos);
+	ret = ocfs2_extend_no_holes(inode, di_bh, newsize, pos);
 	if (ret)
 		mlog_errno(ret);
 
@@ -1649,7 +1647,11 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 		}
 	}
 
-	ret = ocfs2_expand_nonsparse_inode(inode, pos, len, wc);
+	if (ocfs2_sparse_alloc(osb))
+		ret = ocfs2_zero_extend(inode, di_bh, pos);
+	else
+		ret = ocfs2_expand_nonsparse_inode(inode, di_bh, pos, len,
+						   wc);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index a6e0eb6..1fdc45a 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -787,6 +787,11 @@ static int ocfs2_write_zero_page(struct inode *inode, u64 abs_from,
 	if (!zero_to)
 		zero_to = PAGE_CACHE_SIZE;
 
+	mlog(0,
+	     "abs_from = %llu, abs_to = %llu, index = %lu, zero_from = %u, zero_to = %u\n",
+	     (unsigned long long)abs_from, (unsigned long long)abs_to,
+	     index, zero_from, zero_to);
+
 	/* We know that zero_from is block aligned */
 	for (block_start = zero_from;
 	     (block_start < PAGE_CACHE_SIZE) && (block_start < zero_to);
@@ -834,25 +839,114 @@ out:
 	return ret;
 }
 
-static int ocfs2_zero_extend(struct inode *inode,
-			     u64 zero_to_size)
+/*
+ * Find the next range to zero.  We do this in terms of bytes because
+ * that's what ocfs2_zero_extend() wants, and it is dealing with the
+ * pagecache.  We may return multiple extents.
+ *
+ * zero_start and zero_end are ocfs2_zero_extend()s current idea of what
+ * needs to be zeroed.  range_start and range_end return the next zeroing
+ * range.  A subsequent call should pass the previous range_end as its
+ * zero_start.  If range_end is 0, there's nothing to do.
+ *
+ * Unwritten extents are skipped over.  Refcounted extents are CoWd.
+ */
+static int ocfs2_zero_extend_get_range(struct inode *inode,
+				       struct buffer_head *di_bh,
+				       u64 zero_start, u64 zero_end,
+				       u64 *range_start, u64 *range_end)
 {
-	int ret = 0;
-	u64 start_off, next_off;
-	struct super_block *sb = inode->i_sb;
+	int rc = 0, needs_cow = 0;
+	u32 p_cpos, zero_clusters = 0;
+	u32 zero_cpos =
+		zero_start >> OCFS2_SB(inode->i_sb)->s_clustersize_bits;
+	u32 last_cpos = ocfs2_clusters_for_bytes(inode->i_sb, zero_end);
+	unsigned int num_clusters = 0;
+	unsigned int ext_flags = 0;
 
-	start_off = ocfs2_align_bytes_to_blocks(sb, i_size_read(inode));
-	while (start_off < zero_to_size) {
-		next_off = (start_off & PAGE_CACHE_MASK) + PAGE_CACHE_SIZE;
-		if (next_off > zero_to_size)
-			next_off = zero_to_size;
-		ret = ocfs2_write_zero_page(inode, start_off, next_off);
-		if (ret < 0) {
-			mlog_errno(ret);
+	while (zero_cpos < last_cpos) {
+		rc = ocfs2_get_clusters(inode, zero_cpos, &p_cpos,
+					&num_clusters, &ext_flags);
+		if (rc) {
+			mlog_errno(rc);
+			goto out;
+		}
+
+		if (p_cpos && !(ext_flags & OCFS2_EXT_UNWRITTEN)) {
+			zero_clusters = num_clusters;
+			if (ext_flags & OCFS2_EXT_REFCOUNTED)
+				needs_cow = 1;
+			break;
+		}
+
+		zero_cpos += num_clusters;
+	}
+	if (!zero_clusters) {
+		*range_end = 0;
+		goto out;
+	}
+
+	while ((zero_cpos + zero_clusters) < last_cpos) {
+		rc = ocfs2_get_clusters(inode, zero_cpos + zero_clusters,
+					&p_cpos, &num_clusters,
+					&ext_flags);
+		if (rc) {
+			mlog_errno(rc);
+			goto out;
+		}
+
+		if (!p_cpos || (ext_flags & OCFS2_EXT_UNWRITTEN))
+			break;
+		if (ext_flags & OCFS2_EXT_REFCOUNTED)
+			needs_cow = 1;
+		zero_clusters += num_clusters;
+	}
+	if ((zero_cpos + zero_clusters) > last_cpos)
+		zero_clusters = last_cpos - zero_cpos;
+
+	if (needs_cow) {
+		rc = ocfs2_refcount_cow(inode, di_bh, zero_cpos, zero_clusters,
+					UINT_MAX);
+		if (rc) {
+			mlog_errno(rc);
 			goto out;
 		}
+	}
 
-		start_off = next_off;
+	*range_start = ocfs2_clusters_to_bytes(inode->i_sb, zero_cpos);
+	*range_end = ocfs2_clusters_to_bytes(inode->i_sb,
+					     zero_cpos + zero_clusters);
+
+out:
+	return rc;
+}
+
+/*
+ * Zero one range returned from ocfs2_zero_extend_get_range().  The caller
+ * has made sure that the entire range needs zeroing.
+ */
+static int ocfs2_zero_extend_range(struct inode *inode, u64 range_start,
+				   u64 range_end)
+{
+	int rc = 0;
+	u64 next_pos;
+	u64 zero_pos = range_start;
+
+	mlog(0, "range_start = %llu, range_end = %llu\n",
+	     (unsigned long long)range_start,
+	     (unsigned long long)range_end);
+	BUG_ON(range_start >= range_end);
+
+	while (zero_pos < range_end) {
+		next_pos = (zero_pos & PAGE_CACHE_MASK) + PAGE_CACHE_SIZE;
+		if (next_pos > range_end)
+			next_pos = range_end;
+		rc = ocfs2_write_zero_page(inode, zero_pos, next_pos);
+		if (rc < 0) {
+			mlog_errno(rc);
+			break;
+		}
+		zero_pos = next_pos;
 
 		/*
 		 * Very large extends have the potential to lock up
@@ -861,16 +955,60 @@ static int ocfs2_zero_extend(struct inode *inode,
 		cond_resched();
 	}
 
-out:
+	return rc;
+}
+
+int ocfs2_zero_extend(struct inode *inode, struct buffer_head *di_bh,
+		      loff_t zero_to_size)
+{
+	int ret = 0;
+	u64 zero_start, range_start = 0, range_end = 0;
+	struct super_block *sb = inode->i_sb;
+
+	zero_start = ocfs2_align_bytes_to_blocks(sb, i_size_read(inode));
+	while (zero_start < zero_to_size) {
+		ret = ocfs2_zero_extend_get_range(inode, di_bh, zero_start,
+						  zero_to_size,
+						  &range_start,
+						  &range_end);
+		if (ret) {
+			mlog_errno(ret);
+			break;
+		}
+		if (!range_end)
+			break;
+		/* Trim the ends */
+		if (range_start < zero_start)
+			range_start = zero_start;
+		if (range_end > zero_to_size)
+			range_end = zero_to_size;
+
+		ret = ocfs2_zero_extend_range(inode, range_start,
+					      range_end);
+		if (ret) {
+			mlog_errno(ret);
+			break;
+		}
+		zero_start = range_end;
+	}
+
 	return ret;
 }
 
-int ocfs2_extend_no_holes(struct inode *inode, u64 new_i_size, u64 zero_to)
+int ocfs2_extend_no_holes(struct inode *inode, struct buffer_head *di_bh,
+			  u64 new_i_size, u64 zero_to)
 {
 	int ret;
 	u32 clusters_to_add;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 
+	/*
+	 * Only quota files call this without a bh, and they can't be
+	 * refcounted.
+	 */
+	BUG_ON(!di_bh && (oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL));
+	BUG_ON(!di_bh && !(oi->ip_flags & OCFS2_INODE_SYSTEM_FILE));
+
 	clusters_to_add = ocfs2_clusters_for_bytes(inode->i_sb, new_i_size);
 	if (clusters_to_add < oi->ip_clusters)
 		clusters_to_add = 0;
@@ -891,7 +1029,7 @@ int ocfs2_extend_no_holes(struct inode *inode, u64 new_i_size, u64 zero_to)
 	 * still need to zero the area between the old i_size and the
 	 * new i_size.
 	 */
-	ret = ocfs2_zero_extend(inode, zero_to);
+	ret = ocfs2_zero_extend(inode, di_bh, zero_to);
 	if (ret < 0)
 		mlog_errno(ret);
 
@@ -913,27 +1051,15 @@ static int ocfs2_extend_file(struct inode *inode,
 		goto out;
 
 	if (i_size_read(inode) == new_i_size)
-  		goto out;
+		goto out;
 	BUG_ON(new_i_size < i_size_read(inode));
 
 	/*
-	 * Fall through for converting inline data, even if the fs
-	 * supports sparse files.
-	 *
-	 * The check for inline data here is legal - nobody can add
-	 * the feature since we have i_mutex. We must check it again
-	 * after acquiring ip_alloc_sem though, as paths like mmap
-	 * might have raced us to converting the inode to extents.
-	 */
-	if (!(oi->ip_dyn_features & OCFS2_INLINE_DATA_FL)
-	    && ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)))
-		goto out_update_size;
-
-	/*
 	 * The alloc sem blocks people in read/write from reading our
 	 * allocation until we're done changing it. We depend on
 	 * i_mutex to block other extend/truncate calls while we're
-	 * here.
+	 * here.  We even have to hold it for sparse files because there
+	 * might be some tail zeroing.
 	 */
 	down_write(&oi->ip_alloc_sem);
 
@@ -950,14 +1076,16 @@ static int ocfs2_extend_file(struct inode *inode,
 		ret = ocfs2_convert_inline_data_to_extents(inode, di_bh);
 		if (ret) {
 			up_write(&oi->ip_alloc_sem);
-
 			mlog_errno(ret);
 			goto out;
 		}
 	}
 
-	if (!ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)))
-		ret = ocfs2_extend_no_holes(inode, new_i_size, new_i_size);
+	if (ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)))
+		ret = ocfs2_zero_extend(inode, di_bh, new_i_size);
+	else
+		ret = ocfs2_extend_no_holes(inode, di_bh, new_i_size,
+					    new_i_size);
 
 	up_write(&oi->ip_alloc_sem);
 
diff --git a/fs/ocfs2/file.h b/fs/ocfs2/file.h
index d66cf4f..97bf761 100644
--- a/fs/ocfs2/file.h
+++ b/fs/ocfs2/file.h
@@ -54,8 +54,10 @@ int ocfs2_add_inode_data(struct ocfs2_super *osb,
 int ocfs2_simple_size_update(struct inode *inode,
 			     struct buffer_head *di_bh,
 			     u64 new_i_size);
-int ocfs2_extend_no_holes(struct inode *inode, u64 new_i_size,
-			  u64 zero_to);
+int ocfs2_extend_no_holes(struct inode *inode, struct buffer_head *di_bh,
+			  u64 new_i_size, u64 zero_to);
+int ocfs2_zero_extend(struct inode *inode, struct buffer_head *di_bh,
+		      loff_t zero_to);
 int ocfs2_setattr(struct dentry *dentry, struct iattr *attr);
 int ocfs2_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		  struct kstat *stat);
diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index 2bb35fe..4607923 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -775,7 +775,7 @@ static int ocfs2_acquire_dquot(struct dquot *dquot)
 		 * locking allocators ranks above a transaction start
 		 */
 		WARN_ON(journal_current_handle());
-		status = ocfs2_extend_no_holes(gqinode,
+		status = ocfs2_extend_no_holes(gqinode, NULL,
 			gqinode->i_size + (need_alloc << sb->s_blocksize_bits),
 			gqinode->i_size);
 		if (status < 0)
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 8bd70d4..dc78764 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -971,7 +971,7 @@ static struct ocfs2_quota_chunk *ocfs2_local_quota_add_chunk(
 	u64 p_blkno;
 
 	/* We are protected by dqio_sem so no locking needed */
-	status = ocfs2_extend_no_holes(lqinode,
+	status = ocfs2_extend_no_holes(lqinode, NULL,
 				       lqinode->i_size + 2 * sb->s_blocksize,
 				       lqinode->i_size);
 	if (status < 0) {
@@ -1114,7 +1114,7 @@ static struct ocfs2_quota_chunk *ocfs2_extend_local_quota_file(
 		return ocfs2_local_quota_add_chunk(sb, type, offset);
 
 	/* We are protected by dqio_sem so no locking needed */
-	status = ocfs2_extend_no_holes(lqinode,
+	status = ocfs2_extend_no_holes(lqinode, NULL,
 				       lqinode->i_size + sb->s_blocksize,
 				       lqinode->i_size);
 	if (status < 0) {
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 4793f36..32949df 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -4166,6 +4166,12 @@ static int __ocfs2_reflink(struct dentry *old_dentry,
 	struct inode *inode = old_dentry->d_inode;
 	struct buffer_head *new_bh = NULL;
 
+	if (OCFS2_I(inode)->ip_flags & OCFS2_INODE_SYSTEM_FILE) {
+		ret = -EINVAL;
+		mlog_errno(ret);
+		goto out;
+	}
+
 	ret = filemap_fdatawrite(inode->i_mapping);
 	if (ret) {
 		mlog_errno(ret);
-- 
1.7.1
