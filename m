From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed Jan 16 11:33:17 2008
Subject: [Ocfs2-devel] [PATCH 05/20] ocfs2: fix write() performance
	regression
In-Reply-To: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
References: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1200511977-19513-6-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 4e9563fd55ff4479f2b118d0757d121dd0cfc39c
Author: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu, 1 Nov 2007 11:37:48 -0700

On file systems which don't support sparse files, Ocfs2_map_page_blocks()
was reading blocks on appending writes. This caused write performance to
suffer dramatically. Fix this by detecting an appending write on a nonsparse
fs and skipping the read.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/aops.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 93c01b7..4999180 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -729,6 +729,27 @@ static void ocfs2_clear_page_regions(struct page *page,
 }
 
 /*
+ * Nonsparse file systems fully allocate before we get to the write
+ * code. This prevents ocfs2_write() from tagging the write as an
+ * allocating one, which means ocfs2_map_page_blocks() might try to
+ * read-in the blocks at the tail of our file. Avoid reading them by
+ * testing i_size against each block offset.
+ */
+static int ocfs2_should_read_blk(struct inode *inode, struct page *page,
+				 unsigned int block_start)
+{
+	u64 offset = page_offset(page) + block_start;
+
+	if (ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)))
+		return 1;
+
+	if (i_size_read(inode) > offset)
+		return 1;
+
+	return 0;
+}
+
+/*
  * Some of this taken from block_prepare_write(). We already have our
  * mapping by now though, and the entire write will be allocating or
  * it won't, so not much need to use BH_New.
@@ -781,6 +802,7 @@ int ocfs2_map_page_blocks(struct page *page, u64 *p_blkno,
 				set_buffer_uptodate(bh);
 		} else if (!buffer_uptodate(bh) && !buffer_delay(bh) &&
 			   !buffer_new(bh) &&
+			   ocfs2_should_read_blk(inode, page, block_start) &&
 			   (block_start < from || block_end > to)) {
 			ll_rw_block(READ, 1, &bh);
 			*wait_bh++=bh;
-- 
1.5.3.4
