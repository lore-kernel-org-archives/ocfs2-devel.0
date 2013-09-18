From: Rui Xiang <rui.xiang@huawei.com>
Date: Wed, 18 Sep 2013 15:36:44 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: add missing return value and check for
	sb_getblk
Message-ID: <5239580C.7060007@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

- Fix the return err in serval places missed in
  (ocfs2: return ENOMEM while sb_getblk failing).

- Add the missing check for new_bh in ocfs2_create_xattr_block.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
---
 fs/ocfs2/aops.c           | 1 +
 fs/ocfs2/buffer_head_io.c | 4 ++--
 fs/ocfs2/xattr.c          | 5 +++++
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index f37d3c0..e415919 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -92,6 +92,7 @@ static int ocfs2_symlink_get_block(struct inode *inode, sector_t iblock,
 			    iblock;
 		buffer_cache_bh = sb_getblk(osb->sb, blkno);
 		if (!buffer_cache_bh) {
+			err = -ENOMEM;
 			mlog(ML_ERROR, "couldn't getblock for symlink!\n");
 			goto bail;
 		}
diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index 5d18ad1..5b704c6 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -115,7 +115,7 @@ int ocfs2_read_blocks_sync(struct ocfs2_super *osb, u64 block,
 		if (bhs[i] == NULL) {
 			bhs[i] = sb_getblk(osb->sb, block++);
 			if (bhs[i] == NULL) {
-				status = -EIO;
+				status = -ENOMEM;
 				mlog_errno(status);
 				goto bail;
 			}
@@ -214,7 +214,7 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
 			bhs[i] = sb_getblk(sb, block++);
 			if (bhs[i] == NULL) {
 				ocfs2_metadata_cache_io_unlock(ci);
-				status = -EIO;
+				status = -ENOMEM;
 				mlog_errno(status);
 				goto bail;
 			}
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 05d97c7..024ce11 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2865,6 +2865,11 @@ static int ocfs2_create_xattr_block(struct inode *inode,
 	}
 
 	new_bh = sb_getblk(inode->i_sb, first_blkno);
+	if (!new_bh) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto end;
+	}
 	ocfs2_set_new_buffer_uptodate(INODE_CACHE(inode), new_bh);
 
 	ret = ocfs2_journal_access_xb(ctxt->handle, INODE_CACHE(inode),
-- 
1.8.2.2
