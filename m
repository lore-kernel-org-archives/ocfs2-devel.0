From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Tue, 22 Nov 2016 20:36:35 -0800
Subject: [Ocfs2-devel] [PATCH 5/7] ocfs2: don't eat io errors during
	_dio_end_io_write
In-Reply-To: <147987576127.2678.7138661302696363830.stgit@birch.djwong.org>
References: <147987576127.2678.7138661302696363830.stgit@birch.djwong.org>
Message-ID: <147987579593.2678.14305853637089494031.stgit@birch.djwong.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@versity.com, jlbec@evilplan.org, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, darwin.xupt@gmail.com, zren@suse.com, ocfs2-devel@oss.oracle.com

ocfs2_dio_end_io_write eats whatever errors may happen,
which means that write errors do not propagate to userspace.
Fix that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ocfs2/aops.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)


diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 4d037db..136a49c 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2263,10 +2263,10 @@ static int ocfs2_dio_get_block(struct inode *inode, sector_t iblock,
 	return ret;
 }
 
-static void ocfs2_dio_end_io_write(struct inode *inode,
-				   struct ocfs2_dio_write_ctxt *dwc,
-				   loff_t offset,
-				   ssize_t bytes)
+static int ocfs2_dio_end_io_write(struct inode *inode,
+				  struct ocfs2_dio_write_ctxt *dwc,
+				  loff_t offset,
+				  ssize_t bytes)
 {
 	struct ocfs2_cached_dealloc_ctxt dealloc;
 	struct ocfs2_extent_tree et;
@@ -2374,6 +2374,8 @@ static void ocfs2_dio_end_io_write(struct inode *inode,
 	if (locked)
 		inode_unlock(inode);
 	ocfs2_dio_free_write_ctx(inode, dwc);
+
+	return ret;
 }
 
 /*
@@ -2388,6 +2390,7 @@ static int ocfs2_dio_end_io(struct kiocb *iocb,
 {
 	struct inode *inode = file_inode(iocb->ki_filp);
 	int level;
+	int ret = 0;
 
 	if (bytes <= 0)
 		return 0;
@@ -2396,13 +2399,13 @@ static int ocfs2_dio_end_io(struct kiocb *iocb,
 	BUG_ON(!ocfs2_iocb_is_rw_locked(iocb));
 
 	if (private)
-		ocfs2_dio_end_io_write(inode, private, offset, bytes);
+		ret = ocfs2_dio_end_io_write(inode, private, offset, bytes);
 
 	ocfs2_iocb_clear_rw_locked(iocb);
 
 	level = ocfs2_iocb_rw_locked_level(iocb);
 	ocfs2_rw_unlock(inode, level);
-	return 0;
+	return ret;
 }
 
 static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
