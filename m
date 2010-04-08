From: Li Dongyang <lidongyang@novell.com>
Date: Thu, 8 Apr 2010 15:47:24 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: avoid direct write if we fall back to
	buffered
Message-ID: <201004081547.24593.lidongyang@novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

when we fall back to buffered write from direct write, we call
__generic_file_aio_write but that will end up doing direct write
even we are only prepared to do buffered write because the file
has O_DIRECT flag set. This is a fix for
https://bugzilla.novell.com/show_bug.cgi?id=591039


Signed-off-by: Li Dongyang <lidongyang@novell.com>
---
 fs/ocfs2/file.c |   27 +++++++++++++++++----------
 1 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index de059f4..707f2a2 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1973,18 +1973,24 @@ relock:
 	/* communicate with ocfs2_dio_end_io */
 	ocfs2_iocb_set_rw_locked(iocb, rw_level);
 
-	if (direct_io) {
-		ret = generic_segment_checks(iov, &nr_segs, &ocount,
-					     VERIFY_READ);
-		if (ret)
-			goto out_dio;
+	ret = generic_segment_checks(iov, &nr_segs, &ocount,
+				     VERIFY_READ);
+	if (ret)
+		goto out_dio;
 
-		count = ocount;
-		ret = generic_write_checks(file, ppos, &count,
+	count = ocount;
+	ret = generic_write_checks(file, ppos, &count,
 					   S_ISBLK(inode->i_mode));
-		if (ret)
-			goto out_dio;
+	if (ret)
+		goto out_dio;
+
+	ret = file_remove_suid(file);
+	if (ret)
+		goto out_dio;
 
+	file_update_time(file);
+
+	if (direct_io) {
 		written = generic_file_direct_write(iocb, iov, &nr_segs, *ppos,
 						    ppos, count, ocount);
 		if (written < 0) {
@@ -1999,7 +2005,8 @@ relock:
 			goto out_dio;
 		}
 	} else {
-		written = __generic_file_aio_write(iocb, iov, nr_segs, ppos);
+		written = generic_file_buffered_write(iocb, iov, nr_segs,
+				*ppos, ppos, count, 0);
 	}
 
 out_dio:
-- 
1.7.0.3
