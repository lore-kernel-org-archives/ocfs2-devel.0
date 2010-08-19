From: Tristan Ye <tristan.ye@oracle.com>
Date: Thu, 19 Aug 2010 09:14:58 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Correctly treat O_DIRECT write in
	holes or outside 'i_size'.
Message-ID: <1282180498-6690-1-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Currently, O_DIRECT writes in a hole or outside the 'i_size' was not
actually honored, while using a buffered io instead.

It hurts/cheats the 'O_DIRECT' semantics somehow, users may be confusing
about the data lost after a crash when performing the odirect append writes.

A straightforward way is to flush the pagecache like O_SYNC did to guarantee
the real touch to disk before writes get returned.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 2b10b36..97b41f8 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2321,7 +2321,7 @@ out_dio:
 	BUG_ON(ret == -EIOCBQUEUED && !(file->f_flags & O_DIRECT));
 
 	if (((file->f_flags & O_DSYNC) && !direct_io) || IS_SYNC(inode) ||
-	    ((file->f_flags & O_DIRECT) && has_refcount)) {
+	    ((file->f_flags & O_DIRECT) && !direct_io)) {
 		ret = filemap_fdatawrite_range(file->f_mapping, pos,
 					       pos + count - 1);
 		if (ret < 0)
-- 
1.5.5
