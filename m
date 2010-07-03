From: Joel Becker <Joel.Becker@oracle.com>
Date: Sat, 3 Jul 2010 14:32:20 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: Zero the tail cluster when
 extending past i_size v2
In-Reply-To: <20100702224912.GC5800@mail.oracle.com>
References: <20100628173529.GA10573@mail.oracle.com>
	<20100629002421.GY6590@dastard>
	<20100629005403.GC24343@mail.oracle.com>
	<20100629015615.GZ6590@dastard>
	<20100629020420.GE24343@mail.oracle.com>
	<20100629022757.GA6590@dastard>
	<20100629071817.GA4150@mail.oracle.com>
	<20100702224912.GC5800@mail.oracle.com>
Message-ID: <20100703213219.GB21262@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Tao Ma <tao.ma@oracle.com>, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>

	Here's the second version of my corruption fix.  It fixes two
bugs:

1) i_size can obviously be at a place that is a hole, so don't BUG on
   that.
2) Fix an off-by-one when checking whether the write position is within
   the tail allocation.

This version passes my tail corruption test as well as the kernel
compile that exposed the two bugs above.  

Joel

---------------------------------------------------------------

ocfs2's allocation unit is the cluster.  This can be larger than a block
or even a memory page.  This means that a file may have many blocks in
its last extent that are beyond the block containing i_size.

When ocfs2 grows a file, it zeros the entire cluster in order to ensure
future i_size growth will see cleared blocks.  Unfortunately,
block_write_full_page() drops the pages past i_size.  This means that
ocfs2 is actually leaking garbage data into the tail end of that last
cluster.

We adjust ocfs2_write_begin_nolock() and ocfs2_extend_file() to detect
when a write or truncate is past i_size.  If there is any existing
allocation between the block containing the current i_size and the
location of the write or truncate, zeros will be written to that
allocation.

This is only for sparse filesystems.  Non-sparse filesystems already get
this via ocfs2_extend_no_holes().

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/aops.c |   22 ++++----
 fs/ocfs2/file.c |  154 +++++++++++++++++++++++++++++++++++++++++++++++++------
 fs/ocfs2/file.h |    2 +
 3 files changed, 150 insertions(+), 28 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 3623ca2..96e6aeb 100644
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
@@ -1625,11 +1624,9 @@ static int ocfs2_expand_nonsparse_inode(struct inode *inode, loff_t pos,
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
@@ -1679,7 +1676,10 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 		}
 	}
 
-	ret = ocfs2_expand_nonsparse_inode(inode, pos, len, wc);
+	if (ocfs2_sparse_alloc(osb))
+		ret = ocfs2_zero_tail(inode, di_bh, pos);
+	else
+		ret = ocfs2_expand_nonsparse_inode(inode, pos, len, wc);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 6a13ea6..7fca78d 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -848,6 +848,137 @@ out:
 	return ret;
 }
 
+/*
+ * This function is a helper for ocfs2_zero_tail().  It calculates
+ * what blocks need zeroing and does any CoW necessary.
+ */
+static int ocfs2_zero_tail_prepare(struct inode *inode,
+				   struct buffer_head *di_bh,
+				   loff_t pos, u64 *start_blkno,
+				   u64 *blocks)
+{
+	int rc = 0;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	u32 tail_cpos, pos_cpos, p_cpos;
+	u64 tail_blkno, pos_blkno, blocks_to_zero;
+	unsigned int num_clusters = 0;
+	unsigned int ext_flags = 0;
+
+	/*
+	 * The block containing i_size has already been zeroed, so our tail
+	 * block is the first block after i_size.  The block containing
+	 * pos will be zeroed.  So we only need to do anything if
+	 * tail_blkno is before pos_blkno.
+	 */
+	tail_blkno = (i_size_read(inode) >> inode->i_sb->s_blocksize_bits) + 1;
+	pos_blkno = pos >> inode->i_sb->s_blocksize_bits;
+	mlog(0, "tail_blkno = %llu, pos_blkno = %llu\n",
+	     (unsigned long long)tail_blkno, (unsigned long long)pos_blkno);
+	if (pos_blkno <= tail_blkno)
+		goto out;
+	blocks_to_zero = pos_blkno - tail_blkno;
+
+	/*
+	 * If tail_blkno is in the cluster past i_size, we don't need
+	 * to touch the cluster containing i_size@all.
+	 */
+	tail_cpos = i_size_read(inode) >> osb->s_clustersize_bits;
+	if (ocfs2_blocks_to_clusters(inode->i_sb, tail_blkno) > tail_cpos)
+		tail_cpos = ocfs2_blocks_to_clusters(inode->i_sb,
+						     tail_blkno);
+
+	rc = ocfs2_get_clusters(inode, tail_cpos, &p_cpos, &num_clusters,
+				&ext_flags);
+	if (rc) {
+		mlog_errno(rc);
+		goto out;
+	}
+
+	/* Is there a cluster to zero? */
+	if (!p_cpos)
+		goto out;
+
+	pos_cpos = pos >> osb->s_clustersize_bits;
+	mlog(0, "tail_cpos = %u, num_clusters = %u, pos_cpos = %u, tail_blkno = %llu, pos_blkno = %llu\n",
+	     (unsigned int)tail_cpos, (unsigned int)num_clusters,
+	     (unsigned int)pos_cpos, (unsigned long long)tail_blkno,
+	     (unsigned long long)pos_blkno);
+	if ((tail_cpos + num_clusters) > pos_cpos) {
+		num_clusters = pos_cpos - tail_cpos;
+		if (pos_blkno >
+		    ocfs2_clusters_to_blocks(inode->i_sb, pos_cpos))
+			num_clusters += 1;
+	} else {
+		blocks_to_zero =
+			ocfs2_clusters_to_blocks(inode->i_sb,
+						 tail_cpos + num_clusters);
+		blocks_to_zero -= tail_blkno;
+	}
+
+	/* Now CoW the clusters we're about to zero */
+	if (ext_flags & OCFS2_EXT_REFCOUNTED) {
+		rc = ocfs2_refcount_cow(inode, di_bh, tail_cpos,
+					num_clusters, UINT_MAX);
+		if (rc) {
+			mlog_errno(rc);
+			goto out;
+		}
+	}
+
+	*start_blkno = tail_blkno;
+	*blocks = blocks_to_zero;
+	mlog(0, "start_blkno = %llu, blocks = %llu\n",
+	     (unsigned long long)(*start_blkno),
+	     (unsigned long long)(*blocks));
+
+out:
+	return rc;
+}
+
+/*
+ * This function only does work for sparse filesystems.
+ * ocfs2_extend_no_holes() will do the same work for non-sparse * files.
+ *
+ * If the last extent of the file has blocks beyond i_size, we must zero
+ * them before we can grow i_size to cover them.  Specifically, any
+ * allocation between the block containing the current i_size and the block
+ * containing pos must be zeroed.
+ */
+int ocfs2_zero_tail(struct inode *inode, struct buffer_head *di_bh,
+		    loff_t pos)
+{
+	int rc = 0;
+	u64 tail_blkno = 0, blocks_to_zero = 0;
+
+	BUG_ON(!ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)));
+
+	rc = ocfs2_zero_tail_prepare(inode, di_bh, pos, &tail_blkno,
+				     &blocks_to_zero);
+	if (rc) {
+		mlog_errno(rc);
+		goto out;
+	}
+
+	if (!blocks_to_zero)
+		goto out;
+
+	mlog(0, "i_size = %llu, tail_blkno = %llu, blocks_to_zero = %llu, pos = %llu, zero_to = %llu\n",
+	     (unsigned long long)i_size_read(inode),
+	     (unsigned long long)tail_blkno,
+	     (unsigned long long)blocks_to_zero,
+	     (unsigned long long)pos,
+	     (unsigned long long)((tail_blkno + blocks_to_zero) <<
+				  inode->i_sb->s_blocksize_bits));
+	rc = ocfs2_zero_extend(inode,
+			       (tail_blkno + blocks_to_zero) <<
+			       inode->i_sb->s_blocksize_bits);
+	if (rc)
+		mlog_errno(rc);
+
+out:
+	return rc;
+}
+
 static int ocfs2_extend_file(struct inode *inode,
 			     struct buffer_head *di_bh,
 			     u64 new_i_size)
@@ -862,27 +993,15 @@ static int ocfs2_extend_file(struct inode *inode,
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
 
@@ -899,13 +1018,14 @@ static int ocfs2_extend_file(struct inode *inode,
 		ret = ocfs2_convert_inline_data_to_extents(inode, di_bh);
 		if (ret) {
 			up_write(&oi->ip_alloc_sem);
-
 			mlog_errno(ret);
 			goto out;
 		}
 	}
 
-	if (!ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)))
+	if (ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)))
+		ret = ocfs2_zero_tail(inode, di_bh, new_i_size);
+	else
 		ret = ocfs2_extend_no_holes(inode, new_i_size, new_i_size);
 
 	up_write(&oi->ip_alloc_sem);
diff --git a/fs/ocfs2/file.h b/fs/ocfs2/file.h
index d66cf4f..7493d97 100644
--- a/fs/ocfs2/file.h
+++ b/fs/ocfs2/file.h
@@ -56,6 +56,8 @@ int ocfs2_simple_size_update(struct inode *inode,
 			     u64 new_i_size);
 int ocfs2_extend_no_holes(struct inode *inode, u64 new_i_size,
 			  u64 zero_to);
+int ocfs2_zero_tail(struct inode *inode, struct buffer_head *di_bh,
+		    loff_t pos);
 int ocfs2_setattr(struct dentry *dentry, struct iattr *attr);
 int ocfs2_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		  struct kstat *stat);
-- 
1.7.1

-- 

"The lawgiver, of all beings, most owes the law allegiance.  He of all
 men should behave as though the law compelled him.  But it is the
 universal weakness of mankind that what we are given to administer we
 presently imagine we own."
        - H.G. Wells

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
