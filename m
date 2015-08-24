From: Ryan Ding <ryan.ding@oracle.com>
Date: Mon, 24 Aug 2015 15:23:15 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: direct write will call
	ocfs2_rw_unlock() twice when doing aio+dio
Message-ID: <1440400995-6399-1-git-send-email-ryan.ding@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Orabug: 21612107

Use wrong return value in ocfs2_file_write_iter(). This will cause
ocfs2_rw_unlock() be called both in write_iter & end_io, and trigger a BUG_ON.

This issue exist since commit 7da839c475894ea872ec909a5d2e83dddccff5be.

Signed-off-by: Ryan Ding <ryan.ding@oracle.com>
---
 fs/ocfs2/file.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 719f7f4..33efa33 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2372,6 +2372,20 @@ relock:
 	/* buffered aio wouldn't have proper lock coverage today */
 	BUG_ON(written == -EIOCBQUEUED && !(iocb->ki_flags & IOCB_DIRECT));
 
+	/*
+	 * deep in g_f_a_w_n()->ocfs2_direct_IO we pass in a ocfs2_dio_end_io
+	 * function pointer which is called when o_direct io completes so that
+	 * it can unlock our rw lock.
+	 * Unfortunately there are error cases which call end_io and others
+	 * that don't.  so we don't have to unlock the rw_lock if either an
+	 * async dio is going to do it in the future or an end_io after an
+	 * error has already done it.
+	 */
+	if ((written == -EIOCBQUEUED) || (!ocfs2_iocb_is_rw_locked(iocb))) {
+		rw_level = -1;
+		unaligned_dio = 0;
+	}
+
 	if (unlikely(written <= 0))
 		goto no_sync;
 
@@ -2396,20 +2410,6 @@ relock:
 	}
 
 no_sync:
-	/*
-	 * deep in g_f_a_w_n()->ocfs2_direct_IO we pass in a ocfs2_dio_end_io
-	 * function pointer which is called when o_direct io completes so that
-	 * it can unlock our rw lock.
-	 * Unfortunately there are error cases which call end_io and others
-	 * that don't.  so we don't have to unlock the rw_lock if either an
-	 * async dio is going to do it in the future or an end_io after an
-	 * error has already done it.
-	 */
-	if ((ret == -EIOCBQUEUED) || (!ocfs2_iocb_is_rw_locked(iocb))) {
-		rw_level = -1;
-		unaligned_dio = 0;
-	}
-
 	if (unaligned_dio) {
 		ocfs2_iocb_clear_unaligned_aio(iocb);
 		mutex_unlock(&OCFS2_I(inode)->ip_unaligned_aio);
-- 
1.7.1
