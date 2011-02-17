From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Thu, 17 Feb 2011 09:44:40 -0600
Subject: [Ocfs2-devel] [PATCH] Treat writes as new when holes span across
	page boundaries
Message-ID: <AANLkTi=pEu5y4=kjG1YoLR+YCd7Ak21QaFQz=AR3dffX@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When a hole spans across page boundaries, the next write forces
a read of the block. This could end up reading existing garbage
data from the disk in ocfs2_map_page_blocks. This leads to
non-zero holes. In order to avoid this, mark the writes as new
when the holes span across page boundaries.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>

---
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 1fbb0e2..4be220d 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1026,6 +1026,12 @@ static int ocfs2_prepare_page_for_write(struct
inode *inode, u64 *p_blkno,
 	ocfs2_figure_cluster_boundaries(OCFS2_SB(inode->i_sb), cpos,
 					&cluster_start, &cluster_end);

+	/* treat the write as new if the a hole/lseek spanned across
+	 * the page boundary.
+	 */
+	new = new | ((i_size_read(inode) <= page_offset(page)) &&
+			(page_offset(page) <= user_pos));
+
 	if (page == wc->w_target_page) {
 		map_from = user_pos & (PAGE_CACHE_SIZE - 1);
 		map_to = map_from + user_len;

-- 
Goldwyn
