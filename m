From: wengang wang <wen.gang.wang@oracle.com>
Date: Fri, 17 Apr 2009 15:38:59 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: Log -EIO errors just when hit them.
Message-ID: <200904170744.n3H7iJac013765@acsinet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch logs(ERROR) -EIO errors just when they are hitted.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
--
diff -up ./linux-2.6.29.y.build/fs/ocfs2/buffer_head_io.c.orig ./linux-2.6.29.y.build/fs/ocfs2/buffer_head_io.c
--- ./linux-2.6.29.y.build/fs/ocfs2/buffer_head_io.c.orig	2009-04-17 13:55:52.000000000 +0800
+++ ./linux-2.6.29.y.build/fs/ocfs2/buffer_head_io.c	2009-04-17 14:19:54.000000000 +0800
@@ -91,6 +91,8 @@ int ocfs2_write_block(struct ocfs2_super
 		 * information for this bh as it's not marked locally
 		 * uptodate. */
 		ret = -EIO;
+		mlog(ML_ERROR, "writing block %llu failed with %d\n",
+		     (u64)bh->b_blocknr, ret);
 		put_bh(bh);
 	}
 
@@ -168,6 +170,8 @@ int ocfs2_read_blocks_sync(struct ocfs2_
 			 * so we can safely record this and loop back
 			 * to cleanup the other buffers. */
 			status = -EIO;
+			mlog(ML_ERROR, "reading block %llu failed with %d\n",
+			     (u64)bh->b_blocknr, status);
 			put_bh(bh);
 			bhs[i - 1] = NULL;
 		}
@@ -340,6 +344,9 @@ int ocfs2_read_blocks(struct inode *inod
 				 * for this bh as it's not marked locally
 				 * uptodate. */
 				status = -EIO;
+				mlog(ML_ERROR, "reading block %llu failed with"
+				     " %d\n",
+				     (u64)bh->b_blocknr, status);
 				put_bh(bh);
 				bhs[i] = NULL;
 				continue;
@@ -431,6 +438,8 @@ int ocfs2_write_super_or_backup(struct o
 
 	if (!buffer_uptodate(bh)) {
 		ret = -EIO;
+		mlog(ML_ERROR, "writing block %llu failed with %d\n",
+		     (u64)bh->b_blocknr, ret);
 		put_bh(bh);
 	}
 
