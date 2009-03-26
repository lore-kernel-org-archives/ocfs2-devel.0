From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 27 Mar 2009 07:02:44 +0800
Subject: [Ocfs2-devel] [PATCH 38/42] ocfs2: Create an xattr indexed block if
	needed.
In-Reply-To: <49CC86FC.2070906@oracle.com>
References: <49CC86FC.2070906@oracle.com>
Message-ID: <1238108568-23740-38-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

With reflink, there is a need that we create a new xattr indexed
block from the very beginning. So add a new parameter for
ocfs2_create_xattr_block.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index d3fd0de..556fae0 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2136,7 +2136,8 @@ static int ocfs2_create_xattr_block(handle_t *handle,
 				    struct inode *inode,
 				    struct buffer_head *inode_bh,
 				    struct ocfs2_alloc_context *meta_ac,
-				    struct buffer_head **ret_bh)
+				    struct buffer_head **ret_bh,
+				    int indexed)
 {
 	int ret;
 	u16 slot, suballoc_bit_start;
@@ -2182,6 +2183,17 @@ static int ocfs2_create_xattr_block(handle_t *handle,
 	xblk->xb_fs_generation = cpu_to_le32(osb->fs_generation);
 	xblk->xb_blkno = cpu_to_le64(first_blkno);
 
+	if (indexed) {
+		struct ocfs2_xattr_tree_root *xr = &xblk->xb_attrs.xb_root;
+		xr->xt_clusters = cpu_to_le32(1);
+		xr->xt_last_eb_blk = 0;
+		xr->xt_list.l_tree_depth = 0;
+		xr->xt_list.l_count = cpu_to_le16(
+					ocfs2_xattr_recs_per_xb(inode->i_sb));
+		xr->xt_list.l_next_free_rec = cpu_to_le16(1);
+		xblk->xb_flags = cpu_to_le16(OCFS2_XATTR_INDEXED);
+	}
+
 	ret = ocfs2_journal_dirty(handle, new_bh);
 	if (ret < 0) {
 		mlog_errno(ret);
@@ -2216,7 +2228,7 @@ static int ocfs2_xattr_block_set(struct inode *inode,
 
 	if (!xs->xattr_bh) {
 		ret = ocfs2_create_xattr_block(handle, inode, xs->inode_bh,
-					       ctxt->meta_ac, &new_bh);
+					       ctxt->meta_ac, &new_bh, 0);
 		if (ret) {
 			mlog_errno(ret);
 			goto end;
-- 
1.6.2.rc2.16.gf474c
