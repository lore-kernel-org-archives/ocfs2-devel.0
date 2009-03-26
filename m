From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 27 Mar 2009 07:02:40 +0800
Subject: [Ocfs2-devel] [PATCH 34/42] ocfs2: Abstract the creation of xattr
	block.
In-Reply-To: <49CC86FC.2070906@oracle.com>
References: <49CC86FC.2070906@oracle.com>
Message-ID: <1238108568-23740-34-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In xattr reflink, we also need to create xattr block, so
abstract the process out.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |  115 +++++++++++++++++++++++++++++++++---------------------
 1 files changed, 70 insertions(+), 45 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 386fa3a..e3d31f5 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2099,6 +2099,72 @@ cleanup:
 	return ret;
 }
 
+static int ocfs2_create_xattr_block(handle_t *handle,
+				    struct inode *inode,
+				    struct buffer_head *inode_bh,
+				    struct ocfs2_alloc_context *meta_ac,
+				    struct buffer_head **ret_bh)
+{
+	int ret;
+	u16 slot, suballoc_bit_start;
+	u32 num_got;
+	u64 first_blkno;
+	struct ocfs2_dinode *di =  (struct ocfs2_dinode *)inode_bh->b_data;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct buffer_head *new_bh = NULL;
+	struct ocfs2_xattr_block *xblk;
+
+	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), inode_bh,
+				      OCFS2_JOURNAL_ACCESS_CREATE);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto end;
+	}
+
+	ret = ocfs2_claim_metadata(osb, handle, meta_ac, 1,
+				   &slot, &suballoc_bit_start, &num_got,
+				   &first_blkno);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto end;
+	}
+
+	new_bh = sb_getblk(inode->i_sb, first_blkno);
+	ocfs2_set_new_buffer_uptodate(INODE_CACHE(inode), new_bh);
+
+	ret = ocfs2_journal_access_xb(handle, INODE_CACHE(inode),
+				      new_bh,
+				      OCFS2_JOURNAL_ACCESS_CREATE);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto end;
+	}
+
+	/* Initialize ocfs2_xattr_block */
+	xblk = (struct ocfs2_xattr_block *)new_bh->b_data;
+	memset(xblk, 0, inode->i_sb->s_blocksize);
+	strcpy((void *)xblk, OCFS2_XATTR_BLOCK_SIGNATURE);
+	xblk->xb_suballoc_slot = cpu_to_le16(slot);
+	xblk->xb_suballoc_bit = cpu_to_le16(suballoc_bit_start);
+	xblk->xb_fs_generation = cpu_to_le32(osb->fs_generation);
+	xblk->xb_blkno = cpu_to_le64(first_blkno);
+
+	ret = ocfs2_journal_dirty(handle, new_bh);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto end;
+	}
+	di->i_xattr_loc = cpu_to_le64(first_blkno);
+	ocfs2_journal_dirty(handle, inode_bh);
+
+	*ret_bh = new_bh;
+	new_bh = NULL;
+
+end:
+	brelse(new_bh);
+	return ret;
+}
+
 /*
  * ocfs2_xattr_block_set()
  *
@@ -2111,65 +2177,24 @@ static int ocfs2_xattr_block_set(struct inode *inode,
 				 struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	struct buffer_head *new_bh = NULL;
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	struct ocfs2_dinode *di =  (struct ocfs2_dinode *)xs->inode_bh->b_data;
 	handle_t *handle = ctxt->handle;
 	struct ocfs2_xattr_block *xblk = NULL;
-	u16 slot, suballoc_bit_start;
-	u32 num_got;
-	u64 first_blkno;
 	int ret;
 
 	if (!xs->xattr_bh) {
-		ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode),
-					      xs->inode_bh,
-					      OCFS2_JOURNAL_ACCESS_CREATE);
-		if (ret < 0) {
-			mlog_errno(ret);
-			goto end;
-		}
-
-		ret = ocfs2_claim_metadata(osb, handle, ctxt->meta_ac, 1,
-					   &slot, &suballoc_bit_start, &num_got,
-					   &first_blkno);
-		if (ret < 0) {
-			mlog_errno(ret);
-			goto end;
-		}
-
-		new_bh = sb_getblk(inode->i_sb, first_blkno);
-		ocfs2_set_new_buffer_uptodate(INODE_CACHE(inode), new_bh);
-
-		ret = ocfs2_journal_access_xb(handle, INODE_CACHE(inode),
-					      new_bh,
-					      OCFS2_JOURNAL_ACCESS_CREATE);
-		if (ret < 0) {
+		ret = ocfs2_create_xattr_block(handle, inode, xs->inode_bh,
+					       ctxt->meta_ac, &new_bh);
+		if (ret) {
 			mlog_errno(ret);
 			goto end;
 		}
 
-		/* Initialize ocfs2_xattr_block */
 		xs->xattr_bh = new_bh;
-		xblk = (struct ocfs2_xattr_block *)new_bh->b_data;
-		memset(xblk, 0, inode->i_sb->s_blocksize);
-		strcpy((void *)xblk, OCFS2_XATTR_BLOCK_SIGNATURE);
-		xblk->xb_suballoc_slot = cpu_to_le16(slot);
-		xblk->xb_suballoc_bit = cpu_to_le16(suballoc_bit_start);
-		xblk->xb_fs_generation = cpu_to_le32(osb->fs_generation);
-		xblk->xb_blkno = cpu_to_le64(first_blkno);
-
+		xblk = (struct ocfs2_xattr_block *)xs->xattr_bh->b_data;
 		xs->header = &xblk->xb_attrs.xb_header;
 		xs->base = (void *)xs->header;
 		xs->end = (void *)xblk + inode->i_sb->s_blocksize;
 		xs->here = xs->header->xh_entries;
-
-		ret = ocfs2_journal_dirty(handle, new_bh);
-		if (ret < 0) {
-			mlog_errno(ret);
-			goto end;
-		}
-		di->i_xattr_loc = cpu_to_le64(first_blkno);
-		ocfs2_journal_dirty(handle, xs->inode_bh);
 	} else
 		xblk = (struct ocfs2_xattr_block *)xs->xattr_bh->b_data;
 
-- 
1.6.2.rc2.16.gf474c
