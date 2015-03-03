From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Tue, 3 Mar 2015 12:09:01 -0600
Subject: [Ocfs2-devel] [PATCH 3/3] Clear the rest of the buffers on error
Message-ID: <20150303180901.GA13147@shrek.lan>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In case a validation fails, clear the rest of the buffers and
return the error to the calling function.

This also facilitates bubbling up the error originating from
ocfs2_error to calling functions.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/ocfs2/buffer_head_io.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index 1edcb14..fe50ded 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -316,6 +316,12 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
 		bh = bhs[i];
 
 		if (!(flags & OCFS2_BH_READAHEAD)) {
+			if (status) {
+				/* Clear the rest of the buffers on error */
+				put_bh(bh);
+				bhs[i] = NULL;
+				continue;
+			}
 			/* We know this can't have changed as we hold the
 			 * owner sem. Avoid doing any work on the bh if the
 			 * journal has it. */
-- 
2.1.4
