From: Joel Becker <joel.becker@oracle.com>
Date: Mon, 20 Oct 2008 19:08:18 -0700
Subject: [Ocfs2-devel] [PATCH 5/5] ocfs2: Don't repeat
	ocfs2_xattr_block_find()
In-Reply-To: <1224554898-3928-1-git-send-email-joel.becker@oracle.com>
References: <1224554898-3928-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1224554898-3928-6-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_xattr_block_get() looks up the xattr in a startlingly familiar
way; it's identical to the function ocfs2_xattr_block_find().  Let's just
use the later in the former.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |   39 +++++++++------------------------------
 1 files changed, 9 insertions(+), 30 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 5f11db2..15158bc 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -116,6 +116,10 @@ static int ocfs2_xattr_bucket_get_name_value(struct inode *inode,
 					     int *block_off,
 					     int *new_offset);
 
+static int ocfs2_xattr_block_find(struct inode *inode,
+				  int name_index,
+				  const char *name,
+				  struct ocfs2_xattr_search *xs);
 static int ocfs2_xattr_index_block_find(struct inode *inode,
 					struct buffer_head *root_bh,
 					int name_index,
@@ -747,46 +751,20 @@ static int ocfs2_xattr_block_get(struct inode *inode,
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
-
-	xb = (struct ocfs2_xattr_block *)blk_bh->b_data;
-	if (!OCFS2_IS_VALID_XATTR_BLOCK(xb)) {
-		ret = -EIO;
 		goto cleanup;
 	}
 
-	xs->xattr_bh = blk_bh;
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
-		goto cleanup;
+	xb = (struct ocfs2_xattr_block *)xs->xattr_bh->b_data;
 	size = le64_to_cpu(xs->here->xe_value_size);
 	if (buffer) {
 		ret = -ERANGE;
@@ -825,7 +803,8 @@ cleanup:
 		brelse(xs->bucket.bhs[i]);
 	memset(&xs->bucket, 0, sizeof(xs->bucket));
 
-	brelse(blk_bh);
+	brelse(xs->xattr_bh);
+	xs->xattr_bh = NULL;
 	return ret;
 }
 
-- 
1.5.6.5
