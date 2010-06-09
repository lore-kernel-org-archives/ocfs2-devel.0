From: Tao Ma <tao.ma@oracle.com>
Date: Wed,  9 Jun 2010 16:48:59 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Remove obscure error handling in
	direct_write.
Message-ID: <1276073339-7427-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2, actually we don't allow any direct write pass i_size,
see the function ocfs2_prepare_inode_for_write. So we don't
need the bogus simple_setsize.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/file.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 06fd85c..4f782b0 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2114,17 +2114,6 @@ relock:
 		written = generic_file_direct_write(iocb, iov, &nr_segs, *ppos,
 						    ppos, count, ocount);
 		if (written < 0) {
-			/*
-			 * direct write may have instantiated a few
-			 * blocks outside i_size. Trim these off again.
-			 * Don't need i_size_read because we hold i_mutex.
-			 *
-			 * XXX(hch): this looks buggy because ocfs2 did not
-			 * actually implement ->truncate.  Take a look at
-			 * the new truncate sequence and update this accordingly
-			 */
-			if (*ppos + count > inode->i_size)
-				simple_setsize(inode, inode->i_size);
 			ret = written;
 			goto out_dio;
 		}
-- 
1.5.5
