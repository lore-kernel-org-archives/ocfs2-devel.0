From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Wed, 26 Dec 2012 16:52:46 -0600
Subject: [Ocfs2-devel] [PATCH] Initialize unaligned I/O bit to clear
Message-ID: <CAJtY7HVZSF+icmBNc2cSwQdwK3EjTs0S3G4anp-HDyQNnEScCw@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The fields of kiocb received in ocfs2_file_aio_write can be
uninitialized/non-zero. This could result in UNALIGED_AIO bit in
iocb->private set. This causes the oi->ip_unaligned_aio to decrement,
well below zero blocking future AIO.

Clear unaligned bit to fix this.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>

---
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 37d313e..d3bc462 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2254,6 +2254,7 @@ static ssize_t ocfs2_file_aio_write(struct kiocb *iocb,

 	mutex_lock(&inode->i_mutex);

+	ocfs2_iocb_clear_unaligned_aio(iocb);
 	ocfs2_iocb_clear_sem_locked(iocb);

 relock:
