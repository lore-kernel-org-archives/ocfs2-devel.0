From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 20 Nov 2009 17:12:48 -0800
Subject: [Ocfs2-devel] [PATCH 01/10] ocfs2: Reduce stack usage in the
	vectorized io kapi patch
In-Reply-To: <1258765977-4334-1-git-send-email-sunil.mushran@oracle.com>
References: <1258765977-4334-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1258765977-4334-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch improves changes in commit 1c87a8619515dba3a5a040daa272088b2cb90dc2
by reducing the stack footprint of the vectorized io kapi code.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/kapi-default.h      |    2 +-
 kapi-compat/include/aiovec.h |   11 +++++------
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/kapi-default.h b/fs/ocfs2/kapi-default.h
index b1afdcf..80f04ff 100644
--- a/fs/ocfs2/kapi-default.h
+++ b/fs/ocfs2/kapi-default.h
@@ -39,7 +39,7 @@ typedef struct work_struct kapi_work_struct_t;
 typedef u64 f_version_t;
 #endif
 
-#ifndef kapi_generic_file_aio_read
+#ifndef NO_VECTORIZED_AIO
 # define kapi_generic_file_aio_read(a, b, c, d) \
 				generic_file_aio_read(a, b, c, d)
 # define ocfs2_file_aio_read	__ocfs2_file_aio_read
diff --git a/kapi-compat/include/aiovec.h b/kapi-compat/include/aiovec.h
index 0c4c312..a10d5b5 100644
--- a/kapi-compat/include/aiovec.h
+++ b/kapi-compat/include/aiovec.h
@@ -11,8 +11,9 @@ static ssize_t kapi_generic_file_aio_read(struct kiocb *iocb,
 					  unsigned long nr_segs,
 					  loff_t pos)
 {
-	BUG_ON(nr_segs != 1);
-	return generic_file_aio_read(iocb, iov->iov_base, iov->iov_len, pos);
+	BUG_ON(iocb->ki_pos != pos);
+
+	return __generic_file_aio_read(iocb, iov, nr_segs, &pos);
 }
 
 static ssize_t __ocfs2_file_aio_read(struct kiocb *iocb,
@@ -28,9 +29,8 @@ static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
 	struct iovec iov_local = { .iov_base = (void __user *)buf,
 				   .iov_len  = buflen };
 	const struct iovec *iov = &iov_local;
-	unsigned long nr_segs = 1;
 
-	return __ocfs2_file_aio_read(iocb, iov, nr_segs, pos);
+	return __ocfs2_file_aio_read(iocb, iov, 1, pos);
 }
 
 static ssize_t __ocfs2_file_aio_write(struct kiocb *iocb,
@@ -46,10 +46,9 @@ static ssize_t ocfs2_file_aio_write(struct kiocb *iocb,
 	struct iovec iov_local = { .iov_base = (void __user *)buf,
 				   .iov_len  = buflen };
 	const struct iovec *iov = &iov_local;
-	unsigned long nr_segs = 1;
 
 	iocb->ki_left = buflen;
-	return __ocfs2_file_aio_write(iocb, iov, nr_segs, pos);
+	return __ocfs2_file_aio_write(iocb, iov, 1, pos);
 }
 
 #endif
-- 
1.5.6.5
