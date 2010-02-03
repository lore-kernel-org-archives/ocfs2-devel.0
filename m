From: Tao Ma <tao.ma@oracle.com>
Date: Wed,  3 Feb 2010 09:56:04 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Add parenthesis to wrap the check for
	O_DIRECT.
Message-ID: <1265162164-22694-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Add parenthesis to wrap the check for O_DIRECT.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/file.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 06ccf6a..b2ca980 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2013,8 +2013,8 @@ out_dio:
 	/* buffered aio wouldn't have proper lock coverage today */
 	BUG_ON(ret == -EIOCBQUEUED && !(file->f_flags & O_DIRECT));
 
-	if ((file->f_flags & O_DSYNC && !direct_io) || IS_SYNC(inode) ||
-	    (file->f_flags & O_DIRECT && has_refcount)) {
+	if (((file->f_flags & O_DSYNC) && !direct_io) || IS_SYNC(inode) ||
+	    ((file->f_flags & O_DIRECT) && has_refcount)) {
 		ret = filemap_fdatawrite_range(file->f_mapping, pos,
 					       pos + count - 1);
 		if (ret < 0)
-- 
1.6.3.3
