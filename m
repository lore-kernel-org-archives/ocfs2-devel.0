From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 10 Sep 2009 15:28:47 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Use buffer IO if we are appending a
	file.
Message-ID: <1252567727-7571-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_file_aio_write, we will prevent direct io if
we find that we are appending(changing i_size) and call
generic_file_aio_write_nolock. But actually O_DIRECT flag
is there and this function will call generic_file_direct_write
eventually which will update i_size and leave di->i_size
alone. The bug is that
http://oss.oracle.com/bugzilla/show_bug.cgi?id=1173.

So this patch let ocfs2_direct_IO returns 0 directly if we
are appending so that buffered write will be called and
di->i_size get updated successfully. And this is also
what we want in ocfs2_file_aio_write.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/aops.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index c4c567e..769e5d0 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -690,6 +690,10 @@ static ssize_t ocfs2_direct_IO(int rw,
 	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
 		return 0;
 
+	/* Fallback to buffered I/O if we are appending. */
+	if (i_size_read(inode) <= offset)
+		return 0;
+
 	ret = blockdev_direct_IO_no_locking(rw, iocb, inode,
 					    inode->i_sb->s_bdev, iov, offset,
 					    nr_segs, 
-- 
1.5.5
