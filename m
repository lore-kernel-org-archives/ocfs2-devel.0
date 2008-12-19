From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 19 Dec 2008 13:53:54 -0800
Subject: [Ocfs2-devel] [PATCH 35/45] ocfs2: Wrap group descriptor reads in a
	dedicated function.
In-Reply-To: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
References: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
Message-ID: <1229723644-13630-36-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Joel Becker <joel.becker@oracle.com>

We have a clean call for validating group descriptors, but every place
that wants the always does a read_block()+validate() call pair.  Create
a toplevel ocfs2_read_group_descriptor() that does the right
thing.  This allows us to leverage the single call point later for
fancier handling.  We also add validation of gd->bg_generation against
the superblock and gd->bg_blkno against the block we thought we read.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/resize.c   |   12 +----
 fs/ocfs2/suballoc.c |  108 ++++++++++++++++++++++++++++++--------------------
 fs/ocfs2/suballoc.h |   19 +++++----
 3 files changed, 78 insertions(+), 61 deletions(-)

diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index a2de32a..252baff 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -330,20 +330,14 @@ int ocfs2_group_extend(struct inode * inode, int new_clusters)
 	lgd_blkno = ocfs2_which_cluster_group(main_bm_inode,
 					      first_new_cluster - 1);
 
-	ret = ocfs2_read_block(main_bm_inode, lgd_blkno, &group_bh);
+	ret = ocfs2_read_group_descriptor(main_bm_inode, fe, lgd_blkno,
+					  &group_bh);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out_unlock;
 	}
-
 	group = (struct ocfs2_group_desc *)group_bh->b_data;
 
-	ret = ocfs2_check_group_descriptor(inode->i_sb, fe, group);
-	if (ret) {
-		mlog_errno(ret);
-		goto out_unlock;
-	}
-
 	cl_bpc = le16_to_cpu(fe->id2.i_chain.cl_bpc);
 	if (le16_to_cpu(group->bg_bits) / cl_bpc + new_clusters >
 		le16_to_cpu(fe->id2.i_chain.cl_cpg)) {
@@ -400,7 +394,7 @@ static int ocfs2_check_new_group(struct inode *inode,
 		(struct ocfs2_group_desc *)group_bh->b_data;
 	u16 cl_bpc = le16_to_cpu(di->id2.i_chain.cl_bpc);
 
-	ret = ocfs2_validate_group_descriptor(inode->i_sb, di, gd, 1);
+	ret = ocfs2_validate_group_descriptor(inode->i_sb, di, group_bh, 1);
 	if (ret)
 		goto out;
 
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index ddba97d..797f509 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -145,13 +145,13 @@ static u32 ocfs2_bits_per_group(struct ocfs2_chain_list *cl)
 	return (u32)le16_to_cpu(cl->cl_cpg) * (u32)le16_to_cpu(cl->cl_bpc);
 }
 
-/* somewhat more expensive than our other checks, so use sparingly. */
 int ocfs2_validate_group_descriptor(struct super_block *sb,
 				    struct ocfs2_dinode *di,
-				    struct ocfs2_group_desc *gd,
+				    struct buffer_head *bh,
 				    int clean_error)
 {
 	unsigned int max_bits;
+	struct ocfs2_group_desc *gd = (struct ocfs2_group_desc *)bh->b_data;
 
 #define do_error(fmt, ...)						\
 	do{								\
@@ -162,16 +162,32 @@ int ocfs2_validate_group_descriptor(struct super_block *sb,
 	} while (0)
 
 	if (!OCFS2_IS_VALID_GROUP_DESC(gd)) {
-		do_error("Group Descriptor #%llu has bad signature %.*s",
-			 (unsigned long long)le64_to_cpu(gd->bg_blkno), 7,
+		do_error("Group descriptor #%llu has bad signature %.*s",
+			 (unsigned long long)bh->b_blocknr, 7,
 			 gd->bg_signature);
 		return -EINVAL;
 	}
 
+	if (le64_to_cpu(gd->bg_blkno) != bh->b_blocknr) {
+		do_error("Group descriptor #%llu has an invalid bg_blkno "
+			 "of %llu",
+			 (unsigned long long)bh->b_blocknr,
+			 (unsigned long long)le64_to_cpu(gd->bg_blkno));
+		return -EINVAL;
+	}
+
+	if (le32_to_cpu(gd->bg_generation) != OCFS2_SB(sb)->fs_generation) {
+		do_error("Group descriptor #%llu has an invalid "
+			 "fs_generation of #%u",
+			 (unsigned long long)bh->b_blocknr,
+			 le32_to_cpu(gd->bg_generation));
+		return -EINVAL;
+	}
+
 	if (di->i_blkno != gd->bg_parent_dinode) {
-		do_error("Group descriptor # %llu has bad parent "
+		do_error("Group descriptor #%llu has bad parent "
 			 "pointer (%llu, expected %llu)",
-			 (unsigned long long)le64_to_cpu(gd->bg_blkno),
+			 (unsigned long long)bh->b_blocknr,
 			 (unsigned long long)le64_to_cpu(gd->bg_parent_dinode),
 			 (unsigned long long)le64_to_cpu(di->i_blkno));
 		return -EINVAL;
@@ -179,33 +195,33 @@ int ocfs2_validate_group_descriptor(struct super_block *sb,
 
 	max_bits = le16_to_cpu(di->id2.i_chain.cl_cpg) * le16_to_cpu(di->id2.i_chain.cl_bpc);
 	if (le16_to_cpu(gd->bg_bits) > max_bits) {
-		do_error("Group descriptor # %llu has bit count of %u",
-			 (unsigned long long)le64_to_cpu(gd->bg_blkno),
+		do_error("Group descriptor #%llu has bit count of %u",
+			 (unsigned long long)bh->b_blocknr,
 			 le16_to_cpu(gd->bg_bits));
 		return -EINVAL;
 	}
 
 	if (le16_to_cpu(gd->bg_chain) >=
 	    le16_to_cpu(di->id2.i_chain.cl_next_free_rec)) {
-		do_error("Group descriptor # %llu has bad chain %u",
-			 (unsigned long long)le64_to_cpu(gd->bg_blkno),
+		do_error("Group descriptor #%llu has bad chain %u",
+			 (unsigned long long)bh->b_blocknr,
 			 le16_to_cpu(gd->bg_chain));
 		return -EINVAL;
 	}
 
 	if (le16_to_cpu(gd->bg_free_bits_count) > le16_to_cpu(gd->bg_bits)) {
-		do_error("Group descriptor # %llu has bit count %u but "
+		do_error("Group descriptor #%llu has bit count %u but "
 			 "claims that %u are free",
-			 (unsigned long long)le64_to_cpu(gd->bg_blkno),
+			 (unsigned long long)bh->b_blocknr,
 			 le16_to_cpu(gd->bg_bits),
 			 le16_to_cpu(gd->bg_free_bits_count));
 		return -EINVAL;
 	}
 
 	if (le16_to_cpu(gd->bg_bits) > (8 * le16_to_cpu(gd->bg_size))) {
-		do_error("Group descriptor # %llu has bit count %u but "
+		do_error("Group descriptor #%llu has bit count %u but "
 			 "max bitmap bits of %u",
-			 (unsigned long long)le64_to_cpu(gd->bg_blkno),
+			 (unsigned long long)bh->b_blocknr,
 			 le16_to_cpu(gd->bg_bits),
 			 8 * le16_to_cpu(gd->bg_size));
 		return -EINVAL;
@@ -215,6 +231,30 @@ int ocfs2_validate_group_descriptor(struct super_block *sb,
 	return 0;
 }
 
+int ocfs2_read_group_descriptor(struct inode *inode, struct ocfs2_dinode *di,
+				u64 gd_blkno, struct buffer_head **bh)
+{
+	int rc;
+	struct buffer_head *tmp = *bh;
+
+	rc = ocfs2_read_block(inode, gd_blkno, &tmp);
+	if (rc)
+		goto out;
+
+	rc = ocfs2_validate_group_descriptor(inode->i_sb, di, tmp, 0);
+	if (rc) {
+		brelse(tmp);
+		goto out;
+	}
+
+	/* If ocfs2_read_block() got us a new bh, pass it up. */
+	if (!*bh)
+		*bh = tmp;
+
+out:
+	return rc;
+}
+
 static int ocfs2_block_group_fill(handle_t *handle,
 				  struct inode *alloc_inode,
 				  struct buffer_head *bg_bh,
@@ -1177,21 +1217,17 @@ static int ocfs2_search_one_group(struct ocfs2_alloc_context *ac,
 	u16 found;
 	struct buffer_head *group_bh = NULL;
 	struct ocfs2_group_desc *gd;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)ac->ac_bh->b_data;
 	struct inode *alloc_inode = ac->ac_inode;
 
-	ret = ocfs2_read_block(alloc_inode, gd_blkno, &group_bh);
+	ret = ocfs2_read_group_descriptor(alloc_inode, di, gd_blkno,
+					  &group_bh);
 	if (ret < 0) {
 		mlog_errno(ret);
 		return ret;
 	}
 
 	gd = (struct ocfs2_group_desc *) group_bh->b_data;
-	if (!OCFS2_IS_VALID_GROUP_DESC(gd)) {
-		OCFS2_RO_ON_INVALID_GROUP_DESC(alloc_inode->i_sb, gd);
-		ret = -EIO;
-		goto out;
-	}
-
 	ret = ac->ac_group_search(alloc_inode, group_bh, bits_wanted, min_bits,
 				  ac->ac_max_block, bit_off, &found);
 	if (ret < 0) {
@@ -1248,19 +1284,14 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
 	     bits_wanted, chain,
 	     (unsigned long long)OCFS2_I(alloc_inode)->ip_blkno);
 
-	status = ocfs2_read_block(alloc_inode,
-				  le64_to_cpu(cl->cl_recs[chain].c_blkno),
-				  &group_bh);
+	status = ocfs2_read_group_descriptor(alloc_inode, fe,
+					     le64_to_cpu(cl->cl_recs[chain].c_blkno),
+					     &group_bh);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
 	}
 	bg = (struct ocfs2_group_desc *) group_bh->b_data;
-	status = ocfs2_check_group_descriptor(alloc_inode->i_sb, fe, bg);
-	if (status) {
-		mlog_errno(status);
-		goto bail;
-	}
 
 	status = -ENOSPC;
 	/* for now, the chain search is a bit simplistic. We just use
@@ -1278,18 +1309,13 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
 		next_group = le64_to_cpu(bg->bg_next_group);
 		prev_group_bh = group_bh;
 		group_bh = NULL;
-		status = ocfs2_read_block(alloc_inode,
-					  next_group, &group_bh);
+		status = ocfs2_read_group_descriptor(alloc_inode, fe,
+						     next_group, &group_bh);
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail;
 		}
 		bg = (struct ocfs2_group_desc *) group_bh->b_data;
-		status = ocfs2_check_group_descriptor(alloc_inode->i_sb, fe, bg);
-		if (status) {
-			mlog_errno(status);
-			goto bail;
-		}
 	}
 	if (status < 0) {
 		if (status != -ENOSPC)
@@ -1801,18 +1827,14 @@ int ocfs2_free_suballoc_bits(handle_t *handle,
 	     (unsigned long long)OCFS2_I(alloc_inode)->ip_blkno, count,
 	     (unsigned long long)bg_blkno, start_bit);
 
-	status = ocfs2_read_block(alloc_inode, bg_blkno, &group_bh);
+	status = ocfs2_read_group_descriptor(alloc_inode, fe, bg_blkno,
+					     &group_bh);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
 	}
-
 	group = (struct ocfs2_group_desc *) group_bh->b_data;
-	status = ocfs2_check_group_descriptor(alloc_inode->i_sb, fe, group);
-	if (status) {
-		mlog_errno(status);
-		goto bail;
-	}
+
 	BUG_ON((count + start_bit) > le16_to_cpu(group->bg_bits));
 
 	status = ocfs2_block_group_clear_bits(handle, alloc_inode,
diff --git a/fs/ocfs2/suballoc.h b/fs/ocfs2/suballoc.h
index 7adfcc4..43de4fd 100644
--- a/fs/ocfs2/suballoc.h
+++ b/fs/ocfs2/suballoc.h
@@ -164,23 +164,24 @@ void ocfs2_free_ac_resource(struct ocfs2_alloc_context *ac);
  * and return that block offset. */
 u64 ocfs2_which_cluster_group(struct inode *inode, u32 cluster);
 
-/* somewhat more expensive than our other checks, so use sparingly. */
 /*
  * By default, ocfs2_validate_group_descriptor() calls ocfs2_error() when it
  * finds a problem.  A caller that wants to check a group descriptor
  * without going readonly passes a nonzero clean_error.  This is only
- * resize, really.
+ * resize, really.  Everyone else should be using
+ * ocfs2_read_group_descriptor().
  */
 int ocfs2_validate_group_descriptor(struct super_block *sb,
 				    struct ocfs2_dinode *di,
-				    struct ocfs2_group_desc *gd,
+				    struct buffer_head *bh,
 				    int clean_error);
-static inline int ocfs2_check_group_descriptor(struct super_block *sb,
-					       struct ocfs2_dinode *di,
-					       struct ocfs2_group_desc *gd)
-{
-	return ocfs2_validate_group_descriptor(sb, di, gd, 0);
-}
+/*
+ * Read a group descriptor block into *bh.  If *bh is NULL, a bh will be
+ * allocated.  This is a cached read.  The descriptor will be validated with
+ * ocfs2_validate_group_descriptor().
+ */
+int ocfs2_read_group_descriptor(struct inode *inode, struct ocfs2_dinode *di,
+				u64 gd_blkno, struct buffer_head **bh);
 
 int ocfs2_lock_allocators(struct inode *inode, struct ocfs2_extent_tree *et,
 			  u32 clusters_to_add, u32 extents_to_split,
-- 
1.5.6
