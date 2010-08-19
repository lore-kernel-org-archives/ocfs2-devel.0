From: Tristan Ye <tristan.ye@oracle.com>
Date: Thu, 19 Aug 2010 15:15:00 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Fix a regression bug from mainline
	commit(6b933c8e6f1a2f3118082c455eef25f9b1ac7b45).
Message-ID: <1282202100-9518-1-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The patch is to fix the regression bug brought from commit 6b933c8...( 'ocfs2: 
Avoid direct write if we fall back to buffered I/O'):

http://oss.oracle.com/bugzilla/show_bug.cgi?id=1285

The commit 6b933c8e6f1a2f3118082c455eef25f9b1ac7b45 changed __generic_file_aio_write
to generic_file_buffered_write, which didn't call filemap_{write,wait}_range to  flush
the pagecaches when we were falling O_DIRECT writes back to buffered ones. it did hurt
the O_DIRECT semantics somehow in extented odirect writes.

This patch tries to guarantee O_DIRECT writes of 'fall back to buffered' to be correctly
flushed.

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
