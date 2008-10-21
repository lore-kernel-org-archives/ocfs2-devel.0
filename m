From: Joel Becker <joel.becker@oracle.com>
Date: Mon, 20 Oct 2008 19:08:14 -0700
Subject: [Ocfs2-devel] [PATCH 1/5] ocfs2: Check xattr block signatures
	properly.
In-Reply-To: <1224554898-3928-1-git-send-email-joel.becker@oracle.com>
References: <1224554898-3928-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1224554898-3928-2-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The xattr.c code is currently memcmp()ing naking buffer pointers.
Create the OCFS2_IS_VALID_XATTR_BLOCK() macro to match its peers and use
that.

In addition, failed signature checks were returning -EFAULT, which is
completely wrong.  Return -EIO.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/ocfs2.h |    3 +++
 fs/ocfs2/xattr.c |   38 ++++++++++++++++----------------------
 2 files changed, 19 insertions(+), 22 deletions(-)

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
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 802c414..44d58f1 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -542,14 +542,12 @@ static int ocfs2_xattr_block_list(struct inode *inode,
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
@@ -766,15 +764,14 @@ static int ocfs2_xattr_block_get(struct inode *inode,
 		mlog_errno(ret);
 		return ret;
 	}
-	/*Verify the signature of xattr block*/
-	if (memcmp((void *)blk_bh->b_data, OCFS2_XATTR_BLOCK_SIGNATURE,
-		   strlen(OCFS2_XATTR_BLOCK_SIGNATURE))) {
-		ret = -EFAULT;
+
+	xb = (struct ocfs2_xattr_block *)blk_bh->b_data;
+	if (!OCFS2_IS_VALID_XATTR_BLOCK(xb)) {
+		ret = -EIO;
 		goto cleanup;
 	}
 
 	xs->xattr_bh = blk_bh;
-	xb = (struct ocfs2_xattr_block *)blk_bh->b_data;
 
 	if (!(le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED)) {
 		xs->header = &xb->xb_attrs.xb_header;
@@ -1514,10 +1511,9 @@ static int ocfs2_xattr_free_block(struct inode *inode,
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
 
@@ -1527,7 +1523,6 @@ static int ocfs2_xattr_free_block(struct inode *inode,
 		goto out;
 	}
 
-	xb = (struct ocfs2_xattr_block *)blk_bh->b_data;
 	blk = le64_to_cpu(xb->xb_blkno);
 	bit = le16_to_cpu(xb->xb_suballoc_bit);
 	bg_blkno = ocfs2_which_suballoc_group(blk, bit);
@@ -1771,15 +1766,14 @@ static int ocfs2_xattr_block_find(struct inode *inode,
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
-- 
1.5.6.5
