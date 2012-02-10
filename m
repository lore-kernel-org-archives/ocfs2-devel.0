From: Jan Kara <jack@suse.cz>
Date: Fri, 10 Feb 2012 16:04:21 -0000
Subject: [Ocfs2-devel] [PATCH 2/4] ocfs2: Use generic handlers of O_SYNC AIO
	DIO
In-Reply-To: <1328889842-23231-1-git-send-email-jack@suse.cz>
References: <1328889842-23231-1-git-send-email-jack@suse.cz>
Message-ID: <1328889842-23231-3-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>

Use generic handlers to queue fsync() when AIO DIO is completed for O_SYNC
file.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/aops.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 78b68af..3d14c2b 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -593,9 +593,7 @@ static void ocfs2_dio_end_io(struct kiocb *iocb,
 	level = ocfs2_iocb_rw_locked_level(iocb);
 	ocfs2_rw_unlock(inode, level);
 
-	if (is_async)
-		aio_complete(iocb, ret, 0);
-	inode_dio_done(inode);
+	generic_dio_end_io(iocb, offset, bytes, private, ret, is_async);
 }
 
 /*
@@ -642,7 +640,7 @@ static ssize_t ocfs2_direct_IO(int rw,
 	return __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev,
 				    iov, offset, nr_segs,
 				    ocfs2_direct_IO_get_blocks,
-				    ocfs2_dio_end_io, NULL, 0);
+				    ocfs2_dio_end_io, NULL, DIO_SYNC_WRITES);
 }
 
 static void ocfs2_figure_cluster_boundaries(struct ocfs2_super *osb,
-- 
1.7.1
