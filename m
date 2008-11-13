From: Joel Becker <joel.becker@oracle.com>
Date: Thu, 13 Nov 2008 14:49:18 -0800
Subject: [Ocfs2-devel] [PATCH 08/11] ocfs2: Wrap xattr block reads in a
	dedicated function
In-Reply-To: <1226616561-29942-1-git-send-email-joel.becker@oracle.com>
References: <1226616561-29942-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1226616561-29942-9-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We weren't consistently checking extent blocks after we read them.
Most places checked the signature, but none checked xb_blkno or
xb_fs_signature.  Create a toplevel ocfs2_read_xattr_block() that does
the read and the validation.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |   94 ++++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 70 insertions(+), 24 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index d4d8d0c..692d740 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -294,6 +294,65 @@ static void ocfs2_xattr_bucket_copy_data(struct ocfs2_xattr_bucket *dest,
 	}
 }
 
+static int ocfs2_validate_xattr_block(struct super_block *sb,
+				      struct buffer_head *bh)
+{
+	struct ocfs2_xattr_block *xb =
+		(struct ocfs2_xattr_block *)bh->b_data;
+
+	mlog(0, "Validating xattr block %llu\n",
+	     (unsigned long long)bh->b_blocknr);
+
+	if (!OCFS2_IS_VALID_XATTR_BLOCK(xb)) {
+		ocfs2_error(sb,
+			    "Extended attribute block #%llu has bad "
+			    "signature %.*s",
+			    (unsigned long long)bh->b_blocknr, 7,
+			    xb->xb_signature);
+		return -EINVAL;
+	}
+
+	if (le64_to_cpu(xb->xb_blkno) != bh->b_blocknr) {
+		ocfs2_error(sb,
+			    "Extended attribute block #%llu has an "
+			    "invalid xb_blkno of %llu",
+			    (unsigned long long)bh->b_blocknr,
+			    (unsigned long long)le64_to_cpu(xb->xb_blkno));
+		return -EINVAL;
+	}
+
+	if (le32_to_cpu(xb->xb_fs_generation) != OCFS2_SB(sb)->fs_generation) {
+		ocfs2_error(sb,
+			    "Extended attribute block #%llu has an invalid "
+			    "xb_fs_generation of #%u",
+			    (unsigned long long)bh->b_blocknr,
+			    le32_to_cpu(xb->xb_fs_generation));
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int ocfs2_read_xattr_block(struct inode *inode, u64 xb_blkno,
+				  struct buffer_head **bh)
+{
+	int rc;
+	struct buffer_head *tmp = *bh;
+
+	rc = ocfs2_read_block(inode, xb_blkno, &tmp);
+	if (!rc) {
+		rc = ocfs2_validate_xattr_block(inode->i_sb, tmp);
+		if (rc)
+			brelse(tmp);
+	}
+
+	/* If ocfs2_read_block() got us a new bh, pass it up. */
+	if (!rc && !*bh)
+		*bh = tmp;
+
+	return rc;
+}
+
 static inline const char *ocfs2_xattr_prefix(int name_index)
 {
 	struct xattr_handler *handler = NULL;
@@ -598,18 +657,14 @@ static int ocfs2_xattr_block_list(struct inode *inode,
 	if (!di->i_xattr_loc)
 		return ret;
 
-	ret = ocfs2_read_block(inode, le64_to_cpu(di->i_xattr_loc), &blk_bh);
+	ret = ocfs2_read_xattr_block(inode, le64_to_cpu(di->i_xattr_loc),
+				     &blk_bh);
 	if (ret < 0) {
 		mlog_errno(ret);
 		return ret;
 	}
 
 	xb = (struct ocfs2_xattr_block *)blk_bh->b_data;
-	if (!OCFS2_IS_VALID_XATTR_BLOCK(xb)) {
-		ret = -EIO;
-		goto cleanup;
-	}
-
 	if (!(le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED)) {
 		struct ocfs2_xattr_header *header = &xb->xb_attrs.xb_header;
 		ret = ocfs2_xattr_list_entries(inode, header,
@@ -619,7 +674,7 @@ static int ocfs2_xattr_block_list(struct inode *inode,
 		ret = ocfs2_xattr_tree_list_index_block(inode, xt,
 						   buffer, buffer_size);
 	}
-cleanup:
+
 	brelse(blk_bh);
 
 	return ret;
@@ -1536,24 +1591,19 @@ static int ocfs2_xattr_free_block(struct inode *inode,
 	u64 blk, bg_blkno;
 	u16 bit;
 
-	ret = ocfs2_read_block(inode, block, &blk_bh);
+	ret = ocfs2_read_xattr_block(inode, block, &blk_bh);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out;
 	}
 
-	xb = (struct ocfs2_xattr_block *)blk_bh->b_data;
-	if (!OCFS2_IS_VALID_XATTR_BLOCK(xb)) {
-		ret = -EIO;
-		goto out;
-	}
-
 	ret = ocfs2_xattr_block_remove(inode, blk_bh);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out;
 	}
 
+	xb = (struct ocfs2_xattr_block *)blk_bh->b_data;
 	blk = le64_to_cpu(xb->xb_blkno);
 	bit = le16_to_cpu(xb->xb_suballoc_bit);
 	bg_blkno = ocfs2_which_suballoc_group(blk, bit);
@@ -1793,19 +1843,15 @@ static int ocfs2_xattr_block_find(struct inode *inode,
 	if (!di->i_xattr_loc)
 		return ret;
 
-	ret = ocfs2_read_block(inode, le64_to_cpu(di->i_xattr_loc), &blk_bh);
+	ret = ocfs2_read_xattr_block(inode, le64_to_cpu(di->i_xattr_loc),
+				     &blk_bh);
 	if (ret < 0) {
 		mlog_errno(ret);
 		return ret;
 	}
 
-	xb = (struct ocfs2_xattr_block *)blk_bh->b_data;
-	if (!OCFS2_IS_VALID_XATTR_BLOCK(xb)) {
-		ret = -EIO;
-		goto cleanup;
-	}
-
 	xs->xattr_bh = blk_bh;
+	xb = (struct ocfs2_xattr_block *)blk_bh->b_data;
 
 	if (!(le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED)) {
 		xs->header = &xb->xb_attrs.xb_header;
@@ -2102,9 +2148,9 @@ meta_guess:
 	/* calculate metadata allocation. */
 	if (di->i_xattr_loc) {
 		if (!xbs->xattr_bh) {
-			ret = ocfs2_read_block(inode,
-					       le64_to_cpu(di->i_xattr_loc),
-					       &bh);
+			ret = ocfs2_read_xattr_block(inode,
+						     le64_to_cpu(di->i_xattr_loc),
+						     &bh);
 			if (ret) {
 				mlog_errno(ret);
 				goto out;
-- 
1.5.6.5
