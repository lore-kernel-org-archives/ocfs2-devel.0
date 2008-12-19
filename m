From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 19 Dec 2008 13:53:59 -0800
Subject: [Ocfs2-devel] [PATCH 40/45] ocfs2: Validate metadata only when it's
	read from disk.
In-Reply-To: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
References: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
Message-ID: <1229723644-13630-41-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Joel Becker <joel.becker@oracle.com>

Add an optional validation hook to ocfs2_read_blocks().  Now the
validation function is only called when a block was actually read off of
disk.  It is not called when the buffer was in cache.

We add a buffer state bit BH_NeedsValidate to flag these buffers.  It
must always be one higher than the last JBD2 buffer state bit.

The dinode, dirblock, extent_block, and xattr_block validators are
lifted to this scheme directly.  The group_descriptor validator needs to
be split into two pieces.  The first part only needs the gd buffer and
is passed to ocfs2_read_block().  The second part requires the dinode as
well, and is called every time.  It's only 3 compares, so it's tiny.
This also allows us to clean up the non-fatal gd check used by resize.c.
It now has no magic argument.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/alloc.c          |   17 +++-----
 fs/ocfs2/buffer_head_io.c |   33 ++++++++++++++++-
 fs/ocfs2/buffer_head_io.h |   27 ++++++++-----
 fs/ocfs2/dir.c            |   13 ++----
 fs/ocfs2/inode.c          |   18 ++------
 fs/ocfs2/resize.c         |    2 +-
 fs/ocfs2/slot_map.c       |    4 +-
 fs/ocfs2/suballoc.c       |   91 +++++++++++++++++++++++++++++++-------------
 fs/ocfs2/suballoc.h       |   15 +++----
 fs/ocfs2/xattr.c          |   26 ++++++-------
 10 files changed, 149 insertions(+), 97 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index f430cc6..e823a27 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -684,6 +684,9 @@ static int ocfs2_validate_extent_block(struct super_block *sb,
 	struct ocfs2_extent_block *eb =
 		(struct ocfs2_extent_block *)bh->b_data;
 
+	mlog(0, "Validating extent block %llu\n",
+	     (unsigned long long)bh->b_blocknr);
+
 	if (!OCFS2_IS_VALID_EXTENT_BLOCK(eb)) {
 		ocfs2_error(sb,
 			    "Extent block #%llu has bad signature %.*s",
@@ -719,21 +722,13 @@ int ocfs2_read_extent_block(struct inode *inode, u64 eb_blkno,
 	int rc;
 	struct buffer_head *tmp = *bh;
 
-	rc = ocfs2_read_block(inode, eb_blkno, &tmp);
-	if (rc)
-		goto out;
-
-	rc = ocfs2_validate_extent_block(inode->i_sb, tmp);
-	if (rc) {
-		brelse(tmp);
-		goto out;
-	}
+	rc = ocfs2_read_block(inode, eb_blkno, &tmp,
+			      ocfs2_validate_extent_block);
 
 	/* If ocfs2_read_block() got us a new bh, pass it up. */
-	if (!*bh)
+	if (!rc && !*bh)
 		*bh = tmp;
 
-out:
 	return rc;
 }
 
diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index 3a178ec..0e9eed0 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -39,6 +39,19 @@
 
 #include "buffer_head_io.h"
 
+/*
+ * Bits on bh->b_state used by ocfs2.
+ *
+ * These MUST be after the JBD2 bits.  Currently BH_Unshadow is the last
+ * JBD2 bit.
+ */
+enum ocfs2_state_bits {
+	BH_NeedsValidate = BH_Unshadow + 1,
+};
+
+/* Expand the magic b_state functions */
+BUFFER_FNS(NeedsValidate, needs_validate);
+
 int ocfs2_write_block(struct ocfs2_super *osb, struct buffer_head *bh,
 		      struct inode *inode)
 {
@@ -166,7 +179,9 @@ bail:
 }
 
 int ocfs2_read_blocks(struct inode *inode, u64 block, int nr,
-		      struct buffer_head *bhs[], int flags)
+		      struct buffer_head *bhs[], int flags,
+		      int (*validate)(struct super_block *sb,
+				      struct buffer_head *bh))
 {
 	int status = 0;
 	int i, ignore_cache = 0;
@@ -298,6 +313,8 @@ int ocfs2_read_blocks(struct inode *inode, u64 block, int nr,
 
 			clear_buffer_uptodate(bh);
 			get_bh(bh); /* for end_buffer_read_sync() */
+			if (validate)
+				set_buffer_needs_validate(bh);
 			bh->b_end_io = end_buffer_read_sync;
 			submit_bh(READ, bh);
 			continue;
@@ -328,6 +345,20 @@ int ocfs2_read_blocks(struct inode *inode, u64 block, int nr,
 				bhs[i] = NULL;
 				continue;
 			}
+
+			if (buffer_needs_validate(bh)) {
+				/* We never set NeedsValidate if the
+				 * buffer was held by the journal, so
+				 * that better not have changed */
+				BUG_ON(buffer_jbd(bh));
+				clear_buffer_needs_validate(bh);
+				status = validate(inode->i_sb, bh);
+				if (status) {
+					put_bh(bh);
+					bhs[i] = NULL;
+					continue;
+				}
+			}
 		}
 
 		/* Always set the buffer in the cache, even if it was
diff --git a/fs/ocfs2/buffer_head_io.h b/fs/ocfs2/buffer_head_io.h
index 75e1dcb..c75d682 100644
--- a/fs/ocfs2/buffer_head_io.h
+++ b/fs/ocfs2/buffer_head_io.h
@@ -31,21 +31,24 @@
 void ocfs2_end_buffer_io_sync(struct buffer_head *bh,
 			     int uptodate);
 
-static inline int ocfs2_read_block(struct inode	       *inode,
-				   u64                  off,
-				   struct buffer_head **bh);
-
 int ocfs2_write_block(struct ocfs2_super          *osb,
 		      struct buffer_head  *bh,
 		      struct inode        *inode);
-int ocfs2_read_blocks(struct inode	  *inode,
-		      u64                  block,
-		      int                  nr,
-		      struct buffer_head  *bhs[],
-		      int                  flags);
 int ocfs2_read_blocks_sync(struct ocfs2_super *osb, u64 block,
 			   unsigned int nr, struct buffer_head *bhs[]);
 
+/*
+ * If not NULL, validate() will be called on a buffer that is freshly
+ * read from disk.  It will not be called if the buffer was in cache.
+ * Note that if validate() is being used for this buffer, it needs to
+ * be set even for a READAHEAD call, as it marks the buffer for later
+ * validation.
+ */
+int ocfs2_read_blocks(struct inode *inode, u64 block, int nr,
+		      struct buffer_head *bhs[], int flags,
+		      int (*validate)(struct super_block *sb,
+				      struct buffer_head *bh));
+
 int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
 				struct buffer_head *bh);
 
@@ -53,7 +56,9 @@ int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
 #define OCFS2_BH_READAHEAD         8
 
 static inline int ocfs2_read_block(struct inode *inode, u64 off,
-				   struct buffer_head **bh)
+				   struct buffer_head **bh,
+				   int (*validate)(struct super_block *sb,
+						   struct buffer_head *bh))
 {
 	int status = 0;
 
@@ -63,7 +68,7 @@ static inline int ocfs2_read_block(struct inode *inode, u64 off,
 		goto bail;
 	}
 
-	status = ocfs2_read_blocks(inode, off, 1, bh, 0);
+	status = ocfs2_read_blocks(inode, off, 1, bh, 0, validate);
 
 bail:
 	return status;
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index c2f3fd9..7e863d4 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -214,6 +214,8 @@ static int ocfs2_validate_dir_block(struct super_block *sb,
 	 * Nothing yet.  We don't validate dirents here, that's handled
 	 * in-place when the code walks them.
 	 */
+	mlog(0, "Validating dirblock %llu\n",
+	     (unsigned long long)bh->b_blocknr);
 
 	return 0;
 }
@@ -255,20 +257,13 @@ static int ocfs2_read_dir_block(struct inode *inode, u64 v_block,
 		goto out;
 	}
 
-	rc = ocfs2_read_blocks(inode, p_blkno, 1, &tmp, flags);
+	rc = ocfs2_read_blocks(inode, p_blkno, 1, &tmp, flags,
+			       ocfs2_validate_dir_block);
 	if (rc) {
 		mlog_errno(rc);
 		goto out;
 	}
 
-	if (!(flags & OCFS2_BH_READAHEAD)) {
-		rc = ocfs2_validate_dir_block(inode->i_sb, tmp);
-		if (rc) {
-			brelse(tmp);
-			goto out;
-		}
-	}
-
 	/* If ocfs2_read_blocks() got us a new bh, pass it up.  */
 	if (!*bh)
 		*bh = tmp;
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 9eb701b..ec3497b 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1255,6 +1255,9 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 	int rc = -EINVAL;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)bh->b_data;
 
+	mlog(0, "Validating dinode %llu\n",
+	     (unsigned long long)bh->b_blocknr);
+
 	BUG_ON(!buffer_uptodate(bh));
 
 	if (!OCFS2_IS_VALID_DINODE(di)) {
@@ -1300,23 +1303,12 @@ int ocfs2_read_inode_block_full(struct inode *inode, struct buffer_head **bh,
 	struct buffer_head *tmp = *bh;
 
 	rc = ocfs2_read_blocks(inode, OCFS2_I(inode)->ip_blkno, 1, &tmp,
-			       flags);
-	if (rc)
-		goto out;
-
-	if (!(flags & OCFS2_BH_READAHEAD)) {
-		rc = ocfs2_validate_inode_block(inode->i_sb, tmp);
-		if (rc) {
-			brelse(tmp);
-			goto out;
-		}
-	}
+			       flags, ocfs2_validate_inode_block);
 
 	/* If ocfs2_read_blocks() got us a new bh, pass it up. */
-	if (!*bh)
+	if (!rc && !*bh)
 		*bh = tmp;
 
-out:
 	return rc;
 }
 
diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index 252baff..867de3e 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -394,7 +394,7 @@ static int ocfs2_check_new_group(struct inode *inode,
 		(struct ocfs2_group_desc *)group_bh->b_data;
 	u16 cl_bpc = le16_to_cpu(di->id2.i_chain.cl_bpc);
 
-	ret = ocfs2_validate_group_descriptor(inode->i_sb, di, group_bh, 1);
+	ret = ocfs2_check_group_descriptor(inode->i_sb, di, group_bh);
 	if (ret)
 		goto out;
 
diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index bdda2d8..40661e7 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -151,7 +151,7 @@ int ocfs2_refresh_slot_info(struct ocfs2_super *osb)
 	 * this is not true, the read of -1 (UINT64_MAX) will fail.
 	 */
 	ret = ocfs2_read_blocks(si->si_inode, -1, si->si_blocks, si->si_bh,
-				OCFS2_BH_IGNORE_CACHE);
+				OCFS2_BH_IGNORE_CACHE, NULL);
 	if (ret == 0) {
 		spin_lock(&osb->osb_lock);
 		ocfs2_update_slot_info(si);
@@ -405,7 +405,7 @@ static int ocfs2_map_slot_buffers(struct ocfs2_super *osb,
 
 		bh = NULL;  /* Acquire a fresh bh */
 		status = ocfs2_read_blocks(si->si_inode, blkno, 1, &bh,
-					   OCFS2_BH_IGNORE_CACHE);
+					   OCFS2_BH_IGNORE_CACHE, NULL);
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail;
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 766a00b..226fe21 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -145,14 +145,6 @@ static u32 ocfs2_bits_per_group(struct ocfs2_chain_list *cl)
 	return (u32)le16_to_cpu(cl->cl_cpg) * (u32)le16_to_cpu(cl->cl_bpc);
 }
 
-int ocfs2_validate_group_descriptor(struct super_block *sb,
-				    struct ocfs2_dinode *di,
-				    struct buffer_head *bh,
-				    int clean_error)
-{
-	unsigned int max_bits;
-	struct ocfs2_group_desc *gd = (struct ocfs2_group_desc *)bh->b_data;
-
 #define do_error(fmt, ...)						\
 	do{								\
 		if (clean_error)					\
@@ -161,6 +153,12 @@ int ocfs2_validate_group_descriptor(struct super_block *sb,
 			ocfs2_error(sb, fmt, ##__VA_ARGS__);		\
 	} while (0)
 
+static int ocfs2_validate_gd_self(struct super_block *sb,
+				  struct buffer_head *bh,
+				  int clean_error)
+{
+	struct ocfs2_group_desc *gd = (struct ocfs2_group_desc *)bh->b_data;
+
 	if (!OCFS2_IS_VALID_GROUP_DESC(gd)) {
 		do_error("Group descriptor #%llu has bad signature %.*s",
 			 (unsigned long long)bh->b_blocknr, 7,
@@ -184,6 +182,35 @@ int ocfs2_validate_group_descriptor(struct super_block *sb,
 		return -EINVAL;
 	}
 
+	if (le16_to_cpu(gd->bg_free_bits_count) > le16_to_cpu(gd->bg_bits)) {
+		do_error("Group descriptor #%llu has bit count %u but "
+			 "claims that %u are free",
+			 (unsigned long long)bh->b_blocknr,
+			 le16_to_cpu(gd->bg_bits),
+			 le16_to_cpu(gd->bg_free_bits_count));
+		return -EINVAL;
+	}
+
+	if (le16_to_cpu(gd->bg_bits) > (8 * le16_to_cpu(gd->bg_size))) {
+		do_error("Group descriptor #%llu has bit count %u but "
+			 "max bitmap bits of %u",
+			 (unsigned long long)bh->b_blocknr,
+			 le16_to_cpu(gd->bg_bits),
+			 8 * le16_to_cpu(gd->bg_size));
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int ocfs2_validate_gd_parent(struct super_block *sb,
+				    struct ocfs2_dinode *di,
+				    struct buffer_head *bh,
+				    int clean_error)
+{
+	unsigned int max_bits;
+	struct ocfs2_group_desc *gd = (struct ocfs2_group_desc *)bh->b_data;
+
 	if (di->i_blkno != gd->bg_parent_dinode) {
 		do_error("Group descriptor #%llu has bad parent "
 			 "pointer (%llu, expected %llu)",
@@ -209,26 +236,35 @@ int ocfs2_validate_group_descriptor(struct super_block *sb,
 		return -EINVAL;
 	}
 
-	if (le16_to_cpu(gd->bg_free_bits_count) > le16_to_cpu(gd->bg_bits)) {
-		do_error("Group descriptor #%llu has bit count %u but "
-			 "claims that %u are free",
-			 (unsigned long long)bh->b_blocknr,
-			 le16_to_cpu(gd->bg_bits),
-			 le16_to_cpu(gd->bg_free_bits_count));
-		return -EINVAL;
-	}
+	return 0;
+}
 
-	if (le16_to_cpu(gd->bg_bits) > (8 * le16_to_cpu(gd->bg_size))) {
-		do_error("Group descriptor #%llu has bit count %u but "
-			 "max bitmap bits of %u",
-			 (unsigned long long)bh->b_blocknr,
-			 le16_to_cpu(gd->bg_bits),
-			 8 * le16_to_cpu(gd->bg_size));
-		return -EINVAL;
-	}
 #undef do_error
 
-	return 0;
+/*
+ * This version only prints errors.  It does not fail the filesystem, and
+ * exists only for resize.
+ */
+int ocfs2_check_group_descriptor(struct super_block *sb,
+				 struct ocfs2_dinode *di,
+				 struct buffer_head *bh)
+{
+	int rc;
+
+	rc = ocfs2_validate_gd_self(sb, bh, 1);
+	if (!rc)
+		rc = ocfs2_validate_gd_parent(sb, di, bh, 1);
+
+	return rc;
+}
+
+static int ocfs2_validate_group_descriptor(struct super_block *sb,
+					   struct buffer_head *bh)
+{
+	mlog(0, "Validating group descriptor %llu\n",
+	     (unsigned long long)bh->b_blocknr);
+
+	return ocfs2_validate_gd_self(sb, bh, 0);
 }
 
 int ocfs2_read_group_descriptor(struct inode *inode, struct ocfs2_dinode *di,
@@ -237,11 +273,12 @@ int ocfs2_read_group_descriptor(struct inode *inode, struct ocfs2_dinode *di,
 	int rc;
 	struct buffer_head *tmp = *bh;
 
-	rc = ocfs2_read_block(inode, gd_blkno, &tmp);
+	rc = ocfs2_read_block(inode, gd_blkno, &tmp,
+			      ocfs2_validate_group_descriptor);
 	if (rc)
 		goto out;
 
-	rc = ocfs2_validate_group_descriptor(inode->i_sb, di, tmp, 0);
+	rc = ocfs2_validate_gd_parent(inode->i_sb, di, tmp, 0);
 	if (rc) {
 		brelse(tmp);
 		goto out;
diff --git a/fs/ocfs2/suballoc.h b/fs/ocfs2/suballoc.h
index 43de4fd..e3c13c7 100644
--- a/fs/ocfs2/suballoc.h
+++ b/fs/ocfs2/suballoc.h
@@ -165,16 +165,15 @@ void ocfs2_free_ac_resource(struct ocfs2_alloc_context *ac);
 u64 ocfs2_which_cluster_group(struct inode *inode, u32 cluster);
 
 /*
- * By default, ocfs2_validate_group_descriptor() calls ocfs2_error() when it
+ * By default, ocfs2_read_group_descriptor() calls ocfs2_error() when it
  * finds a problem.  A caller that wants to check a group descriptor
- * without going readonly passes a nonzero clean_error.  This is only
- * resize, really.  Everyone else should be using
- * ocfs2_read_group_descriptor().
+ * without going readonly should read the block with ocfs2_read_block[s]()
+ * and then checking it with this function.  This is only resize, really.
+ * Everyone else should be using ocfs2_read_group_descriptor().
  */
-int ocfs2_validate_group_descriptor(struct super_block *sb,
-				    struct ocfs2_dinode *di,
-				    struct buffer_head *bh,
-				    int clean_error);
+int ocfs2_check_group_descriptor(struct super_block *sb,
+				 struct ocfs2_dinode *di,
+				 struct buffer_head *bh);
 /*
  * Read a group descriptor block into *bh.  If *bh is NULL, a bh will be
  * allocated.  This is a cached read.  The descriptor will be validated with
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index ef4aa54..8af29b3 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -266,7 +266,8 @@ static int ocfs2_read_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
 	int rc;
 
 	rc = ocfs2_read_blocks(bucket->bu_inode, xb_blkno,
-			       bucket->bu_blocks, bucket->bu_bhs, 0);
+			       bucket->bu_blocks, bucket->bu_bhs, 0,
+			       NULL);
 	if (rc)
 		ocfs2_xattr_bucket_relse(bucket);
 	return rc;
@@ -359,12 +360,8 @@ static int ocfs2_read_xattr_block(struct inode *inode, u64 xb_blkno,
 	int rc;
 	struct buffer_head *tmp = *bh;
 
-	rc = ocfs2_read_block(inode, xb_blkno, &tmp);
-	if (!rc) {
-		rc = ocfs2_validate_xattr_block(inode->i_sb, tmp);
-		if (rc)
-			brelse(tmp);
-	}
+	rc = ocfs2_read_block(inode, xb_blkno, &tmp,
+			      ocfs2_validate_xattr_block);
 
 	/* If ocfs2_read_block() got us a new bh, pass it up. */
 	if (!rc && !*bh)
@@ -925,7 +922,7 @@ static int ocfs2_xattr_get_value_outside(struct inode *inode,
 		blkno = ocfs2_clusters_to_blocks(inode->i_sb, p_cluster);
 		/* Copy ocfs2_xattr_value */
 		for (i = 0; i < num_clusters * bpc; i++, blkno++) {
-			ret = ocfs2_read_block(inode, blkno, &bh);
+			ret = ocfs2_read_block(inode, blkno, &bh, NULL);
 			if (ret) {
 				mlog_errno(ret);
 				goto out;
@@ -1174,7 +1171,7 @@ static int __ocfs2_xattr_set_value_outside(struct inode *inode,
 		blkno = ocfs2_clusters_to_blocks(inode->i_sb, p_cluster);
 
 		for (i = 0; i < num_clusters * bpc; i++, blkno++) {
-			ret = ocfs2_read_block(inode, blkno, &bh);
+			ret = ocfs2_read_block(inode, blkno, &bh, NULL);
 			if (ret) {
 				mlog_errno(ret);
 				goto out;
@@ -2206,7 +2203,7 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
 		base = xis->base;
 		credits += OCFS2_INODE_UPDATE_CREDITS;
 	} else {
-		int i, block_off;
+		int i, block_off = 0;
 		xb = (struct ocfs2_xattr_block *)xbs->xattr_bh->b_data;
 		xe = xbs->here;
 		name_offset = le16_to_cpu(xe->xe_name_offset);
@@ -2840,6 +2837,7 @@ static int ocfs2_find_xe_in_bucket(struct inode *inode,
 			break;
 		}
 
+
 		xe_name = bucket_block(bucket, block_off) + new_offset;
 		if (!memcmp(name, xe_name, name_len)) {
 			*xe_index = i;
@@ -3598,7 +3596,7 @@ static int ocfs2_mv_xattr_bucket_cross_cluster(struct inode *inode,
 			goto out;
 		}
 
-		ret = ocfs2_read_block(inode, prev_blkno, &old_bh);
+		ret = ocfs2_read_block(inode, prev_blkno, &old_bh, NULL);
 		if (ret < 0) {
 			mlog_errno(ret);
 			brelse(new_bh);
@@ -3990,7 +3988,7 @@ static int ocfs2_cp_xattr_cluster(struct inode *inode,
 	ocfs2_journal_dirty(handle, first_bh);
 
 	/* update the new bucket header. */
-	ret = ocfs2_read_block(inode, to_blk_start, &bh);
+	ret = ocfs2_read_block(inode, to_blk_start, &bh, NULL);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out;
@@ -4337,7 +4335,7 @@ static int ocfs2_add_new_xattr_bucket(struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_read_block(inode, p_blkno, &first_bh);
+	ret = ocfs2_read_block(inode, p_blkno, &first_bh, NULL);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -4635,7 +4633,7 @@ static int ocfs2_xattr_bucket_value_truncate(struct inode *inode,
 	BUG_ON(value_blk != (offset + OCFS2_XATTR_ROOT_SIZE - 1) / blocksize);
 	value_blk += header_bh->b_blocknr;
 
-	ret = ocfs2_read_block(inode, value_blk, &value_bh);
+	ret = ocfs2_read_block(inode, value_blk, &value_bh, NULL);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
-- 
1.5.6
